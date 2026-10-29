#!/usr/bin/env bash
# Link dotfiles into $HOME and check out the pinned vim plugins.
#   ./install.sh       link everything
#   ./install.sh vim   link only the vim files
# Update plugins: git submodule update --remote && git commit -am 'tools: update vim plugins'
set -eu

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
STAMP=$(date +%Y%m%d%H%M%S)

# repo-relative source:$HOME-relative target
VIM_LINKS="_vim:.vim _vimrc:.vimrc"
ALL_LINKS="$VIM_LINKS _bashrc:.bashrc _bash_profile:.bash_profile _bash_aliases:.bash_aliases _inputrc:.inputrc _gemrc:.gemrc _screenrc:.screenrc _gitconfig:.config/git/config _tmux.conf:.tmux.conf _psql:.psqlrc"

link_file() {
  local source="$REPO/$1" target="$HOME/$2"
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ]; then
    if [ "$(readlink "$target")" = "$source" ]; then
      return 0
    fi
    rm "$target"
  elif [ -e "$target" ]; then
    mv "$target" "$target.bak.$STAMP"
    echo "backed up $target -> $target.bak.$STAMP"
  fi
  ln -s "$source" "$target"
  echo "linked $target -> $source"
}

# ~/.gitconfig is machine-local (credential helpers, overrides); `git config --global` writes there.
ensure_local_gitconfig() {
  local f="$HOME/.gitconfig"
  if [ -L "$f" ]; then
    case "$(readlink "$f")" in
      "$REPO"/*) rm "$f" ;;   # left over from installs that linked it into the repo
    esac
  fi
  if [ ! -e "$f" ]; then
    printf '%s\n' '# Machine-local git config; shared settings live in ~/.config/git/config.' > "$f"
  fi
}

links=$ALL_LINKS
if [ "${1:-}" = vim ]; then
  links=$VIM_LINKS
fi
for pair in $links; do
  link_file "${pair%%:*}" "${pair#*:}"
done

if [ "${1:-}" != vim ]; then
  ensure_local_gitconfig
fi

cd "$REPO"
git submodule sync --recursive
git submodule update --init --recursive

if command -v vim >/dev/null 2>&1; then
  for doc in "$REPO"/_vim/pack/*/start/*/doc; do
    if [ -d "$doc" ]; then
      vim -Nu NONE -Es -c "helptags $doc" -c 'qa!' || echo "warning: helptags failed for $doc" >&2
    fi
  done
fi
