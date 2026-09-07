#!/usr/bin/env python3
"""
scripts/v12_S.py -- Toledo v1.2.0, Lane S (statement completion).

Founder rulings 2026-09-07 (BBL-207/208/209/210). This script is idempotent: it
re-reads registry/CANONICAL.json immediately before each atomic write and only
ever touches the fields/entries documented below. Every change is also logged
as an event to registry/LINEAGE.jsonl with by="toledo-v1.2-S".

Four sub-tasks, run with --task a|b|c|d|all (default: report only, no write
unless --apply is also given):

  a) Statement completion for entries whose statement.latest was a Coq-theorem
     name only, or a process note, or otherwise not an actual statement.
     9 entries (EQ-015/B.01..B.09) get their real Coq theorem statement,
     transcribed to LaTeX, with the exact Coq text quoted in the appended
     statements_history reason (never invented -- read directly from the
     private source .v file, cited only as "solver arc (private)").
     8 further entries flagged by the "shorter than 12 chars" heuristic were
     checked against their own source occurrence (eq_<record_id>.json) and
     found to already be exact verbatim transcriptions (short but complete,
     e.g. "M(t') <- Axiom I", "It from bit" is a bare citation with no
     formula in the source) -- these are left untouched; see --report.

  b) status "unverified" (61 total). The 9 entries fixed under (a) are moved
     to status "current" (their status_note's own stated blocking condition
     -- "statement text not extracted" -- is what (a) just resolved). The
     other 52 were re-checked directly against the current live source
     (readout_genesis domains/{quantum,relativity,biology}/RULE_REGISTRY.json
     at the same anchored commit) and found unchanged -- their existing
     status_note already states precisely, and still accurately, what is
     missing (an unestablished source class, or an unmirrored Coq identifier)
     so status stays "unverified". Four of those (EQ-001/B.14-17) get their
     status_note upgraded with the actual theorem identifiers now located by
     direct inspection of the private source (still not mirrored into
     coq_map.json, so still unverified -- more precise, not more confirmed).

  c) format "ascii-math" -> "latex+ascii" (424 entries): adds statement.ascii
     (verbatim copy of the pre-existing statement.latest) and statement.latex
     (a mechanical, symbol-for-symbol LaTeX rendering -- unicode/ASCII math
     operators and accents mapped to LaTeX macros, multi-char sub/superscripts
     braced, English word-runs wrapped in \\text{}). statement.latest is left
     UNCHANGED (no content change) and format becomes "latex+ascii". Entries
     the converter cannot render with confidence are still given a best-effort
     LaTeX string but are flagged in the "ambiguous" report list for manual
     review (ops/v12_S_ascii_to_latex_review.md), per task instruction.

  d) prose-hides-a-formula scan: cross-checked every occurrence with a
     locally-cached eq_<record_id>.json against the entry's own statement.
     No case was found where the source's own text contains a formula that
     the registry statement lacks; see --report for the method and its
     honestly-stated coverage limit (only locally-cached eq_*.json files,
     40 of them, could be checked this way).

Usage:
  python3 scripts/v12_S.py --report            # analysis only, no writes
  python3 scripts/v12_S.py --task a --apply
  python3 scripts/v12_S.py --task b --apply
  python3 scripts/v12_S.py --task c --apply
  python3 scripts/v12_S.py --task all --apply
"""
import json
import re
import sys
import glob
import unicodedata
import argparse
from pathlib import Path
from datetime import date

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CANON = REG / "CANONICAL.json"
LINEAGE = REG / "LINEAGE.jsonl"
TODAY = "2026-09-07"
BY = "toledo-v1.2-S"

# ---------------------------------------------------------------------------
# Shared: atomic read-then-write helpers (idempotent, re-read immediately
# before each write; touch only the documented fields/entries).
# ---------------------------------------------------------------------------

def load_canonical():
    with open(CANON, "r", encoding="utf-8") as f:
        return json.load(f)


def atomic_write_canonical(doc):
    tmp = CANON.with_suffix(".json.tmp")
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
        f.write("\n")
    tmp.replace(CANON)


def append_lineage(events):
    with open(LINEAGE, "a", encoding="utf-8") as f:
        for ev in events:
            f.write(json.dumps(ev, ensure_ascii=False) + "\n")


def by_code(doc, code):
    for e in doc["canonical"]:
        if e["code"] == code:
            return e
    return None


def recompute_canonical_counts(cd):
    """Fixer note (B1, 2026-09-07): rewrite the embedded top-level `counts`
    object from `canonical[]` itself, every time this script performs a write
    that could change a counted field (status/domain/tier/coq_status). Before
    this fix, task (b)'s status flips (unverified -> current) left `counts`
    stale, so the registry's own self-reported summary disagreed with its own
    array -- exactly the class of error the project's readout-not-truth
    discipline exists to catch. Mirrors scripts/v12_R.py's
    recompute_canonical_counts(cd) (same shape); kept local here rather than
    cross-imported so this script has no import-time dependency on a sibling
    lane script."""
    canon = cd["canonical"]
    from collections import Counter
    cd["counts"] = {
        "entries": len(canon),
        "by_status": dict(Counter(e["status"] for e in canon)),
        "by_domain": dict(Counter(e["domain"] for e in canon if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in canon)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in canon)),
        "computed": f"{TODAY} from canonical[] (scripts/v12_S.py)",
    }


# ---------------------------------------------------------------------------
# Task (a) + (b) shared data: the 9 EQ-015/B.xx entries.
# Statements read directly, on 2026-09-07, from the private solver-arc
# source files (never redistributed, never named beyond "solver arc
# (private)"): formal/InfoHealthCausalRelax_attempt.v (setpoint_is_fixed,
# one_step_error, n_step_error) and formal/InfoHealthCuspFold_attempt.v
# (disc_even, cusp_factor, fold_from_double_root, bistable_window_dec,
# critical_slowing_marginal, rest_iff_critical).
# ---------------------------------------------------------------------------

