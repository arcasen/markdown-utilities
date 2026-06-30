### Divs 和 Spans

通过使用 `native_divs`[^native_divs] 和 `native_spans`[^native_spans] 扩展，可以在 Markdown 中使用 HTML 语法来创建 Pandoc AST 中的原生 Div 和 Span 元素。不过，还有更简洁的语法可用：

[^native_divs]: <https://pandoc.org/MANUAL.html#extension-native_divs>
[^native_spans]: <https://pandoc.org/MANUAL.html#extension-native_spans>

#### 扩展：`fenced_divs`

允许使用特殊的围栏语法来创建原生 Div 块。Div 块以至少包含三个连续冒号（`:::`）的围栏开始，后面跟着一些属性。属性后可以选择性地再跟一串连续冒号。

::: caution

`commonmark` 解析器不允许在属性后使用冒号。

:::

属性语法与围栏式代码块中的完全相同（参见*[扩展：`fenced_code_attributes`]*）。与围栏式代码块类似，可以使用花括号中的属性或单个不带花括号的单词（将被视为类名）。Div 块以另一行包含至少三个连续冒号的围栏结束。围栏 Div 应通过空行与前后块分隔。

::: caution

在转换成 \LaTeX 时，Div 不起任何作用；如果需要特殊效果，需要自定义过滤器来处理，见*[过滤器实例：启用 \LaTeX 环境]*。

:::

示例：

```markdown
::::: {#special .sidebar}
这是一个段落。

还有一个。
:::::
```

围栏 Div 可以嵌套。开头的围栏因必须包含属性而有所区分：

```markdown
::: Warning ::::::
这是一个警告。

::: Danger
这是警告中的一个警告。
:::
::::::::::::::::::
```

不带属性的围栏始终是结束围栏。与围栏式代码块不同，结束围栏中的冒号数量不必与开头围栏中的数量匹配。不过，为了视觉清晰，使用不同长度的围栏来区分嵌套 Div 与其父级 Div 是很有帮助的。

#### 扩展：`bracketed_spans`

如果一个括号中的内联序列（如同开始链接时使用的语法）紧接着跟有属性，它将被视为带有属性的 Span：

```markdown
[这是 *一些文本*]{.class key="val"}
```

::: caution 

通过 Divs 和 Spans 的 id 属性，可以文档内部实现链接（见*[链接 Links]*）：

```markdown
[链接文本](#标识符)
```

:::