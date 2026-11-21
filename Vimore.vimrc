" ============================================================
" Vimore
" 作者: BiaoZyx
" 邮箱: BiaoZyx@outlook.com
" 版本: 3.34
" ============================================================
"  _   ___
" | | / (_)_ _  ___  _______
" | |/ / /  ' \/ _ \/ __/ -_)
" |___/_/_/_/_/\___/_/  \__/
"                   Less is more.
" ============================================================
" 备注: 普通vim可能剪切板支持不好，建议安装gvim以使用vim
" ============================================================
" 记得更改这个，将用于文件头生成
let g:author = get(g:, 'author', 'Change it in ~/.vimrc')
let g:email  = get(g:, 'email',  'Change it in ~/.vimrc')

" 可选开关（在 source 本文件之前设置，或直接改这里的默认值）
" 打开后，进入文件时自动把窗口工作目录切到文件所在目录
let g:vimore_autochdir = get(g:, 'vimore_autochdir', 0)
" 设为 0 可关闭保存时清理行尾空格
let g:vimore_strip_whitespace = get(g:, 'vimore_strip_whitespace', 1)
" Leader 菜单无操作多少毫秒后自动关闭
let g:vimore_menu_timeout = get(g:, 'vimore_menu_timeout', 3000)
" 设为 0 可不显示行尾空格高亮（终端 / nofile 缓冲本来就不显示）
let g:vimore_show_extra_whitespace = get(g:, 'vimore_show_extra_whitespace', 1)

" ============================================================
" 1. 基础设置
" ============================================================
set nocompatible              " 不使用 vi 兼容模式

" 随附文件（教程、VimMaze）都相对本文件定位；单文件安装时不存在也不影响
let s:root = fnamemodify(resolve(expand('<sfile>:p')), ':h')

syntax on
syntax enable
set background=dark

" 支持真彩色的终端才打开 termguicolors，否则 256 色配色反而会失真
if has('termguicolors') && !has('gui_running') && $COLORTERM =~? 'truecolor\|24bit'
    set termguicolors
endif

let mapleader = " "           " Leader 键设为空格
set clipboard=                " 不自动同步系统剪切板，用 Ctrl+C/V 手动控制

" 颜色主题：只登记名字，不调用任何真实 colorscheme。
" 真实主题会重建高亮组，把 CursorLine 变成下划线；颜色全部在本文件定义。
let g:colors_name = 'vimore'

" 启动信息精简：a=缩写, o=覆盖写入, O=覆盖读取, t=启动提示, T=标签页信息
set shortmess=aoOtT

filetype on
filetype indent on
filetype plugin on

" ============================================================
" 2. 界面显示
" ============================================================
set number                    " 显示行号
set relativenumber            " 显示相对行号
set cursorline                " 高亮当前行
"set cursorcolumn              " 高亮当前列
"set noshowcmd                 " 不显示命令（减少回显）
set noshowmode                " 不显示 --INSERT-- 等（状态栏已显示）
set laststatus=2              " 始终显示状态栏
set ruler                     " 显示光标位置
set title                     " 设置终端标题
set ttyfast                   " 快速终端连接
"set lazyredraw                " 延迟屏幕更新（提高性能）

" 进入插入模式时使用绝对行号
augroup VimoreNumber
    autocmd!
    autocmd InsertEnter * setlocal norelativenumber
    autocmd InsertLeave * setlocal relativenumber
augroup END

" 限制语法同步范围 (避免 Vim 每次重绘都从头解析整个文件)
syntax sync minlines=200
syntax sync maxlines=500

" 插入模式补全弹出菜单垂直长度
set pumheight=15

" ============================================================
" 3. 状态栏
" ============================================================
" ---------- 与 NeoVimore 同步的深海墨色调色板 ----------
" 真正的颜色全部在这里定义；只登记 g:colors_name，不加载真实主题，
" 避免它覆盖 CursorLine 等自定义高亮。单文件安装不需要任何外部文件。
let s:pal = {
            \ 'bg0': ['#121217', 233],
            \ 'bg1': ['#1a1a22', 234],
            \ 'bg2': ['#22222c', 235],
            \ 'bg3': ['#2c2c38', 236],
            \ 'bg4': ['#3e3e4c', 238],
            \ 'fg0': ['#d4d4dc', 188],
            \ 'fg1': ['#a0a0b0', 248],
            \ 'fg2': ['#6c6c7e', 243],
            \ 'fg3': ['#454552', 239],
            \ 'punct': ['#5b5b6d', 241],
            \ 'red': ['#e5748a', 174],
            \ 'orange': ['#e8a77d', 180],
            \ 'yellow': ['#d6bc84', 180],
            \ 'green': ['#82c79a', 114],
            \ 'cyan': ['#82c4d4', 116],
            \ 'blue': ['#7fa9de', 110],
            \ 'purple': ['#b39fe0', 146]
            \ }

function! s:Hl(group, fg, bg, style) abort
    let fg = a:fg ==# '' ? 'NONE' : s:pal[a:fg][0]
    let bg = a:bg ==# '' ? 'NONE' : s:pal[a:bg][0]
    let cfg = a:fg ==# '' ? 'NONE' : s:pal[a:fg][1]
    let cbg = a:bg ==# '' ? 'NONE' : s:pal[a:bg][1]
    execute 'silent! highlight ' . a:group
          \ . ' term=NONE guifg=' . fg . ' guibg=' . bg . ' gui=' . a:style
          \ . ' ctermfg=' . cfg . ' ctermbg=' . cbg . ' cterm=' . a:style
endfunction

call s:Hl('Normal', 'fg0', 'bg0', 'NONE')
call s:Hl('NormalNC', 'fg0', 'bg0', 'NONE')
call s:Hl('NormalFloat', 'fg0', 'bg2', 'NONE')
call s:Hl('FloatBorder', 'bg4', 'bg2', 'NONE')
call s:Hl('FloatTitle', 'yellow', 'bg2', 'bold')
call s:Hl('FloatFooter', 'fg2', 'bg2', 'NONE')
call s:Hl('LineNr', 'fg3', 'bg0', 'NONE')
call s:Hl('CursorLineNr', 'yellow', 'bg1', 'bold')
call s:Hl('CursorLine', '', 'bg1', 'NONE')
call s:Hl('CursorColumn', '', 'bg1', 'NONE')
call s:Hl('Cursor', 'bg0', 'fg0', 'NONE')
call s:Hl('lCursor', 'bg0', 'fg0', 'NONE')
call s:Hl('TermCursor', 'bg0', 'fg0', 'NONE')
call s:Hl('SignColumn', 'fg3', 'bg0', 'NONE')
call s:Hl('CursorLineSign', 'fg3', 'bg1', 'NONE')
call s:Hl('CursorLineFold', 'fg3', 'bg1', 'NONE')
call s:Hl('ColorColumn', '', 'bg1', 'NONE')
call s:Hl('VertSplit', 'bg4', 'bg0', 'NONE')
call s:Hl('WinSeparator', 'bg4', 'bg0', 'NONE')
call s:Hl('Visual', '', 'bg3', 'NONE')
call s:Hl('VisualNOS', '', 'bg2', 'NONE')
call s:Hl('Search', 'bg0', 'yellow', 'NONE')
call s:Hl('IncSearch', 'bg0', 'yellow', 'bold')
call s:Hl('CurSearch', 'bg0', 'yellow', 'bold')
call s:Hl('MatchParen', 'cyan', '', 'bold,underline')
call s:Hl('Pmenu', 'fg0', 'bg2', 'NONE')
call s:Hl('PmenuSel', 'bg0', 'purple', 'bold')
call s:Hl('PmenuSbar', '', 'bg1', 'NONE')
call s:Hl('PmenuThumb', '', 'bg4', 'NONE')
call s:Hl('PmenuKind', 'yellow', 'bg2', 'NONE')
call s:Hl('PmenuExtra', 'fg2', 'bg2', 'NONE')
call s:Hl('PmenuMatch', 'blue', 'bg2', 'NONE')
call s:Hl('PmenuMatchSel', 'bg0', 'purple', 'bold')
call s:Hl('StatusLine', 'fg0', 'bg3', 'bold')
call s:Hl('StatusLineNC', 'fg2', 'bg1', 'NONE')
call s:Hl('StatusLineTerm', 'fg0', 'bg3', 'bold')
call s:Hl('StatusLineTermNC', 'fg2', 'bg1', 'NONE')
call s:Hl('MsgArea', 'fg0', 'bg0', 'NONE')
call s:Hl('MsgSeparator', 'bg4', 'bg0', 'NONE')
call s:Hl('WildMenu', 'bg0', 'purple', 'bold')
call s:Hl('QuickFixLine', '', 'bg2', 'bold')
call s:Hl('TabLine', 'fg2', 'bg1', 'NONE')
call s:Hl('TabLineSel', 'fg0', 'bg3', 'bold')
call s:Hl('TabLineFill', '', 'bg1', 'NONE')
call s:Hl('NonText', 'bg4', '', 'NONE')
call s:Hl('SpecialKey', 'bg4', '', 'NONE')
call s:Hl('Whitespace', 'punct', '', 'NONE')
call s:Hl('ExtraWhitespace', 'punct', '', 'NONE')
call s:Hl('Conceal', 'fg2', '', 'NONE')
call s:Hl('Directory', 'blue', '', 'bold')
call s:Hl('Title', 'yellow', '', 'NONE')
call s:Hl('ErrorMsg', 'red', '', 'bold')
call s:Hl('WarningMsg', 'yellow', '', 'bold')
call s:Hl('MoreMsg', 'green', '', 'bold')
call s:Hl('Question', 'green', '', 'NONE')
call s:Hl('ModeMsg', 'fg0', '', 'bold')
call s:Hl('Folded', 'fg2', 'bg1', 'NONE')
call s:Hl('FoldColumn', 'fg3', 'bg0', 'NONE')
call s:Hl('DiffAdd', 'green', 'bg1', 'NONE')
call s:Hl('DiffChange', 'yellow', 'bg1', 'NONE')
call s:Hl('DiffDelete', 'red', 'bg1', 'NONE')
call s:Hl('DiffText', 'blue', 'bg2', 'bold')
call s:Hl('User1', 'yellow', 'bg3', 'bold')
call s:Hl('User2', 'green', 'bg3', 'bold')
call s:Hl('User3', 'blue', 'bg3', 'bold')
call s:Hl('User4', 'purple', 'bg3', 'bold')
call s:Hl('User5', 'cyan', 'bg3', 'bold')
call s:Hl('ModeNormal', 'fg0', 'bg3', 'bold')
call s:Hl('ModeInsert', 'blue', 'bg3', 'bold')
call s:Hl('ModeVisual', 'green', 'bg3', 'bold')
call s:Hl('ModeVLine', 'cyan', 'bg3', 'bold')
call s:Hl('ModeVBlock', 'purple', 'bg3', 'bold')
call s:Hl('ModeReplace', 'red', 'bg3', 'bold')
call s:Hl('ModeCmdline', 'yellow', 'bg3', 'bold')
call s:Hl('ModeTerminal', 'orange', 'bg3', 'bold')
call s:Hl('Comment', 'fg2', '', 'italic')
call s:Hl('Constant', 'yellow', '', 'NONE')
call s:Hl('String', 'green', '', 'NONE')
call s:Hl('Character', 'green', '', 'NONE')
call s:Hl('Number', 'yellow', '', 'NONE')
call s:Hl('Boolean', 'yellow', '', 'NONE')
call s:Hl('Float', 'yellow', '', 'NONE')
call s:Hl('Identifier', 'fg0', '', 'NONE')
call s:Hl('Function', 'blue', '', 'NONE')
call s:Hl('Statement', 'purple', '', 'bold')
call s:Hl('Conditional', 'purple', '', 'bold')
call s:Hl('Repeat', 'purple', '', 'bold')
call s:Hl('Keyword', 'purple', '', 'bold')
call s:Hl('Exception', 'purple', '', 'bold')
call s:Hl('PreProc', 'purple', '', 'NONE')
call s:Hl('Include', 'purple', '', 'NONE')
call s:Hl('Define', 'purple', '', 'NONE')
call s:Hl('Macro', 'orange', '', 'NONE')
call s:Hl('PreCondit', 'purple', '', 'NONE')
call s:Hl('Type', 'yellow', '', 'NONE')
call s:Hl('StorageClass', 'yellow', '', 'NONE')
call s:Hl('Structure', 'yellow', '', 'NONE')
call s:Hl('Typedef', 'yellow', '', 'NONE')
call s:Hl('Special', 'cyan', '', 'NONE')
call s:Hl('SpecialChar', 'cyan', '', 'NONE')
call s:Hl('Tag', 'red', '', 'NONE')
call s:Hl('Delimiter', 'punct', '', 'NONE')
call s:Hl('SpecialComment', 'cyan', '', 'italic')
call s:Hl('Debug', 'red', '', 'NONE')
call s:Hl('Underlined', 'blue', '', 'underline')
call s:Hl('Ignore', 'fg3', '', 'NONE')
call s:Hl('Error', 'red', '', 'bold')
call s:Hl('Todo', 'yellow', '', 'bold,italic')
call s:Hl('DiagnosticError', 'red', '', 'NONE')
call s:Hl('DiagnosticWarn', 'yellow', '', 'NONE')
call s:Hl('DiagnosticInfo', 'blue', '', 'NONE')
call s:Hl('DiagnosticHint', 'cyan', '', 'NONE')
call s:Hl('DiagnosticVirtualTextError', 'red', 'bg1', 'NONE')
call s:Hl('DiagnosticVirtualTextWarn', 'yellow', 'bg1', 'NONE')
call s:Hl('DiagnosticVirtualTextInfo', 'blue', 'bg1', 'NONE')
call s:Hl('DiagnosticVirtualTextHint', 'cyan', 'bg1', 'NONE')
call s:Hl('DiagnosticSignError', 'red', '', 'NONE')
call s:Hl('DiagnosticSignWarn', 'yellow', '', 'NONE')
call s:Hl('DiagnosticSignInfo', 'blue', '', 'NONE')
call s:Hl('DiagnosticSignHint', 'cyan', '', 'NONE')
call s:Hl('LspReferenceText', '', 'bg2', 'NONE')
call s:Hl('LspReferenceRead', '', 'bg2', 'NONE')
call s:Hl('LspReferenceWrite', '', 'bg2', 'underline')
call s:Hl('LspSignatureActiveParameter', 'orange', '', 'bold')
call s:Hl('GitSignsAdd', 'green', '', 'NONE')
call s:Hl('GitSignsChange', 'yellow', '', 'NONE')
call s:Hl('GitSignsDelete', 'red', '', 'NONE')

