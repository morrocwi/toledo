# VERIFY_REPORT.md — readout_genesis import (Toledo)

Source: public GitHub repository `readout_genesis` (not the private solver arc).
Upstream commit: `082dde893b70c7500c13d463239909c99cf17f0a` (matches `registry/coq_imports.json`; 
re-verified directly against the upstream working tree at import time -- see `PROVENANCE.json`).

Build: `coq_makefile`-generated `Makefile` from a Toledo-side `_CoqProject` (no `_CoqProject`/
`Makefile`/`verify.sh` exists anywhere upstream -- confirmed by direct search). `-Q formal 
ReadoutGenesis.Formal -Q domains/standard_model ReadoutGenesis.Domains.StandardModel`. All 39 
`.v` files compile clean with a single sequential `make` (no `-j`); no cross-file `Require` 
dependencies exist among them (all `Require`s target the Coq standard library only), so no 
dependency ordering was needed.

Verification method: for every `Theorem`/`Lemma`/`Corollary`/`Proposition` name listed for this 
source in `registry/coq_imports.json` (356 identifiers across 39 files), a scratch `.v` file 
`Require`s the compiled module and runs `Print Assumptions <identifier>.`; `coqc` run sequentially, 
one invocation at a time (never `-j`), checking `docs/RAM_LOW` before each. 27 of the 39 files wrap 
their content in a `Module <Name> ... End <Name>.` block whose name does not always match the file's 
own basename (e.g. `InfoTrueRecordUnreadable_attempt.v` wraps in `Module TrueRecordUnreadable`, not 
`InfoTrueRecordUnreadable`); a first pass using the bare identifier failed with "reference not found" 
for all 261 identifiers in those 28 wrapped files (this is a Coq scoping fact, not a mathematical 
failure), and a second pass re-ran those 261 using the module-qualified identifier (`<Module>.<ident>`), 
all 261 confirmed. **Tier rule applied literally**: a lemma counts "Closed" only when `Print 
Assumptions` printed exactly `Closed under the global context`; none printed a named axiom, and none 
failed to build.

## Summary

| files | identifiers | Closed | +axioms | build_failed |
|---|---|---|---|---|
| 39 | 356 | 356 | 0 | 0 |

All 356 identifiers are **Closed under the global context** (fully axiom-free over ℚ). This matches 
the source repository's own repeated README claims of "axiom-free" for these files -- independently 
re-verified here, not merely copied from the source's self-report.

## Per-file detail

| file | identifiers | Closed | +axioms | build_failed |
|---|---|---|---|---|
| `formal/InfoCPEquivariantGenerationBound_attempt.v` | 13 | 13 | 0 | 0 |
| `formal/InfoRetentionMetricSkewDecomposition_attempt.v` | 9 | 9 | 0 | 0 |
| `formal/InfoSharedReadoutForcesSharedMemory_attempt.v` | 8 | 8 | 0 | 0 |
| `formal/InfoThetaCPSquareObstruction_attempt.v` | 1 | 1 | 0 | 0 |
| `formal/InfoThetaEdgeCensus_attempt.v` | 3 | 3 | 0 | 0 |
| `formal/InfoThetaFixedPointBalance_attempt.v` | 3 | 3 | 0 | 0 |
| `formal/InfoThetaLivingOrientationSign_attempt.v` | 19 | 19 | 0 | 0 |
| `formal/InfoThetaMinimalLiving_attempt.v` | 7 | 7 | 0 | 0 |
| `formal/InfoThetaOrientedSkewObstruction_attempt.v` | 7 | 7 | 0 | 0 |
| `formal/InfoThetaQuartetSquareObstruction_attempt.v` | 14 | 14 | 0 | 0 |
| `formal/InfoThetaSectorSpectrum_attempt.v` | 9 | 9 | 0 | 0 |
| `formal/InfoThetaTopologyReadout_attempt.v` | 10 | 10 | 0 | 0 |
| `formal/InfoTrueRecordUnreadable_attempt.v` | 3 | 3 | 0 | 0 |
| `domains/standard_model/InfoAllOrderCharacter.v` | 6 | 6 | 0 | 0 |
| `domains/standard_model/InfoBlindMatterSearch.v` | 10 | 10 | 0 | 0 |
| `domains/standard_model/InfoBlockCorrelation.v` | 9 | 9 | 0 | 0 |
| `domains/standard_model/InfoCenterConfinement.v` | 9 | 9 | 0 | 0 |
| `domains/standard_model/InfoConfinementCertificate.v` | 9 | 9 | 0 | 0 |
| `domains/standard_model/InfoDimensionFourClosure.v` | 10 | 10 | 0 | 0 |
| `domains/standard_model/InfoElectroweakNullDirection.v` | 7 | 7 | 0 | 0 |
| `domains/standard_model/InfoFiniteTransferGap.v` | 8 | 8 | 0 | 0 |
| `domains/standard_model/InfoFourForceCirculationRecovery.v` | 6 | 6 | 0 | 0 |
| `domains/standard_model/InfoFrameMixingAction.v` | 11 | 11 | 0 | 0 |
| `domains/standard_model/InfoGaugeAutomorphismGroup.v` | 8 | 8 | 0 | 0 |
| `domains/standard_model/InfoGaugeLocalizationConnectionHolonomy.v` | 10 | 10 | 0 | 0 |
| `domains/standard_model/InfoHyperchargeAnomalyClosure.v` | 7 | 7 | 0 | 0 |
| `domains/standard_model/InfoHyperchargeGlobalQuotient.v` | 14 | 14 | 0 | 0 |
| `domains/standard_model/InfoIntertwinerOrderVacuum.v` | 11 | 11 | 0 | 0 |
| `domains/standard_model/InfoIsotropicFixedPoint.v` | 11 | 11 | 0 | 0 |
| `domains/standard_model/InfoOrderDefectFromComposition.v` | 12 | 12 | 0 | 0 |
| `domains/standard_model/InfoOrderHiggsClosure.v` | 15 | 15 | 0 | 0 |
| `domains/standard_model/InfoOrderedTapeClosure.v` | 9 | 9 | 0 | 0 |
| `domains/standard_model/InfoRetainedIntertwiner.v` | 7 | 7 | 0 | 0 |
| `domains/standard_model/InfoRootChirality.v` | 17 | 17 | 0 | 0 |
| `domains/standard_model/InfoSurfaceAutomaton.v` | 9 | 9 | 0 | 0 |
| `domains/standard_model/InfoSurfaceUpperAutomaton.v` | 9 | 9 | 0 | 0 |
| `domains/standard_model/InfoTapeKineticGW.v` | 13 | 13 | 0 | 0 |
| `domains/standard_model/InfoTrialitySpectralFlow.v` | 5 | 5 | 0 | 0 |
| `domains/standard_model/InfoUniversalRPSlab.v` | 8 | 8 | 0 | 0 |

