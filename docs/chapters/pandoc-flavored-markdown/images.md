### 图片 Images

在链接语法前加上 `!` 就是图片插入语法。“链接文本”将用作图片的替代文本，图片的标题是“链接文本”内容，“链接标题”在鼠标悬停在图片上时显示的文本（见*[扩展: `implicit_figures`]*）。

::: caution

如果指定了图片的标题，则图片自动居中显示；否则，左侧可能缩进。

:::

在使用 Pandoc 将 Markdown 文档转换为 PDF（通过 LaTeX）时，图片插入位置默认是*浮动的*（floating），并且将自动将图片宽度限制在文本宽度（`textwidth`）内，如：

```markdown
![[ ../../examples/pandoc-flavored-markdown/images.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/images.md ]]

:::

#### 扩展：`implicit_figures`

如果图片带有非空的 alt 文本，且单独出现在段落中，则该图片将被渲染为带有标题的图形。图片的 alt 文本将用作标题。

```markdown
![This is the caption](/url/of/image.png)
```

如何渲染取决于输出格式。某些输出格式（例如 RTF）尚不支持图形。在这些格式中，您只会在段落中看到一张图片，没有标题。

如果你只是想要一个普通的内联图片，请确保它不是段落中唯一的内容。一种方法是在图片后插入一个不间断的空格：

```markdown
![This image won't be a figure](/url/of/image.png)\
```

请注意，在 reveal.js 幻灯片中，段落中具有该类的图像本身 r-stretch 将填满屏幕，并且标题和图形标签将被省略。

#### 扩展：`link_attributes`

图片的 width 和 height 属性 会被特殊处理。如果不带单位使用，则单位被假定为像素（pixels）。但是，可以使用以下任何单位标识符：`px`、`cm`、 `mm`、`in`、`inch` 和 `%`。**数字和单位之间不得有任何空格**。例如：

```markdown
![](file.jpg){ width=50% }
```

- 尺寸可能会转换为与输出格式兼容的形式（例如，将 HTML 转换为 LaTeX 时，以像素为单位的尺寸将转换为英寸）。像素与物理测量值之间的转换受 `--dpi` 选项影响（默认情况下，假定为 96 dpi，除非图像本身包含 dpi 信息）。

- 单位 `%` 通常与某个可用空间相关。例如，上面的示例将渲染成以下内容。
  - HTML：`<img href="file.jpg" style="width: 50%;" />`
  - LaTeX：`\includegraphics[width=0.5\textwidth,height=\textheight]{file.jpg}` （如果您使用自定义模板，则需要 `graphicx` 按照默认模板进行配置。）
  - ConTeXt：`\externalfigure[file.jpg][width=0.5\textwidth]`
- 一些输出格式具有类（ ConTeXt）或唯一标识符（LaTeX `\caption`）或两者（HTML）。
- 当未指定 width 或 height 属性时，后备方法是查看图像分辨率和图像文件中嵌入的 dpi 元数据。

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/images-attributes.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/images-attributes.md ]]

:::

#### 旋转图片

由于标准的 Markdown 语法不支持旋转图片，需要使用过滤器，见 *[过滤器实例：旋转图片]*。

使用语法：

```markdown
![旋转的图片](/path/to/image.png){width=30% angle=90}
```

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/images-rotation.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/images-rotation.md ]]

:::