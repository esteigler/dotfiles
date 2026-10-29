# macOS specifics (sourced by ~/.bashrc).

# MacVim command-line tools (vim, mvim, gvim, vimdiff); Homebrew below takes precedence.
__df_path_prepend /Applications/MacVim.app/Contents/bin

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl"

  # Point compilers at Homebrew's libpq.
  if [ -d "$HOMEBREW_PREFIX/opt/libpq" ]; then
    export LDFLAGS="-L$HOMEBREW_PREFIX/opt/libpq/lib"
    export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/libpq/include"
    export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/libpq/lib/pkgconfig"
    __df_path_prepend "$HOMEBREW_PREFIX/opt/libpq/bin"
  fi

  if [ -x "$HOMEBREW_PREFIX/bin/go" ]; then
    export GOPATH="$HOME/.go"
    # Appended even before the directory exists, so `go install` results work immediately.
    case ":$PATH:" in *":$GOPATH/bin:"*) ;; *) PATH="$PATH:$GOPATH/bin" ;; esac
  fi
fi

# Default Python virtualenv.
if [ -f "$HOME/.venv/bin/activate" ]; then
  . "$HOME/.venv/bin/activate"
fi
