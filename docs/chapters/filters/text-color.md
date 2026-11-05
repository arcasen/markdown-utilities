### 过滤器实例：设置文字颜色（支持 HTML 和 \LaTeX 格式输出）

下面是一个用 Panflute 编写的过滤器，可以处理两种颜色标记格式，支持以 `#` 开头的 HTML 十六进制颜色代码，并同时兼容 HTML 和 \LaTeX 输出：

1. 行内（Span）颜色
   
   ```
   [文字]{color=颜色}
   ```

2. 块级（Div）颜色
   
   ```
   :::{color=颜色} 
   文字内容 
   :::
   ```

代码如下：

```{.python .numberLines}
![[ ../../examples/filters/text-color ]]
```

使用说明：

1. 将上述代码保存为 `text-color`
2. 使用 Pandoc 转换时添加过滤器：

   ```bash
   # 转换为 HTML
   pandoc input.md -o output.html --filter text-color
   
   # 转换为 PDF
   pandoc input.md -o output.pdf --filter text-color
   ```

功能特点：

1. 支持 HTML 十六进制颜色：
   - 可以处理 `[文字]{color=#FF0000}` 这样的十六进制颜色代码
   - 也可以处理标准颜色名称如 `[文字]{color=red}`

2. 自动适应输出格式：
   - HTML 输出：使用 `style="color: #FF0000;"`
   - \LaTeX 输出：自动生成 `\definecolor` 命令和 `\textcolor` 环境

3. 块级和行内颜色支持：
   - 行内：`[红色文字]{color=#FF0000}`
   - 块级：
     ```markdown
     ::: {color=#00FF00}
     这里是绿色文字块
     :::
     ```

注意事项：

1. 确保 \LaTeX 安装了 `xcolor` 包
2. 对于 PDF 输出，复杂的颜色组合可能需要额外的 \LaTeX 包
3. 颜色名称和十六进制值需要是有效的 CSS/\LaTeX 颜色值

示例：

```markdown
![[ ../../examples/filters/colored-text.md ]]
```

::: rendered

![[ ../../examples/filters/colored-text.md ]]

:::