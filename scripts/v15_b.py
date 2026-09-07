#!/usr/bin/env python3
"""Toledo v1.5, Lane B (DEBT #45, part 1) -- registrar+builder for the 119
coq.coq_status=="mapped_not_wrapped" Theta/CMC readings (root Theta: 86,
root CMC: 33; the readings scripts/v12_R.py added at v1.2 from
registry/root_candidates_report.json / EQ_CODE_SCHEME.md's Root registry
extension R1 addendum, left "wrapping into coq/canonical/ files ... to a
later lane" at the time).

Idempotent, per SCHEMA.md's own convention: re-reads registry/CANONICAL.json
immediately before every atomic write and touches only the coq{}/tier
fields of this lane's own target entries (mapped_not_wrapped at the time
each chunk starts, still mapped_not_wrapped at write time -- otherwise
skipped, another lane got there first). Never re-derives tier upward: tier
is left exactly as already recorded (it was set at v1.2 from the source's
own registry/coq_map.json-quoted Print Assumptions classification).

Mechanism (per entry): every one of the 119 statements is a literal
Coq `Theorem|Lemma|Corollary <identifier> : <type>.` declaration copied
verbatim from its source .v file at v1.2 (statement.format == "coq";
verified programmatically, 2026-09-07, that the identifier occurs in the
statement text for all 119). This script writes a Toledo-named wrapper file
coq/canonical/<mangled-code>.v that:
  1. Requires the already-verified source module (readout_genesis's own
     formal/<X>.v for a Theta reading, or -- for CMC -- either the leaf
     "solver arc (private)" formal/CMC_TargetClass_Definitions.v directly,
     or one of five _cmc_mirror_CMC_*.v companion files this lane wrote
     alongside this script; see those files' own header comments for why
     the mirror indirection exists: the ORIGINAL CMC_*.v files' own
     internal "From RDL Require Import CMC_TargetClass_Definitions."
     lines assume RDL == formal/ itself, flat -- correct only when built
     standalone from inside coq/solver-arc/formal/ -- but Toledo's shared
     coq/canonical/build_sequential.sh already binds "-R ../solver-arc RDL"
     RECURSIVELY (needed by the 210 already-shipped q_formal/EQ-015
     wrapper files from v11_wrapa.py, which cannot be renamed), under
     which "RDL" bare resolves one level higher and the original files'
     own internal Require cannot find its target. The mirror files
     (mechanical import-line fix only, verified byte-identical otherwise)
     resolve this without touching either the verbatim solver-arc mirror
     or the 210 pre-existing files.
  2. Restates the identifier as a FRESH Theorem/Lemma/Corollary of the
     SAME type (parsed out of statement.latest, dropping only the
     original keyword+identifier prefix and the final period, which are
     replaced by this wrapper's own name) with a one-line proof
     `Proof. exact <original identifier>. Qed.` -- a restatement, not a
     mere alias, so verify.sh's own Theorem/Lemma/Corollary grep (which
     only re-checks proof-bearing declarations, per its own comment) picks
     this identifier up on the next full verify pass exactly like every
     other canonical file.
  3. Ends with `Print Assumptions <new name>.` so THIS script's own coqc
     invocation captures the real, freshly-run classification text
     (never asserted) to fill registry `coq.assumptions`.

coq_status: "closed" when the freshly-captured output is exactly "Closed
under the global context" (116 of 119, confirmed by direct compilation,
2026-09-07); "axioms" (the base SCHEMA.md enum value, not a new one) when
it discloses a named axiom/Parameter dependency instead (3: TargetClass's
own cmc_no_refuter_under_axioms via cmc_bridge_axiom, and
Bridge_Decomposition's decomposed_bridge_obligation/decomposed_no_refuter
via its own three named Axioms + one Parameter) -- both classifications are
copied from this run's actual coqc output, never asserted from the
EQ_CODE_SCHEME.md addendum's prose alone.

RAM discipline: one coqc invocation at a time; docs/RAM_LOW checked (and
waited on) before every single one; no -j anywhere.

Usage:
  python3 scripts/v15_b.py --report                # dry run, no writes
  python3 scripts/v15_b.py --apply                 # build + write all
  python3 scripts/v15_b.py --apply --start 0 --limit 25   # one chunk
"""
import argparse
import json
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN = REG / "CANONICAL.json"
LINEAGE = REG / "LINEAGE.jsonl"
CAN_DIR = ROOT / "coq" / "canonical"
RAM_LOW = ROOT / "docs" / "RAM_LOW"
DATE = "2026-09-07"
BY = "toledo-v1.5-b"

