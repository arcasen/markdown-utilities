### 引用公式 Referencing Equations

在文本中定义公式标签 `{#eq:label}`，然后引用该标签 `[@eq:label]`：

```latex
![[ ../../examples/cross-referencing/referencing-equations.md ]]
```

::: rendered
![[ ../../examples/cross-referencing/referencing-equations.md ]]
:::

::: note
\LaTeX 的 `amsmath` 提供了 `\numberwithin` 命令，可以定义公式编号格式，如按章编号：
```
\numberwithin{equation}{chapter}
```
或按节编号：
```
\numberwithin{equation}{section}
```
:::
