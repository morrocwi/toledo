# Equation Library — Human–AI Readout Programme

Generated 2026-09-07 by `registry/build_eq_library.py`. One file for the state of every equation: raw inventory per chapter → canonical id (Genesis-first: one root equation read per domain; latest formulation wins; occurrences mapped, sources never edited) → Coq identifier and tier.

## Status
- Chapters inventoried: 40
- Raw equations: 946
- Canonical objects: 990
- Raw→canonical mapped: 1069
- Coq identifiers (canonical set): 913
- Master River v1.4 (22519148) equations 1–79: Coq set 22518450, 45 lemmas closed (coq/MR_Ledger.md)
- Founder rulings: BBL-165 (Th_coqc for every equation), 170 (all chapters, one file), 171 (canonicalise first), 172 (latest formulation), 173 (map only), 174 (one master equation along the line), 175/176 (Readout Genesis first: same equation read per domain), 177 (collapse until one reader reads the whole line)

## Canonical objects (Genesis-first order; codes per EQ_CODE_SCHEME.md)

| Code | CAN | Root object | Domain | Canonical statement | Tier | Coq | #occ |
|---|---|---|---|---|---|---|---|
| weld/M.01.v1 | CAN-001 | weld | M | δ_R = (a ♯ b) ⊢[Th_coqc] L_R = D_W − W ⊢[Dr] F (MQ.08 stepper); concretely S_{n+1}=F(S_n,u_n,c_n,T_n); indepen | Th_coqc | closed CAN_001_degree, CAN_001_laplacian, CAN_001_sum_neg_distributes, CAN_001_laplacian_row_sums_to_neg_degre | 7 |
| EQ-015/M.01.v1 | CAN-002 | EQ-015 | M | S_n = (G_n, Λ_n, T_n) | Definition | closed RootState, CAN_002_root_state_tuple_faithful | 3 |
| EQ-015/M.02.v1 | CAN-003 | EQ-015 | M | S_{n+1} = F(S_n, u_n, c_n, T_n) | Definition | closed CAN_003_trajectory, CAN_003_stepper_can_move_state, CAN_003_trajectory_zero | 3 |
| EQ-015/M.03.v1 | CAN-004 | EQ-015 | M | retention → structure → translation → readout → meaning → experience → memory → belief → claim → checking → st | Dr | closed CAN_004_Stage, CAN_004_index, CAN_004_forbidden_order, CAN_004_index_injective, CAN_004_checking_before | 1 |
| EQ-015/M.04.v1 | CAN-005 | EQ-015 | M | Retention→Structure→Translation→Readout→Meaning→Report (compressed); Retention→Structure→Candidate State→Suffi | Definition | definition CAN_005_readout_admission_order, CAN_005_readout_admission_order_stage | 4 |
| weld/M.02.v1 | CAN-006 | weld | M | q_{D,n+1}∘F_n = F#_{D,n}∘q_{D,n}; O_{D,n} = O#_{D,n}∘q_{D,n}; equivalently q_D(F(z,u,c,T)) = F_D(q_D(z),u,c,T) | Definition | closed CAN_006_domain_admissible, CAN_006_domain_weld_satisfiable_on_pair_projection, DomainReading, weld_hold | 7 |
| weld/M.03.v1 | CAN-007 | weld | M | z ~_{Q,O,c,L} z' ⟺ O(F^k z) = O(F^k z') for all k ≤ L | Definition | closed CAN_007_reader_equiv, CAN_007_reader_equiv_is_equivalence | 3 |
| A.5/M.01.v1 | CAN-008 | A.5 | M | S_n ≠ Z_{D,n} ≠ D_{D,n} (D=HCA or MEMK) | Definition | closed CAN_008_noncollapse, CAN_008_root_candidate_quotient_are_three_things | 2 |
| A.8/M.01.v1 | CAN-009 | A.8 | M | ΔA_past = 0 | Dr | closed CAN_009_extends, CAN_009_extension_preserves_past, CAN_009_witness_append_preserves_first_event | 2 |
| EQ-002/E.01.v1 | CAN-010 | EQ-002 | E | r_n = R_H(x_n \| H_n, c_n); extended with an explicit question index in Before Meaning, Before Choice: ρ^H_n =  | Definition | definition CAN010_human_readout, CAN010_H2_reader_dependence_Open | 4 |
| EQ-002/E.02.v1 | CAN-011 | EQ-002 | E | R_A = O_A(W; Π_A) (≠ W);  m(A) ≠ ρ(A) | Definition | closed CAN011_R_A, CAN011_readout_not_world_witness, CAN011_Notion, CAN011_code, CAN011_non_collapse | 3 |
| EQ-002/E.03.v1 | CAN-012 | EQ-002 | E | M_A(E) = (T_A ∘ Π_A)(S_A(E)) | Definition | definition CAN012_M_A | 2 |
| EQ-015/E.01.v1 | CAN-013 | EQ-015 | E | μ_n = Ψ_H(r_n, H_n, c_n, Q_n); typed as μ_n=(μ_n^aff, μ_n^prag, μ_n^auto, μ_n^conc, μ_n^epi) | Definition | definition CAN013_meaning_giving | 4 |
| EQ-015/E.02.v1 | CAN-014 | EQ-015 | E | ξ_n=(ξ_n^+,ξ_n^-,ξ_n^0); Ξ_n=α_n^+P_n^++α_n^-P_n^-+α_n^0P_n^0; G~_{μ,n}=G_{μ,n}∘(I+Ξ_n); ε_{Ξ,n}=d_O(G_{μ,n}(z | Definition | closed CAN014_distort, CAN014_distortion_can_change_meaning, CAN014_distortion_preserves_epistemic_mode | 3 |
| EQ-015/E.03.v1 | CAN-015 | EQ-015 | E | μ_n = Ψ_H(r_n, H_n, c_n, Q_n) | Definition | definition CAN015_meaning | 3 |
| EQ-002/E.04.v1 | CAN-016 | EQ-002 | E | μ_n=(μ_n^aff, μ_n^prag, μ_n^auto, μ_n^conc, μ_n^epi) | Definition | definition CAN016_MeaningModes, CAN016_decomposition_faithful | 1 |
| EQ-015/E.04.v1 | CAN-017 | EQ-015 | E | E_n = Φ_E(x_n, μ_n, γ^μ_n, c_n); central identity: Experience = phenomenon-as-meaningfully-read | Definition | closed CAN017_experience_joint_witness, CAN017_experience_joint_witness_on_bool | 11 |
| EQ-015/E.05.v1 | CAN-019 | EQ-015 | E | ℓ_n = L_H(E_n, μ_n \| H_n, c_n), with E_n,μ_n permitted before stable ℓ_n; recursive form: μ_n → E_n → ℓ_n → μ_ | Definition | definition CAN019_naming_operator | 6 |
| EQ-002/E.05.v1 | CAN-020 | EQ-002 | E | ℓ_n=L_H(E_n,μ_n\|H_n,c_n); μ_n→E_n→ℓ_n→μ_{n+1}→E_{n+1} | Definition | definition CAN020_NamingChainStep, CAN020_naming_chain | 2 |
| EQ-015/E.06.v1 | CAN-021 | EQ-015 | E | I_{H,n}=Retrieve(M_{H,n}\|c_n,Q_n); Res_H(n)=C_H(E_n^cur,I_{H,n}\|c_n,Q_n) ∈[0,1]; Res≠Identity, Res≠Truth, Res≠ | Dr | definition CAN021_ResonanceNotion, CAN021_resonance_non_collapse | 5 |
| EQ-015/E.07.v1 | CAN-022 | EQ-015 | E | ΔW_{j,N}=Σ_{n=1}^N η_n·eligibleGradient_n; W_n^eff=W_{info,n}·g(Res_H(n),eligibility,context); Σ_{k≤n}W_k^eff  | Definition | definition CAN022_accum_work, CAN022_threshold_crossed, CAN022_Open_transition | 4 |
| EQ-015/E.08.v1 | CAN-023 | EQ-015 | E | H_{n+1} = U_H(H_n, Retain(E_n, μ_n, r_n), δ^world_{n:n+1}) — restated with an added other-experience term in l | Definition | definition CAN023_retention_can_change_reader | 14 |
| EQ-002/E.06.v1 | CAN-024 | EQ-002 | E | m_{t+1}(e)=ρm_t(e)+1[e_t=e]; a_{Q,t}(e)=[Φ_{Q,t}(s)-Φ_{Q,t}(s')]_+; κ^sem_{t+1}(e\|Q)∝κ^sem,(0)_t(e\|Q)·exp(βa+μ | Definition | definition CAN024_momentum, CAN024_Open_momentum_eases_reentry, CAN024_accessibility_score, CAN024_Open_access | 3 |
| weld/E.01.v1 | CAN-025 | weld | E | Know_A(W) = 1 iff Dist(R_A[n], R_A^ν[n]) ≤ ε_K for all admissible variations ν on window W. Independently echo | Definition | definition CAN025_stable_under, CAN025_stable_under_dec | 2 |
| EQ-002/E.07.v1 | CAN-026 | EQ-002 | E | ε_tot > 0 (Genesis Constraint-First); decomposed independently as ε_tot = ε_clock + ε_cross + ε_sel + ε_map +  | Ax | closed CAN026_eps_tot, CAN026_decomposition_identity, CAN026_fallibilism_Open | 2 |
| EQ-015/E.09.v1 | CAN-027 | EQ-015 | E | V_A[n] = Align(M_A[n], θ_W \| D); E[V_A[n+1] \| Rsn_A, D] > E[V_A[n] \| D] | Definition | definition CAN027_V_A, CAN027_expected_improvement_Open | 2 |
| EQ-015/E.10.v1 | CAN-028 | EQ-015 | E | When external generation of coherent structure increases without bound, observable production ceases to serve  | Dr | definition CAN028_Regime, CAN028_regime_transition_Open | 2 |
| weld/E.02.v1 | CAN-029 | weld | E | SC: K(S,p)→Subject(S); the collapse the paper rejects, HSC: Epi(X,p)→Knower(X,p); Possession-Constitution Coll | Definition | closed CAN029_possession_constitution_non_collapse | 6 |
| EQ-015/E.11.v1 | CAN-030 | EQ-015 | E | K_A(D,t):=V_A^D(M_A(t),θ_D); V_A^D=w1P+w2I+w3S+w4R+w5L, Σw_i^D=1 | Definition | definition CAN030_Profile, CAN030_weights_normalized, CAN030_V_A_D | 2 |
| weld/E.03.v1 | CAN-031 | weld | E | σ_K(p)=Admit_E(p\|Agent,D,C,O,Access,Language,Tools,Rights,Prov,Ev,Method,Infer,Assumptions,Uncertainty,Scope,O | Definition | definition CAN031_Status, CAN031_status_eq_dec, CAN031_Admission | 20 |
| weld/E.04.v1 | CAN-032 | weld | E | Π_prac(p)=TestPerformance(Y,Ŷ,intervention,C,O); σ_K(p) ≠ Π_prac(p) | Definition | closed CAN032_Notion, CAN032_code, CAN032_non_collapse, CAN032_status_and_performance_can_diverge | 1 |
| weld/E.05.v1 | CAN-033 | weld | E | χ_G ∈ {1,0,⊥}, 1=ADMITTED, 0=OBSTRUCTED, ⊥=UNRESOLVED (thirteen admission gates G0–G13); independently, χ_t(d) | Definition | definition CAN033_GateOutcome, CAN033_Provenance, CAN033_gate_eq_dec, CAN033_prov_eq_dec, CAN033_Ledger | 3 |
| weld/E.06.v1 | CAN-034 | weld | E | Suff_{E,L}(Z_E^cand; Q,O,c,T) ∈ {1,0,⊥}; Inv_E(z)≠Inv_E(z') ⟹ q_E(z)≠q_E(z') | Definition | closed CAN034_Sufficiency, CAN034_invariant_preserving, CAN034_invariant_functional_implies_preserving | 2 |
| weld/E.07.v1 | CAN-035 | weld | E | τ_public(p) ≤ inf_{g∈G_p} τ(g) (Weakest-link claim ceiling, proved) | Dr | closed CAN035_claim_ceiling, CAN035_claim_ceiling_bound | 2 |
| weld/E.08.v1 | CAN-036 | weld | E | K_local=K\|_{Ω_local}; T^Y_{ij}∘K_i ≅ K_j∘T^C_{ij}, ε_bridge=d(T^Y_{ij}∘K_i, K_j∘T^C_{ij}); Ω(K)={(g,d,l,P,O,c) | Definition | closed CAN036_bridge_error, CAN036_transports_within, CAN036_identity_transport_zero_error | 5 |
| A.5/E.01.v1 | CAN-037 | A.5 | E | A_n ≠ r_n ≠ x_n; root retention ≠\|= belief state ≠\|= meaning ≠\|= experience ≠\|= choice | Definition | closed CAN037_Notion, CAN037_code, CAN037_non_collapse | 2 |
| A.5/E.02.v1 | CAN-039 | A.5 | E | P^H_t → Q_{H,t} —Decompose_AI→ Q^{AI}_{t+1} —T_AI→ H~_{t+1} —/~_{D,t}→ H^{disc}_{t+1} —Gate→ U_{t+1} —Spawn→ F | Definition | closed CAN039_CandidateSet, CAN039_comparable, CAN039_not_in_implies_not_comparable, CAN039_Notion, CAN039_cod | 19 |
| EQ-002/E.08.v1 | CAN-040 | EQ-002 | E | k_epi(t) = \|New_{t+1}\| / max(1, \|F_t\|); k_epi<1 contractive, k_epi≈1 critical, k_epi>1 expanding | Definition | closed CAN040_Regime, CAN040_k_epi, CAN040_classify, CAN040_classify_contractive_correct | 4 |
| EQ-015/H.01.v1 | CAN-041 | EQ-015 | H | H_t →^{L_H} Q_t; Q_t→AI_t→Y_t →^{R_H} E^{AI}_{H,t}; H_{t+1}=U_H(H_t,E^{AI}_{H,t},δ^world,X^other) | Definition | definition CAN_041_pre_prompt_human_state_transport | 4 |
| A.5/H.01.v1 | CAN-042 | A.5 | H | H_t --L_H--> Q_t, Q_t ≠ H_t (Pre-Prompt Human State Principle); session-indexed restatement H_{s,0}--L_H-->Q_{ | Definition | closed CAN_042_bounded_transport, CAN_042_bounded_transport_satisfiable_on_nat | 5 |
| EQ-015/H.02.v1 | CAN-043 | EQ-015 | H | A0 = ⟨P0, M0, U0, E0, F0, S0⟩ (latest, DCP eq.12); supersedes H0*=(P0,M0,U0,E0,Φ0,κ0) and ENTRY_{H→AI}=H0*∧V0∧ | Definition | definition EntryStateAnchor, CAN_043_entry_state_anchor, CAN_043_mk_entry_state_anchor | 5 |
| A.5/H.02.v1 | CAN-044 | A.5 | H | P^live_{H,t} defined; TopicEntry∈{LiveProblem,OpenExploration,RoutineDelegation}; Problem-First⇒{Agenda Owners | Definition | definition CAN_044_TopicEntry, CAN_044_Legitimate, CAN_044_Open_ProblemFirst_implication, CAN_044_ProblemOnlyP | 6 |
| EQ-015/H.03.v1 | CAN-045 | EQ-015 | H | H_t —L_H→ Q_t; Q_t→AI_t→Y_t —R_H→ E^{AI}_{H,t}; H_{t+1}=U_H(H_t, E^{AI}_{H,t}, δ^{world}, X^{other}); L_{A,t+1 | Definition | definition CAN_045_prompt_coupling_and_update, CAN_045_live_weight_may_change_witness | 4 |
| EQ-015/H.04.v1 | CAN-046 | EQ-015 | H | Q_t→AI_t→Y_t --R_H--> E^AI_{H,t}; H_{t+1}=U_H(H_t,E^AI_{H,t},δ^world,X^other) | Definition | definition CAN_046_ai_response_chain | 5 |
| EQ-015/H.05.v1 | CAN-047 | EQ-015 | H | Z_dlg[s,n+1]=F#_dlg(Z_dlg[s,n],u_H[s,n],u_AI[s,n],c[s,n],T[s,n]); χ_recip[s,n,L]=\|D_recip[s,n,L]\|/\|Σ[s,n]\| | Definition | definition CAN_047_dialogue_session_stepper, CAN_047_chi_recip, CAN_047_chi_recip_bounds_witness | 6 |
| EQ-002/H.01.v1 | CAN-048 | EQ-002 | H | B[n]→H_body[n]→N[n]→S[n]↔A[n]→π[n]→U[n]→B[n+1], with each arrow a discrete update Φ_*; independently parallele | Definition | definition CAN_048_agency_conditional_chain | 13 |
| EQ-002/H.02.v1 | CAN-049 | EQ-002 | H | A_{i,n}=q_A(Z_{i,n};Q_A,O_A,c_n); Aut(F_A,O_A)={h: O_A∘h=O_A, h∘F_A=F_A∘h}; I_n=q_comp(M_n⊕Bel_n⊕Θ_n⊕Roles_n⊕B | Definition | definition CAN_049_agency_readout, CAN_049_is_automorphism, CAN_049_Aut | 3 |
| weld/H.01.v1 | CAN-050 | weld | H | S_A[n]=q_self(F^n[δ_R,T_A,c_{0:n}])=⟨A_A[n],Δ_A[n],H_A[n],Phen_A^str[n],P_A^lived[n],Own_A[n],Coh_A[n],Val_A[n | Definition | definition SelfState, CAN_050_self_readout, CAN_050_mk_self_readout | 2 |
| weld/H.02.v1 | CAN-051 | weld | H | H_dyn: Δ_A(λ)=D_A²−4M_AK_Aλ=0; H_info(A)={z∈Z_A: Rec(z)⇒(E_b<∞,R_p>0)}; H_phen(A)={r=A_A^acc Π_A T_A(δ_R): Phe | Definition | definition CAN_051_horizon_triad, CAN_051_Open_dynamic_to_information_bridge, CAN_051_Open_information_to_phen | 7 |
| A.5/H.03.v1 | CAN-052 | A.5 | H | U_{n+1}=Π_{U≥0}[(I−D_U)U_n+J_{reinforce,n}−J_{release,n}]; sufficient condition J_release−J_reinforce≥ε_releas | Definition | definition CAN_052_release_step, CAN_052_sufficient_release_condition | 4 |
| weld/H.03.v1 | CAN-053 | weld | H | R_A^{(1)}[n]=O_A(q_A(Z_A[n]);c_n,T_n); R_A^{(2)}[n]=O_A(R_A^{(1)}[n];c_n,T_n); G_A^MR[n]=R_{τ_g}(O_A(O_A(q_A(Z | finite_diagnostic | definition CAN_053_second_order_readout, CAN_053_governance_bundle, CAN_053_Open_no_free_governance | 18 |
| EQ-015/H.06.v1 | CAN-054 | EQ-015 | H | ΔO_n^fast = B_nA_n; g_n = Γ_n(s_n,r_n^err,q_n,v_n,c_n,p_n) ∈ ℚ∩[0,1]; ΔO_n^ret = g_n·ΔO_n^fast; O_H[n+1]=O_H[n | Definition | closed CAN_054_gate_weight_valid, CAN_054_retained_update, CAN_054_finite_bottleneck, CAN_054_finite_bottlenec | 18 |
| weld/H.04.v1 | CAN-055 | weld | H | G_H[n]=(V_H[n],E_H[n],w_H[n]), w_H[n](e)∈ℚ_{>0}, φ_n∈ℚ^{\|V_H[n]\|}; μ_H δ²φ_n + d_H δφ_n + κ_H L_H[n] φ_n + ∂_Q | Definition | definition HumanRetainedGraph, CAN_055_human_domain_state_graph, CAN_055_Dr_spine_equation | 8 |
| A.5/H.04.v1 | CAN-056 | A.5 | H | Σ_{H+AI} = D^{use}_{H+AI}(B,Q) / max{ D^{use}_H(B,Q), D^{use}_{AI}(B,Q), 1 }; non-collapse: more AI output ≠ m | Definition | closed CAN_056_synergy_ratio, CAN_056_more_output_ne_more_diversity, CAN_056_Open_H1_H2 | 4 |
| EQ-015/H.07.v1 | CAN-057 | EQ-015 | H | Π^live_{A,t}(g) ⊆ Π^feas_{A,t}(g) ⊆ Π^phys_t(g) | Definition | definition CAN_057_Pi_live, CAN_057_full_nesting_witness, CAN_057_full_nesting_worldsystem_witness | 4 |
| EQ-015/H.08.v1 | CAN-058 | EQ-015 | H | L_{A,t}(g)={(π,λ^live_{A,t}(π\|g)):π∈Π^feas_{A,t}(g)}; Π^live_{A,t}(g)={π:λ^live_{A,t}(π\|g)≥τ_live} | Definition | definition CAN_058_live_field, CAN_058_live_ge_threshold | 2 |
| A.5/H.05.v1 | CAN-059 | A.5 | H | π^choice_{A,t}∈Π^live_{A,t}(g); π^act≠π^choice possible, Y_obs=O_q(H_{0:T})≠H_{0:T}; possible≠feasible≠live≠ch | Definition | definition CAN_059_is_valid_choice, CAN_059_enactment_may_differ_witness, CAN_059_observation_loses_informatio | 3 |
| EQ-015/H.09.v1 | CAN-060 | EQ-015 | H | p*_{A,g}(h,z;T,B,P)=max_{π∈Π^wit_A(g;h,z,T,B)} Pr^π_P(Read_g∩D_g∩X_g∩F_g) | Definition | definition CAN_060_p_star, CAN_060_p_star_upper_bound_witness | 1 |
| A.5/H.06.v1 | CAN-061 | A.5 | H | L_{A,t+1}≠L_{A,t} (if a residue is retained); at world-system scale: Λ̇^live_{H,t}=λ1 B_t+λ2 X_t+λ3 P^plural_t | Definition | definition CAN_061_live_weight_may_change_witness, CAN_061_Open_live_field_dynamic | 2 |
| EQ-015/H.10.v1 | CAN-062 | EQ-015 | H | AI(Q)=K_like, K_like ≠ K_validated | Definition | definition CAN_062_KnowledgeStatus, CAN_062_status_value, CAN_062_non_collapse_witness | 8 |
| EQ-015/H.11.v1 | CAN-063 | EQ-015 | H | K_like→K_assumed (dangerous shortcut); repaired: K_like --check--> K_checked --independent support--> K_suppor | Dr | definition RepairedStatus, CAN_063_next_status, CAN_063_dangerous_shortcut | 3 |
| weld/H.05.v1 | CAN-064 | weld | H | T_{H←AI}∘K_AI ≅ K_H∘T_C, with explicit defects for semantic loss, source omission, authority laundering, uncer | Definition | definition TransportDefect, CAN_064_transport_condition | 2 |
| weld/H.06.v1 | CAN-065 | weld | H | ε_H = Def(q̃_H∘F, F#_H∘q̃_H, O_H, Inv_H) | Definition | definition CAN_065_domain_weld_defect | 2 |
| weld/H.07.v1 | CAN-066 | weld | H | ΔΩ̃^H_s=B_sA_s, rank≪d_H; Ω^H_{s+1,0}=Ω^H_{s,0}+η_sΔΩ̃^H_s; Y^return_{s+Δ}=(R_rec,R_disc,T_new,Q_next); RET=(P | Definition | definition CAN_066_candidate_update, CAN_066_is_low_rank, CAN_066_retention_gate_update, CAN_066_gate_weight_v | 5 |
| EQ-015/H.12.v1 | CAN-067 | EQ-015 | H | G_s=g(k,d,v,p,r,1−f,a\|Θ_s,Π_s); T_s=h(c,f,b,o\|Θ_s,Π_s); Δ_s=G_s−T_s; η_s>0,Δ_s>0⇒expansion; η_s>0,Δ_s<0⇒tunnel | Dr | definition CAN_067_Delta_s, CAN_067_is_expansion, CAN_067_is_tunnel | 5 |
| EQ-015/H.13.v1 | CAN-068 | EQ-015 | H | H0*→K_like→D^eff→R^eff→H↔AI→χ_recip→η→(G−T\|Θ,Π)→Y^return→J* | Dr | definition CAN_068_epistemic_fusion_sequence | 1 |
| A.5/H.07.v1 | CAN-069 | A.5 | H | AI-first fluency≠human baseline; explanation≠verification; resistance quality≠resistance accessibility; uncert | Definition | closed CAN_069_fluency_ne_baseline, CAN_069_explanation_ne_verification, CAN_069_resistance_quality_ne_accessi | 1 |
| weld/H.08.v1 | CAN-070 | weld | H | D_s^eff=\|C_s/∼_R\|, d_s=D_s^eff/\|C_s\|; N_distinct=\|{C1,...,Cn}/∼_Q\| | Dr | definition CAN_070_D_eff, CAN_070_d_s | 3 |
| EQ-015/H.14.v1 | CAN-071 | EQ-015 | H | R_s^ep=ρ(I_s,V_s,Q_s); U_s^R=u(C_s^v,T_s^v,A_s^v); R_s^ex=ψ(R_s^ep,U_s^R); Resistance quality ≠ resistance acc | Dr | closed CAN_071_R_ep, CAN_071_U_R, CAN_071_R_ex, CAN_071_quality_ne_accessibility | 4 |
| EQ-015/H.15.v1 | CAN-072 | EQ-015 | H | K_s=(κ0,κ1,W0,W1); Calibration error ≈ N^{-1}Σ_i(κ_i−y_i)^2 | Dr | definition CalibrationRecord, CAN_072_calibration_record, CAN_072_mk_calibration_record, CAN_072_calibration_e | 2 |
| weld/H.09.v1 | CAN-073 | weld | H | retained experiential reorganization → possible later CTSA crystallization; retained sensitivity→C_return, ret | Open | definition CAN_073_Open_ctsa_bridge | 2 |
| A.5/H.08.v1 | CAN-074 | A.5 | H | ΔPerformance_AI>0 ⇏ ΔH_return>0 (equivalently: Assisted performance ≠ Unaided Human Return) | Definition | closed CAN_074_assisted_gain_does_not_imply_return_gain | 7 |
| A.5/H.09.v1 | CAN-075 | A.5 | H | Exposure ≠ Retention ≠ Improvement | Definition | closed CAN_075_EndChainNotion, CAN_075_end_chain_value, CAN_075_exposure_retention_improvement_non_collapse | 2 |
| EQ-015/H.16.v1 | CAN-076 | EQ-015 | H | H_return = ⟨G_CTSA, L, M, P, W, Δ_dir⟩ | Definition | definition CAN_076_HReturn, CAN_076_mk_h_return | 4 |
| EQ-015/H.17.v1 | CAN-077 | EQ-015 | H | R^return_H = ⟨C, T, S, A⟩ | Definition | definition ReturnCTSA4, CAN_077_human_return_ctsa4, CAN_077_mk_human_return_ctsa4 | 3 |
| EQ-015/H.18.v1 | CAN-078 | EQ-015 | H | D > 0, Resist > 0, A_H > 0 | Definition | definition CAN_078_Open_dra_constitutive | 5 |
| EQ-015/H.19.v1 | CAN-079 | EQ-015 | H | J*_s=(AUG_s,SYN_s,RET_s); AUG_s=P^joint_s−P^H_s; SYN_s=P^joint_s−max(P^H_s,P^AI_s) | Definition | definition CAN_079_AUG, CAN_079_SYN, CAN_079_aug_syn_non_collapse_witness | 2 |
| A.5/H.10.v1 | CAN-080 | A.5 | H | AI fluency≠human baseline; explanation≠verification; output count≠epistemic diversity; exposure≠retention≠impr | Dr | closed CAN_080_fluency_ne_baseline, CAN_080_explanation_ne_verification, CAN_080_output_count_ne_epistemic_div | 1 |
| EQ-015/H.20.v1 | CAN-081 | EQ-015 | H | H1-H6 [Open], §12 | Open | definition CAN_081_Open_hypotheses | 6 |
| EQ-015/H.21.v1 | CAN-082 | EQ-015 | H | π^deploy=f(Stakes,LearningNeed,Irreversibility,DependencyRisk,UserSkill); State→Challenge→Check→Own (Lite); To | Definition | definition CAN_082_deployment_policy, DCPLiteStage, CAN_082_lite_next | 5 |
| A.5/H.11.v1 | CAN-083 | A.5 | H | Anchor→Expand→Oppose→Discriminate→Verify→Integrate→Remove→Return; Q_t--AI-->{Q_i,K_i}; Rival Generation / Boun | Definition | definition DCPStage, CAN_083_stage_next, CAN_083_oppose_ne_manufacture | 6 |
| A.5/H.12.v1 | CAN-084 | A.5 | H | L(c)={Decision,Risk,Money,Health,Legal,Publication,IrreversibleAction}; V={primary source,data,experiment,calc | Definition | definition StakesKind, VerifyMethod, CAN_084_high_stakes | 3 |
| A.8/H.01.v1 | CAN-085 | A.8 | H | I_s=⟨ΔM_s, E^decisive_s, U^remain_s, Next_s⟩ | Definition | definition IntegrationRec, CAN_085_integration_record, CAN_085_mk_integration_record | 1 |
| EQ-015/H.22.v1 | CAN-086 | EQ-015 | H | Reset: fresh framing/session/source route; Removal: absence of decisive AI assistance | Definition | definition CAN_086_is_reset, CAN_086_is_removal | 2 |
| EQ-015/H.23.v1 | CAN-087 | EQ-015 | H | ΔH_s=⟨ΔC_s,ΔT_s,ΔS_s,ΔA_s,ΔA^corr_{H,s},ΔΛ^live_{H,s}⟩; F^return=f(Criticality,LearningNeed,FailureCost,Depend | Definition | definition ReturnConversionVector, CAN_087_return_conversion_vector, CAN_087_mk_return_conversion_vector, CAN_ | 3 |
| EQ-015/H.24.v1 | CAN-088 | EQ-015 | H | I_s→a_s→δ^world_{s+1}→H_{s+1,0}; Live Problem→Question→Dialogue→Human Return→Action→World Feedback→Revision or | Definition | definition CAN_088_world_closure, CAN_088_CycleStage, CAN_088_cycle_next | 6 |
| A.8/H.02.v1 | CAN-089 | A.8 | H | Expansion:=maximize candidate diversity and discriminability; Contraction:=prune by evidence, provenance, stak | Definition | definition CAN_089_is_expansion, CAN_089_is_contraction | 2 |
| EQ-015/H.25.v1 | CAN-090 | EQ-015 | H | DCPp, DEPp, AgP [Open] | Open | definition CAN_090_Open_dcp_propositions | 3 |
| EQ-015/H.26.v1 | CAN-091 | EQ-015 | H | H1-H10, §15.2 | Open | definition CAN_091_Open_hypotheses | 10 |
| EQ-015/H.27.v1 | CAN-092 | EQ-015 | H | What unresolved difference deserves my attention? / How much AI/friction does this task require? / What remain | Dr | definition ClosingQuestion, CAN_092_closing_questions | 1 |
| A.5/H.13.v1 | CAN-093 | A.5 | H | E:=event; C_e:=(S_e,R_e,A_e,τ_e); T̂:=I(E\|C_acc); T̂≠E; general: T̂^(k)=I(E\|C_acc^(k)); epoch 3 (LLM): T̂^(3)= | Definition | closed EventContext, CAN_093_interpretation, CAN_093_interpretation_ne_event_witness | 7 |
| weld/H.10.v1 | CAN-094 | weld | H | A:=capacity to decide under context while retaining accountability; S:=(goals,constraints,stakes,role,local ev | Definition | definition ContextS, CAN_094_is_agency | 7 |
| A.5/H.14.v1 | CAN-095 | A.5 | H | G (referential grounding); Ge (experiential grounding); Emb (embodiment); G≠Emb | Definition | closed CAN_095_referential_ne_embodiment, CAN_095_experiential_grounding | 2 |
| EQ-015/H.28.v1 | CAN-096 | EQ-015 | H | 𝓔:=f(ConstraintPrecision, ContextRecall, SourceTraceability, ErrorRepair) | Definition | definition CAN_096_interaction_efficiency | 1 |
| EQ-015/H.29.v1 | CAN-097 | EQ-015 | H | H1: AI increases access to/reorganization of human interpretive contexts, not event access; H3: bounded interp | Open | definition CAN_097_Open_hypotheses | 3 |
| EQ-002/H.03.v1 | CAN-098 | EQ-002 | H | Retained Difference→Human Readout→Live Problem→Barrier Readout→Candidate Routes→Human Endorsement→Adaptive Sca | Definition | definition CAN_098_hca_native_river | 2 |
| EQ-015/H.30.v1 | CAN-099 | EQ-015 | H | Z_{HCA,i,n} = ⟨P^live_{i,n}, K^life_{i,n}, B^bar_{i,n}, C^cand_{i,n}, C^live_{i,n}, h_{i,n}, R^return_{H,i,n}, | Definition | definition HCACandidateState, CAN_099_hca_candidate_state, CAN_099_mk_hca_candidate_state | 1 |
| EQ-015/H.31.v1 | CAN-100 | EQ-015 | H | K^life_{i,n} = ⟨E^econ, F^base, L^lang, D^digital, T^disc, H^health, M^mob, N^mentor, C^cred⟩ | Definition | definition CAN_100_LifeCapitalContext, CAN_100_mk_life_capital_context | 1 |
| A.5/H.15.v1 | CAN-101 | A.5 | H | Resources≠Access, Access≠Capability, Capability≠Realized Opportunity; Access(z)≠Control(z); Equal AI Access =/ | Definition | closed CAN_101_resources_ne_access, CAN_101_access_ne_capability, CAN_101_capability_ne_realized_opportunity,  | 3 |
| A.5/H.16.v1 | CAN-102 | A.5 | H | B^bar_{i,n}⊆{Knowledge,Skill,Language,Tool,ResourceTime,Network,Credential,Permission,Opportunity,Unknown}; Ob | Definition | definition CAN_102_BarrierType, CAN_102_BarrierLedger, CAN_102_observed_difficulty_ne_skill_deficit_witness | 2 |
| A.5/H.17.v1 | CAN-103 | A.5 | H | C^cand_{i,n}=Gen(P^live,B^bar,K^life,R^return); C^live_{i,n}={c∈C^cand:Endorse_i(c)=1}; Proactive Suggestion≠H | Definition | definition CAN_103_C_live, CAN_103_C_live_subset_witness, CAN_103_proactive_ne_ownership_witness, CAN_103_capa | 5 |
| EQ-015/H.32.v1 | CAN-104 | EQ-015 | H | Stable Unaided Return↑ ⇒ h^decisive↓; Attempt→Minimal Sufficient Scaffold→Feedback→Reattempt→Fading→Unaided Ex | Open | definition CAN_104_hca_ddiff, CAN_104_Open_scaffold_fading | 3 |
| A.5/H.18.v1 | CAN-105 | A.5 | H | Ω^real_{i,n}=G_O(R^return_{H,i,n},K^life_{i,n},Cred_{i,n},Net_{i,n},Perm_{i,n},MarketReadout_n); Credential≠Ca | Definition | definition CAN_105_omega_real, CAN_105_credential_ne_capability_witness, CAN_105_legibility_ne_worth_witness | 4 |
| A.8/H.03.v1 | CAN-106 | A.8 | H | A^HCA_i=⟨Gain_CTSA,Loss,Transfer,Ownership,Burden,BarrierChange,OpportunityChange,Provenance,Warrant⟩; ATE_HCA | Definition | definition CAN_106_NetAdvancementRecord, CAN_106_mk_net_advancement_record, CAN_106_ATE_HCA | 2 |
| A.5/H.19.v1 | CAN-107 | A.5 | H | Outcome_C−Outcome_A ≠ Effect_HCA; Schooling+Human-Owned Inquiry+Supervised Adaptive AI+Projects+Human Return+O | Definition | closed CAN_107_raw_difference_ne_effect_hca | 2 |
| EQ-015/H.33.v1 | CAN-108 | EQ-015 | H | Adult: Purpose+Transparency+Refusal+Revision+Data Minimization; Child: Child Assent+Adult Oversight+Privacy+Sa | Definition | definition CAN_108_adult_governance, CAN_108_child_governance | 2 |
| EQ-015/H.34.v1 | CAN-109 | EQ-015 | H | H1-H6 [Open], §17.2 | Open | definition CAN_109_Open_hypotheses | 6 |
| weld/H.11.v1 | CAN-110 | weld | H | M0=formal option count+stated preference; M1=affordance/capability+cost; M2=constructed-preference/salience; M | Definition | definition RivalModel, CAN_110_ladder_index | 5 |
| EQ-002/H.04.v1 | CAN-111 | EQ-002 | H | α_t(o) ∈ {HUMAN, AI, JOINT} for o ∈ Ω={q_sem,Π_P,Π_Q,B,a,m,κ,Γ_Q,U_D,Π_R} | Definition | definition AttributionLabel, OriginObject, CAN_111_attribution | 3 |
| A.8/H.04.v1 | CAN-112 | A.8 | H | u*^diag=argmax_u[IG_B(u)−λ_C Cost(u)−ρ Risk(u)]; u*^adv=argmin_u E[...]; π*∈argmax_π E[ΔH_s\|π]; π^perf∈argmax_ | Definition | definition CAN_112_is_argmax, CAN_112_Open_is_argmin | 7 |
| weld/H.12.v1 | CAN-113 | weld | H | C→T→Workflow→S→A→C′; Frozen Human baseline→K_like→Difference/Resistance→H↔AI→Retention gate→CTSA Return Profil | Dr | definition CTSAStage, CAN_113_stage_next | 2 |
| EQ-015/H.35.v1 | CAN-114 | EQ-015 | H | P1: framing residual; P2: iteration without integration is insufficient | Open | definition CAN_114_Open_predictions | 2 |
| weld/S.01.v1 | CAN-115 | weld | S | L_R = D_W − W (forced Laplacian); A := L_R + Γ; s[n+1] = s[n] + dt(−A s[n] + J). L1 (invariance/recurrence): a | Definition | definition (re-export shim; apparatus moved to split_children) | 18 |
| weld/S.02.v1 | CAN-116 | weld | S | M(t')∈M [Axiom I: Reality-as-Record]; A_i(t')⊆M(t') [Axiom II: Agency-as-Choice]; G(t'):={A_1(t'),…,A_N(t')}⊆M | Ax | definition (re-export shim; apparatus moved to split_children) | 4 |
| EQ-015/S.01.v1 | CAN-117 | EQ-015 | S | R := (T_R, I_R); M(t'+Δt') = T_R(M(t')); A(t'+Δt') ⊆ I_R(A(t'), M(t')); Etic(A;t') := ∃R_A(t')∈R_adm(t'): A⊆M( | Ax | definition (re-export shim; apparatus moved to split_children) | 4 |
| EQ-015/S.02.v1 | CAN-118 | EQ-015 | S | Ethical(A) ⇔ ∃Choice(A→R_A): d/dt' V_{A,R_A}(M(t')) ≤ 0 ∧ τ_c'(R_A) > 0 ∧ Δ_spec(R_A) > 0 [author-labelled fin | Definition | definition (re-export shim; apparatus moved to split_children) | 6 |
| EQ-015/S.03.v1 | CAN-119 | EQ-015 | S | Eth_col(G) ⇔ d/dt' V_G(M) ≤ 0 ∧ min_i Δ_spec(R_i) > 0; Conf_{ind→col} ⇔ d/dt'V_{A_i}≤0 ∧ d/dt'V_G>0; Conf_{col | Definition | definition (re-export shim; apparatus moved to split_children) | 11 |
| weld/S.03.v1 | CAN-120 | weld | S | C_{A,R}[t1,t2] := ∫_{t1}^{t2} [α V̇⁺_{A,R}(M(t')) + β χ_causal(R) + γ χ_spec(R)] dt', α,β,γ>0; Resp(A)≡C_{A,R_ | Definition | definition (re-export shim; apparatus moved to split_children) | 12 |
| A.5/S.01.v1 | CAN-121 | A.5 | S | x'=F(x,C); x(t)∈V; d/dt[d(x(t),V)]<0 (persistence regulation); C_{t+1}=G(x_t,C_t); ∂C/∂x≠0 (necessary, not suf | Definition | definition (re-export shim; apparatus moved to split_children) | 10 |
| weld/S.04.v1 | CAN-122 | weld | S | Bel_{i,p,n}=Rel_B(a_i,p\|x_i,μ_i,E_i,M_i,Θ_i,I_i,S_i^active,c_i); canonical belief vector b_{i,p,n}=(e_{i,p},c_ | Definition | definition (re-export shim; apparatus moved to split_children) | 5 |
| weld/S.05.v1 | CAN-123 | weld | S | Z_{G,t}=⟨{Z_{A_i,t}}_{i=1}^n, T_{G,t}, A_{G,t}, C_{G,t}⟩; S_{G,t}:=q_{sem,G,Ω_{G,t}}(Z_{G,t}); m^G_{t+1}(e)=ρ_ | Definition | definition (re-export shim; apparatus moved to split_children) | 4 |
| weld/S.06.v1 | CAN-124 | weld | S | Power may alter agency by altering meaning/accessibility before overt choice | Dr | definition CAN_124_power_live_gap | 1 |
| weld/S.07.v1 | CAN-125 | weld | S | Experience→Interpretations→Absent Perspective→Observable Evidence→Direct Human Conversation | Definition | closed CAN_125_DCPStage, CAN_125_index, CAN_125_index_injective, CAN_125_route_is_strictly_ordered | 1 |
| A.5/S.02.v1 | CAN-126 | A.5 | S | no H_org,n+1≠H_org,n attributable to the processing | Open | definition CAN_126_falsifier_condition | 1 |
| weld/S.08.v1 | CAN-127 | weld | S | P1-P8 [Open], §7 | Open | definition CAN_127_OLWProposition | 8 |
| A.5/S.03.v1 | CAN-128 | A.5 | S | Π^{live}_{A,t}(g)⊆Π^{feas}_{A,t}(g)⊆Π^{phys}_t(g); L_{A,t}(g)={(π,λ^{live}_{A,t}(π\|g)):π∈Π^{feas}_{A,t}(g)}; Π | Definition | definition (re-export shim; apparatus moved to split_children) | 7 |
| EQ-015/S.04.v1 | CAN-129 | EQ-015 | S | objective possibility ≠ structural feasibility; feasibility ≠ live possibility; live possibility ≠ stated pref | Definition | definition (re-export shim; apparatus moved to split_children) | 3 |
| EQ-015/S.05.v1 | CAN-130 | EQ-015 | S | P1 objective≠practical possibility; P2 practical possibility is meaning-shaped; P3 meaning-shaping can alter a | Dr | definition CAN_130_MeanPropItem | 5 |
| weld/S.09.v1 | CAN-131 | weld | S | H1 live possibility beyond option count; H2 meaning access beyond resources; H3 history-shaped re-entry; H4 re | Open | definition CAN_131_LiveHyp | 8 |
| EQ-015/S.06.v1 | CAN-132 | EQ-015 | S | p*_{A,g}(h,z;T,B,P) = max_{π∈Π^{wit}_A(g;h,z,T,B)} Pr^π_P(Read_g∩D_g∩X_g∩F_g), with p*_{A,g}:=0 when the set i | Definition | definition (re-export shim; apparatus moved to split_children) | 5 |
| EQ-015/S.07.v1 | CAN-133 | EQ-015 | S | p*(2)_{A,g} := max_{z∈J_feas} p*_{A,g}(h,z;T,B,P); L^{recoverable}_A = max_{z∈J_feas} A^{corr}_A(h,z) − A^{cor | Definition | definition (re-export shim; apparatus moved to split_children) | 2 |
| EQ-015/S.08.v1 | CAN-134 | EQ-015 | S | L^{live}_{A,g} = max_{z∈J_feas} D_L(L^z_A(g), L^{z0}_A(g)) | Definition | closed CAN_134_live_field_gap, CAN_134_gap_nonneg | 1 |
| EQ-015/S.09.v1 | CAN-135 | EQ-015 | S | Δspec(Ri) > 0 ⟺ channel_i = open ∧ Ṙ_i ≠ 0 | Definition | closed CAN_135_Channel, CAN_135_corrigible, CAN_135_corrigible_satisfiable | 1 |
| EQ-015/S.10.v1 | CAN-136 | EQ-015 | S | Y_obs = calm ∧ p*wit = low ∧ F = blocked | Definition | definition (re-export shim; apparatus moved to split_children) | 2 |
| EQ-015/S.11.v1 | CAN-137 | EQ-015 | S | D1 Potential≠exercised≠observed; D2 Declared set≠witnessed set; D3 Layer1≠layer2; D4 Task potential≠aggregate  | Definition | definition (re-export shim; apparatus moved to split_children) | 7 |
| EQ-015/S.12.v1 | CAN-138 | EQ-015 | S | P-B channel shift (load displaces between coupled tasks while the aggregate stays flat); P-C the excluded path | Open | definition CAN_138_Falsif | 3 |
| A.8/S.01.v1 | CAN-139 | A.8 | S | P1: r=d=x=9/10, channel always open, every reason voiced ⇒ f_P1=1, p*_P1=729/1000. P2: channel open w.p. 1/5,  | Dr | closed CAN_139_identifiability_certificate | 1 |
| EQ-015/W.01.v1 | CAN-140 | EQ-015 | W | human labour→production→wage→claim on output; labour-based claim→human/citizen claim on social production | Definition | definition LabourClaimStage, CAN_140_labour_claim_next | 2 |
| EQ-015/W.02.v1 | CAN-141 | EQ-015 | W | Ż_t = v_t G_t − δ_Z Z_t, 0≤v_t≤1 | Definition | definition CAN_141_Z_next, CAN_141_valid_validation_rate | 1 |
| EQ-015/W.03.v1 | CAN-142 | EQ-015 | W | B^RB_t=N^RB_t q^RB_t; growth decomposition Ḃ^RB/B^RB=Ṅ^RB/N^RB+q̇^RB/q^RB; M_t=(K^M_t)^κ(A^AI_t)^α(B^RB_t)^β;  | Definition | definition (re-export shim; apparatus moved to split_children) | 5 |
| EQ-015/W.04.v1 | CAN-143 | EQ-015 | W | L_t = ⟨L^task_t, L^income_t, L^bottleneck_t, L^bargain_t⟩ | Definition | definition (re-export shim; apparatus moved to split_children) | 2 |
| EQ-015/W.05.v1 | CAN-144 | EQ-015 | W | q_t=o_t+τ_t(1−o_t); Γ_t=s^L_t+q_t(1−s^L_t); q^min_t=(Γ̄−s^L_t)/(1−s^L_t); D^rent, Γ^net | Definition | definition (re-export shim; apparatus moved to split_children) | 5 |
| EQ-015/W.06.v1 | CAN-145 | EQ-015 | W | AD_t=C(Γ^eff_tY_t,m_t)+I_t+G_t+NX_t; χ^dem_t=min{1,AD_t/Y_t}; Π^M_t=χ^dem_tY_t−Cost^M_t; Γ^effY→AD→Π^M→W^M_{t+ | Definition | definition (re-export shim; apparatus moved to split_children) | 5 |
| EQ-015/W.07.v1 | CAN-146 | EQ-015 | W | W^M_{i,t+1}=(1−δ_W)W^M_{i,t}+r^M_tW^M_{i,t}+s^{M,cap}_{i,t}+T^cap_{i,t}−Tax^cap_{i,t}; o_t=Σ_{i∈B}W^M_{i,t}/Σ_ | Definition | definition (re-export shim; apparatus moved to split_children) | 3 |
| A.5/W.01.v1 | CAN-147 | A.5 | W | B^scarce_{i,t}=(R^house+R^land+R^energy+DS)/Y; Γ^eff_{i,t}=max{0,Γ^net_{i,t}−B^scarce_{i,t}}; machine abundanc | Definition | definition (re-export shim; apparatus moved to split_children) | 3 |
| EQ-015/W.08.v1 | CAN-148 | EQ-015 | W | G^conv_{j,t}(e)=1−[V_t(e\|−j)/V_t(e)]_+; X_{i,t}(e;j)=clip(V_{i,t}(e\|−j)/V_{i,t}(e),0,1); D_{i→j,t}(g)=Σ_e w_e( | Definition | definition (re-export shim; apparatus moved to split_children) | 5 |
| EQ-015/W.09.v1 | CAN-149 | EQ-015 | W | C_{i,t} = ⟨O_{i,t}, G_{i,t}, Γ_{i,t}, A^access_{i,t}, X_{i,t}, D_{i,t}, R^rent_{i,t}⟩ | Definition | definition RelationalClassPosition, CAN_149_RelationalClassPosition, CAN_149_mk_relational_class_position | 1 |
| weld/W.01.v1 | CAN-150 | weld | W | c^(PE→H)_{i,t} = B^(PE→H)(Z_t; i, g) | Definition | definition CAN_150_pe_to_human_bridge | 1 |
| EQ-015/W.10.v1 | CAN-151 | EQ-015 | W | P^H_t=(Γ^eff_t)^θΓ(A^corr_{H,t})^θA(Λ^live_{H,t})^θΛ(r^H_t)^θR(S^H_t)^θS(X^H_t)^θX/(1+D^H_t)^θD; Ẏ_t>0 ⇏ Ṗ^H_t | Definition | definition (re-export shim; apparatus moved to split_children) | 6 |
| EQ-015/W.11.v1 | CAN-152 | EQ-015 | W | Ṡ^H_t=s1W_t+s2N_t−δ_SS^H_t; 1=l_wage+l_care+l_learn+l_civic+l_leisure | Definition | definition (re-export shim; apparatus moved to split_children) | 2 |
| EQ-015/W.12.v1 | CAN-153 | EQ-015 | W | Ḣ^cap_t=f(Care_t,Health_t,Education_t,Nutrition_t,Community_t)−δ_HH^cap_t; productive necessity of humans ≠ so | Definition | definition (re-export shim; apparatus moved to split_children) | 3 |
| A.5/W.02.v1 | CAN-154 | A.5 | W | P_t=⟨P^econ_t,P^info_t,P^coerc_t⟩; P^B_t∝Γ^eff_tA^corr_{H,t}Λ^live_{H,t}X^H_tr^H_t; P^E_t=P_E(P_t,Ġ^conv,D^H_t | Definition | definition (re-export shim; apparatus moved to split_children) | 6 |
| EQ-015/W.13.v1 | CAN-155 | EQ-015 | W | Ω_t = w_M(g_M−g_H)+w_Dg_D+w_Gg_G−w_qg_q−w_Γg_(Γ^eff)−w_Xg_X−w_Rg_(r^H)−w_Λg_Λ−w_Hg_(H^cap) | Dr | definition CAN_155_Omega | 1 |
| weld/W.02.v1 | CAN-156 | weld | W | candidate generation→validated K/A^AI→robotic embodiment→M_t→Y_t→L_t→s^L_t→Γ_t→W^M_t→o_{t+1}→Γ^eff_t→AD_t→Π^M_ | Definition | definition AfterLabourRiverStage, CAN_156_after_labour_river_next | 1 |
| EQ-015/W.14.v1 | CAN-157 | EQ-015 | W | A^corr_{H,i,t}(g) = max_{π∈Π^live_{i,t}(g)} Pr^π(R_g∩D_g∩X_g∩F_g) | Definition | definition CAN_157_corrigible_agency_ws, CAN_157_corrigible_agency_ws_upper_bound | 1 |
| EQ-015/W.15.v1 | CAN-158 | EQ-015 | W | R^return_{H,t} = ⟨C_t, T_t, S^skill_t, A^alt_t⟩ | Definition | definition CAN_158_ReturnProfileWS, CAN_158_mk_return_profile_ws | 1 |
| EQ-015/W.16.v1 | CAN-159 | EQ-015 | W | Machine expansion ⇏ Human expansion; C^H_t=⟨Γ^eff_t,X^H_t,Λ^live_{H,t},A^corr_{H,t},R^route_{H,t},W^world_{H,t | Definition | definition (re-export shim; apparatus moved to split_children) | 7 |
| A.5/W.03.v1 | CAN-160 | A.5 | W | AI capability≠validated knowledge; assisted performance≠human learning; augmentation≠synergy; formal options≠l | Definition | definition (re-export shim; apparatus moved to split_children) | 9 |
| EQ-015/W.17.v1 | CAN-161 | EQ-015 | W | H problem→AI divergence→H resistance→World test→H integration→AI removal→H return (high-conversion); H problem | Definition | definition HighConversionStage, CAN_161_high_conversion_next, LowConversionStage, CAN_161_low_conversion_next, | 4 |
| EQ-015/W.18.v1 | CAN-162 | EQ-015 | W | B_t = ⟨D_t, Ġ^conv_t, C^info_t, 1−X^H_t, 1−r_{H,t}, 1−Λ^live_{H,t}, 1−A^corr_{H,t}, 1−Γ^eff_t, 1−H^cap_t⟩ | Definition | definition BadModeState, CAN_162_BadModeState, CAN_162_mk_bad_mode_state | 1 |
| EQ-015/W.19.v1 | CAN-163 | EQ-015 | W | W_j={t: C^rec_{j,t}≤C̄_j ∧ τ^rec_{j,t}≤τ̄_j}; Δg_{j,t}=[g̃_{M,t}−g̃_{Cj,t}]_+; U_{j,t}=Δg_{j,t}L_{j,t}S_{j,t}τ | Definition | definition (re-export shim; apparatus moved to split_children) | 6 |
| EQ-002/W.01.v1 | CAN-164 | EQ-002 | W | C^10_{j,t}, C^50_{j,t}, C^90_{j,t}; I^H_{j,t}=C^90_{j,t}−C^10_{j,t} | Definition | definition (re-export shim; apparatus moved to split_children) | 3 |
| EQ-002/M.01.v1 | CAN-165 | EQ-002 | M | Φ:X→Z is readout-admissible relative to R:X→Y iff constant on every fiber of R: R(x)=R(x') ⟹ Φ(x)=Φ(x'); equiv | Definition | closed CAN165_admissible, CAN165_g_of, CAN165_factorization_thm, CAN165_data_processing_inequality_Open, CAN16 | 20 |
| weld/M.04.v1 | CAN-166 | weld | M | M0=arousal/intensity only; M1=familiarity/exposure; M2=prediction/surprise; M3=language/category construction; | Open | definition CAN166_RivalModel, CAN166_must_beat_ladder_Open | 1 |
| weld/M.05.v1 | CAN-167 | weld | M | r_t=A_tε_t−δ_t, V_t=(1/2)r_t^T W_t r_t; P_t:=Retain_{Π_P}(r_t); Q_{Π_Q}(P_t)=d_{Q,t} | Definition | definition CAN167_residual, CAN167_cost, CAN167_problem, CAN167_question_selects | 3 |
| weld/M.06.v1 | CAN-168 | weld | M | 0≤κ_{A,t,Q}(s'\|s)≤1; μ_{A,t}(π\|Q)=∏κ_{A,t,Q}(s_{k+1}\|s_k); Acc_{A,t}(H\|Q)=sup_π μ_{A,t}(π\|Q); reachable(H)=1 ⇏ | Definition | closed CAN168_path_prob, CAN168_reachable, CAN168_high, CAN168_positive_but_not_high | 10 |
| weld/M.07.v1 | CAN-169 | weld | M | G^K_{A,t}(Q)=⟨V_{A,t},E_{A,t},ω_{A,t,Q},χ_{A,t}⟩; U_{A,t}(Q)={[H]∈H^disc_{A,t}(Q): W_t(H)≥w0, ∃u∈U_{D,t} with  | Definition | closed CAN169_first_hit, CAN169_tau_U_bounded, CAN169_tau_U_unbounded_Open, CAN169_usable_ne_actually_true | 19 |
| weld/M.08.v1 | CAN-170 | weld | M | discriminating action u* satisfies δ̂_i(u*)≠δ̂_j(u*); δ*_{t+1}=O_D(Z_{t+1};u*); r*_i=δ̂_i(u*)−δ*_{t+1}; (Z_{t+ | Definition | definition CAN170_discriminating, CAN170_local_residual | 4 |
| A.8/M.02.v1 | CAN-171 | A.8 | M | Λ(e_i) = ⟨Prov_i, Tier_i, Def_i, Reader_i, Falsifier_i⟩ | Definition | definition CAN171_LedgerEntry | 3 |
| A.8/M.03.v1 | CAN-172 | A.8 | M | Status∈{Source, AI-Synthesis, Human-Inference, Candidate, Decision} | Definition | definition CAN172_Status | 1 |
| A.8/M.04.v1 | CAN-173 | A.8 | M | PRC(e_i)∈{0,1}; C_t^valid=Σ_iw_ie_iPRC(e_i) | finite_diagnostic | closed CAN173_valid_term, CAN173_C_valid, CAN173_C_raw, CAN173_term_le, CAN173_valid_le_raw | 2 |
| weld/M.09.v1 | CAN-174 | weld | M | ClaimStrength ≤ EvidenceStrength | finite_diagnostic | closed is, CAN174_invariant, CAN174_invariant_refl | 1 |
| A.8/M.05.v1 | CAN-175 | A.8 | M | Cost_{K2,r}=(Cash_r+λ_HH_r+λ_LL_r)/(D_rR_rI_r+ε); ExpectedK2Yield_j=(P(Review_j)Depth_jFit_j)/(Cash_j+Prep_j+L | finite_diagnostic | definition CAN175_cost_k2, CAN175_expected_yield, CAN175_effective_k2 | 3 |
| weld/M.10.v1 | CAN-177 | weld | M | Phenomenon→ExistingExplanations→PreciseInadequacy→Mechanism→Boundary→Propositions; Engine A: Phenomenon→Theore | Definition | closed CAN177_TheoryStage, CAN177_EngineAStage, CAN177_EngineBStage, CAN177_bridge, CAN177_bridge_iff | 5 |
| A.8/M.06.v1 | CAN-178 | A.8 | M | K0_start=I0+R0+N0+P0; E_t=f(Q_t,C_t,V_t,U_t,X_t,T_t); PosCap=Access×Language×SituatedObservation×TranslationCa | Definition | definition CAN178_K0_start, CAN178_E_t, CAN178_PosCap, CAN178_NetPractice | 4 |
| weld/M.11.v1 | CAN-179 | weld | M | K0: private candidate; K1: K0+public timestamp/provenance/provisionality; K2: K1+substantive external friction | Definition | closed CAN179_KState, CAN179_code, CAN179_lt, CAN179_ladder_strictly_increasing | 3 |
| A.8/M.07.v1 | CAN-180 | A.8 | M | μ_H,f≈0, μ_A≫μ_H,f; EIC⇒BuildSyntheticFormationInfrastructure; AI speed→synthetic criticism→K1→human correctio | finite_diagnostic | definition CAN180_EIC, CAN180_EIC_implies_Open | 3 |
| A.8/M.08.v1 | CAN-181 | A.8 | M | Λ=min(μ_L,μ_H,μ_E,μ_P,μ_C); V_c=(H·L·T)^(1/3); D_e=A·(1−V_c); PublicOutputVelocity≤VerificationCapacity | finite_diagnostic | definition CAN181_Lambda, CAN181_Lambda_le_each, CAN181_Vc, CAN181_De, CAN181_velocity_constraint | 4 |
| EQ-015/M.05.v1 | CAN-182 | EQ-015 | M | DVP*=ReduceCorrelatedError+ExposeResidualDependence+BottomOutWherePossible; Disagreement=>Resolve v Declare; N | finite_diagnostic | definition CAN182_Outcome, CAN182_decision | 3 |
| EQ-002/M.02.v1 | CAN-183 | EQ-002 | M | Coh_effective=Coh_latent×L_g; L_g^proxy=(public assets with one-click programme path)/(public assets); K1→Rela | finite_diagnostic | closed CAN183_Coh_effective, CAN183_effective_le_latent | 3 |
| A.8/M.09.v1 | CAN-184 | A.8 | M | A_s=AssociationStrength(Author,Problem); A_s(t+1)>A_s(t); Paper1→Theme; Paper2→SameTheme+NewMechanism; Paper3→ | finite_diagnostic | definition CAN184_monotone_increase_Open, CAN184_PaperRole | 3 |
| weld/M.12.v1 | CAN-185 | weld | M | χ_t=λ_mint/(λ_conv+ε); B_{t+1}=B_t+M_t−ωX_t; M_t≤λX_t; C_{t+1}=(1−δ)C_t+G_t+Φ_t(Stock)I_tP_t^{(r)}S_t; V_C=dE[ | finite_diagnostic | closed CAN185_chi, CAN185_B, CAN185_B_bounded_by_mint, CAN185_VC, CAN185_priority | 17 |
| A.8/M.10.v1 | CAN-186 | A.8 | M | FlagshipConcept→Preprint→Conference→Journal→EmpiricalTest→ComparativeExtension→Grant; CreditLeverage_i=(Σ_jCre | finite_diagnostic | definition CAN186_CompoundingStage, CAN186_credit_leverage, CAN186_PC_superseded | 3 |
| A.8/M.11.v1 | CAN-187 | A.8 | M | k_t=ν_tf_coh,tL_g,tp_int,tm_leg,tu_conv,tP_NL,t; β_D=(Σw_dE_d)/(Σw_dE_d+Σw_pE_p+ε); IncreaseMintRate=>β_D≥β_mi | Definition | definition CAN187_k_t, CAN187_beta_D, CAN187_increase_mint_rate, CAN187_rho_R, CAN187_X_t, CAN187_BR_t | 6 |
| EQ-015/M.06.v1 | CAN-188 | EQ-015 | M | HorizontalGeneration→EpistemicFriction→VerticalStrengthening→ResourceReturn→HorizontalGrowth | Definition | closed CAN188_LoopStage, CAN188_step, CAN188_iter, CAN188_loop_returns | 1 |
| A.8/M.12.v1 | CAN-189 | A.8 | M | r=Aε−δ; V=(1/2)r^TWr | Definition | definition CAN189_r, CAN189_V | 1 |
| A.5/M.02.v1 | CAN-190 | A.5 | M | P_local⊄D_AI; MultiAIConsensus=/=>GeographicCompleteness; DVP*=DVP+GDA; S_G=L×G×M×B×F; ManuscriptStrength>Iden | finite_diagnostic | closed mr_list_non_containment_witness, CAN190_not_subset, CAN190_not_subset_witness, CAN190_S_G, CAN190_Conve | 9 |
| A.8/M.13.v1 | CAN-191 | A.8 | M | AI candidate→OriginalSource→ClaimMatch→VerifiedCitation; Reject→Objection→Revision→ΔQ; SCRAM=FreezeNewRelease+ | finite_diagnostic | definition CAN191_FirewallStage, CAN191_scram | 3 |
| A.8/M.14.v1 | CAN-192 | A.8 | M | H_g = (questions defended without AI) / 10 | finite_diagnostic | definition CAN192_H_g | 1 |
| EQ-015/M.07.v1 | CAN-193 | EQ-015 | M | Phenomenon→AIExploration→DVP→HumanMastery→Integrity→K1→{Global,Local Friction}→K2→Revision→K3; EpistemicPositi | Definition | definition CAN193_ArchStage, CAN193_EpistemicPosition, CAN193_CrediblePath | 3 |
| A.8/M.15.v1 | CAN-194 | A.8 | M | B_year=B_conference+B_ethics+B_software+B_data+B_publication+B_travel; MissingResource=>ProjectHold; H_planned | finite_diagnostic | closed CAN194_B_year, CAN194_B_year_total, CAN194_component_le_total, CAN194_portfolio_shrink, CAN194_wip_boun | 5 |
| A.8/M.16.v1 | CAN-195 | A.8 | M | PracticeObservation→Hypothesis; Claim<-Literature+ExternalEvidence+ComparativeEvidence; ClaimScope≤SamplingSco | finite_diagnostic | definition CAN195_scope_constraint, CAN195_Pipeline | 3 |
| A.5/M.03.v1 | CAN-196 | A.5 | M | neighboring evidence≠formal-variable validation≠truth of the integrated theory; reachability≠accessibility; sp | untagged | closed CAN196_EvidenceNotion, CAN196_neighboring_ne_formal, CAN196_formal_ne_truth, CAN196_reachability_ne_acc | 6 |
| A.5/M.04.v1 | CAN-197 | A.5 | M | G1K≠G2K => L(τ_U\|G1K,Q)≠L(τ_U\|G2K,Q) | Open | definition CAN197_topology_sensitivity_Open | 1 |
| EQ-015/M.08.v1 | CAN-198 | EQ-015 | M | T_n={(x_k,t_k,w_k)}_{k≤n}, Rhythm_n=Ω(T_n,B_n); m_{t+1}(e)=ρm_t(e)+1[e_t=e], 0≤ρ<1; κ^{sem}_{t+1}(e\|Q) ∝ κ^{se | Definition | definition CAN198_momentum, CAN198_Open_momentum, CAN198_accessibility_score, CAN198_Open_accessibility, CAN19 | 5 |
| EQ-015/M.09.v1 | CAN-199 | EQ-015 | M | B[t+1]=F(B[t])+C_H(H[t]); H[t+1]=G(H[t])+C_B(B[t]); E[t]=R(B[t],H[t]) | Definition | definition CAN199_B, CAN199_E | 3 |
| EQ-015/M.10.v1 | CAN-200 | EQ-015 | M | B^use=⟨Time,CognitiveLoad,VerificationCost,Interruption,LiteracyDemand⟩; Epistemically optimal ≢ Behaviorally  | Definition | closed CAN200_Burden, CAN200_OptimalOrAdoptable, CAN200_optimal_ne_adoptable | 3 |
| EQ-002/M.03.v1 | CAN-201 | EQ-002 | M | Readout_{Q,O,c}(S) = z, z ≠ S | Definition | closed CAN_201_hypothesis_satisfiable_on_bool | 2 |
| EQ-015/E.12.v1 | CAN-202 | EQ-015 | E | M_A[n] = K_A · θ(E[n]) + η_sel + η_map + η_self | Definition | closed CAN202_M_A, CAN202_decomposition | 2 |
| EQ-002/E.09.v1 | CAN-203 | EQ-002 | E | x_{i,n} = Access(A_n; O_i, L_i, T_i, R_i, C_i) | Definition | definition CAN203_x | 1 |
| EQ-002/E.10.v1 | CAN-204 | EQ-002 | E | O_A[n] = Π_A(E[n]);  enc_A(O_A)[n] = T_A(O_A[n]) | Definition | definition CAN204_O_A, CAN204_enc_A | 2 |
| weld/E.09.v1 | CAN-205 | weld | E | S_n : X_n → Z_n;  z_n = Π_n S_n(X_n) + η_n, z_n ∈ ℚ^{m_n};  W_n = {n−h_n+1, …, n};  z̃_n = Σ_{j=0}^{h_n−1} a_{ | Definition | closed CAN205_windowed_avg, CAN205_window_of_one_exact | 4 |
| EQ-002/E.11.v1 | CAN-206 | EQ-002 | E | D_n = {D_n^first, D_n^beh, D_n^neural, D_n^world} | Dr | definition CAN206_DomainSource, CAN206_source_eq_dec | 1 |
| EQ-015/E.13.v1 | CAN-207 | EQ-015 | E | S_{A,t} := q_{sem,A,Ω_t}(Z_t) | Definition | definition CAN207_S_A | 1 |
| A.8/E.01.v1 | CAN-208 | A.8 | E | No epistemic discrimination without provenance. Operational form: (i) What does the attributed source distingu | Definition | definition CAN208_governing_maxim | 6 |
| A.5/E.03.v1 | CAN-209 | A.5 | E | D_Φ(x0) = { d0_{x'} = (x0,x') : Φ(x') ≠ Φ(x0) };  P(d) = (V_d, E_d, τ_d) | Definition | closed CAN209_distinguishes, CAN209_D_Phi, CAN209_D_Phi_sound, CAN209_Path | 2 |
| weld/M.13.v1 | CAN-210 | weld | M | A0 ⊆ A1 ⊆ … ⊆ Am;  l(d0_{x'}) = min{ j : x' ∉ Γ_j } | Definition | closed CAN210_first_false, CAN210_level, CAN210_level_correct | 2 |
| EQ-015/M.11.v1 | CAN-211 | EQ-015 | M | Def-2 Access augmentation (Y1→(Y1,Y2)); Def-3 Contrast/relevance operation (X→X'⊆X); Def-4 Inferential commitm | Definition | closed CAN211_AugmentationKind, CAN211_kinds_pairwise_distinct, CAN211_access_aug, CAN211_contrast_aug, CAN211 | 4 |
| A.8/M.17.v1 | CAN-212 | A.8 | M | E (provenance existence): P(d) nonempty or the claim is marked provenance-indeterminate. A (provenance attribu | Dr | closed CAN212_adequate, CAN212_adequate_intro | 3 |
| A.8/M.18.v1 | CAN-213 | A.8 | M | Epistemic overreach: a claim-level distinction lacks an adequate provenance path, is attributed to a node that | Definition | closed CAN213_overreach, CAN213_silent_lift, CAN213_silent_lift_is_overreach | 2 |
| A.5/M.05.v1 | CAN-214 | A.5 | M | Ess(d) = ⋂_{p∈Π(d)} V(p);  Π_{Δv}(d) = { p∈Π(d) : v∉V(p) };  Corollary (misrouted defeat under silent lift): i | Definition | closed CAN214_intersect, CAN214_Ess, CAN214_misrouted_defeat | 3 |
| A.8/M.19.v1 | CAN-215 | A.8 | M | P(D\|+) = 0.90(0.01) / [0.90(0.01)+0.09(0.99)] ≈ 0.0917;  diagram (y,K̃)+π+L → belief/action | Definition | closed CAN215_p_D_given_pos, CAN215_bayes_value | 2 |
| weld/M.14.v1 | CAN-216 | weld | M | C_D = G_D∘K* (worked identity); Retained-record route (proposition): if a supposedly fixed background corpus c | Dr | closed mrb_no_factorization_when_fiber_varies, CAN216_worked_no_factorization, CAN2xx_MethodNotion | 2 |
| A.8/E.02.v1 | CAN-217 | A.8 | E | (origin, procedure, dependence, checks, answerability) → ΔCr(p);  RPE = Cr(p\|E,R,A,O1) − Cr(p\|E,R,A,O2) | Definition | closed CAN217_RPE, CAN217_RPE_can_be_nonzero | 3 |
| weld/E.10.v1 | CAN-218 | weld | E | Bridge Burden: any inference from source metadata to a change in epistemic standing must identify the mediatin | Dr | closed CAN218_pedigree_substitution, CAN218_no_relation_is_substitution | 1 |
| EQ-015/E.14.v1 | CAN-219 | EQ-015 | E | No Bare Pedigree: a source label is epistemically incomplete reporting. The relevant object is the tuple of pr | Dr | closed CAN219_SourceReport, CAN219_label_underdetermines_report | 1 |
| A.8/E.03.v1 | CAN-220 | A.8 | E | Provenance Relevance Constraint: provenance may rationally alter epistemic standing insofar as it changes tota | Dr | closed CAN220_redescription_alone_cannot_change_standing | 1 |
| EQ-002/E.12.v1 | CAN-221 | EQ-002 | E | Friction, not magic: institutional certification has epistemic force insofar as institutions produce reliable  | Dr | closed CAN221_Friction, CAN221_all_false, CAN221_has_force, CAN221_certified_without_force | 1 |
| A.5/M.06.v1 | CAN-222 | A.5 | M | A≠x≠μ≠E≠M≠Bel≠p≠σ_K(p); A_i=A_j =/=> x_i=x_j; {BeliefStrength,BeliefDistribution,Auth,Pow,Val_E}(p) typed-dist | finite_diagnostic | definition CAN_222_root_non_collapse_chain, CAN_222_root_non_collapse_chain_witness | 9 |
| A.5/E.04.v1 | CAN-223 | A.5 | E | Role Separation: generation, truth, evidential support, reliability, understanding, possession, endorsement, a | Dr | closed CAN223_Role, CAN223_code, CAN223_role_separation | 1 |
| A.5/E.05.v1 | CAN-224 | A.5 | E | Representationality ≠ Selectivity | Dr | closed CAN224_Notion, CAN224_code, CAN224_non_collapse | 1 |
| A.5/E.06.v1 | CAN-225 | A.5 | E | §8: Exposure ≠ felt intensity ≠ retention ≠ improvement. §11: external pattern≠meaning; meaning≠explicit namin | Open | closed CAN225_Notion, CAN225_code, CAN225_non_collapse, CAN225_H6_no_automatic_improvement_Open | 3 |
| A.5/E.07.v1 | CAN-226 | A.5 | E | EMG-15: order≠rhythm, repetition≠rhythm, rhythm≠meaning, rhythm≠retention. EMG-20: release≠transformation, int | Dr | closed CAN226_Notion, CAN226_code, CAN226_non_collapse | 4 |
| A.5/E.08.v1 | CAN-227 | A.5 | E | successful adaptation = mental health  [explicitly REJECTED] | Dr | closed CAN227_Notion, CAN227_code, CAN227_non_collapse | 1 |
| EQ-015/E.15.v1 | CAN-228 | EQ-015 | E | M_A[n]≠θ(E[n]); S_{A,t+1}≠S_{A,t} is admissible and expected; reachable(H)=1 =/=> Acc(H\|Q) high; wholesome=/=t | Dr | closed CAN228_Notion, CAN228_code, CAN228_non_collapse | 9 |
| A.5/E.09.v1 | CAN-229 | A.5 | E | usable ≠ true;  T_U down =/=> W(H) up =/=> truth | untagged | closed CAN229_Notion, CAN229_code, CAN229_usable_ne_true, CAN229_falling_TU_does_not_force_rising_warrant | 2 |
| A.5/M.07.v1 | CAN-230 | A.5 | M | Credit != EpistemicValue | untagged | closed CAN230_credit_not_epistemic_value | 1 |
| A.5/M.08.v1 | CAN-231 | A.5 | M | Friction != Fellowship | untagged | closed CAN231_friction_not_fellowship | 1 |
| A.5/M.09.v1 | CAN-232 | A.5 | M | SelfExperience != GeneralEvidence | untagged | closed CAN232_self_experience_not_general_evidence | 1 |
| A.5/M.10.v1 | CAN-233 | A.5 | M | PositionalAccess != PopulationAuthority | untagged | closed CAN233_positional_access_not_population_authority | 1 |
| A.5/M.11.v1 | CAN-234 | A.5 | M | CommunityTrust != Representativeness | untagged | closed CAN234_community_trust_not_representativeness | 1 |
| A.5/M.12.v1 | CAN-235 | A.5 | M | DVP =/=> K2 | untagged | closed CAN235_dvp_not_k2 | 3 |
| A.5/M.13.v1 | CAN-236 | A.5 | M | ManyModels =/=> Independence | untagged | closed CAN236_many_models_not_independence | 1 |
| A.5/M.14.v1 | CAN-237 | A.5 | M | MechanicalValidity != SemanticValidity | untagged | closed CAN237_mechanical_not_semantic_validity | 3 |
| A.5/M.15.v1 | CAN-238 | A.5 | M | SourceExistence != ClaimSupport | untagged | closed CAN238_source_existence_not_claim_support | 2 |
| A.5/M.16.v1 | CAN-239 | A.5 | M | Friendship != IndependentEvidence | untagged | closed CAN239_friendship_not_independent_evidence | 1 |
| A.5/M.17.v1 | CAN-240 | A.5 | M | Correspondence != PeerReview | untagged | closed CAN240_correspondence_not_peer_review | 1 |
| A.5/M.18.v1 | CAN-241 | A.5 | M | IntellectualAffinity != Truth | untagged | closed CAN241_intellectual_affinity_not_truth | 1 |
| A.5/M.19.v1 | CAN-242 | A.5 | M | ActivationAction != CreditEvent | untagged | closed CAN242_activation_action_not_credit_event | 1 |
| A.5/M.20.v1 | CAN-243 | A.5 | M | RawSpeed(down) =/=> V_C(down) | untagged | closed CAN243_rawspeed_not_vc | 1 |
| A.5/M.21.v1 | CAN-244 | A.5 | M | L_H != Truth, L_V != Truth | untagged | closed CAN244_lh_lv_not_truth | 1 |
| EQ-015/M.12.v1 | CAN-245 | EQ-015 | M | M_A[n] != theta(E) | untagged | closed CAN245_mission_stepper_not_theta | 1 |
| A.5/M.22.v1 | CAN-246 | A.5 | M | MultiAIConsensus =/=> GeographicCompleteness | untagged | closed CAN246_multiai_consensus_not_geographic_completeness | 2 |
| A.5/M.23.v1 | CAN-247 | A.5 | M | DoubleBlind = Bonus; DoubleBlind != Requirement | untagged | closed CAN247_doubleblind_bonus_not_requirement | 1 |
| A.5/M.24.v1 | CAN-248 | A.5 | M | K2,Global != K2,Thai | untagged | closed CAN248_k2global_not_k2thai | 2 |
| A.5/M.25.v1 | CAN-249 | A.5 | M | InterventionCreator != SoleEvaluator | untagged | closed CAN249_interventioncreator_not_soleevaluator | 2 |
| A.5/M.26.v1 | CAN-250 | A.5 | M | PracticeExperience != PopulationEvidence | untagged | closed CAN250_practiceexperience_not_populationevidence | 1 |
| A.5/M.27.v1 | CAN-251 | A.5 | M | A_t != C_t^scholarly | untagged | closed CAN251_at_not_ctscholarly | 1 |
| A.5/M.28.v1 | CAN-252 | A.5 | M | M_attention != M_truth, M_attention != M_K2 | untagged | closed CAN252_mattention_not_mtruth_mk2 | 1 |
| A.5/M.29.v1 | CAN-253 | A.5 | M | NoHumanAvailable =/=> ResearchStop | untagged | closed CAN253_nohuman_not_researchstop | 1 |
| A.5/M.30.v1 | CAN-254 | A.5 | M | Prestige =/=> APCApproval; APCApproval => FieldFit + CreditYield + BudgetFit | finite_diagnostic | closed CAN254_prestige_not_apc_approval, CAN254_approval_requires | 1 |
| A.5/M.31.v1 | CAN-255 | A.5 | M | DisclosurePenalty =/=> Concealment; DisclosurePenalty => BetterProvenance + BetterHumanDefence + VenueFit | finite_diagnostic | closed CAN255_disclosurepenalty_not_concealment, CAN255_penalty_requires | 1 |
| A.5/M.32.v1 | CAN-256 | A.5 | M | AIContribution != EpistemicResponsibility | untagged | closed CAN256_aicontribution_not_epistemicresponsibility | 2 |
| EQ-015/H.36.v1 | CAN-257 | EQ-015 | H | M0: context-only state change; M1: sparse but not low-rank update; M2: low-rank factorized update (= CAN-054's | Open | wrapped_related EQ_015__H_36_v1_reads | 6 |
| EQ-015/H.37.v1 | CAN-258 | EQ-015 | H | W_n=(F_n,A_n^agency,M_n^meaning,R_n^relation,C_n^competence,Q_n^repair); C_mal[n]=rig(a_n)·gen(a_n)·mis(a_n)·l | Definition | wrapped_related EQ_015__H_37_v1_reads | 2 |
| weld/S.10.v1 | CAN-115-SPLIT-01 | weld | S | s(x,t) ∈ R^n | Definition | not_formalisable | 1 |
| weld/S.11.v1 | CAN-115-SPLIT-02 | weld | S | V(x,t) = Φ(s(x,t)) | Definition | not_formalisable | 1 |
| weld/S.12.v1 | CAN-115-SPLIT-03 | weld | S | τ ∂t j + j = −D∇s | Definition | not_formalisable | 1 |
| weld/S.13.v1 | CAN-115-SPLIT-04 | weld | S | ∂t s = −∇·j − Γ(s) + Senv | Definition | not_formalisable | 1 |
| weld/S.14.v1 | CAN-115-SPLIT-05 | weld | S | ∂t s = Lτ s | Definition | not_formalisable | 1 |
| weld/S.15.v1 | CAN-115-SPLIT-06 | weld | S | s(t) = Σ_k c_k e^{−λ_k t} r_k | Definition | not_formalisable | 1 |
| weld/S.16.v1 | CAN-115-SPLIT-07 | weld | S | L = [[−α, ε], [ε, −β]], α, β > 0 | Dr | definition weld_S16_L, weld_S16_valid | 1 |
| weld/S.17.v1 | CAN-115-SPLIT-08 | weld | S | λ± = −(α+β)/2 ± sqrt( ((α−β)/2)^2 + ε^2 ) | Dr | not_formalisable | 1 |
| weld/S.18.v1 | CAN-115-SPLIT-09 | weld | S | Γ ↑ (increase dissipation) | Dr | definition weld__S_18_v1_lever | 1 |
| weld/S.19.v1 | CAN-115-SPLIT-10 | weld | S | Senv ↓ (reduce load) | Dr | definition weld__S_19_v1_lever | 1 |
| weld/S.20.v1 | CAN-115-SPLIT-11 | weld | S | Lij ↓ (limit propagation) | Dr | definition weld__S_20_v1_lever | 1 |
| weld/S.21.v1 | CAN-115-SPLIT-12 | weld | S | τ ↓ (shorten memory) | Dr | definition weld__S_21_v1_lever | 1 |
| weld/S.22.v1 | CAN-115-SPLIT-13 | weld | S | LR = DW − W (forced Laplacian); A := LR + Γ; s[n+1] = s[n] + dt(−A s[n] + J) | Definition | closed CAN_115_degree, CAN_115_L_R, CAN_115_A, CAN_115_step, CAN_115_par_stepper_moves_state | 1 |
| weld/S.23.v1 | CAN-115-SPLIT-14 | weld | S | s* = A^{-1}J is the unique fixed point independent of u; ∥s[n]−s*∥ ≤ ρ^{n−nB}∥s[nB]−s*∥ after the last nonzero | Dr | definition | 1 |
| weld/S.24.v1 | CAN-115-SPLIT-15 | weld | S | \|u_i[n]\| = dt[(γ_i+D_i)(s*_i−θ) − Σ_{k≠i} W_ik(s*_k−s_k[n])], converging to a rate F_i^∞ > 0 whenever s*_i ≥ θ | Dr | definition | 1 |
| weld/S.25.v1 | CAN-115-SPLIT-16 | weld | S | s*'_i = s*_i / (1+ΔB_ii) with B = A^{-1} (Sherman–Morrison); any θ < s*_i is reached below with Δ > Δ* = (s*_i | Dr | definition | 1 |
| weld/S.26.v1 | CAN-115-SPLIT-17 | weld | S | s_j ≳ (J_j + W_ij·s̄_i)/(γ_j+D_j), with s̄_i an explicit increasing function of node i's own inflow, under per | Dr | definition | 1 |
| weld/S.27.v1 | CAN-116-SPLIT-01 | weld | S | M(t') ∈ M | Ax | definition CAN_116_ManifestedRecord | 1 |
| weld/S.28.v1 | CAN-116-SPLIT-02 | weld | S | A_i(t') ⊆ M(t') | Ax | definition CAN_116_ManifestedRecord, CAN_116_is_agency | 1 |
| weld/S.29.v1 | CAN-116-SPLIT-03 | weld | S | G(t') := {A_1(t'), …, A_N(t')} ⊆ M(t') | Ax | closed CAN_116_ManifestedRecord, CAN_116_is_agency, CAN_116_is_collective, CAN_116_axioms_satisfiable | 1 |
| weld/S.30.v1 | CAN-116-SPLIT-04 | weld | S | R ∈ R_adm(t') | Ax | open_prop weld_S30_hyp | 1 |
| EQ-015/S.13.v1 | CAN-117-SPLIT-01 | EQ-015 | S | R := (T_R, I_R) | Ax | definition CAN_117_Record, CAN_117_Regime | 1 |
| EQ-015/S.14.v1 | CAN-117-SPLIT-02 | EQ-015 | S | M(t' + Δt') = T_R(M(t')) | Definition | definition CAN_117_Record, CAN_117_Regime, CAN_117_record_updates | 1 |
| EQ-015/S.15.v1 | CAN-117-SPLIT-03 | EQ-015 | S | A(t' + Δt') ⊆ I_R(A(t'), M(t')) | Definition | definition CAN_117_Record, CAN_117_Regime, CAN_117_agency_updates | 1 |
| EQ-015/S.16.v1 | CAN-117-SPLIT-04 | EQ-015 | S | Etic(A; t') := ∃ R_A(t') ∈ R_adm(t') : A ⊆ M(t'), M(t'+Δt') = T_{R_A}(M(t')), A(t'+Δt') ⊆ I_{R_A}(A(t'), M(t') | Definition | closed CAN_117_Record, CAN_117_Regime, CAN_117_record_updates, CAN_117_agency_updates, CAN_117_Etic, CAN_117_e | 1 |
| EQ-015/S.17.v1 | CAN-118-SPLIT-01 | EQ-015 | S | V_{A,R}(M) ≥ 0 | Definition | definition CAN_118_non_increasing | 1 |
| EQ-015/S.18.v1 | CAN-118-SPLIT-02 | EQ-015 | S | τ_c'(R) > 0 | Definition | definition | 1 |
| EQ-015/S.19.v1 | CAN-118-SPLIT-03 | EQ-015 | S | Δ_spec(R) > 0 | Definition | definition | 1 |
| EQ-015/S.20.v1 | CAN-118-SPLIT-04 | EQ-015 | S | Ethical(A) ⇔ ∃ Choice(A → R_A) : d/dt' V_{A,R_A}(M(t')) ≤ 0 ∧ τ_c'(R_A) > 0 ∧ Δ_spec(R_A) > 0 | Definition | closed CAN_118_non_increasing, CAN_118_Ethical, CAN_118_ethical_satisfiable | 1 |
| EQ-015/S.21.v1 | CAN-118-SPLIT-05 | EQ-015 | S | V̇⁺ := max(dV/dt', 0) | Definition | wrapped_related EQ_015__S_21_v1_reads | 1 |
| EQ-015/S.22.v1 | CAN-118-SPLIT-06 | EQ-015 | S | Eth_ind(A) ⇔ d/dt' V_{A,R_A} ≤ 0 ∧ Δ_spec(R_A) > 0 | Definition | wrapped_related EQ_015__S_22_v1_reads | 1 |
| EQ-015/S.23.v1 | CAN-119-SPLIT-01 | EQ-015 | S | M(t') = M_0 φ_0 + Σ_k a_k(t') φ_k | Definition | wrapped_related EQ_015__S_23_v1_reads | 1 |
| EQ-015/S.24.v1 | CAN-119-SPLIT-02 | EQ-015 | S | S_A(R) ⊆ span{φ_k} | Definition | wrapped_related EQ_015__S_24_v1_reads | 1 |
| EQ-015/S.25.v1 | CAN-119-SPLIT-03 | EQ-015 | S | P_{S_A(R)} : M → S_A(R) | Definition | wrapped_related EQ_015__S_25_v1_reads | 1 |
| EQ-015/S.26.v1 | CAN-119-SPLIT-04 | EQ-015 | S | limsup_{n→∞} ‖P_{S_A(R_A)} M(t'+n)‖² > 0 | Definition | wrapped_related EQ_015__S_26_v1_reads | 1 |
| EQ-015/S.27.v1 | CAN-119-SPLIT-05 | EQ-015 | S | lim_{n→∞} ‖P_{S_A(R_A)} M(t'+n)‖² = 0 | Definition | wrapped_related EQ_015__S_27_v1_reads | 1 |
| EQ-015/S.28.v1 | CAN-119-SPLIT-06 | EQ-015 | S | V_G(M) := Σ_{i=1}^N w_i V_{A_i,R_i}(M),  w_i > 0 | Definition | wrapped_related EQ_015__S_28_v1_reads | 1 |
| EQ-015/S.29.v1 | CAN-119-SPLIT-07 | EQ-015 | S | Eth_col(G) ⇔ d/dt' V_G(M) ≤ 0 ∧ min_i Δ_spec(R_i) > 0 | Definition | definition CAN_119_min_margin, CAN_119_Eth_col | 1 |
| EQ-015/S.30.v1 | CAN-119-SPLIT-08 | EQ-015 | S | Conf_{ind→col} ⇔ d/dt' V_{A_i} ≤ 0 ∧ d/dt' V_G > 0 | Definition | definition CAN_119_Conf_ind_to_col | 1 |
| EQ-015/S.31.v1 | CAN-119-SPLIT-09 | EQ-015 | S | Conf_{col→ind} ⇔ d/dt' V_G ≤ 0 ∧ ∃i: d/dt' V_{A_i} > 0 | Definition | definition CAN_119_Conf_col_to_ind | 1 |
| EQ-015/S.32.v1 | CAN-119-SPLIT-10 | EQ-015 | S | Δ_spec(R_i ∪ R_j) ≤ 0 | Definition | wrapped_related EQ_015__S_32_v1_reads | 1 |
| EQ-015/S.33.v1 | CAN-119-SPLIT-11 | EQ-015 | S | ∃ i,j : C_{A_i,R_i} ≫ C_{A_j,R_j} | Definition | closed CAN_119_structural_injustice, CAN_119_structural_injustice_satisfiable | 1 |
| weld/S.31.v1 | CAN-120-SPLIT-01 | weld | S | χ_causal(R) := 1[τ_c'(R) ≈ 0] | Definition | definition weld_S31_chi_causal | 1 |
| weld/S.32.v1 | CAN-120-SPLIT-02 | weld | S | χ_spec(R) := 1[Δ_spec(R) ≤ 0] | Definition | definition weld_S32_chi_spec | 1 |
| weld/S.33.v1 | CAN-120-SPLIT-03 | weld | S | C_{A,R}[t1,t2] := ∫_{t1}^{t2} [ α V̇⁺_{A,R}(M(t')) + β χ_causal(R) + γ χ_spec(R) ] dt',  α,β,γ > 0 | Definition | definition CAN_120_moral_cost | 1 |
| weld/S.34.v1 | CAN-120-SPLIT-04 | weld | S | Resp(A) ≡ C_{A,R_A} | Definition | definition CAN_120_moral_cost, CAN_120_Responsibility | 1 |
| weld/S.35.v1 | CAN-120-SPLIT-05 | weld | S | C_G[t1,t2] := Σ_{i=1}^N w_i C_{A_i,R_i}[t1,t2] | Definition | definition weld_S35_C_G | 1 |
| weld/S.36.v1 | CAN-120-SPLIT-06 | weld | S | lim_{T→∞} C_{A,R}[0,T] = ∞ | Definition | not_formalisable | 1 |
| weld/S.37.v1 | CAN-120-SPLIT-07 | weld | S | lim_{T→∞} C_{A,R}[0,T] = ∞ ⇒ lim_{n→∞} ‖P_{S_A} M(t'+n)‖² = 0 | Dr | definition | 1 |
| weld/S.38.v1 | CAN-120-SPLIT-08 | weld | S | Eth(A) ⇔ C_{A,R_A}[t,∞) = 0 | Definition | not_formalisable | 1 |
| weld/S.39.v1 | CAN-120-SPLIT-09 | weld | S | R* ∈ argmin_{R∈R_adm} C_{system,R}  s.t.  τ_c'(R) > 0, Δ_spec(R) > 0 | Definition | definition weld_S39_R_star | 1 |
| weld/S.40.v1 | CAN-120-SPLIT-10 | weld | S | ¬∃ Choice(A → R_A) ⇒ no ethics attribution, no responsibility attribution, and no moral cost attribution | Definition | closed CAN_120_choice_gate, CAN_120_choice_gate_satisfiable | 1 |
| weld/S.41.v1 | CAN-120-SPLIT-11 | weld | S | ∀ R ∈ R_available(t') : ¬[τ_c'(R) > 0 ∧ Δ_spec(R) > 0] ∨ C_{A,R}[t',t'+T] > 0,  for all T > 0 | Definition | closed CAN_120_Tragic, CAN_120_tragic_satisfiable | 1 |
| weld/S.42.v1 | CAN-120-SPLIT-12 | weld | S | R†_A ∈ argmin_{R∈R_available(t')} C_{A,R}[t',t'+T]  s.t.  τ_c'(R) > 0, Δ_spec(R) > 0 | Definition | definition weld_S42_R_tragic_min | 1 |
| A.5/S.04.v1 | CAN-121-SPLIT-01 | A.5 | S | x' = F(x, C) | Definition | definition A5_S04_v1_dynamics | 1 |
| A.5/S.05.v1 | CAN-121-SPLIT-02 | A.5 | S | x(t) ∈ V,  where V ⊆ S is the viable region of the state space S, for all times in the interval of observation | Definition | definition A5_S05_v1_viable_at | 1 |
| A.5/S.06.v1 | CAN-121-SPLIT-03 | A.5 | S | d/dt [ d(x(t), V) ] < 0  (in expectation), where d(x,V) is the distance between state x and the viable region  | Definition | definition A5_S06_v1_persistence_regulation | 1 |
| A.5/S.07.v1 | CAN-121-SPLIT-04 | A.5 | S | C_{t+1} = G(x_t, C_t) | Definition | definition A5_S07_v1_constraint_evolution | 1 |
| A.5/S.08.v1 | CAN-121-SPLIT-05 | A.5 | S | ∂C/∂x ≠ 0 | Definition | definition CAN_121_StateConstraintCoupling | 1 |
| A.5/S.09.v1 | CAN-121-SPLIT-06 | A.5 | S | ∂Tp/∂C · ∂C/∂x > 0,  where Tp is the expected persistence time of the system within the viable region V | Definition | definition A5_S09_v1_agency_condition | 1 |
| A.5/S.10.v1 | CAN-121-SPLIT-07 | A.5 | S | ∂C/∂x = 0 | Definition | definition CAN_121_ProtoAgency | 1 |
| A.5/S.11.v1 | CAN-121-SPLIT-08 | A.5 | S | C_{t+1} = G(x_t, C_t, H_t),  where H_t is the system's interaction history | Definition | definition CAN_121_L3_history | 1 |
| A.5/S.12.v1 | CAN-121-SPLIT-09 | A.5 | S | C_{t+1} = G(x_t, C_t, x̂_{t+k}),  where x̂_{t+k} represents predicted future states | Definition | definition CAN_121_L4_predictive | 1 |
| A.5/S.13.v1 | CAN-121-SPLIT-10 | A.5 | S | G_{t+1} = M(G_t) | Definition | closed CAN_121_ProtoAgency, CAN_121_StateConstraintCoupling, CAN_121_L5_meta, CAN_121_hierarchy_levels_satisfi | 1 |
| weld/S.43.v1 | CAN-122-SPLIT-01 | weld | S | Bel_{i,p,n} = Rel_B(a_i, p \| x_i, mu_i, E_i, M_i, Theta_i, I_i, S_i^active, c_i) | Definition | definition CAN_122_BeliefVector, CAN_122_Bel | 1 |
| weld/S.44.v1 | CAN-122-SPLIT-02 | weld | S | b_{i,p,n} = (e_{i,p}, c_{i,p}, s_{i,p}, a_{i,p}, eta_{i,p}, g_{i,p}, r_{i,p}) | Definition | definition CAN_122_BeliefVector | 1 |
| weld/S.45.v1 | CAN-122-SPLIT-03 | weld | S | b_{i,p,n+1} = U_B(b_{i,p,n}, Ev_{i,p}, M_i, mu_i, E_i, Theta_i, I_i, Trust_i, Affect_i, Utility_i, Repetition_ | Definition | definition CAN_122_BeliefVector, CAN_122_update | 1 |
| weld/S.46.v1 | CAN-122-SPLIT-04 | weld | S | Bel_{g,d,n}^{(l)}(p) = Stabilize_B({b_{i,p,n}}_{i in G}, C_B) | Definition | closed CAN_122_BeliefVector, CAN_122_group_belief, CAN_122_sigma_K, CAN_122_belief_scale_nonpromotion | 1 |
| weld/S.47.v1 | CAN-123-SPLIT-01 | weld | S | Z_{G,t} := < {Z_{A_i,t}}_{i=1}^n, T_{G,t}, A_{G,t}, C_{G,t} > | Definition | definition CAN_123_GroupState | 1 |
| weld/S.48.v1 | CAN-123-SPLIT-02 | weld | S | S_{G,t} := q_{sem,G,Omega_{G,t}}(Z_{G,t}) | Definition | definition CAN_123_GroupState, CAN_123_group_readout | 1 |
| weld/S.49.v1 | CAN-123-SPLIT-03 | weld | S | m^G_{t+1}(e) = rho_G * m^G_t(e) + sigma_{G,t}(e) | Definition | closed CAN_123_memory_update, CAN_123_memory_update_zero_signal | 1 |
| weld/S.50.v1 | CAN-123-SPLIT-04 | weld | S | W_{G,t}(H) = W_G(R_{G,<=t}, independence, defects, calibration, objection channels) | Definition | definition weld_S50_W | 1 |
| A.5/S.14.v1 | CAN-128-SPLIT-01 | A.5 | S | Πlive_{A,t}(g) ⊆ Πfeas_{A,t}(g) ⊆ Πphys_t(g), π^choice ∈ Πlive_{A,t}(g) | Definition | definition CAN_128_live_full_nesting, CAN_128_is_valid_choice | 1 |
| A.5/S.15.v1 | CAN-128-SPLIT-02 | A.5 | S | L_{A,t}(g) = {(π, κ_{A,t}(π\|g)) : π ∈ Πfeas_{A,t}(g)} | Definition | definition CAN_128_live_field | 1 |
| A.5/S.16.v1 | CAN-128-SPLIT-03 | A.5 | S | Πlive_{A,t}(g) = {π : κ_{A,t}(π\|g) ≥ τlive} | Definition | definition CAN_128_Pi_live | 1 |
| A.5/S.17.v1 | CAN-128-SPLIT-04 | A.5 | S | π^choice_{A,t} ∈ Πlive_{A,t}(g) | Definition | definition A5_S17_v1_choice_membership | 1 |
| A.5/S.18.v1 | CAN-128-SPLIT-05 | A.5 | S | π^act ≠ π^choice possible; Yobs = Oq(H0:T); Yobs ≠ H0:T | Definition | definition CAN_128_enactment_may_differ_from_choice, CAN_128_observation_loses_information | 1 |
| A.5/S.19.v1 | CAN-128-SPLIT-06 | A.5 | S | possible ≠ feasible ≠ live ≠ chosen ≠ enacted ≠ observed | Definition | definition CAN_128_six_level_non_collapse | 1 |
| A.5/S.20.v1 | CAN-128-SPLIT-07 | A.5 | S | Πlive_{A,t}(g) ⊆ Πfeas_A(g; h, z, T, B) | Definition | definition A5_S20_v1_refinement | 1 |
| EQ-015/S.34.v1 | CAN-129-SPLIT-01 | EQ-015 | S | objective possibility ≠ structural feasibility | Definition | closed CAN_129_NCItem, CAN_129_index, CAN_129_index_injective | 1 |
| EQ-015/S.35.v1 | CAN-129-SPLIT-02 | EQ-015 | S | feasibility ≠ live possibility | Definition | wrapped_related EQ_015__S_35_v1_reads | 1 |
| EQ-015/S.36.v1 | CAN-129-SPLIT-03 | EQ-015 | S | live possibility ≠ stated preference | Definition | wrapped_related EQ_015__S_36_v1_reads | 1 |
| EQ-015/S.37.v1 | CAN-129-SPLIT-04 | EQ-015 | S | stated preference ≠ free consent | Definition | wrapped_related EQ_015__S_37_v1_reads | 1 |
| EQ-015/S.38.v1 | CAN-129-SPLIT-05 | EQ-015 | S | choice ≠ enactment | Definition | wrapped_related EQ_015__S_38_v1_reads | 1 |
| EQ-015/S.39.v1 | CAN-129-SPLIT-06 | EQ-015 | S | enactment ≠ evaluator-visible agency | Definition | wrapped_related EQ_015__S_39_v1_reads | 1 |
| EQ-015/S.40.v1 | CAN-129-SPLIT-07 | EQ-015 | S | option count ≠ effective agency | Definition | wrapped_related EQ_015__S_40_v1_reads | 1 |
| EQ-015/S.41.v1 | CAN-129-SPLIT-08 | EQ-015 | S | accessibility ≠ warrant | Definition | wrapped_related EQ_015__S_41_v1_reads | 1 |
| EQ-015/S.42.v1 | CAN-129-SPLIT-09 | EQ-015 | S | resonance ≠ consent | Definition | wrapped_related EQ_015__S_42_v1_reads | 1 |
| EQ-015/S.43.v1 | CAN-129-SPLIT-10 | EQ-015 | S | repetition ≠ legitimacy | Definition | wrapped_related EQ_015__S_43_v1_reads | 1 |
| EQ-015/S.44.v1 | CAN-129-SPLIT-11 | EQ-015 | S | retention ≠ improvement | Definition | wrapped_related EQ_015__S_44_v1_reads | 1 |
| EQ-015/S.45.v1 | CAN-129-SPLIT-12 | EQ-015 | S | norm conformity ≠ absence of agency | Definition | wrapped_related EQ_015__S_45_v1_reads | 1 |
| EQ-015/S.46.v1 | CAN-129-SPLIT-13 | EQ-015 | S | resistance to norms ≠ agency by definition | Definition | wrapped_related EQ_015__S_46_v1_reads | 1 |
| EQ-015/S.47.v1 | CAN-129-SPLIT-14 | EQ-015 | S | meaning-shaping ≠ domination | Definition | wrapped_related EQ_015__S_47_v1_reads | 1 |
| EQ-015/S.48.v1 | CAN-129-SPLIT-15 | EQ-015 | S | live-field narrowing ≠ structural violence without causal and normative conditions | Definition | wrapped_related EQ_015__S_48_v1_reads | 1 |
| EQ-015/S.49.v1 | CAN-129-SPLIT-16 | EQ-015 | S | AI influence ≠ manipulation by definition | Definition | wrapped_related EQ_015__S_49_v1_reads | 1 |
| EQ-015/S.50.v1 | CAN-129-SPLIT-17 | EQ-015 | S | coupled performance ≠ Human Return | Definition | wrapped_related EQ_015__S_50_v1_reads | 1 |
| EQ-015/S.51.v1 | CAN-132-SPLIT-01 | EQ-015 | S | p*_{A,g} = max_{π∈Πfeas_A(g)} Pr(Rg ∩ Dg ∩ Xg ∩ Fg) | Definition | definition CAN_132_p_star, CAN_132_p_star_upper_bound | 1 |
| EQ-015/S.52.v1 | CAN-132-SPLIT-02 | EQ-015 | S | p*_{A,g}(h,z;T,B,P) := max_{π∈Πwit_A(g;h,z,T,B)} Pr^π_P(Rg ∩ Dg ∩ Xg ∩ Fg), with p*_{A,g} := 0 when the set is | Definition | wrapped_related EQ_015__S_52_v1_reads | 1 |
| EQ-015/S.53.v1 | CAN-132-SPLIT-03 | EQ-015 | S | p*_A = (p*_{A,g})_{g∈G}, C^α_A = {g : p*_{A,g} ≥ α} | Definition | wrapped_related EQ_015__S_53_v1_reads | 1 |
| EQ-015/S.54.v1 | CAN-132-SPLIT-04 | EQ-015 | S | A^corr_A(h,z;T,B,P,w) := Σ_g w_g p*_{A,g} ∈ [0,1] | Definition | wrapped_related EQ_015__S_54_v1_reads | 1 |
| EQ-015/S.55.v1 | CAN-132-SPLIT-05 | EQ-015 | S | p_{A,g}(π) = r·d·x·f, with r = Pr(Rg), d = Pr(Dg\|Rg), x = Pr(Xg\|Rg,Dg), f = Pr(Fg\|Rg,Dg,Xg) | Definition | wrapped_related EQ_015__S_55_v1_reads | 1 |
| EQ-015/S.56.v1 | CAN-133-SPLIT-01 | EQ-015 | S | p*(2)_{A,g} := max_{z∈Jfeas} p*_{A,g}(h,z;T,B,P) | Definition | definition CAN_133_p_star2 | 1 |
| EQ-015/S.57.v1 | CAN-133-SPLIT-02 | EQ-015 | S | L^recoverable_A = max_{z∈Jfeas} A^corr_A(h,z) − A^corr_A(h,z0) | Definition | closed CAN_133_recoverable_gap, CAN_133_recoverable_gap_nonneg | 1 |
| EQ-015/S.58.v1 | CAN-136-SPLIT-01 | EQ-015 | S | Yobs = calm ∧ p*wit = low ∧ F = blocked | Definition | closed CAN_136_Observation, CAN_136_ChannelStatus, CAN_136_pseudo_peace_signature, CAN_136_pseudo_peace_satisf | 1 |
| EQ-015/S.59.v1 | CAN-137-SPLIT-01 | EQ-015 | S | Potential ≠ exercised ≠ observed | Definition | closed CAN_137_Distinction, CAN_137_index, CAN_137_index_injective | 1 |
| EQ-015/S.60.v1 | CAN-137-SPLIT-02 | EQ-015 | S | Declared set ≠ witnessed set | Definition | wrapped_related EQ_015__S_60_v1_reads | 1 |
| EQ-015/S.61.v1 | CAN-137-SPLIT-03 | EQ-015 | S | Layer 1 ≠ layer 2 | Definition | wrapped_related EQ_015__S_61_v1_reads | 1 |
| EQ-015/S.62.v1 | CAN-137-SPLIT-04 | EQ-015 | S | Task potential ≠ aggregate potential | Definition | wrapped_related EQ_015__S_62_v1_reads | 1 |
| EQ-015/S.63.v1 | CAN-137-SPLIT-05 | EQ-015 | S | Feasible ≠ permitted | Definition | wrapped_related EQ_015__S_63_v1_reads | 1 |
| EQ-015/S.64.v1 | CAN-137-SPLIT-06 | EQ-015 | S | Diagnosis of compression ≠ attribution of responsibility | Definition | wrapped_related EQ_015__S_64_v1_reads | 1 |
| EQ-015/S.65.v1 | CAN-137-SPLIT-07 | EQ-015 | S | Recoverable gap ≠ accumulated loss | Definition | wrapped_related EQ_015__S_65_v1_reads | 1 |
| EQ-015/W.20.v1 | CAN-142-SPLIT-01 | EQ-015 | W | B^RB_t = N^RB_t q^RB_t | Definition | closed CAN_142_B_RB, CAN_142_B_RB_identity | 1 |
| EQ-015/W.21.v1 | CAN-142-SPLIT-02 | EQ-015 | W | B_dot^RB_t / B^RB_t = N_dot^RB_t / N^RB_t + q_dot^RB_t / q^RB_t | Definition | wrapped_related EQ_015__W_21_v1_reads | 1 |
| EQ-015/W.22.v1 | CAN-142-SPLIT-03 | EQ-015 | W | M_t = (K^M_t)^kappa (A^AI_t)^alpha (B^RB_t)^beta | Definition | definition CAN_142_M_index | 1 |
| EQ-015/W.23.v1 | CAN-142-SPLIT-04 | EQ-015 | W | rho = (sigma - 1) / sigma | Definition | definition CAN_142_rho_CES | 1 |
| EQ-015/W.24.v1 | CAN-142-SPLIT-05 | EQ-015 | W | s^L_t = (omega_H H_t^rho) / (omega_H H_t^rho + omega_M M_t^rho) | Definition | definition CAN_142_labour_share | 1 |
| EQ-015/W.25.v1 | CAN-143-SPLIT-01 | EQ-015 | W | L_t = < L^task_t, L^income_t, L^bottleneck_t, L^bargain_t > | Definition | definition CAN_143_LabourCentrality, CAN_143_mk_labour_centrality | 1 |
| EQ-015/W.26.v1 | CAN-144-SPLIT-01 | EQ-015 | W | q_t = o_t + tau_t(1 - o_t) = 1 - (1 - o_t)(1 - tau_t) | Definition | closed CAN_144_convex_combine, CAN_144_convex_combine_identity, CAN_144_q_t | 1 |
| EQ-015/W.27.v1 | CAN-144-SPLIT-02 | EQ-015 | W | Gamma_t = s^L_t + q_t(1 - s^L_t) | Definition | closed CAN_144_convex_combine, CAN_144_convex_combine_identity, CAN_144_Gamma_t | 1 |
| EQ-015/W.28.v1 | CAN-144-SPLIT-03 | EQ-015 | W | q^min_t = (Gamma_bar - s^L_t) / (1 - s^L_t) | Definition | definition CAN_144_q_min, CAN_144_citizen_claim_threshold_identity | 1 |
| EQ-015/W.29.v1 | CAN-144-SPLIT-04 | EQ-015 | W | D^rent_(i,t) = (Rent^(AI,out)_(i,t) - Rent^(AI,in)_(i,t)) / Y_(i,t) | Definition | wrapped_related EQ_015__W_29_v1_reads | 1 |
| EQ-015/W.30.v1 | CAN-144-SPLIT-05 | EQ-015 | W | Gamma^net_(i,t) = Gamma_(i,t) - D^rent_(i,t) | Definition | wrapped_related EQ_015__W_30_v1_reads | 1 |
| EQ-015/W.31.v1 | CAN-145-SPLIT-01 | EQ-015 | W | AD_t = C(Gamma^eff_t Y_t, m_t) + I_t + G_t + NX_t | Definition | definition CAN_145_AD | 1 |
| EQ-015/W.32.v1 | CAN-145-SPLIT-02 | EQ-015 | W | chi^dem_t = min{1, AD_t / Y_t} | Definition | closed CAN_145_chi_dem, CAN_145_chi_dem_le_one | 1 |
| EQ-015/W.33.v1 | CAN-145-SPLIT-03 | EQ-015 | W | Pi^M_t = chi^dem_t Y_t - Cost^M_t | Definition | definition CAN_145_Pi_M | 1 |
| EQ-015/W.34.v1 | CAN-146-SPLIT-01 | EQ-015 | W | W^M_(i,t+1) = (1 - delta_W) W^M_(i,t) + r^M_t W^M_(i,t) + s^(M,cap)_(i,t) + T^cap_(i,t) - Tax^cap_(i,t) | Definition | definition CAN_146_ownership_accumulate | 1 |
| EQ-015/W.35.v1 | CAN-146-SPLIT-02 | EQ-015 | W | o_t = ( sum_(i in B) W^M_(i,t) ) / ( sum_i W^M_(i,t) ) | Definition | definition CAN_146_ownership_share | 1 |
| EQ-015/W.36.v1 | CAN-146-SPLIT-03 | EQ-015 | W | current redistribution != future ownership reproduction | Definition | closed CAN_146_ownership_accumulate, CAN_146_ownership_share, CAN_146_redistribution_not_ownership_reproductio | 1 |
| A.5/W.04.v1 | CAN-147-SPLIT-01 | A.5 | W | B^scarce_(i,t) = (R^house_(i,t) + R^land_(i,t) + R^energy_(i,t) + DS_(i,t)) / Y_(i,t) | Definition | definition CAN_147_B_scarce | 1 |
| A.5/W.05.v1 | CAN-147-SPLIT-02 | A.5 | W | Gamma^eff_(i,t) = max{0, Gamma^net_(i,t) - B^scarce_(i,t)} | Definition | definition CAN_147_Gamma_eff | 1 |
| A.5/W.06.v1 | CAN-147-SPLIT-03 | A.5 | W | machine abundance != low rent burden != effective material freedom | Definition | closed CAN_147_Gamma_eff, CAN_147_abundance_not_low_burden_not_freedom | 1 |
| EQ-015/W.37.v1 | CAN-148-SPLIT-01 | EQ-015 | W | G^conv_(j,t)(e) = 1 - [ V_t(e \| -j) / V_t(e) ]_+ | Definition | definition CAN_148_G_conv | 1 |
| EQ-015/W.38.v1 | CAN-148-SPLIT-02 | EQ-015 | W | X_(i,t)(e; j) = clip( V_(i,t)(e \| -j) / V_(i,t)(e), 0, 1 ) | Definition | wrapped_related EQ_015__W_38_v1_reads | 1 |
| EQ-015/W.39.v1 | CAN-148-SPLIT-03 | EQ-015 | W | D_(i->j,t)(g) = sum_(e in E(g)) w_e(g) G^conv_(j,t)(e) [1 - X_(i,t)(e; j)] | Definition | definition CAN_148_G_conv, CAN_148_Dependency | 1 |
| EQ-015/W.40.v1 | CAN-148-SPLIT-04 | EQ-015 | W | Concentration != G^conv != D | Definition | closed CAN_148_G_conv, CAN_148_Dependency, CAN_148_concentration_not_dependency | 1 |
| EQ-015/W.41.v1 | CAN-148-SPLIT-05 | EQ-015 | W | concentration =/=> dependency =/=> agency loss | Definition | wrapped_related EQ_015__W_41_v1_reads | 1 |
| EQ-015/W.42.v1 | CAN-151-SPLIT-01 | EQ-015 | W | P^H_t = [ (Gamma^eff_t)^theta_Gamma (A^corr_(H,t))^theta_A (Lambda^live_(H,t))^theta_Lambda (r^H_t)^theta_R (S | Definition | definition CAN_151_P_H_index | 1 |
| EQ-015/W.43.v1 | CAN-151-SPLIT-02 | EQ-015 | W | P_dot^H_t / P^H_t = theta_Gamma (Gamma_dot^eff_t/Gamma^eff_t) + theta_A (A_dot^corr_(H,t)/A^corr_(H,t)) + thet | Definition | wrapped_related EQ_015__W_43_v1_reads | 1 |
| EQ-015/W.44.v1 | CAN-151-SPLIT-03 | EQ-015 | W | ... + theta_S (S_dot^H_t/S^H_t) + theta_X (X_dot^H_t/X^H_t) - theta_D (D_dot^H_t/(1+D^H_t)) | Definition | wrapped_related EQ_015__W_44_v1_reads | 1 |
| EQ-015/W.45.v1 | CAN-151-SPLIT-04 | EQ-015 | W | Y_dot_t > 0  =/=>  P_dot^H_t > 0 | Definition | definition CAN_151_output_rise_not_position_rise | 1 |
| EQ-015/W.46.v1 | CAN-151-SPLIT-05 | EQ-015 | W | AWA_t = < Y(up), Gamma^eff adequate, O^H(down), X^H(down), D^H(up), Lambda^live_H(down), A^corr_H(down), r_H(d | Definition | wrapped_related EQ_015__W_46_v1_reads | 1 |
| EQ-015/W.47.v1 | CAN-152-SPLIT-01 | EQ-015 | W | S_dot^H_t = s_1 W_t + s_2 N_t - delta_S S^H_t | Definition | definition CAN_152_S_H_next | 1 |
| EQ-015/W.48.v1 | CAN-152-SPLIT-02 | EQ-015 | W | 1 = l_wage + l_care + l_learn + l_civic + l_leisure | Definition | closed CAN_152_time_budget_valid, CAN_152_time_budget_satisfiable | 1 |
| EQ-015/W.49.v1 | CAN-153-SPLIT-01 | EQ-015 | W | H_dot^cap_t = f(Care_t, Health_t, Education_t, Nutrition_t, Community_t) - delta_H H^cap_t | Definition | definition CAN_153_H_cap_next, CAN_153_Open_dynamic_sign, CAN_153_productive_not_social_necessity_witness | 1 |
| EQ-015/W.50.v1 | CAN-153-SPLIT-02 | EQ-015 | W | productive necessity of humans != social necessity of human reproduction | Definition | definition CAN_153_productive_not_social_necessity_witness | 1 |
| A.5/W.07.v1 | CAN-154-SPLIT-01 | A.5 | W | P_t = < P^econ_t, P^info_t, P^coerc_t > | Definition | definition PowerVector, CAN_154_mk_power_vector | 1 |
| A.5/W.08.v1 | CAN-154-SPLIT-02 | A.5 | W | P^B_t proportional-to Gamma^eff_t A^corr_(H,t) Lambda^live_(H,t) X^H_t r^H_t | Definition | definition A5_W08_v1_proportional | 1 |
| A.5/W.09.v1 | CAN-154-SPLIT-03 | A.5 | W | P^E_t = P_E( P_t, G_dot^conv, D^H_t, 1 - Gamma^eff_t ) | Definition | definition A5_W09_v1_epistemic_power | 1 |
| A.5/W.10.v1 | CAN-154-SPLIT-04 | A.5 | W | I_dot_t = F_I( P^B_t, P^E_t, state capacity, rules, shocks ) | Definition | definition PowerVector, CAN_154_Open_not_predetermined | 1 |
| A.5/W.11.v1 | CAN-154-SPLIT-05 | A.5 | W | ownership != informational power != coercive power | Definition | definition CAN_154_channel_noncollapse_witness | 1 |
| EQ-015/W.51.v1 | CAN-159-SPLIT-01 | EQ-015 | W | Machine expansion  =/=>  Human expansion | Definition | definition CAN_159_machine_expansion_not_human_expansion | 1 |
| EQ-015/W.52.v1 | CAN-159-SPLIT-02 | EQ-015 | W | C^H_t = < Gamma^eff_t, X^H_t, Lambda^live_(H,t), A^corr_(H,t), R^route_(H,t), W^world_(H,t), r_(H,t), H^cap_t, | Definition | definition CAN_159_HumanConversionVector, CAN_159_mk_human_conversion_vector | 1 |
| EQ-015/W.53.v1 | CAN-159-SPLIT-03 | EQ-015 | W | eta^HC_(j,t) = d(ln C^H_(j,t)) / d(ln M_t) | Definition | definition CAN_159_eta_HC | 1 |
| EQ-015/W.54.v1 | CAN-159-SPLIT-04 | EQ-015 | W | eta^HC_Gamma > 0,  eta^HC_(rH) < 0,  eta^HC_X < 0 | Definition | wrapped_related EQ_015__W_54_v1_reads | 1 |
| A.5/W.12.v1 | CAN-160-SPLIT-01 | A.5 | W | AI capability != validated knowledge | Definition | closed CAN_160_separation, CAN_160_all_separations_satisfiable | 1 |
| A.5/W.13.v1 | CAN-160-SPLIT-02 | A.5 | W | assisted performance != human learning | Definition | closed A_5__W_13_v1_holds | 1 |
| A.5/W.14.v1 | CAN-160-SPLIT-03 | A.5 | W | augmentation != synergy | Definition | closed A_5__W_14_v1_holds | 1 |
| A.5/W.15.v1 | CAN-160-SPLIT-04 | A.5 | W | formal options != live possibilities | Definition | closed A_5__W_15_v1_holds | 1 |
| A.5/W.16.v1 | CAN-160-SPLIT-05 | A.5 | W | access != credible exit | Definition | closed A_5__W_16_v1_holds | 1 |
| A.5/W.17.v1 | CAN-160-SPLIT-06 | A.5 | W | income transfer != future ownership | Definition | closed A_5__W_17_v1_holds | 1 |
| A.5/W.18.v1 | CAN-160-SPLIT-07 | A.5 | W | material security != agency | Definition | closed A_5__W_18_v1_holds | 1 |
| A.5/W.19.v1 | CAN-160-SPLIT-08 | A.5 | W | market concentration != domination | Definition | closed A_5__W_19_v1_holds | 1 |
| A.5/W.20.v1 | CAN-160-SPLIT-09 | A.5 | W | productive necessity != social necessity | Definition | closed A_5__W_20_v1_holds | 1 |
| EQ-015/W.55.v1 | CAN-163-SPLIT-01 | EQ-015 | W | W_j = { t : C^rec_(j,t) <= C_bar_j  AND  tau^rec_(j,t) <= tau_bar_j } | Definition | definition CAN_163_reversibility_window, CAN_163_in_reversibility_window, CAN_163_Open_reversibility_principle | 1 |
| EQ-015/W.56.v1 | CAN-163-SPLIT-02 | EQ-015 | W | Delta g_(j,t) = [ g~_(M,t) - g~_(Cj,t) ]_+ | Definition | wrapped_related EQ_015__W_56_v1_reads | 1 |
| EQ-015/W.57.v1 | CAN-163-SPLIT-03 | EQ-015 | W | U_(j,t) = Delta g_(j,t) * L_(j,t) * S_(j,t) * tau^rec_(j,t) | Definition | definition CAN_163_urgency_term | 1 |
| EQ-015/W.58.v1 | CAN-163-SPLIT-04 | EQ-015 | W | U_t = < U_(1,t), ..., U_(J,t) > | Definition | wrapped_related EQ_015__W_58_v1_reads | 1 |
| EQ-015/W.59.v1 | CAN-163-SPLIT-05 | EQ-015 | W | U^max_t = max_j U_(j,t) | Definition | wrapped_related EQ_015__W_59_v1_reads | 1 |
| EQ-002/W.02.v1 | CAN-164-SPLIT-01 | EQ-002 | W | C^10_(j,t), C^50_(j,t), C^90_(j,t) | Definition | definition EQ002_W02_Percentiles | 1 |
| EQ-002/W.03.v1 | CAN-164-SPLIT-02 | EQ-002 | W | I^H_(j,t) = C^90_(j,t) - C^10_(j,t) | Definition | definition CAN_164_I_H, CAN_164_Open_proposition4_broad_expansion | 1 |
| EQ-001/C.01.v1 | RGD-CHEM-001 | EQ-001 | C | If the declared closed boundary preserves ledger L(n)=A n, then A(n1-n0)=0. | untagged | closed EQ001_C01_L, EQ001_C01_ledger_conservation | 0 |
| EQ-001/C.02.v1 | RGD-CHEM-002 | EQ-001 | C | A change delta preserves the ledger iff delta is in ker(A). | untagged | closed EQ001_C02_L, EQ001_C02_in_ker, EQ001_C02_preserves_iff_ker | 0 |
| EQ-001/C.03.v1 | RGD-CHEM-003 | EQ-001 | C | If columns of N form a basis for the admitted kernel subspace, every admitted change has coordinates xi with d | untagged | open_prop EQ001_C03_hyp | 0 |
| EQ-001/C.04.v1 | RGD-CHEM-004 | EQ-001 | C | Admitted coordinates satisfy n0+N xi \ge 0 and all declared capacity/boundary inequalities. | untagged | open_prop EQ001_C04_hyp | 0 |
| EQ-001/C.05.v1 | RGD-CHEM-005 | EQ-001 | C | For a finite state set, repeatedly splitting cells by declared readout and successor-cell signatures terminate | untagged | open_prop EQ001_C05_hyp | 0 |
| EQ-001/C.06.v1 | RGD-CHEM-006 | EQ-001 | C | If composition is a free commutative monoid and R is a monoid homomorphism, then R(c)=sum_i c_i R(e_i). | untagged | closed EQ001_C06_R, EQ001_C06_additive | 0 |
| EQ-001/C.07.v1 | RGD-CHEM-007 | EQ-001 | C | A quotient fixed point can hide source-state cycles or currents; therefore fixed quotient readout alone establ | untagged | closed EQ001_C07_quotient_hides_cycle | 0 |
| EQ-001/C.08.v1 | RGD-CHEM-008 | EQ-001 | C | Candidate mathematical languages must be frozen and reported before held-out evidence is opened. | untagged | not_formalisable | 0 |
| EQ-001/C.09.v1 | RGD-CHEM-009 | EQ-001 | C | Use integer/Fraction arithmetic for the finite proof witnesses in v0.901. | untagged | definition EQ001_C09_ExactArithmeticType | 0 |
| EQ-001/C.10.v1 | RGD-CHEM-010 | EQ-001 | C | Freeze generator identities, aliases, source profiles, contexts, and permitted transformations before quotient | untagged | not_formalisable | 0 |
| EQ-001/C.11.v1 | RGD-CHEM-011 | EQ-001 | C | For a frozen finite generator registry G, N^G with coordinatewise addition and zero is a free commutative mono | untagged | open_prop EQ001_C11_hyp | 0 |
| EQ-001/C.12.v1 | RGD-CHEM-012 | EQ-001 | C | Counting registered generators maps empty source word to zero and concatenation to coordinatewise addition. | untagged | closed EQ001_C12_count, EQ001_C12_empty_word, EQ001_C12_concat_additive | 0 |
| EQ-001/C.13.v1 | RGD-CHEM-013 | EQ-001 | C | If equal occupation vectors imply equal registered readout and successor signatures in every frozen profile, t | untagged | closed EQ001_C13_count, EQ001_C13_admissible, EQ001_C13_g_of, EQ001_C13_factorization_thm, EQ001_C13_permutati | 0 |
| EQ-001/C.14.v1 | RGD-CHEM-014 | EQ-001 | C | Within N^G and a frozen independent generator basis, occupation coordinates uniquely specify structural decomp | untagged | closed EQ001_C14_coords_unique | 0 |
| EQ-001/C.15.v1 | RGD-CHEM-015 | EQ-001 | C | A declared nonnegative-integer coarsening map P commutes with composition: P(c+d)=Pc+Pd. | untagged | open_prop EQ001_C15_hyp | 0 |
| EQ-001/C.16.v1 | RGD-CHEM-016 | EQ-001 | C | The marked quotient stores structural occupation separately from an append-only lineage sidecar; equal structu | untagged | closed EQ001_C16_structure_not_lineage | 0 |
| EQ-001/C.17.v1 | RGD-CHEM-017 | EQ-001 | C | Enumerate all registered same-count pairs and compare exact frozen signatures. | untagged | definition EQ001_C17_gate | 0 |
| EQ-001/P.01.v1 | RGD-QUANTUM-001 | EQ-001 | P | a\neqb is retained as a distinction; the distinction is asymmetric, giving an ordering direction. Identical to | untagged | definition EQ001_P01_distinct | 0 |
| EQ-001/P.02.v1 | RGD-QUANTUM-002 | EQ-001 | P | The asymmetric ordering yields ordered transitions with a positive retention time tau_c>0. | untagged | definition EQ001_P02_valid_retention | 0 |
| EQ-001/P.03.v1 | RGD-QUANTUM-003 | EQ-001 | P | Retention discretizes into ticks t=n\cdot Delta_theta; a finite causal graph is built on those ticks. | untagged | definition EQ001_P03_tick | 0 |
| EQ-001/P.04.v1 | RGD-QUANTUM-004 | EQ-001 | P | The retained-distinction axioms FORCE the finite retention operator L_R's form -- not merely posit it. Machine | Th_coqc | not_formalisable | 0 |
| EQ-001/P.05.v1 | RGD-QUANTUM-005 | EQ-001 | P | Coarse-graining L_R over the ticks gives the spine second-order stepper M\cdot d2 + D\cdot d + K, shared verba | untagged | definition EQ001_P05_SpineStepper | 0 |
| EQ-001/P.06.v1 | RGD-QUANTUM-006 | EQ-001 | P | The spine stepper's characteristic equation is M\cdot s^2 + D\cdot s + K\cdot lambda = 0, exact-rational, para | untagged | definition EQ001_P06_char | 0 |
| EQ-001/P.07.v1 | RGD-QUANTUM-007 | EQ-001 | P | lambda_c = D^2/(4\cdot M\cdot K). The discriminant disc(lambda) = D^2 - 4\cdot M\cdot K\cdot lambda is negativ | finite_diagnostic | closed EQ001_P07_lambda_c, EQ001_P07_disc, EQ001_P07_witness | 0 |
| EQ-001/P.08.v1 | RGD-QUANTUM-008 | EQ-001 | P | Any asymmetric seed matrix R0 decomposes uniquely as R0 = DiagPart + SymOff + SkewOff. Exact rational witness  | Th_coqc | closed EQ001_P08_Diag, EQ001_P08_Sym, EQ001_P08_Skew, EQ001_P08_decompose, EQ001_P08_R0, EQ001_P08_skew_nonzer | 0 |
| EQ-001/P.09.v1 | RGD-QUANTUM-009 | EQ-001 | P | The seed torsion/circulation branch is exactly SkewOff; the set of admissible SkewOff parts forms a group and  | Th_coqc | closed EQ001_P09_IsSkew, EQ001_P09_zero_skew, EQ001_P09_add_skew, EQ001_P09_neg_skew | 0 |
| EQ-001/P.10.v1 | RGD-QUANTUM-010 | EQ-001 | P | The torsion/circulation branch produces genuine (non-trivial, non-decomposable-further) mixing among retained  | Th_coqc | closed EQ001_P10_R0, EQ001_P10_SkewOff, EQ001_P10_genuine_mixing | 0 |
| EQ-001/P.11.v1 | RGD-QUANTUM-011 | EQ-001 | P | An orientation J on a closed real oriented mode-pair with J^2=-I and G-adjoint J^{dagger_G}=-J (G-skew under t | untagged | closed EQ001_P11_J_squared_neg_I, EQ001_P11_J_transpose_is_neg_J, EQ001_P11_failing_control | 0 |
| EQ-001/P.12.v1 | RGD-QUANTUM-012 | EQ-001 | P | N_Q(psi) = <psi, G psi> is \ge 0 for all psi and =0 iff psi=0, on the exact rational witness (G=I2, psi=(3,4)  | finite_diagnostic | closed EQ001_P12_NQ, EQ001_P12_witness | 0 |
| EQ-001/P.13.v1 | RGD-QUANTUM-013 | EQ-001 | P | An evolution operator U satisfying U^{dagger_G} G U = G preserves N_Q exactly. Exact witness: U=J (the complex | finite_diagnostic | closed EQ001_P13_NQ, EQ001_P13_preserved | 0 |
| EQ-001/P.14.v1 | RGD-QUANTUM-014 | EQ-001 | P | Retained memory (discrete algebra on the retention operator) FORCES a mass-like readout, axiom-free, machine-c | Th_coqc | not_formalisable | 0 |
| EQ-001/P.15.v1 | RGD-QUANTUM-015 | EQ-001 | P | The discrete connection U_{j<-i}=V_j^-1\cdot V_i, the curvature certificate K_C=U_C-I (two finite transports f | Th_coqc | not_formalisable | 0 |
| EQ-001/P.16.v1 | RGD-QUANTUM-016 | EQ-001 | P | InfoQuantumRelativityUnification.v (box_quad_is_spine_residual, spine_dispersion_iff_box_quad_vanishes) and In | untagged | not_formalisable | 0 |
| EQ-001/P.17.v1 | RGD-QUANTUM-017 | EQ-001 | P | InfoTelegraphHorizonUnification_attempt.v / InfoTelegraphCrossover_attempt.v prove disc_is_spine_discr, lam_c_ | untagged | not_formalisable | 0 |
| EQ-001/P.18.v1 | RGD-QUANTUM-018 | EQ-001 | P | Under the DECLARED (not derived) identification of the spine's own front-speed-squared with K/M, the oscillato | untagged | definition EQ001_P18_declared_v_sq | 0 |
| EQ-001/P.19.v1 | RGD-QUANTUM-019 | EQ-001 | P | Q-G1's discrete metric/curvature chain is root-native and Coq-green as GEOMETRY, but its bridge toward a quant | untagged | not_formalisable | 0 |
| EQ-001/P.20.v1 | RGD-QUANTUM-020 | EQ-001 | P | Q-M1 establishes the FORMAL algebraic claim (retained memory forces a mass-like readout) as Coq-green. Whether | untagged | not_formalisable | 0 |
| EQ-001/P.21.v1 | RGD-QUANTUM-021 | EQ-001 | P | A formal CPTP (completely-positive, trace-preserving) channel CARD exists as a target definition (the abstract | untagged | not_formalisable | 0 |
| EQ-001/P.22.v1 | RGD-QUANTUM-022 | EQ-001 | P | Q-C1 establishes complexification for ONE closed real oriented mode-pair, exact witness. General existence and | Open | not_formalisable | 0 |
| EQ-001/P.23.v1 | RGD-QUANTUM-023 | EQ-001 | P | A candidate architecture for a quantum quotient q_Q (mirroring relativity's q_g / chem's q_D pattern) is sketc | Open | open_prop EQ001_P23_hyp | 0 |
| EQ-001/P.24.v1 | RGD-QUANTUM-024 | EQ-001 | P | Whether a mixed-state description (density-matrix-shaped object) arises from tracing out a hidden lineage of t | Open | not_formalisable | 0 |
| EQ-001/P.25.v1 | RGD-QUANTUM-025 | EQ-001 | P | Whether a composition operation (x)_kappa on retained subsystems, derived from the no-free-copy law, reproduce | Open | not_formalisable | 0 |
| EQ-001/P.26.v1 | RGD-QUANTUM-026 | EQ-001 | P | TARGET, not established: uniqueness of the Born weight p=\|psi\|^2 across ALL admissible refinements. quantum_cl | Open | not_formalisable | 0 |
| EQ-001/P.27.v1 | RGD-QUANTUM-027 | EQ-001 | P | Whether a root-native conditional-update rule (projection-postulate-shaped) exists is OPEN -- no finite witnes | Open | not_formalisable | 0 |
| EQ-001/P.28.v1 | RGD-QUANTUM-028 | EQ-001 | P | An RDL_Heisenberg-shaped formal guard exists and SURVIVED the hollow-card audit (it correctly refuses to fire  | Open | not_formalisable | 0 |
| EQ-001/P.29.v1 | RGD-QUANTUM-029 | EQ-001 | P | A CHSH/Tsirelson-shaped formal guard exists as a boundary check (it can flag classical-vs-quantum-shaped corre | Open | not_formalisable | 0 |
| EQ-001/P.30.v1 | RGD-QUANTUM-030 | EQ-001 | P | A particle ontology (localized, countable excitations with mass) is OPEN -- Q-M1/Q-Y5 establish only a formal  | Open | not_formalisable | 0 |
| EQ-001/P.31.v1 | RGD-QUANTUM-031 | EQ-001 | P | Spin and the spin-statistics theorem are fully OPEN. Q-S1's SkewOff torsion branch is NOT spin -- no rotation- | Open | not_formalisable | 0 |
| EQ-001/P.32.v1 | RGD-QUANTUM-032 | EQ-001 | P | A full QFT / effective-field-theory closure requires the JOINT construction of the quantum quotient q_Q, the r | Open | not_formalisable | 0 |
| EQ-001/P.33.v1 | RGD-QUANTUM-033 | EQ-001 | P | A conditional superposition gate exists ONLY for a fixed, pre-specified pair of orthogonal readout operators o | Open | closed EQ001_P33_NQ, EQ001_P33_pythagorean_additive | 0 |
| EQ-001/P.34.v1 | RGD-RELATIVITY-001 | EQ-001 | P | a\neqb is retained as a distinction; the distinction is asymmetric, giving an ordering direction. | untagged | definition EQ001_P34_distinct | 0 |
| EQ-001/P.35.v1 | RGD-RELATIVITY-004 | EQ-001 | P | Coarse-graining the stepper gives a telegraph process with finite front speed v=\sqrt{D/tau_c), derived from f | untagged | definition EQ001_P35_v_sq | 0 |
| EQ-001/P.36.v1 | RGD-RELATIVITY-005 | EQ-001 | P | The finite front speed bounds a causal cone \|x\|\lev\cdot t. | untagged | definition EQ001_P36_in_cone | 0 |
| EQ-001/P.37.v1 | RGD-RELATIVITY-006 | EQ-001 | P | Define null coordinates n_+ = v\cdot t+x, n_- = v\cdot t-x from the cone's own two edges. | finite_diagnostic | definition EQ001_P37_n_plus, EQ001_P37_n_minus | 0 |
| EQ-001/P.38.v1 | RGD-RELATIVITY-007 | EQ-001 | P | Q_v = n_+ \cdot  n_- = v^2 t^2 - x^2, composed from the cone's own null edges, not an imported interval. | finite_diagnostic | closed EQ001_P38_n_plus, EQ001_P38_n_minus, EQ001_P38_Qv, EQ001_P38_cone_product | 0 |
| EQ-001/P.39.v1 | RGD-RELATIVITY-008 | EQ-001 | P | B(delta1+delta2)=B(delta1)+B(delta2) is imposed and forces linearity of B over Q (derived, not separately assu | finite_diagnostic | closed EQ001_P39_doubling | 0 |
| EQ-001/P.40.v1 | RGD-RELATIVITY-009 | EQ-001 | P | The observer map B must send the cone to itself (preserve \|x\|\lev\cdot t under the map). | finite_diagnostic | definition EQ001_P40_cone_preserving | 0 |
| EQ-001/P.41.v1 | RGD-RELATIVITY-010 | EQ-001 | P | The observer map B preserves the forward/backward orientation of the cone. | finite_diagnostic | definition EQ001_P41_orientation_preserving | 0 |
| EQ-001/P.42.v1 | RGD-RELATIVITY-011 | EQ-001 | P | A pure observer change preserves the RD causal-cell count n_+ \cdot  n_- (Q_v). This is the one new internal g | untagged | definition EQ001_P42_neutrality | 0 |
| EQ-001/P.43.v1 | RGD-RELATIVITY-012 | EQ-001 | P | O4 forces n_+' = kappa^-1 \cdot  n_+, n_-' = kappa \cdot  n_-, kappa>0, so that Q_v'=Q_v automatically. | untagged | closed EQ001_P43_rescale_invariant | 0 |
| EQ-001/P.44.v1 | RGD-RELATIVITY-013 | EQ-001 | P | Relative velocity beta=u/v; kappa^2=(1+beta)/(1-beta); Gamma_R=(kappa+1/kappa)/2=1/\sqrt{1-beta^2). Exact witn | untagged | closed EQ001_P44_beta, EQ001_P44_kappa_sq, EQ001_P44_Gamma_R, EQ001_P44_witness | 0 |
| EQ-001/P.45.v1 | RGD-RELATIVITY-014 | EQ-001 | P | x'=Gamma_R\cdot (x-u\cdot t), t'=Gamma_R\cdot (t-u\cdot x/v^2). Exact witness: event (t=8,x=5) \to (t'=7,x'=-5 | untagged | closed EQ001_P45_xprime, EQ001_P45_tprime, EQ001_P45_Qv, EQ001_P45_witness | 0 |
| EQ-001/P.46.v1 | RGD-RELATIVITY-015 | EQ-001 | P | t'/t=1/Gamma_R and L=L_0/Gamma_R follow from OA-09 with no new law inserted. | untagged | definition EQ001_P46_time_dilation, EQ001_P46_length_contraction | 0 |
| EQ-001/P.47.v1 | RGD-RELATIVITY-016 | EQ-001 | P | Delta t' = -Gamma_R \cdot  u \cdot  Delta x / v^2 follows from OA-09 with no new law inserted. | untagged | definition EQ001_P47_delta_tprime | 0 |
| EQ-001/P.48.v1 | RGD-RELATIVITY-017 | EQ-001 | P | u_21=(u1+u2)/(1+u1\cdot u2/v^2) follows from OA-09; exact witness stays sub-cone (\|u21\|<v). | untagged | definition EQ001_P48_u21 | 0 |
| EQ-001/P.49.v1 | RGD-RELATIVITY-018 | EQ-001 | P | g^ij ~= 1/2 \cdot  Hess(sigma_LR), the retention operator's principal symbol read as a metric. This direction  | Th_coqc | not_formalisable | 0 |
| EQ-001/P.50.v1 | RGD-RELATIVITY-019 | EQ-001 | P | The geometry-only quotient Theta lacks the variables to close on its own (Theta_{n+1} depends on Phi,Psi, not  | finite_diagnostic | definition EQ001_P50_MinimalState | 0 |
| EQ-001/P.51.v1 | RGD-RELATIVITY-020 | EQ-001 | P | U_{j<-i} = V_j^-1 \cdot  V_i from the basis-change identity; transport defect o_{i\toj} = phi_j - U_{j<-i}\cdo | Th_coqc | definition EQ001_P51_Group, EQ001_P51_connection, EQ001_P51_defect | 0 |
| EQ-001/P.52.v1 | RGD-RELATIVITY-021 | EQ-001 | P | Loop transport U_C = U_C(loop) - I defines curvature K_C: local transports failing to commute (finite witness: | Th_coqc | definition EQ001_P52_curvature | 0 |
| EQ-001/P.53.v1 | RGD-RELATIVITY-022 | EQ-001 | P | Free path selects O(P)=sum_e o_e^T G_j o_e minimal; witness phi_i=[1,0], phi_f=[1,1]: path x\toy obstruction 0 | finite_diagnostic | definition EQ001_P53_argmin_path | 0 |
| EQ-001/P.54.v1 | RGD-RELATIVITY-023 | EQ-001 | P | The geometry-field feedback loop closes as a time-unrolled DAG (not circular), satisfying q_LG o F_full = F_LG | finite_diagnostic | open_prop EQ001_P54_hyp | 0 |
| EQ-001/P.55.v1 | RGD-RELATIVITY-024 | EQ-001 | P | CLOSED in v0.2 by the Null-Transport Factorization Gate: the local causal-cell rate relates to a remote record | untagged | definition EQ001_P55_theta_i, EQ001_P55_nu_o | 0 |
| EQ-001/P.56.v1 | RGD-RELATIVITY-025 | EQ-001 | P | The diagonal cone map B=diag(a,b) factors uniquely as B=N\cdot diag(chi^-1,chi), with N=\sqrt{ab)=\sqrt{det B) | untagged | closed EQ001_P56_witness | 0 |
| EQ-001/P.57.v1 | RGD-RELATIVITY-026 | EQ-001 | P | On a stationary path, dtheta_i = N_{i\|o} dtheta_o (theta = retained transition count), so nu_o = N nu_i and dt | finite_diagnostic | closed EQ001_P57_inverse_rate | 0 |
| EQ-001/P.58.v1 | RGD-RELATIVITY-027 | EQ-001 | P | Determinants multiply under composition of diagonal observer maps, so N_{j\|o}=N_{j\|i}\cdot N_{i\|o}, and N_P=pr | finite_diagnostic | closed EQ001_P58_witness | 0 |
| EQ-001/P.59.v1 | RGD-RELATIVITY-028 | EQ-001 | P | N=0 iff det B=0, a finite rank-loss boundary of the observer map (not a statement involving infinity). At N=0  | untagged | closed EQ001_P59_witness | 0 |
| EQ-001/P.60.v1 | RGD-RELATIVITY-029 | EQ-001 | P | From the DeclaredFormula tau_c^(U)=pi\cdot c/a_local, a_local=pi\cdot c/tau_c^(U). The observer reads a_o = N_ | untagged | closed EQ001_P60_kappa_R, EQ001_P60_witness | 0 |
| EQ-001/P.61.v1 | RGD-RELATIVITY-030 | EQ-001 | P | The graph front-speed v is declared (not derived) as playing the role a measured propagation speed would play; | untagged | not_formalisable | 0 |
| EQ-001/P.62.v1 | RGD-RELATIVITY-031 | EQ-001 | P | Retention memory is declared (not derived) as playing a mass-like role; no mass-energy law is derived from the | untagged | not_formalisable | 0 |
| EQ-001/P.63.v1 | RGD-RELATIVITY-032 | EQ-001 | P | r_s = 2\cdot G\cdot E/c^4, admitted only as a declared calculator identity, not a derived theorem of this doma | untagged | definition EQ001_P63_r_s | 0 |
| EQ-001/P.64.v1 | RGD-RELATIVITY-033 | EQ-001 | P | tau_c = pi\cdot c/a, admitted only as a declared calculator identity, not a derived theorem of this domain. | untagged | definition EQ001_P64_tau_c | 0 |
| EQ-001/P.65.v1 | RGD-RELATIVITY-034 | EQ-001 | P | CLOSED in v0.2: the horizon half by GC-04 (N=0 \le> det B=0, finite rank-loss boundary) plus GC-05 (Unruh-fix  | finite_diagnostic | not_formalisable | 0 |
| EQ-001/P.66.v1 | RGD-RELATIVITY-035 | EQ-001 | P | Since G[Theta]=G_0+sum_a Theta^a G_a, dG/dTheta^a=G_a. The geometry source is S_Theta,n^a = Phi_n^T G_a Psi_n  | finite_diagnostic | closed EQ001_P66_witness | 0 |
| EQ-001/P.67.v1 | RGD-RELATIVITY-036 | EQ-001 | P | The living-geometry state Theta obeys the same retained-action grammar as the rest of the root: S_closed = S_D | finite_diagnostic | closed EQ001_P67_gradU, EQ001_P67_stepper, EQ001_P67_residual, EQ001_P67_witness | 0 |
| EQ-001/P.68.v1 | RGD-RELATIVITY-037 | EQ-001 | P | The minimal closed state is Z_n=(Phi_n,Phi_{n-1},Psi_n,Psi_{n-1},Theta_n,Theta_{n-1}); Z_{n+1}=F_MSG(Z_n). The | finite_diagnostic | definition EQ001_P68_Z | 0 |
| EQ-001/P.69.v1 | RGD-RELATIVITY-038 | EQ-001 | P | Four named fail states for the geometry stationarity gate: FAIL_GEOMETRY_PIVOT (det M_Theta=0 / low pivot), FA | finite_diagnostic | definition EQ001_P69_FailState | 0 |
| MQ08-stepper/P.01.v1 | RGD-RELATIVITY-003 | MQ08-stepper | P | Retention discretizes into ticks t=n\cdot Delta_theta; the finite causal graph and retention operator L_R are  | untagged | definition MQ08_stepper_P01_tick | 0 |
| EQ-001/B.01.v1 | RGD-BIOLOGY-001 | EQ-001 | B | a\neqb is retained as a distinction; the distinction is asymmetric, giving an ordering direction. The same sha | untagged | not_formalisable | 0 |
| EQ-001/B.02.v1 | RGD-BIOLOGY-002 | EQ-001 | B | The asymmetric ordering yields ordered transitions with a positive retention time tau_c>0. | untagged | not_formalisable | 0 |
| EQ-001/B.03.v1 | RGD-BIOLOGY-003 | EQ-001 | B | Retention discretizes into ticks; the ordered-tape carrier G\cdot  keeps order (ab \neq ba), giving the finite | untagged | not_formalisable | 0 |
| EQ-001/B.04.v1 | RGD-BIOLOGY-004 | EQ-001 | B | The count carrier N^G (multiset/count quotient of G\cdot ) FAILS to keep dynamics well-defined: nu(ab)=nu(ba)= | finite_diagnostic | not_formalisable | 0 |
| EQ-001/B.05.v1 | RGD-BIOLOGY-005 | EQ-001 | B | Because the count carrier N^G loses the distinction the future-response signature F needs, the ORDERED quotien | untagged | not_formalisable | 0 |
| EQ-001/B.06.v1 | RGD-BIOLOGY-006 | EQ-001 | B | The intervention-response equivalence class q_F(w) = O(w) (order-of-positions readout) is invariant under the  | untagged | not_formalisable | 0 |
| EQ-001/B.07.v1 | RGD-BIOLOGY-007 | EQ-001 | B | A two-component state (integrity x, reserve e) updates under a no-free-repair ledger x'+e'=x+e+j-d for contrac | Definition | definition EQ001_B07_v1_ledger_update | 0 |
| EQ-001/B.08.v1 | RGD-BIOLOGY-008 | EQ-001 | B | A self-maintaining fixed point V_A=Gamma(V_A) exists under the no-free-repair ledger: exact witness (1,1) with | Definition | definition EQ001_B08_v1_is_fixed_point | 0 |
| EQ-001/B.09.v1 | RGD-BIOLOGY-009 | EQ-001 | B | The failing control of BIO-G3 (sustained (d,j)=(1,0)) exhibits integrity x \to 0 with no return path in the fi | Definition | definition EQ001_B09_v1_irreversible_exit | 0 |
| EQ-001/B.10.v1 | RGD-BIOLOGY-010 | EQ-001 | B | A heredity quotient q_H (descendant-signature equivalence) closes structurally: a coarse parent-quotient that  | untagged | not_formalisable | 0 |
| EQ-001/B.11.v1 | RGD-BIOLOGY-011 | EQ-001 | B | From licensed replication-count matrix B and initial counts N0, N1=B\cdot N0 gives a frequency readout p1=N1/s | finite_diagnostic | closed EQ001_B11_v1_matvec_diag, EQ001_B11_v1_N1_witness, EQ001_B11_v1_p1_witness | 0 |
| EQ-001/B.12.v1 | RGD-BIOLOGY-012 | EQ-001 | B | The I-only quotient q_I fails to distinguish z1=(1,1,0) and z2=(1,1,1) BEFORE the endogenous step (q_I identic | untagged | not_formalisable | 0 |
| EQ-001/B.13.v1 | RGD-BIOLOGY-013 | EQ-001 | B | Exact witness: tstep(1,1,0)=(1,1,0), tstep(1,1,1)=(2,0,1); q_I(z1)=q_I(z2)=(1,1) before, but (1,1,0)_{1:2} \ne | finite_diagnostic | not_formalisable | 0 |
| EQ-001/B.14.v1 | RGD-BIOLOGY-014 | EQ-001 | B | Geometric decay, turnover-is-production, and homeostasis-balance theorems compile axiom-clean and root-native, | Th_coqc | not_formalisable | 0 |
| EQ-001/B.15.v1 | RGD-BIOLOGY-015 | EQ-001 | B | Setpoint relaxation (one-step and n-step error decay toward a fixed setpoint) theorems compile axiom-clean and | Th_coqc | not_formalisable | 0 |
| EQ-001/B.16.v1 | RGD-BIOLOGY-016 | EQ-001 | B | A bistable window and critical-slowing-down theorem compile axiom-clean and root-native, backing the BIO-G3 li | Th_coqc | not_formalisable | 0 |
| EQ-001/B.17.v1 | RGD-BIOLOGY-017 | EQ-001 | B | Coupling-energy, locked-iff-energy-zero, and one-way-coupling-breaks-conservation theorems compile axiom-clean | Th_coqc | not_formalisable | 0 |
| EQ-001/B.18.v1 | RGD-BIOLOGY-018 | EQ-001 | B | BIO-G2 closes q_F as an abstract functional quotient; whether q_F corresponds to a real protein, enzyme, or ca | untagged | not_formalisable | 0 |
| EQ-001/B.19.v1 | RGD-BIOLOGY-019 | EQ-001 | B | BIO-G3 closes V_A as an abstract self-maintaining fixed point; whether V_A corresponds to a real cell or organ | untagged | not_formalisable | 0 |
| EQ-001/B.20.v1 | RGD-BIOLOGY-020 | EQ-001 | B | A reproduction operator R_kappa is architecturally sketched as a branch off the living-unit fixed point V_A (a | untagged | not_formalisable | 0 |
| EQ-001/B.21.v1 | RGD-BIOLOGY-021 | EQ-001 | B | BIO-G4 closes q_H and the frequency readout p_{j,n+1} structurally; whether this frequency change corresponds  | untagged | not_formalisable | 0 |
| EQ-001/B.22.v1 | RGD-BIOLOGY-022 | EQ-001 | B | The lineage-frequency trend (B-LIN) can be READ as an 'evolution' trajectory, but this reading is a declared i | untagged | not_formalisable | 0 |
| EQ-001/B.23.v1 | RGD-BIOLOGY-023 | EQ-001 | B | B-SUB1's discrete-algebra homeostasis theorems are Coq-green as FORMAL claims; whether they describe real phys | untagged | not_formalisable | 0 |
| EQ-001/B.24.v1 | RGD-BIOLOGY-024 | EQ-001 | B | B-SUB2's setpoint-relaxation theorems are Coq-green as FORMAL claims; whether they describe real clinical reco | untagged | not_formalisable | 0 |
| EQ-001/B.25.v1 | RGD-BIOLOGY-025 | EQ-001 | B | B-SUB3's bistable-window theorem is Coq-green as a FORMAL claim; whether it describes a real bistable disease  | untagged | not_formalisable | 0 |
| EQ-001/B.26.v1 | RGD-BIOLOGY-026 | EQ-001 | B | B-SUB4's coupling-energy theorems are Coq-green as FORMAL claims; whether they describe real physiological cou | untagged | not_formalisable | 0 |
| EQ-001/B.27.v1 | RGD-BIOLOGY-027 | EQ-001 | B | The domain-discovery battery is real and runnable (PASS), but has been run only on SYNTHETIC tapes -- no real  | untagged | not_formalisable | 0 |
| EQ-001/B.28.v1 | RGD-BIOLOGY-028 | EQ-001 | B | The bacteriorhodopsin (bR) lineage ledger and its CLI are narrated and architected in the core, but NO real ev | untagged | not_formalisable | 0 |
| EQ-001/B.29.v1 | RGD-BIOLOGY-029 | EQ-001 | B | TARGET, not established: a calibrated encoding mapping retained root state to real biological observables (seq | Open | open_prop EQ001_B29_v1_hyp | 0 |
| EQ-001/B.30.v1 | RGD-BIOLOGY-030 | EQ-001 | B | TARGET, not established: derivation of any real biological result from the root through real (measured, event- | Open | open_prop EQ001_B30_v1_hyp | 0 |
| EQ-001/B.31.v1 | RGD-BIOLOGY-031 | EQ-001 | B | DNA/genome as a real molecular carrier is a destination the ordered-sequence carrier (BIO-G1) might eventually | Open | open_prop EQ001_B31_v1_hyp | 0 |
| EQ-001/B.32.v1 | RGD-BIOLOGY-032 | EQ-001 | B | A real cell or organelle is a destination the living-unit closure (BIO-G3) might eventually be calibrated to r | Open | open_prop EQ001_B32_v1_hyp | 0 |
| EQ-001/B.33.v1 | RGD-BIOLOGY-033 | EQ-001 | B | Real enzyme kinetics (e.g. Michaelis-Menten-shaped catalysis) is a destination the functional quotient (BIO-G2 | Open | open_prop EQ001_B33_v1_hyp | 0 |
| EQ-001/B.34.v1 | RGD-BIOLOGY-034 | EQ-001 | B | Fitness / natural selection is explicitly FORBIDDEN as a root variable anywhere in BIO-G4/B-LIN; it remains a  | Open | not_formalisable | 0 |
| EQ-001/B.35.v1 | RGD-BIOLOGY-035 | EQ-001 | B | Real population-level ecological dynamics beyond the abstract lineage-count trend (B-LIN/B-Y5) are fully open  | Open | not_formalisable | 0 |
| EQ-001/B.36.v1 | RGD-BIOLOGY-036 | EQ-001 | B | The LINE-2 textbook curriculum solver (45/45 checklist, tier textbook_closure/finite_diagnostic, no Th_coqc) s | Open | not_formalisable | 0 |
| Face.10.IdentifiabilityGate/E.01.v1 | RUS-0001 | Face.10.IdentifiabilityGate | E | Phi_FI(q; A1, A2, C, pi) = 1 - V*(C\pi) / V*(C) | Definition | closed Face10_E01_PhiFI, Face10_E01_zero_when_equal | 0 |
| EQ-015/M.13.v1 | RUS-0002 | EQ-015 | M | \mathbb{L}^{n}[X] = (M/2dt)\cdot\DeltaX^{T}(G\otimesI)\DeltaX + (D/2)\cdotX^{T}(\Omega\otimesI)\DeltaX − (dt/2 | finite_diagnostic | wrapped_related EQ_015__M_13_v1_reads | 1 |
| EQ-015/M.14.v1 | RUS-0003 | EQ-015 | M | H = M\cdotv\Phi^{T}v\Psi + K\cdot\Phi^{T}L_R\Psi + k_{2}\cdot\Phi^{T}\Psi (conserved quantity) | finite_diagnostic | wrapped_related EQ_015__M_14_v1_reads | 0 |
| EQ-015/M.15.v1 | RUS-0004 | EQ-015 | M | H_nl = \Sigmaᵢ Mᵢ v\Phiᵢv\Psiᵢ + K \Phi^{T}L_w\Psi + \Psi^{T}\nablaV(\Phi) − J^{T}\Psi | finite_diagnostic | wrapped_related EQ_015__M_15_v1_reads | 0 |
| EQ-009/E.01.v1 | RUS-0005 | EQ-009 | E | z̃ = C z \to z' = \sqrt(1−\gamma) z̃,  \rho = −\sqrt\gamma z̃ \to \Psiₙ₊_{1} = \Psiₙ \oplus \rhoₙ | Definition | definition EQ009_E01_zprime, EQ009_E01_rho, EQ009_E01_unitary, EQ009_E01_Psi_next | 0 |
| EQ-009/E.02.v1 | RUS-0006 | EQ-009 | E | T1 conservation бваг: Q(zₙ)+\SigmaQ(\rhoⱼ)=Q(z_{0}) — rel. error <10^{-}^{1}^{2}, decay \omegaนตรง (1−\gamma)^ | finite_diagnostic | definition EQ009_E02_conserved | 0 |
| EQ-009/E.03.v1 | RUS-0007 | EQ-009 | E | T4 = สะพาน: สองชั้นทำนาย envelope เดียวกันเมื่อ \gamma\leftrightarrowD/M | Open | not_formalisable | 0 |
| BridgeCommute/H.01.v1 | RUS-0008 | BridgeCommute | H | T_{j\toi}\cdotF#_H^j = F#_H^i\cdotT_{j\toi}  (commutation criterion for 'closure-meaningful' cross-agent commu | Definition | definition BridgeCommute_H01_v1_commutes | 0 |
| EQ-015/P.01.v1 | RUS-0009 | EQ-015 | P | Planck–Einstein relation E=\hbar\omega | untagged | wrapped_related EQ_015__P_01_v1_reads | 1 |
| EQ-015/P.02.v1 | RUS-0010 | EQ-015 | P | Schrödinger equation / eigenvalue problem | untagged | wrapped_related EQ_015__P_02_v1_reads | 1 |
| EQ-015/P.03.v1 | RUS-0011 | EQ-015 | P | Special relativity / Lorentz invariance | untagged | wrapped_related EQ_015__P_03_v1_reads | 1 |
| EQ-015/P.04.v1 | RUS-0012 | EQ-015 | P | General relativity field equations G_\mu\nu+\Lambdag_\mu\nu=8\piGT_\mu\nu | untagged | wrapped_related EQ_015__P_04_v1_reads | 1 |
| EQ-015/P.05.v1 | RUS-0013 | EQ-015 | P | Schwarzschild metric | untagged | wrapped_related EQ_015__P_05_v1_reads | 1 |
| EQ-015/P.06.v1 | RUS-0014 | EQ-015 | P | Regge-Wheeler equation | untagged | wrapped_related EQ_015__P_06_v1_reads | 2 |
| EQ-015/P.07.v1 | RUS-0015 | EQ-015 | P | Electroweak mixing: A=sin\thetaW\cdotW^{3}+cos\thetaW\cdotB, Z=cos\thetaW\cdotW^{3}−sin\thetaW\cdotB, m_W^{2}= | untagged | wrapped_related EQ_015__P_07_v1_reads | 1 |
| EQ-015/P.08.v1 | RUS-0016 | EQ-015 | P | Fermi coupling G_F and v=(\sqrt2 G_F)^{-1/2} (Higgs vev) | untagged | wrapped_related EQ_015__P_08_v1_reads | 1 |
| EQ-015/P.09.v1 | RUS-0017 | EQ-015 | P | Gauge-anomaly cancellation conditions [SU(3)]^{2}U(1), [SU(2)]^{2}U(1), [grav]^{2}U(1), [U(1)]^{3} fixing the  | untagged | wrapped_related EQ_015__P_09_v1_reads | 1 |
| EQ-015/P.10.v1 | RUS-0018 | EQ-015 | P | Peter–Weyl theorem / character convolution (class-function convolution multiplies representation coefficients) | untagged | wrapped_related EQ_015__P_10_v1_reads | 1 |
| EQ-015/P.11.v1 | RUS-0019 | EQ-015 | P | Wilson-loop area-law criterion for confinement −log\langleW(C)\rangle = \sigma\cdotA(C), and the center (Z_N)  | untagged | wrapped_related EQ_015__P_11_v1_reads | 1 |
| EQ-015/P.12.v1 | RUS-0020 | EQ-015 | P | Ginsparg–Wilson relation {\Gamma,D}=a D \Gamma D (lattice chirality without naïve anticommutation) and the ove | untagged | wrapped_related EQ_015__P_12_v1_reads | 1 |
| EQ-015/P.13.v1 | RUS-0021 | EQ-015 | P | Nielsen–Ninomiya fermion-doubling no-go (locality + translation invariance + Hermiticity + exact naïve chiral  | untagged | wrapped_related EQ_015__P_13_v1_reads | 1 |
| EQ-015/P.14.v1 | RUS-0022 | EQ-015 | P | Clifford algebra {A_\mu,A_\nu}=2\delta_\mu\nu I / irreducible Dirac-matrix dimension (2\times2 Pauli, mutually | untagged | wrapped_related EQ_015__P_14_v1_reads | 1 |
| EQ-015/P.15.v1 | RUS-0023 | EQ-015 | P | Unitary N\timesN quark-mixing-matrix physical-parameter counting (N^{2} real params, 2N−1 removable by phase r | untagged | wrapped_related EQ_015__P_15_v1_reads | 1 |
| EQ-015/P.16.v1 | RUS-0024 | EQ-015 | P | Gatto–Sartori–Tonin relation sin \theta_C \approx \sqrt(m_d/m_s) (Cabibbo angle from the down-type quark mass  | untagged | wrapped_related EQ_015__P_16_v1_reads | 1 |
| EQ-015/P.17.v1 | RUS-0025 | EQ-015 | P | Group-averaging / Reynolds ("twirl") projection onto the invariant subspace Π(X)=(1/\|G\|)\Sigma_{R\inG} R^{T}XR | untagged | wrapped_related EQ_015__P_17_v1_reads | 1 |
| EQ-015/P.18.v1 | RUS-0026 | EQ-015 | P | Osterwalder–Schrader reflection positivity via the Gram / transfer-matrix construction (a half-slab amplitude  | untagged | wrapped_related EQ_015__P_18_v1_reads | 1 |
| EQ-015/P.19.v1 | RUS-0027 | EQ-015 | P | Perron–Frobenius / doubly-stochastic consensus (a primitive doubly-stochastic P has a simple eigenvalue 1 with | untagged | wrapped_related EQ_015__P_19_v1_reads | 1 |
| EQ-015/P.20.v1 | RUS-0028 | EQ-015 | P | Quasinormal-mode late-time power-law ("Price") tail | finite_diagnostic | wrapped_related EQ_015__P_20_v1_reads | 1 |
| EQ-015/P.21.v1 | RUS-0029 | EQ-015 | P | Late-time tail dependence on initial data | untagged | wrapped_related EQ_015__P_21_v1_reads | 1 |
| EQ-015/P.22.v1 | RUS-0030 | EQ-015 | P | Late-time tails, further numerical study | untagged | wrapped_related EQ_015__P_22_v1_reads | 1 |
| EQ-015/P.23.v1 | RUS-0031 | EQ-015 | P | Quasinormal mode spectrum (continued-fraction method) | untagged | wrapped_related EQ_015__P_23_v1_reads | 1 |
| EQ-015/P.24.v1 | RUS-0032 | EQ-015 | P | Raychaudhuri equation | Open | wrapped_related EQ_015__P_24_v1_reads | 1 |
| EQ-015/P.25.v1 | RUS-0033 | EQ-015 | P | de Broglie's internal clock | Dr | wrapped_related EQ_015__P_25_v1_reads | 1 |
| EQ-015/P.26.v1 | RUS-0034 | EQ-015 | P | Dirac equation | untagged | wrapped_related EQ_015__P_26_v1_reads | 1 |
| EQ-015/P.27.v1 | RUS-0035 | EQ-015 | P | Zitterbewegung (relativistic) | untagged | wrapped_related EQ_015__P_27_v1_reads | 1 |
| EQ-015/P.28.v1 | RUS-0036 | EQ-015 | P | Zitterbewegung interpretation | untagged | wrapped_related EQ_015__P_28_v1_reads | 1 |
| EQ-015/P.29.v1 | RUS-0037 | EQ-015 | P | Higgs mechanism | untagged | wrapped_related EQ_015__P_29_v1_reads | 1 |
| EQ-015/P.30.v1 | RUS-0038 | EQ-015 | P | Electroweak Higgs mechanism / one-doublet EWSB: residual Q=T_{3}+Y stabilizer, m_W^{2}=g^{2}v^{2}/4, m_Z^{2}=( | untagged | wrapped_related EQ_015__P_30_v1_reads | 1 |
| EQ-015/P.31.v1 | RUS-0039 | EQ-015 | P | Elitzur's theorem (a local gauge symmetry cannot break spontaneously; only gauge-invariant order parameters li | untagged | wrapped_related EQ_015__P_31_v1_reads | 1 |
| EQ-015/P.32.v1 | RUS-0040 | EQ-015 | P | Robb's causal-order axiomatization | untagged | wrapped_related EQ_015__P_32_v1_reads | 1 |
| EQ-015/P.33.v1 | RUS-0041 | EQ-015 | P | Zeeman: causality determines Lorentz group | untagged | wrapped_related EQ_015__P_33_v1_reads | 1 |
| EQ-015/P.34.v1 | RUS-0042 | EQ-015 | P | Malament: causal order fixes topology | untagged | wrapped_related EQ_015__P_34_v1_reads | 1 |
| EQ-015/P.35.v1 | RUS-0043 | EQ-015 | P | One-loop non-abelian gauge \beta-function with matter, b_a = (11/3)C_{2}(G_a) − (2/3)\SigmaT_a(R_fermion) − (1 | finite_diagnostic | wrapped_related EQ_015__P_35_v1_reads | 1 |
| EQ-015/P.36.v1 | RUS-0044 | EQ-015 | P | GUT hypercharge normalization T_{1}(R) = (3/5)Y^{2} (SU(5) embedding factor needed to compare U(1)_Y on the sa | untagged | wrapped_related EQ_015__P_36_v1_reads | 1 |
| EQ-015/P.37.v1 | RUS-0045 | EQ-015 | P | Schutz's independent Minkowski axioms | untagged | wrapped_related EQ_015__P_37_v1_reads | 1 |
| EQ-015/P.38.v1 | RUS-0046 | EQ-015 | P | Regge calculus | untagged | wrapped_related EQ_015__P_38_v1_reads | 1 |
| EQ-015/P.39.v1 | RUS-0047 | EQ-015 | P | Causal set theory | untagged | wrapped_related EQ_015__P_39_v1_reads | 1 |
| EQ-015/P.40.v1 | RUS-0048 | EQ-015 | P | Wolfram hypergraph rewriting project | untagged | wrapped_related EQ_015__P_40_v1_reads | 1 |
| EQ-015/P.41.v1 | RUS-0049 | EQ-015 | P | Tree-level Higgs quartic self-coupling relation lambda = m_H^2/(2 v^2) (from V(H)=-mu^2 H^dag H + lambda (H^da | untagged | wrapped_related EQ_015__P_41_v1_reads | 1 |
| EQ-015/P.42.v1 | RUS-0050 | EQ-015 | P | QCD running coupling alpha_s(M_Z) (asymptotic freedom / one-loop-and-beyond running of the SU(3) gauge couplin | untagged | wrapped_related EQ_015__P_42_v1_reads | 1 |
| EQ-015/P.43.v1 | RUS-0051 | EQ-015 | P | QCD vacuum angle theta_QCD and the strong CP problem (CP-violating term theta (g^2/32 pi^2) G G-tilde in the Q | untagged | wrapped_related EQ_015__P_43_v1_reads | 1 |
| EQ-015/P.44.v1 | RUS-0052 | EQ-015 | P | Neutrino oscillation mass-squared splittings Delta m^2_21, Delta m^2_31 (PMNS-driven flavor oscillation probab | untagged | wrapped_related EQ_015__P_44_v1_reads | 1 |
| EQ-015/P.45.v1 | RUS-0053 | EQ-015 | P | Clausius relation \deltaQ=T\deltaS | untagged | wrapped_related EQ_015__P_45_v1_reads | 1 |
| EQ-015/P.46.v1 | RUS-0054 | EQ-015 | P | Bekenstein–Hawking area-entropy law | untagged | wrapped_related EQ_015__P_46_v1_reads | 1 |
| EQ-015/P.47.v1 | RUS-0055 | EQ-015 | P | Unruh temperature | untagged | wrapped_related EQ_015__P_47_v1_reads | 1 |
| EQ-015/P.48.v1 | RUS-0056 | EQ-015 | P | Jacobson's thermodynamic derivation of Einstein's equation | Ax | wrapped_related EQ_015__P_48_v1_reads | 1 |
| EQ-015/P.49.v1 | RUS-0057 | EQ-015 | P | Verlinde's entropic gravity | untagged | wrapped_related EQ_015__P_49_v1_reads | 1 |
| EQ-015/P.50.v1 | RUS-0058 | EQ-015 | P | Sakharov induced gravity | untagged | wrapped_related EQ_015__P_50_v1_reads | 1 |
| EQ-015/P.51.v1 | RUS-0059 | EQ-015 | P | Susskind holographic principle | untagged | wrapped_related EQ_015__P_51_v1_reads | 1 |
| EQ-015/P.52.v1 | RUS-0060 | EQ-015 | P | Maldacena AdS/CFT | untagged | wrapped_related EQ_015__P_52_v1_reads | 1 |
| EQ-015/P.53.v1 | RUS-0061 | EQ-015 | P | Ryu–Takayanagi entanglement=area | untagged | wrapped_related EQ_015__P_53_v1_reads | 1 |
| EQ-015/P.54.v1 | RUS-0062 | EQ-015 | P | Van Raamsdonk: spacetime from entanglement | untagged | wrapped_related EQ_015__P_54_v1_reads | 1 |
| q_formal/M.01.v1 | RUS-0063 | q_formal | M | Forman(-Ricci) combinatorial curvature | untagged | wrapped_related q_formal__M_01_v1_reads_Sum_ext, q_formal__M_01_v1_reads_Sum_plus, q_formal__M_01_v1_reads_Sum | 1 |
| q_formal/M.02.v1 | RUS-0064 | q_formal | M | Ollivier-Ricci curvature | untagged | wrapped_related q_formal__M_02_v1_reads_Sum_ext, q_formal__M_02_v1_reads_Sum_plus, q_formal__M_02_v1_reads_Sum | 1 |
| q_formal/M.03.v1 | RUS-0065 | q_formal | M | Ricci curvature of graphs (Forman/Ollivier relation) | untagged | wrapped_related q_formal__M_03_v1_reads_Sum_ext, q_formal__M_03_v1_reads_Sum_plus, q_formal__M_03_v1_reads_Sum | 1 |
| q_formal/M.04.v1 | RUS-0066 | q_formal | M | Rayleigh quotient / theory of sound | untagged | wrapped_related q_formal__M_04_v1_reads_Sum_ext, q_formal__M_04_v1_reads_Sum_plus, q_formal__M_04_v1_reads_Sum | 1 |
| q_formal/M.05.v1 | RUS-0067 | q_formal | M | Anderson–Morley eigenvalue bound \lambda_max\lemax(deg u+deg v) | untagged | wrapped_related q_formal__M_05_v1_reads_Sum_ext, q_formal__M_05_v1_reads_Sum_plus, q_formal__M_05_v1_reads_Sum | 1 |
| q_formal/M.06.v1 | RUS-0068 | q_formal | M | Algebraic connectivity / Fiedler value | untagged | wrapped_related q_formal__M_06_v1_reads_Sum_ext, q_formal__M_06_v1_reads_Sum_plus, q_formal__M_06_v1_reads_Sum | 1 |
| q_formal/M.07.v1 | RUS-0069 | q_formal | M | Diameter-based algebraic-connectivity floor \lambda_{2}\ge4/(nD) | untagged | wrapped_related q_formal__M_07_v1_reads_Sum_ext, q_formal__M_07_v1_reads_Sum_plus, q_formal__M_07_v1_reads_Sum | 1 |
| q_formal/M.08.v1 | RUS-0070 | q_formal | M | Spectral graph theory (survey) | untagged | wrapped_related q_formal__M_08_v1_reads_Sum_ext, q_formal__M_08_v1_reads_Sum_plus, q_formal__M_08_v1_reads_Sum | 1 |
| q_formal/M.09.v1 | RUS-0071 | q_formal | M | Can one hear the shape of a drum? | untagged | wrapped_related q_formal__M_09_v1_reads_Sum_ext, q_formal__M_09_v1_reads_Sum_plus, q_formal__M_09_v1_reads_Sum | 1 |
| q_formal/M.10.v1 | RUS-0072 | q_formal | M | Graph Laplacian \to Laplace–Beltrami convergence | untagged | wrapped_related q_formal__M_10_v1_reads_Sum_ext, q_formal__M_10_v1_reads_Sum_plus, q_formal__M_10_v1_reads_Sum | 1 |
| q_formal/M.11.v1 | RUS-0073 | q_formal | M | Crystallographic restriction theorem (only n-fold rotational symmetries with n in {1,2,3,4,6} are compatible w | untagged | wrapped_related q_formal__M_11_v1_reads_Sum_ext, q_formal__M_11_v1_reads_Sum_plus, q_formal__M_11_v1_reads_Sum | 1 |
| q_formal/M.12.v1 | RUS-0074 | q_formal | M | Euler–Lagrange first variation | untagged | wrapped_related q_formal__M_12_v1_reads_Sum_ext, q_formal__M_12_v1_reads_Sum_plus, q_formal__M_12_v1_reads_Sum | 1 |
| q_formal/M.13.v1 | RUS-0075 | q_formal | M | Noether's theorem | untagged | wrapped_related q_formal__M_13_v1_reads_Sum_ext, q_formal__M_13_v1_reads_Sum_plus, q_formal__M_13_v1_reads_Sum | 1 |
| q_formal/M.14.v1 | RUS-0076 | q_formal | M | Courant–Friedrichs–Lewy stability condition | untagged | wrapped_related q_formal__M_14_v1_reads_Sum_ext, q_formal__M_14_v1_reads_Sum_plus, q_formal__M_14_v1_reads_Sum | 1 |
| q_formal/M.15.v1 | RUS-0077 | q_formal | M | Green's identity | untagged | wrapped_related q_formal__M_15_v1_reads_Sum_ext, q_formal__M_15_v1_reads_Sum_plus, q_formal__M_15_v1_reads_Sum | 1 |
| q_formal/M.16.v1 | RUS-0078 | q_formal | M | Gauss–Ostrogradsky divergence theorem | untagged | wrapped_related q_formal__M_16_v1_reads_Sum_ext, q_formal__M_16_v1_reads_Sum_plus, q_formal__M_16_v1_reads_Sum | 1 |
| q_formal/M.17.v1 | RUS-0079 | q_formal | M | Störmer–Verlet leapfrog integrator | untagged | wrapped_related q_formal__M_17_v1_reads_Sum_ext, q_formal__M_17_v1_reads_Sum_plus, q_formal__M_17_v1_reads_Sum | 1 |
| q_formal/M.18.v1 | RUS-0080 | q_formal | M | Marsden–West discrete mechanics | untagged | wrapped_related q_formal__M_18_v1_reads_Sum_ext, q_formal__M_18_v1_reads_Sum_plus, q_formal__M_18_v1_reads_Sum | 1 |
| q_formal/M.19.v1 | RUS-0081 | q_formal | M | Lax–Richtmyer stability equivalence | untagged | wrapped_related q_formal__M_19_v1_reads_Sum_ext, q_formal__M_19_v1_reads_Sum_plus, q_formal__M_19_v1_reads_Sum | 1 |
| q_formal/M.20.v1 | RUS-0082 | q_formal | M | Polyak's heavy-ball momentum method | untagged | wrapped_related q_formal__M_20_v1_reads_Sum_ext, q_formal__M_20_v1_reads_Sum_plus, q_formal__M_20_v1_reads_Sum | 1 |
| q_formal/M.21.v1 | RUS-0083 | q_formal | M | Nesterov's accelerated gradient method | untagged | wrapped_related q_formal__M_21_v1_reads_Sum_ext, q_formal__M_21_v1_reads_Sum_plus, q_formal__M_21_v1_reads_Sum | 1 |
| q_formal/M.22.v1 | RUS-0084 | q_formal | M | ODE model of Nesterov's method | untagged | wrapped_related q_formal__M_22_v1_reads_Sum_ext, q_formal__M_22_v1_reads_Sum_plus, q_formal__M_22_v1_reads_Sum | 1 |
| q_formal/M.23.v1 | RUS-0085 | q_formal | M | Integral quadratic constraints for optimizer analysis | untagged | wrapped_related q_formal__M_23_v1_reads_Sum_ext, q_formal__M_23_v1_reads_Sum_plus, q_formal__M_23_v1_reads_Sum | 1 |
| q_formal/M.24.v1 | RUS-0086 | q_formal | M | Onsager reciprocity relations (symmetric linear-response/susceptibility when circulation vanishes) | untagged | wrapped_related q_formal__M_24_v1_reads_Sum_ext, q_formal__M_24_v1_reads_Sum_plus, q_formal__M_24_v1_reads_Sum | 1 |
| q_formal/M.25.v1 | RUS-0087 | q_formal | M | Discrete cosine transform (DCT-II) diagonalization of the free/Neumann path-graph Laplacian | untagged | wrapped_related q_formal__M_25_v1_reads_Sum_ext, q_formal__M_25_v1_reads_Sum_plus, q_formal__M_25_v1_reads_Sum | 1 |
| q_formal/M.26.v1 | RUS-0088 | q_formal | M | Discrete sine transform (DST) diagonalization of the pinned/Dirichlet path-graph Laplacian | untagged | wrapped_related q_formal__M_26_v1_reads_Sum_ext, q_formal__M_26_v1_reads_Sum_plus, q_formal__M_26_v1_reads_Sum | 1 |
| q_formal/M.27.v1 | RUS-0089 | q_formal | M | Chebyshev polynomial expansion of a matrix exponential (modified-Bessel coefficients) | untagged | wrapped_related q_formal__M_27_v1_reads_Sum_ext, q_formal__M_27_v1_reads_Sum_plus, q_formal__M_27_v1_reads_Sum | 1 |
| q_formal/M.28.v1 | RUS-0090 | q_formal | M | Lanczos/Krylov-subspace approximation of matrix functions | untagged | wrapped_related q_formal__M_28_v1_reads_Sum_ext, q_formal__M_28_v1_reads_Sum_plus, q_formal__M_28_v1_reads_Sum | 1 |
| q_formal/M.29.v1 | RUS-0091 | q_formal | M | expm_multiply scaling-and-squaring / Krylov baseline algorithm | untagged | wrapped_related q_formal__M_29_v1_reads_Sum_ext, q_formal__M_29_v1_reads_Sum_plus, q_formal__M_29_v1_reads_Sum | 1 |
| q_formal/M.30.v1 | RUS-0092 | q_formal | M | Regular-polygon planar central configuration (equal masses, rigid rotation) | untagged | wrapped_related q_formal__M_30_v1_reads_Sum_ext, q_formal__M_30_v1_reads_Sum_plus, q_formal__M_30_v1_reads_Sum | 1 |
| q_formal/M.31.v1 | RUS-0093 | q_formal | M | Errors-in-variables (EIV) attenuation: M_hat_OLS/M_true \approx Var(a_true)/(Var(a_true)+Var(noise)), method-o | untagged | wrapped_related q_formal__M_31_v1_reads_Sum_ext, q_formal__M_31_v1_reads_Sum_plus, q_formal__M_31_v1_reads_Sum | 1 |
| q_formal/M.32.v1 | RUS-0094 | q_formal | M | Instrumental-variable (IV) estimation via two independent noisy replicate measurements of the same latent regr | untagged | wrapped_related q_formal__M_32_v1_reads_Sum_ext, q_formal__M_32_v1_reads_Sum_plus, q_formal__M_32_v1_reads_Sum | 1 |
| EQ-015/P.55.v1 | RUS-0096 | EQ-015 | P | Quasinormal-mode analytic representation | untagged | wrapped_related EQ_015__P_55_v1_reads | 1 |
| EQ-015/P.56.v1 | RUS-0097 | EQ-015 | P | QNM review (literature target values) | untagged | wrapped_related EQ_015__P_56_v1_reads | 1 |
| EQ-015/P.57.v1 | RUS-0098 | EQ-015 | P | Hyperboloidal-slicing method | untagged | wrapped_related EQ_015__P_57_v1_reads | 1 |
| EQ-015/P.58.v1 | RUS-0099 | EQ-015 | P | Perfectly Matched Layer absorbing boundary | untagged | wrapped_related EQ_015__P_58_v1_reads | 1 |
| EQ-001/E.01.v1 | RUS-0100 | EQ-001 | E | A mathematical theory of communication | untagged | not_formalisable | 1 |
| EQ-001/E.02.v1 | RUS-0101 | EQ-001 | E | Szilárd's information-work engine | untagged | not_formalisable | 1 |
| EQ-001/E.03.v1 | RUS-0102 | EQ-001 | E | Landauer's erasure principle | untagged | not_formalisable | 1 |
| EQ-001/E.04.v1 | RUS-0103 | EQ-001 | E | It from bit | Dr | not_formalisable | 1 |
| EQ-001/E.05.v1 | RUS-0104 | EQ-001 | E | Stinespring dilation | untagged | not_formalisable | 1 |
| EQ-001/E.06.v1 | RUS-0105 | EQ-001 | E | Completely positive maps | untagged | not_formalisable | 1 |
| EQ-001/E.07.v1 | RUS-0106 | EQ-001 | E | States, Effects, and Operations (Kraus) | untagged | not_formalisable | 1 |
| EQ-015/P.59.v1 | RUS-0107 | EQ-015 | P | Kepler's third law T^2 = 4 pi^2 a^3/(G M) | untagged | wrapped_related EQ_015__P_59_v1_reads | 1 |
| EQ-015/P.60.v1 | RUS-0108 | EQ-015 | P | Bernoulli's equation (steady incompressible streamline energy balance) | untagged | wrapped_related EQ_015__P_60_v1_reads | 1 |
| EQ-015/P.61.v1 | RUS-0109 | EQ-015 | P | Continuity equation A1 v1 = A2 v2 (incompressible 1D duct form) | untagged | wrapped_related EQ_015__P_61_v1_reads | 1 |
| EQ-015/P.62.v1 | RUS-0110 | EQ-015 | P | 2D truss method of joints (joint-equilibrium linear system, m+r=2j determinacy count) | untagged | wrapped_related EQ_015__P_62_v1_reads | 1 |
| EQ-015/P.63.v1 | RUS-0111 | EQ-015 | P | Euler–Bernoulli beam theory | untagged | wrapped_related EQ_015__P_63_v1_reads | 1 |
| EQ-015/P.64.v1 | RUS-0112 | EQ-015 | P | Cubic-Hermite beam FEM element (4-DOF stiffness matrix, consistent UDL fixed-end forces; exact nodal values fo | untagged | wrapped_related EQ_015__P_64_v1_reads | 1 |
| EQ-015/P.65.v1 | RUS-0113 | EQ-015 | P | 1D axial-bar FEM element (k_e = EA/L two-node element) | untagged | wrapped_related EQ_015__P_65_v1_reads | 1 |
| EQ-015/P.66.v1 | RUS-0114 | EQ-015 | P | Modal analysis closed forms for uniform spring-mass chains, omega_n^2 = (2k/m)(1-cos(n pi/(N+1))), and the gen | untagged | wrapped_related EQ_015__P_66_v1_reads | 1 |
| EQ-015/P.67.v1 | RUS-0115 | EQ-015 | P | 1D Ising model + transfer-matrix exact solution (f = -kT ln lambda_+, xi = -1/ln tanh(beta J) at h=0) | untagged | wrapped_related EQ_015__P_67_v1_reads | 1 |
| EQ-015/P.68.v1 | RUS-0116 | EQ-015 | P | 2D square-lattice Ising critical temperature T_c = 2J/(k_B ln(1+sqrt 2)) | untagged | wrapped_related EQ_015__P_68_v1_reads | 1 |
| EQ-015/P.69.v1 | RUS-0117 | EQ-015 | P | 1D Ising real-space decimation RG, K' = (1/2) ln cosh(2K) (b=2 block-spin) | untagged | wrapped_related EQ_015__P_69_v1_reads | 1 |
| EQ-015/P.70.v1 | RUS-0118 | EQ-015 | P | SUVAT kinematics equations (v=u+at, s=ut+\tfrac{1}{2}at^{2}, v^{2}=u^{2}+2as) | untagged | wrapped_related EQ_015__P_70_v1_reads | 1 |
| EQ-015/P.71.v1 | RUS-0119 | EQ-015 | P | Hooke's law F=kx and spring elastic PE \tfrac{1}{2}kx^{2} | untagged | wrapped_related EQ_015__P_71_v1_reads | 1 |
| EQ-015/P.72.v1 | RUS-0120 | EQ-015 | P | Simple-pendulum and mass-spring SHM period (T=2\pi\sqrt(L/g), T=2\pi\sqrt(m/k)) and closed-form SHM motion (x= | untagged | wrapped_related EQ_015__P_72_v1_reads | 1 |
| EQ-015/P.73.v1 | RUS-0121 | EQ-015 | P | Snell's law of refraction n1 sin \theta1 = n2 sin \theta2 and total-internal-reflection critical angle | untagged | wrapped_related EQ_015__P_73_v1_reads | 1 |
| EQ-015/P.74.v1 | RUS-0122 | EQ-015 | P | Young's double-slit interference fringe spacing \Deltay=\lambdaL/d | untagged | wrapped_related EQ_015__P_74_v1_reads | 1 |
| EQ-015/P.75.v1 | RUS-0123 | EQ-015 | P | Diffraction grating equation d sin\theta = m\lambda | untagged | wrapped_related EQ_015__P_75_v1_reads | 1 |
| EQ-015/P.76.v1 | RUS-0124 | EQ-015 | P | Malus's law I=I0 cos^{2}\theta | untagged | wrapped_related EQ_015__P_76_v1_reads | 1 |
| EQ-015/P.77.v1 | RUS-0125 | EQ-015 | P | Radioactive decay law N=N0 e^{-\lambdat} and half-life t\tfrac{1}{2}=ln2/\lambda | untagged | wrapped_related EQ_015__P_77_v1_reads | 1 |
| EQ-015/P.78.v1 | RUS-0126 | EQ-015 | P | Bohr model hydrogen energy levels E_n=-13.6056931/n^{2} eV (full-precision CODATA 2018 Rydberg energy) | untagged | wrapped_related EQ_015__P_78_v1_reads | 1 |
| EQ-015/P.79.v1 | RUS-0127 | EQ-015 | P | Planck-Einstein photon energy relation E=hf=hc/\lambda | untagged | wrapped_related EQ_015__P_79_v1_reads | 1 |
| EQ-015/P.80.v1 | RUS-0128 | EQ-015 | P | Mass-energy equivalence E=mc^{2} | untagged | wrapped_related EQ_015__P_80_v1_reads | 1 |
| EQ-015/P.81.v1 | RUS-0129 | EQ-015 | P | Fourier's law of heat conduction Q/t=kA\DeltaT/L | untagged | wrapped_related EQ_015__P_81_v1_reads | 1 |
| EQ-015/P.82.v1 | RUS-0130 | EQ-015 | P | Newton's law of cooling (convective form) Q/t=hA\DeltaT | untagged | wrapped_related EQ_015__P_82_v1_reads | 1 |
| EQ-015/P.83.v1 | RUS-0131 | EQ-015 | P | Stefan-Boltzmann law P=\varepsilon\sigmaAT^{4} | untagged | wrapped_related EQ_015__P_83_v1_reads | 1 |
| EQ-015/P.84.v1 | RUS-0132 | EQ-015 | P | Carnot heat-engine efficiency \eta=1-Tc/Th | untagged | wrapped_related EQ_015__P_84_v1_reads | 1 |
| EQ-015/P.85.v1 | RUS-0133 | EQ-015 | P | Linear thermal expansion \DeltaL=\alphaL0\DeltaT | untagged | wrapped_related EQ_015__P_85_v1_reads | 1 |
| EQ-015/P.86.v1 | RUS-0134 | EQ-015 | P | Force on a current-carrying wire F=BIL | untagged | wrapped_related EQ_015__P_86_v1_reads | 1 |
| EQ-015/P.87.v1 | RUS-0135 | EQ-015 | P | Solenoid magnetic field B=\mu0nI and straight-wire field B=\mu0I/(2\pir) (Ampère's law special cases) | untagged | wrapped_related EQ_015__P_87_v1_reads | 1 |
| EQ-015/P.88.v1 | RUS-0136 | EQ-015 | P | Faraday's law of induction EMF=-N\Delta\Phi/\Deltat and the motional-EMF special case EMF=BLv | untagged | wrapped_related EQ_015__P_88_v1_reads | 1 |
| EQ-015/P.89.v1 | RUS-0137 | EQ-015 | P | Coulomb's law potential of a point charge V=kq/r, uniform-field relation E=V/d, and capacitor relations (Q=CV, | untagged | wrapped_related EQ_015__P_89_v1_reads | 1 |
| EQ-015/P.90.v1 | RUS-0138 | EQ-015 | P | Real-source terminal voltage with internal resistance V=\varepsilon-Ir | untagged | wrapped_related EQ_015__P_90_v1_reads | 1 |
| EQ-015/P.91.v1 | RUS-0139 | EQ-015 | P | Rotational dynamics: \tau=I\alpha, L=I\omega, KE=\tfrac{1}{2}I\omega^{2}, and standard moment-of-inertia forms | untagged | wrapped_related EQ_015__P_91_v1_reads | 1 |
| EQ-015/P.92.v1 | RUS-0140 | EQ-015 | P | Coulomb friction model f=\muN, incline force components, Atwood machine acceleration, Pascal's principle hydra | untagged | wrapped_related EQ_015__P_92_v1_reads | 1 |
| EQ-015/P.93.v1 | RUS-0141 | EQ-015 | P | Torsion of circular shafts: shear stress \tau=Tr/J, angle of twist \theta=TL/GJ, polar moment of a solid/hollo | untagged | wrapped_related EQ_015__P_93_v1_reads | 1 |
| EQ-015/P.94.v1 | RUS-0142 | EQ-015 | P | Fast Fourier Transform (Cooley–Tukey algorithm; used here via numpy.fft.rfft) | untagged | wrapped_related EQ_015__P_94_v1_reads | 1 |
| EQ-015/P.95.v1 | RUS-0143 | EQ-015 | P | Periodogram / power spectral density estimation (one-sided PSD scaling used here follows the periodogram linea | untagged | wrapped_related EQ_015__P_95_v1_reads | 1 |
| EQ-015/P.96.v1 | RUS-0144 | EQ-015 | P | Total harmonic distortion (THD, ratio of harmonic to fundamental amplitude) | untagged | wrapped_related EQ_015__P_96_v1_reads | 1 |
| EQ-015/P.97.v1 | RUS-0145 | EQ-015 | P | Fokker–Planck equation (and its overdamped/Smoluchowski stationary limit p(x) \propto exp(-V(x)/D)) | untagged | wrapped_related EQ_015__P_97_v1_reads | 1 |
| EQ-015/P.98.v1 | RUS-0146 | EQ-015 | P | Boltzmann distribution p \propto exp(-E/k_B T) | untagged | wrapped_related EQ_015__P_98_v1_reads | 1 |
| EQ-015/P.99.v1 | RUS-0147 | EQ-015 | P | Hydrogen fine-structure energy shift dE_fs = -(Ry alpha^2/n^4)(n/(j+1/2) - 3/4) (relativistic kinetic + spin-o | untagged | wrapped_related EQ_015__P_99_v1_reads | 1 |
| EQ-015/P.100.v1 | RUS-0148 | EQ-015 | P | Normal Zeeman effect dE = m_l mu_B B | untagged | wrapped_related EQ_015__P_100_v1_reads | 1 |
| EQ-015/P.101.v1 | RUS-0149 | EQ-015 | P | Rutherford differential scattering cross section dsigma/dOmega = (Z1 Z2 k_e e^2/4E)^2 / sin^4(theta/2) | untagged | wrapped_related EQ_015__P_101_v1_reads | 1 |
| EQ-015/P.102.v1 | RUS-0150 | EQ-015 | P | Fermi-Dirac distribution | untagged | wrapped_related EQ_015__P_102_v1_reads | 1 |
| EQ-015/P.103.v1 | RUS-0151 | EQ-015 | P | Bose-Einstein distribution | untagged | wrapped_related EQ_015__P_103_v1_reads | 1 |
| EQ-015/P.104.v1 | RUS-0152 | EQ-015 | P | Quantum harmonic oscillator canonical partition function Z = 1/(2 sinh(hbar omega/2 k_B T)) | untagged | wrapped_related EQ_015__P_104_v1_reads | 1 |
| EQ-015/P.105.v1 | RUS-0153 | EQ-015 | P | Planck's law of blackbody spectral radiance B(lambda,T) | untagged | wrapped_related EQ_015__P_105_v1_reads | 1 |
| EQ-015/P.106.v1 | RUS-0154 | EQ-015 | P | Rectangular waveguide TE_mn cutoff frequency | untagged | wrapped_related EQ_015__P_106_v1_reads | 1 |
| EQ-015/P.107.v1 | RUS-0155 | EQ-015 | P | Oscillating electric dipole radiated power P = p0^2 omega^4/(12 pi eps0 c^3) | untagged | wrapped_related EQ_015__P_107_v1_reads | 1 |
| EQ-015/P.108.v1 | RUS-0156 | EQ-015 | P | Relativistic Doppler shift (radial) f_obs = f_source sqrt((1-beta)/(1+beta)) | untagged | wrapped_related EQ_015__P_108_v1_reads | 1 |
| EQ-015/P.109.v1 | RUS-0157 | EQ-015 | P | Vis-viva equation v^2 = GM(2/r - 1/a) | untagged | wrapped_related EQ_015__P_109_v1_reads | 1 |
| EQ-015/P.110.v1 | RUS-0158 | EQ-015 | P | General-relativistic perihelion/apsidal precession d_phi = 6 pi G M/(c^2 a (1-e^2)) | untagged | wrapped_related EQ_015__P_110_v1_reads | 1 |
| EQ-015/P.111.v1 | RUS-0159 | EQ-015 | P | Schwarzschild radius r_s = 2GM/c^2 | untagged | wrapped_related EQ_015__P_111_v1_reads | 1 |
| EQ-015/P.112.v1 | RUS-0160 | EQ-015 | P | Schwarzschild static-observer gravitational time dilation d_tau/dt = sqrt(1-r_s/r) | untagged | wrapped_related EQ_015__P_112_v1_reads | 1 |
| EQ-015/P.113.v1 | RUS-0161 | EQ-015 | P | Debye model heat capacity, low-temperature T^3 limit C_V = (12 pi^4/5) N k_B (T/theta_D)^3 | untagged | wrapped_related EQ_015__P_113_v1_reads | 1 |
| EQ-015/P.114.v1 | RUS-0162 | EQ-015 | P | Resonance quality factor from damping ratio Q = 1/(2 zeta) | untagged | wrapped_related EQ_015__P_114_v1_reads | 1 |
| EQ-015/P.115.v1 | RUS-0163 | EQ-015 | P | Ziegler-Nichols closed-loop PID tuning rule (Kp=0.6 K_u, Ti=0.5 P_u, Td=0.125 P_u) | untagged | wrapped_related EQ_015__P_115_v1_reads | 1 |
| EQ-015/P.116.v1 | RUS-0164 | EQ-015 | P | Hagen-Poiseuille equation Q = pi r^4 dP/(8 mu L) | untagged | wrapped_related EQ_015__P_116_v1_reads | 1 |
| EQ-015/P.117.v1 | RUS-0165 | EQ-015 | P | Blasius laminar flat-plate boundary layer similarity solution (delta_99\approx5.0x/sqrt(Re_x), Cf_x=0.664/sqrt | untagged | wrapped_related EQ_015__P_117_v1_reads | 1 |
| ChemDomain_ledger/C.01.v1 | RUS-0166 | ChemDomain_ledger | C | Amount of substance n = m/M (using IUPAC atomic-weight molar masses) | Definition | definition C01_v1_amount_of_substance | 1 |
| ChemDomain_ledger/C.02.v1 | RUS-0167 | ChemDomain_ledger | C | Percent composition by mass %X = n_X M_X/M_compound * 100 | Definition | definition C02_v1_percent_composition | 1 |
| ChemDomain_ledger/C.03.v1 | RUS-0168 | ChemDomain_ledger | C | Mass-mass stoichiometry from a balanced equation | Definition | definition C03_v1_mass_mass_stoichiometry | 1 |
| ChemDomain_ledger/C.04.v1 | RUS-0169 | ChemDomain_ledger | C | Molarity c = n/V | Definition | definition C04_v1_molarity | 1 |
| ChemDomain_ledger/C.05.v1 | RUS-0170 | ChemDomain_ledger | C | Dilution C1 V1 = C2 V2 | Definition | definition C05_v1_dilution | 1 |
| ChemDomain_ledger/C.06.v1 | RUS-0171 | ChemDomain_ledger | C | pH scale pH = -log10([H+]) | Definition | definition C06_v1_pH | 1 |
| ChemDomain_ledger/C.07.v1 | RUS-0172 | ChemDomain_ledger | C | Limiting-reagent product yield (compare n_i/coeff_i, take the minimum) | Definition | definition C07_v1_ratios, C07_v1_limiting_ratio | 1 |
| ChemDomain_ledger/C.08.v1 | RUS-0173 | ChemDomain_ledger | C | Empirical-formula mole ratio from percent composition | Definition | definition C08_v1_moles, C08_v1_mole_ratio | 1 |
| ChemDomain_ledger/C.09.v1 | RUS-0174 | ChemDomain_ledger | C | Molecular-formula multiplier k = M_molecular/M_empirical | Definition | definition C09_v1_multiplier | 1 |
| ChemDomain_ledger/C.10.v1 | RUS-0175 | ChemDomain_ledger | C | Graham's law of effusion rate1/rate2 = sqrt(M2/M1) | Definition | definition C10_v1_grahams_law | 1 |
| ChemDomain_ledger/C.11.v1 | RUS-0176 | ChemDomain_ledger | C | Hess's law of constant heat summation | Definition | definition C11_v1_hess_total | 1 |
| ChemDomain_ledger/C.12.v1 | RUS-0177 | ChemDomain_ledger | C | Reaction enthalpy from average bond dissociation energies dH = sum(broken) - sum(formed) | Definition | definition C12_v1_bond_enthalpy | 1 |
| ChemDomain_ledger/C.13.v1 | RUS-0178 | ChemDomain_ledger | C | Law of mass action / equilibrium constant Kc = [B]/[A], ICE-table solution | Definition | definition C13_v1_equilibrium_constant | 1 |
| ChemDomain_ledger/C.14.v1 | RUS-0179 | ChemDomain_ledger | C | Le Chatelier's principle (quantitative re-equilibration) | untagged | not_formalisable | 1 |
| ChemDomain_ledger/C.15.v1 | RUS-0180 | ChemDomain_ledger | C | Henderson-Hasselbalch equation pH = pKa + log10([A-]/[HA]) | Definition | definition C15_v1_henderson_hasselbalch | 1 |
| ChemDomain_ledger/C.16.v1 | RUS-0181 | ChemDomain_ledger | C | Acid-base titration equivalence-point stoichiometry C_acid V_acid = C_base V_base | Definition | definition C16_v1_titration_equivalence | 1 |
| ChemDomain_ledger/C.17.v1 | RUS-0182 | ChemDomain_ledger | C | Solubility product Ksp, molar solubility of a 1:1 salt s = sqrt(Ksp) | Definition | definition C17_v1_solubility | 1 |
| ChemDomain_ledger/C.18.v1 | RUS-0183 | ChemDomain_ledger | C | Standard electrochemical cell potential E_cell = E_cathode - E_anode, standard reduction potentials | Definition | definition C18_v1_cell_potential | 1 |
| ChemDomain_ledger/C.19.v1 | RUS-0184 | ChemDomain_ledger | C | Faraday's laws of electrolysis m = I t M/(n F) | Definition | definition C19_v1_faraday_mass | 1 |
| ChemDomain_ledger/C.20.v1 | RUS-0185 | ChemDomain_ledger | C | Bimolecular (mixed second-order) rate law rate = k[A][B] | Definition | definition C20_v1_bimolecular_rate | 1 |
| ChemDomain_ledger/C.21.v1 | RUS-0186 | ChemDomain_ledger | C | Raoult's law P = x_solvent P0 | Definition | definition C21_v1_raoults_law | 1 |
| ChemDomain_ledger/C.22.v1 | RUS-0187 | ChemDomain_ledger | C | Colligative property closed form dT = i K m (boiling-point elevation / freezing-point depression, one closed f | Definition | definition C22_v1_colligative_dT | 1 |
| ChemDomain_ledger/C.23.v1 | RUS-0188 | ChemDomain_ledger | C | Van der Waals real-gas equation of state P = nRT/(V-nb) - a n^2/V^2 | Definition | definition C23_v1_van_der_waals | 1 |
| ChemDomain_ledger/C.24.v1 | RUS-0189 | ChemDomain_ledger | C | Clausius-Clapeyron equation ln(P2/P1) = -(dHvap/R)(1/T2-1/T1) | Definition | definition C24_v1_clausius_clapeyron | 1 |
| ChemDomain_ledger/C.25.v1 | RUS-0190 | ChemDomain_ledger | C | Gibbs free energy dG = dH - T dS | Definition | definition C25_v1_gibbs_free_energy | 1 |
| ChemDomain_ledger/C.26.v1 | RUS-0191 | ChemDomain_ledger | C | Van 't Hoff equation ln(K2/K1) = -(dH/R)(1/T2-1/T1) | Definition | definition C26_v1_vant_hoff | 1 |
| ChemDomain_ledger/C.27.v1 | RUS-0192 | ChemDomain_ledger | C | Nernst equation E = E0 - (RT/nF) ln Q | Definition | definition C27_v1_nernst | 1 |
| ChemDomain_ledger/C.28.v1 | RUS-0193 | ChemDomain_ledger | C | Arrhenius equation, two-temperature activation energy Ea = -R ln(k2/k1)/(1/T2-1/T1) | Definition | definition C28_v1_arrhenius_ea | 1 |
| ChemDomain_ledger/C.29.v1 | RUS-0194 | ChemDomain_ledger | C | Zero-order integrated rate law [A] = [A]0 - k t | Definition | definition C29_v1_zero_order | 1 |
| ChemDomain_ledger/C.30.v1 | RUS-0195 | ChemDomain_ledger | C | Second-order integrated rate law 1/[A] = 1/[A]0 + k t | Definition | definition C30_v1_second_order | 1 |
| ChemDomain_ledger/C.31.v1 | RUS-0196 | ChemDomain_ledger | C | Beer-Lambert law A = epsilon b c | Definition | definition C31_v1_beer_lambert | 1 |
| ChemDomain_ledger/C.32.v1 | RUS-0197 | ChemDomain_ledger | C | Bragg's law n lambda = 2 d sin(theta) | Definition | definition C32_v1_braggs_law | 1 |
| ChemDomain_ledger/C.33.v1 | RUS-0198 | ChemDomain_ledger | C | Born-Landé lattice energy U = -(N_A M z1 z2 e^2)/(4 pi eps0 r0)(1-1/n) | Definition | definition C33_v1_born_lande | 1 |
| ChemDomain_ledger/C.34.v1 | RUS-0199 | ChemDomain_ledger | C | Rigid-rotor rotational constant B = h/(8 pi^2 mu r^2) | Definition | definition C34_v1_rotational_constant | 1 |
| ChemDomain_ledger/C.35.v1 | RUS-0200 | ChemDomain_ledger | C | Debye-Hückel limiting law log10(gamma) = -A z^2 sqrt(I) | Definition | definition C35_v1_debye_huckel | 1 |
| ChemDomain_ledger/C.36.v1 | RUS-0201 | ChemDomain_ledger | C | Michaelis-Menten enzyme kinetics v = Vmax [S]/(Km+[S]) | Definition | definition C36_v1_michaelis_menten | 1 |
| ChemDomain_ledger/C.37.v1 | RUS-0202 | ChemDomain_ledger | C | Eyring transition-state theory k = (kB T/h) exp(-dG_ddagger/(R T)) | Definition | definition C37_v1_eyring | 1 |
| ChemDomain_ledger/C.38.v1 | RUS-0203 | ChemDomain_ledger | C | Marcus electron-transfer theory k = A exp(-(dG0+lambda)^2/(4 lambda kB T)) | Definition | definition C38_v1_marcus | 1 |
| ChemDomain_ledger/C.39.v1 | RUS-0204 | ChemDomain_ledger | C | Langmuir adsorption isotherm theta = K P/(1+K P) | Definition | definition C39_v1_langmuir | 1 |
| ChemDomain_ledger/C.40.v1 | RUS-0205 | ChemDomain_ledger | C | Brunauer-Emmett-Teller (BET) multilayer adsorption isotherm V/Vm = C x/((1-x)(1-x+Cx)) | Definition | definition C40_v1_bet | 1 |
| ChemDomain_ledger/C.41.v1 | RUS-0206 | ChemDomain_ledger | C | Zero-point-energy model of the primary kinetic isotope effect k_H/k_D = exp(hc(w_H-w_D)/(2 kB T)) | Definition | definition C41_v1_kie | 1 |
| ChemDomain_ledger/C.42.v1 | RUS-0207 | ChemDomain_ledger | C | Stokes-Einstein diffusion coefficient D = kB T/(6 pi eta r) | Definition | definition C42_v1_stokes_einstein | 1 |
| BiologyDomain_living_unit/B.01.v1 | RUS-0208 | BiologyDomain_living_unit | B | Compound microscope total magnification M = M_objective * M_eyepiece | Definition | definition B01_v1_magnification | 1 |
| BiologyDomain_living_unit/B.02.v1 | RUS-0209 | BiologyDomain_living_unit | B | Surface-area-to-volume ratio of a cube SA/V = 6/side | Definition | definition B02_v1_sa_to_v | 1 |
| BiologyDomain_living_unit/B.03.v1 | RUS-0210 | BiologyDomain_living_unit | B | Population density density = count/area | Definition | definition B03_v1_density | 1 |
| BiologyDomain_living_unit/B.04.v1 | RUS-0211 | BiologyDomain_living_unit | B | Body mass index BMI = mass_kg/height_m^2 | Definition | definition B04_v1_bmi | 1 |
| BiologyDomain_living_unit/B.05.v1 | RUS-0212 | BiologyDomain_living_unit | B | Mendelian monohybrid cross recessive-phenotype probability P(aa) = p_maternal * p_paternal | Definition | definition B05_v1_p_aa | 1 |
| BiologyDomain_living_unit/B.06.v1 | RUS-0213 | BiologyDomain_living_unit | B | Cardiac output CO = HR * SV | Definition | definition B06_v1_cardiac_output | 1 |
| BiologyDomain_living_unit/B.07.v1 | RUS-0214 | BiologyDomain_living_unit | B | Hardy-Weinberg equilibrium, homozygous-recessive genotype frequency q^2 | Definition | definition B07_v1_q_squared | 1 |
| BiologyDomain_living_unit/B.08.v1 | RUS-0215 | BiologyDomain_living_unit | B | Allele frequency from genotype counts q = (2 n_aa + n_Aa)/(2(n_AA+n_Aa+n_aa)) | Definition | definition B08_v1_allele_freq | 1 |
| BiologyDomain_living_unit/B.09.v1 | RUS-0216 | BiologyDomain_living_unit | B | Chi-square goodness-of-fit statistic chi2 = sum((O_i-E_i)^2/E_i) | Definition | definition B09_v1_chi2 | 1 |
| BiologyDomain_living_unit/B.10.v1 | RUS-0217 | BiologyDomain_living_unit | B | Exponential (Malthusian) population growth N = N0 exp(r t) | Definition | definition B10_v1_exponential_growth | 1 |
| BiologyDomain_living_unit/B.11.v1 | RUS-0218 | BiologyDomain_living_unit | B | Logistic population growth with carrying capacity N = K/(1+((K-N0)/N0) exp(-r t)) | Definition | definition B11_v1_logistic_growth | 1 |
| BiologyDomain_living_unit/B.12.v1 | RUS-0219 | BiologyDomain_living_unit | B | Lincoln-Petersen mark-recapture population estimator N = M C/R | Definition | definition B12_v1_lincoln_petersen | 1 |
| BiologyDomain_living_unit/B.13.v1 | RUS-0220 | BiologyDomain_living_unit | B | Plant/cell water potential Psi = Psi_s + Psi_p | Definition | definition B13_v1_water_potential | 1 |
| BiologyDomain_living_unit/B.14.v1 | RUS-0221 | BiologyDomain_living_unit | B | Fick's first law of diffusion rate = D A (dC/dx) | Definition | definition B14_v1_ficks_law | 1 |
| BiologyDomain_living_unit/B.15.v1 | RUS-0222 | BiologyDomain_living_unit | B | Respiratory quotient RQ = CO2_produced/O2_consumed | Definition | definition B15_v1_respiratory_quotient | 1 |
| BiologyDomain_living_unit/B.16.v1 | RUS-0223 | BiologyDomain_living_unit | B | Goldman-Hodgkin-Katz multi-ion membrane potential Vm = (RT/F) ln((P_K K_out+P_Na Na_out+P_Cl Cl_in)/(P_K K_in+ | Definition | definition B16_v1_ghk_potential | 1 |
| BiologyDomain_living_unit/B.17.v1 | RUS-0224 | BiologyDomain_living_unit | B | Hill equation cooperative ligand binding Y = S^n/(S05^n+S^n) (Vmax-scaled variant also serves the PhD alloster | Definition | definition B17_v1_hill_equation | 1 |
| BiologyDomain_living_unit/B.18.v1 | RUS-0225 | BiologyDomain_living_unit | B | Lotka-Volterra predator-prey interior equilibrium (x*, y*) = (gamma/delta, alpha/beta) | Definition | definition B18_v1_lv_equilibrium | 1 |
| BiologyDomain_living_unit/B.19.v1 | RUS-0226 | BiologyDomain_living_unit | B | One-compartment pharmacokinetic clearance CL = k Vd | Definition | definition B19_v1_clearance | 1 |
| BiologyDomain_living_unit/B.20.v1 | RUS-0227 | BiologyDomain_living_unit | B | One-compartment IV-bolus area under the curve AUC = C0/k | Definition | definition B20_v1_auc | 1 |
| BiologyDomain_living_unit/B.21.v1 | RUS-0228 | BiologyDomain_living_unit | B | Mutation-selection balance, recessive allele q_hat = sqrt(mu/s) | Definition | definition B21_v1_mutation_selection_balance | 1 |
| BiologyDomain_living_unit/B.22.v1 | RUS-0229 | BiologyDomain_living_unit | B | Kleiber's law, 3/4-power metabolic scaling BMR = a M^0.75 | Definition | definition B22_v1_kleiber | 1 |
| BiologyDomain_living_unit/B.23.v1 | RUS-0230 | BiologyDomain_living_unit | B | Jukes-Cantor phylogenetic distance d = -3/4 ln(1-4p/3) | Definition | definition B23_v1_jukes_cantor | 1 |
| BiologyDomain_living_unit/B.24.v1 | RUS-0231 | BiologyDomain_living_unit | B | Moran/Wright-Fisher genic-selection fixation probability p_fix = (1-exp(-2 Ne s p0))/(1-exp(-2 Ne s)) | Definition | definition B24_v1_fixation_probability | 1 |
| BiologyDomain_living_unit/B.25.v1 | RUS-0232 | BiologyDomain_living_unit | B | Kingman coalescent expected TMRCA E[TMRCA] = 2(1-1/n) Ne | Definition | definition B25_v1_expected_tmrca | 1 |
| BiologyDomain_living_unit/B.26.v1 | RUS-0233 | BiologyDomain_living_unit | B | Price equation, selection-only term Delta_zbar = Cov(w,z)/wbar | Definition | definition B26_v1_price_equation | 1 |
| BiologyDomain_living_unit/B.27.v1 | RUS-0234 | BiologyDomain_living_unit | B | Lotka-Volterra interior-equilibrium Jacobian eigenvalue magnitude \\|Im(lambda)\\|= sqrt(alpha gamma) | Definition | definition B27_v1_lv_eigenvalue_magnitude | 1 |
| BiologyDomain_living_unit/B.28.v1 | RUS-0235 | BiologyDomain_living_unit | B | Luria-Delbrück fluctuation-test expected mutant number m = N mu | Definition | definition B28_v1_expected_mutants | 1 |
| BiologyDomain_living_unit/B.29.v1 | RUS-0236 | BiologyDomain_living_unit | B | Karlin-Altschul local-alignment E-value E = K m n exp(-lam S) | Definition | definition B29_v1_karlin_altschul_evalue | 1 |
| BiologyDomain_living_unit/B.30.v1 | RUS-0237 | BiologyDomain_living_unit | B | Approaching-sound auditory time-dilation effect sizes (+15% approach / -6% recede) | untagged | not_formalisable | 1 |
| EQ-015/B.01.v1 | RUS-0238 | EQ-015 | B | \forall\, \alpha,\beta,u,dt \in \mathbb{Q},\ \beta \neq 0 \implies \mathrm{step}(\alpha,\beta,u,dt,\mathrm{set | Th_coqc | wrapped_related EQ_015__B_01_v1_reads | 1 |
| EQ-015/B.02.v1 | RUS-0239 | EQ-015 | B | \forall\, \alpha,\beta,u,dt,C \in \mathbb{Q},\ \beta \neq 0 \implies \mathrm{step}(\alpha,\beta,u,dt,C) - \mat | Th_coqc | wrapped_related EQ_015__B_02_v1_reads | 1 |
| EQ-015/B.03.v1 | RUS-0240 | EQ-015 | B | \forall\, \alpha,\beta,u,dt \in \mathbb{Q},\ \beta \neq 0,\ \forall\, n \in \mathbb{N},\, C \in \mathbb{Q}:\qu | Th_coqc | wrapped_related EQ_015__B_03_v1_reads | 1 |
| EQ-015/B.04.v1 | RUS-0241 | EQ-015 | B | \forall\, h \in \mathbb{Q}:\quad \mathrm{disc}(-h) = \mathrm{disc}(h), \quad \mathrm{disc}(h) := 4 - 27h^2 | Th_coqc | wrapped_related EQ_015__B_04_v1_reads | 1 |
| EQ-015/B.05.v1 | RUS-0242 | EQ-015 | B | \forall\, R,h \in \mathbb{Q}:\quad h = R - R^3 \implies 27h^2 - 4 = (3R^2-1)(9R^4 - 15R^2 + 4) | Th_coqc | wrapped_related EQ_015__B_05_v1_reads | 1 |
| EQ-015/B.06.v1 | RUS-0243 | EQ-015 | B | \forall\, R,h \in \mathbb{Q}:\quad V_p(R,h)=0 \wedge V_{pp}(R)=0 \implies 27h^2 = 4, \quad V_p(R,h) := R^3 - R | Th_coqc | wrapped_related EQ_015__B_06_v1_reads | 1 |
| EQ-015/B.07.v1 | RUS-0244 | EQ-015 | B | \forall\, h \in \mathbb{Q}:\quad \mathrm{disc}(h) > 0 \iff 27h^2 < 4 | Th_coqc | wrapped_related EQ_015__B_07_v1_reads | 1 |
| EQ-015/B.08.v1 | RUS-0245 | EQ-015 | B | \forall\, R,h \in \mathbb{Q}:\quad V_p(R,h)=0 \wedge V_{pp}(R)=0 \implies V_{pp}(R) = 0 | Th_coqc | wrapped_related EQ_015__B_08_v1_reads | 1 |
| EQ-015/B.09.v1 | RUS-0246 | EQ-015 | B | \forall\, R,h,dt \in \mathbb{Q},\ dt \neq 0:\quad \mathrm{repair\_step}(R,h,dt) = R \iff V_p(R,h) = 0, \quad \ | Th_coqc | wrapped_related EQ_015__B_09_v1_reads | 1 |
| Theta/P.01.v1 | R1T-0001 | Theta | P | Theorem real_quartet_no_cp_readout :
  forall a b c d : Q,
    (cim (Cmul (Cmul (mkC a 0) (mkC b 0))
          | Th_coqc | closed real_quartet_no_cp_readout | 1 |
| Theta/P.02.v1 | R1T-0002 | Theta | P | Theorem theta_census_exists_3 :
  exists w01 w02 w12 : Q,
    (0 <= w01)%Q /\ (0 <= w02)%Q /\ (0 <= w12)%Q /\
 | Th_coqc | closed theta_census_exists_3 | 1 |
| Theta/P.03.v1 | R1T-0003 | Theta | P | Theorem theta_census_unique_3 :
  forall w01 w02 w12 v01 v02 v12 : Q,
    (L01 == - w01)%Q -> (L02 == - w02)%Q | Th_coqc | closed theta_census_unique_3 | 1 |
| Theta/P.04.v1 | R1T-0004 | Theta | P | Theorem edge_generators_independent_3 :
  forall a b c : Q,
    (a + b == 0)%Q -> (- a == 0)%Q -> (- b == 0)%Q | Th_coqc | closed edge_generators_independent_3 | 1 |
| Theta/P.05.v1 | R1T-0005 | Theta | P | Theorem fixed_point_balance_law :
  (p0*p0*p0*s0 + p1*p1*p1*s1 + p2*p2*p2*s2 == 0)%Q. | Th_coqc | closed fixed_point_balance_law | 1 |
| Theta/P.06.v1 | R1T-0006 | Theta | P | Theorem mirror_symmetry_is_dead :
  forall a b gp p : Q,
    ~ (b == 0)%Q ->
    (gp + a*p + b*(p*p*p) == 0)%Q | Th_coqc | closed mirror_symmetry_is_dead | 1 |
| Theta/P.07.v1 | R1T-0007 | Theta | P | Theorem agreement_is_dead :
  forall a b p : Q,
    ~ (a == 0)%Q ->
    (a*p + b*(p*p*p) == 0)%Q ->            | Th_coqc | closed agreement_is_dead | 1 |
| Theta/P.08.v1 | R1T-0008 | Theta | P | Theorem locus_Z1Z3_J_square :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi1 == Phi3)%Q -> (P | Th_coqc | closed locus_Z1Z3_J_square | 1 |
| Theta/P.09.v1 | R1T-0009 | Theta | P | Lemma qsquare_nonneg : forall x : Q, (0 <= x*x)%Q. | Th_coqc | closed qsquare_nonneg | 1 |
| Theta/P.10.v1 | R1T-0010 | Theta | P | Corollary locus_Z1Z3_J_nonneg :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi1 == Phi3)%Q ->  | Th_coqc | closed locus_Z1Z3_J_nonneg | 1 |
| Theta/P.11.v1 | R1T-0011 | Theta | P | Lemma qsquare_pos_of_nonzero : forall x : Q, ~ (x == 0)%Q -> (0 < x*x)%Q. | Th_coqc | closed qsquare_pos_of_nonzero | 1 |
| Theta/P.12.v1 | R1T-0012 | Theta | P | Corollary locus_Z1Z3_J_pos :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi1 == Phi3)%Q -> (Ps | Th_coqc | closed locus_Z1Z3_J_pos | 1 |
| Theta/P.13.v1 | R1T-0013 | Theta | P | Theorem locus_Z0Z2_J_square :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi0 == Phi2)%Q -> (P | Th_coqc | closed locus_Z0Z2_J_square | 1 |
| Theta/P.14.v1 | R1T-0014 | Theta | P | Corollary locus_Z0Z2_J_nonneg :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi0 == Phi2)%Q ->  | Th_coqc | closed locus_Z0Z2_J_nonneg | 1 |
| Theta/P.15.v1 | R1T-0015 | Theta | P | Corollary locus_Z0Z2_J_pos :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi0 == Phi2)%Q -> (Ps | Th_coqc | closed locus_Z0Z2_J_pos | 1 |
| Theta/P.16.v1 | R1T-0016 | Theta | P | Theorem diffR_taylor_identity :
  forall Phi0 Phi2 Phi3 Psi0 Psi2 Psi3 dPhi dPsi : Q,
    (
      (* diffR, ex | Th_coqc | closed diffR_taylor_identity | 1 |
| Theta/P.17.v1 | R1T-0017 | Theta | P | Theorem diffRec_taylor_identity :
  forall Phi0 Phi2 Phi3 Psi0 Psi2 Psi3 dPhi dPsi : Q,
    (
      (* diffRec | Th_coqc | closed diffRec_taylor_identity | 1 |
| Theta/P.18.v1 | R1T-0018 | Theta | P | Theorem linear_diff_system_nondegenerate :
  forall D E F dPhi dPsi : Q,
    (D*dPhi + E*dPsi == 0)%Q ->
    ( | Th_coqc | closed linear_diff_system_nondegenerate | 1 |
| Theta/P.19.v1 | R1T-0019 | Theta | P | Theorem edge_locus_kills_support :
  forall Phi_i Phi_j Psi_i Psi_j : Q,
    (Phi_i == Phi_j)%Q -> (Psi_i == P | Th_coqc | closed edge_locus_kills_support | 1 |
| Theta/P.20.v1 | R1T-0020 | Theta | P | Corollary edge_locus_incompatible_with_strict_support_rule :
  forall Phi_i Phi_j Psi_i Psi_j : Q,
    (Phi_i  | Th_coqc | closed edge_locus_incompatible_with_strict_support_rule | 1 |
| Theta/P.21.v1 | R1T-0021 | Theta | P | Corollary c4_edge01_locus_excluded :
  forall Phi0 Phi1 Psi0 Psi1 : Q,
    (Phi0 == Phi1)%Q -> (Psi0 == Psi1)% | Th_coqc | closed c4_edge01_locus_excluded | 1 |
| Theta/P.22.v1 | R1T-0022 | Theta | P | Corollary c4_edge12_locus_excluded :
  forall Phi1 Phi2 Psi1 Psi2 : Q,
    (Phi1 == Phi2)%Q -> (Psi1 == Psi2)% | Th_coqc | closed c4_edge12_locus_excluded | 1 |
| Theta/P.23.v1 | R1T-0023 | Theta | P | Corollary c4_edge23_locus_excluded :
  forall Phi2 Phi3 Psi2 Psi3 : Q,
    (Phi2 == Phi3)%Q -> (Psi2 == Psi3)% | Th_coqc | closed c4_edge23_locus_excluded | 1 |
| Theta/P.24.v1 | R1T-0024 | Theta | P | Corollary c4_edge03_locus_excluded :
  forall Phi0 Phi3 Psi0 Psi3 : Q,
    (Phi0 == Phi3)%Q -> (Psi0 == Psi3)% | Th_coqc | closed c4_edge03_locus_excluded | 1 |
| Theta/P.25.v1 | R1T-0025 | Theta | P | Corollary c4_reflection_01_23_excluded :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi0 == Ph | Th_coqc | closed c4_reflection_01_23_excluded | 1 |
| Theta/P.26.v1 | R1T-0026 | Theta | P | Corollary c4_reflection_12_30_excluded :
  forall Phi0 Phi1 Phi2 Phi3 Psi0 Psi1 Psi2 Psi3 : Q,
    (Phi1 == Ph | Th_coqc | closed c4_reflection_12_30_excluded | 1 |
| Theta/P.27.v1 | R1T-0027 | Theta | P | Theorem n2_empty_support_dead :
  forall p s : Q,
    (- p + p*p*p == 0)%Q ->
    ((- (1#1) + (3#1)*(p*p)) * s | Th_coqc | closed n2_empty_support_dead | 1 |
| Theta/P.28.v1 | R1T-0028 | Theta | P | Lemma red_rsum :
  ((4#1) * ((- D*D*E - p0 + p0*p0*p0) + (D*D*E - p1 + p1*p1*p1))
   == U * (U*U + (3#1)*(D*D) | Th_coqc | closed red_rsum | 1 |
| Theta/P.29.v1 | R1T-0029 | Theta | P | Lemma red_rdiff :
  ((4#1) * ((- D*D*E - p0 + p0*p0*p0) - (D*D*E - p1 + p1*p1*p1))
   == D * (- (8#1)*(D*E) -  | Th_coqc | closed red_rdiff | 1 |
| Theta/P.30.v1 | R1T-0030 | Theta | P | Lemma red_csum :
  ((4#1) * ((- D*E*E + (- (1#1) + (3#1)*(p0*p0))*s0)
            + (D*E*E + (- (1#1) + (3#1)* | Th_coqc | closed red_csum | 1 |
| Theta/P.31.v1 | R1T-0031 | Theta | P | Lemma red_cdiff :
  ((4#1) * ((- D*E*E + (- (1#1) + (3#1)*(p0*p0))*s0)
            - (D*E*E + (- (1#1) + (3#1) | Th_coqc | closed red_cdiff | 1 |
| Theta/P.32.v1 | R1T-0032 | Theta | P | Theorem n2_edge_present_dead :
  forall U D T E : Q,
    (U * (U*U + (3#1)*(D*D) - (4#1)) == 0)%Q ->
    (D *  | Th_coqc | closed n2_edge_present_dead | 1 |
| Theta/P.33.v1 | R1T-0033 | Theta | P | Theorem n2_no_living_fixed_point :
  forall p0 p1 s0 s1 w : Q,
    ( ((w == 0)%Q /\ (0 <= (p0-p1)*(s0-s1))%Q)
 | Th_coqc | closed n2_no_living_fixed_point | 1 |
| Theta/P.34.v1 | R1T-0034 | Theta | P | Lemma qsign_exists : forall x : Q, exists e : Q, (e*e == 1)%Q /\ (0 <= e*x)%Q. | Th_coqc | closed qsign_exists | 1 |
| Theta/P.35.v1 | R1T-0035 | Theta | P | Theorem cyclic_product_switching_invariant_triangle :
  forall a01 a12 a20 eps0 eps1 eps2 : Q,
    (eps0*eps0  | Th_coqc | closed cyclic_product_switching_invariant_triangle | 1 |
| Theta/P.36.v1 | R1T-0036 | Theta | P | Theorem cyclic_product_switching_invariant_C4 :
  forall a01 a12 a23 a30 eps0 eps1 eps2 eps3 : Q,
    (eps0*ep | Th_coqc | closed cyclic_product_switching_invariant_C4 | 1 |
| Theta/P.37.v1 | R1T-0037 | Theta | P | Theorem tree_gauge_fixable_P3 :
  forall a01 a12 : Q,
    exists eps0 eps1 eps2 : Q,
      (eps0*eps0 == 1)%Q  | Th_coqc | closed tree_gauge_fixable_P3 | 1 |
| Theta/P.38.v1 | R1T-0038 | Theta | P | Theorem tree_gauge_fixable_star3 :
  forall a01 a02 : Q,
    exists eps0 eps1 eps2 : Q,
      (eps0*eps0 == 1) | Th_coqc | closed tree_gauge_fixable_star3 | 1 |
| Theta/P.39.v1 | R1T-0039 | Theta | P | Theorem tree_gauge_fixable_P4 :
  forall a01 a12 a23 : Q,
    exists eps0 eps1 eps2 eps3 : Q,
      (eps0*eps0 | Th_coqc | closed tree_gauge_fixable_P4 | 1 |
| Theta/P.40.v1 | R1T-0040 | Theta | P | Theorem tree_gauge_fixable_star4 :
  forall a01 a02 a03 : Q,
    exists eps0 eps1 eps2 eps3 : Q,
      (eps0*e | Th_coqc | closed tree_gauge_fixable_star4 | 1 |
| Theta/P.41.v1 | R1T-0041 | Theta | P | Theorem quartet_rescale_invariant :
  forall alpha0 alpha1 beta1 beta2 v01 v12 v02 v11 : Cq,
    (cre alpha0 * | Th_coqc | closed quartet_rescale_invariant | 1 |
| Theta/P.42.v1 | R1T-0042 | Theta | P | Theorem quartet_real_scalar_rescale :
  forall lam : Q, forall v01 v12 v02 v11 : Cq,
    (quartetJraw (Cmul (m | Th_coqc | closed quartet_real_scalar_rescale | 1 |
| Theta/P.43.v1 | R1T-0043 | Theta | P | Theorem family_B_K3_exact :
  forall a1 a2 a3 : Q,
    (cim (Cmul (Cmul (zB a1) (zB a2)) (Cconj (zB a3))) == a | Th_coqc | closed family_B_K3_exact | 1 |
| Theta/P.44.v1 | R1T-0044 | Theta | P | Theorem family_B_C4_vanishes :
  forall a01 a12 a23 a30 : Q,
    (cim (Cmul (Cmul (zB a01) (zB a23))
          | Th_coqc | closed family_B_C4_vanishes | 1 |
| Theta/P.45.v1 | R1T-0045 | Theta | P | Theorem family_C_rank1_vanishes :
  forall Za Zb Zc Zd : Cq,
    (cim (Cmul (Cmul (Nij Za Zb) (Nij Zc Zd))
    | Th_coqc | closed family_C_rank1_vanishes | 1 |
| Theta/P.46.v1 | R1T-0046 | Theta | P | Theorem family_A_not_switching_invariant :
  exists eps0 eps1 eps2 eps3 : Q,
    (eps0*eps0 == 1)%Q /\ (eps1*e | Th_coqc | closed family_A_not_switching_invariant | 1 |
| Theta/P.47.v1 | R1T-0047 | Theta | P | Theorem family_A_witness_original_value :
  (PA 1 2 3 4 5 6 7 8 == 188)%Q. | Th_coqc | closed family_A_witness_original_value | 1 |
| Theta/P.48.v1 | R1T-0048 | Theta | P | Theorem family_A_witness_switched_value :
  (PA 1 2 3 4 5 (-6) 7 (-8) == 144)%Q. | Th_coqc | closed family_A_witness_switched_value | 1 |
| Theta/P.49.v1 | R1T-0049 | Theta | P | Theorem skew_source_switching_covariant :
  forall Phi_i Phi_j Psi_i Psi_j Di Dj : Q,
    (Di*Di == 1)%Q -> (D | Th_coqc | closed skew_source_switching_covariant | 1 |
| Theta/P.50.v1 | R1T-0050 | Theta | P | Theorem symmetric_source_switched_value :
  (sQ_switched 1 (-1) 1 2 3 4 == 21)%Q. | Th_coqc | closed symmetric_source_switched_value | 1 |
| Theta/P.51.v1 | R1T-0051 | Theta | P | Theorem symmetric_source_naive_covariant_prediction :
  (1 * (-1) * sQ 1 2 3 4 == -1)%Q. | Th_coqc | closed symmetric_source_naive_covariant_prediction | 1 |
| Theta/P.52.v1 | R1T-0052 | Theta | P | Theorem symmetric_source_not_switching_covariant :
  ~ (sQ_switched 1 (-1) 1 2 3 4 == 1 * (-1) * sQ 1 2 3 4)%Q | Th_coqc | closed symmetric_source_not_switching_covariant | 1 |
| Theta/P.53.v1 | R1T-0053 | Theta | P | Theorem c4_reversal_is_gauge_witness :
  exists eps0 eps1 eps2 eps3 : Q,
    (eps0*eps0 == 1)%Q /\ (eps1*eps1  | Th_coqc | closed c4_reversal_is_gauge_witness | 1 |
| Theta/P.54.v1 | R1T-0054 | Theta | P | Theorem k3_no_uniform_reversal_gauge :
  forall eps0 eps1 eps2 : Q,
    (eps0*eps0 == 1)%Q -> (eps1*eps1 == 1) | Th_coqc | closed k3_no_uniform_reversal_gauge | 1 |
| Theta/P.55.v1 | R1T-0055 | Theta | P | Theorem k3_invariance_forces_uniform :
  forall w01 w02 w12 : Q,
    (- w02 == - w12)%Q ->      (* invariance  | Th_coqc | closed k3_invariance_forces_uniform | 1 |
| Theta/P.56.v1 | R1T-0056 | Theta | P | Theorem p3_invariance_forces_uniform :
  forall w01 w12 : Q,
    (- w01 == - w12)%Q ->      (* invariance unde | Th_coqc | closed p3_invariance_forces_uniform | 1 |
| Theta/P.57.v1 | R1T-0057 | Theta | P | Theorem k3_spectrum_zero :
  forall w : Q,
    (2*w*1 + (-w)*1 + (-w)*1 == 0*1)%Q /\
    ((-w)*1 + 2*w*1 + (-w | Th_coqc | closed k3_spectrum_zero | 1 |
| Theta/P.58.v1 | R1T-0058 | Theta | P | Theorem k3_spectrum_top_a :   (* eigenvector (1,-1,0), eigenvalue 3w *)
  forall w : Q,
    (2*w*1 + (-w)*(-1) | Th_coqc | closed k3_spectrum_top_a | 1 |
| Theta/P.59.v1 | R1T-0059 | Theta | P | Theorem k3_spectrum_top_b :   (* eigenvector (1,0,-1), SAME eigenvalue 3w *)
  forall w : Q,
    (2*w*1 + (-w) | Th_coqc | closed k3_spectrum_top_b | 1 |
| Theta/P.60.v1 | R1T-0060 | Theta | P | Theorem p3_spectrum_zero :
  forall w : Q,
    (w*1 + (-w)*1 + 0*1 == 0*1)%Q /\
    ((-w)*1 + 2*w*1 + (-w)*1 = | Th_coqc | closed p3_spectrum_zero | 1 |
| Theta/P.61.v1 | R1T-0061 | Theta | P | Theorem p3_spectrum_mid :     (* eigenvector (1,0,-1), eigenvalue w *)
  forall w : Q,
    (w*1 + (-w)*0 + 0*( | Th_coqc | closed p3_spectrum_mid | 1 |
| Theta/P.62.v1 | R1T-0062 | Theta | P | Theorem p3_spectrum_top :     (* eigenvector (1,-2,1), eigenvalue 3w *)
  forall w : Q,
    (w*1 + (-w)*(-2) + | Th_coqc | closed p3_spectrum_top | 1 |
| Theta/P.63.v1 | R1T-0063 | Theta | P | Theorem p3_levels_distinct :
  forall w : Q, (0 < w)%Q ->
    ~ (0 == w)%Q /\ ~ (0 == 3*w)%Q /\ ~ (w == 3*w)%Q | Th_coqc | closed p3_levels_distinct | 1 |
| Theta/P.64.v1 | R1T-0064 | Theta | P | Theorem edge_source_bilinear_01 :
  forall p0 p1 s0 s1 : Q,
    (p0*s0 - p0*s1 - p1*s0 + p1*s1 == (p0 - p1) *  | Th_coqc | closed edge_source_bilinear_01 | 1 |
| Theta/P.65.v1 | R1T-0065 | Theta | P | Theorem edge_source_bilinear_02 :
  forall p0 p2 s0 s2 : Q,
    (p0*s0 - p0*s2 - p2*s0 + p2*s2 == (p0 - p2) *  | Th_coqc | closed edge_source_bilinear_02 | 1 |
| Theta/P.66.v1 | R1T-0066 | Theta | P | Theorem edge_source_bilinear_12 :
  forall p1 p2 s1 s2 : Q,
    (p1*s1 - p1*s2 - p2*s1 + p2*s2 == (p1 - p2) *  | Th_coqc | closed edge_source_bilinear_12 | 1 |
| Theta/P.67.v1 | R1T-0067 | Theta | P | Lemma Qmult_pos_pos : forall a b : Q, (0 < a)%Q -> (0 < b)%Q -> (0 < a * b)%Q. | Th_coqc | closed Qmult_pos_pos | 1 |
| Theta/P.68.v1 | R1T-0068 | Theta | P | Lemma Qsquare_nonneg : forall d : Q, (0 <= d * d)%Q. | Th_coqc | closed Qsquare_nonneg | 1 |
| Theta/P.69.v1 | R1T-0069 | Theta | P | Theorem clipped_stationarity_absent :
  forall mu K s w : Q,
    (0 < mu)%Q -> (0 < K)%Q -> (0 <= s)%Q -> (0 < | Th_coqc | closed clipped_stationarity_absent | 1 |
| Theta/P.70.v1 | R1T-0070 | Theta | P | Theorem clipped_stationarity_present :
  forall mu K s w wstar : Q,
    (0 < mu)%Q -> (0 < K)%Q -> (s < 0)%Q - | Th_coqc | closed clipped_stationarity_present | 1 |
| Theta/P.71.v1 | R1T-0071 | Theta | P | Theorem discordance_complement_flip :
  forall pi pj si sj : Q,
    ((pi - pj) * ((- si) - (- sj)) == - ((pi - | Th_coqc | closed discordance_complement_flip | 1 |
| Theta/P.72.v1 | R1T-0072 | Theta | P | Theorem witness_total_disorder_K3 :
  ((1 - 2) * (3 - 2) < 0)%Q /\
  ((1 - 3) * (3 - 1) < 0)%Q /\
  ((2 - 3) * | Th_coqc | closed witness_total_disorder_K3 | 1 |
| Theta/P.73.v1 | R1T-0073 | Theta | P | Theorem witness_partial_disorder_P3 :
  ((3 - 1) * ((-2) - (-1)) < 0)%Q /\
  (0 < (3 - 2) * ((-2) - (-5)))%Q / | Th_coqc | closed witness_partial_disorder_P3 | 1 |
| Theta/P.74.v1 | R1T-0074 | Theta | P | Lemma quartet_decomp :
  forall a b c d e f g h : Q,
  (cim (Cmul (Cmul (mkC a b) (mkC g h)) (Cmul (Cconj (mkC | Th_coqc | closed quartet_decomp | 1 |
| Theta/P.75.v1 | R1T-0075 | Theta | P | Theorem two_gen_quartet_im_vanishes :
  forall a b c d e f g h : Q,
  (a*c + b*d + (e*g + f*h) == 0)%Q ->
  (( | Th_coqc | closed two_gen_quartet_im_vanishes | 1 |
| Theta/P.76.v1 | R1T-0076 | Theta | P | Theorem quartet_conj_flips_sign :
  forall z1 z2 z3 z4 : Cq,
  (cim (Cmul (Cmul (Cconj z1) (Cconj z2))
        | Th_coqc | closed quartet_conj_flips_sign | 1 |
| Theta/P.77.v1 | R1T-0077 | Theta | P | Theorem witness_unitary : unitary3 V3w = true. | Th_coqc | closed witness_unitary | 1 |
| Theta/P.78.v1 | R1T-0078 | Theta | P | Theorem witness_J_value : Qeq_bool (quartetJ V3w) (110592 # 4151485) = true. | Th_coqc | closed witness_J_value | 1 |
| Theta/P.79.v1 | R1T-0079 | Theta | P | Theorem witness_J_nonzero : Qeq_bool (quartetJ V3w) 0 = false. | Th_coqc | closed witness_J_nonzero | 1 |
| Theta/P.80.v1 | R1T-0080 | Theta | P | Theorem witness_cp_unitary : unitary3 (conj3 V3w) = true. | Th_coqc | closed witness_cp_unitary | 1 |
| Theta/P.81.v1 | R1T-0081 | Theta | P | Theorem witness_cp_flips : Qeq_bool (quartetJ (conj3 V3w)) (- (110592 # 4151485)) = true. | Th_coqc | closed witness_cp_flips | 1 |
| Theta/P.82.v1 | R1T-0082 | Theta | P | Theorem neutral_cp_fixed : meq3 (conj3 I3) I3 = true. | Th_coqc | closed neutral_cp_fixed | 1 |
| Theta/P.83.v1 | R1T-0083 | Theta | P | Theorem neutral_unitary : unitary3 I3 = true. | Th_coqc | closed neutral_unitary | 1 |
| Theta/P.84.v1 | R1T-0084 | Theta | P | Theorem neutral_J_zero : Qeq_bool (quartetJ I3) 0 = true. | Th_coqc | closed neutral_J_zero | 1 |
| Theta/P.85.v1 | R1T-0085 | Theta | P | Theorem three_values_realized :
  sgnQ (quartetJ V3w) = SPlus
  /\ sgnQ (quartetJ (conj3 V3w)) = SMinus
  /\ s | Th_coqc | closed three_values_realized | 1 |
| Theta/P.86.v1 | R1T-0086 | Theta | P | Theorem values_pairwise_distinct :
  SPlus <> SMinus /\ SPlus <> SZero /\ SMinus <> SZero. | Th_coqc | closed values_pairwise_distinct | 1 |
| CMC/M.01.v1 | R1C-0001 | CMC | M | Theorem decomposed_bridge_obligation :
  CMC_Bridge_Obligation. | Ax | axioms decomposed_bridge_obligation | 1 |
| CMC/M.02.v1 | R1C-0002 | CMC | M | Theorem decomposed_no_refuter :
  forall g : TransportReadout,
    CMC_Refuter_Burden g -> False. | Ax | axioms decomposed_no_refuter | 1 |
| CMC/M.03.v1 | R1C-0003 | CMC | M | Theorem closure_free_implies_no_named_closure :
  forall g : TransportReadout,
    ClosureFree g -> NoNamedClo | Th_coqc | closed closure_free_implies_no_named_closure | 1 |
| CMC/M.04.v1 | R1C-0004 | CMC | M | Theorem no_named_closure_implies_closure_free :
  forall g : TransportReadout,
    NoNamedClosure g -> Closure | Th_coqc | closed no_named_closure_implies_closure_free | 1 |
| CMC/M.05.v1 | R1C-0005 | CMC | M | Theorem closure_free_iff_no_named_closure :
  forall g : TransportReadout,
    ClosureFree g <-> NoNamedClosur | Th_coqc | closed closure_free_iff_no_named_closure | 1 |
| CMC/M.06.v1 | R1C-0006 | CMC | M | Theorem refuter_burden_expands_to_named_absence :
  forall g : TransportReadout,
    CMC_Refuter_Burden g ->
  | Th_coqc | closed refuter_burden_expands_to_named_absence | 1 |
| CMC/M.07.v1 | R1C-0007 | CMC | M | Theorem independent_exhaustion_blocks_refuter :
  forall s : IndependentTransportSignature,
    ClosureExhaust | Th_coqc | closed independent_exhaustion_blocks_refuter | 1 |
| CMC/M.08.v1 | R1C-0008 | CMC | M | Theorem retained_definition_not_closure_definition :
  RetainedDiffusive_independent retained_without_closure_ | Th_coqc | closed retained_definition_not_closure_definition | 1 |
| CMC/M.09.v1 | R1C-0009 | CMC | M | Theorem finite_speed_definition_not_closure_definition :
  IntrinsicFiniteSpeed_independent finite_speed_witho | Th_coqc | closed finite_speed_definition_not_closure_definition | 1 |
| CMC/M.10.v1 | R1C-0010 | CMC | M | Theorem cattaneo_independent_target_has_closure :
  CMC_TargetClass_independent cattaneo_independent_signature | Th_coqc | closed cattaneo_independent_target_has_closure | 1 |
| CMC/M.11.v1 | R1C-0011 | CMC | M | Theorem fourier_independent_is_not_target_class :
  ~ CMC_TargetClass_independent fourier_independent_signatur | Th_coqc | closed fourier_independent_is_not_target_class | 1 |
| CMC/M.12.v1 | R1C-0012 | CMC | M | Theorem class_witness_has_nonzero_closure :
  forall (c : WitnessModelClass) (g : TransportReadout),
    Class | Th_coqc | closed class_witness_has_nonzero_closure | 1 |
| CMC/M.13.v1 | R1C-0013 | CMC | M | Theorem class_witness_not_closure_free :
  forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWit | Th_coqc | closed class_witness_not_closure_free | 1 |
| CMC/M.14.v1 | R1C-0014 | CMC | M | Theorem class_witness_blocks_refuter :
  forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWitne | Th_coqc | closed class_witness_blocks_refuter | 1 |
| CMC/M.15.v1 | R1C-0015 | CMC | M | Theorem fourier_memoryless_face_not_target :
  forall g : TransportReadout,
    FourierMemorylessFace g -> ~ C | Th_coqc | closed fourier_memoryless_face_not_target | 1 |
| CMC/P.01.v1 | R1C-0016 | CMC | P | Theorem Retention_Lemma_certified :
  forall r : CertifiedPhysicalReadout,
    retained_diffusive (certified_g | Th_coqc | closed Retention_Lemma_certified | 1 |
| CMC/P.02.v1 | R1C-0017 | CMC | P | Theorem Finite_Speed_Lemma_certified :
  forall r : CertifiedPhysicalReadout,
    intrinsic_finite_speed (cert | Th_coqc | closed Finite_Speed_Lemma_certified | 1 |
| CMC/P.03.v1 | R1C-0018 | CMC | P | Theorem Closure_Exhaustion_Lemma_certified :
  forall r : CertifiedPhysicalReadout,
  forall kr ks : CarrierKi | Th_coqc | closed Closure_Exhaustion_Lemma_certified | 1 |
| CMC/P.04.v1 | R1C-0019 | CMC | P | Theorem certified_physical_readout_has_nonzero_closure :
  forall r : CertifiedPhysicalReadout,
    NonzeroClo | Th_coqc | closed certified_physical_readout_has_nonzero_closure | 1 |
| CMC/P.05.v1 | R1C-0020 | CMC | P | Theorem certified_physical_readout_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    CMC_Refuter_Bur | Th_coqc | closed certified_physical_readout_blocks_refuter | 1 |
| CMC/P.06.v1 | R1C-0021 | CMC | P | Theorem cattaneo_telegraph_closure_witness :
  forall r : CertifiedPhysicalReadout,
    CattaneoTelegraphCerti | Th_coqc | closed cattaneo_telegraph_closure_witness | 1 |
| CMC/P.07.v1 | R1C-0022 | CMC | P | Theorem cattaneo_telegraph_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    CattaneoTelegraphCertif | Th_coqc | closed cattaneo_telegraph_blocks_refuter | 1 |
| CMC/P.08.v1 | R1C-0023 | CMC | P | Theorem kinetic_transport_closure_witness :
  forall r : CertifiedPhysicalReadout,
    KineticTransportCertifi | Th_coqc | closed kinetic_transport_closure_witness | 1 |
| CMC/P.09.v1 | R1C-0024 | CMC | P | Theorem kinetic_transport_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    KineticTransportCertifie | Th_coqc | closed kinetic_transport_blocks_refuter | 1 |
| CMC/P.10.v1 | R1C-0025 | CMC | P | Theorem flux_limited_diffusion_closure_witness :
  forall r : CertifiedPhysicalReadout,
    FluxLimitedDiffusi | Th_coqc | closed flux_limited_diffusion_closure_witness | 1 |
| CMC/P.11.v1 | R1C-0026 | CMC | P | Theorem flux_limited_diffusion_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    FluxLimitedDiffusio | Th_coqc | closed flux_limited_diffusion_blocks_refuter | 1 |
| CMC/P.12.v1 | R1C-0027 | CMC | P | Theorem wave_bounded_propagator_closure_witness :
  forall r : CertifiedPhysicalReadout,
    WaveBoundedPropag | Th_coqc | closed wave_bounded_propagator_closure_witness | 1 |
| CMC/P.13.v1 | R1C-0028 | CMC | P | Theorem wave_bounded_propagator_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    WaveBoundedPropaga | Th_coqc | closed wave_bounded_propagator_blocks_refuter | 1 |
| CMC/P.14.v1 | R1C-0029 | CMC | P | Theorem fourier_heat_singular_memoryless_face_not_finite_speed_target :
  forall g : TransportReadout,
    Fou | Th_coqc | closed fourier_heat_singular_memoryless_face_not_finite_speed_target | 1 |
| CMC/P.15.v1 | R1C-0030 | CMC | P | Theorem fourier_heat_singular_memoryless_face_not_refuter :
  forall g : TransportReadout,
    FourierHeatSing | Th_coqc | closed fourier_heat_singular_memoryless_face_not_refuter | 1 |
| CMC/M.16.v1 | R1C-0031 | CMC | M | Theorem nonzero_closure_not_closure_free :
  forall g : TransportReadout,
    NonzeroClosure g -> ~ ClosureFre | Th_coqc | closed nonzero_closure_not_closure_free | 1 |
| CMC/M.17.v1 | R1C-0032 | CMC | M | Theorem bridge_obligation_blocks_refuter :
  CMC_Bridge_Obligation ->
  forall g : TransportReadout,
    CMC_R | Th_coqc | closed bridge_obligation_blocks_refuter | 1 |
| CMC/M.18.v1 | R1C-0033 | CMC | M | Theorem cmc_no_refuter_under_axioms :
  forall g : TransportReadout,
    CMC_Refuter_Burden g -> False. | Ax | axioms cmc_no_refuter_under_axioms | 1 |
| weld/E.11.v1 | EFFORT-v0.3-01 | weld | E | \text{uncertainty} \not\equiv \text{stochastic mechanism} \\ \text{stochastic mechanism} \not\equiv \text{othe | Dr | open_prop weld__E_11_v1_hyp | 1 |
| weld/H.13.v1 | EFFORT-v0.3-02 | weld | H | N_{ext} < \infty \;\not\Rightarrow\; N_{int} = N_{ext} | Dr | open_prop weld__H_13_v1_hyp | 1 |
| weld/M.15.v1 | EFFORT-v0.3-03 | weld | M | \mathfrak{M}_Q(r_n) := \{\, m \in \mathfrak{M}_Q^{adm} : O_Q^G(m) = r_n \,\} | Definition | definition weld__M_15_v1_def | 1 |
| weld/M.16.v1 | EFFORT-v0.3-04 | weld | M | CSML_Q(M) = \mathsf{PASS} \iff M \in \mathfrak{M}_Q^{adm} \wedge \mathrm{Asm}(M,Q)\ \text{is explicit} | Definition | definition weld__M_16_v1_def | 1 |
| weld/M.17.v1 | EFFORT-v0.3-05 | weld | M | SAL_Q^{strong}(n) = \mathsf{PASS} \iff \mathfrak{M}_Q(r_n) \subseteq \mathfrak{M}_Q^{stoch} | Definition | definition weld__M_17_v1_def | 1 |
| weld/M.18.v1 | EFFORT-v0.3-06 | weld | M | \mathfrak{M}_Q(r_n)\cap\mathfrak{M}_Q^{stoch}\neq\varnothing,\quad \mathfrak{M}_Q(r_n)\cap\mathfrak{M}_Q^{nons | Dr | open_prop weld__M_18_v1_hyp | 1 |
| weld/M.19.v1 | EFFORT-v0.3-07 | weld | M | CSML_Q(M) = \mathsf{PASS} \;\not\Rightarrow\; SAL_Q^{strong}(n) = \mathsf{PASS} | Dr | open_prop weld__M_19_v1_hyp | 1 |
| weld/M.20.v1 | EFFORT-v0.3-08 | weld | M | T_{R\to D}\circ F_R = F_D\circ T_{R\to D},\quad O_D\circ T_{R\to D}=O_R,\quad W^D_{Q,j}\circ T_{R\to D}=W^R_{Q | Dr | open_prop weld__M_20_v1_hyp | 1 |
| weld/M.21.v1 | EFFORT-v0.3-09 | weld | M | CDOL_Q(\mathcal{R}\to D) = \mathsf{PASS} \iff \exists\, T_{R\to D} : \text{Eq.\ (14) holds} | Definition | definition weld__M_21_v1_def | 1 |
| weld/M.22.v1 | EFFORT-v0.3-10 | weld | M | ECT_Q(e_n) \in \{E_0, E_1, E_2, E_3, E_4, \mathsf{HOLD}\} | Definition | definition weld__M_22_v1_def | 1 |
| weld/M.23.v1 | EFFORT-v0.3-11 | weld | M | SID_Q(n,m) \in \{\mathsf{SAME}_{mech}, \mathsf{EQUIV}_Q, \mathsf{DIFF}_Q, \mathsf{HOLD}\} | Definition | definition weld__M_23_v1_def | 1 |
| weld/M.24.v1 | EFFORT-v0.3-12 | weld | M | SID_Q(n,m) = \mathsf{EQUIV}_Q \;\not\Rightarrow\; \mathcal{G}_n = \mathcal{G}_m | Dr | open_prop weld__M_24_v1_hyp | 1 |
| weld/H.14.v1 | EFFORT-v0.3-13 | weld | H | A_n^Q := q_A(S_n, T_n, c_n; Q) | Definition | definition weld__H_14_v1_def | 1 |
| weld/H.15.v1 | EFFORT-v0.3-14 | weld | H | \mathfrak{I}_n^Q := \mathfrak{I}_Q(\mathcal{G}_n, A_n^Q, c_n) | Definition | definition weld__H_15_v1_def | 1 |
| weld/H.16.v1 | EFFORT-v0.3-15 | weld | H | SameTrial_Q(n,m)=1 \iff SID_Q(n,m)\in\{\mathsf{SAME}_{mech},\mathsf{EQUIV}_Q\},\ A_n^Q \sim_Q A_m^Q,\ \mathfra | Dr | open_prop weld__H_16_v1_hyp | 1 |
| weld/H.17.v1 | EFFORT-v0.3-16 | weld | H | \text{same source readout} \not\Rightarrow \text{same effective agent} \not\Rightarrow \text{same encounter} | Dr | open_prop weld__H_17_v1_hyp | 1 |
| weld/H.18.v1 | EFFORT-v0.3-17 | weld | H | ISW_Q(\mathcal{G},A,A';c) = \mathsf{PASS} \iff d_I^Q\big(O_I^Q\,\mathfrak{I}_Q(\mathcal{G},A,c),\, O_I^Q\,\mat | Definition | definition weld__H_18_v1_def | 1 |
| weld/H.19.v1 | EFFORT-v0.3-18 | weld | H | SID_Q(n,n{+}1)=\mathsf{SAME}_{mech},\quad A_{n+1}^Q \not\sim_Q A_n^Q,\quad ISW_Q(\mathcal{G}_n, A_n^Q, A_{n+1} | Definition | definition weld__H_19_v1_def | 1 |
| weld/H.20.v1 | EFFORT-v0.3-19 | weld | H | \mathfrak{I}_{n+1}^Q \not\sim_Q \mathfrak{I}_n^Q | Dr | open_prop weld__H_20_v1_hyp | 1 |
| weld/H.21.v1 | EFFORT-v0.3-20 | weld | H | SID_Q(n,n{+}1)=\mathsf{SAME}_{mech},\ A_{n+1}^Q \not\sim_Q A_n^Q,\ ISW_Q(\mathcal{G}_n, A_n^Q, A_{n+1}^Q; c_n) | Dr | open_prop weld__H_21_v1_hyp | 1 |
| EQ-015/H.38.v1 | EFFORT-v0.3-21 | EQ-015 | H | Y_{n+1}^{world} \to O_Q \to \mu_{n+1}^Q \to E_{n+1}^Q \to \mathrm{Retain}_Q \to A_{n+1}^Q | Dr | open_prop EQ_015__H_38_v1_hyp | 1 |
| EQ-015/H.39.v1 | EFFORT-v0.3-22 | EQ-015 | H | RB_Q(n) = 1 \iff A_{n+1}^Q \not\sim_Q A_n^Q | Definition | definition EQ_015__H_39_v1_def | 1 |
| A.5/H.20.v1 | EFFORT-v0.3-23 | A.5 | H | LC_Q(n) = \mathsf{PASS} \iff RB_Q(n)=1 \wedge \Lambda_Q(n) = \mathsf{PASS} | Definition | definition A_5__H_20_v1_def | 1 |
| A.5/H.21.v1 | EFFORT-v0.3-24 | A.5 | H | IC_Q(n) = \mathsf{PASS} \iff LC_Q(n) = \mathsf{PASS} \wedge \Gamma_Q(n) > \tau_G | Definition | definition A_5__H_21_v1_def | 1 |
| A.5/H.22.v1 | EFFORT-v0.3-25 | A.5 | H | \text{Exposure} \neq \text{Retained Revision} \neq \text{Certified Learning} \neq \text{Improvement} | Dr | open_prop A_5__H_22_v1_hyp | 1 |
| weld/M.25.v1 | EFFORT-v0.3-26 | weld | M | ERG_D = \mathsf{PASS} \iff \exists\, u_a,u_b \in \mathcal{U}_D^{adm} : d_Q\big(R_D(s,u_a), R_D(s,u_b)\big) > \ | Dr | open_prop weld__M_25_v1_hyp | 1 |
| weld/M.26.v1 | EFFORT-v0.3-27 | weld | M | CER_Q = \mathsf{PASS} \iff ERG_D = \mathsf{PASS} \wedge ID_Q(u \to Y) = \mathsf{PASS} | Definition | definition weld__M_26_v1_def | 1 |
| A.5/H.23.v1 | EFFORT-v0.3-28 | A.5 | H | V_n^{learn}(u) \not\equiv V_n^{act}(u) | Dr | open_prop A_5__H_23_v1_hyp | 1 |
| weld/M.27.v1 | EFFORT-v0.3-29 | weld | M | \mathbf{C}_n(u) = \big(C_n^{int}(u),\, C_n^{ext}(u),\, C_n^{opp}(u),\, C_n^{risk}(u)\big) | Definition | definition weld__M_27_v1_def | 1 |
| weld/M.28.v1 | EFFORT-v0.3-30 | weld | M | \mathcal{U}_{n+1}^{safe} := \Big\{ u \in \mathcal{U}_D^{adm} : \mathbf{C}_n(u) \preceq \mathbf{B}_n,\ \mathbb{ | Dr | open_prop weld__M_28_v1_hyp | 1 |
| weld/M.29.v1 | EFFORT-v0.3-31 | weld | M | \mathrm{Route}_Q(e_n) = \begin{cases} \mathcal{A}_M, & ECT_Q(e_n)=E_0,\\ \mathcal{A}_B, & ECT_Q(e_n)=E_1,\\ \m | Definition | definition weld__M_29_v1_def | 1 |
| weld/M.30.v1 | EFFORT-v0.3-32 | weld | M | D_{n+1} = \begin{cases} \mathsf{HOLD}, & \mathrm{Route}_Q(e_n)=\mathsf{HOLD},\\ \mathsf{STOP}, & \mathcal{U}_{ | Definition | definition weld__M_30_v1_def | 1 |
| weld/M.31.v1 | EFFORT-v0.3-33 | weld | M | \mathcal{U}_{n+1}^{safe} = \varnothing \;\Rightarrow\; \mathsf{STOP} | Dr | open_prop weld__M_31_v1_hyp | 1 |
| weld/M.32.v1 | EFFORT-v0.3-34 | weld | M | \text{Event} \to \text{Readout} \to \text{Conditional/Strong Stochastic License} \to \text{Event-Control Type} | Definition | definition weld__M_32_v1_def | 1 |
| weld/H.22.v1 | ECONEXP-v1.0-01 | weld | H | \text{credential} \neq \text{expertise} | Definition | definition weld__H_22_v1_def | 0 |
| weld/H.23.v1 | ECONEXP-v1.0-02 | weld | H | \text{project role} \neq \text{expertise type} \neq \text{AI system} | Definition | definition weld__H_23_v1_def | 0 |
| weld/H.24.v1 | ECONEXP-v1.0-03 | weld | H | \chi_i(Q,D,t)\in\{N,I,C\} | Definition | definition ExpertiseIdealType, weld__H_24_v1_def | 0 |
| weld/H.25.v1 | ECONEXP-v1.0-04 | weld | H | P\!\left(\chi_{i,t+1}=b \mid \chi_{i,t}=a, A_t, P_t, W_t, R_t\right) | Open | open_prop ExpertiseIdealType25, weld__H_25_v1_hyp | 0 |
| weld/H.26.v1 | ECONEXP-v1.0-05 | weld | H | C_{N\rightarrow I}^{AI} < C_{N\rightarrow I}^{baseline} | Open | open_prop weld__H_26_v1_hyp | 0 |
| weld/H.27.v1 | ECONEXP-v1.0-06 | weld | H | \|\Delta C_{I\rightarrow C}^{AI}\| < \|\Delta C_{N\rightarrow I}^{AI}\| | Open | open_prop weld__H_27_v1_hyp | 0 |
| weld/H.28.v1 | ECONEXP-v1.0-07 | weld | H | \mathcal R_p = \left\langle E_p^{exp}, E_p^{int}, \mathcal M_p^{AI} \right\rangle \\ E_p^{int}=\varnothing \\  | Definition | definition weld__H_28_v1_def | 0 |
| weld/W.03.v1 | ECONEXP-v1.0-08 | weld | W | \Lambda_t = \sum_{c\in\mathcal C_t^{new}} w(c) | Definition | definition weld__W_03_v1_def | 0 |
| weld/W.04.v1 | ECONEXP-v1.0-09 | weld | W | \mu_t = V\!\left( E_t^C, E_t^I, W_t, D_t, R_t, A_{v,t} \right) | Definition | definition weld__W_04_v1_def | 0 |
| weld/W.05.v1 | ECONEXP-v1.0-10 | weld | W | B_{t+1} = \max\left\{ 0, (1-\delta_B)B_t+\Lambda_t-\mu_t \right\} | Dr | open_prop weld__W_05_v1_hyp | 0 |
| weld/W.06.v1 | ECONEXP-v1.0-11 | weld | W | B^* = \frac{\Lambda-\mu}{\delta_B} \qquad \text{for }\Lambda>\mu | Dr | open_prop weld__W_06_v1_hyp | 0 |
| weld/W.07.v1 | ECONEXP-v1.0-12 | weld | W | \frac{\partial B^*}{\partial A_g} = \frac{\partial \Lambda/\partial A_g}{\delta_B} >0 \\ \frac{\partial B^*}{\ | Dr | open_prop weld__W_07_v1_hyp | 0 |
| weld/W.08.v1 | ECONEXP-v1.0-13 | weld | W | Y_{K,t} = \sum_{c\in\mathcal P_t} v(c)\,\mathbf 1[G(c)=1] \\ \|\mathcal C_t^{new}\|\uparrow \not\Rightarrow Y_{K | Definition | definition weld__W_08_v1_def_indicator, weld__W_08_v1_def | 0 |
| weld/W.09.v1 | ECONEXP-v1.0-14 | weld | W | \mathcal{L} = U(Y_K)-C(x) + \lambda_V[\Phi(\mu,\mathcal C)-Y_K] | Dr | open_prop weld__W_09_v1_hyp | 0 |
| weld/H.29.v1 | ECONEXP-v1.0-15 | weld | H | \text{Live Problem} \rightarrow \text{Core Respondent / Practitioner} + \text{Researcher} + \text{Interactiona | Definition | definition weld__H_29_v1_def | 0 |
| weld/W.10.v1 | ECONEXP-v1.0-16 | weld | W | \left\{ Y_K, \Delta R_H^{return}, W, T, N_v \right\} \\ \text{Budget}\leq\bar B,\ \text{Safety risk}\leq\bar S | Definition | definition weld__W_10_v1_def | 0 |
| weld/H.30.v1 | CES-2026-09-07-01 | weld | H | E_p = \left\langle X_p^{exp}, X_p^{int}, \mathcal{M}_p^{AI} \right\rangle | Definition | definition weld__H_30_v1_def | 0 |
| weld/H.31.v1 | CES-2026-09-07-02 | weld | H | \mathcal{M}_p^{AI} = \{M_1, M_2, \ldots, M_k\} | Definition | definition weld__H_31_v1_def | 0 |
| weld/H.32.v1 | CES-2026-09-07-03 | weld | H | X_p^{int} = \varnothing \quad \text{(role unheld, not a zero score)} | Definition | definition weld__H_32_v1_def | 0 |
| weld/H.33.v1 | CES-2026-09-07-04 | weld | H | \text{Experience-Based Expertise} \neq \text{Interactional Expertise} \neq \text{AI Model} | Dr | open_prop weld__H_33_v1_hyp | 0 |
| weld/H.34.v1 | CES-2026-09-07-05 | weld | H | X_p^{exp} = \left\langle \text{Exp}, \text{Sel}, \text{Int} \right\rangle | Definition | definition weld__H_34_v1_def | 0 |
| EQ-015/H.40.v1 | RET-v2.0-01 | EQ-015 | H | \mathcal G_t = (\mathcal A_t, \mathcal E_t, \mathcal P_t) | Definition | definition EQ_015__H_40_v1_def | 1 |
| EQ-002/H.05.v1 | RET-v2.0-02 | EQ-002 | H | z_{i,t} = R_{i,t}\left(q_D(S_t), m_{-i,t}, c_{i,t}\right) | Dr | open_prop EQ_002__H_05_v1_hyp | 1 |
| EQ-002/H.06.v1 | RET-v2.0-03 | EQ-002 | H | z_{j,t+1} = R_{j,t+1}\left(z_{i,t}, c_{j,t+1}\right) | Dr | open_prop EQ_002__H_06_v1_hyp | 1 |
| EQ-015/H.41.v1 | RET-v2.0-04 | EQ-015 | H | a_i \rightarrow a_j \rightarrow a_i | Definition | definition EQ_015__H_41_v1_def | 1 |
| weld/H.35.v1 | RET-v2.0-05 | weld | H | N_A(c) \not\equiv N_P(c) | Dr | open_prop weld__H_35_v1_hyp | 1 |
| weld/H.36.v1 | RET-v2.0-06 | weld | H | N_A(c)\uparrow \not\Rightarrow N_P(c)\uparrow | Dr | open_prop weld__H_36_v1_hyp | 1 |
| A.8/M.20.v1 | RET-v2.0-07 | A.8 | M | \Pi(c) = (V_c, E_c, \tau_c) | Definition | definition A_8__M_20_v1_def | 1 |
| EQ-015/H.42.v1 | RET-v2.0-08 | EQ-015 | H | \mathfrak R_t = \left\langle \chi_{\mathrm{recip},t}^{\mathcal G}, D_{\mathcal G,t}^{\mathrm{eff}}, R_{\mathca | Dr | open_prop EQ_015__H_42_v1_hyp | 1 |
| weld/H.37.v1 | RET-v2.0-09 | weld | H | \Delta D^{eff}_{\mathcal G}<0,\ \Delta R^{ex}_{\mathcal G}>0 \quad\text{and}\quad \Delta P^{ind}_{\mathcal G}> | Definition | definition weld__H_37_v1_def | 1 |
| EQ-015/H.43.v1 | RET-v2.0-10 | EQ-015 | H | \Delta\chi_{\mathrm{recip}}^{\mathcal G}>0,\ \Delta\kappa_{\mathcal G}>0,\ \Delta D^{eff}_{\mathcal G}<0,\ \De | Definition | definition EQ_015__H_43_v1_def | 1 |
| EQ-015/H.44.v1 | RET-v2.0-11 | EQ-015 | H | RET \neq Falsehood; \quad RET \neq Consensus | Definition | definition EQ_015__H_44_v1_def | 1 |
| EQ-015/H.45.v1 | RET-v2.0-12 | EQ-015 | H | K_{\mathrm{like}} \overset{forget}{\longrightarrow} K_{\mathrm{assumed}} \overset{recursion}{\longrightarrow}  | Definition | definition EQ_015__H_45_v1_def | 1 |
| EQ-015/H.46.v1 | RET-v2.0-13 | EQ-015 | H | Consensus_{\mathcal M}(c) = \frac{1}{k}\sum_{j=1}^{k}\mathbf 1[M_j\ accepts\ c] | Dr | open_prop EQ_015__H_46_v1_hyp | 1 |
| EQ-015/H.47.v1 | RET-v2.0-14 | EQ-015 | H | Consensus_{\mathcal M}(c)\uparrow \not\Rightarrow Validation(c)\uparrow | Dr | open_prop EQ_015__H_47_v1_hyp | 1 |
| A.5/H.24.v1 | RET-v2.0-15 | A.5 | H | \Delta Accuracy_{\mathrm{agent}}>0 \not\Rightarrow \Delta Corrigibility_{\mathcal G}>0 | Dr | open_prop A_5__H_24_v1_hyp | 1 |
| A.8/M.21.v1 | RET-v2.0-16 | A.8 | M | H \Rightarrow y \quad\text{such that}\quad CausalAncestry(y) \not\subseteq \mathcal G^{recursive}_{\le \tau} | Dr | open_prop A_8__M_21_v1_hyp | 1 |
| A.8/M.22.v1 | RET-v2.0-17 | A.8 | M | Claim \rightarrow Freeze \rightarrow AI\text{-Off} \rightarrow World\ Record \rightarrow Fixed\ Evaluation \ri | Dr | open_prop A_8__M_22_v1_hyp | 1 |
| A.8/M.23.v1 | RET-v2.0-18 | A.8 | M | Freeze(H,\tau),\ Predeclare(T,\mathcal A_H),\ AI_{\mathrm{decisive\ execution}}(T)=0,\ AI_{\mathrm{primary\ ev | Definition | definition A_8__M_23_v1_def | 1 |
| A.8/M.24.v1 | RET-v2.0-19 | A.8 | M | Frozen\ Artifact + AI_{\mathrm{runtime}}=0 \rightarrow Test\ Outcome | Dr | open_prop A_8__M_24_v1_hyp | 1 |
| EQ-002/M.04.v1 | RET-v2.0-20 | EQ-002 | M | Simulation\ Success \not\Rightarrow World\ Validation | Dr | open_prop EQ_002__M_04_v1_hyp | 1 |
| EQ-015/H.48.v1 | RET-v2.0-21 | EQ-015 | H | \Delta\chi_{\mathrm{recip}}^{\mathcal G}>0,\ \Delta\kappa_{\mathcal G}>0 \ \text{while}\ \Delta D_{\mathcal G} | Dr | open_prop EQ_015__H_48_v1_hyp | 1 |
| EQ-015/H.49.v1 | RET-v2.0-22 | EQ-015 | H | SessionReset \not\Rightarrow EpistemicReset | Dr | open_prop EQ_015__H_49_v1_hyp | 1 |
| weld/W.11.v1 | RET-v2.0-23 | weld | W | \mu_t^{eff} = \mu_t(1-\pi_t^{RET}) | Dr | open_prop weld__W_11_v1_hyp | 1 |

## Raw inventory by chapter (every numbered equation, with its canonical id when assigned)

### The Language Bridge: Expanding Human Potential in the Age of AI — 10.5281/zenodo.17280546 (0 equations)

_No numbered equations (One-page reflective conceptual abstract, pure prose (no displayed formulas, no numbered/boxed equations, no named propositions/definitions written as formulas). Checked plain and -layout pdftotext output in full; nothing to extract.)._

### Violence as a Special Case of Instability in Finite–Memory Causal Systems — 10.5281/zenodo.18383439 (13 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | Sec. 2, From Events to States: Ontologic | s(x,t) ∈ R^n | definition |  | weld/S.10.v1 |
| (2) | Sec. 2, From Events to States: Ontologic | V(x,t) = Φ(s(x,t)) | definition |  | weld/S.11.v1 |
| (3) | Sec. 3, Finite Causal Memory and Telegra | τ ∂t j + j = −D∇s | definition |  | weld/S.12.v1 |
| (4) | Sec. 3, Finite Causal Memory and Telegra | ∂t s = −∇·j − Γ(s) + Senv | definition |  | weld/S.13.v1 |
| (5) | Sec. 4, Spectral Structure and Persisten | ∂t s = Lτ s | identity |  | weld/S.14.v1 |
| (6) | Sec. 4, Spectral Structure and Persisten | s(t) = Σ_k c_k e^{−λ_k t} r_k | identity |  | weld/S.15.v1 |
| Theorem (No-Go for Elimination by Suppression) | Sec. 5, A Structural No-Go Result | Given Lτ with τ > 0, assuming (i) at least one slow spectral mode exists, (ii) suppression acts only on state amplitudes | theorem |  | weld/S.01.v1 |
| (7) | Sec. 8, Minimal Constructive Model | L = [[−α, ε], [ε, −β]], α, β > 0 | definition |  | weld/S.16.v1 |
| (8) | Sec. 8, Minimal Constructive Model | λ± = −(α+β)/2 ± sqrt( ((α−β)/2)^2 + ε^2 ) | identity |  | weld/S.17.v1 |
| (9) | Sec. 9, Ecosystem-Level Stabilization | Γ ↑ (increase dissipation) | measurement |  | weld/S.18.v1 |
| (10) | Sec. 9, Ecosystem-Level Stabilization | Senv ↓ (reduce load) | measurement |  | weld/S.19.v1 |
| (11) | Sec. 9, Ecosystem-Level Stabilization | Lij ↓ (limit propagation) | measurement |  | weld/S.20.v1 |
| (12) | Sec. 9, Ecosystem-Level Stabilization | τ ↓ (shorten memory) | measurement |  | weld/S.21.v1 |

### CAUSAL ETHICS : The Mathematics of Regime Choice and Survival — 10.5281/zenodo.18444260 (37 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| CE-01 | Ch.1 §1.1.1; Ch.2 §2.1 (Axiom I: Reality | M(t') ∈ M | axiom (Axiom I: Reality-as-Record) |  | weld/S.27.v1 |
| CE-02 | Ch.1 §1.1.2; Ch.2 §2.2 (Axiom II: Agency | A_i(t') ⊆ M(t') | axiom (Axiom II: Agency-as-Choice) |  | weld/S.28.v1 |
| CE-03 | Ch.1 §1.1.3; Ch.2 §2.5 (Axiom IV: Collec | G(t') := {A_1(t'), …, A_N(t')} ⊆ M(t') | axiom (Axiom IV: Collective as Coupled Agencies) |  | weld/S.29.v1 |
| CE-04 | Ch.1 §1.1.4 (Admissible Regime Set); Equ | R ∈ R_adm(t') | definition |  | weld/S.30.v1 |
| CE-05 | Ch.1 §1.1.5; Ch.2 §2.3 (Axiom III: Regim | R := (T_R, I_R) | axiom (Axiom III: Regime Structure) |  | EQ-015/S.13.v1 |
| CE-06 | Ch.1 §1.1.6; Ch.2 §2.3.2 (Update Laws);  | M(t' + Δt') = T_R(M(t')) | law (update law) |  | EQ-015/S.14.v1 |
| CE-07 | Ch.1 §1.1.6; Ch.2 §2.3.2 (Update Laws);  | A(t' + Δt') ⊆ I_R(A(t'), M(t')) | law (update law) |  | EQ-015/S.15.v1 |
| CE-08 | Ch.1 §1.2.3 (What 'Etic' Means Here); Ch | Etic(A; t') := ∃ R_A(t') ∈ R_adm(t') : A ⊆ M(t'), M(t'+Δt') = T_{R_A}(M(t')), A(t'+Δt') ⊆ I_{R_A}(A(t'), M(t')) | definition |  | EQ-015/S.16.v1 |
| CE-09 | Ch.3 §3.2 (Ethical Load: the Lyapunov Po | V_{A,R}(M) ≥ 0 | definition |  | EQ-015/S.17.v1 |
| CE-10 | Ch.3 §3.3 (Causal Memory Constraint); Eq | τ_c'(R) > 0 | definition |  | EQ-015/S.18.v1 |
| CE-11 | Ch.3 §3.4 (Spectral Stability Margin); E | Δ_spec(R) > 0 | definition |  | EQ-015/S.19.v1 |
| CE-12 | Ch.3 §3.1.1 (Core Definition: Ethics as  | Ethical(A) ⇔ ∃ Choice(A → R_A) : d/dt' V_{A,R_A}(M(t')) ≤ 0 ∧ τ_c'(R_A) > 0 ∧ Δ_spec(R_A) > 0 | definition (author-labelled 'final' / locked) |  | EQ-015/S.20.v1 |
| CE-13 | Ch.4/Ch.7 §4.1.2/§7.1.2 (Interpretation  | V̇⁺ := max(dV/dt', 0) | definition |  | EQ-015/S.21.v1 |
| CE-14 | Ch.1 §1.3 (Symbol Dictionary — Spectrum  | M(t') = M_0 φ_0 + Σ_k a_k(t') φ_k | definition |  | EQ-015/S.23.v1 |
| CE-15 | Ch.1 §1.3 (Symbol Dictionary); Equation  | S_A(R) ⊆ span{φ_k} | definition |  | EQ-015/S.24.v1 |
| CE-16 | Ch.1 §1.3 (Symbol Dictionary); Equation  | P_{S_A(R)} : M → S_A(R) | definition |  | EQ-015/S.25.v1 |
| CE-17 | Ch.5 §5.6 (Individual Survival Link); Eq | limsup_{n→∞} ‖P_{S_A(R_A)} M(t'+n)‖² > 0 | definition |  | EQ-015/S.26.v1 |
| CE-18 | Ch.5 §5.6 (Individual Survival Link); Eq | lim_{n→∞} ‖P_{S_A(R_A)} M(t'+n)‖² = 0 | definition |  | EQ-015/S.27.v1 |
| CE-19 | Ch.5 §5.3 (Individual Admissibility Test | Eth_ind(A) ⇔ d/dt' V_{A,R_A} ≤ 0 ∧ Δ_spec(R_A) > 0 | definition |  | EQ-015/S.22.v1 |
| CE-20 | Ch.6 §6.1 (From Individual Potentials to | V_G(M) := Σ_{i=1}^N w_i V_{A_i,R_i}(M),  w_i > 0 | definition |  | EQ-015/S.28.v1 |
| CE-21 | Ch.6 §6.2 (Collective Admissibility and  | Eth_col(G) ⇔ d/dt' V_G(M) ≤ 0 ∧ min_i Δ_spec(R_i) > 0 | definition |  | EQ-015/S.29.v1 |
| CE-22 | Ch.8 §8.2.1 (Individual-Admissible, Coll | Conf_{ind→col} ⇔ d/dt' V_{A_i} ≤ 0 ∧ d/dt' V_G > 0 | definition |  | EQ-015/S.30.v1 |
| CE-23 | Ch.8 §8.2.2 (Collective-Admissible, Indi | Conf_{col→ind} ⇔ d/dt' V_G ≤ 0 ∧ ∃i: d/dt' V_{A_i} > 0 | definition |  | EQ-015/S.31.v1 |
| CE-24 | Ch.8 §8.1 (Moral Conflict as a Mathemati | Δ_spec(R_i ∪ R_j) ≤ 0 | definition |  | EQ-015/S.32.v1 |
| CE-25 | Ch.4/Ch.7 §4.2.1/§7.2.1 (Definition (Cau | χ_causal(R) := 1[τ_c'(R) ≈ 0] | definition |  | weld/S.31.v1 |
| CE-26 | Ch.4/Ch.7 §4.2.2/§7.2.2 (Definition (Spe | χ_spec(R) := 1[Δ_spec(R) ≤ 0] | definition |  | weld/S.32.v1 |
| CE-27 | Ch.4/Ch.7 §4.1.1/§7.1.1 (Definition (Mor | C_{A,R}[t1,t2] := ∫_{t1}^{t2} [ α V̇⁺_{A,R}(M(t')) + β χ_causal(R) + γ χ_spec(R) ] dt',  α,β,γ > 0 | definition |  | weld/S.33.v1 |
| CE-28 | Ch.4/Ch.7 §4.3/§7.3 (Definition (Respons | Resp(A) ≡ C_{A,R_A} | definition |  | weld/S.34.v1 |
| CE-29 | Ch.4/Ch.7 §4.4/§7.4 (Definition (Collect | C_G[t1,t2] := Σ_{i=1}^N w_i C_{A_i,R_i}[t1,t2] | definition |  | weld/S.35.v1 |
| CE-30 | Ch.4/Ch.7 §4.4.2/§7.4.2 (Definition (Str | ∃ i,j : C_{A_i,R_i} ≫ C_{A_j,R_j} | definition |  | EQ-015/S.33.v1 |
| CE-31 | Ch.4/Ch.7 §4.5/§7.5 (Definition (Karma a | lim_{T→∞} C_{A,R}[0,T] = ∞ | definition |  | weld/S.36.v1 |
| CE-32 | Ch.4/Ch.7 §4.5.2/§7.5.2 (Theorem (Cost–S | lim_{T→∞} C_{A,R}[0,T] = ∞ ⇒ lim_{n→∞} ‖P_{S_A} M(t'+n)‖² = 0 | theorem (author-labelled 'Theorem (Cost–Survival Link)') |  | weld/S.37.v1 |
| CE-33 | Ch.4/Ch.7 §4.6.1/§7.6.1 (Definition (Zer | Eth(A) ⇔ C_{A,R_A}[t,∞) = 0 | definition (author-labelled 'ideal condition') |  | weld/S.38.v1 |
| CE-34 | Ch.4/Ch.7 §4.6.2/§7.6.2 (Definition (Con | R* ∈ argmin_{R∈R_adm} C_{system,R}  s.t.  τ_c'(R) > 0, Δ_spec(R) > 0 | definition |  | weld/S.39.v1 |
| (CE-choice gate) | Ch.5 §5.3 (Hard rule: Choice gate) | ¬∃ Choice(A → R_A) ⇒ no ethics attribution, no responsibility attribution, and no moral cost attribution | law (author-labelled 'Hard rule') |  | weld/S.40.v1 |
| (Tragic) | Ch.5 §5.4 (Definition (Tragic regime cla | ∀ R ∈ R_available(t') : ¬[τ_c'(R) > 0 ∧ Δ_spec(R) > 0] ∨ C_{A,R}[t',t'+T] > 0,  for all T > 0 | definition |  | weld/S.41.v1 |
| (Tragic-min) | Ch.5 §5.4 (Consequence, following Defini | R†_A ∈ argmin_{R∈R_available(t')} C_{A,R}[t',t'+T]  s.t.  τ_c'(R) > 0, Δ_spec(R) > 0 | proposition (derived consequence of the Tragic definition) |  | weld/S.42.v1 |

### AI, Translation, and Access to Event-Specific Contex — 10.5281/zenodo.18517054 (20 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| Def-1 | 3.1 Events and reality | E := an event in the world (used as a separation device, not an ontological claim). | definition |  | A.5/H.13.v1 |
| Def-2 | 3.2 Event-specific context | C_e := (S_e, R_e, A_e, τ_e), where S_e = situational/environmental condition, R_e = relational/causal structure, A_e = s | definition |  | A.5/H.13.v1 |
| Def-3 | 3.3 Translation/interpretation and non-i | T̂ := I(E \| C_acc), where I is the human interpreter (language + reasoning + experience) and C_acc is the context actual | definition |  | A.5/H.13.v1 |
| Prop-1 | 3.3 Translation/interpretation and non-i | T̂ ≠ E | proposition |  | A.5/H.13.v1 |
| Def-4 | 3.4 Human agency and self-context | A := the capacity to decide under context while retaining accountability; agency is anchored by preservation of S. | definition |  | weld/H.10.v1 |
| Def-5 | 3.4 Human agency and self-context | S := (goals, constraints, stakes, role, local evidence, lived situation). | definition |  | weld/H.10.v1 |
| Def-6 | 3.5 External context-frame | F := a context-frame induced by external structures (ranking, engagement optimization, typicality pressures, standardiza | definition |  | weld/H.10.v1 |
| Prop-2 | 3.5 External context-frame | When S is not preserved, the tendency for F to dominate interpretation increases, with a corresponding risk of agency de | proposition |  | weld/H.10.v1 |
| Def-7 | 3.6 Grounding vs embodiment | G (referential grounding) = ability to pick out referents/factual anchors; Ge (experiential grounding) = meaning anchore | definition |  | A.5/H.14.v1 |
| Prop-3 | 3.6 Grounding vs embodiment | G ≠ Emb | hypothesis/Open |  | A.5/H.14.v1 |
| (1) | 3.7 Interaction efficiency | 𝓔 := f(ConstraintPrecision, ContextRecall, SourceTraceability, ErrorRepair). | definition |  | EQ-015/H.28.v1 |
| Eq-unifying | 4.1 A unifying formalization | T̂^(k) = I(E \| C_acc^(k)), where k indexes the dominant mediation architecture (epoch). | definition |  | A.5/H.13.v1 |
| Eq-epoch3 | 4.5 Epoch 3: LLM-based AI mediation | T̂^(3) = I(E \| C_acc^(3)) + ΔC via dialogue(S, prompts, checks). | definition |  | A.5/H.13.v1 |
| Prop-4 | 4.6 The context-access chain | E → C_acc^(0) → C_acc^(1) → C_acc^(2) → C_acc^(3). | proposition |  | A.5/H.13.v1 |
| Finding-1 (H1) | 6.2 H1: Context-access amplification wit | AI does not directly increase access to event-specific context E; it increases access to, and reorganization of, human i | hypothesis/Open |  | EQ-015/H.29.v1 |
| Finding-2 (H3) | 6.3 H3: Open-ended but bounded interpret | When human–AI interaction achieves high 𝓔 and preserves S, individuals may tend toward open-ended cross-domain interpret | hypothesis/Open |  | EQ-015/H.29.v1 |
| Finding-3 (H4) | 6.4 H4: Architectural doorway through di | AI introduces an architectural doorway enabling access to diverse human-generated translations/interpretations via immed | hypothesis/Open |  | EQ-015/H.29.v1 |
| Prop-5 (B1) | 6.5 Boundary B1: External-context domina | AI-mediated empowerment tends to occur iff (i) 𝓔 is high and (ii) S is preserved; if S is displaced by language alone, F | proposition |  | weld/H.10.v1 |
| (2) | 7. Boxed master equation and interpretiv | AI-Empowerment(H) ⇐⇒ S preserved ∧ high 𝓔. | proposition |  | weld/H.10.v1 |
| (3) | 7. Boxed master equation and interpretiv | S replaced by language ⇒ F dominates ⇒ [agency] degrades. | proposition |  | weld/H.10.v1 |

### Learning Under Generative Abundance: A Structural Law of Epistemic Stabilization — None (2 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| L1 | A Structural Law of Epistemic Environmen | When the external generation of coherent structure increases without bound, observable production ceases to serve as a u | law |  | EQ-015/E.10.v1 |
| L2 | The Regime Transition | accumulation --> discrimination | law |  | EQ-015/E.10.v1 |

### Causal Agency  A Persistence Control Theory of Adaptive Systems — 10.5281/zenodo.18897585 (10 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| Def-1 | 6.1 Constrained Dynamical Systems | x' = F(x, C) | definition |  | A.5/S.04.v1 |
| Def-2 | 6.2 Persistence and Viable Regions | x(t) ∈ V,  where V ⊆ S is the viable region of the state space S, for all times in the interval of observation | definition |  | A.5/S.05.v1 |
| Persistence-Regulation-Condition | 6.4 Persistence Regulation | d/dt [ d(x(t), V) ] < 0  (in expectation), where d(x,V) is the distance between state x and the viable region V | definition (formalization of persistence regulation) |  | A.5/S.06.v1 |
| Constraint-Evolution | 5.5 / 6.3 Constraint Dynamics | C_{t+1} = G(x_t, C_t) | definition (schematic representation, not yet the agency condition) |  | A.5/S.07.v1 |
| State-Constraint-Coupling | 6.5 Agency as Constraint Regulation | ∂C/∂x ≠ 0 | definition (necessary condition, part of the agency criterion) |  | A.5/S.08.v1 |
| Def-3 (Agency-Condition) | 6.5 Agency as Constraint Regulation | ∂Tp/∂C · ∂C/∂x > 0,  where Tp is the expected persistence time of the system within the viable region V | definition |  | A.5/S.09.v1 |
| Proto-Agency-Condition | 8.2–8.3 Level 0 / Level 1; 9.2 Control S | ∂C/∂x = 0 | definition |  | A.5/S.10.v1 |
| L3-Constraint-Evolution-History | 8.5 Level 3: Adaptive Constraint Regulat | C_{t+1} = G(x_t, C_t, H_t),  where H_t is the system's interaction history | definition |  | A.5/S.11.v1 |
| L4-Constraint-Evolution-Predictive | 8.6 Level 4: Predictive Constraint Regul | C_{t+1} = G(x_t, C_t, x̂_{t+k}),  where x̂_{t+k} represents predicted future states | definition |  | A.5/S.12.v1 |
| L5-Meta-Regulation | 8.7 Level 5: Reflective Constraint Regul | G_{t+1} = M(G_t) | definition |  | A.5/S.13.v1 |

### Knowledge as Stabilized Translation: Toward an Observer-Constrained Epistemology — 10.5281/zenodo.18925129 (2 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 6. The Observer as a Bounded System | M_A(E) = (T_A o Pi_A)(S_A(E)) | definition (source manuscripts' minimal observation pipeline) |  | EQ-002/E.03.v1 |
| (2) | 6. The Observer as a Bounded System | Know_A(W) = 1 iff Dist(R_A[n], R_A^nu[n]) <= epsilon_K for all admissible variations nu on the declared window W | definition (knowledge as stability-achievement) |  | weld/E.01.v1 |

### The Causal Grammar of Structured Coexistence: Conflict, Violence, Repair, and Non-Suppress — 10.5281/zenodo.18925131 (0 equations)

_No numbered equations (Preprint, 9 March 2026, 5 pages. Read in full via pdftotext (plain and -layout). This is a purely qualitative/sociological theory paper: it contains no numbered or boxed mathematical equations, no lettered propositions/lemmas (no CE-/P-/H-style labels), and no non-collapse 'X ≠ Y' formulas. Its only formal apparatus is prose definitions (structure as organized possibility; conflict as incompatible coexistence; violence as possibility compression; repair as protected reopening; peace as non-suppressive stability), one causal diagram (Figure 1: Structure -> Compatible/Incompatible Coexistence -> Violence -> Repair -> Peace), and one qualitative typology table (Table 1: Regimes of structured coexistence -- Tension/Conflict/Violence/Pseudo-peace/Peace by Compatibility x Possibility Space x Repair). Cross-checked against Master Equation River v1.4/main.tex and refs.bib: this paper is not cited there and has no restated equation among eq:1-79. Confirmed not restated in Master River v1.4 (record_id/title/'causal grammar'/'structured coexistence' do not appear in main.tex or refs.bib).)._

### The Civilization of Knowledge: Who Has the Authority to Interpret the World — 10.5281/zenodo.18943971 (1 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| Canonical Formula | Working Thesis and Governing Formula | M_A(E) = (T_A ∘ Π_A)(S_A(E)),   S_A(E) ⊆ Δ(E) | definition (author-labelled 'Canonical Formula'; the paper explicitly states it does not claim all historical formations can be captured by one formula without remainder — it is an organizing heuristic, not a proven law) |  | EQ-002/E.03.v1 |

### The Architecture of Mediated Agency: Beyond the Misframing of Free Will and Truth — 10.5281/zenodo.19176260 (0 equations)

_No numbered equations (5-page prose article with no numbered, boxed, or otherwise displayed equations. It uses inline symbolic notation only within running prose — 'inherent errors (ε_tot > 0)' (abstract; §2.1 Theorem of Irreducible Error) and 'perfect self-knowledge (ε_self = 0)' (§5) — neither of which is set off as a formal displayed/numbered equation, definition box, or named proposition. Checked via both plain and -layout pdftotext extraction of the full 5 pages; no equation environment, numbered formula, or non-collapse (X ≠ Y) law block appears anywhere in the text.)._

### Constraint-First Epistemology: Normativity, Conditioned Agency, and the Non-Zero Kantian F — 10.5281/zenodo.19205869 (6 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 4 Formal Core | O_A[n] = Π_A(E[n]) | definition |  | EQ-002/E.10.v1 |
| (2) | 4 Formal Core | enc_A(O_A)[n] = T_A(O_A[n]) | definition |  | EQ-002/E.10.v1 |
| (3) | 4 Formal Core | M_A[n+1] = U_A(M_A[n], enc_A(O_A)[n], C_A, Δ_A[n]) | definition |  | EQ-015/E.08.v1 |
| (4) | 4 Formal Core | ε_tot > 0 | law |  | EQ-002/E.07.v1 |
| (5) | 4 Formal Core | V_A[n] = Align(M_A[n], θ_W \| D) | definition |  | EQ-015/E.09.v1 |
| (6) | 4 Formal Core | E[V_A[n+1] \| Rsn_A, D] > E[V_A[n] \| D] | proposition |  | EQ-015/E.09.v1 |

### When AI Expands Human Potential: Reflective Dissonance, Epistemic Agency, and Constraint — 10.5281/zenodo.19215748 (2 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| unlabeled (§7, display 1) | 7 Context-Indexed Evaluation | K_A(D, t) := V_A^D( M_A(t), θ_D ) | definition |  | EQ-015/E.11.v1 |
| unlabeled (§7, display 2) | 7 Context-Indexed Evaluation | V_A^D = w_1^D P + w_2^D I + w_3^D S + w_4^D R + w_5^D L,  with Σ_i w_i^D = 1 | definition |  | EQ-015/E.11.v1 |

### Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Disc — 10.5281/zenodo.19640361 (18 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| P3 | 2.2 The Three Postulates and the Telegra | v = sqrt(D/τ_c) < ∞ | law |  | weld/M.01.v1 |
| MQ.08 | 2.2 The Three Postulates and the Telegra | V[n+1] = V[n] + Δθ·(−γ·V[n] − D_s·L_R·X[n]) | theorem |  | weld/M.01.v1 |
| Th-5 | 2.3 Eigenmodes, Decay, and the Emergence | \|a_k[n]\| ≤ \|a_k[0]\| · e^(−γ_k · n · Δθ) | theorem |  | weld/M.01.v1 |
| (1) | 3.1 The Causal Body Framework | B[n] → H_body[n] → N[n] → S[n] ↔ A[n] → π[n] → U[n] → B[n+1] | definition |  | EQ-002/H.01.v1 |
| (2) | 3.1 The Causal Body Framework | H_body[n+1] = Φ_H(B[n], H_body[n]) | definition |  | EQ-002/H.01.v1 |
| (3) | 3.1 The Causal Body Framework | N[n+1] = Φ_N(B[n], H_body[n], N[n]) | definition |  | EQ-002/H.01.v1 |
| (4) | 3.1 The Causal Body Framework | S[n+1] = Φ_S(S[n], N[n], H_body[n]) | definition |  | EQ-002/H.01.v1 |
| (5) | 3.1 The Causal Body Framework | A[n+1] = Φ_A(S[n], A[n])  (brain-internal only) | definition |  | EQ-002/H.01.v1 |
| (6) | 3.1 The Causal Body Framework | π[n+1] ∈ arg min_{π∈Π_feas} L_sel(S, H_body, π) | definition |  | EQ-002/H.01.v1 |
| (7) | 3.1 The Causal Body Framework | U[n+1] = Exec(π[n+1]) | definition |  | EQ-002/H.01.v1 |
| (8) | 3.1 The Causal Body Framework | B[n+1] = Φ_B(B[n], U[n+1]) | definition |  | EQ-002/H.01.v1 |
| (9) | 4.1 The Coupling Model | B[t+1] = F(B[t]) + C_H(H[t]) | definition |  | EQ-015/M.09.v1 |
| (10) | 4.1 The Coupling Model | H[t+1] = G(H[t]) + C_B(B[t]) | definition |  | EQ-015/M.09.v1 |
| (11) | 4.1 The Coupling Model | E[t] = R(B[t], H[t]) | definition |  | EQ-015/M.09.v1 |
| (12) | 5.2 World-Resistance and Structural Erro | ε_tot = ε_clock + ε_cross + ε_sel + ε_map + ε_self | theorem |  | EQ-002/E.07.v1 |
| (13) | 5.3 The Knowledge Event | Knowing = Coupled System + Selection + Retention + Model + Error + Correction | definition |  | weld/E.01.v1 |
| (14) | 6.1 The Knowledge Triple | K_S^A = (Tr_A, Str_A, Cap_A) | definition |  | weld/E.03.v1 |
| (15) | 6.3 The Legitimacy Gate | LegitKnow ⇔ Know_A ∧ Grounded ∧ Q_auth ≥ θ_Q ∧ N_know ≥ θ_N | theorem |  | weld/E.03.v1 |

### Experience Is the Human LoRA: A Readout–Retention Theory of Selective Model Change — 10.5281/zenodo.21425420 (47 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2.1 The readout-not-truth stance | G_H[n] = (V_H[n], E_H[n], w_H[n]) | definition |  | weld/H.04.v1 |
| (2) | 2.1 The readout-not-truth stance | w_H[n](e) in Q_{>0} | definition |  | weld/H.04.v1 |
| (3) | 2.1 The readout-not-truth stance | phi_n in Q^{\|V_H[n]\|} | definition |  | weld/H.04.v1 |
| (4) | 2.2 Discrete time and the human spine | delta phi_n = phi_{n+1} - phi_n | definition |  | weld/H.04.v1 |
| (5) | 2.2 Discrete time and the human spine | delta^2 phi_n = phi_{n+1} - 2 phi_n + phi_{n-1} | definition |  | weld/H.04.v1 |
| (6) | 2.2 Discrete time and the human spine | mu_H delta^2 phi_n + d_H delta phi_n + kappa_H L_H[n] phi_n + partial_Q V_H(phi_n) = J_H[n] - eta_H[n] | Dr/interpretive (explicitly not a derived law) |  | weld/H.04.v1 |
| (7) | 3.1 World contact and selected readout | S_n : X_n -> Z_n | definition |  | weld/E.09.v1 |
| (8) | 3.1 World contact and selected readout | z_n = Pi_n S_n(X_n) + eta_n,  z_n in Q^{m_n} | definition |  | weld/E.09.v1 |
| (9) | 3.2 Finite temporal thickness | W_n = {n - h_n + 1, ..., n} | definition |  | weld/E.09.v1 |
| (10) | 3.2 Finite temporal thickness | tilde{z}_n = sum_{j=0}^{h_n-1} a_{n,j} z_{n-j} | definition |  | weld/E.09.v1 |
| (11) | 3.3 Embodied and relational phenomenaliz | O_H[n] = O(G_brain[n], G_body[n], G_environment[n], G_relation[n], G_practice[n], G_language[n], V_H[n]) | definition |  | weld/H.04.v1 |
| (12) | 3.3 Embodied and relational phenomenaliz | P_n = Phi_n(tilde{z}_n, O_H[n], B_n, A^aff_n, C_n, U_n) | definition |  | EQ-015/E.04.v1 |
| (13) | 3.3 Embodied and relational phenomenaliz | E_n = <X_n, z_n, tilde{z}_n, P_n, u_n, R_{n+1}, Delta O_n> | definition |  | EQ-015/E.04.v1 |
| (14) | 3.4 No experience without retained diffe | H_{n+1} != H_n | law |  | EQ-015/E.08.v1 |
| (15) | 4.1 Two aspects of one event | E_n^phen = P_n | definition |  | EQ-015/E.04.v1 |
| (16) | 4.1 Two aspects of one event | E_n^adapt = Delta O_n | definition |  | EQ-015/E.04.v1 |
| (17) | 4.1 Two aspects of one event | E_n = <E_n^phen, E_n^adapt> = Human LoRA_n | identity |  | EQ-015/E.04.v1 |
| (18) | 4.2 Transient and retained updates | Delta O_n^fast = B_n A_n | definition |  | EQ-015/H.06.v1 |
| (19) | 4.2 Transient and retained updates | g_n = Gamma_n(s_n, r_n^err, q_n, v_n, c_n, p_n) in Q intersect [0,1] | definition |  | EQ-015/H.06.v1 |
| (20) | 4.2 Transient and retained updates | Delta O_n^ret = g_n * Delta O_n^fast | definition |  | EQ-015/H.06.v1 |
| (21) | 4.2 Transient and retained updates | O_H[n+1] = O_H[n] + Delta O_n^ret + epsilon_n | definition |  | EQ-015/H.06.v1 |
| (22) | 5.1 The finite-bottleneck postulate | 0 < m_n < d_n | hypothesis/Open |  | EQ-015/H.06.v1 |
| (23)-(24) | 5.1 The finite-bottleneck postulate | A_n in Q^{m_n x d_n},  B_n in Q^{d_n x m_n} | definition |  | EQ-015/H.06.v1 |
| (25) | 5.1 The finite-bottleneck postulate | Delta O_n = B_n A_n | definition |  | EQ-015/H.06.v1 |
| (26) | 5.1 (Proposition 1) | rank_Q(B_n A_n) <= m_n | theorem |  | EQ-015/H.06.v1 |
| (27) | 5.1 (Proposition 2) | (O_H[n] + B_n A_n) x = O_H[n] x   whenever A_n x = 0 | theorem |  | EQ-015/H.06.v1 |
| (28) | 5.1 (Proposition 3) | rank_Q( sum_{i=1}^{N} Delta O_i ) <= sum_{i=1}^{N} m_i | theorem |  | EQ-015/H.06.v1 |
| (29) | 5.2 Transformative experience without re | O_H[N] = O_H[0] + sum_{n=0}^{N-1} g_n B_n A_n + sum_{0<=i<j<N} Lambda_{ij} + sum_{n=0}^{N-1} epsilon_n | definition |  | EQ-015/H.06.v1 |
| (30) | 6.1 Intentionality | I_n = (x --as--> y)_n | definition |  | weld/H.04.v1 |
| (31) | 6.2 Horizon | H_n subseteq V_H[n],  \|H_n\| < infinity | definition |  | weld/H.02.v1 |
| (32) | 7.2 Consolidation, retrieval, and recons | Delta O^{old}_{new} = g_n B_n A_n Q_n(Delta O^{old}) | definition |  | EQ-015/H.06.v1 |
| (33) | 7.3 Neural-manifold findings translated  | Y in Q^{T x p} | measurement |  | EQ-015/H.06.v1 |
| (34) | 7.3 (Definition 3) | r_rho(D) = rank_Q( q_rho(D) ) | definition |  | EQ-015/H.06.v1 |
| (35) | 8.1 Adaptation is not well-being | successful adaptation = mental health   [explicitly REJECTED] | law (non-collapse, rejected identity) |  | A.5/E.08.v1 |
| (36) | 8.1 Adaptation is not well-being | W_n = (F_n, A_n^agency, M_n^meaning, R_n^relation, C_n^competence, Q_n^repair) | definition |  | EQ-015/H.37.v1 |
| (37) | 8.2 A discrete misfit model | C_mal[n] = rig(a_n) * gen(a_n) * mis(a_n) * loss(a_n) | measurement |  | EQ-015/H.37.v1 |
| (38) | 8.4 Therapeutic learning as adapter comp | O_post = O_threat + g_s B_s A_s | Dr/interpretive |  | EQ-015/H.06.v1 |
| (39) | 9.1 Four synchronized readout layers | D_n = {D_n^first, D_n^beh, D_n^neural, D_n^world} | measurement |  | EQ-002/E.11.v1 |
| (40) | 9.2 Study 1: finite bottleneck and rank  | D_{post-pre} = B A + E | hypothesis/Open |  | EQ-015/H.06.v1 |
| (41) | 9.2 Study 1: finite bottleneck and rank  | r_rho(D_{post-pre}) <= m | hypothesis/Open |  | EQ-015/H.06.v1 |
| (42) | 9.4 Study 3: consolidation and rank traj | r_rho(D_0), r_rho(D_1), ..., r_rho(D_N) | hypothesis/Open |  | EQ-015/H.06.v1 |
| (43) | 9.7 Competing models | M0: context-only state change | hypothesis/Open |  | EQ-015/H.36.v1 |
| (44) | 9.7 Competing models | M1: sparse but not low-rank update | hypothesis/Open |  | EQ-015/H.36.v1 |
| (45) | 9.7 Competing models | M2: low-rank factorized update | hypothesis/Open |  | EQ-015/H.36.v1 |
| (46) | 9.7 Competing models | M3: regularized full-rank update | hypothesis/Open |  | EQ-015/H.36.v1 |
| (47) | 9.7 Competing models | M4: finite graph rewiring | hypothesis/Open |  | EQ-015/H.36.v1 |
| (48) | 9.7 Competing models | M5: hybrid fast trace plus slow update | hypothesis/Open |  | EQ-015/H.36.v1 |

### Readout Genesis Standalone Synthesis: Information Epistemic Foundation, Conditioned Agency — 10.5281/zenodo.21529456 (91 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | III.A Retained distinction and graph str | delta_R = (a # b);  delta_R => L_R = D_W - W;  S_{n+1} = F(S_n, u_n, c_n, T_n) | identity (root weld / architecture) |  | weld/M.01.v1 |
| (2) | III.A Retained distinction and graph str | q_{D,n+1} o F_n = F^#_{D,n} o q_{D,n};  O_{D,n} = O^#_{D,n} o q_{D,n} | definition (admissibility condition) |  | weld/M.02.v1 |
| (3) | III.A Retained distinction and graph str | delta_R = (a # b) | definition |  | weld/M.01.v1 |
| (4) | III.A Retained distinction and graph str | L_R = D_W - W | identity |  | weld/M.01.v1 |
| (5) | III.A Retained distinction and graph str | S_{n+1} = F(S_n, u_n, c_n, T_n) | definition |  | weld/M.01.v1 |
| (6) | III.B Domain translation and reader equi | q_D(F(z,u,c,T)) = F_D(q_D(z), u, c, T) | definition (admissibility) |  | weld/M.02.v1 |
| (7) | III.B Domain translation and reader equi | O_D(z; Q, c) = O^#_D(q_D(z); Q, c) | definition (admissibility) |  | weld/M.02.v1 |
| (8) | III.B Domain translation and reader equi | z ~_{Q,O,c,L} z'  <=>  O(F^k z) = O(F^k z')  for all k <= L | definition |  | weld/M.03.v1 |
| (9) | III.C Constitutional ordering | retention -> structure -> translation -> readout -> meaning -> experience -> memory -> belief -> claim -> checking -> st | law (constitutional ordering rule) |  | EQ-015/M.03.v1 |
| (10) | IV From occurrence to meaning, experienc | A != x != mu != E != M != Bel != p != sigma_K(p) | law (non-collapse) |  | A.5/M.06.v1 |
| (11) | IV From occurrence to meaning, experienc | x_{i,n} = Access(A_n; O_i, L_i, T_i, R_i, C_i) | definition |  | EQ-002/E.09.v1 |
| (12) | IV From occurrence to meaning, experienc | A_i = A_j  =/=>  x_i = x_j | law (non-collapse) |  | A.5/M.06.v1 |
| (13) | IV From occurrence to meaning, experienc | mu_{i,n} = G_mu(x_{i,n}, M_{i,n-1}, K_{i,n-1}, Theta_{i,n-1}, I_{i,n-1}, S_{i,n}^active, c_n) | definition |  | EQ-015/E.01.v1 |
| (14) | IV From occurrence to meaning, experienc | E_{i,n} = Phi_E(x_{i,n}, mu_{i,n}, kappa_{i,n}, c_n) | definition | 4 | EQ-015/E.04.v1 |
| (15) | IV From occurrence to meaning, experienc | M_{i,n} = U_M(M_{i,n-1}, x_{i,n}, mu_{i,n}, E_{i,n}, c_n, Lineage_n, T_n) | definition |  | EQ-015/E.08.v1 |
| (16) | IV From occurrence to meaning, experienc | Delta A_past = 0 | law (invariant) |  | A.8/M.01.v1 |
| (17) | V.A Relational and multidimensional beli | Bel_{i,p,n} = Rel_B(a_i, p \| x_i, mu_i, E_i, M_i, Theta_i, I_i, S_i^active, c_i) | definition |  | weld/S.43.v1 |
| (18) | V.A Relational and multidimensional beli | b_{i,p,n} = (e_{i,p}, c_{i,p}, s_{i,p}, a_{i,p}, eta_{i,p}, g_{i,p}, r_{i,p}) | definition |  | weld/S.44.v1 |
| (19) | V.A Relational and multidimensional beli | b_{i,p,n+1} = U_B(b_{i,p,n}, Ev_{i,p}, M_i, mu_i, E_i, Theta_i, I_i, Trust_i, Affect_i, Utility_i, Repetition_i, Auth_i, | law (descriptive update rule) |  | weld/S.45.v1 |
| (20) | V.B Scale and stabilization | Bel_{g,d,n}^{(l)}(p) = Stabilize_B({b_{i,p,n}}_{i in G}, C_B) | definition |  | weld/S.46.v1 |
| (21) | V.B Scale and stabilization | Belief Strength(p), Belief Distribution(p), Auth(p), Pow(p), Val_E(p) | law (non-collapse) |  | A.5/M.06.v1 |
| Prop-1 | V.B Scale and stabilization | Belief-scale nonpromotion: for any proposition p, increasing the distribution scale of Bel(p) does not, without addition | proposition (with proof) |  | weld/S.04.v1 |
| Def-1 | VI.A Normative proposal | Knowledge status: Knowledge is the bounded epistemic status granted to a claim about the world or a declared domain when | definition |  | weld/E.03.v1 |
| (22) | VI.A Normative proposal | sigma_K(p) = Admit_E(p \| Agent, D, C, O, Access, Language, Tools, Rights, Prov, Ev, Method, Infer, Assumptions, Uncertai | definition |  | weld/E.03.v1 |
| (23) | VI.A Normative proposal | K_p = <p, C_p, P_p, E_p, M_p, I_p, U_p, Omega_p, O_p, L_p, sigma_K(p)> | definition |  | weld/E.03.v1 |
| (24) | VI.B Status of speaker and status of cla | StatusOfSpeaker != StatusOfClaim;  Auth(p) != Val_E(p);  Pow(p) != Val_E(p) | law (non-collapse) |  | A.5/M.06.v1 |
| (25) | VI.C Practical effectiveness as a separa | Pi_prac(p) = TestPerformance(Y, Y_hat, intervention, C, O) | definition |  | weld/E.04.v1 |
| (26) | VI.C Practical effectiveness as a separa | sigma_K(p) != Pi_prac(p) | law (non-collapse) |  | A.5/M.06.v1 |
| (27) | VII.A The gate sequence | chi_G in {1, 0, perp};  1 = ADMITTED, 0 = OBSTRUCTED, perp = UNRESOLVED | definition |  | weld/E.05.v1 |
| (28) | VII.B State sufficiency and invariant co | Suff_{E,L}(Z_E^cand; Q, O, c, T) in {1, 0, perp} | definition |  | weld/E.06.v1 |
| (29) | VII.B State sufficiency and invariant co | Inv_E(z) != Inv_E(z')  =>  q_E(z) != q_E(z') | law (invariant preservation) |  | weld/E.06.v1 |
| (30) | VII.D Claim ceiling | tau_public(p) <= inf_{g in G_p} tau(g) | identity (claim-ceiling bound) |  | weld/E.07.v1 |
| Prop-2 | VII.D Claim ceiling | Weakest-link claim ceiling: if any load-bearing gate for p is unresolved or obstructed, a public claim that presupposes  | proposition (with proof) |  | weld/E.07.v1 |
| (31) | VII.D Claim ceiling | sigma_K(p) in {ADMITTED, LOCAL, TRANSPORTABLE, UNRESOLVED, OBSTRUCTED, RETRACTED, SUPERSEDED} | definition |  | weld/E.03.v1 |
| (32) | VIII Local, institutional, and global kn | Omega(K) = {(g, d, l, P, O, c) : all required gates pass} | definition |  | weld/E.03.v1 |
| (33) | VIII Local, institutional, and global kn | K_local = K \|_{Omega_local} | definition |  | weld/E.08.v1 |
| (34) | VIII Local, institutional, and global kn | T^Y_{ij} o K_i ~= K_j o T^C_{ij};  epsilon_bridge = d(T^Y_{ij} o K_i, K_j o T^C_{ij}) | definition (transport condition) |  | weld/E.08.v1 |
| (35) | VIII Local, institutional, and global kn | Bel_global(p) != K_global(p) | law (non-collapse) |  | A.5/M.06.v1 |
| (36) | IX.A Agency as a process quotient | A_{i,n} = q_A(Z_{i,n}; Q_A, O_A, c_n) | definition |  | EQ-002/H.02.v1 |
| (37) | IX.A Agency as a process quotient | Aut(F_A, O_A) = {h : O_A o h = O_A, h o F_A = F_A o h} | definition |  | EQ-002/H.02.v1 |
| (38) | IX.A Agency as a process quotient | I_n = q_comp(M_n (+) Bel_n (+) Theta_n (+) Roles_n (+) BodyTool_n (+) SocialLineage_n) | definition |  | EQ-002/H.02.v1 |
| (39) | IX.B The conditional chain | x_n -> zeta_n -> v_n -> rho_n -> U_n -> beta_n -> I_{n+1} -> a_n -> S_{n+1} | definition (chain structure) |  | EQ-002/H.01.v1 |
| (40) | IX.B The conditional chain | zeta_n = Contact(x_n, O_n, BodyTool_n, Attention_n, c_n) | definition |  | EQ-002/H.01.v1 |
| (41) | IX.B The conditional chain | v_n = V_valence(zeta_n, M_n, mu_n, BodyState_n, c_n) | definition |  | EQ-002/H.01.v1 |
| (42) | IX.B The conditional chain | rho_n = R_drive(v_n, ExpectedRelief_n, ExpectedGain_n, Habit_n, c_n) | definition |  | EQ-002/H.01.v1 |
| (43) | IX.B The conditional chain | U_n = Bind_self(rho_n, Bel_n, Theta_n, I_n, S_n^active, c_n) | definition |  | EQ-002/H.01.v1 |
| (44) | IX.C Distortion before knowledge | xi_n = (xi_n^+, xi_n^-, xi_n^0) | definition |  | EQ-015/E.02.v1 |
| (45) | IX.C Distortion before knowledge | Xi_n = alpha_n^+ P_n^+ + alpha_n^- P_n^- + alpha_n^0 P_n^0;  G~_{mu,n} = G_{mu,n} o (I + Xi_n) | definition |  | EQ-015/E.02.v1 |
| (46) | IX.C Distortion before knowledge | epsilon_{Xi,n} = d_O(G_{mu,n}(z_n), G~_{mu,n}(z_n)) | definition (measurement) |  | EQ-015/E.02.v1 |
| (47) | X.A Typed self readout | S_A[n] = q_self(F^n[delta_R, T_A, c_{0:n}]) = <A_A[n], Delta_A[n], H_A[n], Phen_A^str[n], P_A^lived[n], Own_A[n], Coh_A[ | definition |  | weld/H.01.v1 |
| (48) | X.A Typed self readout | A_A != I_A != Phen_A^str != P_A^lived != Own_A != Coh_A != Val_A | law (non-collapse) |  | A.5/M.06.v1 |
| (49) | X.A Typed self readout | I_A[n+1] = q_id(I_A[n] (+) A_A[n] (+) P_A^lived[n] (+) Pi_A^star[n] (+) Res_A[n] (+) Delta T_A[n]) | definition |  | weld/H.01.v1 |
| (50) | X.B The horizon triad | H_dyn: Delta_A(lambda) = D_A^2 - 4 M_A K_A lambda = 0 | definition |  | weld/H.02.v1 |
| (51) | X.B The horizon triad | H_info(A) = {z in Z_A : Rec(z) => (E_b < infinity, R_p > 0)} | definition |  | weld/H.02.v1 |
| (52) | X.B The horizon triad | H_phen(A) = {r = A_A^acc Pi_A T_A(delta_R) : PhenGate(r) = 1} | definition |  | weld/H.02.v1 |
| (53) | X.B The horizon triad | H_dyn --DI_K--> H_info --IP_K--> H_phen | hypothesis/Open (weld, bridge open) |  | weld/H.02.v1 |
| (54) | X.B The horizon triad | Phen_A^str[n] = A_A^acc Pi_A T_A^{<=n}(delta_R; T_A, c_n) | definition |  | weld/H.02.v1 |
| (55) | X.B The horizon triad | P_A^lived[n] = Phi_A^phen(M_A^rec[n], Omega_A[n], B_A[n], c_n) | definition |  | weld/H.02.v1 |
| (56) | XI.A Three levels of knowledge | K_prop(p) = sigma_K(p) | definition |  | weld/E.03.v1 |
| (57) | XI.A Three levels of knowledge | K_op(p) = <K_prop(p), Task_p, Completion_p> | definition |  | weld/E.03.v1 |
| (58) | XI.A Three levels of knowledge | K_trans(p) = <K_op(p), Delta Theta, Delta I, Delta U, Delta Action, Persistence, Transport, Viability> | definition |  | weld/E.03.v1 |
| (59) | XI.A Three levels of knowledge | sigma_K(p) = ADMITTED | definition (admission condition) |  | weld/E.03.v1 |
| (60) | XI.A Three levels of knowledge | Completion_p = PASS | definition (admission condition) |  | weld/E.03.v1 |
| (61) | XI.A Three levels of knowledge | z_post in V_A | definition (admission condition) |  | weld/E.03.v1 |
| (62) | XI.A Three levels of knowledge | Defects_{persistence, transport, lineage} <= tau | definition (admission condition) |  | weld/E.03.v1 |
| (63) | XI.B Release without destruction | U_{n+1} = Pi_{U>=0}[(I - D_U) U_n + J_{reinforce,n} - J_{release,n}] | definition |  | A.5/H.03.v1 |
| (64) | XI.B Release without destruction | J_release - J_reinforce >= epsilon_release > 0 | definition (sufficient condition) |  | A.5/H.03.v1 |
| (65) | XI.B Release without destruction | z_n in V_A,  O_E(z_n) != 0,  \|\|U_n\|\| -> 0 | definition (conditions) |  | A.5/H.03.v1 |
| (66) | XI.B Release without destruction | v_free in ker B_I,  B_I v_free = 0,  O_E(v_free) != 0 | definition |  | A.5/H.03.v1 |
| (67) | XII.A From readout to readout-of-readout | R_A^{(1)}[n] = O_A(q_A(Z_A[n]); c_n, T_n) | definition |  | weld/H.03.v1 |
| (68) | XII.A From readout to readout-of-readout | R_A^{(2)}[n] = O_A(R_A^{(1)}[n]; c_n, T_n) | definition |  | weld/H.03.v1 |
| (69) | XII.A From readout to readout-of-readout | W_A^R[n] = R_{tau_g}(R_A^{(2)}[n]; T_n) | definition |  | weld/H.03.v1 |
| (70) | XII.B Interruptibility, alternatives, an | R_A^{(1)} != Claim_A != Identity_A;  Identity_A != ActionCandidate_A != CommittedAction_A | law (non-collapse) |  | A.5/M.06.v1 |
| (71) | XII.B Interruptibility, alternatives, an | C_A^ret[n] = O_A^ctx(c_{n-h:n}, T_{n-h:n}) | definition |  | weld/H.03.v1 |
| (72) | XII.B Interruptibility, alternatives, an | L_A^acc[n] = O_A^lin(Lambda_A[n], T_n) | definition |  | weld/H.03.v1 |
| (73) | XII.B Interruptibility, alternatives, an | U_A[n] = {u : C_A(u \| Z_A[n], c_n, T_n) = 1} | definition |  | weld/H.03.v1 |
| (74) | XII.B Interruptibility, alternatives, an | F_A^act[n] = O_A^act(U_A[n], Pi_A[n]) | definition |  | weld/H.03.v1 |
| (75) | XII.B Interruptibility, alternatives, an | I_A^resp[n] = 1  <=>  exists u' != u*: u' in U_A[n], t < t_c, Repair(F(Z_A, u')) >= R_min | definition |  | weld/H.03.v1 |
| (76) | XII.B Interruptibility, alternatives, an | A_A^pol[n] = O_A^alt(U_A[n]) | definition |  | weld/H.03.v1 |
| (77) | XII.B Interruptibility, alternatives, an | Pi_A^star[n] = arg min_{u in U_A[n]} J_A(u) | definition |  | weld/H.03.v1 |
| (78) | XII.B Interruptibility, alternatives, an | J_A(u) = E\|\|Res_{A,u}\|\|^2 + lambda_C C(u) + rho R(u) + mu L_repair(u) - nu V(u) | definition |  | weld/H.03.v1 |
| (79) | XII.B Interruptibility, alternatives, an | u_A^repair = arg min_{u in U_A^repair} (\|\|Res_A(F(Z_A,u))\|\|^2 + Cost(u) + RepairLoss(u)) | definition |  | weld/H.03.v1 |
| (80) | XII.C Governance state and operator | G_A^MR[n] = <R_A^{(1)}, R_A^{(2)}, W_A^R, D_A^type, C_A^ret, L_A^acc, F_A^act, I_A^resp, A_A^pol, Pi_A^star, Delta Z_A^r | definition |  | weld/H.03.v1 |
| (81) | XII.C Governance state and operator | G_A^MR[n] = R_{tau_g}(O_A(O_A(q_A(Z_A[n]))), C_A^ret, L_A^acc, F_A, Pi_A) | definition |  | weld/H.03.v1 |
| (82) | XII.C Governance state and operator | Delta_G Pi_A^star = d_Pi(Pi_A^star, Pi_{A,-G}^star) > tau_idle | definition (relevance criterion) |  | weld/H.03.v1 |
| (83) | XII.D Defect vector, capture, and finite | epsilon_G = (epsilon_R1, epsilon_R2, epsilon_W, epsilon_D, epsilon_C, epsilon_L, epsilon_F, epsilon_I, epsilon_A, epsilo | measurement (diagnostic) |  | weld/H.03.v1 |
| (84) | XII.D Defect vector, capture, and finite | Gamma_A = Load_A - Capacity_A | definition |  | weld/H.03.v1 |
| (85) | XII.D Defect vector, capture, and finite | CurrentReadout + SelectionPriority + SelectionStability + SelfReport  =/=>  G_A^MR | law (non-collapse / no-free-governance) |  | A.5/M.06.v1 |
| (86) | XII.D Defect vector, capture, and finite | B_G = I(R_A^{(2)}; Z_A) / tau_cA < infinity,  ker O_A^{(2)} != empty | law / measurement |  | weld/H.03.v1 |
| (87) | XIII Human-AI relation and knowledge civ | AIOutput != ClaimIdentity != Evidence;  Evidence != Inference != KnowledgeStatus | law (non-collapse) |  | weld/H.05.v1 |
| (88) | XIII Human-AI relation and knowledge civ | T_{H<-AI} o K_AI ~= K_H o T_C | definition (transport condition, Maker-Checker firewall) |  | weld/H.05.v1 |

### The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship — 10.5281/zenodo.22163849 (122 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2.1 Cumulative advantage without prestig | Credit != EpistemicValue | identity (non-collapse) |  | A.5/M.07.v1 |
| (2) | 2.2 Conceptual research as disciplined t | Phenomenon -> ExistingExplanations -> PreciseInadequacy -> Mechanism -> Boundary -> Propositions | definition |  | weld/M.10.v1 |
| (3) | 2.3 Social objectivity, distributed reas | Friction != Fellowship | identity (non-collapse) |  | A.5/M.08.v1 |
| (4) | 3.1 Standalone is an infrastructural con | K0_start = I0 + R0 + N0 + P0 | definition (bookkeeping identity, not a psychometric scale) |  | A.8/M.06.v1 |
| (5) | 3.1 Standalone is an infrastructural con | E_t = f(Q_t, C_t, V_t, U_t, X_t, T_t) | definition (conceptual/Dr, directional claim only) |  | A.8/M.06.v1 |
| (6) | 3.2 Two engines and one bridge | Phenomenon -> TheoreticalInadequacy -> Mechanism -> ConceptualContribution | definition |  | weld/M.10.v1 |
| (7) | 3.2 Two engines and one bridge | Practice -> Observation -> Intervention -> Evidence -> Implementation | definition |  | weld/M.10.v1 |
| (8) | 3.2 Two engines and one bridge | Bridge = 1  <=>  Practice Delta Theory | definition |  | weld/M.10.v1 |
| (9) | 3.3 The lived and positional bridge: con | SelfExperience != GeneralEvidence | identity (non-collapse) |  | A.5/M.09.v1 |
| (10) | 3.3 The lived and positional bridge | PosCap = Access x Language x SituatedObservation x TranslationCapacity x Trust | definition/Dr (not a psychometric construct) |  | A.8/M.06.v1 |
| (11) | 3.3 The lived and positional bridge | PositionalAccess != PopulationAuthority | identity (non-collapse) |  | A.5/M.10.v1 |
| (12) | 3.3 The lived and positional bridge | CommunityTrust != Representativeness | identity (non-collapse) |  | A.5/M.11.v1 |
| (13)-(16) | 4 Knowledge states: synthetic formation  | K0: private candidate;  K1: public, timestamped, citable, explicitly provisional;  K2: K1 + independent external frictio | definition |  | weld/M.11.v1 |
| (17) | 4 Knowledge states | K0 -> K1 -> K2 -> K3 | definition |  | weld/M.11.v1 |
| (18) | 4 Knowledge states | DVP =/=> K2 | identity (non-collapse) |  | A.5/M.12.v1 |
| (19) | 5.1 The Epistemic Isolation Constraint | mu_H,f approx 0,   mu_A >> mu_H,f | finite_diagnostic / definitional starting condition |  | A.8/M.07.v1 |
| (20) | 5.1 The Epistemic Isolation Constraint | EIC => BuildSyntheticFormationInfrastructure | governance definition |  | A.8/M.07.v1 |
| (21) | 5.1 The Epistemic Isolation Constraint | AI speed -> synthetic criticism -> K1 -> human correction | definition |  | A.8/M.07.v1 |
| (22) | 5.2 Bottleneck inversion | Lambda = min(mu_L, mu_H, mu_E, mu_P, mu_C) | governance definition |  | A.8/M.08.v1 |
| (23) | 5.2 Bottleneck inversion | V_c = (H * L * T)^(1/3) | governance definition |  | A.8/M.08.v1 |
| (24) | 5.2 Bottleneck inversion | D_e = A * (1 - V_c) | governance definition |  | A.8/M.08.v1 |
| (25) | 5.2 Bottleneck inversion | PublicOutputVelocity <= VerificationCapacity | governance definition |  | A.8/M.08.v1 |
| (26) | 6.1 Route diversity, not model voting | ManyModels =/=> Independence | identity (non-collapse) |  | A.5/M.13.v1 |
| (27) | 6.1 Route diversity, not model voting | DVP* = ReduceCorrelatedError + ExposeResidualDependence + BottomOutWherePossible | governance definition |  | EQ-015/M.05.v1 |
| (28) | 6.2 Frame break, recovery, and anchored  | MechanicalValidity != SemanticValidity | identity (non-collapse) |  | A.5/M.14.v1 |
| (29) | 6.2 Frame break, recovery, and anchored  | SourceExistence != ClaimSupport | identity (non-collapse) |  | A.5/M.15.v1 |
| (30) | 6.3 Disagreement as information | Disagreement => Resolve v Declare | governance definition |  | EQ-015/M.05.v1 |
| (31) | 7 From friction to fellowship | Friendship != IndependentEvidence | identity (non-collapse) |  | A.5/M.16.v1 |
| (32) | 7 From friction to fellowship | Correspondence != PeerReview | identity (non-collapse) |  | A.5/M.17.v1 |
| (33) | 7 From friction to fellowship | IntellectualAffinity != Truth | identity (non-collapse) |  | A.5/M.18.v1 |
| (34) | 8 Programme legibility: coherence that c | Coh_effective = Coh_latent x L_g | governance definition |  | EQ-002/M.02.v1 |
| (35) | 8 Programme legibility | L_g^proxy = (public assets with a one-click programme path) / (public assets) | definition (proxy measure) |  | EQ-002/M.02.v1 |
| (36) | 8 Programme legibility | K1 -> RelatedAssetDiscovery -> LongerExposure -> K2 opportunity | definition |  | EQ-002/M.02.v1 |
| (37) | 8.1 Association stability and recognitio | A_s = AssociationStrength(Author, Problem) | definition |  | A.8/M.09.v1 |
| (38) | 8.1 Association stability and recognitio | A_s(t+1) > A_s(t) | governance definition |  | A.8/M.09.v1 |
| (39) | 8.1 Association stability and recognitio | Paper1 -> Theme;  Paper2 -> SameTheme + NewMechanism;  Paper3 -> EmpiricalTest;  Paper4 -> BoundaryExtension | definition |  | A.8/M.09.v1 |
| (40) | 9.1 Production criticality is not schola | chi_t = lambda_mint / (lambda_conv + epsilon) | governance definition |  | weld/M.12.v1 |
| (41) | 9.1 Production criticality is not schola | B_t+1 = B_t + M_t - omega * X_t | governance definition |  | weld/M.12.v1 |
| (42) | 9.2 Mint-convert coupling | M_t <= lambda * X_t | governance definition |  | weld/M.12.v1 |
| (43) | 9.3 Back-catalog activation | C_t+1 = (1 - delta) * C_t + G_t + Phi_t(Stock) * I_t * P_t^(r) * S_t | governance definition |  | weld/M.12.v1 |
| (44) | 9.3 Back-catalog activation | ActivationAction != CreditEvent | identity (non-collapse) |  | A.5/M.19.v1 |
| (45) | 9.3 Back-catalog activation | d^2 E[C] / dt^2 > 0   can occur while   dM/dt <= 0 | governance definition |  | weld/M.12.v1 |
| (46) | 9.3 Back-catalog activation | dPhi(Stock)/dt > 0 | governance definition |  | weld/M.12.v1 |
| (47) | 9.4 Concept-cluster compounding | FlagshipConcept -> Preprint -> Conference -> Journal -> EmpiricalTest -> ComparativeExtension -> Grant | definition |  | A.8/M.10.v1 |
| (48) | 9.4 Concept-cluster compounding | CreditLeverage_i = ( sum_{j=1}^{n} CreditEvent_ij ) / (CoreIntellectualInvestment_i + epsilon) | governance definition |  | A.8/M.10.v1 |
| (49) | 10 Credit, provenance, and Goodhart cont | PRC(e_i) in {0, 1} | definition |  | A.8/M.04.v1 |
| (50) | 10 Credit, provenance, and Goodhart cont | C_t^valid = sum_i w_i * e_i * PRC(e_i) | governance definition |  | A.8/M.04.v1 |
| (51) | 11 Scholarly Credit Velocity and Gradien | V_C = dE[C]/dt ~= (CreditCreation x Retention x Conversion) / H_critical | governance definition |  | weld/M.12.v1 |
| (52) | 11 Scholarly Credit Velocity and Gradien | AIAcceleration -> HumanTimeReallocation | governance definition |  | weld/M.12.v1 |
| (53) | 11 Scholarly Credit Velocity and Gradien | V proportional-to  product_j x_j | definition/Dr (heuristic functional form) |  | weld/M.12.v1 |
| (54) | 11 Scholarly Credit Velocity and Gradien | dV/dx_j = V / x_j | definition (algebraic consequence of eq.53) |  | weld/M.12.v1 |
| (55) | 11 Scholarly Credit Velocity and Gradien | Priority_j = (dV/dx_j) / (MarginalHumanCost_j + epsilon) | governance definition |  | weld/M.12.v1 |
| (56) | 12 Criticality as a control mapping | k_t = nu_t * f_coh,t * L_g,t * p_int,t * m_leg,t * u_conv,t * P_NL,t | definition (diagnostic; explicitly disclaimed as a structural analogy, not a physical law) |  | A.8/M.11.v1 |
| (57) | 12.1 Prompt versus delayed channels | beta_D = ( sum_d w_d E_d ) / ( sum_d w_d E_d + sum_p w_p E_p + epsilon ) | governance definition |  | A.8/M.11.v1 |
| (58) | 12.1 Prompt versus delayed channels | IncreaseMintRate => beta_D >= beta_min  AND  IntegrityClean  AND  XenonLow  AND  ConversionLogOn | governance definition |  | A.8/M.11.v1 |
| (59) | 12.2 Reflectors, moderators, xenon, and  | rho_R = N^ind_{<=6m} / N^cit_{>6m} | governance definition |  | A.8/M.11.v1 |
| (60) | 12.2 Reflectors, moderators, xenon, and  | RawSpeed (down-arrow) =/=> V_C (down-arrow) | identity (non-collapse) |  | A.5/M.20.v1 |
| (61) | 12.2 Reflectors, moderators, xenon, and  | X_t = 1*(O_sub) + 2*(E_known) + 3*(C_stale) | governance definition |  | A.8/M.11.v1 |
| (62) | 12.2 Reflectors, moderators, xenon, and  | BR_t = N^{ind-reuse}_t / N^{terminal}_t | governance definition |  | A.8/M.11.v1 |
| (63) | 13 Legitimacy without truth laundering | L_H != Truth,   L_V != Truth | identity (non-collapse) |  | A.5/M.21.v1 |
| (64) | 13 Legitimacy without truth laundering | HorizontalGeneration -> EpistemicFriction -> VerticalStrengthening -> ResourceReturn -> HorizontalGrowth | definition |  | EQ-015/M.06.v1 |
| (65) | 14 Readout Universe as meta-governance | M_A[n] = K_A * theta(E[n]) + eta_sel + eta_map + eta_self | definition (inherited from Readout Universe/Lahtee 2026a) |  | EQ-015/E.12.v1 |
| (66) | 14 Readout Universe as meta-governance | M_A[n] != theta(E) | identity (non-collapse) |  | EQ-015/M.12.v1 |
| (67) | 14 Readout Universe as meta-governance | r = A*epsilon - delta,   V = (1/2) * r^T * W * r | definition/Dr |  | A.8/M.12.v1 |
| (68) | 14 Readout Universe as meta-governance | ClaimStrength <= EvidenceStrength | governance definition |  | weld/M.09.v1 |
| (69) | 15.1 Why one global route is insufficien | P_local (not subset of) D_AI | definition/Dr (conditional premise) |  | A.5/M.02.v1 |
| (70) | 15.1 Why one global route is insufficien | MultiAIConsensus =/=> GeographicCompleteness | identity (non-collapse) |  | A.5/M.22.v1 |
| (71) | 15.2 Geographic Distribution Audit | DVP* = DVP + GDA | governance definition |  | A.5/M.02.v1 |
| (72) | 15.3 Global strength without identity de | S_G = L x G x M x B x F | definition/Dr (not a psychometric scale) |  | A.5/M.02.v1 |
| (73)-(74) | 15.3 Global strength without identity de | DoubleBlind = Bonus;   DoubleBlind != Requirement | identity (non-collapse) |  | A.5/M.23.v1 |
| (75) | 15.3 Global strength without identity de | ManuscriptStrength > IdentityDependence | governance definition |  | A.5/M.02.v1 |
| (76) | 15.4 Global and Thai tracks | ConversionPlan_i = {Global_i, Thai_i} | definition |  | A.5/M.02.v1 |
| (77) | 15.4 Global and Thai tracks | K2,Global != K2,Thai | identity (non-collapse) |  | A.5/M.24.v1 |
| (78) | 15.4 Global and Thai tracks | K2,Global + K2,Thai => RouteDiversity (up-arrow) | governance definition |  | A.5/M.02.v1 |
| (79) | 16 Thailand as an operational epistemic  | FrictionValue_e = (F_e * O_e * D_e * R_e) / (T_e + C_e + P_e + epsilon) | governance definition |  | A.5/M.02.v1 |
| (80) | 16 Thailand as an operational epistemic  | GlobalAsset -> ThaiLegibility -> ThaiFriction | definition |  | A.5/M.02.v1 |
| (81) | 17 Open research toolchain as epistemic  | a*_f = argmax_a  FaceIndependence_f(a) | governance definition |  | A.8/H.04.v1 |
| (82) | 18.1 Integrity firewall | AI candidate -> OriginalSource -> ClaimMatch -> VerifiedCitation | definition |  | A.8/M.13.v1 |
| (83) | 18.3 Survival buffer | Reject -> Objection -> Revision -> Delta Q | definition |  | A.8/M.13.v1 |
| (84) | 18.4 Attention-credit separation | A_t != C_t^scholarly | identity (non-collapse) |  | A.5/M.27.v1 |
| (85) | 19 Human Mastery, ethics, and creator-ev | H_g = (questions defended without AI) / 10 | definition (governance heuristic) |  | A.8/M.14.v1 |
| (86) | 19 Human Mastery, ethics, and creator-ev | InterventionCreator != SoleEvaluator | identity (non-collapse) |  | A.5/M.25.v1 |
| (87) | 19 Human Mastery, ethics, and creator-ev | PracticeExperience != PopulationEvidence | identity (non-collapse) |  | A.5/M.26.v1 |
| (88) | 20 Portfolio control and defeat conditio | SCRAM = FreezeNewRelease + Correction + ReAudit | governance definition |  | A.8/M.13.v1 |
| (89) | 21 An integrated architecture | Phenomenon -> AIExploration -> DVP -> HumanMastery -> Integrity -> K1 -> {Global, Local Friction} -> K2 -> Revision -> K | definition |  | EQ-015/M.07.v1 |
| (90) | 21 An integrated architecture | E[C_{t+k}] > C_t | governance definition |  | weld/M.12.v1 |
| (91) | 21 An integrated architecture | V_C* = (C_Y * Coh_latent * L_g * Conv * Net * I * R * P * S * Ver) / (H_critical * (Debt + Frag + Bias + COI + epsilon)) | definition (deliberately heuristic, not a precision instrument) |  | weld/M.12.v1 |
| (92) | 22 Research propositions and empirical a | P* = argmax_{P_i} [ TheoreticalImportance_i x DiscriminatingPower_i ] | governance definition |  | A.8/H.04.v1 |
| (93) | 22 Research propositions and empirical a | ConceptualPaper -> CriticalEmpiricalTest -> TheoryRevision | definition |  | weld/M.10.v1 |
| (94) | 24 Conclusion: from epistemic isolation  | EpistemicPosition = RecognizableProblem + RepeatHumanNodes + CitableAssets + CorrectionHistory | definition |  | EQ-015/M.07.v1 |
| (95) | 24 Conclusion: from epistemic isolation  | CrediblePath = EarlyTimestamp + ExplicitProvisionality + RapidRevision + ExternalFriction + EventualCertification | definition |  | EQ-015/M.07.v1 |
| (96) | Appendix A: Finite diagnostic that motiv | M_attention != M_truth,   M_attention != M_K2 | identity (non-collapse) |  | A.5/M.28.v1 |
| (97)-(100) | Appendix B.1 Knowledge-state boundary | K0: private candidate;  K1: K0 + public timestamp, provenance, provisionality;  K2: K1 + substantive external friction;  | definition |  | weld/M.11.v1 |
| (101) | Appendix B.1 Knowledge-state boundary | DVP =/=> K2 | identity (non-collapse) |  | A.5/M.12.v1 |
| (102) | Appendix B.2 DVP route packet | MechanicalValidity != SemanticValidity | identity (non-collapse) |  | A.5/M.14.v1 |
| (103) | Appendix B.2 DVP route packet | SourceExistence != ClaimSupport | identity (non-collapse) |  | A.5/M.15.v1 |
| (104) | Appendix B.4 Preprint-to-human conversio | NoHumanAvailable =/=> ResearchStop | identity (non-collapse) |  | A.5/M.29.v1 |
| (105) | Appendix B.4 Preprint-to-human conversio | NoHumanAvailable => DVP -> K1 -> HumanAcquisition | governance definition |  | EQ-015/M.05.v1 |
| (106) | Appendix C Material feasibility and publ | B_year = B_conference + B_ethics + B_software + B_data + B_publication + B_travel | governance definition |  | A.8/M.15.v1 |
| (107)-(108) | Appendix C Material feasibility and publ | Prestige =/=> APCApproval;   APCApproval => FieldFit + CreditYield + BudgetFit | governance definition |  | A.5/M.30.v1 |
| (109) | Appendix C Material feasibility and publ | MissingResource => ProjectHold | governance definition |  | A.8/M.15.v1 |
| (110) | Appendix C.1 Superseded publication-cred | PC_i = JournalQuality_i x ProgrammeFit_i x ContributionStrength_i x UptakePotential_i | definition (superseded) |  | A.8/M.10.v1 |
| (111) | Appendix D K2 procurement | Cost_{K2,r} = (Cash_r + lambda_H*H_r + lambda_L*L_r) / (D_r * R_r * I_r + epsilon) | governance definition |  | A.8/M.05.v1 |
| (112) | Appendix D K2 procurement | ExpectedK2Yield_j = ( P(Review_j) * Depth_j * Fit_j ) / (Cash_j + Prep_j + Latency_j + epsilon) | governance definition |  | A.8/M.05.v1 |
| (113) | Appendix D K2 procurement | EffectiveK2 = Depth x Relevance x Independence | governance definition |  | A.8/M.05.v1 |
| (114) | Appendix E.1 Stock pressure and mint-con | chi_t = lambda_mint,t / (lambda_conv,t + epsilon) | governance definition |  | weld/M.12.v1 |
| (115) | Appendix E.1 Stock pressure and mint-con | B_t+1 = B_t + M_t - omega * X_t | governance definition |  | weld/M.12.v1 |
| (116) | Appendix E.1 Stock pressure and mint-con | M_t <= lambda * X_t | governance definition |  | weld/M.12.v1 |
| (117) | Appendix E.1 Stock pressure and mint-con | C_t+1 = (1 - delta) * C_t + G_t + Phi_t(Stock) * I_t * P_t^(r) * S_t | governance definition |  | weld/M.12.v1 |
| (118) | Appendix E.2 Critical human time and WIP | H_planned > H_sustainable => PortfolioShrink | governance definition |  | A.8/M.15.v1 |
| (119) | Appendix E.2 Critical human time and WIP | PublicWIP <= 3 | definition (local heuristic guardrail) |  | A.8/M.15.v1 |
| (120) | Appendix E.3 Portfolio and project prior | Priority_i = (I_i * N_i * E_i * F_i * Y_i * S_i) / (D_i + C_i + Frag_i + COI_i + epsilon) | governance definition |  | A.8/M.15.v1 |
| (121)-(122) | Appendix F AI disclosure and provenance  | DisclosurePenalty =/=> Concealment;   DisclosurePenalty => BetterProvenance + BetterHumanDefence + VenueFit | governance definition |  | A.5/M.31.v1 |
| (123) | Appendix F.2 Route-level disclosure | AIContribution != EpistemicResponsibility | identity (non-collapse) |  | A.5/M.32.v1 |
| (124) | Appendix H Embedded-practice and positio | NetPractice = P_A - (Co + Bi) | definition (bookkeeping heuristic) |  | A.8/M.06.v1 |
| (125) | Appendix H.1 Discovery-justification sep | PracticeObservation -> Hypothesis | definition |  | A.8/M.16.v1 |
| (126) | Appendix H.1 Discovery-justification sep | Claim <- Literature + ExternalEvidence + ComparativeEvidence | definition |  | A.8/M.16.v1 |
| (127) | Appendix H.1 Discovery-justification sep | InterventionCreator != SoleEvaluator | identity (non-collapse) |  | A.5/M.25.v1 |
| (128) | Appendix H.1 Discovery-justification sep | ClaimScope <= SamplingScope | governance definition |  | A.8/M.16.v1 |
| (129) | Appendix I.1 Dual-track invariant | ConversionPlan_i = {Global_i, Thai_i} | definition |  | A.5/M.02.v1 |
| (130) | Appendix I.1 Dual-track invariant | K2,Global != K2,Thai | identity (non-collapse) |  | A.5/M.24.v1 |
| (131) | Appendix I.2 Geographic Distribution Aud | MultiAIConsensus =/=> GeographicCompleteness | identity (non-collapse) |  | A.5/M.22.v1 |

### Written by AI. Still True. Knower Fetishism, Epistemic Pedigree, and the Human Face as a B — 10.5281/zenodo.22301202 (16 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| SC | 3. The Possession-Constitution Collapse | SC :  K(S, p) -> Subject(S) | definition (deliberately weak premise) |  | weld/E.02.v1 |
| HSC | 3. The Possession-Constitution Collapse | HSC :  Epi(X, p) -> Knower(X, p) | hypothesis (the collapse the paper rejects) |  | weld/E.02.v1 |
| Def-1 | 3. The Possession-Constitution Collapse | Pre-subjective constraint structure: a worldly state, relation, trace, record, or lawful dependence capable of constrain | definition |  | weld/E.02.v1 |
| Def-2 | 3. The Possession-Constitution Collapse | Possession-Constitution Collapse: occurs when a condition on who can possess knowledge is treated as a condition on what | definition |  | weld/E.02.v1 |
| Prin-1 | 3. The Possession-Constitution Collapse | Role Separation: generation, truth, evidential support, reliability, understanding, possession, endorsement, accountabil | law (non-collapse, named principle) |  | A.5/E.04.v1 |
| Prop-1 | 3. The Possession-Constitution Collapse | No transitivity of knowerhood: from the fact that knowledge has a subject it does not follow that every epistemically si | proposition |  | weld/E.02.v1 |
| (RA) | 3.1 The source label is a readout, not a | R_A = O_A(W; Pi_A) | definition |  | EQ-002/E.02.v1 |
| (m-rho) | 3.1 The source label is a readout, not a | m(A) != rho(A) | law (non-collapse) |  | EQ-002/E.02.v1 |
| Prin-2 | 3.1 The source label is a readout, not a | Bridge Burden: any inference from source metadata to a change in epistemic standing must identify the mediating relation | law (named principle) |  | weld/E.10.v1 |
| Prin-3 | 3.1 (Table 1 discussion) | No Bare Pedigree: a source label is epistemically incomplete reporting. The relevant object is not merely who or what pr | law (named principle) |  | EQ-015/E.14.v1 |
| (dCr) | 7. The Epistemic Pedigree Paradox | origin, procedure, dependence, checks, answerability  -->  Delta Cr(p) | definition (functional diagram) |  | A.8/E.02.v1 |
| (RPE) | 7. The Epistemic Pedigree Paradox | RPE = Cr(p \| E, R, A, O1) - Cr(p \| E, R, A, O2) | measurement (diagnostic, not a psychological law) |  | A.8/E.02.v1 |
| Def-4 | 7. The Epistemic Pedigree Paradox | Residual Provenance Effect: occurs when epistemic assessment changes with provenance after the epistemically relevant pa | definition |  | A.8/E.02.v1 |
| Prin-4 | 7. The Epistemic Pedigree Paradox | Provenance Relevance Constraint: provenance may rationally alter epistemic standing insofar as it changes total evidence | law (named principle) |  | A.8/E.03.v1 |
| Def-3 | 6. Knower fetishism | Knower fetishism: the treatment of the recognized identity, humanity, credentials, or social standing of a knower as tho | definition |  | weld/E.02.v1 |
| Prin-5 | 10. Institutions after epistemic monarch | Friction, not magic: institutional certification has epistemic force insofar as institutions produce reliable epistemic  | law (named principle) |  | EQ-002/E.12.v1 |

### The Readout Condition: Distinguishability, Access, and Epistemic Warrant — 10.5281/zenodo.22301318 (47 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 1. Introduction | No epistemic discrimination without provenance. | law (governing maxim) |  | A.8/E.01.v1 |
| (2) | 2.5 Suhrawardi: selectivity without repr | Representationality != Selectivity | law (non-collapse) |  | A.5/E.05.v1 |
| (3) | 3.2 Units and roles | D_Phi(x0) = { d0_x' = (x0, x') : Phi(x') != Phi(x0) } | definition |  | A.5/E.03.v1 |
| (4) | 3.2 Units and roles | P(d) = (V_d, E_d, tau_d) | definition |  | A.5/E.03.v1 |
| (5) | 4.1 Local contrasts and claim discrimina | Phi : X -> Z | definition |  | EQ-002/M.01.v1 |
| (6) | 4.2 Exact functional case | R : X -> Y | definition |  | EQ-002/M.01.v1 |
| Def-1 | 4.2 Exact functional case | Readout-admissible discrimination: a categorical claim structure Phi: X->Z is readout-admissible relative to R: X->Y whe | definition |  | EQ-002/M.01.v1 |
| (7) | 4.2 Exact functional case | R(x) = R(x')  =>  Phi(x) = Phi(x') | definition |  | EQ-002/M.01.v1 |
| Prop-1 | 4.2 Exact functional case | Factorization: for functions R: X->Y and Phi: X->Z, the following are equivalent: (i) Phi is constant on every fiber of  | proposition (with proof) |  | EQ-002/M.01.v1 |
| Princ-4 | 4.2 Exact functional case | Exact Readout Condition: if a categorical distinction in Phi is licensed by R alone, then Phi must be readout-admissible | law (named principle) |  | EQ-002/M.01.v1 |
| (8) | 4.3 Relational readouts: pointwise licen | N_R(x0) = { x' in X : (x0, x') in I_R } | definition |  | EQ-002/M.01.v1 |
| (9) | 4.3 Relational readouts: pointwise licen | N_R(x0) subseteq Phi^{-1}(z0) | law (named principle) |  | EQ-002/M.01.v1 |
| Prop-2 | 4.3 Relational readouts: pointwise licen | Reduction to the deterministic case: if I_R is induced by a deterministic readout R via x I_R x' <=> R(x)=R(x'), then re | proposition |  | EQ-002/M.01.v1 |
| (10) | 4.4 Stochastic readouts: access audit, n | K* : Y \| X | definition |  | EQ-002/M.01.v1 |
| (11) | 4.4 Stochastic readouts: access audit, n | C = G o K* | law (named principle) |  | EQ-002/M.01.v1 |
| (12) | 4.4 Stochastic readouts: access audit, n | K* != K~ | law (non-collapse) |  | EQ-002/M.01.v1 |
| (13) | 4.4 Stochastic readouts: access audit, n | Lambda_K~(y; x, x') = K~(y\|x) / K~(y\|x') | definition |  | EQ-002/M.01.v1 |
| (14) | 4.4 Stochastic readouts: access audit, n | log[P(x\|y)/P(x'\|y)] = log[P(x)/P(x')] + log Lambda_K~(y; x, x') | identity |  | EQ-002/M.01.v1 |
| (15) | 5.2 Identification ladder | A0 subseteq A1 subseteq ... subseteq Am | definition |  | weld/M.13.v1 |
| (16) | 5.2 Identification ladder | l(d0_x') = min{ j : x' not in Gamma_j } | definition (identification-ladder audit) |  | weld/M.13.v1 |
| Def-2 | 5.1 Typed augmentation grammar | Access augmentation: a new target-sensitive route is added to the epistemic basis (e.g. a second measurement, testimony, | definition |  | EQ-015/M.11.v1 |
| Def-3 | 5.1 Typed augmentation grammar | Contrast or relevance operation: the contrast domain changes, X -> X' subseteq X; a restriction selected after inspectin | definition |  | EQ-015/M.11.v1 |
| Def-4 | 5.1 Typed augmentation grammar | Inferential commitment: a model, prior, theory, bridge principle, calibration assumption, or other rule changes what can | definition |  | EQ-015/M.11.v1 |
| Def-5 | 5.1 Typed augmentation grammar | Decision-policy augmentation: a loss function, threshold, utility, or institutional rule maps an epistemic state into an | definition |  | EQ-015/M.11.v1 |
| Princ-7 | 5.3 The E-A-D form of the Readout Condit | E: provenance existence -- for every epistemically load-bearing claim distinction d, P(d) is nonempty or the claim is ex | law (named principle) |  | A.8/M.17.v1 |
| Princ-8 | 5.3 The E-A-D form of the Readout Condit | A: provenance attribution -- if the public or doxastic attribution map credits distinction d to source S, then S must pa | law (named principle) |  | A.8/M.17.v1 |
| Princ-9 | 5.3 The E-A-D form of the Readout Condit | D: provenance disclosure -- every non-source node on an essential dependency path to d must remain declared or recoverab | law (named principle) |  | A.8/M.17.v1 |
| Def-6 | 5.4 Epistemic overreach and silent lift | Epistemic overreach: a claim-level distinction exhibits epistemic overreach when it lacks an adequate provenance path, i | definition |  | A.8/M.18.v1 |
| Def-7 | 5.4 Epistemic overreach and silent lift | Silent lift: with lambda(d) the actual essential dependency set of distinction d and lambda-hat(d) the represented depen | definition |  | A.8/M.18.v1 |
| (17) | 5.5 Defeater routing on the provenance D | Ess(d) = intersection over p in Pi(d) of V(p) | definition |  | A.5/M.05.v1 |
| (18) | 5.5 Defeater routing on the provenance D | Pi_{Delta v}(d) = { p in Pi(d) : v not in V(p) } | proposition (with proof) |  | A.5/M.05.v1 |
| Cor-1 | 5.5 Defeater routing on the provenance D | Misrouted defeat under silent lift: if the symmetric difference between the actual essential set Ess(d) and the represen | corollary |  | A.5/M.05.v1 |
| (19) | 6.1 Deterministic composition | X --R1--> Y1 --R2--> Y2 --...--> Yn | definition |  | EQ-002/M.01.v1 |
| (20) | 6.1 Deterministic composition | ker R1 subseteq ker R1:n | corollary |  | EQ-002/M.01.v1 |
| (21) | 6.2 Stochastic composition | I(X; Y_{j+1}) <= I(X; Y_j) | identity |  | EQ-002/M.01.v1 |
| (22) | 6.3 Calibration and the model of the rea | R* != R~,   K* != K~ | law (non-collapse) |  | EQ-002/M.01.v1 |
| (23) | 8.1 Worked audit I: a positive diagnosti | P(D \| +) = 0.90(0.01) / [0.90(0.01) + 0.09(0.99)] ~= 0.0917 | measurement (worked example) |  | A.8/M.19.v1 |
| (24) | 8.1 Worked audit I: a positive diagnosti | (y, K~) + pi + L --> belief/action | definition (diagram) |  | A.8/M.19.v1 |
| (25) | 8.2 Worked audit II: AI-assisted inferen | C_D = G_D o K* | identity (worked example) |  | weld/M.14.v1 |
| Prop-4 | 8.2 Worked audit II: AI-assisted inferen | Retained-record route: if a supposedly fixed background corpus contains a current-case-specific retained record D(x) tha | proposition |  | weld/M.14.v1 |
| (26) | 9.1 What is actually new | distinction-token audit + source licensing + identification layer + typed provenance DAG + E-A-D norms + defeater routin | definition (novelty claim) |  | A.8/E.01.v1 |
| (27) | 11. Conclusion | What does the attributed source distinguish? | law (governing questions) |  | A.8/E.01.v1 |
| (28) | 11. Conclusion | Which distinction does the claim add? | law (governing questions) |  | A.8/E.01.v1 |
| (29) | 11. Conclusion | Which provenance path makes that addition licit? | law (governing questions) |  | A.8/E.01.v1 |
| (30) | 11. Conclusion | No epistemic discrimination without provenance. | law (governing maxim) |  | A.8/E.01.v1 |
| (31) | A.2 Pointwise relational reduction | N_R(x0) = R^{-1}(R(x0)) | identity |  | EQ-002/M.01.v1 |
| (32) | A.3 Distinction-level attribution map | lambda-hat : D_Phi(x0) -> 2^V | definition |  | EQ-002/M.01.v1 |

### From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Di — 10.5281/zenodo.22307148 (54 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 4.1 Readout-not-truth and problem format | M_A[n] = K_A * theta(E[n]) + eta_sel + eta_map + eta_self | definition |  | EQ-015/E.12.v1 |
| (2) | 4.1 Readout-not-truth and problem format | M_A[n] != theta(E[n]) | identity (non-collapse) |  | EQ-015/E.15.v1 |
| (3) | 4.1 Readout-not-truth and problem format | r_t = A_t*epsilon_t - delta_t,  V_t = (1/2) r_t^T W_t r_t | definition |  | weld/M.05.v1 |
| (4) | 4.1 Readout-not-truth and problem format | P_t := Retain_{Pi_P}(r_t) | definition |  | weld/M.05.v1 |
| (5) | 4.1 Readout-not-truth and problem format | Q_{Pi_Q}(P_t) = d_{Q,t} | definition |  | weld/M.05.v1 |
| (6) | 4.2 Meaning after readout | S_{A,t} := q_{sem,A,Omega_t}(Z_t) | definition |  | EQ-015/E.13.v1 |
| (7) | 4.2 Meaning after readout | S_{A,t+1} != S_{A,t}  is admissible and expected | identity (non-collapse) |  | EQ-015/E.15.v1 |
| (8) | 4.3 Reader equivalence | x ~_{O_D} y  <=>  O_alpha(x) = O_alpha(y)  for all alpha | definition |  | weld/M.03.v1 |
| (9) | 5.1 A provenance-typed distinction ledge | L_{Q,t} = {(d, chi_t(d))} | definition |  | weld/E.05.v1 |
| (10) | 5.1 A provenance-typed distinction ledge | chi_t(d) in {FORCED, DERIVED, POSITED, BORROWED, OPEN} | definition |  | weld/E.05.v1 |
| (11)-(12) | 5.2 Transport with explicit defect accou | Def_Q(T) := {d in L_{Q,t} : the declared readout of d is lost under T} | definition |  | weld/E.08.v1 |
| (13) | 5.2 Transport with explicit defect accou | Delta_O(d; s, T, Pi) := \|\| O^out_{A,Pi}(T(s (+) d)) - O^out_{A,Pi}(T(s)) \|\|_G | definition |  | weld/E.08.v1 |
| (14) | 5.2 Transport with explicit defect accou | lambda^{RG}_{A,T,Pi}(d;s) := Delta_O(d;s,T,Pi) / \|\|d\|\|^{in}_G | definition (diagnostic) |  | weld/E.08.v1 |
| (15) | 5.3 Reachability is not accessibility | 0 <= kappa_{A,t,Q}(s'\|s) <= 1 | definition |  | weld/M.06.v1 |
| (16) | 5.3 Reachability is not accessibility | mu_{A,t}(pi\|Q) := product_{k=0}^{m-1} kappa_{A,t,Q}(s_{k+1}\|s_k) | definition |  | weld/M.06.v1 |
| (17) | 5.3 Reachability is not accessibility | Acc_{A,t}(H\|Q) := sup_{pi: Gamma_Q(pi)=H} mu_{A,t}(pi\|Q) | definition |  | weld/M.06.v1 |
| (18) | 5.3 Reachability is not accessibility | reachable(H) = 1  =/=>  Acc(H\|Q) is high | proposition (non-collapse) |  | EQ-015/E.15.v1 |
| (19) | 5.4 History-shaped access: attraction an | a_{Q,t}(e) := [ Phi_{Q,t}(s) - Phi_{Q,t}(s') ]_+   for oriented edge e: s -> s' | definition |  | EQ-015/M.08.v1 |
| (20) | 5.4 History-shaped access: attraction an | m_{t+1}(e) = rho*m_t(e) + 1[e_t=e],  0<=rho<1 | definition | 13 | EQ-015/M.08.v1 |
| (21) | 5.4 History-shaped access: attraction an | kappa^{(0)}_{t+1}(e\|Q) propto kappa_t(e\|Q) * exp[ beta*a_{Q,t}(e) + mu*m_t(e) - nu*c_{A,t,Q}(e) + xi_t(e) ] | hypothesis [Open] | 14 | EQ-015/M.08.v1 |
| (22) | 5.5 Historical structural analogy, not e | wholesome =/= true,  unwholesome =/= false | identity (non-collapse) |  | EQ-015/E.15.v1 |
| (23) | 5.6 Restructuring and insight | D^{sem}_t := < q_{sem,t}, L_{Q,t}, G_t, kappa_t, Pi_{Q,t} > | definition |  | weld/M.06.v1 |
| (24) | 5.6 Restructuring and insight | B_t : D^{sem}_{t-} -> D^{sem}_{t+} | definition |  | weld/M.06.v1 |
| (25) | 5.6 Restructuring and insight | Acc_{t+}(H*\|Q) >> Acc_{t-}(H*\|Q) | measurement (candidate signature) |  | weld/M.06.v1 |
| (26) | 5.4 (thesis restatement) | Imagination is mobility inside finitude. | definition (thesis) |  | weld/M.06.v1 |
| (27) | 6.1 Generation, retention, and warrant a | H~_{A,t}(Q) := {(H, Acc_{A,t}(H\|Q)) : H retained by Gamma_Q} | definition |  | weld/M.06.v1 |
| (28) | 6.1 Generation, retention, and warrant a | A_i = A_t + Delta_{H_i} A | definition |  | weld/M.06.v1 |
| (29) | 6.1 Generation, retention, and warrant a | W_t(H_i) = W(delta_{<=t}, independence, defects, calibration) | definition |  | weld/M.06.v1 |
| (30)-(32) | 6.1 Generation, retention, and warrant a | a_{Q,t}(H_i) high =/=> W_t(H_i) high;  m_t(H_i) high =/=> W_t(H_i) high;  Acc(H_i) high =/=> W_t(H_i) high | identity (non-collapse, [Dr]) |  | EQ-015/E.15.v1 |
| (33) | 6.1 Generation, retention, and warrant a | Attraction != Warrant,  Momentum != Truth | identity (non-collapse) |  | EQ-015/E.15.v1 |
| (34)-(35) | 6.2 Readout-discriminable hypothesis cla | H_i ~_{O_D,U_{D,t},L} H_j  <=>  delta-hat_i(u) = delta-hat_j(u)  for all u in U_{D,t} over the declared horizon | definition |  | weld/M.07.v1 |
| (36) | 6.2 Readout-discriminable hypothesis cla | H^{disc}_{A,t}(Q) := {H : (H,Acc(H\|Q)) in H~_{A,t}(Q)} / ~_{O_D,U_{D,t},L} | definition |  | weld/M.07.v1 |
| (37) | 6.2 Readout-discriminable hypothesis cla | D_H(t) := \| H^{disc}_{A,t}(Q) \| | definition |  | weld/M.07.v1 |
| (38) | 6.2 Readout-discriminable hypothesis cla | H_i ~_{U_{D,t}} H_j  =/=>  H_i ~_{U_{D,t+1}} H_j | identity (non-collapse) |  | EQ-015/E.15.v1 |
| (39) | 7 Bounded Knower: Epistemic Standing Is  | K_{A,t}(Q, D; O_D, Pi_t, R_t) | definition |  | weld/E.03.v1 |
| (40) | 7 Bounded Knower: Epistemic Standing Is  | K_{A,t}(Q1,D1;...) =/=> K_{A,t}(Q2,D2;...) | identity (non-collapse) |  | weld/E.03.v1 |
| (41) | 7 Bounded Knower: Epistemic Standing Is  | K_{A,t}(Q,D;...) =/=> K_{A,t+1}(Q,D;...) | identity (non-collapse) |  | weld/E.03.v1 |
| (42) | 7 Bounded Knower: Epistemic Standing Is  | social/epistemic label  =/=>  unconditional standing across Q, D, t | proposition [Dr] (corollary) |  | weld/E.03.v1 |
| (43) | 8 Collective Epistemic Systems Without a | Z_{G,t} := < {Z_{A_i,t}}_{i=1}^n, T_{G,t}, A_{G,t}, C_{G,t} > | definition |  | weld/S.47.v1 |
| (44) | 8 Collective Epistemic Systems Without a | S_{G,t} := q_{sem,G,Omega_{G,t}}(Z_{G,t}) | definition |  | weld/S.48.v1 |
| (45) | 8 Collective Epistemic Systems Without a | m^G_{t+1}(e) = rho_G * m^G_t(e) + sigma_{G,t}(e) | definition |  | weld/S.49.v1 |
| (46) | 8 Collective Epistemic Systems Without a | W_{G,t}(H) = W_G(R_{G,<=t}, independence, defects, calibration, objection channels) | definition |  | weld/S.50.v1 |
| (47) | 8 Collective Epistemic Systems Without a | a_G up  =/=>  W_G(H) up;   m_G up  =/=>  truth | identity (non-collapse) |  | EQ-015/E.15.v1 |
| (48) | 9 Discrimination, Record, and Revision | delta-hat_i(u*) != delta-hat_j(u*) | definition |  | weld/M.08.v1 |
| (49) | 9 Discrimination, Record, and Revision | delta*_{t+1} = O_D(Z_{t+1}; u*) | definition |  | weld/M.08.v1 |
| (50) | 9 Discrimination, Record, and Revision | r*_i = delta-hat_i(u*) - delta*_{t+1} | definition |  | weld/M.08.v1 |
| (51) | 9 Discrimination, Record, and Revision | (Z_{t+1}, A_{t+1}, D^{sem}_{t+1}) = Update(Z_t, A_t, delta*_{t+1}, Pi_R) | definition |  | weld/M.08.v1 |
| (52) | 10 The Final Architecture | X_{A,t}(Q) := B_t(S_{A,t}, L_{Q,t}, Pi_{Q,t}) | definition |  | weld/M.07.v1 |
| (53) | 10 The Final Architecture | H~_{A,t}(Q) := Gamma_Q[ WReach^{kappa}_{A,t,Q}[X_{A,t}(Q)] ] | definition |  | weld/M.07.v1 |
| (54) | 10 The Final Architecture | H^{disc}_{A,t}(Q) = H~_{A,t}(Q) / ~_{O_D,U_{D,t},L} | definition |  | weld/M.07.v1 |
| (55) | 11 Human-AI Operator Attribution | alpha_t(o) in {HUMAN, AI, JOINT} | definition |  | EQ-002/H.04.v1 |
| (56) | 11 Human-AI Operator Attribution | o in Omega = {q_sem, Pi_P, Pi_Q, B, a, m, kappa, Gamma_Q, U_D, Pi_R} | definition |  | EQ-002/H.04.v1 |
| (57) | 11 Human-AI Operator Attribution | S^{epi}_H = (c_P, c_Q, c_H, c_D, c_R) | definition |  | EQ-002/H.04.v1 |
| (58) | 16 Conclusion | Attraction != Accessibility != Warrant != Truth | identity (non-collapse law) |  | EQ-015/E.15.v1 |

### Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discove — 10.5281/zenodo.22307561 (15 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 3.1 Knowledge organization is a domain r | G^K_{A,t}(Q) = < V_{A,t}, E_{A,t}, omega_{A,t,Q}, chi_{A,t} > | definition |  | weld/M.07.v1 |
| (2)-(3) | 3.2 From access to a usable hypothesis | U_{A,t}(Q) = { [H] in H^disc_{A,t}(Q) : W_t(H) >= w0,  exists u in U_{D,t} with Delta_u(H,H') > 0 for at least one live  | definition |  | weld/M.07.v1 |
| (4) | 3.2 From access to a usable hypothesis | usable != true | identity (non-collapse) |  | A.5/E.09.v1 |
| (5) | 4.1 First-passage time | tau_U = inf{ n >= 0 : Gamma_Q(S_n) in U_{A,n}(Q) } | definition |  | weld/M.07.v1 |
| (6) | 4.1 First-passage time | T_U(G^K, Q) = E[ tau_U \| G^K, Q ] | definition |  | weld/M.07.v1 |
| (7) | 4.2 Direction is a first-hit distributio | pi^{first}_{G^K,Q}(C_j) = Pr[ H_{tau_U} = C_j \| G^K, Q ] | definition |  | weld/M.07.v1 |
| (8) | 4.2 Direction is a first-hit distributio | D_dir = JS( pi_1^{first}, pi_2^{first} ) | definition (finite diagnostic) |  | weld/M.07.v1 |
| H1 | 5 Central Hypothesis and Propositions (H | G_1^K =/=~ G_2^K  =>  L(tau_U \| G_1^K, Q) =/=~ L(tau_U \| G_2^K, Q) | hypothesis [Open] |  | weld/M.07.v1 |
| (9) | 5.2 H3 - Efficiency-diversity tradeoff | P_Q(G^K) = < T_U, H(pi^{first}), D_H, W, C_escape > | definition |  | weld/M.07.v1 |
| H2 | 5.1 H2 - Organization-to-direction | pi^{first}_{G_1^K,Q} != pi^{first}_{G_2^K,Q} | hypothesis [Open] |  | weld/M.07.v1 |
| (10) | 7.4 Experiment D: graph-structured AI co | graph organization -> Delta T_U != 0 | hypothesis/measurement (prediction) |  | weld/M.07.v1 |
| (11) | 7.4 Experiment D: graph-structured AI co | graph organization -> D_dir > 0 | hypothesis/measurement (prediction) |  | weld/M.07.v1 |
| (12) | 8.1 Speed is not warrant | T_U down  =/=>  W(H) up  =/=>  truth | identity (non-collapse) |  | A.5/E.09.v1 |
| (13) | 9 Relationship to the Companion Theory | G^K --> (tau_U, pi^{first}) --> U | definition (schematic) |  | weld/M.07.v1 |
| (14) | 13 Conclusion | G^K => ( L(tau_U), pi^{first} ) | hypothesis (central proposal, [Open]) |  | weld/M.07.v1 |

### Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Al — 10.5281/zenodo.22307564 (7 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2 A Minimal Cycle, Not a Solution | Psi_{E,t,Q} : H^disc_{E,t}(Q) -> C_{E,t}(Q) | definition |  | A.5/E.02.v1 |
| (2) | 2 A Minimal Cycle, Not a Solution | Appraise_t : ( C_{E,t}(Q), delta_{<=t}, Pi_t ) -> R_t | definition |  | A.5/E.02.v1 |
| (3) | 2 A Minimal Cycle, Not a Solution | H not in C_{E,t}(Q)  =>  H receives no comparative appraisal at cycle t | identity (definitional consequence) |  | A.5/E.02.v1 |
| (4) | 2 A Minimal Cycle, Not a Solution | delta_{t+1} -> B_{t+1} -> C_{E,t+1}(Q') | definition |  | A.5/E.02.v1 |
| (5) | 2 A Minimal Cycle, Not a Solution | C_t -> Appraise_t -> delta_{t+1} -> B_{t+1} -> C_{t+1} | definition |  | A.5/E.02.v1 |
| (Q5, unlabeled) | 4.5 Q5. What is the collective candidate | C_{G,t} = union_i C_{A_i,t}  ? | hypothesis (posed then rejected as insufficient) [Open] |  | A.5/E.02.v1 |
| (6) | 11 Conclusion | Question -> Candidate-set formation -> Appraisal -> Record -> Candidate-set revision | definition (schematic) |  | A.5/E.02.v1 |

### Rigour Without Infrastructure: Three Propositions on Claim-Card Discipline as a Substitute — 10.5281/zenodo.22307841 (4 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (unnumbered, Sec.1) | 1 Problem Before Observation | R_A = O_A(W; Pi_A) != W | definition (readout-not-truth notation, inherited from Readout Universe/Readout Genesis) |  | EQ-002/E.02.v1 |
| (unnumbered, Sec.3.3) | 3.3 Existence-Attribution-Disclosure and | mechanical validity != semantic validity | identity (non-collapse) |  | A.5/M.14.v1 |
| (unnumbered, Sec.8.1, disclaimer D-DVP-NOT-K2) | 8.1 Knowledge state / D-DVP-NOT-K2 | DVP != K2 | identity (non-collapse) |  | A.5/M.12.v1 |
| (unnumbered, Sec.9 / Appendix disclaimer D-AUTHORSHIP) | 9 AI-assistance disclosure / D-AUTHORSHI | AIContribution != EpistemicResponsibility | identity (non-collapse) |  | A.5/M.32.v1 |

### State of Evidence for the Readout Hypothesis-Generation Programme: A Shared Evidence Regis — 10.5281/zenodo.22308066 (7 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (unnumbered, Sec.1) | 1 Purpose and Evidence Coding (Non-colla | neighboring evidence != formal-variable validation != truth of the integrated theory | identity (non-collapse rule) |  | A.5/M.03.v1 |
| (1) | 4 What the Literature Jointly Supports | reachability != accessibility | identity (non-collapse) |  | A.5/M.03.v1 |
| (2) | 4 What the Literature Jointly Supports | speed != quality/warrant | identity (non-collapse) |  | A.5/M.03.v1 |
| (3) | 4 What the Literature Jointly Supports | AI output volume != epistemic diversity | identity (non-collapse) |  | A.5/M.03.v1 |
| (unnumbered, Sec.4) | 4 What the Literature Jointly Supports ( | Attraction != Accessibility != Warrant != Truth | identity (non-collapse) / conceptual typing rule, not yet decomposed |  | A.5/M.03.v1 |
| (unnumbered, Sec.3.4) | 3.4 Stage D: hypothesis timing, usabilit | generation speed != hypothesis quality | identity (non-collapse), OBSERVED/MODERATE evidence support |  | A.5/M.03.v1 |
| (4) | 3.6 Stage F / 5.2 Paper II: knowledge to | G1K != G2K => L(tau_U \| G1K, Q) != L(tau_U \| G2K, Q) | hypothesis [Open] (Paper II H1-H2, requires randomized content-matched topology experiment) |  | A.5/M.04.v1 |

### The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguis — 10.5281/zenodo.22308072 (20 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 3.1 Human question as retained seed | Q^{AI}_{t+1} = Decompose_AI(Q_{H,t}, R_{<=t}, Pi_H) | definition |  | A.5/E.02.v1 |
| (2) | 3.2 Parallel semantic transport | T_AI = { T_lit, T_data, T_analogy, T_cross, T_counter, T_model, ... } | definition |  | A.5/E.02.v1 |
| (3) | 3.3 Candidate generation is not multipli | H^{disc}_{t+1} = H~_{t+1} / ~_{D,t} | definition |  | A.5/E.02.v1 |
| (4) | 3.3 Candidate generation is not multipli | U_{t+1} = Gate( H^{disc}_{t+1} ; W >= w0, provenance, testability ) | definition |  | A.5/E.02.v1 |
| (5) | 3.3 Candidate generation is not multipli | usable for propagation != true | identity (non-collapse) |  | A.5/E.02.v1 |
| (6) | 4 The Epistemic Multiplication Factor | New_{t+1} = U_{t+1} \ (union_{s<=t} U_s) | definition |  | A.5/E.02.v1 |
| (7) | 4 The Epistemic Multiplication Factor | k_epi(t) = \|New_{t+1}\| / max(1, \|F_t\|) | definition |  | EQ-002/E.08.v1 |
| (8) | 4 The Epistemic Multiplication Factor | k_epi < 1 : contractive frontier | definition |  | EQ-002/E.08.v1 |
| (9) | 4 The Epistemic Multiplication Factor | k_epi ~= 1 : roughly critical frontier | definition |  | EQ-002/E.08.v1 |
| (10) | 4 The Epistemic Multiplication Factor | k_epi > 1 : expanding frontier | definition |  | EQ-002/E.08.v1 |
| (11) | 5.3 A synergy quantity | Sigma_{H+AI} = D^{use}_{H+AI}(B,Q) / max{ D^{use}_H(B,Q), D^{use}_{AI}(B,Q), 1 } | definition (finite diagnostic) |  | A.5/H.04.v1 |
| (12) | 6 Why Maximum Delegation Is Not Maximum  | more AI output != more epistemic diversity;  more epistemic diversity != better warrant | identity (non-collapse) |  | A.5/H.04.v1 |
| (13)-(15) | 7 A Proposed Human-AI Chain-Reaction Wor | P^H_t -> Q_{H,t} --Decompose_AI--> Q^{AI}_{t+1} --T_AI--> H~_{t+1} --/~_{D,t}--> H^{disc}_{t+1} --Gate--> U_{t+1} --Spaw | definition (schematic) |  | A.5/E.02.v1 |
| (16) | 8.1 H1 - Productive multiplication | D^{use}_{H+AI,chain} > max{ D^{use}_H, D^{use}_{AI,1shot}, D^{use}_{AI,auto} } | hypothesis [Open] |  | A.5/H.04.v1 |
| (17) | 8.2 H2 - First-passage acceleration | T_U^{H+AI,chain} < T_U^H | hypothesis [Open] |  | A.5/H.04.v1 |
| (18) | 10 Relationship to Papers I-III | Question -> bounded semantic mobility -> H^{disc} | definition (schematic, cites Paper I) |  | A.5/E.02.v1 |
| (19) | 10 Relationship to Papers I-III | G^K -> ( L(tau_U), pi^{first} ) | definition (schematic, cites Paper II) |  | A.5/E.02.v1 |
| (20) | 10 Relationship to Papers I-III | H^{disc} --Psi--> C_t --appraisal--> delta_{t+1} | definition (schematic, cites Paper III) |  | A.5/E.02.v1 |
| (21) | 10 Relationship to Papers I-III | Q^H -> AI branching -> readout classes -> gated frontier -> new questions / hypotheses | definition (schematic) |  | A.5/E.02.v1 |
| (22) | 13 Conclusion | Question -> Branches -> Distinct Hypotheses -> Gates -> New Questions -> ... | definition (schematic) |  | A.5/E.02.v1 |

### Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrai — 10.5281/zenodo.22331922 (29 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| CN-1 | 1. Claim Types, Evidence, and Legitimate | D > 0, R > 0, A > 0 (constitutive necessities: Difference, Resistance, Agency). | hypothesis/Open |  | EQ-015/H.18.v1 |
| EF-01 | 3. Problem 1 - entry state | H0 = (P0, M0, U0, E0, Φ0), where the human declares the problem, current model, unknowns, independent evidence, and a ch | definition |  | EQ-015/H.02.v1 |
| EF-02 (Repair 1) | 3. Problem 1 - Repair 1: Baseline withou | H0* = (P0, M0, U0, E0, Φ0, κ0), where κ0 is the human's declared confidence in the pre-AI model. | definition |  | EQ-015/H.02.v1 |
| EF-03 (Repair 1) | 3. Problem 1 - Repair 1 | ENTRY_{H→AI} = H0* ∧ V0 ∧ C0 ∧ R*, where V0 is verification intent, C0 the candidate-status contract, R* a precommitted  | definition |  | EQ-015/H.02.v1 |
| EF-04 | 4. Problem 2 | AI(Q) = K_like, K_like ≠ K_validated. | law |  | EQ-015/H.10.v1 |
| EF-05 | 4. Problem 2 | K_like → K_assumed. | law |  | EQ-015/H.11.v1 |
| EF-06 (Repair 2) | 4. Problem 2 - Repair 2: status as state | K_like --check--> K_checked --independent support--> K_supported --declared warrant criterion V*--> K_validated\|V*. | proposition |  | EQ-015/H.11.v1 |
| EF-07 (Repair 3) | 5. Problem 3 - Repair 3: count equivalen | D_s^eff = \|C_s / ∼_R\|, d_s = D_s^eff / \|C_s\|. | measurement |  | weld/H.08.v1 |
| EF-08 (Repair 4) | 6. Problem 4 - Repair 4: resistance qual | R_s^ep = ρ(I_s, V_s, Q_s); U_s^R = u(C_s^v, T_s^v, A_s^v), where I_s = independence from generative loop, V_s = practica | proposition |  | EQ-015/H.14.v1 |
| EF-09 (Repair 4) | 6. Problem 4 - Repair 4 | R_s^ex = ψ(R_s^ep, U_s^R). | proposition |  | EQ-015/H.14.v1 |
| EF-10 | 6. Problem 4 | Resistance quality ≠ resistance accessibility. | law |  | EQ-015/H.14.v1 |
| EF-11 (Repair 5) | 7. Problem 5 - Repair 5 | K_s = (κ0, κ1, W0, W1), where W_t is the best available task-relative warrant/readout of correctness. | measurement |  | EQ-015/H.15.v1 |
| EF-12 (Repair 5) | 7. Problem 5 | Calibration error ≈ N^{-1} Σ_i (κ_i − y_i)^2, where y_i are repeated objective outcomes. | measurement |  | EQ-015/H.15.v1 |
| EF-13 | 8. Problem 6 | H_{s,t} → AI_{s,t} → H_{s,t+1} → AI_{s,t+1} → ⋯ | definition |  | EQ-015/H.05.v1 |
| EF-14 | 8. Problem 6 - finite history scores | m^H_{s,n+1}(e) = λ_H m^H_{s,n}(e) + 1[e_{s,n}=e]; m^AI_{s,n+1}(e) = λ_AI m^AI_{s,n}(e) + 1[e_{s,n}=e]. | measurement |  | EQ-015/H.05.v1 |
| EF-15 (Repair 6) | 8. Problem 6 - Repair 6 | P(e_{t+1} \| X_t, H_{<t}) ≠ P(e_{t+1} \| X_t). | hypothesis/Open |  | EQ-015/H.05.v1 |
| EF-16 | 8. Problem 6 - finite reciprocal amplifi | χ_recip[s,n,L] = \|D_recip[s,n,L]\| / \|Σ[s,n]\|. | measurement |  | EQ-015/H.05.v1 |
| EF-17 | 9. Problem 7 | Exposure ≠ Retention ≠ Improvement. | law |  | A.5/H.09.v1 |
| EF-18 (Repair 7) | 9. Problem 7 - Repair 7 | Y^return_{s+Δ} = (R_rec, R_disc, T_new, Q_next). | measurement |  | weld/H.07.v1 |
| EF-19 (Repair 7) | 9. Problem 7 - Repair 7 | RET = (P^post_{H,AI} − P^pre_{H,AI}) − (P^post_{H,C} − P^pre_{H,C}). | measurement |  | weld/H.07.v1 |
| EF-20 | 10. Problem 8 | G_s = g(k_s, d_s, v_s, p_s, r_s, 1−f_s, a_s); T_s = h(c_s, f_s, b_s, o_s); Δ_s = G_s − T_s. | definition |  | EQ-015/H.12.v1 |
| EF-21 | 10. Problem 8 | G_s = g(· \| Θ_s, Π_s); T_s = h(· \| Θ_s, Π_s). | definition |  | EQ-015/H.12.v1 |
| EF-22 (Repair 8) | 10. Problem 8 - Repair 8 | η_s > 0, Δ_s > 0 ⇒ durable expansion; η_s > 0, Δ_s < 0 ⇒ durable epistemic tunnel. | proposition |  | EQ-015/H.12.v1 |
| EF-23 | 11. Problem 9 | AUG_s = P_s^joint − P_s^H; SYN_s = P_s^joint − max(P_s^H, P_s^AI); RET_s = ΔP^return_{H,s+Δ}. | definition |  | EQ-015/H.19.v1 |
| EF-24 (Repair 9) | 11. Problem 9 - Repair 9 | J*_s = (AUG_s, SYN_s, RET_s). | definition |  | EQ-015/H.19.v1 |
| EF-25 | 12. Problem 10 | Θ_s = (C_s, U_s, V_s, T_s, Δ^{AI−H}_s), where C_s = task complexity, U_s = uncertainty, V_s = practical verifiability, T | definition |  | EQ-015/H.12.v1 |
| EF-26 (Repair 10) | 12. Problem 10 - Repair 10 | G_s = g(k,d,v,p,r,1−f,a \| Θ_s, Π_s); T_s = h(c,f,b,o \| Θ_s, Π_s). | proposition |  | EQ-015/H.12.v1 |
| EF-27 | 13. Revised Problem-First Architecture | H0* → K_like → D^eff → R^eff → H↔AI → χ_recip → η → (G−T \| Θ,Π) → Y^return → J*. | proposition |  | EQ-015/H.13.v1 |
| NCL-14 | 14. Revised Non-Collapse Laws | AI-first fluency ≠ human baseline; explanation ≠ verification; resistance quality ≠ resistance accessibility; uncertaint | law |  | A.5/H.07.v1 |

### CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human  — 10.5281/zenodo.22339909 (12 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| CTSA-01 | 5.1 Retained difference before semantic  | Δ^ret_H = R_Q(S^post_H) − R_Q(S^pre_H), where R_Q is a declared reader/question and S^pre_H, S^post_H are bounded task-r | definition |  | EQ-015/H.16.v1 |
| CTSA-02 | 5.2 Meaning, persistence, and truth rema | AI(Q) = K_like, K_like ≠ K_validated\|V*. | law |  | EQ-015/H.10.v1 |
| CTSA-03 | 7.1 Where workflow belongs | C → T → Workflow → S → A → C′. | proposition |  | weld/H.12.v1 |
| CTSA-04 | 9. The Full Human-Return Audit | R_H = ⟨G_CTSA, L, M, P, W, Δ_dir⟩. | definition |  | EQ-015/H.16.v1 |
| CTSA-05 | 10. Session-Boundary Architecture | Frozen Human baseline → K_like → Difference/Resistance → H↔AI → Retention gate → CTSA Return Profile → Unaided Return Te | proposition |  | weld/H.12.v1 |
| NCL-10 | 10. Session-Boundary Architecture (prese | AI fluency ≠ human baseline; explanation ≠ verification; output count ≠ epistemic diversity; exposure ≠ retention ≠ impr | law |  | A.5/H.10.v1 |
| H1 | 12. Hypotheses and Legitimate Defeaters | Incremental Readout Hypothesis [Open]: a CTSA Return Profile will explain reproducible variance in delayed unaided human | hypothesis/Open |  | EQ-015/H.20.v1 |
| H2 | 12. Hypotheses and Legitimate Defeaters | Partial Dissociation Hypothesis [Open]: Conceptual, Tool-Selection, Skill-Execution, and Alternative-Generation returns  | hypothesis/Open |  | EQ-015/H.20.v1 |
| H3 | 12. Hypotheses and Legitimate Defeaters | Return-vs-Exposure Prediction [Externally constrained]: items visible only while AI support is present will predict assi | hypothesis/Open |  | EQ-015/H.20.v1 |
| H4 | 12. Hypotheses and Legitimate Defeaters | Gain/Loss Asymmetry Hypothesis [Open]: positive CTSA gain can coexist with negative loss in previously accessible routes | hypothesis/Open |  | EQ-015/H.20.v1 |
| H5 | 12. Hypotheses and Legitimate Defeaters | Recombination Hypothesis [Open]: CTSA gains will sometimes interact compositionally (new Concept improves Tool selection | hypothesis/Open |  | EQ-015/H.20.v1 |
| H6 | 12. Hypotheses and Legitimate Defeaters | Regulation/Direction Hypothesis [Open]: equal gross CTSA gains will yield different later corrigibility depending on met | hypothesis/Open |  | EQ-015/H.20.v1 |

### glosa — Rigour Without Infrastructure: A Standalone Scholar Methodology for Human–AI Knowl — 10.5281/zenodo.22340255 (0 equations)

_No numbered equations ()._

### Human Learning as Epistemic Architecture: A Method for Word Mapping, Life-Concept Graphs,  — 10.5281/zenodo.22341297 (0 equations)

_No numbered equations (Checked exhaustively (full pdftotext, both plain and -layout modes, 51 pages, all sections read/scanned): this paper contains ZERO LaTeX-style numbered or boxed mathematical equations. It is a qualitative methods/pedagogy paper. Across the entire document there is exactly one algebraic-looking line in the whole text -- a prose identity the paper itself frames rhetorically, not as a formal equation: 'success = external recognition' -- and the paper's only recurring formal-looking objects are unnumbered prose pipeline/arrow diagrams (e.g. 'AI: data -> tokens -> embeddings -> relations -> retrieval -> evaluation -> update' vs 'Human learning: experience -> lived words -> meaning maps -> life-concept graphs -> retrieval-augmented inquiry -> constraint testing -> revision -> responsible action'; 'subject -> relation -> object' for life-concept-graph triples; 'encounter -> friction -> branching -> validation -> integration' for reflective dissonance; and an extended end-to-end pipeline 'word -> pre-reflective meaning -> source map -> meaning map -> semantic neighborhood -> life-concept graph -> retrieval -> constraint test -> reflective dissonance -> revision -> problem-context -> tools & workflow -> deliberate practice -> skill -> real problems -> feedback -> revision of map'). These are illustrative process diagrams and YAML-style worksheet templates (life_concept_graph triples, claim_status, constraint_test), not numbered/boxed propositions, definitions, theorems, or non-collapse laws with defined operators the way Experience Is the Human LoRA or Experience Is Meaning-Giving have. Master Equation River v1.4 confirms this: \citep{human_learning} is cited only descriptively (Sec. 'programme' list, Table 1 lineage) and is never attached via a \Src tag to any numbered master-river equation (eq.1-79); no symbol or pipeline from this paper appears in main.tex. Per the task instruction, a chapter with no numbered equations gets an empty array and this note; nothing has been invented to fill it.)._

### Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonan — 10.5281/zenodo.22357744 (29 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| EMG-01 | 6. Readout-Native Formalization | r_n = R_H(x_n \| H_n, c_n) | definition | 1 | EQ-002/E.01.v1 |
| EMG-02 | 6. Readout-Native Formalization | mu_n = Psi_H(r_n, H_n, c_n, Q_n) | definition | 2 | EQ-015/E.01.v1 |
| EMG-03 | 5.1 Meaning plurality without dilution / | mu_n = (mu_n^aff, mu_n^prag, mu_n^auto, mu_n^conc, mu_n^epi) | definition | 3 | EQ-015/E.01.v1 |
| EMG-04 | 6. Readout-Native Formalization | E_n = Phi_E(x_n, mu_n, kappa_n, c_n) | definition | 4 | EQ-015/E.04.v1 |
| EMG-05 | 6. Readout-Native Formalization | Experience = phenomenon-as-meaningfully-read (within a declared human domain) | identity | 5 | EQ-015/E.04.v1 |
| EMG-06 | 6. Readout-Native Formalization | ell_n = L_H(E_n, mu_n \| H_n, c_n); permits E_n, mu_n before stable ell_n | definition | 6 | EQ-015/E.05.v1 |
| EMG-07 | 10. Naming as a Recursive Operator | mu_n -> E_n -> ell_n -> mu_{n+1} -> E_{n+1} | identity | 7 | EQ-015/E.05.v1 |
| EMG-08 | 6. Readout-Native Formalization | H_{n+1} = U_H( H_n, Retain(E_n, mu_n, r_n), delta^world_{n:n+1} ) | definition | 8 | EQ-015/E.08.v1 |
| EMG-09 | 7. Resonance: External-Internal Experien | I_{H,n} = Retrieve(M_{H,n} \| c_n, Q_n) | definition | 9 | EQ-015/E.06.v1 |
| EMG-10 | 7. Resonance: External-Internal Experien | C_H(E_n^cur, I_{H,n} \| c_n, Q_n) in [0,1];  Res_H(n) = C_H(E_n^cur, I_{H,n} \| c_n, Q_n) | definition | 10 | EQ-015/E.06.v1 |
| EMG-11 | 7. Resonance: External-Internal Experien | Res != Identity,  Res != Truth,  Res != Retention,  Res != Improvement | law | 11 | EQ-015/E.06.v1 |
| EMG-12 | 7. Resonance: External-Internal Experien | Delta_Res = P(Y \| B, Res) - P(Y \| B) | hypothesis/Open |  | EQ-015/E.06.v1 |
| EMG-13 | 8. Rhythm: Structured Recurrence Across  | T_n = {(x_k, t_k, w_k)}_{k<=n};   R_n = Omega(T_n, B_n) | definition | 12 | EQ-015/M.08.v1 |
| EMG-14 | 8. Rhythm: Structured Recurrence Across  | m_{t+1}(e) = rho*m_t(e) + 1[e_t = e],  0 <= rho < 1 | definition | 13 | EQ-015/M.08.v1 |
| EMG-15 | 8. Rhythm: Structured Recurrence Across  | order != rhythm,  repetition != rhythm,  rhythm != meaning,  rhythm != retention | law |  | A.5/E.07.v1 |
| EMG-16 | 9. Accumulation, Potential, Barrier Cros | Delta W_{j,N} = sum_{n=1}^{N} eta_n * eligibleGradient_n | definition | 16 | EQ-015/E.07.v1 |
| EMG-17 | 9. Accumulation, Potential, Barrier Cros | W_n^eff = W_{info,n} * g( Res_H(n), eligibility, context ),  g left DR/Open | definition | 17 | EQ-015/E.07.v1 |
| EMG-18 | 9. Accumulation, Potential, Barrier Cros | sum_{k<=n} W_k^eff >= Delta V^dagger_{old->new} | hypothesis/Open | 18 | EQ-015/E.07.v1 |
| EMG-19 | 9. Accumulation, Potential, Barrier Cros | z_{n+1} = z_n + alpha*W_n^eff + epsilon_n | hypothesis/Open |  | EQ-015/E.07.v1 |
| EMG-20 | 9. Accumulation, Potential, Barrier Cros | release != transformation,  intensity != truth,  shock != insight,  barrier crossing != improvement | law |  | A.5/E.07.v1 |
| EMG-21 | 11. Human-AI Coupling Begins Before the  | H_t --L_H--> Q_t | law | 27 | EQ-015/H.01.v1 |
| EMG-22 | 11. Human-AI Coupling Begins Before the  | Y_t --R_H--> E^AI_{H,t} | definition | 28 | EQ-015/H.01.v1 |
| EMG-23 | 11. Human-AI Coupling Begins Before the  | H_{t+1} = U_H(H_t, E^AI_{H,t}, world correction, other experience) | definition | 29 | EQ-015/E.08.v1 |
| EMG-24 | 11. Human-AI Coupling Begins Before the  | H_t -> Q_t -> AI_t -> Y_t -> E_{H,t} -> Retain? -> H_{t+1} -> Q_{t+1} | definition |  | EQ-015/H.01.v1 |
| EMG-25 | 12. From Retained Experience to CTSA Hum | retained experiential reorganization -> possible later CTSA crystallization | hypothesis/Open |  | weld/H.09.v1 |
| EMG-26 | 12. From Retained Experience to CTSA Hum | retained sensitivity -> C_return;  retained reweighting -> A_return;  retained reorganization -> Q_next^better | hypothesis/Open |  | weld/H.09.v1 |
| EMG-27 | 13. Non-Collapse Laws | phenomenon != experience; event trace != meaning; meaning-giving != truth-making; pre-explicit significance != fully for | law |  | A.5/E.07.v1 |
| EMG-28 | 14.10 Rival model ladder | M0 = arousal/intensity only; M1 = familiarity/exposure; M2 = prediction/surprise; M3 = language/category construction; M | hypothesis/Open |  | weld/M.04.v1 |
| EMG-29 | 5.1 Meaning plurality without dilution | mu^aff != mu^epi,  mu^auto != mu^epi,  mu^prag != truth | law |  | A.5/E.07.v1 |

### Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective — 10.5281/zenodo.22357788 (29 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| CBC-01 | Sec. 6, Six Levels That Must Not Collaps | Πlive_{A,t}(g) ⊆ Πfeas_{A,t}(g) ⊆ Πphys_t(g), π^choice ∈ Πlive_{A,t}(g) | definition | 19 | A.5/S.14.v1 |
| CBC-02 | Sec. 6, Six Levels That Must Not Collaps | π^choice_{A,t} ∈ Πlive_{A,t}(g) | definition | 22 | A.5/S.17.v1 |
| CBC-03 | Sec. 6, Six Levels That Must Not Collaps | π^act ≠ π^choice possible; Yobs = Oq(H0:T); Yobs ≠ H0:T | definition | 23 | A.5/S.18.v1 |
| CBC-04 | Sec. 6, Six Levels That Must Not Collaps | possible ≠ feasible ≠ live ≠ chosen ≠ enacted ≠ observed | definition | 24 | A.5/S.19.v1 |
| CBC-05 | Sec. 7, A Live Possibility Field | L_{A,t}(g) = {(π, κ_{A,t}(π\|g)) : π ∈ Πfeas_{A,t}(g)} | definition | 20 | A.5/S.15.v1 |
| CBC-06 | Sec. 7, A Live Possibility Field | Πlive_{A,t}(g) = {π : κ_{A,t}(π\|g) ≥ τlive} | definition | 21 | A.5/S.16.v1 |
| CBC-07 | Sec. 8.1, Resonance: experiential fit | Resonance ≠ Consent, Resonance ≠ Truth | definition |  | EQ-015/S.04.v1 |
| CBC-08 | Sec. 9, Effective, Corrigible Agency Rev | p*_{A,g} = max_{π∈Πfeas_A(g)} Pr(Rg ∩ Dg ∩ Xg ∩ Fg) | definition | 25 | EQ-015/S.51.v1 |
| CBC-09 | Sec. 9, Effective, Corrigible Agency Rev | Πlive_{A,t}(g) ⊆ Πfeas_A(g; h, z, T, B) | definition |  | A.5/S.20.v1 |
| CBC-10 | Sec. 11, Structural Deprivation and Viol | L^live_{A,g} = max_{z∈Jfeas} DL(L^z_A(g), L^{z0}_A(g)) | definition | 26 | EQ-015/S.08.v1 |
| CBC-11 | Sec. 13, Human-AI: The Pre-Prompt Live P | Ht —L_H→ Qt | identity | 27 | EQ-015/H.03.v1 |
| CBC-12 | Sec. 13, Human-AI: The Pre-Prompt Live P | Qt → AIt → Yt —R_H→ E^AI_{H,t} | identity | 28 | EQ-015/H.03.v1 |
| CBC-13 | Sec. 13, Human-AI: The Pre-Prompt Live P | Ht+1 = UH(Ht, E^AI_{H,t}, δ^world, X^other) | definition | 29 | EQ-015/H.03.v1 |
| CBC-14 | Sec. 13, Human-AI: The Pre-Prompt Live P | L_{A,t+1} ≠ L_{A,t} | identity | 30 | EQ-015/H.03.v1 |
| CBC-15 | Sec. 13, Human-AI: The Pre-Prompt Live P | more live accessibility ≠ better agency; more fluent choice ≠ better choice | definition |  | EQ-015/S.04.v1 |
| CBC-16 | Sec. 15, Non-Collapse Laws | objective possibility ≠ structural feasibility; feasibility ≠ live possibility; live possibility ≠ stated preference; st | definition |  | EQ-015/S.04.v1 |
| CBC-P1 | Sec. 5, The Core Thesis: Choice Begins B | P1 — Objective possibility is not practical possibility. An action may be physically or legally available while remainin | proposition |  | EQ-015/S.05.v1 |
| CBC-P2 | Sec. 5, The Core Thesis: Choice Begins B | P2 — Practical possibility is meaning-shaped. An option becomes live only insofar as the agent can discriminate, interpr | proposition |  | EQ-015/S.05.v1 |
| CBC-P3 | Sec. 5, The Core Thesis: Choice Begins B | P3 — Meaning-shaping can alter agency. Changing how an option is named, framed, remembered, socially recognized, or conn | proposition |  | EQ-015/S.05.v1 |
| CBC-P4 | Sec. 5, The Core Thesis: Choice Begins B | P4 — Choice can be real within a narrowed field. A person may genuinely choose among the live options available while st | proposition |  | EQ-015/S.05.v1 |
| CBC-P5 | Sec. 5, The Core Thesis: Choice Begins B | P5 — Expansion can also be harmful. Increasing the number or salience of live options is not automatically emancipatory. | proposition |  | EQ-015/S.05.v1 |
| CBC-H1 | Sec. 16, Empirical Programme: Try to Kil | H1 [Open] — Live possibility beyond formal option count: the live-field model should predict which options enter deliber | hypothesis/Open |  | weld/S.09.v1 |
| CBC-H2 | Sec. 16, Empirical Programme: Try to Kil | H2 [Open] — Meaning access beyond resources: holding material resources constant, whether an option is intelligible/name | hypothesis/Open |  | weld/S.09.v1 |
| CBC-H3 | Sec. 16, Empirical Programme: Try to Kil | H3 [Open] — History-shaped re-entry: holding current option content fixed, prior traversal history should predict which  | hypothesis/Open |  | weld/S.09.v1 |
| CBC-H4 | Sec. 16, Empirical Programme: Try to Kil | H4 [Open] — Resonance without consent: high experiential congruence should predict felt fit or uptake but should not per | hypothesis/Open |  | weld/S.09.v1 |
| CBC-H5 | Sec. 16, Empirical Programme: Try to Kil | H5 [Open] — Structural closure before overt prohibition: changing retaliation risk, complaint credibility, interpretive  | hypothesis/Open |  | weld/S.09.v1 |
| CBC-H6 | Sec. 16, Empirical Programme: Try to Kil | H6 [Open] — Evaluator visibility: changing the assessment interface may change observed agency rankings without changing | hypothesis/Open |  | weld/S.09.v1 |
| CBC-H7 | Sec. 16, Empirical Programme: Try to Kil | H7 [Open/externally allied] — Human-AI live-field carryover: randomizing AI dialogue histories and then removing AI shou | hypothesis/Open |  | weld/S.09.v1 |
| CBC-H8 | Sec. 16, Empirical Programme: Try to Kil | H8 [Open] — Corrigibility predicts durable agency: feedback/objection capacity should predict later error correction bey | hypothesis/Open |  | weld/S.09.v1 |

### Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseu — 10.5281/zenodo.22361830 (25 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | Sec. 4.2, The joint event and the envelo | p*_{A,g}(h,z;T,B,P) := max_{π∈Πwit_A(g;h,z,T,B)} Pr^π_P(Rg ∩ Dg ∩ Xg ∩ Fg), with p*_{A,g} := 0 when the set is empty | definition | 25 | EQ-015/S.52.v1 |
| (2) | Sec. 4.2, The joint event and the envelo | p*_A = (p*_{A,g})_{g∈G}, C^α_A = {g : p*_{A,g} ≥ α} | definition |  | EQ-015/S.53.v1 |
| (3) | Sec. 4.2, The joint event and the envelo | A^corr_A(h,z;T,B,P,w) := Σ_g w_g p*_{A,g} ∈ [0,1] | definition |  | EQ-015/S.54.v1 |
| unnumbered | Sec. 4.2, The joint event and the envelo | p_{A,g}(π) = r·d·x·f, with r = Pr(Rg), d = Pr(Dg\|Rg), x = Pr(Xg\|Rg,Dg), f = Pr(Fg\|Rg,Dg,Xg) | identity |  | EQ-015/S.55.v1 |
| (4) | Sec. 4.3, Two layers | p*(2)_{A,g} := max_{z∈Jfeas} p*_{A,g}(h,z;T,B,P) | definition |  | EQ-015/S.56.v1 |
| (5) | Sec. 4.3, Two layers | L^recoverable_A = max_{z∈Jfeas} A^corr_A(h,z) − A^corr_A(h,z0) | definition |  | EQ-015/S.57.v1 |
| (6) | Sec. 4.4, Corrigibility and spectral sup | Δspec(Ri) > 0 ⟺ channel_i = open ∧ Ṙ_i ≠ 0 | definition |  | EQ-015/S.09.v1 |
| (7) | Sec. 6, Pseudo-peace: a gate collapse wi | Yobs = calm ∧ p*wit = low ∧ F = blocked | definition |  | EQ-015/S.58.v1 |
| PAR-stepper | Sec. 5, Setting (forced Laplacian model) | LR = DW − W (forced Laplacian); A := LR + Γ; s[n+1] = s[n] + dt(−A s[n] + J) | definition |  | weld/S.22.v1 |
| L1 | Sec. 5, Lemmas (invariance and recurrenc | s* = A^{-1}J is the unique fixed point independent of u; ∥s[n]−s*∥ ≤ ρ^{n−nB}∥s[nB]−s*∥ after the last nonzero tick of a | theorem |  | weld/S.23.v1 |
| L2 | Sec. 5, Lemmas (the bill) | \|u_i[n]\| = dt[(γ_i+D_i)(s*_i−θ) − Σ_{k≠i} W_ik(s*_k−s_k[n])], converging to a rate F_i^∞ > 0 whenever s*_i ≥ θ, so cumul | theorem |  | weld/S.24.v1 |
| L3 | Sec. 5, Lemmas (operator change) | s*'_i = s*_i / (1+ΔB_ii) with B = A^{-1} (Sherman–Morrison); any θ < s*_i is reached below with Δ > Δ* = (s*_i/θ − 1)/B_ | theorem |  | weld/S.25.v1 |
| L4 | Sec. 5, Lemmas (mutation) | s_j ≳ (J_j + W_ij·s̄_i)/(γ_j+D_j), with s̄_i an explicit increasing function of node i's own inflow, under permanent per | theorem |  | weld/S.26.v1 |
| D1 (NC-78) | Sec. 3, An anatomy of 'potential': seven | Potential ≠ exercised ≠ observed | definition |  | EQ-015/S.59.v1 |
| D2 | Sec. 3, An anatomy of 'potential': seven | Declared set ≠ witnessed set | definition |  | EQ-015/S.60.v1 |
| D3 | Sec. 3, An anatomy of 'potential': seven | Layer 1 ≠ layer 2 | definition |  | EQ-015/S.61.v1 |
| D4 | Sec. 3, An anatomy of 'potential': seven | Task potential ≠ aggregate potential | definition |  | EQ-015/S.62.v1 |
| D5 | Sec. 3, An anatomy of 'potential': seven | Feasible ≠ permitted | definition |  | EQ-015/S.63.v1 |
| D6 (NC-79) | Sec. 3, An anatomy of 'potential': seven | Diagnosis of compression ≠ attribution of responsibility | definition |  | EQ-015/S.64.v1 |
| D7 | Sec. 3, An anatomy of 'potential': seven | Recoverable gap ≠ accumulated loss | definition |  | EQ-015/S.65.v1 |
| P-A | Sec. 8, Falsifiable propositions | Pseudo-peace signature: amplitude-suppressing interventions raise the calm an evaluator reads while p*wit does not rise  | hypothesis/Open |  | EQ-015/S.10.v1 |
| P-B | Sec. 8, Falsifiable propositions | Channel shift: when F is blocked and C^α shrinks in task g, load rises in a coupled task g' while the aggregate (3) stay | hypothesis/Open |  | EQ-015/S.12.v1 |
| P-C | Sec. 8, Falsifiable propositions | The excluded path: groups whose min_i \|C^α_i\| falls while the mean rises show persistent cost concentration (CE-30) and  | hypothesis/Open |  | EQ-015/S.12.v1 |
| P-D | Sec. 8, Falsifiable propositions | Layer 2 dominates the structural case: in cases classified as structural, the gap closable by layer-2 interventions exce | hypothesis/Open |  | EQ-015/S.12.v1 |
| PAR-cert | Sec. 4.5, Identifiability (an exact cert | P1: r=d=x=9/10, channel always open, every reason voiced ⇒ f_P1=1, p*_P1=729/1000. P2: channel open w.p. 1/5, every open | measurement |  | A.8/S.01.v1 |

### Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganizati — 10.5281/zenodo.22410666 (15 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| MBN-readout | 5. The Core Readout-Retention Architectu | r_n = R_H(x_n \| H_n, c_n) | definition |  | EQ-002/E.01.v1 |
| MBN-config | 5. The Core Readout-Retention Architectu | μ_n = G(r_n, M_{n-1}, A_{n-1}, L_{n-1}, V_{n-1}, c_n) | definition |  | EQ-015/E.01.v1 |
| MBN-experience | 5. The Core Readout-Retention Architectu | E_n = Φ(r_n, μ_n, B_n, c_n) | definition |  | EQ-015/E.04.v1 |
| MBN-retention | 5. The Core Readout-Retention Architectu | H_{n+1} = U(H_n, Retain(E_n, r_n, μ_n), δ^world_{n:n+1}) | definition |  | EQ-015/E.08.v1 |
| MBN-naming | 5. The Core Readout-Retention Architectu | ℓ_n = L_H(E_n, μ_n \| H_n, c_n) | definition | 6 | EQ-015/E.05.v1 |
| MBN-resonance-diagnostic | 6. Resonance Is Reorganization, Not Tran | ΔA_H(x,c) = A_H^post − A_H^pre | measurement |  | EQ-015/E.06.v1 |
| MBN-articulation | 7. Language Is a Special Transport Layer | Z_{H,t} —L_H→ Q_{H,t} | definition |  | EQ-015/H.01.v1 |
| §8-non-collapse-chain | 8. From Felt Change to Retained Human Ch | Exposure ≠ felt intensity ≠ retention ≠ improvement | law |  | A.5/E.06.v1 |
| §11-non-collapse-laws | 11. Non-Collapse Laws | external pattern ≠ meaning; meaning ≠ explicit naming; shared stimulus ≠ shared inner state; affective intensity ≠ epist | law |  | A.5/E.06.v1 |
| H1 | 13. Empirical Programme | H1 — Pre-nominative reorganization [Open] | hypothesis/Open |  | EQ-015/E.05.v1 |
| H2 | 13. Empirical Programme | H2 — Reader dependence [Open] | hypothesis/Open |  | EQ-002/E.01.v1 |
| H3 | 13. Empirical Programme | H3 — Translation loss [Open] | hypothesis/Open |  | EQ-015/E.05.v1 |
| H4 | 13. Empirical Programme | H4 — Retention selectivity [Open] | hypothesis/Open |  | EQ-015/E.08.v1 |
| H5 | 13. Empirical Programme | H5 — Recursive naming [Open] | hypothesis/Open |  | EQ-015/E.05.v1 |
| H6 | 13. Empirical Programme | H6 — No automatic improvement [Derived guardrail] | hypothesis/Open |  | A.5/E.06.v1 |

### Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility — 10.5281/zenodo.22424434 (56 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2.5 Power, interpretive resources, and s | Retention -> Structure -> Translation -> Readout -> Meaning -> Report | definition |  | EQ-015/M.04.v1 |
| (2) | 2.5 Power, interpretive resources, and s | Retention -> Structure -> Candidate State -> Sufficiency -> Quotient -> Domain Dynamics -> Readout -> Meaning -> Experie | definition |  | EQ-015/M.04.v1 |
| (3) | 3.1 Root state and finite stepper | S_n = (G_n, Lambda_n, T_n) | definition |  | EQ-015/M.01.v1 |
| (4) | 3.1 Root state and finite stepper | S_(n+1) = F(S_n, u_n, c_n, T_n) | definition |  | EQ-015/M.02.v1 |
| (5) | 3.1 Root state and finite stepper | S_n != Z_(MEMK,n) != D_(MEMK,n) | definition |  | A.5/M.01.v1 |
| (6) | 4. Domain Weld: How Human Vocabulary Is  | q_(D,n+1) o F_n = F^#_(D,n) o q_(D,n) | definition |  | weld/M.02.v1 |
| (7) | 4. Domain Weld: How Human Vocabulary Is  | epsilon_H = Def( q~_H o F, F^#_H o q~_H, O_H, Inv_H ) | definition |  | weld/H.06.v1 |
| (8) | 5. From Retained Record to Meaning and E | A_n != r_n != x_n | definition |  | A.5/E.01.v1 |
| (9) | 5. From Retained Record to Meaning and E | rho^H_n = R_H(x_n \| H_n, c_n, Q_n) | definition |  | EQ-002/E.01.v1 |
| (10) | 5. From Retained Record to Meaning and E | mu_n = Psi_H(rho^H_n, H_n, c_n, Q_n) | definition |  | EQ-015/E.03.v1 |
| (11) | 5. From Retained Record to Meaning and E | mu_n = (mu_n^aff, mu_n^prag, mu_n^auto, mu_n^conc, mu_n^epi) | definition |  | EQ-002/E.04.v1 |
| (12) | 5. From Retained Record to Meaning and E | E_n = Phi_E(x_n, mu_n, gamma^mu_n, c_n) | definition |  | EQ-015/E.04.v1 |
| (13) | 5. From Retained Record to Meaning and E | Experience = phenomenon-as-meaningfully-read | definition |  | EQ-015/E.04.v1 |
| (14) | 5.1 Naming comes later, but can loop bac | l_n = L_H(E_n, mu_n \| H_n, c_n);  E_n, mu_n may precede stable l_n | definition |  | EQ-002/E.05.v1 |
| (15) | 5.1 Naming comes later, but can loop bac | mu_n -> E_n -> l_n -> mu_(n+1) -> E_(n+1) | definition |  | EQ-002/E.05.v1 |
| (16) | 6. Retention: The Reader Can Change | H_(n+1) = U_H( H_n, Retain(E_n, mu_n, rho^H_n), delta^world_(n:n+1), X^other_(n:n+1) ) | definition |  | EQ-015/E.08.v1 |
| (17) | 6. Retention: The Reader Can Change | Retain(E_n) > 0  ==>  H_(n+1) != H_n  (possible, not guaranteed) | proposition |  | EQ-015/E.08.v1 |
| (18) | 7. History-Shaped Readout-Accessibility | a_(Q,t)(e) = [ Phi_(Q,t)(s) - Phi_(Q,t)(s') ]_+ | definition |  | EQ-002/E.06.v1 |
| (19) | 7. History-Shaped Readout-Accessibility | m_(t+1)(e) = rho m_t(e) + 1[e_t = e],  0 <= rho < 1 | definition |  | EQ-002/E.06.v1 |
| (20) | 7. History-Shaped Readout-Accessibility | kappa^sem_(t+1)(e\|Q) proportional-to kappa^sem_t(e\|Q) * exp[ beta a_(Q,t)(e) + mu_m m_t(e) - nu c_(A,t,Q)(e) + xi_t(e) ] | hypothesis/Open |  | EQ-002/E.06.v1 |
| (21) | 7. History-Shaped Readout-Accessibility  | Pi^live_(A,t)(g) subseteq Pi^feas_(A,t)(g) subseteq Pi^phys_t(g) | definition |  | EQ-015/H.07.v1 |
| (22) | 8. Before Choice: The Live Possibility F | L_(A,t)(g) = { (pi, lambda^live_(A,t)(pi\|g)) : pi in Pi^feas_(A,t)(g) } | definition |  | EQ-015/H.08.v1 |
| (23) | 8. Before Choice: The Live Possibility F | Pi^live_(A,t)(g) = { pi : lambda^live_(A,t)(pi\|g) >= tau_live } | definition |  | EQ-015/H.08.v1 |
| (24) | 8. Before Choice: The Live Possibility F | pi^choice_(A,t) in Pi^live_(A,t)(g) | definition |  | A.5/H.05.v1 |
| (25) | 8. Before Choice: The Live Possibility F | pi^act_(A,t) != pi^choice_(A,t) is possible;  Y_obs = O_q(H_(0:T)),  Y_obs != H_(0:T) | definition |  | A.5/H.05.v1 |
| (26) | 8. Before Choice: The Live Possibility F | possible != feasible != live != chosen != enacted != observed | definition |  | A.5/H.05.v1 |
| (27) | 9. Effective, Corrigible Agency | p*_(A,g)(h,z;T,B,P) = max_(pi in Pi^wit_A(g;h,z,T,B)) Pr^(pi_P)( Read_g cap D_g cap X_g cap F_g ) | measurement |  | EQ-015/H.09.v1 |
| (28) | 9.1 Power before prohibition | Power may alter agency by altering meaning/accessibility before overt choice | proposition |  | weld/S.06.v1 |
| (29) | 10. Human-AI Mediation Begins Before the | H_t --L_H--> Q_t,  Q_t != H_t | definition |  | A.5/H.01.v1 |
| (30) | 10. Human-AI Mediation Begins Before the | Q_t -> AI_t -> Y_t | definition |  | EQ-015/H.04.v1 |
| (31) | 10. Human-AI Mediation Begins Before the | AI(Q_t) = K_like,  K_like != K_validated | definition |  | EQ-015/H.10.v1 |
| (32) | 10. Human-AI Mediation Begins Before the | Y_t --R_H--> E^AI_(H,t) | definition |  | EQ-015/H.04.v1 |
| (33) | 10. Human-AI Mediation Begins Before the | H_(t+1) = U_H( H_t, E^AI_(H,t), delta^world, X^other ) | definition |  | EQ-015/H.04.v1 |
| (34) | 10. Human-AI Mediation Begins Before the | L_(A,t+1) != L_(A,t) | definition |  | A.5/H.06.v1 |
| (35) | 10.1 Difference, resistance, and retaine | D > 0,  Resist > 0,  A_H > 0 | definition |  | EQ-015/H.18.v1 |
| (36) | 10.1 Difference, resistance, and retaine | Delta Omega^(fH)_s = B_s A_s,  rank(B_s A_s) << d_H | definition |  | weld/H.07.v1 |
| (37) | 10.1 Difference, resistance, and retaine | Omega^H_(s+1,0) = Omega^H_(s,0) + eta_s Delta Omega^(fH)_s,  0 <= eta_s <= 1 | definition |  | weld/H.07.v1 |
| (38) | 11. Human Return: The Upper Measurement  | H^return = < G_CTSA, L, M, P, W, Delta_dir > | definition |  | EQ-015/H.16.v1 |
| (39) | 11. Human Return: The Upper Measurement  | Exposure != Retention != Improvement | definition |  | A.5/H.09.v1 |
| (40) | 11. Human Return: The Upper Measurement  | Assisted performance != Unaided Human Return | definition |  | A.5/H.08.v1 |
| (41) | 13. Provenance and Claim Status Are Part | Lambda(e_i) = < Prov_i, Tier_i, Def_i, Reader_i, Falsifier_i > | definition |  | A.8/M.02.v1 |
| (42) | 14. Why This Is Not Simply Active Infere | root retention =/=\|= belief state =/=\|= meaning =/=\|= experience =/=\|= choice | definition |  | A.5/E.01.v1 |
| (43) | 15. Why This Is Not Simply Affordance or | feasible for the agent != currently live for the agent | definition |  | EQ-015/H.07.v1 |
| (44) | 17.1 Rival-model ladder | M0 = formal option count + stated preference | definition |  | weld/H.11.v1 |
| (45) | 17.1 Rival-model ladder | M1 = affordance/capability + cost/resources | definition |  | weld/H.11.v1 |
| (46) | 17.1 Rival-model ladder | M2 = constructed-preference / salience model | definition |  | weld/H.11.v1 |
| (47) | 17.1 Rival-model ladder | M3 = predictive or active-inference implementation | definition |  | weld/H.11.v1 |
| (48) | 17.1 Rival-model ladder | M4 = readout-native live-field model | definition |  | weld/H.11.v1 |
| (49) | 18. Graceful Degradation | retained distinction -> domain translation/readout -> meaning -> experience -> retained change -> graded accessibility - | definition |  | EQ-015/M.04.v1 |
| (50) | 20. Conclusion: Before Meaning, Before C | Retained Difference -> Admissible Readout -> Meaning -> Experience -> History-Shaped Accessibility -> Live Possibility - | definition |  | EQ-015/M.04.v1 |
| H1 | 17.2 Minimal empirical predictions | H1 - Live-field incremental value [Open]. Under matched feasible sets, L_(A,t) will explain reproducible variance in whi | hypothesis/Open |  | EQ-015/H.34.v1 |
| H2 | 17.2 Minimal empirical predictions | H2 - History residual [Open]. Prior traversal history will predict later route accessibility after current semantic stat | hypothesis/Open |  | EQ-015/H.34.v1 |
| H3 | 17.2 Minimal empirical predictions | H3 - Pre-prompt carryover [externally constrained, mechanism Open]. Repeated Human-AI interaction can alter later human  | hypothesis/Open |  | EQ-015/H.34.v1 |
| H4 | 17.2 Minimal empirical predictions | H4 - Human Return dissociation [Open]. Delayed unaided Concept, Tool, Skill, and Alternative Return will show partially  | hypothesis/Open |  | EQ-015/H.34.v1 |
| H5 | 17.2 Minimal empirical predictions | H5 - Gain/loss asymmetry [Open]. Positive gross return can coexist with reduced checking habits, uncertainty sensitivity | hypothesis/Open |  | EQ-015/H.34.v1 |
| H6 | 17.2 Minimal empirical predictions | H6 - Optional modifiers must earn survival [Open]. Resonance, rhythm, and barrier/transition variables remain only if th | hypothesis/Open |  | EQ-015/H.34.v1 |

### AI–Cognitive Interaction: Activating Youth Potential through Reflective Dialogue and Lingu — 10.5281/zenodo.22456414 (2 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2. Reading This Paper Through the Progra | Π^live_{A,t}(g) ⊆ Π^feas_{A,t}(g) ⊆ Π^phys_t(g) | definition (quoted, not a new claim of this paper) | 21 | EQ-015/H.07.v1 |
| (2) | 2. Reading This Paper Through the Progra | H_{n+1} = U_H( H_n, Retain(E_n, μ_n, ρ^H_n), δ^world_{n:n+1}, X^other_{n:n+1} ) | definition (quoted, not a new claim of this paper) | 8 | EQ-015/E.08.v1 |

### Operational Linguistic Wisdom: Elective Connectivity and Linguistic Capital Activation in  — 10.5281/zenodo.22456487 (14 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 5.1 Elective Connectivity | H_org,t --consent, scope--> Q_org,t,   Q_org,t ≠ H_org,t | definition | 27 | A.5/H.01.v1 |
| (2) | 5 (Capability Activation stage) | AI(Q_org,t) = K_like,   K_like ≠ K_validated | definition | 38 | EQ-015/H.10.v1 |
| unlabeled (5, Reflexive Reconfiguration stage) | 5 (Reflexive Reconfiguration stage) | H_org,t+1 = U_Horg( H_org,t , ... ) | definition | 8 | EQ-015/E.08.v1 |
| unlabeled (§2, falsifier condition) | 2 Introduction: From Communication Chann | no H_org,n+1 ≠ H_org,n attributable to the processing | hypothesis/Open |  | A.5/S.02.v1 |
| unlabeled (§5.1, provenance ledger) | 5.1 Construct clarity | Λ(e_i) = ⟨ Prov_i, Tier_i, Def_i, Reader_i, Falsifier_i ⟩ | definition |  | A.8/M.02.v1 |
| unlabeled (§5.2, AVRH) | 5.2 OLW and AVRH (kept, reformulated) | D > 0,   Resist > 0,   A_H > 0 | definition |  | EQ-015/H.18.v1 |
| P1 | 7 Propositions for Future Testing (Open  | Connectivity quality: Elective Connectivity quality predicts the breadth and safety of linguistic assets available for l | hypothesis/Open |  | weld/S.08.v1 |
| P2 | 7 Propositions for Future Testing (Open  | Activation clarity: Capability Activation routines predict concept clarity and perceived value alignment. | hypothesis/Open |  | weld/S.08.v1 |
| P3 | 7 Propositions for Future Testing (Open  | Reconfiguration cadence: Reflexive Reconfiguration cadence predicts policy-update rates and learning-KPI improvements. | hypothesis/Open |  | weld/S.08.v1 |
| P4 | 7 Propositions for Future Testing (Open  | Reviewer diversity: Reviewer diversity strengthens clarity and alignment (moderation). | hypothesis/Open |  | weld/S.08.v1 |
| P5 | 7 Propositions for Future Testing (Open  | Over-reliance: Over-reliance on LLM outputs weakens the P2-P3 relationships (negative moderation), paralleling K_like ≠  | hypothesis/Open |  | weld/S.08.v1 |
| P6 | 7 Propositions for Future Testing (Open  | Minimization trade-off: Data minimization reduces decontextualization risk without lowering activation benefits. | hypothesis/Open |  | weld/S.08.v1 |
| P7 | 7 Propositions for Future Testing (Open  | Dissent protocols: Formal dissent protocols reduce power-capture risk. | hypothesis/Open |  | weld/S.08.v1 |
| P8 | 7 Propositions for Future Testing (Open  | SECI complementarity: SECI-practicing organizations experience complementary gains from OLW routines. | hypothesis/Open |  | weld/S.08.v1 |

### The Dialogue as the Ground of Enlightenment: Religious and Cognitive Frameworks for Unders — 10.5281/zenodo.22456564 (9 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 3 Reflective Dialogue as a Mirror of Tho | μ_n = Ψ_H(ρ_n^H, H_n, c_n, Q_n) | definition | 2 | EQ-015/E.03.v1 |
| (2) | 6 Digital Yonisomanasīkāra as a Working  | Z_dlg[s,n+1] = F#_dlg( Z_dlg[s,n], u_H[s,n], u_AI[s,n], c[s,n], T[s,n] ) | definition | 31 | EQ-015/H.05.v1 |
| (3) | 7 AI as Mirror, Not Moral Agent | AI(Q_t) = K_like,   K_like ≠ K_validated | definition | 38 | EQ-015/H.10.v1 |
| (4) | 7 AI as Mirror, Not Moral Agent | Assisted performance ≠ Unaided Human Return | identity |  | A.5/H.08.v1 |
| (5) | 7.1 Difference, resistance, and retained | D > 0,   Resist > 0,   A_H > 0 | definition |  | EQ-015/H.18.v1 |
| unlabeled (§6, Framing bullet) | 6 Digital Yonisomanasīkāra as a Working  | H_t —L_H→ Q_t,   Q_t ≠ H_t | definition | 27 | A.5/H.01.v1 |
| unlabeled (§6, Integration bullet) | 6 Digital Yonisomanasīkāra as a Working  | H_{n+1} = U_H( H_n, Retain(E_n, μ_n, ρ_n^H), δ^world, X^other ),  with the explicit non-guarantee: Retain(E_n) > 0 ⇒ H_{ | definition |  | EQ-015/E.08.v1 |
| P1 | 6.2 Minimal empirical predictions for th | Framing residual: under matched topic and matched AI model, dialogues that open with an explicit statement of moral or c | hypothesis/Open |  | EQ-015/H.35.v1 |
| P2 | 6.2 Minimal empirical predictions for th | Iteration without Integration is insufficient: recursive questioning (Iteration, Equation (2)) that is not followed by a | hypothesis/Open |  | EQ-015/H.35.v1 |

### After Labour: Human Position in an AI-Robotic World System (full world-system standalone,  — 10.5281/zenodo.22481924 (58 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 1. The Question After Labour | human labour -> production -> wage -> claim on output | definition |  | EQ-015/W.01.v1 |
| (2) | 2.1 Readout in this paper | Readout_(Q,O,c)(S) = z,  z != S | definition | 52 | EQ-002/M.03.v1 |
| (3) | 5. Technology Block: Candidate Generatio | Z_dot_t = v_t G_t - delta_Z Z_t,  0 <= v_t <= 1 | definition |  | EQ-015/W.02.v1 |
| (4) | 5. Technology Block: Candidate Generatio | K_like != K_validated | definition |  | EQ-015/H.10.v1 |
| (5) | 5. Technology Block: Candidate Generatio | B^RB_t = N^RB_t q^RB_t | definition |  | EQ-015/W.20.v1 |
| (6) | 5. Technology Block: Candidate Generatio | B_dot^RB_t / B^RB_t = N_dot^RB_t / N^RB_t + q_dot^RB_t / q^RB_t | identity |  | EQ-015/W.21.v1 |
| (7) | 5. Technology Block: Candidate Generatio | M_t = (K^M_t)^kappa (A^AI_t)^alpha (B^RB_t)^beta | definition |  | EQ-015/W.22.v1 |
| (8) | 6. Labour Centrality, Not Labour Disappe | L_t = < L^task_t, L^income_t, L^bottleneck_t, L^bargain_t > | definition | 53 | EQ-015/W.25.v1 |
| Labour-Decentering Proposition | 6. Labour Centrality, Not Labour Disappe | Labour-Decentering Proposition [Open]. AI and robotics can reduce labour centrality without eliminating labour. Stable e | hypothesis/Open |  | EQ-015/W.04.v1 |
| (9) | 6. Labour Centrality, Not Labour Disappe | rho = (sigma - 1) / sigma | definition |  | EQ-015/W.23.v1 |
| (10) | 6. Labour Centrality, Not Labour Disappe | s^L_t = (omega_H H_t^rho) / (omega_H H_t^rho + omega_M M_t^rho) | identity |  | EQ-015/W.24.v1 |
| (11) | 7. The Claim Constitution: From Wages to | q_t = o_t + tau_t(1 - o_t) = 1 - (1 - o_t)(1 - tau_t) | definition |  | EQ-015/W.26.v1 |
| (12) | 7. The Claim Constitution: From Wages to | Gamma_t = s^L_t + q_t(1 - s^L_t) | identity |  | EQ-015/W.27.v1 |
| (13) | 7. The Claim Constitution: From Wages to | q^min_t = (Gamma_bar - s^L_t) / (1 - s^L_t) | identity | 54 | EQ-015/W.28.v1 |
| (14) | 7. The Claim Constitution: From Wages to | D^rent_(i,t) = (Rent^(AI,out)_(i,t) - Rent^(AI,in)_(i,t)) / Y_(i,t) | definition |  | EQ-015/W.29.v1 |
| (15) | 7. The Claim Constitution: From Wages to | Gamma^net_(i,t) = Gamma_(i,t) - D^rent_(i,t) | identity |  | EQ-015/W.30.v1 |
| (16) | 8. Ownership Accumulation: The Stock Tha | W^M_(i,t+1) = (1 - delta_W) W^M_(i,t) + r^M_t W^M_(i,t) + s^(M,cap)_(i,t) + T^cap_(i,t) - Tax^cap_(i,t) | definition |  | EQ-015/W.34.v1 |
| (17) | 8. Ownership Accumulation: The Stock Tha | o_t = ( sum_(i in B) W^M_(i,t) ) / ( sum_i W^M_(i,t) ) | definition |  | EQ-015/W.35.v1 |
| (18) | 8. Ownership Accumulation: The Stock Tha | current redistribution != future ownership reproduction | definition |  | EQ-015/W.36.v1 |
| (19) | 9. Scarce Assets, Rent Burden, and Effec | B^scarce_(i,t) = (R^house_(i,t) + R^land_(i,t) + R^energy_(i,t) + DS_(i,t)) / Y_(i,t) | definition |  | A.5/W.04.v1 |
| (20) | 9. Scarce Assets, Rent Burden, and Effec | Gamma^eff_(i,t) = max{0, Gamma^net_(i,t) - B^scarce_(i,t)} | identity |  | A.5/W.05.v1 |
| (21) | 9. Scarce Assets, Rent Burden, and Effec | machine abundance != low rent burden != effective material freedom | definition |  | A.5/W.06.v1 |
| (22) | 10. Aggregate Demand and Realization: Wh | AD_t = C(Gamma^eff_t Y_t, m_t) + I_t + G_t + NX_t | definition |  | EQ-015/W.31.v1 |
| (23) | 10. Aggregate Demand and Realization: Wh | chi^dem_t = min{1, AD_t / Y_t} | definition |  | EQ-015/W.32.v1 |
| (24) | 10. Aggregate Demand and Realization: Wh | Pi^M_t = chi^dem_t Y_t - Cost^M_t | identity |  | EQ-015/W.33.v1 |
| (25) | 10. Aggregate Demand and Realization: Wh | Gamma^eff Y -> AD -> Pi^M -> W^M_(t+1) -> M_(t+1) | definition |  | EQ-015/W.06.v1 |
| (26) | 11. Ownership Is Not Transition Power: C | G^conv_(j,t)(e) = 1 - [ V_t(e \| -j) / V_t(e) ]_+ | definition |  | EQ-015/W.37.v1 |
| (27) | 11. Ownership Is Not Transition Power: C | X_(i,t)(e; j) = clip( V_(i,t)(e \| -j) / V_(i,t)(e), 0, 1 ) | definition |  | EQ-015/W.38.v1 |
| (28) | 11. Ownership Is Not Transition Power: C | D_(i->j,t)(g) = sum_(e in E(g)) w_e(g) G^conv_(j,t)(e) [1 - X_(i,t)(e; j)] | definition |  | EQ-015/W.39.v1 |
| (29) | 11. Ownership Is Not Transition Power: C | Concentration != G^conv != D | definition |  | EQ-015/W.40.v1 |
| (30) | 12. Relational Class Position in an AI-R | C_(i,t) = < O_(i,t), G_(i,t), Gamma_(i,t), A^access_(i,t), X_(i,t), D_(i,t), R^rent_(i,t) > | definition |  | EQ-015/W.09.v1 |
| (31) | 13. The Political-Economy-to-Human Bridg | c^(PE->H)_(i,t) = B^(PE->H)(Z_t; i, g) | definition |  | weld/W.01.v1 |
| (32) | 13.1 Live possibility, defined here | Pi^live_(i,t)(g) subseteq Pi^feas_(i,t)(g) subseteq Pi^phys_(i,t)(g) | definition | 55 | EQ-015/H.07.v1 |
| (33) | 13.1 Live possibility, defined here | Lambda_dot^live_(H,t) = lambda_1 B_t + lambda_2 X_t + lambda_3 P^plural_t + lambda_4 r^H_t - lambda_5 D_t - lambda_6 C^I | hypothesis/Open |  | A.5/H.06.v1 |
| (34) | 13.2 Corrigible human agency, defined he | A^corr_(H,i,t)(g) = max_(pi in Pi^live_(i,t)(g)) Pr^pi( R_g cap D_g cap X_g cap F_g ) | definition | 56 | EQ-015/W.14.v1 |
| (35) | 13.3 Human Return, defined here | R^return_(H,t) = < C_t, T_t, S^skill_t, A^alt_t > | definition | 57 | EQ-015/W.15.v1 |
| (36) | 14. Social Role After Labour | S_dot^H_t = s_1 W_t + s_2 N_t - delta_S S^H_t | definition |  | EQ-015/W.47.v1 |
| (37) | 14. Social Role After Labour | 1 = l_wage + l_care + l_learn + l_civic + l_leisure | identity |  | EQ-015/W.48.v1 |
| (38) | 15. Social Reproduction: Productive Nece | H_dot^cap_t = f(Care_t, Health_t, Education_t, Nutrition_t, Community_t) - delta_H H^cap_t | hypothesis/Open |  | EQ-015/W.49.v1 |
| (39) | 15. Social Reproduction: Productive Nece | productive necessity of humans != social necessity of human reproduction | definition |  | EQ-015/W.50.v1 |
| (40) | 16. The Human Systemic Position Equation | P^H_t = [ (Gamma^eff_t)^theta_Gamma (A^corr_(H,t))^theta_A (Lambda^live_(H,t))^theta_Lambda (r^H_t)^theta_R (S^H_t)^thet | definition | 58 | EQ-015/W.42.v1 |
| (41) | 16. The Human Systemic Position Equation | P_dot^H_t / P^H_t = theta_Gamma (Gamma_dot^eff_t/Gamma^eff_t) + theta_A (A_dot^corr_(H,t)/A^corr_(H,t)) + theta_R (r_dot | identity |  | EQ-015/W.43.v1 |
| (42) | 16. The Human Systemic Position Equation | ... + theta_S (S_dot^H_t/S^H_t) + theta_X (X_dot^H_t/X^H_t) - theta_D (D_dot^H_t/(1+D^H_t)) | identity |  | EQ-015/W.44.v1 |
| (43) | 16. The Human Systemic Position Equation | Y_dot_t > 0  =/=>  P_dot^H_t > 0 | definition | 59 | EQ-015/W.45.v1 |
| (44) | 17. Abundance Without Agency | AWA_t = < Y(up), Gamma^eff adequate, O^H(down), X^H(down), D^H(up), Lambda^live_H(down), A^corr_H(down), r_H(down), S_H( | definition |  | EQ-015/W.46.v1 |
| (45) | 18. Recursive Political Economy: Three P | P_t = < P^econ_t, P^info_t, P^coerc_t > | definition |  | A.5/W.07.v1 |
| (46) | 18. Recursive Political Economy: Three P | P^B_t proportional-to Gamma^eff_t A^corr_(H,t) Lambda^live_(H,t) X^H_t r^H_t | definition |  | A.5/W.08.v1 |
| (47) | 18. Recursive Political Economy: Three P | P^E_t = P_E( P_t, G_dot^conv, D^H_t, 1 - Gamma^eff_t ) | definition |  | A.5/W.09.v1 |
| (48) | 18. Recursive Political Economy: Three P | I_dot_t = F_I( P^B_t, P^E_t, state capacity, rules, shocks ) | hypothesis/Open |  | A.5/W.10.v1 |
| (49) | 18. Recursive Political Economy: Three P | economic gate control -> rents -> political influence -> future gate control;  information control -> attention/interpre | definition |  | A.5/W.02.v1 |
| (50) | 18. Recursive Political Economy: Three P | ownership != informational power != coercive power | definition |  | A.5/W.11.v1 |
| (51) | 21. What Humans May Actually Do | labour-based claim -> human/citizen claim on social production | definition |  | EQ-015/W.01.v1 |
| (52) | 23. What Can and Cannot Be Forecast Now | Omega_t = w_M(g_M - g_H) + w_D g_D + w_G g_G - w_q g_q - w_Gamma g_(Gamma^eff) - w_X g_X - w_R g_(r^H) - w_Lambda g_Lamb | measurement |  | EQ-015/W.13.v1 |
| (53) | 24. Claim Boundaries | concentration =/=> dependency =/=> agency loss | definition |  | EQ-015/W.41.v1 |
| (54) | 25. Conclusion: From Productive Necessit | candidate generation -> validated K/A^AI -> robotic embodiment -> M_t -> Y_t -> L_t -> s^L_t -> Gamma_t -> W^M_t -> o_(t | definition |  | weld/W.02.v1 |
| (55) | 25. Conclusion: From Productive Necessit | Gamma^eff Y -> AD -> Pi^M -> W^M_(t+1) -> {o_(t+1), M_(t+1)} | definition |  | EQ-015/W.06.v1 |
| (56) | 25. Conclusion: From Productive Necessit | {Care, Health, Education} -> H^cap -> {A^corr_H, r_H, S_H} -> P -> I_(t+1) | definition |  | EQ-015/W.12.v1 |
| (57) | 25. Conclusion: From Productive Necessit | growth of machine productive power  versus  growth of broad human claim, exit, agency, and Human Return | definition |  | EQ-015/W.10.v1 |

### The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibil — 10.5281/zenodo.22481926 (30 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 1. The Missing Dependent Variable | Machine expansion  =/=>  Human expansion | definition | 60 | EQ-015/W.51.v1 |
| (2) | 4. Non-Collapse Discipline | AI capability != validated knowledge | definition |  | A.5/W.12.v1 |
| (3) | 4. Non-Collapse Discipline | assisted performance != human learning | definition |  | A.5/W.13.v1 |
| (4) | 4. Non-Collapse Discipline | augmentation != synergy | definition |  | A.5/W.14.v1 |
| (5) | 4. Non-Collapse Discipline | formal options != live possibilities | definition |  | A.5/W.15.v1 |
| (6) | 4. Non-Collapse Discipline | access != credible exit | definition |  | A.5/W.16.v1 |
| (7) | 4. Non-Collapse Discipline | income transfer != future ownership | definition |  | A.5/W.17.v1 |
| (8) | 4. Non-Collapse Discipline | material security != agency | definition |  | A.5/W.18.v1 |
| (9) | 4. Non-Collapse Discipline | market concentration != domination | definition |  | A.5/W.19.v1 |
| (10) | 4. Non-Collapse Discipline | productive necessity != social necessity | definition |  | A.5/W.20.v1 |
| (11) | 5. Human Conversion as a Vector, Not a S | C^H_t = < Gamma^eff_t, X^H_t, Lambda^live_(H,t), A^corr_(H,t), R^route_(H,t), W^world_(H,t), r_(H,t), H^cap_t, S_(H,t) > | definition | 61 | EQ-015/W.52.v1 |
| (12) | 5. Human Conversion as a Vector, Not a S | eta^HC_(j,t) = d(ln C^H_(j,t)) / d(ln M_t) | definition | 62 | EQ-015/W.53.v1 |
| (13) | 5. Human Conversion as a Vector, Not a S | eta^HC_Gamma > 0,  eta^HC_(rH) < 0,  eta^HC_X < 0 | definition |  | EQ-015/W.54.v1 |
| Proposition 1 | 5. Human Conversion as a Vector, Not a S | Proposition 1 (Conversion non-identity) [Open]. An increase in M_t or current human-AI performance is insufficient to es | hypothesis/Open |  | EQ-015/W.16.v1 |
| (14) | 6. The Epistemic Conversion Mechanism | H problem -> AI divergence -> H resistance -> World test -> H integration -> AI removal -> H return | definition |  | EQ-015/W.17.v1 |
| (15) | 6. The Epistemic Conversion Mechanism | H problem -> AI answer -> use -> dependence | definition |  | EQ-015/W.17.v1 |
| Proposition 2 | 6. The Epistemic Conversion Mechanism | Proposition 2 (Assistance-conversion divergence) [Open]. The AI assistance intensity that maximizes current performance  | hypothesis/Open |  | EQ-015/W.17.v1 |
| (16) | 7. Bad Mode Is a State Space, Not a Stai | B_t = < D_t, G_dot^conv_t, C^info_t, 1 - X^H_t, 1 - r_(H,t), 1 - Lambda^live_(H,t), 1 - A^corr_(H,t), 1 - Gamma^eff_t, 1 | definition |  | EQ-015/W.18.v1 |
| (17) | 8. Reversibility, Hysteresis, and the In | W_j = { t : C^rec_(j,t) <= C_bar_j  AND  tau^rec_(j,t) <= tau_bar_j } | definition | 63 | EQ-015/W.55.v1 |
| Proposition 3 | 8. Reversibility, Hysteresis, and the In | Proposition 3 (Reversibility Principle) [Open]. The faster machine capability grows relative to human conversion, the mo | hypothesis/Open |  | EQ-015/W.19.v1 |
| (18) | 9. An Urgency Vector Instead of a Panic  | Delta g_(j,t) = [ g~_(M,t) - g~_(Cj,t) ]_+ | definition |  | EQ-015/W.56.v1 |
| (19) | 9. An Urgency Vector Instead of a Panic  | U_(j,t) = Delta g_(j,t) * L_(j,t) * S_(j,t) * tau^rec_(j,t) | definition | 64 | EQ-015/W.57.v1 |
| (20) | 9. An Urgency Vector Instead of a Panic  | U_t = < U_(1,t), ..., U_(J,t) > | definition |  | EQ-015/W.58.v1 |
| (21) | 9. An Urgency Vector Instead of a Panic  | U^max_t = max_j U_(j,t) | definition |  | EQ-015/W.59.v1 |
| (22) | 10. Distribution: Whose Potential Expand | C^10_(j,t), C^50_(j,t), C^90_(j,t) | definition |  | EQ-002/W.02.v1 |
| (23) | 10. Distribution: Whose Potential Expand | I^H_(j,t) = C^90_(j,t) - C^10_(j,t) | definition |  | EQ-002/W.03.v1 |
| Proposition 4 | 10. Distribution: Whose Potential Expand | Proposition 4 (Distributional conversion) [Open]. Broad human expansion requires that conversion gains reach a declared  | hypothesis/Open |  | EQ-002/W.01.v1 |
| (24) | 15. Discussion: From Maximum Assistance  | Maximum AI assistance -> Maximum durable human conversion | definition |  | EQ-015/W.17.v1 |
| (25) | 16. Conclusion | rate of machine capability growth  versus  rate of human conversion and institutional adaptation | definition |  | EQ-015/W.16.v1 |
| (26) | 16. Conclusion | Machine Capability -> Human Conversion Vector -> Human Return/Agency/Exit -> Reversibility or Lock-in -> Next Institutio | definition |  | EQ-015/W.16.v1 |

### How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol  — 10.5281/zenodo.22481928 (59 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 3. The Unit of Analysis | H_{s,0} --L_H--> Q_{s,0}. | definition |  | A.5/H.01.v1 |
| (2) | 3. The Unit of Analysis | Q_{s,t} → AI_{s,t} → Y_{s,t} --R^AI_H--> E_{H,s,t}. | definition |  | EQ-015/H.04.v1 |
| (3) | 3. The Unit of Analysis | H_{s+1,0} = U_H(H_{s,0}, E^AI_{H,s,*}, δ^world, X^other). | definition |  | EQ-015/E.08.v1 |
| (4) | 4. Topic Entry Condition | P^live_{H,t} = a presently consequential unresolved difference in the person's life, work, understanding, relationship t | definition |  | A.5/H.02.v1 |
| (5) | 4. Topic Entry Condition | TopicEntry ∈ {LiveProblem, OpenExploration, RoutineDelegation}. | definition |  | A.5/H.02.v1 |
| (6) | 4. Topic Entry Condition | Problem-First ⇒ (Human Agenda Ownership, Bounded Relevance, World-Side Testability, Observable Human Return). | proposition |  | A.5/H.02.v1 |
| (7) | 4. Topic Entry Condition | Problem-First ≠ Problem-Only. | law |  | A.5/H.02.v1 |
| PFDP | 5. Deployment Layer | Problem-First Dialogue Principle [Open]: when AI is used for human development rather than entertainment or routine exec | hypothesis/Open |  | A.5/H.02.v1 |
| (8) | 5. Deployment Layer | π^deploy = f(Stakes, LearningNeed, Irreversibility, DependencyRisk, UserSkill). | definition |  | EQ-015/H.21.v1 |
| (9) | 5. Deployment Layer - DCP-Lite | State → Challenge → Check → Own. | definition |  | EQ-015/H.21.v1 |
| AFP | 5. Deployment Layer | Adaptive-friction proposition [Open]: the best real-world protocol will often be the least burdensome policy that preser | hypothesis/Open |  | EQ-015/H.21.v1 |
| (10) | 5. Deployment Layer - DCP-Critical | Topic Entry → Triage → Minimum Sufficient Dialogue → Escalate if Stakes Rise → Periodic Return. | definition |  | EQ-015/H.21.v1 |
| (11) | 6. The Dialogue Conversion Protocol | Anchor → Expand → Oppose → Discriminate → Verify → Integrate → Remove → Return. | definition |  | A.5/H.11.v1 |
| (12) | 6.1 Anchor | A0 = ⟨P0, M0, U0, E0, F0, S0⟩, where P0 = problem as understood, M0 = current model/tentative answer, U0 = important unk | definition |  | EQ-015/H.02.v1 |
| (13) | 6.1 Anchor - elicitation for novices | AI_clarify → {Known, Unknown, Goal, Stakes} → Human Anchor. | definition |  | EQ-015/H.02.v1 |
| (14) | 6.2 Expand | Q_t --AI--> {Q_{i,t+1}, K_{i,t}}_{i=1}^n. | definition |  | A.5/H.11.v1 |
| (15) | 6.3 Oppose or boundary-test | Rival Generation: for genuinely open spaces. | definition |  | A.5/H.11.v1 |
| (16) | 6.3 Oppose or boundary-test | Boundary Test: for strongly asymmetric evidence. | definition |  | A.5/H.11.v1 |
| (17) | 6.3 Oppose or boundary-test | Oppose a claim ≠ manufacture an opposite claim. | law |  | A.5/H.11.v1 |
| (18) | 6.4 Discriminate | N_distinct = \|{C1, ..., Cn} / ∼_Q\|. | measurement |  | weld/H.08.v1 |
| (19) | 6.5 Verify | L(c) = {Decision, Risk, Money, Health, Legal, Publication, IrreversibleAction}. | definition |  | A.5/H.12.v1 |
| (20) | 6.5 Verify | V = {primary source, data, experiment, calculation, expert, independent method, world outcome}. | definition |  | A.5/H.12.v1 |
| (21) | 6.5 Verify | Source ≠ AI synthesis ≠ Human inference ≠ Unverified candidate. | law |  | A.5/H.12.v1 |
| (22) | 6.6 Integrate | I_s = ⟨ΔM_s, E^decisive_s, U^remain_s, Next_s⟩. | definition |  | A.8/H.01.v1 |
| (23) | 6.7 Remove | Reset: fresh framing/session/source route. | definition |  | EQ-015/H.22.v1 |
| (24) | 6.7 Remove | Removal: absence of decisive AI assistance. | definition |  | EQ-015/H.22.v1 |
| (25) | 6.8 Return | R^return_H = ⟨C, T, S, A⟩, where C = Conceptual reconstruction, T = Tool selection, S = Skill execution, A = Alternative | definition |  | EQ-015/H.17.v1 |
| (26) | 6.8 Return | ΔH_s = ⟨ΔC_s, ΔT_s, ΔS_s, ΔA_s, ΔA^corr_{H,s}, ΔΛ^live_{H,s}⟩. | definition |  | EQ-015/H.23.v1 |
| (27) | 6.8 Return | ΔPerformance_AI > 0 ⇏ ΔH_s > 0. | law |  | A.5/H.08.v1 |
| (28) | 6.8 Return | F^return = f(Criticality, LearningNeed, FailureCost, DependencyRisk). | definition |  | EQ-015/H.23.v1 |
| (29) | 7. Action and World Feedback | I_s → a_s → δ^world_{s+1} → H_{s+1,0}. | definition |  | EQ-015/H.24.v1 |
| (30) | 7. Action and World Feedback | Live Problem → Question → Dialogue → Human Return → Action → World Feedback → Revision or New Problem. | definition |  | EQ-015/H.24.v1 |
| WCP | 7. Action and World Feedback | World-closure proposition [Open]: for live problems with observable consequences, dialogue policies that include post-co | hypothesis/Open |  | EQ-015/H.24.v1 |
| (31)-(32) | 8. Expansion and Contraction Must Altern | Expansion := maximize candidate diversity and discriminability. | definition |  | A.8/H.02.v1 |
| (33)-(34) | 8. Expansion and Contraction Must Altern | Contraction := prune by evidence, provenance, stakes, and action relevance. | definition |  | A.8/H.02.v1 |
| (35) | 10. Dialogue Policy Must Depend on the G | π^dialogue = f(TopicMode, Goal, Skill, Stakes, Domain, LearningNeed, Reversibility). | definition |  | EQ-015/H.21.v1 |
| (36) | 10.1 Personal and relational dialogue | Experience → Interpretations → Absent Perspective → Observable Evidence → Direct Human Conversation. | definition |  | weld/S.07.v1 |
| (37) | 11. Protocol Burden and Behavioral Adopt | B^use = ⟨Time, CognitiveLoad, VerificationCost, Interruption, LiteracyDemand⟩. | definition |  | EQ-015/M.10.v1 |
| (38) | 11. Protocol Burden and Behavioral Adopt | Epistemically optimal ≢ Behaviorally adoptable. | law |  | EQ-015/M.10.v1 |
| (39) | 12. Provenance Ledger | Status ∈ {Source, AI-Synthesis, Human-Inference, Candidate, Decision}. | definition |  | A.8/M.03.v1 |
| (40)-(41) | 14. Formal Success Condition | π* ∈ argmax_π E[ΔH_s \| π, task, user], subject to minimum task-performance/safety constraints and B_use(π) ≤ B̄(task, us | definition |  | A.8/H.04.v1 |
| (42) | 14. Formal Success Condition | π^perf ∈ argmax_π E[P^assist_s \| π]. | definition |  | A.8/H.04.v1 |
| DCPp | 14. Formal Success Condition | Dialogue Conversion Proposition [Open]: for tasks in which learning, judgment transfer, or future unaided competence mat | hypothesis/Open |  | EQ-015/H.25.v1 |
| DEPp | 14. Formal Success Condition | Deployment Proposition [Open]: the full protocol will not maximize real-world adoption across all tasks; adaptive triage | hypothesis/Open |  | EQ-015/H.25.v1 |
| AgP | 14. Formal Success Condition | Agenda Proposition [Open]: when the objective is human development, self-selected live-problem entry will often produce  | hypothesis/Open |  | EQ-015/H.25.v1 |
| H1 | 15.2 Primary hypotheses | Direct-answer AI will often maximize immediate performance but not delayed Human Return in learning-intensive tasks. | hypothesis/Open |  | EQ-015/H.26.v1 |
| H2 | 15.2 Primary hypotheses | DCP and cognitive-forcing conditions will reduce overreliance but may increase cognitive load. | hypothesis/Open |  | EQ-015/H.26.v1 |
| H3 | 15.2 Primary hypotheses | DCP will produce more non-equivalent unaided alternatives at follow-up than direct-answer AI. | hypothesis/Open |  | EQ-015/H.26.v1 |
| H4 | 15.2 Primary hypotheses | Provenance accuracy and error detection after AI removal will mediate the relationship between protocol and Human Return | hypothesis/Open |  | EQ-015/H.26.v1 |
| H5 | 15.2 Primary hypotheses | Effects will be heterogeneous by prior skill: novices may require more scaffolded opposition/verification than experts. | hypothesis/Open |  | EQ-015/H.26.v1 |
| H6 | 15.2 Primary hypotheses | In creation tasks, aggressive expansion may improve coupled output without harming Return, whereas high-stakes decision  | hypothesis/Open |  | EQ-015/H.26.v1 |
| H7 | 15.2 Primary hypotheses | DCP-Lite will achieve higher adoption and lower burden than DCP-Standard in low-stakes tasks with little loss of safety  | hypothesis/Open |  | EQ-015/H.26.v1 |
| H8 | 15.2 Primary hypotheses | In relational interpretation tasks, facts-versus-interpretation separation and absent-perspective prompts will reduce un | hypothesis/Open |  | EQ-015/H.26.v1 |
| H9 | 15.2 Primary hypotheses | For capability-sensitive tasks, self-selected live-problem entry will increase perceived relevance, follow-through, and  | hypothesis/Open |  | EQ-015/H.26.v1 |
| H10 | 15.2 Primary hypotheses | For action-relevant live problems, Action → World Feedback closure will improve calibration and transfer relative to oth | hypothesis/Open |  | EQ-015/H.26.v1 |
| (43) | 18. Conclusion | Problem-First ≠ Problem-Only. | law |  | A.5/H.02.v1 |
| (44) | 18. Conclusion | Topic Entry → Triage → Minimum Sufficient Dialogue → Human Return → Action/World Feedback → Revision or New Problem. | definition |  | EQ-015/H.24.v1 |
| (45) | 18. Conclusion | Anchor → Expand → Oppose/Boundary-Test → Discriminate → Verify → Integrate → Remove → Return. | definition |  | A.5/H.11.v1 |
| (46) | 18. Conclusion | What unresolved difference deserves my attention? / How much AI/friction does this task require? / What remains with me  | proposition |  | EQ-015/H.27.v1 |

### From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Uneq — 10.5281/zenodo.22498047 (38 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2. Readout Genesis Is the Rail, Not a Me | S_n = (G_n, Lambda_n, T_n) | definition |  | EQ-015/M.01.v1 |
| (2) | 2. Readout Genesis Is the Rail, Not a Me | S_(n+1) = F(S_n, u_n, c_n, T_n) | definition |  | EQ-015/M.02.v1 |
| (3) | 2. Readout Genesis Is the Rail, Not a Me | q#_(HCA,n+1) o F_n = F_(HCA,n) o q_(HCA,n) | definition |  | weld/M.02.v1 |
| (4) | 2. Readout Genesis Is the Rail, Not a Me | S_n != Z_(HCA,n) != D_(HCA,n) | definition |  | A.5/M.01.v1 |
| (5) | 3. Internal Programme Lineage: The Nativ | Retained Difference -> Human Readout -> Live Problem -> Barrier Readout -> Candidate Routes -> Human Endorsement -> Adap | definition | 67 | EQ-002/H.03.v1 |
| (6) | 5. Candidate HCA Domain State and Defect | Z_(HCA,i,n) = < P^live_(i,n), K^life_(i,n), B^bar_(i,n), C^cand_(i,n), C^live_(i,n), h_(i,n), R^return_(H,i,n), Omega^re | definition |  | EQ-015/H.30.v1 |
| (7) | 5. Candidate HCA Domain State and Defect | epsilon_HCA = Def( q~_HCA o F, F_HCA o q~_HCA, O_HCA, Inv_HCA ) | definition |  | weld/H.06.v1 |
| (8) | 6. Unequal Life Conditions: Capability C | K^life_(i,n) = < E^econ, F^base, L^lang, D^digital, T^disc, H^health, M^mob, N^mentor, C^cred >_(i,n) | definition | 68 | EQ-015/H.31.v1 |
| (9) | 6. Unequal Life Conditions: Capability C | Resources != Access,  Access != Capability,  Capability != Realized Opportunity | definition |  | A.5/H.15.v1 |
| (10) | 6. Unequal Life Conditions: Capability C | Access(z) != Control(z) | definition |  | A.5/H.15.v1 |
| (11) | 6. Unequal Life Conditions: Capability C | Equal AI Access =/=> Equal Capability Conversion | definition |  | A.5/H.15.v1 |
| (12) | 7. Live Problem Entry and Barrier Readou | B^bar_(i,n) subseteq {Knowledge, Skill, Language, Tool, ResourceTime, Network, Credential, Permission, Opportunity, Unkn | definition | 69 | A.5/H.16.v1 |
| (13) | 7. Live Problem Entry and Barrier Readou | Observed Difficulty != Skill Deficit | definition | 70 | A.5/H.16.v1 |
| (14) | 7. Live Problem Entry and Barrier Readou | u*^diag_(i,n) = argmax_(u in U^diag) [ IG_B(u) - lambda_C Cost(u) - rho Risk(u) ] | hypothesis/Open |  | A.8/H.04.v1 |
| (15) | 8. Candidate Advancement Routes: Capabil | C^cand_(i,n) = Gen( P^live_(i,n), B^bar_(i,n), K^life_(i,n), R^return_(H,i,n) ) | definition |  | A.5/H.17.v1 |
| (16) | 8. Candidate Advancement Routes: Capabil | C^live_(i,n) = { c in C^cand_(i,n) : Endorse_i(c) = 1 } | definition | 71 | A.5/H.17.v1 |
| (17) | 8. Candidate Advancement Routes: Capabil | Proactive Suggestion != Human Goal Ownership | definition | 72 | A.5/H.17.v1 |
| (18) | 8. Candidate Advancement Routes: Capabil | Capability Advancement != AI Goal Authority | definition | 72 | A.5/H.17.v1 |
| (19) | 8. Candidate Advancement Routes: Capabil | Scaffolding != Control | definition | 72 | A.5/H.17.v1 |
| (20) | 9. The Proactive Human Capability Advanc | u*^adv_(i,n) = argmin_(u in U^adv) E[ (Res^cap_i + u)^2 + lambda_B B^use(u) + rho R_u + mu D_u + xi A_u + psi O_u - nu V | hypothesis/Open |  | A.8/H.04.v1 |
| (21) | 9. The Proactive Human Capability Advanc | subject to: AgendaOwnership = 1, Endorsement = 1, Transparency = 1, Safety/Governance = 1 | hypothesis/Open |  | A.8/H.04.v1 |
| Human Capability Advancement Principle | 9. The Proactive Human Capability Advanc | Human Capability Advancement Principle [Open]. When durable human development is an endorsed goal, AI may proactively id | hypothesis/Open |  | EQ-002/H.03.v1 |
| (22) | 10. Adaptive Scaffolding: Use What the L | Stable Unaided Return (up) => h^decisive (down) | hypothesis/Open | 73 | EQ-015/H.32.v1 |
| (23) | 10. Adaptive Scaffolding: Use What the L | Attempt -> Minimal Sufficient Scaffold -> Feedback -> Reattempt -> Fading -> Unaided Execution -> Novel Transfer | definition |  | EQ-015/H.32.v1 |
| (24) | 11. Human Return: The AI Should Know Whe | R^return_H = < C, T, S, A > | definition |  | EQ-015/H.17.v1 |
| (25) | 11. Human Return: The AI Should Know Whe | Delta Performance_AI > 0  =/=>  Delta R^return_H > 0 | definition |  | A.5/H.08.v1 |
| (26) | 11. Human Return: The AI Should Know Whe | R^return_H (up) => h^decisive (down) | hypothesis/Open |  | EQ-015/H.32.v1 |
| (27) | 12. World Return: Capability That Never  | R^return_(H,i,n) -> a_(i,n) -> delta^world_(i,n+1) -> Z_(HCA,i,n+1) | definition | 74 | EQ-015/H.24.v1 |
| (28) | 13. Opportunity Conversion: The Market M | Omega^real_(i,n) = G_O( R^return_(H,i,n), K^life_(i,n), Cred_(i,n), Net_(i,n), Perm_(i,n), MarketReadout_n ) | definition | 75 | A.5/H.18.v1 |
| (29) | 13. Opportunity Conversion: The Market M | Credential != Capability | definition | 76 | A.5/H.18.v1 |
| (30) | 13. Opportunity Conversion: The Market M | Market Legibility != Human Worth | definition | 76 | A.5/H.18.v1 |
| (31) | 13. Opportunity Conversion: The Market M | Skill -> Evidence of Skill -> Recognition -> Opportunity | definition |  | A.5/H.18.v1 |
| (32) | 14. Worked Scenario: Three Children, Une | Outcome_C - Outcome_A  !=  Effect_HCA | definition |  | A.5/H.19.v1 |
| (33) | 14. Worked Scenario: Three Children, Une | Schooling + Human-Owned Inquiry + Supervised Adaptive AI + Projects + Human Return + Opportunity Bridges | proposition |  | A.5/H.19.v1 |
| (34) | 15. Child and Adult Governance: Proactiv | Purpose + Transparency + Refusal + Revision + Data Minimization | definition |  | EQ-015/H.33.v1 |
| (35) | 15. Child and Adult Governance: Proactiv | Child Assent + Adult Oversight + Privacy + Safety + No Opaque Persuasion (+ Age-Appropriate Design) | definition |  | EQ-015/H.33.v1 |
| (36) | 16. Measurement Architecture: What Would | A^HCA_i = < Gain_CTSA, Loss, Transfer, Ownership, Burden, BarrierChange, OpportunityChange, Provenance, Warrant > | definition | 77 | A.8/H.03.v1 |
| (37) | 17.6 Identification discipline | ATE_HCA(x) = E[ Y(1) - Y(0) \| K^life = x ] | definition | 78 | A.8/H.03.v1 |
