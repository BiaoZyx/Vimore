#!/usr/bin/env bash
# Vimore 安装脚本
#   ./setup.sh            完整安装：仓库 + 软链接（含教程、迷宫）
#   ./setup.sh --minimal  最小安装：只把 Vimore.vimrc 拷成 ~/.vimrc
#   ./setup.sh --uninstall 卸载（会确认是否删除配置目录）
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.vim/vimore"
RC="$HOME/.vimrc"
MODE="full"
NO_BACKUP=0

usage() {
    cat <<EOF
用法: $0 [选项]

  --minimal    只复制 Vimore.vimrc 到 ~/.vimrc（核心功能完全可用）
  --full       完整安装（默认）：复制仓库到 ~/.vim/vimore，并软链接 ~/.vimrc
  --uninstall  删除本脚本安装的 ~/.vimrc，并询问是否删除配置目录
  --no-backup  覆盖旧配置时不生成 .bak 备份
  -h, --help   显示帮助
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --minimal) MODE="minimal"; shift ;;
        --full) MODE="full"; shift ;;
        --uninstall) MODE="uninstall"; shift ;;
        --no-backup) NO_BACKUP=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "未知选项: $1" >&2; usage >&2; exit 2 ;;
    esac
done

read_user_info() {
    AUTHOR="${VIMORE_AUTHOR:-}"
    EMAIL="${VIMORE_EMAIL:-}"
    if [[ -t 0 ]]; then
        if [[ -z "$AUTHOR" ]]; then
            read -r -p "作者名字（留空则跳过）: " AUTHOR || true
        fi
        if [[ -z "$EMAIL" ]]; then
            read -r -p "邮箱（留空则跳过）: " EMAIL || true
        fi
    fi
}

# Vim 单引号字符串里用两个单引号表示一个；再转义 sed 的替换特殊字符
vim_quote() {
    printf '%s' "$1" | sed -e "s/'/''/g" -e 's/[\\&|]/\\&/g'
}

set_author_email() {
    local file="$1"
    if [[ -n "$AUTHOR" ]]; then
        sed -i \
            -e "s|let g:author = get(g:, 'author', 'Change it in ~/.vimrc')|let g:author = get(g:, 'author', '$(vim_quote "$AUTHOR")')|" \
            "$file"
    fi
    if [[ -n "$EMAIL" ]]; then
        sed -i \
            -e "s|let g:email  = get(g:, 'email',  'Change it in ~/.vimrc')|let g:email  = get(g:, 'email',  '$(vim_quote "$EMAIL")')|" \
            "$file"
    fi
}

backup_rc() {
    [[ "$NO_BACKUP" == 1 ]] && return
    if [[ -e "$RC" || -L "$RC" ]]; then
        local bak="${RC}.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$RC" "$bak"
        echo "已备份旧配置: $bak"
    fi
}

backup_target() {
    [[ "$NO_BACKUP" == 1 ]] && return
    if [[ -d "$TARGET" ]]; then
        local bak="${TARGET}.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$TARGET" "$bak"
        echo "已备份旧配置目录: $bak"
    fi
}

backup_plugin() {
    [[ "$NO_BACKUP" == 1 ]] && return
    local plugin="$HOME/.vim/plugin/vimore-plugins.vim"
    if [[ -e "$plugin" || -L "$plugin" ]]; then
        local bak="${plugin}.bak.$(date +%Y%m%d-%H%M%S)"
        mv "$plugin" "$bak"
        echo "已备份旧 LSP 片段: $bak"
    fi
}

verify() {
    if command -v vim >/dev/null 2>&1; then
        if vim -Nu "$RC" -es -c 'messages' -c 'qa!' </dev/null >/dev/null 2>&1; then
            echo "启动检查通过：$RC"
        else
            echo "警告：Vim 启动时报错，请用 vim -Nu '$RC' 查看 messages" >&2
        fi
    else
        echo "未找到 vim，跳过启动检查"
    fi
}

case "$MODE" in
    minimal)
        read_user_info
        backup_rc
        cp "$ROOT/Vimore.vimrc" "$RC"
        set_author_email "$RC"
        echo "已最小安装：$RC"
        echo "提示：:VimoreTutor / :VimMaze 需要完整安装才有随附文件。"
        verify
        ;;

    full)
        read_user_info
        mkdir -p "$HOME/.vim"
        if [[ -e "$TARGET" && ! -d "$TARGET" ]]; then
            echo "$TARGET 存在但不是目录，请先移走它" >&2
            exit 1
        fi
        backup_target
        mkdir -p "$TARGET"
        cp -a "$ROOT/Vimore.vimrc" "$ROOT/tutor" \
              "$ROOT/VimMaze.vim" "$ROOT/.vim" "$TARGET/"
        set_author_email "$TARGET/Vimore.vimrc"
        echo "已复制配置到：$TARGET"

        # 可选 LSP 片段用独立文件名，避免覆盖用户自己的 plugins.vim
        if [[ -f "$ROOT/.vim/plugin/plugins.vim" ]]; then
            mkdir -p "$HOME/.vim/plugin"
            backup_plugin
            cp "$ROOT/.vim/plugin/plugins.vim" "$HOME/.vim/plugin/vimore-plugins.vim"
            echo "已安装可选 LSP 片段：~/.vim/plugin/vimore-plugins.vim"
        fi

        if [[ -L "$RC" ]]; then
            if [[ "$(readlink "$RC")" == "$TARGET/Vimore.vimrc" ]]; then
                echo "$RC 已经指向 $TARGET/Vimore.vimrc"
            else
                backup_rc
                ln -s "$TARGET/Vimore.vimrc" "$RC"
            fi
        elif [[ -e "$RC" ]]; then
            backup_rc
            ln -s "$TARGET/Vimore.vimrc" "$RC"
        else
            ln -s "$TARGET/Vimore.vimrc" "$RC"
        fi
        echo "已链接：$RC -> $TARGET/Vimore.vimrc"
        verify
        ;;

    uninstall)
        removed=0
        if [[ -L "$RC" && "$(readlink "$RC")" == "$TARGET/Vimore.vimrc" ]]; then
            rm "$RC"; removed=1
        elif [[ -f "$RC" ]] && cmp -s "$RC" "$ROOT/Vimore.vimrc"; then
            rm "$RC"; removed=1
        fi
        if [[ $removed -eq 0 ]]; then
            echo "$RC 不是本脚本安装的，未删除" >&2
            exit 1
        fi
        echo "已删除 $RC"
        read -r -p "是否同时删除 $TARGET ? [y/N] " ans
        if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            rm -rf "$TARGET"
            rm -f "$HOME/.vim/plugin/vimore-plugins.vim"
            echo "已删除 $TARGET"
        fi
        ;;
esac
