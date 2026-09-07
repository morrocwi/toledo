#!/usr/bin/env bash
# BBL-182/T10 -- build every file listed in _CoqProject ONE AT A TIME
# (no -j, ever). Checks docs/RAM_LOW before every single coqc invocation
# and waits while it exists (never launches a second coqc concurrently).
set -u
cd "$(dirname "$0")"
RAM_LOW="../../docs/RAM_LOW"
LOG="build_report.txt"
: > "$LOG"

FAIL=0
OK=0
FILES=$(grep -E '\.v$' _CoqProject)

for f in $FILES; do
  while [ -f "$RAM_LOW" ]; do
    echo "RAM_LOW present -- waiting 10s before building $f" | tee -a "$LOG"
    sleep 10
  done
  avail=$(awk '/MemAvailable/{print int($2/1024)}' /proc/meminfo)
  if [ "$avail" -lt 1500 ]; then
    echo "MemAvailable ${avail}MB < 1500MB -- waiting before $f" | tee -a "$LOG"
    while [ "$(awk '/MemAvailable/{print int($2/1024)}' /proc/meminfo)" -lt 1500 ]; do sleep 10; done
  fi
  out=$(coqc -q -Q . MRC -Q ../master-river MR -R ../solver-arc RDL -Q ../readout_universe/evidence URR "$f" 2>&1)
  status=$?
  if [ $status -eq 0 ]; then
    OK=$((OK+1))
    echo "OK   $f" | tee -a "$LOG"
  else
    FAIL=$((FAIL+1))
    echo "FAIL $f" | tee -a "$LOG"
    echo "$out" | sed 's/^/     /' | tee -a "$LOG"
  fi
done

echo "----" | tee -a "$LOG"
echo "build_sequential.sh: $OK ok, $FAIL failed (of $(echo "$FILES" | wc -w))" | tee -a "$LOG"
[ "$FAIL" -eq 0 ]