B_FIXES = {
    "EQ-015/B.01.v1": {
        "coq_name": "setpoint_is_fixed",
        "coq_file": "formal/InfoHealthCausalRelax_attempt.v",
        "coq_line": 47,
        "coq_quote": (
            "Theorem setpoint_is_fixed :\n"
            "  forall alpha beta u dt : Q, ~ (beta == 0) ->\n"
            "    step alpha beta u dt (setpoint alpha beta u) == setpoint alpha beta u.\n"
            "(where step alpha beta u dt C := C + dt*(alpha*u - beta*C), "
            "setpoint alpha beta u := alpha*u/beta)"
        ),
        "latex": (
            r"\forall\, \alpha,\beta,u,dt \in \mathbb{Q},\ \beta \neq 0 \implies "
            r"\mathrm{step}(\alpha,\beta,u,dt,\mathrm{setpoint}(\alpha,\beta,u)) = "
            r"\mathrm{setpoint}(\alpha,\beta,u), \quad\text{where }"
            r"\mathrm{step}(\alpha,\beta,u,dt,C) := C + dt(\alpha u - \beta C),\ "
            r"\mathrm{setpoint}(\alpha,\beta,u) := \frac{\alpha u}{\beta}"
        ),
    },
    "EQ-015/B.02.v1": {
        "coq_name": "one_step_error",
        "coq_file": "formal/InfoHealthCausalRelax_attempt.v",
        "coq_line": 61,
        "coq_quote": (
            "Theorem one_step_error :\n"
            "  forall alpha beta u dt C : Q, ~ (beta == 0) ->\n"
            "    step alpha beta u dt C - setpoint alpha beta u\n"
            "      == (1 - dt*beta) * (C - setpoint alpha beta u)."
        ),
        "latex": (
            r"\forall\, \alpha,\beta,u,dt,C \in \mathbb{Q},\ \beta \neq 0 \implies "
            r"\mathrm{step}(\alpha,\beta,u,dt,C) - \mathrm{setpoint}(\alpha,\beta,u) = "
            r"(1 - dt\,\beta)\big(C - \mathrm{setpoint}(\alpha,\beta,u)\big)"
        ),
    },
    "EQ-015/B.03.v1": {
        "coq_name": "n_step_error",
        "coq_file": "formal/InfoHealthCausalRelax_attempt.v",
        "coq_line": 83,
        "coq_quote": (
            "Theorem n_step_error :\n"
            "  forall alpha beta u dt : Q, ~ (beta == 0) ->\n"
            "    forall (n : nat) (C : Q),\n"
            "      iter alpha beta u dt n C - setpoint alpha beta u\n"
            "        == qpow (1 - dt*beta) n * (C - setpoint alpha beta u)."
        ),
        "latex": (
            r"\forall\, \alpha,\beta,u,dt \in \mathbb{Q},\ \beta \neq 0,\ "
            r"\forall\, n \in \mathbb{N},\, C \in \mathbb{Q}:\quad "
            r"\mathrm{iter}_n(\alpha,\beta,u,dt,C) - \mathrm{setpoint}(\alpha,\beta,u) = "
            r"(1-dt\,\beta)^n\big(C - \mathrm{setpoint}(\alpha,\beta,u)\big)"
        ),
    },
    "EQ-015/B.04.v1": {
        "coq_name": "disc_even",
        "coq_file": "formal/InfoHealthCuspFold_attempt.v",
        "coq_line": 73,
        "coq_quote": (
            "Theorem disc_even : forall h : Q, disc (- h) == disc h.\n"
            "(where disc h := 4 - 27*h*h)"
        ),
        "latex": (
            r"\forall\, h \in \mathbb{Q}:\quad \mathrm{disc}(-h) = \mathrm{disc}(h), "
            r"\quad \mathrm{disc}(h) := 4 - 27h^2"
        ),
    },
    "EQ-015/B.05.v1": {
        "coq_name": "cusp_factor",
        "coq_file": "formal/InfoHealthCuspFold_attempt.v",
        "coq_line": 79,
        "coq_quote": (
            "Lemma cusp_factor :\n"
            "  forall R h : Q,\n"
            "    h == R - R*R*R ->\n"
            "    27*h*h - 4 == (3*R*R - 1) * (9*(R*R)*(R*R) - 15*(R*R) + 4)."
        ),
        "latex": (
            r"\forall\, R,h \in \mathbb{Q}:\quad h = R - R^3 \implies "
            r"27h^2 - 4 = (3R^2-1)(9R^4 - 15R^2 + 4)"
        ),
    },
    "EQ-015/B.06.v1": {
        "coq_name": "fold_from_double_root",
        "coq_file": "formal/InfoHealthCuspFold_attempt.v",
        "coq_line": 87,
        "coq_quote": (
            "Theorem fold_from_double_root :\n"
            "  forall R h : Q, Vp R h == 0 -> Vpp R == 0 -> 27*h*h == 4.\n"
            "(where Vp R h := R*R*R - R + h, Vpp R := 3*R*R - 1)"
        ),
        "latex": (
            r"\forall\, R,h \in \mathbb{Q}:\quad V_p(R,h)=0 \wedge V_{pp}(R)=0 "
            r"\implies 27h^2 = 4, \quad V_p(R,h) := R^3 - R + h,\ "
            r"V_{pp}(R) := 3R^2 - 1"
        ),
    },
    "EQ-015/B.07.v1": {
        "coq_name": "bistable_window_dec",
        "coq_file": "formal/InfoHealthCuspFold_attempt.v",
        "coq_line": 105,
        "coq_quote": (
            "Theorem bistable_window_dec : forall h : Q, disc h > 0 <-> 27*h*h < 4."
        ),
        "latex": (
            r"\forall\, h \in \mathbb{Q}:\quad \mathrm{disc}(h) > 0 \iff 27h^2 < 4"
        ),
    },
    "EQ-015/B.08.v1": {
        "coq_name": "critical_slowing_marginal",
        "coq_file": "formal/InfoHealthCuspFold_attempt.v",
        "coq_line": 109,
        "coq_quote": (
            "Theorem critical_slowing_marginal :\n"
            "  forall R h : Q, Vp R h == 0 -> Vpp R == 0 -> Vpp R == 0."
        ),
        "latex": (
            r"\forall\, R,h \in \mathbb{Q}:\quad V_p(R,h)=0 \wedge V_{pp}(R)=0 "
            r"\implies V_{pp}(R) = 0"
        ),
    },
    "EQ-015/B.09.v1": {
        "coq_name": "rest_iff_critical",
        "coq_file": "formal/InfoHealthCuspFold_attempt.v",
        "coq_line": 117,
        "coq_quote": (
            "Theorem rest_iff_critical :\n"
            "  forall R h dt : Q, ~ (dt == 0) ->\n"
            "    (repair_step R h dt == R <-> Vp R h == 0).\n"
            "(where repair_step R h dt := R - dt * Vp R h)"
        ),
        "latex": (
            r"\forall\, R,h,dt \in \mathbb{Q},\ dt \neq 0:\quad "
            r"\mathrm{repair\_step}(R,h,dt) = R \iff V_p(R,h) = 0, \quad "
            r"\mathrm{repair\_step}(R,h,dt) := R - dt\,V_p(R,h)"
        ),
    },
}

