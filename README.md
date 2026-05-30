# シンプル電卓（Flet 製）

Python の UI フレームワーク [Flet](https://flet.dev/) で作った、iOS 風のシンプルな電卓アプリです。
Web アプリとしてビルドして、GitHub Pages で公開しています。

🔗 **公開ページ:** https://katzkawai.github.io/kklab-flet-simple-calc/

---

## 📁 このプロジェクトの中身

| ファイル / フォルダ | 役割 |
| --- | --- |
| `main.py` | アプリ本体（電卓のプログラム） |
| `pyproject.toml` | プロジェクトの設定と必要なライブラリ |
| `uv.lock` | ライブラリのバージョンを固定するファイル |
| `build/` | ビルドで自動生成される（Git では管理しない） |
| `.venv/` | Python の仮想環境（Git では管理しない） |

---

## 🚀 ローカルで動かす（自分のパソコンで試す）

```bash
# 必要なライブラリをインストール
uv sync

# デスクトップアプリとして起動
uv run flet run
```

---

## 🌐 GitHub Pages へのデプロイ手順

> **デプロイ（deploy）とは？**
> 作ったアプリをインターネット上に公開して、誰でもブラウザから使えるようにすることです。

このプロジェクトでは「**自分のパソコンでビルド → `gh-pages` ブランチに置く → GitHub Pages が自動で公開**」という流れになっています。

### ⚡ かんたんな方法（おすすめ）

下のコマンド 1 つで、ビルドから公開までを自動でやってくれます。

```bash
./deploy.sh
```

中で何をしているか知りたい人や、手動でやりたい人は、この下の「全体像」と各ステップを読んでください
（`deploy.sh` も同じことをしています）。

### 全体像

```
[main ブランチ]        … プログラムの元（ソースコード）
       │
       │  flet build web でビルド
       ▼
[build/web フォルダ]   … ブラウザ用に変換された Web アプリ
       │
       │  gh-pages ブランチへコピーして push
       ▼
[gh-pages ブランチ]    … 公開される中身
       │
       │  GitHub Pages が自動で配信
       ▼
🌍 https://katzkawai.github.io/kklab-flet-simple-calc/
```

---

### ステップ 1: Web アプリをビルドする

```bash
uv run flet build web --base-url /kklab-flet-simple-calc/ --exclude .venv build .git
```

このコマンドの意味:

- `flet build web` … アプリをブラウザで動く形（Web アプリ）に変換します。結果は `build/web` フォルダに入ります。
- `--base-url /kklab-flet-simple-calc/` … **とても重要！**
  GitHub Pages では URL が `https://〇〇.github.io/kklab-flet-simple-calc/` のように
  **リポジトリ名のサブフォルダ**になります。この指定がないと画像や JS の読み込みに失敗して
  真っ白な画面になります。
- `--exclude .venv build .git` … **これも重要！**
  この指定がないと `.venv`（Python 一式）がアプリに同梱され、ファイルが
  **120MB 以上**になって GitHub にアップロードできません（上限は 100MB）。
  除外すると 1MB 以下に収まります。

---

### ステップ 2: ビルド結果を `gh-pages` ブランチに公開する

下のコマンドをそのままコピーして実行すれば OK です。
（`build/web` の中身を `gh-pages` ブランチに丸ごと置き換えて push します）

```bash
# 1. ビルド結果を一時フォルダにコピー
rm -rf /tmp/ghp-site && cp -r build/web /tmp/ghp-site

# 2. Jekyll 処理を無効化する目印を置く（Flutter のファイルが消えないように）
touch /tmp/ghp-site/.nojekyll

# 3. gh-pages 用の作業フォルダを用意
git worktree remove --force /tmp/ghp 2>/dev/null; rm -rf /tmp/ghp
git worktree add --detach /tmp/ghp
cd /tmp/ghp
git checkout --orphan gh-pages

# 4. 中身を入れ替えてコミット & push
git rm -rf --quiet . 2>/dev/null
cp -r /tmp/ghp-site/. .
git add -A
git commit -m "Deploy web app to GitHub Pages"
git push -f origin gh-pages

# 5. 後片付け
cd -
git worktree remove --force /tmp/ghp
git branch -D gh-pages 2>/dev/null
```

push が終わると、1〜2 分ほどで公開ページが新しい内容に更新されます。

---

### ステップ 3: 公開を確認する

ブラウザで下の URL を開いて、電卓が表示されれば成功です 🎉

https://katzkawai.github.io/kklab-flet-simple-calc/

---

## ⚙️ 初回だけ必要な設定（すでに設定済み）

> 一度設定すれば、次回からはステップ 1〜2 を繰り返すだけです。

GitHub のリポジトリ設定で、Pages の配信元を `gh-pages` ブランチに指定しています。

- GitHub のリポジトリページ → **Settings** → **Pages**
- **Source** を「Deploy from a branch」
- **Branch** を `gh-pages` / `/ (root)` に設定

---

## ❓ よくあるつまずき

| 症状 | 原因と対処 |
| --- | --- |
| 画面が真っ白になる | `--base-url /kklab-flet-simple-calc/` を付け忘れている → 付けて再ビルド |
| push が `File ... exceeds 100.00 MB` で失敗 | `--exclude .venv build .git` を付け忘れている → 付けて再ビルド |
| ページが更新されない | 反映に 1〜2 分かかります。ブラウザの強制リロード（Ctrl+Shift+R）も試す |

---

## 🛠 使用技術

- [Flet](https://flet.dev/) — Python だけで作れる UI フレームワーク
- [uv](https://docs.astral.sh/uv/) — Python のパッケージ・仮想環境マネージャー
- GitHub Pages — 静的サイトの無料ホスティング
