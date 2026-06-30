### 列表 Lists

#### 无序列表

项目符号列表是由项目符号列表项组成的列表。项目符号列表项以项目符号（`*`、`+` 或 `-`）开头，**列表前必须添加空行**。如：

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/lists-bullet.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/lists-bullet.md ]]

:::

列表项可以包含其他列表。在这种情况下，前面的空行是可选的。嵌套列表必须缩进，以与包含列表项的列表标记后的第一个非空格字符对齐。

#### 列表项含有多个段落

列表项可以包含多个段落和其他块级内容。然而，后续段落必须以一个空行开头，并且缩进以与列表标记后的第一个非空格内容对齐。

例外情况：如果列表标记后跟一个缩进的代码块，该代码块必须在列表标记后5个空格开始，那么后续段落必须在列表标记最后一个字符后两个空格处开始。

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/lists-with-block-contents.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/lists-with-block-contents.md ]]

:::


::: caution

如果要在列表项之间插入脚注，也需要缩进；否则将提前结束列表，见*[列表的结束]*。

:::

#### 嵌套列表

列表项可以包含其他列表。在这种情况下，前面的空行是可选的。嵌套列表必须缩进，以与包含它的列表项的列表标记后的第一个非空格字符对齐。

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/lists-nested.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/lists-nested.md ]]

:::

::: caution

在 \LaTeX 中，列表（包括 itemize、enumerate 和 description 环境）默认支持 四级嵌套；否则，\LaTeX 会报错，提示 `Too deeply nested`。在 HTML 中，列表（包括无序列表 `<ul>` 和有序列表 `<ol>`）的嵌套层级没有明确的上限，理论上可以无限嵌套。

:::

#### 有序列表

有序列表的工作方式与项目符号列表相同，只是项目以枚举器而不是项目符号开头。

在原始 Markdown 中，枚举器是十进制数字，后跟一个句点和一个空格。数字本身会被忽略，如：

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/lists-ordered.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/lists-ordered.md ]]

:::

#### 扩展：`fancy_lists`

与原始 Markdown 不同，Pandoc 允许使用大小写字母和罗马数字以及阿拉伯数字来标记有序列表项。列表标记可以用括号括起来，也可以后跟一个右括号或句点。它们必须与后面的文本至少间隔一个空格；如果列表标记是带句点的大写字母，则必须至少间隔两个空格。

该 ` fancy_lists` 扩展还允许使用 `#` 代替数字作为有序列表标记：

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/lists-fancy.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/lists-fancy.md ]]

:::

#### 扩展：`task_lists`

Pandoc 支持任务列表，使用 GitHub Flavored Markdown 的语法。

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/lists-task.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/lists-task.md ]]

:::

#### 扩展：`definition_lists`

Pandoc 支持定义列表，使用 PHP Markdown Extra[^php] 的语法，并带有一些扩展。

[^php]: <https://michelf.ca/projects/php-markdown/extra/>

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/definition-lists-1.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/definition-lists-1.md ]]

:::

每个术语必须占一行，行尾可以空一行，并且必须跟一个或多个定义。定义以冒号或波浪号开头，可以缩进一至两个空格。

一个术语可能有多个定义，每个定义可以由一个或多个块元素（段落、代码块、列表等）组成，每个块元素缩进四个空格或一个制表位。定义的主体（不包括第一行）应该缩进四个空格。但是，与其他 Markdown 列表一样，除了段落或其他块元素的开头外，你可以“懒惰地”省略缩进。

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/definition-lists-2.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/definition-lists-2.md ]]

:::

如果你在定义前留有空格（如上例所示），定义的文本将被视为段落。在某些输出格式中，这意味着术语/定义对之间的间距会更大。要获得更紧凑的定义列表，请省略定义前的空格：

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/definition-lists-3.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/definition-lists-3.md ]]

:::

请注意，定义列表中的项目之间需要有空格。


#### 列表的结束

如果您想在列表后放置缩进的代码块怎么办？要“截断”第二项之后的列表，您可以插入一些非缩进的内容，例如 HTML 注释，这样不会以任何格式产生可见的输出；如果您想要两个连续的列表而不是一个大列表，则可以使用相同的技巧：

```markdown
![[ ../../examples/pandoc-flavored-markdown/lists/lists-end.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/lists/lists-end.md ]]

:::

#### 紧凑型列表

在使用 Pandoc 将 Markdown 列表转换为 \LaTeX 时，是否使用 `\tightlist` 取决于 Pandoc 的版本、列表的上下文以及输出的 \LaTeX 模板。如果列表嵌套在其他环境中（例如表格、定义列表等）或列表项间存在空行，Pandoc 可能不会插入 `\tightlist`。