## Per-theorem identifiers

Every identifier below is `Closed under the global context`. (No axioms were found anywhere in this 
import; the `+axioms` column is retained above per the tier rule even though it is 0 for every file, 
so a future re-run that finds an axiom cannot be silently absorbed into this template.)

### `formal/InfoCPEquivariantGenerationBound_attempt.v`

- `quartet_decomp` — **Closed under the global context**
- `two_gen_quartet_im_vanishes` — **Closed under the global context**
- `quartet_conj_flips_sign` — **Closed under the global context**
- `witness_unitary` — **Closed under the global context**
- `witness_J_value` — **Closed under the global context**
- `witness_J_nonzero` — **Closed under the global context**
- `witness_cp_unitary` — **Closed under the global context**
- `witness_cp_flips` — **Closed under the global context**
- `neutral_cp_fixed` — **Closed under the global context**
- `neutral_unitary` — **Closed under the global context**
- `neutral_J_zero` — **Closed under the global context**
- `three_values_realized` — **Closed under the global context**
- `values_pairwise_distinct` — **Closed under the global context**

### `formal/InfoRetentionMetricSkewDecomposition_attempt.v`

- `group_right_id` — **Closed under the global context**
- `group_right_inv` — **Closed under the global context**
- `double_regroup` — **Closed under the global context**
- `ip_linear_arg2` — **Closed under the global context**
- `ip_scalar_arg2` — **Closed under the global context**
- `ip_opp_arg2` — **Closed under the global context**
- `retention_split_reconstructs_operator` — **Closed under the global context**
- `retention_sym_part_is_self_adjoint` — **Closed under the global context**
- `retention_skew_quadratic_form_vanishes` — **Closed under the global context**

### `formal/InfoSharedReadoutForcesSharedMemory_attempt.v`

- `rate_times_tau` (as `InfoSharedReadoutForcesSharedMemory.rate_times_tau`) — **Closed under the global context**
- `rate_nonzero` (as `InfoSharedReadoutForcesSharedMemory.rate_nonzero`) — **Closed under the global context**
- `tau_eq_of_rate_eq` (as `InfoSharedReadoutForcesSharedMemory.tau_eq_of_rate_eq`) — **Closed under the global context**
- `rate_eq_of_ratio_eq` (as `InfoSharedReadoutForcesSharedMemory.rate_eq_of_ratio_eq`) — **Closed under the global context**
- `shared_readout_forces_shared_memory` (as `InfoSharedReadoutForcesSharedMemory.shared_readout_forces_shared_memory`) — **Closed under the global context**
- `ratio_eq_of_tau_eq` (as `InfoSharedReadoutForcesSharedMemory.ratio_eq_of_tau_eq`) — **Closed under the global context**
- `memory_iff_readout` (as `InfoSharedReadoutForcesSharedMemory.memory_iff_readout`) — **Closed under the global context**
- `readout_cannot_split_mass` (as `InfoSharedReadoutForcesSharedMemory.readout_cannot_split_mass`) — **Closed under the global context**

### `formal/InfoThetaCPSquareObstruction_attempt.v`

- `real_quartet_no_cp_readout` — **Closed under the global context**

### `formal/InfoThetaEdgeCensus_attempt.v`

- `theta_census_exists_3` — **Closed under the global context**
- `theta_census_unique_3` — **Closed under the global context**
- `edge_generators_independent_3` — **Closed under the global context**

### `formal/InfoThetaFixedPointBalance_attempt.v`

- `fixed_point_balance_law` — **Closed under the global context**
- `mirror_symmetry_is_dead` — **Closed under the global context**
- `agreement_is_dead` — **Closed under the global context**

### `formal/InfoThetaLivingOrientationSign_attempt.v`

- `locus_Z1Z3_J_square` — **Closed under the global context**
- `qsquare_nonneg` — **Closed under the global context**
- `locus_Z1Z3_J_nonneg` — **Closed under the global context**
- `qsquare_pos_of_nonzero` — **Closed under the global context**
- `locus_Z1Z3_J_pos` — **Closed under the global context**
- `locus_Z0Z2_J_square` — **Closed under the global context**
- `locus_Z0Z2_J_nonneg` — **Closed under the global context**
- `locus_Z0Z2_J_pos` — **Closed under the global context**
- `diffR_taylor_identity` — **Closed under the global context**
- `diffRec_taylor_identity` — **Closed under the global context**
- `linear_diff_system_nondegenerate` — **Closed under the global context**
- `edge_locus_kills_support` — **Closed under the global context**
- `edge_locus_incompatible_with_strict_support_rule` — **Closed under the global context**
- `c4_edge01_locus_excluded` — **Closed under the global context**
- `c4_edge12_locus_excluded` — **Closed under the global context**
- `c4_edge23_locus_excluded` — **Closed under the global context**
- `c4_edge03_locus_excluded` — **Closed under the global context**
- `c4_reflection_01_23_excluded` — **Closed under the global context**
- `c4_reflection_12_30_excluded` — **Closed under the global context**

### `formal/InfoThetaMinimalLiving_attempt.v`

- `n2_empty_support_dead` — **Closed under the global context**
- `red_rsum` — **Closed under the global context**
- `red_rdiff` — **Closed under the global context**
- `red_csum` — **Closed under the global context**
- `red_cdiff` — **Closed under the global context**
- `n2_edge_present_dead` — **Closed under the global context**
- `n2_no_living_fixed_point` — **Closed under the global context**

