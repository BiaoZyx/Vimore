" ============================================================
" VimMaze - Vim 迷宫探索游戏
" 作者: BiaoZyx
" 版本: 1.1
" ============================================================

if exists('g:loaded_vimmaze')
  finish
endif
let g:loaded_vimmaze = 1

" ============================================================
" 1. 常量定义
" ============================================================
let s:CHAR_FLOOR  = ' '
let s:CHAR_PLAYER = '@'
let s:CHAR_EXIT   = '>'
let s:CHAR_CHEST  = '$'
let s:CHAR_KEY    = 'K'
let s:CHAR_DOOR   = 'D'
let s:CHAR_DOOR_OPEN = '*'
let s:CHAR_WALL   = '#'

let s:FREEZE_STEPS  = 10
let s:HINT_DURATION = 10000

" ============================================================
" 2. 全局状态
" ============================================================
let g:vm_player        = {}
let g:vm_maze          = []
let g:vm_level         = 1
let g:vm_max_level     = 7
let g:vm_score         = 0
let g:vm_steps         = 0
let g:vm_total_chests  = 0
let g:vm_opened_chests = 0
let g:vm_frozen        = 0
let g:vm_game_active   = 0
let g:vm_bufnr         = -1
let g:vm_hint_timer_id = -1
let g:vm_path_coords   = []
let g:vm_game_seed     = [0]
let g:vm_maze_original = []

" ============================================================
" 3. 预设关卡数据
" ============================================================
let s:LEVELS = []

call add(s:LEVELS, [
\ '###############',
\ '#@  $   #   > #',
\ '# # # # # # # #',
\ '# # $ #   #   #',
\ '# # # ### # # #',
\ '#   #   $ # # #',
\ '### # ### # # #',
\ '#   #   #   # #',
\ '# ### # ####  #',
\ '# $   #  $    #',
\ '# # ### ####  #',
\ '# #   #    K  #',
\ '# ### ####  # #',
\ '#   #      # D#',
\ '###############',
\ ])

call add(s:LEVELS, [
\ '#################',
\ '#@    $     #  >#',
\ '# # # # ### # # #',
\ '# # $   #   #   #',
\ '# # ### # ### # #',
\ '#   # $ #   # $ #',
\ '### # # # # # # #',
\ '#   # #   # #   #',
\ '# # # ### # ### #',
\ '# # $   #   #   #',
\ '# # # # ### # # #',
\ '#   # # $ # # K #',
\ '# # # # # # # # #',
\ '# # $   #   # D #',
\ '# # # # # ### # #',
\ '#       #       #',
\ '#################',
\ ])

call add(s:LEVELS, [
\ '###################',
\ '#@   $    #   $  >#',
\ '# # # # # # # # # #',
\ '# # $ #   #   #   #',
\ '# # # # # # # # # #',
\ '#   #     # $ #   #',
\ '### # # # # # # # #',
\ '#   # # #     #   #',
\ '# # # # # ### # # #',
\ '# #   #   # $ #   #',
\ '# # # ### # # # # #',
\ '#   #   $ #   # K #',
\ '# # # # # # # # # #',
\ '# # # $ #   #   D #',
\ '# # # # # # # # # #',
\ '#   #   #   #     #',
\ '# # # # # # # # # #',
\ '#       #       $ #',
\ '###################',
\ ])

call add(s:LEVELS, [
\ '#####################',
\ '#@   $      #    $ >#',
\ '# # # # # # # # # # #',
\ '# # $ #   #   #   # #',
\ '# # # # # # # # # # #',
\ '#   #     # $ #     #',
\ '### # # # # # # # # #',
\ '# $ # # #     # # $ #',
\ '# # # # # ### # # # #',
\ '# #   #   # $ #   # #',
\ '# # # # # # # # # # #',
\ '#   #   $ #   #   K #',
\ '# # # # # # # # # # #',
\ '# # $ #   # $ #   D #',
\ '# # # # # # # # # # #',
\ '#   #     #   #     #',
\ '# # # # # # # # # # #',
\ '# $ #   #   #   # $ #',
\ '# # # # # # # # # # #',
\ '#       #       #   #',
\ '#####################',
\ ])

call add(s:LEVELS, [
\ '#######################',
\ '#@   $      #    $   >#',
\ '# # # # # # # # # # # #',
\ '# # $ #   #   #   #   #',
\ '# # # # # # # # # # # #',
\ '#   #     # $ #     $ #',
\ '### # # # # # # # # # #',
\ '# $ # # #     # # # $ #',
\ '# # # # # ### # # # # #',
\ '# #   #   # $ #   #   #',
\ '# # # # # # # # # # # #',
\ '#   #   $ #   #   $ K #',
\ '# # # # # # # # # # # #',
\ '# # $ #   # $ #   # D #',
\ '# # # # # # # # # # # #',
\ '#   #     #   #     $ #',
\ '# # # # # # # # # # # #',
\ '# $ #   #   #   # # $ #',
\ '# # # # # # # # # # # #',
\ '#   # $ #   # $ #   # #',
\ '# # # # # # # # # # # #',
\ '# $   #       #   $   #',
\ '#######################',
\ ])

