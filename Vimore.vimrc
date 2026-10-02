" ============================================================
" Vimore
" 作者: BiaoZyx
" 邮箱: BiaoZyx@outlook.com
" 版本: 3.17
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
let author = "Change it in ~/.vimrc"
let email  = "Change it in ~/.vimrc"

" ============================================================
" 插件设置 (根据需求)
" ============================================================
" === ALE(Example) ===
" let g:ale_linters = {
" \ 'sh': ['language_server'],
" \ }

" ============================================================
" 1. 基础设置
" ============================================================
set nocompatible              " 不使用 vi 兼容模式
syntax on
syntax enable
set background=dark

let mapleader = " "           " Leader 键设为空格
set clipboard=                " 不自动同步系统剪切板，用 Ctrl+C/V 手动控制

" 颜色主题
try
    colorscheme slate
catch
    colorscheme default
endtry

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
autocmd InsertEnter * set norelativenumber
autocmd InsertEnter * set number

" 退出插入模式时使用相对行号
autocmd InsertLeave * set relativenumber

" 限制语法同步范围 (避免 Vim 每次重绘都从头解析整个文件)
syntax sync minlines=200
syntax sync maxlines=500

" ============================================================
" 3. 状态栏
" ============================================================
" ---------- 高亮颜色定义（终端 + GUI 统一设置） ----------
if has('gui_running')
    " ---- GUI 颜色 ----
    highlight StatusLine   guifg=#ffffff guibg=#585858 gui=bold
    highlight StatusLineNC guifg=#aaaaaa guibg=#303030
    highlight StatusLineTerm guifg=#ffffff guibg=#303030 gui=bold
    highlight User1        guifg=#ffd700 guibg=#585858 gui=bold
    highlight User2        guifg=#87d787 guibg=#585858 gui=bold
    highlight User3        guifg=#5fd7ff guibg=#585858 gui=bold
    highlight User4        guifg=#d7afff guibg=#585858 gui=bold
    highlight User5        guifg=#ffaf5f guibg=#585858 gui=bold
    " 模式指示器颜色（GUI 版）
    highlight ModeNormal   guifg=#ffffff guibg=#585858 gui=bold
    highlight ModeInsert   guifg=#5fafff guibg=#585858 gui=bold
    highlight ModeVisual   guifg=#87d787 guibg=#585858 gui=bold
    highlight ModeVLine    guifg=#5faf5f guibg=#585858 gui=bold
    highlight ModeVBlock   guifg=#5fd7ff guibg=#585858 gui=bold
    highlight ModeReplace  guifg=#d787ff guibg=#585858 gui=bold
    highlight ModeCmdline  guifg=#ff5f5f guibg=#585858 gui=bold
    highlight ModeTerminal guifg=#ffd700 guibg=#585858 gui=bold
