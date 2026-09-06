#!/usr/bin/env python3
"""BBL-182 / T8 / T10 — split the 9 MRC_*.v canonical modules into one Coq
file per Toledo code (file name = code, mangled for filesystem/Coq-identifier
safety).  Reads registry/CANONICAL.json for code/tier/parents/occurrences,
registry/genesis_root.json for the 'weld' root entry (master_equation),
parses the existing coq/canonical/MRC_*.v files by their per-id tag comments
"(* CAN-NNN -- ... *)", and writes:

  - coq/canonical/<mangled-code>.v   (one per CAN id + weld.v)
  - coq/canonical/MRC_Prelude.v      (shared devices used by >1 id in a family)
  - registry/coq_rename_ledger.json  (old module.identifier -> new file)
  - coq/canonical/_CoqProject (regenerated)

Idempotent: safe to re-run (regenerates all outputs from the source-of-record
MRC_*.v / LEDGER_*.md files, which are moved to coq/canonical/_mrc_pre_split/
on first run and read from there on subsequent runs).
"""
import json, os, re, shutil, sys

import pathlib as _pathlib
ROOT = str(_pathlib.Path(__file__).resolve().parents[1])
CAN_DIR = os.path.join(ROOT, "coq/canonical")
SRC_DIR = os.path.join(CAN_DIR, "_mrc_pre_split")
REG_DIR = os.path.join(ROOT, "registry")

FAMILY_FILES = [
    "MRC_root_spine.v",
    "MRC_epistemic_reading.v",
    "MRC_method_reading_a.v",
    "MRC_method_reading_b.v",
    "MRC_social_reading.v",
    "MRC_world_system_reading.v",
    "MRC_human_ai_reading_a.v",
    "MRC_human_ai_reading_b.v",
]
MASTER_FILE = "MRC_master.v"

TAG_RE = re.compile(r'^\s*\(\* CAN-(\d+) \xe2\x80\x94'.encode().decode('utf-8', 'ignore')) if False else None
# Use a simple, robust matcher on decoded text instead:
def is_tag_line(line: str):
    m = re.match(r'^\s*\(\* CAN-(\d+) [—-] ', line)
    if m:
        return 'CAN-' + m.group(1)
    return None


def mangle(code: str) -> str:
    return code.replace('/', '__').replace('.', '_').replace('-', '_')


def ensure_source_copy():
    """First run: move the 9 original MRC_*.v + LEDGER_*.md + old verify.sh
    into _mrc_pre_split/ (provenance, excluded from the build). Idempotent."""
    os.makedirs(SRC_DIR, exist_ok=True)
    moved = []
    for fname in FAMILY_FILES + [MASTER_FILE]:
        src = os.path.join(CAN_DIR, fname)
        dst = os.path.join(SRC_DIR, fname)
        if os.path.exists(src) and not os.path.exists(dst):
            shutil.copy2(src, dst)
            moved.append(fname)
    for fname in os.listdir(CAN_DIR):
        if fname.startswith('LEDGER_') and fname.endswith('.md'):
            src = os.path.join(CAN_DIR, fname)
            dst = os.path.join(SRC_DIR, fname)
            if not os.path.exists(dst):
                shutil.copy2(src, dst)
                moved.append(fname)
    old_verify = os.path.join(CAN_DIR, 'verify.sh')
    if os.path.exists(old_verify) and not os.path.exists(os.path.join(SRC_DIR, 'verify.sh.pre-split')):
        shutil.copy2(old_verify, os.path.join(SRC_DIR, 'verify.sh.pre-split'))
    return moved


def load_registry():
    with open(os.path.join(REG_DIR, 'CANONICAL.json')) as f:
        reg = json.load(f)
    id2entry = {e['id']: e for e in reg['canonical']}
    with open(os.path.join(REG_DIR, 'genesis_root.json')) as f:
        groot = json.load(f)
    weld_entry = None
    for r in groot['root_equations']:
        if r.get('code') == 'weld':
            weld_entry = r
            break
    return reg, id2entry, weld_entry


DIVIDER_RE = re.compile(r'^\(\* =+ \*\)\s*$')


