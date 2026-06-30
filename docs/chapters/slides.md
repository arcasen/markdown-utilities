## 幻灯片展示

您可以使用 Pandoc 生成基于 HTML + JavaScript 的幻灯片演示文稿，可通过网页浏览器查看。有五种方式可以实现：使用 S5、DZSlides、Slidy、Slideous 或 reveal.js。您还可以使用 \LaTeX Beamer 生成 PDF 格式的幻灯片，或生成 Microsoft PowerPoint 格式的幻灯片。

以下是一个简单的幻灯片展示的 Markdown 源文件，名为 habits.txt：

``` markdown
% Habits
% John Doe
% March 22, 2005

# In the morning

## Getting up

- Turn off alarm
- Get out of bed

## Breakfast

- Eat eggs
- Drink coffee

# In the evening

## Dinner

- Eat spaghetti
- Drink wine

------------------

![picture of spaghetti](images/spaghetti.jpg)

## Going to sleep

- Get in bed
- Count sheep
```

要生成 HTML/JavaScript 幻灯片，只需输入：

``` bash
pandoc -t FORMAT -s habits.txt -o habits.html
```

其中 FORMAT 可以是 s5、slidy、slideous、dzslides 或 revealjs。

对于 Slidy、Slideous、reveal.js 和 S5，使用 `-s/--standalone` 选项生成的文件的 JavaScript 和 CSS 文件链接，默认假设这些文件位于相对路径 s5/default（S5）、slideous（Slideous）、reveal.js（reveal.js）或 Slidy 的 w3.org 网站（Slidy）。（这些路径可以通过设置 `slidy-url`、`slideous-url`、`revealjs-url` 或 `s5-url` 变量更改；见上文 HTML 幻灯片变量。）对于 DZSlides，默认情况下，JavaScript 和 CSS（相对较短）会包含在文件中。

对于所有 HTML 幻灯片格式，可以使用 `--self-contained` 选项生成一个包含所有展示所需数据的单一文件，包括链接的脚本、样式表、图片和视频。

要使用 Beamer 生成 PDF 幻灯片，输入：

```
pandoc -t Beamer habits.txt -o habits.pdf
```

::: caution

reveal.js 幻灯片还可以通过浏览器打印到文件转换为 PDF。

:::

要生成 PowerPoint 幻灯片，输入：

```
pandoc habits.txt -o habits.pptx
```

### 幻灯片结构

默认情况下，幻灯片级别是文档中最高标题级别，且该标题后紧跟内容而非另一个标题。在上例中，1 级标题总是后跟 2 级标题，2 级标题后跟内容，因此幻灯片级别为 2。可以使用 `--slide-level` 选项覆盖此默认设置。

文档按以下规则分割为幻灯片：

- 水平线始终开始一个新幻灯片。
- 幻灯片级别的标题始终开始一个新幻灯片。
- 低于幻灯片级别的标题在幻灯片内创建子标题。（在 Beamer 中，会创建一个“块”。如果标题带有 `example` 类，将使用 `exampleblock` 环境；如果带有 `alert` 类，将使用 `alertblock`；否则使用普通块。）
- 高于幻灯片级别的标题创建“标题幻灯片”，仅包含章节标题，用于将幻灯片展示分段。HTML 幻灯片中，这些标题下的非幻灯片内容将包含在标题幻灯片中；Beamer 中，则包含在后续同标题的幻灯片中。
- 如果文档包含标题块，会自动生成标题页。（在 Beamer 中，可通过注释默认模板中的某些行禁用此功能。）

这些规则支持多种幻灯片展示风格。如果您不关心幻灯片的章节和子章节结构，可以仅使用 1 级标题（此时幻灯片级别为 1），或设置 `--slide-level=0`。

::: caution

在 reveal.js 幻灯片中，如果幻灯片级别为 2，将生成二维布局，1 级标题水平构建，2 级标题垂直构建。建议不要在 reveal.js 中使用更深的嵌套，除非设置 `--slide-level=0`（此时 reveal.js 生成一维布局，仅将水平线视为幻灯片分隔）。

:::

### PowerPoint 布局选择

创建幻灯片时，pptx 编写器根据幻灯片内容从预定义布局中选择：

