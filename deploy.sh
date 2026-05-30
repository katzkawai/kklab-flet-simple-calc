#!/usr/bin/env bash
#
# deploy.sh — Flet 製の電卓アプリを GitHub Pages に公開するスクリプト
#
# 使い方:
#   ./deploy.sh
#
# このスクリプトがやること:
#   1. アプリを Web 用にビルドする（build/web フォルダができる）
#   2. その中身を gh-pages ブランチに置き換えて push する
#   3. GitHub Pages が自動でインターネットに公開する
#
# 詳しい説明は README.md を見てください。

# エラーが起きたら、その場で止める（おかしな状態のまま進まないように）
set -euo pipefail

# ===== 設定（リポジトリが変わったらここだけ直せば OK）=====
REPO_NAME="kklab-flet-simple-calc"   # GitHub のリポジトリ名（= 公開 URL のサブフォルダ名）
PAGES_BRANCH="gh-pages"              # 公開用ブランチ
BASE_URL="/${REPO_NAME}/"            # Web アプリの base URL（サブフォルダ公開に必須）

# 一時的に使う作業フォルダ
WORKTREE_DIR="/tmp/ghp"
SITE_DIR="/tmp/ghp-site"

# スクリプトがある場所（= プロジェクトのルート）に移動
cd "$(dirname "$0")"

echo "=================================================="
echo " GitHub Pages デプロイを開始します"
echo "=================================================="

# ----- ステップ 0: 準備（前回の残りがあれば掃除）-----
echo "▶ 0/3 作業フォルダを掃除しています..."
git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
rm -rf "$WORKTREE_DIR" "$SITE_DIR"
git branch -D "$PAGES_BRANCH" 2>/dev/null || true

# ----- ステップ 1: Web アプリをビルド -----
echo "▶ 1/3 Web アプリをビルドしています（数分かかります）..."
#   --base-url ... : サブフォルダ公開に必須（無いと真っ白画面になる）
#   --exclude  ... : .venv 等を同梱しない（無いと 100MB 超で push できない）
uv run flet build web --base-url "$BASE_URL" --exclude .venv build .git

# ビルド結果が本当にできたか確認
if [ ! -f build/web/index.html ]; then
  echo "✗ ビルドに失敗しました（build/web/index.html が見つかりません）。"
  exit 1
fi

# ----- ステップ 2: gh-pages ブランチに公開 -----
echo "▶ 2/3 ${PAGES_BRANCH} ブランチに公開しています..."

# ビルド結果を一時フォルダにコピー
cp -r build/web "$SITE_DIR"
# Jekyll の自動処理を止める目印（Flutter のファイルが消えないように）
touch "$SITE_DIR/.nojekyll"

# 公開用の作業ブランチを履歴なし（orphan）で作る
git worktree add --detach "$WORKTREE_DIR" >/dev/null
(
  cd "$WORKTREE_DIR"
  git checkout --orphan "$PAGES_BRANCH"
  git rm -rf --quiet . 2>/dev/null || true
  cp -r "$SITE_DIR"/. .
  git add -A
  git commit -q -m "Deploy web app to GitHub Pages"
  git push -f origin "$PAGES_BRANCH"
)

# ----- ステップ 3: 後片付け -----
echo "▶ 3/3 後片付けをしています..."
git worktree remove --force "$WORKTREE_DIR" 2>/dev/null || true
rm -rf "$WORKTREE_DIR" "$SITE_DIR"
git branch -D "$PAGES_BRANCH" 2>/dev/null || true

echo "=================================================="
echo " ✅ デプロイ完了！"
echo ""
echo " 1〜2 分ほどで下の URL に反映されます:"
echo "   https://katzkawai.github.io/${REPO_NAME}/"
echo ""
echo " （更新が見えないときは Ctrl+Shift+R で強制リロード）"
echo "=================================================="
