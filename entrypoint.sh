#!/bin/bash
set -e
set -o pipefail

DOGFOOD_BRANCH=$1
GH_TOKEN=$2

echo "[user]" > ~/.gitconfig
echo "	email = sonartech@sonarsource.com" >> ~/.gitconfig
echo "  name = sonartech" >> ~/.gitconfig

# Default to GITHUB_TOKEN environment variable, fallback to GH_TOKEN parameter
git clone https://x-access-token:${GITHUB_TOKEN:-$GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git repo
cd repo

# Fetch conflicts resolutions
git fetch origin -p +refs/heads/*:refs/remotes/origin/* +refs/conflicts/*:refs/conflicts/*

# Delete dogfood branches whose original branch does not exist (because merged and deleted)
git for-each-ref --shell --format='b=%(refname:short); f=${b#origin/dogfood/}; git ls-remote --exit-code --heads origin refs/heads/"$f" >/dev/null || git push origin :dogfood/"$f"' refs/remotes/origin/dogfood | sh

# Merge all dogfood branches
git octopus origin/dogfood/* origin/master

# Force push to the dogfood branch
git diff -s --exit-code HEAD origin/$DOGFOOD_BRANCH || git push origin +HEAD:$DOGFOOD_BRANCH

echo "dogfood-branch=$DOGFOOD_BRANCH" >> "$GITHUB_OUTPUT"
echo "sha1=$(git rev-parse HEAD)" >> "$GITHUB_OUTPUT"
