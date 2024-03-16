# Deployer - update k8s manifest and commit changes
This is ment to be part of CD proccess.
Will update k8s manifest in local repo with selected key-value and push changes to remote (where ArgoCD/Flux/other gitops will deploy)
Using `DEPLOY_KEY` will pull target repo

## Usage

### Args
`-f` -- file to be changed and commited
`-k` -- (key) - yaml path in -f(ile) to be changed
`-v` -- (value) - new values to be set for -k(ey)

### Environment variables

- `DEPLOY_KEY` -- plain ssh key to be used to commit

## Examples

### Argo Workflows

```yaml

```

## Tests

```sh
./deployer.sh -f tests/test.yaml -k '.global.tag' -v testing
```

## TODO

- [ ] Option to pull repo
- [ ] Set to which branch changes should be pushed
- [ ] create PR