- **标题幻灯片**：用于初始幻灯片，基于元数据字段（日期、作者、标题）生成和填充（如果存在）。
- **章节标题**：用于 pandoc 称为“标题幻灯片”的幻灯片，即以高于幻灯片级别的标题开始的幻灯片。
- **双列内容**：用于双列幻灯片，即包含带有 `columns` 类的 div，且其中至少有两个带有 `column` 类的 div。
- **比较**：用于双列幻灯片中至少一列包含文本后跟非文本（例如图片或表格）的场景，替代“双列内容”。
- **带标题的内容**：用于非双列幻灯片，包含文本后跟非文本（例如图片或表格）。
- **空白**：用于仅包含空白内容的幻灯片，例如仅包含演讲者笔记或仅包含不间断空格的幻灯片。
- **标题和内容**：用于不符合其他布局条件的幻灯片。

这些布局从 pandoc 包含的默认 pptx 参考文档中选择，除非使用 `--reference-doc` 指定了其他参考文档。

### 增量列表

默认情况下，列表一次性显示所有内容。如果希望列表逐项显示，使用 `-i` 选项。如果希望特定列表偏离默认设置，可将其放入带有 `incremental` 或 `nonincremental` 类的 div 块中。例如，使用围栏式 div 语法，以下内容无论文档默认设置如何都将逐项显示：

```markdown
::: incremental

- Eat spaghetti
- Drink wine

:::
```

或：

```markdown
::: nonincremental

- Eat spaghetti
- Drink wine

:::
```

虽然推荐使用 `incremental` 和 `nonincremental` div 设置逐个列表的增量显示，但也支持一种较旧的方法：将列表放入引用块会偏离文档默认设置（即不使用 `-i` 选项时逐项显示，使用 `-i` 选项时一次性显示）：

```markdown
> - Eat spaghetti
> - Drink wine
```

两种方法都允许在同一文档中混合增量和非增量列表。

如果想包含引用块中的列表，可以通过将列表放入围栏式 div 绕过此行为，使其不直接作为引用块的子节点：

```markdown
> ::: wrapper
> - a
> - list in a quote
> :::
```

### 插入暂停

您可以通过包含一个包含三个点的段落（点之间用空格分隔）在幻灯片内添加“暂停”：

```markdown
# Slide with a pause

content before the pause

. . .

content after the pause
```

::: caution

此功能尚未在 PowerPoint 输出中实现。

:::

### 幻灯片样式

您可以通过在用户数据目录（见上文 `--data-dir`）的 `$DATADIR/s5/default`（S5）、`$DATADIR/slidy`（Slidy）或 `$DATADIR/slideous`（Slideous）中放置自定义 CSS 文件更改 HTML 幻灯片的样式。原始文件可在 pandoc 的系统数据目录（通常为 `$CABALDIR/pandoc-VERSION/s5/default`）中找到。如果用户数据目录中没有找到文件，pandoc 将在系统数据目录中查找。

对于 dzslides，CSS 包含在 HTML 文件本身中，可在其中修改。

所有 reveal.js 配置选项都可以通过变量设置。例如，可以通过设置 `theme` 变量使用主题：

```bash
-V theme=moon
```

或者可以使用 `--css` 选项指定自定义样式表。

要为 Beamer 幻灯片设置样式，可以使用 `-V` 选项指定主题、颜色主题、字体主题、内部主题和外部主题：

``` bash
pandoc -t Beamer habits.txt -V theme:Warsaw -o habits.pdf
```

::: caution

在 HTML 幻灯片格式中，标题属性将转换为幻灯片属性（在 `<div>` 或 `<section>` 上），允许您为单个幻灯片设置样式。在 Beamer 中，某些标题类和属性被识别为框架选项，并作为选项传递给框架（见下文 Beamer 的框架属性）。

:::

### 演讲者笔记

reveal.js、PowerPoint (pptx) 和 Beamer 输出支持演讲者笔记。您可以在 Markdown 文档中添加笔记，如下所示：

```markdown
::: notes

This is my note.

- It can contain Markdown
- like this list

:::
```

在 reveal.js 中，按 `s` 键查看演示时可显示笔记窗口。在 PowerPoint 中，演讲者笔记将在讲义和演示者视图中正常可用。

其他幻灯片格式尚不支持笔记，但笔记不会显示在幻灯片本身上。

### 列布局

要将内容并排放置在列中，可以使用带有 `columns` 类的原生 div 容器，其中包含两个或更多带有 `column` 类和 `width` 属性的 div 容器：

```markdown
:::::::::::::: {.columns}
::: {.column width="40%"}
contents...
:::
::: {.column width="60%"}
contents...
:::
::::::::::::::
```

::: caution

当前不支持在 PowerPoint 中指定列宽。

:::

### Beamer 中的额外列属性

