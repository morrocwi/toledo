#!/usr/bin/env bash
# verify.sh — BBL-182/T10, post-split verification.
#
# For every Definition/Lemma/Theorem/Corollary/Example/Remark/Record/
# Inductive top-level identifier in every generated per-code .v file listed
# in _CoqProject (MRC_Prelude.v included), generate a scratch file that
# Requires the module and runs `Print Assumptions` on each PROOF-BEARING
# identifier (Lemma/Theorem/Corollary/Example/Remark — Definitions/Records/
# Inductives carry no proof obligation and are skipped), then greps for
# "Closed under the global context" (the only acceptable result: no stray
# axioms, no classical logic, nothing left Admitted).  RAM discipline:
# sequential, one coqc at a time, checks docs/RAM_LOW first.
set -u
cd "$(dirname "$0")"
RAM_LOW="../../docs/RAM_LOW"
MR_DIR="$(cd .. && pwd)/master-river"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

FAIL=0
TOTAL=0
REPORT="verify_report.txt"
: > "$REPORT"

for vfile in $(grep -E '\.v$' _CoqProject); do
  modname="${vfile%.v}"
  idents=$(grep -oE '^\s*(Theorem|Lemma|Corollary|Example|Remark)\s+[A-Za-z0-9_'\'']+' "$vfile" \
           | awk '{print $2}')
  for id in $idents; do
    while [ -f "$RAM_LOW" ]; do sleep 10; done
    TOTAL=$((TOTAL+1))
    scratch="$TMPDIR/scratch_${modname}_${id}.v"
    cat > "$scratch" <<EOF
From MRC Require Import ${modname}.
Print Assumptions ${id}.
EOF
    out=$(coqc -Q . MRC -Q "$MR_DIR" MR -q "$scratch" 2>&1)
    if echo "$out" | grep -q "Closed under the global context"; then
      echo "PASS  ${modname}.${id}  -- Closed under the global context" | tee -a "$REPORT"
    else
      echo "FAIL  ${modname}.${id}" | tee -a "$REPORT"
      echo "$out" | sed 's/^/      /' | tee -a "$REPORT"
      FAIL=$((FAIL+1))
    fi
  done
done

echo "----" | tee -a "$REPORT"
echo "verify.sh: ${TOTAL} identifiers checked, ${FAIL} failed." | tee -a "$REPORT"
if [ "$FAIL" -ne 0 ]; then
  exit 1
fi
exit 0
