# Setup the OS X specific configuration stuff here

if [ -d "/Applications/MacVim.app/Contents/bin" ]; then
  PATH="/Applications/MacVim.app/Contents/bin:$PATH"
fi

# Setup brew paths
if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # Since we have homebrew, let's configure the ruby options
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
  
  # Point compilers and such to the homebrew libpq version
  if [ -d "/usr/local/opt/libpq" ]; then
    export LDFLAGS="-L/usr/local/opt/libpq/lib"
    export CPPFLAGS="-I/usr/local/opt/libpq/include"
    export PKG_CONFIG_PATH="/usr/local/opt/libpq/lib/pkgconfig"
    PATH="/usr/local/opt/libpq/bin:$PATH"
  fi
fi
