### 过滤器实例：显示引用内容所在页面

下面是一个用 Panflute 编写的过滤器，在建立链接时显示引用内容所在页面（这样对纸质资料读者更友好）。代码如下：

```{.python .numberLines}
![[ ../../examples/filters/pageref ]]
```

`url.startswith('#ref-')` 专门识别文献引用的跳转链接，需要排除。

**进阶建议：区分引用的类型**

如果你希望对章节引用显示“第 X 页”，对公式或图表显示不同的格式，可以进一步细化判断：

- 如果是章节：`if url.startswith('#sec:')`
- 如果是图表：`if url.startswith('#fig:')`
- 如果是公式：`if url.startswith('#eq:')`

示例：

```markdown
关于在 Markdown 中书写书写公式，请参考 *[数学公式 Mathematical
Expressions]*。
```

::: rendered

关于在 Markdown 中书写书写公式，请参考 *[数学公式 Mathematical
Expressions]*。

:::