### `formal/InfoThetaOrientedSkewObstruction_attempt.v`

- `qsign_exists` — **Closed under the global context**
- `cyclic_product_switching_invariant_triangle` — **Closed under the global context**
- `cyclic_product_switching_invariant_C4` — **Closed under the global context**
- `tree_gauge_fixable_P3` — **Closed under the global context**
- `tree_gauge_fixable_star3` — **Closed under the global context**
- `tree_gauge_fixable_P4` — **Closed under the global context**
- `tree_gauge_fixable_star4` — **Closed under the global context**

### `formal/InfoThetaQuartetSquareObstruction_attempt.v`

- `quartet_rescale_invariant` — **Closed under the global context**
- `quartet_real_scalar_rescale` — **Closed under the global context**
- `family_B_K3_exact` — **Closed under the global context**
- `family_B_C4_vanishes` — **Closed under the global context**
- `family_C_rank1_vanishes` — **Closed under the global context**
- `family_A_not_switching_invariant` — **Closed under the global context**
- `family_A_witness_original_value` — **Closed under the global context**
- `family_A_witness_switched_value` — **Closed under the global context**
- `skew_source_switching_covariant` — **Closed under the global context**
- `symmetric_source_switched_value` — **Closed under the global context**
- `symmetric_source_naive_covariant_prediction` — **Closed under the global context**
- `symmetric_source_not_switching_covariant` — **Closed under the global context**
- `c4_reversal_is_gauge_witness` — **Closed under the global context**
- `k3_no_uniform_reversal_gauge` — **Closed under the global context**

### `formal/InfoThetaSectorSpectrum_attempt.v`

- `k3_invariance_forces_uniform` — **Closed under the global context**
- `p3_invariance_forces_uniform` — **Closed under the global context**
- `k3_spectrum_zero` — **Closed under the global context**
- `k3_spectrum_top_a` — **Closed under the global context**
- `k3_spectrum_top_b` — **Closed under the global context**
- `p3_spectrum_zero` — **Closed under the global context**
- `p3_spectrum_mid` — **Closed under the global context**
- `p3_spectrum_top` — **Closed under the global context**
- `p3_levels_distinct` — **Closed under the global context**

### `formal/InfoThetaTopologyReadout_attempt.v`

- `edge_source_bilinear_01` — **Closed under the global context**
- `edge_source_bilinear_02` — **Closed under the global context**
- `edge_source_bilinear_12` — **Closed under the global context**
- `Qmult_pos_pos` — **Closed under the global context**
- `Qsquare_nonneg` — **Closed under the global context**
- `clipped_stationarity_absent` — **Closed under the global context**
- `clipped_stationarity_present` — **Closed under the global context**
- `discordance_complement_flip` — **Closed under the global context**
- `witness_total_disorder_K3` — **Closed under the global context**
- `witness_partial_disorder_P3` — **Closed under the global context**

### `formal/InfoTrueRecordUnreadable_attempt.v`

- `no_decoder_recovers_state` (as `TrueRecordUnreadable.no_decoder_recovers_state`) — **Closed under the global context**
- `gauge_redundancy_forces_undecodability` (as `TrueRecordUnreadable.gauge_redundancy_forces_undecodability`) — **Closed under the global context**
- `true_state_exists_but_no_total_decoder` (as `TrueRecordUnreadable.true_state_exists_but_no_total_decoder`) — **Closed under the global context**

### `domains/standard_model/InfoAllOrderCharacter.v`

- `fusion_3_3bar_dim` (as `InfoAllOrderCharacter.fusion_3_3bar_dim`) — **Closed under the global context**
- `chi8_at_identity` (as `InfoAllOrderCharacter.chi8_at_identity`) — **Closed under the global context**
- `adjoint_tail_bound_N8` (as `InfoAllOrderCharacter.adjoint_tail_bound_N8`) — **Closed under the global context**
- `c0_prime_coefficient` (as `InfoAllOrderCharacter.c0_prime_coefficient`) — **Closed under the global context**
- `c0_prime_is_two_c3` (as `InfoAllOrderCharacter.c0_prime_is_two_c3`) — **Closed under the global context**
- `certificate_ratio_linear` (as `InfoAllOrderCharacter.certificate_ratio_linear`) — **Closed under the global context**

### `domains/standard_model/InfoBlindMatterSearch.v`

- `min_components` (as `InfoBlindMatterSearch.min_components`) — **Closed under the global context**
- `min_multiplets` (as `InfoBlindMatterSearch.min_multiplets`) — **Closed under the global context**
- `witness_minimum` (as `InfoBlindMatterSearch.witness_minimum`) — **Closed under the global context**
- `witness_gates` (as `InfoBlindMatterSearch.witness_gates`) — **Closed under the global context**
- `conjugate_minimum` (as `InfoBlindMatterSearch.conjugate_minimum`) — **Closed under the global context**
- `Z6_center_lock` (as `InfoBlindMatterSearch.Z6_center_lock`) — **Closed under the global context**
- `A_grav_lock` (as `InfoBlindMatterSearch.A_grav_lock`) — **Closed under the global context**
- `A111_factorizes` (as `InfoBlindMatterSearch.A111_factorizes`) — **Closed under the global context**
- `derived_charges` (as `InfoBlindMatterSearch.derived_charges`) — **Closed under the global context**
- `nu_grav_vanishes` (as `InfoBlindMatterSearch.nu_grav_vanishes`) — **Closed under the global context**

### `domains/standard_model/InfoBlockCorrelation.v`