call add(s:LEVELS, [
\ '#########################',
\ '#@   $      #    $     >#',
\ '# # # # # # # # # # # # #',
\ '# # $ #   #   #   #   $ #',
\ '# # # # # # # # # # # # #',
\ '#   #     # $ #     $   #',
\ '### # # # # # # # # # # #',
\ '# $ # # #     # # # # $ #',
\ '# # # # # ### # # # # # #',
\ '# #   #   # $ #   #     #',
\ '# # # # # # # # # # # # #',
\ '#   #   $ #   #   $   K #',
\ '# # # # # # # # # # # # #',
\ '# # $ #   # $ #   # # D #',
\ '# # # # # # # # # # # # #',
\ '#   #     #   #     $   #',
\ '# # # # # # # # # # # # #',
\ '# $ #   #   #   # # # $ #',
\ '# # # # # # # # # # # # #',
\ '#   # $ #   # $ #   #   #',
\ '# # # # # # # # # # # # #',
\ '# $ # $ #   #   #   # $ #',
\ '# # # # # # # # # # # # #',
\ '#   $   #       #   $   #',
\ '#########################',
\ ])

call add(s:LEVELS, [
\ '###########################',
\ '#@   $      #    $       >#',
\ '# # # # # # # # # # # # # #',
\ '# # $ #   #   #   #   # $ #',
\ '# # # # # # # # # # # # # #',
\ '#   #     # $ #     $     #',
\ '### # # # # # # # # # # # #',
\ '# $ # # #     # # # # # $ #',
\ '# # # # # ### # # # # # # #',
\ '# #   #   # $ #   #       #',
\ '# # # # # # # # # # # # # #',
\ '#   #   $ #   #   $     K #',
\ '# # # # # # # # # # # # # #',
\ '# # $ #   # $ #   # # # D #',
\ '# # # # # # # # # # # # # #',
\ '#   #     #   #     $     #',
\ '# # # # # # # # # # # # # #',
\ '# $ #   #   #   # # # # $ #',
\ '# # # # # # # # # # # # # #',
\ '#   # $ #   # $ #   #     #',
\ '# # # # # # # # # # # # # #',
\ '# $ # $ #   #   #   # # $ #',
\ '# # # # # # # # # # # # # #',
\ '#   $ # $ #       #   # $ #',
\ '# # # # # # # # # # # # # #',
\ '# $   #       #       $   #',
\ '###########################',
\ ])

" ============================================================
" 4. Box Drawing 墙壁渲染
" ============================================================
function! s:WallChar(u, d, l, r) abort
  if a:u && a:d && a:l && a:r
    return '┼'
  elseif a:u && a:d && a:l && !a:r
    return '┤'
  elseif a:u && a:d && !a:l && a:r
    return '├'
  elseif a:u && !a:d && a:l && a:r
    return '┴'
  elseif !a:u && a:d && a:l && a:r
    return '┬'
  elseif a:u && a:l
    return '┘'
  elseif a:u && a:r
    return '└'
  elseif a:d && a:l
    return '┐'
  elseif a:d && a:r
    return '┌'
  elseif a:u || a:d
    return '│'
  elseif a:l || a:r
    return '─'
  endif
  return '·'
endfunction

