# Toledo registration proposal — ARAYA Captain financial and social-mission readout

**Status (15 October 2026): PROPOSAL / HUMAN-REGISTRAR REVIEW REQUIRED**  
**Do not treat as a canon entry, Coq-certified registration, peer-reviewed empirical model, or wealth guarantee.**

## 1. Anchor integrity and target

The 12 original chapters of the Captain Handbook v1.2 remain unchanged. Existing research appendix v0.1 remains preserved; this document is a Toledo-specific proof/lineage candidate. The business question is whether a captain can systematically increase *real net economic wealth*, respect every prior duty, avoid overclaiming legal/religious authority, and preserve refusal capacity and social mission.

**Requested Toledo scope:** social domain `S` (not `B`, reserved for biology/health). A new `EQ-015/S.nn.v1` or `weld/S.nn.v1` code may be assigned ONLY by the registry's human maintainer after a duplicate search and lineage review. No new code is self-assigned here.

## 2. TG-RFG-01 source/lineage evidence

| Constraint | Existing Toledo object | Source status | This proposal |
|---|---|---|---|
| State step / root | `EQ-015/M.02.v1`, `CAN-003` | Existing Toledo definition / listed Coq closed | REUSE; declares a business state/transition specialisation |
| Readout commutation | `weld/M.02.v1`, `CAN-006` | Existing Toledo definition / listed Coq closed | REUSE; prove a finite business projection instance |
| Semantic/evidential readout | Relevant Readout Universe framework | Interpretive lens only | No assertion that a readout reveals total actual business state |
| Human authority/AI | GLOSA and ARAYA charter | Institution-governance and epistemic boundary | AI drafts/tests; human approves finance, law, religion and risks |
| Financial and SE gates | ARAYA CC-SE source, TTD, ARAYA EQmap | External domain-specific proposal (not in Toledo) | Typed reconstruction; uncalibrated, not promoted to Toledo fact |

Sources: `morrocwi/toledo/EQUATION_SOURCE_POLICY.md`, `morrocwi/toledo/registry/EQ_LIBRARY.md`, `morrocwi/readout_genesis/README.md`, `morrocwi/readout_universe/README.md`, `morrocwi/glosa/README.md`, `morrocwi/anse-asia-office/org/core/araya-eqmap.yaml`, and full Captain Appendix v0.1 on `anse-asia-office` PR #48.

Mandatory rule: Toledo lookup → Genesis compatibility → reuse → derive only a missing instance → label `PROPOSAL`.

## 3. Mathematical objects proposed for review

Let `World = (cash, refunds_due, irrelevant_trace)` and `Ledger = (cash, refunds_due)`. For a deliberately declared toy model, set

- `q(world) = (cash, refunds_due)`;
- `F_world(world, receipts) = (cash + receipts - refunds_due, 0, successor(trace))`;
- `F_ledger(ledger, receipts) = (cash + receipts - refunds_due, 0)`.

**Proposition 1 (concrete weld instance).** `q(F_world(w,r)) = F_ledger(q(w),r)`. The Coq candidate contains a structural proof. This establishes only the explicitly declared toy transitions, **not** that real ARAYA states are fully observed by these two fields. It does not prove causal forecasting.

**Counterexample 1 (missing liability).** Two states with cash 100 but refund liability 10 versus 20 share the cash-only record, yet their next observed cash differs. The cash-only quotient fails the admissibility condition. This justifies recording obligations, not merely bank balances.

**Proposition 2 (hard-gate dominance).** For a boolean predicate `admissible` containing legal, safety, authority, privacy and mission gates, the *defined* candidate selector returns `None` on failure whatever an arbitrary proposed wealth score. This is a declared policy invariant, **not** proof that a real assessment or reviewer correctly evaluates those gates.

**Proposition 3 (book-wealth conservation).** Under the declared book-wealth proxy, injecting extra owner capital equally into equity and owner paid-in contributions does not create profit; a dividend funded by reducing equity cannot mint new wealth. These are elementary algebraic identities, **not** a valuation of ARAYA ownership.

**Proposition 4 (guarded cash floor).** If an explicitly guarded finite sequence returns `Some final`, final cash is at least its specified floor. This proves the guarded procedure's behavior, **not** that all future cash changes, shocks and data are included.

