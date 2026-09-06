(** * MR_WorldSystem.v — Master Equation River, Block C: eq. (52)-(64)

    Source of record: research/society-justice-peace/master-river/v1_3/main.tex
    (Master Equation River v1.3), Section "The World-System Layer: Human
    Systemic Position and Human Conversion" (\label{sec:worldsystem}),
    eq. 52-64. eq. 52-59 restate After Labour \citep{after_labour}
    (each traced to After Labour's own equation number in the running
    prose); eq. 60-64 restate The Human Conversion Imperative (HCI)
    \citep{human_conversion_imperative}.

    Tier source (each cited to the paper's own words / Table 2):
    - eq. 52: "a self-contained readout definition (After Labour eq. 2)" —
      Table 2's "New in v1.3" Domain-definitions row lists
      "the self-contained readout Readout_{Q,O,c}(S)".
    - eq. 53: "disaggregated into four coordinates" (After Labour eq. 8) —
      Table 2 lists "four-dimensional labour centrality L_t" as a Domain
      definition.
    - eq. 54: "an accounting identity inside the stylized claim block"
      (After Labour eq. 13) — Table 2's Accounting-identities row names
      "The Citizen Claim Threshold q_t^min" explicitly.
    - eq. 55: "restates ... the same possible/feasible/live nesting
      already used" in \Cref{sec:live1} (After Labour eq. 32) — the source
      of eq. (19), tiered Th_coqc in MR_Live.v via a proof from the
      definitions; the same proof technique is used here.
    - eq. 56: "the same task-relative envelope form as \eqref{eq:25},
      restated here at the world-system level" (After Labour eq. 34) —
      eq. (25) is tiered Definition in MR_Live.v (a finite max over a
      declared set); the same tier and technique is used here.
    - eq. 57: "likewise restated at this level" (After Labour eq. 35) — a
      typed 4-tuple, parallel to eq. (41)'s [HReturn] record but kept
      under a distinct name/type since After Labour does not assert the
      two instruments are identical.
    - eq. 58: "a typed audit index" that After Labour "states explicitly
      is not a welfare utility function or a validated cardinal scale"
      (After Labour eq. 40) — Definition tier, not a proof obligation.
    - eq. 59: "its primary non-collapse result" (After Labour eq. 43) —
      the assignment brief's own worked example: a witness model where an
      output difference is positive and the position difference is not,
      exactly the eq. (30)/(59) family already used for possibility claims
      in MR_Prompt.v, now proved as a genuine non-collapse.
    - eq. 60: HCI's "one framing inequality" (HCI eq. 1) — the same
      witnessed non-collapse technique as eq. 59, restated for machine
      versus human expansion.
    - eq. 61: "a Human Conversion Vector [\textsc{Definition}]"
      (HCI eq. 11) — explicitly tagged Definition by the paper itself.
    - eq. 62: "a local elasticity for each dimension j ...
      [\textsc{Definition}]" (HCI eq. 12) — explicitly tagged Definition.
    - eq. 63: "a Reversibility Window for each dimension j
      [\textsc{Definition}]" (HCI eq. 17) — explicitly tagged Definition.
    - eq. 64: "an Urgency term ... [\textsc{Definition}]" (HCI eq. 19) —
      explicitly tagged Definition.

    DISCIPLINE: readout-first, as in the other Block A/B/C files — no
    [Reals], no classical axioms, [Q]-valued weights, finite lists model
    finite sets, Section+Variables/Hypotheses for abstract objects
    (discharged, never top-level [Parameter]/[Axiom]), no [Admitted]. Two
    readout-first replacements are recorded explicitly where the paper's
    own notation is continuum-looking:
    - eq. (58)'s Cobb-Douglas-style index uses free *real* exponents
      theta_*; these are replaced by declared [nat] exponents and a
      finite repeated-multiplication power [Qpow_nat] (never
      [Coq.Reals]/an analytic power function).
    - eq. (62)'s partial log-derivative d(ln C)/d(ln M) is replaced by its
      discrete finite-difference (percentage-change) surrogate, a ratio of
      two [Q]-valued one-step relative changes, never a continuum limit.
*)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

(* ------------------------------------------------------------------ *)
(** ** Section: the self-contained readout definition (eq. 52) *)

Section ReadoutDefinition.

  Variables StateT ParamQuestion ParamObserver ParamContext : Type.

  (* eq. (52) — tier: Definition *)
  (** Readout_{Q,O,c}(S) = z, z <> S (After Labour eq. 2).  A
      self-contained readout: a declared map from a state and three
      parameters (question, observer, context) to a value, together with
      the defining requirement that the readout is a genuine
      transformation of the state, never silently equal to it — the
      identical "a readout is not the thing itself" commitment this whole
      development is built on. The value type is taken to be [StateT]
      itself (so that "[z <> S]" is a well-typed comparison, exactly as
      the paper's own notation implies), and the non-identity requirement
      is recorded as a discharged Section [Hypothesis], never a top-level
      [Axiom]. *)
  Variable readout_52 : StateT -> ParamQuestion -> ParamObserver -> ParamContext -> StateT.

  Hypothesis readout_ne_state :
    forall (s : StateT) (q : ParamQuestion) (o : ParamObserver) (c : ParamContext),
      readout_52 s q o c <> s.

  (** Supporting fact (not itself a new equation number): the defining
      hypothesis above is satisfiable — a concrete non-identity readout
      genuinely exists on a two-point state space — so eq. (52)'s
      requirement is not vacuous. This is scaffolding confirming the
      Definition is well-formed, not a re-tagging of eq. 52 itself. *)
  Remark readout_52_hypothesis_satisfiable_on_bool :
    exists (readout' : bool -> unit -> unit -> unit -> bool),
      forall (s : bool) (q o c : unit), readout' s q o c <> s.
  Proof.
    exists (fun s _ _ _ => negb s).
    intros [] [] [] []; simpl; discriminate.
  Qed.

End ReadoutDefinition.

(* ------------------------------------------------------------------ *)
(** ** Section: four-dimensional labour centrality (eq. 53) *)

Section LabourCentrality.

  Variables Task Income Bottleneck Bargain : Type.

  (* eq. (53) — tier: Definition *)
  (** L_t = <L_t^task, L_t^income, L_t^bottleneck, L_t^bargain>
      (After Labour eq. 8).  Labour's systemic role, typed as a 4-tuple
      rather than read off employment status alone. *)
  Definition LabourCentrality : Type := Task * Income * Bottleneck * Bargain.

  Definition mk_labour_centrality
             (task : Task) (income : Income) (bottleneck : Bottleneck) (bargain : Bargain)
    : LabourCentrality := (task, income, bottleneck, bargain).

End LabourCentrality.

(* ------------------------------------------------------------------ *)
(** ** Section: the Citizen Claim Threshold (eq. 54) *)

Section CitizenClaimThreshold.

  (* eq. (54) — tier: Th_coqc *)
  (** q_t^min = (Gammabar - s_t^L) / (1 - s_t^L) (After Labour eq. 13).
      An accounting identity inside the stylized claim block: proved over
      [Q], exactly the "q = o + tau(1-o) = 1-(1-o)(1-tau)"-style algebraic
      identity the task brief itself names as the Th_coqc pattern for
      accounting identities, here for the minimum non-labour conversion
      needed to hold a target claim [Gammabar] against a labour-income
      share [s_t^L], valid away from the [s_t^L = 1] singularity (a
      refused non-readout, per the information-discrete-math discipline:
      the identity is stated exactly where it is well-defined, not
      silently completed across the pole). *)
  Definition q_min (Gammabar s_tL : Q) : Q := (Gammabar - s_tL) / (1 - s_tL).

  Theorem eq54_citizen_claim_threshold_identity :
    forall Gammabar s_tL : Q,
      ~ (1 - s_tL == 0) ->
      q_min Gammabar s_tL * (1 - s_tL) == Gammabar - s_tL.
  Proof.
    intros Gammabar s_tL Hne.
    unfold q_min.
    field.
    exact Hne.
  Qed.

End CitizenClaimThreshold.

(* ------------------------------------------------------------------ *)
(** ** Section: the world-system possible/feasible/live nesting (eq. 55) *)

Section WorldSystemNesting.

  Variables Person Goal2 Policy2 : Type.

  (** Pi^feas_{i,t}(g) and Pi^phys_t(g), restated at the world-system
      level (After Labour eq. 32): the identical finite-list modelling
      already used for eq. (19) in MR_Live.v, reindexed by person [i]
      rather than agent [A]. *)
  Variable Pi_feas_ws : Person -> nat -> Goal2 -> list Policy2.
  Variable Pi_phys_ws : nat -> Goal2 -> list Policy2.

  Hypothesis feas_subset_phys_ws :
    forall (i : Person) (t : nat) (g : Goal2) (pi : Policy2),
      In pi (Pi_feas_ws i t g) -> In pi (Pi_phys_ws t g).

  Variable lambda_live_ws : Person -> nat -> Policy2 -> Goal2 -> Q.
  Variable tau_live_ws : Q.

  Definition live_ge_threshold_ws (i : Person) (t : nat) (g : Goal2) (pi : Policy2) : bool :=
    Qle_bool tau_live_ws (lambda_live_ws i t pi g).

  Definition Pi_live_ws (i : Person) (t : nat) (g : Goal2) : list Policy2 :=
    filter (live_ge_threshold_ws i t g) (Pi_feas_ws i t g).

  (* eq. (55) — tier: Th_coqc *)
  (** Pi^live_{i,t}(g) subseteq Pi^feas_{i,t}(g) subseteq Pi^phys_t(g).
      Proved from the definitions exactly as eq. (19) in MR_Live.v: [Pi_live_ws]
      is by construction a [filter] of [Pi_feas_ws], so membership entails
      membership in [Pi_feas_ws] (stdlib [filter_In]); [Pi_feas_ws subseteq
      Pi_phys_ws] is the declared structural hypothesis
      [feas_subset_phys_ws], carried over unchanged from Choice Begins
      Before Choice via After Labour's own restatement. *)
  Theorem eq55_live_subset_feas_ws :
    forall (i : Person) (t : nat) (g : Goal2) (pi : Policy2),
      In pi (Pi_live_ws i t g) -> In pi (Pi_feas_ws i t g).
  Proof.
    intros i t g pi Hin.
    unfold Pi_live_ws in Hin.
    apply filter_In in Hin.
    destruct Hin as [Hin _].
    exact Hin.
  Qed.

  Theorem eq55_live_subset_phys_ws :
    forall (i : Person) (t : nat) (g : Goal2) (pi : Policy2),
      In pi (Pi_live_ws i t g) -> In pi (Pi_phys_ws t g).
  Proof.
    intros i t g pi Hin.
    apply (feas_subset_phys_ws i t g pi).
    exact (eq55_live_subset_feas_ws i t g pi Hin).
  Qed.

  Theorem eq55_full_nesting_ws :
    forall (i : Person) (t : nat) (g : Goal2) (pi : Policy2),
      In pi (Pi_live_ws i t g) ->
      In pi (Pi_feas_ws i t g) /\ In pi (Pi_phys_ws t g).
  Proof.
    intros i t g pi Hin.
    split.
    - exact (eq55_live_subset_feas_ws i t g pi Hin).
    - exact (eq55_live_subset_phys_ws i t g pi Hin).
  Qed.

End WorldSystemNesting.

(* ------------------------------------------------------------------ *)
(** ** Section: the world-system corrigible-agency envelope and the
       delayed unaided return profile (eq. 56-57) *)

Section WorldSystemEnvelope.

  Variables PolicyW2 : Type.

  (** Pr^pi(R_g cap D_g cap X_g cap F_g), abstracted as in eq. (25) of
      MR_Live.v: a single declared [Q]-valued evaluation of a policy under
      the four intersected event conditions. *)
  Variable Pr_event_ws : PolicyW2 -> Q.

  (* eq. (56) — tier: Definition *)
  (** A^corr_{H,i,t}(g) = max_{pi in Pi^live_{i,t}(g)} Pr^pi(R_g cap D_g
      cap X_g cap F_g) (After Labour eq. 34).  "The same task-relative
      envelope form as eq. (25), restated here at the world-system level
      rather than the witnessed-set level": the identical finite-list-max
      construction as eq. (25), now maximised over the (world-system)
      live set rather than the witnessed set. *)
  Definition corrigible_agency_ws (live_policies : list PolicyW2) : Q :=
    fold_right Qmax 0 (map Pr_event_ws live_policies).

  Theorem corrigible_agency_ws_upper_bound :
    forall (live_policies : list PolicyW2) (pi : PolicyW2),
      In pi live_policies -> Pr_event_ws pi <= corrigible_agency_ws live_policies.
  Proof.
    intro live_policies.
    induction live_policies as [| p rest IH]; intros pi Hin.
    - simpl in Hin. contradiction.
    - simpl in Hin. destruct Hin as [Heq | Hin'].
      + subst. unfold corrigible_agency_ws. simpl. apply Q.le_max_l.
      + unfold corrigible_agency_ws. simpl.
        apply Qle_trans with (y := fold_right Qmax 0 (map Pr_event_ws rest)).
        * apply IH. exact Hin'.
        * apply Q.le_max_r.
  Qed.

End WorldSystemEnvelope.

Section DelayedReturnProfile.

  Variables Concept2 ToolSel SkillExec AltGen : Type.

  (* eq. (57) — tier: Definition *)
  (** R^return_{H,t} = <C_t, T_t, S_t^skill, A_t^alt> (After Labour eq. 35).
      A delayed unaided return profile, restated at the world-system
      level; its four coordinates parallel [HReturn] (eq. 41 in
      MR_Retention.v) but are kept under a distinct type, since After
      Labour does not assert the two instruments are identical. *)
  Definition ReturnProfileWS : Type := Concept2 * ToolSel * SkillExec * AltGen.

  Definition mk_return_profile_ws
             (c : Concept2) (t : ToolSel) (s : SkillExec) (a : AltGen)
    : ReturnProfileWS := (c, t, s, a).

End DelayedReturnProfile.

(* ------------------------------------------------------------------ *)
(** ** Section: the Human Systemic Position audit index and its
       non-collapse (eq. 58-59) *)

Section HumanSystemicPosition.

  (** Discrete-readout replacement for eq. (58)'s continuum real-valued
      exponents theta_*: a finite repeated-multiplication power on [Q] for
      a declared [nat] exponent, never [Coq.Reals]/an analytic power
      function. [Qpow_nat q 0 = 1] and [Qpow_nat q (S n) = q * Qpow_nat q n]. *)
  Fixpoint Qpow_nat (q : Q) (n : nat) : Q :=
    match n with
    | O => 1
    | S n' => q * Qpow_nat q n'
    end.

  (* eq. (58) — tier: Definition *)
  (** P_t^H = (Gamma^eff)^theta_Gamma (A^corr)^theta_A (Lambda^live)^theta_Lambda
      (r^H)^theta_R (S^H)^theta_S (X^H)^theta_X / (1+D^H)^theta_D
      (After Labour eq. 40).  A typed audit index — After Labour states
      explicitly this is "not a welfare utility function or a validated
      cardinal scale" — so it is typed exactly as the paper writes it
      (with the theta_* exponents replaced by declared [nat] readouts per
      the discrete-power substitution above), not proved. *)
  Definition P_H_index
             (Gamma_eff A_corr Lambda_live r_H S_H X_H D_H : Q)
             (theta_Gamma theta_A theta_Lambda theta_R theta_S theta_X theta_D : nat)
    : Q :=
    (Qpow_nat Gamma_eff theta_Gamma * Qpow_nat A_corr theta_A *
     Qpow_nat Lambda_live theta_Lambda * Qpow_nat r_H theta_R *
     Qpow_nat S_H theta_S * Qpow_nat X_H theta_X)
    / Qpow_nat (1 + D_H) theta_D.

  (** Discrete-difference replacement for the continuum time-derivative
      dot-notation (Ydot, Pdot) used in eq. (58)'s prose and eq. (59): a
      one-step [Q]-valued finite difference on a [nat]-indexed sequence,
      never an [h -> 0] limit. Shared scaffolding for eq. 59 and eq. 60
      below (it is not itself a numbered equation). *)
  Definition ddiff (f : nat -> Q) (t : nat) : Q := f (S t) - f t.

  (* eq. (59) — tier: Th_coqc *)
  (** Ydot_t > 0 =/=> Pdot_t^H > 0 (After Labour eq. 43), read discretely
      as: a rising aggregate-output sequence does not entail a rising
      Human Systemic Position sequence. Proved as a witnessed non-collapse
      — a concrete finite model where the discrete output difference is
      strictly positive while the discrete position-index difference is
      not — exactly the assignment brief's own worked example for this
      equation. *)
  Theorem eq59_output_rise_not_position_rise :
    exists (Y PH : nat -> Q) (t : nat),
      0 < ddiff Y t /\ ~ (0 < ddiff PH t).
  Proof.
    exists (fun n => match n with O => 0 | S _ => 1 end).
    exists (fun _ => 0).
    exists O.
    unfold ddiff. split; simpl; lra.
  Qed.

End HumanSystemicPosition.

(* ------------------------------------------------------------------ *)
(** ** Section: HCI's framing inequality (eq. 60) *)

Section MachineHumanExpansion.

  (* eq. (60) — tier: Th_coqc *)
  (** Machine expansion =/=> Human expansion (HCI eq. 1).  The same
      witnessed-non-collapse technique as eq. (59): a concrete finite
      model where machine-capability rises (a strictly positive discrete
      difference) while human-capability does not. *)
  Theorem eq60_machine_expansion_not_human_expansion :
    exists (M Hc : nat -> Q) (t : nat),
      0 < ddiff M t /\ ~ (0 < ddiff Hc t).
  Proof.
    exists (fun n => match n with O => 0 | S _ => 1 end).
    exists (fun _ => 0).
    exists O.
    unfold ddiff. split; simpl; lra.
  Qed.

End MachineHumanExpansion.

(* ------------------------------------------------------------------ *)
(** ** Section: the Human Conversion Vector (eq. 61) *)

Section HumanConversionVector.

  Variables GammaEffT XHT LambdaLiveT ACorrT RRouteT WWorldT RHT HCapT SHT : Type.

  (* eq. (61) — tier: Definition *)
  (** C^H_t = <Gamma^eff_t, X^H_t, Lambda^live_{H,t}, A^corr_{H,t},
      R^route_{H,t}, W^world_{H,t}, r_{H,t}, H^cap_t, S_{H,t}>
      (HCI eq. 11, explicitly tagged [\textsc{Definition}] by the paper
      itself).  A typed 9-tuple replacing a single scalar augmentation
      score. *)
  Definition HumanConversionVector : Type :=
    GammaEffT * XHT * LambdaLiveT * ACorrT * RRouteT * WWorldT * RHT * HCapT * SHT.

  Definition mk_human_conversion_vector
             (g : GammaEffT) (x : XHT) (l : LambdaLiveT) (a : ACorrT) (r : RRouteT)
             (w : WWorldT) (rh : RHT) (h : HCapT) (s : SHT)
    : HumanConversionVector := (g, x, l, a, r, w, rh, h, s).

End HumanConversionVector.

(* ------------------------------------------------------------------ *)
(** ** Section: the per-dimension conversion elasticity (eq. 62) *)

Section ConversionElasticity.

  Variables C_j M_t : nat -> Q.

  (* eq. (62) — tier: Definition *)
  (** eta^HC_{j,t} = d(ln C^H_{j,t}) / d(ln M_t) (HCI eq. 12, explicitly
      tagged [\textsc{Definition}]).  Discrete-readout replacement of the
      continuum partial log-derivative: a ratio of two one-step [Q]-valued
      relative (percentage) changes, never [Coq.Reals]/an [exp]/[ln]
      construction — meaningful away from [C_j t == 0] and
      [M_t (S t) - M_t t == 0], per the declared-per-study discipline the
      source paper itself states for every weight/elasticity/threshold. *)
  Definition eta_HC (t : nat) : Q :=
    ((C_j (S t) - C_j t) / C_j t) / ((M_t (S t) - M_t t) / M_t t).

End ConversionElasticity.

(* ------------------------------------------------------------------ *)
(** ** Section: the Reversibility Window (eq. 63) *)

Section ReversibilityWindow.

  Variable C_rec tau_rec : nat -> Q.
  Variable Cbar taubar : Q.

  (* eq. (63) — tier: Definition *)
  (** W_j = {t : C^rec_{j,t} <= Cbar_j /\ tau^rec_{j,t} <= taubar_j}
      (HCI eq. 17, explicitly tagged [\textsc{Definition}]).  A decidable
      threshold-cut filter over a declared finite list of time indices,
      exactly the [filter]/[Qle_bool] pattern already used for eq. (21) in
      MR_Live.v, never an unbounded set-comprehension over an
      uncountable/continuum index. *)
  Definition in_reversibility_window (t : nat) : bool :=
    andb (Qle_bool (C_rec t) Cbar) (Qle_bool (tau_rec t) taubar).

  Definition reversibility_window (candidate_times : list nat) : list nat :=
    filter in_reversibility_window candidate_times.

End ReversibilityWindow.

(* ------------------------------------------------------------------ *)
(** ** Section: the Urgency term (eq. 64) *)

Section UrgencyTerm.

  (* eq. (64) — tier: Definition *)
  (** U_{j,t} = Delta g_{j,t} L_{j,t} S_{j,t} tau^rec_{j,t}
      (HCI eq. 19, explicitly tagged [\textsc{Definition}]).  A declared
      product of four [Q]-valued per-dimension quantities: the
      machine/human growth gap, lock-in, severity, and recovery time. *)
  Definition urgency_term (delta_g L_jt S_jt tau_rec_jt : Q) : Q :=
    delta_g * L_jt * S_jt * tau_rec_jt.

End UrgencyTerm.
