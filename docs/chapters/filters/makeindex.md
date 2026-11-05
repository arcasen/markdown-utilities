### 过滤器实例：创建索引

Pandoc 原生没有一键生成「术语索引（Index，按术语 + 页码的书末索引）」的能力；但原生支持目录 TOC、表格清单 LOT、图清单 LOF。

#### 使用过滤器建立索引

Pandoc markdown 支持 `[文本]{.cls1 .cls2}` 的写法，空格分隔多个 class（见*[扩展：`bracketed_spans`]*）。属性块里可以同时放：ID、多个 class、多个 key-value 属性，多个 class 也支持逗号分隔：`{.cls1,.cls2}`，空格更常用。

可以通过下面的过滤器实现对形如 `[文本]{.index}` 的文本进行处理，并在 \TeX 文件中生成 `\index{文本}`，同时在 Stenciler 模板加入了对索引的支持。

```python
#!/usr/bin/env python3
import panflute as pf

def action(elem, doc):
    # 只处理 Span，并且包含 .index class
    if isinstance(elem, pf.Span) and "index" in elem.classes:
        content = elem.content
        # 优先读 term 属性，没有就取span内纯文本
        term = elem.attributes.get("term", pf.stringify(elem, newlines=False))

        if doc.format in ("latex", "beamer"):
            if "mark" in elem.classes:
                # mark：手动接管，输出 \hl{内容}\index{term}，保留内部富格式
                return [
                    pf.RawInline(r"\hl{", "latex"),
                    *content,
                    pf.RawInline(r"}", "latex"),
                    pf.RawInline(r"\index{" + term + "}", "latex")
                ]
            else:
                # underline / smallcaps 等：保留Span，追加\index，原生逻辑生效
                elem.content.append(pf.RawInline(r"\index{" + term + "}", "latex"))
                return elem
        else:
            # html / docx：移除 index class，保留其他样式class
            elem.classes.discard("index")
            return elem

if __name__ == "__main__":
    pf.run_filter(action, doc=None)
```

需要注意的是：

- `.mark`：手动接管，输出 `\hl{内容}\index{term}`，保留内部富格式
- `.underline` / `.smallcaps` 等：保留 Span，追加\`index`，原生逻辑生效

这是因为 Pandoc 对这些属性的解析是不同的：`.underline` 和 `.smallcaps` 生成特殊的 Underline 和 Smallcaps 节点，而 `.mark` 不会，所以必须在该过滤器中进行处理，否则会被丢弃。

**`.underline`**

```markdown
![[ ../../examples/filters/ast/underline.md]]
```

解析输出：

```haskell
![[ ../../examples/filters/ast/underline.hs]]
```

**`.smallcaps`**

```markdown
![[ ../../examples/filters/ast/smallcaps.md]]
```

解析输出：

```haskell
![[ ../../examples/filters/ast/smallcaps.hs]]
```

**`.mark`**

```markdown
![[ ../../examples/filters/ast/mark.md]]
```

解析输出：

```haskell
![[ ../../examples/filters/ast/mark.hs]]
```

| Markdown 写法 | 输出 \LaTeX |
| -------- | -------- |
| `[ABC]{.underline .index}` | `\underline{ABC}\index{ABC}` |
| `[ABC]{.smallcaps .index}` | `\textsc{ABC}\index{ABC}` |
| `[ABC]{.mark .index}` | `\hl{ABC}\index{ABC}` | 
| `[ABC]{.index term="测试词条"}` | `ABC\index{测试词条}` |
: 过滤器 `makeindex` 的行为对照表 {.striped}

#### 中文索引的分组和排序

\TeX Live 自带的 `makeindex` 程序不能很好地处理中文索引的分组和排序，建议使用 `zhmakeindex` 程序，该程序不在 \TeX Live 中，是刘海洋写的独立 Go 程序，静态单文件，无依赖。

项目地址：[https://github.com/leo-liu/zhmakeindex](https://github.com/leo-liu/zhmakeindex)

**1. 安装 `zhmakeindex`**

**macOS 平台**

- 解压 zip，取 `bin/darwin_x64/zhmakeindex`（Intel）
- 复制到 \TeX Live 的 bin 路径，例如：

  ```bash
  sudo chmod +x zhmakeindex
  sudo cp zhmakeindex /usr/local/texlive/2026/bin/universal-darwin/
  ```
- 终端验证：`zhmakeindex --help`
  第一次运行会弹窗：**无法打开，因为 Apple 无法检查开发者**，去“系统设置|隐私与安全性”放行。

**Linux 平台**

- 取 `bin/linux_x64/zhmakeindex`
- 复制到 \TeX Live 的 bin 路径，例如：
   
  ```bash
  sudo chmod +x zhmakeindex
  sudo cp zhmakeindex /usr/local/texlive/2026/bin/x86_64-linux/
  ```
- 终端验证：`zhmakeindex --help`

**编译安装**

从 GitHub 上下载源代码编译安装（需要 Go 环境）：

```bash
cd zhmakeindex
go build -o zhmakeindex
```

简单使用示例（和 `makeindex` 兼容）

```bash
xelatex test.tex
zhmakeindex test
xelatex test.tex
```
加 `-z pinyin` 拼音排序（默认），`-z stroke` 笔画排序，`-z radical` 部首排序。

**2. 与 `latexmk` 集成**

创建配置文件 `~/.latexmkrc`：

```perl
# 把默认 makeindex 替换为 zhmakeindex，默认拼音排序
$makeindex = 'zhmakeindex -z pinyin %O %S';

# 如果你用 xelatex / lualatex（中文文档常用）
$xelatex = 'xelatex --synctex=1 %O %S';
$lualatex = 'lualatex --synctex=1 %O %S';

# 可选：想要笔画排序，改成下面这行
# $makeindex = 'zhmakeindex -z stroke %O %S';
# 可选：部首排序
# $makeindex = 'zhmakeindex -z radical %O %S';
```