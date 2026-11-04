### 表格 Tables

Pandoc 中支持四种列表样式，前三种要求等宽字体（fixed-width font）[^fwf],最后一种可以使用比例间隔字体（proportionally spaced font）[^psf]：

- `simple_tables`
- `multiline_tables`
- `grid_tables`
- `pipe_tables`

[^fwf]: Fixed-width Font（等宽字体），又称为 Monospaced Font，是一种所有字符（包括字母、数字、标点符号等）占据相同水平宽度的字体。

[^psf]: Proportionally Spaced Font（比例间隔字体）是一种字符宽度不固定的字体，每个字符根据其实际形状占据不同的水平空间。现代中文字体（如思源黑体、苹方、微软雅黑）多为比例间隔字体，尤其在标点和中西文混排时体现宽度优化，适合出版、网页、UI 设计等。

::: caution

中文排版时该对齐是不好控制的，因为中文字体不属于等宽字体。

:::

#### 扩展：`table_captions`

所有 4 种表格类型均可选择添加标题（如下例所示）。标题是一个以字符串 `Table:`（或 `table:` 或仅 `:`）开头的段落，可以出现在表格之前或之后。

::: caution
- 当在表格之前使用 `: <table caption>` 形式的标题时，为避免解析成定义列表（见*[扩展：`definition_lists`]*），可在前面增加一空白行，或将其置于表格之后。

- Pandoc 的原生 Markdown 语法不支持在表格标题中直接添加脚注（见*[脚注 Footnotes]*）。当你在表格标题中使用脚注语法 `[^1]` 并尝试生成文件时，Pandoc 通常会将其作为纯文本处理，而不会将其渲染为正确的脚注格式。
:::

#### 扩展：`simple_tables`

表头和表行必须各占一行。列对齐由表头文本相对于其下方虚线的位置决定：

- 如果虚线与右侧的标题文本齐平，但左侧超出标题文本，则该列右对齐。
- 如果虚线与左侧的标题文本齐平，但在右侧超出标题文本，则该列左对齐。
- 如果虚线超出两侧的标题文本，则该列居中。
- 如果虚线与两侧的标题文本齐平，则使用默认对齐方式（在大多数情况下，将保持对齐）。
  
表格末尾必须留空行，或者以虚线行后接空行结束。

可以省略列表头行，但必须以虚线行作为表格结束标记。省略表头时，对齐规则依据表格正文第一行判断。

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/simple-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/simple-tables.md ]]
:::

#### 扩展：`mutiline_tables`

多行表格允许表头、单元格内容跨多行；不支持单元格跨列、跨行。

语法规则大体与简单表格一致，区别如下：

1. 表头内容之前，必须有一整行虚线（省略表头时除外）
2. 表格结尾必须是虚线行，后面紧跟空行
3. 行与行之间，必须用空行隔开

解析器会识别各列的宽度，输出文档会尽量保留各列的相对宽度。如果输出中某一列过窄，可以在 Markdown 源文件里把该列写宽一点。

多行表格也可以省略表头。

多行表格可以只有一行数据；但该行后必须有空行，再加上结尾虚线行，否则会被解析器识别成简单表格。

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/multiline-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/multiline-tables.md ]]
:::

#### 扩展：`grid_tables`

由等号 `=` 组成的分隔线，用来区分表头和表格主体；无表头表格可以删掉这一行。网格表格单元格内可以放置任意块级元素：多段文本、代码块、列表等。

单元格可以跨越多列或多行^[对于含有中文的表格，可能会失效。]。

表头可能包含多行。

对齐设置：和管道表格一样，在表头下方分隔线的边界处添加冒号设置对齐。

无表头网格表格，则在最上方分隔线写冒号。

可以定义表脚，使用 `=` 代替 `-` 做分隔线，表脚必须放在表格最底部。

表格脚注必须始终放在表格的最底部。

Emacs 的 `table‑mode`（`M‑x table‑insert`）可以便捷生成网格表格。

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/grid-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/grid-tables.md ]]
:::

#### 扩展：`pipe_tables`

语法和 PHP Markdown Extra[^php-table] 的表格保持一致。表格首尾的竖线 `|` 可以省略，但列与列之间必须写竖线。冒号用来指定列对齐。**管道表格不能省略表头**；想要模拟无表头，就把表头单元格留空。

竖线只负责划分列边界，不需要上下严格对齐，下面这份写法虽然排版难看，但完全合法。

[^php-table]: <https://michelf.ca/projects/php-markdown/extra/#table>

管道表格单元格**不支持列表、多段落等块级元素，内容不能跨多行**。

如果源文件中某一行超出 `--columns` 指定宽度，表格将占满正文宽度，单元格文本自动换行；列相对宽度由表头下分隔线的短横线数量决定。例：`---|-`，第一列占 3/4，第二列占 1/4。
如果所有行都没有超出列宽，则文本不换行，单元格宽度随内容自适应。

Pandoc 同样可以识别 Emacs `orgtbl‑mode` 输出的管道表格，允许用 `+` 代替竖线。但 `orgtbl` 的其它特性不受支持；如需修改对齐，仍然要手动加上冒号。

示例：

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/pipe-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/pipe-tables.md ]]
:::

#### `simple_tables` / `multiline_tables` / `grid_tables` / `pipe_tables` 对比

核心分界：**简单表格、多行表格和网格表格依赖等宽字体、必须手工对齐列；管道表格不需要列对齐，兼容比例字体。**

| 属性 | Simple | Multiline | Grid | Pipe |
|---|---|---|---|---|
| 是否需要等宽对齐 | Yes | Yes | Yes | No |
| 单元格内换行 | No | Yes | Yes | No |
| 块元素（列表/代码） | No | No | Yes | No |
| 单元格合并 | No | No | Yes | No |
| 表头能否省略 | Yes | Yes | Yes | No（可空表头） |
: `simple_tables` / `multiline_tables` / `grid_tables` / `pipe_tables` 对比 {.striped}

