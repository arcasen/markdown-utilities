### 引用图片 Referencing Figures

在文本中定义图片标签 `{#fig:label}`，然后引用该标签 `[@fig:label]`：

```markdown
![alt text](/path/to/image){#fig:label}
```

如果需要加入属性：

```markdown
![alt text](/path/to/image){#fig:label width=32px}
```

::: caution
标题与属性之间不能有空格。
:::
