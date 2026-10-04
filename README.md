# Vimore

> Less is more.

一个 **Vim 原生增强基础配置**。不依赖任何插件，只靠 `.vimrc` 本身，
把 Vim 补成一个更顺手、更现代、更「开箱即用」的编辑器。

---

## What is Vimore?

Vimore is a pure Vimscript `.vimrc` that turns vanilla Vim into a
modern, out-of-the-box editor — without any plugin manager, LSP,
or external dependency. It provides a which-key style menu,
smart bracket handling, terminal integration, Git shortcuts,
and more, all in ~1500 lines of Vimscript.

---

## 这是什么

Vimore 是一份纯 Vimscript 写的 `.vimrc`，目标是：

- **零插件依赖**：不装任何插件管理器，不拉任何 GitHub 仓库
- **原生增强**：只用 Vim 自带的能力（自动命令、函数、`popup`、`terminal`、`timers`）
- **现代化手感**：借鉴 Helix / which-key 的交互，但保持 Vim 的键位逻辑
- **开箱即用**：拷过去 `source` 一下就能用，不需要额外编译或配置

适合：

- 想在服务器 / 容器 / 陌生机器上快速获得一套顺手的 Vim
- 不想被插件生态绑架，但又觉得原版 Vim 太「素」
- 喜欢用纯 Vimscript 折腾配置的人

Vimore 面向的是折腾意愿中等的 Vim 用户：想用 Vim，但不想为它搭一套插件生态。
典型路径是 nano → vim → helix/neovim → 某个 Neovim 框架 → 回到 vim。走完一圈的人会发现，真正想要的不是「插件堆出来的 IDE」，而是「编辑器本身可编程」——这正是 Vim 的原初设计。Vimore 把这份「可编程」包装成一个开箱即用的配置：纯 Vimscript，无插件管理器，无 LSP，无外部依赖，但功能齐全。

---

## 主要特性

### 界面

- 相对行号 + 插入模式自动切绝对行号
- 自定义状态栏：模式指示器、文件名、文件类型、编码、行列、时间
- 自定义标签栏：标签名截断、修改标记、当前标签高亮
- 行尾空格高亮 + 保存时自动清理
- `colorcolumn=120` 边界线

### 编辑
- 智能括号 / 引号补全：`(` `[` `"` `<` `{` 自动配对
- 智能退格：成对删除 `()` `[]` `{}` `""` `''`
- 成对删除括号：`<Leader>d`
- 单按 `<` / `>` 缩进当前行，可视模式缩进选区并保持选中
- 快速注释：`<Leader>/`，支持 Python / C / HTML / CSS / Lua 等
- 排序：`:sort` / `:sort u` / `:sort n`

### 搜索

- 增量搜索、智能大小写、高亮结果
- `<Leader>h` 取消高亮

### 终端

- `<Leader>tt` 底部终端
- `<Leader>tv` 右侧终端
- `<Leader>tr` 在最新终端运行当前文件
- `<Leader>tk` 切换 / 关闭终端
- 终端里 `Esc` 回普通模式

### 运行 / 格式化 / 检查

- `<F5>` 运行当前文件
- `<F6>` 调试当前文件
- `<F8>` 代码检查
- `<F9>` 基础格式化（`gg=G`）
- `<F10>` 自动格式化（优先用 black / gofmt / prettier / clang-format）

### Leader 提示菜单

按 `<Space>` 单独停住，弹出 which-key 风格的提示菜单：

- 顶层显示所有可用键，子菜单用 `<名字>` 标出
- 进入子菜单后，第一行显示 `Leader c - 维护`
- 子菜单项不带前缀，干净利落
- 支持「具体映射优先，没有映射才走菜单」

### 文件头自动生成

新建 `.py` / `.go` / `.sh` / `.c` / `.cpp` / `.java` / `.js` 时，
自动插入作者、邮箱、日期、描述等文件头。

作者和邮箱在 `.vimrc` 顶部配置：

```vim
let author = "Change it in ~/.vimrc"
let email  = "Change it in ~/.vimrc"
