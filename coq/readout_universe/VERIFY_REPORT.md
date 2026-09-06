# VERIFY_REPORT.md — readout_universe import (Toledo)

Source: public GitHub repository `readout_universe` (github.com/morrocwi/readout_universe; not the private solver arc).
Upstream commit: `960165f13ced6e3f2bfd433928733a35be8283e6` (matches `registry/coq_imports.json`; re-verified directly against the upstream working tree at import time — see `PROVENANCE.json`).

Build: `coq_makefile`-generated `Makefile` from a Toledo-side `_CoqProject` (no `_CoqProject` exists upstream; the upstream `Makefile` covers only 11 of the 14 imported files and is not reused verbatim — its own `COQPATH := -Q evidence URR` convention is preserved in the Toledo `_CoqProject`). `-Q evidence URR` for the `evidence/` files; the two `code/` files (`UPL_Sorites.v`, `UPL_Sorites_OneReversal.v`) carry no logical-path mapping upstream either (confirmed via `make -n`) and compile/`Require` by bare filename via the implicit current-directory root. All 14 `.v` files compile clean with a single sequential `make` (no `-j`). Dependency order: `RD.v`, `DRL_Discrete.v`, `DRL_General_Legendre.v` before `URR_C_Foundational_Chain.v` (the only file with cross-file `Require`s — `From URR Require Import RD/DRL_Discrete/DRL_General_Legendre`); every other file only `Require`s the Coq standard library.

