#!/bin/bash
set -e
set -o pipefail

CURRENT_BRANCH="$GITHUB_HEAD_REF"

echo "Current branch: $CURRENT_BRANCH"
DOGFOOD_BRANCH="dogfood/$CURRENT_BRANCH"
echo "dogfood-branch=$DOGFOOD_BRANCH" >> "$GITHUB_OUTPUT"

# Create a test dogfood branch if it doesn't exist
if [[ -z "$(git ls-remote --heads origin $DOGFOOD_BRANCH)" ]]; then
  echo "Creating test dogfood branch"
  git checkout -b $DOGFOOD_BRANCH
  git push origin $DOGFOOD_BRANCH
  echo "Successfully created and pushed $DOGFOOD_BRANCH"
  git checkout "$CURRENT_BRANCH"
  echo "Switched back to $CURRENT_BRANCH"
else
  echo "$DOGFOOD_BRANCH already exists, skipping creation"
fi
