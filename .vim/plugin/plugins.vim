" ============================================================
" 插件设置
" ============================================================
" === yegappan/lsp(Vim 9.0+) ===
if has('vim9script')
    packadd lsp

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
        \   path: 'pyright-langserver',
        \   args: ['--stdio']
        \ },
        \ #{
        \   name: 'bash-language-server',
        \   filetype: ['sh', 'bash'],
        \   path: 'bash-language-server',
        \   args: ['start']
        \ }
        \ ])
endif