- `transverse_axes` (as `InfoBlockCorrelation.transverse_axes`) — **Closed under the global context**
- `bump_dirs_per_plaq` (as `InfoBlockCorrelation.bump_dirs_per_plaq`) — **Closed under the global context**
- `single_bump_count` (as `InfoBlockCorrelation.single_bump_count`) — **Closed under the global context**
- `bump_area` (as `InfoBlockCorrelation.bump_area`) — **Closed under the global context**
- `planar_control_D2` (as `InfoBlockCorrelation.planar_control_D2`) — **Closed under the global context**
- `rho_geom_expand` (as `InfoBlockCorrelation.rho_geom_expand`) — **Closed under the global context**
- `correlations_increase_survival` (as `InfoBlockCorrelation.correlations_increase_survival`) — **Closed under the global context**
- `planar_recovers_serial` (as `InfoBlockCorrelation.planar_recovers_serial`) — **Closed under the global context**
- `first_shell_cert_witness` (as `InfoBlockCorrelation.first_shell_cert_witness`) — **Closed under the global context**

### `domains/standard_model/InfoCenterConfinement.v`

- `omega_sq` (as `InfoCenterConfinement.omega_sq`) — **Closed under the global context**
- `omega_cubed_is_one` (as `InfoCenterConfinement.omega_cubed_is_one`) — **Closed under the global context**
- `one_plus_w_plus_w2_zero` (as `InfoCenterConfinement.one_plus_w_plus_w2_zero`) — **Closed under the global context**
- `abs_omega_minus_one_sq_is_three` (as `InfoCenterConfinement.abs_omega_minus_one_sq_is_three`) — **Closed under the global context**
- `numerator_is_one_minus_r` (as `InfoCenterConfinement.numerator_is_one_minus_r`) — **Closed under the global context**
- `q_flat_is_one` (as `InfoCenterConfinement.q_flat_is_one`) — **Closed under the global context**
- `q_disorder_is_zero` (as `InfoCenterConfinement.q_disorder_is_zero`) — **Closed under the global context**
- `wilson_area_multiplicative` (as `InfoCenterConfinement.wilson_area_multiplicative`) — **Closed under the global context**
- `area_beats_perimeter` (as `InfoCenterConfinement.area_beats_perimeter`) — **Closed under the global context**

### `domains/standard_model/InfoConfinementCertificate.v`

- `plaquette_max_degree_4D` (as `InfoConfinementCertificate.plaquette_max_degree_4D`) — **Closed under the global context**
- `frobenius_identity_R` (as `InfoConfinementCertificate.frobenius_identity_R`) — **Closed under the global context**
- `center_max_is_nine` (as `InfoConfinementCertificate.center_max_is_nine`) — **Closed under the global context**
- `identity_min_is_zero` (as `InfoConfinementCertificate.identity_min_is_zero`) — **Closed under the global context**
- `c3_factors_out_k` (as `InfoConfinementCertificate.c3_factors_out_k`) — **Closed under the global context**
- `c0_at_zero` (as `InfoConfinementCertificate.c0_at_zero`) — **Closed under the global context**
- `c3_at_zero` (as `InfoConfinementCertificate.c3_at_zero`) — **Closed under the global context**
- `retained_suppression` (as `InfoConfinementCertificate.retained_suppression`) — **Closed under the global context**
- `finite_surface_sum` (as `InfoConfinementCertificate.finite_surface_sum`) — **Closed under the global context**

### `domains/standard_model/InfoDimensionFourClosure.v`

- `carrier_dim` (as `InfoDimensionFourClosure.carrier_dim`) — **Closed under the global context**
- `parity_d4` (as `InfoDimensionFourClosure.parity_d4`) — **Closed under the global context**
- `parity_d2` (as `InfoDimensionFourClosure.parity_d2`) — **Closed under the global context**
- `parity_d3` (as `InfoDimensionFourClosure.parity_d3`) — **Closed under the global context**
- `parity_d1` (as `InfoDimensionFourClosure.parity_d1`) — **Closed under the global context**
- `even_grading` (as `InfoDimensionFourClosure.even_grading`) — **Closed under the global context**
- `odd_grading_fails` (as `InfoDimensionFourClosure.odd_grading_fails`) — **Closed under the global context**
- `e_orthonormal` (as `InfoDimensionFourClosure.e_orthonormal`) — **Closed under the global context**
- `no_fourth_orthogonal` (as `InfoDimensionFourClosure.no_fourth_orthogonal`) — **Closed under the global context**
- `clifford_reduces_to_dot` (as `InfoDimensionFourClosure.clifford_reduces_to_dot`) — **Closed under the global context**

### `domains/standard_model/InfoElectroweakNullDirection.v`

- `det_neutral_zero` (as `InfoElectroweakNullDirection.det_neutral_zero`) — **Closed under the global context**
- `photon_null_direction` (as `InfoElectroweakNullDirection.photon_null_direction`) — **Closed under the global context**
- `Z_massive_eigenvector` (as `InfoElectroweakNullDirection.Z_massive_eigenvector`) — **Closed under the global context**
- `mZ2_is_trace` (as `InfoElectroweakNullDirection.mZ2_is_trace`) — **Closed under the global context**
- `photon_orthogonal_Z` (as `InfoElectroweakNullDirection.photon_orthogonal_Z`) — **Closed under the global context**
- `generic_rank2_det_is_one` (as `InfoElectroweakNullDirection.generic_rank2_det_is_one`) — **Closed under the global context**
- `generic_rank2_no_massless` (as `InfoElectroweakNullDirection.generic_rank2_no_massless`) — **Closed under the global context**

### `domains/standard_model/InfoFiniteTransferGap.v`

- `strict_contraction_gives_gap` (as `InfoFiniteTransferGap.strict_contraction_gives_gap`) — **Closed under the global context**
- `fixture_gap` (as `InfoFiniteTransferGap.fixture_gap`) — **Closed under the global context**
- `positive_control` (as `InfoFiniteTransferGap.positive_control`) — **Closed under the global context**
- `e0_e1_orthogonal` (as `InfoFiniteTransferGap.e0_e1_orthogonal`) — **Closed under the global context**
- `contraction_on_perp` (as `InfoFiniteTransferGap.contraction_on_perp`) — **Closed under the global context**
- `degeneracy_no_gap` (as `InfoFiniteTransferGap.degeneracy_no_gap`) — **Closed under the global context**
- `diffusion_gap_positive` (as `InfoFiniteTransferGap.diffusion_gap_positive`) — **Closed under the global context**
- `diffusion_gap_closes` (as `InfoFiniteTransferGap.diffusion_gap_closes`) — **Closed under the global context**

