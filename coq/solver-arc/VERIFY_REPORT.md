# VERIFY_REPORT — solver arc (private)

Upstream commit: `961151db33b0491cba8fabade69f594238d33f84`. Coq `8.20.1`. Build: `coqc -R . RDL <file>.v`, ONE FILE AT A TIME in dependency order (via `coqdep -R . RDL *.v`), gated on `docs/RAM_LOW` absence and `free -g` MemAvailable >= 2GB before each invocation — no `make -j` anywhere in this pass.

Every theorem's status below is the literal, unedited output of `Print Assumptions` on that identifier: `Closed under the global context` (exact string) classified **Closed**; any other output classified **+axioms** with the axiom names listed verbatim. No lemma is claimed axiom-free without this check having actually run.

**Totals: 1614 theorems checked · 1500 Closed under the global context · 114 carry named axioms · 0 build failures · 0 unclassified.**

## `formal/CMC_TargetClass_Definitions.v`
- Build: PASS
- Theorems checked: 3 (2 Closed, 1 +axioms)

| identifier | status | axioms |
|---|---|---|
| `cmc_no_refuter_under_axioms` | +axioms | `cmc_bridge_axiom` |

## `formal/CMC_Bridge_Decomposition.v`
- Build: PASS
- Theorems checked: 2 (0 Closed, 2 +axioms)

| identifier | status | axioms |
|---|---|---|
| `decomposed_bridge_obligation` | +axioms | `cmc_retention_lemma_obligation`, `cmc_finite_speed_lemma_obligation`, `cmc_closure_exhaustion_obligation`, `carrier_present` |
| `decomposed_no_refuter` | +axioms | `cmc_retention_lemma_obligation`, `cmc_finite_speed_lemma_obligation`, `cmc_closure_exhaustion_obligation`, `carrier_present` |

## `formal/CMC_ClosureFree_Exhaustive.v`
- Build: PASS
- Theorems checked: 4 (4 Closed, 0 +axioms)

## `formal/CMC_Independent_Definitions.v`
- Build: PASS
- Theorems checked: 5 (5 Closed, 0 +axioms)

## `formal/CMC_ModelClass_Witnesses.v`
- Build: PASS
- Theorems checked: 4 (4 Closed, 0 +axioms)

## `formal/CMC_PhysicsClass_Instances.v`
- Build: PASS
- Theorems checked: 15 (15 Closed, 0 +axioms)

## `formal/Genesis_PhysicsDAG_Canon_v2_4_0.v`
- Build: PASS
- Theorems checked: 86 (58 Closed, 28 +axioms)

