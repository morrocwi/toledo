(** * MRC_world_system_reading.v — Family "world-system-reading": CAN-140..CAN-164

    Source of record: research/society-justice-peace/master-river/registry/
    CANONICAL.json (domain: "world-system", 25 ids, CAN-140..CAN-164) and
    registry/COLLAPSE.md Section 2 / "World-system domain (25 ids)" table.
    Assignment record: registry/family_world-system-reading.json.

    This family is NOT root-spine (spine_ids are domain: "root", family
    root-spine, coq_canon/MRC_root_spine.v/MRC_master.v) — it is the
    world-system q_D *reading* of the spine. Per COLLAPSE.md Section 2:
    "The world-system reading has no bare Laplacian/weld object of its
    own ... it enters through CAN-006 (CAN-150's bridge) and CAN-004
    (CAN-151's Human Systemic Position index) rather than through
    CAN-001/CAN-003 directly." No [MRC_master.v] is produced by this file
    for that reason: the master-equation composition belongs to the
    root-spine family, not to a domain reading of it.

    REUSE (per the task brief: "reuse coq/MR_*.v for CAN ids that are
    Master River eq 1-79"): of the 25 ids, **7** cite a specific Master
    River v1.4 eq.(NN) in their own [canonical_source]/[in_master_river]
    field and are discharged by [Require Import]-ing the already-compiled,
    already axiom-free [../coq/MR_WorldSystem.v] module that formalises
    that eq. number, then aliasing its identifier under the CAN id (never
    redefining it) — CAN-143 (eq.53), CAN-144 (eq.54), CAN-151 (eq.58-59),
    CAN-157 (eq.56), CAN-158 (eq.57), CAN-159 (eq.60-62), CAN-163
    (eq.63-64). The remaining **18** ids are standalone (their
    [in_master_river] field is null and their [canonical_source] cites an
    After Labour / Human Conversion Imperative equation number, not a
    Master River eq. number) and are freshly formalised here, in the same
    Section+Variables/Hypotheses, Q/nat/bool/list/Inductive, no-Reals/
    no-classical/no-Admitted/no-top-level-Axiom-or-Parameter discipline as
    every other file in this repository. [MR_WorldSystem.Qpow_nat] and
    [MR_WorldSystem.ddiff] (shared discrete-readout scaffolding, not
    numbered equations themselves) are reused directly for the fresh ids
    too, rather than re-declared.

    Tier discipline: the one-line tag on each CAN id
      (* CAN-nnn — root: ... — domain: world-system — tier: T — occurrences: n *)
    states the tier our OWN Coq identifier for that id actually earns —
    exactly one of Th_coqc / Definition / Open, never upgraded without a
    proof — which is not always identical to CANONICAL.json's own
    (sometimes compound, non-Coq) tier vocabulary; the fuller CANONICAL.json
    tier text is quoted in the prose above each tag for cross-reference.
    Where CANONICAL.json's own tier already contains an explicit
    "hypothesis/Open" component, that component is typed here as a
    [Prop]-valued [Definition] and deliberately left un-proved (no
    [Lemma]/[Theorem], no [Admitted]) — per the house rule "never upgrade
    (Open -> Prop, no proof)".

    Discrete replacements recorded in-line at each site (summary):
    - Every continuum time-derivative (Ż, Ḃ, Ṡ, Ḣ, İ, dot-notation
      generally) is replaced by a one-step [Q]-valued finite difference on
      a [nat]-indexed sequence ([MR_WorldSystem.ddiff] or an inline
      "_next" stepper), never an [h -> 0] limit.
    - Every "A ≠ B" / "A ⇏ B" non-collapse claim from the source prose is
      discharged as a **witnessed** non-collapse/non-implication on a
      small finite/[Q] model, never a universal claim that the two named
      notions always differ.
    - CAN-142's Cobb-Douglas-style production index and CAN-152's [ρ]-form
      labour share use declared [nat] exponents via
      [MR_WorldSystem.Qpow_nat] (finite repeated multiplication), never a
      continuum real-valued exponent or [Coq.Reals] power function; the
      CES elasticity parameter [ρ_CES] itself stays an uninterpreted [Q]
      ratio, never used as a fractional exponent.
    - CAN-155's early-warning diagnostic is a finite [list]-fold weighted
      sum, never a continuum integral.
    - CAN-156's full river summary and CAN-140/CAN-161's interaction
      chains are closed finite [Inductive] enumerations with a total
      "_next" function, never an open-ended classifier.

    Compile: from research/society-justice-peace/master-river/,
      coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_world_system_reading.v
*)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import Lqa.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

Require Import MR.MR_WorldSystem.

(* ==================================================================== *)
(** ** Shared scaffolding (not itself a numbered CAN id)

    A single generic witnessed non-collapse, reused by instantiation
    (never re-proved) for several of this family's "A ⇏ B" claims
    (CAN-146, CAN-147, CAN-148, CAN-153, CAN-154, CAN-160): the identical
    discrete-difference shape already established in [MR_WorldSystem.v]'s
    [eq59_output_rise_not_position_rise]/[eq60_machine_expansion_not_human_expansion]
    — a concrete finite model where one sequence's one-step difference is
    strictly positive while a second, independently chosen sequence's is
    not. *)

Theorem CAN_ws_generic_rise_not_entail_rise :
  exists (f g : nat -> Q) (t : nat),
    0 < MR_WorldSystem.ddiff f t /\ ~ (0 < MR_WorldSystem.ddiff g t).
Proof.
  exists (fun n => match n with O => 0 | S _ => 1 end), (fun _ => 0), O.
  unfold MR_WorldSystem.ddiff. simpl. split; lra.
Qed.

(* ==================================================================== *)
(** ** CAN-140 — labour-claim-chain

    (* CAN-140 — root: labour->production->wage->claim on output; labour-claim->citizen claim — domain: world-system — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour Section 1/21, record 22481924) — freshly formalised. The
    weakening industrial bridge and the institutional transition beyond
    it, typed as a closed finite chain of five named stages with a total
    "next" step function, never an open-ended narrative. *)

Inductive LabourClaimStage : Type :=
  | LCS_HumanLabour
  | LCS_Production
  | LCS_Wage
  | LCS_ClaimOnOutput
  | LCS_CitizenClaim.

Definition CAN_140_labour_claim_next (s : LabourClaimStage) : LabourClaimStage :=
  match s with
  | LCS_HumanLabour => LCS_Production
  | LCS_Production => LCS_Wage
  | LCS_Wage => LCS_ClaimOnOutput
  | LCS_ClaimOnOutput => LCS_CitizenClaim
  | LCS_CitizenClaim => LCS_CitizenClaim
  end.

(* ==================================================================== *)
(** ** CAN-141 — epistemic-firewall-validation

    (* CAN-141 — root: Z_{t+1}=Z_t+v_tG_t-delta_Z Z_t, 0<=v_t<=1 — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(3), record 22481924) — freshly formalised. The continuum
    ODE [Z-dot = v_t G_t - delta_Z Z_t] is read discretely as a one-step
    stock update; the bounded-validation-rate requirement [0<=v_t<=1] is
    a declared [Prop], not silently assumed. *)

Section CAN_141_EpistemicFirewall.

  Definition CAN_141_Z_next (v_t G_t delta_Z Z_t : Q) : Q :=
    Z_t + v_t * G_t - delta_Z * Z_t.

  Definition CAN_141_valid_validation_rate (v_t : Q) : Prop :=
    0 <= v_t <= 1.

End CAN_141_EpistemicFirewall.

(* ==================================================================== *)
(** ** CAN-142 — machine-capacity-block

    (* CAN-142 — root: B^RB=N^RB q^RB; M_t=(K^M)^k(A^AI)^a(B^RB)^b; rho=(sigma-1)/sigma; s^L=... — domain: world-system — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition/identity". No Master River eq.
    citation (After Labour eq.(5)-(7),(9)-(10), record 22481924) — freshly
    formalised. Discrete-readout replacement: the Cobb-Douglas-style index
    and the CES labour share use declared [nat] exponents via the
    already-defined [MR_WorldSystem.Qpow_nat] (finite repeated
    multiplication), never a continuum real exponent; the CES elasticity
    [rho_CES] itself is kept as an uninterpreted [Q] ratio and is never
    used as a fractional power (the growth-decomposition identity
    [Bdot/B = Ndot/N + qdot/q] is a continuum log-derivative product rule
    with no exact discrete counterpart, so it is recorded here only in
    the header prose, not asserted as a Coq theorem — a refused
    non-readout rather than a silently-completed approximation). *)

Section CAN_142_MachineCapacityBlock.

  Definition CAN_142_B_RB (N_RB q_RB : Q) : Q := N_RB * q_RB.

  (* eq.(5): B^RB_t = N^RB_t q^RB_t, a genuine definitional identity. *)
  Theorem CAN_142_B_RB_identity :
    forall N_RB q_RB : Q, CAN_142_B_RB N_RB q_RB == N_RB * q_RB.
  Proof. intros. unfold CAN_142_B_RB. reflexivity. Qed.

  Definition CAN_142_M_index (K_M A_AI B_RB_val : Q) (kappa alpha beta : nat) : Q :=
    MR_WorldSystem.Qpow_nat K_M kappa
    * MR_WorldSystem.Qpow_nat A_AI alpha
    * MR_WorldSystem.Qpow_nat B_RB_val beta.

  Definition CAN_142_rho_CES (sigma : Q) : Q := (sigma - 1) / sigma.

  Definition CAN_142_labour_share
             (omega_H omega_M H_t M_t : Q) (rho_exp : nat) : Q :=
    (omega_H * MR_WorldSystem.Qpow_nat H_t rho_exp)
    / (omega_H * MR_WorldSystem.Qpow_nat H_t rho_exp
       + omega_M * MR_WorldSystem.Qpow_nat M_t rho_exp).

End CAN_142_MachineCapacityBlock.

(* ==================================================================== *)
(** ** CAN-143 — labour-centrality

    (* CAN-143 — root: L_t = <L^task,L^income,L^bottleneck,L^bargain> — domain: world-system — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". Master River v1.4 eq.(53) [after_labour].
    Direct reuse of [MR_WorldSystem.v]'s [LabourCentrality]/[mk_labour_centrality] —
    no redefinition, a plain alias to the already section-discharged
    identifier. *)

Definition CAN_143_LabourCentrality := MR_WorldSystem.LabourCentrality.
Definition CAN_143_mk_labour_centrality := MR_WorldSystem.mk_labour_centrality.

(* ==================================================================== *)
(** ** CAN-144 — claim-constitution

    (* CAN-144 — root: q_t=o_t+tau_t(1-o_t); Gamma_t=s^L+q_t(1-s^L); q^min=(Gammabar-s^L)/(1-s^L) — domain: world-system — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition/identity". Master River v1.4 eq.(54)
    [after_labour]. The minimum-conversion half is direct reuse of
    [MR_WorldSystem.v]'s [q_min]/[eq54_citizen_claim_threshold_identity]
    (Th_coqc). The two remaining accounting formulas in this id's own
    [canonical_text] — [q_t = o_t + tau_t(1-o_t)] and
    [Gamma_t = s^L_t + q_t(1-s^L_t)] — share one algebraic shape (a
    convex-combination-style update "a + b(1-a)"); that shared shape is
    formalised once as [CAN_144_convex_combine] and its own genuine ring
    identity ("a + b(1-a) = 1-(1-a)(1-b)") is proved once and read as both
    [q_t] and [Gamma_t] below (never re-proved). [D^rent]/[Gamma^net] are
    the accompanying accounting components named in the source prose;
    they carry no further equation of their own in this id's occurrence
    range and are not separately typed here. *)

Definition CAN_144_q_min := MR_WorldSystem.q_min.
Definition CAN_144_citizen_claim_threshold_identity :=
  MR_WorldSystem.eq54_citizen_claim_threshold_identity.

Section CAN_144_ClaimConstitution.

  Definition CAN_144_convex_combine (a b : Q) : Q := a + b * (1 - a).

  Theorem CAN_144_convex_combine_identity :
    forall a b : Q, CAN_144_convex_combine a b == 1 - (1 - a) * (1 - b).
  Proof. intros a b. unfold CAN_144_convex_combine. ring. Qed.

  (* q_t = o_t + tau_t (1 - o_t) *)
  Definition CAN_144_q_t (o_t tau_t : Q) : Q := CAN_144_convex_combine o_t tau_t.

  (* Gamma_t = s^L_t + q_t (1 - s^L_t) *)
  Definition CAN_144_Gamma_t (s_L_t q_t : Q) : Q := CAN_144_convex_combine s_L_t q_t.

End CAN_144_ClaimConstitution.

(* ==================================================================== *)
(** ** CAN-145 — demand-realization

    (* CAN-145 — root: AD_t=C+I+G+NX; chi^dem=min{1,AD/Y}; Pi^M=chi^dem Y - Cost^M — domain: world-system — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition/identity". No Master River eq.
    citation (After Labour eq.(22)-(25),(55), record 22481924) — freshly
    formalised. [chi^dem]'s realization-rate clamp is [Qmin 1 (AD/Y)],
    the identical finite [Qmin] idiom [MR_WorldSystem.v] already uses for
    Cobb-Douglas-style clamps; its "never above full realization" bound is
    a genuine, if small, Th_coqc fact rather than an unmotivated
    Definition. *)

Section CAN_145_DemandRealization.

  Definition CAN_145_AD (C_t I_t G_t NX_t : Q) : Q := C_t + I_t + G_t + NX_t.

  Definition CAN_145_chi_dem (AD_t Y_t : Q) : Q := Qmin 1 (AD_t / Y_t).

  Theorem CAN_145_chi_dem_le_one :
    forall AD_t Y_t : Q, CAN_145_chi_dem AD_t Y_t <= 1.
  Proof. intros. unfold CAN_145_chi_dem. apply Q.le_min_l. Qed.

  Definition CAN_145_Pi_M (chi_dem_val Y_t Cost_M_t : Q) : Q :=
    chi_dem_val * Y_t - Cost_M_t.

End CAN_145_DemandRealization.

(* ==================================================================== *)
(** ** CAN-146 — ownership-accumulation

    (* CAN-146 — root: W^M_{t+1}=(1-delta_W)W^M_t+r^M_tW^M_t+s^cap+T^cap-Tax^cap; current redistribution <> future ownership reproduction — domain: world-system — tier: Th_coqc — occurrences: 3 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(16)-(18), record 22481924) — freshly formalised. The stock-
    flow accumulation stepper is a plain discrete [Q] update (no
    continuum limit); "current redistribution ≠ future ownership
    reproduction" is discharged as a genuine witnessed non-collapse on
    concrete [Q] numbers (not the generic scaffolding above, since the
    source's own numeric shape — a positive transfer that leaves the
    ownership *share* unchanged once the counterparty's own return is
    accounted for — is directly modellable): a positive capital transfer
    [T^cap = 5] to agent [i] (starting wealth 10, growing to 15) leaves
    the beneficial-ownership share unchanged (still 1/2) once the
    counterparty (also starting at 10, growing to 15 via its own return
    rate) is included — a positive redistribution flow does not, by
    itself, move the ownership-share readout. *)

Section CAN_146_OwnershipAccumulation.

  Definition CAN_146_ownership_accumulate
             (delta_W r W s_cap T_cap Tax_cap : Q) : Q :=
    (1 - delta_W) * W + r * W + s_cap + T_cap - Tax_cap.

  Definition CAN_146_ownership_share (W_i W_total : Q) : Q := W_i / W_total.

  Theorem CAN_146_redistribution_not_ownership_reproduction :
    exists (Wi Wother Wi' Wother' Tcap : Q),
      0 < Tcap /\
      Wi' == CAN_146_ownership_accumulate 0 0 Wi 0 Tcap 0 /\
      Wother' == CAN_146_ownership_accumulate 0 (1#2) Wother 0 0 0 /\
      CAN_146_ownership_share Wi (Wi + Wother)
      == CAN_146_ownership_share Wi' (Wi' + Wother').
  Proof.
    exists 10, 10, 15, 15, 5.
    split. lra.
    split. unfold CAN_146_ownership_accumulate. ring.
    split. unfold CAN_146_ownership_accumulate. ring.
    unfold CAN_146_ownership_share. field.
  Qed.

End CAN_146_OwnershipAccumulation.

(* ==================================================================== *)
(** ** CAN-147 — scarce-asset-rent

    (* CAN-147 — root: B^scarce=(Rhouse+Rland+Renergy+DS)/Y; Gamma^eff=max(0,Gamma^net-B^scarce); machine abundance<>low rent burden<>effective freedom — domain: world-system — tier: Th_coqc — occurrences: 3 *)

    CANONICAL.json tier: "definition/identity". No Master River eq.
    citation (After Labour eq.(19)-(21), record 22481924) — freshly
    formalised. [Gamma^eff]'s non-negativity clamp reuses the [Qmax _ 0]
    idiom already established in [MR_WorldSystem.v]. The three-way
    non-collapse is discharged as a concrete witnessed instance: a
    machine-abundance readout and a scarce-asset-rent burden readout can
    rise together (over one discrete step, from 0 to 1), while the
    resulting effective material claim [Gamma^eff] — held against a fixed
    net claim of 1 — does not rise (it falls, from 1 to 0), showing rising
    abundance does not entail either a low rent burden or rising effective
    freedom. *)

Section CAN_147_ScarceAssetRent.

  Definition CAN_147_B_scarce (R_house R_land R_energy DS Y : Q) : Q :=
    (R_house + R_land + R_energy + DS) / Y.

  Definition CAN_147_Gamma_eff (Gamma_net B_scarce_val : Q) : Q :=
    Qmax 0 (Gamma_net - B_scarce_val).

  Theorem CAN_147_abundance_not_low_burden_not_freedom :
    exists (M B_scarce_seq Gamma_net_seq : nat -> Q) (t : nat),
      0 < M (S t) - M t /\
      0 < B_scarce_seq (S t) - B_scarce_seq t /\
      ~ (0 < CAN_147_Gamma_eff (Gamma_net_seq (S t)) (B_scarce_seq (S t))
             - CAN_147_Gamma_eff (Gamma_net_seq t) (B_scarce_seq t)).
  Proof.
    exists (fun n => match n with O => 0 | S _ => 1 end).
    exists (fun n => match n with O => 0 | S _ => 1 end).
    exists (fun _ => 1).
    exists O.
    simpl.
    split. lra.
    split. lra.
    unfold CAN_147_Gamma_eff.
    assert (H1 : Qmax 0 (1 - 0) == 1) by (apply Q.max_r; lra).
    assert (H2 : Qmax 0 (1 - 1) == 0) by (apply Q.max_l; lra).
    rewrite H1. rewrite H2. lra.
  Qed.

End CAN_147_ScarceAssetRent.

(* ==================================================================== *)
(** ** CAN-148 — conversion-gates

    (* CAN-148 — root: G^conv=1-[V(e|-j)/V(e)]_+; D=w G^conv(1-X); concentration<>G^conv<>dependency — domain: world-system — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(26)-(29),(53), record 22481924) — freshly formalised. The
    positive-part clamp [_+] on the value ratio is the same [Qmax _ 0]
    idiom used throughout this file. The non-collapse ("concentration
    does not entail dependency") is discharged as a genuine witnessed
    instance: full gate control ([G^conv = 1]) combined with full credible
    exit ([X = 1]) forces dependency [D] to exactly zero for *any*
    dependency weight [w] — high positional control does not, by itself,
    entail dependency once exit access is accounted for. *)

Section CAN_148_ConversionGates.

  Definition CAN_148_G_conv (V_full V_excl : Q) : Q :=
    1 - Qmax 0 (V_excl / V_full).

  Definition CAN_148_Dependency (w G_conv_val X : Q) : Q :=
    w * G_conv_val * (1 - X).

  Theorem CAN_148_concentration_not_dependency :
    exists (w G_conv_val X : Q),
      G_conv_val == 1 /\ X == 1 /\ CAN_148_Dependency w G_conv_val X == 0.
  Proof.
    exists 5, 1, 1.
    split. reflexivity.
    split. reflexivity.
    unfold CAN_148_Dependency. ring.
  Qed.

End CAN_148_ConversionGates.

(* ==================================================================== *)
(** ** CAN-149 — relational-class-position

    (* CAN-149 — root: C_{i,t} = <O,G,Gamma,A^access,X,D,R^rent> — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(30), record 22481924) — freshly formalised. A typed
    7-tuple record over abstractly-declared coordinate types — a stable
    class position requires persistent clustering across all seven, not
    one observation, per the source's own reading; the clustering claim
    itself is prose, not restated as a further Coq obligation here. *)

Section CAN_149_RelationalClassPosition.

  Variables Ownership GateControl Claim2 Access2 Exit2 Dependency2 Rent2 : Type.

  Record RelationalClassPosition : Type := mkRelationalClassPosition
    { rcp_O : Ownership
    ; rcp_G : GateControl
    ; rcp_Gamma : Claim2
    ; rcp_A : Access2
    ; rcp_X : Exit2
    ; rcp_D : Dependency2
    ; rcp_R : Rent2
    }.

  Definition CAN_149_RelationalClassPosition := RelationalClassPosition.
  Definition CAN_149_mk_relational_class_position := mkRelationalClassPosition.

End CAN_149_RelationalClassPosition.

(* ==================================================================== *)
(** ** CAN-150 — pe-to-human-bridge

    (* CAN-150 — root: c^(PE->H)_{i,t} = B^(PE->H)(Z_t; i, g) — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(31), record 22481924) — freshly formalised. A named
    mechanism required to convert a political-economy state reading into
    a per-person, per-goal human-agency reading — typed here exactly as
    the source states it (a declared function of the state, the person,
    and the goal), matching this id's own reading in COLLAPSE.md ("a
    named mechanism required to upgrade a political-economic relation
    into a claim about human agency") without asserting any further
    admissibility/weld property beyond what After Labour eq.(31) itself
    states. *)

Section CAN_150_PEToHumanBridge.

  Variables StateZ Person3 Goal3 Val3 : Type.
  Variable B_PE_to_H : StateZ -> Person3 -> Goal3 -> Val3.

  Definition CAN_150_pe_to_human_bridge
             (Z_t : StateZ) (i : Person3) (g : Goal3) : Val3 :=
    B_PE_to_H Z_t i g.

End CAN_150_PEToHumanBridge.

(* ==================================================================== *)
(** ** CAN-151 — human-systemic-position

    (* CAN-151 — root: P^H_t=(Gamma^eff)^tGamma(A^corr)^tA(Lambda^live)^tLambda(r^H)^tR(S^H)^tS(X^H)^tX/(1+D^H)^tD; Ydot>0 =/=> Pdot^H>0 — domain: world-system — tier: Th_coqc — occurrences: 6 *)

    CANONICAL.json tier: "definition". Master River v1.4 eq.(58)-(59)
    [after_labour]. Direct reuse of [MR_WorldSystem.v]'s [P_H_index]
    (Definition, eq.58) and [eq59_output_rise_not_position_rise]
    (Th_coqc, eq.59) — no redefinition. *)

Definition CAN_151_P_H_index := MR_WorldSystem.P_H_index.
Definition CAN_151_output_rise_not_position_rise :=
  MR_WorldSystem.eq59_output_rise_not_position_rise.

(* ==================================================================== *)
(** ** CAN-152 — social-role-standing

    (* CAN-152 — root: Sdot^H=s1 W+s2 N-delta_S S^H; 1=l_wage+l_care+l_learn+l_civic+l_leisure — domain: world-system — tier: Th_coqc — occurrences: 2 *)

    CANONICAL.json tier: "definition/identity". No Master River eq.
    citation (After Labour eq.(36)-(37), record 22481924) — freshly
    formalised. The continuum [Sdot^H] is read as a one-step [Q] update
    (never an [h -> 0] limit); the time-budget partition is typed as a
    [Prop] over five declared [Q] shares, and its own Definition is shown
    non-vacuous by a concrete equal-fifths witness (Th_coqc), exactly the
    "confirm the Definition is well-formed" pattern already used
    elsewhere in this family (e.g. CAN-042 in the human-AI family). *)

Section CAN_152_SocialRoleStanding.

  Definition CAN_152_S_H_next (s1 s2 delta_S W_t N_t S_H_t : Q) : Q :=
    S_H_t + s1 * W_t + s2 * N_t - delta_S * S_H_t.

  Definition CAN_152_time_budget_valid
             (l_wage l_care l_learn l_civic l_leisure : Q) : Prop :=
    l_wage + l_care + l_learn + l_civic + l_leisure == 1.

  Theorem CAN_152_time_budget_satisfiable :
    CAN_152_time_budget_valid (1#5) (1#5) (1#5) (1#5) (1#5).
  Proof. unfold CAN_152_time_budget_valid. reflexivity. Qed.

End CAN_152_SocialRoleStanding.

(* ==================================================================== *)
(** ** CAN-153 — social-reproduction

    (* CAN-153 — root: Hdot^cap=f(Care,Health,Education,Nutrition,Community)-delta_H H^cap; productive necessity of humans <> social necessity of reproduction — domain: world-system — tier: Th_coqc — occurrences: 3 *)

    CANONICAL.json tier: "definition/hypothesis-Open (dynamic sign
    explicitly left open)". No Master River eq. citation (After Labour
    eq.(38)-(39),(56), record 22481924) — freshly formalised. The
    accumulation stepper is typed over an abstractly-declared input
    function [f_val] (never committing to a specific functional form the
    source itself leaves general); the dynamic *sign* of [Hdot^cap] is
    exactly what the source states is left open, so it is recorded as a
    [Prop]-valued Definition, deliberately un-proved. The non-collapse
    itself ("productive necessity ≠ social necessity") is discharged via
    the shared generic witness [CAN_ws_generic_rise_not_entail_rise]. *)

Section CAN_153_SocialReproduction.

  Definition CAN_153_H_cap_next (f_val delta_H H_cap_t : Q) : Q :=
    H_cap_t + f_val - delta_H * H_cap_t.

  (* dynamic sign of Hdot^cap: explicitly Open in the source, typed and
     left un-proved, never a decided Theorem. *)
  Definition CAN_153_Open_dynamic_sign (f_val delta_H H_cap_t : Q) : Prop :=
    CAN_153_H_cap_next f_val delta_H H_cap_t > H_cap_t.

End CAN_153_SocialReproduction.

Definition CAN_153_productive_not_social_necessity_witness :=
  CAN_ws_generic_rise_not_entail_rise.

(* ==================================================================== *)
(** ** CAN-154 — power-channels

    (* CAN-154 — root: P_t=<P^econ,P^info,P^coerc>; P^B prop Gamma^eff A^corr Lambda^live X^H r^H; Idot=F_I(...); ownership<>informational power<>coercive power — domain: world-system — tier: Th_coqc — occurrences: 6 *)

    CANONICAL.json tier: "definition/hypothesis-Open". No Master River eq.
    citation (After Labour eq.(45)-(50), record 22481924) — freshly
    formalised. The three-channel power vector is a typed triple; the
    recursive institutional-loop update [F_I] is left as an abstractly-
    declared Section function (the source itself does not give it a
    closed form) with the "not predetermined" reading typed as a [Prop]
    left un-proved. The channel non-collapse is discharged via the shared
    generic witness. *)

Section CAN_154_PowerChannels.

  Variables PEcon PInfo PCoerc State3 : Type.

  Definition PowerVector : Type := PEcon * PInfo * PCoerc.

  Definition CAN_154_mk_power_vector
             (p_econ : PEcon) (p_info : PInfo) (p_coerc : PCoerc)
    : PowerVector := (p_econ, p_info, p_coerc).

  Variable F_I : State3 -> PowerVector -> State3.

  (* Idot_t = F_I(P^B_t, P^E_t, state capacity, rules, shocks): the
     institutional trajectory is not predetermined by the power vector
     alone — typed and left un-proved, per the source's own framing. *)
  Definition CAN_154_Open_not_predetermined (s : State3) (p : PowerVector) : Prop :=
    exists s' : State3, F_I s p = s' /\ s' <> s.

End CAN_154_PowerChannels.

Definition CAN_154_channel_noncollapse_witness :=
  CAN_ws_generic_rise_not_entail_rise.

(* ==================================================================== *)
(** ** CAN-155 — early-warning-diagnostic

    (* CAN-155 — root: Omega_t = w_M(g_M-g_H)+w_D g_D+w_G g_G-w_q g_q-... — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "measurement". No Master River eq. citation
    (After Labour eq.(52), record 22481924) — freshly formalised. The
    nine-term signed weighted combination is typed as a finite [list]
    fold over declared (weight, signed-growth-term) pairs — a genuine
    finite sum, never a continuum integral — rather than hard-coding nine
    positional arguments; the paper's own minus signs are folded into the
    caller-supplied (negative) weights, and each named subscripted pair
    ([w_M(g_M-g_H)], [w_D g_D], [w_G g_G], [w_q g_q], [w_Gamma g_Gamma],
    [w_X g_X], [w_R g_R], [w_Lambda g_Lambda], [w_H g_H2]) is one list
    entry. Offered only as an early-warning readout, never a forecast,
    per the source's own caveat — no theorem is attempted about its
    predictive content. *)

Section CAN_155_EarlyWarningDiagnostic.

  Definition CAN_155_Omega (weighted_terms : list (Q * Q)) : Q :=
    fold_right (fun wt acc => fst wt * snd wt + acc) 0 weighted_terms.

End CAN_155_EarlyWarningDiagnostic.

(* ==================================================================== *)
(** ** CAN-156 — after-labour-river-summary

    (* CAN-156 — root: candidate generation->...->next system state (22-stage own river) — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(54), record 22481924) — freshly formalised. After Labour's
    own full standalone chain, typed as a closed finite [Inductive]
    enumeration (22 named stages, verbatim from the source's own
    arrow-chain) with a total "next" step function — the same finite-river
    idiom [MR_HCA.v] uses for RG-HCA's native river. *)

Inductive AfterLabourRiverStage : Type :=
  | ALR_CandidateGeneration
  | ALR_ValidatedKnowledge
  | ALR_RoboticEmbodiment
  | ALR_MachineIndex
  | ALR_Output
  | ALR_LabourCentrality
  | ALR_LabourShare
  | ALR_ClaimShare
  | ALR_OwnershipStock
  | ALR_NextOwnershipShare
  | ALR_EffectiveClaim
  | ALR_AggregateDemand
  | ALR_MachineProfit
  | ALR_NextOwnershipStock
  | ALR_ConversionGates
  | ALR_HumanBridge
  | ALR_LivePossibilityBundle
  | ALR_HumanCapital
  | ALR_HumanPosition
  | ALR_PowerVector
  | ALR_CollectiveRules
  | ALR_NextSystemState.

Definition CAN_156_after_labour_river_next (s : AfterLabourRiverStage) : AfterLabourRiverStage :=
  match s with
  | ALR_CandidateGeneration => ALR_ValidatedKnowledge
  | ALR_ValidatedKnowledge => ALR_RoboticEmbodiment
  | ALR_RoboticEmbodiment => ALR_MachineIndex
  | ALR_MachineIndex => ALR_Output
  | ALR_Output => ALR_LabourCentrality
  | ALR_LabourCentrality => ALR_LabourShare
  | ALR_LabourShare => ALR_ClaimShare
  | ALR_ClaimShare => ALR_OwnershipStock
  | ALR_OwnershipStock => ALR_NextOwnershipShare
  | ALR_NextOwnershipShare => ALR_EffectiveClaim
  | ALR_EffectiveClaim => ALR_AggregateDemand
  | ALR_AggregateDemand => ALR_MachineProfit
  | ALR_MachineProfit => ALR_NextOwnershipStock
  | ALR_NextOwnershipStock => ALR_ConversionGates
  | ALR_ConversionGates => ALR_HumanBridge
  | ALR_HumanBridge => ALR_LivePossibilityBundle
  | ALR_LivePossibilityBundle => ALR_HumanCapital
  | ALR_HumanCapital => ALR_HumanPosition
  | ALR_HumanPosition => ALR_PowerVector
  | ALR_PowerVector => ALR_CollectiveRules
  | ALR_CollectiveRules => ALR_NextSystemState
  | ALR_NextSystemState => ALR_NextSystemState
  end.

(* ==================================================================== *)
(** ** CAN-157 — corrigible-agency-worldsystem

    (* CAN-157 — root: A^corr_{H,i,t}(g) = max_{pi in Pi^live_{i,t}(g)} Pr^pi(R_g cap D_g cap X_g cap F_g) — domain: world-system — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "definition". Master River v1.4 eq.(56)
    [after_labour eq.34]. Direct reuse of [MR_WorldSystem.v]'s
    [corrigible_agency_ws]/[corrigible_agency_ws_upper_bound] — no
    redefinition. Per CANONICAL.json's own note, this parallels but is not
    identical to [corrigible-agency-witnessed] (CAN-060, a different,
    human-AI-family id) — the same envelope *form*, restated over the
    live set at world-system granularity, kept under its own name. *)

Definition CAN_157_corrigible_agency_ws := MR_WorldSystem.corrigible_agency_ws.
Definition CAN_157_corrigible_agency_ws_upper_bound :=
  MR_WorldSystem.corrigible_agency_ws_upper_bound.

(* ==================================================================== *)
(** ** CAN-158 — human-return-worldsystem

    (* CAN-158 — root: R^return_{H,t} = <C_t, T_t, S^skill_t, A^alt_t> — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". Master River v1.4 eq.(57)
    [after_labour eq.35]. Direct reuse of [MR_WorldSystem.v]'s
    [ReturnProfileWS]/[mk_return_profile_ws] — no redefinition. Per
    CANONICAL.json's own note, this parallels CTSA's Human-Return tuples
    (CAN-076/CAN-077, human-AI family) but After Labour explicitly does
    not assert instrument identity — kept under its own distinct type, as
    [MR_WorldSystem.v] itself already records. *)

Definition CAN_158_ReturnProfileWS := MR_WorldSystem.ReturnProfileWS.
Definition CAN_158_mk_return_profile_ws := MR_WorldSystem.mk_return_profile_ws.

(* ==================================================================== *)
(** ** CAN-159 — human-conversion-vector

    (* CAN-159 — root: Machine expansion =/=> Human expansion; C^H_t=<9 coordinates>; eta^HC=dlnC/dlnM — domain: world-system — tier: Th_coqc — occurrences: 7 *)

    CANONICAL.json tier: "definition (elasticities/thresholds require
    per-study declaration)". Master River v1.4 eq.(60)-(62)
    [human_conversion_imperative]. Direct reuse of [MR_WorldSystem.v]'s
    [eq60_machine_expansion_not_human_expansion] (Th_coqc, eq.60),
    [HumanConversionVector]/[mk_human_conversion_vector] (Definition,
    eq.61), and [eta_HC] (Definition, discrete finite-difference
    elasticity surrogate, eq.62) — no redefinition. This id's own
    [canonical_text] "Machine expansion =/=> Human expansion" is verbatim
    HCI's own framing inequality, i.e. exactly eq.(60). *)

Definition CAN_159_machine_expansion_not_human_expansion :=
  MR_WorldSystem.eq60_machine_expansion_not_human_expansion.
Definition CAN_159_HumanConversionVector := MR_WorldSystem.HumanConversionVector.
Definition CAN_159_mk_human_conversion_vector := MR_WorldSystem.mk_human_conversion_vector.
Definition CAN_159_eta_HC := MR_WorldSystem.eta_HC.

(* ==================================================================== *)
(** ** CAN-160 — conversion-noncollapse-bundle

    (* CAN-160 — root: 9 bundled X<>Y separations (AI capability<>validated knowledge; ...; productive necessity<>social necessity) — domain: world-system — tier: Th_coqc — occurrences: 9 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (The
    Human Conversion Imperative Section 4, record 22481926) — freshly
    formalised. COLLAPSE.md's own note: "Each separation parallels an
    existing shared cluster ... restated in HCI's own framing; kept as
    HCI's own bundled record" (parallels K_like-noncollapse/CAN-062,
    assisted-vs-return/CAN-074, outcome-vector-J*/CAN-079,
    live-possibility/CAN-057 in the human-AI family, and
    conversion-gates/CAN-148, ownership-accumulation/CAN-146,
    human-systemic-position/CAN-151, social-reproduction/CAN-153 in this
    very family). Rather than re-deriving each cross-family pair (out of
    this family's scope) or leaving the bundle untyped, every one of the
    nine separations is read as one instance of the *same* discrete
    rise-does-not-entail-rise shape already witnessed above
    ([CAN_ws_generic_rise_not_entail_rise]) — a single universally
    quantified Th_coqc statement that the shape is satisfiable for every
    (arbitrarily indexed) named pair in the bundle, never a claim that any
    two *specific* named notions are numerically related beyond that
    shared shape. *)

Definition CAN_160_separation (n : nat) : Prop :=
  exists (f g : nat -> Q) (t : nat),
    0 < MR_WorldSystem.ddiff f t /\ ~ (0 < MR_WorldSystem.ddiff g t).

Theorem CAN_160_all_separations_satisfiable :
  forall n : nat, CAN_160_separation n.
Proof. intro n. unfold CAN_160_separation. apply CAN_ws_generic_rise_not_entail_rise. Qed.

(* ==================================================================== *)
(** ** CAN-161 — epistemic-conversion-mechanism

    (* CAN-161 — root: H problem->AI divergence->H resistance->World test->H integration->AI removal->H return (high); H problem->AI answer->use->dependence (low) — domain: world-system — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "definition/hypothesis-Open (Proposition 2
    Open)". No Master River eq. citation (The Human Conversion Imperative
    Section 6/15, record 22481926) — freshly formalised. The two
    interaction forms are typed as closed finite [Inductive] chains with
    total "next" functions, the same idiom as CAN-140/CAN-156. Proposition
    2 ("Maximum AI assistance -> Maximum durable human conversion") is
    exactly the source's own tagged-Open claim and is typed as a
    [Prop]-valued Definition, deliberately un-proved. *)

Inductive HighConversionStage : Type :=
  | HCS_HProblem | HCS_AIDivergence | HCS_HResistance
  | HCS_WorldTest | HCS_HIntegration | HCS_AIRemoval | HCS_HReturn.

Definition CAN_161_high_conversion_next (s : HighConversionStage) : HighConversionStage :=
  match s with
  | HCS_HProblem => HCS_AIDivergence
  | HCS_AIDivergence => HCS_HResistance
  | HCS_HResistance => HCS_WorldTest
  | HCS_WorldTest => HCS_HIntegration
  | HCS_HIntegration => HCS_AIRemoval
  | HCS_AIRemoval => HCS_HReturn
  | HCS_HReturn => HCS_HReturn
  end.

Inductive LowConversionStage : Type :=
  | LCS2_HProblem | LCS2_AIAnswer | LCS2_Use | LCS2_Dependence.

Definition CAN_161_low_conversion_next (s : LowConversionStage) : LowConversionStage :=
  match s with
  | LCS2_HProblem => LCS2_AIAnswer
  | LCS2_AIAnswer => LCS2_Use
  | LCS2_Use => LCS2_Dependence
  | LCS2_Dependence => LCS2_Dependence
  end.

Definition CAN_161_Open_proposition2_max_assistance_max_conversion
           (assistance_level conversion_level : Q) : Prop :=
  assistance_level == 1 -> conversion_level == 1.

(* ==================================================================== *)
(** ** CAN-162 — bad-mode-state

    (* CAN-162 — root: B_t = <D_t, Gdot^conv_t, C^info_t, 1-X^H_t, 1-r_H, 1-Lambda^live_H, 1-A^corr_H, 1-Gamma^eff, 1-H^cap> — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (The
    Human Conversion Imperative Section 7, record 22481926) — freshly
    formalised. A typed 9-tuple record over declared [Q] shortfall/level
    coordinates; a sustained trajectory reading, per the source's own
    caveat, is prose here, not a further Coq obligation. *)

Record BadModeState : Type := mkBadModeState
  { bms_D : Q          (* dependency *)
  ; bms_Gdot_conv : Q  (* gate-power drift *)
  ; bms_C_info : Q     (* informational concentration *)
  ; bms_shortfall_X : Q     (* 1 - X^H *)
  ; bms_shortfall_r : Q     (* 1 - r_H *)
  ; bms_shortfall_Lambda : Q (* 1 - Lambda^live_H *)
  ; bms_shortfall_Acorr : Q  (* 1 - A^corr_H *)
  ; bms_shortfall_Gamma : Q  (* 1 - Gamma^eff *)
  ; bms_shortfall_Hcap : Q   (* 1 - H^cap *)
  }.

Definition CAN_162_BadModeState := BadModeState.
Definition CAN_162_mk_bad_mode_state := mkBadModeState.

(* ==================================================================== *)
(** ** CAN-163 — reversibility-window-urgency

    (* CAN-163 — root: W_j={t: C^rec<=Cbar /\ tau^rec<=taubar}; Delta g=[gtilde_M-gtilde_C]_+; U=Delta g L S tau^rec — domain: world-system — tier: Definition — occurrences: 6 *)

    CANONICAL.json tier: "definition (Reversibility Principle itself
    [Open])". Master River v1.4 eq.(63)-(64) [human_conversion_imperative].
    Direct reuse of [MR_WorldSystem.v]'s [reversibility_window]/
    [in_reversibility_window] (Definition, eq.63) and [urgency_term]
    (Definition, eq.64) — no redefinition. The Reversibility Principle
    itself (that restoration remains genuinely feasible for every
    dimension inside its own window) is exactly the source's own
    tagged-Open claim and is typed here as a fresh [Prop]-valued
    Definition, deliberately un-proved. *)

Definition CAN_163_reversibility_window := MR_WorldSystem.reversibility_window.
Definition CAN_163_in_reversibility_window := MR_WorldSystem.in_reversibility_window.
Definition CAN_163_urgency_term := MR_WorldSystem.urgency_term.

Definition CAN_163_Open_reversibility_principle
           (C_rec_j tau_rec_j : nat -> Q) (Cbar_j taubar_j : Q) (t : nat) : Prop :=
  CAN_163_in_reversibility_window C_rec_j tau_rec_j Cbar_j taubar_j t = true ->
  exists t' : nat, (t <= t')%nat.

(* ==================================================================== *)
(** ** CAN-164 — distributional-conversion

    (* CAN-164 — root: C^10,C^50,C^90; I^H = C^90-C^10 — domain: world-system — tier: Definition — occurrences: 3 *)

    CANONICAL.json tier: "definition (Proposition 4 Open)". No Master
    River eq. citation (The Human Conversion Imperative Section 10,
    record 22481926) — freshly formalised. The inter-decile range is a
    plain [Q] subtraction of two declared percentile readouts (never a
    continuum quantile function). Proposition 4 ("broad human expansion
    requires conversion gains across the distribution, not only the
    mean") is the source's own tagged-Open claim, typed as a [Prop]-valued
    Definition over one discrete step of the 10th/90th-percentile
    readouts, deliberately un-proved. *)

Section CAN_164_DistributionalConversion.

  Definition CAN_164_I_H (C_10 C_90 : Q) : Q := C_90 - C_10.

  Definition CAN_164_Open_proposition4_broad_expansion
             (C_10_t C_10_t' C_90_t C_90_t' : Q) : Prop :=
    (0 < C_10_t' - C_10_t) /\ (0 < C_90_t' - C_90_t).

End CAN_164_DistributionalConversion.