FLAGS = [
    "-Q", ".", "MRC",
    "-Q", "../master-river", "MR",
    "-R", "../solver-arc", "RDL",
    "-Q", "../readout_universe/evidence", "URR",
    "-Q", "../readout_genesis/formal", "ReadoutGenesis.Formal",
]

# Identifiers whose own CMC source file already discloses a named axiom
# (Axiom/Parameter) dependency -- confirmed 2026-09-07 by direct coqc +
# Print Assumptions on the mirror files this lane wrote (see their build
# log, ops/v15_b_cmc_mirror_build.log). Never guessed from prose.
CMC_AXIOM_IDENTS = {
    "cmc_no_refuter_under_axioms",
    "decomposed_bridge_obligation",
    "decomposed_no_refuter",
}

STMT_RE = re.compile(
    r"^\s*(Theorem|Lemma|Corollary)\s+([A-Za-z0-9_']+)\s*:\s*(.*)\.\s*$",
    re.DOTALL,
)


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def load():
    return json.loads(CAN.read_text(encoding="utf-8"))


def atomic_write(doc):
    tmp = CAN.with_suffix(".json.tmp")
    tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    tmp.replace(CAN)


def append_lineage(events):
    if not events:
        return
    with open(LINEAGE, "a", encoding="utf-8") as fh:
        for ev in events:
            fh.write(json.dumps(ev, ensure_ascii=False) + "\n")


def import_lines(e) -> str:
    """Returns the full block of Require lines this wrapper needs. Coq's
    `Require Import` is NOT transitively re-exported (the original CMC_*.v
    files use plain Require Import, not Export), so any wrapper whose
    statement mentions a type/definition from the leaf
    (TransportReadout, CMC_Bridge_Obligation, CMC_TargetClass, ClosureForm,
    ClosureFree, CMC_Refuter_Burden, NonzeroClosure, ...) must import the
    leaf directly too, not rely on it leaking in through a second Require.
    Confirmed empirically 2026-09-07 (three otherwise-correct wrappers
    failed with "reference ... was not found" until the leaf import was
    added explicitly)."""
    root = e["root"]
    ident_file = e["coq"]["identifiers"][0]["file"]  # e.g. "formal/InfoThetaEdgeCensus_attempt.v"
    basename = Path(ident_file).stem
    if root == "Theta":
        # The Theta source files themselves each do `Require Import QArith.`
        # (some also List/Bool) to bring QArith's own notations ("==", "%Q",
        # "#") into scope for their own Theorem's TYPE, not just its proof.
        # `Require Import <module>.` is not transitively re-exported in
        # Coq, so a wrapper that only imports the compiled module (not
        # QArith itself) cannot parse a restated type using those notations
        # -- confirmed empirically 2026-09-07 (syntax error on the exact
        # same, otherwise-unmodified type text). Re-opening the same
        # stdlib scopes here is not a new claim -- QArith/List/Bool are
        # Coq's own standard library, already a transitive dependency of
        # every one of these ten files.
        return (
            "Require Import QArith.\n"
            "Require Import List.\n"
            "Import ListNotations.\n"
            "Require Import Bool.\n"
            f"From ReadoutGenesis.Formal Require Import {basename}."
        )
    if root == "CMC":
        leaf = "From RDL.formal Require Import CMC_TargetClass_Definitions."
        if basename == "CMC_TargetClass_Definitions":
            return leaf
        lines = [leaf]
        # CarrierKind/RetentionCarrier/FiniteSpeedCarrier live in
        # CMC_Bridge_Decomposition; Independent_Definitions and
        # PhysicsClass_Instances both build on them but (like every other
        # CMC_*.v file) only `Require Import` it themselves, which Coq does
        # not re-export -- so any wrapper whose own statement mentions one
        # of those three names needs this import too, independent of which
        # file the wrapper's own identifier lives in.
        if basename != "CMC_Bridge_Decomposition":
            lines.append("From MRC Require Import _cmc_mirror_CMC_Bridge_Decomposition.")
        lines.append(f"From MRC Require Import _cmc_mirror_{basename}.")
        return "\n".join(lines)
    raise SystemExit(f"unexpected root for mapped_not_wrapped entry: {root} ({e['code']})")