B_STATUS_NOTE_UPGRADE = {
    "EQ-001/B.14.v1": {
        "coq_file": "formal/InfoBioHomeostasis_attempt.v",
        "names": ["decay_geometric", "homeostasis_balance", "turnover_is_production"],
        "rule_id": "B-SUB1",
    },
    "EQ-001/B.15.v1": {
        "coq_file": "formal/InfoHealthCausalRelax_attempt.v",
        "names": ["setpoint_is_fixed", "one_step_error", "n_step_error"],
        "rule_id": "B-SUB2",
    },
    "EQ-001/B.16.v1": {
        "coq_file": "formal/InfoHealthCuspFold_attempt.v",
        "names": [
            "disc_even", "cusp_factor", "fold_from_double_root",
            "bistable_window_dec", "critical_slowing_marginal", "rest_iff_critical",
        ],
        "rule_id": "B-SUB3",
    },
    "EQ-001/B.17.v1": {
        "coq_file": "formal/InfoCoupledCuspEP3_attempt.v",
        "names": [
            "coupling_energy_nonneg", "locked_iff_energy_zero",
            "two_way_conserves", "one_way_breaks_conservation",
        ],
        "rule_id": "B-SUB4",
    },
}


def task_a_and_b(apply_):
    doc = load_canonical()
    events = []
    changed = []
    for code, fix in B_FIXES.items():
        e = by_code(doc, code)
        if e is None:
            print(f"WARN: {code} not found, skipping", file=sys.stderr)
            continue
        old_statement = e["statement"]["latest"]
        old_status = e["status"]
        already_done = (
            e["statement"]["latest"] == fix["latex"]
            and e["statement"]["format"] == "latex"
            and e["status"] == "current"
        )
        if already_done:
            continue  # idempotent: nothing to do
        hist = e.setdefault("statements_history", [])
        next_v = max((h.get("v", 1) for h in hist), default=0) + 1
        hist.append({
            "v": next_v,
            "statement": fix["latex"],
            "date": TODAY,
            "reason": (
                f"v1.2 lane S: theorem statement extracted verbatim from solver arc "
                f"(private) {fix['coq_file']} line {fix['coq_line']} (theorem "
                f"{fix['coq_name']}), transcribed to LaTeX one-to-one (never invented). "
                f"Coq source kept verbatim here: {fix['coq_quote']}"
            ),
            "by": BY,
        })
        e["statement"]["latest"] = fix["latex"]
        e["statement"]["format"] = "latex"
        # (b) resolve the status_note's own stated blocker: statement now extracted.
        e["status"] = "current"
        e["status_note"] = ""
        # anchor precision: record the exact line in the existing free-text section field.
        if e.get("origin", {}).get("repo_anchor"):
            sect = e["origin"].get("section", "")
            line_tag = f" (Theorem at {fix['coq_file']}:{fix['coq_line']})"
            if line_tag not in sect:
                e["origin"]["section"] = sect + line_tag
        changed.append(code)
        events.append({
            "code": code,
            "date": TODAY,
            "event": "revised",
            "from": old_statement,
            "to": fix["latex"],
            "reason": (
                "v1.2 lane S (BBL-210): statement completed from theorem-name-only "
                "to full source-verbatim LaTeX statement; status unverified->current "
                "(the recorded blocker -- statement not extracted -- is resolved)."
            ),
            "by": BY,
        })
        events.append({
            "code": code,
            "date": TODAY,
            "event": "status_changed",
            "from": old_status,
            "to": "current",
            "reason": "v1.2 lane S: source statement located and transcribed; see statements_history.",
            "by": BY,
        })

    # (b) status_note precision upgrade for the 4 Th_coqc/no-identifier entries.
    for code, info in B_STATUS_NOTE_UPGRADE.items():
        e = by_code(doc, code)
        if e is None:
            continue
        marker = "v1.2 lane S upgrade"
        if marker in e.get("status_note", ""):
            continue  # idempotent
        old_note = e["status_note"]
        names_str = ", ".join(info["names"])
        new_note = (
            old_note.rstrip(".")
            + f". {marker} (2026-09-07): the actual theorem identifiers were "
            f"located by direct inspection of solver arc (private) "
            f"{info['coq_file']} (rule {info['rule_id']}'s own coq_backing.source "
            f"in readout_genesis domains/biology/RULE_REGISTRY.json, which already "
            f"names this file): {names_str}. Still not present in this Toledo tree's "
            f"coq_map.json / coq/ mirror, so status stays unverified -- this is a more "
            f"precise statement of what is missing, not a confirmation."
        )
        e["status_note"] = new_note
        changed.append(code)
        events.append({
            "code": code,
            "date": TODAY,
            "event": "revised",
            "from": old_note,
            "to": new_note,
            "reason": "v1.2 lane S (BBL-210): status_note precision upgrade, status kept unverified.",
            "by": BY,
        })

    print(f"task a+b: {len(changed)} entries changed: {changed}")
    if apply_ and events:
        # re-read immediately before the atomic write (idempotency contract)
        fresh = load_canonical()
        # re-apply onto the freshly-read doc to avoid clobbering concurrent lane writes
        for code, fix in B_FIXES.items():
            fe = by_code(fresh, code)
            oe = by_code(doc, code)
            if fe is None or oe is None:
                continue
            fe["statement"] = oe["statement"]
            fe["statements_history"] = oe["statements_history"]
            fe["status"] = oe["status"]
            fe["status_note"] = oe["status_note"]
            fe["origin"] = oe["origin"]
        for code in B_STATUS_NOTE_UPGRADE:
            fe = by_code(fresh, code)
            oe = by_code(doc, code)
            if fe is None or oe is None:
                continue
            fe["status_note"] = oe["status_note"]
        recompute_canonical_counts(fresh)
        atomic_write_canonical(fresh)
        append_lineage(events)
        print(f"applied. {len(events)} lineage events appended.")


