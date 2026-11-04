### 创建索引

Pandoc 原生没有一键生成「术语索引（Index，按术语 + 页码的书末索引）」的能力；但原生支持目录 TOC、表格清单 LOT、图清单 LOF。

Pandoc markdown 支持 `[文本]{.cls1 .cls2}` 的写法，空格分隔多个 class（见*[扩展：`bracketed_spans`]*）。属性块里可以同时放：ID、多个 class、多个 key-value 属性，多个 class 也支持逗号分隔：`{.cls1,.cls2}`，空格更常用。

可以通过下面的过滤器实现对形如 `[文本]{.index}` 的文本进行处理，并在 \TeX 文件中生成 `\index{文本}`，同时在 stenciler 模板加入了对索引的支持。

::: important
需要注意的是：

- `.mark`：手动接管，输出 `\hl{内容}\index{term}`，保留内部富格式
- `.underline` / `.smallcaps` 等：保留 Span，追加\`index`，原生逻辑生效
:::

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

| Markdown 写法 | 输出 \LaTeX |
| -------- | -------- |
| `[ABC]{.underline .index}` | `\underline{ABC}\index{ABC}` |
| `[ABC]{.smallcaps .index}` | `\textsc{ABC}\index{ABC}` |
| `[ABC]{.mark .index}` | `\hl{ABC}\index{ABC}` | 
| `[ABC]{.index term="测试词条"}` | `ABC\index{测试词条}` |
: 过滤器 `makeindex` 的行为对照表 {.striped}