#!/usr/bin/env bash
# One-shot setup for the zohuyhieuzo03 GitHub profile.
# Run while logged in to gh as zohuyhieuzo03:  gh auth login  &&  gh auth refresh -s user
set -euo pipefail
USER_NAME="zohuyhieuzo03"
cd "$(dirname "$0")"
[ "$(gh api user --jq .login)" = "$USER_NAME" ] || { echo "✗ gh active account is not $USER_NAME (run: gh auth switch -u $USER_NAME)"; exit 1; }

# 1. Profile fields — these drive the Google title/snippet of github.com/zohuyhieuzo03
#    Needs the `user` scope: gh auth refresh -h github.com -s user
if gh api -X PATCH user \
  -f name="Nguyễn Huy Hiệu" \
  -f bio="Software Engineer · Security R&D @OPSWAT · Founder techjobs.vn · AI/LLM security, Kubernetes (CKS), full-stack · ICPC & Procon awardee" \
  -f blog="https://techjobs.vn" \
  -f location="Hà Nội, Việt Nam" \
  -f company="@OPSWAT" \
  -F hireable=false > /dev/null 2>&1; then
  echo "✓ profile fields updated"
else
  echo "⚠ profile fields skipped — token lacks 'user' scope (run: gh auth refresh -h github.com -s user)"
fi

# 2. Profile README repo (special repo named after the username)
if ! gh repo view "$USER_NAME/$USER_NAME" > /dev/null 2>&1; then
  gh repo create "$USER_NAME/$USER_NAME" --public \
    --description "Nguyễn Huy Hiệu — Software Engineer, Security R&D, founder of techjobs.vn" \
    --homepage "https://techjobs.vn"
fi
if [ ! -d .git ]; then
  git init -b main
  git config user.name "Nguyễn Huy Hiệu"
  git config user.email "88488050+zohuyhieuzo03@users.noreply.github.com"
  git config credential.helper "!gh auth git-credential"
  git remote add origin "https://github.com/$USER_NAME/$USER_NAME.git"
fi
git add README.md assets .github
git commit -m "feat: redesign GitHub profile README" || true
git push -u origin main
echo "✓ profile README pushed (snake workflow runs on push)"

# 3. Repo descriptions, homepages and topics — topics are indexed by GitHub search & Google
gh repo edit "$USER_NAME/aivulndb" \
  --description "Normalized, cross-linked database of AI/LLM vulnerabilities — infra, model, artifact & agent layers (prompt injection, MCP tool poisoning)" \
  --add-topic ai-security,llm-security,vulnerability-database,prompt-injection,mcp,cve,threat-intelligence,python
gh repo edit "$USER_NAME/AI-Prompt-Store" \
  --description "Store for sharing and discovering AI prompts — Next.js + Supabase" \
  --homepage "https://ai-prompt-store.vercel.app" \
  --add-topic ai,prompt-engineering,nextjs,supabase,typescript
gh repo edit "$USER_NAME/voz_summarize" \
  --description "Telegram bot that crawls long VOZ forum threads and summarizes them with Gemini" \
  --add-topic telegram-bot,gemini,llm,summarization,web-scraping,flask,python
gh repo edit "$USER_NAME/ExpenseTracker" \
  --description "Telegram bot for tracking personal expenses" \
  --add-topic telegram-bot,expense-tracker,python
gh repo edit "$USER_NAME/portfolio" \
  --description "Personal portfolio of Nguyễn Huy Hiệu — Next.js" \
  --homepage "https://portfolio-taupe-three-91.vercel.app" \
  --add-topic portfolio,nextjs,typescript
echo "✓ repo metadata updated"
echo "→ Now pin repos manually: Profile → Customize your pins"
