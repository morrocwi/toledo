#!/usr/bin/env bash
# verify.sh — Master River Canonicalisation (coq_canon) verification
#
# For every Lemma/Theorem/Corollary/Example in every MRC_*.v file, generate a
# scratch .v file that Requires the module and runs `Print Assumptions` on
# it, then greps for "Closed under the global context" (the only acceptable
# result under the readout-first discipline: no stray axioms, no classical
# logic, nothing left Admitted). Prints a PASS/FAIL line per identifier and
# a final summary; non-zero exit if anything failed.
#
# Mirrors ../coq/verify.sh, adapted for the two-library layout
# (-Q . MRC -Q ../coq MR) that MRC_*.v files needing Master River state
# mappings (MRC_epistemic_reading, MRC_method_reading_a, MRC_social_reading,
# MRC_world_system_reading, MRC_human_ai_reading_a/b) Require via `MR.*`.
set -u
cd "$(dirname "$0")"

MR_DIR="$(cd .. && pwd)/coq"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

FAIL=0
TOTAL=0

for vfile in MRC_*.v; do
  modname="${vfile%.v}"
  # Extract Theorem/Lemma/Corollary/Example identifiers (top-level or inside Sections)
  idents=$(grep -oE '^\s*(Theorem|Lemma|Corollary|Example|Remark)\s+[A-Za-z0-9_'\'']+' "$vfile" \
           | awk '{print $2}')
  for id in $idents; do
    TOTAL=$((TOTAL+1))
    scratch="$TMPDIR/scratch_${modname}_${id}.v"
    cat > "$scratch" <<EOF
From MRC Require Import ${modname}.
Print Assumptions ${id}.
EOF
    out=$(coqc -Q . MRC -Q "$MR_DIR" MR -q "$scratch" 2>&1)
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
