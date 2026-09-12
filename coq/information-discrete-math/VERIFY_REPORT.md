# VERIFY_REPORT — information-discrete-math import

Upstream commit: `147fc92671f35eb102405fec913eb361dc41f966` (public, MIT) for all files below except `formal/IDM_ReaderDomainFoundation.v`, which was vendored separately from a later commit, `ca5018925d98f5a710b2ceb561433f814915545b` (see its own `upstream_commit_for_this_file` entry in `PROVENANCE.json`). Verified on this machine 2026-09-06 (2026-09-13 for the later-vendored file). Readout-not-truth: every count below is read from the actual build/verify run recorded in `verify_report.json`, not copied from upstream's own claims.

## Build status (per file)

| file | build |
|---|---|
| `case_studies/double_pendulum_readout/ShakeIrrational.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_ApproxCount.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Apriori.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Bridge.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Calculus.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Certified.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Continuum.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_DeclarationBound.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_EquivariantReadout.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_FiniteWitnesses.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_FiniteWitnesses2.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_FiniteWitnesses3.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_FirstOrder.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Genesis.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Geometry.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Harvest.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Hilbert.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_HilbertReadout.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Keystone.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Logic.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Matrix.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_ReadoutMinimality.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_ReaderDomainFoundation.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Reduction.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_ResolvedCount.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Schur.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_SetsFunctions.v` | OK (coqc -q, sequential, one at a time) |
| `formal/IDM_Tropical.v` | OK (coqc -q, sequential, one at a time) |

All **28** files compiled cleanly with `coqc -q`, in dependency order (no `make -j`, one process at a time), matching upstream's own `formal/verify.sh` compile order for the 27 `formal/` files; `case_studies/double_pendulum_readout/ShakeIrrational.v` compiled standalone (no internal Toledo/IDM dependency, only stdlib `ZArith`/`Lia`).

## Theorem-level verification (`Print Assumptions`)

**274** identifiers checked (every Theorem/Lemma/Corollary/Proposition the manifest lists for this source) — **274 Closed under the global context**, **0 with named axioms**, **0 build/print failures**.