### `domains/standard_model/InfoFourForceCirculationRecovery.v`

- `A_times_X_is_204I` (as `InfoFourForceCirculationRecovery.A_times_X_is_204I`) — **Closed under the global context**
- `directed_response_identity` (as `InfoFourForceCirculationRecovery.directed_response_identity`) — **Closed under the global context**
- `circulation_recovery` (as `InfoFourForceCirculationRecovery.circulation_recovery`) — **Closed under the global context**
- `reciprocal_control_zero` (as `InfoFourForceCirculationRecovery.reciprocal_control_zero`) — **Closed under the global context**
- `omega_antisym` (as `InfoFourForceCirculationRecovery.omega_antisym`) — **Closed under the global context**
- `omega_nonzero` (as `InfoFourForceCirculationRecovery.omega_nonzero`) — **Closed under the global context**

### `domains/standard_model/InfoFrameMixingAction.v`

- `weight_term_nonneg` (as `InfoFrameMixingAction.weight_term_nonneg`) — **Closed under the global context**
- `weight_reversal_symmetric` (as `InfoFrameMixingAction.weight_reversal_symmetric`) — **Closed under the global context**
- `weights_sum_to_one` (as `InfoFrameMixingAction.weights_sum_to_one`) — **Closed under the global context**
- `identity_self_loop_positive` (as `InfoFrameMixingAction.identity_self_loop_positive`) — **Closed under the global context**
- `sextic_leading_is_25pow6` (as `InfoFrameMixingAction.sextic_leading_is_25pow6`) — **Closed under the global context**
- `rho_bracket_low` (as `InfoFrameMixingAction.rho_bracket_low`) — **Closed under the global context**
- `rho_bracket_high` (as `InfoFrameMixingAction.rho_bracket_high`) — **Closed under the global context**
- `rho_at_one_pos` (as `InfoFrameMixingAction.rho_at_one_pos`) — **Closed under the global context**
- `rho_bracket_in_unit` (as `InfoFrameMixingAction.rho_bracket_in_unit`) — **Closed under the global context**
- `stronger_than_v1_10` (as `InfoFrameMixingAction.stronger_than_v1_10`) — **Closed under the global context**
- `scale_preserved` (as `InfoFrameMixingAction.scale_preserved`) — **Closed under the global context**

### `domains/standard_model/InfoGaugeAutomorphismGroup.v`

- `pathcomp_nil` (as `InfoGaugeAutomorphismGroup.pathcomp_nil`) — **Closed under the global context**
- `pathcomp_app` (as `InfoGaugeAutomorphismGroup.pathcomp_app`) — **Closed under the global context**
- `pathcomp_single` (as `InfoGaugeAutomorphismGroup.pathcomp_single`) — **Closed under the global context**
- `pathcomp_app_assoc` (as `InfoGaugeAutomorphismGroup.pathcomp_app_assoc`) — **Closed under the global context**
- `id_is_aut` (as `InfoGaugeAutomorphismGroup.id_is_aut`) — **Closed under the global context**
- `aut_closed_under_compose` (as `InfoGaugeAutomorphismGroup.aut_closed_under_compose`) — **Closed under the global context**
- `aut_closed_under_inverse` (as `InfoGaugeAutomorphismGroup.aut_closed_under_inverse`) — **Closed under the global context**
- `aut_is_a_group` (as `InfoGaugeAutomorphismGroup.aut_is_a_group`) — **Closed under the global context**

### `domains/standard_model/InfoGaugeLocalizationConnectionHolonomy.v`

- `group_cancel_left` (as `InfoGaugeLocalizationConnectionHolonomy.group_cancel_left`) — **Closed under the global context**
- `group_cancel_middle` (as `InfoGaugeLocalizationConnectionHolonomy.group_cancel_middle`) — **Closed under the global context**
- `pathprod_O` (as `InfoGaugeLocalizationConnectionHolonomy.pathprod_O`) — **Closed under the global context**
- `coboundary_telescopes` (as `InfoGaugeLocalizationConnectionHolonomy.coboundary_telescopes`) — **Closed under the global context**
- `closed_loop_pure_gauge_flat` (as `InfoGaugeLocalizationConnectionHolonomy.closed_loop_pure_gauge_flat`) — **Closed under the global context**
- `connection_law_exists` (as `InfoGaugeLocalizationConnectionHolonomy.connection_law_exists`) — **Closed under the global context**
- `connection_law_unique` (as `InfoGaugeLocalizationConnectionHolonomy.connection_law_unique`) — **Closed under the global context**
- `conj_preserves_identity` (as `InfoGaugeLocalizationConnectionHolonomy.conj_preserves_identity`) — **Closed under the global context**
- `conj_trivial_iff` (as `InfoGaugeLocalizationConnectionHolonomy.conj_trivial_iff`) — **Closed under the global context**
- `conj_composes` (as `InfoGaugeLocalizationConnectionHolonomy.conj_composes`) — **Closed under the global context**

### `domains/standard_model/InfoHyperchargeAnomalyClosure.v`

- `coupling_invariance` (as `InfoHyperchargeAnomalyClosure.coupling_invariance`) — **Closed under the global context**
- `mixed_SU2_U1` (as `InfoHyperchargeAnomalyClosure.mixed_SU2_U1`) — **Closed under the global context**
- `mixed_grav_U1` (as `InfoHyperchargeAnomalyClosure.mixed_grav_U1`) — **Closed under the global context**
- `cubic_anomaly_zero` (as `InfoHyperchargeAnomalyClosure.cubic_anomaly_zero`) — **Closed under the global context**
- `are_SM_hypercharges` (as `InfoHyperchargeAnomalyClosure.are_SM_hypercharges`) — **Closed under the global context**
- `TrK0inv_is_27_10` (as `InfoHyperchargeAnomalyClosure.TrK0inv_is_27_10`) — **Closed under the global context**
- `r1_raw_response` (as `InfoHyperchargeAnomalyClosure.r1_raw_response`) — **Closed under the global context**

### `domains/standard_model/InfoHyperchargeGlobalQuotient.v`