" undercurl 需要单独指定 sp 颜色
silent! highlight DiagnosticUnderlineError gui=undercurl guisp=#e5748a cterm=underline
silent! highlight DiagnosticUnderlineWarn gui=undercurl guisp=#d6bc84 cterm=underline
silent! highlight DiagnosticUnderlineInfo gui=undercurl guisp=#7fa9de cterm=underline
silent! highlight DiagnosticUnderlineHint gui=undercurl guisp=#82c4d4 cterm=underline

" 内置终端 16 色跟随主题
let g:terminal_color_0 = '#3e3e4c'
let g:terminal_color_1 = '#e5748a'
let g:terminal_color_2 = '#82c79a'
let g:terminal_color_3 = '#d6bc84'
let g:terminal_color_4 = '#7fa9de'
let g:terminal_color_5 = '#b39fe0'
let g:terminal_color_6 = '#82c4d4'
let g:terminal_color_7 = '#d4d4dc'
let g:terminal_color_8 = '#454552'
let g:terminal_color_9 = '#e5748a'
let g:terminal_color_10 = '#82c79a'
let g:terminal_color_11 = '#d6bc84'
let g:terminal_color_12 = '#7fa9de'
let g:terminal_color_13 = '#b39fe0'
let g:terminal_color_14 = '#82c4d4'
let g:terminal_color_15 = '#ffffff'

" ---------- 模式指示器函数（根据 mode() 返回文字） ----------
function! StatuslineMode()
    let m = mode()
    if m == 'n'
        return '%#ModeNormal# [-]%*'
    elseif m == 'i'
        return '%#ModeInsert# [I]%*'
    elseif m == 'v'
        return '%#ModeVisual# [v]%*'
    elseif m == 'V'
        return '%#ModeVLine# [V]%*'
    elseif m == "\<C-v>"
        return '%#ModeVBlock# [B]%*'
    elseif m == 'R'
        return '%#ModeReplace# [R]%*'
    elseif m == 'c'
        return '%#ModeCmdline# [C]%*'
    elseif m == 't'
        return '%#ModeTerminal# [T]%*'
    else
        return ''
    endif
endfunction