else
    " ---- 终端颜色（256 色优先） ----
    if &t_Co >= 256
        highlight StatusLine   ctermfg=white ctermbg=238 cterm=bold
        highlight StatusLineNC ctermfg=gray  ctermbg=236
        highlight StatusLineTerm ctermfg=white ctermbg=236 cterm=bold
        highlight User1        ctermfg=220   ctermbg=238 cterm=bold
        highlight User2        ctermfg=114   ctermbg=238 cterm=bold
        highlight User3        ctermfg=81    ctermbg=238 cterm=bold
        highlight User4        ctermfg=176   ctermbg=238 cterm=bold
        highlight User5        ctermfg=215   ctermbg=238 cterm=bold
        " 模式指示器颜色（256 色终端）
        highlight ModeNormal   ctermfg=white ctermbg=238 cterm=bold
        highlight ModeInsert   ctermfg=blue  ctermbg=238 cterm=bold
        highlight ModeVisual   ctermfg=green ctermbg=238 cterm=bold
        highlight ModeVLine    ctermfg=darkgreen ctermbg=238 cterm=bold
        highlight ModeVBlock   ctermfg=cyan  ctermbg=238 cterm=bold
        highlight ModeReplace  ctermfg=magenta ctermbg=238 cterm=bold
        highlight ModeCmdline  ctermfg=red   ctermbg=238 cterm=bold
        highlight ModeTerminal ctermfg=yellow ctermbg=238 cterm=bold
    else
        " ---- 低色彩终端（8/16 色） ----
        highlight StatusLine   ctermfg=white ctermbg=darkblue cterm=bold
        highlight StatusLineNC ctermfg=gray  ctermbg=darkgray
        highlight User1        ctermfg=yellow ctermbg=darkblue cterm=bold
        highlight User2        ctermfg=green  ctermbg=darkblue cterm=bold
        highlight User3        ctermfg=cyan   ctermbg=darkblue cterm=bold
        highlight User4        ctermfg=magenta ctermbg=darkblue cterm=bold
        highlight User5        ctermfg=lightred ctermbg=darkblue cterm=bold
        " 模式指示器颜色（低色彩终端）
        highlight ModeNormal   ctermfg=white  ctermbg=darkblue cterm=bold
        highlight ModeInsert   ctermfg=blue   ctermbg=darkblue cterm=bold
        highlight ModeVisual   ctermfg=green  ctermbg=darkblue cterm=bold
        highlight ModeVLine    ctermfg=darkgreen ctermbg=darkblue cterm=bold
        highlight ModeVBlock   ctermfg=cyan   ctermbg=darkblue cterm=bold
        highlight ModeReplace  ctermfg=magenta ctermbg=darkblue cterm=bold
        highlight ModeCmdline  ctermfg=red    ctermbg=darkblue cterm=bold
        highlight ModeTerminal ctermfg=yellow ctermbg=darkblue cterm=bold
    endif
endif

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

set undodir=~/.vim/undodir
set backupdir=~/.vim/backupdir
set directory=~/.vim/swapdir

" ============================================================
" 5. 缩进与格式
" ============================================================
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set cindent
set shiftround
set infercase
set formatoptions+=mB
set lbr
set textwidth=0                " 禁止自动换行
set nowrap
set nolinebreak
set showbreak=↪

" 各文件类型自定义缩进
autocmd FileType python,sh setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
autocmd FileType javascript,typescript,html,css,json,yaml,markdown setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType c,cpp,java,rust setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" 普通模式：单按 < / > 缩进当前行
nnoremap <silent> < :<C-u>silent! normal! <<<CR>
nnoremap <silent> > :<C-u>silent! normal! >><CR>

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
set sidescrolloff=5
set sidescroll=5
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
" 进入选择模式：稳定方块
let &t_SS = "\<Esc>[2 q"
" 退出选择模式：恢复普通模式方块
let &t_SE = "\<Esc>[1 q"
" 进入可视模式：稳定方块
autocmd ModeChanged *:[vV\x16]* silent !echo -ne "\e[2 q"
" 退出可视模式：恢复普通模式方块
autocmd ModeChanged [vV\x16]*:* silent !echo -ne "\e[1 q"
set timeoutlen=300   " 缩短普通映射超时（单位毫秒）
set ttimeoutlen=50   " 缩短按键码（如功能键、方向键）超时

function! SaveAndClear()
    write
    call timer_start(2000, {-> execute('echo ""', '')})
endfunction

