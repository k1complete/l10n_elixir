PATH=`pwd`/deps/elixir/bin:$PATH
export PATH
if [ ! -f logo.png ]; then
    wget "http://elixir-lang.org/docs/logo.png"
fi
mix docs