带有 `columns` 和 `column` 类的 div 容器可以选择性地具有 `align` 属性。`columns` 类还可以选择性地具有 `totalwidth` 属性或 `onlytextwidth` 类：

```markdown
:::::::::::::: {.columns align=center totalwidth=8em}
::: {.column width="40%"}
contents...
:::
::: {.column width="60%" align=bottom}
contents...
:::
::::::::::::::
```

`columns` 和 `column` 上的 `align` 属性可以取值 `top`、`top-baseline`、`center` 和 `bottom`，用于垂直对齐列，默认值为 `top`。

`totalwidth` 属性将列的总宽度限制为指定值：

```markdown
:::::::::::::: {.columns align=top .onlytextwidth}
::: {.column width="40%" align=center}
contents...
:::
::: {.column width="60%"}
contents...
:::
::::::::::::::
```

`onlytextwidth` 类将 `totalwidth` 设置为 `\textwidth`。

详情请参阅《Beamer 用户指南》第 12.7 节。

### Beamer 中的框架属性

有时需要在 Beamer 的框架中添加 \LaTeX `[fragile]` 选项（例如，使用 minted 环境时）。可以通过在引入幻灯片的标题中添加 `fragile` 类强制实现：

```markdown
# Fragile slide {.fragile}
```

《Beamer 用户指南》第 8.1 节中描述的所有其他框架属性也都可以使用：`allowdisplaybreaks`、`allowframebreaks`、`b`、`c`、`s`、`t`、`environment`、`label`、`plain`、`shrink`、`standout`、`noframenumbering`、`squeeze`。特别推荐使用 `allowframebreaks`，尤其是在参考文献中，因为它允许在内容溢出框架时创建多个幻灯片：

```markdown
# References {.allowframebreaks}
```

此外，`frameoptions` 属性可用于将任意框架选项传递给 Beamer 幻灯片：

```markdown
# Heading {frameoptions="squeeze,shrink,customoption=foobar"}
```

### reveal.js、Beamer 和 pptx 中的背景

可以在自包含的 reveal.js 幻灯片、Beamer 幻灯片和 pptx 幻灯片中添加背景图片。

1. 所有幻灯片（Beamer、reveal.js、pptx）

在 Beamer 和 reveal.js 中，可以通过 YAML 元数据块或命令行变量使用 `background-image` 配置选项，在每页幻灯片上设置相同的背景图片。

对于 reveal.js，`background-image` 将作为 `parallaxBackgroundImage` 使用（见下文）。

对于 pptx，可以使用 `--reference-doc`，在相关布局上设置背景图片。

2. parallaxBackgroundImage（reveal.js）

对于 reveal.js，还可以使用 reveal.js 原生选项 `parallaxBackgroundImage`，生成视差滚动背景。必须同时设置 `parallaxBackgroundSize`，并可以选择设置 `parallaxBackgroundHorizontal` 和 `parallaxBackgroundVertical` 来配置滚动行为。有关这些选项的含义，请参阅 reveal.js 文档。

在 reveal.js 的概览模式中，`parallaxBackgroundImage` 仅在第一页幻灯片上显示。

3. 单个幻灯片（reveal.js、pptx）

要在特定 reveal.js 或 pptx 幻灯片上设置背景图片，请在幻灯片的第一个幻灯片级别标题上添加 `{background-image="/path/to/image"}`（标题甚至可以为空）。

由于 HTML 编写器会传递未知属性，reveal.js 的其他背景设置也适用于单个幻灯片，包括 `background-size`、`background-repeat`、`background-color`、`transition` 和 `transition-speed`。（`data-` 前缀会自动添加。）

为与 reveal.js 保持一致，pptx 也支持 `data-background-image`——如果未找到 `background-image`，将检查 `data-background-image`。

4. 标题幻灯片（reveal.js、pptx）

要在 reveal.js 的自动生成标题幻灯片上添加背景图片，请在 YAML 元数据块中使用 `title-slide-attributes` 变量，该变量必须包含属性名称和值的映射。（注意，此处需要 `data-` 前缀，因为它不会自动添加。）

对于 pptx，请传递一个在“标题幻灯片”布局上设置了背景图片的 `--reference-doc`。

示例（reveal.js）：

```markdown
---
title: My Slide Show
parallaxBackgroundImage: /path/to/my/background_image.png
title-slide-attributes:
    data-background-image: /path/to/title_image.png
    data-background-size: contain
---

## Slide One

Slide 1 has background_image.png as its background.

## {background-image="/path/to/special_image.jpg"}

Slide 2 has a special image for its background, even though the heading has no content.
```