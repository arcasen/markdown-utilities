### 处理孤行和寡行

在 \LaTeX 中，孤行（Orphan / Club line）和寡行（Widow line）是排版美观的大敌：

孤行（Orphan）
: 一段话的第一行留在页面最底部，其余部分换到了下一页。

寡行（Widow）
: 一段话的最后一行孤零零地换到了下一页的最顶部。

\LaTeX 默认其实有一些微调机制，但有时候为了严格对齐垂直间距，它会妥协容忍孤寡行。我们可以通过以下几种方法来优雅地解决这个问题。

#### 全局控制：调整孤行与寡行惩罚值

如果你希望整个文档都自动处理这种排版瑕疵，可以在文档的导言区（`\begin{document}` 之前）设置惩罚值（Penalty）。

```latex
\widowpenalty=10000  % 严格禁止寡行（段落最后一行留在新页顶部）
\clubpenalty=10000   % 严格禁止孤行（段落第一行留在旧页底部）
```

概念解析：

- `\widowpenalty`（寡行惩罚）：控制段落的最后一行是否会单独出现在下一页的页首。设置为 `10000` 表示绝对禁止。
- `\clubpenalty`（孤行惩罚）：控制段落的第一行是否会单独留在当前页的页尾（即第二行被挤到下一页的页首）。

将它们设置为 `10000`（无限大）可以强制 \LaTeX 重新调整分页，宁可让前一页稍微留白，也不会让单行落单。

#### 局部控制：强制某几行文本绑定在一起

如果只是想在某个特定地方，确保某一行与其后面的内容绝对不被分页隔开（即这一行不能作为当前页的最后一行，也不能单独去下一页页首），可以使用以下方法：

在这一行的末尾换行时，使用 `\nopagebreak` 告诉 \LaTeX 这里绝对不能分页。

```latex
这是绝对不能留在页尾（或单独去页首）的那一行字，\\ \nopagebreak
这是紧随其后的下一行字，它们会紧紧绑定在一起。
```

#### 解决模板中的寡行问题

修正前的代码：

```latex
\newenvironment{rendered}{%
  % \par\vspace{0.5cm}% Adding vertical space before the top line
  % Drawing the top separator line with TikZ
  \noindent\begin{tikzpicture}
    \draw[line width=2pt, draw=teal] (0,0) -- (\textwidth,0);
  \end{tikzpicture}\nobreak
  % 渲染结果：
  % \par\vspace{0.2cm}% Adding space between line and content
}{%
  % \par\vspace{0.2cm}% Adding space after content
  % Drawing the bottom separator line with TikZ
  \noindent\begin{tikzpicture}
    \node (line) at (0,0) {}; % Node to anchor baseline
    \draw[line width=2pt, draw=teal] (0,0) -- (\textwidth,0);
  \end{tikzpicture}\nobreak
  % \par\vspace{0.5cm}% Adding vertical space after the bottom line
}
```

这里使用了 TikZ 来绘制上下两条分割线。在环境结束时，底部的 TikZ 分割线（`\begin{tikzpicture} ... \end{tikzpicture}`）和它前面的最后一行文字之间，如果发生了分页，就会导致分割线单独跑到下一页的页首，或者最后一行文字单独去下一页页首，而分割线留在上一页。在代码末尾写了 `\nobreak`，但因为 TikZ 绘图默认的行为以及环境末尾缺少显式的段落结束符（`\par`），导致 `\nobreak` 没有正确作用于“最后一行文字”与“底部线”之间。

在 TikZ 环境中，用 `\nopagebreak` 是非常直接且标准的做法。但有一个致命的陷阱：`\nopagebreak` 必须紧跟在 `\par`（显式或隐式的段落结束）后面才能生效。 如果直接写在两个环境之间，\LaTeX 往往会忽略它。为了让 `\nopagebreak` 完美生效，你需要这样修改环境结束部分：

```latex
% 定义自定义环境 rendered
\newenvironment{rendered}{%
  \par\addvspace{0.3cm}%
  \noindent
  \begin{tikzpicture}
    \draw[line width=2pt, draw=blue!55!black] (0,0.15) -- (\textwidth,0.15);
    \draw[line width=1pt, draw=blue!55!black!80] (0,0) -- (\textwidth,0);
  \end{tikzpicture}%
  \par\nopagebreak[4]% 确保下面紧跟的垂直间距不会断开
  \vspace{0.2cm}%
  \nopagebreak[4]% 再次强力锚定，禁止与随后的第一行文字断开
}{%
  \par\nopagebreak[4]% 内部最后一行文字结束后，禁止分页
  \vspace{0.2cm}%
  \nopagebreak[4]% 禁止在间距后分页
  \noindent
  \begin{tikzpicture}
    \draw[line width=1pt, draw=blue!55!black!80] (0,0) -- (\textwidth,0);
    \draw[line width=2pt, draw=blue!55!black] (0,-0.15) -- (\textwidth,-0.15);
  \end{tikzpicture}%
  \par\addvspace{0.3cm}%
}
```

为什么必须要写 `\par\nopagebreak[4]`？

1. \LaTeX 的分页机制：\LaTeX 只会在段落之间（也就是 `\par` 触发的地方）或者行与行之间寻找分页点。
2. 如果不加 `\par`：自定义环境最后一行字还没正式“结稿”，你就调用了 TikZ 绘图。\LaTeX 会把 TikZ 盒子当成这一行文字的一部分或者紧随其后的内容，此时 `\nopagebreak` 会失去锚定点，导致底部的 TikZ 线依然可能被挤到下一页页首。
3. 加上 `[4]`：`\nopagebreak[4]` 是最高指令（相当于“绝对不允许”）。

::: caution
在 \LaTeX 中，即使你写了 `\nopagebreak[4]`（最高惩罚级别），\TeX 依然可能在那个地方给你断页。这是由其底层的段落切分与页面构建算法（Page-Builder Algorithm）决定的。
:::