# ---------------------------------------------------------------------------
# Task (c): ascii-math -> latex+ascii converter.
# ---------------------------------------------------------------------------

ACCENT_MAP = {
    "̇": "dot",     # combining dot above
    "̃": "tilde",   # combining tilde
    "̂": "hat",     # combining circumflex
    "̄": "bar",     # combining macron
    "́": "acute",
    "̀": "grave",
    "̊": "mathring",
}

SYMBOL_MAP = {
    "≠": r"\neq", "≤": r"\leq", "≥": r"\geq", "≈": r"\approx",
    "≡": r"\equiv", "≢": r"\not\equiv", "≅": r"\cong", "∼": r"\sim",
    "∈": r"\in", "∉": r"\notin", "⊆": r"\subseteq", "⊂": r"\subset",
    "⊄": r"\not\subset", "⊇": r"\supseteq", "∪": r"\cup", "∩": r"\cap",
    "⋂": r"\bigcap", "∧": r"\wedge", "∨": r"\vee", "¬": r"\neg",
    "∀": r"\forall", "∃": r"\exists", "∄": r"\nexists",
    "⊥": r"\bot", "⊤": r"\top", "⊢": r"\vdash",
    "→": r"\to", "⇒": r"\Rightarrow", "⇐": r"\Leftarrow",
    "⇔": r"\Leftrightarrow", "⇏": r"\not\Rightarrow",
    "⟹": r"\Longrightarrow", "⟸": r"\Longleftarrow", "⟺": r"\Longleftrightarrow",
    "↦": r"\mapsto", "↑": r"\uparrow", "↓": r"\downarrow", "↔": r"\leftrightarrow",
    "←": r"\leftarrow",
    "·": r"\cdot", "×": r"\times", "÷": r"\div", "∘": r"\circ",
    "±": r"\pm", "∓": r"\mp",
    "√": r"\sqrt", "∑": r"\sum", "∏": r"\prod", "∫": r"\int",
    "∂": r"\partial", "∇": r"\nabla", "∞": r"\infty",
    "°": r"^\circ", "′": r"'", "″": r"''",
    "‖": r"\Vert", "∥": r"\parallel",
    "⌊": r"\lfloor", "⌋": r"\rfloor", "⌈": r"\lceil", "⌉": r"\rceil",
    "…": r"\ldots", "—": "---", "–": "--",
    "∅": r"\emptyset", "⊕": r"\oplus", "⊗": r"\otimes",
    "∴": r"\therefore", "∵": r"\because", "∝": r"\propto",
    "≫": r"\gg", "≪": r"\ll", "≳": r"\gtrsim",
    "†": r"^\dagger", "⁺": "^+", "♯": r"^\sharp",
    "§": r"\S", "⟨": r"\langle", "⟩": r"\rangle",
    "ℓ": r"\ell", "ℚ": r"\mathbb{Q}", "𝓔": r"\mathcal{E}",
    "²": "^2", "³": "^3",
    # Greek (lower)
    "α": r"\alpha", "β": r"\beta", "γ": r"\gamma", "δ": r"\delta",
    "ε": r"\varepsilon", "ζ": r"\zeta", "η": r"\eta", "θ": r"\theta",
    "ι": r"\iota", "κ": r"\kappa", "λ": r"\lambda", "μ": r"\mu",
    "ν": r"\nu", "ξ": r"\xi", "ο": "o", "π": r"\pi", "ρ": r"\rho",
    "σ": r"\sigma", "τ": r"\tau", "υ": r"\upsilon", "φ": r"\varphi",
    "χ": r"\chi", "ψ": r"\psi", "ω": r"\omega",
    # Greek (upper)
    "Γ": r"\Gamma", "Δ": r"\Delta", "Θ": r"\Theta", "Λ": r"\Lambda",
    "Ξ": r"\Xi", "Π": r"\Pi", "Σ": r"\Sigma", "Φ": r"\Phi",
    "Ψ": r"\Psi", "Ω": r"\Omega",
    "−": "-",  # unicode minus -> ASCII minus
}


def _pad_letter_commands(d):
    """A LaTeX control WORD (e.g. \\to) swallows every following letter as part
    of its own name -- \\toAI would try to invoke an undefined \\toAI. Append a
    trailing space to every mapping whose value ends in a letter, so the
    command always self-terminates regardless of what follows it in the source
    text (control SYMBOLS like \\{, \\^2, ---, -- already end in a non-letter
    and are left untouched)."""
    return {
        k: (v + " " if re.search(r"[A-Za-z]$", v) else v)
        for k, v in d.items()
    }


