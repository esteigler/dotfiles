# Setup the OS X specific configuration stuff here

if [ -d "/Applications/MacVim.app/Contents/bin" ]; then
  PATH="/Applications/MacVim.app/Contents/bin:$PATH"
fi

# Setup brew paths
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Since we have homebrew, let's configure the ruby options
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl"
  
  # Point compilers and such to the homebrew libpq version
  if [ -d "$HOMEBREW_PREFIX/opt/libpq" ]; then
    export LDFLAGS="-L$HOMEBREW_PREFIX/opt/libpq/lib"
    export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/libpq/include"
    export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/libpq/lib/pkgconfig"
    PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"
  fi
fi

if [ -x "/opt/homebrew/bin/go" ]; then
  export GOPATH="$HOME/.go"
  PATH="$PATH:$GOPATH/bin"
fi

# Setup the Python world
if [ -f ~/.venv/bin/activate ]; then
  source ~/.venv/bin/activate
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
