"""toledo_mcp.lint — TODO IDM-5: `toledo_lint`, a continuum-injection linter.

Standard library only. Reads a statement (LaTeX/ascii/prose), optionally
paired with a Toledo `code` for context, and flags places where a classical
continuum concept has been silently smuggled in — the exact failure mode the
`information-discrete-math` skill's contaminated-concept table exists to
catch (see that skill's SKILL.md, "The contaminated-concept ->
discrete-replacement TABLE"). Every rule below quotes that table's own
sentence verbatim for `why`/`discrete_replacement` rather than paraphrasing
it, so the two documents cannot silently drift apart.

**This lint never blocks (P24: it disciplines, not gates).** The founder
rule this whole `mcp/` package otherwise enforces ("every equation must be
looked up in Toledo before use") is a hard USABLE/NOT-USABLE gate
(`verdict.py`); this module is deliberately NOT that — a continuum concept
appearing in a statement is not itself grounds to refuse the statement, only
grounds to flag it so a human/agent can look at the IDM ladder object that
carries the discrete replacement. `verdict` is always one of exactly two
strings: `"clean"` or `"continuum_injection_warned"` — there is no
`"blocked"`/`"rejected"` value in this module's vocabulary.

Each finding is a plain dict:

    {
        "class": "I1",                     # the IDM table's own short code
        "matched_text": "completeness of ℝ",
        "why": "<verbatim sentence from the skill's table>",
        "discrete_replacement": "<verbatim sentence from the skill's table>",
        "toledo_code": "R",                # resolved at RUNTIME by alias, or
        "severity": "warn",                # "code pending" if the alias is
    }                                       # not (yet) registered — fail soft

`toledo_code` is never hand-typed as a literal Toledo code in this file —
`RULES` below carries only the registry ALIAS string (the same
`"IDM:..."`-prefixed aliases `registry/proposals/idm.merged.json`/
`registry/genesis_root.json`'s IDM root rows actually carry), and
`resolve_toledo_code` looks the real code up against the live registry each
call, through the same `cache.py` every other tool in this package reads
from. If the registry does not (yet) carry that alias — a plausible,
non-hypothetical state while the IDM root-extension entries are still
landing — this fails soft with the literal string `"code pending"` rather
than raising or fabricating a code.
"""
from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Any

try:
    from . import cache as cache_mod
except ImportError:  # pragma: no cover - see server.py/cli.py's own fallback
    import pathlib
    import sys
    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
    from toledo_mcp import cache as cache_mod


@dataclass(frozen=True)
class LintRule:
    cls: str  # the IDM table's own short code, e.g. "I1", "Z3", "angle_degree"
    label: str  # short human name for this rule
    pattern: "re.Pattern[str]"
    why: str  # verbatim sentence(s) from the SKILL.md table
    discrete_replacement: str  # verbatim sentence(s) from the SKILL.md table
    alias: str  # the registry alias (e.g. "IDM:reals-R") this rule's
    # replacement object is registered under — resolved to a real Toledo
    # code at call time by `resolve_toledo_code`, never hand-typed here.


# ---------------------------------------------------------------------------
# The rule table. `why`/`discrete_replacement` are quoted verbatim from
# information-discrete-math's SKILL.md "contaminated-concept ->
# discrete-replacement TABLE" and its "four injected infinities + four
# injected zeros" section — never paraphrased, so a change to that skill's
# wording is visible as a diff here rather than silently going stale.
# ---------------------------------------------------------------------------

