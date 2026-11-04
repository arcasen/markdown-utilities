## 默认配置文件 Defaults files

Pandoc 的默认配置文件（defaults files）[^defaults]是一个 YAML 格式[^yaml]的配置文件，用于存储 Pandoc 转换文档时常用的选项和设置。它允许用户将命令行参数持久化保存，避免重复输入相同的参数，特别适合复杂的文档转换任务或团队协作场景。

[^defaults]: <https://pandoc.org/MANUAL.html#defaults-files>

[^yaml]: YAML Ain't Markup Language，与 XML（标记语言）不同，YAML 避免使用标签（`< >`），而是依赖缩进和符号表示结构。

`--defaults` 选项可用于指定一组选项，格式为 YAML 文件。默认文件可以放置在用户数据目录的 `defaults` 子目录中，并从任何目录使用。例如，可以创建一个指定写信默认设置的文件，将其保存为用户数据目录的 `defaults` 子目录中的 `letter.yaml`，然后从任何目录通过 `pandoc --defaults letter` 或 `pandoc -dletter` 调用这些默认设置。

当使用多个默认文件时，它们的设置将被合并。需要注意的是，对于可以重复的命令行参数（例如 `--metadata-file`、`--css`、`--include-in-header`、`--include-before-body`、`--include-after-body`、`--variable`、`--metadata`、`--syntax-definition`），命令行中指定的值将与默认文件中指定的值合并，而不是替换。

### General Options

<!-- 

在使用 Pandoc 将 Markdown 转换为其他格式（如 HTML 或 PDF）时，
表格单元格中以反引号（`）包裹的代码（如 ` hello,world`）可能会导致前面
的空格被忽略。

在 Markdown 中，可以手动将前导空格替换为 Unicode 非断行空格（U+00A0）。
虽然直接输入非断行空格不方便，但可以通过文本编辑器或脚本替换。

-->

----------------------------------------------------------------------
Command line                        Default file                  
----------------------------------  ----------------------------------
`--from markdown+emoji`             `from: markdown+emoji`          

`--to markdown+hard_line_breaks`    `to: markdown+hard_line_breaks` 

`--output foo.pdf`                  `output-file: foo.pdf`          

`--data-dir dir`                    `data-dir: dir`                 

`--defaults file`                   `defaults:`\                     
                                    `  - file`       
----------------------------------------------------------------------

: General Options{.striped}

::: caution

表格中只列举部分选项，详见 Pandoc 文档，下同。

:::

默认文件中指定的选项始终优先于通过 `defaults:` 条目包含的其他文件中的选项。

### 阅读器选项 Reader Options

----------------------------------------------------------------------
Command line                        Default file                  
----------------------------------  ----------------------------------
`--shift-heading-level-by -1`       `shift-heading-level-by: -1`

`--default-image-extension ".jpg"`  `default-image-extension: '.jpg'`

`--file-scope`                      `file-scope: true`

`--citeproc \`                      `filters:`\
`--lua-filter wc.lua \`             `  - citeproc`\
`--filter special.lua`              `  - wc.lua`\
                                    `  - type: json`\
                                    `    path: special.lua`

`--metadata key=value \`            `metadata:`\
`--metadata key2`                   `  key: value`\
                                    `  key2: true`
  
`--metadata-file meta.yaml`         `metadata-files:`\
                                    `  - meta.yaml`\
                                    OR\
                                    `metadata-file: meta.yaml`
----------------------------------------------------------------------

: Reader Options{.striped}

默认文件中指定的元数据值被解析为字面字符串文本（literal string text），而不是 Markdown。

如果过滤器具有 `.lua` 扩展名，则假定为 Lua 过滤器，否则为 JSON 过滤器。但也可以明确指定过滤器类型，如上所示。过滤器按指定顺序运行。要包含内置的 `citeproc` 过滤器，可以使用 `citeproc` 或 `{type: citeproc}`。

### 通用写入器选项

----------------------------------------------------------------------
Command line                        Default file                  
----------------------------------  ----------------------------------
`--standalone`                      `standalone: true`               

`--template letter`                 `template: letter`               

`--variable key=val \`              `variables:`\
`--variable key2`                   `  key: val`\  
                                    `  key2: true`                   

`--table-of-contents`               `table-of-contents: true`        

`--toc`                             `toc: true`                      

`--toc-depth 3`                     `toc-depth: 3`                   

`--strip-comments`                  `strip-comments: true`           

`--no-highlight`                    `highlight-style: null`          

`--highlight-style kate`            `highlight-style: kate`  

`--include-in-header inc.tex`       `include-in-header:`\
                                    `  - inc.tex`

`--include-before-body inc.tex`     `include-before-body:`\
                                    `  - inc.tex`

`--include-after-body inc.tex`      `include-after-body:`\
                                    `  - inc.tex`
----------------------------------------------------------------------

: 通用写入器选项{.striped}

### 特定写入器选项

----------------------------------------------------------------------
Command line                        Default file                  
----------------------------------  ----------------------------------
`--self-contained`                  `self-contained: true`            

`--link-images`                     `link-images: true`               

`--html-q-tags`                     `html-q-tags: true`               

`--ascii`                           `ascii: true`                     

`--reference-links`                 `reference-links: true`           

`--reference-location block`        `reference-location: block`       

`--figure-caption-position=above`   `figure-caption-position: above`  

`--table-caption-position=below`    `table-caption-position: below`   

`--markdown-headings atx`           `markdown-headings: atx`          

`--list-tables`                     `list-tables: true`               

`--top-level-division chapter`      `top-level-division: chapter`     

`--number-sections`                 `number-sections: true`           

`--number-offset=1,4`               `number-offset: [1,4]`            

`--listings`                        `listings: true`                  

`--list-of-figures`                 `list-of-figures: true`           

`--lof`                             `lof: true`                       

`--list-of-tables`                  `list-of-tables: true`            

`--lot`                             `lot: true`                       

`--incremental`                     `incremental: true`               

`--slide-level 2`                   `slide-level: 2`                  

`--section-divs`                    `section-divs: true`              

`--email-obfuscation references`    `email-obfuscation: references`   

`--id-prefix ch1`                   `identifier-prefix: ch1`          

`--title-prefix MySite`             `title-prefix: MySite`            

`--reference-doc my.docx`           `reference-doc: my.docx`          

`--epub-cover-image cover.jpg`      `epub-cover-image: cover.jpg`     

`--epub-title-page=false`           `epub-title-page: false`          

`--epub-metadata meta.xml`          `epub-metadata: meta.xml`         

`--split-level 2`                   `split-level: 2`                  

`--chunk-template="%i.html"`        `chunk-template: "%i.html"`       

`--pdf-engine xelatex`              `pdf-engine: xelatex`             

`--pdf-engine-opt=--shell-escape`   `pdf-engine-opts: `\
                                    `  - 'shell-escape`\
                                    OR\
                                    `pdf-engine-opt: '-shell-escape'` 
