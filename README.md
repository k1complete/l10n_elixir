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

    |$ git clone https://github.com/k1complete/l10n_elixir
    |$ mix deps.get 
    |$ mix compile
    |$ ls -l priv/lang/ja/l10n_elixir.exmo

使いかた
--------

ビルド後、日本後リソースと、いくつかの支援モジュールが組込まれますので、
iex -S mixで実行してみます。

    |$ iex -S mix
    |iex> h Code           
    
                                          Code                                      
    
    Utilities for managing code compilation, code evaluation and code loading.
    
    This module complements Erlang's code module
    (http://www.erlang.org/doc/man/code.html) to add behaviour which is specific to
    Elixir.
    
    |iex> import Exgettext.Helper
    |iex> h Code           
    
                                          Code                                      
    
    コードコンパイル、コード評価、コードローディングの管理のためのユーティ リティです。

    このモジュールは Erlangのcodeモジュー ル (http://www.erlang.org/doc/man/code.html)
    にElixir固有の振舞いを追加 して補足しました。

    |iex>

.iex.exsフィアルに import Exgettext.Helperを入れておくことで、日本語の
表示を優先できます。

Ex_doc
-------

ex_docとの連携は、Exgettext側で或る程度準備しています。その上で、
パッチをあてた[ex_doc](https://github.com/k1complete/ex_doc.git)を
クローンしてビルドしてください。

ビルド位置は、elixirのソースのとなりが良いです(elixirのソースへ
cd してから、make docsでレファレンスマニュアルをビルドしますが、
その際の想定位置がそうなっているためです)。

ex_docのビルドが終ったら、elixirのソースへcdし、

  |$> make docs
  
でドキュメントをビルドします。docsディレクトリにリファレンスマニュアル
がHTMLでレンダリングされます。

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

    |$ mix l10n.xgettext --elixir path/to/elixir/source
    xgettext for l10n_elixir
    clean l10n_elixir.pot_db
    
    Compiled lib/l10n_elixir.ex
    Generated l10n_elixir.app
    xgettext l10n_elixir.pot_db --output=priv/po/l10n_elixir.pot
    collecting document for l10n_elixir
    collecting document for elixir

priv/po/l10n_elixir.potファイルが生成されます。これと既存の
poファイルとをマージします。

    |$ mix l10n.msgmerge
    msgmerge -o priv/po/ja.pox priv/po/ja.po priv/po/l10n_elixir.pot
    .............................................................
    .................................. 完了.
    |$ diff priv/po/ja.po priv/po/ja.pox    

いろいろ差分がでますので、目視で確認してOKならja.poxをja.poへリネーム
します。その後、追加エントリの翻訳を行います。

翻訳後、言語リソースをビルドします。

    |$ mix l10n.msgfmt ## または、
    |$ mix compile





