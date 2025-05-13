# sinatra-memo
[Sinatra を使ってWebアプリケーションの基本を理解する] 用リポジトリ

以下に手順を示す。

## 概要
Sinatraを使って実装したメモアプリケーションです。タイトルと本文を持つメモを作成・閲覧・編集・削除できます。

## 環境
- Ruby 3.3.8
- Sinatra
- Bundler

## セットアップ手順

```bash
git clone https://github.com/inafu1137/sinatra-memo.git
cd sinatra-memo
cd memo_app
bundle install
bundle exec ruby app.rb