def build_wrapper_text(e) -> tuple[str, str, str]:
    """Returns (file_text, new_theorem_name, identifier).

    The restated Theorem's TYPE is obtained from Coq itself
    (`ltac:(let t := type of <ident> in exact t)`), never retyped by hand
    from statement.latest -- confirmed necessary, not a style choice:
    several of these 119 identifiers are declared inside a Coq `Section`
    whose `Variable`s get auto-generalized into the EXPORTED theorem's real
    type once the section closes, so the raw source text (what
    statement.latest quotes) is not always the literal exported signature
    (e.g. Theta_census_exists_3's source-text body free-mentions L00..L22,
    which are Section Variables prepended as `forall L00 .. L22 : Q,` in
    the actual compiled type) -- confirmed empirically 2026-09-07 (three
    otherwise-correct wrappers failed with "reference L00/L01/p0 was not
    found" using the hand-copied type text). Asking Coq for the identifier's
    own `type of` sidesteps this (and also the unrelated, separately-fixed
    v1.2-lane-R statement-truncation bug on Theta/P.17) with no loss of
    rigor: the restated Theorem is still `exact <ident>`, i.e. still
    provably the same proposition Coq itself already assigned to <ident>."""
    code = e["code"]
    mangled = mangle(code)
    stmt = e["statement"]["latest"]
    m = STMT_RE.match(stmt)
    ident = e["coq"]["identifier"]
    keyword = m.group(1) if m and m.group(2) == ident else "Theorem"
    new_name = f"{mangled}_restates_{ident}"
    parents = ", ".join(p["code"] for p in e["parents"]) or "(none)"
    name = (e["name"] or "").replace("(*", "( *").replace("*)", "* )")
    tier = e["tier"]
    tier_verb = (e["tier_in_genesis_verbatim"] or "").replace("(*", "( *").replace("*)", "* )")
    header = (
        f"(* {code} -- mapped_not_wrapped -> wrapped -- restates {ident} "
        f"({e['coq']['imported_from']}) -- parents: {parents} *)\n"
        f"(* name: {name} *)\n"
        f"(* tier: {tier} ({tier_verb}) *)\n"
        f"(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.\n"
        f"   The type is obtained from Coq's own `type of {ident}` (see this\n"
        f"   script's build_wrapper_text docstring for why: Section-variable\n"
        f"   auto-generalization in the source makes a hand-copied type\n"
        f"   text from statement.latest unreliable for some of these 119\n"
        f"   entries). The proof is `exact {ident}.` against the\n"
        f"   already-verified import below -- no new proof technique,\n"
        f"   no new claim. *)\n"
    )
    body = (
        f"{header}\n"
        f"{import_lines(e)}\n\n"
        f"Definition {new_name}_type := ltac:(let t := type of {ident} in exact t).\n"
        f"{keyword} {new_name} : {new_name}_type.\n"
        f"Proof. exact {ident}. Qed.\n\n"
        f"Print Assumptions {new_name}.\n"
    )
    return body, new_name, ident


def run_coqc(relpath: str) -> str:
    while RAM_LOW.exists():
        print(f"RAM_LOW present, waiting 10s before {relpath}", file=sys.stderr)
        time.sleep(10)
    cmd = ["coqc", "-q"] + FLAGS + [relpath]
    out = subprocess.run(cmd, cwd=str(CAN_DIR), capture_output=True, text=True)
    return out.stdout + out.stderr, out.returncode