**1. Simple table（简单表格，`simple_tables`）**

**特点**

- 所有单元格**只能单行**，不能换行、不能放块级元素（列表、代码块、多段文字）
- 靠虚线和文字相对位置判断对齐，语法最简洁
- 可以不要表头
- 必须等宽字体、列要上下对齐

**局限**

- 不支持单元格内换行、不支持块内容、不能合并单元格
- 表头是必需的（如果没有表头则无法识别），同样不支持多行文本和块级元素。

**适用**

- 简短纯文本、数字小表；
- 追求极致简洁、不希望有过多标点符号干扰的纯文本阅读。

**单元格对齐**

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/alignment-of-simple-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/alignment-of-simple-tables.md ]]
:::

**2. Multiline table（多行表格，`multiline_tables`）**

**特点**

- 单元格**支持内部换行**，可以写多行文字（但依然不能放列表、代码块这类块元素）
- 解析器会记录源文件里的列宽，输出时尽量保持相对列宽
- 行之间必须用空行隔开，首尾都要有虚线分隔线
- 同样依赖等宽对齐、可省略表头

**局限**

- 不支持单元格跨行/跨列，不支持块元素
- 不支持显式的竖线分隔，编写时需要注意列宽边界的对齐。

**适用**

- 文字较长、需要单元格内换行，但不需要列表/代码的表格

**单元格对齐**

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/alignment-of-multiline-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/alignment-of-multiline-tables.md ]]
:::

**单元格内换行**

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/line-break-multiline-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/line-break-multiline-tables.md ]]
:::

**3. Grid table（网格表格，`grid_tables`）**

**特点**

- 用 `+ - | =` 画网格线；`=` 区分表头与表体
- 单元格**支持任意块级内容**：多段落、列表、代码块、公式
- **支持单元格跨行、跨列合并**，支持多行表头、表尾
- 也支持用冒号设置对齐方式
- 等宽对齐，源码写起来繁琐（最麻烦，但能力最强）

**局限**

- 语法繁琐，书写成本最高，对字符对齐的精度要求极高（通常需要配合工具或编辑器插件来生成）。

**适用**

- 复杂学术表格、带列表/代码、需要合并单元格的表（\LaTeX 论文首选）
- 复杂的表格结构、需要合并单元格或在单元格内部嵌套复杂 Markdown 元素（如列表、引用块、甚至是代码块）的高级排版。

**单元格对齐**

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/alignment-of-grid-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/alignment-of-grid-tables.md ]]
:::

**单元格内换行**

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/line-break-grid-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/line-break-grid-tables.md ]]
:::

**4. Pipe table（管道表格，`pipe_tables`，GitHub Flavor Markdown 兼容）**

**特点**

- 竖线 `|` 分隔列，**不需要垂直对齐**，随便挤在一起也能解析
- 冒号 `:` 控制对齐（`:---`左、`---:`右、`:---:`居中）
- 最通用，很多外部 Markdown 平台原生支持
- 不强制等宽字体

**局限**

- 表头不可省略（只能填空表头模拟无表头）；
- 每个单元格只能写在单行内，不能放块元素，不能合并单元格，无法包含换行符、多个段落或其他块级元素（如列表、代码块）。

**适用**

- 快速写表、兼顾 GFM 兼容、日常文档
- 小型、单行、结构简单的表格。

**单元格对齐**

```markdown
![[ ../../examples/pandoc-flavored-markdown/tables/alignment-of-pipe-tables.md ]]
```

::: rendered
![[ ../../examples/pandoc-flavored-markdown/tables/alignment-of-pipe-tables.md ]]
:::

#### Caveats

1. 在 Pandoc 表格中插入图片是支持的，而且相对简单。你可以使用标准的 Markdown 图片语法在表格的单元格中插入图片。

2. 在 Pandoc 中，直接在 Markdown 表格的单元格内插入多行围栏式代码块是不支持的。Pandoc 的标准 Markdown 表格语法（如 Pipe Tables、Simple Tables 和 Grid Tables）对单元格内容有一些限制。它们通常期望单元格内容是单行的，或者至少是不包含像围栏式代码块那样需要多行且有特定格式的块级元素。如果你尝试这样做，Pandoc 通常会将其解析为表格中断，或者将代码块视为表格之外的独立内容，导致表格结构被破坏。在 Pandoc Markdown 表格中直接插入多行围栏式代码块是不推荐且通常不可行的。Pandoc 的表格语法设计目的不是为了容纳这种复杂的块级内容。

3. 在 Pandoc 的 Markdown 表格中处理多行中文内容时，容易出现换行错乱、对齐错误或单元格溢出等问题。以下是具体原因和解决方案：

   问题原因：

   - 换行符不兼容：Pandoc 的 Markdown 表格默认用 `<br>` 或空格换行，但中文段落换行可能被忽略。
   - 中文字符宽度计算错误：中文字符宽度是西文的 2 倍，导致自动列宽计算失效。
   - 表格语法限制：Pandoc 的 pipe_tables（`|` 分隔表格）对多行支持较弱，尤其是跨行内容。

   解决方法：

   - 确保分隔线 `|---|` 的宽度足够（如 `|--------|`）。
   - 在网格表格中用空行分隔段落。
     
   <!-- 示例：

   ```markdown
   ![[ ../../examples/pandoc-flavored-markdown/tables/multiline-chinese.md ]]
   ```

   ::: rendered
   ![[ ../../examples/pandoc-flavored-markdown/tables/multiline-chinese.md ]]
   ::: -->
