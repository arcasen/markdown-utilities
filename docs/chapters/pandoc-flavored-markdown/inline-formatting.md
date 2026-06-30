### 内联格式 Inline Formatting

#### 强调

- 斜体：使用 `*` 或 `_` 包裹
- 粗体：使用 `**` 或 `__` 包裹
- `*` 或 `_` 被空格包围或用反斜杠转义不会触发强调

例如：

```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/emphasis.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/emphasis.md ]]

:::


#### 扩展：`intraword_underscores`

由于 `_` 有时会在单词和标识符内部使用，因此 pandoc 不会将 `_` 字母数字字符包围的 解释为强调标记。如果只想强调单词的一部分，请使用*：

```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/intraword_underscores.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/intraword_underscores.md ]]

:::

Pandoc 默认是启用该扩展的，如果要想将单词内部的 `_` 解析强调语法，需要取消该扩展：`-f markdown-intraword_underscores`。

#### 扩展：`strikeout`

要用水平线划掉一段文本，请以 `~~` 开始和结束该部分。

::: caution

在转化为 LaTeX/PDF 时，unline 类会转化成 `\st{...}`（`soul` 宏包命令）， 对于中文是不起作用的。 在 Stenciler 模板中，使用了 `CJKfntef` 宏包的 `CJKsout` 命令重新定义。

:::

例如，

```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/strikeout.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/strikeout.md ]]

:::

#### 扩展：`superscript` 和 `subscript`

上标可以用字符包围上标文本来书写`^`；下标也可以用字符包围下标文本来书写`~`。例如，


```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/superscript-subscript.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/superscript-subscript.md ]]

:::

`^...^` 或之间的文本 `~...~` 不能包含空格或换行符。如果上标或下标文本包含空格，则必须使用反斜杠转义这些空格。（这是为了防止在日常使用~和 时 意外地将文本变为上标或下标^，以及与脚注产生不良交互。）因此，如果您希望下标中包含字母 P 和“a cat”，请使用 `P~a\ cat~`，而不是 `P~a cat~`。

#### 抄录（代码）

- 要抄录一小段文本，请将其放在反引号内
- 如果抄录文本包含反引号，请使用双反引号
- 反斜杠转义符（和其他 Markdown 结构）在抄录环境中不起作用

```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/verbatim.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/verbatim.md ]]

:::

#### 扩展：`inline_code_attributes`

可以将属性附加到逐字文本，就像围栏式代码块一样：

```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/inline_code_attributes.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/inline_code_attributes.md ]]

:::

#### 下划线

要为文本添加下划线，请使用以下 underline 类。

::: caution

在转化为 \LaTeX/PDF 时，unline 类会转化成 `\ul{...}`（`soul` 宏包命令）， 对于中文是不起作用的。 在 Stenciler 模板中，使用了 `CJKfntef` 宏包的 `CJKunderline` 命令重新定义。

:::

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/underline.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/underline.md ]]

:::

#### Small Caps

要编写小型大写字母，请使用以下 smallcaps 类：

```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/small-caps.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/small-caps.md ]]

:::

#### 高亮显示

要突出显示文本，请使用以下 mark 类。

::: caution

在转化为 \LaTeX/PDF 时，unline 类会转化成 `\hl{...}`（`soul` 宏包命令）， 对于中文是不起作用的。`CJKfntef` 宏包不支持中文高亮显示。在 Stenciler 模板中，使用了 `CJKfntef` 宏包绘制字高宽度的下划线来替代。（见<https://tex.stackexchange.com/questions/75019/is-there-any-solution-for-highlighting-text-in-cjk>）

:::

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/inline-formatting/highlighting.md ]]
```

::: rendered

![[ ../../examples/pandoc-flavored-markdown/inline-formatting/highlighting.md ]]

:::