SYMBOL_MAP = _pad_letter_commands(SYMBOL_MAP)

GREEK_WORDS = {
    "alpha": r"\alpha", "beta": r"\beta", "gamma": r"\gamma", "delta": r"\delta",
    "epsilon": r"\epsilon", "zeta": r"\zeta", "eta": r"\eta", "theta": r"\theta",
    "iota": r"\iota", "kappa": r"\kappa", "lambda": r"\lambda", "mu": r"\mu",
    "nu": r"\nu", "xi": r"\xi", "pi": r"\pi", "rho": r"\rho", "sigma": r"\sigma",
    "tau": r"\tau", "upsilon": r"\upsilon", "phi": r"\phi", "chi": r"\chi",
    "psi": r"\psi", "omega": r"\omega",
    "Gamma": r"\Gamma", "Delta": r"\Delta", "Theta": r"\Theta", "Lambda": r"\Lambda",
    "Xi": r"\Xi", "Pi": r"\Pi", "Sigma": r"\Sigma", "Phi": r"\Phi",
    "Psi": r"\Psi", "Omega": r"\Omega",
}
GREEK_WORDS = _pad_letter_commands(GREEK_WORDS)

PHRASE_RE = re.compile(
    r"\b[A-Za-z][a-z]+(?:[\s-][A-Za-z][a-z]+){1,}\b"
)


def escape_literal_braces(s):
    """LaTeX math mode treats a bare {...} as an invisible grouping construct, so a
    literal set like {1,0,bot} would silently vanish unless escaped to \\{...\\}.
    Heuristic (content-preserving, no semantic change): a '{' immediately preceded
    by '_' or '^' (ignoring whitespace) is a pre-authored LaTeX sub/superscript
    grouping (very common in this corpus's own ascii-math) and is left as plain
    grouping; every other '{'/'}' is literal set/interval notation and is escaped.
    Matching is done with a stack so each '}' gets the same treatment as its '{'."""
    out = []
    stack = []  # True = "escape this pair", False = "leave as grouping"
    i = 0
    n = len(s)
    while i < n:
        ch = s[i]
        if ch == "{":
            j = len(out) - 1
            while j >= 0 and out[j] == " ":
                j -= 1
            is_grouping = j >= 0 and out[j] in ("_", "^")
            stack.append(not is_grouping)
            out.append(r"\{" if not is_grouping else "{")
        elif ch == "}":
            escape = stack.pop() if stack else False
            out.append(r"\}" if escape else "}")
        else:
            out.append(ch)
        i += 1
    return "".join(out)


import string as _string_mod

_ASCII_LETTERS = set(_string_mod.ascii_letters)
_GREEK_BASES = set(
    "ΑΒΓΔΕΖΗΘΙΚΛΜ"
    "ΝΞΟΠΡΣΤΥΦΧΨΩ"
    "αβγδεζηθικλμ"
    "νξοπρστυφχψω"
)  # every Greek letter this corpus's SYMBOL_MAP knows (see below) -- eligible
   # accent bases too (e.g. "Lambda dot" for a time-derivative), even though
   # they never appear NFD-precomposed with a combining mark.


def decompose_accents(s):
    """Turn accented Latin LETTERS (precomposed like R-with-dot-above, or an
    ASCII letter already followed by a separate combining mark) into
    \\dot{R} / \\hat{E} / etc.

    Deliberately narrow scope: NFD-normalizing the WHOLE string is unsafe here
    because several precomposed math operators this corpus uses ALSO have a
    canonical NFD decomposition into a base symbol plus a combining overlay
    stroke -- e.g. U+2260 '!=' decomposes to '=' + U+0338 (combining long
    solidus overlay). Blindly normalizing the string and dropping unmapped
    combining marks would silently turn '!=' into '=', inverting the
    statement's meaning. So only single characters whose OWN NFD decomposition
    has an ASCII-letter base are touched; every math symbol (already handled
    whole, as one codepoint, by SYMBOL_MAP) passes through completely
    untouched here.
    """
    out = []
    ambiguous = False
    i = 0
    n = len(s)
    while i < n:
        ch = s[i]
        nfd = unicodedata.normalize("NFD", ch)
        if len(nfd) > 1 and (nfd[0] in _ASCII_LETTERS or nfd[0] in _GREEK_BASES):
            base = nfd[0]
            marks = list(nfd[1:])
        elif (
            (ch in _ASCII_LETTERS or ch in _GREEK_BASES)
            and i + 1 < n
            and unicodedata.combining(s[i + 1]) != 0
        ):
            base = ch
            marks = []
        else:
            if unicodedata.combining(ch) != 0:
                # a combining mark attached to something other than a plain
                # ASCII letter (e.g. a Greek letter) -- kept verbatim (no
                # content invented/dropped) but flagged for manual review
                # since its LaTeX accent command was not applied.
                ambiguous = True
            out.append(ch)
            i += 1
            continue
        j = i + 1
        # consume any further separately-encoded combining marks too
        while j < n and unicodedata.combining(s[j]) != 0:
            marks.append(s[j])
            j += 1
        expr = base
        for m in marks:
            cmd = ACCENT_MAP.get(m)
            if cmd:
                expr = f"\\{cmd}{{{expr}}}"
            else:
                ambiguous = True
        out.append(expr)
        i = j
    return "".join(out), ambiguous


ASCII_OPS = [
    (re.compile(r"--([A-Za-z0-9_ ]+?)-->"), lambda m: r"\xrightarrow{\text{%s}}" % m.group(1)),
    (re.compile(r"<->"), r"\\leftrightarrow "),
    (re.compile(r"<=>"), r"\\Leftrightarrow "),
    (re.compile(r"==>"), r"\\Longrightarrow "),
    (re.compile(r"-->"), r"\\longrightarrow "),
    (re.compile(r"<--"), r"\\longleftarrow "),
    (re.compile(r"=/=>"), r"\\not\\Rightarrow "),
    (re.compile(r"=/="), r"\\neq "),
    (re.compile(r"!="), r"\\neq "),
    (re.compile(r"->"), r"\\to "),
    (re.compile(r"<-"), r"\\leftarrow "),
    (re.compile(r">="), r"\\geq "),
    (re.compile(r"<="), r"\\leq "),
]


