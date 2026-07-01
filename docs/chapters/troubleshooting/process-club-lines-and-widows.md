### 处理孤行和寡行

在 \LaTeX 中，孤行（Orphan / Club line）和寡行（Widow line）是排版美观的大敌：

孤行（Orphan）
: 一段话的第一行留在页面最底部，其余部分换到了下一页。

寡行（Widow）
: 一段话的最后一行孤零零地换到了下一页的最顶部。

\LaTeX 默认其实有一些微调机制，但有时候为了严格对齐垂直间距，它会妥协容忍孤寡行。我们可以通过以下几种方法来优雅地解决这个问题。

#### 全局控制：调整孤行与寡行惩罚值（最推荐）

如果你希望整个文档都自动处理这种排版瑕疵，可以在文档的导言区（`\begin{document}` 之前）设置惩罚值（Penalty）。

```latex
\widowpenalty=10000  % 严格禁止寡行（段落最后一行留在新页顶部）
\clubpenalty=10000   % 严格禁止孤行（段落第一行留在旧页底部）
```

概念解析：

- **`\widowpenalty`（寡行惩罚）**：控制段落的**最后一行**是否会单独出现在**下一页的页首**。设置为 `10000` 表示绝对禁止。
- **`\clubpenalty`（孤行惩罚）**：控制段落的**第一行**是否会单独留在**当前页的页尾**（即第二行被挤到下一页的页首）。

将它们设置为 `10000`（无限大）可以强制 \LaTeX 重新调整分页，宁可让前一页稍微留白，也不会让单行落单。

#### 局部控制：强制某几行文本绑定在一起

如果只是想在某个特定地方，确保某一行与其后面的内容**绝对不被分页隔开**（即这一行不能作为当前页的最后一行，也不能单独去下一页页首），可以使用以下方法：

在这一行的末尾换行时，使用 `\nopagebreak` 告诉 \LaTeX 这里绝对不能分页。

```latex
这是绝对不能留在页尾（或单独去页首）的那一行字，\\ \nopagebreak
这是紧随其后的下一行字，它们会紧紧绑定在一起。
```

#### 解决模板中的寡行问题

**修正前的代码**

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

这里使用了 TikZ 来绘制上下两条分割线。在环境结束时，底部的 TikZ 分割线（`\begin{tikzpicture} ... \end{tikzpicture}`）和它前面的最后一行文字之间，如果发生了分页，就会导致**分割线单独跑到下一页的页首**，或者**最后一行文字单独去下一页页首，而分割线留在上一页**。

在代码末尾写了 `\nobreak`，但因为 TikZ 绘图默认的行为以及环境末尾缺少显式的段落结束符（`\par`），导致 `\nobreak` 没有正确作用于“最后一行文字”与“底部线”之间。

为了完美实现“底部分割线绝对不与环境内最后一行文字断开，且它们整体不能单独出现在页首”，你需要对环境的结束部分（End code）进行如下修正：

**修正后的代码**

```latex
\newenvironment{rendered}{%
  \par\vspace{0.5cm}% 建议保留，开启新段落并留空
  % Drawing the top separator line with TikZ
  \noindent\begin{tikzpicture}
    \draw[line width=2pt, draw=teal] (0,0) -- (\textwidth,0);
  \end{tikzpicture}%
  \par\nobreak\vspace{0.2cm}% 强制不允许在此处分页
}{%
  \par\nobreak % 1. 核心：强制结束当前段落，并禁止在这里分页！
  % 2. 局部调高惩罚值，确保最后一行不孤立
  \widowpenalty=10000 
  \nopagebreak[4]%
  % Drawing the bottom separator line with TikZ
  \noindent\begin{tikzpicture}
    \draw[line width=2pt, draw=teal] (0,0) -- (\textwidth,0);
  \end{tikzpicture}%
  \par\vspace{0.5cm}% 底部线画完后，开启新段落并留空
}
```

**关键修改点解析**

