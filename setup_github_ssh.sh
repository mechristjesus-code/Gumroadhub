#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "=== GumroadHub GitHub SSH Setup ==="

# Project location - Fixed to your actual project directory
PROJECT_DIR="/data/data/com.termux/files/home/GumRoad"

# GitHub info
GITHUB_USER="mechristjesus-code"
GITHUB_EMAIL="mechristjesus@gmail.com"
REPO_URL="git@github.com:${GITHUB_USER}/Gumroadhub.git"

echo "[1/7] Configuring Git identity..."

git config --global user.name "$GITHUB_USER"
git config --global user.email "$GITHUB_EMAIL"


echo "[2/7] Creating SSH directory..."

mkdir -p ~/.ssh
chmod 700 ~/.ssh


echo "[3/7] Creating SSH key..."

if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen \
    -t ed25519 \
    -C "$GITHUB_EMAIL" \
    -f ~/.ssh/id_ed25519 \
    -N ""
else
    echo "SSH key already exists."
fi


echo "[4/7] Starting SSH agent..."

# Using pkill to ensure no zombie agents
pkill ssh-agent || true
eval "$(ssh-agent -s)" >/dev/null
ssh-add ~/.ssh/id_ed25519


echo "[5/7] Adding GitHub host..."

ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null


echo "[6/7] Preparing repository..."

if [ -d "$PROJECT_DIR" ]; then

    cd "$PROJECT_DIR"

    # Ensure it's a git repo
    [ ! -d .git ] && git init

    git add .

    # Commit if there are changes
    git commit -m "Gumroad Creator Hub full app release" || echo "No changes to commit."

    git branch -M main

    # Remove old remote and add correct one
    git remote remove origin 2>/dev/null || true
    git remote add origin "$REPO_URL"

else
    echo "Project folder not found at: $PROJECT_DIR"
    exit 1
fi


echo ""
echo "================================"
echo "SSH PUBLIC KEY (COPY THIS):"
echo "================================"

cat ~/.ssh/id_ed25519.pub

echo ""
echo "================================"
echo "NEXT STEP:"
echo "1. Copy the key above."
echo "2. Go to: GitHub -> Settings -> SSH and GPG Keys -> New SSH Key"
echo "3. Paste the key."
echo "4. After saving, run:"
echo "   cd /data/data/com.termux/files/home/GumRoad && git push -u origin main"
echo "================================"
