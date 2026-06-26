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
| `deploy.sh` | ビルド〜公開を 1 コマンドで行うデプロイスクリプト |
| `TUTORIAL.md` | サンプル入手〜改造〜公開までの詳しいチュートリアル |
| `AGENTS.md` | コーディングエージェント向けのリポジトリ取扱説明書 |
| `build/` | ビルドで自動生成される（Git では管理しない） |
| `.venv/` | Python の仮想環境（Git では管理しない） |

> 📖 サンプルの入手から改造・公開までを通しで知りたい人は、[`TUTORIAL.md`](./TUTORIAL.md) を参照してください。

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

> 🤖 **コマンドを覚えたくない人へ**
> [Claude Code](https://claude.com/claude-code) や [Codex](https://openai.com/codex/) などのコーディングエージェントに
> 「`deploy.sh` を実行して GitHub Pages にデプロイして」と頼むだけでも公開できます。
> このリポジトリには手順や規約をまとめた [`AGENTS.md`](./AGENTS.md) があり、エージェントはそれを読んで作業します。
> 詳しくは [`TUTORIAL.md`](./TUTORIAL.md) を参照してください。

> 💻 **Windows（PowerShell）の人へ**
> `deploy.sh` や下の手動コマンド（`cp`・`touch` など）は **macOS / Linux のシェル向け** で、
> **PowerShell ではそのままでは動きません**。Windows では、上の「コマンドを覚えたくない人へ」（コーディングエージェント）に任せるか、
> **Git Bash / WSL** で実行するのが簡単です。PowerShell 用に読み替えたコマンドは [`TUTORIAL.md`](./TUTORIAL.md) に載せています。

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

### 手動で公開する手順（`deploy.sh` の中身）

`deploy.sh` を使わず手動でやる場合も、やることは次の 2 つだけです。

**1. Web アプリとしてビルドする**

```bash
uv run flet build web --base-url /kklab-flet-simple-calc/ --exclude .venv build .git
```

結果は `build/web` フォルダに出力されます。次の 2 つのオプションは必須です。

| オプション | なぜ必要か（付け忘れると…） |
| --- | --- |
| `--base-url /kklab-flet-simple-calc/` | GitHub Pages はリポジトリ名のサブフォルダで配信される → 無いと画面が**真っ白**に |
| `--exclude .venv build .git` | `.venv`（Python 一式）を同梱しない → 無いと **100MB 超**で push できない |

**2. `build/web` を `gh-pages` ブランチに公開する**

`build/web` の中身で `gh-pages`（履歴を持たない orphan ブランチ）を丸ごと置き換えて force push します。
具体的なコマンドは **bash / Windows PowerShell / コーディングエージェント** の 3 通りを
[`TUTORIAL.md` のステップ 5](./TUTORIAL.md) にまとめています（`deploy.sh` もこれと同じことを自動で行います）。

公開後、1〜2 分ほどで [公開ページ](https://katzkawai.github.io/kklab-flet-simple-calc/) に反映されます
（反映されないときは強制リロード `Ctrl+Shift+R`）。

---

## ⚙️ 初回だけ必要な設定（すでに設定済み）

> 一度設定すれば、次回からは `./deploy.sh`（または上の手動手順）を繰り返すだけです。

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
