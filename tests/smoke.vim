" Vimore 冒烟测试：vim --clean -Nu Vimore.vimrc -es -S tests/smoke.vim
let s:failed = 0
let s:lines = []
let s:tmp = expand('$SMOKE_TMP')

function! s:Check(name, got, want) abort
    if a:got ==# a:want
        call add(s:lines, 'ok ' . a:name)
    else
        let s:failed += 1
        call add(s:lines, 'FAIL ' . a:name . ' got=' . string(a:got) . ' want=' . string(a:want))
    endif
endfunction

" 配置与按键
call s:Check('shortmess', &shortmess, 'aoOtT')
call s:Check('C-t 保持默认', maparg('<C-t>', 'n'), '')
call s:Check('j/k 保持默认', maparg('j', 'n') . maparg('k', 'n'), '')
call s:Check('插入 C-s 留在插入模式', maparg('<C-s>', 'i') =~# '<C-O>', 1)
call s:Check('F2 有普通模式映射', maparg('<F2>', 'n') != '', 1)
call s:Check('菜单入口', maparg('<Leader>', 'n') != '', 1)
call s:Check('自动 cd 默认关闭', get(g:, 'vimore_autochdir', -1), 0)
call s:Check('傀儡配色名', get(g:, 'colors_name', ''), 'vimore')
call s:Check('光标行不是下划线', execute('highlight CursorLine') =~# 'underline', 0)
call s:Check('标签栏可点击', MyTabLine() =~# '%1T', 1)
call s:Check('行尾空格显示为 ·', &list == 1 && &listchars =~# 'trail:·', 1)
call s:Check('工作目录后缀', &undodir =~# '//$', 1)
call s:Check('命令 VimoreMenu', exists(':VimoreMenu'), 2)
call s:Check('菜单标签英文', get(g:leader_menu['w'], 'name', '') ==# 'Write', 1)
call s:Check('命令 VimoreTutor', exists(':VimoreTutor'), 2)
call s:Check('命令 VimMaze', exists(':VimMaze'), 2)
call s:Check('命令 VimoreHealth', exists(':VimoreHealth'), 2)
call s:Check('命令 VimoreKeys', exists(':VimoreKeys'), 2)
call s:Check('updatetime', &updatetime, 250)
call s:Check('splitright/splitbelow', &splitright == 1 && &splitbelow == 1, 1)
" 缩进按语言分配
for [file, ft, width, expand] in [
      \ ['/tmp/vimore-indent.json', 'json', 2, 1],
      \ ['/tmp/vimore-indent.py', 'python', 4, 1],
      \ ['/tmp/vimore-indent.go', 'go', 4, 0],
      \ ['/tmp/vimore-indent.mk', 'make', 8, 0],
      \ ]
  execute 'edit ' . fnameescape(file)
  execute 'setlocal filetype=' . ft
  call s:Check('缩进 ' . ft, &tabstop == width && &shiftwidth == width && &expandtab == expand, 1)
endfor

" 文件头：Go 按目录推导 package，附加后缀也支持
call mkdir(s:tmp . '/my-proj', 'p')
execute 'edit ' . fnameescape(s:tmp . '/my-proj/x.go')
call s:Check('Go package', getline(1, '$')->filter('v:val =~# "^package "')->get(0, ''), 'package my_proj')
call s:Check('Go 头 Doxygen 字段', search('// @file    x.go', 'nw') > 0, 1)
bwipeout!
execute 'edit ' . fnameescape(s:tmp . '/x.cc')
call s:Check('cc 文件头', getline(1), '/**')
call s:Check('cc 头 Doxygen 字段', search(' \* @date    ', 'nw') > 0, 1)
" 容器末尾回车：右括号换行
enew!
call setline(1, 'local xs = [1, 2, 3]')
call cursor(1, 20)
call s:Check('容器拆分返回值', SplitContainerEnd(), 1)
call s:Check('容器拆分第一项', getline(2), '    1,')
call s:Check('容器拆分第二项', getline(3), '    2,')
call s:Check('容器拆分第三项', getline(4), '    3,')
call s:Check('容器拆分右括号', getline(5), ']')
" 只删包裹符号 / 换包裹符号
enew!
call setline(1, 'foo("bar")')
call cursor(1, 6)
call s:Check('删除双引号', DeleteSurround('"'), 1)
call s:Check('删除后保留内容', getline(1), 'foo(bar)')
call setline(1, 'foo((bar))')
call cursor(1, 6)
call s:Check('更换包裹符号', ChangeSurroundTo('"'), 1)
call s:Check('更换后保留内容', getline(1), 'foo("bar")')
bwipeout!
bwipeout!
execute 'edit ' . fnameescape(s:tmp . '/x.bash')
call s:Check('bash 文件头', getline(1), '#!/bin/sh')
bwipeout!

" 智能拆分尊重 noexpandtab
enew!
setlocal noexpandtab shiftwidth=4
call setline(1, 'func f() {}')
call cursor(1, 11)
call SplitPair()
call s:Check('noexpandtab 拆分', getline(2), "\t")
bwipeout!

" 行尾空格可关闭
enew!
call setline(1, 'x   ')
let g:vimore_strip_whitespace = 0
call StripTrailingWhitespace()
call s:Check('清理空格可关闭', getline(1), 'x   ')
let g:vimore_strip_whitespace = 1
call StripTrailingWhitespace()
call s:Check('清理空格默认开启', getline(1), 'x')
bwipeout!

" 可视选区外不能凭旧标记加括号
let g:vimore_from_visual = 0
enew!
call setline(1, 'abc')
call setpos("'<", [0, 1, 1, 0])
call setpos("'>", [0, 1, 3, 0])
call AddPair('(')
call s:Check('AddPair 需要可视选区', getline(1), 'abc')
bwipeout!

" 运行命令要给路径加引号
call mkdir(s:tmp . '/my dir', 'p')
execute 'edit ' . fnameescape(s:tmp . '/my dir/a b.c')
setfiletype c
call s:Check('运行命令转义', GetRunCommand() =~# shellescape(expand('%:p')), 1)
bwipeout!

if s:failed > 0
    call add(s:lines, s:failed . ' 项检查失败')
endif
call writefile(s:lines, s:tmp . '/smoke.out')
if s:failed > 0
    cquit 1
endif
qa!
