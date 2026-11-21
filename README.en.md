# Vimore

> Less is more.

English quick reference. The Chinese [README](README.md) and the interactive
tutorials in `tutor/` are the canonical documentation.

Vimore is a single-file Vim configuration written in pure Vimscript. No plugin
manager, no LSP dependency, no external tools required for core editing. Copy
`Vimore.vimrc` to `~/.vimrc` and it just works; runtime messages, menu labels
and keymap descriptions are in English.

## Install

```bash
# minimal: one file, full core feature set
./setup.sh --minimal

# full: repo + symlink + tutorial + VimMaze (author/email are prompted)
./setup.sh

# non-interactive
VIMORE_AUTHOR='Your Name' VIMORE_EMAIL='you@example.com' ./setup.sh

# skip .bak creation
./setup.sh --no-backup

./setup.sh --uninstall
./setup.sh --no-backup  # no .bak files
./setup.sh -y           # assume yes
./setup.sh --version
./setup.sh --help
```

You can also just `cp Vimore.vimrc ~/.vimrc`.

## Requirements

Vim 9.0+ (tested on 9.2). Optional: `wl-copy`/`xclip` for system clipboard,
external formatters/checkers for F8/F10.

## Key mappings

| Keys | Action |
|---|---|
| `<Space>` | Leader menu (which-key style) |
| `Ctrl-s` | Save (stays in Insert mode) |
| `Ctrl-h/j/k/l` | Move between windows |
| `Alt-Left/Right` | Previous / next tab |
| `Ctrl-t` | Vim default: pop tag stack (new tab is `SPC t n`) |
| `Ctrl-x` (Visual) | Cut selection to system clipboard |
| `F2` | Toggle paste mode (Normal and Insert) |
| `F3` / `F4` | File explorer / vertical file explorer |
| `F5` / `F6` | Run / debug current file in a terminal |
| `F7` | Toggle line wrap (current window) |
| `F8` / `F10` | Async code check / format |
| `F9` | Basic indent (`gg=G`) |

Indentation: 2 spaces for Web/config/scripts, 4 for systems languages,
Go uses tabs displayed at 4, Makefile tabs at 8; 6 is not a base width.
| `<C-x><C-o>` | Manually open completion (no C-Space: IME may use it) |
| `SPC F` | Find file (falls back to netrw) |

Inside the menu: `SPC w` Write, `SPC c` Maintain, `SPC b` Brackets,
`SPC s` Sort / clean, `SPC t` Window, `SPC z` View, `SPC g` Git, `SPC l` LSP
(NeoVimore only), `SPC /` toggle comment, `SPC ?` tutorial, `SPC F` find file.
`SPC b d` removes only the surrounding symbols, `SPC b c` changes them;
use `daX` to delete a pair together with its contents. Visual `p` keeps the
unnamed register. Operators keep the normal text color; NeoVimore additionally
colors C pointers `*` blue.

Bracket handling:
- Empty `()` `[]` `{}`: Enter splits into three lines, cursor stays in Insert.
- At the end of a container (before the closing bracket): Enter moves the
  closing bracket to the next line.

Trailing whitespace is shown as a dim `·` and stripped on save (Markdown
excluded). Terminal and nofile buffers never show it.

## Commands

- `:VimoreMenu` — open the Leader menu
- `:VimoreKeys` — list all mappings in a scratch buffer
- `:VimoreHealth` — colored environment self-check
- `:VimoreTutor` — open the Chinese interactive tutorial
- `:VimMaze` — small maze game (`?` help, `q` quit)

## Options

Set before sourcing, or edit the top of `Vimore.vimrc`:

```vim
let g:vimore_autochdir = 0          " 1 = cd to file directory on BufEnter
let g:vimore_strip_whitespace = 1   " 0 = keep trailing whitespace on save
let g:vimore_show_extra_whitespace = 1 " 0 = hide the trailing-space marker
let g:vimore_menu_timeout = 3000    " menu auto-close after N ms
let g:author = 'Your Name'
let g:email = 'you@example.com'
```

## License

GPL-3.0, see [LICENSE](LICENSE).