- `center_lock_Q` (as `InfoHyperchargeGlobalQuotient.center_lock_Q`) — **Closed under the global context**
- `center_lock_uc` (as `InfoHyperchargeGlobalQuotient.center_lock_uc`) — **Closed under the global context**
- `center_lock_dc` (as `InfoHyperchargeGlobalQuotient.center_lock_dc`) — **Closed under the global context**
- `center_lock_L` (as `InfoHyperchargeGlobalQuotient.center_lock_L`) — **Closed under the global context**
- `center_lock_ec` (as `InfoHyperchargeGlobalQuotient.center_lock_ec`) — **Closed under the global context**
- `center_lock_H` (as `InfoHyperchargeGlobalQuotient.center_lock_H`) — **Closed under the global context**
- `global_su2_even` (as `InfoHyperchargeGlobalQuotient.global_su2_even`) — **Closed under the global context**
- `A_grav_is_h_minus_3q` (as `InfoHyperchargeGlobalQuotient.A_grav_is_h_minus_3q`) — **Closed under the global context**
- `A111_factorizes` (as `InfoHyperchargeGlobalQuotient.A111_factorizes`) — **Closed under the global context**
- `sm_hypercharges` (as `InfoHyperchargeGlobalQuotient.sm_hypercharges`) — **Closed under the global context**
- `Y_values` (as `InfoHyperchargeGlobalQuotient.Y_values`) — **Closed under the global context**
- `Q_em_pattern` (as `InfoHyperchargeGlobalQuotient.Q_em_pattern`) — **Closed under the global context**
- `nu_grav_vanishes` (as `InfoHyperchargeGlobalQuotient.nu_grav_vanishes`) — **Closed under the global context**
- `nu_cubic_vanishes` (as `InfoHyperchargeGlobalQuotient.nu_cubic_vanishes`) — **Closed under the global context**

### `domains/standard_model/InfoIntertwinerOrderVacuum.v`

- `nu_U1_closures` (as `InfoIntertwinerOrderVacuum.nu_U1_closures`) — **Closed under the global context**
- `closure_mode_count` (as `InfoIntertwinerOrderVacuum.closure_mode_count`) — **Closed under the global context**
- `tape_quotient` (as `InfoIntertwinerOrderVacuum.tape_quotient`) — **Closed under the global context**
- `fock_vanishes_at_zero` (as `InfoIntertwinerOrderVacuum.fock_vanishes_at_zero`) — **Closed under the global context**
- `origin_slope` (as `InfoIntertwinerOrderVacuum.origin_slope`) — **Closed under the global context**
- `fraction_term_nonneg` (as `InfoIntertwinerOrderVacuum.fraction_term_nonneg`) — **Closed under the global context**
- `convexity_automatic` (as `InfoIntertwinerOrderVacuum.convexity_automatic`) — **Closed under the global context**
- `pressure_max_seven` (as `InfoIntertwinerOrderVacuum.pressure_max_seven`) — **Closed under the global context**
- `no_go_alpha_seven` (as `InfoIntertwinerOrderVacuum.no_go_alpha_seven`) — **Closed under the global context**
- `scale_lower_bound` (as `InfoIntertwinerOrderVacuum.scale_lower_bound`) — **Closed under the global context**
- `scale_upper_bound` (as `InfoIntertwinerOrderVacuum.scale_upper_bound`) — **Closed under the global context**

### `domains/standard_model/InfoIsotropicFixedPoint.v`

- `contraction_factor` (as `InfoIsotropicFixedPoint.contraction_factor`) — **Closed under the global context**
- `one_step` (as `InfoIsotropicFixedPoint.one_step`) — **Closed under the global context**
- `trace_preserved` (as `InfoIsotropicFixedPoint.trace_preserved`) — **Closed under the global context**
- `sextic_bracket_low` (as `InfoIsotropicFixedPoint.sextic_bracket_low`) — **Closed under the global context**
- `sextic_bracket_high` (as `InfoIsotropicFixedPoint.sextic_bracket_high`) — **Closed under the global context**
- `sextic_at_one` (as `InfoIsotropicFixedPoint.sextic_at_one`) — **Closed under the global context**
- `rho_bracket_in_unit` (as `InfoIsotropicFixedPoint.rho_bracket_in_unit`) — **Closed under the global context**
- `P_stochastic` (as `InfoIsotropicFixedPoint.P_stochastic`) — **Closed under the global context**
- `average_conserved` (as `InfoIsotropicFixedPoint.average_conserved`) — **Closed under the global context**
- `consensus_gap` (as `InfoIsotropicFixedPoint.consensus_gap`) — **Closed under the global context**
- `deviation_update` (as `InfoIsotropicFixedPoint.deviation_update`) — **Closed under the global context**

### `domains/standard_model/InfoOrderDefectFromComposition.v`

- `mmul_assoc` (as `InfoOrderDefectFromComposition.mmul_assoc`) — **Closed under the global context**
- `mmul_id_l` (as `InfoOrderDefectFromComposition.mmul_id_l`) — **Closed under the global context**
- `mmul_id_r` (as `InfoOrderDefectFromComposition.mmul_id_r`) — **Closed under the global context**
- `K_is_ordered_defect` (as `InfoOrderDefectFromComposition.K_is_ordered_defect`) — **Closed under the global context**
- `K_antisym` (as `InfoOrderDefectFromComposition.K_antisym`) — **Closed under the global context**
- `K_bilinear_left` (as `InfoOrderDefectFromComposition.K_bilinear_left`) — **Closed under the global context**
- `K_bilinear_right` (as `InfoOrderDefectFromComposition.K_bilinear_right`) — **Closed under the global context**
- `jacobi` (as `InfoOrderDefectFromComposition.jacobi`) — **Closed under the global context**
- `nonabelian_witness_a11` (as `InfoOrderDefectFromComposition.nonabelian_witness_a11`) — **Closed under the global context**
- `nonabelian_witness` (as `InfoOrderDefectFromComposition.nonabelian_witness`) — **Closed under the global context**
- `abelian_no_selfforce` (as `InfoOrderDefectFromComposition.abelian_no_selfforce`) — **Closed under the global context**
- `diagonal_commute_zero_defect` (as `InfoOrderDefectFromComposition.diagonal_commute_zero_defect`) — **Closed under the global context**

