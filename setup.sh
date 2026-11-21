#!/usr/bin/env bash
# Vimore 安装脚本。
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.vim/vimore"
RC="$HOME/.vimrc"
VERSION="$(grep -m1 -E '^" .*: *[0-9]+\.[0-9]+' "$ROOT/Vimore.vimrc" 2>/dev/null | tr -cd '0-9.' || true)"

MODE="full"
NO_BACKUP=0
ASSUME_YES=0

log()  { printf '[vimore] %s\n' "$*"; }
warn() { printf '[vimore] WARN: %s\n' "$*" >&2; }
die()  { printf '[vimore] ERROR: %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --minimal     Copy only Vimore.vimrc to ~/.vimrc (core features work)
  --full        Full install (default): copy repo to ~/.vim/vimore and symlink ~/.vimrc
  --uninstall   Remove ~/.vimrc and optionally the config directory
  --no-backup   Do not create .bak files when overwriting
  -y, --yes     Assume yes for prompts
  -V, --version Print version and exit
  -h, --help    Show this help

Environment:
  VIMORE_AUTHOR, VIMORE_EMAIL  Non-interactive author/email for file headers
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --minimal)    MODE="minimal"; shift ;;
        --full)       MODE="full"; shift ;;
        --uninstall)  MODE="uninstall"; shift ;;
        --no-backup)  NO_BACKUP=1; shift ;;
        -y|--yes)     ASSUME_YES=1; shift ;;
        -V|--version) echo "${VERSION:-unknown}"; exit 0 ;;
        -h|--help)    usage; exit 0 ;;
        --)           shift; break ;;
        -*)           die "unknown option: $1" ;;
        *)            die "unexpected argument: $1" ;;
    esac
done
[[ $# -eq 0 ]] || die "unexpected argument: $1"

read_user_info() {
    AUTHOR="${VIMORE_AUTHOR:-}"
    EMAIL="${VIMORE_EMAIL:-}"
    if [[ "$ASSUME_YES" == 0 && -t 0 ]]; then
        [[ -n "$AUTHOR" ]] || read -r -p "Author name (empty to skip): " AUTHOR || true
        [[ -n "$EMAIL" ]]  || read -r -p "Email (empty to skip): " EMAIL || true
    fi
}

# sed 替换串转义：用 | 作分隔符，需要转义 \ & 和 |
sed_escape() { printf '%s' "$1" | sed -e 's/[\\&|]/\\&/g' | tr -d '\n\r'; }

# Vim 单引号字符串里用两个单引号表示一个引号。
vim_quote() { sed_escape "$(printf '%s' "$1" | sed "s/'/''/g")"; }

set_author_email() {
    local file="$1"
    if [[ -n "$AUTHOR" ]]; then
        sed -i -E "s|^let g:author = .*|let g:author = get(g:, 'author', '$(vim_quote "$AUTHOR")')|" "$file"
    fi
    if [[ -n "$EMAIL" ]]; then
        sed -i -E "s|^let g:email[[:space:]]*=.*|let g:email  = get(g:, 'email',  '$(vim_quote "$EMAIL")')|" "$file"
    fi
}

backup_rc() {
    [[ "$NO_BACKUP" == 1 ]] && return 0
    if [[ -e "$RC" || -L "$RC" ]]; then
        local bak="${RC}.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$RC" "$bak"
        log "backed up $RC to $bak"
    fi
}

backup_target() {
    [[ "$NO_BACKUP" == 1 ]] && return 0
    if [[ -d "$TARGET" ]]; then
        local bak="${TARGET}.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$TARGET" "$bak"
        log "backed up $TARGET to $bak"
    fi
}

backup_plugin() {
    [[ "$NO_BACKUP" == 1 ]] && return 0
    local plugin="$HOME/.vim/plugin/vimore-plugins.vim"
    if [[ -e "$plugin" || -L "$plugin" ]]; then
        local bak="${plugin}.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$plugin" "$bak"
        log "backed up LSP snippet to $bak"
    fi
}

verify() {
    if ! command -v vim >/dev/null 2>&1; then
        warn "vim not found; skipping startup check"
        return 0
    fi
    if vim -Nu "$RC" -es -c 'qa!' </dev/null >/dev/null 2>&1; then
        log "startup check passed: $RC"
    else
        warn "Vim reported errors at startup; run \"vim -Nu '$RC'\" and check :messages"
    fi
}

case "$MODE" in
    minimal)
        read_user_info
        backup_rc
        cp "$ROOT/Vimore.vimrc" "$RC"
        set_author_email "$RC"
        log "minimal install complete: $RC"
        log "note: :VimoreTutor / :VimMaze need the full install for companion files"
        verify
        ;;

    full)
        read_user_info
        mkdir -p "$HOME/.vim"
        [[ ! -e "$TARGET" || -d "$TARGET" ]] || die "$TARGET exists but is not a directory"
        backup_target
        mkdir -p "$TARGET"
        cp -a "$ROOT/Vimore.vimrc" "$ROOT/tutor" "$ROOT/VimMaze.vim" \
              "$ROOT/.vim" "$ROOT/README.md" "$ROOT/README.en.md" "$TARGET/"
        set_author_email "$TARGET/Vimore.vimrc"
        log "copied config to $TARGET"

        # 可选 LSP 片段用独立文件名，避免覆盖用户自己的 plugins.vim
        if [[ -f "$ROOT/.vim/plugin/plugins.vim" ]]; then
            mkdir -p "$HOME/.vim/plugin"
            backup_plugin
            cp "$ROOT/.vim/plugin/plugins.vim" "$HOME/.vim/plugin/vimore-plugins.vim"
            log "installed optional LSP snippet: ~/.vim/plugin/vimore-plugins.vim"
        fi

        if [[ -L "$RC" && "$(readlink "$RC")" == "$TARGET/Vimore.vimrc" ]]; then
            log "$RC already points to $TARGET/Vimore.vimrc"
        else
            backup_rc
            ln -s "$TARGET/Vimore.vimrc" "$RC"
            log "linked $RC -> $TARGET/Vimore.vimrc"
        fi
        verify
        ;;

    uninstall)
        removed=0
        if [[ -L "$RC" && "$(readlink "$RC")" == "$TARGET/Vimore.vimrc" ]]; then
            rm "$RC"; removed=1
        elif [[ -f "$RC" ]] && cmp -s "$RC" "$ROOT/Vimore.vimrc"; then
            rm "$RC"; removed=1
        fi
        [[ "$removed" == 1 ]] || die "$RC was not installed by this script; nothing removed"
        log "removed $RC"
        answer="n"
        if [[ "$ASSUME_YES" == 1 ]]; then
            answer="y"
        elif [[ -t 0 ]]; then
            read -r -p "Also remove $TARGET? [y/N] " answer || true
        fi
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            rm -rf "$TARGET"
            rm -f "$HOME/.vim/plugin/vimore-plugins.vim"
            log "removed $TARGET"
        fi
        ;;
esac