----------------------------------------------------------------------

: 特定写入器选项{.striped}

### 引文渲染

----------------------------------------------------------------------
Command line                        Default file                  
----------------------------------  ----------------------------------
`--citeproc`                        `citeproc: true`                  

`--bibliography logic.bib`          `bibliography: logic.bib`         

`--csl ieee.csl`                    `csl: ieee.csl`                   

`--citation-abbreviations ab.json`  `citation-abbreviations: ab.json` 

`--natbib`                          `cite-method: natbib`             

`--biblatex`                        `cite-method: biblatex`           
----------------------------------------------------------------------

: 引文渲染{.striped}

`cite-method` 可以是 `citeproc`、`natbib` 或 `biblatex`。这仅影响 \LaTeX 输出。如果要使用 `citeproc` 格式化引文，还应设置 `citeproc: true`。

如果需要控制 `citeproc` 处理与其他过滤器的相对顺序，应在过滤器列表中使用 `citeproc`（参见*[阅读器选项 Reader Options]*）。

### HTML 中的数学渲染

----------------------------------------------------------------------
Command line                        Default file                  
----------------------------------  ----------------------------------
`--mathjax`                         `html-math-method:`\
                                    `  method: mathjax` 

`--mathml`                          `html-math-method:`\
                                    `  method: mathml`  

`--webtex`                          `html-math-method:`\
                                    `  method: webtex`  

`--katex`                           `html-math-method:`\
                                    `  method: katex`   

`--gladtex`                         `html-math-method:`\
                                    `  method: gladtex` 
----------------------------------------------------------------------

: HTML 中的数学渲染{.striped}

除上述值外，`method` 还可以取值 `plain`。

如果命令行选项接受 URL 参数，可以在 `html-math-method:` 中添加 `url:` 字段。