Verification method: for every `Theorem`/`Lemma`/`Corollary`/`Proposition` name listed for this source in `registry/coq_imports.json` (997 identifiers across 14 files), a scratch `.v` file (`evidence/ZZVerify_<name>.v` / `code/ZZVerify_<name>.v`, deleted after this pass — not part of the committed tree) `Require`s the compiled module and runs `Print Assumptions <qualified-identifier>.`; `coqc` run sequentially, one invocation at a time (never `-j`), checking `docs/RAM_LOW` before each. Two of the fourteen files (`URCF_RD_All.v`, 687 identifiers; `URR_C_Foundational_Chain.v`, 19 identifiers) nest every declaration inside one or more `Module ... End` blocks (up to several levels deep, some blocks reusing a name already used by an enclosing `Section`); a purpose-built parser (`.scripts/qualify.py`) walks each file tracking the live `Module`/`Section` stack line by line and records, for every `Theorem`/`Lemma`/`Corollary`/`Proposition` declaration, the dotted path of enclosing `Module` names only (`Section` names never qualify an identifier in Coq). The parser's extracted identifier list was checked to match `registry/coq_imports.json`'s own `theorems` list **exactly, in order**, for all 14 files before any `coqc` was run (this caught and fixed one bug: the parser initially trimmed a trailing `'` off a primed identifier `two_halves'` via an overzealous `\b` word-boundary in the declaration regex, and initially included `Fact`/`Remark` declarations that the manifest's own extraction rule excludes — both fixed and re-verified against the manifest before compiling). Each `Print Assumptions` call is bracketed by `Goal True. idtac "@@@BEGIN:<qualified>@@@". Abort.` / `@@@END:<qualified>@@@` markers so a possibly multi-line axiom listing can be parsed unambiguously. **Tier rule applied literally**: a lemma counts "Closed" only when `Print Assumptions` printed exactly `Closed under the global context`; every other outcome is listed here with its named axioms — none failed to build.

## Summary

- Total identifiers: **997**
- Closed under the global context: **947**
- With named axioms: **50**
- Build failed: **0**

All named axioms are standard Coq-library axioms pulled in by `Require Import Reals`/`Require Import ... Classical` in the source files themselves (never introduced by the Toledo import step):
- `Classical_Prop.classic` (excluded middle)
- `ClassicalDedekindReals.sig_forall_dec`, `ClassicalDedekindReals.sig_not_dec` (from the `Reals` library's Dedekind-cut construction)
- `FunctionalExtensionality.functional_extensionality_dep`

## Per-file breakdown

| File | Identifiers | Closed | With axioms | Build |
|---|---|---|---|---|
| `code/UPL_Sorites.v` | 4 | 4 | 0 | ok |
| `code/UPL_Sorites_OneReversal.v` | 10 | 10 | 0 | ok |
| `evidence/RD.v` | 184 | 181 | 3 | ok |
| `evidence/DRL_Discrete.v` | 5 | 0 | 5 | ok |
| `evidence/DRL_Finite_Cut_Balance.v` | 16 | 16 | 0 | ok |
| `evidence/DRL_Forced_Master.v` | 17 | 17 | 0 | ok |
| `evidence/DRL_General_EL.v` | 15 | 15 | 0 | ok |
| `evidence/DRL_General_Legendre.v` | 12 | 12 | 0 | ok |
| `evidence/DRL_Hidden_Elimination_Convolution.v` | 9 | 9 | 0 | ok |
| `evidence/DRL_NoGo_Single_Field.v` | 7 | 7 | 0 | ok |
| `evidence/RD_Chance_Presupposes_Distinguishability.v` | 6 | 6 | 0 | ok |
| `evidence/RetentionLoopClosureMonotone.v` | 6 | 6 | 0 | ok |
| `evidence/URCF_RD_All.v` | 687 | 645 | 42 | ok |
| `evidence/URR_C_Foundational_Chain.v` | 19 | 19 | 0 | ok |

## Identifiers with named axioms

### `evidence/RD.v`

- `soundnessC` — axioms: `Classical_Prop.classic`
- `consistencyC` — axioms: `Classical_Prop.classic`
- `Con_PA_classical` — axioms: `Classical_Prop.classic`

### `evidence/DRL_Discrete.v`

- `T1_el_psi_node1` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `T1_el_psi_node2` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `T1_el_phi_node1` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `T2_D_cancellation` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `T3_leapfrog_D0_invariant` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`

### `evidence/URCF_RD_All.v`

- `RD.soundnessC` — axioms: `Classical_Prop.classic`
- `RD.consistencyC` — axioms: `Classical_Prop.classic`
- `RD.Con_PA_classical` — axioms: `Classical_Prop.classic`
- `ContLimit.sq_neq0` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `ContLimit.D2sym_expand` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `ContLimit.symmetric_second_difference_limit` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `ContLimit.quadratic_symmetric_limit` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `ContReadout.secondDiff_quad_R` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `ContReadout.readout_invariant_R` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.d_shift` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.d_sq_shift` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.d_lin_shift` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.d_sqterm` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.Gfun_x` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.Gfun_xh` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.G_deriv` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.mvt_pack` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic`
- `Taylor.Rabs_ratio_le_1` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.taylor_young2` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic`
- `Taylor.twice_diff_secondDiff_limit` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic`
- `Taylor.G_deriv_at` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Taylor.mvt_pack_local` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic`
- `Taylor.taylor_young2_local` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic`
- `Taylor.twice_diff_secondDiff_limit_local` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic`
- `Taylor.twice_diff_secondDiff_limit_global` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic`
- `Capstone.continuum_gate_readout_native` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `Capstone.continuum_gate_classical_via_readout` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic`
- `Capstone.capstone_quadratic_meets` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoLorentzContinuum.tends0_opp` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoLorentzContinuum.tends0_plus` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoLorentzContinuum.lorentz_box_continuum` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoLorentzTaylor.boost_norm_upper` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoLorentzTaylor.o2_boost` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoLorentzTaylor.box2_boost_invariant` — axioms: `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoEvolution.evolution_identity` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoEvolution.evolution_group` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoEvolution.evolution_preserves_norm` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoHilbertBridge.rot1_norm` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoHilbertBridge.rot1_identity` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoHilbertBridge.rot1_group` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoHilbertBridge.multimode_preserves_norm` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`
- `InfoHilbertBridge.multimode_group` — axioms: `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`

No `pass2` re-verification was needed (`pass2_reverified: 0`) — the qualified-name parser was validated against `registry/coq_imports.json`'s own identifier lists (exact order match, all 14 files) *before* any `coqc` invocation, so every `Print Assumptions` call resolved on the first attempt.
