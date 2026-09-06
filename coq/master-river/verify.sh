#!/usr/bin/env bash
# verify.sh — Master Equation River Coq formalisation
#
# For every Lemma/Theorem/Corollary/Example in every MR_*.v file, generate a
# scratch .v file that Requires the module and runs `Print Assumptions` on
# it, then greps for "Closed under the global context" (the only acceptable
# result under the readout-first discipline: no stray axioms, no classical
# logic, nothing left Admitted). Prints a PASS/FAIL line per identifier and
# a final summary; non-zero exit if anything failed.
set -u
cd "$(dirname "$0")"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

FAIL=0
TOTAL=0

for vfile in MR_*.v; do
  modname="${vfile%.v}"
  # Extract Theorem/Lemma/Corollary/Example identifiers (top-level or inside Sections)
  idents=$(grep -oE '^\s*(Theorem|Lemma|Corollary|Example|Remark)\s+[A-Za-z0-9_'\'']+' "$vfile" \
           | awk '{print $2}')
  for id in $idents; do
    TOTAL=$((TOTAL+1))
    scratch="$TMPDIR/scratch_${modname}_${id}.v"
    cat > "$scratch" <<EOF
From MR Require Import ${modname}.
Print Assumptions ${id}.
EOF
    out=$(coqc -Q . MR -q "$scratch" 2>&1)
    if echo "$out" | grep -q "Closed under the global context"; then
      echo "PASS  ${modname}.${id}  -- Closed under the global context"
    else
      echo "FAIL  ${modname}.${id}"
      echo "$out" | sed 's/^/      /'
      FAIL=$((FAIL+1))
    fi
  done
done

echo "----"
echo "verify.sh: ${TOTAL} identifiers checked, ${FAIL} failed."
if [ "$FAIL" -ne 0 ]; then
  exit 1
fi
exit 0
