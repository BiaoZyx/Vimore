# Vimore

> Less is more.

[English](README.en.md) | 中文

一个 **Vim 原生增强基础配置**。不依赖任何插件，只靠 `.vimrc` 本身，
把 Vim 补成一个更顺手、更现代、更「开箱即用」的编辑器。

---

## What is Vimore?

Vimore is a pure Vimscript `.vimrc` that turns vanilla Vim into a
modern, out-of-the-box editor — without any plugin manager, LSP,
or external dependency. It provides a which-key style menu,
smart bracket handling, terminal integration, Git shortcuts,
and more, all in ~2000 lines of Vimscript.

---

## 这是什么

Vimore 是一份纯 Vimscript 写的 `.vimrc`，目标是：

- **零插件依赖**：不装任何插件管理器，不拉任何 GitHub 仓库（格式化/检查工具是可选的外部程序）
- **原生增强**：只用 Vim 自带的能力（自动命令、函数、`popup`、`terminal`、`timers`）
- **现代化手感**：借鉴 Helix / which-key 的交互，但保持 Vim 的键位逻辑
- **开箱即用**：拷过去 `source` 一下就能用，不需要额外编译或配置

适合：

- 想在服务器 / 容器 / 陌生机器上快速获得一套顺手的 Vim
- 不想被插件生态绑架，但又觉得原版 Vim 太「素」
- 喜欢用纯 Vimscript 折腾配置的人

Vimore 面向的是折腾意愿中等的 Vim 用户：想用 Vim，但不想为它搭一套插件生态。
典型路径是 nano → vim → helix/neovim → 某个 Neovim 框架 → 回到 vim。走完一圈的人会发现，真正想要的不是「插件堆出来的 IDE」，而是「编辑器本身可编程」——这正是 Vim 的原初设计。Vimore 把这份「可编程」包装成一个开箱即用的配置：纯 Vimscript，无插件管理器，无 LSP，不强制依赖外部程序，但功能齐全。

---

## 安装

仓库根目录自带 `setup.sh`，最省事：

```bash
./setup.sh             # 完整安装（仓库 + 软链接）
./setup.sh --minimal   # 只复制 Vimore.vimrc
./setup.sh --uninstall
./setup.sh --no-backup # 覆盖时不生成 .bak
./setup.sh -y          # 跳过询问
./setup.sh --version   # 显示版本
./setup.sh --help      # 查看全部选项
```

脚本会询问作者名字和邮箱（也可用 `VIMORE_AUTHOR` / `VIMORE_EMAIL`
环境变量非交互式提供），写进安装后的配置顶部；已有的 `~/.vimrc`
会先备份，安装完自动跑一次启动检查。

**最小安装：只拷一个文件，核心功能全部可用。**

```bash
cp Vimore.vimrc ~/.vimrc
```

调色板、菜单、F 键、终端、格式化/检查、Git、文件头都写在这一个文件里，
不需要 `colors/` 目录。只有 `:VimoreTutor` 和 `:VimMaze` 会友好提示
「随附文件不存在」。

**完整安装：把整个仓库当作配置目录，额外拿到教程和小游戏。**

```bash
git clone https://github.com/BiaoZyx/Vimore.git ~/.vim/vimore
ln -s ~/.vim/vimore/Vimore.vimrc ~/.vimrc
```

教程和 `VimMaze.vim` 都相对本文件定位；软链接也能保证这一点。

---

## 主要特性

### 界面

- 相对行号 + 插入模式自动切绝对行号
- 自定义状态栏：模式指示器、文件名、文件类型、编码、行列、时间
- 自定义标签栏：标签名截断、修改标记、当前标签高亮
- 行尾空格显示成淡灰 `·` + 保存时自动清理
- `colorcolumn=120` 边界线

### 编辑
- 智能括号 / 引号补全：`(` `[` `"` 自动配对，`<` 只在 HTML/XML 里配对，`{` 除 C/C++/CSS 外配对
- 智能退格：成对删除 `()` `[]` `{}` `""` `''`
- 括号操作：`<Leader>b d` 只删包裹符号、`<Leader>b c` 换符号、`<Leader>b a` 给选区加括号；连内容删用 `daX`
- 缩进按语言分配：Web/配置/脚本 2 格，系统语言 4 格，Go 用 tab（显示 4），Makefile tab 8；6 格不作为基础宽度
- `<` / `>` 保持 Vim 默认（单按缩进当前行），可视模式缩进选区并保持选中
- 快速注释：`<Leader>/`，支持 Python / C / HTML / CSS / Lua 等

