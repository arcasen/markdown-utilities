### 标题 Headings

Pandoc 可以使用两种标题格式：Setext 和 ATX。

#### Setext 样式

Setext 样式的标题是一行带有“下划线”的文本，其中带有一行=符号（对于一级标题）或 -符号（对于二级标题）。标题文本可能包括*[内联格式 Inline Formatting]*，例如强调和斜体。

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/headings/setext-style-headings.md ]]
```

#### ATX 格式

ATX 样式标题由 1 到 6 个连续的`#`符号和一行文本组成，在行尾可能有任意数量的符号。行首的符号`#`数量即为标题的级别。与 Setext 标题一样，ATX 标题允许*[内联格式 Inline Formatting]*。

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/headings/atx-style-headings.md ]]
```

#### 扩展：`blank_before_header`

原始 Markdown 语法不需要标题前有空行。 Pandoc 确实需要这个（当然，文档的开头除外）。提出这一要求的原因是，`#` 很容易意外地出现在一行的开头（可能由于换行）。

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/headings/blank_before_header.md ]]
```

#### 扩展：`space_in_atx_header`

许多 Markdown 实现并不要求 ATX 标题开头的 `#` 与标题文本之间有空格，因此 `# heading 1` 和 `#heading 1` 都算作标题。

::: caution 

Pandoc 默认要求 `#` 与标题文本之间有空格。如果要取消这个要求，编译时使用选项 `-f markdown-space_in_atx_header`。

:::

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/headings/space_in_atx_header.md ]]
```

编译时执行命令：`pandoc -f markdown-space_in_atx_header input.md -o output.md`。

#### 扩展：`auto_identifiers`

没有明确指定标识符的标题将根据标题文本自动分配唯一标识符。

从标题文本中获取标识符的默认算法是：

- 删除所有格式、链接等。
- 删除所有脚注。
- 删除所有非字母数字字符，下划线、连字符和句点除外。
- 用连字符替换所有空格和换行符。
- 将所有字母字符转换为小写。
- 删除第一个字母之前的所有内容（标识符不能以数字或标点符号开头）。
- 如果此后没有剩余内容，则使用标识符 `section`。

例如：

|           标题               |            标识符          |
| --------------------------- | ------------------------- |
|Heading identifiers in HTML	|heading-identifiers-in-html|
|Maître d'hôtel	              |maître-dhôtel              |
|*Dogs*?--in *my* house?	    |dogs--in-my-house          |
|[HTML], [S5], or [RTF]?	    |html-s5-or-rtf             |
|3. Applications	            |applications               |
|33	                          |section                    |

在大多数情况下，这些规则应该允许根据标题文本确定标识符。例外情况是多个标题具有*相同的文本*；在这种情况下，第一个标题将获得如上所述的标识符；第二个标题将获得相同的标识符并附加 `-1`；第三个标题将附加 `-2`；依此类推。

但是，如果启用 `gfm_auto_identifiers`，则会使用不同的算法；请参见下文。

这些标识符用于在选项生成的目录中提供链接目标 `--toc|--table-of-contents`。它们还可以轻松地提供从文​​档某个部分到另一个部分的链接。例如，指向此部分的链接可能如下所示：

```
See the section on
[heading identifiers](#heading-identifiers-in-html-latex-and-context).
```

但请注意，这种提供章节链接的方法仅适用于 HTML、\LaTeX 和 ConTeXt 格式。

如果 `--section-divs` 指定了该选项，则每个部分将被包裹在 section（或 div，如果指定了 html4）中，并且标识符将附加到封闭的 `<section>`（或 `<div>`）标签而不是标题本身。这允许使用 JavaScript 操作整个部分，或在 CSS 中进行不同的处理。

#### 扩展：`ascii_identifiers`

使生成的标识符为 `auto_identifiers` 纯 ASCII 码。带重音符号的拉丁字母中的重音符号会被去除，非拉丁字母会被省略。

#### 扩展：`gfm_auto_identifiers`

更改 `auto_identifiers` 使用的算法以符合 GitHub 的方法。空格将转换为短划线 (`-`)，大写字母将转换为小写字母，除`-`和 `_` 之外的标点符号将被删除。表情符号将替换为其名称。

#### 扩展：`header_attributes`

可以在包含标题文本的行末尾使用以下语法为标题分配属性：

```markdown
{#identifier .class .class key=value key=value}
```

请注意，虽然此语法允许分配类和键/值属性，但编写者通常不会使用所有这些信息。标识符、类和键/值属性用于 HTML 和基于 HTML 的格式（例如 EPUB 和 slidy）。标识符用于 \LaTeX、ConTeXt、Textile、Jira 标记和 AsciiDoc 编写器中的标签和链接锚点。

如果指定了带有 `unnumbered` 类的标题，则即使使用 `--number-sections` 也不会被编号。属性上下文中的单个连字符（`-`） 相当于 `.unnumbered`，并且在非英语文档中更可取。例如：

```markdown
# My heading {-}
```

和

```markdown
# My heading {.unnumbered}
```

如果存在 `unnumbered` 和 `unlisted` ，则标题将不会包含在目录中。（目前此功能仅适用于某些格式：基于 LaTeX 和 HTML、PowerPoint 和 RTF 的格式。）

::: caution

不编号的标题仍然会出现在目录中，除非你明确排除它们（例如，使用 `{.unlisted}` 属性）。

:::

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/headings/header_attributes.md ]]
```

#### 扩展：`implicit_header_references`

Pandoc 的行为就像每个标题都定义了引用链接（reference links）一样。因此，要链接到标题，只需要直接在标题加上`[]`，并且可以使用*[内联格式 Inline Formatting]*。

如要链接到标题：

`# Heading identifiers in HTML`

你可以简单地写：

`[Heading identifiers in HTML]`

或者（使用斜体）

`*[Heading identifiers in HTML]*`

或者

`[Heading identifiers in HTML][]`

或者

`[the section on heading identifiers][heading identifiers in
HTML]`

而不是明确给出标识符：

`[Heading identifiers in HTML](#heading-identifiers-in-html)`

如果有多个标题具有相同的文本，则相应的参考将仅链接到第一个标题，并且您需要使用明确的链接来链接到其他标题，如上所述。

与常规参考链接一样，这些参考不区分大小写。

::: caution

显式链接引用定义始终优先于隐式标题引用。因此，在下面的例子中，链接将指向 `bar`，而不是 `#foo`：

```markdown
# Foo

[foo]: bar

See [foo]
```

:::

下面是一个完整示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/headings/implicit_header_references.md ]]
```
