#!/bin/bash
set -e
set -o pipefail
whoami
cd ~
ls -al

#git clone git@github.com:/${GITHUB_REPOSITORY}.git repo
echo "https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" > tmp.txt
cat tmp.txt
git clone https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git repo
cd repo

# Fetch conflicts resolutions
git fetch origin -p +refs/heads/*:refs/remotes/origin/* +refs/conflicts/*:refs/conflicts/*

# Delete dogfood branches whose original branch does not exist (because merged and deleted)
# git for-each-ref --shell --format='b=%(refname:short); f=${b#origin/dogfood/}; git ls-remote --exit-code --heads origin refs/heads/"$f" >/dev/null || git push origin :dogfood/"$f"' refs/remotes/origin/dogfood | sh

# Merge all dogfood branches
git octopus origin/dogfood/* origin/master

# Push to the dogfood branch
git diff -s --exit-code HEAD origin/$1 || git push origin +HEAD:$1

echo ::set-output name=dogfood-branch::$1
echo ::set-output name=sha1::$(git rev-parse HEAD)
