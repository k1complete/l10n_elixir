L10nElixir
==========

[Elixir](http://elixir-lang.com/docs/stable/elixir)の地域化パッケージで
ある[Exgettext](http://github.com/k1complete/exgettext)を用いて翻訳され
た、言語リソースです。作者が日本人であることもあり、現在、日本語
リソースのみですが、仕組み的には増やすことが出来ると思います。

言語リソースは、[GNU gettext](https://www.gnu.org/software/gettext/)の
po file(Portable Object)に準拠しています。

ビルド
------

ビルドには、Exgettext, L10n.iexが必要ですが、通常はmix deps.getにより
自動的にダウンロードされます。

    $ git clone https://github.com/k1complete/l10n_elixir
    $ mix deps.get 
    $ mix compile
    $ ls -l priv/lang/ja/l10n_elixir.exmo
    $ sh mix_doc.sh
    --2015-09-26 18:58:38--  http://elixir-lang.org/docs/logo.png
    Resolving elixir-lang.org... 
    (snip)
    2015-09-26 18:58:39 (202 MB/s) - ‘logo.png’ saved [7636/7636]

    Docs successfully generated.
    View them at "doc/elixir/index.html".
    $ 

使いかた
--------

ビルド後、日本後リソースと、いくつかの支援モジュールが組込まれます。
このディレクトリの.iex.exsは l10n_helper.exsをimport_file/2していますが、
l10n_helper.exsは以下のようになっています。

    import IEx.Helpers, except: [h: 0, h: 1]
    import Exgettext.Helper

これで、IExのhコマンドをExgettext.Helper.hコマンドに置き換えています。
iex -S mixで実行してみます。

    $ iex -S mix
    iex> h Code           
    
                                          Code                                      
    
    コードコンパイル、コード評価、コードローディングの管理のためのユーティ リティです。

    このモジュールは Erlangのcodeモジュー ル (http://www.erlang.org/doc/man/code.html)
    にElixir固有の振舞いを追加 して補足しました。

    iex>


Ex_doc
-------

ex_docとの連携は、Exgettext側である程度準備していますので、

    $> sh mix_doc.sh 

mix_doc.shは以下のようになっています:

    PATH=`pwd`/deps/elixir/bin:$PATH
    export PATH
    if [ ! -f logo.png ]; then
        wget "http://elixir-lang.org/docs/logo.png"
    fi
    mix docs

つまり、mix docsはdeps/elixir/binのelixirを利用します。そのため
deps/elixirが再ビルドされることがあります。利用するelixirバージョン
は mix.exsのdepsで変更することができます。

出力先などの設定はex_docのドキュメント通りです。

POファイルの修正
----------------

poフィアルは、GNU gettext互換ですので、emacs po-modeを使うか、
テキストエディタで修正します。

poファイルを修正したら、mix compileでコンパイルすることで、言語リソース
であるexmoファイルがアップデートされます。

内部的にはMix.Tasks.Compile.Poというタスクを作成しています。

elixirソース変更への追随
------------------------

elixir本体のソースが変更されたら、トークンの拾い出しを行います。
これは、l10n_elixirのプロジェクトディレクトリで行います。

     $ mix l10n.xgettext --elixir deps/elixir/lib/elixir
     xgettext for l10n_elixir
     clean l10n_elixir.pot_db
    
     Compiled lib/l10n_elixir.ex
     Generated l10n_elixir.app
     xgettext l10n_elixir.pot_db --output=priv/po/l10n_elixir.pot
     collecting document for l10n_elixir
     collecting document for elixir

priv/po/l10n_elixir.potファイルが生成されます。モジュール毎にpotファイル
が別れていますので、新規モジュール用のpoファイルを生成します:

     $ (. ./env.sh;  mix l10n.msginit)
     ....
     $

その後、既存のpoファイルとをマージします:

     $ mix l10n.msgmerge
     msgmerge -o priv/po/ja.pox priv/po/ja.po priv/po/l10n_elixir.pot
     .............................................................
     .................................. 完了.
     $ diff priv/po/ja.po priv/po/ja.pox    

いろいろ差分がでますので、目視で確認してOKならja.poxをja.poへリネーム
します。あるいは、
   
     $ mix l10n.msgmerge --update

でもよいです。その後、追加エントリの翻訳を行います。fuzzyエントリ
とuntranslatedエントリを探しながら行います。emacs の po-modeが
便利です。

翻訳後、言語リソースをビルドします。

     $ (. ./env.sh; mix docs)

logo.pngがない場合は、mix_doc.shなどで取得してください。
