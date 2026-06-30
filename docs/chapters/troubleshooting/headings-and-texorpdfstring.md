### 显示含有 `\LaTeX` 的 标题

见 [关于 \LaTeX 代码渲染]

#### \LaTeX 处理含命令和数学公式的书签

在 PDF 中，书签（Bookmarks）是由 PDF 阅读器直接渲染的纯文本，不支持标准的 \LaTeX 数学公式渲染（比如 $\cfrac{a}{b}$ 或 $\sqrt{x}$ 无法直接显示）。

如果你在章、节标题（如 `\section{...}`）中使用了 \LaTeX 公式，直接生成书签会导致书签栏出现一堆乱码（如 `\alpha` 变成一串奇怪的控制字符）或空白。

为了在书签中正确显示数学符号或特殊字符，通常有以下几种解决方案：

**1. 核心解决方案：使用 `hyperref` 的 `\texorpdfstring`**

这是最标准、最通用的方法。`hyperref` 宏包提供了 `\texorpdfstring{LaTeX代码}{PDF书签文本}` 命令。它允许你为正文和书签分别指定不同的内容：

* 第一个参数：在正文中显示的 \LaTeX 公式（支持完整排版）。
* 第二个参数：在 PDF 书签中显示的纯文本或 Unicode 字符。

示例代码：

```latex
\documentclass{article}
\usepackage{ctex} % 支持中文
\usepackage[unicode]{hyperref} % 启用书签的 Unicode 支持

\begin{document}

% 示例 1：用纯文本代替公式
\section{\texorpdfstring{$E=mc^2$}{E=mc^2}}
正文里显示能量守恒：$E=mc^2$。

% 示例 2：使用 Unicode 字符（希腊字母）
\section{\texorpdfstring{关于 $\alpha$ 的讨论}{关于 α 的讨论}}
正文里显示希腊字母 $\alpha$。

\end{document}
```

**2. 使用 `pdfstringdefDisableCommands`**

在 \LaTeX 中，想要全局自动处理 `\LaTeX`（以及类似的 `\TeX` 等命令），让它们在正文中正常渲染、在 PDF 书签中自动变成纯文本最标准、最推荐的方法是使用 `pdfstringdefDisableCommands`。这是 `hyperref` 宏包官方提供的方法。它的核心逻辑是：**“在准备生成 PDF 书签时，临时把 `\LaTeX` 定义为纯文本字符串”**。

你只需要在 \LaTeX 模版的导言区（Preamble）加入以下代码：

```latex
\usepackage{hyperref}

% 全局设定：在生成 PDF 书签时，将这些宏替换为纯文本
\pdfstringdefDisableCommands{%
  \def\LaTeX{LaTeX}%
  \def\TeX{TeX}%
}
```

::: note
加入 `\usepackage{bookmark}` 能够处理一些数学公式，如 $E=mc^2$，但不能处理 `\alpha`。
:::

#### Pandoc 处理含 `\LaTeX` 命令的标题的默认方式

Pandoc 在解析 Markdown 标题中的 `\LaTeX` 时，确实会自动把它打包进 `\texorpdfstring`。

Pandoc 在把你写的 Markdown 转换成 LaTeX 时，并不是简单的“查找与替换”，而是经历了一个**拆解再重组**的过程：

**第一步：读取并理解（构建 AST）**

当你输入 `# 介绍 \LaTeX` 时，Pandoc 会把这句话拆成不同的“零件”（节点）：

* `介绍`：被识别为**普通文本（Str）**。
* `\LaTeX`：被识别为**原生 \TeX 代码（RawInline）**。

**第二步：翻译成目标语言（\LaTeX{ }Writer）**

当 Pandoc 的 \LaTeX 翻译器看到这个标题里包含 `RawInline`（原生 \TeX 代码）时，为了同时兼顾“正文完美渲染”和“书签不乱码”，Pandoc 就会**自动施放 `\texorpdfstring` 魔法**。在生成的 `.tex` 文件里是这样的：

```latex
\section{\texorpdfstring{介绍 \LaTeX}{介绍}}\label{...}
```

所以，在生成的书签中显示 `\LaTeX` 这些字符为空白。

::: important
在写 Markdown 标题时，**不要** 手写 `\texorpdfstring`，因那样的话，Pandoc 还会在外层加入 `\texorpdfstring`，形成命令嵌套，编译会出错。
:::

#### 禁用 Pandoc 自动添加的 `\texorpdfstring`

如果你希望彻底废除 Pandoc 自动生成的 `\texorpdfstring` 的双重机制，强制让它在任何地方（包括正文和 PDF 书签）都只保留第一个参数，你可以直接在 \LaTeX 模板中对这个命令进行重定义（Redefine）。

由于 `hyperref` 宏包在加载时会定义 `\texorpdfstring`，我们必须在它加载**之后**，用 `\renewcommand` 去覆盖它。

请在你的 \LaTeX 模板中，找到 `\begin{document}` 之前的位置（建议放在靠近 `\begin{document}` 的地方），写入以下代码：

```latex
% 确保在 hyperref 宏包加载之后执行
\makeatletter
\AtBeginDocument{
  % 重新定义 \texorpdfstring，使其忽略第二个参数 #2，只输出第一个参数 #1
  \long\def\texorpdfstring#1#2{#1}
}
\makeatother
```

说明如下：

- **`\long\def`**：使用底层 TeX 命令来重定义。`\long` 允许参数中包含分段（以防万一），`#1` 代表第一个参数，`#2` 代表第二个参数。
- **`#1`**：定义体的右边只有 `#1`，意味着传入的 `#2` 会被系统直接丢弃，不参与编译。
- **`\AtBeginDocument{...}`**：这是关键。因为 `hyperref` 宏包非常霸道，它会在内部多次检查并重置自己的命令。通过把重定义放进 `\AtBeginDocument`（即在文档正式 excellence 渲染的那一刹那执行），可以**确保绝对能覆盖掉 `hyperref` 的默认行为**。

如果在模板里配合了前面提到的 `\pdfstringdefDisableCommands{\def\LaTeX{LaTeX}}`，那么即便书签强行读取了第一个参数，其中的 `\LaTeX` 也会被你的全局规则完美修复！