### 搜索

- 增量搜索、智能大小写、高亮结果
- `<C-x><C-o>` 手动补全（避开输入法占用的 `C-Space`）；可视模式 `p` 粘贴不会吞掉寄存器
- `SPC F` 轻量文件搜索（无结果时回退到 netrw）
- 普通运算符保持正文颜色（NeoVim 版会把 C 指针 `*` 单独染蓝）
- `<Leader>hh` 取消高亮

### 终端

- 在 `()` `[]` `{}` 中间回车拆三行；在数组等容器末尾回车把右括号挪到下一行
- 两种拆分都留在插入模式，不经过 `<C-o>`
- `:set splitright` / `splitbelow` + `updatetime=250`
- `<Leader>tt` Terminal (bottom)
- `<Leader>tv` Terminal (right)
- `<Leader>tr` 在最新终端运行当前文件
- `<Leader>tk` 切换 / 关闭终端
- 终端里 `C-\ C-n` 回普通模式

### 运行 / 格式化 / 检查

- `<F5>` Run current file
- `<F6>` 在终端里调试当前文件（pdb / gdb / dlv）
- `<F8>` 异步代码检查，问题放进 quickfix
- `<F9>` 基础格式化（`gg=G`）
- `<F10>` 自动格式化（优先用 black / gofmt / prettier / clang-format）

### Leader 提示菜单

按 `<Space>` 停住约 300ms，弹出 which-key 风格的提示菜单：

- 顶层显示所有可用键，子菜单用 `<名字>` 标出
- 进入子菜单后，第一行显示 `Leader c - Maintain`
- 子菜单项不带前缀，干净利落
- 支持「具体映射优先，没有映射才走菜单」

### 文件头自动生成

新建 `.py` / `.go` / `.sh` / `.bash` / `.c` / `.cc` / `.cpp` / `.h` /
`.hpp` / `.java` / `.js` / `.ts` / `.rs` / `.lua` 时自动插入 **Doxygen 风格**
文件头，按文件类型用 `#` / `"""` / `//` / `/* */` / `--[[]]` 等注释包裹：

```
@file    文件名
@author  作者
@email   邮箱
@date    创建日期（只到天）
@brief   简介
```

Python 3 源码默认 UTF-8，不再生成 `# -*- coding: utf-8 -*-`；Shell 脚本的
shebang 用 `#!/bin/sh`（POSIX 标准）；许可证全文在根目录 `LICENSE`
（GPL-3.0），不重复贴到每个文件里。Go 的 package 按所在
目录推导，Java 的类名按文件名推导。

作者和邮箱在 `.vimrc` 顶部配置：

```vim
let g:author = "Change it in ~/.vimrc"
let g:email  = "Change it in ~/.vimrc"
```


## 配色与主题

调色板与 NeoVimore 同步（深海墨色 + 哑光多巴胺语义色），全部写在
`Vimore.vimrc` 的第 3 节。这里不加载任何真实 `colorscheme`，只登记
`g:colors_name = 'vimore'` 作为傀儡名——真实主题会重建高亮组，把光标行
变成下划线。可以这样确认：

```vim
:echo g:colors_name
:highlight CursorLine   " 应该是 bg=#1a1a22，没有 underline
```

Vim 版**不需要** `colors/` 目录，单文件就是完全体。

终端不支持真彩色时用最接近的 256 色；`COLORTERM=truecolor` 时自动
开启 `termguicolors` 并使用 hex 色值。

## 命令与可选开关

- `:VimoreMenu` — 直接用命令打开 Leader 菜单
- `:VimoreKeys` — 新缓冲区里按模式列出所有键位
- `:VimoreHealth` — 彩色文字标记的自检（版本、配色、工具、随附文件）
- `:VimoreTutor` — 打开 28 章的 Vimore 交互式教程（`tutor/vim.tutor.txt` 是 23 章的原版 Vim 教程）
- `:VimMaze` — 打开仓库根目录的迷宫小游戏（按 `?` 看帮助，`q` 退出）
- `:checkhealth` 之外的健康检查：`vim --clean -Nu Vimore.vimrc -c 'messages' -c 'qa!'`

在 `source` 本配置之前（或直接改文件顶部）可以设置：