function! s:RenderMaze() abort
  if g:vm_bufnr == -1 || !bufexists(g:vm_bufnr)
    return
  endif

  let l:rows = len(g:vm_maze)
  let l:cols = len(g:vm_maze[0])

  " 创建渲染副本
  let l:disp = []
  for l:row in g:vm_maze
    call add(l:disp, copy(l:row))
  endfor

  " 将 # 转换为制表符字符
  for l:r in range(l:rows)
    for l:c in range(l:cols)
      if l:disp[l:r][l:c] == s:CHAR_WALL
        let l:u = (l:r > 0          && g:vm_maze[l:r-1][l:c] == s:CHAR_WALL)
        let l:d = (l:r < l:rows - 1 && g:vm_maze[l:r+1][l:c] == s:CHAR_WALL)
        let l:lc= (l:c > 0          && g:vm_maze[l:r][l:c-1] == s:CHAR_WALL)
        let l:rc= (l:c < l:cols - 1 && g:vm_maze[l:r][l:c+1] == s:CHAR_WALL)
        let l:disp[l:r][l:c] = s:WallChar(l:u, l:d, l:lc, l:rc)
      endif
    endfor
  endfor

  " 放入玩家
  let l:disp[g:vm_player.row][g:vm_player.col] = s:CHAR_PLAYER

  " 组装边框
  let l:lines = []
  call add(l:lines, '╔' . repeat('═', l:cols) . '╗')
  for l:row in l:disp
    call add(l:lines, '║' . join(l:row, '') . '║')
  endfor
  call add(l:lines, '╚' . repeat('═', l:cols) . '╝')
  call add(l:lines, '  hjkl:移动 e/空格:拾取 s:保存 L:读取 r:重试 R:新游戏 q:退出 ?:帮助')

  " 写入 buffer
  call setbufvar(g:vm_bufnr, '&modifiable', 1)
  " 清空旧内容
  let l:old_lines = line('$', g:vm_bufnr)
  if l:old_lines > len(l:lines)
    call deletebufline(g:vm_bufnr, len(l:lines) + 1, l:old_lines)
  endif
  call setbufline(g:vm_bufnr, 1, s:BuildHud())
  call setbufline(g:vm_bufnr, 2, l:lines)
  call setbufvar(g:vm_bufnr, '&modifiable', 0)

  " 重新应用高亮
  call s:ReapplyHighlights()

  " 顶栏和底栏高亮
  call matchadd('VimMazeHud', '^  VimMaze.*', 2)
  call matchadd('VimMazeBar', '^  hjkl:.*', 2)

  redraw
  echo ''
endfunction

function! s:BuildHud() abort
  let l:lv = g:vm_level == 0 ? '无尽' : g:vm_level . '/' . g:vm_max_level
  let l:fr = g:vm_frozen > 0 ? '  [冻结:' . g:vm_frozen . '步]' : ''
  return '  VimMaze  第' . l:lv . '关'
        \ . '  钥匙:' . g:vm_player.keys
        \ . '  宝箱:' . g:vm_opened_chests . '/' . g:vm_total_chests
        \ . '  步数:' . g:vm_steps
        \ . '  分数:' . g:vm_score
        \ . l:fr
endfunction

" ============================================================
" 4. 高亮
" ============================================================
function! s:SetupHighlights() abort
  highlight VimMazeWall     guifg=#555555 ctermfg=darkgray
  highlight VimMazePlayer   guifg=#00ff00 ctermfg=green  gui=bold cterm=bold
  highlight VimMazeExit     guifg=#ffff00 ctermfg=yellow gui=bold cterm=bold
  highlight VimMazeChest    guifg=#ff8800 ctermfg=darkyellow
  highlight VimMazeKey      guifg=#00ffff ctermfg=cyan   gui=bold cterm=bold
  highlight VimMazeDoor     guifg=#ff0000 ctermfg=red    gui=bold cterm=bold
  highlight VimMazePath     guifg=#5555ff ctermfg=blue
  highlight VimMazeHud      guifg=#ffffff ctermfg=white  guibg=#333333 ctermbg=darkgray
  highlight VimMazeBar      guifg=#aaaaaa ctermfg=gray   guibg=#222222 ctermbg=black
  highlight VimMazeWin      guifg=#00ff00 ctermfg=green  gui=bold cterm=bold
endfunction

function! s:ReapplyHighlights() abort
  if exists('s:match_ids')
    for l:id in s:match_ids
      silent! call matchdelete(l:id)
    endfor
  endif
  let s:match_ids = []
  call add(s:match_ids, matchadd('VimMazeWall',   '[─│┌┐└┘├┤┬┴┼╔╗╚╝═║]', 1))
  call add(s:match_ids, matchadd('VimMazePlayer', '@',  10))
  call add(s:match_ids, matchadd('VimMazeExit',   '>',  10))
  call add(s:match_ids, matchadd('VimMazeChest',  '\$', 10))
  call add(s:match_ids, matchadd('VimMazeKey',    'K',  10))
  call add(s:match_ids, matchadd('VimMazeDoor',   '[D*]', 10))
  call add(s:match_ids, matchadd('VimMazePath',   '·', 5))
endfunction