### `domains/standard_model/InfoOrderHiggsClosure.v`

- `yH_from_QHU` (as `InfoOrderHiggsClosure.yH_from_QHU`) — **Closed under the global context**
- `yH_from_QHdD` (as `InfoOrderHiggsClosure.yH_from_QHdD`) — **Closed under the global context**
- `yH_from_LHdE` (as `InfoOrderHiggsClosure.yH_from_LHdE`) — **Closed under the global context**
- `yH_unique` (as `InfoOrderHiggsClosure.yH_unique`) — **Closed under the global context**
- `su2_doublet_has_singlet` (as `InfoOrderHiggsClosure.su2_doublet_has_singlet`) — **Closed under the global context**
- `su2_singlet_no_singlet` (as `InfoOrderHiggsClosure.su2_singlet_no_singlet`) — **Closed under the global context**
- `su2_triplet_no_singlet` (as `InfoOrderHiggsClosure.su2_triplet_no_singlet`) — **Closed under the global context**
- `broken_count` (as `InfoOrderHiggsClosure.broken_count`) — **Closed under the global context**
- `dof_balance` (as `InfoOrderHiggsClosure.dof_balance`) — **Closed under the global context**
- `residual_annihilates_vacuum` (as `InfoOrderHiggsClosure.residual_annihilates_vacuum`) — **Closed under the global context**
- `broken_diagonal_nonzero` (as `InfoOrderHiggsClosure.broken_diagonal_nonzero`) — **Closed under the global context**
- `neutral_det_zero` (as `InfoOrderHiggsClosure.neutral_det_zero`) — **Closed under the global context**
- `mW_mZ_relation` (as `InfoOrderHiggsClosure.mW_mZ_relation`) — **Closed under the global context**
- `mZ2_is_trace` (as `InfoOrderHiggsClosure.mZ2_is_trace`) — **Closed under the global context**
- `photon_zero_mode` (as `InfoOrderHiggsClosure.photon_zero_mode`) — **Closed under the global context**

### `domains/standard_model/InfoOrderedTapeClosure.v`

- `oddness_from_cyclic_closure` (as `InfoOrderedTapeClosure.oddness_from_cyclic_closure`) — **Closed under the global context**
- `two_is_not_odd` (as `InfoOrderedTapeClosure.two_is_not_odd`) — **Closed under the global context**
- `three_is_odd` (as `InfoOrderedTapeClosure.three_is_odd`) — **Closed under the global context**
- `k_min_is_three` (as `InfoOrderedTapeClosure.k_min_is_three`) — **Closed under the global context**
- `repeated_event_zero` (as `InfoOrderedTapeClosure.repeated_event_zero`) — **Closed under the global context**
- `R_preserves_load` (as `InfoOrderedTapeClosure.R_preserves_load`) — **Closed under the global context**
- `R_preserves_triple` (as `InfoOrderedTapeClosure.R_preserves_triple`) — **Closed under the global context**
- `det_common_phase_is_cube` (as `InfoOrderedTapeClosure.det_common_phase_is_cube`) — **Closed under the global context**
- `wilson_trace_invariant` (as `InfoOrderedTapeClosure.wilson_trace_invariant`) — **Closed under the global context**

### `domains/standard_model/InfoRetainedIntertwiner.v`

- `G_orthogonal_preserves_load` (as `InfoRetainedIntertwiner.G_orthogonal_preserves_load`) — **Closed under the global context**
- `intertwiner_idempotent` (as `InfoRetainedIntertwiner.intertwiner_idempotent`) — **Closed under the global context**
- `intertwiner_contraction` (as `InfoRetainedIntertwiner.intertwiner_contraction`) — **Closed under the global context**
- `finite_geometric` (as `InfoRetainedIntertwiner.finite_geometric`) — **Closed under the global context**
- `ratio_is_linear` (as `InfoRetainedIntertwiner.ratio_is_linear`) — **Closed under the global context**
- `tail_resummation` (as `InfoRetainedIntertwiner.tail_resummation`) — **Closed under the global context**
- `eight_v_series` (as `InfoRetainedIntertwiner.eight_v_series`) — **Closed under the global context**

### `domains/standard_model/InfoRootChirality.v`

- `gamma_involution` (as `InfoRootChirality.gamma_involution`) — **Closed under the global context**
- `gamma_selfadjoint` (as `InfoRootChirality.gamma_selfadjoint`) — **Closed under the global context**
- `reversal_involution` (as `InfoRootChirality.reversal_involution`) — **Closed under the global context**
- `reversal_flips_gamma` (as `InfoRootChirality.reversal_flips_gamma`) — **Closed under the global context**
- `Pp_idem` (as `InfoRootChirality.Pp_idem`) — **Closed under the global context**
- `Pm_idem` (as `InfoRootChirality.Pm_idem`) — **Closed under the global context**
- `P_orth` (as `InfoRootChirality.P_orth`) — **Closed under the global context**
- `P_complete` (as `InfoRootChirality.P_complete`) — **Closed under the global context**
- `nogo_reversal_symmetric` (as `InfoRootChirality.nogo_reversal_symmetric`) — **Closed under the global context**
- `nogo_commutes` (as `InfoRootChirality.nogo_commutes`) — **Closed under the global context**
- `Pw_idem_plus` (as `InfoRootChirality.Pw_idem_plus`) — **Closed under the global context**
- `Pw_idem_minus` (as `InfoRootChirality.Pw_idem_minus`) — **Closed under the global context**
- `Pw_Ps_orth` (as `InfoRootChirality.Pw_Ps_orth`) — **Closed under the global context**
- `Pw_selects_minus` (as `InfoRootChirality.Pw_selects_minus`) — **Closed under the global context**
- `Pw_flip` (as `InfoRootChirality.Pw_flip`) — **Closed under the global context**
- `KXi_psd_det` (as `InfoRootChirality.KXi_psd_det`) — **Closed under the global context**
- `KXi_psd_diag` (as `InfoRootChirality.KXi_psd_diag`) — **Closed under the global context**

