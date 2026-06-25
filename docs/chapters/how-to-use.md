## 如何使用 markdown-utilities

本章将讲述 **markdown-utilities** 的使用方法，涉及 Pandoc 处理 Markdown 的核心原理，如果对这些内容尚不清楚，可暂时略过此章。

### 准备工作

#### 系统配置要求

使用 **markdown-utilities** 需要下面的工具：

- TeX Live
- perl, sed 
- GNU Make
- Pandoc
- Python3
- Python3 包：panflute

如果要构建 `markdown-utilities/docs` 还需要：

- Node 
- Node 包：mermaid-cli，markmap-cli，puppeteer
- mmap-cli：<https://github.com/arcasen/mmap-cli>

#### 安装 markdown-utilities

```bash
bash install
```

主要功能：

- 将 `boilerplate`，`filters`，`templates` 安装到 `~/.local/share/Pandoc`
- 将 `mdtool` 安装到 `~/.local/bin`

### 基本工作原理与使用

**markdown-utilities** 是通过 `Makefile` 集成 Pandoc，sed，Python3 和 \LaTeX 等工具， 将多个 Markdown 子文档合成为 Markdown 主文档，并将主文档转换为 HTML、PDF 或 DOCX 等格式。

#### 文档包含语法

```
![[ relative/path/to/filename:range ]]  <!--使用时该注释需要删除-->
```

或者：

```
![[ /absolute/path/to/filename:range ]]  <!--使用时该注释需要删除-->
```

该语法与 Obsidian Flavored Markdown[^obsidian] 兼容，但做了一些限制。文档的所有文件应置于 `docs` 目录下，所有 Markdown 文件以 `.md` 为后缀，如涉及文件包含 (包括图片等)，文件包含路径应是绝对路径或相对于本 Markdown 文件的路径； 将 `Makefile` 放入与 `docs` 同级目录中，运行 `make` 命令即可，生成文件在 `dist` 目录中。

[^obsidian]: <https://help.obsidian.md/obsidian-flavored-markdown>


::: important
该文件包含语法的要求如下：

- 文件包含指令必须单独成行；
- `![[` 前面可以有缩进，替换时每一行都保留该缩进；
- `filename` 前后可以有空格，可以为任意文本文件；
- `]]` 后面除了空格外，不能含有其它字符；
- `:range` 是可选的，表示行号范围字符串（即 `:start-end`），行号从 1 开始，支持格式：
  - 如果缺省，表示包含整个文档
  - `10`：仅第 10 行
  - `10-20`：第 10 行到第 20 行（闭区间）
  - `10-`：从第 10 行直到文件末尾
- 为了保证文件之间的内容不相互干扰，每个文件指令包含指令前后应该空出一行。
:::

#### `mdtool` 基本使用

`mdtool` 是用 Python 语言编写的一个处理工具，在 `Makefile` 规则命令中会调用该命令执行**文件展开**和生成**子文档及图片依赖关系**。

```bash
$ mdtool -h
usage: mdtool [-h] [-v] Command ...

Markdown Processing Tool

positional arguments:
  Command        Description
    init (i)     create a project from a boilerplate
    depend (d)   generate nested markdown and image dependencies rules
    expand (e)   process markdown expansion

options:
  -h, --help     show this help message and exit
  -v, --version  show program's version number and exit

example:
  mdtool init [target_dir]  # default dir: .
  mdtool init [target_dir] -y  # overwrite
  mdtool init [target_dir] -a  # create an article
  mdtool depend input.md 
  mdtool expand input.md
```

1. 创建新文档 
   在当前目录下创建：
   ```bash
   mdtool init 
   ```

   或者，在当前目录下创建名为 `helloworld` 的目录：
   ```bash
   mdtool init helloworld
   ```

2. 解析文档中的子文档和本地图片依赖：
   ```bash
   mdtool depend input.md
   ```

3. 展开文档中的子文档：
   ```bash
   mdtool expand input.md
   ```
   如果 `input.md` 含有子文档，则会将子文档插入其中，
   在 `markdown-utilities/Makefile` 调用了该命令。

   ::: note
   文档可以任意嵌套，如 A 包含 B，B 包含 C，那么执行展开命令时，会先将 C 插入 B 中，再将 B 插入 A 中。这个顺序是 GNU Make 根据**文件依赖关系**决定。

   含有文件嵌套的 Markdown 文件必须置于 `docs` 目录或其子目录下，只有这样才能进行文件扩展。相反地，不需要进行文件扩展操作的文件无需置于 `docs` 目录下。
   :::

#### 文档目录结构

现在，我们来创建一个简单的文档：

```bash
mdtool init helloworld
```

文档目录结构如下：

```bash
helloworld
├── Makefile
├── defaults.yaml
├── docs
│   ├── HelloWorld.md
│   ├── images
│   │   └── tux.png
│   ├── sections
│   │   ├── Sec-01.md
│   │   └── Sec-02.md
│   └── title-page.tex
├── examples
│   └── helloworld.c
├── metadata.yaml
└── preamble.tex
```

- `Makefile`：**markdown-utilities** 的核心实现；
- `defaults.yaml`：见 *[默认配置文件 Defaults files]*；
- `metadata.yaml`：见 *[使用元数据 Metadata]*；
- `preamble.tex`：插入到 \TeX 文件导言区的内容，需要在 `defaults.yaml` 设置，见 *[`--include-in-header` 与 `header-includes`]*；
- `docs/title-page.tex`：自定义封面，需要在主文档的 Metadata 中设置。

文件包含语法和图片包含语法中的路径都是**绝对路径**或**相对父文档的相对路径**。
如：

- `docs/sections/Sec-01.md` 引用了 `examples/helloworld.c`，则使用 `![[ ../../examples/helloworld.c ]]`  
- `docs/sections/Sec-02.md` 引用了 `docs/images/tux.png`，则使用
`![tux](../images/tux.png)`

运行 `make` 时， `docs` 下的内容会全部拷贝到 `dist` 目录下，其中 `*.markdown` 是原始未处理的 Markdown 文档，`*.md` 是插入子文档（即执行文件展开）后的 Markdown 文档，需要进行 Markdown 嵌入的文件（包含 `![[ filepath ]]` 的文件）都需要置于该目录中。

`docs` 下的 Markdown 是主文档，可以有多个主文档，构建后将各自生成独立的文档。如果运行 `make tex` 将在 `dist` 产生 `HelloWorld.tex`。同样地，还可以运行 `make pdf` 和 `make html`。

### 自定义 `make` 规则

如果我们需要将一段 Python 代码的运行结果插入到 Markdown 文档中，那么我们可以在文档中写入：`![[ ../../examples/helloworld.py.txt ]]`。

 然后在 `helloworld` 目录创建 `make` 目录，并建立规则 `python.mk` 或 `python.mak`，文件 `helloworld/make/python.mk` 内容如下：

```makefile
%.py.txt: %.py
	Python3 $< > $@
```

文档目录下的 `make` 目录中的所有 `*.mk` 或 `*.mak` 都会插入到 `dist/Makefile` 中。 `markdown-utilities/docs` 就采用了该方法创建 Markmap 思维导图和 Mermaid 图标（见 *[使用 Markmap 思维导图]* 和 *[使用 Mermaid 图表]*）。