" ============================================================
" 5. 输入处理
" ============================================================
function! s:SetupKeymaps() abort
  nnoremap <silent> <buffer> h :call <SID>Move(2)<CR>
  nnoremap <silent> <buffer> j :call <SID>Move(1)<CR>
  nnoremap <silent> <buffer> k :call <SID>Move(0)<CR>
  nnoremap <silent> <buffer> l :call <SID>Move(3)<CR>
  nnoremap <silent> <buffer> <Up>    :call <SID>Move(0)<CR>
  nnoremap <silent> <buffer> <Down>  :call <SID>Move(1)<CR>
  nnoremap <silent> <buffer> <Left>  :call <SID>Move(2)<CR>
  nnoremap <silent> <buffer> <Right> :call <SID>Move(3)<CR>
  nnoremap <silent> <buffer> <Space> :call <SID>Interact()<CR>
  nnoremap <silent> <buffer> e        :call <SID>Interact()<CR>
  nnoremap <silent> <buffer> r        :call <SID>RestartLevel()<CR>
  nnoremap <silent> <buffer> R        :call <SID>StartEndless()<CR>
  nnoremap <silent> <buffer> q        :call <SID>QuitGame()<CR>
  nnoremap <silent> <buffer> ?        :call <SID>ShowHelp()<CR>
  nnoremap <silent> <buffer> s        :call <SID>SaveGame()<CR>
  nnoremap <silent> <buffer> L        :call <SID>LoadSavedGame()<CR>
endfunction

function! s:RestoreKeymaps() abort
  for l:key in ['h','j','k','l','e','r','R','q','?','s','L']
    execute 'silent! unmap <buffer>' l:key
  endfor
  for l:key in ['<Up>','<Down>','<Left>','<Right>','<Space>']
    execute 'silent! unmap <buffer>' l:key
  endfor
endfunction

function! s:SaveGame() abort
  let l:save_dir = expand('~/.vimmaze')
  if !isdirectory(l:save_dir)
    call mkdir(l:save_dir, 'p')
  endif

  let l:name = input('  存档名称: ')
  if empty(l:name)
    echo '  已取消'
    return
  endif

  let l:save_file = l:save_dir . '/' . l:name . '.dat'

  let l:data = {
        \ 'level': g:vm_level,
        \ 'score': g:vm_score,
        \ 'steps': g:vm_steps,
        \ 'player': g:vm_player,
        \ 'frozen': g:vm_frozen,
        \ 'maze': g:vm_maze,
        \ 'total_chests': g:vm_total_chests,
        \ 'opened_chests': g:vm_opened_chests,
        \ }
  call writefile([json_encode(l:data)], l:save_file)
  echohl VimMazeKey | echon '  已保存: ' . l:name | echohl None
endfunction

function! s:LoadSavedGame() abort
  let l:save_dir = expand('~/.vimmaze')
  if !isdirectory(l:save_dir)
    echohl VimMazeDoor | echon '  没有存档!' | echohl None
    return
  endif

  let l:saves = split(glob(l:save_dir . '/*.dat'), "\n")
  if empty(l:saves)
    echohl VimMazeDoor | echon '  没有存档!' | echohl None
    return
  endif

  " 显示存档列表
  let l:list = []
  for l:s in l:saves
    call add(l:list, fnamemodify(l:s, ':t:r'))
  endfor
  echo '  可用存档: ' . join(l:list, ', ')

  let l:name = input('  读取哪个存档? ')
  if empty(l:name)
    echo '  已取消'
    return
  endif

  let l:save_file = l:save_dir . '/' . l:name . '.dat'
  if !filereadable(l:save_file)
    echohl VimMazeDoor | echon '  存档不存在: ' . l:name | echohl None
    return
  endif

  let l:lines = readfile(l:save_file)
  let l:data = json_decode(l:lines[0])

  let g:vm_level = l:data.level
  let g:vm_score = l:data.score
  let g:vm_steps = l:data.steps
  let g:vm_player = l:data.player
  let g:vm_frozen = l:data.frozen
  let g:vm_maze = l:data.maze
  let g:vm_total_chests = l:data.total_chests
  let g:vm_opened_chests = l:data.opened_chests
  let g:vm_game_active = 1

  call s:RenderMaze()
  echohl VimMazeKey | echon '  已加载: ' . l:name | echohl None
endfunction

" ============================================================
" 6. 游戏逻辑
" ============================================================
function! s:Move(dir) abort
  if !g:vm_game_active | return | endif

  let l:dr = [-1, 1, 0, 0][a:dir]
  let l:dc = [0, 0, -1, 1][a:dir]
  let l:nr = g:vm_player.row + l:dr
  let l:nc = g:vm_player.col + l:dc

  if l:nr < 0 || l:nr >= len(g:vm_maze) || l:nc < 0 || l:nc >= len(g:vm_maze[0])
    return
  endif

  let l:target = g:vm_maze[l:nr][l:nc]

  if l:target == s:CHAR_WALL
    return
  endif

  if l:target == s:CHAR_DOOR
    if g:vm_player.keys > 0
      let g:vm_player.keys -= 1
      let g:vm_maze[l:nr][l:nc] = s:CHAR_DOOR_OPEN
      let g:vm_score += 30
    else
      return
    endif
  endif

  if l:target == s:CHAR_CHEST
    call s:OpenChest(l:nr, l:nc)
    let g:vm_player.row = l:nr
    let g:vm_player.col = l:nc
    call s:RenderMaze()
    return
  endif

  if l:target == s:CHAR_KEY
    let g:vm_player.keys += 1
    let g:vm_maze[l:nr][l:nc] = s:CHAR_FLOOR
    echohl VimMazeKey | echon '  获得钥匙!' | echohl None
  endif

  let g:vm_player.row = l:nr
  let g:vm_player.col = l:nc

  let g:vm_steps += 1
  if g:vm_frozen > 0
    let g:vm_frozen -= 1
  elseif g:vm_steps % 10 == 0
    let g:vm_score = max([0, g:vm_score - 5])
  endif

  call s:CheckWin()
  call s:RenderMaze()
