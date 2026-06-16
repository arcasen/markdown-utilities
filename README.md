# Markdown Utilities

## Introduction

Markdown 的优点是简洁, 只需很少的几种标记即可将文档内容条理清晰地呈现给读者, 使用者非常容易上手, 而 AsciiDoc, reStructuredText 等标记文件虽然功能较多, 但掌握起来并非易事, 更不用说重量级的排版工具 LaTeX. 然而, "成也萧何, 败也萧何", Markdown 缺少一项非常重要的文件包含功能, 这限制了使用 Markdown 构建复杂文档的功能. 本项目采用文本处理程序 (如 perl, awk, sed 等) 和 GNU Make 实现了 Markdown 的文件包含功能, 能够先自动生成 .md 文件的包含依赖关系, 然后通过 GNU Make 构建一个单一的 .md 文件.

The advantage of Markdown is its simplicity; with just a few types of markup, it can present document content to readers in a clear and organized manner, making it very easy for users to get started. In contrast, markup languages like AsciiDoc and reStructuredText, while offering more features, are not as easy to master—not to mention heavyweight typesetting tools like LaTeX. However, "what makes it succeed can also lead to its failure." Markdown lacks a crucial file inclusion function, which limits its ability to build complex documents. This project utilizes text processing programs (such as Perl, Awk, Sed, etc.) and GNU Make to implement file inclusion for Markdown. It can automatically generate the inclusion dependencies of .md files and then use GNU Make to build a single, unified .md file.

## Prerequistes

- Text processing utilities: perl, awk, sed
- GNU make
- If you want to convert Markdown to PDF, you must install TeX Live and Pandoc.
- Noto and JetBrain Mono fonts
  - Debian: 
    `sudo apt install fonts-noto-cjk fonts-jetbrains-mono`
  - macOS: 
    `brew install --cask font-noto-sans-cjk font-noto-serif-cjk font-jetbrains-mono`

## Installation

```bash
bash install
```

This command will install `mdtool` in `~/.local/bin`. Please append this path to your `PATH`.
This command will also install `boilerplate` in `~/.local/share/pandoc`, then 
you can create the first project:

```bash
mdtool init helloworld
cd helloworld
make pdf
```

## Embedded Markdown Syntax

语法 Syntax:

```
![[ relative/path/to/filename:range ]]
```

OR

```
![[ /absolute/path/to/filename:range ]]
```

该语法与 [Obsidian Flavored Markdown](https://help.obsidian.md/obsidian-flavored-markdown) 兼容，但做了一些限制。文档的所有文件应置于 docs 目录下，所有 Markdown 文件以 .md 为后缀，如涉及文件包含 (包括图片等)，文件包含路径应是绝对路径或相对于本 Markdown 文件的路径； 将 Makefile 放入与 docs 同级目录中，运行 make 命令即可，生成文件在 dist 目录中。

注意:

- 文件包含指令必须单独成行,
- `![[` 前面可以有缩进, 替换时每一行都保留该缩进,
- `filename` 前后可以有空格, 可以为任意文本文件,
- `]]` 后面除了空格外, 不能含有其它字符,
- `:range` 是可选的 (optional), 表示行号范围字符串 (即 `:start-end`), 行号从 1 开始, 支持格式:
  - 如果缺省, 表示包含整个文档
  - `10`: 仅第 10 行
  - `10-20`: 第 10 行到第 20 行 (闭区间)
  - `10-`: 从第 10 行直到文件末尾

Beset practice: 为了保证文件之间的内容不相互干扰, 每个文件指令包含指令前后应该空出一行.

The embeded markdown syntax is comptiable with [Obsidian Flavored Markdown](https://help.obsidian.md/obsidian-flavored-markdown), but adding more restrictions. All files of the document should be placed in the `docs` directory, and all Markdown files should have the `.md` suffix. If file inclusion is involved （including images etc）, the file inclusion path should be absolute path or relative path to this Markdown file. Place the `Makefile` in the same level directory as `docs`, and simply run the `make` command to generate the files in the `dist` directory.

Note:

- The file inclusion directives must stand alone on their own lines.
- `![[` can be preceded by indentation, and when replacing, 
  this indentation will be retained on each line.
- Spaces before or after `filename` are allowed.
- After `]]`, only whitespace is permitted—no other characters are allowed.
- Circular file inclusions can cause errors.

Beset practice: To ensure content between files does not interfere with each other, each directive in a file should be preceded and followed by a blank line.

## Converting Markdown to PDF with Pandoc

The rule in Makefile is as follows:

```
%.pdf: %.md
	pandoc $(OPTIONS) $< -o $@
```

You need to reset variable FONT in Makefile according to your system and run `make pdf`.

When automatically generated PDFs have formatting issues, you can generate a .tex file instead by running `make tex`, edit it manually, and then compile it to the final PDF.

The rule in Makefile is as follows:

```
%.tex: %.md
	pandoc $(OPTIONS) $< -o $@
```

## Building the project

To create a standalone HTML file:

```bash
make html
```

To create a PDF file (TeX Live is required): 

```bash
make pdf
```

## References

- [Markdown and Including Multiple Files](https://stackoverflow.com/questions/4779582/markdown-and-including-multiple-files)
- [Embedding One Markdown Document in Another](https://stackoverflow.com/questions/18438907/embedding-one-markdown-document-in-another)
- [Markdown Guide](https://www.markdownguide.org/)
- [Makrdown 中文](https://www.markdown.cn/) 或 [Markdown 指南中文版](https://www.markdown.xyz/)
- [Introducing Markdown and Pandoc](https://github.com/Apress/introducing-markdown-and-pandoc)

