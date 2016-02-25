defmodule L10nElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :l10n_elixir,
     version: "0.0.4",
#     elixir: "~> 1.2",
     compilers: Mix.compilers ++ [:po],
     source_url: "https://github.com/elixir-lang/elixir",
     docs: fn() -> docs() end,
     exgettext: [ extra: Extrans ],
     aliases: aliases,
     deps: deps]
  end
  def abs_path(s) when is_list(s) do
    Path.join([File.cwd! | s])
  end
  def abs_path(s) do
    Path.join(File.cwd!, s)
  end
  def make_source_ref(source_dir) do
    gitdir = Path.join(source_dir, ".git")
    {shead, 0} = System.cmd("git", ["--git-dir", gitdir, 
                                    "rev-parse", "HEAD"])
    shead = String.rstrip(shead)
    {stag, 0} = System.cmd("git", ["--git-dir", gitdir, 
                                   "tag", "--points-at", shead])
    stag = String.rstrip(stag)
    case stag do
      nil -> shead
      "" -> shead
      _ -> stag
    end
  end
  def docs do 
    source_dir = "deps/elixir"
    sr = abs_path([source_dir, "lib/elixir/ebin"])
#    IO.inspect File.los(sr)
    sref = if (File.exists?(source_dir)) do
             make_source_ref(source_dir)
           else
             nil
           end
    version_path = Path.join(source_dir, "VERSION")
    IO.inspect [version_path: version_path]
    {:ok, version} = if File.exists?(version_path) do
                       File.read(version_path)
                     else
                       {:ok, nil}
                     end
    [
     project: "Elixir",
     app: "elixir",
     version: version,
     formatter: Exgettext.HTML,
     source_root: abs_path("deps/elixir"),
     logo: "logo.png",
     logo_url: "http://elixir-lang.org/docs/logo.png",
     source_beam: sr,
     source_ref: sref,
     extras: [
              "pages/Typespecs.md",
              "pages/Writing Documentation.md"
             ],
     main: "Kernel",
     output: "doc/elixir"
    ]
  end
  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:exgettext, :l10n_iex]]
  end
  defp aliases do
    [docs_all: &docs_all/1]
  end
  def docs_all(_) do
    apps = ["l10n_iex", "l10n_ex_unit"]
    locale = Regex.replace(~r/(..).*/, System.get_env("LANG"), "\\1")
    Enum.map apps,
    fn(app) ->
      Code.load_file("deps/#{app}/mix.exs")
      Code.append_path("_build/dev/lib/ex_doc/ebin")
      File.cp("deps/#{app}/priv/lang/#{locale}/#{app}.exmo", 
              "priv/lang/#{locale}/#{app}.exmo")
      mod = Module.concat(Mix.Utils.camelize(app), Mixfile)
      l10napp = mod.project
      b = Regex.replace(~r/^l10n_(.*)/, app, "\\1")
        |> String.to_atom 
      :ok = Application.load(b)
      b = Application.spec(b)
        |> Keyword.get(:mod)
        |> elem(0)
        |> Module.split
        |> hd
        |> Module.concat(nil)
      l10napp = update_in(l10napp, 
                          [:docs, :source_root], 
                          fn(_) ->  
                            d = Path.dirname(b.__info__(:compile)[:source])
                            r = Path.join([d, "..", "..", ".."]) 
                            |> Path.expand
                            IO.inspect [r: r]
                            r
                          end)
      Mix.Tasks.Docs.run([], l10napp)
    end
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
    [{:elixir, github: "elixir-lang/elixir" }, # tag: "v1.2.0"},
     {:ex_doc, github: "elixir-lang/ex_doc"},
     {:earmark, "~> 0.1.17 or ~> 0.2", optional: true},
     {:extrans, path: "../../extrans"},
     {:exgettext, github: "k1complete/exgettext"},
	   {:l10n_iex,  github: "k1complete/l10n_iex"},
#      compile: "mix do deps.get, deps.compile, compile, docs" },
	   {:l10n_ex_unit,  github: "k1complete/l10n_ex_unit"}
#      compile: "mix do deps.get, deps.compile, compile, docs" }
#	    compile: "mix do deps.get, deps.compile; mix; mix l10n.msgfmt"}
    ]
  end
end
