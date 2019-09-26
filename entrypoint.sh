#!/bin/bash
set -e
set -o pipefail

if [[ -n "$TOKEN" ]]; then
	GITHUB_TOKEN=$TOKEN
fi
if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the GITHUB_TOKEN env variable."
	exit 1
fi

git clone https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git .

# Fetch conflicts resolutions
git fetch origin -p +refs/heads/*:refs/remotes/origin/* +refs/conflicts/*:refs/conflicts/*

# Delete dogfood branches whose original branch does not exist (because merged and deleted)
git for-each-ref --shell --format='b=%(refname:short); f=${b#origin/dogfood/}; git ls-remote --exit-code --heads origin refs/heads/"$f" >/dev/null || git push origin :dogfood/"$f"' refs/remotes/origin/dogfood | sh

# Merge all dogfood branches
git octopus origin/dogfood/* origin/master

# Push to the dogfood branch
git diff -s --exit-code HEAD origin/$1 || git push origin +HEAD:$1

echo ::set-output name=dogfood-branch::$1
echo ::set-output name=sha1::$(git rev-parse HEAD)
