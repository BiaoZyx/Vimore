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
- 括号操作：`<Leader>b`
- 单按 `<` / `>` 缩进当前行，可视模式缩进选区并保持选中
- 快速注释：`<Leader>/`，支持 Python / C / HTML / CSS / Lua 等

### 搜索

- 增量搜索、智能大小写、高亮结果
- `<Leader>hh` 取消高亮

### 终端

- `<Leader>tt` 底部终端
- `<Leader>tv` 右侧终端
- `<Leader>tr` 在最新终端运行当前文件
- `<Leader>tk` 切换 / 关闭终端
- 终端里 `C-\ C-n` 回普通模式

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
if has('vim9script')
    " 从 ~/.vim/pack/lsp/opt/ 加载
    packadd lsp

    " 注册语言服务器
    " path 建议写绝对路径，避免 Vim 从不同 shell 启动时找不到
    call LspAddServer([
        \ #{
        \   name: 'clangd',
        \   filetype: ['c', 'cpp'],
        \   path: 'clangd',
        \   args: ['--background-index']
        \ },
        \ #{
        \   name: 'pyright',
        \   filetype: ['python'],
        \   path: '/home/YOUR_NAME/.npm-global/bin/pyright-langserver',
        \   args: ['--stdio']
        \ },
        \ #{
        \   name: 'bash-language-server',
        \   filetype: ['sh', 'bash'],
        \   path: '/home/YOUR_NAME/.npm-global/bin/bash-language-server',
        \   args: ['start']
        \ }
        \ ])

    " 限制补全弹出菜单高度，避免遮挡代码
    set pumheight=15
endif
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

- **`wildignore` 里有 `*.exe` 时**，`path` 不要以 `.exe` 结尾，
  否则 `expand()` 会返回空字符串导致服务器找不到。
- **LSP 会接管 `omnifunc`**。Vimore 第 12 节给各文件类型设了原生 `omnifunc`，
  LSP 启动后可能覆盖它。想要 LSP 补全就用它，不想的话可以在
  `SetOmniFunc()` 里加判断跳过。
- **插件本体不要进 Git**。在 Vimore 仓库的 `.gitignore` 里加：
  ```gitignore
  .vim/pack/
  ```