RULES: list[LintRule] = [
    LintRule(
        cls="I1",
        label="real-number / ℝ-completeness",
        pattern=re.compile(
            r"\breal numbers?\b|\bℝ-complet\w*|\bLUB\b|\bDedekind\b|"
            r"\blimits? that lands?\b|\bcompleteness of (?:the reals|ℝ)\b",
        ),
        why=(
            "I1 ℝ-completeness (LUB/Dedekind) — makes √2, π \"numbers\"; "
            "limits always land."
        ),
        discrete_replacement=(
            "ℝ = a readout of the discrete (Bishop regular Cauchy sequences "
            "of ℚ); only finite ℚ-approximants ever appear; √2, π are "
            "non-readouts"
        ),
        alias="IDM:reals-R",
    ),
    LintRule(
        cls="I2",
        label="h→0 infinite divisibility",
        pattern=re.compile(
            r"\bh\s*(?:→|->)\s*0\b|\binfinite divisibility\b|\bcontinuum PDE\b",
        ),
        why=(
            "I2 infinite divisibility of space/time (h→0) — the continuum "
            "PDE, \"every scale to zero\"."
        ),
        discrete_replacement=(
            "a finite step / a τ_c floor (machine-checked: nothing below "
            "the first tick)"
        ),
        alias="IDM:naturals-D",
    ),
    LintRule(
        cls="I3",
        label="infinite scale separation",
        pattern=re.compile(
            r"\bRe\s*(?:→|->)\s*(?:∞|infinity)\b|\bΛ\s*(?:→|->)\s*(?:∞|infinity)\b|"
            r"\binfinite scale separation\b|\bUV divergences?\b",
        ),
        why=(
            "I3 infinite scale separation (Re→∞, UV Λ→∞) — infinite range, "
            "UV divergences."
        ),
        discrete_replacement=(
            "ℚ has no +∞; readouts are finite; a \"limit\" is the finite "
            "approach, never the endpoint"
        ),
        alias="IDM:rationals-Q",
    ),
    LintRule(
        cls="I4",
        label="actual +∞",
        pattern=re.compile(
            r"\+∞|\bN\s*(?:→|->)\s*∞\b|\binfinity\b|\bblow-up\b|"
            r"\bsingularit(?:y|ies)\b",
        ),
        why="I4 actual +∞ (norms/energies →∞) — blow-up, singularities.",
        discrete_replacement=(
            "ℚ has no +∞; readouts are finite; a \"limit\" is the finite "
            "approach, never the endpoint"
        ),
        alias="IDM:rationals-Q",
    ),
    LintRule(
        cls="Z1",
        label="point of zero extent",
        pattern=re.compile(
            r"\bpoints? of zero (?:extent|size)\b|\br\s*=\s*0\b|"
            r"\bdelta-source\b|\bδ-source\b",
        ),
        why=(
            "Z1 the point (zero extent, r=0) ... the point (zero extent, "
            "r=0) | Z1 — a geometric point / δ-source"
        ),
        discrete_replacement=(
            "a node / a retained distinction (a graph vertex; finite, has "
            "neighbours)"
        ),
        alias="IDM:L_R",
    ),
    LintRule(
        cls="Z2",
        label="exact-zero spacing",
        pattern=re.compile(
            r"\bexact[- ]zero spacing\b|\breached continuum\b",
        ),
        why="Z2 exact-zero spacing (reached continuum)",
        discrete_replacement=(
            "a refused non-readout (approached, never reached) or the L_R "
            "kernel = indistinguishability (uniformity), NOT a void"
        ),
        alias="IDM:L_R",
    ),
    LintRule(
        cls="Z3",
        label="absolute rest / exact vacuum",
        pattern=re.compile(
            r"\bv\s*=\s*0\b|\bT\s*=\s*0\b|\babsolute rest\b|\bexact vacuum\b",
        ),
        why="Z3 absolute rest / exact vacuum (v=0, T=0)",
        discrete_replacement=(
            "a refused non-readout (approached, never reached) or the L_R "
            "kernel = indistinguishability (uniformity), NOT a void"
        ),
        alias="IDM:L_R",
    ),
    LintRule(
        cls="Z4",
        label="the void",
        pattern=re.compile(r"\bthe (?:true )?void\b"),
        why="Z4 the true void.",
        discrete_replacement=(
            "a refused non-readout (approached, never reached) or the L_R "
            "kernel = indistinguishability (uniformity), NOT a void"
        ),
        alias="IDM:L_R",
    ),
    LintRule(
        cls="angle_degree",
        label="angle / degree / acos / atan2",
        pattern=re.compile(r"\bacos\b|\batan2\b|\bdegrees?\b|\bangle\b"),
        why=(
            "angle / degree (the classic trap) | acos/atan2/degree need "
            "ℝ-completeness = I1 — inverse-trig are analytic objects, not "
            "finite computations"
        ),
        discrete_replacement=(
            "an overlap fraction = Born-rule ratio overlap(v,e) = "
            "|⟨v,e⟩_G|² / (⟨v,v⟩_G · ⟨e,e⟩_G) (rational: +,·,÷ only — no "
            "trig, no π, no ℝ) or a rational turning number (a fraction of "
            "one full cycle)"
        ),
        alias="IDM:L_R",
    ),
    LintRule(
        cls="coordinate_distance",
        label="distance = coordinate difference",
        pattern=re.compile(r"√\s*Σ|Σ\s*\(?Δx|\\sqrt\{?\\sum"),
        why=(
            "distance = coordinate difference √Σ(Δxᵢ)² | embeds an ℝ "
            "coordinate frame"
        ),
        discrete_replacement=(
            "distance = accumulated retained resistance along the optimal "
            "path (a graph geodesic); the triangle inequality holds because "
            "a detour cannot be cheaper than the direct optimum"
        ),
        alias="IDM:L_R",
    ),
    LintRule(
        cls="continuum_operator",
        label="operator on a continuum (∂², d'Alembertian)",
        pattern=re.compile(r"∂²|d['’]Alembertian|\bwave operator\b"),
        why=(
            "operator on a continuum (∂², d'Alembertian) | I2 | the graph "
            "Laplacian L_R (lap/B: symmetric, PSD, kernel ⊇ constants, "
            "div-grad, summation-by-parts) — axiom-free; ∂² is a "
            "+ℝ-axioms readout of it"
        ),
        discrete_replacement=(
            "the graph Laplacian L_R (lap/B: symmetric, PSD, kernel ⊇ "
            "constants, div-grad, summation-by-parts) — axiom-free; ∂² is a "
            "+ℝ-axioms readout of it"
        ),
        alias="IDM:L_R",
    ),
    LintRule(
        cls="epsilon_delta_continuity",
        label="continuity / smooth (ε–δ over ℝ) as primitive",
        pattern=re.compile(r"ε[-–]δ|\bepsilon-delta\b"),
        why=(
            "continuity / \"smooth\" (ε–δ over ℝ) | I1+I2 | discrete "
            "Lipschitz / non-expansive maps; ε–δ continuity is a later "
            "derived rung on ℝ-as-readout, not primitive"
        ),
        discrete_replacement=(
            "discrete Lipschitz / non-expansive maps; ε–δ continuity is a "
            "later derived rung on ℝ-as-readout, not primitive"
        ),
        alias="IDM:reals-R",
    ),
    LintRule(
        cls="constant_as_number",
        label="π / e / φ as primitive numbers",
        pattern=re.compile(r"\bπ\b|\bφ\b|\btranscendental numbers?\b|\bgolden ratio\b"),
        why=(
            "π, e, φ as \"numbers\" | transcendentals treated as primitive "
            "reals"
        ),
        discrete_replacement=(
            "readout-invariants — diagnostics that reconstruction "
            "succeeded; only their finite ℚ-approximants appear"
        ),
        alias="IDM:reals-R",
    ),
    LintRule(
        cls="trichotomy_lub",
        label="trichotomy / total ≤ / classical LUB",
        pattern=re.compile(
            r"\btrichotomy\b|\bclassical LUB\b|\bleast upper bound\b",
        ),
        why=(
            "trichotomy / total ≤ / classical LUB | each implies an "
            "omniscience principle (LPO/WLPO)"
        ),
        discrete_replacement=(
            "cotransitivity + Cauchy-completeness + finite sup/inf lattice "
            "(max/min) — the constructive substitutes"
        ),
        alias="IDM:reals-R",
    ),
    LintRule(
        cls="derivative_integral_limit",
        label="derivative / integral as a continuum limit",
        pattern=re.compile(r"\bderivatives?\b|\bintegrals?\b|\bd/dx\b|∫"),
        why="derivative / integral = continuum limit | I2",
        discrete_replacement=(
            "discrete difference Δ + sum Σ + the discrete FTC and Leibniz "
            "rule — calculus from retained difference, no reals"
        ),
        alias="IDM:integers-Z",
    ),
]