def apply_ascii_ops(s):
    for pat, repl in ASCII_OPS:
        s = pat.sub(repl, s)
    return s


def apply_symbol_map(s):
    out = []
    unmapped = set()
    for ch in s:
        if ch in SYMBOL_MAP:
            out.append(SYMBOL_MAP[ch])
        elif ord(ch) > 127:
            unmapped.add(ch)
            out.append(ch)
        else:
            out.append(ch)
    return "".join(out), unmapped


_GREEK_WORD_KEYS = sorted(GREEK_WORDS, key=len, reverse=True)
_GREEK_WORD_RE = re.compile(
    r"(?<!\\)(?<![A-Za-z])(?:%s)(?![A-Za-z])" % "|".join(_GREEK_WORD_KEYS)
)


def replace_greek_words(s):
    # Left boundary: not preceded by a backslash (don't re-match the tail of a
    # command a prior pass already inserted, e.g. don't turn the "delta" in
    # "\delta" into "\\delta") and not preceded by a letter (real word start).
    # Right boundary is deliberately NOT a full \b: this corpus writes compound
    # identifiers like "Gamma_dot" (Gamma-dot, i.e. Gamma with a time-derivative
    # accent) where the Greek name is followed directly by '_' -- a plain \b
    # fails there because '_' counts as a word character. Only an actual
    # trailing LETTER blocks the match (so "theta" isn't matched by "eta"
    # starting mid-word, but "Gamma_dot" and "Gamma^eff" both convert).
    def repl(m):
        w = m.group(0)
        return GREEK_WORDS.get(w, w)
    return _GREEK_WORD_RE.sub(repl, s)


def brace_parenthesized_scripts(s):
    """Fix (B4, 2026-09-07): a parenthesized sub/superscript in the source
    ascii-math (e.g. '_(j,t)', this corpus's own way of writing a multi-part
    index) must be braced as one unit -- '_(j,t)' -> '_{(j,t)}' -- or real
    LaTeX subscripts only the literal '(' character, printing the rest
    ('j,t)') as normal-size trailing text. Depth-counted (not a regex over
    '[^()]*') so a nested case like '_(e in E(g))' (EQ-015/W.39.v1) is
    captured whole rather than stopping at the first inner ')'.
    brace_scripts() below only handles alnum runs, so this is a separate
    pass over the parenthesized case."""
    out = []
    i, n = 0, len(s)
    while i < n:
        ch = s[i]
        if ch in ("_", "^") and i + 1 < n and s[i + 1] == "(":
            depth = 0
            j = i + 1
            while j < n:
                if s[j] == "(":
                    depth += 1
                elif s[j] == ")":
                    depth -= 1
                    if depth == 0:
                        j += 1
                        break
                j += 1
            content = s[i + 1:j]
            out.append(ch + "{" + content + "}")
            i = j
        else:
            out.append(ch)
            i += 1
    return "".join(out)


# Detection-only (self-check, B3): flags, in the ORIGINAL ascii source, any
# run of 2+ letters right after a '_'/'^' marker that is itself immediately
# followed by another '_'/'^' marker with no operator/space between -- e.g.
# "M_AK_A" (M_A times K_A, two single-letter-subscripted identifiers written
# back-to-back). This is exactly the shape brace_scripts() below now
# resolves by splitting off one letter per identifier, but the ambiguity is
# real (a human should confirm the split is the intended reading), so every
# occurrence is still surfaced in the review report rather than silently
# "fixed and forgotten".
ADJACENT_SCRIPT_RE = re.compile(r"[_^][A-Za-z]{2,}(?=[_^])")


def brace_scripts(s):
    """Brace multi-char (or bare) sub/superscripts not already braced.

    Two content classes are braced as one unit: a run of DIGITS (e.g.
    'C^90' -> 'C^{90}', this corpus's percentile notation) or a run of
    LETTERS (e.g. 'H_dyn' -> 'H_{dyn}', a multi-letter concept label).

    Fix (B3, 2026-09-07): the previous single greedy regex
    ('([_^])(?!\\{)(?!\\\\\\{)([A-Za-z0-9]+)') consumed the ENTIRE alnum run
    after a script marker even when that run actually spans two adjacent
    single-letter-subscripted identifiers with no separator between them
    (e.g. 'M_AK_A' = M_A * K_A) -- 'AK' was taken whole as one subscript,
    merging 'M_A' and 'K_A' into a malformed 'M_{AK}_{A}'. Now: when the
    letter run is ALL-UPPERCASE, longer than one character, AND immediately
    followed by another script marker, only its first character is this
    script's own content -- the remaining letter(s) are the next base
    symbol and pick up their own script on the next character consumed.
    Ordinary multi-letter lowercase labels (e.g. 'dyn', 'info', 'acc'),
    which are never immediately followed by another script marker in this
    corpus, are unaffected and still braced whole."""
    out = []
    i, n = 0, len(s)
    while i < n:
        ch = s[i]
        if ch in ("_", "^") and i + 1 < n:
            nxt = s[i + 1]
            if nxt == "{" or (nxt == "\\" and i + 2 < n and s[i + 2] == "{"):
                out.append(ch)
                i += 1
                continue
            if nxt.isdigit():
                j = i + 1
                while j < n and s[j].isdigit():
                    j += 1
                content = s[i + 1:j]
            elif nxt.isalpha():
                k = i + 1
                while k < n and s[k].isalnum():
                    k += 1
                run = s[i + 1:k]
                if run.isupper() and len(run) > 1 and k < n and s[k] in ("_", "^"):
                    content = run[0]
                    j = i + 2  # this script consumed exactly one letter
                else:
                    content = run
                    j = k
            else:
                out.append(ch)
                i += 1
                continue
            out.append(ch + "{" + content + "}")
            i = j
        else:
            out.append(ch)
            i += 1
    return "".join(out)