" ============================================================
" 8. 括号/引号智能补全
" ============================================================
" 补全左括号光标后无字符或紧挨右括号时智能处理）
inoremap <silent> ( <C-r>=SmartPair('(', ')')<CR>
inoremap <silent> [ <C-r>=SmartPair('[', ']')<CR>

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
"inoremap <silent> { <C-r>=SmartCondition('{')<CR>  " 不再补全左大括号
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

function! SmartCloseQuote(quote)
    silent!
    let line = getline('.')
    let col = col('.') - 1

    if col < len(line) && line[col] == a:quote
        return "\<Right>"
    endif

    return a:quote
endfunction

" 智能退格：成对删除括号/引号
inoremap <silent> <BS> <C-r>=SmartBackspace()<CR>

function! SmartBackspace()
    silent!
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
" 复制到系统剪切板：<Leader>y
nnoremap <Leader>y "+yy
vnoremap <Leader>y "+y

" 从系统剪切板粘贴：<Leader>p / <Leader>P
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" 粘贴模式开关
set pastetoggle=<F2>

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
    let trimmed = substitute(line, '^\s*', '', '')

    if trimmed =~ '^' . escape(comment, '.*^$[]')
        " 取消注释
        if comment_end != ''
            let line = substitute(line, '\(\s*\)' . escape(comment, '.*^$[]') . '\(.*\)' . escape(comment_end, '.*^$[]'), '\1\2', '')
        else
            let line = substitute(line, '\(\s*\)' . escape(comment, '.*^$[]'), '\1', '')
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
    let safe_comment = escape(comment, '"!')
    let safe_comment_end = escape(comment_end, '"!')
    let first_line = getline("'<")
    let trimmed = substitute(first_line, '^\s*', '', '')
    let is_commented = trimmed =~ '^' . escape(comment, '.*^$[]')

    if is_commented
        if comment_end != ''
            execute "silent '<,'>s!\\(\\s*\\)" . escape(comment, '.*^$!') . "\\(.*\\)" . escape(comment_end, '.*^$!') . "!\\1\\2!"
        else
            execute "silent '<,'>s!\\(\\s*\\)" . escape(comment, '.*^$!') . "!\\1!"
        endif
    else
        if comment_end != ''
            execute "silent '<,'>s!^\\(\\s*\\)!\\1" . safe_comment . "!"
            execute "silent '<,'>s!$!" . safe_comment_end . "!"
        else
            execute "silent '<,'>s!^\\(\\s*\\)!\\1" . safe_comment . "!"
        endif
    endif
endfunction

" ============================================================
" 11. 终端集成
" ============================================================
" 终端退出
tnoremap <Esc><Esc> <C-\><C-n>
" tnoremap <C-c> <C-\><C-n>

" 终端复制（退出终端模式后复制到系统剪切板）
tnoremap <C-S-c> <C-\><C-n>"+yy
tnoremap <C-S-v> <C-\><C-n>"+pi

function! OpenTerminal(direction)
    if a:direction == 'horizontal'
        botright terminal
        execute "resize " . (&lines / 3)
    else
        vertical botright terminal
        execute "vertical resize " . (&columns / 3)
    endif
    startinsert
endfunction

function! GetRunCommand()
    let ft = &filetype
    if ft == 'python'
        return 'python3 ' . expand('%')
    elseif ft == 'go'
        return 'go run ' . expand('%')
    elseif ft == 'c'
        return 'gcc ' . expand('%') . ' -o ' . expand('%:r') . ' && ./' . expand('%:r')
    elseif ft == 'cpp'
        return 'g++ ' . expand('%') . ' -o ' . expand('%:r') . ' && ./' . expand('%:r')
    elseif ft == 'javascript'
        return 'node ' . expand('%')
    elseif ft == 'sh' || ft == 'bash'
        return 'bash ' . expand('%')
    elseif ft == 'lua'
        return 'lua ' . expand('%')
    elseif ft == 'rust'
        return 'cargo run'
    else
        return ''
    endif
endfunction

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
function! RunInLatestTerminal()
    let cmd = GetRunCommand()
    if cmd == ''
        echo "不支持的文件类型: " . &filetype
        return
    endif
    silent! write

    let term_buf = s:FindLatestTerminal()

    if term_buf == -1
        " 没有终端，新开一个
        botright terminal
        execute "resize " . (&lines / 3)
    else
        " 有终端，切到它的窗口
        let win = bufwinnr(term_buf)
        if win == -1
            " buffer 存在但窗口关了，重新打开
            execute "botright split | buffer " . term_buf
            execute "resize " . (&lines / 3)
            let win = bufwinnr(term_buf)
        endif
        execute win . "wincmd w"
    endif

    " 进入终端模式并发送命令
    startinsert
    call feedkeys(cmd . "\<CR>", 'n')
endfunction

function! ToggleTerminal()
    let term_buf = -1
    for buf in range(1, bufnr('$'))
        if getbufvar(buf, '&buftype') == 'terminal'
            let term_buf = buf
            break
        endif
    endfor

    if term_buf == -1
        botright terminal
        execute "resize " . (&lines / 3)
        startinsert
    else
        if bufwinnr(term_buf) == -1
            execute "botright split | buffer " . term_buf
            execute "resize " . (&lines / 3)
            startinsert
        else
            execute bufwinnr(term_buf) . "wincmd c"
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
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : (SmartEnterCondition() ? "\<C-o>:call SmartEnter()\<CR>" : "\<CR>")

filetype plugin on

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

function! SetOmniFunc()
    let ft = &filetype
    if has_key(g:omni_func_map, ft)
        execute 'set omnifunc=' . g:omni_func_map[ft]
    else
        set omnifunc=syntaxcomplete#Complete
    endif
endfunction
autocmd FileType * call SetOmniFunc()

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
highlight ExtraWhitespace ctermfg=240 guifg=#666666 ctermbg=NONE guibg=NONE
match ExtraWhitespace /\s\+$/

" 保存时自动清理行尾空格（Markdown 除外）
autocmd BufWritePre * call StripTrailingWhitespace()

function! StripTrailingWhitespace()
    if &filetype == 'markdown'
        return
    endif
    let pos = getpos('.')
    silent! execute '%s/\s\+$//e'
    call setpos('.', pos)
endfunction

function! StripTrailingWhitespaceManual()
    let pos = getpos('.')
    silent! execute '%s/\s\+$//e'
    call setpos('.', pos)
    echo "已清理行尾空格"
    call timer_start(2000, {-> execute('echo ""', '')})
endfunction

" ============================================================
" 15. 边界线
" ============================================================
if exists('+colorcolumn')
    set colorcolumn=120
    highlight! ColorColumn ctermbg=234 guibg=#3a3a3a cterm=NONE gui=NONE
endif

" ============================================================
" 16. 普通快捷键（无 leader）
" ============================================================
" 保存
nnoremap <C-s> :call SaveAndClear()<CR>
inoremap <C-s> <Esc>:call SaveAndClear()<CR>

" 窗口切换
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 标签页切换
nnoremap <silent> <A-Left> :tabp<CR>
nnoremap <silent> <A-Right> :tabn<CR>
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <silent> <C-w> :tabclose<CR>

" 全选复制
vnoremap <C-x> "+x

" ============================================================
" 17. F 键快捷键
" ============================================================
" F1 - 帮助
" F2 - 粘贴模式总开关
nnoremap <silent> <F3> :Explore<CR>
                            " 文件浏览器
nnoremap <silent> <F4> :Vexplore<CR>
                            " 垂直浏览器
nnoremap <silent> <F5> :call RunInLatestTerminal()<CR>
                            " 运行代码
nnoremap <silent> <F6> :call DebugCode()<CR>
                            " 调试代码
nnoremap <silent> <F7> :set wrap!<CR>:echo "wrap = " . &wrap<CR>
                            " 切换自动换行
nnoremap <silent> <F8> :call CheckCode()<CR>
                            " 代码检查
nnoremap <silent> <F9> gg=G
                            " 基础格式化
nnoremap <silent> <F10> :call FormatCode()<CR>
                            " 自动格式化

" ============================================================
" 18. 运行、调试、格式化、检查函数
" ============================================================
func! DebugCode()
    silent! write
    let ft = &filetype
    if ft == 'python'
        exec "!python3 -m pdb %"
    elseif ft == 'c' || ft == 'cpp'
        exec "!g++ % -g -o %< && gdb ./%<"
    elseif ft == 'go'
        exec "!dlv debug %"
    else
        echo "vimore: 调试不支持的文件类型: " . ft
    endif
    "redraw!
endfunc

func! FormatCode()
    silent! write
    let pos = getpos('.')
    let ft = &filetype
    let formatted = 0
    let output = ''

    if ft == 'python'
        if executable('black')
            let output = system('black --skip-string-normalization ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        elseif executable('autopep8')
            let output = system('autopep8 -i --aggressive --max-line-length=120 ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        endif
        if formatted && executable('isort')
            let output .= system('isort ' . shellescape(expand('%')) . ' 2>&1')
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif ft == 'go'
        if executable('gofmt')
            let output = system('gofmt -w ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        endif
        if formatted && executable('goimports')
            let output .= system('goimports -w ' . shellescape(expand('%')) . ' 2>&1')
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif ft == 'javascript' || ft == 'typescript'
        if executable('prettier')
            let output = system('prettier --write ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        elseif executable('eslint')
            let output = system('eslint --fix ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif ft == 'c' || ft == 'cpp'
        if executable('clang-format')
            let output = system('clang-format -i ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif ft == 'java'
        if executable('astyle')
            let output = system('astyle --style=java --suffix=none ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        endif
        if !formatted
            execute "normal gg=G"
        endif
    elseif ft == 'json'
        if executable('prettier')
            let output = system('prettier --write ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        elseif executable('python3')
            let output = system('python3 -m json.tool ' . shellescape(expand('%')) . ' > ' . shellescape(expand('%:r')) . '.tmp && mv ' . shellescape(expand('%:r')) . '.tmp ' . shellescape(expand('%')) . ' 2>&1')
            let formatted = 1
        endif
        if !formatted
            execute "normal gg=G"
        endif
    else
        execute "normal gg=G"
    endif

    " 重载文件，恢复光标
    silent! execute "e!"
    call setpos('.', pos)

    " 显示输出
    if empty(output)
        echo "格式化完成"
    else
        echo output
    endif
endfunc

func! CheckCode()
    silent! write
    let ft = &filetype
    let output = ''

    if ft == 'python'
        if executable('pylint')
            let output = system('pylint ' . shellescape(expand('%')))
        elseif executable('flake8')
            let output = system('flake8 ' . shellescape(expand('%')))
        else
            echo "vimore: 未找到 Python 代码检查工具"
            return
        endif
    elseif ft == 'javascript'
        if executable('eslint')
            let output = system('eslint ' . shellescape(expand('%')))
        else
            echo "vimore: 未找到 JavaScript 代码检查工具"
            return
        endif
    else
        echo "vimore: 代码检查不支持的文件类型: " . ft
        return
    endif

    if empty(output)
        echo "检查通过，没有发现问题"
    else
        echo output
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
autocmd BufNewFile *.py,*.go,*.sh,*.c,*.cpp,*.java,*.js,*.ts,*.rs,*.lua call s:SetTitle()

function! s:SetTitle()
    if line('$') > 1 && getline(1) != ''
        return
    endif

    let date = strftime("%Y-%m-%d %H:%M:%S")

    if &filetype == 'python'
        call setline(1, "#!/usr/bin/env python3")
        call append(1, "# -*- coding: utf-8 -*-")
        call append(2, "\"\"\"")
        call append(3, "@Author: " . g:author)
        call append(4, "@Email: " . g:email)
        call append(5, "@Date: " . date)
        call append(6, "@Description: ")
        call append(7, "\"\"\"")
        call append(8, "")
    elseif &filetype == 'go'
        call setline(1, "package main")
        call append(1, "")
        call append(2, "func main() {")
        call append(3, "}")
        call append(4, "")
    elseif &filetype == 'sh'
        call setline(1, "#!/bin/bash")
        call append(1, "# Author: " . g:author)
        call append(2, "# Email: " . g:email)
        call append(3, "# Date: " . date)
        call append(4, "")
    elseif &filetype == 'c'
        call setline(1, "/*************************************************************************")
        call append(1, " * @file: ".expand("%"))
        call append(2, " * @author: " . g:author)
        call append(3, " * @email: " . g:email)
        call append(4, " * @date: " . date)
        call append(5, " * @description: ")
        call append(6, " ************************************************************************/")
        call append(7, "")
        call append(8, "#include <stdio.h>")
        call append(9, "#include <stdlib.h>")
        call append(10, "")
        call append(11, "int main(int argc, char *argv[]) {")
        call append(12, "    return 0;")
        call append(13, "}")
        call append(14, "")
    elseif &filetype == 'cpp'
        call setline(1, "/*************************************************************************")
        call append(1, " * @file: ".expand("%"))
        call append(2, " * @author: " . g:author)
        call append(3, " * @email: " . g:email)
        call append(4, " * @date: " . date)
        call append(5, " * @description: ")
        call append(6, " ************************************************************************/")
        call append(7, "")
        call append(8, "#include <iostream>")
        call append(9, "#include <vector>")
        call append(10, "#include <string>")
        call append(11, "#include <algorithm>")
        call append(12, "")
        call append(13, "using namespace std;")
        call append(14, "")
        call append(15, "int main(int argc, char *argv[]) {")
        call append(16, "    return 0;")
        call append(17, "}")
        call append(18, "")
    elseif &filetype == 'java'
        call setline(1, "/*")
        call append(1, " * @file: ".expand("%"))
        call append(2, " * @author: " . g:author)
        call append(3, " * @email: " . g:email)
        call append(4, " * @date: " . date)
        call append(5, " */")
        call append(6, "")
        call append(7, "public class ".expand("%:r"))
        call append(8, "{")
        call append(9, "    public static void main(String[] args) {")
        call append(10, "        System.out.println(\"Hello, World!\");")
        call append(11, "    }")
        call append(12, "}")
        call append(13, "")
    elseif &filetype == 'javascript'
        call setline(1, "/**")
        call append(1, " * @file: ".expand("%"))
        call append(2, " * @author: " . g:author)
        call append(3, " * @email: " . g:email)
        call append(4, " * @date: " . date)
        call append(5, " */")
        call append(6, "")
    endif
    normal G
endfunction

" ============================================================
" 21. 自动命令
" ============================================================
autocmd FocusGained,BufEnter * :silent! checktime
autocmd BufEnter * :silent! lcd %:p:h
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" ============================================================
" 22. 标签栏
" ============================================================
set showtabline=1

highlight clear TabLine
highlight clear TabLineSel
highlight clear TabLineFill

highlight TabLine       ctermfg=245 ctermbg=237 cterm=NONE
highlight TabLineSel    ctermfg=220 ctermbg=235 cterm=bold
highlight TabLineFill   ctermbg=237 cterm=NONE

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
        if len(bufname) > name_len
            let bufname = bufname[:name_len-2] . '…'
        endif

        let modified = getbufvar(buflist[winnr - 1], '&modified') ? '+' : ''
        let label = ' ' . i . ':' . bufname . modified
        let label = label . repeat(' ', width - len(label))

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
function! AddPair(pair)
    let map = {'(' : ')', '[' : ']', '{' : '}', '"' : '"', "'" : "'"}
    if !has_key(map, a:pair)
        echo "不支持的括号: " . a:pair
        return
    endif
    let left = a:pair
    let right = map[left]

    let start_pos = getpos("'<")
    let end_pos = getpos("'>")
    if start_pos[1] == 0 || end_pos[1] == 0
        echo "没有可视选区"
        return
    endif

    let start_line = start_pos[1]
    let end_line = end_pos[1]
    let start_col = start_pos[2]
    let end_col = end_pos[2]

    if start_line == end_line
        let line = getline(start_line)
        let prefix = start_col > 1 ? line[:start_col-2] : ''
        let new_line = prefix . left . line[start_col-1:end_col-1] . right . line[end_col:]
        call setline(start_line, new_line)
    else
        let first = getline(start_line)
        let last = getline(end_line)
        let prefix = start_col > 1 ? first[:start_col-2] : ''
        call setline(start_line, prefix . left . first[start_col-1:])
        call setline(end_line, last[:end_col-1] . right . last[end_col:])
    endif
endfunction

function! AddPairCode(code)
    call AddPair(nr2char(a:code))
endfunction

" === 菜单主体 ===
let g:leader_menu = {
            \ 'w':  {
            \ 'name': '写入',
            \ 'w': ['保存',           function('SaveAndClear')],
            \ 's': ['清理行尾空格',   function('StripTrailingWhitespaceManual')],
            \ 'c': ['统计字数',       function('WordCount')],
            \ },
            \ 'q':  ['退出',              ':silent! quit<CR>'],
            \ 'W':  ['全部保存',          ':silent! wall<CR>'],
            \ 'Q':  ['全部退出',          ':silent! qall<CR>'],
            \ 'h':  {
            \ 'name': '显示',
            \ 'h': ['取消搜索高亮',   ':nohlsearch<CR>'],
            \ 'x': ['十六进制模式',   ':%!xxd<CR>'],
            \ 'X': ['退出十六进制',   ':%!xxd -r<CR>'],
            \ },
            \ 'f':  ['格式化代码',        function('FormatCode')],
            \ 'c':  {
            \ 'name': '维护',
            \ 'c': ['代码检查',       function('CheckCode')],
            \ 'v': ['重新加载配置',   ':source $MYVIMRC<CR>'],
            \ 'e': ['编辑配置',       ':e $MYVIMRC<CR>'],
            \ },
            \ '/':  ['注释/取消注释',     function('ToggleComment')],
            \ 'b':  {
            \ 'name': '括号',
            \ 'd': {
            \ 'name': '删除指定括号对及其内容',
            \ '(': ['圆括号',  ':execute "normal! da" . nr2char(40)<CR>'],
            \ '[': ['方括号',  ':execute "normal! da" . nr2char(91)<CR>'],
            \ '{': ['花括号',  ':execute "normal! da" . nr2char(123)<CR>'],
            \ '"': ['双引号',  ':execute "normal! da" . nr2char(34)<CR>'],
            \ "'": ['单引号',  ':execute "normal! da" . nr2char(39)<CR>'],
            \ },
            \ 'a': {
            \ 'name': '在可视选区外添加指定括号',
            \ '(': ['圆括号',  ':call AddPair("(")<CR>'],
            \ '[': ['方括号',  ':call AddPair("[")<CR>'],
            \ '{': ['花括号',  ':call AddPair("{")<CR>'],
            \ '"': ['双引号',  ':call AddPairCode(34)<CR>'],
            \ "'": ['单引号',  ':call AddPairCode(39)<CR>'],
            \ },
            \ },
            \ 'r':  ['查看寄存器',        ':reg<CR>'],
            \ 'z':  {
            \ 'name': '视图',
            \ 'z': ['全部折叠',       ':normal! zM<CR>'],
            \ 'a': ['切换折叠',       ':normal! za<CR>'],
            \ 'Z': ['全部展开',       ':normal! zR<CR>'],
            \ },
            \ 'y':  ['复制到系统剪切板',  ':normal! "+yy<CR>'],
            \ 'p':  ['从系统剪切板粘贴',  ':normal! "+p<CR>'],
            \ 'P':  ['从系统剪切板粘贴(前)', ':normal! "+P<CR>'],
            \ 's':  {
            \ 'name': '整理',
            \ 'd': ['删除空行',       ':silent! g/^\s*$/d<CR>'],
            \ 's': ['排序选中行',     ':sort<CR>'],
            \ 'u': ['去重排序',       ':sort u<CR>'],
            \ 'n': ['数字排序',       ':sort n<CR>'],
            \ },
            \ 'g':  {
            \ 'name': 'Git',
            \ 's': ['git status',     ':!git status<CR>'],
            \ 'd': ['git diff',       ':!git diff<CR>'],
            \ 'l': ['git log',        ':!git log --oneline --graph<CR>'],
            \ 'a': ['git add',        ':!git add %<CR>'],
            \ 'c': ['git commit',     ':!git commit -m "<C-r>=input(''Commit: '')<CR>"<CR>'],
            \ 'p': ['git push',       ':!git push<CR>'],
            \ 'P': ['git pull',       ':!git pull<CR>'],
            \ },
            \ 't':  {
            \ 'name': '窗口',
            \ 't': ['底部终端',       ':call OpenTerminal("horizontal")<CR>'],
            \ 'v': ['右侧终端',       ':call OpenTerminal("vertical")<CR>'],
            \ 'r': ['运行当前文件',   function('RunInLatestTerminal')],
            \ 'k': ['切换/关闭终端',  function('ToggleTerminal')],
            \ 'n': ['新建标签',       ':tabnew<CR>'],
            \ 'e': ['新标签编辑当前', ':tabedit %<CR>'],
            \ 'c': ['关闭标签',       ':tabclose<CR>'],
            \ 'o': ['保留当前标签',   ':tabonly<CR>'],
            \ 'M': ['左移标签',       ':tabmove -1<CR>'],
            \ 'N': ['右移标签',       ':tabmove +1<CR>'],
            \ 'l': ['列出标签',       ':tabs<CR>'],
            \ 'u': ['恢复关闭标签',   ':tabnew #<CR>'],
            \ 'd': ['新标签打开目录', ':tabnew .<CR>'],
            \ 'f': ['文件浏览器',     ':Explore<CR>'],
            \ 'F': ['垂直文件浏览器', ':Vexplore<CR>']
            \ },
            \ }

" === 可视模式单独快捷键 ===
xnoremap <Leader>y "+y
xnoremap <Leader>p "+p
xnoremap <Leader>P "+P
xnoremap <silent> <Leader>/ :call ToggleCommentVisual()<CR>
xnoremap <silent> <Leader>s :sort<CR>
xnoremap <silent> <Leader>su :sort u<CR>
xnoremap <silent> <Leader>sn :sort n<CR>
xnoremap <C-x> "+x

" 缩进
xnoremap <silent> < <gv
xnoremap <silent> > >gv
" 缩进选区并保持选中（方便连续缩进）
vnoremap <silent> < <gv
vnoremap <silent> > >gv


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
            call add(sub_lines, printf(' %-6s <%s>', k, name))
        else
            " 叶子节点
            call add(leaf_lines, printf(' %-6s %s', k, item[0]))
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
            \ 'CheckCode'
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
        if l:cmd =~ '^:\(reg\|tabs\|marks\|jumps\|ls\|buffers\|messages\)\>'
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

" == 主提示循环 ==
function! s:LeaderPrompt(...)
    let silent_mode = a:0 > 0 ? a:1 : 0

    let save_mode = mode()
    let save_visual = (save_mode == 'v' || save_mode == 'V' || save_mode == "\<C-v>")
    let save_start = getpos("'<")
    let save_end = getpos("'>")
    let save_cur = getpos('.')

    let menu = g:leader_menu
    let prefix = ''

    while 1
        let lines = s:RenderMenu(menu, prefix)
        if empty(lines)
            let lines = [' (无可用命令)']
        endif

        let title = ' Leader ' . (prefix == '' ? '' : prefix . ' ')
        if has_key(menu, 'name')
            let title .= '- ' . menu['name'] . ' '
        endif

        if !silent_mode
            let width = 0
            for l in lines
                if len(l) > width | let width = len(l) | endif
            endfor
            if width < 24 | let width = 24 | endif

            if exists('*popup_create')
                let winid = popup_create(lines, #{
                            \ line: &lines - len(lines) - 3,
                            \ col: &columns - width - 4,
                            \ minwidth: width + 2,
                            \ maxwidth: width + 2,
                            \ padding: [0, 1, 0, 1],
                            \ title: title,
                            \ })
                redraw!
            else
                redraw
                echo title . "\n" . join(lines, "\n")
                let winid = -1
            endif
        else
            let winid = -1
        endif

        let char = getcharstr()

        if !silent_mode && exists('*popup_close') && winid != -1
            call popup_close(winid)
        endif
        if !silent_mode
            redraw
        endif

        if char == "\<Esc>"
            return
        endif

        if has_key(menu, char)
            let item = menu[char]
            if type(item) == v:t_dict
                let prefix .= char
                let menu = item
            else
                " 恢复选区，再执行
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
            return
        endif
    endwhile
endfunction

nnoremap <silent> <Leader> :call <SID>LeaderPrompt()<CR>
xnoremap <silent> <Leader> :<C-u>call <SID>LeaderPrompt(1)<CR>

