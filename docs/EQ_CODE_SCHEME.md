# Equation code scheme — Human–AI Readout Programme equation library (HRP)

**Builds on what already exists (founder rule BBL-181): no new numbering where one exists.**

## Existing systems reused
| System | Where | What it gives us |
|---|---|---|
| Readout Genesis Appendix C "SM domain equation stream" | `readout_genesis/READOUT_GENESIS_CORE.md` (SOT), mirrored in `research_universal_solver/EQUATION_LIBRARY_ROOT_TO_SM_STREAM.md` | root codes `EQ-001 … EQ-071` with tier tags |
| Readout Genesis named results | same file | ids `weld`, `MQ.08`, `Forced.I…XXIV`, `Face.1…12`, `N1…N5`, `VI.1…VI.8`, `T0…T2`, `RD1…RD9` |
| Equation Registry (owner/year at first use) | `research_universal_solver/docs/root/EQUATION_REGISTRY.md` | rule: any imported equation is registered with owner + year at first use — the library carries `external_owner_year` and cites that registry |
| Equivalence Registry design | `research_universal_solver/docs/design/EQUIVALENCE_REGISTRY_DESIGN.md`, `data/equivalence_registry.yaml` | the merge criterion: A ≡ B iff a documented bijective φ of (i) renaming, (ii) fixed positive scale, (iii) fixed constant substitution gives A(x)=B(φ(x)) on the shared domain — no limits, no approximations; otherwise `same_form_different_theory`, `special_case_of`, or (ours) `reads` |
| Domain Registration Standard | `readout_genesis/domains/DOMAIN_REGISTRATION_STANDARD.md` | a domain is a quotient/readout `q_D` of the one root, never a new root; claim boundary per domain |

## Layer 0 — root codes (Readout Genesis, verbatim)
`code` = the Genesis identifier as written: `EQ-0nn` when the object is in the Appendix C stream, else the named id
(`MQ.08`, `Forced.XII`, `Face.10`, `N2`, `VI.3`, `T1`, `RD4`, `weld`). Never prefixed, never renumbered. `aliases` lists any
second id the same object carries. Registry: `genesis_root.json` (git commit + blob anchors; deposited form = Standalone
Synthesis 10.5281/zenodo.21529456).

## Layer 1 — readings (domain translations)
`<root code>/<D>.<nn>.v<k>` — the same root equation read through a domain readout q_D (Domain Registration Standard):
`<D>` ∈ E epistemic · H human–AI · S social · W world-system · M method; `<nn>` sequence under that root (assigned once, never
reused); `.v<k>` revision of the canonical statement. Example `MQ.08/H.02`. A reading of a composite names the primary root and
lists `reads_also`. Genuinely rootless objects: `HRP-X.<nnn>` + drift note (target: none).

## Merge rule (canonicalisation)
Two raw equations are ONE object only under the Equivalence Registry φ-criterion above (renaming / positive scale / constant
substitution, exact). Otherwise they are related, never merged: `same_form_different_theory`, `special_case_of`, `refines`, `reads`.
The latest formulation is the canonical statement; sources are never edited; occurrences `<record_id>#<label>` map to one code.

## Lineage (permanent library, BBL-179)
Every code has a lineage log in `LINEAGE.jsonl`: `{code, date, event: assigned|revised|retired|merged|split, from, to, reason, by}`.
A retired code stays forever with its successor. A revision of the statement bumps `.v<k>` and appends an event; mapping a new
occurrence appends `occurrence_added`. No silent edits.

## Coq (BBL-182)
File name = code: `EQ-012.v`, `MQ.08.v` → for filesystem safety dots and slashes map to `_`: `MQ_08.v`, `MQ_08__H_02.v`
(`/`→`__`, `.`→`_`); the exact code is repeated in the header comment. One identifier per code inside.

## Where codes live
Source of truth: `genesis_root.json`, `CANONICAL.json` (`code`), `LINEAGE.jsonl`, `CANONICAL_REGISTRY.json` (Coq ids). Generated
views: `EQ_LIBRARY.md`, Master Equation River Appendix C, textbook Appendix F. Deposit: the library's own Zenodo dataset record
(versioned; BBL-178), linked to Master River and the Coq record.