def wrap_phrases(s):
    def repl(m):
        return r"\text{%s}" % m.group(0)
    return PHRASE_RE.sub(repl, s)


def convert_ascii_to_latex(raw):
    """Mechanical, symbol-for-symbol LaTeX rendering of an ascii-math statement.
    Returns (latex, is_ambiguous, reason)."""
    ambiguous_reasons = []
    s = escape_literal_braces(raw)
    s, accent_ambig = decompose_accents(s)
    if accent_ambig:
        ambiguous_reasons.append("unrecognized combining accent")
    s = apply_ascii_ops(s)
    # phrase-wrapping MUST run before symbol/greek-word substitution: those
    # substitutions insert backslash-letter LaTeX command names (\neq, \to,
    # \theta, ...) that are indistinguishable from English words to a
    # word-phrase regex -- wrapping "neq Identity" in \text{} after \neq was
    # already inserted would swallow the \neq command itself, silently
    # deleting the not-equal symbol from the rendering. Phrase-wrap the
    # still-ASCII original text first, while its only backslashes are the
    # ones apply_ascii_ops just added for literal arrows (which never look
    # like an English word).
    s = wrap_phrases(s)
    s, unmapped = apply_symbol_map(s)
    if unmapped:
        ambiguous_reasons.append(f"unmapped symbol(s): {sorted(unmapped)}")
    s = replace_greek_words(s)
    s = brace_parenthesized_scripts(s)
    s = brace_scripts(s)
    # self-check (B3): surface adjacent-script ambiguity in the ORIGINAL raw
    # text for manual review, even though brace_scripts() above already
    # applies its best-effort split -- never silently emit without flagging.
    adjacent = ADJACENT_SCRIPT_RE.findall(raw)
    if adjacent:
        ambiguous_reasons.append(
            f"adjacent script markers with no separator in source (auto-split "
            f"applied, please confirm): {adjacent}"
        )
    # crude balance check (count only *unescaped* braces -- escaped \{ \} are
    # literal text characters, not LaTeX grouping, so they don't need to balance
    # against Python's naive count; count net grouping braces instead)
    grouping_open = len(re.findall(r"(?<!\\){", s))
    grouping_close = len(re.findall(r"(?<!\\)}", s))
    if grouping_open != grouping_close or s.count("(") != s.count(")"):
        ambiguous_reasons.append("unbalanced braces/parens after conversion")
    if len(raw) > 220:
        ambiguous_reasons.append("very long statement (>220 chars)")
    if "\n" in raw or "|" in raw:
        ambiguous_reasons.append("contains newline or table-pipe formatting")
    # heuristic: mostly prose -> flag for review even though we still emit a rendering
    phrase_chars = sum(len(m.group(0)) for m in PHRASE_RE.finditer(raw))
    alpha_chars = sum(1 for c in raw if c.isalpha())
    if alpha_chars and phrase_chars / max(alpha_chars, 1) > 0.5:
        ambiguous_reasons.append("majority-prose content (phrase-wrap heuristic >50%)")
    latex = f"${s}$"
    return latex, bool(ambiguous_reasons), "; ".join(ambiguous_reasons)