1. **`\par\nobreak` 的顺序（至关重要）**：
在环境结束的开头，必须先执行 `\par` 结束环境内的最后一行文本。
在 LaTeX 中，**分页符只能插入在段落之间（即 `\par` 产生的地方）**。如果你直接写 `\nobreak`，它可能作用在错误的地方。写成 `\par\nobreak` 意味着：“当前段落在这里结束，但是**绝对不允许**在这里把前后切断切到下一页”。
2. **`\widowpenalty=10000`**：
将其写在环境结束部分，可以动态隐式地影响环境内最后几行的分页权重，配合 `\nopagebreak[4]`，双重保险，强制让环境的最后一行文字与底部的 TikZ 分割线**死死绑定在一起**。
3. **去掉了 TikZ 内部无用的 `node**`：
底部的 TikZ 里的 `\node (line) ...` 移除了，直接使用 `\noindent` 配合 `\draw` 即可，这样可以避免不必要的垂直间距抖动。
4. **代码末尾的 `%`（百分号）**：
在 TikZ 环境和命令后面加上 `%` 可以防止 LaTeX 把换行符误认为是一个空格，避免导致线段错位或产生微小的垂直间隙。

也可以使用 `\nopagebreak**`！事实上，在你的 TikZ 环境中，用 `\nopagebreak` 是非常直接且标准的做法。但有一个致命的陷阱：**`\nopagebreak` 必须紧跟在 `\par`（显式或隐式的段落结束）后面才能生效。** 如果直接写在两个环境之间，\LaTeX 往往会忽略它。

为了让 `\nopagebreak` 完美生效，你需要这样修改你的环境结束部分：

```latex
}{%
  \par\nopagebreak[4]% 1. 先用 \par 结束最后一行文字，然后立刻用 \nopagebreak 紧紧黏住下一行
  \noindent\begin{tikzpicture}
    \draw[line width=2pt, draw=teal] (0,0) -- (\textwidth,0);
  \end{tikzpicture}%
  \par\vspace{0.5cm}% 底部线画完后，正常分页并留出下文间距
}
```

为什么必须要写 `\par\nopagebreak[4]`？

1. **\LaTeX 的分页机制**：\LaTeX 只会在**段落之间**（也就是 `\par` 触发的地方）或者**行与行之间**寻找分页点。
2. **如果不加 `\par**`：你的自定义环境最后一行字还没正式“结稿”，你就调用了 TikZ 绘图。\LaTeX 会把 TikZ 盒子当成这一行文字的一部分或者紧随其后的内容，此时 `\nopagebreak` 会失去锚定点，导致底部的 TikZ 线依然可能被无情地挤到下一页页首。
3. **加上 `[4]**`：`\nopagebreak[4]` 是最高指令（相当于“绝对不允许”）。

只要像上面这样调整，最后一行文字和你的 TikZ 底部分割线就会合二为一，绝对不会在页首落单了。

整合好、修正后的完整且可直接运行的代码（包含测试用的虚拟文本，方便你查看排版效果）。已经优化了 `\par` 和 `\nopagebreak[4]` 的配合，并且为上下两条分割线加上了可选的垂直间距。

```latex
\documentclass{article}
\usepackage{ctex} % 支持中文（如果是英文文档可改为 \usepackage[utf8]{inputenc}）
\usepackage{tikz}
\usepackage{lipsum} % 用于生成测试文本

% 定义自定义环境 rendered
\newenvironment{rendered}{%
   \par\vspace{0.5cm}% 1. 环境上方留出 0.5cm 间距
   \noindent
   \begin{tikzpicture}
      \draw[line width=2pt, draw=teal] (0,0) -- (\textwidth,0);
   \end{tikzpicture}%
   \par\nopagebreak[4]% 2. 强力锚定：顶部分割线与环境内第一行字不切断
   \vspace{0.2cm}% 线条与内部文字的微调间距
}{%
   \par\nopagebreak[4]% 3. 核心修改：结束内部文字，并绝对禁止在这里分页！
   \vspace{0.2cm}% 内部文字与底部分割线的微调间距
   \noindent
   \begin{tikzpicture}
      \draw[line width=2pt, draw=teal] (0,0) -- (\textwidth,0);
   \end{tikzpicture}%
   \par\vspace{0.5cm}% 4. 底部分割线画完后，开启新段落并留出 0.5cm 间距
}

\begin{document}

\lipsum[1] % 环境前的一些常规文本

\begin{rendered}
    这是一个自定义的渲染环境。这里的文本可以是一行，也可以是很多行。
    
    通过在环境结束的那个括号里精确使用 \verb|\par\nopagebreak[4]|，
    LaTeX 会把这最后一行文字和下面的 Teal 色 TikZ 分割线牢牢地“粘”在一起。
    
    哪怕到了页面的最边缘，它们也绝对不会被分页符拆散（不会发生文字在上一页页尾，而线去了下一页页首的尴尬情况）。
\end{rendered}

\lipsum[2] % 环境后的一些常规文本

\end{document}
```