endfunction

function! s:Interact() abort
  if !g:vm_game_active | return | endif

  let l:offsets = [[-1,0],[1,0],[0,-1],[0,1]]
  for [l:dr, l:dc] in l:offsets
    let l:r = g:vm_player.row + l:dr
    let l:c = g:vm_player.col + l:dc
    if l:r >= 0 && l:r < len(g:vm_maze) && l:c >= 0 && l:c < len(g:vm_maze[0])
      if g:vm_maze[l:r][l:c] == s:CHAR_CHEST
        call s:OpenChest(l:r, l:c)
        return
      endif
    endif
  endfor
endfunction

function! s:Rand() abort
  let l:t = reltime()
  return l:t[1] % 1000000
endfunction

function! s:OpenChest(row, col) abort
  let g:vm_maze[a:row][a:col] = s:CHAR_FLOOR
  let g:vm_opened_chests += 1

  let l:roll = s:Rand() % 100
  if l:roll < 40
    let g:vm_score += 100
    echohl VimMazeChest  | echon '  宝箱: +100分!' | echohl None
  elseif l:roll < 70
    let g:vm_player.keys += 1
    echohl VimMazeKey    | echon '  宝箱: 获得钥匙!' | echohl None
  elseif l:roll < 90
    let g:vm_frozen += s:FREEZE_STEPS
    echohl VimMazeExit   | echon '  宝箱: 时间冻结! 10步免罚' | echohl None
  else
    call s:ShowPathHint()
    echohl VimMazePath   | echon '  宝箱: 路径提示!' | echohl None
  endif

  call s:RenderMaze()
endfunction

function! s:CheckWin() abort
  if g:vm_maze[g:vm_player.row][g:vm_player.col] != s:CHAR_EXIT
    return
  endif
  let g:vm_score += 200
  let g:vm_game_active = 0

  " 显示通关动画 - 角色变点
  call s:ShowWinAnimation()
  sleep 1

  if g:vm_level > 0 && g:vm_level < g:vm_max_level
    call s:LoadLevel(g:vm_level + 1)
  else
    let g:vm_score += 500
    call s:StartEndless()
  endif
endfunction

function! s:ShowWinAnimation() abort
  " 在出口位置显示点
  let l:disp = copy(g:vm_maze)
  for l:r in range(len(l:disp))
    for l:c in range(len(l:disp[l:r]))
      if l:disp[l:r][l:c] == s:CHAR_WALL
        " 保持墙壁
      endif
    endfor
  endfor

  " 渲染一个简化的胜利画面
  let l:lines = []
  let l:cols = len(g:vm_maze[0])
  call add(l:lines, '╔' . repeat('═', l:cols) . '╗')
  for l:row in g:vm_maze
    let l:line = '║' . join(l:row, '') . '║'
    call add(l:lines, l:line)
  endfor
  call add(l:lines, '╚' . repeat('═', l:cols) . '╝')
  call add(l:lines, '  恭喜通关! +200分  总分: ' . g:vm_score)

  call setbufvar(g:vm_bufnr, '&modifiable', 1)
  call setbufline(g:vm_bufnr, 1, s:BuildHud())
  call setbufline(g:vm_bufnr, 2, l:lines)
  call setbufvar(g:vm_bufnr, '&modifiable', 0)

  call s:ReapplyHighlights()
  call matchadd('VimMazeHud', '^  VimMaze.*', 2)
  call matchadd('VimMazeBar', '^  .*通关.*', 2)
  redraw
endfunction

" ============================================================
" 7. 路径提示
" ============================================================
function! s:ShowPathHint() abort
  let l:path = s:FindPath(g:vm_player.row, g:vm_player.col)
  if empty(l:path) | return | endif

  for [l:r, l:c] in l:path
    if g:vm_maze[l:r][l:c] == s:CHAR_FLOOR
      let g:vm_maze[l:r][l:c] = '·'
      call add(g:vm_path_coords, [l:r, l:c])
    endif
  endfor
  call s:RenderMaze()

  if g:vm_hint_timer_id != -1
    call timer_stop(g:vm_hint_timer_id)
  endif
  let g:vm_hint_timer_id = timer_start(s:HINT_DURATION, function('s:ClearPathHint'))
