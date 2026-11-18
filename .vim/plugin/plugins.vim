" ============================================================
" 可选插件设置（没装插件时保持静默，不影响 Vim 启动）
" ============================================================
" === yegappan/lsp（Vim 9.0+，可选） ===
if has('vim9script') && !empty(globpath(&packpath, 'pack/*/opt/lsp', 1, 1))
    packadd lsp
endif

" 用命令行注册，没有插件时不会报 E117
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
        \   'path': 'pyright-langserver',
        \   'args': ['--stdio']
        \ },
        \ {
        \   'name': 'bash-language-server',
        \   'filetype': ['sh', 'bash'],
        \   'path': 'bash-language-server',
        \   'args': ['start']
        \ }
        \ ])
endif
