### 变量

#### 元数据变量

`title`, `author`, `date`： 用于标识文档的基本信息。可以通过 \LaTeX 和 ConTeXt 将这些信息嵌入到 PDF 元数据中。可以通过 Pandoc 标题块设置，标题块支持多个作者，也可以通过 YAML 元数据块设置：

```yaml
---
author:
- 亚里士多德
- 彼得·阿贝拉尔
...
```

如果仅需设置 PDF 或 HTML 的元数据，而不在文档中包含标题块，可以设置 `title-meta`、`author-meta` 和 `date-meta` 变量。（默认情况下，这些变量会根据 `title`、`author` 和 `date` 自动设置。）HTML 页面标题由 `pagetitle` 设置，默认与 `title` 相同。

`subtitle`： 文档副标题，包含在 HTML、EPUB、\LaTeX、ConTeXt 和 docx 文档中。

`abstract`： 文档摘要，包含在 HTML、\LaTeX、ConTeXt、AsciiDoc 和 docx 文档中。

`abstract-title`： 摘要标题，目前仅用于 HTML、EPUB 和 docx。会根据 `lang` 自动设置为本地化值，但可以手动覆盖。

`keywords`： 关键词列表，包含在 HTML、PDF、ODT、pptx、docx 和 AsciiDoc 元数据中；与 `author` 类似，可重复设置。

`subject`： 文档主题，包含在 ODT、PDF、docx、EPUB 和 pptx 元数据中。

`description`： 文档描述，包含在 ODT、docx 和 pptx 元数据中。某些应用程序将其显示为“注释”元数据。

`category`： 文档类别，包含在 docx 和 pptx 元数据中。

此外，任何未包含在 ODT、docx 或 pptx 元数据中的根级字符串元数据将作为自定义属性添加。例如，以下 YAML 元数据块：

```yaml
---
title: '这是标题'
subtitle: "这是副标题"
author:
- 作者一
- 作者二
description: |
    这是一个较长的描述。

    它包含两段文字。
...
```

在转换为 docx、ODT 或 pptx 时，`title`、`author` 和 `description` 将作为标准文档属性，`subtitle` 将作为自定义属性。

#### 语言变量

`lang`： 使用 IETF 语言标签（遵循 BCP 47 标准）标识文档的主要语言，例如 `en` 或 `en-GB`。可使用语言子标签查询工具验证这些标签。影响大多数格式，并在使用 \LaTeX（通过 babel 和 polyglossia）或 ConTeXt 生成 PDF 时控制连字符。

使用带有 `lang` 属性的原生 Pandoc Div 和 Span 切换语言：

```markdown
---
lang: en-GB
...

Text in the main document language (British English).

::: {lang=fr-CA}
> Cette citation est écrite en français canadien.
:::

More text in English. ['Zitat auf Deutsch.']{lang=de}
```

`dir`： 基本书写方向，值为 `rtl`（从右到左）或 `ltr`（从左到右）。

对于双向文档，可以使用带有 `dir` 属性（值为 `rtl` 或 `ltr`）的原生 Pandoc Span 和 Div 来覆盖某些输出格式的默认方向。如果最终渲染器（如生成 HTML 时的浏览器）支持 Unicode 双向算法，可能不需要此操作。

在使用 \LaTeX 处理双向文档时，仅 `xelatex` 引擎完全支持（使用 `--pdf-engine=xelatex`）。

#### HTML 变量

`document-css`： 启用 `styles.html` 模板中大部分 CSS 的包含（可通过 `Pandoc --print-default-data-file=templates/styles.html` 查看）。默认情况下，除非使用 `--css`，此变量为 `true`。可通过 `Pandoc -M document-css=false` 禁用。

`mainfont`： 设置 HTML 元素的 CSS `font-family` 属性。

`fontsize`： 设置基础 CSS `font-size`，通常设置为例如 `20px`，但也接受 `pt`（在大多数浏览器中，12pt = 16px）。

`fontcolor`： 设置 HTML 元素的 CSS `color` 属性。

`linkcolor`： 设置所有链接的 CSS `color` 属性。

`monofont`： 设置代码元素的 CSS `font-family` 属性。

`monobackgroundcolor`： 设置代码元素的 CSS `background-color` 属性并添加额外内边距。

`linestretch`： 设置 HTML 元素的 CSS `line-height` 属性，推荐使用无单位值。

