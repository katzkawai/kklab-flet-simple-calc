# Flet アプリの改造 & デプロイ チュートリアル

Flet のギャラリーからサンプルアプリをダウンロードして、自分好みに改造し、
GitHub Pages で世界に公開するまでの流れを **最初から最後まで** まとめたチュートリアルです。

このリポジトリ（[シンプル電卓](https://katzkawai.github.io/kklab-flet-simple-calc/)）も、
まさにこの手順で作られています。

---

## 🧭 全体の流れ（5 ステップ）

```
1. ギャラリーからサンプルをダウンロード
        ▼
2. uv sync でセットアップ → uv run flet run で動作確認
        ▼
3. main.py を改造・機能追加
        ▼
4. uv run flet build web でビルド
        ▼
5. gh-pages ブランチに push → GitHub Pages で公開 🌍
```

---

## ✅ 事前に用意するもの

| ツール | 用途 | インストール確認コマンド |
| --- | --- | --- |
| [uv](https://docs.astral.sh/uv/) | Python のパッケージ / 仮想環境マネージャー | `uv --version` |
| [Git](https://git-scm.com/) | バージョン管理・GitHub への push | `git --version` |
| GitHub アカウント | アプリの公開先 | — |

> **uv が入っていない場合**
> ```bash
> # macOS / Linux
> curl -LsSf https://astral.sh/uv/install.sh | sh
> ```
> （Windows は [公式手順](https://docs.astral.sh/uv/getting-started/installation/) を参照）

---

## ステップ 1: ギャラリーからサンプルアプリをダウンロード

1. ブラウザで Flet のギャラリーを開きます。
   👉 **https://flet.dev/gallery**

2. 気に入ったサンプル（例: **Calculator**）をクリックします。

3. 各サンプルのページには **ソースコードへのリンク**（GitHub）があります。
   そこからアプリのフォルダ一式を入手します。方法は 2 通り:

   **方法 A: ZIP でダウンロード**
   - GitHub のサンプルページで `Code` → `Download ZIP`
   - 解凍して、目的のアプリのフォルダ（例 `calculator/`）だけ取り出す

   **方法 B: git で clone して 1 つだけ取り出す**
   ```bash
   git clone https://github.com/flet-dev/examples.git
   # 例: calculator アプリのフォルダをコピー
   cp -r examples/python/apps/calculator ~/my-flet-app
   ```

> 💡 サンプルのフォルダには最低限、以下が入っています。
> - `main.py` … アプリ本体
> - `pyproject.toml` … 依存ライブラリやプロジェクト設定

---

## ステップ 2: 新しいフォルダでセットアップ & 起動

取り出したアプリのフォルダに移動して、セットアップします。

```bash
# 1. アプリのフォルダに移動（フォルダ名は適宜読み替え）
cd ~/my-flet-app

# 2. 必要なライブラリをインストール（.venv が自動で作られる）
uv sync

# 3. デスクトップアプリとして起動して動作確認
uv run flet run
```

- `uv sync` … `pyproject.toml` / `uv.lock` を読み、必要なライブラリを `.venv` に揃えます。
- `uv run flet run` … デスクトップウィンドウでアプリが立ち上がります。
  ここで正しく動けば、サンプルの取り込みは成功です 🎉

> **ホットリロードで開発したいとき**
> ```bash
> uv run flet run --recursive
> ```
> ソースを保存するたびに自動で再読み込みされ、改造がはかどります。

---

## ステップ 3: アプリを改造・機能追加する

`main.py` を編集して、見た目や機能を変えていきます。

### 改造の例 1: 色を変えて明るい雰囲気にする

```python
# 変更前（ダークなテーマ）
self.bgcolor = ft.Colors.BLACK

# 変更後（明るいテーマ）
self.bgcolor = ft.Colors.BLUE_50
```

ボタンの色も同様に `ft.Colors.XXX` を差し替えるだけで変えられます。
使える色名は [Flet の Colors 一覧](https://flet.dev/docs/reference/colors) を参照してください。

### 改造の例 2: ウィンドウタイトルや背景を変える

```python
def main(page: ft.Page):
    page.title = "My Calculator"        # ウィンドウ / タブのタイトル
    page.bgcolor = ft.Colors.WHITE      # ページ全体の背景色
```

### 改造したら、その都度こまめに確認

```bash
uv run flet run
```

> ✅ **ローカルで思いどおりに動くこと** を確認してから、次のデプロイに進みましょう。

---

## ステップ 4: Web アプリとしてビルドする

デスクトップ用のアプリを、ブラウザで動く **Web アプリ** に変換します。

```bash
uv run flet build web --base-url /レポジトリ名/ --exclude .venv build .git
```

`レポジトリ名` は、自分の GitHub リポジトリ名に置き換えてください。
（このプロジェクトなら `kklab-flet-simple-calc`）

```bash
# 実際の例
uv run flet build web --base-url /kklab-flet-simple-calc/ --exclude .venv build .git
```

### 各オプションの意味（重要）

| オプション | 役割 | 付け忘れると… |
| --- | --- | --- |
| `flet build web` | アプリを Web 用に変換。結果は `build/web` に出力 | — |
| `--base-url /レポジトリ名/` | GitHub Pages はリポジトリ名のサブフォルダで配信される。その base URL を指定 | **画面が真っ白**になる |
| `--exclude .venv build .git` | `.venv`（Python 一式）などを同梱しない | ファイルが **100MB 超**になり push できない |

ビルドが終わると `build/web/index.html` などが生成されます。
存在を確認しておくと安心です。

```bash
ls build/web/index.html
```

---

## ステップ 5: GitHub Pages で公開する

「`build/web` の中身を `gh-pages` ブランチに置いて push する」と、GitHub Pages が自動で配信します。

### 5-1. ビルド結果を `gh-pages` ブランチに push する

下のコマンドをそのまま実行すれば OK です。
（`build/web` の中身で `gh-pages` ブランチを丸ごと置き換えます）

```bash
# 1. ビルド結果を一時フォルダにコピー
rm -rf /tmp/ghp-site && cp -r build/web /tmp/ghp-site

# 2. Jekyll の自動処理を無効化する目印を置く（Flutter のファイルが消えないように）
touch /tmp/ghp-site/.nojekyll

# 3. gh-pages 用の作業フォルダ（worktree）を用意
git worktree remove --force /tmp/ghp 2>/dev/null; rm -rf /tmp/ghp
git worktree add --detach /tmp/ghp
cd /tmp/ghp
git checkout --orphan gh-pages

# 4. 中身を入れ替えてコミット & 強制 push
git rm -rf --quiet . 2>/dev/null
cp -r /tmp/ghp-site/. .
git add -A
git commit -m "Deploy web app to GitHub Pages"
git push -f origin gh-pages

# 5. 後片付け（元のフォルダに戻る）
cd -
git worktree remove --force /tmp/ghp
git branch -D gh-pages 2>/dev/null
```

> 💡 **`orphan` ブランチ + 強制 push にする理由**
> `gh-pages` は「公開する中身だけ」を入れる、履歴を持たないブランチにします。
> 毎回まっさらにビルド結果で置き換えるため、`--orphan` と `-f`（force）を使います。

### 5-2. （初回だけ）GitHub Pages の配信元を設定する

リポジトリで **一度だけ** 必要な設定です。次回からは不要です。

1. GitHub のリポジトリページ → **Settings** → **Pages**
2. **Source** を「**Deploy from a branch**」にする
3. **Branch** を `gh-pages` / `/(root)` に設定して **Save**

### 5-3. 公開を確認する

数分待ってから、ブラウザで下の URL を開きます（`ユーザー名` と `レポジトリ名` は自分のものに置き換え）。

```
https://ユーザー名.github.io/レポジトリ名/
```

アプリが表示されれば成功です 🎉

> 更新が反映されないときは、1〜2 分待ってから **強制リロード（Ctrl+Shift+R）** を試してください。

---

## ⚡ おまけ: デプロイをワンコマンドにする

ステップ 4〜5 を毎回手で打つのは大変なので、シェルスクリプトにまとめると便利です。
このリポジトリの [`deploy.sh`](./deploy.sh) がその例で、次の 1 コマンドでビルド〜公開まで自動化しています。

```bash
./deploy.sh
```

中身はこのチュートリアルのステップ 4・5 とまったく同じことをしています。
リポジトリ名が変わったときは、`deploy.sh` 冒頭の `REPO_NAME` を直すだけで使い回せます。

---

## 🔁 2 回目以降の更新フロー

一度公開した後は、改造するたびに次を繰り返すだけです。

```bash
# 1. main.py を改造
# 2. ローカルで確認
uv run flet run

# 3. ソースをコミット & push（main ブランチ）
git add -A
git commit -m "改造の内容を書く"
git push origin main

# 4. 公開（ワンコマンド）
./deploy.sh
```

> `git push origin main` は **ソースコードの保存**、`./deploy.sh` は **公開サイトの更新** です。
> 役割が違うので、両方やっておくのがおすすめです。

---

## ❓ よくあるつまずき

| 症状 | 原因と対処 |
| --- | --- |
| 公開ページが **真っ白** | `--base-url /レポジトリ名/` を付け忘れ → 付けて再ビルド |
| push が `File ... exceeds 100.00 MB` で失敗 | `--exclude .venv build .git` を付け忘れ → 付けて再ビルド |
| `uv run flet run` でウィンドウが出ない | `uv sync` が済んでいるか確認。エラーメッセージも読む |
| ページが更新されない | 反映に 1〜2 分かかる。強制リロード（Ctrl+Shift+R）も試す |
| 404 になる | GitHub Pages の Source が `gh-pages` ブランチに設定されているか確認（5-2） |

---

## 🛠 使用技術

- [Flet](https://flet.dev/) — Python だけで UI が作れるフレームワーク
- [uv](https://docs.astral.sh/uv/) — Python のパッケージ・仮想環境マネージャー
- GitHub Pages — 静的サイトの無料ホスティング