def _outer_doc_start(lines, tag_idx, cid):
    """Some families nest the compact "(* CAN-NNN -- ... *)" tag INSIDE an
    outer "(** ** CAN-NNN -- Name\\n\\n    (* CAN-NNN ... *)\\n\\n  prose *)"
    doc-comment (root-spine, social, world-system, human-ai a/b). Splitting
    at the inner tag would tear that outer comment in half (leaving a
    dangling unmatched '(**' in the previous chunk and a dangling unmatched
    '*)' plus exposed prose in this one). Detect the enclosing
    "(** ** CAN-NNN" divider a few lines above and split THERE instead;
    also pull in the "(* ==== *)" rule line directly above that, if present."""
    lo = max(0, tag_idx - 6)
    for j in range(tag_idx - 1, lo - 1, -1):
        if re.match(r'^\(\*\* \*\* ' + re.escape(cid) + r'\b', lines[j]):
            if j > 0 and DIVIDER_RE.match(lines[j - 1]):
                return j - 1
            return j
        if lines[j].strip() and not lines[j].strip().startswith('(*'):
            break  # hit real code / blank-only run ended -- not the nested style
    return tag_idx


def split_family_file(path):
    """Return (top_matter_text, ordered list of (CAN id, chunk_text))."""
    with open(path, encoding='utf-8') as f:
        lines = f.readlines()
    boundaries = []  # (line_index, id)
    for i, l in enumerate(lines):
        cid = is_tag_line(l)
        if cid:
            start = _outer_doc_start(lines, i, cid)
            boundaries.append((start, cid))
    if not boundaries:
        return ''.join(lines), []
    top = ''.join(lines[:boundaries[0][0]])
    chunks = []
    for idx, (start, cid) in enumerate(boundaries):
        end = boundaries[idx + 1][0] if idx + 1 < len(boundaries) else len(lines)
        chunks.append((cid, ''.join(lines[start:end])))
    return top, chunks


def extract_requires(top_text):
    """Pull out the '(From )?Require Import ...'/'Import ListNotations.'/
    'Set Implicit Arguments.' lines from a family file's top matter (the
    part before the module docstring's closing '*)' is skipped by the
    caller already having stripped it, but be defensive and only take
    lines that look like directives)."""
    out = []
    for line in top_text.splitlines():
        s = line.strip()
        if (s.startswith('From Coq Require') or s.startswith('From MR Require') or
                s.startswith('Require Import') or s.startswith('From MRC Require') or
                s == 'Import ListNotations.' or s == 'Set Implicit Arguments.'):
            out.append(s)
    return out


def strip_docstring(top_text):
    """Remove the leading (** * ... *) module docstring, if present, and
    return (docstring_removed_text)."""
    text = top_text
    m = re.match(r'\s*\(\*\*.*?\*\)\s*', text, re.DOTALL)
    if m:
        return text[m.end():]
    return text


def extract_identifiers(chunk_text):
    """Best-effort scrape of top-level Definition/Lemma/Theorem/Corollary/
    Example/Remark/Record/Inductive/Notation identifiers introduced in a
    chunk (used for the rename ledger and CANONICAL.json coq.identifier)."""
    ids = []
    for m in re.finditer(
        r'^\s*(?:Definition|Lemma|Theorem|Corollary|Example|Remark|Record|Inductive|Notation|Fixpoint)\s+'
        r'([A-Za-z0-9_\']+)',
        chunk_text, re.MULTILINE):
        ids.append(m.group(1))
    return ids


def build_header(code, can_id, entry, extra_note=""):
    tier = entry.get('tier', 'untagged') if entry else 'root'
    parents = ", ".join(p['code'] for p in entry.get('parents', [])) if entry else ""
    occ_n = len(entry.get('occurrences', [])) if entry else 0
    note = f" — {extra_note}" if extra_note else ""
    # NOTE: extra_note MUST stay inside the comment -- appending text after
    # the closing '*)' would hand the lexer raw (non-ASCII) Coq "source".
    return f"(* {code} — {can_id} — {tier} — parents: {parents} — occurrences {occ_n}{note} *)\n"


