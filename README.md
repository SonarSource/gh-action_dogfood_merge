# Git octopus action

This action automatically merges branches prefixed with name "dogfood/" into the "dogfood-automerge" branch or the branch specified as input.

## Inputs

### `dogfood-branch`

**Required** The name of the dogfood branch. Default `dogfood-automerge`.

### `delete-branches`
**Required**  If set to `1`, delete dogfood branches whose original branch does not exist (because merged and deleted)'. Default `0`.

## Outputs

### `dogfood-branch`

The dogfood branch.

### `sha1`

The HEAD sha1 of the dogfood branch.

## Example usage

uses: SonarSource/gh-action_git-octopus@master
env:
  GITHUB_TOKEN: ${{ secrets.GH_TOKEN }}
with:
  dogfood-branch: 'dogfood-on-next'
  delete-branches: '1'
