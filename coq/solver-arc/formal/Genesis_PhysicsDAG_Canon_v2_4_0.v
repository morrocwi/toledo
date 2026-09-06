Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lia.
Require Import Coq.Lists.List.
Import ListNotations.
Open Scope R_scope.

Module Quantum_Relativity_Formal_DAG_Deep.

Parameter C : Type.
Parameter Ket Op Channel Point Tensor GaugeGroup FieldExpr Action Variation Source Config TensorField ConnT : Type.
Parameter C0 C1 : C.
Parameter Cadd Cmul : C -> C -> C.
Parameter ket_zero ket_00 ket_11 bell_phi_plus : Ket.
Parameter ket_add ket_tensor : Ket -> Ket -> Ket.
Parameter ket_scale : R -> Ket -> Ket.
Parameter mul_i_ket : Ket -> Ket.
Parameter inner : Ket -> Ket -> R.
Parameter normalized separable entangled : Ket -> Prop.
Parameter op_id op_i op_zero Xop Pop H_osc a_create a_annihilate number_op Jx Jy Jz Sx Sy Sz sigma_x sigma_y sigma_z S_matrix CKM PMNS : Op.
Parameter op_add op_mul op_comm op_anticomm : Op -> Op -> Op.
Parameter op_adj : Op -> Op.
Parameter op_scale : R -> Op -> Op.
Parameter apply : Op -> Ket -> Ket.
Parameter trace : Op -> R.
Parameter positive self_adjoint observable projector unitary density : Op -> Prop.
Parameter spectral_sum : Op -> Op.
Parameter finite_op_sum : (nat -> Op) -> nat -> Op.
Parameter Proj POVM Kraus annihilate a_in a_out : nat -> Op.
Parameter partial_trace_env : Op -> Op.
Parameter born_prob expectation : Ket -> Op -> R.
Parameter pure_density : Ket -> Op.
Parameter mixed_density : nat -> Op.
Parameter prob_i : nat -> R.
Parameter state_i : nat -> Ket.
Parameter rho Ham : R -> Op.
Parameter psi : R -> Ket.
Parameter d_ket : (R -> Ket) -> R -> Ket.
Parameter d_op partial_t_op : (R -> Op) -> R -> Op.
Parameter lindblad_sum : Op -> Op.
Parameter offdiag_norm : Op -> R.
Parameter trace_preserving completely_positive : Channel -> Prop.
Parameter chan : Channel -> Op -> Op.
Parameter choi : Channel -> Op.
Parameter hbar hbar_omega mass m0 c G Lambda kB PI mu0 epsilon0 xi mu_H lambda_H v_H M_bh Q_bh aK ell_AdS kappa T_H S_BH A_horizon dM_bh dA_bh Omega_H dJ_bh Phi_H dQ_bh rs r_photon r_isco r_kerr_plus H_infl epsilon_star Mpl chsh_expect Erel pnorm2 mnu : R.
Parameter field_op pi_op : Point -> Op.
Parameter gamma : nat -> Op.
Parameter delta_op : Point -> Point -> Op.
Parameter phase : R -> C.
Parameter functional_integral : (Config -> C) -> C.
Parameter S_value : Action -> Config -> R.
Parameter S_source : Config -> Source -> R.
Parameter Z curved_Z : Action -> C.
Parameter ZJ : Source -> C.
Parameter propagator : Point -> Point -> R.
Parameter vacuum_expect : R -> R.
Parameter time_order : Op -> Op -> R.
Parameter time_order_exp : Action -> Op.
Parameter interaction_action matter_action S_EH : Action.
Parameter scattering_amp amputated_correlator : Ket -> Ket -> R.
Parameter running_coupling beta : R -> R.
Parameter callan_symanzik : nat -> R -> R.
Parameter L_KG L_Dirac L_Maxwell L_YM L_QED L_QCD L_EW L_Higgs L_Yukawa L_SM L_gf L_ghost : Point -> R.
Parameter contract_grad field_sq phi_scalar mass_term dirac_lagrangian_density dirac_operator curved_dirac : Point -> R.
Parameter box : (Point -> R) -> Point -> R.
Parameter phi_field h_TT : Point -> R.
Parameter eta eta_ab : nat -> nat -> R.
Parameter current J : nat -> Point -> R.
Parameter D_mu partial_mu : nat -> Point -> R.
Parameter gauge_coupling : R.
Parameter A_mu : nat -> Point -> R.
Parameter d : nat -> (Point -> R) -> Point -> R.
Parameter F : nat -> nat -> Point -> R.
Parameter lie_term : nat -> nat -> Point -> R.
Parameter F_contract J_contract_A YM_F_contract quark_kinetic quark_mass ew_gauge ew_fermion interaction_QED yukawa_density ghost_lagrangian gauge_condition ward_identity cyclic_dF : Point -> R.
Parameter covD_F YM_J dF_source : nat -> Point -> R.
Parameter brst : FieldExpr -> FieldExpr.
Parameter field_expr_zero : FieldExpr.
Parameter V_Higgs : R -> R.
Parameter anomaly_su3 : R -> R -> R -> R.
Parameter anomaly_su2 : R -> R -> R.
Parameter anomaly_u1 anomaly_grav : R -> R -> R -> R -> R -> R.
Parameter Riemann : nat -> nat -> nat -> nat -> Point -> R.
Parameter Ricci Einstein Tstress T_expect : nat -> nat -> Point -> R.
Parameter g gInv : nat -> nat -> Point -> R.
Parameter dx : nat -> Point -> R.
Parameter ds2 ds2_lorentz dtau2 : Point -> R.
Parameter sum4 : (nat -> R) -> R.
Parameter gammaL : R -> R.
Parameter tprime xprime : R -> R -> R -> R.
Parameter U4 P4 : nat -> R -> R.
Parameter xcoord : nat -> R -> R.
Parameter d_R dd_R : (R -> R) -> R -> R.
Parameter tetrad : nat -> nat -> Point -> R.
Parameter spin_conn spin_conn_formula : nat -> nat -> nat -> Point -> R.
Parameter Conn : ConnT.
Parameter torsion_free metric_compatible : ConnT -> Prop.
Parameter Gamma : nat -> nat -> nat -> Point -> R.
Parameter covD tensor_covariant_derivative : nat -> TensorField -> TensorField.
Parameter worldline : R -> Point.
Parameter ddx dxds D2xi xi_vec : nat -> R -> R.
Parameter ScalarR neg_det_g : Point -> R.
Parameter covD_scalar : nat -> (Point -> R) -> Point -> R.
Parameter metric_variation : Action -> nat -> nat -> Point -> R.
Parameter stationary : Action -> Prop.
Parameter variation : Action -> Variation -> R.
Parameter action_integral : (Point -> R) -> Action.
Parameter PhiN : Point -> R.
Parameter lapse spatial_line adm_ds2 : Point -> R.
Parameter Kext h_dot : nat -> nat -> Point -> R.
Parameter shift : nat -> Point -> R.
Parameter D_spatial : nat -> (Point -> R) -> Point -> R.
Parameter R3 Ktrace KijKij rho_ADM : Point -> R.
Parameter D_spatial_j_constraint j_ADM : nat -> Point -> R.
Parameter theta_exp shear2 vorticity2 RicciUU : R -> R.
Parameter rad th time f_schw SigmaK DeltaK f_RN f_dS f_AdS ds2_FLRW spatial_curved_line : Point -> R.
Parameter g_schw : nat -> nat -> Point -> R.
Parameter scale_a Hubble rho_m pressure_m delta : R -> R.
Parameter epsilon_SR : R -> R.
Parameter k_curv : R.
Parameter accel_a : R -> R.
Parameter Power ensemble_average_delta2 P_R : R -> R.
Parameter alphaBog betaBog beta_abs2 N_created : nat -> R.
Parameter T_Unruh hawking_spectrum : R -> R.
Parameter renormalized_expectation_T : nat -> nat -> Point -> R.
Parameter Open_QuantumGravity : Prop.
Parameter exp cos sqrt Rabs : R -> R.

Inductive Sector : Type := Base | Quantum | QFT | Relativity | GR | Exact | Cosmology | BlackHole | Bridge.
Inductive ProofStage : Type := DeclaredFormula | CoqBackedTier0 | BoundaryMeasured | OpenFormula.

Inductive QRNode : Type :=
| N_Base_Logic
| N_Base_RealField
| N_Base_ComplexField
| N_Base_HilbertSpace
| N_Base_OperatorAlgebra
| N_Base_Adjoint
| N_Base_Trace
| N_Base_PositiveOperator
| N_Base_TensorProduct
| N_Base_LieGroup
| N_Base_Manifold
| N_Base_TensorCalculus
| N_Base_Variation
| N_Q_State
| N_Q_Normalization
| N_Q_Observable
| N_Q_Spectral
| N_Q_Born
| N_Q_Projector
| N_Q_POVM
| N_Q_Schrodinger
| N_Q_Heisenberg
| N_Q_CommutatorXP
| N_Q_Uncertainty
| N_Q_Density
| N_Q_VonNeumann
| N_Q_Lindblad
| N_Q_Kraus
| N_Q_TP
| N_Q_CP
| N_Q_Choi
| N_Q_Stinespring
| N_Q_Entanglement
| N_Q_CHSH
| N_Q_Decoherence
| N_QFT_CanonicalQuantization
| N_QFT_Fock
| N_QFT_PathIntegral
| N_QFT_Generating
| N_QFT_Propagator
| N_QFT_SMatrix
| N_QFT_LSZ
| N_QFT_RG
| N_QFT_CallanSymanzik
| N_QFT_KG_L
| N_QFT_KG_Eq
| N_QFT_GammaAlgebra
| N_QFT_Dirac_L
| N_QFT_Dirac_Eq
| N_QFT_Noether
| N_QFT_CovD
| N_QFT_FieldStrength
| N_QFT_Maxwell_L
| N_QFT_Maxwell_Bianchi
| N_QFT_Maxwell_Source
| N_QFT_YM_L
| N_QFT_YM_Eq
| N_QFT_GaugeFix
| N_QFT_Ghost
| N_QFT_BRST
| N_QFT_Ward
| N_QFT_QED
| N_QFT_QCD
| N_QFT_EW
| N_QFT_Higgs
| N_QFT_SSB
| N_QFT_Yukawa
| N_QFT_SM
| N_QFT_CKM_PMNS
| N_QFT_NeutrinoMass
| N_QFT_Anomaly1
| N_QFT_Anomaly2
| N_QFT_Anomaly3
| N_QFT_Anomaly4
| N_R_Manifold
| N_R_Minkowski
| N_R_Metric
| N_R_LineElement
| N_R_LorentzGamma
| N_R_LorentzTransform
| N_R_Invariance
| N_R_ProperTime
| N_R_FourVelocity
| N_R_FourMomentum
| N_R_EnergyMomentum
| N_GR_Tetrad
| N_GR_SpinConnection
| N_GR_LeviCivita
| N_GR_Christoffel
| N_GR_CovDerivative
| N_GR_Geodesic
| N_GR_GeodesicDeviation
| N_GR_Riemann
| N_GR_RiemannSym
| N_GR_Ricci
| N_GR_ScalarR
| N_GR_EinsteinTensor
| N_GR_Bianchi
| N_GR_StressEnergy
| N_GR_StressConserve
| N_GR_EHAction
| N_GR_EFE
| N_GR_Newtonian
| N_GR_ADM
| N_GR_ExtrinsicK
| N_GR_HamiltonianConstraint
| N_GR_MomentumConstraint
| N_GR_Raychaudhuri
| N_EX_Schwarzschild
| N_EX_SchwarzschildHorizon
| N_EX_PhotonSphere
| N_EX_ISCO
| N_EX_Kerr
| N_EX_KerrHorizon
| N_EX_RN
| N_EX_DeSitter
| N_EX_AdS
| N_EX_FLRW
| N_COS_Friedmann1
| N_COS_Friedmann2
| N_COS_Continuity
| N_COS_Acceleration
| N_COS_Perturbation
| N_COS_Power
| N_COS_SlowRoll
| N_COS_Primordial
| N_COS_GW
| N_BH_SurfaceGravity
| N_BH_HawkingT
| N_BH_Entropy
| N_BH_FirstLaw
| N_BR_RelQM
| N_BR_DiracCurved
| N_BR_QFTCurved
| N_BR_Texpect
| N_BR_SemiclassicalEFE
| N_BR_Bogoliubov
| N_BR_ParticleCreation
| N_BR_Hawking
| N_BR_Unruh
| N_BR_OpenQG
| N_BR_BoundaryConstants
.

Definition node_sector (n : QRNode) : Sector :=
  match n with
  | N_Base_Logic => Base
  | N_Base_RealField => Base
  | N_Base_ComplexField => Base
  | N_Base_HilbertSpace => Base
  | N_Base_OperatorAlgebra => Base
  | N_Base_Adjoint => Base
  | N_Base_Trace => Base
  | N_Base_PositiveOperator => Base
  | N_Base_TensorProduct => Base
  | N_Base_LieGroup => Base
  | N_Base_Manifold => Base
  | N_Base_TensorCalculus => Base
  | N_Base_Variation => Base
  | N_Q_State => Quantum
  | N_Q_Normalization => Quantum
  | N_Q_Observable => Quantum
  | N_Q_Spectral => Quantum
  | N_Q_Born => Quantum
  | N_Q_Projector => Quantum
  | N_Q_POVM => Quantum
  | N_Q_Schrodinger => Quantum
  | N_Q_Heisenberg => Quantum
  | N_Q_CommutatorXP => Quantum
  | N_Q_Uncertainty => Quantum
  | N_Q_Density => Quantum
  | N_Q_VonNeumann => Quantum
  | N_Q_Lindblad => Quantum
  | N_Q_Kraus => Quantum
  | N_Q_TP => Quantum
  | N_Q_CP => Quantum
  | N_Q_Choi => Quantum
  | N_Q_Stinespring => Quantum
  | N_Q_Entanglement => Quantum
  | N_Q_CHSH => Quantum
  | N_Q_Decoherence => Quantum
  | N_QFT_CanonicalQuantization => QFT
  | N_QFT_Fock => QFT
  | N_QFT_PathIntegral => QFT
  | N_QFT_Generating => QFT
  | N_QFT_Propagator => QFT
  | N_QFT_SMatrix => QFT
  | N_QFT_LSZ => QFT
  | N_QFT_RG => QFT
  | N_QFT_CallanSymanzik => QFT
  | N_QFT_KG_L => QFT
  | N_QFT_KG_Eq => QFT
  | N_QFT_GammaAlgebra => QFT
  | N_QFT_Dirac_L => QFT
  | N_QFT_Dirac_Eq => QFT
  | N_QFT_Noether => QFT
  | N_QFT_CovD => QFT
  | N_QFT_FieldStrength => QFT
  | N_QFT_Maxwell_L => QFT
  | N_QFT_Maxwell_Bianchi => QFT
  | N_QFT_Maxwell_Source => QFT
  | N_QFT_YM_L => QFT
  | N_QFT_YM_Eq => QFT
  | N_QFT_GaugeFix => QFT
  | N_QFT_Ghost => QFT
  | N_QFT_BRST => QFT
  | N_QFT_Ward => QFT
  | N_QFT_QED => QFT
  | N_QFT_QCD => QFT
  | N_QFT_EW => QFT
  | N_QFT_Higgs => QFT
  | N_QFT_SSB => QFT
  | N_QFT_Yukawa => QFT
  | N_QFT_SM => QFT
  | N_QFT_CKM_PMNS => QFT
  | N_QFT_NeutrinoMass => QFT
  | N_QFT_Anomaly1 => QFT
  | N_QFT_Anomaly2 => QFT
  | N_QFT_Anomaly3 => QFT
  | N_QFT_Anomaly4 => QFT
  | N_R_Manifold => Relativity
  | N_R_Minkowski => Relativity
  | N_R_Metric => Relativity
  | N_R_LineElement => Relativity
  | N_R_LorentzGamma => Relativity
  | N_R_LorentzTransform => Relativity
  | N_R_Invariance => Relativity
  | N_R_ProperTime => Relativity
  | N_R_FourVelocity => Relativity
  | N_R_FourMomentum => Relativity
  | N_R_EnergyMomentum => Relativity
  | N_GR_Tetrad => GR
  | N_GR_SpinConnection => GR
  | N_GR_LeviCivita => GR
  | N_GR_Christoffel => GR
  | N_GR_CovDerivative => GR
  | N_GR_Geodesic => GR
  | N_GR_GeodesicDeviation => GR
  | N_GR_Riemann => GR
  | N_GR_RiemannSym => GR
  | N_GR_Ricci => GR
  | N_GR_ScalarR => GR
  | N_GR_EinsteinTensor => GR
  | N_GR_Bianchi => GR
  | N_GR_StressEnergy => GR
  | N_GR_StressConserve => GR
  | N_GR_EHAction => GR
  | N_GR_EFE => GR
  | N_GR_Newtonian => GR
  | N_GR_ADM => GR
  | N_GR_ExtrinsicK => GR
  | N_GR_HamiltonianConstraint => GR
  | N_GR_MomentumConstraint => GR
  | N_GR_Raychaudhuri => GR
  | N_EX_Schwarzschild => Exact
  | N_EX_SchwarzschildHorizon => Exact
  | N_EX_PhotonSphere => Exact
  | N_EX_ISCO => Exact
  | N_EX_Kerr => Exact
  | N_EX_KerrHorizon => Exact
  | N_EX_RN => Exact
  | N_EX_DeSitter => Exact
  | N_EX_AdS => Exact
  | N_EX_FLRW => Cosmology
  | N_COS_Friedmann1 => Cosmology
  | N_COS_Friedmann2 => Cosmology
  | N_COS_Continuity => Cosmology
  | N_COS_Acceleration => Cosmology
  | N_COS_Perturbation => Cosmology
  | N_COS_Power => Cosmology
  | N_COS_SlowRoll => Cosmology
  | N_COS_Primordial => Cosmology
  | N_COS_GW => Cosmology
  | N_BH_SurfaceGravity => BlackHole
  | N_BH_HawkingT => BlackHole
  | N_BH_Entropy => BlackHole
  | N_BH_FirstLaw => BlackHole
  | N_BR_RelQM => Bridge
  | N_BR_DiracCurved => Bridge
  | N_BR_QFTCurved => Bridge
  | N_BR_Texpect => Bridge
  | N_BR_SemiclassicalEFE => Bridge
  | N_BR_Bogoliubov => Bridge
  | N_BR_ParticleCreation => Bridge
  | N_BR_Hawking => Bridge
  | N_BR_Unruh => Bridge
  | N_BR_OpenQG => Bridge
  | N_BR_BoundaryConstants => Bridge
  end.

Definition node_stage (n : QRNode) : ProofStage :=
  match n with
  | N_Base_Logic => DeclaredFormula
  | N_Base_RealField => DeclaredFormula
  | N_Base_ComplexField => DeclaredFormula
  | N_Base_HilbertSpace => DeclaredFormula
  | N_Base_OperatorAlgebra => DeclaredFormula
  | N_Base_Adjoint => DeclaredFormula
  | N_Base_Trace => DeclaredFormula
  | N_Base_PositiveOperator => DeclaredFormula
  | N_Base_TensorProduct => DeclaredFormula
  | N_Base_LieGroup => DeclaredFormula
  | N_Base_Manifold => DeclaredFormula
  | N_Base_TensorCalculus => DeclaredFormula
  | N_Base_Variation => DeclaredFormula
  | N_Q_State => DeclaredFormula
  | N_Q_Normalization => DeclaredFormula
  | N_Q_Observable => DeclaredFormula
  | N_Q_Spectral => DeclaredFormula
  | N_Q_Born => DeclaredFormula
  | N_Q_Projector => DeclaredFormula
  | N_Q_POVM => DeclaredFormula
  | N_Q_Schrodinger => DeclaredFormula
  | N_Q_Heisenberg => DeclaredFormula
  | N_Q_CommutatorXP => DeclaredFormula
  | N_Q_Uncertainty => DeclaredFormula
  | N_Q_Density => DeclaredFormula
  | N_Q_VonNeumann => DeclaredFormula
  | N_Q_Lindblad => DeclaredFormula
  | N_Q_Kraus => CoqBackedTier0
  | N_Q_TP => CoqBackedTier0
  | N_Q_CP => CoqBackedTier0
  | N_Q_Choi => CoqBackedTier0
  | N_Q_Stinespring => DeclaredFormula
  | N_Q_Entanglement => DeclaredFormula
  | N_Q_CHSH => DeclaredFormula
  | N_Q_Decoherence => DeclaredFormula
  | N_QFT_CanonicalQuantization => DeclaredFormula
  | N_QFT_Fock => DeclaredFormula
  | N_QFT_PathIntegral => DeclaredFormula
  | N_QFT_Generating => DeclaredFormula
  | N_QFT_Propagator => DeclaredFormula
  | N_QFT_SMatrix => DeclaredFormula
  | N_QFT_LSZ => DeclaredFormula
  | N_QFT_RG => DeclaredFormula
  | N_QFT_CallanSymanzik => DeclaredFormula
  | N_QFT_KG_L => DeclaredFormula
  | N_QFT_KG_Eq => DeclaredFormula
  | N_QFT_GammaAlgebra => DeclaredFormula
  | N_QFT_Dirac_L => DeclaredFormula
  | N_QFT_Dirac_Eq => DeclaredFormula
  | N_QFT_Noether => DeclaredFormula
  | N_QFT_CovD => DeclaredFormula
  | N_QFT_FieldStrength => DeclaredFormula
  | N_QFT_Maxwell_L => DeclaredFormula
  | N_QFT_Maxwell_Bianchi => DeclaredFormula
  | N_QFT_Maxwell_Source => DeclaredFormula
  | N_QFT_YM_L => DeclaredFormula
  | N_QFT_YM_Eq => DeclaredFormula
  | N_QFT_GaugeFix => DeclaredFormula
  | N_QFT_Ghost => DeclaredFormula
  | N_QFT_BRST => DeclaredFormula
  | N_QFT_Ward => DeclaredFormula
  | N_QFT_QED => DeclaredFormula
  | N_QFT_QCD => DeclaredFormula
  | N_QFT_EW => DeclaredFormula
  | N_QFT_Higgs => DeclaredFormula
  | N_QFT_SSB => DeclaredFormula
  | N_QFT_Yukawa => DeclaredFormula
  | N_QFT_SM => DeclaredFormula
  | N_QFT_CKM_PMNS => DeclaredFormula
  | N_QFT_NeutrinoMass => DeclaredFormula
  | N_QFT_Anomaly1 => DeclaredFormula
  | N_QFT_Anomaly2 => DeclaredFormula
  | N_QFT_Anomaly3 => DeclaredFormula
  | N_QFT_Anomaly4 => DeclaredFormula
  | N_R_Manifold => DeclaredFormula
  | N_R_Minkowski => DeclaredFormula
  | N_R_Metric => CoqBackedTier0
  | N_R_LineElement => DeclaredFormula
  | N_R_LorentzGamma => DeclaredFormula
  | N_R_LorentzTransform => DeclaredFormula
  | N_R_Invariance => DeclaredFormula
  | N_R_ProperTime => DeclaredFormula
  | N_R_FourVelocity => DeclaredFormula
  | N_R_FourMomentum => DeclaredFormula
  | N_R_EnergyMomentum => DeclaredFormula
  | N_GR_Tetrad => DeclaredFormula
  | N_GR_SpinConnection => DeclaredFormula
  | N_GR_LeviCivita => DeclaredFormula
  | N_GR_Christoffel => DeclaredFormula
  | N_GR_CovDerivative => DeclaredFormula
  | N_GR_Geodesic => DeclaredFormula
  | N_GR_GeodesicDeviation => DeclaredFormula
  | N_GR_Riemann => DeclaredFormula
  | N_GR_RiemannSym => DeclaredFormula
  | N_GR_Ricci => DeclaredFormula
  | N_GR_ScalarR => DeclaredFormula
  | N_GR_EinsteinTensor => DeclaredFormula
  | N_GR_Bianchi => DeclaredFormula
  | N_GR_StressEnergy => DeclaredFormula
  | N_GR_StressConserve => DeclaredFormula
  | N_GR_EHAction => DeclaredFormula
  | N_GR_EFE => DeclaredFormula
  | N_GR_Newtonian => DeclaredFormula
  | N_GR_ADM => DeclaredFormula
  | N_GR_ExtrinsicK => DeclaredFormula
  | N_GR_HamiltonianConstraint => DeclaredFormula
  | N_GR_MomentumConstraint => DeclaredFormula
  | N_GR_Raychaudhuri => DeclaredFormula
  | N_EX_Schwarzschild => DeclaredFormula
  | N_EX_SchwarzschildHorizon => DeclaredFormula
  | N_EX_PhotonSphere => DeclaredFormula
  | N_EX_ISCO => DeclaredFormula
  | N_EX_Kerr => DeclaredFormula
  | N_EX_KerrHorizon => DeclaredFormula
  | N_EX_RN => DeclaredFormula
  | N_EX_DeSitter => DeclaredFormula
  | N_EX_AdS => DeclaredFormula
  | N_EX_FLRW => DeclaredFormula
  | N_COS_Friedmann1 => DeclaredFormula
  | N_COS_Friedmann2 => DeclaredFormula
  | N_COS_Continuity => DeclaredFormula
  | N_COS_Acceleration => DeclaredFormula
  | N_COS_Perturbation => DeclaredFormula
  | N_COS_Power => DeclaredFormula
  | N_COS_SlowRoll => DeclaredFormula
  | N_COS_Primordial => DeclaredFormula
  | N_COS_GW => DeclaredFormula
  | N_BH_SurfaceGravity => DeclaredFormula
  | N_BH_HawkingT => DeclaredFormula
  | N_BH_Entropy => DeclaredFormula
  | N_BH_FirstLaw => DeclaredFormula
  | N_BR_RelQM => DeclaredFormula
  | N_BR_DiracCurved => DeclaredFormula
  | N_BR_QFTCurved => DeclaredFormula
  | N_BR_Texpect => DeclaredFormula
  | N_BR_SemiclassicalEFE => DeclaredFormula
  | N_BR_Bogoliubov => DeclaredFormula
  | N_BR_ParticleCreation => DeclaredFormula
  | N_BR_Hawking => DeclaredFormula
  | N_BR_Unruh => DeclaredFormula
  | N_BR_OpenQG => OpenFormula
  | N_BR_BoundaryConstants => BoundaryMeasured
  end.

Definition rank (n : QRNode) : nat :=
  match n with
  | N_Base_Logic => 0
  | N_Base_RealField => 1
  | N_Base_ComplexField => 2
  | N_Base_HilbertSpace => 3
  | N_Base_OperatorAlgebra => 4
  | N_Base_Adjoint => 5
  | N_Base_Trace => 5
  | N_Base_PositiveOperator => 6
  | N_Base_TensorProduct => 4
  | N_Base_LieGroup => 1
  | N_Base_Manifold => 2
  | N_Base_TensorCalculus => 3
  | N_Base_Variation => 2
  | N_Q_State => 4
  | N_Q_Normalization => 5
  | N_Q_Observable => 5
  | N_Q_Spectral => 6
  | N_Q_Born => 7
  | N_Q_Projector => 8
  | N_Q_POVM => 9
  | N_Q_Schrodinger => 5
  | N_Q_Heisenberg => 6
  | N_Q_CommutatorXP => 6
  | N_Q_Uncertainty => 7
  | N_Q_Density => 5
  | N_Q_VonNeumann => 6
  | N_Q_Lindblad => 7
  | N_Q_Kraus => 6
  | N_Q_TP => 7
  | N_Q_CP => 7
  | N_Q_Choi => 8
  | N_Q_Stinespring => 8
  | N_Q_Entanglement => 5
  | N_Q_CHSH => 6
  | N_Q_Decoherence => 8
  | N_QFT_CanonicalQuantization => 7
  | N_QFT_Fock => 8
  | N_QFT_PathIntegral => 8
  | N_QFT_Generating => 9
  | N_QFT_Propagator => 10
  | N_QFT_SMatrix => 11
  | N_QFT_LSZ => 12
  | N_QFT_RG => 9
  | N_QFT_CallanSymanzik => 10
  | N_QFT_KG_L => 9
  | N_QFT_KG_Eq => 10
  | N_QFT_GammaAlgebra => 11
  | N_QFT_Dirac_L => 12
  | N_QFT_Dirac_Eq => 13
  | N_QFT_Noether => 14
  | N_QFT_CovD => 2
  | N_QFT_FieldStrength => 3
  | N_QFT_Maxwell_L => 4
  | N_QFT_Maxwell_Bianchi => 4
  | N_QFT_Maxwell_Source => 4
  | N_QFT_YM_L => 4
  | N_QFT_YM_Eq => 5
  | N_QFT_GaugeFix => 5
  | N_QFT_Ghost => 6
  | N_QFT_BRST => 7
  | N_QFT_Ward => 8
  | N_QFT_QED => 3
  | N_QFT_QCD => 3
  | N_QFT_EW => 3
  | N_QFT_Higgs => 4
  | N_QFT_SSB => 5
  | N_QFT_Yukawa => 6
  | N_QFT_SM => 7
  | N_QFT_CKM_PMNS => 8
  | N_QFT_NeutrinoMass => 8
  | N_QFT_Anomaly1 => 8
  | N_QFT_Anomaly2 => 8
  | N_QFT_Anomaly3 => 8
  | N_QFT_Anomaly4 => 8
  | N_R_Manifold => 3
  | N_R_Minkowski => 4
  | N_R_Metric => 5
  | N_R_LineElement => 6
  | N_R_LorentzGamma => 7
  | N_R_LorentzTransform => 8
  | N_R_Invariance => 9
  | N_R_ProperTime => 7
  | N_R_FourVelocity => 8
  | N_R_FourMomentum => 9
  | N_R_EnergyMomentum => 10
  | N_GR_Tetrad => 6
  | N_GR_SpinConnection => 7
  | N_GR_LeviCivita => 6
  | N_GR_Christoffel => 7
  | N_GR_CovDerivative => 8
  | N_GR_Geodesic => 9
  | N_GR_GeodesicDeviation => 10
  | N_GR_Riemann => 8
  | N_GR_RiemannSym => 9
  | N_GR_Ricci => 9
  | N_GR_ScalarR => 10
  | N_GR_EinsteinTensor => 10
  | N_GR_Bianchi => 11
  | N_GR_StressEnergy => 0
  | N_GR_StressConserve => 12
  | N_GR_EHAction => 11
  | N_GR_EFE => 13
  | N_GR_Newtonian => 14
  | N_GR_ADM => 14
  | N_GR_ExtrinsicK => 15
  | N_GR_HamiltonianConstraint => 16
  | N_GR_MomentumConstraint => 16
  | N_GR_Raychaudhuri => 10
  | N_EX_Schwarzschild => 14
  | N_EX_SchwarzschildHorizon => 15
  | N_EX_PhotonSphere => 15
  | N_EX_ISCO => 15
  | N_EX_Kerr => 14
  | N_EX_KerrHorizon => 15
  | N_EX_RN => 14
  | N_EX_DeSitter => 14
  | N_EX_AdS => 14
  | N_EX_FLRW => 14
  | N_COS_Friedmann1 => 15
  | N_COS_Friedmann2 => 16
  | N_COS_Continuity => 16
  | N_COS_Acceleration => 17
  | N_COS_Perturbation => 16
  | N_COS_Power => 17
  | N_COS_SlowRoll => 16
  | N_COS_Primordial => 17
  | N_COS_GW => 14
  | N_BH_SurfaceGravity => 16
  | N_BH_HawkingT => 17
  | N_BH_Entropy => 16
  | N_BH_FirstLaw => 17
  | N_BR_RelQM => 14
  | N_BR_DiracCurved => 14
  | N_BR_QFTCurved => 15
  | N_BR_Texpect => 16
  | N_BR_SemiclassicalEFE => 17
  | N_BR_Bogoliubov => 16
  | N_BR_ParticleCreation => 17
  | N_BR_Hawking => 18
  | N_BR_Unruh => 16
  | N_BR_OpenQG => 18
  | N_BR_BoundaryConstants => 14
  end.

Definition F_N_Base_Logic : Prop := forall P : Prop, P -> P.
Definition F_N_Base_RealField : Prop := R1 <> R0.
Definition F_N_Base_ComplexField : Prop := forall z : C, Cadd z C0 = z /\ Cmul z C1 = z.
Definition F_N_Base_HilbertSpace : Prop := forall v : Ket, inner v v >= 0.
Definition F_N_Base_OperatorAlgebra : Prop := forall A : Op, op_mul A op_id = A /\ op_mul op_id A = A.
Definition F_N_Base_Adjoint : Prop := forall A : Op, op_adj (op_adj A) = A.
Definition F_N_Base_Trace : Prop := forall A B : Op, trace (op_add A B) = trace A + trace B.
Definition F_N_Base_PositiveOperator : Prop := forall A : Op, positive A -> forall v : Ket, inner v (apply A v) >= 0.
Definition F_N_Base_TensorProduct : Prop := forall a b : Ket, ket_tensor a b = ket_tensor a b.
Definition F_N_Base_LieGroup : Prop := exists G0 : GaugeGroup, G0 = G0.
Definition F_N_Base_Manifold : Prop := exists p : Point, p = p.
Definition F_N_Base_TensorCalculus : Prop := forall T : Tensor, T = T.
Definition F_N_Base_Variation : Prop := forall S : Action, stationary S -> forall v : Variation, variation S v = 0.
Definition F_N_Q_State : Prop := forall psi0 : Ket, psi0 = psi0.
Definition F_N_Q_Normalization : Prop := forall psi0 : Ket, normalized psi0 -> inner psi0 psi0 = 1.
Definition F_N_Q_Observable : Prop := forall A : Op, observable A -> self_adjoint A.
Definition F_N_Q_Spectral : Prop := forall A : Op, self_adjoint A -> A = spectral_sum A.
Definition F_N_Q_Born : Prop := forall psi0 : Ket, forall P : Op, born_prob psi0 P = inner psi0 (apply P psi0).
Definition F_N_Q_Projector : Prop := forall i : nat, projector (Proj i) /\ op_mul (Proj i) (Proj i) = Proj i.
Definition F_N_Q_POVM : Prop := forall N : nat, finite_op_sum POVM N = op_id.
Definition F_N_Q_Schrodinger : Prop := forall t : R, ket_scale hbar (mul_i_ket (d_ket psi t)) = apply (Ham t) (psi t).
Definition F_N_Q_Heisenberg : Prop := forall A : R -> Op, forall t : R, d_op A t = op_add (op_scale (/ hbar) (op_comm (Ham t) (A t))) (partial_t_op A t).
Definition F_N_Q_CommutatorXP : Prop := op_comm Xop Pop = op_scale hbar op_i.
Definition F_N_Q_Uncertainty : Prop := forall dx0 dp0 : R, dx0 * dp0 >= hbar / 2.
Definition F_N_Q_Density : Prop := forall rho0 : Op, density rho0 -> positive rho0 /\ trace rho0 = 1.
Definition F_N_Q_VonNeumann : Prop := forall t : R, d_op rho t = op_scale (- / hbar) (op_comm (Ham t) (rho t)).
Definition F_N_Q_Lindblad : Prop := forall t : R, d_op rho t = op_add (op_scale (- / hbar) (op_comm (Ham t) (rho t))) (lindblad_sum (rho t)).
Definition F_N_Q_Kraus : Prop := forall N : nat, finite_op_sum (fun k => op_mul (op_adj (Kraus k)) (Kraus k)) N = op_id.
Definition F_N_Q_TP : Prop := forall E : Channel, trace_preserving E -> forall r : Op, trace (chan E r) = trace r.
Definition F_N_Q_CP : Prop := forall E : Channel, completely_positive E -> forall r : Op, positive r -> positive (chan E r).
Definition F_N_Q_Choi : Prop := forall E : Channel, completely_positive E <-> positive (choi E).
Definition F_N_Q_Stinespring : Prop := forall E : Channel, exists V : Op, forall r : Op, chan E r = partial_trace_env (op_mul V (op_mul r (op_adj V))).
Definition F_N_Q_Entanglement : Prop := forall psiAB : Ket, entangled psiAB <-> ~ separable psiAB.
Definition F_N_Q_CHSH : Prop := Rabs chsh_expect <= 2 \/ Rabs chsh_expect <= 2 * sqrt 2.
Definition F_N_Q_Decoherence : Prop := forall t : R, offdiag_norm (rho t) <= offdiag_norm (rho 0).
Definition F_N_QFT_CanonicalQuantization : Prop := forall x y : Point, op_comm (field_op x) (pi_op y) = op_scale hbar (delta_op x y).
Definition F_N_QFT_Fock : Prop := exists vacuum : Ket, forall k : nat, apply (annihilate k) vacuum = ket_zero.
Definition F_N_QFT_PathIntegral : Prop := forall S : Action, Z S = functional_integral (fun cfg => phase (S_value S cfg / hbar)).
Definition F_N_QFT_Generating : Prop := forall J0 : Source, ZJ J0 = functional_integral (fun cfg => phase (S_source cfg J0 / hbar)).
Definition F_N_QFT_Propagator : Prop := forall x y : Point, propagator x y = vacuum_expect (time_order (field_op x) (field_op y)).
Definition F_N_QFT_SMatrix : Prop := S_matrix = time_order_exp interaction_action.
Definition F_N_QFT_LSZ : Prop := forall i f : Ket, scattering_amp i f = amputated_correlator i f.
Definition F_N_QFT_RG : Prop := forall mu : R, d_R running_coupling mu = beta (running_coupling mu).
Definition F_N_QFT_CallanSymanzik : Prop := forall n : nat, forall mu : R, callan_symanzik n mu = 0.
Definition F_N_QFT_KG_L : Prop := forall p : Point, L_KG p = (1/2) * contract_grad p - (1/2) * mass * mass * field_sq p.
Definition F_N_QFT_KG_Eq : Prop := forall p : Point, box phi_field p + mass * mass * phi_scalar p = 0.
Definition F_N_QFT_GammaAlgebra : Prop := forall mu nu : nat, op_anticomm (gamma mu) (gamma nu) = op_scale (2 * eta mu nu) op_id.
Definition F_N_QFT_Dirac_L : Prop := forall p : Point, L_Dirac p = dirac_lagrangian_density p.
Definition F_N_QFT_Dirac_Eq : Prop := forall p : Point, dirac_operator p = 0.
Definition F_N_QFT_Noether : Prop := forall mu : nat, forall p : Point, d mu (fun q => current mu q) p = 0.
Definition F_N_QFT_CovD : Prop := forall mu : nat, forall p : Point, D_mu mu p = partial_mu mu p + gauge_coupling * A_mu mu p.
Definition F_N_QFT_FieldStrength : Prop := forall mu nu : nat, forall p : Point, F mu nu p = d mu (A_mu nu) p - d nu (A_mu mu) p + lie_term mu nu p.
Definition F_N_QFT_Maxwell_L : Prop := forall p : Point, L_Maxwell p = (-1/4) * F_contract p - J_contract_A p.
Definition F_N_QFT_Maxwell_Bianchi : Prop := forall p : Point, cyclic_dF p = 0.
Definition F_N_QFT_Maxwell_Source : Prop := forall nu : nat, forall p : Point, dF_source nu p = mu0 * J nu p.
Definition F_N_QFT_YM_L : Prop := forall p : Point, L_YM p = (-1/4) * YM_F_contract p.
Definition F_N_QFT_YM_Eq : Prop := forall nu : nat, forall p : Point, covD_F nu p = YM_J nu p.
Definition F_N_QFT_GaugeFix : Prop := forall p : Point, L_gf p = - (1/(2*xi)) * gauge_condition p * gauge_condition p.
Definition F_N_QFT_Ghost : Prop := forall p : Point, L_ghost p = ghost_lagrangian p.
Definition F_N_QFT_BRST : Prop := forall X : FieldExpr, brst (brst X) = field_expr_zero.
Definition F_N_QFT_Ward : Prop := forall p : Point, ward_identity p = 0.
Definition F_N_QFT_QED : Prop := forall p : Point, L_QED p = L_Maxwell p + L_Dirac p + interaction_QED p.
Definition F_N_QFT_QCD : Prop := forall p : Point, L_QCD p = L_YM p + quark_kinetic p + quark_mass p.
Definition F_N_QFT_EW : Prop := forall p : Point, L_EW p = ew_gauge p + ew_fermion p.
Definition F_N_QFT_Higgs : Prop := forall H2 : R, V_Higgs H2 = - mu_H * mu_H * H2 + lambda_H * H2 * H2.
Definition F_N_QFT_SSB : Prop := v_H * v_H = mu_H * mu_H / lambda_H.
Definition F_N_QFT_Yukawa : Prop := forall p : Point, L_Yukawa p = yukawa_density p.
Definition F_N_QFT_SM : Prop := forall p : Point, L_SM p = L_QCD p + L_EW p + L_Higgs p + L_Yukawa p.
Definition F_N_QFT_CKM_PMNS : Prop := unitary CKM /\ unitary PMNS.
Definition F_N_QFT_NeutrinoMass : Prop := exists mnu : R, mnu >= 0.
Definition F_N_QFT_Anomaly1 : Prop := forall YQ Yu Yd : R, anomaly_su3 YQ Yu Yd = 2*YQ - Yu - Yd.
Definition F_N_QFT_Anomaly2 : Prop := forall YQ YL : R, anomaly_su2 YQ YL = 3*YQ + YL.
Definition F_N_QFT_Anomaly3 : Prop := forall YQ Yu Yd YL Ye : R, anomaly_u1 YQ Yu Yd YL Ye = 6*YQ*YQ*YQ - 3*Yu*Yu*Yu - 3*Yd*Yd*Yd + 2*YL*YL*YL - Ye*Ye*Ye.
Definition F_N_QFT_Anomaly4 : Prop := forall YQ Yu Yd YL Ye : R, anomaly_grav YQ Yu Yd YL Ye = 6*YQ - 3*Yu - 3*Yd + 2*YL - Ye.
Definition F_N_R_Manifold : Prop := exists p : Point, p = p.
Definition F_N_R_Minkowski : Prop := eta 0 0 = -1 /\ eta 1 1 = 1 /\ eta 2 2 = 1 /\ eta 3 3 = 1.
Definition F_N_R_Metric : Prop := forall mu nu : nat, forall p : Point, g mu nu p = g nu mu p.
Definition F_N_R_LineElement : Prop := forall p : Point, ds2 p = sum4 (fun mu => sum4 (fun nu => g mu nu p * dx mu p * dx nu p)).
Definition F_N_R_LorentzGamma : Prop := forall v : R, gammaL v = / sqrt (1 - v*v/(c*c)).
Definition F_N_R_LorentzTransform : Prop := forall v t x : R, tprime v t x = gammaL v * (t - v*x/(c*c)) /\ xprime v t x = gammaL v * (x - v*t).
Definition F_N_R_Invariance : Prop := forall p : Point, ds2_lorentz p = ds2 p.
Definition F_N_R_ProperTime : Prop := forall p : Point, dtau2 p = - ds2 p / (c*c).
Definition F_N_R_FourVelocity : Prop := forall mu : nat, forall s : R, U4 mu s = d_R (fun u => xcoord mu u) s.
Definition F_N_R_FourMomentum : Prop := forall mu : nat, forall s : R, P4 mu s = m0 * U4 mu s.
Definition F_N_R_EnergyMomentum : Prop := Erel*Erel = pnorm2*c*c + m0*m0*c*c*c*c.
Definition F_N_GR_Tetrad : Prop := forall mu nu : nat, forall p : Point, g mu nu p = sum4 (fun a => sum4 (fun b => eta_ab a b * tetrad a mu p * tetrad b nu p)).
Definition F_N_GR_SpinConnection : Prop := forall mu a b : nat, forall p : Point, spin_conn mu a b p = spin_conn_formula mu a b p.
Definition F_N_GR_LeviCivita : Prop := torsion_free Conn /\ metric_compatible Conn.
Definition F_N_GR_Christoffel : Prop := forall rho mu nu : nat, forall p : Point, Gamma rho mu nu p = (1/2) * sum4 (fun sigma => gInv rho sigma p * (d mu (fun q => g nu sigma q) p + d nu (fun q => g mu sigma q) p - d sigma (fun q => g mu nu q) p)).
Definition F_N_GR_CovDerivative : Prop := forall mu : nat, forall T : TensorField, covD mu T = tensor_covariant_derivative mu T.
Definition F_N_GR_Geodesic : Prop := forall mu : nat, forall s : R, ddx mu s + sum4 (fun a => sum4 (fun b => Gamma mu a b (worldline s) * dxds a s * dxds b s)) = 0.
Definition F_N_GR_GeodesicDeviation : Prop := forall mu : nat, forall s : R, D2xi mu s = - sum4 (fun nu => sum4 (fun a => sum4 (fun b => Riemann mu nu a b (worldline s) * U4 nu s * xi_vec a s * U4 b s))).
Definition F_N_GR_Riemann : Prop := forall rho sigma mu nu : nat, forall p : Point, Riemann rho sigma mu nu p = d mu (fun q => Gamma rho nu sigma q) p - d nu (fun q => Gamma rho mu sigma q) p + sum4 (fun lam => Gamma rho mu lam p * Gamma lam nu sigma p - Gamma rho nu lam p * Gamma lam mu sigma p).
Definition F_N_GR_RiemannSym : Prop := forall a b c0 d0 : nat, forall p : Point, Riemann a b c0 d0 p = - Riemann a b d0 c0 p.
Definition F_N_GR_Ricci : Prop := forall mu nu : nat, forall p : Point, Ricci mu nu p = sum4 (fun rho => Riemann rho mu rho nu p).
Definition F_N_GR_ScalarR : Prop := forall p : Point, ScalarR p = sum4 (fun mu => sum4 (fun nu => gInv mu nu p * Ricci mu nu p)).
Definition F_N_GR_EinsteinTensor : Prop := forall mu nu : nat, forall p : Point, Einstein mu nu p = Ricci mu nu p - (1/2) * g mu nu p * ScalarR p.
Definition F_N_GR_Bianchi : Prop := forall nu : nat, forall p : Point, sum4 (fun mu => covD_scalar mu (fun q => Einstein mu nu q) p) = 0.
Definition F_N_GR_StressEnergy : Prop := forall mu nu : nat, forall p : Point, Tstress mu nu p = -2 / sqrt (neg_det_g p) * metric_variation matter_action mu nu p.
Definition F_N_GR_StressConserve : Prop := forall nu : nat, forall p : Point, sum4 (fun mu => covD_scalar mu (fun q => Tstress mu nu q) p) = 0.
Definition F_N_GR_EHAction : Prop := S_EH = action_integral (fun p => (c*c*c/(16*PI*G))*sqrt(neg_det_g p)*(ScalarR p - 2*Lambda)).
Definition F_N_GR_EFE : Prop := forall mu nu : nat, forall p : Point, Einstein mu nu p + Lambda * g mu nu p = (8*PI*G/(c*c*c*c)) * Tstress mu nu p.
Definition F_N_GR_Newtonian : Prop := forall p : Point, g 0 0 p = - (1 + 2 * PhiN p/(c*c)).
Definition F_N_GR_ADM : Prop := forall p : Point, adm_ds2 p = - lapse p*lapse p + spatial_line p.
Definition F_N_GR_ExtrinsicK : Prop := forall i j : nat, forall p : Point, Kext i j p = (1/(2*lapse p))*(h_dot i j p - D_spatial i (shift j) p - D_spatial j (shift i) p).
Definition F_N_GR_HamiltonianConstraint : Prop := forall p : Point, R3 p + Ktrace p*Ktrace p - KijKij p = 16*PI*G*rho_ADM p/(c*c*c*c).
Definition F_N_GR_MomentumConstraint : Prop := forall i : nat, forall p : Point, D_spatial_j_constraint i p = 8*PI*G*j_ADM i p/(c*c*c*c).
Definition F_N_GR_Raychaudhuri : Prop := forall s : R, d_R theta_exp s = - (1/3)*theta_exp s*theta_exp s - shear2 s + vorticity2 s - RicciUU s.
Definition F_N_EX_Schwarzschild : Prop := forall p : Point, f_schw p = 1 - rs/(rad p) /\ g_schw 0 0 p = - f_schw p * c*c /\ g_schw 1 1 p = / f_schw p.
Definition F_N_EX_SchwarzschildHorizon : Prop := rs = 2*G*M_bh/(c*c).
Definition F_N_EX_PhotonSphere : Prop := r_photon = 3*G*M_bh/(c*c).
Definition F_N_EX_ISCO : Prop := r_isco = 6*G*M_bh/(c*c).
Definition F_N_EX_Kerr : Prop := forall p : Point, SigmaK p = rad p*rad p + aK*aK*cos(th p)*cos(th p) /\ DeltaK p = rad p*rad p - 2*G*M_bh*rad p/(c*c) + aK*aK.
Definition F_N_EX_KerrHorizon : Prop := r_kerr_plus = G*M_bh/(c*c) + sqrt ((G*M_bh/(c*c))*(G*M_bh/(c*c)) - aK*aK).
Definition F_N_EX_RN : Prop := forall p : Point, f_RN p = 1 - 2*G*M_bh/(rad p*c*c) + G*Q_bh*Q_bh/(4*PI*epsilon0*rad p*rad p*c*c*c*c).
Definition F_N_EX_DeSitter : Prop := forall p : Point, f_dS p = 1 - Lambda * rad p*rad p / 3.
Definition F_N_EX_AdS : Prop := forall p : Point, f_AdS p = 1 + rad p*rad p/(ell_AdS*ell_AdS).
Definition F_N_EX_FLRW : Prop := forall p : Point, ds2_FLRW p = -c*c + scale_a(time p)*scale_a(time p) * spatial_curved_line p.
Definition F_N_COS_Friedmann1 : Prop := forall t : R, Hubble t*Hubble t = (8*PI*G/3)*rho_m t - k_curv*c*c/(scale_a t*scale_a t) + Lambda*c*c/3.
Definition F_N_COS_Friedmann2 : Prop := forall t : R, dd_R scale_a t / scale_a t = - (4*PI*G/3)*(rho_m t + 3*pressure_m t/(c*c)) + Lambda*c*c/3.
Definition F_N_COS_Continuity : Prop := forall t : R, d_R rho_m t + 3*Hubble t*(rho_m t + pressure_m t/(c*c)) = 0.
Definition F_N_COS_Acceleration : Prop := forall t : R, accel_a t = dd_R scale_a t / scale_a t.
Definition F_N_COS_Perturbation : Prop := forall t : R, dd_R delta t + 2*Hubble t*d_R delta t = 4*PI*G*rho_m t*delta t.
Definition F_N_COS_Power : Prop := forall k : R, Power k = ensemble_average_delta2 k.
Definition F_N_COS_SlowRoll : Prop := forall t : R, epsilon_SR t = - d_R Hubble t/(Hubble t*Hubble t).
Definition F_N_COS_Primordial : Prop := forall k : R, P_R k = H_infl*H_infl/(8*PI*PI*epsilon_star*Mpl*Mpl).
Definition F_N_COS_GW : Prop := forall p : Point, box h_TT p = 0.
Definition F_N_BH_SurfaceGravity : Prop := kappa = c*c*c*c/(4*G*M_bh).
Definition F_N_BH_HawkingT : Prop := T_H = hbar*kappa/(2*PI*kB*c).
Definition F_N_BH_Entropy : Prop := S_BH = kB*c*c*c*A_horizon/(4*G*hbar).
Definition F_N_BH_FirstLaw : Prop := dM_bh = kappa*dA_bh/(8*PI*G) + Omega_H*dJ_bh + Phi_H*dQ_bh.
Definition F_N_BR_RelQM : Prop := forall p : Point, box phi_field p + mass*mass*phi_scalar p = 0 /\ dirac_operator p = 0.
Definition F_N_BR_DiracCurved : Prop := forall p : Point, curved_dirac p = 0.
Definition F_N_BR_QFTCurved : Prop := forall S : Action, curved_Z S = functional_integral (fun cfg => phase (S_value S cfg/hbar)).
Definition F_N_BR_Texpect : Prop := forall mu nu : nat, forall p : Point, T_expect mu nu p = renormalized_expectation_T mu nu p.
Definition F_N_BR_SemiclassicalEFE : Prop := forall mu nu : nat, forall p : Point, Einstein mu nu p + Lambda*g mu nu p = (8*PI*G/(c*c*c*c))*T_expect mu nu p.
Definition F_N_BR_Bogoliubov : Prop := forall k : nat, a_out k = op_add (op_scale (alphaBog k) (a_in k)) (op_scale (betaBog k) (op_adj (a_in k))).
Definition F_N_BR_ParticleCreation : Prop := forall k : nat, N_created k = beta_abs2 k.
Definition F_N_BR_Hawking : Prop := forall omega : R, hawking_spectrum omega = / (exp (hbar*omega/(kB*T_H)) - 1).
Definition F_N_BR_Unruh : Prop := forall acc : R, T_Unruh acc = hbar*acc/(2*PI*c*kB).
Definition F_N_BR_OpenQG : Prop := Open_QuantumGravity.
Definition F_N_BR_BoundaryConstants : Prop := hbar > 0 /\ c > 0 /\ G > 0 /\ kB > 0.

Definition formula_of (n : QRNode) : Prop :=
  match n with
  | N_Base_Logic => F_N_Base_Logic
  | N_Base_RealField => F_N_Base_RealField
  | N_Base_ComplexField => F_N_Base_ComplexField
  | N_Base_HilbertSpace => F_N_Base_HilbertSpace
  | N_Base_OperatorAlgebra => F_N_Base_OperatorAlgebra
  | N_Base_Adjoint => F_N_Base_Adjoint
  | N_Base_Trace => F_N_Base_Trace
  | N_Base_PositiveOperator => F_N_Base_PositiveOperator
  | N_Base_TensorProduct => F_N_Base_TensorProduct
  | N_Base_LieGroup => F_N_Base_LieGroup
  | N_Base_Manifold => F_N_Base_Manifold
  | N_Base_TensorCalculus => F_N_Base_TensorCalculus
  | N_Base_Variation => F_N_Base_Variation
  | N_Q_State => F_N_Q_State
  | N_Q_Normalization => F_N_Q_Normalization
  | N_Q_Observable => F_N_Q_Observable
  | N_Q_Spectral => F_N_Q_Spectral
  | N_Q_Born => F_N_Q_Born
  | N_Q_Projector => F_N_Q_Projector
  | N_Q_POVM => F_N_Q_POVM
  | N_Q_Schrodinger => F_N_Q_Schrodinger
  | N_Q_Heisenberg => F_N_Q_Heisenberg
  | N_Q_CommutatorXP => F_N_Q_CommutatorXP
  | N_Q_Uncertainty => F_N_Q_Uncertainty
  | N_Q_Density => F_N_Q_Density
  | N_Q_VonNeumann => F_N_Q_VonNeumann
  | N_Q_Lindblad => F_N_Q_Lindblad
  | N_Q_Kraus => F_N_Q_Kraus
  | N_Q_TP => F_N_Q_TP
  | N_Q_CP => F_N_Q_CP
  | N_Q_Choi => F_N_Q_Choi
  | N_Q_Stinespring => F_N_Q_Stinespring
  | N_Q_Entanglement => F_N_Q_Entanglement
  | N_Q_CHSH => F_N_Q_CHSH
  | N_Q_Decoherence => F_N_Q_Decoherence
  | N_QFT_CanonicalQuantization => F_N_QFT_CanonicalQuantization
  | N_QFT_Fock => F_N_QFT_Fock
  | N_QFT_PathIntegral => F_N_QFT_PathIntegral
  | N_QFT_Generating => F_N_QFT_Generating
  | N_QFT_Propagator => F_N_QFT_Propagator
  | N_QFT_SMatrix => F_N_QFT_SMatrix
  | N_QFT_LSZ => F_N_QFT_LSZ
  | N_QFT_RG => F_N_QFT_RG
  | N_QFT_CallanSymanzik => F_N_QFT_CallanSymanzik
  | N_QFT_KG_L => F_N_QFT_KG_L
  | N_QFT_KG_Eq => F_N_QFT_KG_Eq
  | N_QFT_GammaAlgebra => F_N_QFT_GammaAlgebra
  | N_QFT_Dirac_L => F_N_QFT_Dirac_L
  | N_QFT_Dirac_Eq => F_N_QFT_Dirac_Eq
  | N_QFT_Noether => F_N_QFT_Noether
  | N_QFT_CovD => F_N_QFT_CovD
  | N_QFT_FieldStrength => F_N_QFT_FieldStrength
  | N_QFT_Maxwell_L => F_N_QFT_Maxwell_L
  | N_QFT_Maxwell_Bianchi => F_N_QFT_Maxwell_Bianchi
  | N_QFT_Maxwell_Source => F_N_QFT_Maxwell_Source
  | N_QFT_YM_L => F_N_QFT_YM_L
  | N_QFT_YM_Eq => F_N_QFT_YM_Eq
  | N_QFT_GaugeFix => F_N_QFT_GaugeFix
  | N_QFT_Ghost => F_N_QFT_Ghost
  | N_QFT_BRST => F_N_QFT_BRST
  | N_QFT_Ward => F_N_QFT_Ward
  | N_QFT_QED => F_N_QFT_QED
  | N_QFT_QCD => F_N_QFT_QCD
  | N_QFT_EW => F_N_QFT_EW
  | N_QFT_Higgs => F_N_QFT_Higgs
  | N_QFT_SSB => F_N_QFT_SSB
  | N_QFT_Yukawa => F_N_QFT_Yukawa
  | N_QFT_SM => F_N_QFT_SM
  | N_QFT_CKM_PMNS => F_N_QFT_CKM_PMNS
  | N_QFT_NeutrinoMass => F_N_QFT_NeutrinoMass
  | N_QFT_Anomaly1 => F_N_QFT_Anomaly1
  | N_QFT_Anomaly2 => F_N_QFT_Anomaly2
  | N_QFT_Anomaly3 => F_N_QFT_Anomaly3
  | N_QFT_Anomaly4 => F_N_QFT_Anomaly4
  | N_R_Manifold => F_N_R_Manifold
  | N_R_Minkowski => F_N_R_Minkowski
  | N_R_Metric => F_N_R_Metric
  | N_R_LineElement => F_N_R_LineElement
  | N_R_LorentzGamma => F_N_R_LorentzGamma
  | N_R_LorentzTransform => F_N_R_LorentzTransform
  | N_R_Invariance => F_N_R_Invariance
  | N_R_ProperTime => F_N_R_ProperTime
  | N_R_FourVelocity => F_N_R_FourVelocity
  | N_R_FourMomentum => F_N_R_FourMomentum
  | N_R_EnergyMomentum => F_N_R_EnergyMomentum
  | N_GR_Tetrad => F_N_GR_Tetrad
  | N_GR_SpinConnection => F_N_GR_SpinConnection
  | N_GR_LeviCivita => F_N_GR_LeviCivita
  | N_GR_Christoffel => F_N_GR_Christoffel
  | N_GR_CovDerivative => F_N_GR_CovDerivative
  | N_GR_Geodesic => F_N_GR_Geodesic
  | N_GR_GeodesicDeviation => F_N_GR_GeodesicDeviation
  | N_GR_Riemann => F_N_GR_Riemann
  | N_GR_RiemannSym => F_N_GR_RiemannSym
  | N_GR_Ricci => F_N_GR_Ricci
  | N_GR_ScalarR => F_N_GR_ScalarR
  | N_GR_EinsteinTensor => F_N_GR_EinsteinTensor
  | N_GR_Bianchi => F_N_GR_Bianchi
  | N_GR_StressEnergy => F_N_GR_StressEnergy
  | N_GR_StressConserve => F_N_GR_StressConserve
  | N_GR_EHAction => F_N_GR_EHAction
  | N_GR_EFE => F_N_GR_EFE
  | N_GR_Newtonian => F_N_GR_Newtonian
  | N_GR_ADM => F_N_GR_ADM
  | N_GR_ExtrinsicK => F_N_GR_ExtrinsicK
  | N_GR_HamiltonianConstraint => F_N_GR_HamiltonianConstraint
  | N_GR_MomentumConstraint => F_N_GR_MomentumConstraint
  | N_GR_Raychaudhuri => F_N_GR_Raychaudhuri
  | N_EX_Schwarzschild => F_N_EX_Schwarzschild
  | N_EX_SchwarzschildHorizon => F_N_EX_SchwarzschildHorizon
  | N_EX_PhotonSphere => F_N_EX_PhotonSphere
  | N_EX_ISCO => F_N_EX_ISCO
  | N_EX_Kerr => F_N_EX_Kerr
  | N_EX_KerrHorizon => F_N_EX_KerrHorizon
  | N_EX_RN => F_N_EX_RN
  | N_EX_DeSitter => F_N_EX_DeSitter
  | N_EX_AdS => F_N_EX_AdS
  | N_EX_FLRW => F_N_EX_FLRW
  | N_COS_Friedmann1 => F_N_COS_Friedmann1
  | N_COS_Friedmann2 => F_N_COS_Friedmann2
  | N_COS_Continuity => F_N_COS_Continuity
  | N_COS_Acceleration => F_N_COS_Acceleration
  | N_COS_Perturbation => F_N_COS_Perturbation
  | N_COS_Power => F_N_COS_Power
  | N_COS_SlowRoll => F_N_COS_SlowRoll
  | N_COS_Primordial => F_N_COS_Primordial
  | N_COS_GW => F_N_COS_GW
  | N_BH_SurfaceGravity => F_N_BH_SurfaceGravity
  | N_BH_HawkingT => F_N_BH_HawkingT
  | N_BH_Entropy => F_N_BH_Entropy
  | N_BH_FirstLaw => F_N_BH_FirstLaw
  | N_BR_RelQM => F_N_BR_RelQM
  | N_BR_DiracCurved => F_N_BR_DiracCurved
  | N_BR_QFTCurved => F_N_BR_QFTCurved
  | N_BR_Texpect => F_N_BR_Texpect
  | N_BR_SemiclassicalEFE => F_N_BR_SemiclassicalEFE
  | N_BR_Bogoliubov => F_N_BR_Bogoliubov
  | N_BR_ParticleCreation => F_N_BR_ParticleCreation
  | N_BR_Hawking => F_N_BR_Hawking
  | N_BR_Unruh => F_N_BR_Unruh
  | N_BR_OpenQG => F_N_BR_OpenQG
  | N_BR_BoundaryConstants => F_N_BR_BoundaryConstants
  end.

Inductive QREdge : QRNode -> QRNode -> Prop :=
| E001 : QREdge N_Base_Logic N_Base_RealField
| E002 : QREdge N_Base_RealField N_Base_ComplexField
| E003 : QREdge N_Base_ComplexField N_Base_HilbertSpace
| E004 : QREdge N_Base_HilbertSpace N_Base_OperatorAlgebra
| E005 : QREdge N_Base_OperatorAlgebra N_Base_Adjoint
| E006 : QREdge N_Base_OperatorAlgebra N_Base_Trace
| E007 : QREdge N_Base_Adjoint N_Base_PositiveOperator
| E008 : QREdge N_Base_HilbertSpace N_Base_TensorProduct
| E009 : QREdge N_Base_RealField N_Base_Manifold
| E010 : QREdge N_Base_Manifold N_Base_TensorCalculus
| E011 : QREdge N_Base_Logic N_Base_LieGroup
| E012 : QREdge N_Base_RealField N_Base_Variation
| E013 : QREdge N_Base_HilbertSpace N_Q_State
| E014 : QREdge N_Q_State N_Q_Normalization
| E015 : QREdge N_Base_OperatorAlgebra N_Q_Observable
| E016 : QREdge N_Q_Observable N_Q_Spectral
| E017 : QREdge N_Q_Spectral N_Q_Born
| E018 : QREdge N_Q_Born N_Q_Projector
| E019 : QREdge N_Q_Projector N_Q_POVM
| E020 : QREdge N_Q_State N_Q_Schrodinger
| E021 : QREdge N_Q_Schrodinger N_Q_Heisenberg
| E022 : QREdge N_Q_Observable N_Q_CommutatorXP
| E023 : QREdge N_Q_CommutatorXP N_Q_Uncertainty
| E024 : QREdge N_Q_State N_Q_Density
| E025 : QREdge N_Q_Density N_Q_VonNeumann
| E026 : QREdge N_Q_VonNeumann N_Q_Lindblad
| E027 : QREdge N_Q_Density N_Q_Kraus
| E028 : QREdge N_Q_Kraus N_Q_TP
| E029 : QREdge N_Q_Kraus N_Q_CP
| E030 : QREdge N_Q_CP N_Q_Choi
| E031 : QREdge N_Q_CP N_Q_Stinespring
| E032 : QREdge N_Base_TensorProduct N_Q_Entanglement
| E033 : QREdge N_Q_Entanglement N_Q_CHSH
| E034 : QREdge N_Q_Lindblad N_Q_Decoherence
| E035 : QREdge N_Q_CommutatorXP N_QFT_CanonicalQuantization
| E036 : QREdge N_QFT_CanonicalQuantization N_QFT_Fock
| E037 : QREdge N_QFT_CanonicalQuantization N_QFT_PathIntegral
| E038 : QREdge N_QFT_PathIntegral N_QFT_Generating
| E039 : QREdge N_QFT_Generating N_QFT_Propagator
| E040 : QREdge N_QFT_Propagator N_QFT_SMatrix
| E041 : QREdge N_QFT_SMatrix N_QFT_LSZ
| E042 : QREdge N_QFT_PathIntegral N_QFT_RG
| E043 : QREdge N_QFT_RG N_QFT_CallanSymanzik
| E044 : QREdge N_QFT_PathIntegral N_QFT_KG_L
| E045 : QREdge N_QFT_KG_L N_QFT_KG_Eq
| E046 : QREdge N_QFT_KG_Eq N_QFT_GammaAlgebra
| E047 : QREdge N_QFT_GammaAlgebra N_QFT_Dirac_L
| E048 : QREdge N_QFT_Dirac_L N_QFT_Dirac_Eq
| E049 : QREdge N_QFT_Dirac_Eq N_QFT_Noether
| E050 : QREdge N_Base_LieGroup N_QFT_CovD
| E051 : QREdge N_QFT_CovD N_QFT_FieldStrength
| E052 : QREdge N_QFT_FieldStrength N_QFT_Maxwell_L
| E053 : QREdge N_QFT_FieldStrength N_QFT_Maxwell_Bianchi
| E054 : QREdge N_QFT_FieldStrength N_QFT_Maxwell_Source
| E055 : QREdge N_QFT_FieldStrength N_QFT_YM_L
| E056 : QREdge N_QFT_YM_L N_QFT_YM_Eq
| E057 : QREdge N_QFT_YM_L N_QFT_GaugeFix
| E058 : QREdge N_QFT_GaugeFix N_QFT_Ghost
| E059 : QREdge N_QFT_Ghost N_QFT_BRST
| E060 : QREdge N_QFT_BRST N_QFT_Ward
| E061 : QREdge N_QFT_CovD N_QFT_QED
| E062 : QREdge N_QFT_CovD N_QFT_QCD
| E063 : QREdge N_QFT_CovD N_QFT_EW
| E064 : QREdge N_QFT_EW N_QFT_Higgs
| E065 : QREdge N_QFT_Higgs N_QFT_SSB
| E066 : QREdge N_QFT_SSB N_QFT_Yukawa
| E067 : QREdge N_QFT_QED N_QFT_SM
| E068 : QREdge N_QFT_QCD N_QFT_SM
| E069 : QREdge N_QFT_EW N_QFT_SM
| E070 : QREdge N_QFT_Yukawa N_QFT_SM
| E071 : QREdge N_QFT_SM N_QFT_CKM_PMNS
| E072 : QREdge N_QFT_SM N_QFT_NeutrinoMass
| E073 : QREdge N_QFT_SM N_QFT_Anomaly1
| E074 : QREdge N_QFT_SM N_QFT_Anomaly2
| E075 : QREdge N_QFT_SM N_QFT_Anomaly3
| E076 : QREdge N_QFT_SM N_QFT_Anomaly4
| E077 : QREdge N_Base_Manifold N_R_Manifold
| E078 : QREdge N_R_Manifold N_R_Minkowski
| E079 : QREdge N_R_Minkowski N_R_Metric
| E080 : QREdge N_R_Metric N_R_LineElement
| E081 : QREdge N_R_LineElement N_R_LorentzGamma
| E082 : QREdge N_R_LorentzGamma N_R_LorentzTransform
| E083 : QREdge N_R_LorentzTransform N_R_Invariance
| E084 : QREdge N_R_LineElement N_R_ProperTime
| E085 : QREdge N_R_ProperTime N_R_FourVelocity
| E086 : QREdge N_R_FourVelocity N_R_FourMomentum
| E087 : QREdge N_R_FourMomentum N_R_EnergyMomentum
| E088 : QREdge N_R_Metric N_GR_Tetrad
| E089 : QREdge N_GR_Tetrad N_GR_SpinConnection
| E090 : QREdge N_R_Metric N_GR_LeviCivita
| E091 : QREdge N_GR_LeviCivita N_GR_Christoffel
| E092 : QREdge N_GR_Christoffel N_GR_CovDerivative
| E093 : QREdge N_GR_CovDerivative N_GR_Geodesic
| E094 : QREdge N_GR_Geodesic N_GR_GeodesicDeviation
| E095 : QREdge N_GR_Christoffel N_GR_Riemann
| E096 : QREdge N_GR_Riemann N_GR_RiemannSym
| E097 : QREdge N_GR_Riemann N_GR_Ricci
| E098 : QREdge N_GR_Ricci N_GR_ScalarR
| E099 : QREdge N_GR_Ricci N_GR_EinsteinTensor
| E100 : QREdge N_GR_EinsteinTensor N_GR_Bianchi
| E101 : QREdge N_GR_Bianchi N_GR_StressConserve
| E102 : QREdge N_GR_EinsteinTensor N_GR_EHAction
| E103 : QREdge N_GR_StressEnergy N_GR_EFE
| E104 : QREdge N_GR_EHAction N_GR_EFE
| E105 : QREdge N_GR_StressConserve N_GR_EFE
| E106 : QREdge N_GR_EFE N_GR_Newtonian
| E107 : QREdge N_GR_EFE N_GR_ADM
| E108 : QREdge N_GR_ADM N_GR_ExtrinsicK
| E109 : QREdge N_GR_ExtrinsicK N_GR_HamiltonianConstraint
| E110 : QREdge N_GR_ExtrinsicK N_GR_MomentumConstraint
| E111 : QREdge N_GR_Geodesic N_GR_Raychaudhuri
| E112 : QREdge N_GR_EFE N_EX_Schwarzschild
| E113 : QREdge N_EX_Schwarzschild N_EX_SchwarzschildHorizon
| E114 : QREdge N_EX_Schwarzschild N_EX_PhotonSphere
| E115 : QREdge N_EX_Schwarzschild N_EX_ISCO
| E116 : QREdge N_GR_EFE N_EX_Kerr
| E117 : QREdge N_EX_Kerr N_EX_KerrHorizon
| E118 : QREdge N_GR_EFE N_EX_RN
| E119 : QREdge N_GR_EFE N_EX_DeSitter
| E120 : QREdge N_GR_EFE N_EX_AdS
| E121 : QREdge N_GR_EFE N_EX_FLRW
| E122 : QREdge N_EX_FLRW N_COS_Friedmann1
| E123 : QREdge N_COS_Friedmann1 N_COS_Friedmann2
| E124 : QREdge N_COS_Friedmann1 N_COS_Continuity
| E125 : QREdge N_COS_Friedmann2 N_COS_Acceleration
| E126 : QREdge N_COS_Friedmann1 N_COS_Perturbation
| E127 : QREdge N_COS_Perturbation N_COS_Power
| E128 : QREdge N_COS_Friedmann1 N_COS_SlowRoll
| E129 : QREdge N_COS_SlowRoll N_COS_Primordial
| E130 : QREdge N_GR_EFE N_COS_GW
| E131 : QREdge N_EX_SchwarzschildHorizon N_BH_SurfaceGravity
| E132 : QREdge N_BH_SurfaceGravity N_BH_HawkingT
| E133 : QREdge N_EX_SchwarzschildHorizon N_BH_Entropy
| E134 : QREdge N_BH_SurfaceGravity N_BH_FirstLaw
| E135 : QREdge N_QFT_KG_Eq N_BR_RelQM
| E136 : QREdge N_QFT_Dirac_Eq N_BR_RelQM
| E137 : QREdge N_GR_SpinConnection N_BR_DiracCurved
| E138 : QREdge N_QFT_Dirac_Eq N_BR_DiracCurved
| E139 : QREdge N_BR_RelQM N_BR_QFTCurved
| E140 : QREdge N_R_Metric N_BR_QFTCurved
| E141 : QREdge N_BR_QFTCurved N_BR_Texpect
| E142 : QREdge N_QFT_Noether N_BR_Texpect
| E143 : QREdge N_BR_Texpect N_BR_SemiclassicalEFE
| E144 : QREdge N_GR_EFE N_BR_SemiclassicalEFE
| E145 : QREdge N_BR_QFTCurved N_BR_Bogoliubov
| E146 : QREdge N_BR_Bogoliubov N_BR_ParticleCreation
| E147 : QREdge N_BR_ParticleCreation N_BR_Hawking
| E148 : QREdge N_BH_HawkingT N_BR_Hawking
| E149 : QREdge N_BR_QFTCurved N_BR_Unruh
| E150 : QREdge N_BR_SemiclassicalEFE N_BR_OpenQG
| E151 : QREdge N_QFT_SM N_BR_BoundaryConstants
| E152 : QREdge N_GR_EFE N_BR_BoundaryConstants
.

Inductive QRPath : QRNode -> QRNode -> Prop :=
| QRPath_edge : forall a b : QRNode, QREdge a b -> QRPath a b
| QRPath_step : forall a b c : QRNode, QREdge a b -> QRPath b c -> QRPath a c.

Theorem edge_rank : forall a b : QRNode, QREdge a b -> (rank a < rank b)%nat.
Proof.
  intros a b H; inversion H; simpl; lia.
Qed.

Theorem path_rank : forall a b : QRNode, QRPath a b -> (rank a < rank b)%nat.
Proof.
  intros a b H; induction H.
  - apply edge_rank; assumption.
  - apply Nat.lt_trans with (m := rank b).
    + apply edge_rank; assumption.
    + assumption.
Qed.

Theorem qr_dag_acyclic : forall n : QRNode, ~ QRPath n n.
Proof.
  intros n H.
  pose proof (path_rank n n H) as Hlt.
  lia.
Qed.

Definition all_nodes : list QRNode :=
  [N_Base_Logic; N_Base_RealField; N_Base_ComplexField; N_Base_HilbertSpace;
  N_Base_OperatorAlgebra; N_Base_Adjoint; N_Base_Trace; N_Base_PositiveOperator;
  N_Base_TensorProduct; N_Base_LieGroup; N_Base_Manifold; N_Base_TensorCalculus;
  N_Base_Variation; N_Q_State; N_Q_Normalization; N_Q_Observable;
  N_Q_Spectral; N_Q_Born; N_Q_Projector; N_Q_POVM;
  N_Q_Schrodinger; N_Q_Heisenberg; N_Q_CommutatorXP; N_Q_Uncertainty;
  N_Q_Density; N_Q_VonNeumann; N_Q_Lindblad; N_Q_Kraus;
  N_Q_TP; N_Q_CP; N_Q_Choi; N_Q_Stinespring;
  N_Q_Entanglement; N_Q_CHSH; N_Q_Decoherence; N_QFT_CanonicalQuantization;
  N_QFT_Fock; N_QFT_PathIntegral; N_QFT_Generating; N_QFT_Propagator;
  N_QFT_SMatrix; N_QFT_LSZ; N_QFT_RG; N_QFT_CallanSymanzik;
  N_QFT_KG_L; N_QFT_KG_Eq; N_QFT_GammaAlgebra; N_QFT_Dirac_L;
  N_QFT_Dirac_Eq; N_QFT_Noether; N_QFT_CovD; N_QFT_FieldStrength;
  N_QFT_Maxwell_L; N_QFT_Maxwell_Bianchi; N_QFT_Maxwell_Source; N_QFT_YM_L;
  N_QFT_YM_Eq; N_QFT_GaugeFix; N_QFT_Ghost; N_QFT_BRST;
  N_QFT_Ward; N_QFT_QED; N_QFT_QCD; N_QFT_EW;
  N_QFT_Higgs; N_QFT_SSB; N_QFT_Yukawa; N_QFT_SM;
  N_QFT_CKM_PMNS; N_QFT_NeutrinoMass; N_QFT_Anomaly1; N_QFT_Anomaly2;
  N_QFT_Anomaly3; N_QFT_Anomaly4; N_R_Manifold; N_R_Minkowski;
  N_R_Metric; N_R_LineElement; N_R_LorentzGamma; N_R_LorentzTransform;
  N_R_Invariance; N_R_ProperTime; N_R_FourVelocity; N_R_FourMomentum;
  N_R_EnergyMomentum; N_GR_Tetrad; N_GR_SpinConnection; N_GR_LeviCivita;
  N_GR_Christoffel; N_GR_CovDerivative; N_GR_Geodesic; N_GR_GeodesicDeviation;
  N_GR_Riemann; N_GR_RiemannSym; N_GR_Ricci; N_GR_ScalarR;
  N_GR_EinsteinTensor; N_GR_Bianchi; N_GR_StressEnergy; N_GR_StressConserve;
  N_GR_EHAction; N_GR_EFE; N_GR_Newtonian; N_GR_ADM;
  N_GR_ExtrinsicK; N_GR_HamiltonianConstraint; N_GR_MomentumConstraint; N_GR_Raychaudhuri;
  N_EX_Schwarzschild; N_EX_SchwarzschildHorizon; N_EX_PhotonSphere; N_EX_ISCO;
  N_EX_Kerr; N_EX_KerrHorizon; N_EX_RN; N_EX_DeSitter;
  N_EX_AdS; N_EX_FLRW; N_COS_Friedmann1; N_COS_Friedmann2;
  N_COS_Continuity; N_COS_Acceleration; N_COS_Perturbation; N_COS_Power;
  N_COS_SlowRoll; N_COS_Primordial; N_COS_GW; N_BH_SurfaceGravity;
  N_BH_HawkingT; N_BH_Entropy; N_BH_FirstLaw; N_BR_RelQM;
  N_BR_DiracCurved; N_BR_QFTCurved; N_BR_Texpect; N_BR_SemiclassicalEFE;
  N_BR_Bogoliubov; N_BR_ParticleCreation; N_BR_Hawking; N_BR_Unruh;
  N_BR_OpenQG; N_BR_BoundaryConstants].

Definition all_edges : list (QRNode * QRNode) :=
  [(N_Base_Logic,N_Base_RealField); (N_Base_RealField,N_Base_ComplexField);
  (N_Base_ComplexField,N_Base_HilbertSpace); (N_Base_HilbertSpace,N_Base_OperatorAlgebra);
  (N_Base_OperatorAlgebra,N_Base_Adjoint); (N_Base_OperatorAlgebra,N_Base_Trace);
  (N_Base_Adjoint,N_Base_PositiveOperator); (N_Base_HilbertSpace,N_Base_TensorProduct);
  (N_Base_RealField,N_Base_Manifold); (N_Base_Manifold,N_Base_TensorCalculus);
  (N_Base_Logic,N_Base_LieGroup); (N_Base_RealField,N_Base_Variation);
  (N_Base_HilbertSpace,N_Q_State); (N_Q_State,N_Q_Normalization);
  (N_Base_OperatorAlgebra,N_Q_Observable); (N_Q_Observable,N_Q_Spectral);
  (N_Q_Spectral,N_Q_Born); (N_Q_Born,N_Q_Projector);
  (N_Q_Projector,N_Q_POVM); (N_Q_State,N_Q_Schrodinger);
  (N_Q_Schrodinger,N_Q_Heisenberg); (N_Q_Observable,N_Q_CommutatorXP);
  (N_Q_CommutatorXP,N_Q_Uncertainty); (N_Q_State,N_Q_Density);
  (N_Q_Density,N_Q_VonNeumann); (N_Q_VonNeumann,N_Q_Lindblad);
  (N_Q_Density,N_Q_Kraus); (N_Q_Kraus,N_Q_TP);
  (N_Q_Kraus,N_Q_CP); (N_Q_CP,N_Q_Choi);
  (N_Q_CP,N_Q_Stinespring); (N_Base_TensorProduct,N_Q_Entanglement);
  (N_Q_Entanglement,N_Q_CHSH); (N_Q_Lindblad,N_Q_Decoherence);
  (N_Q_CommutatorXP,N_QFT_CanonicalQuantization); (N_QFT_CanonicalQuantization,N_QFT_Fock);
  (N_QFT_CanonicalQuantization,N_QFT_PathIntegral); (N_QFT_PathIntegral,N_QFT_Generating);
  (N_QFT_Generating,N_QFT_Propagator); (N_QFT_Propagator,N_QFT_SMatrix);
  (N_QFT_SMatrix,N_QFT_LSZ); (N_QFT_PathIntegral,N_QFT_RG);
  (N_QFT_RG,N_QFT_CallanSymanzik); (N_QFT_PathIntegral,N_QFT_KG_L);
  (N_QFT_KG_L,N_QFT_KG_Eq); (N_QFT_KG_Eq,N_QFT_GammaAlgebra);
  (N_QFT_GammaAlgebra,N_QFT_Dirac_L); (N_QFT_Dirac_L,N_QFT_Dirac_Eq);
  (N_QFT_Dirac_Eq,N_QFT_Noether); (N_Base_LieGroup,N_QFT_CovD);
  (N_QFT_CovD,N_QFT_FieldStrength); (N_QFT_FieldStrength,N_QFT_Maxwell_L);
  (N_QFT_FieldStrength,N_QFT_Maxwell_Bianchi); (N_QFT_FieldStrength,N_QFT_Maxwell_Source);
  (N_QFT_FieldStrength,N_QFT_YM_L); (N_QFT_YM_L,N_QFT_YM_Eq);
  (N_QFT_YM_L,N_QFT_GaugeFix); (N_QFT_GaugeFix,N_QFT_Ghost);
  (N_QFT_Ghost,N_QFT_BRST); (N_QFT_BRST,N_QFT_Ward);
  (N_QFT_CovD,N_QFT_QED); (N_QFT_CovD,N_QFT_QCD);
  (N_QFT_CovD,N_QFT_EW); (N_QFT_EW,N_QFT_Higgs);
  (N_QFT_Higgs,N_QFT_SSB); (N_QFT_SSB,N_QFT_Yukawa);
  (N_QFT_QED,N_QFT_SM); (N_QFT_QCD,N_QFT_SM);
  (N_QFT_EW,N_QFT_SM); (N_QFT_Yukawa,N_QFT_SM);
  (N_QFT_SM,N_QFT_CKM_PMNS); (N_QFT_SM,N_QFT_NeutrinoMass);
  (N_QFT_SM,N_QFT_Anomaly1); (N_QFT_SM,N_QFT_Anomaly2);
  (N_QFT_SM,N_QFT_Anomaly3); (N_QFT_SM,N_QFT_Anomaly4);
  (N_Base_Manifold,N_R_Manifold); (N_R_Manifold,N_R_Minkowski);
  (N_R_Minkowski,N_R_Metric); (N_R_Metric,N_R_LineElement);
  (N_R_LineElement,N_R_LorentzGamma); (N_R_LorentzGamma,N_R_LorentzTransform);
  (N_R_LorentzTransform,N_R_Invariance); (N_R_LineElement,N_R_ProperTime);
  (N_R_ProperTime,N_R_FourVelocity); (N_R_FourVelocity,N_R_FourMomentum);
  (N_R_FourMomentum,N_R_EnergyMomentum); (N_R_Metric,N_GR_Tetrad);
  (N_GR_Tetrad,N_GR_SpinConnection); (N_R_Metric,N_GR_LeviCivita);
  (N_GR_LeviCivita,N_GR_Christoffel); (N_GR_Christoffel,N_GR_CovDerivative);
  (N_GR_CovDerivative,N_GR_Geodesic); (N_GR_Geodesic,N_GR_GeodesicDeviation);
  (N_GR_Christoffel,N_GR_Riemann); (N_GR_Riemann,N_GR_RiemannSym);
  (N_GR_Riemann,N_GR_Ricci); (N_GR_Ricci,N_GR_ScalarR);
  (N_GR_Ricci,N_GR_EinsteinTensor); (N_GR_EinsteinTensor,N_GR_Bianchi);
  (N_GR_Bianchi,N_GR_StressConserve); (N_GR_EinsteinTensor,N_GR_EHAction);
  (N_GR_StressEnergy,N_GR_EFE); (N_GR_EHAction,N_GR_EFE);
  (N_GR_StressConserve,N_GR_EFE); (N_GR_EFE,N_GR_Newtonian);
  (N_GR_EFE,N_GR_ADM); (N_GR_ADM,N_GR_ExtrinsicK);
  (N_GR_ExtrinsicK,N_GR_HamiltonianConstraint); (N_GR_ExtrinsicK,N_GR_MomentumConstraint);
  (N_GR_Geodesic,N_GR_Raychaudhuri); (N_GR_EFE,N_EX_Schwarzschild);
  (N_EX_Schwarzschild,N_EX_SchwarzschildHorizon); (N_EX_Schwarzschild,N_EX_PhotonSphere);
  (N_EX_Schwarzschild,N_EX_ISCO); (N_GR_EFE,N_EX_Kerr);
  (N_EX_Kerr,N_EX_KerrHorizon); (N_GR_EFE,N_EX_RN);
  (N_GR_EFE,N_EX_DeSitter); (N_GR_EFE,N_EX_AdS);
  (N_GR_EFE,N_EX_FLRW); (N_EX_FLRW,N_COS_Friedmann1);
  (N_COS_Friedmann1,N_COS_Friedmann2); (N_COS_Friedmann1,N_COS_Continuity);
  (N_COS_Friedmann2,N_COS_Acceleration); (N_COS_Friedmann1,N_COS_Perturbation);
  (N_COS_Perturbation,N_COS_Power); (N_COS_Friedmann1,N_COS_SlowRoll);
  (N_COS_SlowRoll,N_COS_Primordial); (N_GR_EFE,N_COS_GW);
  (N_EX_SchwarzschildHorizon,N_BH_SurfaceGravity); (N_BH_SurfaceGravity,N_BH_HawkingT);
  (N_EX_SchwarzschildHorizon,N_BH_Entropy); (N_BH_SurfaceGravity,N_BH_FirstLaw);
  (N_QFT_KG_Eq,N_BR_RelQM); (N_QFT_Dirac_Eq,N_BR_RelQM);
  (N_GR_SpinConnection,N_BR_DiracCurved); (N_QFT_Dirac_Eq,N_BR_DiracCurved);
  (N_BR_RelQM,N_BR_QFTCurved); (N_R_Metric,N_BR_QFTCurved);
  (N_BR_QFTCurved,N_BR_Texpect); (N_QFT_Noether,N_BR_Texpect);
  (N_BR_Texpect,N_BR_SemiclassicalEFE); (N_GR_EFE,N_BR_SemiclassicalEFE);
  (N_BR_QFTCurved,N_BR_Bogoliubov); (N_BR_Bogoliubov,N_BR_ParticleCreation);
  (N_BR_ParticleCreation,N_BR_Hawking); (N_BH_HawkingT,N_BR_Hawking);
  (N_BR_QFTCurved,N_BR_Unruh); (N_BR_SemiclassicalEFE,N_BR_OpenQG);
  (N_QFT_SM,N_BR_BoundaryConstants); (N_GR_EFE,N_BR_BoundaryConstants)].

End Quantum_Relativity_Formal_DAG_Deep.

(*
  ============================================================================
  Extension: Reality-Channel-Perception DAG
  ----------------------------------------------------------------------------
  This module keeps the original DAG as an anchor and extends it toward
  computable perception-facing problems:

    object/state -> light/channel -> spacetime/geodesic distortion
                 -> retinal POVM/decoherence -> neural reconstruction

  It does not claim to solve full quantum gravity or neurobiology.  It marks
  those boundaries explicitly as OpenFormula nodes.
  ============================================================================
*)

Module Quantum_Relativity_Perception_Extension.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.

Inductive EnhancedSector : Type :=
| ES_Anchor
| ES_Information
| ES_Perception
| ES_Computation
| ES_BlackHoleComputation
| ES_OpenBoundary
| ES_Output.

Inductive EnhancedStage : Type :=
| ES_Original
| ES_DeclaredFormula
| ES_ComputableFormula
| ES_BoundaryFormula
| ES_OpenFormula.

Inductive EnhancedNode : Type :=
| Anchor : QRD.QRNode -> EnhancedNode

(* Information-theoretic bridge. *)
| N_INF_StateAsCarrier
| N_INF_ChannelComposition
| N_INF_OperationalReality

(* Perception chain. *)
| N_PER_ObjectToLight
| N_PER_LightGeodesicBundle
| N_PER_RetinalPOVM
| N_PER_NeuralChannel
| N_PER_Reconstruction

(* Directly computable nodes. *)
| N_COMP_SchwarzschildRadius
| N_COMP_LensingAngle
| N_COMP_SchwarzschildRedshift
| N_COMP_PhotonSphereImage
| N_COMP_TimeDelay
| N_COMP_DecoherenceTc
| N_COMP_CoherenceVisibility
| N_COMP_HawkingCriticalMass
| N_COMP_BH_CMBBoundary

(* Open-problem frontier nodes. *)
| N_OPEN_InfoParadox
| N_OPEN_QGMetricState
| N_OPEN_NeuralQuantumLimit

(* Final synthesis node. *)
| N_OUT_RealityChannelTheorem.

Definition enhanced_sector (n : EnhancedNode) : EnhancedSector :=
  match n with
  | Anchor _ => ES_Anchor
  | N_INF_StateAsCarrier => ES_Information
  | N_INF_ChannelComposition => ES_Information
  | N_INF_OperationalReality => ES_Information
  | N_PER_ObjectToLight => ES_Perception
  | N_PER_LightGeodesicBundle => ES_Perception
  | N_PER_RetinalPOVM => ES_Perception
  | N_PER_NeuralChannel => ES_Perception
  | N_PER_Reconstruction => ES_Perception
  | N_COMP_SchwarzschildRadius => ES_Computation
  | N_COMP_LensingAngle => ES_Computation
  | N_COMP_SchwarzschildRedshift => ES_Computation
  | N_COMP_PhotonSphereImage => ES_BlackHoleComputation
  | N_COMP_TimeDelay => ES_Computation
  | N_COMP_DecoherenceTc => ES_Computation
  | N_COMP_CoherenceVisibility => ES_Computation
  | N_COMP_HawkingCriticalMass => ES_BlackHoleComputation
  | N_COMP_BH_CMBBoundary => ES_BlackHoleComputation
  | N_OPEN_InfoParadox => ES_OpenBoundary
  | N_OPEN_QGMetricState => ES_OpenBoundary
  | N_OPEN_NeuralQuantumLimit => ES_OpenBoundary
  | N_OUT_RealityChannelTheorem => ES_Output
  end.

Definition enhanced_stage (n : EnhancedNode) : EnhancedStage :=
  match n with
  | Anchor _ => ES_Original
  | N_INF_StateAsCarrier => ES_DeclaredFormula
  | N_INF_ChannelComposition => ES_ComputableFormula
  | N_INF_OperationalReality => ES_DeclaredFormula
  | N_PER_ObjectToLight => ES_ComputableFormula
  | N_PER_LightGeodesicBundle => ES_ComputableFormula
  | N_PER_RetinalPOVM => ES_ComputableFormula
  | N_PER_NeuralChannel => ES_ComputableFormula
  | N_PER_Reconstruction => ES_BoundaryFormula
  | N_COMP_SchwarzschildRadius => ES_ComputableFormula
  | N_COMP_LensingAngle => ES_ComputableFormula
  | N_COMP_SchwarzschildRedshift => ES_ComputableFormula
  | N_COMP_PhotonSphereImage => ES_ComputableFormula
  | N_COMP_TimeDelay => ES_ComputableFormula
  | N_COMP_DecoherenceTc => ES_ComputableFormula
  | N_COMP_CoherenceVisibility => ES_ComputableFormula
  | N_COMP_HawkingCriticalMass => ES_ComputableFormula
  | N_COMP_BH_CMBBoundary => ES_ComputableFormula
  | N_OPEN_InfoParadox => ES_OpenFormula
  | N_OPEN_QGMetricState => ES_OpenFormula
  | N_OPEN_NeuralQuantumLimit => ES_OpenFormula
  | N_OUT_RealityChannelTheorem => ES_BoundaryFormula
  end.

(* New abstract symbols.  They make the extension computable at the formula
   level while preserving the original file's style of parameterized physics. *)
Parameter channel_compose : QRD.Channel -> QRD.Channel -> QRD.Channel.
Parameter space_channel eye_channel brain_channel total_perception_channel : QRD.Channel.

Parameter raw_reality object_state light_state retinal_state brain_state perceived_state : QRD.Op.
Parameter operational_image : QRD.Op -> QRD.Op.

Parameter schwarzschild_radius photon_sphere_radius isco_radius : R -> R.
Parameter lensing_angle : R -> R -> R.
Parameter redshift_factor : R -> R -> R.
Parameter observed_wavelength : R -> R -> R -> R.
Parameter shapiro_delay : R -> R -> R.
Parameter photon_ring_radius : R -> R.

Parameter Tc_decoh : R.
Parameter coherence_visibility : R -> R.
Parameter evolved_density : R -> QRD.Op.

Parameter CMB_temperature critical_cmb_mass : R.
Parameter information_recovery_unitary : QRD.Op -> Prop.
Parameter quantum_metric_state : Prop.
Parameter neural_quantum_limit : Prop.

(* Information layer. *)
Definition F_E_INF_StateAsCarrier : Prop :=
  QRD.density object_state ->
  QRD.density light_state.

Definition F_E_INF_ChannelComposition : Prop :=
  total_perception_channel =
    channel_compose brain_channel (channel_compose eye_channel space_channel).

Definition F_E_INF_OperationalReality : Prop :=
  perceived_state = operational_image raw_reality.

(* Perception layer. *)
Definition F_E_PER_ObjectToLight : Prop :=
  light_state = QRD.chan space_channel object_state.

Definition F_E_PER_LightGeodesicBundle : Prop :=
  forall M b : R,
    b <> 0 ->
    lensing_angle M b = 4 * QRD.G * M / (QRD.c * QRD.c * b).

Definition F_E_PER_RetinalPOVM : Prop :=
  QRD.trace_preserving eye_channel /\ QRD.completely_positive eye_channel.

Definition F_E_PER_NeuralChannel : Prop :=
  QRD.trace_preserving brain_channel /\ QRD.completely_positive brain_channel.

Definition F_E_PER_Reconstruction : Prop :=
  perceived_state = QRD.chan brain_channel retinal_state.

(* Computation layer. *)
Definition F_E_COMP_SchwarzschildRadius : Prop :=
  forall M : R,
    schwarzschild_radius M = 2 * QRD.G * M / (QRD.c * QRD.c).

Definition F_E_COMP_LensingAngle : Prop :=
  forall M b : R,
    b <> 0 ->
    lensing_angle M b = 4 * QRD.G * M / (QRD.c * QRD.c * b).

Definition F_E_COMP_SchwarzschildRedshift : Prop :=
  forall M r lambda_emit : R,
    r > schwarzschild_radius M ->
    observed_wavelength M r lambda_emit =
      lambda_emit / QRD.sqrt (1 - schwarzschild_radius M / r).

Definition F_E_COMP_PhotonSphereImage : Prop :=
  forall M : R,
    photon_sphere_radius M = 3 * QRD.G * M / (QRD.c * QRD.c).

Definition F_E_COMP_TimeDelay : Prop :=
  forall M b : R,
    b <> 0 ->
    shapiro_delay M b >= 0.

Definition F_E_COMP_DecoherenceTc : Prop :=
  Tc_decoh > 0 ->
  forall t : R,
    t >= 0 ->
    coherence_visibility t = coherence_visibility 0 * QRD.exp (- t / Tc_decoh).

Definition F_E_COMP_CoherenceVisibility : Prop :=
  forall t : R,
    coherence_visibility t = QRD.offdiag_norm (evolved_density t).

Definition F_E_COMP_HawkingCriticalMass : Prop :=
  CMB_temperature <> 0 ->
  critical_cmb_mass =
    QRD.hbar * QRD.c * QRD.c * QRD.c /
      (8 * QRD.PI * QRD.G * QRD.kB * CMB_temperature).

Definition F_E_COMP_BH_CMBBoundary : Prop :=
  forall M : R,
    M > critical_cmb_mass ->
    QRD.T_H < CMB_temperature.

(* Open boundaries. *)
Definition F_E_OPEN_InfoParadox : Prop :=
  information_recovery_unitary perceived_state \/ ~ information_recovery_unitary perceived_state.

Definition F_E_OPEN_QGMetricState : Prop :=
  quantum_metric_state -> QRD.Open_QuantumGravity.

Definition F_E_OPEN_NeuralQuantumLimit : Prop :=
  neural_quantum_limit \/ ~ neural_quantum_limit.

(* Final synthesis. *)
Definition F_E_OUT_RealityChannelTheorem : Prop :=
  perceived_state =
    QRD.chan brain_channel
      (QRD.chan eye_channel
        (QRD.chan space_channel raw_reality)).

Definition enhanced_formula_of (n : EnhancedNode) : Prop :=
  match n with
  | Anchor q => QRD.formula_of q
  | N_INF_StateAsCarrier => F_E_INF_StateAsCarrier
  | N_INF_ChannelComposition => F_E_INF_ChannelComposition
  | N_INF_OperationalReality => F_E_INF_OperationalReality
  | N_PER_ObjectToLight => F_E_PER_ObjectToLight
  | N_PER_LightGeodesicBundle => F_E_PER_LightGeodesicBundle
  | N_PER_RetinalPOVM => F_E_PER_RetinalPOVM
  | N_PER_NeuralChannel => F_E_PER_NeuralChannel
  | N_PER_Reconstruction => F_E_PER_Reconstruction
  | N_COMP_SchwarzschildRadius => F_E_COMP_SchwarzschildRadius
  | N_COMP_LensingAngle => F_E_COMP_LensingAngle
  | N_COMP_SchwarzschildRedshift => F_E_COMP_SchwarzschildRedshift
  | N_COMP_PhotonSphereImage => F_E_COMP_PhotonSphereImage
  | N_COMP_TimeDelay => F_E_COMP_TimeDelay
  | N_COMP_DecoherenceTc => F_E_COMP_DecoherenceTc
  | N_COMP_CoherenceVisibility => F_E_COMP_CoherenceVisibility
  | N_COMP_HawkingCriticalMass => F_E_COMP_HawkingCriticalMass
  | N_COMP_BH_CMBBoundary => F_E_COMP_BH_CMBBoundary
  | N_OPEN_InfoParadox => F_E_OPEN_InfoParadox
  | N_OPEN_QGMetricState => F_E_OPEN_QGMetricState
  | N_OPEN_NeuralQuantumLimit => F_E_OPEN_NeuralQuantumLimit
  | N_OUT_RealityChannelTheorem => F_E_OUT_RealityChannelTheorem
  end.

Definition enhanced_rank (n : EnhancedNode) : nat :=
  match n with
  | Anchor q => QRD.rank q
  | N_INF_StateAsCarrier => 30
  | N_INF_ChannelComposition => 30
  | N_INF_OperationalReality => 31
  | N_PER_ObjectToLight => 32
  | N_PER_LightGeodesicBundle => 33
  | N_PER_RetinalPOVM => 34
  | N_PER_NeuralChannel => 35
  | N_PER_Reconstruction => 36
  | N_COMP_SchwarzschildRadius => 31
  | N_COMP_LensingAngle => 34
  | N_COMP_SchwarzschildRedshift => 34
  | N_COMP_PhotonSphereImage => 34
  | N_COMP_TimeDelay => 34
  | N_COMP_DecoherenceTc => 34
  | N_COMP_CoherenceVisibility => 35
  | N_COMP_HawkingCriticalMass => 34
  | N_COMP_BH_CMBBoundary => 35
  | N_OPEN_InfoParadox => 40
  | N_OPEN_QGMetricState => 41
  | N_OPEN_NeuralQuantumLimit => 41
  | N_OUT_RealityChannelTheorem => 39
  end.

Inductive EnhancedEdge : EnhancedNode -> EnhancedNode -> Prop :=
(* Preserve all original edges as anchors. *)
| EE_Anchor : forall a b : QRD.QRNode,
    QRD.QREdge a b ->
    EnhancedEdge (Anchor a) (Anchor b)

(* Original DAG anchors into the new information/perception/computation layer. *)
| EE_QDensity_StateCarrier :
    EnhancedEdge (Anchor QRD.N_Q_Density) N_INF_StateAsCarrier
| EE_QKraus_ChannelComposition :
    EnhancedEdge (Anchor QRD.N_Q_Kraus) N_INF_ChannelComposition
| EE_QCP_Retinal :
    EnhancedEdge (Anchor QRD.N_Q_CP) N_PER_RetinalPOVM
| EE_QTP_Retinal :
    EnhancedEdge (Anchor QRD.N_Q_TP) N_PER_RetinalPOVM
| EE_QBorn_Retinal :
    EnhancedEdge (Anchor QRD.N_Q_Born) N_PER_RetinalPOVM
| EE_QDecoherence_Tc :
    EnhancedEdge (Anchor QRD.N_Q_Decoherence) N_COMP_DecoherenceTc
| EE_GRGeodesic_LightBundle :
    EnhancedEdge (Anchor QRD.N_GR_Geodesic) N_PER_LightGeodesicBundle
| EE_Schwarzschild_Radius :
    EnhancedEdge (Anchor QRD.N_EX_Schwarzschild) N_COMP_SchwarzschildRadius
| EE_Schwarzschild_Redshift :
    EnhancedEdge (Anchor QRD.N_EX_Schwarzschild) N_COMP_SchwarzschildRedshift
| EE_PhotonSphere_Image :
    EnhancedEdge (Anchor QRD.N_EX_PhotonSphere) N_COMP_PhotonSphereImage
| EE_HawkingT_CriticalMass :
    EnhancedEdge (Anchor QRD.N_BH_HawkingT) N_COMP_HawkingCriticalMass
| EE_Semiclassical_QGMetric :
    EnhancedEdge (Anchor QRD.N_BR_SemiclassicalEFE) N_OPEN_QGMetricState
| EE_OpenQG_QGMetric :
    EnhancedEdge (Anchor QRD.N_BR_OpenQG) N_OPEN_QGMetricState

(* New extended DAG. *)
| EE_State_ObjectToLight :
    EnhancedEdge N_INF_StateAsCarrier N_PER_ObjectToLight
| EE_Channel_ObjectToLight :
    EnhancedEdge N_INF_ChannelComposition N_PER_ObjectToLight
| EE_ObjectToLight_LightBundle :
    EnhancedEdge N_PER_ObjectToLight N_PER_LightGeodesicBundle
| EE_Radius_Redshift :
    EnhancedEdge N_COMP_SchwarzschildRadius N_COMP_SchwarzschildRedshift
| EE_LightBundle_Lensing :
    EnhancedEdge N_PER_LightGeodesicBundle N_COMP_LensingAngle
| EE_LightBundle_TimeDelay :
    EnhancedEdge N_PER_LightGeodesicBundle N_COMP_TimeDelay
| EE_LightBundle_Retinal :
    EnhancedEdge N_PER_LightGeodesicBundle N_PER_RetinalPOVM
| EE_Retinal_Neural :
    EnhancedEdge N_PER_RetinalPOVM N_PER_NeuralChannel
| EE_Channel_Neural :
    EnhancedEdge N_INF_ChannelComposition N_PER_NeuralChannel
| EE_Decoherence_Visibility :
    EnhancedEdge N_COMP_DecoherenceTc N_COMP_CoherenceVisibility
| EE_Visibility_Reconstruction :
    EnhancedEdge N_COMP_CoherenceVisibility N_PER_Reconstruction
| EE_Neural_Reconstruction :
    EnhancedEdge N_PER_NeuralChannel N_PER_Reconstruction
| EE_Operational_Reconstruction :
    EnhancedEdge N_INF_OperationalReality N_PER_Reconstruction
| EE_Redshift_Output :
    EnhancedEdge N_COMP_SchwarzschildRedshift N_OUT_RealityChannelTheorem
| EE_Lensing_Output :
    EnhancedEdge N_COMP_LensingAngle N_OUT_RealityChannelTheorem
| EE_TimeDelay_Output :
    EnhancedEdge N_COMP_TimeDelay N_OUT_RealityChannelTheorem
| EE_PhotonSphere_Information :
    EnhancedEdge N_COMP_PhotonSphereImage N_OPEN_InfoParadox
| EE_Hawking_CMB :
    EnhancedEdge N_COMP_HawkingCriticalMass N_COMP_BH_CMBBoundary
| EE_CMB_InfoParadox :
    EnhancedEdge N_COMP_BH_CMBBoundary N_OPEN_InfoParadox
| EE_Reconstruction_Output :
    EnhancedEdge N_PER_Reconstruction N_OUT_RealityChannelTheorem
| EE_Output_NeuralLimit :
    EnhancedEdge N_OUT_RealityChannelTheorem N_OPEN_NeuralQuantumLimit
| EE_InfoParadox_QGMetric :
    EnhancedEdge N_OPEN_InfoParadox N_OPEN_QGMetricState
.

Inductive EnhancedPath : EnhancedNode -> EnhancedNode -> Prop :=
| EnhancedPath_edge : forall a b : EnhancedNode,
    EnhancedEdge a b -> EnhancedPath a b
| EnhancedPath_step : forall a b c : EnhancedNode,
    EnhancedEdge a b -> EnhancedPath b c -> EnhancedPath a c.

Theorem enhanced_edge_rank :
  forall a b : EnhancedNode,
    EnhancedEdge a b -> (enhanced_rank a < enhanced_rank b)%nat.
Proof.
  intros a b H; inversion H; subst; simpl; try lia.
  apply QRD.edge_rank; assumption.
Qed.

Theorem enhanced_path_rank :
  forall a b : EnhancedNode,
    EnhancedPath a b -> (enhanced_rank a < enhanced_rank b)%nat.
Proof.
  intros a b H; induction H.
  - apply enhanced_edge_rank; assumption.
  - apply Nat.lt_trans with (m := enhanced_rank b).
    + apply enhanced_edge_rank; assumption.
    + assumption.
Qed.

Theorem enhanced_dag_acyclic :
  forall n : EnhancedNode, ~ EnhancedPath n n.
Proof.
  intros n H.
  pose proof (enhanced_path_rank n n H) as Hlt.
  lia.
Qed.

Definition new_nodes : list EnhancedNode :=
  [N_INF_StateAsCarrier; N_INF_ChannelComposition; N_INF_OperationalReality;
   N_PER_ObjectToLight; N_PER_LightGeodesicBundle; N_PER_RetinalPOVM;
   N_PER_NeuralChannel; N_PER_Reconstruction;
   N_COMP_SchwarzschildRadius; N_COMP_LensingAngle; N_COMP_SchwarzschildRedshift;
   N_COMP_PhotonSphereImage; N_COMP_TimeDelay; N_COMP_DecoherenceTc;
   N_COMP_CoherenceVisibility; N_COMP_HawkingCriticalMass; N_COMP_BH_CMBBoundary;
   N_OPEN_InfoParadox; N_OPEN_QGMetricState; N_OPEN_NeuralQuantumLimit;
   N_OUT_RealityChannelTheorem].

Definition all_enhanced_nodes : list EnhancedNode :=
  map Anchor QRD.all_nodes ++ new_nodes.

Definition new_edges : list (EnhancedNode * EnhancedNode) :=
  [(Anchor QRD.N_Q_Density, N_INF_StateAsCarrier);
   (Anchor QRD.N_Q_Kraus, N_INF_ChannelComposition);
   (Anchor QRD.N_Q_CP, N_PER_RetinalPOVM);
   (Anchor QRD.N_Q_TP, N_PER_RetinalPOVM);
   (Anchor QRD.N_Q_Born, N_PER_RetinalPOVM);
   (Anchor QRD.N_Q_Decoherence, N_COMP_DecoherenceTc);
   (Anchor QRD.N_GR_Geodesic, N_PER_LightGeodesicBundle);
   (Anchor QRD.N_EX_Schwarzschild, N_COMP_SchwarzschildRadius);
   (Anchor QRD.N_EX_Schwarzschild, N_COMP_SchwarzschildRedshift);
   (Anchor QRD.N_EX_PhotonSphere, N_COMP_PhotonSphereImage);
   (Anchor QRD.N_BH_HawkingT, N_COMP_HawkingCriticalMass);
   (Anchor QRD.N_BR_SemiclassicalEFE, N_OPEN_QGMetricState);
   (Anchor QRD.N_BR_OpenQG, N_OPEN_QGMetricState);
   (N_INF_StateAsCarrier, N_PER_ObjectToLight);
   (N_INF_ChannelComposition, N_PER_ObjectToLight);
   (N_PER_ObjectToLight, N_PER_LightGeodesicBundle);
   (N_COMP_SchwarzschildRadius, N_COMP_SchwarzschildRedshift);
   (N_PER_LightGeodesicBundle, N_COMP_LensingAngle);
   (N_PER_LightGeodesicBundle, N_COMP_TimeDelay);
   (N_PER_LightGeodesicBundle, N_PER_RetinalPOVM);
   (N_PER_RetinalPOVM, N_PER_NeuralChannel);
   (N_INF_ChannelComposition, N_PER_NeuralChannel);
   (N_COMP_DecoherenceTc, N_COMP_CoherenceVisibility);
   (N_COMP_CoherenceVisibility, N_PER_Reconstruction);
   (N_PER_NeuralChannel, N_PER_Reconstruction);
   (N_INF_OperationalReality, N_PER_Reconstruction);
   (N_COMP_SchwarzschildRedshift, N_OUT_RealityChannelTheorem);
   (N_COMP_LensingAngle, N_OUT_RealityChannelTheorem);
   (N_COMP_TimeDelay, N_OUT_RealityChannelTheorem);
   (N_COMP_PhotonSphereImage, N_OPEN_InfoParadox);
   (N_COMP_HawkingCriticalMass, N_COMP_BH_CMBBoundary);
   (N_COMP_BH_CMBBoundary, N_OPEN_InfoParadox);
   (N_PER_Reconstruction, N_OUT_RealityChannelTheorem);
   (N_OUT_RealityChannelTheorem, N_OPEN_NeuralQuantumLimit);
   (N_OPEN_InfoParadox, N_OPEN_QGMetricState)].

Definition all_enhanced_edges : list (EnhancedNode * EnhancedNode) :=
  map (fun e =>
         match e with
         | (a,b) => (Anchor a, Anchor b)
         end) QRD.all_edges ++ new_edges.

End Quantum_Relativity_Perception_Extension.



(*
===============================================================================
String-theory readout extension
Anchor policy:
  This module does not import the whole of string theory.  It extracts only the
  readout layer that naturally continues the previous "reality-channel / open-QG
  thread": perception output, black-hole information, and quantum metric state.
===============================================================================
*)

Module Quantum_Relativity_String_Readout_Extension.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.
Module PER := Quantum_Relativity_Perception_Extension.

Inductive StringReadoutSector : Type :=
| SRS_Anchor
| SRS_TreddThread
| SRS_Worldsheet
| SRS_Consistency
| SRS_TargetSpace
| SRS_BraneHolography
| SRS_Compactification
| SRS_BlackHoleReadout
| SRS_ObservableReadout
| SRS_OpenBoundary.

Inductive StringReadoutStage : Type :=
| SRT_Anchored
| SRT_StringInput
| SRT_ConsistencyConstraint
| SRT_EffectiveGeometry
| SRT_ComputableReadout
| SRT_OpenProblem.

Inductive StringReadoutNode : Type :=
| AnchorP : PER.EnhancedNode -> StringReadoutNode

(* Explicit continuation of the user's previous thread / "tredd" node. *)
| N_TREDD_RealityQGThread

(* Minimal string input layer. *)
| N_STR_StringLengthAlphaPrime
| N_STR_WorldsheetSigma
| N_STR_PolyakovAction
| N_STR_QuantizedString
| N_STR_OpenClosedSectors
| N_STR_MassSpectrum

(* Consistency constraints that produce target-space equations. *)
| N_STR_ConformalInvariance
| N_STR_VirasoroConstraints
| N_STR_BetaFunctions
| N_STR_CriticalDimension
| N_STR_AnomalyCancellation

(* Target-space gravity readout. *)
| N_STR_TargetMetric
| N_STR_BFieldDilaton
| N_STR_LowEnergyEffectiveAction
| N_STR_BetaToEinstein
| N_STR_AlphaPrimeCorrection

(* Brane and holographic readout. *)
| N_STR_DBranes
| N_STR_OpenStringGaugeFields
| N_STR_AdSCFTDictionary
| N_STR_BulkBoundaryMap
| N_STR_EntanglementGeometry

(* Compactification and phenomenological readout. *)
| N_STR_CompactificationManifold
| N_STR_ModuliFields
| N_STR_EFTCouplings
| N_STR_ReadoutMassScales

(* Black-hole/information readout. *)
| N_STR_DbraneMicrostates
| N_STR_CardyEntropy
| N_STR_BlackHoleEntropyReadout
| N_STR_InfoRecoveryChannel

(* Final extracted outputs. *)
| N_STR_Readout_GEOM
| N_STR_Readout_SPECTRUM
| N_STR_Readout_ENTROPY
| N_STR_Readout_HOLOGRAPHY
| N_STR_Readout_CORRECTIONS
| N_STR_Final_StringReadoutTheorem
| N_STR_Open_LandscapeSelection
| N_STR_Open_FullQGCompletion.

Definition string_readout_sector (n : StringReadoutNode) : StringReadoutSector :=
  match n with
  | AnchorP _ => SRS_Anchor
  | N_TREDD_RealityQGThread => SRS_TreddThread
  | N_STR_StringLengthAlphaPrime => SRS_Worldsheet
  | N_STR_WorldsheetSigma => SRS_Worldsheet
  | N_STR_PolyakovAction => SRS_Worldsheet
  | N_STR_QuantizedString => SRS_Worldsheet
  | N_STR_OpenClosedSectors => SRS_Worldsheet
  | N_STR_MassSpectrum => SRS_ObservableReadout
  | N_STR_ConformalInvariance => SRS_Consistency
  | N_STR_VirasoroConstraints => SRS_Consistency
  | N_STR_BetaFunctions => SRS_Consistency
  | N_STR_CriticalDimension => SRS_Consistency
  | N_STR_AnomalyCancellation => SRS_Consistency
  | N_STR_TargetMetric => SRS_TargetSpace
  | N_STR_BFieldDilaton => SRS_TargetSpace
  | N_STR_LowEnergyEffectiveAction => SRS_TargetSpace
  | N_STR_BetaToEinstein => SRS_TargetSpace
  | N_STR_AlphaPrimeCorrection => SRS_TargetSpace
  | N_STR_DBranes => SRS_BraneHolography
  | N_STR_OpenStringGaugeFields => SRS_BraneHolography
  | N_STR_AdSCFTDictionary => SRS_BraneHolography
  | N_STR_BulkBoundaryMap => SRS_BraneHolography
  | N_STR_EntanglementGeometry => SRS_BraneHolography
  | N_STR_CompactificationManifold => SRS_Compactification
  | N_STR_ModuliFields => SRS_Compactification
  | N_STR_EFTCouplings => SRS_Compactification
  | N_STR_ReadoutMassScales => SRS_ObservableReadout
  | N_STR_DbraneMicrostates => SRS_BlackHoleReadout
  | N_STR_CardyEntropy => SRS_BlackHoleReadout
  | N_STR_BlackHoleEntropyReadout => SRS_BlackHoleReadout
  | N_STR_InfoRecoveryChannel => SRS_BlackHoleReadout
  | N_STR_Readout_GEOM => SRS_ObservableReadout
  | N_STR_Readout_SPECTRUM => SRS_ObservableReadout
  | N_STR_Readout_ENTROPY => SRS_ObservableReadout
  | N_STR_Readout_HOLOGRAPHY => SRS_ObservableReadout
  | N_STR_Readout_CORRECTIONS => SRS_ObservableReadout
  | N_STR_Final_StringReadoutTheorem => SRS_ObservableReadout
  | N_STR_Open_LandscapeSelection => SRS_OpenBoundary
  | N_STR_Open_FullQGCompletion => SRS_OpenBoundary
  end.

Definition string_readout_stage (n : StringReadoutNode) : StringReadoutStage :=
  match n with
  | AnchorP _ => SRT_Anchored
  | N_TREDD_RealityQGThread => SRT_Anchored
  | N_STR_StringLengthAlphaPrime => SRT_StringInput
  | N_STR_WorldsheetSigma => SRT_StringInput
  | N_STR_PolyakovAction => SRT_StringInput
  | N_STR_QuantizedString => SRT_StringInput
  | N_STR_OpenClosedSectors => SRT_StringInput
  | N_STR_MassSpectrum => SRT_ComputableReadout
  | N_STR_ConformalInvariance => SRT_ConsistencyConstraint
  | N_STR_VirasoroConstraints => SRT_ConsistencyConstraint
  | N_STR_BetaFunctions => SRT_ConsistencyConstraint
  | N_STR_CriticalDimension => SRT_ConsistencyConstraint
  | N_STR_AnomalyCancellation => SRT_ConsistencyConstraint
  | N_STR_TargetMetric => SRT_EffectiveGeometry
  | N_STR_BFieldDilaton => SRT_EffectiveGeometry
  | N_STR_LowEnergyEffectiveAction => SRT_EffectiveGeometry
  | N_STR_BetaToEinstein => SRT_EffectiveGeometry
  | N_STR_AlphaPrimeCorrection => SRT_ComputableReadout
  | N_STR_DBranes => SRT_StringInput
  | N_STR_OpenStringGaugeFields => SRT_ComputableReadout
  | N_STR_AdSCFTDictionary => SRT_ComputableReadout
  | N_STR_BulkBoundaryMap => SRT_ComputableReadout
  | N_STR_EntanglementGeometry => SRT_ComputableReadout
  | N_STR_CompactificationManifold => SRT_EffectiveGeometry
  | N_STR_ModuliFields => SRT_EffectiveGeometry
  | N_STR_EFTCouplings => SRT_ComputableReadout
  | N_STR_ReadoutMassScales => SRT_ComputableReadout
  | N_STR_DbraneMicrostates => SRT_ComputableReadout
  | N_STR_CardyEntropy => SRT_ComputableReadout
  | N_STR_BlackHoleEntropyReadout => SRT_ComputableReadout
  | N_STR_InfoRecoveryChannel => SRT_OpenProblem
  | N_STR_Readout_GEOM => SRT_ComputableReadout
  | N_STR_Readout_SPECTRUM => SRT_ComputableReadout
  | N_STR_Readout_ENTROPY => SRT_ComputableReadout
  | N_STR_Readout_HOLOGRAPHY => SRT_ComputableReadout
  | N_STR_Readout_CORRECTIONS => SRT_ComputableReadout
  | N_STR_Final_StringReadoutTheorem => SRT_ComputableReadout
  | N_STR_Open_LandscapeSelection => SRT_OpenProblem
  | N_STR_Open_FullQGCompletion => SRT_OpenProblem
  end.

(*
Core parameters for a readout layer.
The goal is not to postulate a complete string theory, but to specify what the
previous DAG can read from one: geometry, spectra, entropy, holographic maps,
and alpha-prime corrections.
*)
Parameter alpha_prime ell_s g_s : R.
Parameter worldsheet_action : QRD.Action.
Parameter target_metric_readout : QRD.TensorField.
Parameter bfield_dilaton_readout : QRD.TensorField.
Parameter string_readout_channel : QRD.Channel.
Parameter ads_cft_dictionary : QRD.Op -> QRD.Op.
Parameter bulk_state boundary_state : QRD.Op.
Parameter compactification_data : QRD.Config.
Parameter moduli_potential : R -> R.
Parameter beta_metric beta_bfield beta_dilaton : nat -> nat -> QRD.Point -> R.
Parameter alpha_prime_curvature_correction : R -> R -> R.
Parameter unitary_info_channel : QRD.Channel.

Definition string_length_from_alpha_prime : R :=
  QRD.sqrt alpha_prime.

Definition string_tension_natural_units : R :=
  1 / (2 * QRD.PI * alpha_prime).

Definition open_string_mass2 (N a : R) : R :=
  (N - a) / alpha_prime.

Definition closed_string_mass2 (N Nbar a : R) : R :=
  4 * (N + Nbar - 2 * a) / alpha_prime.

Definition closed_string_level_matching (N Nbar : R) : Prop :=
  N = Nbar.

Definition beta_metric_vanishes : Prop :=
  forall mu nu x, beta_metric mu nu x = 0.

Definition beta_bfield_vanishes : Prop :=
  forall mu nu x, beta_bfield mu nu x = 0.

Definition beta_dilaton_vanishes : Prop :=
  forall mu nu x, beta_dilaton mu nu x = 0.

Definition conformal_consistency : Prop :=
  beta_metric_vanishes /\ beta_bfield_vanishes /\ beta_dilaton_vanishes.

Definition leading_string_geometry_equation : Prop :=
  beta_metric_vanishes.

Definition string_corrected_lensing_angle (M b : R) : R :=
  4 * QRD.G * M / (QRD.c * QRD.c * b)
  + alpha_prime_curvature_correction M b.

Definition cardy_entropy (central_charge L0 : R) : R :=
  2 * QRD.PI * QRD.sqrt (central_charge * L0 / 6).

Definition left_right_cardy_entropy
  (cL cR L0 L0bar : R) : R :=
  2 * QRD.PI *
  (QRD.sqrt (cL * L0 / 6) + QRD.sqrt (cR * L0bar / 6)).

Definition holographic_readout (bulk : QRD.Op) : QRD.Op :=
  ads_cft_dictionary bulk.

Definition string_channel_readout (raw : QRD.Op) : QRD.Op :=
  QRD.chan string_readout_channel raw.

Definition information_recovery_readout (encoded : QRD.Op) : QRD.Op :=
  QRD.chan unitary_info_channel encoded.

Record StringReadoutPacket : Type := {
  readout_geometry_equation : Prop;
  readout_mass2_open : R;
  readout_mass2_closed : R;
  readout_entropy_cardy : R;
  readout_corrected_lensing : R;
  readout_boundary_state : QRD.Op
}.

Definition build_string_readout_packet
  (N Nbar a cL cR L0 L0bar M b : R)
  (bulk : QRD.Op) : StringReadoutPacket :=
  {|
    readout_geometry_equation := leading_string_geometry_equation;
    readout_mass2_open := open_string_mass2 N a;
    readout_mass2_closed := closed_string_mass2 N Nbar a;
    readout_entropy_cardy := left_right_cardy_entropy cL cR L0 L0bar;
    readout_corrected_lensing := string_corrected_lensing_angle M b;
    readout_boundary_state := holographic_readout bulk
  |}.

Theorem string_length_readout_is_alpha_prime_sqrt :
  string_length_from_alpha_prime = QRD.sqrt alpha_prime.
Proof. reflexivity. Qed.

Theorem string_tension_readout_formula :
  string_tension_natural_units = 1 / (2 * QRD.PI * alpha_prime).
Proof. reflexivity. Qed.

Theorem open_spectrum_readout_formula :
  forall N a : R,
    open_string_mass2 N a = (N - a) / alpha_prime.
Proof. intros; reflexivity. Qed.

Theorem closed_spectrum_readout_formula :
  forall N Nbar a : R,
    closed_string_mass2 N Nbar a =
    4 * (N + Nbar - 2 * a) / alpha_prime.
Proof. intros; reflexivity. Qed.

Theorem beta_readout_to_geometry_condition :
  conformal_consistency -> leading_string_geometry_equation.
Proof.
  intros H.
  unfold conformal_consistency in H.
  destruct H as [HG _].
  exact HG.
Qed.

Theorem holographic_readout_formula :
  forall bulk : QRD.Op,
    holographic_readout bulk = ads_cft_dictionary bulk.
Proof. intros; reflexivity. Qed.

Theorem string_corrected_lensing_formula :
  forall M b : R,
    string_corrected_lensing_angle M b =
    4 * QRD.G * M / (QRD.c * QRD.c * b)
    + alpha_prime_curvature_correction M b.
Proof. intros; reflexivity. Qed.

Inductive StringReadoutEdge : StringReadoutNode -> StringReadoutNode -> Prop :=

(* Only three anchors are allowed to feed the string readout thread. *)
| SRE_Tredd_From_OpenQG :
    StringReadoutEdge (AnchorP PER.N_OPEN_QGMetricState) N_TREDD_RealityQGThread
| SRE_Tredd_From_Info :
    StringReadoutEdge (AnchorP PER.N_OPEN_InfoParadox) N_TREDD_RealityQGThread
| SRE_Tredd_From_RealityChannel :
    StringReadoutEdge (AnchorP PER.N_OUT_RealityChannelTheorem) N_TREDD_RealityQGThread

(* Worldsheet input. *)
| SRE_Tredd_To_AlphaPrime :
    StringReadoutEdge N_TREDD_RealityQGThread N_STR_StringLengthAlphaPrime
| SRE_Tredd_To_Worldsheet :
    StringReadoutEdge N_TREDD_RealityQGThread N_STR_WorldsheetSigma
| SRE_AlphaPrime_To_Polyakov :
    StringReadoutEdge N_STR_StringLengthAlphaPrime N_STR_PolyakovAction
| SRE_Worldsheet_To_Polyakov :
    StringReadoutEdge N_STR_WorldsheetSigma N_STR_PolyakovAction
| SRE_Polyakov_To_Quantized :
    StringReadoutEdge N_STR_PolyakovAction N_STR_QuantizedString
| SRE_Quantized_To_OpenClosed :
    StringReadoutEdge N_STR_QuantizedString N_STR_OpenClosedSectors
| SRE_OpenClosed_To_Spectrum :
    StringReadoutEdge N_STR_OpenClosedSectors N_STR_MassSpectrum

(* Consistency layer. *)
| SRE_Quantized_To_Virasoro :
    StringReadoutEdge N_STR_QuantizedString N_STR_VirasoroConstraints
| SRE_Virasoro_To_Conformal :
    StringReadoutEdge N_STR_VirasoroConstraints N_STR_ConformalInvariance
| SRE_Conformal_To_Beta :
    StringReadoutEdge N_STR_ConformalInvariance N_STR_BetaFunctions
| SRE_Conformal_To_CriticalDim :
    StringReadoutEdge N_STR_ConformalInvariance N_STR_CriticalDimension
| SRE_CriticalDim_To_Anomaly :
    StringReadoutEdge N_STR_CriticalDimension N_STR_AnomalyCancellation

(* Geometry readout. *)
| SRE_Beta_To_TargetMetric :
    StringReadoutEdge N_STR_BetaFunctions N_STR_TargetMetric
| SRE_Beta_To_BDilaton :
    StringReadoutEdge N_STR_BetaFunctions N_STR_BFieldDilaton
| SRE_Target_To_EFT :
    StringReadoutEdge N_STR_TargetMetric N_STR_LowEnergyEffectiveAction
| SRE_BDilaton_To_EFT :
    StringReadoutEdge N_STR_BFieldDilaton N_STR_LowEnergyEffectiveAction
| SRE_EFT_To_BetaEinstein :
    StringReadoutEdge N_STR_LowEnergyEffectiveAction N_STR_BetaToEinstein
| SRE_EFT_To_AlphaCorrection :
    StringReadoutEdge N_STR_LowEnergyEffectiveAction N_STR_AlphaPrimeCorrection

(* Brane/holography layer. *)
| SRE_OpenClosed_To_DBranes :
    StringReadoutEdge N_STR_OpenClosedSectors N_STR_DBranes
| SRE_DBranes_To_Gauge :
    StringReadoutEdge N_STR_DBranes N_STR_OpenStringGaugeFields
| SRE_DBranes_To_AdSCFT :
    StringReadoutEdge N_STR_DBranes N_STR_AdSCFTDictionary
| SRE_AdSCFT_To_BulkBoundary :
    StringReadoutEdge N_STR_AdSCFTDictionary N_STR_BulkBoundaryMap
| SRE_BulkBoundary_To_Entanglement :
    StringReadoutEdge N_STR_BulkBoundaryMap N_STR_EntanglementGeometry

(* Compactification readout. *)
| SRE_EFT_To_Compactification :
    StringReadoutEdge N_STR_LowEnergyEffectiveAction N_STR_CompactificationManifold
| SRE_Compactification_To_Moduli :
    StringReadoutEdge N_STR_CompactificationManifold N_STR_ModuliFields
| SRE_Moduli_To_EFTCouplings :
    StringReadoutEdge N_STR_ModuliFields N_STR_EFTCouplings
| SRE_EFTCouplings_To_MassScales :
    StringReadoutEdge N_STR_EFTCouplings N_STR_ReadoutMassScales

(* Black-hole readout. *)
| SRE_DBranes_To_Microstates :
    StringReadoutEdge N_STR_DBranes N_STR_DbraneMicrostates
| SRE_Microstates_To_Cardy :
    StringReadoutEdge N_STR_DbraneMicrostates N_STR_CardyEntropy
| SRE_Cardy_To_BHEntropy :
    StringReadoutEdge N_STR_CardyEntropy N_STR_BlackHoleEntropyReadout
| SRE_BHEntropy_To_InfoRecovery :
    StringReadoutEdge N_STR_BlackHoleEntropyReadout N_STR_InfoRecoveryChannel

(* Final extracted readouts. *)
| SRE_BetaEinstein_To_ReadoutGEOM :
    StringReadoutEdge N_STR_BetaToEinstein N_STR_Readout_GEOM
| SRE_MassSpectrum_To_ReadoutSpectrum :
    StringReadoutEdge N_STR_MassSpectrum N_STR_Readout_SPECTRUM
| SRE_BHEntropy_To_ReadoutEntropy :
    StringReadoutEdge N_STR_BlackHoleEntropyReadout N_STR_Readout_ENTROPY
| SRE_BulkBoundary_To_ReadoutHolography :
    StringReadoutEdge N_STR_BulkBoundaryMap N_STR_Readout_HOLOGRAPHY
| SRE_AlphaCorrection_To_ReadoutCorrections :
    StringReadoutEdge N_STR_AlphaPrimeCorrection N_STR_Readout_CORRECTIONS

| SRE_ReadoutGEOM_To_Final :
    StringReadoutEdge N_STR_Readout_GEOM N_STR_Final_StringReadoutTheorem
| SRE_ReadoutSpectrum_To_Final :
    StringReadoutEdge N_STR_Readout_SPECTRUM N_STR_Final_StringReadoutTheorem
| SRE_ReadoutEntropy_To_Final :
    StringReadoutEdge N_STR_Readout_ENTROPY N_STR_Final_StringReadoutTheorem
| SRE_ReadoutHolography_To_Final :
    StringReadoutEdge N_STR_Readout_HOLOGRAPHY N_STR_Final_StringReadoutTheorem
| SRE_ReadoutCorrections_To_Final :
    StringReadoutEdge N_STR_Readout_CORRECTIONS N_STR_Final_StringReadoutTheorem

(* What remains open after the readout layer. *)
| SRE_Final_To_Landscape :
    StringReadoutEdge N_STR_Final_StringReadoutTheorem N_STR_Open_LandscapeSelection
| SRE_InfoRecovery_To_FullQG :
    StringReadoutEdge N_STR_InfoRecoveryChannel N_STR_Open_FullQGCompletion
| SRE_Landscape_To_FullQG :
    StringReadoutEdge N_STR_Open_LandscapeSelection N_STR_Open_FullQGCompletion.

Definition string_readout_rank (n : StringReadoutNode) : nat :=
  match n with
  | AnchorP _ => 0
  | N_TREDD_RealityQGThread => 10
  | N_STR_StringLengthAlphaPrime => 20
  | N_STR_WorldsheetSigma => 20
  | N_STR_PolyakovAction => 30
  | N_STR_QuantizedString => 40
  | N_STR_OpenClosedSectors => 50
  | N_STR_MassSpectrum => 60
  | N_STR_VirasoroConstraints => 50
  | N_STR_ConformalInvariance => 60
  | N_STR_BetaFunctions => 70
  | N_STR_CriticalDimension => 70
  | N_STR_AnomalyCancellation => 80
  | N_STR_TargetMetric => 80
  | N_STR_BFieldDilaton => 80
  | N_STR_LowEnergyEffectiveAction => 90
  | N_STR_BetaToEinstein => 100
  | N_STR_AlphaPrimeCorrection => 100
  | N_STR_DBranes => 60
  | N_STR_OpenStringGaugeFields => 70
  | N_STR_AdSCFTDictionary => 70
  | N_STR_BulkBoundaryMap => 80
  | N_STR_EntanglementGeometry => 90
  | N_STR_CompactificationManifold => 100
  | N_STR_ModuliFields => 110
  | N_STR_EFTCouplings => 120
  | N_STR_ReadoutMassScales => 130
  | N_STR_DbraneMicrostates => 70
  | N_STR_CardyEntropy => 80
  | N_STR_BlackHoleEntropyReadout => 90
  | N_STR_InfoRecoveryChannel => 100
  | N_STR_Readout_GEOM => 110
  | N_STR_Readout_SPECTRUM => 110
  | N_STR_Readout_ENTROPY => 110
  | N_STR_Readout_HOLOGRAPHY => 110
  | N_STR_Readout_CORRECTIONS => 110
  | N_STR_Final_StringReadoutTheorem => 140
  | N_STR_Open_LandscapeSelection => 150
  | N_STR_Open_FullQGCompletion => 160
  end.

Theorem string_readout_edge_rank :
  forall a b : StringReadoutNode,
    StringReadoutEdge a b -> (string_readout_rank a < string_readout_rank b)%nat.
Proof.
  intros a b H; inversion H; simpl; lia.
Qed.

Inductive StringReadoutPath : StringReadoutNode -> StringReadoutNode -> Prop :=
| SRPath_edge :
    forall a b,
      StringReadoutEdge a b -> StringReadoutPath a b
| SRPath_trans :
    forall a b c,
      StringReadoutEdge a b ->
      StringReadoutPath b c ->
      StringReadoutPath a c.

Theorem string_readout_path_rank :
  forall a b : StringReadoutNode,
    StringReadoutPath a b -> (string_readout_rank a < string_readout_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply string_readout_edge_rank; assumption.
  - apply Nat.lt_trans with (m := string_readout_rank b).
    + apply string_readout_edge_rank; assumption.
    + assumption.
Qed.

Theorem string_readout_dag_acyclic :
  forall n : StringReadoutNode, ~ StringReadoutPath n n.
Proof.
  intros n H.
  pose proof (string_readout_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

Definition string_readout_edges_as_pairs : list (StringReadoutNode * StringReadoutNode) :=
  [
   (AnchorP PER.N_OPEN_QGMetricState, N_TREDD_RealityQGThread);
   (AnchorP PER.N_OPEN_InfoParadox, N_TREDD_RealityQGThread);
   (AnchorP PER.N_OUT_RealityChannelTheorem, N_TREDD_RealityQGThread);
   (N_TREDD_RealityQGThread, N_STR_StringLengthAlphaPrime);
   (N_TREDD_RealityQGThread, N_STR_WorldsheetSigma);
   (N_STR_StringLengthAlphaPrime, N_STR_PolyakovAction);
   (N_STR_WorldsheetSigma, N_STR_PolyakovAction);
   (N_STR_PolyakovAction, N_STR_QuantizedString);
   (N_STR_QuantizedString, N_STR_OpenClosedSectors);
   (N_STR_OpenClosedSectors, N_STR_MassSpectrum);
   (N_STR_QuantizedString, N_STR_VirasoroConstraints);
   (N_STR_VirasoroConstraints, N_STR_ConformalInvariance);
   (N_STR_ConformalInvariance, N_STR_BetaFunctions);
   (N_STR_ConformalInvariance, N_STR_CriticalDimension);
   (N_STR_CriticalDimension, N_STR_AnomalyCancellation);
   (N_STR_BetaFunctions, N_STR_TargetMetric);
   (N_STR_BetaFunctions, N_STR_BFieldDilaton);
   (N_STR_TargetMetric, N_STR_LowEnergyEffectiveAction);
   (N_STR_BFieldDilaton, N_STR_LowEnergyEffectiveAction);
   (N_STR_LowEnergyEffectiveAction, N_STR_BetaToEinstein);
   (N_STR_LowEnergyEffectiveAction, N_STR_AlphaPrimeCorrection);
   (N_STR_OpenClosedSectors, N_STR_DBranes);
   (N_STR_DBranes, N_STR_OpenStringGaugeFields);
   (N_STR_DBranes, N_STR_AdSCFTDictionary);
   (N_STR_AdSCFTDictionary, N_STR_BulkBoundaryMap);
   (N_STR_BulkBoundaryMap, N_STR_EntanglementGeometry);
   (N_STR_LowEnergyEffectiveAction, N_STR_CompactificationManifold);
   (N_STR_CompactificationManifold, N_STR_ModuliFields);
   (N_STR_ModuliFields, N_STR_EFTCouplings);
   (N_STR_EFTCouplings, N_STR_ReadoutMassScales);
   (N_STR_DBranes, N_STR_DbraneMicrostates);
   (N_STR_DbraneMicrostates, N_STR_CardyEntropy);
   (N_STR_CardyEntropy, N_STR_BlackHoleEntropyReadout);
   (N_STR_BlackHoleEntropyReadout, N_STR_InfoRecoveryChannel);
   (N_STR_BetaToEinstein, N_STR_Readout_GEOM);
   (N_STR_MassSpectrum, N_STR_Readout_SPECTRUM);
   (N_STR_BlackHoleEntropyReadout, N_STR_Readout_ENTROPY);
   (N_STR_BulkBoundaryMap, N_STR_Readout_HOLOGRAPHY);
   (N_STR_AlphaPrimeCorrection, N_STR_Readout_CORRECTIONS);
   (N_STR_Readout_GEOM, N_STR_Final_StringReadoutTheorem);
   (N_STR_Readout_SPECTRUM, N_STR_Final_StringReadoutTheorem);
   (N_STR_Readout_ENTROPY, N_STR_Final_StringReadoutTheorem);
   (N_STR_Readout_HOLOGRAPHY, N_STR_Final_StringReadoutTheorem);
   (N_STR_Readout_CORRECTIONS, N_STR_Final_StringReadoutTheorem);
   (N_STR_Final_StringReadoutTheorem, N_STR_Open_LandscapeSelection);
   (N_STR_InfoRecoveryChannel, N_STR_Open_FullQGCompletion);
   (N_STR_Open_LandscapeSelection, N_STR_Open_FullQGCompletion)
  ].

End Quantum_Relativity_String_Readout_Extension.


(******************************************************************************)
(* String amplitude-bootstrap no-impact layer.                                 *)
(*                                                                            *)
(* This module is deliberately additive: it does not edit, rename, remove, or   *)
(* re-rank any constructor in [Quantum_Relativity_String_Readout_Extension].    *)
(* Existing string nodes enter only through [AnchorSTR].                        *)
(*                                                                            *)
(* Source citation embedded for traceability:                                  *)
(* Cheung, Remmen, Sciotti, Tarquini, "Strings from Almost Nothing",           *)
(* Phys. Rev. Lett. 136, 251601 (2026), DOI 10.1103/cw4p-cqh7.                *)
(* It is formalized here as a readout branch from scattering-amplitude          *)
(* consistency to Regge zeros, ultrasoft/minimal-zero constraints, and the      *)
(* Veneziano / Virasoro-Shapiro / five-point string-amplitude readouts.         *)
(******************************************************************************)

Module Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.
Module PER := Quantum_Relativity_Perception_Extension.
Module STR := Quantum_Relativity_String_Readout_Extension.

Inductive StringAmplitudeBootstrapSector : Type :=
| SABS_Anchor
| SABS_ScatteringBootstrap
| SABS_ReggeZeros
| SABS_Minimality
| SABS_StringAmplitudeReadout
| SABS_FivePointReadout
| SABS_NoImpactGuard.

Inductive StringAmplitudeBootstrapStage : Type :=
| SABT_Anchored
| SABT_BootstrapInput
| SABT_ReggeConstraint
| SABT_MinimalityAssumption
| SABT_UniquenessReadout
| SABT_LegacyPreservation.

Inductive StringAmplitudeBootstrapNode : Type :=
| AnchorSTR : STR.StringReadoutNode -> StringAmplitudeBootstrapNode

(* No-impact guard: old nodes remain only anchors inside this extension. *)
| N_SAB_LegacyNodesPreserved

(* Scattering-amplitude bootstrap branch. *)
| N_SAB_ScatteringBootstrap
| N_SAB_ReggeLimit
| N_SAB_ReggeResidueZeros
| N_SAB_UltrasoftRegge
| N_SAB_MinimalZeros
| N_SAB_LinearReggeSpectrum
| N_SAB_VenezianoUniqueness
| N_SAB_VirasoroShapiroUniqueness
| N_SAB_FivePointBootstrap
| N_SAB_StringAmplitudeBootstrapReadout.

Definition string_amp_bootstrap_sector
  (n : StringAmplitudeBootstrapNode) : StringAmplitudeBootstrapSector :=
  match n with
  | AnchorSTR _ => SABS_Anchor
  | N_SAB_LegacyNodesPreserved => SABS_NoImpactGuard
  | N_SAB_ScatteringBootstrap => SABS_ScatteringBootstrap
  | N_SAB_ReggeLimit => SABS_ScatteringBootstrap
  | N_SAB_ReggeResidueZeros => SABS_ReggeZeros
  | N_SAB_UltrasoftRegge => SABS_Minimality
  | N_SAB_MinimalZeros => SABS_Minimality
  | N_SAB_LinearReggeSpectrum => SABS_StringAmplitudeReadout
  | N_SAB_VenezianoUniqueness => SABS_StringAmplitudeReadout
  | N_SAB_VirasoroShapiroUniqueness => SABS_StringAmplitudeReadout
  | N_SAB_FivePointBootstrap => SABS_FivePointReadout
  | N_SAB_StringAmplitudeBootstrapReadout => SABS_StringAmplitudeReadout
  end.

Definition string_amp_bootstrap_stage
  (n : StringAmplitudeBootstrapNode) : StringAmplitudeBootstrapStage :=
  match n with
  | AnchorSTR _ => SABT_Anchored
  | N_SAB_LegacyNodesPreserved => SABT_LegacyPreservation
  | N_SAB_ScatteringBootstrap => SABT_BootstrapInput
  | N_SAB_ReggeLimit => SABT_ReggeConstraint
  | N_SAB_ReggeResidueZeros => SABT_ReggeConstraint
  | N_SAB_UltrasoftRegge => SABT_MinimalityAssumption
  | N_SAB_MinimalZeros => SABT_MinimalityAssumption
  | N_SAB_LinearReggeSpectrum => SABT_UniquenessReadout
  | N_SAB_VenezianoUniqueness => SABT_UniquenessReadout
  | N_SAB_VirasoroShapiroUniqueness => SABT_UniquenessReadout
  | N_SAB_FivePointBootstrap => SABT_UniquenessReadout
  | N_SAB_StringAmplitudeBootstrapReadout => SABT_UniquenessReadout
  end.

(* Abstract amplitude-bootstrap symbols.  They are parameters because this layer
   records the readout theorem-shape without claiming a constructive proof of
   the full physics inside Coq. *)
Parameter tree_level_four_point_consistency : Prop.
Parameter crossing_lorentz_unitarity_locality : Prop.
Parameter amplitude_ultrasoft_high_energy : Prop.
Parameter amplitude_minimal_zeros : Prop.

Parameter regge_alpha : R -> R.
Parameter mass2_level : nat -> R.
Parameter spin_level : nat -> R.
Parameter residue4 : nat -> R -> R.
Parameter residue5 : nat -> nat -> R -> R -> R -> R.

Parameter planar_veneziano_unique : Prop.
Parameter nonplanar_virasoro_shapiro_unique : Prop.
Parameter five_point_open_string_unique : Prop.

Definition F_SAB_ScatteringBootstrap : Prop :=
  tree_level_four_point_consistency /\
  crossing_lorentz_unitarity_locality.

Definition F_SAB_ReggeLimit : Prop :=
  forall n : nat,
    regge_alpha (mass2_level n) = spin_level n.

Definition F_SAB_ReggeResidueZeros : Prop :=
  forall (n r : nat) (t : R),
    t < 0 ->
    regge_alpha t + INR r = 0 ->
    residue4 n t = 0.

Definition F_SAB_UltrasoftRegge : Prop :=
  amplitude_ultrasoft_high_energy /\
  forall B : R,
    exists T : R,
      forall t : R, t < T -> regge_alpha t < B.

Definition F_SAB_MinimalZeros : Prop :=
  amplitude_minimal_zeros /\
  forall (n : nat) (t : R),
    residue4 n t = 0 ->
    exists r : nat,
      t < 0 /\ regge_alpha t + INR r = 0.

Definition F_SAB_LinearReggeSpectrum : Prop :=
  exists k : R,
    k <> 0 /\
    (forall n : nat, mass2_level n = k * spin_level n) /\
    (forall t : R, regge_alpha t = k * t).

Definition F_SAB_VenezianoUniqueness : Prop :=
  F_SAB_UltrasoftRegge /\
  F_SAB_MinimalZeros /\
  F_SAB_LinearReggeSpectrum ->
  planar_veneziano_unique.

Definition F_SAB_VirasoroShapiroUniqueness : Prop :=
  F_SAB_UltrasoftRegge /\
  F_SAB_MinimalZeros /\
  F_SAB_LinearReggeSpectrum ->
  nonplanar_virasoro_shapiro_unique.

Definition F_SAB_FivePointBootstrap : Prop :=
  forall (n1 n2 : nat) (a1 a2 a12 : R),
    -(a1 + a2 + a12) >= 1 ->
    a12 >= 0 ->
    residue5 n1 n2 a1 a2 a12 = 0.

Definition F_SAB_StringAmplitudeBootstrapReadout : Prop :=
  planar_veneziano_unique /\
  nonplanar_virasoro_shapiro_unique /\
  five_point_open_string_unique.

Definition F_SAB_LegacyNodesPreserved : Prop :=
  forall a b : STR.StringReadoutNode,
    AnchorSTR a = AnchorSTR b -> a = b.

Definition sab_formula_of (n : StringAmplitudeBootstrapNode) : Prop :=
  match n with
  | AnchorSTR _ => True
  | N_SAB_LegacyNodesPreserved => F_SAB_LegacyNodesPreserved
  | N_SAB_ScatteringBootstrap => F_SAB_ScatteringBootstrap
  | N_SAB_ReggeLimit => F_SAB_ReggeLimit
  | N_SAB_ReggeResidueZeros => F_SAB_ReggeResidueZeros
  | N_SAB_UltrasoftRegge => F_SAB_UltrasoftRegge
  | N_SAB_MinimalZeros => F_SAB_MinimalZeros
  | N_SAB_LinearReggeSpectrum => F_SAB_LinearReggeSpectrum
  | N_SAB_VenezianoUniqueness => F_SAB_VenezianoUniqueness
  | N_SAB_VirasoroShapiroUniqueness => F_SAB_VirasoroShapiroUniqueness
  | N_SAB_FivePointBootstrap => F_SAB_FivePointBootstrap
  | N_SAB_StringAmplitudeBootstrapReadout =>
      F_SAB_StringAmplitudeBootstrapReadout
  end.

Theorem sab_legacy_anchor_injective :
  F_SAB_LegacyNodesPreserved.
Proof.
  unfold F_SAB_LegacyNodesPreserved.
  intros a b H.
  inversion H.
  reflexivity.
Qed.

Theorem sab_planar_open_formula_shape :
  F_SAB_VenezianoUniqueness =
  (F_SAB_UltrasoftRegge /\
   F_SAB_MinimalZeros /\
   F_SAB_LinearReggeSpectrum ->
   planar_veneziano_unique).
Proof. reflexivity. Qed.

Theorem sab_nonplanar_closed_formula_shape :
  F_SAB_VirasoroShapiroUniqueness =
  (F_SAB_UltrasoftRegge /\
   F_SAB_MinimalZeros /\
   F_SAB_LinearReggeSpectrum ->
   nonplanar_virasoro_shapiro_unique).
Proof. reflexivity. Qed.

Inductive StringAmplitudeBootstrapEdge :
  StringAmplitudeBootstrapNode -> StringAmplitudeBootstrapNode -> Prop :=

(* Old graph enters as anchors only; no constructor in STR is modified. *)
| SABE_FinalString_To_LegacyGuard :
    StringAmplitudeBootstrapEdge
      (AnchorSTR STR.N_STR_Final_StringReadoutTheorem)
      N_SAB_LegacyNodesPreserved
| SABE_SMatrixAnchor_To_ScatteringBootstrap :
    StringAmplitudeBootstrapEdge
      (AnchorSTR (STR.AnchorP (PER.Anchor QRD.N_QFT_SMatrix)))
      N_SAB_ScatteringBootstrap
| SABE_MassSpectrum_To_ScatteringBootstrap :
    StringAmplitudeBootstrapEdge
      (AnchorSTR STR.N_STR_MassSpectrum)
      N_SAB_ScatteringBootstrap

(* Amplitude-bootstrap chain. *)
| SABE_ScatteringBootstrap_To_ReggeLimit :
    StringAmplitudeBootstrapEdge
      N_SAB_ScatteringBootstrap
      N_SAB_ReggeLimit
| SABE_ReggeLimit_To_ReggeZeros :
    StringAmplitudeBootstrapEdge
      N_SAB_ReggeLimit
      N_SAB_ReggeResidueZeros
| SABE_ReggeZeros_To_Ultrasoft :
    StringAmplitudeBootstrapEdge
      N_SAB_ReggeResidueZeros
      N_SAB_UltrasoftRegge
| SABE_ReggeZeros_To_MinimalZeros :
    StringAmplitudeBootstrapEdge
      N_SAB_ReggeResidueZeros
      N_SAB_MinimalZeros
| SABE_Ultrasoft_To_LinearRegge :
    StringAmplitudeBootstrapEdge
      N_SAB_UltrasoftRegge
      N_SAB_LinearReggeSpectrum
| SABE_MinimalZeros_To_LinearRegge :
    StringAmplitudeBootstrapEdge
      N_SAB_MinimalZeros
      N_SAB_LinearReggeSpectrum
| SABE_LinearRegge_To_Veneziano :
    StringAmplitudeBootstrapEdge
      N_SAB_LinearReggeSpectrum
      N_SAB_VenezianoUniqueness
| SABE_LinearRegge_To_VirasoroShapiro :
    StringAmplitudeBootstrapEdge
      N_SAB_LinearReggeSpectrum
      N_SAB_VirasoroShapiroUniqueness
| SABE_ReggeZeros_To_FivePoint :
    StringAmplitudeBootstrapEdge
      N_SAB_ReggeResidueZeros
      N_SAB_FivePointBootstrap
| SABE_Veneziano_To_StringAmpReadout :
    StringAmplitudeBootstrapEdge
      N_SAB_VenezianoUniqueness
      N_SAB_StringAmplitudeBootstrapReadout
| SABE_Virasoro_To_StringAmpReadout :
    StringAmplitudeBootstrapEdge
      N_SAB_VirasoroShapiroUniqueness
      N_SAB_StringAmplitudeBootstrapReadout
| SABE_FivePoint_To_StringAmpReadout :
    StringAmplitudeBootstrapEdge
      N_SAB_FivePointBootstrap
      N_SAB_StringAmplitudeBootstrapReadout

(* Optional sink back to the already-existing spectrum readout, still as an
   anchor in this no-impact layer rather than a new STR edge. *)
| SABE_StringAmpReadout_To_ExistingSpectrumReadout :
    StringAmplitudeBootstrapEdge
      N_SAB_StringAmplitudeBootstrapReadout
      (AnchorSTR STR.N_STR_Readout_SPECTRUM).

Definition string_amp_bootstrap_rank
  (n : StringAmplitudeBootstrapNode) : nat :=
  match n with
  | AnchorSTR s => (10 * STR.string_readout_rank s)%nat
  | N_SAB_LegacyNodesPreserved => 1450
  | N_SAB_ScatteringBootstrap => 610
  | N_SAB_ReggeLimit => 620
  | N_SAB_ReggeResidueZeros => 630
  | N_SAB_UltrasoftRegge => 640
  | N_SAB_MinimalZeros => 640
  | N_SAB_LinearReggeSpectrum => 650
  | N_SAB_VenezianoUniqueness => 700
  | N_SAB_VirasoroShapiroUniqueness => 700
  | N_SAB_FivePointBootstrap => 700
  | N_SAB_StringAmplitudeBootstrapReadout => 900
  end.

Theorem string_amp_bootstrap_edge_rank :
  forall a b : StringAmplitudeBootstrapNode,
    StringAmplitudeBootstrapEdge a b ->
    (string_amp_bootstrap_rank a < string_amp_bootstrap_rank b)%nat.
Proof.
  intros a b H; inversion H; simpl; lia.
Qed.

Inductive StringAmplitudeBootstrapPath :
  StringAmplitudeBootstrapNode -> StringAmplitudeBootstrapNode -> Prop :=
| SABPath_edge :
    forall a b,
      StringAmplitudeBootstrapEdge a b ->
      StringAmplitudeBootstrapPath a b
| SABPath_trans :
    forall a b c,
      StringAmplitudeBootstrapEdge a b ->
      StringAmplitudeBootstrapPath b c ->
      StringAmplitudeBootstrapPath a c.

Theorem string_amp_bootstrap_path_rank :
  forall a b : StringAmplitudeBootstrapNode,
    StringAmplitudeBootstrapPath a b ->
    (string_amp_bootstrap_rank a < string_amp_bootstrap_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply string_amp_bootstrap_edge_rank; assumption.
  - apply Nat.lt_trans with (m := string_amp_bootstrap_rank b).
    + apply string_amp_bootstrap_edge_rank; assumption.
    + assumption.
Qed.

Theorem string_amp_bootstrap_dag_acyclic :
  forall n : StringAmplitudeBootstrapNode,
    ~ StringAmplitudeBootstrapPath n n.
Proof.
  intros n H.
  pose proof (string_amp_bootstrap_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

Definition string_amp_bootstrap_edges_as_pairs :
  list (StringAmplitudeBootstrapNode * StringAmplitudeBootstrapNode) :=
  [
   (AnchorSTR STR.N_STR_Final_StringReadoutTheorem,
    N_SAB_LegacyNodesPreserved);
   (AnchorSTR (STR.AnchorP (PER.Anchor QRD.N_QFT_SMatrix)),
    N_SAB_ScatteringBootstrap);
   (AnchorSTR STR.N_STR_MassSpectrum,
    N_SAB_ScatteringBootstrap);
   (N_SAB_ScatteringBootstrap, N_SAB_ReggeLimit);
   (N_SAB_ReggeLimit, N_SAB_ReggeResidueZeros);
   (N_SAB_ReggeResidueZeros, N_SAB_UltrasoftRegge);
   (N_SAB_ReggeResidueZeros, N_SAB_MinimalZeros);
   (N_SAB_UltrasoftRegge, N_SAB_LinearReggeSpectrum);
   (N_SAB_MinimalZeros, N_SAB_LinearReggeSpectrum);
   (N_SAB_LinearReggeSpectrum, N_SAB_VenezianoUniqueness);
   (N_SAB_LinearReggeSpectrum, N_SAB_VirasoroShapiroUniqueness);
   (N_SAB_ReggeResidueZeros, N_SAB_FivePointBootstrap);
   (N_SAB_VenezianoUniqueness, N_SAB_StringAmplitudeBootstrapReadout);
   (N_SAB_VirasoroShapiroUniqueness, N_SAB_StringAmplitudeBootstrapReadout);
   (N_SAB_FivePointBootstrap, N_SAB_StringAmplitudeBootstrapReadout);
   (N_SAB_StringAmplitudeBootstrapReadout,
    AnchorSTR STR.N_STR_Readout_SPECTRUM)
  ].

End Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.



(******************************************************************************)
(* Closure / Connection layer.                                                 *)
(*                                                                            *)
(* This module DOES NOT remove or collapse earlier nodes.  Every earlier node   *)
(* remains available through [AnchorS].  The new layer only adds connecting     *)
(* morphisms that explain how the previous open nodes are closed *inside this   *)
(* formal readout model*.  These closure principles are formal hypotheses, not  *)
(* claims that the community's open quantum-gravity problems are solved.        *)
(******************************************************************************)

Module Quantum_Relativity_Readout_Closure_Extension.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.
Module PER := Quantum_Relativity_Perception_Extension.
Module STR := Quantum_Relativity_String_Readout_Extension.

Inductive ClosureSector : Type :=
| CLS_Anchor
| CLS_BlackHoleOptics
| CLS_NeuralInformation
| CLS_CrossDomainInvariant
| CLS_LandscapeClosure
| CLS_QGCompletion
| CLS_FinalReadout.

Inductive ClosureNode : Type :=
| AnchorS : STR.StringReadoutNode -> ClosureNode

(* Keep source nodes visible; these are not replacements for the anchors. *)
| N_CLS_SourceNodesRemainVisible

(* Black-hole optical readout: bending as a Jacobian on light data. *)
| N_CLS_BH_NullGeodesicBundle
| N_CLS_BH_OpticalJacobian
| N_CLS_BH_MagnificationReadout
| N_CLS_BH_RedshiftTimeReadout

(* Neural readout: bending as a Fisher/information channel. *)
| N_CLS_NeuralChannelKernel
| N_CLS_NeuralFisherMetric
| N_CLS_NeuralTimeWindow

(* Cross-domain bridge: both are the same kind of readout invariant. *)
| N_CLS_InformationVolumeRatio
| N_CLS_ReadoutJacobianInvariant
| N_CLS_TimeScaleInvariant
| N_CLS_CrossDomainEquals

(* Close landscape selection by the node-tree path. *)
| N_CLS_LandscapeScoreFunctional
| N_CLS_LandscapeAdmissibleSet
| N_CLS_SelectedVacuumReadout
| N_CLS_LandscapeSelectionClosed

(* Close full QG completion by demanding simultaneous recovery of the earlier
   quantum, GR, string, holographic, black-hole, and neural-channel readouts. *)
| N_CLS_QGStateSpace
| N_CLS_QGReadoutFunctor
| N_CLS_SemiclassicalRecovery
| N_CLS_StringRecovery
| N_CLS_ChannelRecovery
| N_CLS_FullQGCompletionClosed

(* Final connected theorem node.  The graph does not collapse old nodes; it
   adds an equality layer showing how their readouts can be compared. *)
| N_CLS_FinalConnectedReadoutTheorem.

Definition closure_sector (n : ClosureNode) : ClosureSector :=
  match n with
  | AnchorS _ => CLS_Anchor
  | N_CLS_SourceNodesRemainVisible => CLS_Anchor
  | N_CLS_BH_NullGeodesicBundle => CLS_BlackHoleOptics
  | N_CLS_BH_OpticalJacobian => CLS_BlackHoleOptics
  | N_CLS_BH_MagnificationReadout => CLS_BlackHoleOptics
  | N_CLS_BH_RedshiftTimeReadout => CLS_BlackHoleOptics
  | N_CLS_NeuralChannelKernel => CLS_NeuralInformation
  | N_CLS_NeuralFisherMetric => CLS_NeuralInformation
  | N_CLS_NeuralTimeWindow => CLS_NeuralInformation
  | N_CLS_InformationVolumeRatio => CLS_CrossDomainInvariant
  | N_CLS_ReadoutJacobianInvariant => CLS_CrossDomainInvariant
  | N_CLS_TimeScaleInvariant => CLS_CrossDomainInvariant
  | N_CLS_CrossDomainEquals => CLS_CrossDomainInvariant
  | N_CLS_LandscapeScoreFunctional => CLS_LandscapeClosure
  | N_CLS_LandscapeAdmissibleSet => CLS_LandscapeClosure
  | N_CLS_SelectedVacuumReadout => CLS_LandscapeClosure
  | N_CLS_LandscapeSelectionClosed => CLS_LandscapeClosure
  | N_CLS_QGStateSpace => CLS_QGCompletion
  | N_CLS_QGReadoutFunctor => CLS_QGCompletion
  | N_CLS_SemiclassicalRecovery => CLS_QGCompletion
  | N_CLS_StringRecovery => CLS_QGCompletion
  | N_CLS_ChannelRecovery => CLS_QGCompletion
  | N_CLS_FullQGCompletionClosed => CLS_QGCompletion
  | N_CLS_FinalConnectedReadoutTheorem => CLS_FinalReadout
  end.

Definition closure_rank (n : ClosureNode) : nat :=
  match n with
  | AnchorS _ => 0
  | N_CLS_SourceNodesRemainVisible => 5
  | N_CLS_BH_NullGeodesicBundle => 10
  | N_CLS_BH_OpticalJacobian => 20
  | N_CLS_BH_MagnificationReadout => 30
  | N_CLS_BH_RedshiftTimeReadout => 30
  | N_CLS_NeuralChannelKernel => 10
  | N_CLS_NeuralFisherMetric => 20
  | N_CLS_NeuralTimeWindow => 20
  | N_CLS_InformationVolumeRatio => 40
  | N_CLS_ReadoutJacobianInvariant => 50
  | N_CLS_TimeScaleInvariant => 50
  | N_CLS_CrossDomainEquals => 60
  | N_CLS_LandscapeScoreFunctional => 20
  | N_CLS_LandscapeAdmissibleSet => 30
  | N_CLS_SelectedVacuumReadout => 40
  | N_CLS_LandscapeSelectionClosed => 70
  | N_CLS_QGStateSpace => 20
  | N_CLS_QGReadoutFunctor => 30
  | N_CLS_SemiclassicalRecovery => 40
  | N_CLS_StringRecovery => 40
  | N_CLS_ChannelRecovery => 40
  | N_CLS_FullQGCompletionClosed => 80
  | N_CLS_FinalConnectedReadoutTheorem => 100
  end.

Inductive ClosureEdge : ClosureNode -> ClosureNode -> Prop :=
| CE_KeepSources :
    ClosureEdge
      (AnchorS STR.N_STR_Final_StringReadoutTheorem)
      N_CLS_SourceNodesRemainVisible

(* Black-hole optical branch: old GR/black-hole anchors remain as sources. *)
| CE_GRGeodesic_To_BHBundle :
    ClosureEdge
      (AnchorS (STR.AnchorP (PER.Anchor QRD.N_GR_Geodesic)))
      N_CLS_BH_NullGeodesicBundle
| CE_Schwarzschild_To_BHBundle :
    ClosureEdge
      (AnchorS (STR.AnchorP (PER.Anchor QRD.N_EX_Schwarzschild)))
      N_CLS_BH_NullGeodesicBundle
| CE_PhotonSphere_To_BHBundle :
    ClosureEdge
      (AnchorS (STR.AnchorP (PER.Anchor QRD.N_EX_PhotonSphere)))
      N_CLS_BH_NullGeodesicBundle
| CE_BHBundle_To_Jacobian :
    ClosureEdge N_CLS_BH_NullGeodesicBundle N_CLS_BH_OpticalJacobian
| CE_Jacobian_To_Magnification :
    ClosureEdge N_CLS_BH_OpticalJacobian N_CLS_BH_MagnificationReadout
| CE_Schwarzschild_To_RedshiftTime :
    ClosureEdge
      (AnchorS (STR.AnchorP PER.N_COMP_SchwarzschildRedshift))
      N_CLS_BH_RedshiftTimeReadout

(* Neural branch: earlier neural-channel nodes remain as sources. *)
| CE_NeuralAnchor_To_Kernel :
    ClosureEdge
      (AnchorS (STR.AnchorP PER.N_PER_NeuralChannel))
      N_CLS_NeuralChannelKernel
| CE_RetinaAnchor_To_Kernel :
    ClosureEdge
      (AnchorS (STR.AnchorP PER.N_PER_RetinalPOVM))
      N_CLS_NeuralChannelKernel
| CE_Kernel_To_Fisher :
    ClosureEdge N_CLS_NeuralChannelKernel N_CLS_NeuralFisherMetric
| CE_TcAnchor_To_TimeWindow :
    ClosureEdge
      (AnchorS (STR.AnchorP PER.N_COMP_DecoherenceTc))
      N_CLS_NeuralTimeWindow

(* Cross-domain invariant branch. *)
| CE_BHMag_To_InfoVolume :
    ClosureEdge N_CLS_BH_MagnificationReadout N_CLS_InformationVolumeRatio
| CE_NeuralFisher_To_InfoVolume :
    ClosureEdge N_CLS_NeuralFisherMetric N_CLS_InformationVolumeRatio
| CE_InfoVolume_To_JacInvariant :
    ClosureEdge N_CLS_InformationVolumeRatio N_CLS_ReadoutJacobianInvariant
| CE_BHRedshift_To_TimeInvariant :
    ClosureEdge N_CLS_BH_RedshiftTimeReadout N_CLS_TimeScaleInvariant
| CE_NeuralTime_To_TimeInvariant :
    ClosureEdge N_CLS_NeuralTimeWindow N_CLS_TimeScaleInvariant
| CE_JacInvariant_To_CrossEquals :
    ClosureEdge N_CLS_ReadoutJacobianInvariant N_CLS_CrossDomainEquals
| CE_TimeInvariant_To_CrossEquals :
    ClosureEdge N_CLS_TimeScaleInvariant N_CLS_CrossDomainEquals

(* Landscape closure branch. *)
| CE_OpenLandscape_To_Score :
    ClosureEdge
      (AnchorS STR.N_STR_Open_LandscapeSelection)
      N_CLS_LandscapeScoreFunctional
| CE_Score_To_Admissible :
    ClosureEdge N_CLS_LandscapeScoreFunctional N_CLS_LandscapeAdmissibleSet
| CE_Admissible_To_Selected :
    ClosureEdge N_CLS_LandscapeAdmissibleSet N_CLS_SelectedVacuumReadout
| CE_Selected_To_LandscapeClosed :
    ClosureEdge N_CLS_SelectedVacuumReadout N_CLS_LandscapeSelectionClosed

(* Full QG completion branch. *)
| CE_OpenFullQG_To_QGState :
    ClosureEdge
      (AnchorS STR.N_STR_Open_FullQGCompletion)
      N_CLS_QGStateSpace
| CE_QGState_To_Functor :
    ClosureEdge N_CLS_QGStateSpace N_CLS_QGReadoutFunctor
| CE_Functor_To_Semiclassical :
    ClosureEdge N_CLS_QGReadoutFunctor N_CLS_SemiclassicalRecovery
| CE_Functor_To_String :
    ClosureEdge N_CLS_QGReadoutFunctor N_CLS_StringRecovery
| CE_Functor_To_Channel :
    ClosureEdge N_CLS_QGReadoutFunctor N_CLS_ChannelRecovery
| CE_Semi_To_FullClosed :
    ClosureEdge N_CLS_SemiclassicalRecovery N_CLS_FullQGCompletionClosed
| CE_String_To_FullClosed :
    ClosureEdge N_CLS_StringRecovery N_CLS_FullQGCompletionClosed
| CE_Channel_To_FullClosed :
    ClosureEdge N_CLS_ChannelRecovery N_CLS_FullQGCompletionClosed

(* Final connected theorem: original nodes remain visible, new layer connects. *)
| CE_Sources_To_Final :
    ClosureEdge N_CLS_SourceNodesRemainVisible N_CLS_FinalConnectedReadoutTheorem
| CE_CrossEquals_To_Final :
    ClosureEdge N_CLS_CrossDomainEquals N_CLS_FinalConnectedReadoutTheorem
| CE_LandscapeClosed_To_Final :
    ClosureEdge N_CLS_LandscapeSelectionClosed N_CLS_FinalConnectedReadoutTheorem
| CE_FullQGClosed_To_Final :
    ClosureEdge N_CLS_FullQGCompletionClosed N_CLS_FinalConnectedReadoutTheorem.

Theorem closure_edge_rank :
  forall a b : ClosureNode,
    ClosureEdge a b -> (closure_rank a < closure_rank b)%nat.
Proof.
  intros a b H; inversion H; simpl; lia.
Qed.

Inductive ClosurePath : ClosureNode -> ClosureNode -> Prop :=
| CP_edge :
    forall a b : ClosureNode,
      ClosureEdge a b -> ClosurePath a b
| CP_trans :
    forall a b c : ClosureNode,
      ClosurePath a b -> ClosurePath b c -> ClosurePath a c.

Theorem closure_path_rank :
  forall a b : ClosureNode,
    ClosurePath a b -> (closure_rank a < closure_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply closure_edge_rank; exact H.
  - eapply Nat.lt_trans; eauto.
Qed.

Theorem closure_dag_acyclic :
  forall n : ClosureNode, ~ ClosurePath n n.
Proof.
  intros n H.
  pose proof (closure_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

(******************************************************************************)
(* Cross-domain readout mathematics.                                           *)
(******************************************************************************)

(* The new cross-domain scalar is an information-volume Jacobian.
   It does not claim that black holes and brains are the same object.
   It says their readout distortion becomes comparable after both are mapped
   into the geometry of distinguishability. *)

Definition information_volume_ratio (det_in det_out : R) : R :=
  QRD.sqrt (det_out / det_in).

Definition optical_information_jacobian (detA : R) : R :=
  QRD.Rabs detA.

Definition neural_information_jacobian (detF_in detF_out : R) : R :=
  information_volume_ratio detF_in detF_out.

Definition readout_jacobian_bridge
  (detA detF_in detF_out : R) : Prop :=
  optical_information_jacobian detA =
  neural_information_jacobian detF_in detF_out.

(* Point-mass lens readout.  Let u = theta/theta_E.  The two-dimensional
   lensing Jacobian determinant is det A = 1 - u^{-4}. *)
Definition point_lens_detA (u : R) : R :=
  1 - 1 / (u * u * u * u).

Definition point_lens_information_jacobian (u : R) : R :=
  optical_information_jacobian (point_lens_detA u).

Definition point_lens_magnification (u : R) : R :=
  1 / point_lens_information_jacobian u.

Definition matched_neural_fisher_det
  (detF_in u : R) : R :=
  detF_in *
  point_lens_information_jacobian u *
  point_lens_information_jacobian u.

Theorem cross_domain_jacobian_secret :
  forall detA detF_in detF_out : R,
    readout_jacobian_bridge detA detF_in detF_out ->
    QRD.Rabs detA = QRD.sqrt (detF_out / detF_in).
Proof.
  intros detA detF_in detF_out H.
  exact H.
Qed.

Theorem matched_neural_det_formula :
  forall detF_in u : R,
    matched_neural_fisher_det detF_in u =
    detF_in *
    point_lens_information_jacobian u *
    point_lens_information_jacobian u.
Proof. reflexivity. Qed.

(* Time-scale bridge.  Black-hole redshift and neural integration are not
   identified as mechanisms; they are compared as ratios of readout clock rate. *)

Definition blackhole_time_readout_ratio (M r : R) : R :=
  1 / QRD.sqrt (1 - PER.schwarzschild_radius M / r).

Definition neural_time_readout_ratio (Tc_in Tc_out : R) : R :=
  Tc_out / Tc_in.

Definition readout_time_bridge
  (M r Tc_in Tc_out : R) : Prop :=
  blackhole_time_readout_ratio M r =
  neural_time_readout_ratio Tc_in Tc_out.

Theorem cross_domain_time_secret :
  forall M r Tc_in Tc_out : R,
    readout_time_bridge M r Tc_in Tc_out ->
    1 / QRD.sqrt (1 - PER.schwarzschild_radius M / r) =
    Tc_out / Tc_in.
Proof.
  intros M r Tc_in Tc_out H.
  exact H.
Qed.

(******************************************************************************)
(* Landscape and full-QG closure as node-tree closure hypotheses.              *)
(******************************************************************************)

Parameter Vacuum QGState ObservationData : Type.
Parameter selected_vacuum : Vacuum.
Parameter completed_qg_state : QGState.
Parameter present_observations : ObservationData.

Parameter vacuum_score : Vacuum -> ObservationData -> R.
Parameter landscape_admissible : Vacuum -> Prop.
Parameter observation_compatible : Vacuum -> ObservationData -> Prop.

Parameter recovers_quantum_readout : QGState -> Prop.
Parameter recovers_gr_readout : QGState -> Prop.
Parameter recovers_string_readout : QGState -> Prop.
Parameter recovers_holographic_readout : QGState -> Prop.
Parameter recovers_blackhole_readout : QGState -> Prop.
Parameter recovers_neural_channel_readout : QGState -> Prop.
Parameter has_unitary_boundary_readout : QGState -> Prop.

Definition landscape_selection_closed_by_tree : Prop :=
  landscape_admissible selected_vacuum /\
  observation_compatible selected_vacuum present_observations /\
  forall v : Vacuum,
    landscape_admissible v ->
    observation_compatible v present_observations ->
    vacuum_score selected_vacuum present_observations >=
    vacuum_score v present_observations.

Definition full_qg_completion_closed_by_tree : Prop :=
  recovers_quantum_readout completed_qg_state /\
  recovers_gr_readout completed_qg_state /\
  recovers_string_readout completed_qg_state /\
  recovers_holographic_readout completed_qg_state /\
  recovers_blackhole_readout completed_qg_state /\
  recovers_neural_channel_readout completed_qg_state /\
  has_unitary_boundary_readout completed_qg_state.

Definition connected_readout_closure : Prop :=
  landscape_selection_closed_by_tree /\
  full_qg_completion_closed_by_tree /\
  forall detA detF_in detF_out : R,
    readout_jacobian_bridge detA detF_in detF_out ->
    QRD.Rabs detA = QRD.sqrt (detF_out / detF_in).

Theorem landscape_selection_is_closed_in_this_readout :
  connected_readout_closure -> landscape_selection_closed_by_tree.
Proof.
  intro H; destruct H as [HL _]; exact HL.
Qed.

Theorem full_qg_completion_is_closed_in_this_readout :
  connected_readout_closure -> full_qg_completion_closed_by_tree.
Proof.
  intro H; destruct H as [_ [HQ _]]; exact HQ.
Qed.

Theorem final_connected_readout_secret :
  connected_readout_closure ->
  landscape_selection_closed_by_tree /\
  full_qg_completion_closed_by_tree.
Proof.
  intro H.
  split.
  - apply landscape_selection_is_closed_in_this_readout; exact H.
  - apply full_qg_completion_is_closed_in_this_readout; exact H.
Qed.

Definition closure_edges_as_pairs : list (ClosureNode * ClosureNode) :=
  [
   (AnchorS STR.N_STR_Final_StringReadoutTheorem, N_CLS_SourceNodesRemainVisible);

   (AnchorS (STR.AnchorP (PER.Anchor QRD.N_GR_Geodesic)), N_CLS_BH_NullGeodesicBundle);
   (AnchorS (STR.AnchorP (PER.Anchor QRD.N_EX_Schwarzschild)), N_CLS_BH_NullGeodesicBundle);
   (AnchorS (STR.AnchorP (PER.Anchor QRD.N_EX_PhotonSphere)), N_CLS_BH_NullGeodesicBundle);
   (N_CLS_BH_NullGeodesicBundle, N_CLS_BH_OpticalJacobian);
   (N_CLS_BH_OpticalJacobian, N_CLS_BH_MagnificationReadout);
   (AnchorS (STR.AnchorP PER.N_COMP_SchwarzschildRedshift), N_CLS_BH_RedshiftTimeReadout);

   (AnchorS (STR.AnchorP PER.N_PER_NeuralChannel), N_CLS_NeuralChannelKernel);
   (AnchorS (STR.AnchorP PER.N_PER_RetinalPOVM), N_CLS_NeuralChannelKernel);
   (N_CLS_NeuralChannelKernel, N_CLS_NeuralFisherMetric);
   (AnchorS (STR.AnchorP PER.N_COMP_DecoherenceTc), N_CLS_NeuralTimeWindow);

   (N_CLS_BH_MagnificationReadout, N_CLS_InformationVolumeRatio);
   (N_CLS_NeuralFisherMetric, N_CLS_InformationVolumeRatio);
   (N_CLS_InformationVolumeRatio, N_CLS_ReadoutJacobianInvariant);
   (N_CLS_BH_RedshiftTimeReadout, N_CLS_TimeScaleInvariant);
   (N_CLS_NeuralTimeWindow, N_CLS_TimeScaleInvariant);
   (N_CLS_ReadoutJacobianInvariant, N_CLS_CrossDomainEquals);
   (N_CLS_TimeScaleInvariant, N_CLS_CrossDomainEquals);

   (AnchorS STR.N_STR_Open_LandscapeSelection, N_CLS_LandscapeScoreFunctional);
   (N_CLS_LandscapeScoreFunctional, N_CLS_LandscapeAdmissibleSet);
   (N_CLS_LandscapeAdmissibleSet, N_CLS_SelectedVacuumReadout);
   (N_CLS_SelectedVacuumReadout, N_CLS_LandscapeSelectionClosed);

   (AnchorS STR.N_STR_Open_FullQGCompletion, N_CLS_QGStateSpace);
   (N_CLS_QGStateSpace, N_CLS_QGReadoutFunctor);
   (N_CLS_QGReadoutFunctor, N_CLS_SemiclassicalRecovery);
   (N_CLS_QGReadoutFunctor, N_CLS_StringRecovery);
   (N_CLS_QGReadoutFunctor, N_CLS_ChannelRecovery);
   (N_CLS_SemiclassicalRecovery, N_CLS_FullQGCompletionClosed);
   (N_CLS_StringRecovery, N_CLS_FullQGCompletionClosed);
   (N_CLS_ChannelRecovery, N_CLS_FullQGCompletionClosed);

   (N_CLS_SourceNodesRemainVisible, N_CLS_FinalConnectedReadoutTheorem);
   (N_CLS_CrossDomainEquals, N_CLS_FinalConnectedReadoutTheorem);
   (N_CLS_LandscapeSelectionClosed, N_CLS_FinalConnectedReadoutTheorem);
   (N_CLS_FullQGCompletionClosed, N_CLS_FinalConnectedReadoutTheorem)
  ].

End Quantum_Relativity_Readout_Closure_Extension.

(******************************************************************************)
(* Mass-free visual black-hole extension.                                      *)
(*                                                                            *)
(* No-impact rule:                                                            *)
(* - The earlier Schwarzschild/mass-generated branch is kept untouched.        *)
(* - This module adds a parallel horizon-generated branch.                     *)
(* - Old nodes remain visible as anchors; the new branch does not collapse     *)
(*   them into a single replacement node.                                      *)
(******************************************************************************)

Module Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.
Module PER := Quantum_Relativity_Perception_Extension.
Module STR := Quantum_Relativity_String_Readout_Extension.
Module CLS := Quantum_Relativity_Readout_Closure_Extension.

Inductive MFVSector : Type :=
| MFV_Anchor
| MFV_VisiblePhoton
| MFV_OpticalShadow
| MFV_CausalHorizon
| MFV_GeneratorShift
| MFV_FinalReadout.

Inductive MFVStage : Type :=
| MFV_AnchoredOriginal
| MFV_DeclaredFormula
| MFV_ComputableScale
| MFV_BoundaryCondition
| MFV_FinalFormula.

Inductive MFVNode : Type :=
| AnchorC : CLS.ClosureNode -> MFVNode

(* Visible-light anchor. *)
| N_MFV_VisiblePhotonWavelength
| N_MFV_VisualPhotonEnergy

(* Optical shadow scale. *)
| N_MFV_VisualShadowScale
| N_MFV_CriticalImpactShadow

(* Mass-free horizon scale and metric condition. *)
| N_MFV_MassFreeMetricHorizon
| N_MFV_MassFreeHorizonScale

(* Trapping-horizon condition. *)
| N_MFV_TrappingHorizonCondition

(* Explicit generator shift: mass is not the horizon generator in this branch. *)
| N_MFV_MassRemovedAsGenerator
| N_MFV_HorizonGeneratedByOpticalCausalTrapping

(* Final readout. *)
| N_MFV_MassFreeVisualBlackHole.

Definition mfv_sector (n : MFVNode) : MFVSector :=
  match n with
  | AnchorC _ => MFV_Anchor
  | N_MFV_VisiblePhotonWavelength => MFV_VisiblePhoton
  | N_MFV_VisualPhotonEnergy => MFV_VisiblePhoton
  | N_MFV_VisualShadowScale => MFV_OpticalShadow
  | N_MFV_CriticalImpactShadow => MFV_OpticalShadow
  | N_MFV_MassFreeMetricHorizon => MFV_CausalHorizon
  | N_MFV_MassFreeHorizonScale => MFV_CausalHorizon
  | N_MFV_TrappingHorizonCondition => MFV_CausalHorizon
  | N_MFV_MassRemovedAsGenerator => MFV_GeneratorShift
  | N_MFV_HorizonGeneratedByOpticalCausalTrapping => MFV_GeneratorShift
  | N_MFV_MassFreeVisualBlackHole => MFV_FinalReadout
  end.

Definition mfv_stage (n : MFVNode) : MFVStage :=
  match n with
  | AnchorC _ => MFV_AnchoredOriginal
  | N_MFV_VisiblePhotonWavelength => MFV_ComputableScale
  | N_MFV_VisualPhotonEnergy => MFV_ComputableScale
  | N_MFV_VisualShadowScale => MFV_ComputableScale
  | N_MFV_CriticalImpactShadow => MFV_ComputableScale
  | N_MFV_MassFreeMetricHorizon => MFV_BoundaryCondition
  | N_MFV_MassFreeHorizonScale => MFV_ComputableScale
  | N_MFV_TrappingHorizonCondition => MFV_BoundaryCondition
  | N_MFV_MassRemovedAsGenerator => MFV_DeclaredFormula
  | N_MFV_HorizonGeneratedByOpticalCausalTrapping => MFV_BoundaryCondition
  | N_MFV_MassFreeVisualBlackHole => MFV_FinalFormula
  end.

(******************************************************************************)
(* New symbols.                                                                *)
(******************************************************************************)

Parameter lambda_vis : R.
Parameter photon_frequency_vis photon_energy_vis : R.

Parameter D_shadow_visual bcrit_visual : R.
Parameter rH_visual0 DH_visual0 r_ph_visual0 : R.

(* Generic static optical metric function.  This replaces the old move
   M -> r_s by a direct horizon condition F_psi(r_H) = 0. *)
Parameter F_psi dF_psi d_r2_over_F_psi : R -> R.

(* Null expansion data for a future outer trapping horizon. *)
Parameter theta_plus theta_minus Lminus_theta_plus : R.

(* The branch may set a visual mass parameter to zero, but it does not feed
   that zero into the Schwarzschild radius formula. *)
Parameter M_visual0 : R.
Parameter mass_is_not_horizon_generator : Prop.
Parameter horizon_generated_by_optical_causal_trapping : Prop.

(******************************************************************************)
(* Formula layer.                                                              *)
(******************************************************************************)

Definition F_MFV_VisiblePhotonWavelength : Prop :=
  lambda_vis > 0.

Definition F_MFV_VisualPhotonEnergy : Prop :=
  photon_frequency_vis = QRD.c / lambda_vis /\
  photon_energy_vis = QRD.hbar * 2 * QRD.PI * photon_frequency_vis.

Definition F_MFV_VisualShadowScale : Prop :=
  D_shadow_visual = lambda_vis.

Definition F_MFV_CriticalImpactShadow : Prop :=
  D_shadow_visual = 2 * bcrit_visual.

Definition F_MFV_MassFreeMetricHorizon : Prop :=
  F_psi rH_visual0 = 0 /\
  dF_psi rH_visual0 > 0 /\
  d_r2_over_F_psi r_ph_visual0 = 0 /\
  bcrit_visual = r_ph_visual0 / QRD.sqrt (F_psi r_ph_visual0).

Definition F_MFV_MassFreeHorizonScale : Prop :=
  rH_visual0 = lambda_vis / (3 * QRD.sqrt 3) /\
  DH_visual0 = 2 * lambda_vis / (3 * QRD.sqrt 3).

Definition F_MFV_TrappingHorizonCondition : Prop :=
  theta_plus = 0 /\
  theta_minus < 0 /\
  Lminus_theta_plus < 0.

Definition F_MFV_MassRemovedAsGenerator : Prop :=
  M_visual0 = 0 /\
  mass_is_not_horizon_generator.

Definition F_MFV_HorizonGeneratedByOpticalCausalTrapping : Prop :=
  horizon_generated_by_optical_causal_trapping /\
  F_MFV_MassFreeMetricHorizon /\
  F_MFV_TrappingHorizonCondition.

Definition F_MFV_MassFreeVisualBlackHole : Prop :=
  F_MFV_VisiblePhotonWavelength /\
  F_MFV_VisualShadowScale /\
  F_MFV_CriticalImpactShadow /\
  F_MFV_MassFreeHorizonScale /\
  F_MFV_HorizonGeneratedByOpticalCausalTrapping /\
  F_MFV_MassRemovedAsGenerator.

Definition mfv_formula_of (n : MFVNode) : Prop :=
  match n with
  | AnchorC c => True
  | N_MFV_VisiblePhotonWavelength => F_MFV_VisiblePhotonWavelength
  | N_MFV_VisualPhotonEnergy => F_MFV_VisualPhotonEnergy
  | N_MFV_VisualShadowScale => F_MFV_VisualShadowScale
  | N_MFV_CriticalImpactShadow => F_MFV_CriticalImpactShadow
  | N_MFV_MassFreeMetricHorizon => F_MFV_MassFreeMetricHorizon
  | N_MFV_MassFreeHorizonScale => F_MFV_MassFreeHorizonScale
  | N_MFV_TrappingHorizonCondition => F_MFV_TrappingHorizonCondition
  | N_MFV_MassRemovedAsGenerator => F_MFV_MassRemovedAsGenerator
  | N_MFV_HorizonGeneratedByOpticalCausalTrapping =>
      F_MFV_HorizonGeneratedByOpticalCausalTrapping
  | N_MFV_MassFreeVisualBlackHole => F_MFV_MassFreeVisualBlackHole
  end.

(******************************************************************************)
(* DAG layer.                                                                  *)
(******************************************************************************)

Definition mfv_rank (n : MFVNode) : nat :=
  match n with
  | AnchorC c => CLS.closure_rank c
  | N_MFV_VisiblePhotonWavelength => 110
  | N_MFV_VisualPhotonEnergy => 115
  | N_MFV_VisualShadowScale => 120
  | N_MFV_CriticalImpactShadow => 125
  | N_MFV_MassFreeMetricHorizon => 130
  | N_MFV_MassFreeHorizonScale => 135
  | N_MFV_TrappingHorizonCondition => 135
  | N_MFV_MassRemovedAsGenerator => 140
  | N_MFV_HorizonGeneratedByOpticalCausalTrapping => 145
  | N_MFV_MassFreeVisualBlackHole => 150
  end.

Inductive MFVEdge : MFVNode -> MFVNode -> Prop :=
(* Preserve all closure edges as anchored old structure. *)
| MFVE_Anchor : forall a b : CLS.ClosureNode,
    CLS.ClosureEdge a b ->
    MFVEdge (AnchorC a) (AnchorC b)

(* Visible photon and perception anchors. *)
| MFVE_ObjectToLight_To_VisibleLambda :
    MFVEdge
      (AnchorC (CLS.AnchorS (STR.AnchorP PER.N_PER_ObjectToLight)))
      N_MFV_VisiblePhotonWavelength
| MFVE_VisibleLambda_To_PhotonEnergy :
    MFVEdge
      N_MFV_VisiblePhotonWavelength
      N_MFV_VisualPhotonEnergy

(* Light geodesics and photon-sphere image remain visible as sources. *)
| MFVE_LightBundle_To_Trapping :
    MFVEdge
      (AnchorC (CLS.AnchorS (STR.AnchorP PER.N_PER_LightGeodesicBundle)))
      N_MFV_TrappingHorizonCondition
| MFVE_PhotonSphereImage_To_ShadowScale :
    MFVEdge
      (AnchorC (CLS.AnchorS (STR.AnchorP PER.N_COMP_PhotonSphereImage)))
      N_MFV_VisualShadowScale
| MFVE_ClosureBHBundle_To_Trapping :
    MFVEdge
      (AnchorC CLS.N_CLS_BH_NullGeodesicBundle)
      N_MFV_TrappingHorizonCondition

(* The new branch uses visual shadow scale, not mass, to set the horizon scale. *)
| MFVE_VisibleLambda_To_ShadowScale :
    MFVEdge
      N_MFV_VisiblePhotonWavelength
      N_MFV_VisualShadowScale
| MFVE_ShadowScale_To_CriticalImpact :
    MFVEdge
      N_MFV_VisualShadowScale
      N_MFV_CriticalImpactShadow
| MFVE_CriticalImpact_To_MetricHorizon :
    MFVEdge
      N_MFV_CriticalImpactShadow
      N_MFV_MassFreeMetricHorizon
| MFVE_ShadowScale_To_HorizonScale :
    MFVEdge
      N_MFV_VisualShadowScale
      N_MFV_MassFreeHorizonScale

(* Explicitly separate the new horizon generator from Schwarzschild mass. *)
| MFVE_MetricHorizon_To_OpticalCausalGenerator :
    MFVEdge
      N_MFV_MassFreeMetricHorizon
      N_MFV_HorizonGeneratedByOpticalCausalTrapping
| MFVE_Trapping_To_OpticalCausalGenerator :
    MFVEdge
      N_MFV_TrappingHorizonCondition
      N_MFV_HorizonGeneratedByOpticalCausalTrapping
| MFVE_MassRemoved_To_FinalBH :
    MFVEdge
      N_MFV_MassRemovedAsGenerator
      N_MFV_MassFreeVisualBlackHole
| MFVE_HorizonScale_To_FinalBH :
    MFVEdge
      N_MFV_MassFreeHorizonScale
      N_MFV_MassFreeVisualBlackHole
| MFVE_OpticalCausalGenerator_To_FinalBH :
    MFVEdge
      N_MFV_HorizonGeneratedByOpticalCausalTrapping
      N_MFV_MassFreeVisualBlackHole

(* Final readout connects after the earlier cross-domain closure, without
   rewriting the old closure theorem. *)
| MFVE_CrossDomainEquals_To_FinalBH :
    MFVEdge
      (AnchorC CLS.N_CLS_CrossDomainEquals)
      N_MFV_MassFreeVisualBlackHole.

Definition mfv_edges_as_pairs : list (MFVNode * MFVNode) :=
  [
    ((AnchorC (CLS.AnchorS (STR.AnchorP PER.N_PER_ObjectToLight))),
      N_MFV_VisiblePhotonWavelength);
    (N_MFV_VisiblePhotonWavelength, N_MFV_VisualPhotonEnergy);

    ((AnchorC (CLS.AnchorS (STR.AnchorP PER.N_PER_LightGeodesicBundle))),
      N_MFV_TrappingHorizonCondition);
    ((AnchorC (CLS.AnchorS (STR.AnchorP PER.N_COMP_PhotonSphereImage))),
      N_MFV_VisualShadowScale);
    ((AnchorC CLS.N_CLS_BH_NullGeodesicBundle),
      N_MFV_TrappingHorizonCondition);

    (N_MFV_VisiblePhotonWavelength, N_MFV_VisualShadowScale);
    (N_MFV_VisualShadowScale, N_MFV_CriticalImpactShadow);
    (N_MFV_CriticalImpactShadow, N_MFV_MassFreeMetricHorizon);
    (N_MFV_VisualShadowScale, N_MFV_MassFreeHorizonScale);

    (N_MFV_MassFreeMetricHorizon,
      N_MFV_HorizonGeneratedByOpticalCausalTrapping);
    (N_MFV_TrappingHorizonCondition,
      N_MFV_HorizonGeneratedByOpticalCausalTrapping);
    (N_MFV_MassRemovedAsGenerator,
      N_MFV_MassFreeVisualBlackHole);
    (N_MFV_MassFreeHorizonScale,
      N_MFV_MassFreeVisualBlackHole);
    (N_MFV_HorizonGeneratedByOpticalCausalTrapping,
      N_MFV_MassFreeVisualBlackHole);
    ((AnchorC CLS.N_CLS_CrossDomainEquals),
      N_MFV_MassFreeVisualBlackHole)
  ].

Theorem mfv_edge_rank :
  forall a b : MFVNode,
    MFVEdge a b -> (mfv_rank a < mfv_rank b)%nat.
Proof.
  intros a b H.
  destruct H; simpl; try lia.
  apply CLS.closure_edge_rank; exact H.
Qed.

Inductive MFVPath : MFVNode -> MFVNode -> Prop :=
| MFVP_edge :
    forall a b : MFVNode,
      MFVEdge a b -> MFVPath a b
| MFVP_trans :
    forall a b c : MFVNode,
      MFVPath a b -> MFVPath b c -> MFVPath a c.

Theorem mfv_path_rank :
  forall a b : MFVNode,
    MFVPath a b -> (mfv_rank a < mfv_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply mfv_edge_rank; exact H.
  - eapply Nat.lt_trans; eauto.
Qed.

Theorem mfv_dag_acyclic :
  forall n : MFVNode, ~ MFVPath n n.
Proof.
  intros n H.
  pose proof (mfv_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

(******************************************************************************)
(* Readout theorems: these are formula extractions, not empirical claims.       *)
(******************************************************************************)

Theorem mass_free_visual_shadow_readout :
  F_MFV_MassFreeVisualBlackHole ->
  D_shadow_visual = lambda_vis.
Proof.
  intro H.
  destruct H as [_ [Hshadow _]].
  exact Hshadow.
Qed.

Theorem mass_free_visual_horizon_scale_readout :
  F_MFV_MassFreeVisualBlackHole ->
  rH_visual0 = lambda_vis / (3 * QRD.sqrt 3) /\
  DH_visual0 = 2 * lambda_vis / (3 * QRD.sqrt 3).
Proof.
  intro H.
  destruct H as [_ [_ [_ [Hscale _]]]].
  exact Hscale.
Qed.

Theorem mass_removed_is_not_generator_readout :
  F_MFV_MassFreeVisualBlackHole ->
  M_visual0 = 0 /\ mass_is_not_horizon_generator.
Proof.
  intro H.
  destruct H as [_ [_ [_ [_ [_ Hmass]]]]].
  exact Hmass.
Qed.

Theorem optical_causal_trapping_generates_horizon_readout :
  F_MFV_MassFreeVisualBlackHole ->
  horizon_generated_by_optical_causal_trapping /\
  F_MFV_MassFreeMetricHorizon /\
  F_MFV_TrappingHorizonCondition.
Proof.
  intro H.
  destruct H as [_ [_ [_ [_ [Hgen _]]]]].
  exact Hgen.
Qed.

Theorem final_mass_free_visual_bh_secret :
  F_MFV_MassFreeVisualBlackHole ->
  D_shadow_visual = lambda_vis /\
  rH_visual0 = lambda_vis / (3 * QRD.sqrt 3) /\
  DH_visual0 = 2 * lambda_vis / (3 * QRD.sqrt 3) /\
  M_visual0 = 0 /\
  mass_is_not_horizon_generator.
Proof.
  intro H.
  split.
  - apply mass_free_visual_shadow_readout; exact H.
  - split.
    + pose proof (mass_free_visual_horizon_scale_readout H) as HS.
      destruct HS as [Hr _]. exact Hr.
    + split.
      * pose proof (mass_free_visual_horizon_scale_readout H) as HS.
        destruct HS as [_ Hd]. exact Hd.
      * apply mass_removed_is_not_generator_readout; exact H.
Qed.

End Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.


(*
===============================================================================
Cognitive rhythm / auditory / Earth-field Occam extension
Anchor policy:
  This module does not rewrite the mass-free visual-BH branch.  It treats that
  branch as the visual anchor, then adds an auditory frequency anchor, a
  cognitive-frame anchor, and an external Earth-field rhythm anchor.  The Occam
  gate prevents the new Earth-field node from becoming a causal generator of
  mind.  It remains a boundary condition / rhythm-matching readout only.

Empirical-note anchors used by the formulas below:
  - visual photopic anchor: lambda_vis already carried by the MFV branch;
  - auditory anchor: 3000 Hz as a compact speech/sensitivity-band readout;
  - cognitive-frame anchor: 0.6 s as a frame/event integration scale;
  - Earth-field anchor: Schumann fundamental approximated as 7.83 Hz.
These are readout constants, not proofs that perception is a literal black hole
or that Earth resonance generates consciousness.
===============================================================================
*)

Module Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.
Module PER := Quantum_Relativity_Perception_Extension.
Module STR := Quantum_Relativity_String_Readout_Extension.
Module CLS := Quantum_Relativity_Readout_Closure_Extension.
Module MFV := Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.

Inductive CognitiveSector : Type :=
| COG_Anchor
| COG_VisualAnchor
| COG_AuditoryAnchor
| COG_FrameAnchor
| COG_EarthBoundary
| COG_CycleReadout
| COG_OccamGate
| COG_FinalReadout.

Inductive CognitiveStage : Type :=
| COG_AnchoredOriginal
| COG_EmpiricalAnchor
| COG_ComputableRatio
| COG_BoundaryCondition
| COG_OccamFiltered
| COG_FinalFormula.

Inductive CognitiveNode : Type :=
| AnchorM : MFV.MFVNode -> CognitiveNode

(* Visual anchor inherited from the mass-free visual-BH branch. *)
| N_COG_VisualShadowAnchor

(* Ear branch: frequency-first, not wavelength-first. *)
| N_COG_AuditoryFrequencyAnchor

(* Mind/cognition branch: frame-time, not photon-cycle time. *)
| N_COG_CognitiveFrame_060s

(* External rhythm branch: Schumann fundamental as boundary condition only. *)
| N_COG_SchumannEarthBoundary

(* Ratio readouts. *)
| N_COG_VisualCyclesPerFrame
| N_COG_AuditoryCyclesPerFrame
| N_COG_EarthCyclesPerFrame

(* Occam filter: prevents overclaiming external rhythm as generator of mind. *)
| N_COG_OccamBoundaryGate

(* Consolidated multi-scale readout. *)
| N_COG_MultiscalePerceptionFrame
| N_COG_FinalCognitiveRhythmReadout.

Definition cognitive_sector (n : CognitiveNode) : CognitiveSector :=
  match n with
  | AnchorM _ => COG_Anchor
  | N_COG_VisualShadowAnchor => COG_VisualAnchor
  | N_COG_AuditoryFrequencyAnchor => COG_AuditoryAnchor
  | N_COG_CognitiveFrame_060s => COG_FrameAnchor
  | N_COG_SchumannEarthBoundary => COG_EarthBoundary
  | N_COG_VisualCyclesPerFrame => COG_CycleReadout
  | N_COG_AuditoryCyclesPerFrame => COG_CycleReadout
  | N_COG_EarthCyclesPerFrame => COG_CycleReadout
  | N_COG_OccamBoundaryGate => COG_OccamGate
  | N_COG_MultiscalePerceptionFrame => COG_FinalReadout
  | N_COG_FinalCognitiveRhythmReadout => COG_FinalReadout
  end.

Definition cognitive_stage (n : CognitiveNode) : CognitiveStage :=
  match n with
  | AnchorM _ => COG_AnchoredOriginal
  | N_COG_VisualShadowAnchor => COG_EmpiricalAnchor
  | N_COG_AuditoryFrequencyAnchor => COG_EmpiricalAnchor
  | N_COG_CognitiveFrame_060s => COG_EmpiricalAnchor
  | N_COG_SchumannEarthBoundary => COG_BoundaryCondition
  | N_COG_VisualCyclesPerFrame => COG_ComputableRatio
  | N_COG_AuditoryCyclesPerFrame => COG_ComputableRatio
  | N_COG_EarthCyclesPerFrame => COG_ComputableRatio
  | N_COG_OccamBoundaryGate => COG_OccamFiltered
  | N_COG_MultiscalePerceptionFrame => COG_FinalFormula
  | N_COG_FinalCognitiveRhythmReadout => COG_FinalFormula
  end.

(******************************************************************************)
(* Constants and symbols.                                                       *)
(******************************************************************************)

Definition auditory_pubmed_anchor_hz : R := 3000.
Definition cognitive_frame_nominal_s : R := 6 / 10.
Definition schumann_fundamental_hz : R := 783 / 100.

Parameter f_aud_anchor : R.
Parameter T_aud_cycle : R.
Parameter v_sound : R.
Parameter lambda_sound_anchor : R.

Parameter T_psi_frame : R.
Parameter f_psi_frame : R.

Parameter f_earth_schumann : R.
Parameter T_earth_schumann : R.
Parameter R_psi_earth : R.

Parameter N_visual_cycles_per_frame : R.
Parameter N_auditory_cycles_per_frame : R.

Parameter earth_field_boundary_condition : Prop.
Parameter earth_rhythm_is_mind_generator : Prop.
Parameter occam_rejects_earth_as_generator : Prop.
Parameter multiscale_perception_frame : Prop.

(******************************************************************************)
(* Formula layer.                                                              *)
(******************************************************************************)

Definition F_COG_VisualShadowAnchor : Prop :=
  MFV.D_shadow_visual = MFV.lambda_vis.

Definition F_COG_AuditoryFrequencyAnchor : Prop :=
  f_aud_anchor = auditory_pubmed_anchor_hz /\
  T_aud_cycle = / f_aud_anchor /\
  lambda_sound_anchor = v_sound / f_aud_anchor.

Definition F_COG_CognitiveFrame_060s : Prop :=
  T_psi_frame = cognitive_frame_nominal_s /\
  f_psi_frame = / T_psi_frame.

Definition F_COG_SchumannEarthBoundary : Prop :=
  f_earth_schumann = schumann_fundamental_hz /\
  T_earth_schumann = / f_earth_schumann /\
  earth_field_boundary_condition.

Definition F_COG_VisualCyclesPerFrame : Prop :=
  N_visual_cycles_per_frame = QRD.c * T_psi_frame / MFV.lambda_vis.

Definition F_COG_AuditoryCyclesPerFrame : Prop :=
  N_auditory_cycles_per_frame = f_aud_anchor * T_psi_frame.

Definition F_COG_EarthCyclesPerFrame : Prop :=
  R_psi_earth = f_earth_schumann * T_psi_frame.

Definition F_COG_OccamBoundaryGate : Prop :=
  earth_field_boundary_condition /\
  occam_rejects_earth_as_generator /\
  ~ earth_rhythm_is_mind_generator.

Definition F_COG_MultiscalePerceptionFrame : Prop :=
  F_COG_VisualShadowAnchor /\
  F_COG_AuditoryFrequencyAnchor /\
  F_COG_CognitiveFrame_060s /\
  F_COG_SchumannEarthBoundary /\
  F_COG_VisualCyclesPerFrame /\
  F_COG_AuditoryCyclesPerFrame /\
  F_COG_EarthCyclesPerFrame /\
  F_COG_OccamBoundaryGate /\
  multiscale_perception_frame.

Definition F_COG_FinalCognitiveRhythmReadout : Prop :=
  F_COG_MultiscalePerceptionFrame /\
  MFV.F_MFV_MassFreeVisualBlackHole.

Definition cognitive_formula_of (n : CognitiveNode) : Prop :=
  match n with
  | AnchorM m => MFV.mfv_formula_of m
  | N_COG_VisualShadowAnchor => F_COG_VisualShadowAnchor
  | N_COG_AuditoryFrequencyAnchor => F_COG_AuditoryFrequencyAnchor
  | N_COG_CognitiveFrame_060s => F_COG_CognitiveFrame_060s
  | N_COG_SchumannEarthBoundary => F_COG_SchumannEarthBoundary
  | N_COG_VisualCyclesPerFrame => F_COG_VisualCyclesPerFrame
  | N_COG_AuditoryCyclesPerFrame => F_COG_AuditoryCyclesPerFrame
  | N_COG_EarthCyclesPerFrame => F_COG_EarthCyclesPerFrame
  | N_COG_OccamBoundaryGate => F_COG_OccamBoundaryGate
  | N_COG_MultiscalePerceptionFrame => F_COG_MultiscalePerceptionFrame
  | N_COG_FinalCognitiveRhythmReadout => F_COG_FinalCognitiveRhythmReadout
  end.

(******************************************************************************)
(* DAG layer.                                                                  *)
(******************************************************************************)

Definition cognitive_rank (n : CognitiveNode) : nat :=
  match n with
  | AnchorM m => MFV.mfv_rank m
  | N_COG_VisualShadowAnchor => 160
  | N_COG_AuditoryFrequencyAnchor => 160
  | N_COG_CognitiveFrame_060s => 160
  | N_COG_SchumannEarthBoundary => 160
  | N_COG_VisualCyclesPerFrame => 170
  | N_COG_AuditoryCyclesPerFrame => 170
  | N_COG_EarthCyclesPerFrame => 170
  | N_COG_OccamBoundaryGate => 180
  | N_COG_MultiscalePerceptionFrame => 190
  | N_COG_FinalCognitiveRhythmReadout => 200
  end.

Inductive CognitiveEdge : CognitiveNode -> CognitiveNode -> Prop :=
(* Preserve all previous MFV edges as anchored old structure. *)
| COGE_Anchor : forall a b : MFV.MFVNode,
    MFV.MFVEdge a b ->
    CognitiveEdge (AnchorM a) (AnchorM b)

(* Visual line: old mass-free visual-BH branch remains the anchor. *)
| COGE_MFVFinal_To_VisualAnchor :
    CognitiveEdge
      (AnchorM MFV.N_MFV_MassFreeVisualBlackHole)
      N_COG_VisualShadowAnchor
| COGE_MFVLambda_To_VisualAnchor :
    CognitiveEdge
      (AnchorM MFV.N_MFV_VisiblePhotonWavelength)
      N_COG_VisualShadowAnchor
| COGE_VisualAnchor_To_VisualCycles :
    CognitiveEdge N_COG_VisualShadowAnchor N_COG_VisualCyclesPerFrame

(* Ear line: add frequency-first auditory readout without changing the retina branch. *)
| COGE_NeuralChannel_To_AuditoryAnchor :
    CognitiveEdge
      (AnchorM (MFV.AnchorC (CLS.AnchorS (STR.AnchorP PER.N_PER_NeuralChannel))))
      N_COG_AuditoryFrequencyAnchor
| COGE_AuditoryAnchor_To_AuditoryCycles :
    CognitiveEdge N_COG_AuditoryFrequencyAnchor N_COG_AuditoryCyclesPerFrame

(* Cognitive frame: attach to the old neural time-window node. *)
| COGE_NeuralTimeWindow_To_Frame060 :
    CognitiveEdge
      (AnchorM (MFV.AnchorC CLS.N_CLS_NeuralTimeWindow))
      N_COG_CognitiveFrame_060s
| COGE_Frame_To_VisualCycles :
    CognitiveEdge N_COG_CognitiveFrame_060s N_COG_VisualCyclesPerFrame
| COGE_Frame_To_AuditoryCycles :
    CognitiveEdge N_COG_CognitiveFrame_060s N_COG_AuditoryCyclesPerFrame

(* Earth-field rhythm is introduced only as an external boundary condition. *)
| COGE_Frame_To_EarthCycles :
    CognitiveEdge N_COG_CognitiveFrame_060s N_COG_EarthCyclesPerFrame
| COGE_Schumann_To_EarthCycles :
    CognitiveEdge N_COG_SchumannEarthBoundary N_COG_EarthCyclesPerFrame

(* Occam gate receives the ratios and the external boundary, then filters claims. *)
| COGE_VisualCycles_To_Occam :
    CognitiveEdge N_COG_VisualCyclesPerFrame N_COG_OccamBoundaryGate
| COGE_AuditoryCycles_To_Occam :
    CognitiveEdge N_COG_AuditoryCyclesPerFrame N_COG_OccamBoundaryGate
| COGE_EarthCycles_To_Occam :
    CognitiveEdge N_COG_EarthCyclesPerFrame N_COG_OccamBoundaryGate
| COGE_Schumann_To_Occam :
    CognitiveEdge N_COG_SchumannEarthBoundary N_COG_OccamBoundaryGate

(* Final consolidation. *)
| COGE_Occam_To_MultiscaleFrame :
    CognitiveEdge N_COG_OccamBoundaryGate N_COG_MultiscalePerceptionFrame
| COGE_VisualCycles_To_MultiscaleFrame :
    CognitiveEdge N_COG_VisualCyclesPerFrame N_COG_MultiscalePerceptionFrame
| COGE_AuditoryCycles_To_MultiscaleFrame :
    CognitiveEdge N_COG_AuditoryCyclesPerFrame N_COG_MultiscalePerceptionFrame
| COGE_EarthCycles_To_MultiscaleFrame :
    CognitiveEdge N_COG_EarthCyclesPerFrame N_COG_MultiscalePerceptionFrame
| COGE_MultiscaleFrame_To_Final :
    CognitiveEdge N_COG_MultiscalePerceptionFrame N_COG_FinalCognitiveRhythmReadout
| COGE_MFVFinal_To_Final :
    CognitiveEdge
      (AnchorM MFV.N_MFV_MassFreeVisualBlackHole)
      N_COG_FinalCognitiveRhythmReadout.

Definition cognitive_edges_as_pairs : list (CognitiveNode * CognitiveNode) :=
  [
    ((AnchorM MFV.N_MFV_MassFreeVisualBlackHole), N_COG_VisualShadowAnchor);
    ((AnchorM MFV.N_MFV_VisiblePhotonWavelength), N_COG_VisualShadowAnchor);
    (N_COG_VisualShadowAnchor, N_COG_VisualCyclesPerFrame);

    ((AnchorM (MFV.AnchorC (CLS.AnchorS (STR.AnchorP PER.N_PER_NeuralChannel)))),
      N_COG_AuditoryFrequencyAnchor);
    (N_COG_AuditoryFrequencyAnchor, N_COG_AuditoryCyclesPerFrame);

    ((AnchorM (MFV.AnchorC CLS.N_CLS_NeuralTimeWindow)),
      N_COG_CognitiveFrame_060s);
    (N_COG_CognitiveFrame_060s, N_COG_VisualCyclesPerFrame);
    (N_COG_CognitiveFrame_060s, N_COG_AuditoryCyclesPerFrame);
    (N_COG_CognitiveFrame_060s, N_COG_EarthCyclesPerFrame);
    (N_COG_SchumannEarthBoundary, N_COG_EarthCyclesPerFrame);

    (N_COG_VisualCyclesPerFrame, N_COG_OccamBoundaryGate);
    (N_COG_AuditoryCyclesPerFrame, N_COG_OccamBoundaryGate);
    (N_COG_EarthCyclesPerFrame, N_COG_OccamBoundaryGate);
    (N_COG_SchumannEarthBoundary, N_COG_OccamBoundaryGate);

    (N_COG_OccamBoundaryGate, N_COG_MultiscalePerceptionFrame);
    (N_COG_VisualCyclesPerFrame, N_COG_MultiscalePerceptionFrame);
    (N_COG_AuditoryCyclesPerFrame, N_COG_MultiscalePerceptionFrame);
    (N_COG_EarthCyclesPerFrame, N_COG_MultiscalePerceptionFrame);
    (N_COG_MultiscalePerceptionFrame, N_COG_FinalCognitiveRhythmReadout);
    ((AnchorM MFV.N_MFV_MassFreeVisualBlackHole), N_COG_FinalCognitiveRhythmReadout)
  ].

Inductive CognitivePath : CognitiveNode -> CognitiveNode -> Prop :=
| COGP_edge :
    forall a b : CognitiveNode,
      CognitiveEdge a b -> CognitivePath a b
| COGP_trans :
    forall a b c : CognitiveNode,
      CognitivePath a b -> CognitivePath b c -> CognitivePath a c.

Theorem cognitive_edge_rank :
  forall a b : CognitiveNode,
    CognitiveEdge a b -> (cognitive_rank a < cognitive_rank b)%nat.
Proof.
  intros a b H.
  destruct H; simpl; try lia.
  apply MFV.mfv_edge_rank; exact H.
Qed.

Theorem cognitive_path_rank :
  forall a b : CognitiveNode,
    CognitivePath a b -> (cognitive_rank a < cognitive_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply cognitive_edge_rank; exact H.
  - eapply Nat.lt_trans; eauto.
Qed.

Theorem cognitive_dag_acyclic :
  forall n : CognitiveNode, ~ CognitivePath n n.
Proof.
  intros n H.
  pose proof (cognitive_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

(******************************************************************************)
(* Readout theorems: formula extractions only; no empirical closure claimed.    *)
(******************************************************************************)

Theorem cognitive_frame_060s_readout :
  F_COG_CognitiveFrame_060s ->
  T_psi_frame = cognitive_frame_nominal_s.
Proof.
  intro H.
  destruct H as [HT _].
  exact HT.
Qed.

Theorem schumann_boundary_frequency_readout :
  F_COG_SchumannEarthBoundary ->
  f_earth_schumann = schumann_fundamental_hz.
Proof.
  intro H.
  destruct H as [HF _].
  exact HF.
Qed.

Theorem visual_cycles_per_frame_readout :
  F_COG_MultiscalePerceptionFrame ->
  N_visual_cycles_per_frame = QRD.c * T_psi_frame / MFV.lambda_vis.
Proof.
  intro H.
  destruct H as [_ [_ [_ [_ [HV _]]]]].
  exact HV.
Qed.

Theorem auditory_cycles_per_frame_readout :
  F_COG_MultiscalePerceptionFrame ->
  N_auditory_cycles_per_frame = f_aud_anchor * T_psi_frame.
Proof.
  intro H.
  destruct H as [_ [_ [_ [_ [_ [HA _]]]]]].
  exact HA.
Qed.

Theorem earth_cycles_per_frame_readout :
  F_COG_MultiscalePerceptionFrame ->
  R_psi_earth = f_earth_schumann * T_psi_frame.
Proof.
  intro H.
  destruct H as [_ [_ [_ [_ [_ [_ [HE _]]]]]]].
  exact HE.
Qed.

Theorem occam_blocks_earth_as_mind_generator :
  F_COG_OccamBoundaryGate ->
  ~ earth_rhythm_is_mind_generator.
Proof.
  intro H.
  destruct H as [_ [_ Hnot]].
  exact Hnot.
Qed.

Theorem final_cognitive_rhythm_secret :
  F_COG_FinalCognitiveRhythmReadout ->
  MFV.D_shadow_visual = MFV.lambda_vis /\
  T_psi_frame = cognitive_frame_nominal_s /\
  f_earth_schumann = schumann_fundamental_hz /\
  R_psi_earth = f_earth_schumann * T_psi_frame /\
  ~ earth_rhythm_is_mind_generator.
Proof.
  intro H.
  destruct H as [HM HMFV].
  split.
  - apply MFV.mass_free_visual_shadow_readout; exact HMFV.
  - split.
    + destruct HM as [_ [_ [HF _]]].
      apply cognitive_frame_060s_readout; exact HF.
    + split.
      * destruct HM as [_ [_ [_ [HE _]]]].
        apply schumann_boundary_frequency_readout; exact HE.
      * split.
        -- apply earth_cycles_per_frame_readout; exact HM.
        -- destruct HM as [_ [_ [_ [_ [_ [_ [_ [HO _]]]]]]]].
           apply occam_blocks_earth_as_mind_generator; exact HO.
Qed.

End Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.


(******************************************************************************)
(* Pre-readout geometry/source/proof-obligation substrate.                     *)
(*                                                                            *)
(* Wavelength is treated as a readout scale, not as the generator of the        *)
(* horizon.  The branch below inserts an optical geometry and obligation layer  *)
(* before any visual/cognitive readout claim is used as a strengthened output.  *)
(******************************************************************************)

Module Quantum_Relativity_PreReadout_Geometry_Substrate.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.
Module PER := Quantum_Relativity_Perception_Extension.
Module MFV := Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.

Ltac pre_member :=
  simpl; repeat (first [left; reflexivity | right]).

Theorem pre_qr_nodes_complete :
  forall n : QRD.QRNode, In n QRD.all_nodes.
Proof.
  intro n.
  destruct n; unfold QRD.all_nodes; pre_member.
Qed.

Theorem pre_enhanced_nodes_complete :
  forall n : PER.EnhancedNode, In n PER.all_enhanced_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold PER.all_enhanced_nodes;
      apply in_or_app; left;
      apply in_map;
      apply pre_qr_nodes_complete
    ];
    unfold PER.all_enhanced_nodes;
    apply in_or_app; right;
    unfold PER.new_nodes; pre_member.
Qed.

Inductive PreReadoutNode : Type :=
| PRE_AnchorRoot : QRD.QRNode -> PreReadoutNode
| PRE_AnchorPerception : PER.EnhancedNode -> PreReadoutNode
| N_PRE_DimensionalTyping
| N_PRE_OpticalMetricAnsatz
| N_PRE_DomainRegularity
| N_PRE_NullEikonalLimit
| N_PRE_HorizonExistence
| N_PRE_HorizonBranchControl
| N_PRE_PhotonSphereDerivation
| N_PRE_ShadowMap
| N_PRE_ShadowRatioTheorem
| N_PRE_SourceChoice
| N_PRE_ReadoutCalibration
| N_PRE_NonCircularity
| N_PRE_ShadowStability
| N_PRE_ObservableInvariance
| N_PRE_EmpiricalTolerance
| N_PRE_FinalSubstrateStrengthenedReadout.

Parameter as_length as_time as_frequency as_energy : R -> Prop.
Parameter dimensionless : R -> Prop.
Parameter optical_metric_ansatz optical_source_admissible : Prop.
Parameter optical_null_eikonal : Prop.
Parameter continuous_on : (R -> R) -> R -> R -> Prop.
Parameter has_root_between : (R -> R) -> R -> R -> Prop.
Parameter outermost_root : (R -> R) -> R -> Prop.
Parameter stable_under_perturbation : (R -> R) -> R -> Prop.
Parameter shadow_stability_bound : R -> Prop.
Parameter coordinate_invariant gauge_invariant_readout : R -> Prop.
Parameter derived_from_optical_geometry : R -> Prop.
Parameter readout_calibrated_by_wavelength : R -> R -> Prop.
Parameter physical_GR_horizon_claim null_energy_condition : Prop.
Parameter alpha_vis_readout observed_shadow_diameter shadow_error_tolerance : R.

Definition F_PRE_DimensionalTyping : Prop :=
  as_length MFV.lambda_vis /\
  as_length MFV.rH_visual0 /\
  as_length MFV.r_ph_visual0 /\
  as_length MFV.D_shadow_visual /\
  as_frequency MFV.photon_frequency_vis /\
  as_energy MFV.photon_energy_vis /\
  dimensionless (MFV.D_shadow_visual / MFV.rH_visual0).

Definition F_PRE_OpticalMetricAnsatz : Prop :=
  optical_metric_ansatz /\
  forall r : R,
    r > MFV.rH_visual0 -> MFV.F_psi r > 0.

Definition F_PRE_DomainRegularity : Prop :=
  QRD.c > 0 /\
  QRD.hbar > 0 /\
  QRD.G > 0 /\
  QRD.kB > 0 /\
  MFV.lambda_vis > 0 /\
  MFV.rH_visual0 > 0 /\
  MFV.r_ph_visual0 > MFV.rH_visual0 /\
  MFV.F_psi MFV.r_ph_visual0 > 0.

Definition F_PRE_NullEikonalLimit : Prop :=
  optical_null_eikonal /\
  MFV.F_MFV_MassFreeMetricHorizon.

Definition F_PRE_HorizonExistence : Prop :=
  exists a b : R,
    a < b /\
    continuous_on MFV.F_psi a b /\
    MFV.F_psi a < 0 /\
    MFV.F_psi b > 0 /\
    has_root_between MFV.F_psi a b.

Definition F_PRE_HorizonBranchControl : Prop :=
  MFV.F_psi MFV.rH_visual0 = 0 /\
  MFV.rH_visual0 > 0 /\
  outermost_root MFV.F_psi MFV.rH_visual0.

Definition F_PRE_PhotonSphereDerivation : Prop :=
  MFV.r_ph_visual0 > MFV.rH_visual0 /\
  MFV.d_r2_over_F_psi MFV.r_ph_visual0 = 0 /\
  MFV.bcrit_visual =
    MFV.r_ph_visual0 / QRD.sqrt (MFV.F_psi MFV.r_ph_visual0).

Definition F_PRE_ShadowMap : Prop :=
  MFV.D_shadow_visual = 2 * MFV.bcrit_visual.

Definition F_PRE_ShadowRatioTheorem : Prop :=
  MFV.D_shadow_visual = 3 * QRD.sqrt 3 * MFV.rH_visual0.

Definition F_PRE_SourceChoice : Prop :=
  optical_source_admissible \/
  (physical_GR_horizon_claim /\ null_energy_condition).

Definition F_PRE_ReadoutCalibration : Prop :=
  alpha_vis_readout > 0 /\
  MFV.D_shadow_visual = alpha_vis_readout * MFV.lambda_vis /\
  readout_calibrated_by_wavelength MFV.D_shadow_visual MFV.lambda_vis.

Definition F_PRE_NonCircularity : Prop :=
  derived_from_optical_geometry MFV.rH_visual0 /\
  readout_calibrated_by_wavelength MFV.D_shadow_visual MFV.lambda_vis /\
  ~ derived_from_optical_geometry MFV.lambda_vis.

Definition F_PRE_ShadowStability : Prop :=
  stable_under_perturbation MFV.F_psi MFV.rH_visual0 /\
  shadow_stability_bound MFV.D_shadow_visual.

Definition F_PRE_ObservableInvariance : Prop :=
  coordinate_invariant MFV.D_shadow_visual /\
  gauge_invariant_readout MFV.D_shadow_visual.

Definition F_PRE_EmpiricalTolerance : Prop :=
  shadow_error_tolerance > 0 /\
  Rabs (observed_shadow_diameter - MFV.D_shadow_visual)
    <= shadow_error_tolerance.

Definition F_PRE_FinalSubstrateStrengthenedReadout : Prop :=
  F_PRE_DimensionalTyping /\
  F_PRE_OpticalMetricAnsatz /\
  F_PRE_DomainRegularity /\
  F_PRE_NullEikonalLimit /\
  F_PRE_HorizonExistence /\
  F_PRE_HorizonBranchControl /\
  F_PRE_PhotonSphereDerivation /\
  F_PRE_ShadowMap /\
  F_PRE_ShadowRatioTheorem /\
  F_PRE_SourceChoice /\
  F_PRE_ReadoutCalibration /\
  F_PRE_NonCircularity /\
  F_PRE_ShadowStability /\
  F_PRE_ObservableInvariance /\
  F_PRE_EmpiricalTolerance.

Definition pre_formula_of (n : PreReadoutNode) : Prop :=
  match n with
  | PRE_AnchorRoot _ => True
  | PRE_AnchorPerception _ => True
  | N_PRE_DimensionalTyping => F_PRE_DimensionalTyping
  | N_PRE_OpticalMetricAnsatz => F_PRE_OpticalMetricAnsatz
  | N_PRE_DomainRegularity => F_PRE_DomainRegularity
  | N_PRE_NullEikonalLimit => F_PRE_NullEikonalLimit
  | N_PRE_HorizonExistence => F_PRE_HorizonExistence
  | N_PRE_HorizonBranchControl => F_PRE_HorizonBranchControl
  | N_PRE_PhotonSphereDerivation => F_PRE_PhotonSphereDerivation
  | N_PRE_ShadowMap => F_PRE_ShadowMap
  | N_PRE_ShadowRatioTheorem => F_PRE_ShadowRatioTheorem
  | N_PRE_SourceChoice => F_PRE_SourceChoice
  | N_PRE_ReadoutCalibration => F_PRE_ReadoutCalibration
  | N_PRE_NonCircularity => F_PRE_NonCircularity
  | N_PRE_ShadowStability => F_PRE_ShadowStability
  | N_PRE_ObservableInvariance => F_PRE_ObservableInvariance
  | N_PRE_EmpiricalTolerance => F_PRE_EmpiricalTolerance
  | N_PRE_FinalSubstrateStrengthenedReadout =>
      F_PRE_FinalSubstrateStrengthenedReadout
  end.

Definition pre_rank (n : PreReadoutNode) : nat :=
  match n with
  | PRE_AnchorRoot q => QRD.rank q
  | PRE_AnchorPerception e => (100 + PER.enhanced_rank e)%nat
  | N_PRE_DimensionalTyping => 200
  | N_PRE_OpticalMetricAnsatz => 210
  | N_PRE_DomainRegularity => 220
  | N_PRE_NullEikonalLimit => 230
  | N_PRE_HorizonExistence => 240
  | N_PRE_HorizonBranchControl => 250
  | N_PRE_PhotonSphereDerivation => 260
  | N_PRE_ShadowMap => 270
  | N_PRE_ShadowRatioTheorem => 280
  | N_PRE_SourceChoice => 290
  | N_PRE_ReadoutCalibration => 300
  | N_PRE_NonCircularity => 310
  | N_PRE_ShadowStability => 320
  | N_PRE_ObservableInvariance => 330
  | N_PRE_EmpiricalTolerance => 340
  | N_PRE_FinalSubstrateStrengthenedReadout => 350
  end.

Inductive PreReadoutEdge : PreReadoutNode -> PreReadoutNode -> Prop :=
| PREE_Root : forall a b : QRD.QRNode,
    QRD.QREdge a b -> PreReadoutEdge (PRE_AnchorRoot a) (PRE_AnchorRoot b)
| PREE_Perception : forall a b : PER.EnhancedNode,
    PER.EnhancedEdge a b ->
    PreReadoutEdge (PRE_AnchorPerception a) (PRE_AnchorPerception b)
| PREE_QCD_To_Dimensions :
    PreReadoutEdge (PRE_AnchorRoot QRD.N_QFT_QCD) N_PRE_DimensionalTyping
| PREE_GEODESIC_To_OpticalMetric :
    PreReadoutEdge (PRE_AnchorRoot QRD.N_GR_Geodesic) N_PRE_OpticalMetricAnsatz
| PREE_PerceptionLight_To_NullEikonal :
    PreReadoutEdge
      (PRE_AnchorPerception PER.N_PER_LightGeodesicBundle)
      N_PRE_NullEikonalLimit
| PREE_Dimensions_To_Regularity :
    PreReadoutEdge N_PRE_DimensionalTyping N_PRE_DomainRegularity
| PREE_OpticalMetric_To_Regularity :
    PreReadoutEdge N_PRE_OpticalMetricAnsatz N_PRE_DomainRegularity
| PREE_Regularity_To_NullEikonal :
    PreReadoutEdge N_PRE_DomainRegularity N_PRE_NullEikonalLimit
| PREE_NullEikonal_To_HorizonExistence :
    PreReadoutEdge N_PRE_NullEikonalLimit N_PRE_HorizonExistence
| PREE_HorizonExistence_To_BranchControl :
    PreReadoutEdge N_PRE_HorizonExistence N_PRE_HorizonBranchControl
| PREE_BranchControl_To_PhotonSphere :
    PreReadoutEdge N_PRE_HorizonBranchControl N_PRE_PhotonSphereDerivation
| PREE_PhotonSphere_To_ShadowMap :
    PreReadoutEdge N_PRE_PhotonSphereDerivation N_PRE_ShadowMap
| PREE_ShadowMap_To_Ratio :
    PreReadoutEdge N_PRE_ShadowMap N_PRE_ShadowRatioTheorem
| PREE_Ratio_To_Source :
    PreReadoutEdge N_PRE_ShadowRatioTheorem N_PRE_SourceChoice
| PREE_Source_To_Calibration :
    PreReadoutEdge N_PRE_SourceChoice N_PRE_ReadoutCalibration
| PREE_Calibration_To_NonCircularity :
    PreReadoutEdge N_PRE_ReadoutCalibration N_PRE_NonCircularity
| PREE_NonCircularity_To_Stability :
    PreReadoutEdge N_PRE_NonCircularity N_PRE_ShadowStability
| PREE_Stability_To_Invariance :
    PreReadoutEdge N_PRE_ShadowStability N_PRE_ObservableInvariance
| PREE_Invariance_To_Empirical :
    PreReadoutEdge N_PRE_ObservableInvariance N_PRE_EmpiricalTolerance
| PREE_Empirical_To_Final :
    PreReadoutEdge
      N_PRE_EmpiricalTolerance
      N_PRE_FinalSubstrateStrengthenedReadout.

Theorem pre_edge_rank :
  forall a b : PreReadoutNode,
    PreReadoutEdge a b -> (pre_rank a < pre_rank b)%nat.
Proof.
  intros a b H.
  destruct H; simpl; try lia.
  - apply QRD.edge_rank; exact H.
  - pose proof (PER.enhanced_edge_rank a b H); lia.
Qed.

Inductive PreReadoutPath : PreReadoutNode -> PreReadoutNode -> Prop :=
| PREP_edge :
    forall a b : PreReadoutNode,
      PreReadoutEdge a b -> PreReadoutPath a b
| PREP_trans :
    forall a b c : PreReadoutNode,
      PreReadoutPath a b -> PreReadoutPath b c -> PreReadoutPath a c.

Theorem pre_path_rank :
  forall a b : PreReadoutNode,
    PreReadoutPath a b -> (pre_rank a < pre_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply pre_edge_rank; exact H.
  - eapply Nat.lt_trans; eauto.
Qed.

Theorem pre_dag_acyclic :
  forall n : PreReadoutNode, ~ PreReadoutPath n n.
Proof.
  intros n H.
  pose proof (pre_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

Definition pre_new_nodes : list PreReadoutNode :=
  [N_PRE_DimensionalTyping;
   N_PRE_OpticalMetricAnsatz;
   N_PRE_DomainRegularity;
   N_PRE_NullEikonalLimit;
   N_PRE_HorizonExistence;
   N_PRE_HorizonBranchControl;
   N_PRE_PhotonSphereDerivation;
   N_PRE_ShadowMap;
   N_PRE_ShadowRatioTheorem;
   N_PRE_SourceChoice;
   N_PRE_ReadoutCalibration;
   N_PRE_NonCircularity;
   N_PRE_ShadowStability;
   N_PRE_ObservableInvariance;
   N_PRE_EmpiricalTolerance;
   N_PRE_FinalSubstrateStrengthenedReadout].

Definition all_pre_nodes : list PreReadoutNode :=
  map PRE_AnchorRoot QRD.all_nodes ++
  map PRE_AnchorPerception PER.all_enhanced_nodes ++
  pre_new_nodes.

Theorem pre_nodes_complete :
  forall n : PreReadoutNode, In n all_pre_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_pre_nodes;
      apply in_or_app; left;
      apply in_map;
      apply pre_qr_nodes_complete
    ];
    try solve [
      unfold all_pre_nodes;
      apply in_or_app; right;
      apply in_or_app; left;
      apply in_map;
      apply pre_enhanced_nodes_complete
    ];
    unfold all_pre_nodes, pre_new_nodes;
    apply in_or_app; right;
    apply in_or_app; right;
    simpl; repeat (first [left; reflexivity | right]).
Qed.

End Quantum_Relativity_PreReadout_Geometry_Substrate.


(******************************************************************************)
(* Information, thermodynamic, epistemic, AI, and secret-boundary substrate.   *)
(******************************************************************************)

Module Quantum_Relativity_InfoThermoKnowledge_Substrate.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.

Ltac itk_member :=
  simpl; repeat (first [left; reflexivity | right]).

Theorem itk_qr_nodes_complete :
  forall n : QRD.QRNode, In n QRD.all_nodes.
Proof.
  intro n.
  destruct n; unfold QRD.all_nodes; itk_member.
Qed.

Parameter WorldState Observation LatentState PrivateSecret : Type.
Parameter lawful_observation : Observation -> Prop.
Parameter protected_secret : PrivateSecret -> Prop.
Parameter latent_structure : LatentState -> Prop.
Parameter observes : WorldState -> Observation -> Prop.
Parameter generates_latent : WorldState -> LatentState -> Prop.
Parameter inferable : LatentState -> Prop.
Parameter extractable_private_secret : PrivateSecret -> Prop.
Parameter lawful_observation_obtained : Prop.

Parameter RandomVar Distribution : Type.
Parameter ShannonEntropy : RandomVar -> R.
Parameter ConditionalEntropy : RandomVar -> RandomVar -> R.
Parameter MutualInformation : RandomVar -> RandomVar -> R.
Parameter KLDivergence : Distribution -> Distribution -> R.
Parameter MarkovChain : RandomVar -> RandomVar -> RandomVar -> Prop.
Parameter X_world Y_observation Z_output : RandomVar.
Parameter P_dist Q_dist : Distribution.

Parameter T_bath Q_heat erased_bits ln2 : R.
Parameter InternalEnergy FreeEnergy Temperature Entropy : R.
Parameter prediction_error complexity_penalty AI_free_energy : R.

Parameter HypothesisT EvidenceT SignalT MeaningT DataT RepresentationT OutputT ModelT : Type.
Parameter Prior Likelihood Posterior EvidenceProb : HypothesisT -> R.
Parameter believes true_hypothesis evidentially_supported : HypothesisT -> Prop.
Parameter robust_under_perturbation causally_grounded : HypothesisT -> Prop.
Parameter semantic_decode : SignalT -> MeaningT.
Parameter corresponds_to_world : MeaningT -> WorldState -> Prop.
Parameter semantic_error : SignalT -> WorldState -> R.
Parameter CauseT EffectT InterventionT : Type.
Parameter causes : CauseT -> EffectT -> Prop.
Parameter causal_invariant : HypothesisT -> Prop.
Parameter encode : ModelT -> DataT -> RepresentationT.
Parameter decode : ModelT -> RepresentationT -> OutputT.
Parameter loss : ModelT -> DataT -> R.
Parameter trained_on generalizes_to : ModelT -> DataT -> Prop.
Parameter train_error test_error generalization_gap : R.
Parameter confidence correctness calibration_error acceptable_calibration_error : R.
Parameter ai_output : OutputT -> Prop.
Parameter candidate_belief : OutputT -> HypothesisT -> Prop.
Parameter verified_knowledge : HypothesisT -> Prop.

Definition itk_knowledge (H : HypothesisT) : Prop :=
  believes H /\
  true_hypothesis H /\
  evidentially_supported H /\
  robust_under_perturbation H /\
  causally_grounded H.

Inductive ITKNode : Type :=
| ITK_AnchorRoot : QRD.QRNode -> ITKNode
| N_ITK_WorldState
| N_ITK_ObservationChannel
| N_ITK_ShannonEntropy
| N_ITK_MutualInformation
| N_ITK_DataProcessingInequality
| N_ITK_PrivateSecretBoundary
| N_ITK_LandauerHeatCost
| N_ITK_FreeEnergyBridge
| N_ITK_BayesianUpdate
| N_ITK_SemanticGrounding
| N_ITK_CausalInvariance
| N_ITK_AIRepresentation
| N_ITK_Generalization
| N_ITK_Calibration
| N_ITK_KnowledgeCriterion
| N_ITK_ReadoutPermission.

Definition F_ITK_WorldState : Prop :=
  exists w : WorldState, w = w.

Definition F_ITK_ObservationChannel : Prop :=
  forall w : WorldState,
    exists o : Observation, observes w o /\ lawful_observation o.

Definition F_ITK_ShannonEntropy : Prop :=
  ShannonEntropy X_world >= 0.

Definition F_ITK_MutualInformation : Prop :=
  MutualInformation X_world Y_observation =
    ShannonEntropy X_world - ConditionalEntropy X_world Y_observation /\
  MutualInformation X_world Y_observation >= 0.

Definition F_ITK_DataProcessingInequality : Prop :=
  MarkovChain X_world Y_observation Z_output ->
  MutualInformation X_world Z_output <=
  MutualInformation X_world Y_observation.

Definition F_ITK_PrivateSecretBoundary : Prop :=
  (forall z : LatentState,
      latent_structure z -> lawful_observation_obtained -> inferable z) /\
  (forall s : PrivateSecret,
      protected_secret s -> ~ extractable_private_secret s).

Definition F_ITK_LandauerHeatCost : Prop :=
  QRD.kB > 0 /\
  T_bath > 0 /\
  erased_bits >= 0 /\
  Q_heat >= QRD.kB * T_bath * ln2 * erased_bits.

Definition F_ITK_FreeEnergyBridge : Prop :=
  FreeEnergy = InternalEnergy - Temperature * Entropy /\
  AI_free_energy = prediction_error + complexity_penalty.

Definition F_ITK_BayesianUpdate : Prop :=
  forall H : HypothesisT,
    EvidenceProb H > 0 ->
    Posterior H = Likelihood H * Prior H / EvidenceProb H.

Definition F_ITK_SemanticGrounding : Prop :=
  forall sig : SignalT,
    exists w : WorldState,
      corresponds_to_world (semantic_decode sig) w.

Definition F_ITK_CausalInvariance : Prop :=
  forall H : HypothesisT,
    itk_knowledge H -> causal_invariant H.

Definition F_ITK_AIRepresentation : Prop :=
  forall (m : ModelT) (d : DataT),
    exists z : RepresentationT,
      encode m d = z /\ exists y : OutputT, decode m z = y.

Definition F_ITK_Generalization : Prop :=
  generalization_gap = test_error - train_error /\
  generalization_gap >= 0.

Definition F_ITK_Calibration : Prop :=
  calibration_error >= 0 /\
  calibration_error <= acceptable_calibration_error.

Definition F_ITK_KnowledgeCriterion : Prop :=
  forall H : HypothesisT,
    verified_knowledge H -> itk_knowledge H.

Definition F_ITK_ReadoutPermission : Prop :=
  F_ITK_PrivateSecretBoundary /\
  forall (o : OutputT) (h : HypothesisT),
    ai_output o ->
    candidate_belief o h ->
    verified_knowledge h ->
    itk_knowledge h.

Definition itk_formula_of (n : ITKNode) : Prop :=
  match n with
  | ITK_AnchorRoot _ => True
  | N_ITK_WorldState => F_ITK_WorldState
  | N_ITK_ObservationChannel => F_ITK_ObservationChannel
  | N_ITK_ShannonEntropy => F_ITK_ShannonEntropy
  | N_ITK_MutualInformation => F_ITK_MutualInformation
  | N_ITK_DataProcessingInequality => F_ITK_DataProcessingInequality
  | N_ITK_PrivateSecretBoundary => F_ITK_PrivateSecretBoundary
  | N_ITK_LandauerHeatCost => F_ITK_LandauerHeatCost
  | N_ITK_FreeEnergyBridge => F_ITK_FreeEnergyBridge
  | N_ITK_BayesianUpdate => F_ITK_BayesianUpdate
  | N_ITK_SemanticGrounding => F_ITK_SemanticGrounding
  | N_ITK_CausalInvariance => F_ITK_CausalInvariance
  | N_ITK_AIRepresentation => F_ITK_AIRepresentation
  | N_ITK_Generalization => F_ITK_Generalization
  | N_ITK_Calibration => F_ITK_Calibration
  | N_ITK_KnowledgeCriterion => F_ITK_KnowledgeCriterion
  | N_ITK_ReadoutPermission => F_ITK_ReadoutPermission
  end.

Definition itk_rank (n : ITKNode) : nat :=
  match n with
  | ITK_AnchorRoot q => QRD.rank q
  | N_ITK_WorldState => 400
  | N_ITK_ObservationChannel => 410
  | N_ITK_ShannonEntropy => 420
  | N_ITK_MutualInformation => 430
  | N_ITK_DataProcessingInequality => 440
  | N_ITK_PrivateSecretBoundary => 445
  | N_ITK_LandauerHeatCost => 450
  | N_ITK_FreeEnergyBridge => 460
  | N_ITK_BayesianUpdate => 470
  | N_ITK_SemanticGrounding => 480
  | N_ITK_CausalInvariance => 490
  | N_ITK_AIRepresentation => 535
  | N_ITK_Generalization => 545
  | N_ITK_Calibration => 555
  | N_ITK_KnowledgeCriterion => 530
  | N_ITK_ReadoutPermission => 565
  end.

Inductive ITKEdge : ITKNode -> ITKNode -> Prop :=
| ITKE_Root : forall a b : QRD.QRNode,
    QRD.QREdge a b -> ITKEdge (ITK_AnchorRoot a) (ITK_AnchorRoot b)
| ITKE_BaseLogic_To_World :
    ITKEdge (ITK_AnchorRoot QRD.N_Base_Logic) N_ITK_WorldState
| ITKE_QDensity_To_Shannon :
    ITKEdge (ITK_AnchorRoot QRD.N_Q_Density) N_ITK_ShannonEntropy
| ITKE_World_To_Observation :
    ITKEdge N_ITK_WorldState N_ITK_ObservationChannel
| ITKE_Observation_To_Shannon :
    ITKEdge N_ITK_ObservationChannel N_ITK_ShannonEntropy
| ITKE_Shannon_To_MI :
    ITKEdge N_ITK_ShannonEntropy N_ITK_MutualInformation
| ITKE_MI_To_DPI :
    ITKEdge N_ITK_MutualInformation N_ITK_DataProcessingInequality
| ITKE_DPI_To_Bayes :
    ITKEdge N_ITK_DataProcessingInequality N_ITK_BayesianUpdate
| ITKE_Bayes_To_Semantic :
    ITKEdge N_ITK_BayesianUpdate N_ITK_SemanticGrounding
| ITKE_Semantic_To_Causal :
    ITKEdge N_ITK_SemanticGrounding N_ITK_CausalInvariance
| ITKE_Causal_To_Knowledge :
    ITKEdge N_ITK_CausalInvariance N_ITK_KnowledgeCriterion
| ITKE_Shannon_To_Landauer :
    ITKEdge N_ITK_ShannonEntropy N_ITK_LandauerHeatCost
| ITKE_Landauer_To_FreeEnergy :
    ITKEdge N_ITK_LandauerHeatCost N_ITK_FreeEnergyBridge
| ITKE_FreeEnergy_To_AI :
    ITKEdge N_ITK_FreeEnergyBridge N_ITK_AIRepresentation
| ITKE_Knowledge_To_AI :
    ITKEdge N_ITK_KnowledgeCriterion N_ITK_AIRepresentation
| ITKE_AI_To_Generalization :
    ITKEdge N_ITK_AIRepresentation N_ITK_Generalization
| ITKE_Generalization_To_Calibration :
    ITKEdge N_ITK_Generalization N_ITK_Calibration
| ITKE_Secret_To_Readout :
    ITKEdge N_ITK_PrivateSecretBoundary N_ITK_ReadoutPermission
| ITKE_Calibration_To_Readout :
    ITKEdge N_ITK_Calibration N_ITK_ReadoutPermission.

Theorem itk_edge_rank :
  forall a b : ITKNode, ITKEdge a b -> (itk_rank a < itk_rank b)%nat.
Proof.
  intros a b H.
  destruct H; simpl; try lia.
  apply QRD.edge_rank; exact H.
Qed.

Inductive ITKPath : ITKNode -> ITKNode -> Prop :=
| ITKP_edge : forall a b : ITKNode, ITKEdge a b -> ITKPath a b
| ITKP_trans : forall a b c : ITKNode, ITKPath a b -> ITKPath b c -> ITKPath a c.

Theorem itk_path_rank :
  forall a b : ITKNode, ITKPath a b -> (itk_rank a < itk_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply itk_edge_rank; exact H.
  - eapply Nat.lt_trans; eauto.
Qed.

Theorem itk_dag_acyclic :
  forall n : ITKNode, ~ ITKPath n n.
Proof.
  intros n H.
  pose proof (itk_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

Definition itk_new_nodes : list ITKNode :=
  [N_ITK_WorldState;
   N_ITK_ObservationChannel;
   N_ITK_ShannonEntropy;
   N_ITK_MutualInformation;
   N_ITK_DataProcessingInequality;
   N_ITK_PrivateSecretBoundary;
   N_ITK_LandauerHeatCost;
   N_ITK_FreeEnergyBridge;
   N_ITK_BayesianUpdate;
   N_ITK_SemanticGrounding;
   N_ITK_CausalInvariance;
   N_ITK_AIRepresentation;
   N_ITK_Generalization;
   N_ITK_Calibration;
   N_ITK_KnowledgeCriterion;
   N_ITK_ReadoutPermission].

Definition all_itk_nodes : list ITKNode :=
  map ITK_AnchorRoot QRD.all_nodes ++ itk_new_nodes.

Theorem itk_nodes_complete :
  forall n : ITKNode, In n all_itk_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_itk_nodes;
      apply in_or_app; left;
      apply in_map;
      apply itk_qr_nodes_complete
    ];
    unfold all_itk_nodes, itk_new_nodes;
    apply in_or_app; right;
    simpl; repeat (first [left; reflexivity | right]).
Qed.

End Quantum_Relativity_InfoThermoKnowledge_Substrate.


(******************************************************************************)
(* Nuclear reaction substrate: QCD root -> nucleus -> Q-value -> fission/fusion. *)
(******************************************************************************)

Module Quantum_Relativity_Nuclear_Reaction_Substrate.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.

Ltac nuc_member :=
  simpl; repeat (first [left; reflexivity | right]).

Theorem nuc_qr_nodes_complete :
  forall n : QRD.QRNode, In n QRD.all_nodes.
Proof.
  intro n.
  destruct n; unfold QRD.all_nodes; nuc_member.
Qed.

Parameter alpha_s sigma_QCD Delta_QCD : R.
Parameter V_qqbar : R -> R.
Parameter Quark Gluon Hadron Nucleon Nucleus : Type.
Parameter proton neutron : Nucleon.
Parameter uud udd : Quark -> Quark -> Quark -> Prop.
Parameter hadronizes_to : QRD.FieldExpr -> Hadron -> Prop.
Parameter nucleon_to_hadron : Nucleon -> Hadron.
Parameter residual_strong_force : Nucleon -> Nucleon -> R.
Parameter derived_from_QCD : R -> Prop.

Parameter A_nuc Z_nuc N_neutron : R.
Parameter m_p m_n M_nucleus E_bind mass_defect : R.
Parameter a_v a_s a_c a_a delta_pair : R.
Parameter B_nuclear powR : R -> R -> R.

Parameter M_initial M_final Q_reaction : R.
Parameter A_parent Z_parent A1 Z1 A2 Z2 k_neutron : R.
Parameter M_parent M_frag1 M_frag2 M_neutron Q_fission : R.
Parameter A3 Z3 M_fus1 M_fus2 M_fus_product Q_fusion : R.
Parameter e_charge r_sep V_coulomb : R.
Parameter exothermic endothermic reaction_stable : Prop.
Parameter ChargeLaw BaryonLaw EnergyLaw MomentumLaw LeptonLaw : Type.
Parameter conserved_law : Type -> Prop.

Inductive NuclearReactionNode : Type :=
| NUC_AnchorRoot : QRD.QRNode -> NuclearReactionNode
| N_NUC_SU3GaugeSymmetry
| N_NUC_GluonFieldStrength
| N_NUC_QCDAction
| N_NUC_QCDEulerLagrange
| N_NUC_Confinement
| N_NUC_MassGap
| N_NUC_Hadronization
| N_NUC_Nucleon
| N_NUC_Nucleus
| N_NUC_MassDefect
| N_NUC_BindingEnergy
| N_NUC_SemiEmpiricalMassFormula
| N_NUC_ResidualStrongForce
| N_NUC_ReactionChannel
| N_NUC_ConservationLaws
| N_NUC_QValue
| N_NUC_CoulombBarrier
| N_NUC_Fission
| N_NUC_Fusion
| N_NUC_ReactionStability
| N_NUC_FinalReactionReadout.

Definition F_NUC_SU3GaugeSymmetry : Prop :=
  QRD.F_N_QFT_QCD /\ QRD.F_N_QFT_YM_L.

Definition F_NUC_GluonFieldStrength : Prop :=
  forall mu nu : nat,
  forall p : QRD.Point,
    QRD.F mu nu p =
      QRD.d mu (QRD.A_mu nu) p -
      QRD.d nu (QRD.A_mu mu) p +
      QRD.lie_term mu nu p.

Definition F_NUC_QCDAction : Prop :=
  forall p : QRD.Point,
    QRD.L_QCD p =
      QRD.L_YM p + QRD.quark_kinetic p + QRD.quark_mass p.

Definition F_NUC_QCDEulerLagrange : Prop :=
  QRD.stationary QRD.interaction_action.

Definition F_NUC_Confinement : Prop :=
  alpha_s > 0 /\
  sigma_QCD > 0 /\
  forall r : R,
    r > 0 ->
    V_qqbar r = - alpha_s / r + sigma_QCD * r.

Definition F_NUC_MassGap : Prop :=
  Delta_QCD > 0.

Definition F_NUC_Hadronization : Prop :=
  exists h : Hadron,
    exists x : QRD.FieldExpr,
      hadronizes_to x h.

Definition F_NUC_Nucleon : Prop :=
  exists u d : Quark,
    uud u u d /\ udd u d d.

Definition F_NUC_Nucleus : Prop :=
  A_nuc = Z_nuc + N_neutron /\
  A_nuc > 0.

Definition F_NUC_MassDefect : Prop :=
  mass_defect = Z_nuc * m_p + N_neutron * m_n - M_nucleus.

Definition F_NUC_BindingEnergy : Prop :=
  E_bind = mass_defect * QRD.c * QRD.c.

Definition F_NUC_SemiEmpiricalMassFormula : Prop :=
  forall A Z : R,
    A > 0 ->
    B_nuclear A Z =
      a_v * A
      - a_s * powR A (2/3)
      - a_c * (Z * (Z - 1)) / powR A (1/3)
      - a_a * ((A - 2 * Z) * (A - 2 * Z)) / A
      + delta_pair.

Definition F_NUC_ResidualStrongForce : Prop :=
  forall n1 n2 : Nucleon,
    derived_from_QCD (residual_strong_force n1 n2).

Definition F_NUC_ReactionChannel : Prop :=
  exists initial final : Nucleus, initial = initial /\ final = final.

Definition F_NUC_ConservationLaws : Prop :=
  conserved_law ChargeLaw /\
  conserved_law BaryonLaw /\
  conserved_law EnergyLaw /\
  conserved_law MomentumLaw.

Definition F_NUC_QValue : Prop :=
  Q_reaction = (M_initial - M_final) * QRD.c * QRD.c.

Definition F_NUC_CoulombBarrier : Prop :=
  QRD.epsilon0 > 0 /\
  r_sep > 0 /\
  V_coulomb =
    (1 / (4 * QRD.PI * QRD.epsilon0)) *
    (Z1 * Z2 * e_charge * e_charge) / r_sep.

Definition F_NUC_Fission : Prop :=
  A_parent = A1 + A2 + k_neutron /\
  Z_parent = Z1 + Z2 /\
  Q_fission =
    (M_parent - M_frag1 - M_frag2 - k_neutron * M_neutron) *
    QRD.c * QRD.c.

Definition F_NUC_Fusion : Prop :=
  A3 = A1 + A2 /\
  Z3 = Z1 + Z2 /\
  Q_fusion =
    (M_fus1 + M_fus2 - M_fus_product) * QRD.c * QRD.c.

Definition F_NUC_ReactionStability : Prop :=
  (Q_reaction > 0 -> exothermic) /\
  (Q_reaction < 0 -> endothermic) /\
  reaction_stable.

Definition F_NUC_FinalReactionReadout : Prop :=
  F_NUC_SU3GaugeSymmetry /\
  F_NUC_Confinement /\
  F_NUC_MassGap /\
  F_NUC_Hadronization /\
  F_NUC_Nucleon /\
  F_NUC_Nucleus /\
  F_NUC_BindingEnergy /\
  F_NUC_ConservationLaws /\
  F_NUC_QValue /\
  (F_NUC_Fission \/ F_NUC_Fusion).

Definition nuclear_formula_of (n : NuclearReactionNode) : Prop :=
  match n with
  | NUC_AnchorRoot _ => True
  | N_NUC_SU3GaugeSymmetry => F_NUC_SU3GaugeSymmetry
  | N_NUC_GluonFieldStrength => F_NUC_GluonFieldStrength
  | N_NUC_QCDAction => F_NUC_QCDAction
  | N_NUC_QCDEulerLagrange => F_NUC_QCDEulerLagrange
  | N_NUC_Confinement => F_NUC_Confinement
  | N_NUC_MassGap => F_NUC_MassGap
  | N_NUC_Hadronization => F_NUC_Hadronization
  | N_NUC_Nucleon => F_NUC_Nucleon
  | N_NUC_Nucleus => F_NUC_Nucleus
  | N_NUC_MassDefect => F_NUC_MassDefect
  | N_NUC_BindingEnergy => F_NUC_BindingEnergy
  | N_NUC_SemiEmpiricalMassFormula => F_NUC_SemiEmpiricalMassFormula
  | N_NUC_ResidualStrongForce => F_NUC_ResidualStrongForce
  | N_NUC_ReactionChannel => F_NUC_ReactionChannel
  | N_NUC_ConservationLaws => F_NUC_ConservationLaws
  | N_NUC_QValue => F_NUC_QValue
  | N_NUC_CoulombBarrier => F_NUC_CoulombBarrier
  | N_NUC_Fission => F_NUC_Fission
  | N_NUC_Fusion => F_NUC_Fusion
  | N_NUC_ReactionStability => F_NUC_ReactionStability
  | N_NUC_FinalReactionReadout => F_NUC_FinalReactionReadout
  end.

Definition nuclear_rank (n : NuclearReactionNode) : nat :=
  match n with
  | NUC_AnchorRoot q => QRD.rank q
  | N_NUC_SU3GaugeSymmetry => 600
  | N_NUC_GluonFieldStrength => 610
  | N_NUC_QCDAction => 620
  | N_NUC_QCDEulerLagrange => 630
  | N_NUC_Confinement => 640
  | N_NUC_MassGap => 650
  | N_NUC_Hadronization => 660
  | N_NUC_Nucleon => 670
  | N_NUC_Nucleus => 680
  | N_NUC_MassDefect => 690
  | N_NUC_BindingEnergy => 700
  | N_NUC_SemiEmpiricalMassFormula => 710
  | N_NUC_ResidualStrongForce => 720
  | N_NUC_ReactionChannel => 730
  | N_NUC_ConservationLaws => 740
  | N_NUC_QValue => 750
  | N_NUC_CoulombBarrier => 760
  | N_NUC_Fission => 770
  | N_NUC_Fusion => 770
  | N_NUC_ReactionStability => 780
  | N_NUC_FinalReactionReadout => 790
  end.

Inductive NuclearReactionEdge :
  NuclearReactionNode -> NuclearReactionNode -> Prop :=
| NUCE_Root : forall a b : QRD.QRNode,
    QRD.QREdge a b -> NuclearReactionEdge (NUC_AnchorRoot a) (NUC_AnchorRoot b)
| NUCE_QCD_To_SU3 :
    NuclearReactionEdge (NUC_AnchorRoot QRD.N_QFT_QCD) N_NUC_SU3GaugeSymmetry
| NUCE_LieGroup_To_SU3 :
    NuclearReactionEdge (NUC_AnchorRoot QRD.N_Base_LieGroup) N_NUC_SU3GaugeSymmetry
| NUCE_Variation_To_QCDAction :
    NuclearReactionEdge (NUC_AnchorRoot QRD.N_Base_Variation) N_NUC_QCDAction
| NUCE_SU3_To_Gluon :
    NuclearReactionEdge N_NUC_SU3GaugeSymmetry N_NUC_GluonFieldStrength
| NUCE_Gluon_To_Action :
    NuclearReactionEdge N_NUC_GluonFieldStrength N_NUC_QCDAction
| NUCE_Action_To_Euler :
    NuclearReactionEdge N_NUC_QCDAction N_NUC_QCDEulerLagrange
| NUCE_Euler_To_Confinement :
    NuclearReactionEdge N_NUC_QCDEulerLagrange N_NUC_Confinement
| NUCE_Confinement_To_MassGap :
    NuclearReactionEdge N_NUC_Confinement N_NUC_MassGap
| NUCE_MassGap_To_Hadronization :
    NuclearReactionEdge N_NUC_MassGap N_NUC_Hadronization
| NUCE_Hadronization_To_Nucleon :
    NuclearReactionEdge N_NUC_Hadronization N_NUC_Nucleon
| NUCE_Nucleon_To_Nucleus :
    NuclearReactionEdge N_NUC_Nucleon N_NUC_Nucleus
| NUCE_Nucleus_To_MassDefect :
    NuclearReactionEdge N_NUC_Nucleus N_NUC_MassDefect
| NUCE_MassDefect_To_Binding :
    NuclearReactionEdge N_NUC_MassDefect N_NUC_BindingEnergy
| NUCE_Binding_To_SEMF :
    NuclearReactionEdge N_NUC_BindingEnergy N_NUC_SemiEmpiricalMassFormula
| NUCE_Nucleon_To_ResidualForce :
    NuclearReactionEdge N_NUC_Nucleon N_NUC_ResidualStrongForce
| NUCE_Residual_To_Channel :
    NuclearReactionEdge N_NUC_ResidualStrongForce N_NUC_ReactionChannel
| NUCE_SEMF_To_Channel :
    NuclearReactionEdge N_NUC_SemiEmpiricalMassFormula N_NUC_ReactionChannel
| NUCE_Channel_To_Conservation :
    NuclearReactionEdge N_NUC_ReactionChannel N_NUC_ConservationLaws
| NUCE_Conservation_To_QValue :
    NuclearReactionEdge N_NUC_ConservationLaws N_NUC_QValue
| NUCE_QValue_To_Fission :
    NuclearReactionEdge N_NUC_QValue N_NUC_Fission
| NUCE_QValue_To_Coulomb :
    NuclearReactionEdge N_NUC_QValue N_NUC_CoulombBarrier
| NUCE_Coulomb_To_Fusion :
    NuclearReactionEdge N_NUC_CoulombBarrier N_NUC_Fusion
| NUCE_Fission_To_Stability :
    NuclearReactionEdge N_NUC_Fission N_NUC_ReactionStability
| NUCE_Fusion_To_Stability :
    NuclearReactionEdge N_NUC_Fusion N_NUC_ReactionStability
| NUCE_Stability_To_Final :
    NuclearReactionEdge N_NUC_ReactionStability N_NUC_FinalReactionReadout.

Theorem nuclear_edge_rank :
  forall a b : NuclearReactionNode,
    NuclearReactionEdge a b -> (nuclear_rank a < nuclear_rank b)%nat.
Proof.
  intros a b H.
  destruct H; simpl; try lia.
  apply QRD.edge_rank; exact H.
Qed.

Inductive NuclearReactionPath :
  NuclearReactionNode -> NuclearReactionNode -> Prop :=
| NUCP_edge :
    forall a b : NuclearReactionNode,
      NuclearReactionEdge a b -> NuclearReactionPath a b
| NUCP_trans :
    forall a b c : NuclearReactionNode,
      NuclearReactionPath a b ->
      NuclearReactionPath b c ->
      NuclearReactionPath a c.

Theorem nuclear_path_rank :
  forall a b : NuclearReactionNode,
    NuclearReactionPath a b -> (nuclear_rank a < nuclear_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply nuclear_edge_rank; exact H.
  - eapply Nat.lt_trans; eauto.
Qed.

Theorem nuclear_dag_acyclic :
  forall n : NuclearReactionNode, ~ NuclearReactionPath n n.
Proof.
  intros n H.
  pose proof (nuclear_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

Definition nuclear_new_nodes : list NuclearReactionNode :=
  [N_NUC_SU3GaugeSymmetry;
   N_NUC_GluonFieldStrength;
   N_NUC_QCDAction;
   N_NUC_QCDEulerLagrange;
   N_NUC_Confinement;
   N_NUC_MassGap;
   N_NUC_Hadronization;
   N_NUC_Nucleon;
   N_NUC_Nucleus;
   N_NUC_MassDefect;
   N_NUC_BindingEnergy;
   N_NUC_SemiEmpiricalMassFormula;
   N_NUC_ResidualStrongForce;
   N_NUC_ReactionChannel;
   N_NUC_ConservationLaws;
   N_NUC_QValue;
   N_NUC_CoulombBarrier;
   N_NUC_Fission;
   N_NUC_Fusion;
   N_NUC_ReactionStability;
   N_NUC_FinalReactionReadout].

Definition all_nuclear_nodes : list NuclearReactionNode :=
  map NUC_AnchorRoot QRD.all_nodes ++ nuclear_new_nodes.

Theorem nuclear_nodes_complete :
  forall n : NuclearReactionNode, In n all_nuclear_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_nuclear_nodes;
      apply in_or_app; left;
      apply in_map;
      apply nuc_qr_nodes_complete
    ];
    unfold all_nuclear_nodes, nuclear_new_nodes;
    apply in_or_app; right;
    simpl; repeat (first [left; reflexivity | right]).
Qed.

End Quantum_Relativity_Nuclear_Reaction_Substrate.


(******************************************************************************)
(* Universal-solver compatible equation/readout substrate.                     *)
(*                                                                            *)
(* This module mirrors the solver arc (private) boundary: one spine            *)
(* equation, lossy readout, obstruction gate, tau_c bus, and invariants.        *)
(* It is an equation/constraint layer only; it does not claim final truth.      *)
(******************************************************************************)

Module Quantum_Relativity_UniversalSolver_EquationReadout_Substrate.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.

Ltac usr_member :=
  simpl; repeat (first [left; reflexivity | right]).

Theorem usr_qr_nodes_complete :
  forall n : QRD.QRNode, In n QRD.all_nodes.
Proof.
  intro n.
  destruct n; unfold QRD.all_nodes; usr_member.
Qed.

Parameter SpineState SpineOperator SourceTerm NoiseTerm LatentTheta RecordReadout : Type.
Parameter M_spine D_spine K_spine lambda_mode lambda_c_solver : R.
Parameter Phi dPhi ddPhi L_RPhi gradV J_source eta_noise : R.
Parameter readout_operator latent_theta residual_eta measured_record : R.
Parameter obstruction O_threshold readout_margin eps_total : R.
Parameter tau_c_solver mass_scale invariant_value : R.
Parameter abstain answer_allowed finite_diagnostic_tier readout_not_truth : Prop.
Parameter monotone_obstruction_descent operator_persisted : Prop.

Inductive SolverEquationNode : Type :=
| USR_AnchorRoot : QRD.QRNode -> SolverEquationNode
| N_USR_SpineEquation
| N_USR_RegimeSplit
| N_USR_LossyReadout
| N_USR_ObstructionGate
| N_USR_TauCBus
| N_USR_InvariantReadout
| N_USR_OperatorPersistence
| N_USR_AbstainBoundary
| N_USR_ClaimTierBoundary
| N_USR_FinalEquationReadout.

Definition F_USR_SpineEquation : Prop :=
  M_spine * ddPhi +
  D_spine * dPhi +
  K_spine * L_RPhi +
  gradV =
  J_source - eta_noise.

Definition F_USR_RegimeSplit : Prop :=
  M_spine > 0 /\
  K_spine > 0 /\
  lambda_c_solver =
    D_spine * D_spine / (4 * M_spine * K_spine).

Definition F_USR_LossyReadout : Prop :=
  measured_record =
    readout_operator * latent_theta + residual_eta /\
  eps_total > 0.

Definition F_USR_ObstructionGate : Prop :=
  obstruction >= 0 /\
  monotone_obstruction_descent /\
  ((obstruction < O_threshold /\ readout_margin > eps_total) ->
    answer_allowed) /\
  (~ (obstruction < O_threshold /\ readout_margin > eps_total) ->
    abstain).

Definition F_USR_TauCBus : Prop :=
  mass_scale > 0 /\
  tau_c_solver = QRD.hbar / (2 * mass_scale * QRD.c * QRD.c).

Definition F_USR_InvariantReadout : Prop :=
  invariant_value = invariant_value.

Definition F_USR_OperatorPersistence : Prop :=
  operator_persisted.

Definition F_USR_AbstainBoundary : Prop :=
  F_USR_LossyReadout /\ F_USR_ObstructionGate.

Definition F_USR_ClaimTierBoundary : Prop :=
  finite_diagnostic_tier /\
  readout_not_truth.

Definition F_USR_FinalEquationReadout : Prop :=
  F_USR_SpineEquation /\
  F_USR_RegimeSplit /\
  F_USR_LossyReadout /\
  F_USR_ObstructionGate /\
  F_USR_TauCBus /\
  F_USR_InvariantReadout /\
  F_USR_OperatorPersistence /\
  F_USR_ClaimTierBoundary.

Definition usr_formula_of (n : SolverEquationNode) : Prop :=
  match n with
  | USR_AnchorRoot _ => True
  | N_USR_SpineEquation => F_USR_SpineEquation
  | N_USR_RegimeSplit => F_USR_RegimeSplit
  | N_USR_LossyReadout => F_USR_LossyReadout
  | N_USR_ObstructionGate => F_USR_ObstructionGate
  | N_USR_TauCBus => F_USR_TauCBus
  | N_USR_InvariantReadout => F_USR_InvariantReadout
  | N_USR_OperatorPersistence => F_USR_OperatorPersistence
  | N_USR_AbstainBoundary => F_USR_AbstainBoundary
  | N_USR_ClaimTierBoundary => F_USR_ClaimTierBoundary
  | N_USR_FinalEquationReadout => F_USR_FinalEquationReadout
  end.

Definition usr_rank (n : SolverEquationNode) : nat :=
  match n with
  | USR_AnchorRoot q => QRD.rank q
  | N_USR_SpineEquation => 800
  | N_USR_RegimeSplit => 810
  | N_USR_LossyReadout => 820
  | N_USR_ObstructionGate => 830
  | N_USR_TauCBus => 840
  | N_USR_InvariantReadout => 850
  | N_USR_OperatorPersistence => 860
  | N_USR_AbstainBoundary => 870
  | N_USR_ClaimTierBoundary => 880
  | N_USR_FinalEquationReadout => 890
  end.

Inductive USREdge : SolverEquationNode -> SolverEquationNode -> Prop :=
| USRE_Root : forall a b : QRD.QRNode,
    QRD.QREdge a b -> USREdge (USR_AnchorRoot a) (USR_AnchorRoot b)
| USRE_Variation_To_Spine :
    USREdge (USR_AnchorRoot QRD.N_Base_Variation) N_USR_SpineEquation
| USRE_Metric_To_Spine :
    USREdge (USR_AnchorRoot QRD.N_R_Metric) N_USR_SpineEquation
| USRE_Spine_To_Regime :
    USREdge N_USR_SpineEquation N_USR_RegimeSplit
| USRE_Regime_To_Readout :
    USREdge N_USR_RegimeSplit N_USR_LossyReadout
| USRE_Readout_To_Obstruction :
    USREdge N_USR_LossyReadout N_USR_ObstructionGate
| USRE_Obstruction_To_Tau :
    USREdge N_USR_ObstructionGate N_USR_TauCBus
| USRE_Tau_To_Invariant :
    USREdge N_USR_TauCBus N_USR_InvariantReadout
| USRE_Invariant_To_Operator :
    USREdge N_USR_InvariantReadout N_USR_OperatorPersistence
| USRE_Operator_To_Abstain :
    USREdge N_USR_OperatorPersistence N_USR_AbstainBoundary
| USRE_Abstain_To_ClaimTier :
    USREdge N_USR_AbstainBoundary N_USR_ClaimTierBoundary
| USRE_ClaimTier_To_Final :
    USREdge N_USR_ClaimTierBoundary N_USR_FinalEquationReadout.

Theorem usr_edge_rank :
  forall a b : SolverEquationNode,
    USREdge a b -> (usr_rank a < usr_rank b)%nat.
Proof.
  intros a b H.
  destruct H; simpl; try lia.
  apply QRD.edge_rank; exact H.
Qed.

Inductive USRPath : SolverEquationNode -> SolverEquationNode -> Prop :=
| USRP_edge : forall a b : SolverEquationNode, USREdge a b -> USRPath a b
| USRP_trans :
    forall a b c : SolverEquationNode,
      USRPath a b -> USRPath b c -> USRPath a c.

Theorem usr_path_rank :
  forall a b : SolverEquationNode,
    USRPath a b -> (usr_rank a < usr_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply usr_edge_rank; exact H.
  - eapply Nat.lt_trans; eauto.
Qed.

Theorem usr_dag_acyclic :
  forall n : SolverEquationNode, ~ USRPath n n.
Proof.
  intros n H.
  pose proof (usr_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

Definition usr_new_nodes : list SolverEquationNode :=
  [N_USR_SpineEquation;
   N_USR_RegimeSplit;
   N_USR_LossyReadout;
   N_USR_ObstructionGate;
   N_USR_TauCBus;
   N_USR_InvariantReadout;
   N_USR_OperatorPersistence;
   N_USR_AbstainBoundary;
   N_USR_ClaimTierBoundary;
   N_USR_FinalEquationReadout].

Definition all_usr_nodes : list SolverEquationNode :=
  map USR_AnchorRoot QRD.all_nodes ++ usr_new_nodes.

Theorem usr_nodes_complete :
  forall n : SolverEquationNode, In n all_usr_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_usr_nodes;
      apply in_or_app; left;
      apply in_map;
      apply usr_qr_nodes_complete
    ];
    unfold all_usr_nodes, usr_new_nodes;
    apply in_or_app; right;
    usr_member.
Qed.

End Quantum_Relativity_UniversalSolver_EquationReadout_Substrate.


(******************************************************************************)
(* Biological / viral / memory / cancer equation substrate.                    *)
(*                                                                            *)
(* Only equations and network constraints are added here.  These are readout   *)
(* candidates aligned with the universal-solver spine boundary, not claims     *)
(* that biological truth has been closed.                                      *)
(******************************************************************************)

Module Quantum_Relativity_BioNetwork_Equation_Substrate.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.
Module NUC := Quantum_Relativity_Nuclear_Reaction_Substrate.
Module USR := Quantum_Relativity_UniversalSolver_EquationReadout_Substrate.

Ltac bio_member :=
  simpl; repeat (first [left; reflexivity | right]).

Parameter Molecule Wavefunction Species Reaction StoichMatrix FluxVector ConcentrationVector : Type.
Parameter VirusT ReceptorT ComplexT GenomeT HostOutputT CapsidSubunitT VirionT : Type.
Parameter NetworkState CellState NeuralState : Type.
Parameter H_mol E_mol GibbsFreeEnergy Enthalpy BioTemperature BioEntropy : R.
Parameter V_conc R_conc VR_conc Kd_bind DeltaG_bind Rgas T_bio : R.
Parameter H_genome MutualInfo_genome_host : R.
Parameter n_subunits dg_subunit dG_electrostatic dG_bending : R.
Parameter dG_confinement dS_mix dG_assembly : R.
Parameter activation_barrier entry_rate prefactor : R.
Parameter N_matrix : StoichMatrix.
Parameter v_flux : ConcentrationVector -> FluxVector.
Parameter dxdt_bio stoich_apply : StoichMatrix -> FluxVector -> ConcentrationVector.
Parameter landscape_U grad_U information_input noise_term : NetworkState -> R.
Parameter state_flow : NetworkState -> R.
Parameter stable_attractor information_stored free_energy_constrained : NetworkState -> Prop.
Parameter synaptic_plasticity_encoded : NeuralState -> Prop.
Parameter pathological_cell_state genomic_instability epigenetic_memory : CellState -> Prop.
Parameter uncontrolled_proliferation : CellState -> Prop.
Parameter replicator_mutator_balance : Prop.

Inductive BioEquationNode : Type :=
| BIO_AnchorNuclear : NUC.NuclearReactionNode -> BioEquationNode
| BIO_AnchorSolver : USR.SolverEquationNode -> BioEquationNode
| N_BIO_AtomsFromNuclearSubstrate
| N_BIO_MolecularHamiltonian
| N_BIO_GibbsFreeEnergy
| N_BIO_ReactionNetwork
| N_BIO_MassActionKinetics
| N_BIO_BiopolymerInformation
| N_BIO_CapsidAssemblyFreeEnergy
| N_BIO_ReceptorBinding
| N_BIO_EntryBarrierCrossing
| N_BIO_HostNetworkCoupling
| N_BIO_NetworkAttractorEquation
| N_BIO_MemoryAttractor
| N_BIO_CancerAttractor
| N_BIO_FinalEquationReadout.

Definition F_BIO_AtomsFromNuclearSubstrate : Prop :=
  NUC.F_NUC_FinalReactionReadout \/ NUC.F_NUC_BindingEnergy.

Definition F_BIO_MolecularHamiltonian : Prop :=
  forall psi : Wavefunction, H_mol = E_mol.

Definition F_BIO_GibbsFreeEnergy : Prop :=
  GibbsFreeEnergy = Enthalpy - BioTemperature * BioEntropy.

Definition F_BIO_ReactionNetwork : Prop :=
  forall x : ConcentrationVector,
    dxdt_bio N_matrix (v_flux x) =
      stoich_apply N_matrix (v_flux x).

Definition F_BIO_MassActionKinetics : Prop :=
  forall x : ConcentrationVector,
    exists flux : FluxVector, v_flux x = flux.

Definition F_BIO_BiopolymerInformation : Prop :=
  H_genome >= 0 /\
  MutualInfo_genome_host >= 0.

Definition F_BIO_CapsidAssemblyFreeEnergy : Prop :=
  dG_assembly =
    n_subunits * dg_subunit +
    dG_electrostatic +
    dG_bending +
    dG_confinement -
    T_bio * dS_mix.

Definition F_BIO_ReceptorBinding : Prop :=
  VR_conc <> 0 /\
  Kd_bind = (V_conc * R_conc) / VR_conc /\
  DeltaG_bind = Rgas * T_bio * Kd_bind.

Definition F_BIO_EntryBarrierCrossing : Prop :=
  activation_barrier >= 0 /\
  entry_rate = prefactor *
    QRD.exp (- activation_barrier / (QRD.kB * T_bio)).

Definition F_BIO_HostNetworkCoupling : Prop :=
  F_BIO_ReactionNetwork /\
  F_BIO_BiopolymerInformation.

Definition F_BIO_NetworkAttractorEquation : Prop :=
  forall x : NetworkState,
    state_flow x =
      - grad_U x + information_input x + noise_term x.

Definition F_BIO_MemoryAttractor : Prop :=
  exists x_mem : NeuralState,
    synaptic_plasticity_encoded x_mem.

Definition F_BIO_CancerAttractor : Prop :=
  exists x_cancer : CellState,
    pathological_cell_state x_cancer /\
    genomic_instability x_cancer /\
    epigenetic_memory x_cancer /\
    uncontrolled_proliferation x_cancer.

Definition F_BIO_FinalEquationReadout : Prop :=
  F_BIO_AtomsFromNuclearSubstrate /\
  F_BIO_MolecularHamiltonian /\
  F_BIO_GibbsFreeEnergy /\
  F_BIO_ReactionNetwork /\
  F_BIO_BiopolymerInformation /\
  F_BIO_CapsidAssemblyFreeEnergy /\
  F_BIO_ReceptorBinding /\
  F_BIO_EntryBarrierCrossing /\
  F_BIO_NetworkAttractorEquation.

Definition bio_formula_of (n : BioEquationNode) : Prop :=
  match n with
  | BIO_AnchorNuclear _ => True
  | BIO_AnchorSolver _ => True
  | N_BIO_AtomsFromNuclearSubstrate => F_BIO_AtomsFromNuclearSubstrate
  | N_BIO_MolecularHamiltonian => F_BIO_MolecularHamiltonian
  | N_BIO_GibbsFreeEnergy => F_BIO_GibbsFreeEnergy
  | N_BIO_ReactionNetwork => F_BIO_ReactionNetwork
  | N_BIO_MassActionKinetics => F_BIO_MassActionKinetics
  | N_BIO_BiopolymerInformation => F_BIO_BiopolymerInformation
  | N_BIO_CapsidAssemblyFreeEnergy => F_BIO_CapsidAssemblyFreeEnergy
  | N_BIO_ReceptorBinding => F_BIO_ReceptorBinding
  | N_BIO_EntryBarrierCrossing => F_BIO_EntryBarrierCrossing
  | N_BIO_HostNetworkCoupling => F_BIO_HostNetworkCoupling
  | N_BIO_NetworkAttractorEquation => F_BIO_NetworkAttractorEquation
  | N_BIO_MemoryAttractor => F_BIO_MemoryAttractor
  | N_BIO_CancerAttractor => F_BIO_CancerAttractor
  | N_BIO_FinalEquationReadout => F_BIO_FinalEquationReadout
  end.

Definition bio_rank (n : BioEquationNode) : nat :=
  match n with
  | BIO_AnchorNuclear n0 => NUC.nuclear_rank n0
  | BIO_AnchorSolver s => (100 + USR.usr_rank s)%nat
  | N_BIO_AtomsFromNuclearSubstrate => 1000
  | N_BIO_MolecularHamiltonian => 1010
  | N_BIO_GibbsFreeEnergy => 1020
  | N_BIO_ReactionNetwork => 1030
  | N_BIO_MassActionKinetics => 1040
  | N_BIO_BiopolymerInformation => 1050
  | N_BIO_CapsidAssemblyFreeEnergy => 1060
  | N_BIO_ReceptorBinding => 1070
  | N_BIO_EntryBarrierCrossing => 1080
  | N_BIO_HostNetworkCoupling => 1090
  | N_BIO_NetworkAttractorEquation => 1100
  | N_BIO_MemoryAttractor => 1110
  | N_BIO_CancerAttractor => 1110
  | N_BIO_FinalEquationReadout => 1120
  end.

Inductive BioEquationEdge : BioEquationNode -> BioEquationNode -> Prop :=
| BIOE_Nuclear : forall a b : NUC.NuclearReactionNode,
    NUC.NuclearReactionEdge a b ->
    BioEquationEdge (BIO_AnchorNuclear a) (BIO_AnchorNuclear b)
| BIOE_Solver : forall a b : USR.SolverEquationNode,
    USR.USREdge a b ->
    BioEquationEdge (BIO_AnchorSolver a) (BIO_AnchorSolver b)
| BIOE_NuclearFinal_To_Atoms :
    BioEquationEdge
      (BIO_AnchorNuclear NUC.N_NUC_FinalReactionReadout)
      N_BIO_AtomsFromNuclearSubstrate
| BIOE_SolverFinal_To_ReactionNetwork :
    BioEquationEdge
      (BIO_AnchorSolver USR.N_USR_FinalEquationReadout)
      N_BIO_ReactionNetwork
| BIOE_Atoms_To_Molecular :
    BioEquationEdge N_BIO_AtomsFromNuclearSubstrate N_BIO_MolecularHamiltonian
| BIOE_Molecular_To_Gibbs :
    BioEquationEdge N_BIO_MolecularHamiltonian N_BIO_GibbsFreeEnergy
| BIOE_Gibbs_To_ReactionNetwork :
    BioEquationEdge N_BIO_GibbsFreeEnergy N_BIO_ReactionNetwork
| BIOE_ReactionNetwork_To_MassAction :
    BioEquationEdge N_BIO_ReactionNetwork N_BIO_MassActionKinetics
| BIOE_MassAction_To_Biopolymer :
    BioEquationEdge N_BIO_MassActionKinetics N_BIO_BiopolymerInformation
| BIOE_Biopolymer_To_Capsid :
    BioEquationEdge N_BIO_BiopolymerInformation N_BIO_CapsidAssemblyFreeEnergy
| BIOE_Capsid_To_Receptor :
    BioEquationEdge N_BIO_CapsidAssemblyFreeEnergy N_BIO_ReceptorBinding
| BIOE_Receptor_To_Entry :
    BioEquationEdge N_BIO_ReceptorBinding N_BIO_EntryBarrierCrossing
| BIOE_Entry_To_Host :
    BioEquationEdge N_BIO_EntryBarrierCrossing N_BIO_HostNetworkCoupling
| BIOE_Host_To_Attractor :
    BioEquationEdge N_BIO_HostNetworkCoupling N_BIO_NetworkAttractorEquation
| BIOE_Attractor_To_Memory :
    BioEquationEdge N_BIO_NetworkAttractorEquation N_BIO_MemoryAttractor
| BIOE_Attractor_To_Cancer :
    BioEquationEdge N_BIO_NetworkAttractorEquation N_BIO_CancerAttractor
| BIOE_Memory_To_Final :
    BioEquationEdge N_BIO_MemoryAttractor N_BIO_FinalEquationReadout
| BIOE_Cancer_To_Final :
    BioEquationEdge N_BIO_CancerAttractor N_BIO_FinalEquationReadout.

Theorem bio_edge_rank :
  forall a b : BioEquationNode,
    BioEquationEdge a b -> (bio_rank a < bio_rank b)%nat.
Proof.
  intros a b H.
  destruct H; simpl; try lia.
  - apply NUC.nuclear_edge_rank; exact H.
  - pose proof (USR.usr_edge_rank a b H); lia.
Qed.

Inductive BioEquationPath : BioEquationNode -> BioEquationNode -> Prop :=
| BIOP_edge :
    forall a b : BioEquationNode,
      BioEquationEdge a b -> BioEquationPath a b
| BIOP_trans :
    forall a b c : BioEquationNode,
      BioEquationPath a b -> BioEquationPath b c -> BioEquationPath a c.

Theorem bio_path_rank :
  forall a b : BioEquationNode,
    BioEquationPath a b -> (bio_rank a < bio_rank b)%nat.
Proof.
  intros a b H.
  induction H.
  - apply bio_edge_rank; exact H.
  - eapply Nat.lt_trans; eauto.
Qed.

Theorem bio_dag_acyclic :
  forall n : BioEquationNode, ~ BioEquationPath n n.
Proof.
  intros n H.
  pose proof (bio_path_rank n n H) as Hlt.
  apply Nat.lt_irrefl in Hlt.
  exact Hlt.
Qed.

Definition bio_new_nodes : list BioEquationNode :=
  [N_BIO_AtomsFromNuclearSubstrate;
   N_BIO_MolecularHamiltonian;
   N_BIO_GibbsFreeEnergy;
   N_BIO_ReactionNetwork;
   N_BIO_MassActionKinetics;
   N_BIO_BiopolymerInformation;
   N_BIO_CapsidAssemblyFreeEnergy;
   N_BIO_ReceptorBinding;
   N_BIO_EntryBarrierCrossing;
   N_BIO_HostNetworkCoupling;
   N_BIO_NetworkAttractorEquation;
   N_BIO_MemoryAttractor;
   N_BIO_CancerAttractor;
   N_BIO_FinalEquationReadout].

Definition all_bio_nodes : list BioEquationNode :=
  map BIO_AnchorNuclear NUC.all_nuclear_nodes ++
  map BIO_AnchorSolver USR.all_usr_nodes ++
  bio_new_nodes.

Theorem bio_nodes_complete :
  forall n : BioEquationNode, In n all_bio_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_bio_nodes;
      apply in_or_app; left;
      apply in_map;
      apply NUC.nuclear_nodes_complete
    ];
    try solve [
      unfold all_bio_nodes;
      apply in_or_app; right;
      apply in_or_app; left;
      apply in_map;
      apply USR.usr_nodes_complete
    ];
    unfold all_bio_nodes, bio_new_nodes;
    apply in_or_app; right;
    apply in_or_app; right;
    bio_member.
Qed.

End Quantum_Relativity_BioNetwork_Equation_Substrate.


(******************************************************************************)
(* All-node verification layer.                                                *)
(*                                                                            *)
(* This layer is intentionally proof-only: it adds finite node inventories and  *)
(* coverage theorems without changing any existing formula, edge, rank, or DAG. *)
(* If a constructor is added later but the corresponding list is not updated,   *)
(* the coverage theorem for that node family will fail to prove.               *)
(******************************************************************************)

Module Quantum_Relativity_All_Node_Checks.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.
Module PER := Quantum_Relativity_Perception_Extension.
Module STR := Quantum_Relativity_String_Readout_Extension.
Module SAB := Quantum_Relativity_String_AmplitudeBootstrap_NoImpact_Extension.
Module CLS := Quantum_Relativity_Readout_Closure_Extension.
Module MFV := Quantum_Relativity_MassFreeVisualBH_NoImpact_Extension.
Module COG := Quantum_Relativity_CognitiveRhythm_Occam_NoImpact_Extension.
Module PRE := Quantum_Relativity_PreReadout_Geometry_Substrate.
Module ITK := Quantum_Relativity_InfoThermoKnowledge_Substrate.
Module NUC := Quantum_Relativity_Nuclear_Reaction_Substrate.
Module USR := Quantum_Relativity_UniversalSolver_EquationReadout_Substrate.
Module BIO := Quantum_Relativity_BioNetwork_Equation_Substrate.

Ltac prove_member_literal :=
  simpl; repeat (first [left; reflexivity | right]).

Theorem qr_nodes_complete :
  forall n : QRD.QRNode, In n QRD.all_nodes.
Proof.
  intro n.
  destruct n; unfold QRD.all_nodes; prove_member_literal.
Qed.

Theorem enhanced_nodes_complete :
  forall n : PER.EnhancedNode, In n PER.all_enhanced_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold PER.all_enhanced_nodes;
      apply in_or_app; left;
      apply in_map;
      apply qr_nodes_complete
    ];
    unfold PER.all_enhanced_nodes;
    apply in_or_app; right;
    unfold PER.new_nodes; prove_member_literal.
Qed.

Definition string_readout_new_nodes : list STR.StringReadoutNode :=
  [STR.N_TREDD_RealityQGThread;
   STR.N_STR_StringLengthAlphaPrime;
   STR.N_STR_WorldsheetSigma;
   STR.N_STR_PolyakovAction;
   STR.N_STR_QuantizedString;
   STR.N_STR_OpenClosedSectors;
   STR.N_STR_MassSpectrum;
   STR.N_STR_ConformalInvariance;
   STR.N_STR_VirasoroConstraints;
   STR.N_STR_BetaFunctions;
   STR.N_STR_CriticalDimension;
   STR.N_STR_AnomalyCancellation;
   STR.N_STR_TargetMetric;
   STR.N_STR_BFieldDilaton;
   STR.N_STR_LowEnergyEffectiveAction;
   STR.N_STR_BetaToEinstein;
   STR.N_STR_AlphaPrimeCorrection;
   STR.N_STR_DBranes;
   STR.N_STR_OpenStringGaugeFields;
   STR.N_STR_AdSCFTDictionary;
   STR.N_STR_BulkBoundaryMap;
   STR.N_STR_EntanglementGeometry;
   STR.N_STR_CompactificationManifold;
   STR.N_STR_ModuliFields;
   STR.N_STR_EFTCouplings;
   STR.N_STR_ReadoutMassScales;
   STR.N_STR_DbraneMicrostates;
   STR.N_STR_CardyEntropy;
   STR.N_STR_BlackHoleEntropyReadout;
   STR.N_STR_InfoRecoveryChannel;
   STR.N_STR_Readout_GEOM;
   STR.N_STR_Readout_SPECTRUM;
   STR.N_STR_Readout_ENTROPY;
   STR.N_STR_Readout_HOLOGRAPHY;
   STR.N_STR_Readout_CORRECTIONS;
   STR.N_STR_Final_StringReadoutTheorem;
   STR.N_STR_Open_LandscapeSelection;
   STR.N_STR_Open_FullQGCompletion].

Definition all_string_readout_nodes : list STR.StringReadoutNode :=
  map STR.AnchorP PER.all_enhanced_nodes ++ string_readout_new_nodes.

Theorem string_readout_nodes_complete :
  forall n : STR.StringReadoutNode, In n all_string_readout_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_string_readout_nodes;
      apply in_or_app; left;
      apply in_map;
      apply enhanced_nodes_complete
    ];
    unfold all_string_readout_nodes;
    apply in_or_app; right;
    unfold string_readout_new_nodes; prove_member_literal.
Qed.

Definition string_amp_bootstrap_new_nodes : list SAB.StringAmplitudeBootstrapNode :=
  [SAB.N_SAB_LegacyNodesPreserved;
   SAB.N_SAB_ScatteringBootstrap;
   SAB.N_SAB_ReggeLimit;
   SAB.N_SAB_ReggeResidueZeros;
   SAB.N_SAB_UltrasoftRegge;
   SAB.N_SAB_MinimalZeros;
   SAB.N_SAB_LinearReggeSpectrum;
   SAB.N_SAB_VenezianoUniqueness;
   SAB.N_SAB_VirasoroShapiroUniqueness;
   SAB.N_SAB_FivePointBootstrap;
   SAB.N_SAB_StringAmplitudeBootstrapReadout].

Definition all_string_amp_bootstrap_nodes :
  list SAB.StringAmplitudeBootstrapNode :=
  map SAB.AnchorSTR all_string_readout_nodes ++ string_amp_bootstrap_new_nodes.

Theorem string_amp_bootstrap_nodes_complete :
  forall n : SAB.StringAmplitudeBootstrapNode,
    In n all_string_amp_bootstrap_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_string_amp_bootstrap_nodes;
      apply in_or_app; left;
      apply in_map;
      apply string_readout_nodes_complete
    ];
    unfold all_string_amp_bootstrap_nodes;
    apply in_or_app; right;
    unfold string_amp_bootstrap_new_nodes; prove_member_literal.
Qed.

Definition closure_new_nodes : list CLS.ClosureNode :=
  [CLS.N_CLS_SourceNodesRemainVisible;
   CLS.N_CLS_BH_NullGeodesicBundle;
   CLS.N_CLS_BH_OpticalJacobian;
   CLS.N_CLS_BH_MagnificationReadout;
   CLS.N_CLS_BH_RedshiftTimeReadout;
   CLS.N_CLS_NeuralChannelKernel;
   CLS.N_CLS_NeuralFisherMetric;
   CLS.N_CLS_NeuralTimeWindow;
   CLS.N_CLS_InformationVolumeRatio;
   CLS.N_CLS_ReadoutJacobianInvariant;
   CLS.N_CLS_TimeScaleInvariant;
   CLS.N_CLS_CrossDomainEquals;
   CLS.N_CLS_LandscapeScoreFunctional;
   CLS.N_CLS_LandscapeAdmissibleSet;
   CLS.N_CLS_SelectedVacuumReadout;
   CLS.N_CLS_LandscapeSelectionClosed;
   CLS.N_CLS_QGStateSpace;
   CLS.N_CLS_QGReadoutFunctor;
   CLS.N_CLS_SemiclassicalRecovery;
   CLS.N_CLS_StringRecovery;
   CLS.N_CLS_ChannelRecovery;
   CLS.N_CLS_FullQGCompletionClosed;
   CLS.N_CLS_FinalConnectedReadoutTheorem].

Definition all_closure_nodes : list CLS.ClosureNode :=
  map CLS.AnchorS all_string_readout_nodes ++ closure_new_nodes.

Theorem closure_nodes_complete :
  forall n : CLS.ClosureNode, In n all_closure_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_closure_nodes;
      apply in_or_app; left;
      apply in_map;
      apply string_readout_nodes_complete
    ];
    unfold all_closure_nodes;
    apply in_or_app; right;
    unfold closure_new_nodes; prove_member_literal.
Qed.

Definition mfv_new_nodes : list MFV.MFVNode :=
  [MFV.N_MFV_VisiblePhotonWavelength;
   MFV.N_MFV_VisualPhotonEnergy;
   MFV.N_MFV_VisualShadowScale;
   MFV.N_MFV_CriticalImpactShadow;
   MFV.N_MFV_MassFreeMetricHorizon;
   MFV.N_MFV_MassFreeHorizonScale;
   MFV.N_MFV_TrappingHorizonCondition;
   MFV.N_MFV_MassRemovedAsGenerator;
   MFV.N_MFV_HorizonGeneratedByOpticalCausalTrapping;
   MFV.N_MFV_MassFreeVisualBlackHole].

Definition all_mfv_nodes : list MFV.MFVNode :=
  map MFV.AnchorC all_closure_nodes ++ mfv_new_nodes.

Theorem mfv_nodes_complete :
  forall n : MFV.MFVNode, In n all_mfv_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_mfv_nodes;
      apply in_or_app; left;
      apply in_map;
      apply closure_nodes_complete
    ];
    unfold all_mfv_nodes;
    apply in_or_app; right;
    unfold mfv_new_nodes; prove_member_literal.
Qed.

Definition cognitive_new_nodes : list COG.CognitiveNode :=
  [COG.N_COG_VisualShadowAnchor;
   COG.N_COG_AuditoryFrequencyAnchor;
   COG.N_COG_CognitiveFrame_060s;
   COG.N_COG_SchumannEarthBoundary;
   COG.N_COG_VisualCyclesPerFrame;
   COG.N_COG_AuditoryCyclesPerFrame;
   COG.N_COG_EarthCyclesPerFrame;
   COG.N_COG_OccamBoundaryGate;
   COG.N_COG_MultiscalePerceptionFrame;
   COG.N_COG_FinalCognitiveRhythmReadout].

Definition all_cognitive_nodes : list COG.CognitiveNode :=
  map COG.AnchorM all_mfv_nodes ++ cognitive_new_nodes.

Theorem cognitive_nodes_complete :
  forall n : COG.CognitiveNode, In n all_cognitive_nodes.
Proof.
  intro n.
  destruct n;
    try solve [
      unfold all_cognitive_nodes;
      apply in_or_app; left;
      apply in_map;
      apply mfv_nodes_complete
    ];
    unfold all_cognitive_nodes;
    apply in_or_app; right;
    unfold cognitive_new_nodes; prove_member_literal.
Qed.

Theorem all_node_families_complete :
  (forall n : QRD.QRNode, In n QRD.all_nodes) /\
  (forall n : PER.EnhancedNode, In n PER.all_enhanced_nodes) /\
  (forall n : STR.StringReadoutNode, In n all_string_readout_nodes) /\
  (forall n : SAB.StringAmplitudeBootstrapNode,
      In n all_string_amp_bootstrap_nodes) /\
  (forall n : CLS.ClosureNode, In n all_closure_nodes) /\
  (forall n : MFV.MFVNode, In n all_mfv_nodes) /\
  (forall n : COG.CognitiveNode, In n all_cognitive_nodes) /\
  (forall n : PRE.PreReadoutNode, In n PRE.all_pre_nodes) /\
  (forall n : ITK.ITKNode, In n ITK.all_itk_nodes) /\
  (forall n : NUC.NuclearReactionNode, In n NUC.all_nuclear_nodes) /\
  (forall n : USR.SolverEquationNode, In n USR.all_usr_nodes) /\
  (forall n : BIO.BioEquationNode, In n BIO.all_bio_nodes).
Proof.
  repeat split.
  - apply qr_nodes_complete.
  - apply enhanced_nodes_complete.
  - apply string_readout_nodes_complete.
  - apply string_amp_bootstrap_nodes_complete.
  - apply closure_nodes_complete.
  - apply mfv_nodes_complete.
  - apply cognitive_nodes_complete.
  - apply PRE.pre_nodes_complete.
  - apply ITK.itk_nodes_complete.
  - apply NUC.nuclear_nodes_complete.
  - apply USR.usr_nodes_complete.
  - apply BIO.bio_nodes_complete.
Qed.

Theorem all_dag_acyclicity_checks :
  (forall n : QRD.QRNode, ~ QRD.QRPath n n) /\
  (forall n : PER.EnhancedNode, ~ PER.EnhancedPath n n) /\
  (forall n : STR.StringReadoutNode, ~ STR.StringReadoutPath n n) /\
  (forall n : SAB.StringAmplitudeBootstrapNode,
      ~ SAB.StringAmplitudeBootstrapPath n n) /\
  (forall n : CLS.ClosureNode, ~ CLS.ClosurePath n n) /\
  (forall n : MFV.MFVNode, ~ MFV.MFVPath n n) /\
  (forall n : COG.CognitiveNode, ~ COG.CognitivePath n n) /\
  (forall n : PRE.PreReadoutNode, ~ PRE.PreReadoutPath n n) /\
  (forall n : ITK.ITKNode, ~ ITK.ITKPath n n) /\
  (forall n : NUC.NuclearReactionNode, ~ NUC.NuclearReactionPath n n) /\
  (forall n : USR.SolverEquationNode, ~ USR.USRPath n n) /\
  (forall n : BIO.BioEquationNode, ~ BIO.BioEquationPath n n).
Proof.
  repeat split.
  - apply QRD.qr_dag_acyclic.
  - apply PER.enhanced_dag_acyclic.
  - apply STR.string_readout_dag_acyclic.
  - apply SAB.string_amp_bootstrap_dag_acyclic.
  - apply CLS.closure_dag_acyclic.
  - apply MFV.mfv_dag_acyclic.
  - apply COG.cognitive_dag_acyclic.
  - apply PRE.pre_dag_acyclic.
  - apply ITK.itk_dag_acyclic.
  - apply NUC.nuclear_dag_acyclic.
  - apply USR.usr_dag_acyclic.
  - apply BIO.bio_dag_acyclic.
Qed.

End Quantum_Relativity_All_Node_Checks.


(* ================================================================ *)
(* MERGED RDU MACHINIC MEASUREMENT READOUT                         *)
(* ================================================================ *)

From Coq Require Import QArith.QArith.
From Coq Require Import ZArith.ZArith.
From Coq Require Import Bool.Bool.

Module RDU_Machinic_Measurement_Readout.

(*
  RDU_Machinic_Measurement_Readout.v

  Goal:
    - Every readout passes through one structural unit:
        1 d_{tau,L_R,Omega}
    - Every quantity carries a dimension and a measurement/source flag.
    - The universal/root equation is a discrete, measurable spine.
    - Forces are read back as SI-force quantities when their dimension is Newton:
        [F] = M L T^-2.
    - This file is a measurement grammar, not a derivation of physical constants.

  Intended claim tier:
    TIER0/TIER1 structural Coq grammar + finite diagnostic examples.
    Physical numbers remain lab-measured / fitted inputs.
*)

Import ListNotations.
Open Scope Q_scope.

(* ================================================================ *)
(* 1. DIMENSIONAL GRAMMAR                                           *)
(* ================================================================ *)

Record Dim := mkDim {
  dL  : Z;  (* length             meter       *)
  dM  : Z;  (* mass               kilogram    *)
  dT  : Z;  (* time               second      *)
  dI  : Z;  (* electric current   ampere      *)
  dTh : Z;  (* temperature        kelvin      *)
  dN  : Z;  (* amount             mole        *)
  dJ  : Z   (* luminous intensity candela     *)
}.

Definition dim_eqb (a b : Dim) : bool :=
  Z.eqb (dL a)  (dL b)  &&
  Z.eqb (dM a)  (dM b)  &&
  Z.eqb (dT a)  (dT b)  &&
  Z.eqb (dI a)  (dI b)  &&
  Z.eqb (dTh a) (dTh b) &&
  Z.eqb (dN a)  (dN b)  &&
  Z.eqb (dJ a)  (dJ b).

Definition dim_add (a b : Dim) : Dim :=
  mkDim
    (Z.add (dL a)  (dL b))
    (Z.add (dM a)  (dM b))
    (Z.add (dT a)  (dT b))
    (Z.add (dI a)  (dI b))
    (Z.add (dTh a) (dTh b))
    (Z.add (dN a)  (dN b))
    (Z.add (dJ a)  (dJ b)).

Definition dim_opp (a : Dim) : Dim :=
  mkDim
    (Z.opp (dL a))
    (Z.opp (dM a))
    (Z.opp (dT a))
    (Z.opp (dI a))
    (Z.opp (dTh a))
    (Z.opp (dN a))
    (Z.opp (dJ a)).

Definition dim_sub (a b : Dim) : Dim :=
  dim_add a (dim_opp b).

Definition dim_pow2 (a : Dim) : Dim :=
  dim_add a a.

Definition dim_dimensionless : Dim :=
  mkDim 0%Z 0%Z 0%Z 0%Z 0%Z 0%Z 0%Z.

Definition dim_length : Dim :=
  mkDim 1%Z 0%Z 0%Z 0%Z 0%Z 0%Z 0%Z.

Definition dim_mass : Dim :=
  mkDim 0%Z 1%Z 0%Z 0%Z 0%Z 0%Z 0%Z.

Definition dim_time : Dim :=
  mkDim 0%Z 0%Z 1%Z 0%Z 0%Z 0%Z 0%Z.

Definition dim_current : Dim :=
  mkDim 0%Z 0%Z 0%Z 1%Z 0%Z 0%Z 0%Z.

Definition dim_temperature : Dim :=
  mkDim 0%Z 0%Z 0%Z 0%Z 1%Z 0%Z 0%Z.

Definition dim_amount : Dim :=
  mkDim 0%Z 0%Z 0%Z 0%Z 0%Z 1%Z 0%Z.

Definition dim_luminous : Dim :=
  mkDim 0%Z 0%Z 0%Z 0%Z 0%Z 0%Z 1%Z.

Definition dim_velocity : Dim :=
  dim_sub dim_length dim_time.              (* L T^-1 *)

Definition dim_acceleration : Dim :=
  dim_sub dim_length (dim_pow2 dim_time).   (* L T^-2 *)

Definition dim_frequency : Dim :=
  dim_opp dim_time.                         (* T^-1 *)

Definition dim_energy : Dim :=
  mkDim 2%Z 1%Z (-2)%Z 0%Z 0%Z 0%Z 0%Z.     (* M L^2 T^-2 *)

Definition dim_force : Dim :=
  mkDim 1%Z 1%Z (-2)%Z 0%Z 0%Z 0%Z 0%Z.     (* M L T^-2 *)

Definition dim_action : Dim :=
  mkDim 2%Z 1%Z (-1)%Z 0%Z 0%Z 0%Z 0%Z.     (* M L^2 T^-1 *)

Definition dim_charge : Dim :=
  dim_add dim_current dim_time.             (* I T *)

Definition dim_electric_field : Dim :=
  dim_sub dim_force dim_charge.             (* N / C = M L T^-3 I^-1 *)

Definition dim_magnetic_field : Dim :=
  mkDim 0%Z 1%Z (-2)%Z (-1)%Z 0%Z 0%Z 0%Z.  (* tesla = M T^-2 I^-1 *)

Definition dim_kB : Dim :=
  dim_sub dim_energy dim_temperature.       (* J / K *)

Definition dim_info : Dim :=
  dim_dimensionless.                        (* bit/nat is dimensionless but readout-typed *)

Definition dim_area : Dim :=
  dim_pow2 dim_length.                      (* L^2 *)

Definition dim_volume : Dim :=
  dim_add dim_area dim_length.              (* L^3 *)

Definition dim_jerk : Dim :=
  dim_sub dim_length (dim_add dim_time (dim_pow2 dim_time)).  (* L T^-3 *)

Definition dim_wavenumber : Dim :=
  dim_opp dim_length.                       (* L^-1 *)

Definition dim_curvature : Dim :=
  dim_opp dim_area.                         (* L^-2 *)

Definition dim_momentum : Dim :=
  dim_add dim_mass dim_velocity.            (* M L T^-1 *)

Definition dim_power : Dim :=
  dim_sub dim_energy dim_time.              (* M L^2 T^-3 *)

Definition dim_pressure : Dim :=
  dim_sub dim_force dim_area.               (* M L^-1 T^-2 *)

Definition dim_density : Dim :=
  dim_sub dim_mass dim_volume.              (* M L^-3 *)

Definition dim_diffusion : Dim :=
  dim_sub dim_area dim_time.                (* L^2 T^-1 *)

Definition dim_voltage : Dim :=
  dim_sub dim_power dim_current.            (* M L^2 T^-3 I^-1 *)

Definition dim_molar_energy : Dim :=
  dim_sub dim_energy dim_amount.            (* J / mol *)

Definition dim_resistance : Dim :=
  dim_sub dim_voltage dim_current.          (* M L^2 T^-3 I^-2 *)

Definition dim_conductance : Dim :=
  dim_opp dim_resistance.                   (* M^-1 L^-2 T^3 I^2 *)

Definition dim_capacitance : Dim :=
  dim_sub dim_charge dim_voltage.           (* M^-1 L^-2 T^4 I^2 *)

Definition dim_magnetic_flux : Dim :=
  dim_add dim_voltage dim_time.             (* M L^2 T^-2 I^-1 *)

Definition dim_inductance : Dim :=
  dim_sub dim_magnetic_flux dim_current.    (* M L^2 T^-2 I^-2 *)

Definition dim_permittivity : Dim :=
  dim_sub dim_capacitance dim_length.       (* M^-1 L^-3 T^4 I^2 *)

Definition dim_permeability : Dim :=
  dim_sub dim_force (dim_pow2 dim_current). (* M L T^-2 I^-2 *)


(* ================================================================ *)
(* 2. QUANTITIES AND MEASURED QUANTITIES                            *)
(* ================================================================ *)

Record Quantity := mkQuantity {
  q_val : Q;
  q_dim : Dim
}.

Definition qscale (a : Q) (x : Quantity) : Quantity :=
  mkQuantity (a * q_val x) (q_dim x).

Definition qneg (x : Quantity) : Quantity :=
  mkQuantity (- q_val x) (q_dim x).

Definition qmul (x y : Quantity) : Quantity :=
  mkQuantity (q_val x * q_val y) (dim_add (q_dim x) (q_dim y)).

Definition qdiv (x y : Quantity) : Quantity :=
  mkQuantity (q_val x / q_val y) (dim_sub (q_dim x) (q_dim y)).

Definition qadd_option (x y : Quantity) : option Quantity :=
  if dim_eqb (q_dim x) (q_dim y)
  then Some (mkQuantity (q_val x + q_val y) (q_dim x))
  else None.

Definition qsub_option (x y : Quantity) : option Quantity :=
  if dim_eqb (q_dim x) (q_dim y)
  then Some (mkQuantity (q_val x - q_val y) (q_dim x))
  else None.

Record MeasuredQuantity := mkMeasured {
  mq_quantity : Quantity;
  mq_uncertainty : Q;
  mq_source_declared : bool;
  mq_nonzero_cert : bool
  (* mq_nonzero_cert is used only where division by this measured value is intended.
     It is a measurement certificate, not a proof that the world value is exact. *)
}.

Definition mq_val (x : MeasuredQuantity) : Q :=
  q_val (mq_quantity x).

Definition mq_dim (x : MeasuredQuantity) : Dim :=
  q_dim (mq_quantity x).

Definition measured_dim_ok (x : MeasuredQuantity) (d : Dim) : bool :=
  dim_eqb (mq_dim x) d.

Definition measured_source_ok (x : MeasuredQuantity) : bool :=
  mq_source_declared x.

Definition measured_as (v : Q) (d : Dim) : MeasuredQuantity :=
  mkMeasured (mkQuantity v d) 0 true true.

Definition measured_derived (x : Quantity) : MeasuredQuantity :=
  mkMeasured x 0 true true.

Definition measured_mul (x y : MeasuredQuantity) : MeasuredQuantity :=
  mkMeasured
    (qmul (mq_quantity x) (mq_quantity y))
    (mq_uncertainty x + mq_uncertainty y)
    (mq_source_declared x && mq_source_declared y)
    true.

Definition measured_div (x y : MeasuredQuantity) : MeasuredQuantity :=
  mkMeasured
    (qdiv (mq_quantity x) (mq_quantity y))
    (mq_uncertainty x + mq_uncertainty y)
    (mq_source_declared x && mq_source_declared y && mq_nonzero_cert y)
    true.

Definition measured_scale (a : Q) (x : MeasuredQuantity) : MeasuredQuantity :=
  mkMeasured
    (qscale a (mq_quantity x))
    (mq_uncertainty x)
    (mq_source_declared x)
    (mq_nonzero_cert x).

Definition measured_neg (x : MeasuredQuantity) : MeasuredQuantity :=
  mkMeasured
    (qneg (mq_quantity x))
    (mq_uncertainty x)
    (mq_source_declared x)
    (mq_nonzero_cert x).


(* ================================================================ *)
(* 3. ONE ROOT UNIT: RDU                                            *)
(* ================================================================ *)

Inductive ReadoutChannel : Type :=
| RO_Time
| RO_Length
| RO_Frequency
| RO_Energy
| RO_Mass
| RO_Information
| RO_ThermalErase
| RO_Force.

Record RDU := mkRDU {
  rdu_tau  : MeasuredQuantity;  (* seconds *)
  rdu_c    : MeasuredQuantity;  (* m/s *)
  rdu_hbar : MeasuredQuantity;  (* J s *)
  rdu_kB   : MeasuredQuantity;  (* J/K *)
  rdu_T    : MeasuredQuantity;  (* K *)
  rdu_ln2  : MeasuredQuantity   (* dimensionless measured constant or approximation *)
}.

Definition rdu_dim_ok (u : RDU) : bool :=
  measured_dim_ok (rdu_tau u)  dim_time &&
  measured_dim_ok (rdu_c u)    dim_velocity &&
  measured_dim_ok (rdu_hbar u) dim_action &&
  measured_dim_ok (rdu_kB u)   dim_kB &&
  measured_dim_ok (rdu_T u)    dim_temperature &&
  measured_dim_ok (rdu_ln2 u)  dim_dimensionless.

Definition rdu_sources_ok (u : RDU) : bool :=
  measured_source_ok (rdu_tau u)  &&
  measured_source_ok (rdu_c u)    &&
  measured_source_ok (rdu_hbar u) &&
  measured_source_ok (rdu_kB u)   &&
  measured_source_ok (rdu_T u)    &&
  measured_source_ok (rdu_ln2 u).

(* All readouts pass through the same root unit. *)

Definition RDU_time_readout (u : RDU) : MeasuredQuantity :=
  rdu_tau u.

Definition RDU_length_readout (u : RDU) : MeasuredQuantity :=
  measured_mul (rdu_c u) (rdu_tau u).       (* l = c tau *)

Definition RDU_frequency_readout (u : RDU) : MeasuredQuantity :=
  measured_div (measured_as 1 dim_dimensionless) (rdu_tau u).  (* f = 1/tau *)

Definition RDU_energy_readout (u : RDU) : MeasuredQuantity :=
  measured_div (rdu_hbar u) (measured_scale 2 (rdu_tau u)).    (* E = hbar/(2 tau) *)

Definition RDU_mass_readout (u : RDU) : MeasuredQuantity :=
  let two_tau := measured_scale 2 (rdu_tau u) in
  let c2 := measured_mul (rdu_c u) (rdu_c u) in
  measured_div (rdu_hbar u) (measured_mul two_tau c2).          (* m = hbar/(2 tau c^2) *)

Definition causal_memory_time_from_mass
  (hbar mass c : MeasuredQuantity) : MeasuredQuantity :=
  let c2 := measured_mul c c in
  measured_div hbar (measured_scale 2 (measured_mul mass c2)).
  (* tau_c = hbar/(2 m c^2); this is a coordinate readback from a measured mass,
     not a derivation of that mass from first principles. *)

Definition causal_memory_mass_bridge_dim_ok
  (hbar mass c : MeasuredQuantity) : bool :=
  measured_dim_ok hbar dim_action &&
  measured_dim_ok mass dim_mass &&
  measured_dim_ok c dim_velocity &&
  measured_dim_ok (causal_memory_time_from_mass hbar mass c) dim_time.

Definition causal_memory_rate_readout (tau_c : MeasuredQuantity) : MeasuredQuantity :=
  measured_div (measured_as 1 dim_dimensionless) tau_c.
  (* gamma = 1/tau_c. *)

Definition causal_memory_energy_readout
  (hbar tau_c : MeasuredQuantity) : MeasuredQuantity :=
  measured_div hbar (measured_scale 2 tau_c).
  (* E_c = hbar/(2 tau_c). *)

Definition causal_memory_length_readout
  (c tau_c : MeasuredQuantity) : MeasuredQuantity :=
  measured_mul c tau_c.
  (* L_c = c tau_c. *)

Definition causal_memory_time_ratio
  (tau_a tau_b : MeasuredQuantity) : MeasuredQuantity :=
  measured_div tau_a tau_b.
  (* tau_a/tau_b = m_b/m_a when both tau values are extracted from measured masses. *)

Definition causal_memory_readout_tuple_dim_ok
  (hbar c tau_c : MeasuredQuantity) : bool :=
  measured_dim_ok tau_c dim_time &&
  measured_dim_ok (causal_memory_rate_readout tau_c) dim_frequency &&
  measured_dim_ok (causal_memory_energy_readout hbar tau_c) dim_energy &&
  measured_dim_ok (causal_memory_length_readout c tau_c) dim_length.

Definition causal_memory_time_ratio_dim_ok
  (tau_a tau_b : MeasuredQuantity) : bool :=
  measured_dim_ok tau_a dim_time &&
  measured_dim_ok tau_b dim_time &&
  measured_dim_ok (causal_memory_time_ratio tau_a tau_b) dim_dimensionless.

Definition finite_speed_memory_dim_ok
  (diffusion tau_c speed : MeasuredQuantity) : bool :=
  measured_dim_ok diffusion dim_diffusion &&
  measured_dim_ok tau_c dim_time &&
  measured_dim_ok speed dim_velocity &&
  dim_eqb (dim_sub (mq_dim diffusion) (mq_dim tau_c)) (dim_pow2 dim_velocity).
  (* v^2 has the same dimension as D/tau_c.  This checks finite-speed
     compatibility without claiming a numeric square root. *)

Definition regime_cutoff_dim_ok
  (tau_c diffusion k_c : MeasuredQuantity) : bool :=
  measured_dim_ok tau_c dim_time &&
  measured_dim_ok diffusion dim_diffusion &&
  measured_dim_ok k_c dim_wavenumber &&
  dim_eqb
    (dim_add (dim_pow2 (mq_dim k_c))
             (dim_add (mq_dim tau_c) (mq_dim diffusion)))
    dim_dimensionless.
  (* k_c^2 tau_c D is dimensionless for k_c = 1/(2 sqrt(tau_c D)). *)

Definition coupling_gap_readout
  (gap : Q) : MeasuredQuantity :=
  measured_as gap dim_dimensionless.
  (* Dimensionless couplings open scale gaps; this records the computed ratio,
     not a derivation of the coupling itself. *)

Definition residual_scale_readout
  (residual : MeasuredQuantity) (tau_c : MeasuredQuantity) : MeasuredQuantity :=
  measured_mul residual tau_c.
  (* A typed placeholder for Res(tau_c)-indexed diagnostics.  The value is a
     residual weighted by the scale coordinate; model-specific interpretation
     remains outside this root node. *)

Definition RDU_information_readout (_u : RDU) : MeasuredQuantity :=
  measured_as 1 dim_info.                                      (* one retained distinction *)

Definition RDU_thermal_erase_readout (u : RDU) : MeasuredQuantity :=
  measured_mul (measured_mul (rdu_kB u) (rdu_T u)) (rdu_ln2 u).  (* kB T ln 2 *)

Definition RDU_readout (u : RDU) (ch : ReadoutChannel) : option MeasuredQuantity :=
  match ch with
  | RO_Time         => Some (RDU_time_readout u)
  | RO_Length       => Some (RDU_length_readout u)
  | RO_Frequency    => Some (RDU_frequency_readout u)
  | RO_Energy       => Some (RDU_energy_readout u)
  | RO_Mass         => Some (RDU_mass_readout u)
  | RO_Information  => Some (RDU_information_readout u)
  | RO_ThermalErase => Some (RDU_thermal_erase_readout u)
  | RO_Force        => None
      (* Force requires a measured spine state:
         F_root = - K L_R Phi - gradV(Phi). *)
  end.


(* ================================================================ *)
(* 4. MEASURABLE UNIVERSAL SPINE                                    *)
(* ================================================================ *)

Record SpineSample := mkSpineSample {
  sp_dt       : MeasuredQuantity;  (* time step *)
  sp_phi_prev : MeasuredQuantity;
  sp_phi_now  : MeasuredQuantity;
  sp_phi_next : MeasuredQuantity;

  sp_M        : MeasuredQuantity;
  sp_D        : MeasuredQuantity;
  sp_K        : MeasuredQuantity;

  (* L_R Phi is supplied as an inferred/measured operator readout.
     This file checks dimensions and computes the resulting term. *)
  sp_LR_phi   : MeasuredQuantity;
  sp_gradV    : MeasuredQuantity;

  sp_J        : MeasuredQuantity;
  sp_eta      : MeasuredQuantity
}.

Definition same_phi_dims (s : SpineSample) : bool :=
  dim_eqb (mq_dim (sp_phi_prev s)) (mq_dim (sp_phi_now s)) &&
  dim_eqb (mq_dim (sp_phi_now s))  (mq_dim (sp_phi_next s)).

Definition d1_phi (s : SpineSample) : MeasuredQuantity :=
  (* central difference: (phi[n+1]-phi[n-1])/(2 dt) *)
  let v := (mq_val (sp_phi_next s) - mq_val (sp_phi_prev s))
           / (2 * mq_val (sp_dt s)) in
  let d := dim_sub (mq_dim (sp_phi_now s)) dim_time in
  mkMeasured
    (mkQuantity v d)
    (mq_uncertainty (sp_phi_prev s) + mq_uncertainty (sp_phi_next s) + mq_uncertainty (sp_dt s))
    (mq_source_declared (sp_phi_prev s) &&
     mq_source_declared (sp_phi_next s) &&
     mq_source_declared (sp_dt s) &&
     mq_nonzero_cert (sp_dt s))
    true.

Definition d2_phi (s : SpineSample) : MeasuredQuantity :=
  (* second difference: (phi[n+1]-2 phi[n]+phi[n-1])/(dt^2) *)
  let numerator :=
    mq_val (sp_phi_next s) - 2 * mq_val (sp_phi_now s) + mq_val (sp_phi_prev s) in
  let denom := mq_val (sp_dt s) * mq_val (sp_dt s) in
  let v := numerator / denom in
  let d := dim_sub (mq_dim (sp_phi_now s)) (dim_pow2 dim_time) in
  mkMeasured
    (mkQuantity v d)
    (mq_uncertainty (sp_phi_prev s) +
     mq_uncertainty (sp_phi_now s) +
     mq_uncertainty (sp_phi_next s) +
     mq_uncertainty (sp_dt s))
    (mq_source_declared (sp_phi_prev s) &&
     mq_source_declared (sp_phi_now s) &&
     mq_source_declared (sp_phi_next s) &&
     mq_source_declared (sp_dt s) &&
     mq_nonzero_cert (sp_dt s))
    true.

Definition term_inertia (s : SpineSample) : MeasuredQuantity :=
  measured_mul (sp_M s) (d2_phi s).

Definition term_damping (s : SpineSample) : MeasuredQuantity :=
  measured_mul (sp_D s) (d1_phi s).

Definition term_geometry (s : SpineSample) : MeasuredQuantity :=
  measured_mul (sp_K s) (sp_LR_phi s).

Definition term_nonlinear (s : SpineSample) : MeasuredQuantity :=
  sp_gradV s.

Definition spine_common_dim_ok (s : SpineSample) : bool :=
  let d0 := mq_dim (term_inertia s) in
  dim_eqb d0 (mq_dim (term_damping s)) &&
  dim_eqb d0 (mq_dim (term_geometry s)) &&
  dim_eqb d0 (mq_dim (term_nonlinear s)) &&
  dim_eqb d0 (mq_dim (sp_J s)) &&
  dim_eqb d0 (mq_dim (sp_eta s)).

Definition spine_sources_ok (s : SpineSample) : bool :=
  mq_source_declared (sp_dt s) &&
  mq_source_declared (sp_phi_prev s) &&
  mq_source_declared (sp_phi_now s) &&
  mq_source_declared (sp_phi_next s) &&
  mq_source_declared (sp_M s) &&
  mq_source_declared (sp_D s) &&
  mq_source_declared (sp_K s) &&
  mq_source_declared (sp_LR_phi s) &&
  mq_source_declared (sp_gradV s) &&
  mq_source_declared (sp_J s) &&
  mq_source_declared (sp_eta s).

Definition spine_gate (s : SpineSample) : bool :=
  same_phi_dims s &&
  mq_nonzero_cert (sp_dt s) &&
  spine_common_dim_ok s &&
  spine_sources_ok s.

Definition spine_lhs_value (s : SpineSample) : Q :=
  mq_val (term_inertia s) +
  mq_val (term_damping s) +
  mq_val (term_geometry s) +
  mq_val (term_nonlinear s).

Definition spine_rhs_value (s : SpineSample) : Q :=
  mq_val (sp_J s) - mq_val (sp_eta s).

Definition spine_residual_value (s : SpineSample) : Q :=
  spine_lhs_value s - spine_rhs_value s.

Definition spine_residual_readout (s : SpineSample) : MeasuredQuantity :=
  mkMeasured
    (mkQuantity (spine_residual_value s) (mq_dim (term_inertia s)))
    (mq_uncertainty (term_inertia s) +
     mq_uncertainty (term_damping s) +
     mq_uncertainty (term_geometry s) +
     mq_uncertainty (term_nonlinear s) +
     mq_uncertainty (sp_J s) +
     mq_uncertainty (sp_eta s))
    (spine_gate s)
    true.

Definition root_force_readout (s : SpineSample) : MeasuredQuantity :=
  (* F_root = - K L_R Phi - gradV(Phi) *)
  mkMeasured
    (mkQuantity
       (-(mq_val (term_geometry s) + mq_val (term_nonlinear s)))
       (mq_dim (term_geometry s)))
    (mq_uncertainty (term_geometry s) + mq_uncertainty (term_nonlinear s))
    (spine_gate s)
    true.

Definition force_to_SI_newton (f : MeasuredQuantity) : option Q :=
  if dim_eqb (mq_dim f) dim_force
  then Some (mq_val f)
  else None.


(* ================================================================ *)
(* 5. FORCE TAXONOMY: FUNDAMENTAL AND EFFECTIVE READOUTS            *)
(* ================================================================ *)

Inductive ForceOrigin : Type :=
| Origin_U1_EM
| Origin_SU2_Weak
| Origin_SU3_Strong
| Origin_Metric_Gravity
| Origin_Residual_Strong
| Origin_Residual_EM
| Origin_FreeEnergyGradient
| Origin_PressureGradient
| Origin_FrameArtifact
| Origin_MediumEffective
| Origin_Unknown.

Inductive ForceKind : Type :=
| Force_EM_Lorentz
| Force_Strong_QCD
| Force_Weak_EW
| Force_Gravity
| Force_NuclearResidual
| Force_ChemicalBond
| Force_VanDerWaals
| Force_Normal
| Force_Friction
| Force_Tension
| Force_Elastic
| Force_Pressure
| Force_Buoyancy
| Force_Drag
| Force_Lift
| Force_SurfaceTension
| Force_Osmotic
| Force_Entropic
| Force_Centrifugal
| Force_Coriolis
| Force_Unknown.

Definition force_origin (f : ForceKind) : ForceOrigin :=
  match f with
  | Force_EM_Lorentz      => Origin_U1_EM
  | Force_Strong_QCD      => Origin_SU3_Strong
  | Force_Weak_EW         => Origin_SU2_Weak
  | Force_Gravity         => Origin_Metric_Gravity
  | Force_NuclearResidual => Origin_Residual_Strong
  | Force_ChemicalBond    => Origin_Residual_EM
  | Force_VanDerWaals     => Origin_Residual_EM
  | Force_Normal          => Origin_Residual_EM
  | Force_Friction        => Origin_Residual_EM
  | Force_Tension         => Origin_Residual_EM
  | Force_Elastic         => Origin_Residual_EM
  | Force_Pressure        => Origin_PressureGradient
  | Force_Buoyancy        => Origin_PressureGradient
  | Force_Drag            => Origin_MediumEffective
  | Force_Lift            => Origin_MediumEffective
  | Force_SurfaceTension  => Origin_FreeEnergyGradient
  | Force_Osmotic         => Origin_FreeEnergyGradient
  | Force_Entropic        => Origin_FreeEnergyGradient
  | Force_Centrifugal     => Origin_FrameArtifact
  | Force_Coriolis        => Origin_FrameArtifact
  | Force_Unknown         => Origin_Unknown
  end.

Record ForceMeasurement := mkForceMeasurement {
  fm_kind : ForceKind;
  fm_value : MeasuredQuantity;
  fm_model_residual : MeasuredQuantity
}.

Definition force_measurement_gate (fm : ForceMeasurement) : bool :=
  measured_dim_ok (fm_value fm) dim_force &&
  measured_dim_ok (fm_model_residual fm) dim_force &&
  mq_source_declared (fm_value fm) &&
  mq_source_declared (fm_model_residual fm).

Definition force_measurement_to_newton (fm : ForceMeasurement) : option Q :=
  if force_measurement_gate fm
  then Some (mq_val (fm_value fm))
  else None.


(* ================================================================ *)
(* 6. UNIT NODE GRAPH                                               *)
(* ================================================================ *)

Inductive UnitNode : Type :=
| UN_RetainedDifference
| UN_AdmissibleGrammar
| UN_SIBaseGrammar
| UN_BaseLength
| UN_BaseMass
| UN_BaseTime
| UN_BaseCurrent
| UN_BaseTemperature
| UN_BaseAmount
| UN_BaseLuminous
| UN_Area
| UN_Volume
| UN_Frequency
| UN_Velocity
| UN_Acceleration
| UN_Jerk
| UN_Wavenumber
| UN_Curvature
| UN_Momentum
| UN_Force
| UN_Energy
| UN_Power
| UN_Pressure
| UN_Density
| UN_Action
| UN_Charge
| UN_ElectricField
| UN_MagneticField
| UN_Permittivity
| UN_Permeability
| UN_Diffusion
| UN_Info
| UN_RDU_MetaUnit
| UN_RDU_MeasuredConstantAnchor
| UN_RDU_DimensionalExchangeRate
| UN_RDU_DimensionlessInvariant
| UN_RDU_CausalMemoryCoordinate
| UN_RDU_MemoryRateReadout
| UN_RDU_MemoryEnergyReadout
| UN_RDU_MemoryLengthReadout
| UN_RDU_MassMemoryBridge
| UN_RDU_MassTimeRatio
| UN_RDU_CouplingGap
| UN_RDU_FiniteSpeedMemory
| UN_RDU_RegimeCutoff
| UN_RDU_ResidualScaleMap
| UN_RDU_TauAtlasScaleKey
| UN_RDU_TauClaimBoundary
| UN_RDU_TimeReadout
| UN_RDU_LengthReadout
| UN_RDU_FrequencyReadout
| UN_RDU_EnergyReadout
| UN_RDU_MassReadout
| UN_RDU_InfoReadout
| UN_RDU_ThermalReadout
| UN_RDU_LandauerBit310K
| UN_RDU_BitVoltageReadout
| UN_RDU_BitMassEquivalent
| UN_RDU_BitMemoryTime
| UN_RDU_BitLengthEquivalent
| UN_RDU_BitForceMicron
| UN_RDU_WalkingStepEnergy
| UN_RDU_WalkingBitEquivalent
| UN_RDU_BindingBits
| UN_RDU_BindingFreeEnergy
| UN_Spine_DiscreteStep
| UN_Spine_InertiaTerm
| UN_Spine_DampingTerm
| UN_Spine_GeometryTerm
| UN_Spine_NonlinearTerm
| UN_Spine_SourceResidual
| UN_Spine_Gate
| UN_RootEquation
| UN_RootForceReadout
| UN_SI_NewtonReadback
| UN_ClaimDiscipline.

Definition unit_rank (n : UnitNode) : nat :=
  match n with
  | UN_RetainedDifference => 0
  | UN_AdmissibleGrammar => 1
  | UN_SIBaseGrammar => 2
  | UN_BaseLength
  | UN_BaseMass
  | UN_BaseTime
  | UN_BaseCurrent
  | UN_BaseTemperature
  | UN_BaseAmount
  | UN_BaseLuminous
  | UN_RDU_MetaUnit => 3
  | UN_RDU_MeasuredConstantAnchor
  | UN_RDU_DimensionalExchangeRate
  | UN_RDU_DimensionlessInvariant
  | UN_RDU_CausalMemoryCoordinate => 4
  | UN_RDU_MemoryRateReadout
  | UN_RDU_MemoryEnergyReadout
  | UN_RDU_MemoryLengthReadout => 5
  | UN_Area
  | UN_Frequency
  | UN_Velocity
  | UN_Charge
  | UN_MagneticField
  | UN_Info => 4
  | UN_Volume
  | UN_Acceleration
  | UN_Wavenumber
  | UN_Curvature
  | UN_Momentum
  | UN_Diffusion => 5
  | UN_Jerk
  | UN_Force
  | UN_Density => 6
  | UN_Energy
  | UN_Pressure
  | UN_ElectricField
  | UN_Permeability => 7
  | UN_Power
  | UN_Action
  | UN_Permittivity
  | UN_RDU_ThermalReadout => 8
  | UN_RDU_LandauerBit310K => 9
  | UN_RDU_TimeReadout
  | UN_RDU_LengthReadout
  | UN_RDU_FrequencyReadout
  | UN_RDU_EnergyReadout
  | UN_RDU_MassReadout
  | UN_RDU_InfoReadout => 9
  | UN_RDU_BitVoltageReadout
  | UN_RDU_BitMassEquivalent
  | UN_RDU_BitMemoryTime
  | UN_RDU_BitForceMicron
  | UN_RDU_MassMemoryBridge
  | UN_RDU_FiniteSpeedMemory
  | UN_RDU_WalkingStepEnergy
  | UN_RDU_BindingBits => 10
  | UN_RDU_BitLengthEquivalent
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap
  | UN_RDU_RegimeCutoff
  | UN_RDU_WalkingBitEquivalent
  | UN_RDU_BindingFreeEnergy => 11
  | UN_RDU_ResidualScaleMap => 12
  | UN_RDU_TauAtlasScaleKey => 13
  | UN_RDU_TauClaimBoundary => 14
  | UN_Spine_DiscreteStep
    => 10
  | UN_Spine_InertiaTerm
  | UN_Spine_DampingTerm
  | UN_Spine_GeometryTerm
  | UN_Spine_NonlinearTerm
  | UN_Spine_SourceResidual => 11
  | UN_Spine_Gate => 12
  | UN_RootEquation => 13
  | UN_RootForceReadout => 14
  | UN_SI_NewtonReadback => 15
  | UN_ClaimDiscipline => 16
  end.

Definition unit_node_dim (n : UnitNode) : option Dim :=
  match n with
  | UN_BaseLength => Some dim_length
  | UN_BaseMass => Some dim_mass
  | UN_BaseTime => Some dim_time
  | UN_BaseCurrent => Some dim_current
  | UN_BaseTemperature => Some dim_temperature
  | UN_BaseAmount => Some dim_amount
  | UN_BaseLuminous => Some dim_luminous
  | UN_Area => Some dim_area
  | UN_Volume => Some dim_volume
  | UN_Frequency => Some dim_frequency
  | UN_Velocity => Some dim_velocity
  | UN_Acceleration => Some dim_acceleration
  | UN_Jerk => Some dim_jerk
  | UN_Wavenumber => Some dim_wavenumber
  | UN_Curvature => Some dim_curvature
  | UN_Momentum => Some dim_momentum
  | UN_Force => Some dim_force
  | UN_Energy => Some dim_energy
  | UN_Power => Some dim_power
  | UN_Pressure => Some dim_pressure
  | UN_Density => Some dim_density
  | UN_Action => Some dim_action
  | UN_Charge => Some dim_charge
  | UN_ElectricField => Some dim_electric_field
  | UN_MagneticField => Some dim_magnetic_field
  | UN_Permittivity => Some dim_permittivity
  | UN_Permeability => Some dim_permeability
  | UN_Diffusion => Some dim_diffusion
  | UN_Info => Some dim_info
  | UN_RDU_CausalMemoryCoordinate => Some dim_time
  | UN_RDU_MemoryRateReadout => Some dim_frequency
  | UN_RDU_MemoryEnergyReadout => Some dim_energy
  | UN_RDU_MemoryLengthReadout => Some dim_length
  | UN_RDU_MassMemoryBridge => Some dim_time
  | UN_RDU_MassTimeRatio => Some dim_dimensionless
  | UN_RDU_CouplingGap => Some dim_dimensionless
  | UN_RDU_FiniteSpeedMemory => Some dim_velocity
  | UN_RDU_RegimeCutoff => Some dim_wavenumber
  | UN_RDU_TauAtlasScaleKey => Some dim_time
  | UN_RDU_TimeReadout => Some dim_time
  | UN_RDU_LengthReadout => Some dim_length
  | UN_RDU_FrequencyReadout => Some dim_frequency
  | UN_RDU_EnergyReadout => Some dim_energy
  | UN_RDU_MassReadout => Some dim_mass
  | UN_RDU_InfoReadout => Some dim_info
  | UN_RDU_ThermalReadout => Some dim_energy
  | UN_RDU_LandauerBit310K => Some dim_energy
  | UN_RDU_BitVoltageReadout => Some dim_voltage
  | UN_RDU_BitMassEquivalent => Some dim_mass
  | UN_RDU_BitMemoryTime => Some dim_time
  | UN_RDU_BitLengthEquivalent => Some dim_length
  | UN_RDU_BitForceMicron => Some dim_force
  | UN_RDU_WalkingStepEnergy => Some dim_energy
  | UN_RDU_WalkingBitEquivalent => Some dim_info
  | UN_RDU_BindingBits => Some dim_info
  | UN_RDU_BindingFreeEnergy => Some dim_molar_energy
  | UN_RootForceReadout => Some dim_force
  | UN_SI_NewtonReadback => Some dim_force
  | _ => None
  end.

(* Claim-boundary metadata for the new Landauer-normalized nodes.

   These nodes do not claim discovery of atomic physics formulas such as
   E = kB T ln 2, E = q V, F = -grad G, or DeltaG = R T ln K.
   The retained claim is architectural: a residual-gated, bit-equivalent
   metrology ledger with explicit unit, measurement, uncertainty, residual,
   and heldout gates.
*)

Inductive ReadoutFormulaStatus : Type :=
| FS_KnownPhysicsFormula
| FS_ModelEstimate
| FS_FrameworkProtocol
| FS_NotApplicable.

Definition unit_node_formula_status (n : UnitNode) : ReadoutFormulaStatus :=
  match n with
  | UN_RDU_MeasuredConstantAnchor
  | UN_RDU_DimensionalExchangeRate
  | UN_RDU_DimensionlessInvariant
  | UN_RDU_CausalMemoryCoordinate
  | UN_RDU_MemoryRateReadout
  | UN_RDU_MemoryEnergyReadout
  | UN_RDU_MemoryLengthReadout
  | UN_RDU_MassMemoryBridge
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap
  | UN_RDU_FiniteSpeedMemory
  | UN_RDU_RegimeCutoff
  | UN_RDU_ResidualScaleMap
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary => FS_FrameworkProtocol
  | UN_RDU_LandauerBit310K
  | UN_RDU_BitVoltageReadout
  | UN_RDU_BitMassEquivalent
  | UN_RDU_BitMemoryTime
  | UN_RDU_BitLengthEquivalent
  | UN_RDU_BitForceMicron
  | UN_RDU_BindingBits
  | UN_RDU_BindingFreeEnergy => FS_KnownPhysicsFormula
  | UN_RDU_WalkingStepEnergy
  | UN_RDU_WalkingBitEquivalent => FS_ModelEstimate
  | UN_RetainedDifference
  | UN_AdmissibleGrammar
  | UN_RDU_MetaUnit
  | UN_RootEquation
  | UN_RootForceReadout
  | UN_SI_NewtonReadback
  | UN_ClaimDiscipline => FS_FrameworkProtocol
  | _ => FS_NotApplicable
  end.

Definition unit_node_claims_new_atomic_formula (_n : UnitNode) : bool :=
  false.

Definition unit_node_claims_residual_gated_metrology (n : UnitNode) : bool :=
  match n with
  | UN_RetainedDifference
  | UN_AdmissibleGrammar
  | UN_RDU_MetaUnit
  | UN_RDU_MeasuredConstantAnchor
  | UN_RDU_DimensionalExchangeRate
  | UN_RDU_DimensionlessInvariant
  | UN_RDU_CausalMemoryCoordinate
  | UN_RDU_MemoryRateReadout
  | UN_RDU_MemoryEnergyReadout
  | UN_RDU_MemoryLengthReadout
  | UN_RDU_MassMemoryBridge
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap
  | UN_RDU_FiniteSpeedMemory
  | UN_RDU_RegimeCutoff
  | UN_RDU_ResidualScaleMap
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary
  | UN_RDU_LandauerBit310K
  | UN_RDU_WalkingBitEquivalent
  | UN_RDU_BindingBits
  | UN_RootEquation
  | UN_RootForceReadout
  | UN_SI_NewtonReadback
  | UN_ClaimDiscipline => true
  | _ => false
  end.

Definition unit_node_is_bit_equivalent_readout (n : UnitNode) : bool :=
  match n with
  | UN_RDU_LandauerBit310K
  | UN_RDU_BitVoltageReadout
  | UN_RDU_BitMassEquivalent
  | UN_RDU_BitMemoryTime
  | UN_RDU_BitLengthEquivalent
  | UN_RDU_BitForceMicron
  | UN_RDU_WalkingBitEquivalent
  | UN_RDU_BindingBits
  | UN_RDU_BindingFreeEnergy => true
  | _ => false
  end.

Definition unit_node_is_actual_semantic_information (_n : UnitNode) : bool :=
  false.

Definition unit_node_is_tau_c_memory_coordinate (n : UnitNode) : bool :=
  match n with
  | UN_RDU_CausalMemoryCoordinate
  | UN_RDU_MemoryRateReadout
  | UN_RDU_MemoryEnergyReadout
  | UN_RDU_MemoryLengthReadout
  | UN_RDU_MassMemoryBridge
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap
  | UN_RDU_FiniteSpeedMemory
  | UN_RDU_RegimeCutoff
  | UN_RDU_ResidualScaleMap
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary => true
  | _ => false
  end.

Definition unit_node_claims_new_constant (_n : UnitNode) : bool :=
  false.

Definition unit_node_claims_mass_derivation (_n : UnitNode) : bool :=
  false.

Definition unit_node_reexpresses_measured_mass_as_tau (n : UnitNode) : bool :=
  match n with
  | UN_RDU_CausalMemoryCoordinate
  | UN_RDU_MassMemoryBridge
  | UN_RDU_MassTimeRatio
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary => true
  | _ => false
  end.

Definition unit_node_supports_finite_speed_regime (n : UnitNode) : bool :=
  match n with
  | UN_RDU_FiniteSpeedMemory
  | UN_RDU_RegimeCutoff
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary => true
  | _ => false
  end.

Definition unit_node_is_measured_constant_handle (n : UnitNode) : bool :=
  match n with
  | UN_RDU_MeasuredConstantAnchor
  | UN_RDU_CausalMemoryCoordinate
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary => true
  | _ => false
  end.

Definition unit_node_is_dimensional_exchange_rate (n : UnitNode) : bool :=
  match n with
  | UN_RDU_DimensionalExchangeRate => true
  | _ => false
  end.

Definition unit_node_is_dimensionless_invariant (n : UnitNode) : bool :=
  match n with
  | UN_RDU_DimensionlessInvariant
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap => true
  | _ => false
  end.

Definition unit_node_supports_hierarchy_map (n : UnitNode) : bool :=
  match n with
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary => true
  | _ => false
  end.

Definition unit_node_supports_residual_map (n : UnitNode) : bool :=
  match n with
  | UN_RDU_ResidualScaleMap
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary => true
  | _ => false
  end.

Definition unit_node_requires_smoke_test (n : UnitNode) : bool :=
  match n with
  | UN_RDU_MeasuredConstantAnchor
  | UN_RDU_DimensionalExchangeRate
  | UN_RDU_DimensionlessInvariant
  | UN_RDU_CausalMemoryCoordinate
  | UN_RDU_MemoryRateReadout
  | UN_RDU_MemoryEnergyReadout
  | UN_RDU_MemoryLengthReadout
  | UN_RDU_MassMemoryBridge
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap
  | UN_RDU_FiniteSpeedMemory
  | UN_RDU_RegimeCutoff
  | UN_RDU_ResidualScaleMap
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary
  | UN_RDU_LandauerBit310K
  | UN_RDU_BitVoltageReadout
  | UN_RDU_BitMassEquivalent
  | UN_RDU_BitMemoryTime
  | UN_RDU_BitLengthEquivalent
  | UN_RDU_BitForceMicron
  | UN_RDU_WalkingStepEnergy
  | UN_RDU_WalkingBitEquivalent
  | UN_RDU_BindingBits
  | UN_RDU_BindingFreeEnergy => true
  | _ => false
  end.

Definition unit_node_requires_measurement_for_core_claim (n : UnitNode) : bool :=
  match n with
  | UN_RDU_MeasuredConstantAnchor
  | UN_RDU_DimensionalExchangeRate
  | UN_RDU_DimensionlessInvariant
  | UN_RDU_CausalMemoryCoordinate
  | UN_RDU_MemoryRateReadout
  | UN_RDU_MemoryEnergyReadout
  | UN_RDU_MemoryLengthReadout
  | UN_RDU_MassMemoryBridge
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap
  | UN_RDU_FiniteSpeedMemory
  | UN_RDU_RegimeCutoff
  | UN_RDU_ResidualScaleMap
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary
  | UN_RDU_WalkingStepEnergy
  | UN_RDU_WalkingBitEquivalent
  | UN_RDU_BindingBits
  | UN_RDU_BindingFreeEnergy
  | UN_RootForceReadout
  | UN_SI_NewtonReadback
  | UN_ClaimDiscipline => true
  | _ => false
  end.

Definition unit_node_covered (_n : UnitNode) : bool := true.

Definition unit_edge (a b : UnitNode) : bool :=
  match a, b with
  | UN_RetainedDifference, UN_AdmissibleGrammar => true
  | UN_AdmissibleGrammar, UN_SIBaseGrammar => true
  | UN_RetainedDifference, UN_RDU_MetaUnit => true

  | UN_SIBaseGrammar, UN_BaseLength => true
  | UN_SIBaseGrammar, UN_BaseMass => true
  | UN_SIBaseGrammar, UN_BaseTime => true
  | UN_SIBaseGrammar, UN_BaseCurrent => true
  | UN_SIBaseGrammar, UN_BaseTemperature => true
  | UN_SIBaseGrammar, UN_BaseAmount => true
  | UN_SIBaseGrammar, UN_BaseLuminous => true

  | UN_BaseLength, UN_Area => true
  | UN_Area, UN_Volume => true
  | UN_BaseTime, UN_Frequency => true
  | UN_BaseLength, UN_Velocity => true
  | UN_BaseTime, UN_Velocity => true
  | UN_Velocity, UN_Acceleration => true
  | UN_BaseTime, UN_Acceleration => true
  | UN_Acceleration, UN_Jerk => true
  | UN_BaseTime, UN_Jerk => true
  | UN_BaseLength, UN_Wavenumber => true
  | UN_Area, UN_Curvature => true
  | UN_BaseMass, UN_Momentum => true
  | UN_Velocity, UN_Momentum => true
  | UN_BaseMass, UN_Force => true
  | UN_Acceleration, UN_Force => true
  | UN_Force, UN_Energy => true
  | UN_BaseLength, UN_Energy => true
  | UN_Energy, UN_Power => true
  | UN_BaseTime, UN_Power => true
  | UN_Force, UN_Pressure => true
  | UN_Area, UN_Pressure => true
  | UN_BaseMass, UN_Density => true
  | UN_Volume, UN_Density => true
  | UN_Energy, UN_Action => true
  | UN_BaseTime, UN_Action => true
  | UN_BaseCurrent, UN_Charge => true
  | UN_BaseTime, UN_Charge => true
  | UN_Force, UN_ElectricField => true
  | UN_Charge, UN_ElectricField => true
  | UN_BaseMass, UN_MagneticField => true
  | UN_BaseTime, UN_MagneticField => true
  | UN_BaseCurrent, UN_MagneticField => true
  | UN_Charge, UN_Permittivity => true
  | UN_ElectricField, UN_Permittivity => true
  | UN_Force, UN_Permeability => true
  | UN_BaseCurrent, UN_Permeability => true
  | UN_Area, UN_Diffusion => true
  | UN_BaseTime, UN_Diffusion => true

  | UN_RDU_MetaUnit, UN_RDU_TimeReadout => true
  | UN_RDU_MetaUnit, UN_RDU_LengthReadout => true
  | UN_RDU_MetaUnit, UN_RDU_FrequencyReadout => true
  | UN_RDU_MetaUnit, UN_RDU_EnergyReadout => true
  | UN_RDU_MetaUnit, UN_RDU_MassReadout => true
  | UN_RDU_MetaUnit, UN_RDU_InfoReadout => true
  | UN_RDU_MetaUnit, UN_RDU_ThermalReadout => true
  | UN_RDU_MetaUnit, UN_RDU_MeasuredConstantAnchor => true
  | UN_RDU_MetaUnit, UN_RDU_DimensionalExchangeRate => true
  | UN_RDU_MetaUnit, UN_RDU_DimensionlessInvariant => true
  | UN_RDU_MetaUnit, UN_RDU_CausalMemoryCoordinate => true
  | UN_RDU_MeasuredConstantAnchor, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_DimensionalExchangeRate, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_DimensionlessInvariant, UN_RDU_TauAtlasScaleKey => true
  | UN_BaseTime, UN_RDU_CausalMemoryCoordinate => true
  | UN_RDU_CausalMemoryCoordinate, UN_RDU_MemoryRateReadout => true
  | UN_RDU_CausalMemoryCoordinate, UN_RDU_MemoryEnergyReadout => true
  | UN_RDU_CausalMemoryCoordinate, UN_RDU_MemoryLengthReadout => true
  | UN_RDU_MemoryRateReadout, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_MemoryEnergyReadout, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_MemoryLengthReadout, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_CausalMemoryCoordinate, UN_RDU_MassMemoryBridge => true
  | UN_RDU_MassReadout, UN_RDU_MassMemoryBridge => true
  | UN_RDU_MassMemoryBridge, UN_RDU_MassTimeRatio => true
  | UN_RDU_DimensionlessInvariant, UN_RDU_CouplingGap => true
  | UN_RDU_MassTimeRatio, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_CouplingGap, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_CausalMemoryCoordinate, UN_RDU_FiniteSpeedMemory => true
  | UN_Diffusion, UN_RDU_FiniteSpeedMemory => true
  | UN_Velocity, UN_RDU_FiniteSpeedMemory => true
  | UN_RDU_CausalMemoryCoordinate, UN_RDU_RegimeCutoff => true
  | UN_Diffusion, UN_RDU_RegimeCutoff => true
  | UN_Wavenumber, UN_RDU_RegimeCutoff => true
  | UN_RDU_FiniteSpeedMemory, UN_RDU_RegimeCutoff => true
  | UN_RDU_CausalMemoryCoordinate, UN_RDU_ResidualScaleMap => true
  | UN_Spine_SourceResidual, UN_RDU_ResidualScaleMap => true
  | UN_RDU_ResidualScaleMap, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_CausalMemoryCoordinate, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_MassMemoryBridge, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_FiniteSpeedMemory, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_RegimeCutoff, UN_RDU_TauAtlasScaleKey => true
  | UN_RDU_TauAtlasScaleKey, UN_RDU_TauClaimBoundary => true
  | UN_RDU_TauClaimBoundary, UN_ClaimDiscipline => true
  | UN_BaseTime, UN_RDU_TimeReadout => true
  | UN_BaseLength, UN_RDU_LengthReadout => true
  | UN_Frequency, UN_RDU_FrequencyReadout => true
  | UN_Energy, UN_RDU_EnergyReadout => true
  | UN_BaseMass, UN_RDU_MassReadout => true
  | UN_Info, UN_RDU_InfoReadout => true
  | UN_Energy, UN_RDU_ThermalReadout => true
  | UN_RDU_ThermalReadout, UN_RDU_LandauerBit310K => true
  | UN_RDU_LandauerBit310K, UN_RDU_BitVoltageReadout => true
  | UN_RDU_LandauerBit310K, UN_RDU_BitMassEquivalent => true
  | UN_RDU_LandauerBit310K, UN_RDU_BitMemoryTime => true
  | UN_RDU_BitMemoryTime, UN_RDU_BitLengthEquivalent => true
  | UN_RDU_LandauerBit310K, UN_RDU_BitForceMicron => true
  | UN_RDU_LandauerBit310K, UN_RDU_WalkingBitEquivalent => true
  | UN_Energy, UN_RDU_WalkingStepEnergy => true
  | UN_RDU_WalkingStepEnergy, UN_RDU_WalkingBitEquivalent => true
  | UN_RDU_LandauerBit310K, UN_RDU_BindingBits => true
  | UN_RDU_BindingBits, UN_RDU_BindingFreeEnergy => true
  | UN_RDU_LandauerBit310K, UN_ClaimDiscipline => true
  | UN_RDU_BitVoltageReadout, UN_ClaimDiscipline => true
  | UN_RDU_WalkingBitEquivalent, UN_ClaimDiscipline => true
  | UN_RDU_BindingFreeEnergy, UN_ClaimDiscipline => true

  | UN_RDU_TimeReadout, UN_Spine_DiscreteStep => true
  | UN_Spine_DiscreteStep, UN_Spine_InertiaTerm => true
  | UN_Spine_DiscreteStep, UN_Spine_DampingTerm => true
  | UN_Diffusion, UN_Spine_GeometryTerm => true
  | UN_Force, UN_Spine_NonlinearTerm => true
  | UN_Force, UN_Spine_SourceResidual => true
  | UN_Spine_InertiaTerm, UN_Spine_Gate => true
  | UN_Spine_DampingTerm, UN_Spine_Gate => true
  | UN_Spine_GeometryTerm, UN_Spine_Gate => true
  | UN_Spine_NonlinearTerm, UN_Spine_Gate => true
  | UN_Spine_SourceResidual, UN_Spine_Gate => true
  | UN_Spine_Gate, UN_RootEquation => true
  | UN_RootEquation, UN_RootForceReadout => true
  | UN_Force, UN_RootForceReadout => true
  | UN_RootForceReadout, UN_SI_NewtonReadback => true
  | UN_SI_NewtonReadback, UN_ClaimDiscipline => true
  | _, _ => false
  end.

Definition unit_edge_rank_valid (a b : UnitNode) : bool :=
  if unit_edge a b then Nat.ltb (unit_rank a) (unit_rank b) else true.

Theorem all_unit_nodes_covered :
  forall n : UnitNode, unit_node_covered n = true.
Proof. destruct n; reflexivity. Qed.

Theorem unit_graph_rank_acyclic :
  forall a b : UnitNode, unit_edge_rank_valid a b = true.
Proof. destruct a, b; vm_compute; reflexivity. Qed.

Definition rdu_meta_unit_preserves_SI (u : RDU) : bool :=
  rdu_dim_ok u &&
  measured_dim_ok (RDU_time_readout u) dim_time &&
  measured_dim_ok (RDU_length_readout u) dim_length &&
  measured_dim_ok (RDU_frequency_readout u) dim_frequency &&
  measured_dim_ok (RDU_energy_readout u) dim_energy &&
  measured_dim_ok (RDU_mass_readout u) dim_mass &&
  measured_dim_ok (RDU_information_readout u) dim_info &&
  measured_dim_ok (RDU_thermal_erase_readout u) dim_energy.

Definition unit_node_gate (u : RDU) (s : SpineSample) (n : UnitNode) : bool :=
  match n with
  | UN_RDU_MetaUnit
  | UN_RDU_TimeReadout
  | UN_RDU_LengthReadout
  | UN_RDU_FrequencyReadout
  | UN_RDU_EnergyReadout
  | UN_RDU_MassReadout
  | UN_RDU_InfoReadout
  | UN_RDU_ThermalReadout => rdu_meta_unit_preserves_SI u && rdu_sources_ok u
  | UN_RDU_MeasuredConstantAnchor
  | UN_RDU_DimensionalExchangeRate
  | UN_RDU_DimensionlessInvariant
  | UN_RDU_CausalMemoryCoordinate
  | UN_RDU_MemoryRateReadout
  | UN_RDU_MemoryEnergyReadout
  | UN_RDU_MemoryLengthReadout
  | UN_RDU_MassMemoryBridge
  | UN_RDU_MassTimeRatio
  | UN_RDU_CouplingGap
  | UN_RDU_FiniteSpeedMemory
  | UN_RDU_RegimeCutoff
  | UN_RDU_ResidualScaleMap
  | UN_RDU_TauAtlasScaleKey
  | UN_RDU_TauClaimBoundary
  | UN_RDU_LandauerBit310K
  | UN_RDU_BitVoltageReadout
  | UN_RDU_BitMassEquivalent
  | UN_RDU_BitMemoryTime
  | UN_RDU_BitLengthEquivalent
  | UN_RDU_BitForceMicron
  | UN_RDU_WalkingStepEnergy
  | UN_RDU_WalkingBitEquivalent
  | UN_RDU_BindingBits
  | UN_RDU_BindingFreeEnergy => true
  | UN_Spine_DiscreteStep
  | UN_Spine_InertiaTerm
  | UN_Spine_DampingTerm
  | UN_Spine_GeometryTerm
  | UN_Spine_NonlinearTerm
  | UN_Spine_SourceResidual
  | UN_Spine_Gate
  | UN_RootEquation
  | UN_RootForceReadout => spine_gate s
  | UN_SI_NewtonReadback =>
      match force_to_SI_newton (root_force_readout s) with
      | Some _ => true
      | None => false
      end
  | UN_ClaimDiscipline => true
  | _ => true
  end.


(* ================================================================ *)
(* 7. EXAMPLE COMPUTATIONS                                          *)
(* These are toy values to show the grammar computes. They are NOT  *)
(* physical constants. Replace them with lab/CODATA/PDG inputs.     *)
(* ================================================================ *)

Definition toy_tau  := measured_as 1 dim_time.
Definition toy_c    := measured_as 1 dim_velocity.
Definition toy_hbar := measured_as 1 dim_action.
Definition toy_kB   := measured_as 1 dim_kB.
Definition toy_T    := measured_as 1 dim_temperature.
Definition toy_ln2  := measured_as (7 # 10) dim_dimensionless.

Definition toy_rdu : RDU :=
  mkRDU toy_tau toy_c toy_hbar toy_kB toy_T toy_ln2.

Example toy_rdu_dims_ok :
  rdu_dim_ok toy_rdu = true.
Proof. vm_compute. reflexivity. Qed.

Example toy_energy_readout_value :
  mq_val (RDU_energy_readout toy_rdu) == (1 # 2).
Proof. vm_compute. reflexivity. Qed.

Example toy_mass_readout_value :
  mq_val (RDU_mass_readout toy_rdu) == (1 # 2).
Proof. vm_compute. reflexivity. Qed.

Example toy_length_readout_dim :
  measured_dim_ok (RDU_length_readout toy_rdu) dim_length = true.
Proof. vm_compute. reflexivity. Qed.

Example toy_thermal_erase_value :
  mq_val (RDU_thermal_erase_readout toy_rdu) == (7 # 10).
Proof. vm_compute. reflexivity. Qed.

(* Toy spine:
   Phi is dimensionless.
   dt = 1.
   phi_prev=0, phi_now=1, phi_next=2 gives d1=1 and d2=0.
   Choose:
     M dim = force*time^2
     D dim = force*time
     K dim = force
     LR_phi dim = dimensionless
     gradV dim = force
   Then all terms are force.
   Values:
     inertia=0, damping=1, geometry=3, nonlinear=4, J=8, eta=0.
     residual = 0.
     root force = -(3+4) = -7 N.
*)

Definition dim_force_time : Dim :=
  dim_add dim_force dim_time.

Definition dim_force_time2 : Dim :=
  dim_add dim_force (dim_pow2 dim_time).

Definition toy_spine : SpineSample :=
  mkSpineSample
    (measured_as 1 dim_time)
    (measured_as 0 dim_dimensionless)
    (measured_as 1 dim_dimensionless)
    (measured_as 2 dim_dimensionless)
    (measured_as 1 dim_force_time2)
    (measured_as 1 dim_force_time)
    (measured_as 1 dim_force)
    (measured_as 3 dim_dimensionless)
    (measured_as 4 dim_force)
    (measured_as 8 dim_force)
    (measured_as 0 dim_force).

Example toy_spine_gate_ok :
  spine_gate toy_spine = true.
Proof. vm_compute. reflexivity. Qed.

Example toy_spine_residual_zero :
  spine_residual_value toy_spine == 0.
Proof. vm_compute. reflexivity. Qed.

Example toy_root_force_is_minus_7_newton :
  force_to_SI_newton (root_force_readout toy_spine) = Some (-7).
Proof. vm_compute. reflexivity. Qed.

Example toy_force_origin_normal_is_residual_EM :
  force_origin Force_Normal = Origin_Residual_EM.
Proof. vm_compute. reflexivity. Qed.

Example toy_force_origin_coriolis_is_frame :
  force_origin Force_Coriolis = Origin_FrameArtifact.
Proof. vm_compute. reflexivity. Qed.

Example toy_rdu_meta_unit_preserves_SI :
  rdu_meta_unit_preserves_SI toy_rdu = true.
Proof. vm_compute. reflexivity. Qed.

Example toy_unit_node_gate_root_equation :
  unit_node_gate toy_rdu toy_spine UN_RootEquation = true.
Proof. vm_compute. reflexivity. Qed.

Example toy_unit_node_gate_newton_readback :
  unit_node_gate toy_rdu toy_spine UN_SI_NewtonReadback = true.
Proof. vm_compute. reflexivity. Qed.

Example unit_energy_readout_has_energy_dim :
  unit_node_dim UN_RDU_EnergyReadout = Some dim_energy.
Proof. vm_compute. reflexivity. Qed.

Example landauer_node_is_known_physics_formula :
  unit_node_formula_status UN_RDU_LandauerBit310K = FS_KnownPhysicsFormula.
Proof. vm_compute. reflexivity. Qed.

Example landauer_node_claims_no_new_atomic_formula :
  unit_node_claims_new_atomic_formula UN_RDU_LandauerBit310K = false.
Proof. vm_compute. reflexivity. Qed.

Example bit_equivalent_is_not_actual_semantic_information :
  unit_node_is_bit_equivalent_readout UN_RDU_WalkingBitEquivalent = true /\
  unit_node_is_actual_semantic_information UN_RDU_WalkingBitEquivalent = false.
Proof. vm_compute. split; reflexivity. Qed.

Example walking_node_is_model_estimate_requiring_measurement :
  unit_node_formula_status UN_RDU_WalkingBitEquivalent = FS_ModelEstimate /\
  unit_node_requires_measurement_for_core_claim UN_RDU_WalkingBitEquivalent = true.
Proof. vm_compute. split; reflexivity. Qed.

Example binding_node_is_known_formula_but_claim_gated :
  unit_node_formula_status UN_RDU_BindingFreeEnergy = FS_KnownPhysicsFormula /\
  unit_node_requires_measurement_for_core_claim UN_RDU_BindingFreeEnergy = true.
Proof. vm_compute. split; reflexivity. Qed.

Example claim_discipline_is_framework_protocol :
  unit_node_formula_status UN_ClaimDiscipline = FS_FrameworkProtocol /\
  unit_node_claims_residual_gated_metrology UN_ClaimDiscipline = true.
Proof. vm_compute. split; reflexivity. Qed.

Definition toy_measured_mass := measured_as 1 dim_mass.
Definition toy_diffusion := measured_as 1 dim_diffusion.
Definition toy_cutoff_wavenumber := measured_as 1 dim_wavenumber.

Example tau_from_mass_has_time_dim :
  measured_dim_ok
    (causal_memory_time_from_mass toy_hbar toy_measured_mass toy_c)
    dim_time = true.
Proof. vm_compute. reflexivity. Qed.

Example tau_from_mass_toy_value_is_half :
  mq_val (causal_memory_time_from_mass toy_hbar toy_measured_mass toy_c) == (1 # 2).
Proof. vm_compute. reflexivity. Qed.

Example tau_mass_bridge_dim_guard :
  causal_memory_mass_bridge_dim_ok toy_hbar toy_measured_mass toy_c = true.
Proof. vm_compute. reflexivity. Qed.

Example tau_readout_tuple_dim_guard :
  causal_memory_readout_tuple_dim_ok toy_hbar toy_c toy_tau = true.
Proof. vm_compute. reflexivity. Qed.

Example tau_length_readout_toy_value :
  mq_val (causal_memory_length_readout toy_c toy_tau) == 1.
Proof. vm_compute. reflexivity. Qed.

Example tau_time_ratio_is_dimensionless :
  causal_memory_time_ratio_dim_ok toy_tau (measured_as 2 dim_time) = true.
Proof. vm_compute. reflexivity. Qed.

Example finite_speed_memory_dim_guard :
  finite_speed_memory_dim_ok toy_diffusion toy_tau toy_c = true.
Proof. vm_compute. reflexivity. Qed.

Example regime_cutoff_dim_guard :
  regime_cutoff_dim_ok toy_tau toy_diffusion toy_cutoff_wavenumber = true.
Proof. vm_compute. reflexivity. Qed.

Example tau_c_node_is_framework_not_new_constant :
  unit_node_is_tau_c_memory_coordinate UN_RDU_CausalMemoryCoordinate = true /\
  unit_node_claims_new_constant UN_RDU_CausalMemoryCoordinate = false.
Proof. vm_compute. split; reflexivity. Qed.

Example tau_c_mass_bridge_does_not_derive_mass :
  unit_node_reexpresses_measured_mass_as_tau UN_RDU_MassMemoryBridge = true /\
  unit_node_claims_mass_derivation UN_RDU_MassMemoryBridge = false.
Proof. vm_compute. split; reflexivity. Qed.

Example tau_c_supports_finite_speed_regime :
  unit_node_supports_finite_speed_regime UN_RDU_RegimeCutoff = true /\
  unit_node_requires_measurement_for_core_claim UN_RDU_RegimeCutoff = true.
Proof. vm_compute. split; reflexivity. Qed.

Example measured_constants_are_handles_not_roots :
  unit_node_is_measured_constant_handle UN_RDU_MeasuredConstantAnchor = true /\
  unit_node_claims_new_constant UN_RDU_MeasuredConstantAnchor = false.
Proof. vm_compute. split; reflexivity. Qed.

Example dimensional_constants_are_exchange_rates :
  unit_node_is_dimensional_exchange_rate UN_RDU_DimensionalExchangeRate = true.
Proof. vm_compute. reflexivity. Qed.

Example dimensionless_constants_are_invariants :
  unit_node_is_dimensionless_invariant UN_RDU_DimensionlessInvariant = true.
Proof. vm_compute. reflexivity. Qed.

Example hierarchy_map_from_ratio_and_coupling :
  unit_node_supports_hierarchy_map UN_RDU_MassTimeRatio = true /\
  unit_node_supports_hierarchy_map UN_RDU_CouplingGap = true.
Proof. vm_compute. split; reflexivity. Qed.

Example residual_map_is_scale_indexed_diagnostic :
  unit_node_supports_residual_map UN_RDU_ResidualScaleMap = true /\
  unit_node_requires_measurement_for_core_claim UN_RDU_ResidualScaleMap = true.
Proof. vm_compute. split; reflexivity. Qed.

(* ================================================================ *)
(* 8. CLAIM DISCIPLINE                                              *)
(* ================================================================ *)

Inductive ClaimTier : Type :=
| Tier_CoqChecked
| Tier_ExternalLibComputed
| Tier_MeasuredOnly
| Tier_FittedHeldoutValidated
| Tier_WorkingForm
| Tier_Conjecture.

Definition core_claim_tier (t : ClaimTier) : bool :=
  match t with
  | Tier_CoqChecked => true
  | Tier_ExternalLibComputed => true
  | Tier_MeasuredOnly => true
  | Tier_FittedHeldoutValidated => true
  | Tier_WorkingForm => false
  | Tier_Conjecture => false
  end.

Definition physics_claim_admissible
  (tier : ClaimTier)
  (has_units : bool)
  (has_residual : bool)
  (has_uncertainty : bool) : bool :=
  core_claim_tier tier && has_units && has_residual && has_uncertainty.

Example conjecture_not_core :
  core_claim_tier Tier_Conjecture = false.
Proof. vm_compute. reflexivity. Qed.

Example measured_with_units_residual_uncertainty_is_admissible :
  physics_claim_admissible Tier_MeasuredOnly true true true = true.
Proof. vm_compute. reflexivity. Qed.

End RDU_Machinic_Measurement_Readout.


(******************************************************************************)
(* Genesis_Canon_Bridge_v2_4_0                                                *)
(*                                                                            *)
(* BRIDGE: formal/Genesis_PhysicsDAG_Canon_v2_4_0.v                          *)
(*         ↔ docs/root/GENESIS_COSMOLOGY_EXPANDED_V2_4_0.md (canon)          *)
(*         ↔ engine/ (python -m engine --benchmark, 30/30 PASS)               *)
(*         ↔ docs/engineering/PGFT_V0_8_CANON.md                             *)
(*                                                                            *)
(* Three files are formally linked here:                                      *)
(*  1. Genesis doc   — the canonical cosmology narrative (v2.4.0)             *)
(*  2. Coq canon     — this file (machine-checked structure)                  *)
(*  3. PGFT engine   — engine/ Python module (finite_diagnostic tier)         *)
(*                                                                            *)
(* Version: 2.4.0  |  Date: 2026-06-26                                       *)
(* coqc exit=0 required for Genesis formal floor to be satisfied.            *)
(*                                                                            *)
(* Claim: readout-not-truth.                                                  *)
(*   Proved lemmas  → Th_coqc (structure only, not physics truth)             *)
(*   Definitions    → DeclaredFormula tier                                    *)
(*   Numbers        → CODATA parameters; spine does not derive them           *)
(******************************************************************************)

Module Genesis_Canon_Bridge_v2_4_0.

Open Scope R_scope.

Module QRD := Quantum_Relativity_Formal_DAG_Deep.

(* ─── §1  τ_c = ħ/(2E) — general energy form ───────────────────────────── *)
(* genesis §3 eq: τ_c = ħ/(2E)  where E is ANY energy (photon, virtual, …)  *)
(* USR module has: τ_c = ħ/(2mc²) — a SPECIAL CASE for rest-mass energy.    *)
(* The energy form below is strictly more general.  DeclaredFormula tier.    *)

Parameter E_gen tau_c_gen : R.
Axiom E_gen_pos : E_gen > 0.

Definition F_Genesis_TauC : Prop :=
  tau_c_gen = QRD.hbar / (2 * E_gen).

(* ─── §2  α_QG = G E² / (ħ c⁵) — quantum gravity coupling ─────────────── *)
(* genesis §frontier eq; engine/pde.py alpha_qg(E_J)                        *)

Parameter alpha_QG_gen : R.

Definition F_Genesis_AlphaQG : Prop :=
  alpha_QG_gen =
    QRD.G * E_gen * E_gen /
    (QRD.hbar * QRD.c * QRD.c * QRD.c * QRD.c * QRD.c).

(* ─── §3  r_s = 2GE/c⁴ (energy form of Schwarzschild radius) ────────────  *)
(* Algebraic identity with QRD.F_N_EX_SchwarzschildHorizon (rs = 2GM/c²)   *)
(* when E = Mc²: r_s = 2G(E/c²)/c² = 2GE/c⁴.  DeclaredFormula tier.       *)

Parameter r_s_gen : R.

Definition F_Genesis_SchwarzschildEnergy : Prop :=
  r_s_gen = 2 * QRD.G * E_gen /
             (QRD.c * QRD.c * QRD.c * QRD.c).

(* ─── §4  Unruh τ_c bridge: τ_c(T_Unruh) = πc/a ────────────────────────── *)
(* Derivation (DeclaredFormula tier):                                        *)
(*   QRD.F_N_BR_Unruh : T_Unruh(a) = ħa / (2π c k_B)                       *)
(*   τ_c = ħ/(2E) with E = k_B T  →  τ_c(T_Unruh) = ħ/(2k_B T_Unruh)     *)
(*                                  = ħ·2πck_B/(2k_B·ħa) = πc/a  (exact)   *)

Parameter a_unruh tau_c_unruh : R.
Axiom a_unruh_pos : a_unruh > 0.

Definition F_Genesis_UnruhTauC : Prop :=
  tau_c_unruh = QRD.PI * QRD.c / a_unruh.

(* ─── §5  CLAIM 4 — scale-freedom / boundary data ───────────────────────── *)
(* QRD N_BR_BoundaryConstants → positivity of ħ,c,G,k_B.                   *)
(* QRD N_BR_OpenQG             → quantum gravity is an open parameter.      *)
(* Together these formalize CLAIM 4: the spine cannot derive coupling values.*)

Definition F_Genesis_CLAIM4 : Prop :=
  QRD.F_N_BR_BoundaryConstants /\ QRD.F_N_BR_OpenQG.

(* ─── §6  CLAIM 2 — anomaly cancellation solution EXISTS ────────────────── *)
(* The SM hypercharges satisfy all four anomaly cancellation constraints.    *)
(* Concrete polynomial definitions (no division — integer witnesses):        *)

Definition anomaly_su3_c  (YQ Yu Yd    : R) := 2*YQ - Yu - Yd.
Definition anomaly_su2_c  (YQ YL       : R) := 3*YQ + YL.
Definition anomaly_u1_c   (YQ Yu Yd YL Ye : R) :=
  6*YQ*YQ*YQ - 3*Yu*Yu*Yu - 3*Yd*Yd*Yd + 2*YL*YL*YL - Ye*Ye*Ye.
Definition anomaly_grav_c (YQ Yu Yd YL Ye : R) :=
  6*YQ - 3*Yu - 3*Yd + 2*YL - Ye.

(* Integer witnesses: YQ=1, Yu=4, Yd=-2, YL=-3, Ye=-6                      *)
(*   (proportional to standard: YQ=1/6, Yu=2/3, Yd=-1/3, YL=-1/2, Ye=-1)  *)
(* Proof by ring — Th_coqc tier.                                            *)
Lemma genesis_anomaly_solution_exists :
  anomaly_su3_c  1 4 (-2)           = 0 /\
  anomaly_su2_c  1    (-3)          = 0 /\
  anomaly_u1_c   1 4 (-2) (-3) (-6) = 0 /\
  anomaly_grav_c 1 4 (-2) (-3) (-6) = 0.
Proof.
  unfold anomaly_su3_c, anomaly_su2_c, anomaly_u1_c, anomaly_grav_c.
  repeat split; ring.
Qed.

(* ─── §7  Gateway PDE (DeclaredFormula tier) ────────────────────────────── *)
(* genesis §3.10: ∂_Θ φ = -D_R L_R φ - μ_R φ + S_R                         *)
(* engine/pde.py run_native_pde; engine/README.md Layer 2                    *)

Parameter phi_gw dTheta_phi D_R_gw mu_R_gw L_R_phi S_R_gw : R.

Definition F_Genesis_GatewayPDE : Prop :=
  dTheta_phi = - D_R_gw * L_R_phi * phi_gw
               - mu_R_gw * phi_gw
               + S_R_gw.

(* ─── §8  Λ structural bridge (Wf tier — DeclaredFormula) ───────────────── *)
(* genesis §frontier: α_QG(E_Hubble) ≈ Λ_obs / 2                           *)
(* engine/frontier.py lambda_hubble_bridge()                                 *)
(* Wf tier (0.40): structural connection, factor ~2 unexplained.             *)
(* PROVED BOUNDARY DATA: specific Λ value is outside spine (CLAIM 4).       *)

Parameter H0_gw E_Hubble_gw alpha_QG_Hubble Lambda_obs_gw : R.
Axiom H0_gw_pos      : H0_gw > 0.
Axiom Lambda_obs_pos : Lambda_obs_gw > 0.

Definition F_Genesis_LambdaBridge : Prop :=
  E_Hubble_gw     = QRD.hbar * H0_gw /\
  alpha_QG_Hubble = QRD.G * E_Hubble_gw * E_Hubble_gw /
                    (QRD.hbar * QRD.c * QRD.c * QRD.c * QRD.c * QRD.c) /\
  alpha_QG_Hubble > 0 /\
  Lambda_obs_gw   > 0.

(* ─── §9  Dark matter structural placement (DeclaredFormula, Dr tier) ───── *)
(* engine/frontier.py dark_matter_position()                                 *)
(* DM couples via CausalCone (gravitational) ONLY: α_EM = 0, α_s = 0.      *)

Parameter E_DM alpha_QG_DM : R.
Axiom E_DM_pos : E_DM > 0.

Definition F_Genesis_DarkMatterPlacement : Prop :=
  alpha_QG_DM = QRD.G * E_DM * E_DM /
                (QRD.hbar * QRD.c * QRD.c * QRD.c * QRD.c * QRD.c).
(* No EM coupling declared. Structural placement only.                      *)

(* ─── §10  DAG edges: Genesis sector links to existing QRD nodes ─────────  *)
(* These edges connect genesis physics to the QR physics DAG.               *)

Inductive GenesisEdge : QRD.QRNode -> QRD.QRNode -> Prop :=
| GE_Unruh_to_OpenQG      : GenesisEdge QRD.N_BR_Unruh            QRD.N_BR_OpenQG
| GE_BConst_to_OpenQG     : GenesisEdge QRD.N_BR_BoundaryConstants QRD.N_BR_OpenQG
| GE_EFE_to_OpenQG        : GenesisEdge QRD.N_GR_EFE              QRD.N_BR_OpenQG
| GE_EFE_to_Friedmann     : GenesisEdge QRD.N_GR_EFE              QRD.N_COS_Friedmann1
| GE_Anomaly1_to_SM       : GenesisEdge QRD.N_QFT_Anomaly1        QRD.N_QFT_SM
| GE_Anomaly2_to_SM       : GenesisEdge QRD.N_QFT_Anomaly2        QRD.N_QFT_SM
| GE_Anomaly3_to_SM       : GenesisEdge QRD.N_QFT_Anomaly3        QRD.N_QFT_SM
| GE_Anomaly4_to_SM       : GenesisEdge QRD.N_QFT_Anomaly4        QRD.N_QFT_SM
| GE_Friedmann_to_BHEnt   : GenesisEdge QRD.N_COS_Friedmann1      QRD.N_BH_Entropy
| GE_FLRW_to_Friedmann    : GenesisEdge QRD.N_EX_FLRW             QRD.N_COS_Friedmann1.

(* ─── Compilation gate summary ──────────────────────────────────────────── *)
(* coqc exit=0 on this file ⟺ all of the following hold simultaneously:    *)
(*   (a) τ_c = ħ/(2E) is type-correct                    [DeclaredFormula]  *)
(*   (b) α_QG = GE²/(ħc⁵) is type-correct               [DeclaredFormula]  *)
(*   (c) Gateway PDE is type-correct                      [DeclaredFormula]  *)
(*   (d) Λ bridge structure is type-correct               [DeclaredFormula]  *)
(*   (e) Anomaly cancellation solution EXISTS             [Th_coqc, ring]   *)
(*   (f) Genesis DAG edges are type-correct               [DeclaredFormula]  *)
(*                                                                           *)
(* What this does NOT prove:                                                 *)
(*   - Numerical values of α_EM, Λ, mass ratios (CLAIM 4 / PROVED BOUNDARY) *)
(*   - That PGFT replaces empirical physics (recovery faces are open)        *)
(*   - Quantum gravity (N_BR_OpenQG → OpenFormula, permanently)             *)
(*   - That the factor ~2 in the Λ bridge is exact (Wf tier, not Th_coqc)  *)

End Genesis_Canon_Bridge_v2_4_0.
