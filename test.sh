#!/bin/bash
set -euo pipefail

: "${GITHUB_HEAD_REF:?GITHUB_HEAD_REF is not set}"

echo "Current branch: $GITHUB_HEAD_REF"
DOGFOOD_BRANCH="dogfood/$GITHUB_HEAD_REF"
echo "dogfood-branch=$DOGFOOD_BRANCH" >> "$GITHUB_OUTPUT"

# Create a test dogfood branch if it doesn't exist
if [[ -z "$(git ls-remote --heads origin $DOGFOOD_BRANCH)" ]]; then
  echo "Creating test dogfood branch"
  git checkout -b "$DOGFOOD_BRANCH"
  git push origin "$DOGFOOD_BRANCH"
  echo "Successfully created and pushed $DOGFOOD_BRANCH"
  git checkout "$GITHUB_HEAD_REF"
  echo "Switched back to $GITHUB_HEAD_REF"
else
  echo "$DOGFOOD_BRANCH already exists, skipping creation"
fi