def main():
    moved = ensure_source_copy()
    reg, id2entry, weld_entry = load_registry()

    id2code = {cid: e['code'] for cid, e in id2entry.items()}

    # ---- 1. Parse the 8 family files ----
    family_top = {}
    family_chunks = {}  # fname -> [(id, text)]
    id2chunks = {}       # CAN id -> list of (fname, text)  (usually 1 entry)
    for fname in FAMILY_FILES:
        path = os.path.join(SRC_DIR, fname)
        top, chunks = split_family_file(path)
        family_top[fname] = top
        family_chunks[fname] = chunks
        for cid, text in chunks:
            id2chunks.setdefault(cid, []).append((fname, text))

    tagged_ids = set(id2chunks.keys())
    canonical_ids = set(id2entry.keys())
    untagged = sorted(canonical_ids - tagged_ids, key=lambda x: int(x.split('-')[1]))
    extra_tagged = sorted(tagged_ids - canonical_ids, key=lambda x: int(x.split('-')[1]))

    # ---- 2. Prelude content (family-specific shared devices with no CAN tag) ----
    prelude_parts = []

    # epistemic: notions_pairwise_distinct
    epi_top = strip_docstring(family_top['MRC_epistemic_reading.v'])
    m = re.search(r'(Definition notions_pairwise_distinct.*?\n\n)', epi_top, re.DOTALL)
    if m:
        prelude_parts.append(("epistemic-reading (shared non-collapse device, "
                               "consumed by CAN-011/032/037/219/221/223-229)", m.group(1)))

    # method_reading_a: MRFactorization Section + mr_no_factorization_when_fiber_varies
    #                   + mr_qmin_fold/mr_qsum group
    ma_top = strip_docstring(family_top['MRC_method_reading_a.v'])
    m = re.search(r'(Section MRFactorization\..*?End MRFactorization\.\n)', ma_top, re.DOTALL)
    part1 = m.group(1) if m else ""
    m2 = re.search(r'(Lemma mr_no_factorization_when_fiber_varies.*?Qed\.\n)', ma_top, re.DOTALL)
    part2 = m2.group(1) if m2 else ""
    m3 = re.search(r'(Definition mr_qmin_fold.*?Qed\.\n\Z|Definition mr_qmin_fold.*?(?=\n\(\* =====))',
                    ma_top, re.DOTALL)
    # fallback: grab from 'Definition mr_qmin_fold' to just before the next '(* ====' divider
    if not m3:
        idx = ma_top.find('Definition mr_qmin_fold')
        idx2 = ma_top.find('(* ====', idx + 1) if idx >= 0 else -1
        part3 = ma_top[idx:idx2] if idx >= 0 and idx2 > idx else ""
    else:
        part3 = m3.group(1)
    if part1 or part2 or part3:
        prelude_parts.append(("method-reading-a (shared devices, consumed by "
                               "CAN-165/CAN-181/CAN-194; CAN-216 keeps its own "
                               "local re-declaration per the family docstring)",
                               part1 + "\n" + part2 + "\n" + part3))

    # world_system_reading: CAN_ws_generic_rise_not_entail_rise
    ws_top = strip_docstring(family_top['MRC_world_system_reading.v'])
    m = re.search(r'(Theorem CAN_ws_generic_rise_not_entail_rise.*?Qed\.\n)', ws_top, re.DOTALL)
    if m:
        prelude_parts.append(("world-system-reading (shared witness, consumed by "
                               "CAN-146/147/148/153/154/160)", m.group(1)))

    # method_reading_b: the CAN2xx_MethodNotion shared enumeration, positioned
    # (in the pre-split source) between CAN-216's tag and CAN-230's tag, so it
    # was swept into CAN-216's own chunk by the boundary rule even though
    # CAN-230..256 (not CAN-216) are its real consumers -- lift it into the
    # prelude too, verbatim (CAN-216's file keeps its own harmless private copy).
    mb_path = os.path.join(SRC_DIR, 'MRC_method_reading_b.v')
    with open(mb_path, encoding='utf-8') as f:
        mb_text = f.read()
    m = re.search(r'(Inductive CAN2xx_MethodNotion :=.*?EpistemicResponsibility\.\n)', mb_text, re.DOTALL)
    if m:
        prelude_parts.append(("method-reading-b (shared 50-constructor "
                               "enumeration, consumed by CAN-230..256)", m.group(1)))

    prelude_requires = sorted(set(
        ['From Coq Require Import QArith.', 'From Coq Require Import Qminmax.',
         'From Coq Require Import Lqa.', 'From Coq Require Import ZArith.',
         'From Coq Require Import Lia.', 'From Coq Require Import List.',
         'Import ListNotations.', 'Set Implicit Arguments.',
         'Require Import MR.MR_WorldSystem.']))
    # keep required order: Coq imports, then ListNotations, then Set Implicit, then MR import
    prelude_requires = (
        ['From Coq Require Import QArith.', 'From Coq Require Import Qminmax.',
         'From Coq Require Import Lqa.', 'From Coq Require Import ZArith.',
         'From Coq Require Import Lia.', 'From Coq Require Import List.',
         'Import ListNotations.', 'Set Implicit Arguments.',
         'Require Import MR.MR_WorldSystem.'])

    prelude_text = (
        "(* MRC_Prelude.v -- BBL-182/T8 shared-device prelude, generated by "
        "scripts/bbl182_split_coq.py from the pre-split MRC_*.v family top "
        "matter (originals preserved in coq/canonical/_mrc_pre_split/). "
        "Every generated per-code file that consumes one of these devices "
        "`From MRC Require Import MRC_Prelude.`; every other generated file "
        "also carries the Require harmlessly (unused-import, not an error). "
        "No new proof content: byte-identical device bodies lifted from the "
        "pre-split sources, cited below. *)\n\n"
        + "\n".join(prelude_requires) + "\n\n"
    )
    for note, body in prelude_parts:
        prelude_text += f"(* -- from {note} -- *)\n" + body.strip('\n') + "\n\n"

    # ---- 3. MRC_master.v: weld.v + CAN-006 addendum ----
    master_path = os.path.join(SRC_DIR, MASTER_FILE)
    with open(master_path, encoding='utf-8') as f:
        master_text = f.read()
    m = re.search(r'(Section MasterEquation\..*?End MasterEquation\.\n)', master_text, re.DOTALL)
    weld_section = m.group(1)
    # everything from 'Record DomainReading' to EOF is the CAN-006 addendum
    idx = master_text.find('Record DomainReading')
    can006_addendum = master_text[idx:]
    master_requires = ['From Coq Require Import QArith.', 'From Coq Require Import ZArith.',
                        'From Coq Require Import List.', 'Import ListNotations.',
                        'Set Implicit Arguments.']

    weld_code = 'weld'
    weld_file = mangle(weld_code) + '.v'
    weld_header = (
        f"(* {weld_code} — root (Layer-0, Genesis id verbatim) — "
        f"tier: {weld_entry.get('tier_in_genesis', 'mixed')} — "
        f"parents: {', '.join(weld_entry.get('parents', []))} — "
        f"occurrences {len(weld_entry.get('synthesis_occurrences', []))} — "
        f"'The one-line master equation (the weld)', formalised as the typed "
        f"composition of the root-spine segments in MRC_master.v "
        f"(coq/canonical/_mrc_pre_split/MRC_master.v) *)\n"
    )
    weld_out = (weld_header + "\n" + "\n".join(master_requires) + "\n\n" + weld_section)

    # ---- 4. Write per-CAN-id files ----
    written = {}   # CAN id -> filename
    rename_ledger = []
    id_missing_code = []

    def family_requires(fname):
        top = strip_docstring(family_top[fname])
        return extract_requires(top)

    for cid in sorted(canonical_ids, key=lambda x: int(x.split('-')[1])):
        entry = id2entry[cid]
        code = entry['code']
        if not code:
            id_missing_code.append(cid)
            continue
        chunks = id2chunks.get(cid)
        if not chunks:
            continue  # CAN-257 / CAN-258 (new splits, not yet formalised) -- reported separately
        fname_out = mangle(code) + '.v'
        pieces = []
        req_lines = set()
        origin_files = []
        for src_fname, text in chunks:
            reqs = family_requires(src_fname)
            for r in reqs:
                req_lines.add(r)
            origin_files.append(src_fname)
            pieces.append(text)
        # deterministic, readable ordering of the Require block
        ordered = [r for r in
                   ['From Coq Require Import QArith.', 'From Coq Require Import Qminmax.',
                    'From Coq Require Import Lqa.', 'From Coq Require Import ZArith.',
                    'From Coq Require Import Lia.', 'From Coq Require Import Arith.',
                    'From Coq Require Import List.']
                   if r in req_lines]
        ordered += sorted(r for r in req_lines if r.startswith('Require Import MR.') or r.startswith('From MR Require'))
        ordered += [r for r in ['Import ListNotations.'] if r in req_lines] or ['Import ListNotations.']
        ordered += [r for r in ['Set Implicit Arguments.'] if r in req_lines] or ['Set Implicit Arguments.']
        ordered.append('From MRC Require Import MRC_Prelude.')

        # CAN-006 gets the master.v addendum appended
        extra_note = ""
        if cid == 'CAN-006':
            pieces.append(
                "\n(* ==================================================================== *)\n"
                "(* -- appended from coq/canonical/_mrc_pre_split/MRC_master.v: the "
                "master-equation's per-domain DomainReading/weld_holds apparatus and "
                "the five domain witnesses (CAN_006_epistemic_weld_witness, "
                "CAN_006_human_ai_weld_witness, CAN_006_social_weld_witness, "
                "CAN_006_world_system_weld_witness, CAN_006_method_weld_witness) -- *)\n"
                + "\n".join(master_requires) + "\n\n" + can006_addendum
            )
            for r in master_requires:
                if r not in ordered:
                    ordered.insert(-1, r)
            origin_files.append(MASTER_FILE)
            extra_note = "includes the master-equation per-domain weld witnesses (from MRC_master.v)"

        header = build_header(code, cid, entry, extra_note)
        out_text = header + "\n" + "\n".join(ordered) + "\n\n" + "\n".join(pieces)
        out_path = os.path.join(CAN_DIR, fname_out)
        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(out_text)
        written[cid] = fname_out

        for src_fname, text in [c for c in chunks]:
            for ident in extract_identifiers(text):
                rename_ledger.append({
                    "old_module": src_fname[:-2], "old_identifier": ident,
                    "can_id": cid, "code": code, "new_file": f"coq/canonical/{fname_out}"
                })
        if cid == 'CAN-006':
            for ident in extract_identifiers(can006_addendum):
                rename_ledger.append({
                    "old_module": "MRC_master", "old_identifier": ident,
                    "can_id": cid, "code": code, "new_file": f"coq/canonical/{fname_out}"
                })

    # weld.v identifiers
    for ident in extract_identifiers(weld_section):
        rename_ledger.append({
            "old_module": "MRC_master", "old_identifier": ident,
            "can_id": "(root: weld)", "code": weld_code,
            "new_file": f"coq/canonical/{weld_file}"
        })

    with open(os.path.join(CAN_DIR, weld_file), 'w', encoding='utf-8') as f:
        f.write(weld_out)
    with open(os.path.join(CAN_DIR, 'MRC_Prelude.v'), 'w', encoding='utf-8') as f:
        f.write(prelude_text)

    # ---- 5. _CoqProject ----
    all_files = ['MRC_Prelude.v', weld_file] + sorted(written.values())
    with open(os.path.join(CAN_DIR, '_CoqProject'), 'w', encoding='utf-8') as f:
        f.write("-Q . MRC\n-Q ../master-river MR\n\n")
        f.write("\n".join(all_files) + "\n")

    # ---- 6. rename ledger ----
    with open(os.path.join(REG_DIR, 'coq_rename_ledger.json'), 'w', encoding='utf-8') as f:
        json.dump({
            "generated_by": "scripts/bbl182_split_coq.py",
            "rule": "code.replace('/','__').replace('.','_').replace('-','_') + '.v'",
            "source_files_preserved_at": "coq/canonical/_mrc_pre_split/",
            "entries": rename_ledger,
        }, f, indent=2, ensure_ascii=False)

    # ---- report ----
    print("moved to _mrc_pre_split:", moved)
    print("canonical ids total:", len(canonical_ids))
    print("ids written to their own file:", len(written))
    print("ids with no Coq chunk found (not yet formalised):", untagged)
    print("tag ids not found in CANONICAL.json:", extra_tagged)
    print("weld.v written:", weld_file)
    print("MRC_Prelude.v written")
    print("total generated .v files (incl prelude+weld):", len(all_files))
    print("rename ledger entries:", len(rename_ledger))


if __name__ == '__main__':
    main()