| file | identifier | status | axioms |
|---|---|---|---|
| `case_studies/double_pendulum_readout/ShakeIrrational.v` | `s_val` | Closed |  |
| `case_studies/double_pendulum_readout/ShakeIrrational.v` | `squeeze` | Closed |  |
| `case_studies/double_pendulum_readout/ShakeIrrational.v` | `delta_num_not_perfect_square` | Closed |  |
| `formal/IDM_ApproxCount.v` | `pigeonhole_bits_needed` | Closed |  |
| `formal/IDM_ApproxCount.v` | `weight_cons` | Closed |  |
| `formal/IDM_ApproxCount.v` | `weight_app` | Closed |  |
| `formal/IDM_ApproxCount.v` | `weight_repeat_true` | Closed |  |
| `formal/IDM_ApproxCount.v` | `weight_repeat_false` | Closed |  |
| `formal/IDM_ApproxCount.v` | `fam_elem_weight` | Closed |  |
| `formal/IDM_ApproxCount.v` | `k_bound` | Closed |  |
| `formal/IDM_ApproxCount.v` | `fam_elem_length` | Closed |  |
| `formal/IDM_ApproxCount.v` | `fam_length` | Closed |  |
| `formal/IDM_ApproxCount.v` | `fam_in` | Closed |  |
| `formal/IDM_ApproxCount.v` | `fam_nodup` | Closed |  |
| `formal/IDM_ApproxCount.v` | `r_correct_far_apart_False` | Closed |  |
| `formal/IDM_ApproxCount.v` | `approx_count_deferred_lower_bound` | Closed |  |
| `formal/IDM_Apriori.v` | `apriori_multiplicative_contracts` | Closed |  |
| `formal/IDM_Apriori.v` | `apriori_geometric_contracts` | Closed |  |
| `formal/IDM_Apriori.v` | `apriori_stable` | Closed |  |
| `formal/IDM_Apriori.v` | `half_nonneg` | Closed |  |
| `formal/IDM_Apriori.v` | `richardson_ratio_nonneg` | Closed |  |
| `formal/IDM_Apriori.v` | `richardson_ratio_le_one` | Closed |  |
| `formal/IDM_Apriori.v` | `richardson_apriori_contracts` | Closed |  |
| `formal/IDM_Apriori.v` | `richardson_apriori_stable` | Closed |  |
| `formal/IDM_Bridge.v` | `FTCC_exact` | Closed |  |
| `formal/IDM_Bridge.v` | `FTCC_eps_exact` | Closed |  |
| `formal/IDM_Bridge.v` | `bridge_faithful_exact_core` | Closed |  |
| `formal/IDM_Calculus.v` | `delta_sum` | Closed |  |
| `formal/IDM_Calculus.v` | `delta_scalar` | Closed |  |
| `formal/IDM_Calculus.v` | `delta_product` | Closed |  |
| `formal/IDM_Calculus.v` | `Deps_sum` | Closed |  |
| `formal/IDM_Calculus.v` | `Deps_product` | Closed |  |
| `formal/IDM_Calculus.v` | `FTCC_telescope` | Closed |  |
| `formal/IDM_Calculus.v` | `PSum_ext` | Closed |  |
| `formal/IDM_Calculus.v` | `PSum_delta_telescope` | Closed |  |
| `formal/IDM_Calculus.v` | `summation_by_parts` | Closed |  |
| `formal/IDM_Certified.v` | `geom_certified_identity` | Closed |  |
| `formal/IDM_Certified.v` | `geom_certified_defect` | Closed |  |
| `formal/IDM_Certified.v` | `geom_majorant_tail` | Closed |  |
| `formal/IDM_Certified.v` | `one_le_Sk` | Closed |  |
| `formal/IDM_Certified.v` | `q01` | Closed |  |
| `formal/IDM_Certified.v` | `q01_le` | Closed |  |
| `formal/IDM_Certified.v` | `pos_Sk` | Closed |  |
| `formal/IDM_Certified.v` | `div_le_self` | Closed |  |
| `formal/IDM_Certified.v` | `exp_term_nonneg` | Closed |  |
| `formal/IDM_Certified.v` | `exp_term_ratio` | Closed |  |
| `formal/IDM_Certified.v` | `exp_tail_certified` | Closed |  |
| `formal/IDM_Certified.v` | `two_nonneg` | Closed |  |
| `formal/IDM_Certified.v` | `sq_error_propagation` | Closed |  |
| `formal/IDM_Certified.v` | `mono_step` | Closed |  |
| `formal/IDM_Certified.v` | `valbound_nonneg` | Closed |  |
| `formal/IDM_Certified.v` | `errbound_nonneg` | Closed |  |
| `formal/IDM_Certified.v` | `iter_sq_valbound` | Closed |  |
| `formal/IDM_Certified.v` | `iter_sq_certified` | Closed |  |
| `formal/IDM_Certified.v` | `Qmult_le_l_nonneg` | Closed |  |
| `formal/IDM_Certified.v` | `abs_tailsum_le` | Closed |  |
| `formal/IDM_Certified.v` | `refine_stable` | Closed |  |
| `formal/IDM_Continuum.v` | `radd_at` | Closed |  |
| `formal/IDM_Continuum.v` | `rmul_at` | Closed |  |
| `formal/IDM_Continuum.v` | `radd_comm` | Closed |  |
| `formal/IDM_Continuum.v` | `const_gap_zero` | Closed |  |
| `formal/IDM_Continuum.v` | `gap_subadditive` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `b2n_inj` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `bit_extraction_exact` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `profile_injective` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `bcube_length` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `two_pow_pos` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `bcube_all_len` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `bcube_complete` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `bcube_halves_disjoint` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `NoDup_app_disjoint` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `NoDup_map_cons` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `bcube_nodup` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `short_records_length` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `short_records_complete` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `NoDup_map_inj_on` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `deferred_record_bits` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `declared_forgets_tail` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `declaration_separation` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `qary_symbol_injective` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `flat_map_cons_length` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `qcube_length` | Closed |  |
| `formal/IDM_DeclarationBound.v` | `qcube_all_len` | Closed |  |
| `formal/IDM_EquivariantReadout.v` | `equivariant_stabilizer_containment` | Closed |  |
| `formal/IDM_EquivariantReadout.v` | `faithful_stabilizer_equality` | Closed |  |
| `formal/IDM_EquivariantReadout.v` | `fixed_value_reads_equal` | Closed |  |
| `formal/IDM_EquivariantReadout.v` | `nondegenerate_value_moves` | Closed |  |
| `formal/IDM_FiniteWitnesses.v` | `handshake_lemma` | Closed |  |
| `formal/IDM_FiniteWitnesses.v` | `finite_yoneda` | Closed |  |
| `formal/IDM_FiniteWitnesses.v` | `sing_eq_iff` | Closed |  |
| `formal/IDM_FiniteWitnesses.v` | `kuratowski_pair_inj` | Closed |  |
| `formal/IDM_FiniteWitnesses.v` | `pigeonhole` | Closed |  |
| `formal/IDM_FiniteWitnesses.v` | `semiring_distrib` | Closed |  |
| `formal/IDM_FiniteWitnesses2.v` | `no_infinite_readout` | Closed |  |
| `formal/IDM_FiniteWitnesses2.v` | `tape_count_succ` | Closed |  |
| `formal/IDM_FiniteWitnesses2.v` | `tape_no_terminal` | Closed |  |
| `formal/IDM_FiniteWitnesses2.v` | `same_set_same_size` | Closed |  |
| `formal/IDM_FiniteWitnesses2.v` | `lagrange_order_div` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `no_fibonacci_integer_dim` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `ring_distrib_Z` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `Qsq_nonneg3` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `cauchy_schwarz_2` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `measure_additive` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `aut_assoc` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `aut_id_left` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `aut_id_right` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `aut_inv_left` | Closed |  |
| `formal/IDM_FiniteWitnesses3.v` | `aut_inv_right` | Closed |  |
| `formal/IDM_FirstOrder.v` | `eval_correct` | Closed |  |
| `formal/IDM_FirstOrder.v` | `sat_fo_decidable` | Closed |  |
| `formal/IDM_FirstOrder.v` | `models_decidable` | Closed |  |
| `formal/IDM_Genesis.v` | `primordial_difference_exists` | Closed |  |
| `formal/IDM_Genesis.v` | `succ_ground_distinct` | Closed |  |
| `formal/IDM_Genesis.v` | `discrete_floor` | Closed |  |
| `formal/IDM_Genesis.v` | `no_density_at_root` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_swap_bc` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_swap_ab` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_cyclic` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_coincident_ab` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_coincident_ac` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_coincident_bc` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_translation` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_scale` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_collinear_mid` | Closed |  |
| `formal/IDM_Geometry.v` | `orient_collinear_aff` | Closed |  |
| `formal/IDM_Harvest.v` | `repeated_event_zero` | Closed |  |
| `formal/IDM_Harvest.v` | `odd_from_cyclic_closure` | Closed |  |
| `formal/IDM_Harvest.v` | `least_nontrivial_odd_is_three` | Closed |  |
| `formal/IDM_Harvest.v` | `sym_skew_reconstruct` | Closed |  |
| `formal/IDM_Harvest.v` | `sympart_self_adjoint` | Closed |  |
| `formal/IDM_Harvest.v` | `skew_antisym` | Closed |  |
| `formal/IDM_Harvest.v` | `skew_diag_zero` | Closed |  |
| `formal/IDM_Hilbert.v` | `Qsq_nonneg` | Closed |  |
| `formal/IDM_Hilbert.v` | `Sum_scale` | Closed |  |
| `formal/IDM_Hilbert.v` | `Sum_nonneg` | Closed |  |
| `formal/IDM_Hilbert.v` | `inner_sym` | Closed |  |
| `formal/IDM_Hilbert.v` | `inner_linear_l` | Closed |  |
| `formal/IDM_Hilbert.v` | `inner_pos` | Closed |  |
| `formal/IDM_Hilbert.v` | `parallelogram_law` | Closed |  |
| `formal/IDM_Hilbert.v` | `pythagoras_orthogonal` | Closed |  |
| `formal/IDM_Hilbert.v` | `cauchy_schwarz_2` | Closed |  |
| `formal/IDM_Hilbert.v` | `adjoint_involutive` | Closed |  |
| `formal/IDM_Hilbert.v` | `adjoint_of_product` | Closed |  |
| `formal/IDM_Hilbert.v` | `hermitian_2x2_discriminant_nonneg` | Closed |  |
| `formal/IDM_Hilbert.v` | `hermitian_2x2_gap_is_discriminant` | Closed |  |
| `formal/IDM_Hilbert.v` | `projection_idempotent` | Closed |  |
| `formal/IDM_Hilbert.v` | `projection_self_adjoint` | Closed |  |
| `formal/IDM_HilbertReadout.v` | `Qsq_nonneg` | Closed |  |
| `formal/IDM_HilbertReadout.v` | `Qadd_nonneg` | Closed |  |
| `formal/IDM_HilbertReadout.v` | `partial_energy_nonneg` | Closed |  |
| `formal/IDM_HilbertReadout.v` | `partial_energy_app` | Closed |  |
| `formal/IDM_HilbertReadout.v` | `partial_energy_monotone` | Closed |  |
| `formal/IDM_HilbertReadout.v` | `weighted_energy_nonneg` | Closed |  |
| `formal/IDM_HilbertReadout.v` | `weighted_energy_app` | Closed |  |
| `formal/IDM_Keystone.v` | `keystone_edge` | Closed |  |
| `formal/IDM_Keystone.v` | `keystone_B_eq_I` | Closed |  |
| `formal/IDM_Keystone.v` | `Qsq_nonneg` | Closed |  |
| `formal/IDM_Keystone.v` | `Qadd_nonneg` | Closed |  |
| `formal/IDM_Keystone.v` | `I_edge_nonneg` | Closed |  |
| `formal/IDM_Keystone.v` | `keystone_nonneg` | Closed |  |
| `formal/IDM_Keystone.v` | `relaxation_dissipation` | Closed |  |
| `formal/IDM_Logic.v` | `sat_dec` | Closed |  |
| `formal/IDM_Logic.v` | `finite_satisfaction_dec` | Closed |  |
| `formal/IDM_Logic.v` | `rdl_non_explosion` | Closed |  |
| `formal/IDM_Logic.v` | `classical_would_explode` | Closed |  |
| `formal/IDM_Matrix.v` | `Sum_plus` | Closed |  |
| `formal/IDM_Matrix.v` | `Sum_opp` | Closed |  |
| `formal/IDM_Matrix.v` | `Sum_zero` | Closed |  |
| `formal/IDM_Matrix.v` | `Sum_ext` | Closed |  |
| `formal/IDM_Matrix.v` | `Sum_ext_lt` | Closed |  |
| `formal/IDM_Matrix.v` | `Sum_delta` | Closed |  |
| `formal/IDM_Matrix.v` | `madd_comm` | Closed |  |
| `formal/IDM_Matrix.v` | `madd_assoc` | Closed |  |
| `formal/IDM_Matrix.v` | `transpose_involutive` | Closed |  |
| `formal/IDM_Matrix.v` | `transpose_mmul` | Closed |  |
| `formal/IDM_Matrix.v` | `mid_left` | Closed |  |
| `formal/IDM_Matrix.v` | `laplacian_symmetric` | Closed |  |
| `formal/IDM_Matrix.v` | `laplacian_rowsum_zero` | Closed |  |
| `formal/IDM_Matrix.v` | `laplacian_ones_in_kernel` | Closed |  |
| `formal/IDM_Matrix.v` | `twirl_image_scalar` | Closed |  |
| `formal/IDM_Matrix.v` | `Sum_const` | Closed |  |
| `formal/IDM_Matrix.v` | `trace_scalarM` | Closed |  |
| `formal/IDM_Matrix.v` | `inject_nat_nonzero` | Closed |  |
| `formal/IDM_Matrix.v` | `trace_twirl` | Closed |  |
| `formal/IDM_Matrix.v` | `twirl_idempotent` | Closed |  |
| `formal/IDM_Matrix.v` | `scalar_line_one_dim` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `neg_involution` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `neg_fixed_iff` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `neg_moves_iff` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `readout_of_selfneg_is_neutral` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `minimal_three_values` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `third_value_is_neutral` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `neutral_distinct_from_bottom` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `two_distinct_neutrals` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `bottom_is_least` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `bottom_unique` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `neutral_is_not_below_sign` | Closed |  |
| `formal/IDM_ReadoutMinimality.v` | `neutral_is_not_bottom` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T1_eq_obs_correspondence` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `EqOf_antitone` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `ObsOf_antitone` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T2_closure_extensive` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T2_closure_monotone` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T2_eq_closure_invariant` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T2_closure_idempotent` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T6_question_monotonicity` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T7_joint_question_intersection` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `closure_is_closed` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `closed_intersection` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `closed_join` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `A_con_subseteq_A_sem` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `constructive_closure_invariant` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `future_eq_refl` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `future_eq_sym` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `future_eq_trans` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T3_future_equivalence_dynamic_stability` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T4_dynamic_weld_well_defined` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `step_class_is_class` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T4b_quotient_commuting_square` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `future_eq_immediate` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `future_eq_implies_depth` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `depth_immediate` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `depth_stable_successor_closed` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `depth_stable_implies_future` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `stable_depth_exact_future` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `T5_sufficiency_kernel_inclusion` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `blocks_growth_under_no_closure` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `closed_or_none_upto` | Closed |  |
| `formal/IDM_ReaderDomainFoundation.v` | `finite_strict_refinement_terminates` | Closed |  |
| `formal/IDM_Reduction.v` | `op_swap` | Closed |  |
| `formal/IDM_Reduction.v` | `fold_right_perm` | Closed |  |
| `formal/IDM_Reduction.v` | `ftcc_Z` | Closed |  |
| `formal/IDM_Reduction.v` | `foldmin_le_init` | Closed |  |
| `formal/IDM_Reduction.v` | `foldmin_le_elem` | Closed |  |
| `formal/IDM_Reduction.v` | `sum_is_fold` | Closed |  |
| `formal/IDM_Reduction.v` | `path_is_fold` | Closed |  |
| `formal/IDM_Reduction.v` | `pivot_preserves` | Closed |  |
| `formal/IDM_Reduction.v` | `fold_ext` | Closed |  |
| `formal/IDM_Reduction.v` | `fold_linear` | Closed |  |
| `formal/IDM_Reduction.v` | `fold_add_split` | Closed |  |
| `formal/IDM_Reduction.v` | `foldmax_ge_init` | Closed |  |
| `formal/IDM_Reduction.v` | `foldmax_ge_elem` | Closed |  |
| `formal/IDM_Reduction.v` | `foldmax_in` | Closed |  |
| `formal/IDM_Reduction.v` | `sum_list_perm` | Closed |  |
| `formal/IDM_Reduction.v` | `prod_list_perm` | Closed |  |
| `formal/IDM_Reduction.v` | `dot_is_fold` | Closed |  |
| `formal/IDM_Reduction.v` | `dot_scale` | Closed |  |
| `formal/IDM_Reduction.v` | `horner_scaled` | Closed |  |
| `formal/IDM_Reduction.v` | `horner_is_poly` | Closed |  |
| `formal/IDM_Reduction.v` | `foldmin_in` | Closed |  |
| `formal/IDM_Reduction.v` | `fold_add_app` | Closed |  |
| `formal/IDM_Reduction.v` | `factorial_is_fold` | Closed |  |
| `formal/IDM_Reduction.v` | `relax_nonincreasing` | Closed |  |
| `formal/IDM_Reduction.v` | `relax_idempotent` | Closed |  |
| `formal/IDM_Reduction.v` | `weak_duality_2` | Closed |  |
| `formal/IDM_Reduction.v` | `fold_split_even_odd` | Closed |  |
| `formal/IDM_Reduction.v` | `witness_sound` | Closed |  |
| `formal/IDM_Reduction.v` | `witness_complete` | Closed |  |
| `formal/IDM_Reduction.v` | `decide_dec` | Closed |  |
| `formal/IDM_Reduction.v` | `witness_composite_sound` | Closed |  |
| `formal/IDM_Reduction.v` | `composite_has_factor` | Closed |  |
| `formal/IDM_Reduction.v` | `decide_reflect` | Closed |  |
| `formal/IDM_Reduction.v` | `witness_power_sound` | Closed |  |
| `formal/IDM_Reduction.v` | `witness_qr_sound` | Closed |  |
| `formal/IDM_Reduction.v` | `witness_dlog_sound` | Closed |  |
| `formal/IDM_Reduction.v` | `sat_reduces_to_decision` | Closed |  |
| `formal/IDM_Reduction.v` | `sat_model_sound` | Closed |  |
| `formal/IDM_Reduction.v` | `modpow_is_fold` | Closed |  |
| `formal/IDM_Reduction.v` | `tautology_sound` | Closed |  |
| `formal/IDM_Reduction.v` | `cnf_tautology_sound` | Closed |  |
| `formal/IDM_Reduction.v` | `witness_crt_sound` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `classify_bot_iff` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `bot_needs_positive_resolution` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `classify_zero_iff` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `classify_plus_sound` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `classify_minus_sound` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `classify_not_bot_is_determinate` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `bot_monotone_in_floor` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `count_if_split` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `signedfloor_is_certain_plus_unresolved` | Closed |  |
| `formal/IDM_ResolvedCount.v` | `certain_le_signedfloor` | Closed |  |
| `formal/IDM_Schur.v` | `schur_congruence_00` | Closed |  |
| `formal/IDM_Schur.v` | `schur_congruence_01` | Closed |  |
| `formal/IDM_Schur.v` | `schur_congruence_10` | Closed |  |
| `formal/IDM_Schur.v` | `schur_congruence_11` | Closed |  |
| `formal/IDM_Schur.v` | `diag_inertia_additive` | Closed |  |
| `formal/IDM_Schur.v` | `schur_pivots_are_boundary_and_complement` | Closed |  |
| `formal/IDM_SetsFunctions.v` | `lookup_graph_in` | Closed |  |
| `formal/IDM_SetsFunctions.v` | `graph_total` | Closed |  |
| `formal/IDM_SetsFunctions.v` | `graph_single_valued` | Closed |  |
| `formal/IDM_SetsFunctions.v` | `graph_faithful` | Closed |  |
| `formal/IDM_SetsFunctions.v` | `graph_faithful_converse` | Closed |  |
| `formal/IDM_SetsFunctions.v` | `functional_relation_has_map` | Closed |  |
| `formal/IDM_Tropical.v` | `tmin_assoc` | Closed |  |
| `formal/IDM_Tropical.v` | `tmin_comm` | Closed |  |
| `formal/IDM_Tropical.v` | `tmin_idem` | Closed |  |
| `formal/IDM_Tropical.v` | `tmax_assoc` | Closed |  |
| `formal/IDM_Tropical.v` | `tmax_comm` | Closed |  |
| `formal/IDM_Tropical.v` | `tmax_idem` | Closed |  |
| `formal/IDM_Tropical.v` | `tadd_assoc` | Closed |  |
| `formal/IDM_Tropical.v` | `tadd_comm` | Closed |  |
| `formal/IDM_Tropical.v` | `tadd_0_l` | Closed |  |
| `formal/IDM_Tropical.v` | `minplus_distrib` | Closed |  |
| `formal/IDM_Tropical.v` | `maxplus_distrib` | Closed |  |
| `formal/IDM_Tropical.v` | `bottleneck_distrib` | Closed |  |

## Honesty note

This report classifies a lemma as "Closed" only when `coqc` literally printed the string `Closed under the global context` for that named identifier via a fresh scratch `Print Assumptions` file run on this machine. No lemma is claimed axiom-free on the strength of upstream's README or verify.sh output alone.