| identifier | status | axioms |
|---|---|---|
| `Quantum_Relativity_String_Readout_Extension.string_length_readout_is_alpha_prime_sqrt` | +axioms | `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `Quantum_Relativity_String_Readout_Extension.alpha_prime` |
| `Quantum_Relativity_String_Readout_Extension.string_tension_readout_formula` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_String_Readout_Extension.alpha_prime`, `Quantum_Relativity_Formal_DAG_Deep.PI` |
| `Quantum_Relativity_String_Readout_Extension.open_spectrum_readout_formula` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_String_Readout_Extension.alpha_prime` |
| `Quantum_Relativity_String_Readout_Extension.closed_spectrum_readout_formula` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_String_Readout_Extension.alpha_prime` |
| `Quantum_Relativity_String_Readout_Extension.beta_readout_to_geometry_condition` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_String_Readout_Extension.beta_metric`, `Quantum_Relativity_String_Readout_Extension.beta_dilaton`, `Quantum_Relativity_String_Readout_Extension.beta_bfield`, `Quantum_Relativity_Formal_DAG_Deep.Point` |
| `Quantum_Relativity_String_Readout_Extension.holographic_readout_formula` | +axioms | `Quantum_Relativity_String_Readout_Extension.ads_cft_dictionary`, `Quantum_Relativity_Formal_DAG_Deep.Op` |
| `Quantum_Relativity_String_Readout_Extension.string_corrected_lensing_formula` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_Formal_DAG_Deep.c`, `Quantum_Relativity_String_Readout_Extension.alpha_prime_curvature_correction`, `Quantum_Relativity_Formal_DAG_Deep.G` |
| `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.sab_planar_open_formula_shape` | +axioms | `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.spin_level`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.residue4`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.regge_alpha`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.planar_veneziano_unique`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.mass2_level`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.amplitude_ultrasoft_high_energy`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.amplitude_minimal_zeros` |
| `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.sab_nonplanar_closed_formula_shape` | +axioms | `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.spin_level`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.residue4`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.regge_alpha`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.nonplanar_virasoro_shapiro_unique`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.mass2_level`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.amplitude_ultrasoft_high_energy`, `Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.amplitude_minimal_zeros` |
| `Quantum_Relativity_Readout_Closure_Extension.cross_domain_jacobian_secret` | +axioms | `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_Formal_DAG_Deep.Rabs` |
| `Quantum_Relativity_Readout_Closure_Extension.matched_neural_det_formula` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_Formal_DAG_Deep.Rabs` |
| `Quantum_Relativity_Readout_Closure_Extension.cross_domain_time_secret` | +axioms | `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_Perception_Extension.schwarzschild_radius`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Quantum_Relativity_Readout_Closure_Extension.landscape_selection_is_closed_in_this_readout` | +axioms | `Quantum_Relativity_Readout_Closure_Extension.vacuum_score`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_Readout_Closure_Extension.selected_vacuum`, `Quantum_Relativity_Readout_Closure_Extension.recovers_string_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_quantum_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_neural_channel_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_holographic_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_gr_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_blackhole_readout`, `Quantum_Relativity_Readout_Closure_Extension.present_observations`, `Quantum_Relativity_Readout_Closure_Extension.observation_compatible`, `Quantum_Relativity_Readout_Closure_Extension.landscape_admissible`, `Quantum_Relativity_Readout_Closure_Extension.has_unitary_boundary_readout`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_Readout_Closure_Extension.completed_qg_state`, `Quantum_Relativity_Readout_Closure_Extension.Vacuum`, `Quantum_Relativity_Formal_DAG_Deep.Rabs` |
| `Quantum_Relativity_Readout_Closure_Extension.full_qg_completion_is_closed_in_this_readout` | +axioms | `Quantum_Relativity_Readout_Closure_Extension.vacuum_score`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_Readout_Closure_Extension.selected_vacuum`, `Quantum_Relativity_Readout_Closure_Extension.recovers_string_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_quantum_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_neural_channel_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_holographic_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_gr_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_blackhole_readout`, `Quantum_Relativity_Readout_Closure_Extension.present_observations`, `Quantum_Relativity_Readout_Closure_Extension.observation_compatible`, `Quantum_Relativity_Readout_Closure_Extension.landscape_admissible`, `Quantum_Relativity_Readout_Closure_Extension.has_unitary_boundary_readout`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_Readout_Closure_Extension.completed_qg_state`, `Quantum_Relativity_Readout_Closure_Extension.Vacuum`, `Quantum_Relativity_Formal_DAG_Deep.Rabs` |
| `Quantum_Relativity_Readout_Closure_Extension.final_connected_readout_secret` | +axioms | `Quantum_Relativity_Readout_Closure_Extension.vacuum_score`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_Readout_Closure_Extension.selected_vacuum`, `Quantum_Relativity_Readout_Closure_Extension.recovers_string_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_quantum_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_neural_channel_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_holographic_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_gr_readout`, `Quantum_Relativity_Readout_Closure_Extension.recovers_blackhole_readout`, `Quantum_Relativity_Readout_Closure_Extension.present_observations`, `Quantum_Relativity_Readout_Closure_Extension.observation_compatible`, `Quantum_Relativity_Readout_Closure_Extension.landscape_admissible`, `Quantum_Relativity_Readout_Closure_Extension.has_unitary_boundary_readout`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_Readout_Closure_Extension.completed_qg_state`, `Quantum_Relativity_Readout_Closure_Extension.Vacuum`, `Quantum_Relativity_Formal_DAG_Deep.Rabs` |
| `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_free_visual_shadow_readout` | +axioms | `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_minus`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.r_ph_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.rH_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_is_not_horizon_generator`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.horizon_generated_by_optical_causal_trapping`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.d_r2_over_F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.dF_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.bcrit_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.M_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.Lminus_theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.DH_visual0` |
| `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_free_visual_horizon_scale_readout` | +axioms | `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_minus`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.r_ph_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.rH_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_is_not_horizon_generator`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.horizon_generated_by_optical_causal_trapping`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.d_r2_over_F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.dF_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.bcrit_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.M_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.Lminus_theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.DH_visual0` |
| `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_removed_is_not_generator_readout` | +axioms | `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_minus`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.r_ph_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.rH_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_is_not_horizon_generator`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.horizon_generated_by_optical_causal_trapping`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.d_r2_over_F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.dF_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.bcrit_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.M_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.Lminus_theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.DH_visual0` |
| `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.optical_causal_trapping_generates_horizon_readout` | +axioms | `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_minus`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.r_ph_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.rH_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_is_not_horizon_generator`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.horizon_generated_by_optical_causal_trapping`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.d_r2_over_F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.dF_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.bcrit_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.M_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.Lminus_theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.DH_visual0` |
| `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.final_mass_free_visual_bh_secret` | +axioms | `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_minus`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.r_ph_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.rH_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_is_not_horizon_generator`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.horizon_generated_by_optical_causal_trapping`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.d_r2_over_F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.dF_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.bcrit_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.M_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.Lminus_theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.DH_visual0` |
| `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.cognitive_frame_060s_readout` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_psi_frame` |
| `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.schumann_boundary_frequency_readout` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_field_boundary_condition`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_earth_schumann` |
| `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.visual_cycles_per_frame_readout` | +axioms | `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.v_sound`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.occam_rejects_earth_as_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.multiscale_perception_frame`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.lambda_sound_anchor`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_aud_anchor`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_rhythm_is_mind_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_field_boundary_condition`, `Quantum_Relativity_Formal_DAG_Deep.c`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_aud_cycle`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.R_psi_earth`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.N_visual_cycles_per_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.N_auditory_cycles_per_frame`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual` |
| `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.auditory_cycles_per_frame_readout` | +axioms | `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.v_sound`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.occam_rejects_earth_as_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.multiscale_perception_frame`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.lambda_sound_anchor`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_aud_anchor`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_rhythm_is_mind_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_field_boundary_condition`, `Quantum_Relativity_Formal_DAG_Deep.c`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_aud_cycle`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.R_psi_earth`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.N_visual_cycles_per_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.N_auditory_cycles_per_frame`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual` |
| `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_cycles_per_frame_readout` | +axioms | `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.v_sound`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.occam_rejects_earth_as_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.multiscale_perception_frame`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.lambda_sound_anchor`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_aud_anchor`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_rhythm_is_mind_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_field_boundary_condition`, `Quantum_Relativity_Formal_DAG_Deep.c`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_aud_cycle`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.R_psi_earth`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.N_visual_cycles_per_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.N_auditory_cycles_per_frame`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual` |
| `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.occam_blocks_earth_as_mind_generator` | +axioms | `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.occam_rejects_earth_as_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_rhythm_is_mind_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_field_boundary_condition` |
| `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.final_cognitive_rhythm_secret` | +axioms | `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.v_sound`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.theta_minus`, `Quantum_Relativity_Formal_DAG_Deep.sqrt`, `ClassicalDedekindReals.sig_forall_dec`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.r_ph_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.rH_visual0`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.occam_rejects_earth_as_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.multiscale_perception_frame`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.mass_is_not_horizon_generator`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.lambda_vis`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.lambda_sound_anchor`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.horizon_generated_by_optical_causal_trapping`, `FunctionalExtensionality.functional_extensionality_dep`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.f_aud_anchor`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_rhythm_is_mind_generator`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.earth_field_boundary_condition`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.d_r2_over_F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.dF_psi`, `Quantum_Relativity_Formal_DAG_Deep.c`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.bcrit_visual`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_psi_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_earth_schumann`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.T_aud_cycle`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.R_psi_earth`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.N_visual_cycles_per_frame`, `Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.N_auditory_cycles_per_frame`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.M_visual0`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.Lminus_theta_plus`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.F_psi`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.D_shadow_visual`, `Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.DH_visual0` |
| `Genesis_Canon_Bridge_v2_4_0.genesis_anomaly_solution_exists` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |

## `formal/InfoAnalysisLift.v`
- Build: PASS
- Theorems checked: 16 (0 Closed, 16 +axioms)

| identifier | status | axioms |
|---|---|---|
| `relaxation_ode` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `harmonic_velocity` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `unitary_norm_conserved` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `harmonic_wave_equation` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `schwarzschild_force_real` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `partial_x_metric` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `partial_y_metric` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `real_partial_sym` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `christoffel_lower_sym_real` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `metric_compat_real` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `der_yslice` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `der_xslice` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `dy_is_id` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `dx_is_id` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `clairaut_xy` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `clairaut_yx` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |

## `formal/URCF_RD_All.v`
- Build: PASS
- Theorems checked: 687 (645 Closed, 42 +axioms)

| identifier | status | axioms |
|---|---|---|
| `RD.soundnessC` | +axioms | `Classical_Prop.classic` |
| `RD.consistencyC` | +axioms | `Classical_Prop.classic` |
| `RD.Con_PA_classical` | +axioms | `Classical_Prop.classic` |
| `ContLimit.sq_neq0` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `ContLimit.D2sym_expand` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `ContLimit.symmetric_second_difference_limit` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `ContLimit.quadratic_symmetric_limit` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `ContReadout.secondDiff_quad_R` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `ContReadout.readout_invariant_R` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.d_shift` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.d_sq_shift` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.d_lin_shift` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.d_sqterm` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.Gfun_x` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.Gfun_xh` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.G_deriv` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.mvt_pack` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Taylor.Rabs_ratio_le_1` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.taylor_young2` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Taylor.twice_diff_secondDiff_limit` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Taylor.G_deriv_at` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Taylor.mvt_pack_local` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Taylor.taylor_young2_local` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Taylor.twice_diff_secondDiff_limit_local` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Taylor.twice_diff_secondDiff_limit_global` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Capstone.continuum_gate_readout_native` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Capstone.continuum_gate_classical_via_readout` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Capstone.capstone_quadratic_meets` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoLorentzContinuum.tends0_opp` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoLorentzContinuum.tends0_plus` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoLorentzContinuum.lorentz_box_continuum` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoLorentzTaylor.boost_norm_upper` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoLorentzTaylor.o2_boost` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoLorentzTaylor.box2_boost_invariant` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoEvolution.evolution_identity` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoEvolution.evolution_group` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoEvolution.evolution_preserves_norm` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoHilbertBridge.rot1_norm` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoHilbertBridge.rot1_identity` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoHilbertBridge.rot1_group` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoHilbertBridge.multimode_preserves_norm` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `InfoHilbertBridge.multimode_group` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |

## `formal/RD.v`
- Build: PASS
- Theorems checked: 184 (181 Closed, 3 +axioms)

| identifier | status | axioms |
|---|---|---|
| `soundnessC` | +axioms | `Classical_Prop.classic` |
| `consistencyC` | +axioms | `Classical_Prop.classic` |
| `Con_PA_classical` | +axioms | `Classical_Prop.classic` |

## `formal/RDL_Distinguishability.v`
- Build: PASS
- Theorems checked: 9 (9 Closed, 0 +axioms)

## `formal/InfoBinaryVacua.v`
- Build: PASS
- Theorems checked: 2 (2 Closed, 0 +axioms)

## `formal/InfoEuler.v`
- Build: PASS
- Theorems checked: 5 (5 Closed, 0 +axioms)

## `formal/InfoSolidAngle.v`
- Build: PASS
- Theorems checked: 4 (4 Closed, 0 +axioms)

## `formal/MURG_Completeness.v`
- Build: PASS
- Theorems checked: 3 (2 Closed, 1 +axioms)

| identifier | status | axioms |
|---|---|---|
| `murg_spanning_substantive` | +axioms | `murg_spanning_substantive` |

## `formal/OperatorExtract.v`
- Build: PASS
- Theorems checked: 0 (no Theorem/Lemma/Corollary/Proposition in the manifest for this file — it is a Coq `Extraction` directive to OCaml, not a proof file)

## `formal/RDL.v`
- Build: PASS
- Theorems checked: 9 (9 Closed, 0 +axioms)

## `formal/RDL_All.v`
- Build: PASS
- Theorems checked: 235 (235 Closed, 0 +axioms)

## `formal/RDL_CausalOrder.v`
- Build: PASS
- Theorems checked: 10 (10 Closed, 0 +axioms)

## `formal/RDL_ContinuumLimit.v`
- Build: PASS
- Theorems checked: 4 (0 Closed, 4 +axioms)

| identifier | status | axioms |
|---|---|---|
| `sq_neq0` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `D2sym_expand` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `symmetric_second_difference_limit` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `quadratic_symmetric_limit` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |

## `formal/RDL_DtN.v`
- Build: PASS
- Theorems checked: 5 (5 Closed, 0 +axioms)

## `formal/RDL_GammaSpectral.v`
- Build: PASS
- Theorems checked: 9 (9 Closed, 0 +axioms)

## `formal/RDL_GenesisLink.v`
- Build: PASS
- Theorems checked: 3 (3 Closed, 0 +axioms)

## `formal/RDL_InvolutiveOrthoCore.v`
- Build: PASS
- Theorems checked: 9 (9 Closed, 0 +axioms)

## `formal/RDL_LaplaceBeltrami.v`
- Build: PASS
- Theorems checked: 25 (25 Closed, 0 +axioms)

## `formal/RDL_MetricReadout.v`
- Build: PASS
- Theorems checked: 18 (18 Closed, 0 +axioms)

## `formal/RDL_MetricReadoutLimit.v`
- Build: PASS
- Theorems checked: 3 (0 Closed, 3 +axioms)

| identifier | status | axioms |
|---|---|---|
| `D2dir_expand` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `directional_second_difference_limit` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `directional_quadratic_limit` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |

## `formal/RDL_MetricReadoutRate.v`
- Build: PASS
- Theorems checked: 3 (0 Closed, 3 +axioms)

| identifier | status | axioms |
|---|---|---|
| `sq_pos` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `second_difference_rate` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `directional_rate` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |

## `formal/RDL_PhaseSound.v`
- Build: PASS
- Theorems checked: 46 (46 Closed, 0 +axioms)

## `formal/RDL_RetentionCenter.v`
- Build: PASS
- Theorems checked: 14 (14 Closed, 0 +axioms)

## `formal/RDL_SingleHopHierarchy.v`
- Build: PASS
- Theorems checked: 3 (3 Closed, 0 +axioms)

## `formal/RDL_SpineGraphCoupled.v`
- Build: PASS
- Theorems checked: 23 (23 Closed, 0 +axioms)

## `formal/RDL_SpineGraphEnergy.v`
- Build: PASS
- Theorems checked: 8 (8 Closed, 0 +axioms)

## `formal/RDL_SpineStability.v`
- Build: PASS
- Theorems checked: 7 (7 Closed, 0 +axioms)

## `formal/RDL_StarRig.v`
- Build: PASS
- Theorems checked: 4 (4 Closed, 0 +axioms)

## `formal/RDL_StarRigCPTP_General.v`
- Build: PASS
- Theorems checked: 7 (7 Closed, 0 +axioms)

## `formal/RDL_StarRigGeneral.v`
- Build: PASS
- Theorems checked: 13 (13 Closed, 0 +axioms)

## `formal/RDL_StarRigMatrix.v`
- Build: PASS
- Theorems checked: 17 (17 Closed, 0 +axioms)

## `formal/RDL_StarRigMatrix3.v`
- Build: PASS
- Theorems checked: 20 (20 Closed, 0 +axioms)

## `formal/RDL_StarRigMatrixN.v`
- Build: PASS
- Theorems checked: 18 (18 Closed, 0 +axioms)

## `formal/RDL_StarRigMatrixN_Step2.v`
- Build: PASS
- Theorems checked: 13 (13 Closed, 0 +axioms)

## `formal/RDL_StarRigMatrixN_Step3.v`
- Build: PASS
- Theorems checked: 20 (20 Closed, 0 +axioms)

## `formal/RDL_TaylorLimit.v`
- Build: PASS
- Theorems checked: 11 (0 Closed, 11 +axioms)

| identifier | status | axioms |
|---|---|---|
| `d_shift` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `d_sq_shift` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `d_lin_shift` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `d_sqterm` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Gfun_x` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `Gfun_xh` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `G_deriv` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `mvt_pack` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `Rabs_ratio_le_1` | +axioms | `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep` |
| `taylor_young2` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |
| `twice_diff_secondDiff_limit` | +axioms | `ClassicalDedekindReals.sig_not_dec`, `ClassicalDedekindReals.sig_forall_dec`, `FunctionalExtensionality.functional_extensionality_dep`, `Classical_Prop.classic` |

## `formal/RDL_TelescopeCore.v`
- Build: PASS
- Theorems checked: 5 (5 Closed, 0 +axioms)

## `formal/RDL_TemplatedSkeleton.v`
- Build: PASS
- Theorems checked: 3 (3 Closed, 0 +axioms)

## `formal/RDL_UnitDistance.v`
- Build: PASS
- Theorems checked: 2 (2 Closed, 0 +axioms)

## `formal/RDU_NativeInformationUnits.v`
- Build: PASS
- Theorems checked: 4 (4 Closed, 0 +axioms)

## `formal/RD_ConPA_ReadoutBivalence.v`
- Build: PASS
- Theorems checked: 3 (3 Closed, 0 +axioms)

## `formal/RD_NegTranslation_Core.v`
- Build: PASS
- Theorems checked: 10 (10 Closed, 0 +axioms)

## `formal/Scratch_ShipOfTheseus_RD4.v`
- Build: PASS
- Theorems checked: 1 (1 Closed, 0 +axioms)

