### 代码块 Code Blocks

Pandoc 支持两种代码块：

- 缩进式代码块（indented code blocks，Markdown 基本语法）
- 围栏式代码块（fenced code blocks）

#### 缩进式代码块

缩进四个空格（或一个制表符）的文本块将被视为逐字文本：也就是说，特殊字符不会触发特殊格式，所有空格和换行符都会保留。例如：

```markdown
![[ ../../examples/pandoc-flavored-markdown/code-blocks/indented-code-blocks.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/code-blocks/indented-code-blocks.md ]]

:::

初始（四个空格或一个制表符）缩进不被视为逐字文本的一部分，并将在输出中删除。

::: caution

逐字文本中的空白行不必以四个空格开头。

:::

#### 扩展：`fenced_code_blocks`

除了标准缩进式代码块外，Pandoc 还支持 带围栏式代码块。这些代码块以一行三个或更多波浪号 (`~`) 开始，以一行波浪号结束，波浪号的长度必须至少与起始行一样长。这些行之间的所有内容都被视为代码。无需缩进：

```
~~~~~~~
if (a > 3) {
  moveShip(5 * gravity, DOWN);
}
~~~~~~~
```

与常规代码块一样，围栏式代码块必须用空行与周围文本分隔开。

如果代码本身包含一行波浪号或反引号，则只需在开始和结束处使用一排较长的波浪号或反引号：

~~~~~~~~~~~~~~~~
~~~~~~~~~~
code including tildes
~~~~~~~~~~
~~~~~~~~~~~~~~~~

#### 扩展：`backtick_code_blocks`

与 `fenced_code_blocks` 相同，但使用反引号 (\`) 而不是波浪号 (`~`)。

#### 扩展：`fenced_code_attributes`

或者，您可以使用以下语法将属性附加到隔离或反引号代码块：

~~~markdown
![[ ../../examples/pandoc-flavored-markdown/code-blocks/fenced_code_attributes.md ]]
~~~

::: rendered

![[ ../../examples/pandoc-flavored-markdown/code-blocks/fenced_code_attributes.md ]]

:::

这里 `#helloworld` 是一个标识符，可以使用 `[Helloworld](#helloworld)` 建立链接； `c` 和 `numberLines` 是类，并且 `startFrom` 是一个值为 101 的属性。某些输出格式可以使用此信息进行语法高亮显示。目前，唯一使用此信息的输出格式是 HTML、LaTeX、Docx、Ms 和 PowerPoint。如果您的输出格式和语言支持高亮显示，则上面的代码块将高亮显示，并带有编号行。（要查看支持哪些语言，请输入 `pandoc --list-highlight-languages`。）

`numberLines`（或 `number-lines`）类 将使代码块的行以1或 `startFrom` 的属性值开始进行编号。`lineAnchors`（或 `line-anchors`）类将使这些行在 HTML 输出中成为可点击的锚点。

#### 语法高亮显示

Pandoc 会在标记了语言名称的代码块中自动高亮语法，使用 Haskell 库 skylighting[^skylighting] 进行高亮。目前仅支持 HTML、EPUB、Docx、Ms、Man 和 LaTeX/PDF 输出的高亮功能。要查看 pandoc 识别的语言名称列表，请输入 `pandoc --list-highlight-languages`。

[^skylighting]: <https://github.com/jgm/skylighting>

语法高亮的风格通过样式表的变化进行控制：HTML 输出使用级联样式表（CSS），LaTeX（以及 PDF）输出使用一组 `\newcommand` 选项。这些高亮指令直接嵌入输出文件中（当生成独立文档时），因此不易覆盖。不过，你可以从预定义的高亮样式列表中选择。运行以下命令可查看完整样式列表：

```bash
pandoc --list-highlight-styles
```

默认配色方案是 `pygments`，模仿了 Python 库 pygments[^pygments] 的默认配色（尽管实际高亮并未使用 pygments）。使用 `--highlight-style` 选项选择样式。例如，我在构建书籍的打印版本时想要黑白输出，因此使用选项：

[^pygments]: <https://pygments.org/>

```bash
pandoc --highlight-style=monochrome
```

这会生成黑白高亮，使用斜体和粗体来显示不同的语言组件。你也可以在使用代码块的同时完全禁用语法高亮，只需使用选项 `--no-highlight`。

如果对预定义样式不满意，可以使用 `--print-highlight-style` 生成一个 JSON 格式的 `.theme` 文件，修改后可作为 `--highlight-style` 的参数。例如，获取 pygments 样式的 JSON 版本：

```bash
pandoc -o my.theme --print-highlight-style pygments
```

然后编辑 `my.theme`，并按以下方式使用：

```bash
pandoc --highlight-style my.theme
```

如果内置高亮不满意，或想高亮不支持的语言，可以使用 `--syntax-definition` 选项加载 KDE 风格的 XML 语法定义文件。在编写自己的语法定义前，可参考 KDE 的语法定义仓库。

