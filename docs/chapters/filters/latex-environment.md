### 过滤器实例：启用 \LaTeX 环境

下面是一个用 Panflute 编写的过滤器，可以处理 Pandoc 的 Div，将其转换成对应类名的 \LaTeX 环境。以下是具体的渲染规则和输出示例：

1. 第一个类（class）：如果存在类，会使用第一个类名相应的 \LaTeX 环境名称。
2. 其它类：其它类将转化成 \LaTeX 环境的参数。
3. id： 通常被转换为 \LaTeX 的 `\label` 命令，用于交叉引用。
4. 属性：键值对（如 `key=value`）也将转化成 \LaTeX 环境的参数。

该过滤器支持 \LaTeX 模板中的如下形式的环境：

```latex
\begin{env_name}[env_options]\label{env_label}
<content>
\end{env_name}
```

代码如下：

```{.python .numberLines}
![[ ../../examples/filters/latex-environment ]]
```

::: caution 

与参考文献（见*[文献引用 Citations]*）有冲突，编译时应先使用 `--filter latex-environment`，后使用 `--citeproc`；否则，无法定义 `\citeproc` 等命令。

:::

#### 定理环境

通过这个过滤器，我们可以在 Markdown 中使用定理环境：

```markdown
![[ ../../examples/filters/vieta-formulas.md ]]
```

::: rendered

![[ ../../examples/filters/vieta-formulas.md ]]

:::

#### awesomebox 环境

通过这个过滤器，我们可以在 Markdown 中使用 awesomebox[^awesomebox] 环境：

[^awesomebox]: <https://ctan.org/pkg/awesomebox>

```markdown
![[ ../../examples/filters/awesomebox.md ]]
```

::: rendered

![[ ../../examples/filters/awesomebox.md ]]

:::

::: caution

awesomebox 内部不能使用脚注。

:::

#### messagebox 环境

示例：在 Stenciler 模板中预定义了 `messagebox` 环境，我们可以按如下方法使用。

::: caution

messagebox 可以嵌套使用。

:::

```markdown
![[ ../../examples/filters/messagebox.md ]]
```

::: rendered

![[ ../../examples/filters/messagebox.md ]]

:::

