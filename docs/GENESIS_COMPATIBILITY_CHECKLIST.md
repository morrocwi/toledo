# Genesis Compatibility Checklist

Status: reviewer worksheet (fill-in), doc-only — no new tooling.

This is the fill-in checklist for **step 2 of the reuse pipeline** —
`Toledo lookup -> Genesis compatibility -> reuse existing object -> derive only the missing
piece -> mark PROPOSAL` (`TG-RFG-01` in `EQUATION_SOURCE_POLICY.md`) — for a candidate
mathematical object (equation, theorem, constraint, bridge) that has already cleared step 1
(Toledo lookup) and now needs a Genesis-compatibility read before it is reused, derived, or
proposed.

The seven items below are the **actual named gates** of `morrocwi/readout_genesis`, taken
verbatim from `READOUT_GENESIS_CORE.md`, section **A.13 "The Seven General Gates (canonical
form, 2026-07-21)"** — the section the core text itself says every later part should cite
instead of re-deriving. They are domain-neutral (not chemistry-, biology-, or physics-specific)
and are exactly the gates a candidate object's ontological/translation meaning must be checked
against before it is reused or derived under `TG-RFG-01`. Do not substitute a paraphrase or a
remembered list of terms — if the gate names in `READOUT_GENESIS_CORE.md` change, update this
checklist to match the current file rather than keep an old wording.

A reviewer should have `READOUT_GENESIS_CORE.md` §A.13 open while filling this in.

## How to use this

For each gate: read the candidate object's statement, then read the gate's own text in §A.13,
then answer honestly. `n/a` is a real answer, not a way to skip a gate — use it when the gate's
condition genuinely does not arise for this candidate (e.g. no context-indexing is involved),
and say why in the justification. `unresolved` questions must be recorded as `no` with a
justification noting what would need to be checked next, per Gate 2's own three-valued
discipline (unresolved is not the same as obstructed, and neither is a pass).

---

## Candidate object

- **Candidate description / statement:** _____________________________________________
- **Toledo lookup result (step 1), verdict + code if any:** ___________________________
- **Reviewer (human or AI) and date:** _________________________________________________

---

## Gate 1 — No-Free-Domain-Law

> `δ_R + Retention ⇏ (F, 𝒞, V, θ)_domain` — if more than one compatible model satisfies
> retention and the tape alone (`|𝔐_compatible| > 1`), no domain-specific law may be declared
> from retention alone; an additional interaction tape, observation, or postulate is required.

- Does this candidate satisfy this gate? (yes / no / n-a): _______
- One-line justification: _____________________________________________________________

## Gate 2 — Three-Valued Admissibility

> `𝒞(ξ | c, 𝒯) ∈ {1, 0, ⊥}` — admitted, obstructed, or unresolved. `⊥` (unresolved, not yet
> known) and `0` (obstructed, actively blocked) are two different statuses, never collapsed
> into one "no."

- Does this candidate satisfy this gate? (yes / no / n-a): _______
- One-line justification: _____________________________________________________________

## Gate 3 — Context-Indexed Law

> `F_n = F_n(𝔖_n, c_n, 𝒯_n)` — a law valid in context `c` does not imply validity in context
> `c'`.

- Does this candidate satisfy this gate? (yes / no / n-a): _______
- One-line justification: _____________________________________________________________

## Gate 4 — State-Sufficiency Gate (three-valued)

> `Suff_{α,L}(𝔃_α^cand ; c, 𝒯) ∈ {1, 0, ⊥}` — sufficiency can be unresolved, not only
> pass/fail; a threshold or decoder may never be used to compensate for a distinction the
> state has already lost — the correction is always to enlarge the state, never to patch the
> readout downstream.

- Does this candidate satisfy this gate? (yes / no / n-a): _______
- One-line justification: _____________________________________________________________

## Gate 5 — Invariant-Completion Gate

> `D²(g) = D²(g') but χ(g) ≠ χ(g')` — one invariant set can be insufficient; apparent symmetry
> is not valid quotient symmetry. An invariant set that looked complete for one question can
> turn out incomplete for the next.

- Does this candidate satisfy this gate? (yes / no / n-a): _______
- One-line justification: _____________________________________________________________

## Gate 6 — Query-Relative Symmetry Group

> `ℋ_α = { h : O_α(hz) = O_α(z), hF = Fh }`, `𝒟_α = 𝔃 / ℋ_α` — only transformations that fix
> *this question's* readout may be quotiented away.

- Does this candidate satisfy this gate? (yes / no / n-a): _______
- One-line justification: _____________________________________________________________

## Gate 7 — Calibration Firewall

> `y_α^known = U_α(r_RD ; θ_α, c, 𝒞_α^cal)`, checked against a frozen calibration hash
> (`H_cal`) before checking. A native informational functional is not a physical observable
> until an independently checked calibration has been applied.

- Does this candidate satisfy this gate? (yes / no / n-a): _______
- One-line justification: _____________________________________________________________

---

## Reviewer verdict

- All seven gates recorded above (no blanks left as "TBD")? (yes / no): _______
- Any gate answered `no`: does the candidate proceed only as a declared PROPOSAL/revision
  against the conflicting gate, per `TG-RFG-01`'s `HOLD`/`DRIFT` discipline, rather than as a
  reuse? (yes / no / n-a): _______
- Overall Genesis-compatibility outcome for step 2 of the reuse pipeline
  (`compatible` / `HOLD — unresolved` / `DRIFT — conflicts without declared revision`): _______

This checklist records a Genesis-compatibility read only. It does not itself perform the
Toledo lookup (step 1), does not reuse or register anything (steps 3–5), and does not upgrade
any tier, proof, or Clay status — those gates in `EQUATION_SOURCE_POLICY.md` and
`AGENTS.md` still apply in full.
