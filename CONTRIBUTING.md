# Contributing

## Protected branches and tags

`main` cannot be force-pushed or deleted. The required GitHub Actions checks
are listed in **Settings > Rules > Rulesets > Require main checks**. Missing
or failed checks block updates; GitHub also accepts skipped and neutral
results. The repository owner is the only actor allowed to create, update,
or delete `v*` tags.

Inspect and fix failed Actions runs before retrying. If a check is missing,
verify that its workflow runs on the source branch. After renaming a check,
verify the new name on a branch and update the ruleset before promoting that
change to `main`.

The current ruleset requires `gitleaks`. After the new `Workflow tests`
workflow runs successfully on a branch, add `workflow-tests` to the required
checks as well.

## Floating major-version tag

The `Advance floating version tag` workflow updates the floating `vN` tag
after a push to `main`. The default `GITHUB_TOKEN` cannot bypass the version
tag rule, so the existing floating tag stays at its previous commit until an
authorized workflow run succeeds.

Before deploying the updated workflow, create a fine-grained personal access
token belonging to the repository owner, limited to this repository with
**Contents: read and write** permission. Store it as the `PROMOTE_TOKEN`
repository Actions secret in **Settings > Secrets and variables > Actions**.
Never commit or log the token. If you also store a copy in Bitwarden Secrets
Manager, update both the vault and the GitHub Actions secret during rotation.

After deployment, verify the workflow updates the tag. If a run created after
the update fails, correct the secret or token permissions and rerun its failed
job. A rerun of an older run still uses the older workflow revision.

The reusable pipeline's `auto-promote: full` mode creates and immediately
pushes a new commit to `main`. The required-check rule rejects that unchecked
commit, even with an authorized tag token. Use `bump-only` and ensure the
resulting commit receives the required checks before promotion instead.