endfunction

function! s:ClearPathHint(timer) abort
  for [l:r, l:c] in g:vm_path_coords
    if g:vm_maze[l:r][l:c] == '·'
      let g:vm_maze[l:r][l:c] = s:CHAR_FLOOR
    endif
  endfor
  let g:vm_path_coords = []
  let g:vm_hint_timer_id = -1
  call s:RenderMaze()
endfunction

function! s:FindPath(sr, sc) abort
  let l:rows = len(g:vm_maze)
  let l:cols = len(g:vm_maze[0])
  let l:vis = {}
  let l:par = {}
  let l:q = [[a:sr, a:sc]]
  let l:sk = a:sr . ',' . a:sc
  let l:vis[l:sk] = 1

  while !empty(l:q)
    let [l:r, l:c] = remove(l:q, 0)
    let l:ck = l:r . ',' . l:c

    if g:vm_maze[l:r][l:c] == s:CHAR_EXIT
      let l:path = []
      let l:k = l:ck
      while has_key(l:par, l:k)
        call add(l:path, split(l:k, ',')->map('str2nr(v:val)'))
        let l:k = l:par[l:k]
      endwhile
      return l:path
    endif

    for [l:dr, l:dc] in [[0,1],[0,-1],[1,0],[-1,0]]
      let l:nr = l:r + l:dr
      let l:nc = l:c + l:dc
      let l:nk = l:nr . ',' . l:nc
      if l:nr >= 0 && l:nr < l:rows && l:nc >= 0 && l:nc < l:cols
            \ && !has_key(l:vis, l:nk)
            \ && g:vm_maze[l:nr][l:nc] != s:CHAR_WALL
            \ && g:vm_maze[l:nr][l:nc] != s:CHAR_DOOR
        let l:vis[l:nk] = 1
        let l:par[l:nk] = l:ck
        call add(l:q, [l:nr, l:nc])
      endif
    endfor
  endwhile
  return []
endfunction

" ============================================================
" 8. 关卡管理
" ============================================================
function! s:LoadLevel(level_num) abort
  if a:level_num > 0 && a:level_num <= len(s:LEVELS)
    let l:raw = copy(s:LEVELS[a:level_num - 1])
  else
    let l:raw = s:GenerateMaze(15 + a:level_num * 2, 15 + a:level_num * 2)
  endif

  let g:vm_maze = []
  let g:vm_total_chests = 0
  let g:vm_opened_chests = 0

  for l:line in l:raw
    call add(g:vm_maze, split(l:line, '\zs'))
  endfor

  " 统计宝箱、找到玩家
  for l:r in range(len(g:vm_maze))
    for l:c in range(len(g:vm_maze[l:r]))
      if g:vm_maze[l:r][l:c] == s:CHAR_CHEST
        let g:vm_total_chests += 1
      endif
      if g:vm_maze[l:r][l:c] == s:CHAR_PLAYER
        let g:vm_player = {'row': l:r, 'col': l:c, 'keys': 0}
        let g:vm_maze[l:r][l:c] = s:CHAR_FLOOR
      endif
    endfor
  endfor

  let g:vm_level = a:level_num
  let g:vm_steps = 0
  let g:vm_frozen = 0
  let g:vm_game_active = 1

  call s:ClearPathHint(-1)
  call s:RenderMaze()
endfunction

function! s:RestartLevel() abort
  call s:ClearPathHint(-1)
  call s:StartEndless()
endfunction

function! s:StartEndless() abort
  let l:raw = s:GenerateMaze(31, 31)
  let g:vm_maze_original = l:raw
  let g:vm_maze = []
  let g:vm_total_chests = 0
  let g:vm_opened_chests = 0

  for l:line in l:raw
    call add(g:vm_maze, split(l:line, '\zs'))
  endfor

  for l:r in range(len(g:vm_maze))
    for l:c in range(len(g:vm_maze[l:r]))
      if g:vm_maze[l:r][l:c] == s:CHAR_CHEST
        let g:vm_total_chests += 1
      endif
      if g:vm_maze[l:r][l:c] == s:CHAR_PLAYER
        let g:vm_player = {'row': l:r, 'col': l:c, 'keys': 0}
        let g:vm_maze[l:r][l:c] = s:CHAR_FLOOR
      endif
    endfor
  endfor

  let g:vm_level = 0
  let g:vm_steps = 0
  let g:vm_frozen = 0
  let g:vm_game_active = 1

  call s:ClearPathHint(-1)
  call s:RenderMaze()
