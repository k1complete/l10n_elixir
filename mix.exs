defmodule L10nElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :l10n_elixir,
     version: "0.0.3",
     elixir: "~> 1.1.0-beta",
     compilers: Mix.compilers ++ [:po],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:exgettext, :l10n_iex]]
  end

  # Dependencies can be hex.pm packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
##	   {:exgettext, path: "../"},
##	   {:l10n_iex, path: "../l10n_iex"}
     {:exgettext, github: "k1complete/exgettext"},
	   {:l10n_iex,  github: "k1complete/l10n_iex" }
#	    compile: "mix do deps.get, deps.compile; mix; mix l10n.msgfmt"}
    ]
  end
end