" ---------- 状态栏内容 ----------
let &statusline = ''
let &statusline .= '%{%StatuslineMode()%} '   " 模式指示器
let &statusline .= '%f%m%r%h%w%*'             " 文件名、修改标志、只读等
let &statusline .= '%='                       " 右对齐
let &statusline .= '%2* [%Y]%*'               " 文件类型
let &statusline .= '%3* [%{&ff}] [%{&fenc!=''''?&fenc:&enc}]%*'  " 格式 & 编码
let &statusline .= '%4* [%l,%v] [%p%%]%*'    " 行、列、百分比
let &statusline .= '%5* %{strftime(''%H:%M'')}%* '  " 当前时间

" ============================================================
" 4. 编码与文件
" ============================================================
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,cp936,gb2312,gb18030,ucs-bom
set fileformats=unix,dos,mac

" 备份和交换文件
set backup
set swapfile
set writebackup
set autoread
set confirm
set hidden
set history=2000
set undolevels=1000
set undofile
set updatetime=250
set splitright
set splitbelow

" 自动创建目录
if !isdirectory(expand('~/.vim/undodir'))
    call mkdir(expand('~/.vim/undodir'), 'p')
endif
if !isdirectory(expand('~/.vim/backupdir'))
    call mkdir(expand('~/.vim/backupdir'), 'p')
endif
if !isdirectory(expand('~/.vim/swapdir'))
    call mkdir(expand('~/.vim/swapdir'), 'p')
endif

" 结尾的 // 让不同目录下的同名文件不会互相覆盖
set undodir=~/.vim/undodir//
set backupdir=~/.vim/backupdir//
set directory=~/.vim/swapdir//

" ============================================================
" 5. 缩进与格式
" ============================================================
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
" C 系文件由自带 indent/c.vim 设置 cindent；不要全局打开
set shiftround
set infercase
set formatoptions+=mB
set textwidth=0                " 禁止自动换行
set nowrap
set nolinebreak
set showbreak=

" 文档格式：软换行、词边界换行、不显示折行提示符
" 其他格式：不折行、显示 ↪
let s:text_fts = ['markdown', 'text', 'org', 'gitcommit', 'rst', 'asciidoc', 'tex']

function! s:SetWrapOptions() abort
    " F7 手动切过 wrap 后，不再被文件类型规则覆盖
    if get(b:, 'vimore_wrap_override', 0)
        return
    endif
    if index(s:text_fts, &filetype) >= 0
        setlocal wrap linebreak breakindent showbreak=
        setlocal colorcolumn=
    else
        setlocal nowrap nolinebreak nobreakindent showbreak=↪
    endif
endfunction

augroup VimoreWrap
    autocmd!
    autocmd FileType,BufEnter,WinEnter * call s:SetWrapOptions()
augroup END

" 各文件类型自定义缩进
augroup VimoreIndent
    autocmd!
    autocmd FileType python,sh setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
    autocmd FileType javascript,typescript,html,css,json,yaml,markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType c,cpp,java,rust setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup END

" ============================================================
" 6. 搜索与替换
" ============================================================
set hlsearch                  " 高亮搜索结果
set incsearch                 " 增量搜索
set ignorecase                " 忽略大小写
set smartcase                 " 智能大小写（有大写则区分）
set magic                     " 使用正则表达式
set wrapscan                  " 搜索到文件尾后从开头继续
set gdefault                  " 默认全局替换

" ============================================================
" 7. 编辑行为
" ============================================================
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,b,s
set scrolloff=5
set sidescrolloff=8
set sidescroll=10
set virtualedit=block
set selection=inclusive " 光标下字符也选中
"set selectmode=mouse,key
set mouse=a
set mousemodel=popup
set ttymouse=sgr
set keymodel=startsel,stopsel

" 插入模式下设置为闪烁竖线 (solid vertical bar)
let &t_SI = "\<Esc>[5 q"
" 正常模式下设置为闪烁方块 (solid block)
let &t_EI = "\<Esc>[1 q"
" t_vi / t_ve 是 terminfo 的「光标可见/不可见」，不是可视模式钩子；
" t_SS / t_SE 在 Vim 里也不存在。可视模式的光标形状只能用 ModeChanged 切。
let s:vis_char = nr2char(22)
execute 'augroup VimoreCursor'
execute 'autocmd!'
execute 'autocmd ModeChanged *:[' . s:vis_char . 'vV]* silent !echo -ne "\e[2 q"'
execute 'autocmd ModeChanged [' . s:vis_char . 'vV]*:* silent !echo -ne "\e[1 q"'
execute 'augroup END'
set timeoutlen=300   " 缩短普通映射超时（单位毫秒）
set ttimeoutlen=50   " 缩短按键码（如功能键、方向键）超时

function! SaveAndClear() abort
    if &buftype != '' || expand('%') == ''
        echo 'vimore: Current buffer has no file name'
        return
    endif
    try
        silent write
    catch
        echo 'vimore: Save failed: ' . v:exception
        return
    endtry
    call timer_start(2000, {-> execute('echo ""')})
endfunction

" 不阻塞地把命令放到临时终端里执行
function! s:RunInTerminal(cmd, dir) abort
    let l:win = winnr()
    botright new
    try
        let l:buf = term_start(['sh', '-c', a:cmd], {
                    \ 'cwd': a:dir,
                    \ 'curwin': 1,
                    \ 'term_finish': 'close',
                    \ })
    catch
        close
        echo 'vimore: Failed to start terminal: ' . v:exception
        return -1
    endtry
    execute 'resize ' . max([5, &lines / 3])
    setlocal nonumber norelativenumber signcolumn=no
    startinsert
    return l:buf
endfunction

" ============================================================
" 8. 括号/引号智能补全
" ============================================================
" 补全左括号光标后无字符或紧挨右括号时智能处理）
inoremap <silent> ( <C-r>=SmartPair('(', ')')<CR>
inoremap <silent> [ <C-r>=SmartPair('[', ']')<CR>
inoremap <silent> { <C-r>=SmartCondition('{')<CR>

" 特殊映射
function! SmartCondition(char)
    if a:char == '{'
        " 花括号：C/C++/CSS 中不补全
        if &filetype =~? 'c\|cpp\|css'
            return '{'
        else
            return SmartPair('{', '}')
        endif
    elseif a:char == '<'
        " 小于号：仅在 HTML/XML 中补全
        if &filetype =~? 'xml\|html\|xhtml'
            return SmartPair('<', '>')
        else
            return '<'
        endif
    elseif a:char == '"'
        " 双引号：在 vimrc 中不补全
        if &filetype == 'vim'
            return '"'
        else
            return SmartQuote('"')
        endif
    " 可继续添加其他字符规则（如 '[' 等）
    else
        return a:char
    endif
endfunction
" 应用特殊映射
inoremap <silent> { <C-r>=SmartCondition('{')<CR>
inoremap <silent> < <C-r>=SmartCondition('<')<CR>
inoremap <silent> " <C-r>=SmartCondition('"')<CR>

"inoremap <silent> ' <C-r>=SmartQuote("'")<CR>

function! SmartPair(left, right)
    let line = getline('.')
    let col = col('.') - 1

    " 如果光标前是反斜杠，直接插入左括号，不补全
    if col > 0 && line[col-1] == '\'
        return a:left
    endif

    " 原有逻辑（保持不变）
    if col >= len(line) || line[col] =~ '\s'
        return a:left . a:right . "\<Left>"
    endif
    let next = line[col]
    if next =~ '[])}>"]' || next == "'"
        return a:left . a:right . "\<Left>"
    endif
    return a:left
endfunction

" 引号补全（支持字符串内智能关闭）
function! SmartQuote(quote)
    let line = getline('.')
    let col = col('.') - 1

    " 1. 如果光标前是反斜杠，直接插入，不补全（转义场景）
    if col > 0 && line[col-1] == '\'
        return a:quote
    endif

    " 2. 如果光标后已有同款引号，跳过（充当右引号）
    if col < len(line) && line[col] == a:quote
        return "\<Right>"
    endif

    " 3. 如果光标后是异类引号或右括号，补全一对（嵌套）
    if col < len(line) && (line[col] =~ '[])}>"]' || line[col] == "'")
        return a:quote . a:quote . "\<Left>"
    endif

    " 4. 如果光标后是非空白字符，只插入左引号（续写）
    if col < len(line) && line[col] !~ '\s'
        return a:quote
    endif

    " 5. 行尾或空白：统计未被转义的该引号个数
    let before = line[:col-1]
    let quote_count = 0
    let i = 0
    while i < len(before)
        if before[i] == a:quote
            " 如果前一个字符不是反斜杠，则计数（忽略转义）
            if i == 0 || before[i-1] != '\'
                let quote_count += 1
            endif
        endif
        let i += 1
    endwhile

    " 奇数 → 补全右引号（关闭），偶数 → 补全一对
    if quote_count % 2 == 1
        return a:quote
    else
        return a:quote . a:quote . "\<Left>"
    endif
endfunction

" 右括号智能跳出
inoremap <silent> ) <C-r>=SmartClose(')')<CR>
inoremap <silent> ] <C-r>=SmartClose(']')<CR>
inoremap <silent> } <C-r>=SmartClose('}')<CR>
inoremap <silent> > <C-r>=SmartClose('>')<CR>
"inoremap <silent> " <C-r>=SmartCloseQuote('"')<CR>
"inoremap <silent> ' <C-r>=SmartCloseQuote("'")<CR>

function! SmartClose(char)
    let line = getline('.')
    let col = col('.') - 1
    if col < len(line) && line[col] == a:char
        return "\<Right>"
    endif
    return a:char
endfunction

" 智能退格：成对删除括号/引号
inoremap <silent> <BS> <C-r>=SmartBackspace()<CR>

function! SmartBackspace()
    let line = getline('.')
    let col = col('.') - 1

    if col <= 0
        return "\<BS>"
    endif

    let char_before = line[col - 1]
    let char_after = col < len(line) ? line[col] : ''

    " 删除成对引号 "" 或 ''
    if (char_before == '"' && char_after == '"') ||
                \ (char_before == "'" && char_after == "'")
        let before_prev = col > 1 ? line[col - 2] : ''
        let after_next = col + 1 < len(line) ? line[col + 1] : ''
        if before_prev != char_before && after_next != char_after
            return "\<BS>\<Del>"
        endif
    endif

    " 删除成对括号 () [] {}
    let pairs = {'(' : ')', '[' : ']', '{' : '}', '<' : '>'}
    if has_key(pairs, char_before) && char_after == pairs[char_before]
        let before_prev = col > 1 ? line[col - 2] : ''
        let after_next = col + 1 < len(line) ? line[col + 1] : ''
        if before_prev != char_before || after_next != char_after
            return "\<BS>\<Del>"
        endif
    endif

    " 嵌套括号 ((|)) → 删除内层一对
    if col >= 2 && col + 2 <= len(line)
        let before2 = line[col - 2]
        let after2 = line[col + 1]
        if before2 == '(' && after2 == ')' &&
                    \ char_before == '(' && char_after == ')'
            return "\<BS>\<Del>"
        endif
    endif

    return "\<BS>"
endfunction

" ============================================================
" 9. 复制粘贴 (手动切换内置/系统寄存器)
" ============================================================
" Wayland 剪贴板桥接：Vim 内置的 "+ 寄存器只走 X11/XWayland，
" 在 Sway/Wayland 下不会落到系统剪切板，这里显式调用 wl-copy/wl-paste。
function! WlClipboardYank(reg) abort
    if a:reg ==# '+' && executable('wl-copy')
        call system('wl-copy', getreg('+'))
    endif
endfunction

function! WlClipboardPaste() abort
    if executable('wl-paste')
        " 不用 -n：保留结尾换行，setreg() 才会识别为行wise 选区
        let l:text = system('wl-paste')
        " 只有真的读到内容才覆盖，避免把本来可用的 "+ 寄存器清空
        if v:shell_error == 0 && !empty(l:text)
            call setreg('+', l:text)
        endif
    endif
endfunction

if executable('wl-copy')
    augroup VimoreWaylandClipboard
        autocmd!
        autocmd TextYankPost * call WlClipboardYank(v:event.regname)
    augroup END
endif

" 复制到系统剪切板：<Leader>y
nnoremap <Leader>y "+yy
vnoremap <Leader>y "+y

" 从系统剪切板粘贴：<Leader>p / <Leader>P
nnoremap <Leader>p :<C-u>call WlClipboardPaste()<CR>"+p
nnoremap <Leader>P :<C-u>call WlClipboardPaste()<CR>"+P
vnoremap <Leader>p :<C-u>call WlClipboardPaste()<CR>gv"+p
vnoremap <Leader>P :<C-u>call WlClipboardPaste()<CR>gv"+P

" 直接按 "+p / "+P 也先回读系统剪切板
nnoremap <silent> "+p :<C-u>call WlClipboardPaste()<CR>"+p
nnoremap <silent> "+P :<C-u>call WlClipboardPaste()<CR>"+P
vnoremap <silent> "+p :<C-u>call WlClipboardPaste()<CR>gv"+p
vnoremap <silent> "+P :<C-u>call WlClipboardPaste()<CR>gv"+P

" 粘贴模式开关：插入模式靠 pastetoggle（paste 打开时映射不生效），
" 普通模式补一个映射，两边都能按 F2
set pastetoggle=<F2>
nnoremap <silent> <F2> :set paste! <Bar> echo 'paste = ' . &paste<CR>

" ============================================================
" 10. 快速注释
" ============================================================
let g:comment_map = {
            \ 'python': '# ', 'sh': '# ', 'bash': '# ', 'zsh': '# ',
            \ 'lua': '-- ', 'sql': '-- ',
            \ 'c': '// ', 'cpp': '// ', 'java': '// ', 'javascript': '// ',
            \ 'typescript': '// ', 'go': '// ', 'rust': '// ', 'csharp': '// ',
            \ 'php': '// ', 'json': '// ', 'scss': '// ',
            \ 'vim': '" ', 'vimrc': '" ',
            \ 'html': '<!-- ', 'markdown': '<!-- ',
            \ 'css': '/* ',
            \ 'yaml': '# ', 'yml': '# ', 'ruby': '# ', 'perl': '# ',
            \ 'tex': '% ',
            \ }

function! GetCommentStr()
    return get(g:comment_map, &filetype, '# ')
endfunction

function! GetCommentEndStr()
    let ft = &filetype
    if ft == 'html' || ft == 'markdown'
        return ' -->'
    elseif ft == 'css'
        return ' */'
    endif
    return ''
endfunction

function! ToggleComment()
    let line = getline('.')
    let comment = GetCommentStr()
    let comment_end = GetCommentEndStr()
    let comment_symbol = substitute(comment, '\s\+$', '', '')
    let trimmed = substitute(line, '^\s*', '', '')

    if trimmed =~ '^' . escape(comment_symbol, '.*^$[]')
        " 取消注释
        if comment_end != ''
            let line = substitute(line, '\(\s*\)' . escape(comment_symbol, '.*^$[]') . '\s*\(.*\)' . escape(comment_end, '.*^$[]'), '\1\2', '')
        else
            let line = substitute(line, '\(\s*\)' . escape(comment_symbol, '.*^$[]') . '\s*', '\1', '')
        endif
        call setline('.', line)
    else
        " 添加注释
        if comment_end != ''
            let line = substitute(line, '^\(\s*\)\(.*\)$', '\1' . comment . '\2' . comment_end, '')
        else
            let line = substitute(line, '^\(\s*\)\(.*\)$', '\1' . comment . '\2', '')
        endif
        call setline('.', line)
    endif
endfunction

function! ToggleCommentVisual()
    let comment = GetCommentStr()
    let comment_end = GetCommentEndStr()
    let comment_symbol = substitute(comment, '\s\+$', '', '')
    let symbol_re = escape(comment_symbol, '.*^$[]')
    let end_re = escape(comment_end, '.*^$[]')

    let start_line = line("'<")
    let end_line = line("'>")
    if start_line > end_line
        let [start_line, end_line] = [end_line, start_line]
    endif
    if start_line < 1
        return
    endif

    " 有一行没注释 -> 全部加注释；全都注释了 -> 全部去掉注释
    let all_commented = 1
    for l in range(start_line, end_line)
        let trimmed = substitute(getline(l), '^\s*', '', '')
        if trimmed == ''
            continue    " 空行跳过
        endif
        if trimmed !~ '^' . symbol_re
            let all_commented = 0
            break
        endif
    endfor

    for l in range(start_line, end_line)
        let line = getline(l)
        let indent = matchstr(line, '^\s*')
        let body = strpart(line, strlen(indent))

        if all_commented
            " 取消注释
            if comment_end != ''
                let body = substitute(body, '^' . symbol_re . '\s*\(.\{-}\)' . end_re . '$', '\1', '')
            else
                let body = substitute(body, '^' . symbol_re . '\s*', '', '')
            endif
        else
            " 加注释，但空行跳过
            if body == ''
                continue
            endif
            let body = comment . body
            if comment_end != ''
                let body = body . comment_end
            endif
        endif

        call setline(l, indent . body)
    endfor
endfunction

function! ToggleCommentSmart()
    if exists('g:vimore_from_visual') && g:vimore_from_visual
        call ToggleCommentVisual()
    else
        call ToggleComment()
    endif
endfunction

" ============================================================
" 11. 终端集成
" ============================================================
" 终端退出
tnoremap <Esc><Esc> <C-\><C-n>
" tnoremap <C-c> <C-\><C-n>

" 强制透传 Ctrl-C
tnoremap <C-c> <Cmd>call term_sendkeys(bufnr('%'), nr2char(3))<CR>

" 窗口切换
tnoremap <C-S-h> <C-w>h
tnoremap <C-S-j> <C-w>j
tnoremap <C-S-k> <C-w>k
tnoremap <C-S-l> <C-w>l

" 终端复制（退出终端模式后复制到系统剪切板）
tnoremap <C-S-c> <C-\><C-n>"+yy
tnoremap <C-S-v> <C-\><C-n>"+pi

function! OpenTerminal(direction)
    if a:direction == 'horizontal'
        botright terminal
        execute 'resize ' . max([5, &lines / 3])
    else
        vertical botright terminal
        execute 'vertical resize ' . max([10, &columns / 3])
    endif
    startinsert
endfunction

function! GetRunCommand() abort
    if expand('%') == ''
        return ''
    endif
    let ft = &filetype
    let file = shellescape(expand('%:p'))
    let out = shellescape(expand('%:p:r'))
    if ft == 'python'
        return 'python3 ' . file
    elseif ft == 'go'
        return 'go run ' . file
    elseif ft == 'c'
        return 'gcc ' . file . ' -o ' . out . ' && ' . out
    elseif ft == 'cpp'
        return 'g++ ' . file . ' -o ' . out . ' && ' . out
    elseif ft == 'javascript'
        return 'node ' . file
    elseif ft == 'sh' || ft == 'bash'
        return 'bash ' . file
    elseif ft == 'lua'
        return 'lua ' . file
    elseif ft == 'rust'
        return 'cd ' . shellescape(expand('%:p:h')) . ' && cargo run'
    else
        return ''
    endif
endfunction

augroup VimoreTerminal
    autocmd!
    autocmd TerminalOpen * setlocal nonumber norelativenumber signcolumn=no
augroup END

" 找到最新的终端 buffer
function! s:FindLatestTerminal()
    let term_bufs = []
    for buf in range(1, bufnr('$'))
        if getbufvar(buf, '&buftype') == 'terminal'
            call add(term_bufs, buf)
        endif
    endfor
    if empty(term_bufs)
        return -1
    endif
    " bufnr 越大说明越新
    return max(term_bufs)
endfunction

" 在最新终端里运行当前文件
function! RunInLatestTerminal() abort
    let cmd = GetRunCommand()
    if cmd == ''
        echo 'vimore: Unsupported filetype: ' . &filetype
        return
    endif
    try
        silent write
    catch
        echo 'vimore: Save failed: ' . v:exception
        return
    endtry

    let term_buf = s:FindLatestTerminal()

    if term_buf == -1
        botright terminal
        execute 'resize ' . max([5, &lines / 3])
        let term_buf = bufnr('%')
    else
        let win = bufwinnr(term_buf)
        if win == -1
            execute 'botright sbuffer ' . term_buf
            execute 'resize ' . max([5, &lines / 3])
        else
            execute win . 'wincmd w'
        endif
    endif

    call term_sendkeys(term_buf, cmd . "\r")
    startinsert
endfunction

function! ToggleTerminal() abort
    let term_buf = s:FindLatestTerminal()

    if term_buf == -1
        botright terminal
        execute 'resize ' . max([5, &lines / 3])
        startinsert
    else
        let win = bufwinnr(term_buf)
        if win == -1
            execute 'botright sbuffer ' . term_buf
            execute 'resize ' . max([5, &lines / 3])
            startinsert
        else
            execute win . 'wincmd c'
        endif
    endif
endfunction

" ============================================================
" 12. 补全
" ============================================================
set completeopt=menuone,noinsert,noselect,preview
set complete=.,w,b,u,t,i,k
set wildmenu
set wildmode=full
set wildignorecase
set wildignore+=*.pyc,*.pyo,*.swp,*.swo,*.so,*.dll,*.exe
set wildignore+=*.jpg,*.png,*.gif,*.bmp,*.ico
set wildignore+=*.zip,*.tar,*.gz,*.bz2
set wildignore+=node_modules,__pycache__,*.git,*.svn
set wildignore+=*.o,*.a,*.obj,*.class

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" <CR> 智能拆分
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : SmartEnter()

function! s:IndentStep() abort
    let sw = max([&shiftwidth, 1])
    return &expandtab ? repeat(' ', sw) : "\t"
endfunction

" 光标停在容器右括号上，左侧有同类左括号和内容时返回 [左括号下标, 内容]
function! s:ContainerAtEnd(line, col) abort
    let close_char = a:line[a:col]
    if close_char ==# ''
        return []
    endif
    let open_char = get({'}': '{', ')': '(', ']': '['}, close_char, '')
    if open_char ==# ''
        return []
    endif

    let depth = 1
    let open_pos = -1
    for i in range(a:col - 1, 0, -1)
        let ch = a:line[i]
        if ch ==# close_char
            let depth += 1
        elseif ch ==# open_char
            let depth -= 1
            if depth == 0
                let open_pos = i
                break
            endif
        endif
    endfor

    if open_pos < 0 || open_pos >= a:col
        return []
    endif
    let inner = strpart(a:line, open_pos + 1, a:col - open_pos - 1)
    if inner =~# '^\s*$'
        return []
    endif
    " 右括号后面只能有空白，确保是在容器末尾
    if strpart(a:line, a:col + 1) !~# '^\s*$'
        return []
    endif
    return [open_pos, inner]
endfunction

" expr 映射求值期间有 textlock，不能直接改 buffer；用 timer 延后执行。
" 返回 <Ignore> 保持插入模式，避免 <C-o> 短暂进 normal 造成状态闪动。
function! SmartEnter()
    let line = getline('.')
    let col = col('.') - 1

    if col > 0 && col < len(line)
        let before = line[col - 1]
        let after = line[col]
        let pairs = {'{': '}', '(': ')', '[': ']'}
        if has_key(pairs, before) && after == pairs[before]
            call timer_start(0, function('SplitPair'))
            return "\<Ignore>"
        endif
    endif

    if !empty(s:ContainerAtEnd(line, col))
        call timer_start(0, function('SplitContainerEnd'))
        return "\<Ignore>"
    endif

    return "\<CR>"
endfunction

function! SplitPair() abort
    let lnum = line('.')
    let line = getline(lnum)
    let col = col('.') - 1
    if col <= 0
        return
    endif

    let indent = matchstr(line, '^\s*')
    " Go 等 noexpandtab 文件里内层缩进应该用 Tab，不能混进空格
    let inner = indent . s:IndentStep()

    let line1 = line[:col-1]
    let line2 = inner
    let line3 = indent . line[col:]

    call setline(lnum, line1)
    call append(lnum, line2)
    call append(lnum + 1, line3)

    call cursor(lnum + 1, len(line2) + 1)
endfunction

" 容器末尾回车：右括号挪到下一行，内容单独占一行
function! SplitContainerEnd() abort
    let lnum = line('.')
    let line = getline(lnum)
    let col = col('.') - 1
    let found = s:ContainerAtEnd(line, col)
    if empty(found)
        return 0
    endif

    let inner = substitute(found[1], '^\s*\(.\{-}\)\s*$', '\1', '')
    let indent = matchstr(line, '^\s*')
    let middle = indent . s:IndentStep() . inner
    let last = indent . strpart(line, col)

    call setline(lnum, strpart(line, 0, found[0] + 1))
    call append(lnum, middle)
    call append(lnum + 1, last)
    call cursor(lnum + 1, len(middle) + 1)
    return 1
endfunction

" 各语言补全函数
let g:omni_func_map = {
            \ 'python': 'python3complete#Complete',
            \ 'javascript': 'javascriptcomplete#CompleteJS',
            \ 'html': 'htmlcomplete#CompleteTags',
            \ 'css': 'csscomplete#CompleteCSS',
            \ 'c': 'ccomplete#Complete',
            \ 'cpp': 'cppcomplete#Complete',
            \ 'go': 'go#complete#Complete',
            \ 'ruby': 'rubycomplete#Complete',
            \ 'perl': 'perlcomplete#Complete',
            \ 'php': 'phpcomplete#Complete',
            \ 'xml': 'xmlcomplete#CompleteTags'
            \ }

function! SetOmniFunc() abort
    let ft = &filetype
    if has_key(g:omni_func_map, ft)
        execute 'setlocal omnifunc=' . g:omni_func_map[ft]
    else
        setlocal omnifunc=syntaxcomplete#Complete
    endif
endfunction

augroup VimoreOmni
    autocmd!
    autocmd FileType * call SetOmniFunc()
augroup END

" ============================================================
" 13. 代码折叠
" ============================================================
set foldmethod=indent
set foldlevel=99
set foldenable
set foldnestmax=5
set foldminlines=2
set foldtext=MyFoldText()

function! MyFoldText()
    let line = getline(v:foldstart)
    let n = v:foldend - v:foldstart + 1
    return "+ " . line . " ... " . n . " lines"
endfunction

" ============================================================
" 14. 行尾空格显示与清理
" ============================================================

function! StripTrailingWhitespace() abort
    if get(g:, 'vimore_strip_whitespace', 1) == 0
        return
    endif
    if &buftype != '' || !&modifiable || &filetype == 'markdown'
        return
    endif
    let view = winsaveview()
    silent! keeppatterns %s/\s\+$//e
    call winrestview(view)
endfunction

function! StripTrailingWhitespaceManual() abort
    let view = winsaveview()
    silent! keeppatterns %s/\s\+$//e
    call winrestview(view)
    echo 'vimore: Trailing whitespace cleaned'
    call timer_start(2000, {-> execute('echo ""')})
endfunction

" 行尾空格显示成淡灰的 ·；tab / 行尾 / 折行标记设成空格等于关掉，
" 避免满屏 ^I 和 $。只在可编辑的普通文件里开 list。
set list
set listchars=trail:·,tab:\ \ ,eol:\ ,extends:\ ,precedes:\ ,nbsp:\

function! s:EnsureTrailingList() abort
    let enabled = get(g:, 'vimore_show_extra_whitespace', 1)
                \ && &buftype == '' && &modifiable
    setlocal nolist
    if enabled
        setlocal list
    endif
endfunction

augroup VimoreWhitespace
    autocmd!
    autocmd BufWinEnter,WinEnter,TerminalOpen * call s:EnsureTrailingList()
    autocmd BufWritePre * call StripTrailingWhitespace()
augroup END
call s:EnsureTrailingList()

" ============================================================
" 15. 边界线
" ============================================================
if exists('+colorcolumn')
    set colorcolumn=120
endif

" ============================================================
" 16. 普通快捷键（无 leader）
" ============================================================
" 保存
nnoremap <silent> <C-s> <Cmd>call SaveAndClear()<CR>
inoremap <silent> <C-s> <C-o>:call SaveAndClear()<CR>

" 窗口切换
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 标签页切换（<C-t> 保持 Vim 默认的标签栈跳转）
nnoremap <silent> <A-Left> <Cmd>tabprevious<CR>
nnoremap <silent> <A-Right> <Cmd>tabnext<CR>

" 全选复制
vnoremap <C-x> "+x

" ============================================================
" 17. F 键快捷键
" ============================================================
" F1 - 帮助
" F2 - 粘贴模式总开关
nnoremap <silent> <F3> <Cmd>Explore<CR>
                            " 文件浏览器
nnoremap <silent> <F4> <Cmd>Vexplore<CR>
                            " 垂直浏览器
nnoremap <silent> <F5> <Cmd>call RunInLatestTerminal()<CR>
                            " 运行代码
nnoremap <silent> <F6> <Cmd>call DebugCode()<CR>
                            " 调试代码
nnoremap <silent> <F7> <Cmd>call ToggleWrap()<CR>
                            " 切换自动换行
nnoremap <silent> <F8> <Cmd>call CheckCode()<CR>
                            " 代码检查
nnoremap <silent> <F9> gg=G
                            " 基础格式化
nnoremap <silent> <F10> <Cmd>call FormatCode()<CR>
                            " 自动格式化

function! ToggleWrap() abort
    let b:vimore_wrap_override = 1
    setlocal wrap!
    if &l:wrap
        setlocal linebreak showbreak=↪
    else
        setlocal nolinebreak showbreak=
    endif
    echo 'wrap = ' . &l:wrap
endfunction

" ============================================================
" 18. 运行、调试、格式化、检查函数
" ============================================================
" ---------- 公共小工具 ----------
function! s:SaveFile() abort
    if &buftype != '' || expand('%') == ''
        echo 'vimore: Current buffer has no file name'
        return 0
    endif
    try
        silent write
    catch
        echo 'vimore: Save failed: ' . v:exception
        return 0
    endtry
    return 1
endfunction

function! s:CollectOutput(output, channel, msg) abort
    call add(a:output, a:msg)
endfunction

" ---------- 调试 ----------
func! DebugCode() abort
    if !s:SaveFile()
        return
    endif

    let ft = &filetype
    let file = expand('%:p')
    let dir = expand('%:p:h')
    let out = expand('%:p:r')

    if ft == 'python'
        let cmd = 'python3 -m pdb ' . shellescape(file)
    elseif ft == 'c' || ft == 'cpp'
        let cc = ft == 'c' ? 'gcc' : 'g++'
        let cmd = cc . ' ' . shellescape(file) . ' -g -o ' . shellescape(out) . ' && gdb ' . shellescape(out)
    elseif ft == 'go'
        " dlv debug 调试当前目录的 package，不接受单个 .go 文件
        let cmd = 'dlv debug'
    else
        echo 'vimore: Debugging not supported for filetype: ' . ft
        return
    endif

    call s:RunInTerminal(cmd, dir)
endfunc

" ---------- 格式化 ----------
function! s:FormatCandidates(ft, file) abort
    let list = []
    let tmp = shellescape(expand('%:p') . '.vimore.tmp')

    if a:ft == 'python'
        if executable('black')
            call add(list, ['black', 'black --skip-string-normalization ' . a:file])
        endif
        if executable('ruff')
            call add(list, ['ruff', 'ruff format ' . a:file])
        endif
        if executable('autopep8')
            call add(list, ['autopep8', 'autopep8 -i --aggressive --max-line-length=120 ' . a:file])
        endif
    elseif a:ft == 'go'
        if executable('gofmt')
            call add(list, ['gofmt', 'gofmt -w ' . a:file])
        endif
        if executable('goimports')
            call add(list, ['goimports', 'goimports -w ' . a:file])
        endif
    elseif a:ft == 'rust'
        if executable('rustfmt')
            call add(list, ['rustfmt', 'rustfmt ' . a:file])
        endif
        if executable('cargo')
            call add(list, ['cargo', 'cargo fmt'])
        endif
    elseif a:ft == 'lua'
        if executable('stylua')
            call add(list, ['stylua', 'stylua ' . a:file])
        endif
    elseif a:ft =~? '^javascript\|^typescript'
        if executable('prettier')
            call add(list, ['prettier', 'prettier --write ' . a:file])
        endif
        if executable('eslint')
            call add(list, ['eslint', 'eslint --fix ' . a:file])
        endif
    elseif a:ft =~? '^json'
        if executable('prettier')
            call add(list, ['prettier', 'prettier --write ' . a:file])
        endif
        if executable('jq')
            call add(list, ['jq', 'jq . ' . a:file . ' > ' . tmp . ' && mv ' . tmp . ' ' . a:file])
        endif
        if executable('python3')
            call add(list, ['python3', 'python3 -m json.tool ' . a:file . ' > ' . tmp . ' && mv ' . tmp . ' ' . a:file])
        endif
    elseif a:ft == 'yaml' || a:ft == 'yml'
        if executable('prettier')
            call add(list, ['prettier', 'prettier --write ' . a:file])
        endif
        if executable('yq')
            call add(list, ['yq', 'yq -i ''.style = ""'' ' . a:file])
        endif
    elseif a:ft == 'markdown'
        if executable('prettier')
            call add(list, ['prettier', 'prettier --write ' . a:file])
        endif
        if executable('mdformat')
            call add(list, ['mdformat', 'mdformat ' . a:file])
        endif
    elseif a:ft =~? '^html\|^css\|^scss\|^less'
        if executable('prettier')
            call add(list, ['prettier', 'prettier --write ' . a:file])
        endif
    elseif a:ft =~? '^c$\|^cpp$\|^cuda$'
        if executable('clang-format')
            call add(list, ['clang-format', 'clang-format -i ' . a:file])
        endif
    elseif a:ft == 'java'
        if executable('google-java-format')
            call add(list, ['google-java-format', 'google-java-format -i ' . a:file])
        endif
        if executable('astyle')
            call add(list, ['astyle', 'astyle --style=java --suffix=none ' . a:file])
        endif
    elseif a:ft =~? '^sh$\|^bash$'
        if executable('shfmt')
            call add(list, ['shfmt', 'shfmt -w ' . a:file])
        endif
    elseif a:ft == 'toml'
        if executable('taplo')
            call add(list, ['taplo', 'taplo format ' . a:file])
        endif
    elseif a:ft == 'xml'
        if executable('xmllint')
            call add(list, ['xmllint', 'xmllint --format ' . a:file . ' -o ' . a:file])
        endif
    elseif a:ft == 'sql'
        if executable('sqlfluff')
            call add(list, ['sqlfluff', 'sqlfluff fix ' . a:file])
        endif
        if executable('sqlformat')
            call add(list, ['sqlformat', 'sqlformat -r -k upper -i indent ' . a:file . ' -o ' . a:file])
        endif
    elseif a:ft == 'ruby'
        if executable('rubocop')
            call add(list, ['rubocop', 'rubocop -a ' . a:file])
        endif
    elseif a:ft == 'php'
        if executable('php-cs-fixer')
            call add(list, ['php-cs-fixer', 'php-cs-fixer fix ' . a:file])
        endif
        if executable('pint')
            call add(list, ['pint', 'pint ' . a:file])
        endif
    elseif a:ft == 'zig'
        if executable('zig')
            call add(list, ['zig', 'zig fmt ' . a:file])
        endif
    elseif a:ft == 'nix'
        if executable('alejandra')
            call add(list, ['alejandra', 'alejandra ' . a:file])
        endif
        if executable('nixpkgs-fmt')
            call add(list, ['nixpkgs-fmt', 'nixpkgs-fmt ' . a:file])
        endif
    elseif a:ft == 'cmake'
        if executable('cmake-format')
            call add(list, ['cmake-format', 'cmake-format -i ' . a:file])
        endif
    endif

    return list
endfunction

function! s:FormatDone(bufnr, view, output, job, status) abort
    if !bufexists(a:bufnr)
        return
    endif

    " 外部工具直接改磁盘文件，重新读一次；窗口不在当前标签页时也不打扰用户
    let winid = bufwinid(a:bufnr)
    if winid != -1
        " 强制重读：checktime 依赖 mtime，粗粒度文件系统上会漏掉重写
        call win_execute(winid, 'if !&modified | silent! edit! | endif')
        call win_execute(winid, 'call winrestview(' . string(a:view) . ')')
    endif

    let text = trim(join(a:output, ''))
    if a:status != 0
        echo 'vimore: Formatting failed: ' . (empty(text) ? 'exit ' . a:status : text)
    elseif !empty(text)
        echo 'vimore: ' . text
    else
        echo 'vimore: Formatting complete'
    endif
endfunction

func! FormatCode() abort
    if !s:SaveFile()
        return
    endif

    let view = winsaveview()
    let bufnr = bufnr('%')
    let file = shellescape(expand('%:p'))
    let candidates = s:FormatCandidates(&filetype, file)
    let cmd = ''

    for [exe, c] in candidates
        if executable(exe)
            let cmd = c
            break
        endif
    endfor

    if cmd == ''
        silent! normal! gg=G
        call winrestview(view)
        echo 'vimore: No external formatter found; did basic indent with gg=G'
        return
    endif

    let output = []
    let job = job_start(['sh', '-c', cmd], {
                \ 'cwd': expand('%:p:h'),
                \ 'out_cb': function('s:CollectOutput', [output]),
                \ 'err_cb': function('s:CollectOutput', [output]),
                \ 'exit_cb': function('s:FormatDone', [bufnr, view, output]),
                \ })
    if job_status(job) ==# 'fail'
        echo 'vimore: Failed to start formatter'
    endif
endfunc

" ---------- 代码检查 ----------
function! s:CheckCandidates(ft, file) abort
    let list = []

    if a:ft == 'python'
        if executable('ruff')
            call add(list, ['ruff', 'ruff check ' . a:file])
        endif
        if executable('pylint')
            call add(list, ['pylint', 'pylint ' . a:file])
        endif
        if executable('flake8')
            call add(list, ['flake8', 'flake8 ' . a:file])
        endif
    elseif a:ft =~? '^javascript\|^typescript'
        if executable('eslint')
            call add(list, ['eslint', 'eslint ' . a:file])
        endif
    elseif a:ft == 'go'
        if executable('go')
            call add(list, ['go', 'go vet ' . a:file])
        endif
    elseif a:ft == 'rust'
        if executable('cargo')
            call add(list, ['cargo', 'cargo check'])
        endif
    elseif a:ft == 'lua'
        if executable('luac')
            call add(list, ['luac', 'luac -p ' . a:file])
        endif
    elseif a:ft == 'sh' || a:ft == 'bash'
        if executable('shellcheck')
            call add(list, ['shellcheck', 'shellcheck ' . a:file])
        endif
    elseif a:ft == 'c' || a:ft == 'cpp'
        let cc = a:ft == 'c' ? 'gcc' : 'g++'
        if executable(cc)
            call add(list, [cc, cc . ' -fsyntax-only ' . a:file])
        endif
    elseif a:ft == 'json'
        if executable('jq')
            call add(list, ['jq', 'jq empty ' . a:file])
        endif
    elseif a:ft == 'yaml' || a:ft == 'yml'
        if executable('yamllint')
            call add(list, ['yamllint', 'yamllint ' . a:file])
        endif
    elseif a:ft == 'toml'
        if executable('taplo')
            call add(list, ['taplo', 'taplo check ' . a:file])
        endif
    elseif a:ft == 'markdown'
        if executable('markdownlint')
            call add(list, ['markdownlint', 'markdownlint ' . a:file])
        endif
    endif

    return list
endfunction

function! s:CheckDone(output, job, status) abort
    let text = trim(join(a:output, ''))

    if a:status == 0 && text == ''
        echo 'vimore: Check passed, no issues found'
        return
    endif
    if text == ''
        echo 'vimore: Check failed (exit ' . a:status . ')'
        return
    endif

    let save_efm = &errorformat
    set errorformat=%f:%l:%c:\ %m,%f:%l:\ %m,%m
    try
        execute 'silent cexpr ' . string(text)
    catch
        echo 'vimore: Check output could not be parsed: ' . v:exception
        let &errorformat = save_efm
        return
    endtry
    let &errorformat = save_efm

    if !empty(getqflist())
        copen
    endif
    echo 'vimore: Issues found; see quickfix'
endfunction

func! CheckCode() abort
    if !s:SaveFile()
        return
    endif

    let file = shellescape(expand('%:p'))
    let candidates = s:CheckCandidates(&filetype, file)
    let cmd = ''

    for [exe, c] in candidates
        if executable(exe)
            let cmd = c
            break
        endif
    endfor

    if cmd == ''
        echo 'vimore: No checker found for filetype: ' . &filetype
        return
    endif

    let output = []
    let job = job_start(['sh', '-c', cmd], {
                \ 'cwd': expand('%:p:h'),
                \ 'out_cb': function('s:CollectOutput', [output]),
                \ 'err_cb': function('s:CollectOutput', [output]),
                \ 'exit_cb': function('s:CheckDone', [output]),
                \ })
    if job_status(job) ==# 'fail'
        echo 'vimore: Failed to start checker'
    endif
endfunc

" ============================================================
" 19. 文件浏览器配置
" ============================================================
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_winsize=25
let g:netrw_altv=1
let g:netrw_alto=1
let g:netrw_browse_split=0
let g:netrw_preview=1
let g:netrw_sort_sequence='[\/]$,*'

" ============================================================
" 20. 文件头自动生成
" ============================================================
let s:header_ft = {
            \ 'py': 'python', 'go': 'go', 'sh': 'sh', 'bash': 'sh',
            \ 'c': 'c', 'cc': 'cpp', 'cpp': 'cpp', 'h': 'c', 'hpp': 'cpp',
            \ 'java': 'java', 'js': 'javascript', 'ts': 'typescript',
            \ 'rs': 'rust', 'lua': 'lua',
            \ }

function! s:HeaderFT() abort
    if &filetype != ''
        return &filetype
    endif
    return get(s:header_ft, tolower(expand('%:e')), '')
endfunction

" 统一的 Doxygen 字段块；prefix 决定每行的注释前缀
function! s:MetaLines(prefix, file, date) abort
    let lines = [a:prefix . '@file    ' . a:file]
    if !empty(get(g:, 'author', ''))
        call add(lines, a:prefix . '@author  ' . g:author)
    endif
    if !empty(get(g:, 'email', ''))
        call add(lines, a:prefix . '@email   ' . g:email)
    endif
    call add(lines, a:prefix . '@date    ' . a:date)
    call add(lines, a:prefix . '@brief   ')
    return lines
endfunction

" 新建 foo.go 时按目录推导 package，推导失败再退回 main
function! s:GoPackage() abort
    let name = tolower(fnamemodify(expand('%:p:h'), ':t'))
    let name = substitute(name, '[^0-9a-z_]', '_', 'g')
    if name == '' || name !~# '^[a-z_]'
        return 'main'
    endif
    return name
endfunction

function! s:JavaClass() abort
    let name = fnamemodify(expand('%:r'), ':t')
    if name == '' || name !~# '^[A-Za-z_][0-9A-Za-z_]*$'
        return 'Main'
    endif
    return name
endfunction

function! s:SetTitle() abort
    if line('$') > 1 && getline(1) != ''
        return
    endif

    " 创建日期只到天；时刻交给 git，不写进每个文件
    let date = strftime('%Y-%m-%d')
    let ft = s:HeaderFT()
    let file = fnamemodify(expand('%:t'), ':t')
    let lines = []

    if ft == 'python'
        " Python 3 源码默认 UTF-8（PEP 3120），不再需要 coding 声明
        let lines = ['#!/usr/bin/env python3', '"""']
        call extend(lines, s:MetaLines('', file, date))
        call extend(lines, ['"""', ''])
    elseif ft == 'lua'
        let lines = ['#!/usr/bin/env lua', '--[[']
        call extend(lines, s:MetaLines('', file, date))
        call extend(lines, [']]', ''])
    elseif ft == 'sh' || ft == 'bash'
        let lines = ['#!/usr/bin/env bash']
        call extend(lines, s:MetaLines('# ', file, date))
        call add(lines, '')
    elseif ft == 'go'
        let lines = s:MetaLines('// ', file, date)
        call add(lines, '')
        let pkg = s:GoPackage()
        call add(lines, 'package ' . pkg)
        if pkg ==# 'main'
            call extend(lines, ['', 'func main() {', '}', ''])
        else
            call add(lines, '')
        endif
    elseif ft == 'c' || ft == 'cpp'
        let lines = ['/**']
        call extend(lines, s:MetaLines(' * ', file, date))
        call extend(lines, [' */', ''])
    elseif ft == 'java'
        let lines = ['/**']
        call extend(lines, s:MetaLines(' * ', file, date))
        call extend(lines, [
                    \ ' */',
                    \ '',
                    \ 'public class ' . s:JavaClass(),
                    \ '{',
                    \ '}',
                    \ '',
                    \ ])
    elseif ft == 'javascript' || ft == 'typescript'
        let lines = ['/**']
        call extend(lines, s:MetaLines(' * ', file, date))
        call extend(lines, [' */', ''])
    elseif ft == 'rust'
        let lines = s:MetaLines('//! ', file, date)
        call add(lines, '')
    else
        return
    endif

    silent! %delete _
    call setline(1, lines)
    normal! G
endfunction

augroup VimoreHeader
    autocmd!
    autocmd BufNewFile *.py,*.go,*.sh,*.bash,*.c,*.cc,*.cpp,*.h,*.hpp,*.java,*.js,*.ts,*.rs,*.lua call s:SetTitle()
augroup END

" ============================================================
" 21. 自动命令
" ============================================================
augroup VimoreAuto
    autocmd!
    autocmd FocusGained,BufEnter * silent! checktime

    " 自动切工作目录是可选行为：它会改变相对路径和 :e 的基准
    if get(g:, 'vimore_autochdir', 0)
        autocmd BufEnter * if expand('%:p:h') != '' | silent! lcd %:p:h | endif
    endif

    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
augroup END

" ============================================================
" 22. 标签栏
" ============================================================
set showtabline=1

" 按显示宽度截断，避免把多字节字符切成半个
function! s:StrTruncate(str, cells) abort
    if a:cells < 1
        return ''
    endif
    if strdisplaywidth(a:str) <= a:cells
        return a:str
    endif
    let l:out = ''
    let l:i = 0
    while l:i < strchars(a:str)
        let l:cand = l:out . strcharpart(a:str, l:i, 1)
        if strdisplaywidth(l:cand) > a:cells - 1
            break
        endif
        let l:out = l:cand
        let l:i += 1
    endwhile
    return l:out
endfunction

function! MyTabLine()
    let s = ''
    let t = tabpagenr()
    let n = tabpagenr('$')

    let width = (&columns - 2) / n
    if width < 8 | let width = 8 | endif
    let padding = 2

    for i in range(1, n)
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let bufname = fnamemodify(bufname(buflist[winnr - 1]), ':t')
        if bufname == '' | let bufname = '[No Name]' | endif

        let name_len = width - len(i . ':') - 2 - padding
        if name_len < 1
            let name_len = 1
        endif
        if strdisplaywidth(bufname) > name_len
            let bufname = s:StrTruncate(bufname, name_len - 1) . '…'
        endif

        let modified = getbufvar(buflist[winnr - 1], '&modified') ? '+' : ''
        let label = ' ' . i . ':' . bufname . modified
        let label = label . repeat(' ', max([0, width - strdisplaywidth(label)]))

        " 每个标签前必须有 %NT，鼠标点击才会切到对应标签
        let s .= '%' . i . 'T'
        if i == t
            let s .= '%#TabLineSel#' . label
        else
            let s .= '%#TabLine#' . label
        endif
    endfor

    let s .= '%#TabLineFill#%T'
    return s
endfunction

set tabline=%!MyTabLine()

" ============================================================
" 23. Leader 提示菜单 (仿 which-key / Helix)
" ============================================================
" === 依赖函数 ===
" == Leader w c ==
function! WordCount()
    call feedkeys("g\<C-g>", 'n')
endfunction

" == Leader b ==
" 给可视选区加括号
" 把 1-based 字节列索引扩展到该字符最后一个字节
function! s:char_end_col(line, col)
    let tail = strpart(a:line, a:col - 1)
    if tail == ''
        return a:col
    endif
    let ch = matchstr(tail, '^.')  " Vim 的 . 匹配一个完整字符
    return a:col + len(ch) - 1      " len 返回字节数
endfunction

function! AddPair(pair)
    let map = {'(' : ')', '[' : ']', '{' : '}', '"' : '"', "'" : "'", "<" : ">"}
    if !has_key(map, a:pair)
        echo "Unsupported bracket: " . a:pair
        return
    endif
    if !get(g:, 'vimore_from_visual', 0)
        echo "Select text in Visual mode first"
        return
    endif
    let left = a:pair
    let right = map[left]

    let start_pos = getpos("'<")
    let end_pos = getpos("'>")
    if start_pos[1] == 0 || end_pos[1] == 0
        echo "No visual selection"
        return
    endif

    let start_line = start_pos[1]
    let end_line = end_pos[1]
    let start_col = start_pos[2]
    let end_col = end_pos[2]

    if start_line == end_line
        let line = getline(start_line)
        let end_col = s:char_end_col(line, end_col)
        let prefix = start_col > 1 ? line[:start_col-2] : ''
        let new_line = prefix . left . line[start_col-1:end_col-1] . right . line[end_col:]
        call setline(start_line, new_line)
    else
        let first = getline(start_line)
        let last = getline(end_line)
        let end_col = s:char_end_col(last, end_col)
        let prefix = start_col > 1 ? first[:start_col-2] : ''
        call setline(start_line, prefix . left . first[start_col-1:])
        call setline(end_line, last[:end_col-1] . right . last[end_col:])
    endif
endfunction

function! AddPairCode(code)
    call AddPair(nr2char(a:code))
endfunction

function! GitCommit() abort
    let l:msg = input('Commit: ')
    if empty(l:msg)
        return
    endif
    execute '!git commit -m ' . shellescape(l:msg)
endfunction

function! GitAdd() abort
    if expand('%') == ''
        echo 'vimore: Current buffer has no file name'
        return
    endif
    execute '!git add ' . shellescape(expand('%:p'))
endfunction

" 可视模式进入菜单时，操作只作用于选区；普通模式下作用于整个文件
function! s:RangeCmd(cmd) abort
    if get(g:, 'vimore_from_visual', 0)
        execute "'<,'>" . a:cmd
    else
        execute a:cmd
    endif
endfunction

function! s:DeleteBlankLines() abort
    call s:RangeCmd('g/^\s*$/d')
endfunction

function! s:SortLines(kind) abort
    if a:kind ==# 'unique'
        call s:RangeCmd('sort u')
    elseif a:kind ==# 'number'
        call s:RangeCmd('sort n')
    else
        call s:RangeCmd('sort')
    endif
endfunction

" 按显示宽度左对齐（中文标签不会把菜单撑歪）
function! s:Ljust(str, cells) abort
    return a:str . repeat(' ', max([0, a:cells - strdisplaywidth(a:str)]))
endfunction

" === 菜单主体 ===
function! s:HealthLine(hl, text) abort
    execute 'echohl ' . a:hl
    echo a:text
    echohl None
endfunction

function! VimoreHealth() abort
    redraw
    call s:HealthLine('Title', 'Vimore health check')
    call s:HealthLine('ModeMsg', '[OK] Vim ' . v:version)
    call s:HealthLine('ModeMsg', '[OK] Colorscheme: ' . get(g:, 'colors_name', 'not set'))
    call s:HealthLine('ModeMsg', '[OK] Leader: ' . string(get(g:, 'mapleader', ' ')))
    call s:HealthLine('Directory', '[--] Options: autochdir=' . get(g:, 'vimore_autochdir', 0)
                \ . ' strip_whitespace=' . get(g:, 'vimore_strip_whitespace', 1)
                \ . ' menu_timeout=' . get(g:, 'vimore_menu_timeout', 3000))
    let fmt = []
    for tool in ['black', 'gofmt', 'prettier', 'clang-format', 'shfmt', 'stylua', 'zig']
        if executable(tool) | call add(fmt, tool) | endif
    endfor
    call s:HealthLine(empty(fmt) ? 'WarningMsg' : 'ModeMsg',
                \ (empty(fmt) ? '[WARN]' : '[OK]') . ' Formatters: ' . (empty(fmt) ? 'none detected' : join(fmt, ', ')))
    let chk = []
    for tool in ['luac', 'pylint', 'flake8', 'shellcheck', 'jq']
        if executable(tool) | call add(chk, tool) | endif
    endfor
    call s:HealthLine(empty(chk) ? 'WarningMsg' : 'ModeMsg',
                \ (empty(chk) ? '[WARN]' : '[OK]') . ' Checkers: ' . (empty(chk) ? 'none detected' : join(chk, ', ')))
    if filereadable(s:root . '/tutor/Vimore.tutor.txt')
        call s:HealthLine('ModeMsg', '[OK] Interactive tutorial available (:VimoreTutor)')
    else
        call s:HealthLine('WarningMsg', '[WARN] Tutorial not found (normal for single-file install)')
    endif
    if filereadable(s:root . '/VimMaze.vim')
        call s:HealthLine('ModeMsg', '[OK] VimMaze available (:VimMaze)')
    else
        call s:HealthLine('WarningMsg', '[WARN] VimMaze.vim not found')
    endif
    call s:HealthLine('Title', 'Use :messages for full details')
endfunction

function! s:ShowKeys() abort
    let names = {'n': 'Normal', 'x': 'Visual', 'i': 'Insert', 't': 'Terminal'}
    let lines = ['Viore keymaps', 'Press q or Esc to close', '']
    for mode in ['n', 'x', 'i', 't']
        call add(lines, '== ' . get(names, mode, mode) . ' ==')
        let maps = []
        try
            let maps = split(execute(mode . 'map'), "\n")
        catch
        endtry
        if empty(maps)
            call add(lines, '  (none)')
        else
            for l in maps
                call add(lines, '  ' . substitute(l, '^\s*', '', ''))
            endfor
        endif
        call add(lines, '')
    endfor
    execute 'botright new'
    setlocal buftype=nofile bufhidden=wipe noswapfile
    call setline(1, lines)
    setlocal nomodifiable
    nnoremap <buffer> <silent> q :close<CR>
    nnoremap <buffer> <silent> <Esc> :close<CR>
endfunction

command! VimoreHealth call VimoreHealth()
command! VimoreKeys call s:ShowKeys()

let g:leader_menu = {
            \ 'w':  {
            \ 'name': 'Write',
            \ 'w': ['Save',           function('SaveAndClear')],
            \ 's': ['Strip trailing whitespace', function('StripTrailingWhitespaceManual')],
            \ 'c': ['Word count',      function('WordCount')],
            \ },
            \ 'q':  ['Quit',             ':silent! quit<CR>'],
            \ 'W':  ['Save all',         ':silent! wall<CR>'],
            \ 'Q':  ['Quit all',         ':silent! qall<CR>'],
            \ 'h':  {
            \ 'name': 'Display',
            \ 'h': ['Clear search highlight', ':nohlsearch<CR>'],
            \ 'x': ['Hex mode',        ':%!xxd<CR>'],
            \ 'X': ['Exit hex mode',   ':%!xxd -r<CR>'],
            \ },
            \ 'f':  ['Format code',     function('FormatCode')],
            \ 'c':  {
            \ 'name': 'Maintain',
            \ 'c': ['Check code',     function('CheckCode')],
            \ 'h': ['Run health check', function('VimoreHealth')],
            \ 'k': ['Keymap overview', function('s:ShowKeys')],
            \ 't': ['Open tutorial',   ':VimoreTutor<CR>'],
            \ 'v': ['Reload config',   ':call timer_start(0, {-> execute("source $MYVIMRC")})<CR>'],
            \ 'e': ['Edit config',     ':e $MYVIMRC<CR>'],
            \ },
            \ '/':  ['Toggle comment',  function('ToggleCommentSmart')],
            \ '?':  ['Open tutorial',   ':VimoreTutor<CR>'],
            \ 'b':  {
            \ 'name': 'Brackets',
            \ 'd': {
            \ 'name': 'Delete pair and contents',
            \ '(': ['Parentheses', ':execute "normal! da" . nr2char(40)<CR>'],
            \ '[': ['Square brackets', ':execute "normal! da" . nr2char(91)<CR>'],
            \ '{': ['Braces',    ':execute "normal! da" . nr2char(123)<CR>'],
            \ '"': ['Double quote', ':execute "normal! da" . nr2char(34)<CR>'],
            \ "'": ['Single quote', ':execute "normal! da" . nr2char(39)<CR>'],
            \ },
            \ 'a': {
            \ 'name': 'Wrap visual selection',
            \ '(': ['Parentheses', ':call AddPair("(")<CR>'],
            \ '[': ['Square brackets', ':call AddPair("[")<CR>'],
            \ '{': ['Braces',    ':call AddPair("{")<CR>'],
            \ '"': ['Double quote', ':call AddPairCode(34)<CR>'],
            \ "'": ['Single quote', ':call AddPairCode(39)<CR>'],
            \ '<': ['Angle brackets', ':call AddPair("<")<CR>'],
            \ },
            \ },
            \ 'r':  ['Show registers',   ':reg<CR>'],
            \ 'z':  {
            \ 'name': 'View',
            \ 'z': ['Fold all',      ':normal! zM<CR>'],
            \ 'a': ['Toggle fold',   ':normal! za<CR>'],
            \ 'Z': ['Unfold all',    ':normal! zR<CR>'],
            \ },
            \ 'y':  ['Yank to clipboard', ':normal! "+yy<CR>'],
            \ 'p':  ['Paste from clipboard', ':call WlClipboardPaste() | normal! "+p<CR>'],
            \ 'P':  ['Paste from clipboard (before)', ':call WlClipboardPaste() | normal! "+P<CR>'],
            \ 's':  {
            \ 'name': 'Sort / clean',
            \ 'd': ['Delete blank lines', function('s:DeleteBlankLines')],
            \ 's': ['Sort lines',     function('s:SortLines', ['name'])],
            \ 'u': ['Sort unique',    function('s:SortLines', ['unique'])],
            \ 'n': ['Sort numeric',   function('s:SortLines', ['number'])],
            \ },
            \ 'g':  {
            \ 'name': 'Git',
            \ 's': ['git status',     ':!git status<CR>'],
            \ 'd': ['git diff',       ':!git diff<CR>'],
            \ 'l': ['git log',        ':!git log --oneline --graph<CR>'],
            \ 'a': ['git add',        function('GitAdd')],
            \ 'c': ['git commit',     function('GitCommit')],
            \ 'p': ['git push',       ':!git push<CR>'],
            \ 'P': ['git pull',       ':!git pull<CR>'],
            \ },
            \ 't':  {
            \ 'name': 'Window',
            \ 't': ['Terminal (bottom)', ':call OpenTerminal("horizontal")<CR>'],
            \ 'v': ['Terminal (right)', ':call OpenTerminal("vertical")<CR>'],
            \ 'r': ['Run current file', function('RunInLatestTerminal')],
            \ 'k': ['Toggle terminal', function('ToggleTerminal')],
            \ 'n': ['New tab',        ':tabnew<CR>'],
            \ 'e': ['Edit in new tab', ':tabedit %<CR>'],
            \ 'c': ['Close tab',      ':tabclose<CR>'],
            \ 'o': ['Keep only tab',  ':tabonly<CR>'],
            \ 'M': ['Move tab left', ':tabmove -1<CR>'],
            \ 'N': ['Move tab right', ':tabmove +1<CR>'],
            \ 'l': ['List tabs',      ':tabs<CR>'],
            \ 'u': ['Open alternate file in tab', ':tabnew #<CR>'],
            \ 'd': ['Open directory in tab', ':tabnew .<CR>'],
            \ 'f': ['File explorer',  ':Explore<CR>'],
            \ 'F': ['Vertical file explorer', ':Vexplore<CR>']
            \ },
            \ }

" === 可视模式单独快捷键 ===
" 缩进选区并保持选中（方便连续缩进）
xnoremap <silent> < <gv
xnoremap <silent> > >gv


" === 菜单引擎 ===
" == 渲染菜单为文本行 ==
function! s:RenderMenu(menu, prefix)
    let leaf_lines = []
    let sub_lines = []

    for k in sort(keys(a:menu))
        if k == 'name'
            continue
        endif
        let item = a:menu[k]
        if type(item) == v:t_dict
            " 子菜单：显示键 + <名字>
            let name = has_key(item, 'name') ? item['name'] : k
            call add(sub_lines, ' ' . s:Ljust(k, 6) . ' <' . name . '>')
        else
            " 叶子节点
            call add(leaf_lines, ' ' . s:Ljust(k, 6) . ' ' . item[0])
        endif
    endfor

    if !empty(sub_lines) && !empty(leaf_lines)
        return leaf_lines + [''] + sub_lines
    endif
    return leaf_lines + sub_lines
endfunction

" == 执行菜单项 ==
" 白名单(不静默输出)
let s:verbose_funcs = [
            \ 'SaveAndClear',
            \ 'StripTrailingWhitespaceManual',
            \ 'FormatCode',
            \ 'CheckCode',
            \ 'GitCommit'
            \ ]
function! s:RunMenuItem(item)
    let l:Action = a:item[1]

    if type(l:Action) == v:t_func
        let l:is_verbose = 0
        for f in s:verbose_funcs
            if string(l:Action) =~ f
                let l:is_verbose = 1
                break
            endif
        endfor
        if l:is_verbose
            call call(l:Action, [])
        else
            " 其他命令直接静默执行操作
            silent call call(l:Action, [])
        endif
    elseif l:Action[0] == ':'
        let l:cmd = substitute(l:Action, '<CR>$', '', '')
        " 输出型命令不走 silent，否则屏幕不刷新
        if l:cmd =~ '^:!' || l:cmd =~ '^:\(reg\|tabs\|marks\|jumps\|ls\|buffers\|messages\|copen\|cclose\)\>'
            execute l:cmd
        else
            silent execute l:cmd
            redraw
        endif
    else
        silent execute 'normal! ' . l:Action
        redraw
    endif
endfunction

" 读取一个键；超时返回空串，菜单自己会关掉
function! s:GetChar(timeout) abort
    let start = reltime()
    while 1
        let char = getcharstr(0)
        if char != ''
            return char
        endif
        if a:timeout > 0 && reltimefloat(reltime(start)) * 1000 >= a:timeout
            return ''
        endif
        sleep 20m
    endwhile
endfunction

" 离开可视模式，但不改变已经保存的 '< '> 标记
function! s:LeaveVisual(from_visual) abort
    if a:from_visual && index(['v', 'V', nr2char(22)], mode()) >= 0
        execute "normal! \<Esc>"
    endif
endfunction

" == 主提示循环 ==
function! s:LeaderPrompt(...)
    let silent_mode = a:0 > 0 ? a:1 : 0
    " 是否来自可视模式：由映射显式传入。
    " 映射以 ':' 开头，进入函数时可视模式已经退出，只能靠参数判断。
    let save_visual = a:0 > 1 ? a:2 : 0

    let g:vimore_from_visual = save_visual

    let save_start = getpos("'<")
    let save_end = getpos("'>")
    let save_cur = getpos('.')

    " 重新选中，让菜单打开时仍能看到高亮的选区
    if save_visual
        silent! normal! gv
    endif

    let menu = g:leader_menu
    let prefix = ''
    let timeout = get(g:, 'vimore_menu_timeout', 3000)

    while 1
        let lines = s:RenderMenu(menu, prefix)
        if empty(lines)
            let lines = [' (no commands available)']
        endif

        let title = ' Leader ' . (prefix == '' ? '' : prefix . ' ')
        if has_key(menu, 'name')
            let title .= '- ' . menu['name'] . ' '
        endif

        if !silent_mode
            let width = 0
            for l in lines
                let width = max([width, strdisplaywidth(l)])
            endfor
            if width < 24 | let width = 24 | endif

            if exists('*popup_create')
                let winid = popup_create(lines, #{
                            \ line: max([0, &lines - len(lines) - 3]),
                            \ col: max([0, &columns - width - 4]),
                            \ minwidth: width + 2,
                            \ maxwidth: width + 2,
                            \ padding: [0, 1, 0, 1],
                            \ title: title,
                            \ })
                redraw
            else
                redraw
                echo title . "\n" . join(lines, "\n")
                let winid = -1
            endif
        else
            let winid = -1
        endif

        let char = s:GetChar(timeout)

        if !silent_mode && exists('*popup_close') && winid != -1
            call popup_close(winid)
        endif
        if !silent_mode
            redraw
        endif

        " Esc / Ctrl-C / 超时：关闭菜单；可视模式下保留选区
        if char == '' || char == "\<Esc>" || char == "\<C-c>"
            call s:LeaveVisual(save_visual)
            if save_visual
                call setpos("'<", save_start)
                call setpos("'>", save_end)
                call setpos('.', save_cur)
                silent! normal! gv
            endif
            return
        endif

        if has_key(menu, char)
            let item = menu[char]
            if type(item) == v:t_dict
                let prefix .= char
                let menu = item
            else
                call s:LeaveVisual(save_visual)
                " 恢复选区标记和光标，再执行
                call setpos("'<", save_start)
                call setpos("'>", save_end)
                call setpos('.', save_cur)
                call s:RunMenuItem(item)
                return
            endif
        elseif has_key(menu, '_')
            call s:RunMenuItem(menu['_'])
            return
        else
            call s:LeaveVisual(save_visual)
            return
        endif
    endwhile
endfunction

function! VimoreMenu(...) abort
    call call(function('s:LeaderPrompt'), a:000)
endfunction

nnoremap <silent> <Leader> <Cmd>call <SID>LeaderPrompt()<CR>
xnoremap <silent> <Leader> :<C-u>call <SID>LeaderPrompt(0, 1)<CR>
command! VimoreMenu call VimoreMenu()

" 教程和 VimMaze 是随仓库附带的可选文件；只拷走单个 vimrc 时
" 优雅提示而不是报错（核心编辑功能完全不依赖它们）
function! s:Companion(name) abort
    let path = s:root . '/' . a:name
    if filereadable(path)
        return path
    endif
    echo 'vimore: Companion file not found: ' . path . ' (normal for single-file install)'
    return ''
endfunction

function! s:OpenTutor() abort
    let path = s:Companion('tutor/Vimore.tutor.txt')
    if path != ''
        execute 'edit ' . fnameescape(path)
    endif
endfunction
command! VimoreTutor call s:OpenTutor()

function! s:StartVimMaze() abort
    let path = s:Companion('VimMaze.vim')
    if path == ''
        return
    endif
    execute 'source ' . fnameescape(path)
    VimMaze
endfunction
command! VimMaze call s:StartVimMaze()

