# Git octopus action

This action automatically merges branches prefixed with name "dogfood/" into the "dogfood-automerge" branch or the branch specified as input.

## Inputs

### `dogfood-branch`

**Required** The name of the dogfood branch. Default `dogfood-automerge`.

## Outputs

### `dogfood-branch`

The dogfood branch.

### `sha1`

The HEAD sha1 of the dogfood branch.

## Example usage

uses: SonarSource/gh-action_git-octopus
secrets = ["GITHUB_TOKEN"]
with:
  dogfood-branch: 'dogfood-on-next'
