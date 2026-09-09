# The decision equation, derived from readout metaphysics — not decorated with it

Founder instruction, verbatim (2026-09-09): "อย่าลืมพัฒนาสมการการตัดสินใจนี้ให้สำเร็จ โดยถอดออกมาจาก
อภิปรัชญา readout นะ" (don't forget to develop this decision equation to success by *deriving it out
of* the readout metaphysics — not just illustrating it with a metaphor). This document makes that
derivation explicit, so `PROP-NATIVE-01/02/03`'s parent edges to `delta_R`/`D`/`A2`/`L_R` are read as
genuine lineage, not loose inspiration. Tier: **Dr** (a derivation/reading, awaiting the actual
empirical test — see run 5 for whether the derived construction succeeds, not just whether it is
well-founded).

## The one metaphysical commitment everything below is derived from

> Everything an agency ever reads is a finite retained difference `δ_R` — a readout, rational and
> discrete. The continuum, infinite divisibility, and actual `+∞` are non-readouts.

Two immediate corollaries this workspace already states as standing discipline: **"possible ≠
true"** (a readout that has not excluded `z` does not certify `z`), and **"verify before you
repeat"** (never act as if the one readout in hand is the whole truth).

## Imagination, derived (not decorated)

If `δ_R` is the only thing ever available (never the totality), then at any stage `k` the evidence
in hand — the readout `r_k` — is a *finite* record, and it can only ever **exclude** some
possibilities, never enumerate the true one. The set of hypotheses **not excluded** is therefore
not an add-on invented for this project; it is the *direct logical complement* forced by the
readout axiom itself:

```
C_k := { z : r_k does not exclude z }
```

This is `PROP-NATIVE-01`'s and `theory/FORMALIZATION_v1.md`'s C1 restated as a derivation, not a
metaphor: "imagination" is not "the system pretends things"; it is the *necessary existence* of an
unexcluded-hypothesis set the moment you take the readout axiom seriously and refuse to silently
collapse "not yet excluded" into "known." `weld/H.30-34.v1` (this workspace's own Core Epistemic
Structure non-collapse rule) already states this principle for people (`X^exp ≠ X^int ≠ M^AI`);
`C_k` is the identical non-collapse principle applied to a machine's own pose readout instead of to
who holds an epistemic stance.

## Reason/verification, derived

The same axiom that forbids treating one readout as the whole truth also forbids treating one
readout as *sufficient grounds to act* without checking the others it has not excluded. "Reason"
here is not a separate faculty bolted onto imagination; it is the **discharge condition** the
readout axiom itself imposes before an action is licensed: an action may proceed only if its
outcome does not depend on which unexcluded hypothesis turns out to be the case.

```
ACT licensed  <=>  O_T(z) is the same for every z in C_k
```

This is exactly `PROP-NATIVE-02` — and it is why `weld/M.40.v1`'s already-proven ceiling
(`λ ≤ 4−F_min`) is the right tool to bound *how large* `C_k` needs to be searched, rather than an
arbitrary borrowed fact: both this construction and that ceiling theorem answer the same
readout-native question — "how much does the finite evidence in hand actually constrain?" — one
for a task verdict, the other for a graph's curvature.

## Memory, derived

`D` (root: "the naturals — the retained-difference engine") is *itself* the formal object that
results from taking successive retained differences and refusing to forget their order — `RD3`
("a retained tick is never the ground") and `RD4` ("succ is injective") are exactly the two axioms
that make a *count of consecutive confirmations* a well-defined, discrete object rather than an
ad hoc heuristic. `A2` (the FOLD engine, `I_⊕[f](N) = ⨁_{k<N} f[k]`) generalizes that successor
structure to accumulate any retained readout across stages, with the discrete Fundamental Theorem
of Calculus already machine-checked (root `A2`) guaranteeing the accumulation is exact, not a
lossy running average.

```
M_k := M_{k-1} ⊕ [reason discharged at stage k]     (an A2-shaped accumulator)

ACT licensed  <=>  M_k ≥ θ     (persistence, not a single instant)
```

