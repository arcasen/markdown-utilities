### 链接 Links

使用链接有下面几种形式：

- 自动链接：`<URL>`
- 内联链接：`[链接文本](URL)` 或 `[链接文本](URL "链接标题")`
- `[链接文本][链接标签]`
- 隐式链接("链接文本"和"链接标题"相同)：`[链接文本][]`
- 快捷链接("链接文本"和"链接标题"相同)：`[链接文本]`
- `[链接文本](#标题标识符)` 或 `[标题]`[^id]

[^id]: 标题标识符可以是 Pandoc 按一定规则自动生成，也可以手动定义。

“链接标签”的定义：

- `[链接标签]: URL`
- `[链接标签]: URL "链接标题"`
- `[链接标签]: URL (链接标题)`
- `[链接标签]: <URL>`

#### 自动链接 Automatic Links

如果将 URL 或电子邮件地址放在尖括号中，它将变成链接：

```markdown
![[ ../../examples/pandoc-flavored-markdown/links/automatic-links.md  ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/links/automatic-links.md ]]

:::

#### 内联链接 Inline Links

内联链接由方括号内的链接文本和括号内的 URL[^URL] 组成。（URL 后面也可以跟着链接标题，并用引号引起来。）

[^URL]: URL 可以是网址也可以是本地路径。

```markdown
![[ ../../examples/pandoc-flavored-markdown/links/inline-links.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/links/inline-links.md ]]

:::

方括号和圆括号之间不能有空格。链接文本可以包含格式（例如强调），但标题不能。

内联链接中的电子邮件地址无法自动检测，因此必须加上前缀 `mailto`：

```markdown
[Write me!](mailto:sam@green.eggs.ham)
```

#### 引用链接 Reference Links

显式引用链接包含两部分：链接本身和链接定义，后者可能出现在文档的其他位置（链接之前或之后）。

链接由方括号内的链接文本和方括号内的标签组成。（除非启用了扩展 `spaced_reference_links`，否则两者之间不能有空格。）

链接定义由方括号内的标签、冒号和空格、URL 以及可选的（空格后）链接标题（用引号或括号括起来）组成。

标签不能被解析为文献引用（假设启用了扩展 `citations`）：*文献引用优先于链接标签*。

URL 可以选择性地用尖括号括起来。

标题可以放在下一行。

请注意，链接标签不区分大小写。

在隐式引用链接中，第二对括号为空。

以下是一些示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/links/reference-links.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/links/reference-links.md ]]

:::

在 Markdown.pl Markdown 和大多数其他实现中，引用链接定义不能出现在嵌套结构中，例如列表项或块引用。Pandoc 取消了这一限制。因此，以下代码在 Pandoc 中可以正常工作，但在大多数其他实现中则不行：

```markdown
![[ ../../examples/pandoc-flavored-markdown/links/links-inside-blockquotes-and-lists.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/links/links-inside-blockquotes-and-lists.md ]]

:::

#### 扩展：`shortcut_reference_links`

在快捷引用链接中，第二对括号可以完全省略：

```markdown
See [my website].

[my website]: http://foo.bar.baz
```

#### 内部链接 Internal Links

要链接到同一文档的其他部分，请使用自动生成的标识符（请参阅标题标识符）。例如：

```markdown
See the [Introduction].
```

或者

```markdown
See the [Introduction](#introduction).
```

或者

```markdown
See the [Introduction].

[Introduction]: #introduction
```

或者

```markdown
请参考：[任何其它文本](#标题名称)
```

内部链接目前支持 HTML 格式（包括 HTML 幻灯片和 EPUB）、\LaTeX 和 ConTeXt。
