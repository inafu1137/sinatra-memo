# sinatra-memo
[Sinatra を使ってWebアプリケーションの基本を理解する] 用リポジトリ

以下に手順を示す。

## 概要
Sinatraを使って実装したメモアプリケーションです。タイトルと本文を持つメモを作成・閲覧・編集・削除できます。
データはPostgreSQLに保存されます。

---

## 環境
- Ruby 3.4.4
- Sinatra
- Bundler
- PostgreSQL

---

## セットアップ手順

### 1. リポジトリをクローン

```sh
git clone https://github.com/inafu1137/sinatra-memo.git
cd sinatra-memo/memo_app
```

### 2. 依存ライブラリをインストール
```sh
bundle install
```

### 3. PostgreSQLをインストール（未インストールの場合）

Debian系（Ubuntuなど）の場合
```sh
sudo apt update
sudo apt install postgresql
```

### 4. PostgreSQLでデータベースとテーブルを作成

```sh
psql -U <ユーザー名> -h localhost
```

以下をSQLで入力

```sql
CREATE DATABASE sinatra_memo_app;
\c sinatra_memo_app
CREATE TABLE memos (
    id UUID PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. アプリを起動

```sh
bundle exec ruby app.rb
```

### 6. ブラウザでアクセス

```
http://localhost:4567
```
