### 过滤器实例：设置文字颜色（增加支持 docx 格式输出）

以下是支持 docx、HTML 和 \LaTeX 输出的完整过滤器，能够处理以 `#` 开头的十六进制颜色代码：

```{.python .numberLines}
![[ ../../examples/filters/text-color-plus ]]
```

使用说明：

1. 将上述代码保存为 `text-color-plus         `
2. 准备一个 Word 参考文档 `custom-reference.docx` 包含以下样式：
   - `ColoredText` - 用于行内彩色文本
   - `ColoredBlock` - 用于彩色文本块

3. 使用 Pandoc 转换时添加过滤器：

   ```bash
   # 转换为 HTML
   pandoc input.md -o output.html --filter text-color-plus         
   
   # 转换为 PDF
   pandoc input.md -o output.pdf --filter text-color-plus         
   
   # 转换为 docx
   pandoc input.md -o output.docx --filter text-color-plus          --reference-doc=custom-reference.docx
   ```

注意事项：

1. docx 输出需要参考文档中的预定义样式
2. 对于 docx 输出，颜色信息存储在 `_color` 属性中，实际渲染需要 Word 应用这些样式
3. 更高级的 docx 处理可能需要直接操作 OpenXML，这超出了 Panflute 的基本功能
4. 确保在所有输出格式中测试颜色显示效果，因为不同格式对颜色的支持可能有所不同

使用步骤：

1. 创建参考 Word 文档：
   - 新建一个 Word 文档
   - 创建两个样式：
     - `ColoredText`：字符样式，可以设置任意颜色（实际颜色将由过滤器覆盖）
     - `ColoredBlock`：段落样式，可以设置任意颜色
   - 保存为 `custom-reference.docx`

2. 修改过滤器（可选）：
   - 如果需要更精细的 docx 样式控制，可以扩展过滤器以生成更复杂的 OpenXML 属性

3. 颜色映射（可选）：
   - 可以添加颜色名称到十六进制值的映射表，确保 docx 中的颜色一致性

完整解决方案文件结构：

```bash
.
├── text-color-plus           # 过滤器脚本
├── custom-reference.docx     # Word 参考文档
├── input.md                  # 示例输入文件
└── Makefile                  # 构建脚本示例
```

命令：

```bash
#!/bin/bash
# 生成 HTML
pandoc input.md -o output.html --filter ./text-color-plus         

# 生成 PDF
pandoc input.md -o output.pdf --filter ./text-color-plus         

# 生成 docx
pandoc input.md -o output.docx --filter ./text-color-plus          --reference-doc=custom-reference.docx
```