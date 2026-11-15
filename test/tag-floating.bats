#!/usr/bin/env bats
# Guard the credential contract for protected floating tags.

WORKFLOW="${BATS_TEST_DIRNAME}/../.github/workflows/tag-floating.yml"

@test "missing release credentials are rejected before checkout" {
    local preflight checkout script
    preflight=$(grep -n 'name: Require authorized release token' "${WORKFLOW}" \
        | cut -d: -f1)
    checkout=$(grep -n 'uses: actions/checkout@' "${WORKFLOW}" | cut -d: -f1)

    [[ "${preflight}" -lt "${checkout}" ]]

    script="${BATS_TEST_TMPDIR}/token-preflight.sh"
    sed -n '/^      - name: Require authorized release token$/,/^      - uses: actions\/checkout@/p' \
        "${WORKFLOW}" \
        | sed -n '/^        run: |$/,/^      - uses: actions\/checkout@/p' \
        | sed '1d;$d;s/^          //' > "${script}"

    run env -u PROMOTE_TOKEN bash "${script}"
    [[ "${status}" -ne 0 ]]
    [[ "${output}" == *'Set PROMOTE_TOKEN to an authorized release credential'* ]]

    run env PROMOTE_TOKEN= bash "${script}"
    [[ "${status}" -ne 0 ]]

    run env PROMOTE_TOKEN=authorized bash "${script}"
    [[ "${status}" -eq 0 ]]
}

@test "checkout authenticates tag pushes with the release credential" {
    local checkout_block
    checkout_block=$(sed -n '/uses: actions\/checkout@/,/name: Advance floating tag/p' \
        "${WORKFLOW}")

    grep -Fq "token: \${{ secrets.PROMOTE_TOKEN }}" <<< "${checkout_block}"
    grep -Fq "git push --force origin \"\${tag}\"" "${WORKFLOW}"
}