_CODE_PENDING = "code pending"


def resolve_toledo_code(alias: str, *, cache: Any | None = None) -> str:
    """Look `alias` (an ``"IDM:..."``-prefixed alias string, e.g.
    ``"IDM:reals-R"``) up against the LIVE registry and return the real
    Toledo code it resolves to (e.g. ``"R"``), or the literal string
    ``"code pending"`` if no entry in the currently-loaded registry carries
    that alias — fail soft, never raise, never fabricate a code. `cache`
    defaults to the process-wide singleton (`cache_mod.get_cache()`); tests
    pass their own `RegistryCache` for isolation."""
    c = cache if cache is not None else cache_mod.get_cache()
    c.ensure_fresh()
    reg = c.registry
    if reg is None:
        return _CODE_PENDING
    for entry in reg.entries:
        if alias in (entry.get("aliases") or []):
            code = entry.get("code")
            if code:
                return code
    return _CODE_PENDING


def lint_statement(statement: str, code: str | None = None, *, cache: Any | None = None) -> dict[str, Any]:
    """Lint one `statement` (LaTeX/ascii/prose) for continuum injections per
    `RULES` above. `code`, if given, is an OPTIONAL Toledo code the caller is
    checking this statement against/for — purely informational context
    echoed back on the result; it does not change which rules fire.

    Returns:

        {
            "code": code,
            "statement": statement,
            "verdict": "clean" | "continuum_injection_warned",
            "findings": [ {...}, ... ],
        }

    P24: this NEVER blocks — `verdict` disciplines (flags for a human/agent
    to look at), it does not gate usability the way `verdict.py`'s
    REGISTERED_*/AMBIGUOUS/CAUTION values do for the founder rule."""
    findings: list[dict[str, Any]] = []
    text = statement or ""
    for rule in RULES:
        m = rule.pattern.search(text)
        if not m:
            continue
        findings.append({
            "class": rule.cls,
            "matched_text": m.group(0),
            "why": rule.why,
            "discrete_replacement": rule.discrete_replacement,
            "toledo_code": resolve_toledo_code(rule.alias, cache=cache),
            "severity": "warn",
        })
    verdict = "continuum_injection_warned" if findings else "clean"
    return {"code": code, "statement": statement, "verdict": verdict, "findings": findings}