`maxwidth`： 设置 CSS `max-width` 属性（默认值为 36em）。

`backgroundcolor`： 设置 HTML 元素的 CSS `background-color` 属性。

`margin-left`, `margin-right`, `margin-top`, `margin-bottom`： 设置 body 元素的相应 CSS 内边距属性。

若需为单个文档覆盖或扩展 CSS，可包含例如：

```yaml
---
header-includes: |
  <style>
  blockquote {
    font-style: italic;
  }
  tr.even {
    background-color: #f0f0f0;
  }
  td, th {
    padding: 0.5em 2em 0.5em 0.5em;
  }
  tbody {
    border-bottom: none;
  }
  </style>
---
```

#### HTML 数学变量

`classoption`： 当使用 `--katex` 时，可以通过 YAML 元数据或 `-M classoption=fleqn` 设置数学公式左对齐显示。

#### HTML 幻灯片变量
这些变量影响使用 Pandoc 生成幻灯片时的 HTML 输出。

`institute`： 作者隶属机构：支持多个作者时可以是列表。

`revealjs-url`： reveal.js 文档的基础 URL（默认为 <https://unpkg.com/reveal.js@^5> ）。

`s5-url`： S5 文档的基础 URL（默认为 `s5/default`）。

`slidy-url`： Slidy 文档的基础 URL（默认为 <https://www.w3.org/Talks/Tools/Slidy2> ）。

`slideous-url`： Slideous 文档的基础 URL（默认为 `slideous`）。

`title-slide-attributes`： reveal.js 幻灯片标题页的额外属性。参见 reveal.js、Beamer 和 pptx 中的背景示例[^slide-bg]。

[^slide-bg]: <https://pandoc.org/MANUAL.html#background-in-reveal.js-Beamer-and-pptx>

所有 reveal.js 配置选项[^reveal-options]均可用作变量。若需关闭 reveal.js 中默认开启的布尔标志，使用 `0`。

[^reveal-options]: <https://revealjs.com/config/>

#### Beamer 幻灯片变量

这些变量更改使用 Beamer 生成的 PDF 幻灯片的外观。

`aspectratio`： 幻灯片宽高比（43 表示 4:3 [默认]，169 表示 16:9，1610 表示 16:10，149 表示 14:9，141 表示 1.41:1，54 表示 5:4，32 表示 3:2）。

`beameroption`： 通过 `\setbeameroption{}` 添加额外的 Beamer 选项。

`institute`： 作者隶属机构：支持多个作者时可以是列表。

`logo`： 幻灯片 logo 图片。

`navigation`： 控制导航符号（默认为空，即无导航符号；其他有效值为 `frame`、`vertical` 和 `horizontal`）。

`section-titles`： 启用新部分的“标题页”（默认为 `true`）。

`theme`, `colortheme`, `fonttheme`, `innertheme`, `outertheme`： Beamer 主题。

`themeoptions`, `colorthemeoptions`, `fontthemeoptions`, `innerthemeoptions`, `outerthemeoptions`： \LaTeX Beamer 主题的选项（列表）。

`titlegraphic`： 标题页图片：可以是列表。

`titlegraphicoptions`： 标题页图片的选项。

`shorttitle`, `shortsubtitle`, `shortauthor`, `shortinstitute`, `shortdate`： 某些 Beamer 主题使用标题、副标题、作者、机构、日期的短版本。

#### PowerPoint 变量

这些变量控制幻灯片中不易通过模板控制的视觉效果。

`monofont`： 用于代码的字体。

#### \LaTeX 变量

Pandoc 在使用 \LaTeX 引擎生成 PDF 时使用这些变量。

##### 布局

`block-headings`： 使 `\paragraph` 和 `\subparagraph`（第四级和第五级标题，或在 book 类中为第五级和第六级）独立显示，而非嵌入式；需要进一步格式化以区分 `\subsubsection`（第三级或第四级标题）。与其使用此选项，KOMA-Script 可以更广泛地调整标题：

```yaml
---
documentclass: scrartcl
header-includes: |
  \RedeclareSectionCommand[
    beforeskip=-10pt plus -2pt minus -1pt,
    afterskip=1sp plus -1sp minus 1sp,
    font=\normalfont\itshape]{paragraph}
  \RedeclareSectionCommand[
    beforeskip=-10pt plus -2pt minus -1pt,
    afterskip=1sp plus -1sp minus 1sp,
    font=\normalfont\scshape,
    indent=0pt]{subparagraph}
...
```