endfunction

function! s:RestartLevel() abort
  if empty(g:vm_maze_original)
    call s:StartEndless()
    return
  endif

  " 从原始数据重载迷宫
  let g:vm_maze = []
  let g:vm_total_chests = 0
  let g:vm_opened_chests = 0

  for l:line in g:vm_maze_original
    call add(g:vm_maze, split(l:line, '\zs'))
  endfor

  " 找到起点并重置玩家
  for l:r in range(len(g:vm_maze))
    for l:c in range(len(g:vm_maze[l:r]))
      if g:vm_maze[l:r][l:c] == s:CHAR_CHEST
        let g:vm_total_chests += 1
      endif
      if g:vm_maze[l:r][l:c] == s:CHAR_PLAYER
        let g:vm_player = {'row': l:r, 'col': l:c, 'keys': 0}
        let g:vm_maze[l:r][l:c] = s:CHAR_FLOOR
      endif
    endfor
  endfor

  " 完全重置所有游戏状态
  let g:vm_steps = 0
  let g:vm_frozen = 0
  let g:vm_score = 0
  let g:vm_game_active = 1

  call s:ClearPathHint(-1)
  call s:RenderMaze()
endfunction

" ============================================================
" 9. 随机迷宫生成 (递归回溯)
" ============================================================
function! s:GenerateMaze(w, h) abort
  let g:vm_game_seed = srand()
  let l:mw = (a:w - 1) / 2
  let l:mh = (a:h - 1) / 2

  " 全墙
  let l:grid = []
  for l:y in range(a:h)
    let l:row = []
    for l:x in range(a:w)
      call add(l:row, s:CHAR_WALL)
    endfor
    call add(l:grid, l:row)
  endfor

  " 递归回溯
  let l:vis = {}
  let l:st = []
  let l:sx = s:Rand() % l:mw
  let l:sy = s:Rand() % l:mh
  let l:grid[l:sy * 2 + 1][l:sx * 2 + 1] = s:CHAR_FLOOR
  let l:vis[l:sx . ',' . l:sy] = 1
  call add(l:st, [l:sx, l:sy])

  while !empty(l:st)
    let [l:cx, l:cy] = l:st[-1]
    let l:nb = []
    for [l:dx, l:dy] in [[0,-1],[0,1],[-1,0],[1,0]]
      let l:nx = l:cx + l:dx
      let l:ny = l:cy + l:dy
      if l:nx >= 0 && l:nx < l:mw && l:ny >= 0 && l:ny < l:mh
            \ && !has_key(l:vis, l:nx . ',' . l:ny)
        call add(l:nb, [l:nx, l:ny, l:dx, l:dy])
      endif
    endfor
    if !empty(l:nb)
      let [l:nx, l:ny, l:dx, l:dy] = l:nb[s:Rand() % len(l:nb)]
      let l:grid[l:cy * 2 + 1 + l:dy][l:cx * 2 + 1 + l:dx] = s:CHAR_FLOOR
      let l:grid[l:ny * 2 + 1][l:nx * 2 + 1] = s:CHAR_FLOOR
      let l:vis[l:nx . ',' . l:ny] = 1
      call add(l:st, [l:nx, l:ny])
    else
      call remove(l:st, -1)
    endif
  endwhile

  " 放置玩家、出口
  let l:grid[1][1] = s:CHAR_PLAYER
  let l:grid[a:h - 2][a:w - 2] = s:CHAR_EXIT

  " 放置宝箱
  let l:cnt = 3 + s:Rand() % 4
  let l:n = 0
  while l:n < l:cnt
    let l:rx = s:Rand() % (a:w - 2) + 1
    let l:ry = s:Rand() % (a:h - 2) + 1
    if l:grid[l:ry][l:rx] == s:CHAR_FLOOR
          \ && !(l:rx == 1 && l:ry == 1)
          \ && !(l:rx == a:w - 2 && l:ry == a:h - 2)
      let l:grid[l:ry][l:rx] = s:CHAR_CHEST
      let l:n += 1
    endif
  endwhile

  " 放置钥匙
  let l:cnt = 1 + s:Rand() % 2
  let l:n = 0
  while l:n < l:cnt
    let l:rx = s:Rand() % (a:w - 2) + 1
    let l:ry = s:Rand() % (a:h - 2) + 1
    if l:grid[l:ry][l:rx] == s:CHAR_FLOOR && !(l:rx == 1 && l:ry == 1)
      let l:grid[l:ry][l:rx] = s:CHAR_KEY
      let l:n += 1
    endif
  endwhile

  " 放置门 - 找到路径中点，确保门真正挡住去路
  let l:path = s:BfsPath(l:grid, [1,1], [a:w-2, a:h-2])
  if len(l:path) > 4
    let l:mid = l:path[len(l:path) / 2]
    let l:grid[l:mid[1]][l:mid[0]] = s:CHAR_DOOR
  else
    while 1
      let l:rx = s:Rand() % (a:w - 4) + 2
      let l:ry = s:Rand() % (a:h - 4) + 2
      if l:grid[l:ry][l:rx] == s:CHAR_FLOOR
        let l:grid[l:ry][l:rx] = s:CHAR_DOOR
        break
      endif
    endwhile
  endif

  let l:result = []
  for l:row in l:grid
    call add(l:result, join(l:row, ''))
  endfor
  return l:result
