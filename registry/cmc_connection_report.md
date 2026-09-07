# CMC connection report — Toledo v1.5 Lane C, task 3 (2026-09-07)

**Task.** DEBT #46 / `ops/HANDOFF_OVERNIGHT_2026-09-06.md`: search every `CMC_*.v` header/comment
and any CMC design text in the solver-arc mirror for a sentence stating CMC's relation to the
stepper / causal-memory machinery of the Genesis roots; add `parents`/`relations` with the quote
if found, otherwise report candidate sentences as a proposal, never assert an unevidenced parent.

**Result: no such sentence was found.** This matches, and does not overturn, the finding already
recorded on `registry/genesis_root.json`'s own `CMC` row (`relations: []`,
`relations_note`) and in `registry/root_candidates_report.md` §2 — this report re-runs that search
directly, this session, over the full body of every `CMC_*.v` file (not only headers) plus every
other CMC-adjacent document in this Toledo tree, and confirms the same zero result. No
`parents`/`relations` were added to any registry file by this report.

## What was searched (2026-09-07, this session)

1. **All six `CMC_*.v` files, full text, not only header comments**, at
   `coq/solver-arc/formal/CMC_{TargetClass_Definitions,Bridge_Decomposition,
   ClosureFree_Exhaustive,Independent_Definitions,ModelClass_Witnesses,PhysicsClass_Instances}.v`
   — grepped case-insensitively for `stepper`, `genesis`, `delta_R`, `L_R`, `causal.memory`,
   `PAR-stepper`, `root`, `EQ-0`, `Phi_n`, `Psi_n`, `readout`. The only hits are the identifier
   `TransportReadout` and its field `declared_physical_readout`/`CertifiedPhysicalReadout` (plain
   Coq record/type names built from the ordinary English word "readout", not a reference to this
   project's own retained-difference readout apparatus) and the generic word "readout" inside
   variable names. No file mentions "stepper", "genesis", "delta_R", "L_R", "causal memory" (as a
   phrase distinct from the file's own title "Causal-Memory Closure"), "root", or any `EQ-0nn` code
   anywhere in its body.
2. **`coq/solver-arc/PROVENANCE.json`, `EXCLUDED_ATTEMPTS.md`, `VERIFY_REPORT.md`,
   `LICENSE_NOTE.md`** — the only CMC-related lines are the six files' own path listings in
   `PROVENANCE.json` and their own section headers in `VERIFY_REPORT.md`; no design-text sentence
   about a stepper/causal-memory/Genesis-root relation.
3. **Every public repository already imported into this Toledo tree** (`readout_genesis`,
   `readout_universe`, `information-discrete-math`, `zero-readout-certifies`,
   `finite-readout-acceleration`) — grepped for `CMC`, `Causal-Memory Closure`, `Causal Memory
   Closure`: zero matches (re-confirms `root_candidates_report.md`'s own finding of the same).
4. **`registry/genesis_root.json`'s own `CMC` row** — already carries `relations: []` and a
   `relations_note` quoting `root_candidates_report.md`'s finding; this report's search did not
   surface anything to add to it.

## Candidate sentences (proposal only — not asserted as evidence, not added to any registry file)

No source text states a CMC-to-Genesis-root connection. The following is this report's own
observation of a **structural resemblance**, offered as a candidate for the founder to confirm,
reject, or have restated more precisely by whoever wrote the CMC programme — not as a finding this
report treats as sourced:

> `CMC_TargetClass_Definitions.v`'s `TransportReadout` record has fields `diffusion_positive`,
> `speed_positive`, `speed_finite`, `retained_diffusive`, `intrinsic_finite_speed`,
> `declared_physical_readout`. Read only by their English names (not by any cross-reference the
> file itself makes), `retained_diffusive` and `intrinsic_finite_speed`/`speed_finite` resemble in
> subject matter — a persistence/retention condition and a finite-propagation-speed condition —
> the subject matter of Genesis root axioms `EQ-005` (`tau_c > 0`, persistence) and `EQ-006`
> (`t = n*Delta_theta, n in N, Delta_theta > 0`, discrete step/causal-memory tick), per
> `registry/genesis_root.json`. This resemblance is the same one `root_candidates_report.md`
> already noted and explicitly declined to assert as a `parents[]` link, because no CMC file
> states it. This report reaches the identical conclusion independently and states it again here,
> plainly, as a candidate the founder may wish to confirm directly with whoever can speak to the
> CMC programme's own design intent — not as a reading this report or any prior one is prepared to
> certify from the text alone.

**No action taken.** `registry/genesis_root.json`'s `CMC` row keeps `relations: []`. If the founder
confirms the candidate sentence above (or supplies the source text that actually states the
connection), a follow-up lane should add the `parents`/`relations` entry with that quote, per the
task's own instruction — never before then.
