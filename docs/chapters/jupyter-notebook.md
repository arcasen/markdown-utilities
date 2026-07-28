## Jupyter Notebook 转 Markdown

`jupyter nbconvert` 是 Jupyter Ecosystem 中非常强大的命令行工具，能够将 `.ipynb` 笔记本文件转换为多种格式（如 HTML、PDF、\LaTeX、Python 脚本以及 Markdown）。

将 Notebook 转换为 Markdown (`.md`) 在编写文档、博客（如 Hexo/Hugo）、GitHub 展示或与 LLM 工具配合使用时极其常见。

### `jupyter nbconvert` 命令

最基本的 Markdown 转换命令非常简洁：

```bash
jupyter nbconvert --to markdown notebook.ipynb
```

- **输出文件**：默认在当前目录下生成一个 `notebook.md` 文件。
- **图片/图表处理**：如果 Notebook 中包含 Matplotlib 或 Seaborn 生成的内联图表，`nbconvert` 会自动将其提取并保存到一个名为 `notebook_files/` 的文件夹中，并在 Markdown 中自动插入对应的图片引用链接（如 `![png](notebook_files/notebook_1_0.png)`）。

在实际转换中，你通常需要对输出结果进行更精准的控制：

| 参数 | 功能与用法 |
| -------- | ---------------- |
| `--output <filename>`                    | 指定输出的 Markdown 文件名（例如 `--output README.md`）。                             |
| `--output-dir <path>`                    | 指定输出文件（及配套图片文件夹）的存放目录。                                          |
| `--no-input`                             | 隐藏所有代码块，仅保留 Markdown 文本单元格和代码输出结果（适合导出为报告/文章）。 |
| `--no-prompt`                            | 隐藏代码块前的提示符（如 `In [1]:` 或 `Out [1]:`），使导出的 Markdown 更干净。        |
| `--TemplateExporter.exclude_output=True` | 隐藏所有输出，仅保留代码块和 Markdown 描述（适合导出为纯代码教程）。              |
: 命令参数{.striped}

```bash
# 示例：导出为一个不包含输入代码、直接放在 dist 目录下的报告
jupyter nbconvert --to markdown notebook.ipynb --no-input --output-dir ./dist
```

### 模板（Templates）机制详解

`nbconvert` 使用 **Jinja2** 模板引擎来控制导出文档的具体结构与格式。

#### 内置模板

从 nbconvert 6.0 开始，内置模板机制进行了重构。转换 Markdown 时，系统默认使用的是名为 `markdown` 的 Jinja 模板。可以通过 `--template` 参数指定：

```bash
jupyter nbconvert --to markdown notebook.ipynb --template markdown
```

#### 自定义 Jinja2 模板

如果你需要对导出的 Markdown 结构做深度定制（例如：给每个代码块加上特殊的 HTML 包裹层，或者修改图片的渲染路径），可以创建自定义模板。

**第一步：创建模板文件 (`custom_md.j2`)**

新建一个 `.j2` 文件，继承内置的 `markdown` 模板，并重写特定块（block）：

``````jinja2
{% extends 'markdown/index.md.j2' %}

{# 自定义代码块的渲染格式 #}
{% block input %}
```python
{{ cell.source }}
```

{% endblock input %}

{# 为输出的文本添加引言样式 #}
{% block stream %}

> **运行输出：**
> {{ cell.text }}
> {% endblock stream %}
``````

**第二步：应用自定义模板导出**

在命令行中使用 `--template` 参数指定你的 `.j2` 文件路径：

```bash
jupyter nbconvert --to markdown notebook.ipynb --template custom_md.j2
```

#### 修改图片文本

图片标题问题

在使用 `jupyter nbconvert --to markdown` 将 `.ipynb` 转换成 `.md` 时，关于图片标题（Caption / Alt Text），通常会遇到两个最核心的痛点：

代码生成的图（如 Matplotlib 绘图）：转换后默认生成的 Markdown 标签全是统一的 `![png](文件名.png)`，没有自定义标题。

按如下修改 `/usr/local/share/jupyter/nbconvert/templates/markdown/index.md.j2`，并保存到自定目录（或直接修改原文件，无需每次调用时指定 `--template` 参数）：

```java
![[ ../examples/jupyter-notebook/index.md.j2:40-62 ]]
```

```bash
jupyter nbconvert your_file.ipynb --to markdown --template dir/to/index.md.j2
```

### Jupyter Notebook 转 Markdown 示例

::: caution
因为需要现在处理 `.md` 文件中的包含关系（如 `.md` 或图片），需要先手动将 `.ipynb` 转换成 `.md`，并且这些文件应该置于 `docs` 下。
:::

![[ ../examples/jupyter-notebook/central-limit-theorem.md ]]

![[ ../examples/jupyter-notebook/law-of-large-numbers.md ]]
 
