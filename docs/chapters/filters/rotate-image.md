### 过滤器实例：旋转图片

由于标准的 Markdown 语法不支持旋转图片，需要使用过滤器。使用语法：

```markdown
![旋转的图片](/path/to/image.png){width=30% angle=90}
```

示例见 *[旋转图片]*。

#### 过滤器代码

```python
![[ ../../../filters/rotate-image ]]
```

#### 导出为 PDF (\LaTeX)

Pandoc 在生成图片的 \LaTeX 文本时，将 `width=50%` 转换为 `width=0.5\linewidth`，而在过滤器中是看不到 `0.5\textwidth`。这是因为因为你站在了 AST（抽象语法树） 的内部观察，而转换通常发生在 渲染阶段（Writer）。

解析阶段 (Reader)：Pandoc 把 Markdown 里的 `{width=50%}` 读入，存入 AST 的属性字典，此时它依然是原始字符串 "50%"。

过滤阶段 (Filter)：Panflute 脚本就在这里运行。此时转换还没发生，拿到的 `elem.attributes['width']` 确实就是 "50%"。

渲染阶段 (Writer)：如果你不使用过滤器，Pandoc 的 \LaTeX{ }Writer 会在最后输出 `.tex` 文件时，根据内部逻辑把 "50%" 变成 `0.5\maxwidth`。但如果过滤器返回了 `RawInline`（原生 \LaTeX 代码），你跳过了 Writer 的自动处理。

在这个过滤器中，使用了 `adjustbox` 包，而不返回含 `\includegraphics[...]` 的 `RawInline`，保证 Pandoc 在渲染阶段处理其它属性（如：`width` 和 `height`）。

#### 导出为 HTML

如果你是生成网页，旋转最简单的办法是使用 **CSS 行内样式**。Pandoc 允许你在大括号中传递属性。

```markdown
![旋转的图片](image.png){style="transform: rotate(90deg);"}
```

使上述旋转图片语法和过滤器也是可以的，本质上是一致的。