`classoption`： 文档类的选项，例如 `oneside`；可重复设置多个选项：

```yaml
---
classoption:
- twocolumn
- landscape
...
```

`documentclass`： 文档类：通常为标准类 `article`、`book` 和 `report`；KOMA-Script 类似的是 `scrartcl`、`scrbook` 和 `scrreprt`（默认较小边距）；或 `memoir`。

`geometry`： geometry 包的选项，例如 `margin=1in`；可重复设置多个选项：

```yaml
---
geometry:
- top=30mm
- left=20mm
- heightrounded
...
```

`hyperrefoptions`： hyperref 包的选项，例如 `linktoc=all`；可重复设置多个选项：

```yaml
---
hyperrefoptions:
- linktoc=all
- pdfwindowui
- pdfpagemode=FullScreen
...
```

`indent`： 如果为 `true`，Pandoc 将使用文档类的缩进设置（否则默认 \LaTeX 模板会移除缩进并在段落间添加间距）。

`linestretch`： 使用 setspace 包调整行间距，例如 `1.25`、`1.5`。

`margin-left`, `margin-right`, `margin-top`, `margin-bottom`： 如果未使用 geometry 包，则设置边距（否则 geometry 会覆盖这些设置）。

`pagestyle`： 控制 `\pagestyle{}`：默认 article 类支持 `plain`（默认）、`empty`（无页眉页脚）、`headings`（页眉包含章节标题）。

`papersize`： 纸张大小，例如 `letter`、`a4`。

`secnumdepth`： 章节编号深度（配合 `--number-sections` 选项或 `numbersections` 变量）。

`beamerarticle`： 从 Beamer 幻灯片生成文章。**注意**：若设置此变量，必须指定 Beamer 写入器，但使用默认 \LaTeX 模板，例如：`Pandoc -Vbeamerarticle -t beamer --template default.latex`。

`handout`： 生成 Beamer 幻灯片的讲义版本（将叠加内容压缩为单页）。

`csquotes`： 加载 csquotes 包并对引文使用 `\enquote` 或 `\enquote*`。

`csquotesoptions`： csquotes 包的选项（可重复设置多个选项）。

`babeloptions`： 传递给 babel 包的选项（可重复设置多个选项）。如果主要语言不是使用拉丁或西里尔字母的欧洲语言或越南语，默认设置为 `provide=*`。大多数用户无需调整默认设置。

##### 字体