endfunction

function! s:BfsPath(grid, start, goal) abort
  let l:rows = len(a:grid)
  let l:cols = len(a:grid[0])
  let l:vis = {}
  let l:par = {}
  let l:q = [a:start]
  let l:sk = a:start[0] . ',' . a:start[1]
  let l:vis[l:sk] = 1

  while !empty(l:q)
    let [l:x, l:y] = remove(l:q, 0)
    if l:x == a:goal[0] && l:y == a:goal[1]
      let l:path = []
      let l:k = l:x . ',' . l:y
      while has_key(l:par, l:k)
        let [l:px, l:py] = split(l:k, ',')->map('str2nr(v:val)')
        call add(l:path, [l:px, l:py])
        let l:k = l:par[l:k]
      endwhile
      call add(l:path, a:start)
      return reverse(l:path)
    endif
    for [l:dx, l:dy] in [[0,1],[0,-1],[1,0],[-1,0]]
      let l:nx = l:x + l:dx
      let l:ny = l:y + l:dy
      let l:nk = l:nx . ',' . l:ny
      if l:nx >= 0 && l:nx < l:cols && l:ny >= 0 && l:ny < l:rows
            \ && !has_key(l:vis, l:nk)
            \ && a:grid[l:ny][l:nx] != s:CHAR_WALL
        let l:vis[l:nk] = 1
        let l:par[l:nk] = l:x . ',' . l:y
        call add(l:q, [l:nx, l:ny])
      endif
    endfor
  endwhile
  return []
endfunction

" ============================================================
" 10. 辅助
" ============================================================
function! s:ShowHelp() abort
  echo ''
  echo '  ╔══════════════════════════════════╗'
  echo '  ║       VimMaze 操作帮助           ║'
  echo '  ╠══════════════════════════════════╣'
  echo '  ║  h/j/k/l 或 方向键  -  移动     ║'
  echo '  ║  e / 空格           -  拾取     ║'
  echo '  ║  r                  -  重试      ║'
  echo '  ║  R                  -  新游戏    ║'
  echo '  ║  s                  -  保存游戏  ║'
  echo '  ║  L                  -  读取存档  ║'
  echo '  ║  q                  -  退出游戏  ║'
  echo '  ║  ?                  -  显示帮助  ║'
  echo '  ╠══════════════════════════════════╣'
  echo '  ║  $ = 宝箱   K = 钥匙   D = 门   ║'
  echo '  ║  > = 出口   @ = 玩家             ║'
  echo '  ╠══════════════════════════════════╣'
  echo '  ║  规则:                            ║'
  echo '  ║  · 找到钥匙(K)开门(D)到达出口(>) ║'
  echo '  ║  · 拾取宝箱($)获得奖励或钥匙     ║'
  echo '  ║  · 每10步扣5分，冻结可免扣       ║'
  echo '  ╚══════════════════════════════════╝'
  echo ''
endfunction

function! s:QuitGame() abort
  let g:vm_game_active = 0
  if g:vm_hint_timer_id != -1
    call timer_stop(g:vm_hint_timer_id)
    let g:vm_hint_timer_id = -1
  endif
  call s:RestoreKeymaps()
  bwipeout!
  echo '  游戏已退出'
endfunction

function! s:CreateGameBuffer() abort
  if g:vm_bufnr != -1 && bufexists(g:vm_bufnr)
    bwipeout!
  endif
  enew
  let g:vm_bufnr = bufnr('%')
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nomodifiable
  setlocal nobuflisted
  setlocal nospell
  setlocal nonumber
  setlocal norelativenumber
  setlocal nocursorline
  setlocal nocursorcolumn
  setlocal nofoldenable
  setlocal nowrap
  setlocal filetype=vimmaze
endfunction

" ============================================================
" 11. 启动入口
" ============================================================
function! VimMaze#Start() abort
  call s:SetupHighlights()
  call s:CreateGameBuffer()
  call s:SetupKeymaps()
  call s:StartEndless()
endfunction

command! VimMaze call VimMaze#Start()