### `domains/standard_model/InfoSurfaceAutomaton.v`

- `canonical_critical_polynomial` (as `InfoSurfaceAutomaton.canonical_critical_polynomial`) — **Closed under the global context**
- `shortest_bracket_simplifies` (as `InfoSurfaceAutomaton.shortest_bracket_simplifies`) — **Closed under the global context**
- `shortest_critical_polynomial` (as `InfoSurfaceAutomaton.shortest_critical_polynomial`) — **Closed under the global context**
- `pcan_neg_at_29` (as `InfoSurfaceAutomaton.pcan_neg_at_29`) — **Closed under the global context**
- `pcan_pos_at_30` (as `InfoSurfaceAutomaton.pcan_pos_at_30`) — **Closed under the global context**
- `pshort_neg_at_25` (as `InfoSurfaceAutomaton.pshort_neg_at_25`) — **Closed under the global context**
- `pshort_pos_at_26` (as `InfoSurfaceAutomaton.pshort_pos_at_26`) — **Closed under the global context**
- `mu_short_lower` (as `InfoSurfaceAutomaton.mu_short_lower`) — **Closed under the global context**
- `lower_below_upper` (as `InfoSurfaceAutomaton.lower_below_upper`) — **Closed under the global context**

### `domains/standard_model/InfoSurfaceUpperAutomaton.v`

- `branching_coeff_sum` (as `InfoSurfaceUpperAutomaton.branching_coeff_sum`) — **Closed under the global context**
- `eightyone_is_3_to_4` (as `InfoSurfaceUpperAutomaton.eightyone_is_3_to_4`) — **Closed under the global context**
- `pB_neg_at_14` (as `InfoSurfaceUpperAutomaton.pB_neg_at_14`) — **Closed under the global context**
- `pB_pos_at_15` (as `InfoSurfaceUpperAutomaton.pB_pos_at_15`) — **Closed under the global context**
- `pB_pos_at_fifth` (as `InfoSurfaceUpperAutomaton.pB_pos_at_fifth`) — **Closed under the global context**
- `mu_upper_lower_side` (as `InfoSurfaceUpperAutomaton.mu_upper_lower_side`) — **Closed under the global context**
- `mu_upper_upper_side` (as `InfoSurfaceUpperAutomaton.mu_upper_upper_side`) — **Closed under the global context**
- `new_below_old` (as `InfoSurfaceUpperAutomaton.new_below_old`) — **Closed under the global context**
- `new_above_lower` (as `InfoSurfaceUpperAutomaton.new_above_lower`) — **Closed under the global context**

### `domains/standard_model/InfoTapeKineticGW.v`

- `clifford_Ax_sq` (as `InfoTapeKineticGW.clifford_Ax_sq`) — **Closed under the global context**
- `clifford_Az_sq` (as `InfoTapeKineticGW.clifford_Az_sq`) — **Closed under the global context**
- `clifford_anticommute` (as `InfoTapeKineticGW.clifford_anticommute`) — **Closed under the global context**
- `V_unitary` (as `InfoTapeKineticGW.V_unitary`) — **Closed under the global context**
- `V_gamma_relation` (as `InfoTapeKineticGW.V_gamma_relation`) — **Closed under the global context**
- `Gamma_V_Gamma_is_Vdag` (as `InfoTapeKineticGW.Gamma_V_Gamma_is_Vdag`) — **Closed under the global context**
- `ginsparg_wilson` (as `InfoTapeKineticGW.ginsparg_wilson`) — **Closed under the global context**
- `ghat_involution` (as `InfoTapeKineticGW.ghat_involution`) — **Closed under the global context**
- `ghat_neq_gamma` (as `InfoTapeKineticGW.ghat_neq_gamma`) — **Closed under the global context**
- `physical_zero` (as `InfoTapeKineticGW.physical_zero`) — **Closed under the global context**
- `corners_lifted` (as `InfoTapeKineticGW.corners_lifted`) — **Closed under the global context**
- `corner_count_d4` (as `InfoTapeKineticGW.corner_count_d4`) — **Closed under the global context**
- `corner_count_general` (as `InfoTapeKineticGW.corner_count_general`) — **Closed under the global context**

### `domains/standard_model/InfoTrialitySpectralFlow.v`

- `serial_blocking_law` (as `InfoTrialitySpectralFlow.serial_blocking_law`) — **Closed under the global context**
- `qpow_pos` (as `InfoTrialitySpectralFlow.qpow_pos`) — **Closed under the global context**
- `block_contraction` (as `InfoTrialitySpectralFlow.block_contraction`) — **Closed under the global context**
- `block_scale_exists_witness` (as `InfoTrialitySpectralFlow.block_scale_exists_witness`) — **Closed under the global context**
- `no_contraction_if_rho_one` (as `InfoTrialitySpectralFlow.no_contraction_if_rho_one`) — **Closed under the global context**

### `domains/standard_model/InfoUniversalRPSlab.v`

- `gram_form_psd` (as `InfoUniversalRPSlab.gram_form_psd`) — **Closed under the global context**
- `negative_weight_breaks_psd` (as `InfoUniversalRPSlab.negative_weight_breaks_psd`) — **Closed under the global context**
- `product_weight_nonneg` (as `InfoUniversalRPSlab.product_weight_nonneg`) — **Closed under the global context**
- `gauge_c3_leading_positive` (as `InfoUniversalRPSlab.gauge_c3_leading_positive`) — **Closed under the global context**
- `massless_sector_zeros_total` (as `InfoUniversalRPSlab.massless_sector_zeros_total`) — **Closed under the global context**
- `massive_sector_gap_positive` (as `InfoUniversalRPSlab.massive_sector_gap_positive`) — **Closed under the global context**
- `fock_lift_eigenvalue_in_01` (as `InfoUniversalRPSlab.fock_lift_eigenvalue_in_01`) — **Closed under the global context**
- `mass_ratio_a_independent` (as `InfoUniversalRPSlab.mass_ratio_a_independent`) — **Closed under the global context**