`fontenc`： 通过 fontenc 包指定字体编码（配合 pdflatex）；默认值为 `T1`（参见 [\LaTeX 字体编码指南](https://ctan.org/pkg/encguide)）。

`fontfamily`： 配合 `pdflatex` 使用的字体包：\TeX Live 包含许多选项，详见 [\LaTeX 字体目录](https://tug.org/FontCatalogue/)。默认值为 [Latin Modern](https://ctan.org/pkg/lm)。

`fontfamilyoptions`： 作为 `fontfamily` 的包的选项；可重复设置多个选项。例如，通过 `libertinus` 宏包[^libertinus]使用 Libertine 字体并启用比例小写（旧式）数字：

[^libertinus]: <https://ctan.org/pkg/libertinus>

```yaml
---
fontfamily: libertinus
fontfamilyoptions:
- osf
- p
...
```

`fontsize`： 正文字体大小。标准类支持 10pt、11pt 和 12pt。若需其他大小，设置 `documentclass` 为 KOMA-Script 类，如 `scrartcl` 或 `scrbook`。

`mainfont`, `sansfont`, `monofont`, `mathfont`, `CJKmainfont`, `CJKsansfont`, `CJKmonofont`： 用于 `xelatex` 或 `lualatex` 的字体族：可使用系统字体名称，配合 `fontspec` 包。`CJKmainfont` 在 `xelatex` 中使用 `xecjk` 包，在 `lualatex` 中使用 `luatexja` 包。

`mainfontoptions`, `sansfontoptions`, `monofontoptions`, `mathfontoptions`, `CJKoptions`, `luatexjapresetoptions`： 在 `xelatex` 和 `lualatex` 中用于 `mainfont`、`sansfont`、`monofont`、`mathfont`、`CJKmainfont` 的选项，支持 `fontspec` 包的任何选项；可重复设置多个选项。例如，使用 [TeX Gyre](http://www.gust.org.pl/projects/e-foundry/tex-gyre) 版本的 Palatino 字体并启用小写数字：

```yaml
---
mainfont: TeX Gyre Pagella
mainfontoptions:
- Numbers=Lowercase
- Numbers=Proportional
...
```

`mainfontfallback`, `sansfontfallback`, `monofontfallback`： 如果在 `mainfont`、`sansfont` 或 `monofont` 中找不到字形，则尝试使用的字体列表。字体名称后必须跟冒号，可选附加选项，例如：

```yaml
---
mainfontfallback:
  - "FreeSans:"
  - "NotoColorEmoji:mode=harf"
...
```

字体回退目前仅支持 `lualatex`。

`babelfonts`： Babel 语言名称（例如 `chinese`）与对应字体的映射：

```yaml
---
babelfonts:
  chinese-hant: "Noto Serif CJK TC"
  russian: "Noto Serif"
...
```

`microtypeoptions`: 
传递给 `microtype` 包的选项。

##### 链接

`colorlinks`： 为链接文本添加颜色；如果设置了 `linkcolor`、`filecolor`、`citecolor`、`urlcolor` 或 `toccolor`，则自动启用。

`boxlinks`： 在链接周围添加可见框（如果设置了 `colorlinks`，则无效）。

`linkcolor`, `filecolor`, `citecolor`, `urlcolor`, `toccolor`  
分别为内部链接、外部链接、引用链接、URL 链接和目录链接设置颜色：支持 `xcolor` 包的选项，包括 `dvipsnames`、`svgnames` 和 `x11names` 颜色列表。

`links-as-notes`： 将链接作为脚注打印。

`urlstyle`： URL 的字体样式（例如 `tt`、`rm`、`sf`，默认为 `same`）。

##### 前置内容

`lof`, `lot`： 包含图表列表和表格列表（也可通过 `--lof/--list-of-figures`、`--lot/--list-of-tables` 设置）。

`thanks`： 文档标题后致谢脚注的内容。

`toc`： 包含目录（也可通过 `--toc/--table-of-contents` 设置）。

`toc-depth`： 目录中包含的章节级别。

##### BibLaTeX 参考文献

这些变量在使用 BibLaTeX 渲染引用时生效。

`biblatexoptions`： `biblatex` 的选项列表。

`biblio-style`： 参考文献样式，配合 `--natbib` 和 `--biblatex` 使用。

`biblio-title`： 参考文献标题，配合 `--natbib` 和 `--biblatex` 使用。

`bibliography`： 用于解析引用的参考文献文件。

`natbiboptions`： natbib 的选项列表。

#### ConTeXt 变量

Pandoc 在使用 ConTeXt 生成 PDF 时使用这些变量。

`fontsize`： 正文字体大小（例如 `10pt`、`12pt`）。

`headertext`, `footertext`： 放置在页眉或页脚的文本（参见 [ConTeXt 页眉和页脚](https://wiki.contextgarden.net/Headers_and_Footers)）；可重复设置最多四次以实现不同位置。

`indenting`： 控制段落缩进，例如 `yes,small,next`（参见 [ConTeXt 缩进](https://wiki.contextgarden.net/Indentation)）；可重复设置多个选项。

`interlinespace`： 调整行间距，例如 `4ex`（使用 [`setupinterlinespace`](https://wiki.contextgarden.net/Command/setupinterlinespace)）；可重复设置多个选项。

`layout`： 页面边距和文本排列的选项（参见 [ConTeXt 布局](https://wiki.contextgarden.net/Layout)）；可重复设置多个选项。

`linkcolor`, `contrastcolor`： 页面内外链接的颜色，例如 `red`、`blue`（参见 [ConTeXt 颜色](https://wiki.contextgarden.net/Color)）。

`linkstyle`： 链接的字体样式，例如 `normal`、`bold`、`slanted`、`boldslanted`、`type`、`cap`、`small`。

`lof`, `lot`： 包含图表列表和表格列表。

`mainfont`, `sansfont`, `monofont`, `mathfont`： 字体族：使用任何系统字体名称（参见 [ConTeXt 字体切换](https://wiki.contextgarden.net/Font_Switching)）。

`mainfontfallback`, `sansfontfallback`, `monofontfallback`： 如果主字体中缺少字形，则按顺序尝试的字体列表，使用 `\definefallbackfamily` 兼容的字体名称语法。不支持表情符号字体。

`margin-left`, `margin-right`, `margin-top`, `margin-bottom`： 如果未使用 `layout`，则设置边距（否则 `layout` 会覆盖这些设置）。

`pagenumbering`： 页面编号样式和位置（使用 [`setuppagenumbering`](https://wiki.contextgarden.net/Command/setuppagenumbering)）；可重复设置多个选项。

`papersize`： 纸张大小，例如 `letter`、`A4`、`landscape`（参见 [ConTeXt 纸张设置](https://wiki.contextgarden.net/PaperSetup)）；可重复设置多个选项。

`pdfa`： 添加生成指定类型 PDF/A 所需的设置，例如 `1a:2005`、`2a`。如果未指定类型（例如通过 `--metadata=pdfa` 或 YAML 中 `pdfa: true` 设置），默认使用 `1b:2005` 以保持向后兼容性。不支持未指定值的 `--variable=pdfa`。生成 PDF/A 需确保 ICC 颜色配置文件可用，且内容及包含文件（如图片）符合标准。ICC 配置文件和输出意图可通过 `pdfaiccprofile` 和 `pdfaintent` 变量指定。参见 [ConTeXt PDFA](https://wiki.contextgarden.net/PDF/A) 了解详情。

`pdfaiccprofile`： 配合 `pdfa` 使用，指定 PDF 使用的 ICC 配置文件，例如 `default.cmyk`。如果未指定，默认使用 `sRGB.icc`。可重复设置多个配置文件。配置文件需在系统上可用，可从 [ConTeXt ICC 配置文件](https://wiki.contextgarden.net/PDFX#ICC_profiles)获取。

`pdfaintent`： 配合 `pdfa` 使用，指定颜色输出意图，例如 `ISO coated v2 300\letterpercent\space (ECI)`。如果未指定，默认使用 `sRGB IEC61966-2.1`。

`toc`： 包含目录（也可通过 `--toc/--table-of-contents` 设置）。

`urlstyle`： 无链接文本的 URL 字体样式，例如 `normal`、`bold`、`slanted`、`boldslanted`、`type`、`cap`、`small`。

`whitespace`： 段落间距，例如 `none`、`small`（使用 `setupwhitespace`）。

`includesource`： 将所有源文档作为 PDF 文件附件包含。

#### wkhtmltopdf 变量

Pandoc 在使用 wkhtmltopdf 生成 PDF 时使用这些变量。`--css` 选项也会影响输出。

`footer-html`, `header-html`： 为页眉和页脚添加信息。

`margin-left`, `margin-right`, `margin-top`, `margin-bottom`： 设置页面边距。

`papersize`： 设置 PDF 纸张大小。

#### man 页面变量

`adjusting`： 调整文本对齐方式，值为左（`l`）、右（`r`）、居中（`c`）或两端（`b`）。

`footer`： man 页面页脚。

`header`： man 页面页眉。

`section`： man 页面章节编号。

#### Texinfo 变量

`version`： 软件版本（用于标题和标题页）。

`filename`： 生成 info 文件的名称（默认为基于 texi 文件名的名称）。

#### Typst 变量

`template`： 使用的 Typst 模板。

`margin`： Typst 文档中定义的边距字段：`x`、`y`、`top`、`bottom`、`left`、`right`。

`papersize`： 纸张大小：`a4`、`us-letter` 等。

`mainfont`： 主字体的系统字体名称。

`fontsize`： 字体大小（例如 `12pt`）。

`section-numbering`： 章节编号模式，例如 `1.A.1`。

`page-numbering`： 页面编号模式，例如 `1` 或 `i`，或空字符串以省略页面编号。

`columns`： 正文列数。

#### ms 变量

`fontfamily`： 字体：`A`（Avant Garde）、`B`（Bookman）、`C`（Helvetica）、`HN`（Helvetica Narrow）、`P`（Palatino）或 `T`（Times New Roman）。此设置不影响源代码，源代码始终使用等宽 Courier 显示。这些内置字体字符覆盖范围有限。可使用 Peter Schaffter 提供的 `install-font.sh`[^install-sh] 脚本安装额外字体，详见其网站[^ms-web]。

[^install-sh]: <https://www.schaffter.ca/mom/bin/install-font.sh>
[^ms-web]: <https://www.schaffter.ca/mom/momdoc/appendices.html#steps>

`indent`： 段落缩进（例如 `2m`）。

`lineheight`： 行高（例如 `12p`）。

`pointsize`： 字体大小（例如 `10p`）。

### 自动设置的变量

Pandoc 根据选项[^options]或文档内容自动设置这些变量，用户也可修改。这些变量因输出格式而异，包括：

[^options]: <https://pandoc.org/MANUAL.html#options>

`body`： 文档正文。

`date-meta`： 转换为 ISO 8601 `YYYY-MM-DD` 格式的日期，包含在所有基于 HTML 的格式（dzslides、epub、html、html4、html5、revealjs、s5、slideous、slidy）中。支持的日期格式为：`mm/dd/yyyy`、`mm/dd/yy`、`yyyy-mm-dd`（ISO 8601）、`dd MM yyyy`（例如 `02 Apr 2018` 或 `02 April 2018`）、`MM dd, yyyy`（例如 `Apr. 02, 2018` 或 `April 02, 2018`）、`yyyy[mm[dd]]`（例如 `20180402`、`201804` 或 `2018`）。

`header-includes`： 由 [`-H/--include-in-header`](https://pandoc.org/MANUAL.html#option--include-in-header) 指定的内容（可有多个值）。

`include-before`： 由 [`-B/--include-before-body`](https://pandoc.org/MANUAL.html#option--include-before-body) 指定的内容（可有多个值）。

`include-after`： 由 [`-A/--include-after-body`](https://pandoc.org/MANUAL.html#option--include-after-body) 指定的内容（可有多个值）。

`meta-json`： 文档所有元数据的 JSON 表示，字段值转换为所选输出格式。

`numbersections`： 如果指定了 [`-N/--number-sections`](https://pandoc.org/MANUAL.html#option--number-sections)，则为非空值。

`sourcefile`, `outputfile`： 命令行中给定的源文件和目标文件名。如果输入来自多个文件，`sourcefile` 可以是列表；如果输入来自标准输入，则为空。以下模板片段可区分它们：

```latex
$if(sourcefile)$
$for(sourcefile)$
$sourcefile$
$endfor$
$else$
(stdin)
$endif$
```

类似地，`outputfile` 如果输出到终端，则为 `-`。

如果需要绝对路径，可使用例如 `$curdir$/$sourcefile$`。

`pdf-engine`： 如果通过 `--pdf-engine` 提供 PDF 引擎名称，或请求 PDF 输出时的默认引擎。

`curdir`： 运行 Pandoc 的工作目录。

`pandoc-version`： Pandoc 版本。

`toc`： 如果指定了 [`--toc/--table-of-contents`](https://pandoc.org/MANUAL.html#option--toc[)，则为非空值。

`toc-title`： 目录标题（仅适用于 EPUB、HTML、revealjs、opendocument、odt、docx、pptx、Beamer、\LaTeX）。

::: caution

在 docx 和 pptx 中，自定义 `toc-title` 可从元数据中获取，但无法作为变量设置。

:::

在使用 Pandoc 将文档转换为 PDF 时，Pandoc 会根据输入文件的内容、元数据（metadata）以及使用的模板自动生成一些变量。这些变量主要用于模板渲染，特别是在 \LaTeX 或其他模板中生成 PDF 时。 例如，即使不设置 `header-includes`， Pandoc 也会自动设置一些变量，可以查看生成的 \LaTeX 即知。在自动设置的变量中定义了：

- `figurename`
- `tablename`
- `listfigurename`
- `listtablename`
- `lstlistlistingname`
- 等等

如果在文档中重新设置 `header-includes`，将被置于内置的 `header-includes` 之前，无法修改这些自动设置的变量。可以在 \LaTeX 模板的 `header-includes` 之后增加 `header-continue`。这样，我们就可以在文档中设置新的数据，如：

```yaml
header-continue: |
  \AtBeginDocument{%
    \renewcommand*\figurename{图}
    \renewcommand*\tablename{表}
    \renewcommand*\lstlistingname{代码}
    \renewcommand*\listfigurename{图表清单}
    \renewcommand*\listtablename{表格清单}
    \renewcommand*\lstlistlistingname{代码清单}
  }
```