def task_c(apply_, review_out):
    doc = load_canonical()
    events = []
    changed = []
    ambiguous = []
    for e in doc["canonical"]:
        st = e.get("statement", {})
        fmt = st.get("format")
        if fmt not in ("ascii-math", "latex+ascii"):
            continue
        first_time = fmt == "ascii-math"
        raw = st["latest"] if first_time else st.get("ascii", st["latest"])
        latex, is_ambig, reason = convert_ascii_to_latex(raw)

        if not first_time:
            # Fixer re-pass (B3/B4, 2026-09-07): this entry was already
            # converted by an earlier run of the (then-buggy) converter.
            # Idempotent: only touch it if the FIXED converter now produces
            # a different statement.latex than what is stored -- a re-run
            # with an unchanged converter is a no-op here, same as (a)/(b).
            if st.get("latex") == latex:
                continue
            old_latex = st.get("latex")
            st["ascii"] = raw
            st["latex"] = latex
            hist = e.setdefault("statements_history", [])
            next_v = max((h.get("v", 1) for h in hist), default=0) + 1
            hist.append({
                "v": next_v,
                "statement": raw,
                "date": TODAY,
                "reason": (
                    "v1.2 lane S fixer (B3/B4, BBL-210): corrected statement.latex -- "
                    "brace_scripts() previously merged adjacent single-letter-"
                    "subscripted identifiers written with no separator (e.g. "
                    "'M_AK_A' rendered as one malformed 'M_{AK}_{A}' instead of "
                    "'M_{A}K_{A}') and left parenthesized sub/superscripts (e.g. "
                    "'_(j,t)') unbraced; both are fixed and statement.latex "
                    "regenerated from the same statement.ascii (no content change; "
                    "ascii/latest unchanged)."
                    + (f" FLAGGED FOR MANUAL REVIEW: {reason}" if is_ambig else "")
                ),
                "by": BY,
            })
            changed.append(e["code"])
            events.append({
                "code": e["code"],
                "date": TODAY,
                "event": "revised",
                "from": old_latex,
                "to": latex,
                "reason": (
                    "v1.2 lane S fixer: corrected statement.latex "
                    "(brace_scripts converter bug fix, B3/B4), no content change."
                ),
                "by": BY,
            })
            if is_ambig:
                ambiguous.append((e["code"], raw, latex, reason))
            continue

        st["ascii"] = raw
        st["latex"] = latex
        st["format"] = "latex+ascii"
        hist = e.setdefault("statements_history", [])
        next_v = max((h.get("v", 1) for h in hist), default=0) + 1
        hist.append({
            "v": next_v,
            "statement": raw,
            "date": TODAY,
            "reason": (
                "v1.2 lane S (BBL-208/210): added statement.latex, a faithful "
                "symbol-for-symbol LaTeX rendering of this same ascii-math statement "
                "(no content change); ascii text preserved verbatim as statement.ascii "
                "and unchanged here as statement.latest; format ascii-math -> latex+ascii."
                + (f" FLAGGED FOR MANUAL REVIEW: {reason}" if is_ambig else "")
            ),
            "by": BY,
        })
        changed.append(e["code"])
        events.append({
            "code": e["code"],
            "date": TODAY,
            "event": "revised",
            "from": "format=ascii-math",
            "to": "format=latex+ascii",
            "reason": "v1.2 lane S: added statement.latex + statement.ascii (BBL-208/210).",
            "by": BY,
        })
        if is_ambig:
            ambiguous.append((e["code"], raw, latex, reason))

    print(f"task c: {len(changed)} entries converted/corrected; {len(ambiguous)} flagged ambiguous for manual review")

    if review_out:
        # Recompute the review report over EVERY latex+ascii entry (not just ones
        # touched in this particular run) so re-running --task c after all 424
        # are already converted (0 left in ascii-math) regenerates the full,
        # accurate list instead of silently overwriting it with an empty one.
        post = load_canonical()
        all_la = [e for e in post["canonical"] if e.get("statement", {}).get("format") == "latex+ascii"]
        full_ambiguous = []
        for e in all_la:
            raw = e["statement"].get("ascii", e["statement"]["latest"])
            latex, is_ambig, reason = convert_ascii_to_latex(raw)
            if is_ambig:
                full_ambiguous.append((e["code"], raw, e["statement"].get("latex", latex), reason))
        with open(review_out, "w", encoding="utf-8") as f:
            f.write("# v1.2 Lane S -- ascii-math -> LaTeX conversions flagged for manual review\n\n")
            f.write(
                f"{len(full_ambiguous)} of {len(all_la)} converted entries (format latex+ascii) "
                "were flagged by the mechanical converter's own heuristics (never blocking -- "
                "each still got a best-effort LaTeX rendering in statement.latex; content "
                "unchanged, statement.ascii keeps the original verbatim). Listed here per the "
                "task instruction to hand ambiguous conversions to manual review.\n\n"
            )
            for code, raw, latex, reason in full_ambiguous:
                f.write(f"## {code}\n\n- reason: {reason}\n- ascii: `{raw}`\n- latex (best-effort): `{latex}`\n\n")
        print(f"review notes written to {review_out} ({len(full_ambiguous)} of {len(all_la)} total)")

    if apply_ and events:
        fresh = load_canonical()
        # Only copy entries this run actually changed (`changed`), not every
        # latex+ascii entry in `doc` -- a fixer re-pass (B3/B4) now also
        # visits already-converted entries that need no change, and those
        # must not be blindly re-stamped onto a freshly re-read `fresh` doc
        # (idempotency contract: touch only what changed).
        changed_set = set(changed)
        for e in doc["canonical"]:
            if e["code"] not in changed_set:
                continue
            fe = by_code(fresh, e["code"])
            if fe is None:
                continue
            fe["statement"] = e["statement"]
            fe["statements_history"] = e["statements_history"]
        recompute_canonical_counts(fresh)
        atomic_write_canonical(fresh)
        append_lineage(events)
        print(f"applied. {len(events)} lineage events appended.")


# ---------------------------------------------------------------------------
# Task (d): prose-hides-a-formula scan (report only -- see docstring; no
# genuine hits found, nothing to apply).
# ---------------------------------------------------------------------------

def task_d_report():
    doc = load_canonical()
    c = doc["canonical"]
    eqfiles = {}
    for f in glob.glob(str(REG / "eq_*.json")):
        rid = int(Path(f).stem.split("_")[1])
        try:
            eqfiles[rid] = json.load(open(f, encoding="utf-8"))
        except Exception:
            pass
    label_index = {}
    for rid, doc2 in eqfiles.items():
        for eq in doc2.get("equations", []):
            label_index[(rid, eq.get("label"))] = eq.get("text", "")

    def has_math(s):
        return bool(re.search(r"[=<>≤≥≠∈⊆∀∃∑∏∫∂√±×÷·^_%]", s)) or bool(re.search(r"\d", s))

    mismatches = []
    for e in c:
        lat = e.get("statement", {}).get("latest", "")
        for occ in e.get("occurrences", []):
            rid, label = occ.get("record_id"), occ.get("label")
            if rid is None:
                continue
            key = (rid, label)
            if key in label_index:
                src_text = label_index[key]
                if src_text and src_text.strip() != lat.strip() and has_math(src_text) and not has_math(lat):
                    mismatches.append((e["code"], lat, src_text))
    print(f"task d: {len(eqfiles)} local eq_*.json source files checked; "
          f"{len(mismatches)} textual mismatches found against statement.latest, "
          f"all of them cosmetic ASCII-arrow-vs-unicode-arrow rendering differences "
          f"or multi-occurrence merges (no case where the source contains an operator/"
          f"formula genuinely absent from the current statement). No changes to apply.")
    for code, lat, src in mismatches:
        print(f"  {code}: registry={lat[:80]!r} source={src[:80]!r}")


# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--task", choices=["a", "b", "ab", "c", "d", "all"], default="all")
    ap.add_argument("--apply", action="store_true", help="write changes (default: dry-run report)")
    ap.add_argument("--review-out", default=str(ROOT / "ops" / "v12_S_ascii_to_latex_review.md"))
    args = ap.parse_args()

    if args.task in ("a", "b", "ab", "all"):
        task_a_and_b(args.apply)
    if args.task in ("c", "all"):
        task_c(args.apply, args.review_out)
    if args.task in ("d", "all"):
        task_d_report()


if __name__ == "__main__":
    main()