## 4. Detailed mapping of prior 41 tagged expressions

- **Toledo REUSE (two):** `T-ROOT`, `WELD-CHECK`. Root IDs are existing code references.
- **Declared business-state/measurement definitions (six):** `SE-READOUT-PROPOSED`, `S1`, `R1`, `R2`, `W1`, `W3a`.
- **Accounting/cash identities and partition (nine):** `W2`, `W3b`, `W3c`, `W4`, `W5`, `W6`, `R3`, `W8`, `W9`.
- **Governance/feasible-policy structures and hard constraints (twelve):** `R4`, `M0`, `M1`, `M2`, `M3`, `M4`, `M5`, `G1`, `F1a`, `F1b`, `F2`, `SE1`.
- **Theoretical dynamic/decision candidates requiring independent validation (twelve):** `W7`, `T1`, `T2`, `T3`, `K1`, `K2`, `K3`, `P1`, `SE2`, `W10`, `CTRL1`, `CTRL2`.

**Typing warning:** This classification distinguishes origin, identity, proposed decision convention and uncalibrated dynamics. Not every item should become a Toledo canonical equation. Specific labels and interpretations must be checked before a registrar groups or splits a candidate.

**Known original CC-SE source defect:** `R_A` is THB/step and `R_C` is an index, so `R_safe = R_A + R_C` is not dimensionally admissible. Business income A/C must instead be kept in a common monetary flow unit, while `R_C` remains an independent trust index. The v0.1 appendix already makes this repair as a proposal; the original SSoT is unchanged.

## 5. Verification ladder and falsifiers

| Gate | Expected artifact | Status before CI / human review |
|---|---|---|
| SOURCE | Root codes and tiers verified from current Toledo EQ_LIBRARY | PASS FOR TWO PARENTS ONLY |
| ONTOLOGY | Declared projection preserves necessary state; absent state yields counterexample | Toy-projection proof candidate; real-world coverage OPEN |
| COQ | `coqc` compiles without `Admitted`/new axioms; test log + runner version | NOT YET VERIFIED until CI confirms |
| REGISTER | Human registrar maps to an existing canonical reading or formally creates new one | NOT REGISTERED |
| FINANCE | Reconcile banking/accounting, liabilities, taxes, capital | NOT CALIBRATED |
| GROWTH | Out-of-sample wealth forecast beats baseline after total founder costs | NOT TESTED |
| SE | Impact baseline, rights protection and mission gates measured/approved | NOT TESTED |
| AUTHORITY | Human/legal/religious/board review of proposed use | PENDING |

**Falsify project application if:** two live states have same declared input vector and action but incompatible future readouts beyond declared noise; bookkeeping fails to reconcile; model repeatedly understates refund/capacity obligations; risk-free high-profit action bypasses explicit mission/authority conditions; forecast does not beat simple baseline out of sample; business gain disappears after actual founder compensation; reported impact is ungrounded or harms are masked.

## 6. Coq reproducibility procedure

The accompanying file `coq/candidates/ARAYA_Business_Readout_Candidate.v` uses Coq standard library only (`ZArith`, `Bool`, `List`, `Lia`), avoids new axioms and avoids `Admitted`. A maintainer can reproduce:

```sh
coqc -q coq/candidates/ARAYA_Business_Readout_Candidate.v
```

The GitHub Actions workflow in this PR is designed to run this command on a Linux runner. Passing Coq means **only the eight finite lemmas as defined typecheck**, not that the economic dynamics are empirically justified. If no workflow log is available, status remains `COQ_NOT_RUN`.

## 7. Stop/go ruling

- **Toledo source and proof-method mapping may close** once this file is reviewed and the Coq log succeeds.
- **Toledo registration cannot close** until a human registrar assigns/reuses canonical codes and updates the canonical registry/lineage and generated artifacts under its governance procedure.
- **Business wealth+mission guarantee must NEVER be claimed** on the basis of these proofs. The operational programme cannot close until accounting-data validation, risk/impact review and sustained out-of-sample testing exist.

The Captain Handbook anchor and effective operating policies remain unchanged.