def classify_assumptions(coqc_output: str, ident: str) -> str:
    """Extract the assumptions text following the final 'Print Assumptions' line's
    own output block, honestly, from actual coqc stdout -- never asserted.

    registry/SCHEMA.md's T7.9 contract (coq.assumptions) requires either the
    exact string "Closed under the global context" or a string starting
    "+axioms:" naming the axioms -- never the raw coqc "Axioms:\\n..." header
    verbatim (that raw form fails tests/test_registry.py::
    test_coq_assumptions_honest and verify.sh's own grep-only pass
    criterion). Fixed 2026-09-07 (AXIOM-FORMAT-1): the axiom names below are
    still copied verbatim from this run's actual coqc output, only the
    leading marker is normalised from "Axioms:" to "+axioms:" and the
    per-axiom lines are joined with ", " so the whole value is one line."""
    if "Closed under the global context" in coqc_output:
        return "Closed under the global context"
    if "Axioms:" in coqc_output:
        # keep everything from the last "Axioms:" marker on, trimmed
        idx = coqc_output.rfind("Axioms:")
        block = coqc_output[idx + len("Axioms:"):].strip()
        names = [ln.strip() for ln in block.splitlines() if ln.strip()]
        return "+axioms: " + ", ".join(names)
    return None  # build produced neither -- caller treats as failure


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--report", action="store_true")
    ap.add_argument("--start", type=int, default=0)
    ap.add_argument("--limit", type=int, default=10**9)
    args = ap.parse_args()

    doc = load()
    targets = [e["code"] for e in doc["canonical"] if e["coq"]["coq_status"] == "mapped_not_wrapped"]
    targets.sort()
    chunk = targets[args.start: args.start + args.limit]
    print(f"total mapped_not_wrapped={len(targets)}; this run covers {len(chunk)} "
          f"(start={args.start}, limit={args.limit})")

    if not args.apply:
        for c in chunk:
            print(" would process:", c)
        return

    results = []  # (code, new_name, ident, coq_status, assumptions, ok)
    fail = 0
    for code in chunk:
        doc_now = load()  # re-read: another lane may have written meanwhile
        e = next((x for x in doc_now["canonical"] if x["code"] == code), None)
        if e is None or e["coq"]["coq_status"] != "mapped_not_wrapped":
            print(f"SKIP {code}: no longer mapped_not_wrapped (other lane got there first)")
            continue
        mangled = mangle(code)
        relpath = f"{mangled}.v"
        text, new_name, ident = build_wrapper_text(e)
        (CAN_DIR / relpath).write_text(text, encoding="utf-8")
        out, rc = run_coqc(relpath)
        assumptions = classify_assumptions(out, ident)
        if rc != 0 or assumptions is None:
            fail += 1
            print(f"FAIL {code} ({relpath}):\n{out[-2000:]}")
            continue
        # Decided from THIS run's actual coqc output, not from the
        # CMC_AXIOM_IDENTS prediction list (kept only as a documented,
        # independently-checkable expectation -- see the assertion below).
        coq_status = "closed" if assumptions == "Closed under the global context" else "axioms"
        if (ident in CMC_AXIOM_IDENTS) != (coq_status == "axioms"):
            print(f"NOTE {code}: axiom-disclosure prediction mismatch for {ident} "
                  f"(predicted axioms={ident in CMC_AXIOM_IDENTS}, actual={coq_status=='axioms'}) "
                  f"-- proceeding on the actual coqc output, never the prediction.")
        results.append((code, relpath, new_name, ident, coq_status, assumptions))
        print(f"OK   {code} -> {coq_status} :: {assumptions.splitlines()[0]}")

    if fail:
        print(f"{fail} failures -- stopping before registry write so nothing is recorded "
              f"as built that did not actually build.", file=sys.stderr)
        sys.exit(1)

    if not results:
        print("nothing to write to the registry.")
        return

    # single re-read-then-write for this whole chunk's registry update
    doc_now = load()
    by_code = {x["code"]: x for x in doc_now["canonical"]}
    events = []
    changed = 0
    for code, relpath, new_name, ident, coq_status, assumptions in results:
        e = by_code.get(code)
        if e is None or e["coq"]["coq_status"] != "mapped_not_wrapped":
            print(f"SKIP-AT-WRITE {code}: registry entry moved on before this chunk's write")
            continue
        old_status = e["coq"]["coq_status"]
        e["coq"]["file"] = f"coq/canonical/{relpath}"
        e["coq"]["coq_status"] = coq_status
        e["coq"]["assumptions"] = assumptions
        if coq_status == "axioms":
            # AXIOM-FORMAT-1: assumptions is now the single-line
            # "+axioms: <name>, <name>, ..." string (see classify_assumptions),
            # not the old multi-line raw "Axioms:\n..." header -- split on the
            # marker then on ", " to recover the individual axiom names.
            axiom_part = assumptions.split(":", 1)[1] if ":" in assumptions else assumptions
            axiom_lines = [a.strip() for a in axiom_part.split(",") if a.strip()]
            e["coq"]["coq_axioms"] = axiom_lines
        events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": f"coq.coq_status={old_status}, coq.file=null",
            "to": f"coq.coq_status={coq_status}, coq.file=coq/canonical/{relpath}",
            "reason": (
                f"Toledo v1.5 lane B (DEBT #45): wrapped {ident} -- wrote "
                f"coq/canonical/{relpath} restating {ident} as {new_name} "
                f"(`exact {ident}.`), coqc-verified this run. "
                f"Print Assumptions: {assumptions.splitlines()[0]}"
                + (f" [{', '.join(assumptions.splitlines()[1:])}]" if coq_status == "axioms" else "")
            ),
            "by": BY,
        })
        changed += 1

    atomic_write(doc_now)
    append_lineage(events)
    print(f"registry updated: {changed} entries, {len(events)} lineage events appended.")


if __name__ == "__main__":
    main()