`PROP-NATIVE-03`'s parent edge to `A2` is therefore not "this resembles a fold"; `M_k` **is** a
reading of root `A2`, in exactly the sense `EQ-008`'s readings are readings of `L_R`. The founder's
own observation — imagination and reason connect through memory and work simultaneously to decide
— is, read this way, not a neuroscience metaphor at all: it is the same three-part structure
(δ_R-forced hypothesis set; a discharge condition on it; an A2-shaped accumulation of repeated
discharges) that this workspace's own root layer already names, applied to one machine's pose
decision instead of to a human epistemic act.

## What "success" means for this derivation, stated honestly

## Independent confirmation in the founder's own prior published architecture

Founder framing, 2026-09-09 (two-part, given across two messages): "จินตนาการคือการเคลื่อนย้าย
ความหมายไปในเหตุการณ์ต่างๆ สร้างโครงสร้างความหมายและความเป็นไปได้ใหม่ๆ" (imagination is the
movement of meaning across events, creating structures of meaning and new possibility), then "ส่วน
การคิดคือการทดลองย้ายความหมายกับเหตุการณ์มาแปะกัน แล้วดูว่ามันเข้ากันไหม" (reasoning is the
experiment of placing a moved meaning against an event and checking whether they fit).

Reading `cpg_research_journal`'s "Written by AI. Still True." textbook, Chapter 39 ("Before Meaning,
Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human–AI
Return", Lahtee 2026, record 22424434) already gives this exact triad a typed formal shape, built
from the same Readout Genesis/Readout Universe root this document derives from — an independent
route to the same architecture, not a citation of convenience:

- **Imagination** ↔ semantic attraction `a_{Q,t}(e) = [Φ_{Q,t}(s) − Φ_{Q,t}(s′)]_+` (Ch.39 eq. 18),
  feeding the history-shaped access law `κ^sem_{t+1}(e|Q)` (eq. 20) — meaning pulled toward a
  destination-state along a declared access landscape, the same non-collapse move `C_k` makes for a
  pose readout (§ "Imagination, derived" above), except Ch.39's own text marks eq. 20 explicitly
  **OPEN** ("a typed finite hypothesis, not a validated universal cognitive law") — this document's
  `C_k` should carry the identical honesty, not more confidence than its sibling construction earned.
- **Reason** ↔ **resonance**, Ch.39's own name (p.5, directly after eq. 20) for "a domain diagnostic
  of congruence between a current externally prompted experience and retained experiential
  organisation" — this is precisely the founder's "place the moved meaning against the event, check
  whether it fits," and precisely `PROP-NATIVE-02`'s invariance discharge condition
  (`O_T(z)` unchanged across every unexcluded `z`) restated as a fit-check instead of an
  invariance-check — two readings of the same operation, congruence in one domain, invariance in the
  other.
- **Memory** ↔ the momentum accumulator `m_{t+1}(e) = ρ·m_t(e) + 𝟙[e_t=e]` (eq. 19) and the
  retention law `Retain(E_n) > 0 ⟹ H_{n+1} ≠ H_n` (eq. 17) — the same role as `M_k`/`PROP-NATIVE-03`
  above, but built with exponential decay (`ρ`) rather than a hard streak-and-threshold; a decayed
  accumulator is a candidate refinement of `PROP-NATIVE-03` worth registering if run 5's hard-streak
  version proves too brittle on noisy real sensor data.

This is Dr-tier confirmation, not proof: Chapter 39's own equation is explicitly unvalidated, and
finding the same shape twice from the same root is expected (both are readings of the one
metaphysics), not independent evidence the shape is empirically correct. It does strengthen the
claim that `PROP-NATIVE-01/02/03`'s lineage is a genuine reading of this workspace's root, not an ad
hoc analogy invented for one pose-stop project.

## What "success" means for this derivation, stated honestly

A correct derivation from the metaphysics does not guarantee the *empirical* construction works —
`PROP-DECAY-01` (run 4) was also carefully derived from real Toledo theorems and was still
empirically refuted, on structural grounds the derivation itself had flagged as an assumption to
check. This document strengthens the *lineage* of `PROP-NATIVE-01/02/03` (every arrow is now a
derivation, not a citation of convenience); it does not and cannot substitute for run 5's actual
result, which is the only thing that can say whether this particular readout-derived decision
equation *succeeds*, in the founder's own sense of the word.
