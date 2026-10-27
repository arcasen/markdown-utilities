### 引用表格 Referencing Tables

在文本中定义表格标签 `{#tbl:label}`，然后引用该标签 `[@tbl:label]`：

```markdown
 a   b   c
--- --- ---
 1   2   3
 4   5   6

: Simple Table {#tbl:label}
```

::: caution
- Pandoc 表格并不支持属性设置（见<https://stackoverflow.com/questions/41877612/pandoc-add-class-to-table-in-markdown>），
pandoc-crossref 采用了特殊处理方式（见<https://github.com/jgm/pandoc/issues/6317#issuecomment-618978090>）。

- 标题与属性之间要有空格。
:::
