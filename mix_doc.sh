. env.sh
if [ ! -f logo.png ]; then
    wget "http://elixir-lang.org/docs/logo.png"
fi
mix docs
mix docs_all
