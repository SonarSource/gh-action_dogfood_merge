#!/bin/bash
set -e
set -o pipefail

if [ -n "${GITHUB_TOKEN:-}" ]; then
    echo "::notice ::The GITHUB_TOKEN environment variable is deprecated. Please use the github-token input parameter instead."
fi
DOGFOOD_BRANCH=$1
: ${GITHUB_TOKEN:=$2}

echo "[user]" > ~/.gitconfig
echo "	email = sonartech@sonarsource.com" >> ~/.gitconfig
echo "  name = sonartech" >> ~/.gitconfig

git clone https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git repo
cd repo

# Fetch conflicts resolutions
git fetch origin -p +refs/heads/*:refs/remotes/origin/* +refs/conflicts/*:refs/conflicts/*

# Delete dogfood branches whose original branch does not exist (because merged and deleted)
git for-each-ref --shell --format='b=%(refname:short); f=${b#origin/dogfood/}; git ls-remote --exit-code --heads origin refs/heads/"$f" >/dev/null || git push origin :dogfood/"$f"' refs/remotes/origin/dogfood | sh

# Merge all dogfood branches
git octopus origin/dogfood/* origin/master

# Force push to the dogfood branch
if ! git diff -s --exit-code HEAD origin/$DOGFOOD_BRANCH; then
  git push origin +HEAD:$DOGFOOD_BRANCH
fi

echo "dogfood-branch=$DOGFOOD_BRANCH" >> "$GITHUB_OUTPUT"
echo "sha1=$(git rev-parse HEAD)" >> "$GITHUB_OUTPUT"