```vim
let g:vimore_autochdir = 0        " 1 = 进文件时自动 cd 到文件目录（默认关）
let g:vimore_strip_whitespace = 1 " 0 = 保存时不清理行尾空格
let g:vimore_show_extra_whitespace = 1 " 0 = 不显示行尾空格的 ·
let g:vimore_menu_timeout = 3000  " 菜单无操作后自动关闭的毫秒数
```

---

## 可选：启用 LSP（yegappan/lsp）

Vimore 本身不依赖插件，但如果你想要补全、跳转定义、悬停文档这些 IDE 能力，
可以额外挂一个纯 Vim9script 写的 LSP 客户端：[yegappan/lsp](https://github.com/yegappan/lsp)。

它不依赖 Node.js、Python 或任何包管理器，注册逻辑直白，和你手写映射的风格一致。
代价是必须 **Vim 9.0 以上**，并且要自己提前装好各语言的 LSP 服务器。

### 1. 安装插件（原生 pack，不用包管理器）

```bash
mkdir -p ~/.vim/pack/lsp/opt
git clone https://github.com/yegappan/lsp.git ~/.vim/pack/lsp/opt/lsp
```

### 2. 安装语言服务器

Vimore 面向 Python、C、C++、Shell 四种语言，对应服务器如下：

```bash
# C / C++：clangd（通常随 LLVM 或发行版提供）
sudo apt install clangd        # Debian / Ubuntu
# 或 sudo pacman -S clang

# Python：pyright
npm i -g pyright

# Shell：bash-language-server（需要 Node.js 14+）
npm i -g bash-language-server
```

装完后确认它们在 `$PATH` 里：

```bash
which clangd pyright-langserver bash-language-server
```

如果 `which` 找不到，说明 npm 全局 bin 目录没进 `$PATH`。
在 `~/.zshrc`（不是 `.zprofile`，非登录 shell 不读它）里加：

```bash
export PATH="$HOME/.npm-global/bin:$PATH"
```

### 3. 复制 `plugins.vim` 示例

Vimore 的插件加载逻辑放在 `~/.vim/plugin/plugins.vim`，内容如下。
把它拷到你的 `~/.vim/plugin/` 目录即可，**不需要在 `.vimrc` 里手动 source**——
`~/.vim/plugin/` 下的 `.vim` 文件会在 Vim 启动时自动加载。

```vim
" ============================================================
" plugins.vim — Vimore 可选插件加载
" 放在 ~/.vim/plugin/ 下，Vim 启动时自动 source
" ============================================================

" ------------------------------------------------------------
" LSP（yegappan/lsp，需要 Vim 9.0+）
" ------------------------------------------------------------
if has('vim9script') && !empty(globpath(&packpath, 'pack/*/opt/lsp', 1, 1))
    packadd lsp
endif

" 没装插件时保持静默
if exists(':LspAddServer') == 2
    call LspAddServer([
        \ {
        \   'name': 'clangd',
        \   'filetype': ['c', 'cpp'],
        \   'path': 'clangd',
        \   'args': ['--background-index']
        \ },
        \ {
        \   'name': 'pyright',
        \   'filetype': ['python'],
        \   'path': '/home/YOUR_NAME/.npm-global/bin/pyright-langserver',
        \   'args': ['--stdio']
        \ },
        \ {
        \   'name': 'bash-language-server',
        \   'filetype': ['sh', 'bash'],
        \   'path': '/home/YOUR_NAME/.npm-global/bin/bash-language-server',
        \   'args': ['start']
        \ }
        \ ])
endif

" 限制补全弹出菜单高度，避免遮挡代码
set pumheight=15
```

**注意**：把 `/home/YOUR_NAME/` 换成你自己的家目录路径。
如果 `clangd`、`pyright-langserver`、`bash-language-server` 确实在 `$PATH` 里，
也可以只写命令名。

### 4. 常用操作

配好后打开对应文件，LSP 会自动启动。常用命令：

- `:LspGotoDefinition` — 跳转定义
- `:LspHover` — 悬停文档
- `:LspDiagShow` — 查看全部诊断
- 插入模式 `<C-x><C-o>` — 触发补全

### 5. 注意事项

- **`wildignore` 里有 `*.exe` 时**，`path` 不要以 `.exe` 结尾，否则 `expand()` 会返回空字符串导致服务器找不到。
- **LSP 会接管 `omnifunc`**。Vimore 第 12 节给各文件类型设了原生 `omnifunc`，LSP 启动后可能覆盖它。想要 LSP 补全就用它，不想的话可以在`SetOmniFunc()` 里加判断跳过。