如果遇到 pandoc 报错“无法读取高亮主题”，请检查 JSON 文件是否使用 UTF-8 编码且没有字节顺序标记 (BOM)。

输出格式为 LaTeX 或 PDF 时，

- 没有设置代码属性时，默认使用 `verbatim` 宏；
- 设置代码属性时，使用 Pandoc 自定义的 `Shaded` 宏[^shaded]；
- 在编译时采用选项 `--listings`（也可以在 YAML 中设置 `listings: true`），则输出文件使用 `listings` 宏。

[^shaded]: 此时 `--highlight-style` 和 `--no-highlight` 选项才起作用，使用 `--listings` 时，格式由 `listings` 宏设置。

#### 非断行空格 Non-breaking Space

在使用 Pandoc 将 Markdown 转换为其他格式（如 HTML 或 PDF）时，
含有前导空格的代码（如 `  hello,world`）可能会忽略前导空格，即渲染为：`  hello,world`。

在 Markdown 中，可以手动将前导空格替换为 Unicode 非断行空格（Non-breaking Space，简称 NBSP）。非断行空格可以通过文本编辑器或脚本替换输入，也可以直接输入：

  - Windows：`Alt + 0160`（小键盘）
  - Mac：`Option + Space`
  - HTML/XML：`&nbsp;`
  - LaTeX：`~`（波浪号）
  - Unicode：`U+00A0`

非断行空格的主要用途：

1. 防止自动换行。普通空格（U+0020）在文本换行时会被断开，但 NBSP 会强制让相连的单词或字符保持在同一行，避免被分开。示例： 

   ```html
   100&nbsp;km/h  <!-- "100 km/h" 会始终显示在同一行 -->
   ```

2. 在 HTML 中保留空格。HTML 默认会合并多个普通空格为一个，使用 `&nbsp;` 可以保留连续的空格。示例：  

   ```html
   你好&nbsp;&nbsp;&nbsp;世界  <!-- 显示为 "你好   世界"（3个空格） -->
   ```

3. 用于对齐或固定格式。在表格、代码等需要对齐的场景下，可以用 NBSP 代替普通空格，确保格式稳定。  

::: caution

- 过度使用 `&nbsp;` 可能导致代码可读性下降，建议在真正需要时使用。
- 在响应式设计中，依赖 NBSP 控制布局可能不灵活，推荐使用 CSS（如 `white-space: nowrap`）替代。  

:::


#### 关于 \LaTeX 代码渲染

pandoc 处理后的 tex 代码时显示 `lauange=TeX` 而非  `lauange=[LaTeX]TeX`，而前者不支持一些命令渲染，如`\begin`。

Pandoc 默认的 LaTeX 写入器（Writer）确实会将代码块标记为 `language=TeX`，但在 `listings` 宏包中，`[LaTeX]TeX` 才是专门针对 \LaTeXe 语法定制的方言（包含更多的现代命令支持）。

为什么 Pandoc 默认只给 `TeX`？
Pandoc 的设计哲学是**通用性**。在它的内部定义中，`tex` 语言标签对应的是基础的 TeX 语法。而 `listings` 宏包是一个高度可定制的 LaTeX 插件，它通过 `[dialect]language` 这种非标准语法来区分。Pandoc 的内置模板通常不会为了某个宏包的特殊语法而改变其通用的标签系统。

要解决这个问题，你有两种主要的方案：**全局映射** 或 **局部修改**。

1. **方案一：在导言区强制映射**

你不需要去修改 Pandoc 的生成逻辑，只需要在你的 Markdown 开头（YAML 元数据）中告诉 `listings` 宏包：**当看到 `TeX` 时，请按照 `[LaTeX]TeX` 的规则来处理。**

在 YAML 中添加以下代码：

```yaml
---
header-includes:
  - |
    \usepackage{listings}
    \lstset{
      defaultdialect=[LaTeX]TeX,
      language=[LaTeX]TeX,
      % 在这里添加你其他的 listings 样式
      basicstyle=\ttfamily,
      keywordstyle=\color{blue}
    }
---

```

**原理**：`defaultdialect=[LaTeX]TeX` 会强制让所有的 TeX 代码块默认使用 LaTeX 方言。

2. **方案二：使用 Pandoc 过滤器**

如果你希望生成的 `.tex` 源码文件里清清楚楚地写着 `language=[LaTeX]TeX`，你可以利用 Pandoc 的 **Fenced Code Attributes** 功能。

在 Markdown 中这样写：

````markdown
```{[LaTeX]TeX}
\documentclass{article}
\begin{document}
  Hello
\end{document}

```
````

**但是注意**：有些版本的 Pandoc 会因为方括号 `[]` 产生解析歧义。如果上述写法报错，建议使用方案一，那是处理 Pandoc 转换逻辑最稳妥的方式。
