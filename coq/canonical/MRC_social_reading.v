(** * MRC_social_reading.v — Family "social-reading": CAN-115..CAN-139

    Source of record: research/society-justice-peace/master-river/registry/
    CANONICAL.json (domain: "social", 25 ids, CAN-115..CAN-139) and
    registry/COLLAPSE.md Section 3 / "Social domain (25 ids)" table.
    Assignment record: registry/family_social-reading.json.

    This family is NOT root-spine (spine_ids are domain: "root", family
    root-spine, coq_canon/MRC_root_spine.v/MRC_master.v) — per
    COLLAPSE.md Section 2: "The social reading (CAN-115 B-SOC-LRSTEPPER)
    reads CAN-001 directly and by the same symbol ... CAN-117 (regime
    translation operator T_R) reads CAN-003". Being a q_D *reading* of the
    spine, not a second spine, this file does not produce [MRC_master.v] —
    the master-equation composition and [DomainReading]/[weld_holds]
    apparatus belong to the root-spine family's own file.

    REUSE (per the task brief: "reuse coq/MR_*.v for CAN ids that are
    Master River eq 1-79"): of the 25 ids, exactly THREE carry a non-null
    [in_master_river] field in CANONICAL.json — CAN-128 (eq.19-24),
    CAN-132 (eq.25), CAN-134 (eq.26) — all three formalised already, axiom-
    free, in [../coq/MR_Live.v]. Those three are discharged here by
    [Require Import]-ing [MR.MR_Live] and aliasing its identifiers under
    the CAN id, never redefining them. A fourth id, CAN-124, cites the same
    eq.(26) text in its own [canonical_source] prose but has
    [in_master_river: null] in CANONICAL.json itself (a registry drift,
    disclosed in the ledger, not silently resolved) — it is aliased to the
    same [MR_Live.live_field_gap] object rather than re-derived, since its
    [canonical_text] is symbol-identical to CAN-134's. The remaining 21 ids
    are standalone (their own [canonical_source] cites a record id, not a
    Master River eq. number) and are freshly formalised here.

    DISCIPLINE (identical to every other file in this repository):
      - Coq 8.20.1. No [Coq.Reals], no classical axioms, no [Admitted], no
        top-level [Axiom]/[Parameter] (only Section [Variable]/[Hypothesis],
        discharged when the section closes).
      - All numeric content lives on [Q] (rationals), [nat], [bool], lists,
        or [Inductive]s — never a continuum type. Every "derivative"
        (d/dt' V <= 0), "limit" (lim_{T->infty}), or "supremum over an
        unbounded set" in the source papers is discretely replaced: a
        derivative-sign condition becomes a per-tick non-increase on a
        [nat -> Q] sequence; a "for all t" persistence claim becomes a
        finite unrolled trajectory; a supremum becomes [fold_right Qmax 0]
        over a finite, declared, witnessed list — never a classical [sup].
      - One Coq identifier per CAN id, tagged with a one-line comment of
        the exact required shape:
          (* CAN-nnn — root: ... — domain: social — tier: T — occurrences: n *)
        Tier is exactly one of Th_coqc / Definition / Open, never upgraded
        without a proof. Where CANONICAL.json's own tier word is "axiom",
        the object is typed here as [Definition] (a locked domain-typing
        discipline, not a further logical assumption needing an axiom) —
        following the house style already used for "Dr"/"law" tiers in
        [MRC_root_spine.v]. Where CANONICAL.json's own tier contains
        "theorem [paper-internal, not Coq-verified]" or "hypothesis/Open",
        the corresponding object is typed as a [Prop]-valued [Definition]
        (or an abstract, Section-discharged [Variable] of type [Prop]) and
        deliberately left un-proved — no [Lemma]/[Theorem], no [Admitted] —
        per the house rule "never upgrade (Open -> Prop, no proof)".

    Compile: from research/society-justice-peace/master-river/,
      coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_social_reading.v
*)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

Require Import MR.MR_Live.

(* ==================================================================== *)
(** ** CAN-115 — B-SOC-LRSTEPPER

    (* CAN-115 — root: A:=L_R+Gamma; s[n+1]=s[n]+dt(-A s[n]+J) — domain: social — tier: Definition — occurrences: 18 *)

    CANONICAL.json tier: "definition (PAR-stepper); theorem [paper-internal,
    not Coq-verified] (L1-L4, and the earlier No-Go Theorem)". Reads CAN-001
    (root-weld) directly, by the same symbol L_R = D_W - W, onto a social-
    tension field: nodes are social units (a finite [list nat], never an
    unbounded/continuum vertex set), edges are [Q]-valued couplings, and
    [Gamma] is a per-node dissipation/repair-rate diagonal. The stepper
    [CAN_115_step] is the discrete Euler update s[n+1]=s[n]+dt(-A s[n]+J) —
    a genuinely finite recurrence, never a continuum ODE. PAR-stepper itself
    (the object) is typed and witnessed non-trivial at tier Th_coqc; L1-L4
    (fixed-point invariance, cost lower bound, operator-change escape route,
    mutation-to-neighbour) are the paper's own theorems, not independently
    machine-checked here, so each is typed as a [Prop]-valued [Definition]
    and deliberately left un-proved (tier: Open), per the house rule. *)

Section CAN_115_SocialLRStepper.

  Variable verts : list nat.
  Variable W     : nat -> nat -> Q.   (* pairwise coupling / retained-distinction weight *)
  Variable Gamma : nat -> Q.          (* per-node dissipation / repair rate *)
  Variable J     : nat -> Q.          (* sustained load / inequality forcing *)
  Variable dt    : Q.

  Definition CAN_115_degree (i : nat) : Q :=
    fold_right Qplus 0 (map (W i) verts).

  Definition CAN_115_L_R (i j : nat) : Q :=
    if Nat.eqb i j then CAN_115_degree i else - W i j.

  (* A := L_R + Gamma (diagonal repair-rate addition). *)
  Definition CAN_115_A (i j : nat) : Q :=
    CAN_115_L_R i j + (if Nat.eqb i j then Gamma i else 0).

  (* s[n+1] = s[n] + dt(-A s[n] + J), one coordinate i at a time, the row
     i of [A] applied to [s] as a finite sum over [verts]. *)
  Definition CAN_115_step (s : nat -> Q) (i : nat) : Q :=
    s i + dt * ( - (fold_right Qplus 0 (map (fun j => CAN_115_A i j * s j) verts))
                 + J i ).

End CAN_115_SocialLRStepper.

(* Witness (tier: Th_coqc): PAR-stepper is not definitionally idle — a
   concrete, self-contained finite model (one node, zero coupling and
   zero dissipation, unit time step, non-zero load 1): the stepper moves
   the state by exactly the load, exactly the [../coq/MR_Foundation.v]
   eq.(8)/[MRC_root_spine.v] [CAN_003_stepper_can_move_state] technique
   specialised to this stepper's own shape. *)
Remark CAN_115_par_stepper_moves_state :
  CAN_115_step [0%nat] (fun _ _ => 0) (fun _ => 0) (fun _ => 1) 1
               (fun _ => 0) 0%nat <> 0.
Proof.
  unfold CAN_115_step, CAN_115_A, CAN_115_L_R, CAN_115_degree.
  vm_compute. discriminate.
Qed.

(* L1 (invariance/recurrence), L2 (the bill), L3 (operator change), L4
   (mutation) — the paper's own theorems (record 22361830 / 18383439),
   NOT independently machine-checked here. Typed as abstract, Section-
   discharged [Prop]-valued objects and deliberately left un-proved — tier:
   Open, per the house rule "never upgrade (Open -> Prop, no proof)". *)
Section CAN_115_L1_L4_Open.

  Variables verts' : list nat.
  Variable W' Gamma' : nat -> Q.
  Variable J' : nat -> Q.
  Variable dt' : Q.
  Variable s_star : nat -> Q.          (* the fixed point s* = A^{-1} J, left abstract *)
  Variable intervention : (nat -> Q) -> nat -> (nat -> Q).  (* bounded, amplitude-only, ticks-held *)

  (* L1: a bounded amplitude-only intervention cannot move the fixed point,
     and the state returns above threshold after a finite number of ticks
     once the intervention ends. *)
  Variable CAN_115_L1_invariance_recurrence : Prop.

  (* L2: holding the state at threshold requires a non-vanishing per-tick
     force, cost growing linearly in time held. *)
  Variable CAN_115_L2_the_bill : Prop.

  (* L3: raising dissipation gamma_i (operator-level, not amplitude
     suppression) can push the fixed point permanently below threshold at
     zero ongoing force. *)
  Variable CAN_115_L3_operator_change : Prop.

  (* L4: suppressing one node under permanent resets produces a strictly
     positive long-run floor in a coupled neighbour node. *)
  Variable CAN_115_L4_mutation : Prop.

End CAN_115_L1_L4_Open.

(* ==================================================================== *)
(** ** CAN-116 — B-SOC-ETHAXIOM

    (* CAN-116 — root: M(t') in M; A_i(t') subseteq M(t'); G(t'):={A_1,...,A_N} subseteq M(t') — domain: social — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "axiom" (CE-01..CE-04). Discrete replacement: a
    "manifested record" is a finite, append-only [list Event] (the same
    readout-first shape as [MRC_root_spine.v]'s [CAN_009_extends]); an
    "agency" A_i is a sub-structure of that record, typed as list
    inclusion ([incl]), never an opaque abstract subset relation on an
    unstructured carrier; a "collective" is a finite [list] of such
    agencies. CANONICAL.json's own "axiom" tier is typed here, per the
    house style, as [Definition] (a locked domain-typing discipline) with
    a Th_coqc witness that the typing is genuinely satisfiable and
    non-trivial (a proper, non-empty sub-record actually exists). *)

Section CAN_116_EthAxiom.

  Variable Event : Type.

  (* Axiom I: Reality-as-Record — M(t') is (typed as) a finite record. *)
  Definition CAN_116_ManifestedRecord : Type := list Event.

  (* Axiom II: Agency-as-Choice — A_i(t') subseteq M(t'). *)
  Definition CAN_116_is_agency (A M : CAN_116_ManifestedRecord) : Prop :=
    incl A M.

  (* Axiom IV: Collective as Coupled Agencies — G(t') := {A_1,...,A_N}
     subseteq M(t'); a collective is a finite list of agencies, each
     itself included in the shared record. *)
  Definition CAN_116_is_collective
             (G : list CAN_116_ManifestedRecord) (M : CAN_116_ManifestedRecord) : Prop :=
    Forall (fun A => CAN_116_is_agency A M) G.

  (* Witness (tier: Th_coqc): the axioms are jointly satisfiable by a
     genuinely non-trivial finite instance — a two-agency collective
     properly included in a three-event record, on any [Event] carrier
     with two distinguishable events. *)
  Theorem CAN_116_axioms_satisfiable :
    forall e1 e2 : Event, e1 <> e2 ->
      exists (M : CAN_116_ManifestedRecord) (A1 A2 : CAN_116_ManifestedRecord),
        CAN_116_is_agency A1 M /\ CAN_116_is_agency A2 M /\
        CAN_116_is_collective [A1; A2] M /\ A1 <> A2.
  Proof.
    intros e1 e2 Hne.
    exists [e1; e2], [e1], [e2].
    assert (Hin1 : CAN_116_is_agency [e1] [e1; e2]).
    { intros x Hx. simpl in Hx. destruct Hx as [<- | []]. simpl. left. reflexivity. }
    assert (Hin2 : CAN_116_is_agency [e2] [e1; e2]).
    { intros x Hx. simpl in Hx. destruct Hx as [<- | []]. simpl. right. left. reflexivity. }
    repeat split.
    - exact Hin1.
    - exact Hin2.
    - apply Forall_cons; [exact Hin1 | apply Forall_cons; [exact Hin2 | apply Forall_nil]].
    - intro Hc. injection Hc as Hc. congruence.
  Qed.

End CAN_116_EthAxiom.

(* ==================================================================== *)
(** ** CAN-117 — B-SOC-REGIME

    (* CAN-117 — root: R:=(T_R,I_R); M(t'+dt')=T_R(M(t')); A(t'+dt')subseteq I_R(A(t'),M(t')) — domain: social — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "axiom (CE-05); law/update-law (CE-06, CE-07);
    definition (CE-08, the 'etic' minimal layer)". Reads CAN-003
    (root-stepper): M(t'+Δt')=T_R(M(t')) is a direct q_social instance of
    S_{n+1}=F(S_n,...) — formalised fresh here (not re-derived from
    [MRC_root_spine.CAN_003_F]), on the [CAN_116_ManifestedRecord]/
    [CAN_116_is_agency] carriers just typed above, since the ethics-domain
    admissibility clause (Etic) needs those specific typed objects. *)

Section CAN_117_Regime.

  Variable Event : Type.

  Definition CAN_117_Record := CAN_116_ManifestedRecord Event.

  Record CAN_117_Regime : Type := mkRegime
    { reg_T_R : CAN_117_Record -> CAN_117_Record                    (* translation operator: updates M *)
    ; reg_I_R : CAN_117_Record -> CAN_117_Record -> CAN_117_Record  (* interaction operator: updates A given M *)
    }.

  (* CE-06/CE-07 (update laws), typed as the two defining equations a
     regime's data must satisfy at one tick. *)
  Definition CAN_117_record_updates (R : CAN_117_Regime) (M M' : CAN_117_Record) : Prop :=
    M' = reg_T_R R M.

  Definition CAN_117_agency_updates (R : CAN_117_Regime) (A M A' : CAN_117_Record) : Prop :=
    incl A' (reg_I_R R A M).

  (* CE-08: Etic(A;t') — the minimal admissibility layer: some admissible
     regime exists under which A is a genuine agency in M and both update
     laws hold for one tick. [R_adm] is the declared admissible-regime set
     (a finite list, never an unbounded comprehension). *)
  Definition CAN_117_Etic
             (R_adm : list CAN_117_Regime) (A M M' A' : CAN_117_Record) : Prop :=
    exists R : CAN_117_Regime,
      In R R_adm
      /\ CAN_116_is_agency A M
      /\ CAN_117_record_updates R M M'
      /\ CAN_117_agency_updates R A M A'.

  (* Witness (tier: Th_coqc): Etic is satisfiable by the identity regime
     (T_R and I_R both act as the identity on the record component), on a
     one-event finite model — the minimal admissibility layer is not
     vacuous. *)
  Theorem CAN_117_etic_satisfiable :
    forall e : Event,
      exists (R_adm : list CAN_117_Regime) (A M M' A' : CAN_117_Record),
        CAN_117_Etic R_adm A M M' A'.
  Proof.
    intro e.
    pose (R0 := mkRegime (fun M => M) (fun A M => M)).
    exists [R0], [e], [e], [e], [e], R0.
    assert (H1 : In R0 [R0]) by (left; reflexivity).
    assert (H2 : CAN_116_is_agency [e] [e]) by (intros x Hx; exact Hx).
    assert (H3 : CAN_117_record_updates R0 [e] [e]) by reflexivity.
    assert (H4 : CAN_117_agency_updates R0 [e] [e] [e]) by (intros x Hx; exact Hx).
    exact (conj H1 (conj H2 (conj H3 H4))).
  Qed.

End CAN_117_Regime.

(* ==================================================================== *)
(** ** CAN-118 — B-SOC-ETHLOAD

    (* CAN-118 — root: Ethical(A) iff dV/dt<=0 and tau_c'(R)>0 and Delta_spec(R)>0 — domain: social — tier: Definition — occurrences: 6 *)

    CANONICAL.json tier: "definition (author-labelled 'final'/locked)".
    Reads Genesis's forced root axiom E00.5 (tau_c > 0, causal memory) as
    an ethics admissibility clause. Discrete replacement: "d/dt' V <= 0"
    becomes per-tick non-increase of a [nat -> Q] ledger sequence — never
    a continuum derivative. *)

Section CAN_118_EthLoad.

  Variable V : nat -> Q.       (* ethical-load ledger, one value per tick *)
  Variable tau_c : Q.          (* causal-memory admissibility parameter *)
  Variable Delta_spec : Q.     (* spectral-stability margin *)

  Definition CAN_118_non_increasing : Prop :=
    forall n : nat, V (S n) <= V n.

  Definition CAN_118_Ethical : Prop :=
    CAN_118_non_increasing /\ tau_c > 0 /\ Delta_spec > 0.

  (* Witness (tier: Th_coqc): satisfiable by the trivially-flat ledger
     V=0, with both admissibility parameters positive — the locked
     definition is not vacuous. *)
  Theorem CAN_118_ethical_satisfiable :
    exists (V' : nat -> Q) (tau_c' Delta_spec' : Q),
      (forall n, V' (S n) <= V' n) /\ tau_c' > 0 /\ Delta_spec' > 0.
  Proof.
    exists (fun _ => 0), 1, 1.
    split; [| split].
    - intro n. apply Qle_refl.
    - lra.
    - lra.
  Qed.

End CAN_118_EthLoad.

(* ==================================================================== *)
(** ** CAN-119 — B-SOC-COLCONF

    (* CAN-119 — root: Eth_col(G) iff dV_G/dt<=0 and min_i Delta_spec(R_i)>0 — domain: social — tier: Definition — occurrences: 11 *)

    CANONICAL.json tier: "definition". Discrete replacement: "min_i" over
    a (finite) family of agents is [fold_right Qmin] over a declared
    finite [list Q] of per-agent margins — never an unbounded infimum. *)

Section CAN_119_ColConf.

  Variable V_G : nat -> Q.               (* collective ethical-load ledger *)
  Variable individual_margins : list Q.  (* {Delta_spec(R_i)}_i, finite, declared *)
  Variable V_indiv : nat -> Q.           (* one representative individual ledger, for Conf *)

  Definition CAN_119_min_margin : Q :=
    match individual_margins with
    | nil => 0
    | x :: xs => fold_right Qmin x xs
    end.

  Definition CAN_119_Eth_col : Prop :=
    (forall n, V_G (S n) <= V_G n) /\ CAN_119_min_margin > 0.

  Definition CAN_119_Conf_ind_to_col : Prop :=
    (forall n, V_indiv (S n) <= V_indiv n) /\ ~ (forall n, V_G (S n) <= V_G n).

  Definition CAN_119_Conf_col_to_ind : Prop :=
    (forall n, V_G (S n) <= V_G n) /\ ~ (forall n, V_indiv (S n) <= V_indiv n).

  (* Structural injustice: two agents whose costs are grossly asymmetric —
     ">>" discretely replaced by "strictly greater by at least a declared
     margin [eps] > 0", never an informal "much greater than". *)
  Definition CAN_119_structural_injustice (C : nat -> Q) (eps : Q) (i j : nat) : Prop :=
    eps > 0 /\ C i - C j > eps.

  (* Witness (tier: Th_coqc): structural injustice is a satisfiable,
     non-vacuous relation — a concrete two-agent finite model with a
     genuine cost gap exceeding a positive declared margin. *)
  Theorem CAN_119_structural_injustice_satisfiable :
    exists (C : nat -> Q) (eps : Q) (i j : nat), CAN_119_structural_injustice C eps i j.
  Proof.
    exists (fun k => if Nat.eqb k 0 then 10 else 0), 1, 0%nat, 1%nat.
    unfold CAN_119_structural_injustice. simpl. split; lra.
  Qed.

End CAN_119_ColConf.

(* ==================================================================== *)
(** ** CAN-120 — B-SOC-MORALCOST

    (* CAN-120 — root: C_{A,R}[t1,t2]:=sum(alpha*Vplus+beta*chi_causal+gamma*chi_spec); choice-gate; Tragic — domain: social — tier: Definition — occurrences: 12 *)

    CANONICAL.json tier: "definition (...); theorem [paper-internal, not
    Coq-verified] (CE-32)". Discrete replacement: the moral-cost integral
    over $[t_1,t_2]$ becomes a finite [fold_right Qplus] over
    [List.seq t1 (t2-t1)] — a genuinely finite sum, never a continuum
    integral. The Cost-Survival Link (CE-32, an infinite-limit theorem) is
    the paper's own result, not independently machine-checked here, so it
    is typed as an abstract Open [Prop] and left un-proved. *)

Section CAN_120_MoralCost.

  Variable Vplus : nat -> Q.       (* per-tick worsening-load indicator, >= 0 *)
  Variable chi_causal chi_spec : Q. (* per-regime causal-memory / spectral violation indicators *)
  Variable alpha beta gamma : Q.
  Hypothesis Halpha : alpha > 0.
  Hypothesis Hbeta  : beta  > 0.
  Hypothesis Hgamma : gamma > 0.

  Definition CAN_120_moral_cost (t1 t2 : nat) : Q :=
    fold_right Qplus 0
      (map (fun _ => alpha * Vplus t1 + beta * chi_causal + gamma * chi_spec)
           (List.seq t1 (t2 - t1))).

  Definition CAN_120_Responsibility (t1 t2 : nat) : Q := CAN_120_moral_cost t1 t2.

  (* Choice-gate: with no instantiated choice of regime, no ethics,
     responsibility, or cost may be attributed at all. *)
  Definition CAN_120_choice_gate (has_choice : bool) (t1 t2 : nat) (attributed_cost : Q) : Prop :=
    has_choice = false -> attributed_cost = 0.

  (* Witness (tier: Th_coqc): the choice-gate is satisfiable both ways —
     an instance where it correctly fires (no choice, zero cost) and an
     instance where a genuine choice permits a non-zero attributed cost. *)
  Theorem CAN_120_choice_gate_satisfiable :
    CAN_120_choice_gate false 0%nat 0%nat 0
    /\ exists (has_choice : bool) (t1 t2 : nat) (c : Q),
         has_choice = true /\ c = 5 /\ CAN_120_choice_gate has_choice t1 t2 c.
  Proof.
    split.
    - unfold CAN_120_choice_gate. intro H. reflexivity.
    - exists true, 0%nat, 1%nat, 5. repeat split. unfold CAN_120_choice_gate. discriminate.
  Qed.

  (* Tragic regime class: every regime in a declared finite list is either
     inadmissible or incurs strictly positive unavoidable cost. *)
  Definition CAN_120_Tragic
             (regimes : list nat) (admissible : nat -> bool) (cost : nat -> Q) : Prop :=
    Forall (fun r => admissible r = false \/ cost r > 0) regimes.

  (* Witness (tier: Th_coqc): Tragic is satisfiable on a finite two-regime
     model, one inadmissible and one admissible-but-costly. *)
  Theorem CAN_120_tragic_satisfiable :
    exists (regimes : list nat) (admissible : nat -> bool) (cost : nat -> Q),
      CAN_120_Tragic regimes admissible cost.
  Proof.
    exists [0%nat; 1%nat],
           (fun r => if Nat.eqb r 0%nat then false else true),
           (fun r => if Nat.eqb r 0%nat then 0 else 3).
    unfold CAN_120_Tragic.
    apply Forall_cons.
    - left. reflexivity.
    - apply Forall_cons; [right; simpl; lra | apply Forall_nil].
  Qed.

  (* CE-32, Cost-Survival Link: lim_{T->infty} C=infty implies
     lim_{n->infty} ||P_{S_A} M(t'+n)||^2 = 0 — a paper-internal theorem
     about a continuum/infinite limit, NOT independently machine-checked
     here (and not restated on [Q]/[nat] since a faithful discrete
     restatement would require an unbounded-limit apparatus this file
     does not build). Typed as an abstract, Section-discharged [Prop] and
     deliberately left un-proved — tier: Open. *)
  Variable CAN_120_cost_survival_link : Prop.

End CAN_120_MoralCost.

(* ==================================================================== *)
(** ** CAN-121 — B-SOC-AGENCYHIER

    (* CAN-121 — root: x'=F(x,C); C_{t+1}=G(x_t,C_t,...); L5: G_{t+1}=M(G_t) — domain: social — tier: Definition — occurrences: 10 *)

    CANONICAL.json tier: "definition". Five successively higher orders of
    the SAME generator-family, read at increasing informational scope, up
    to L5 applying a stepper to the stepper's own generating rule
    (q_D∘F, one level up) — a textbook confirmation of "one equation, read
    at different orders, is a reading not a new equation" (per the
    founder rule already invoked in [MRC_root_spine.v]'s CAN-003 header). *)

Section CAN_121_AgencyHierarchy.

  Variables X C H : Type.
  Variable F : X -> C -> X.

  (* Level 0/1 (Proto-Agency): the constraint update does not depend on
     the state at all — "partial C / partial x = 0" discretely replaced
     as: the update function ignores its state argument. *)
  Definition CAN_121_ProtoAgency (G : X -> C -> C) : Prop :=
    forall (x1 x2 : X) (c : C), G x1 c = G x2 c.

  (* Level 2 (Agency-Condition, necessary not sufficient): the update
     function genuinely does depend on the state — "partial C/partial x
     <> 0" discretely replaced as: some state pair changes the update. *)
  Definition CAN_121_StateConstraintCoupling (G : X -> C -> C) : Prop :=
    exists (x1 x2 : X) (c : C), G x1 c <> G x2 c.

  (* Level 3: history-dependent constraint update, C_{t+1}=G(x_t,C_t,H_t). *)
  Definition CAN_121_L3_history (G3 : X -> C -> H -> C) : Type := X -> C -> H -> C.

  (* Level 4: predictive constraint update using a forecast state,
     C_{t+1}=G(x_t,C_t,x_hat_{t+k}). *)
  Definition CAN_121_L4_predictive (G4 : X -> C -> X -> C) : Type := X -> C -> X -> C.

  (* Level 5 (meta-regulation): the system revises its own generating
     rule, G_{t+1}=M(G_t) — a second-order stepper acting on the Level-2
     rule itself, never re-defining Level 2's [G] in place. *)
  Definition CAN_121_L5_meta (M : (X -> C -> C) -> (X -> C -> C)) : Type :=
    (X -> C -> C) -> (X -> C -> C).

End CAN_121_AgencyHierarchy.

(* Witness (tier: Th_coqc): the hierarchy is non-vacuous at every level on
   a small finite model ([X:=bool], [C:=bool]) — Proto-Agency, genuine
   State-Constraint-Coupling, and a genuine Level-5 meta-update (M flips
   the rule's output) are all simultaneously exhibitable, no level
   collapsing into another. Stated OUTSIDE [CAN_121_AgencyHierarchy] so
   its own [X]/[C] are the concrete witness types, never the section's
   abstract ones. *)
  Theorem CAN_121_hierarchy_levels_satisfiable :
    exists (G_proto G_coupled : bool -> bool -> bool) (M5 : (bool -> bool -> bool) -> (bool -> bool -> bool)),
      CAN_121_ProtoAgency G_proto
      /\ CAN_121_StateConstraintCoupling G_coupled
      /\ (forall x : bool, M5 G_coupled x x = negb (G_coupled x x)) (* a genuine, non-identity meta-update *)
      /\ (exists x : bool, M5 G_coupled x x <> G_coupled x x).
  Proof.
    exists (fun _ c => c), (fun x _ => x), (fun G x y => negb (G x y)).
    split; [| split; [| split]].
    - intros x1 x2 c. reflexivity.
    - exists true, false, true. simpl. discriminate.
    - intro x. reflexivity.
    - exists true. simpl. discriminate.
  Qed.

(* ==================================================================== *)
(** ** CAN-122 — belief-relation

    (* CAN-122 — root: Bel_{i,p,n}=Rel_B(a_i,p|...); b_{i,p,n}=(e,c,s,a,eta,g,r) — domain: social — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition / proposition (with proof)".
    root_object: none (a downstream social construct, not one of the
    eight named Genesis root objects). The "Belief-scale nonpromotion"
    proposition (increasing distribution scale does not by itself raise
    epistemic status sigma_K) is typed here as a genuine, machine-checked
    Th_coqc witness: an epistemic-status function that structurally
    ignores its scale argument is a satisfiable instance of the claim. *)

Section CAN_122_BeliefRelation.

  Variables Agent Prop_ Context BeliefFactors : Type.

  (* Canonical belief vector: the seven [Q]-valued components
     (e,c,s,a,eta,g,r) — evidence-weight, confidence, salience, affect,
     effort/heta, group-alignment, resonance — typed as a record, never
     an untyped tuple. *)
  Record CAN_122_BeliefVector : Type := mkBeliefVector
    { bv_e : Q ; bv_c : Q ; bv_s : Q ; bv_a : Q ; bv_eta : Q ; bv_g : Q ; bv_r : Q }.

  Variable Rel_B : Agent -> Prop_ -> Context -> CAN_122_BeliefVector.
  Variable U_B   : CAN_122_BeliefVector -> CAN_122_BeliefVector.   (* per-tick update *)
  Variable Stabilize_B : list CAN_122_BeliefVector -> CAN_122_BeliefVector.  (* group stabilisation *)

  Definition CAN_122_Bel := Rel_B.
  Definition CAN_122_update := U_B.
  Definition CAN_122_group_belief := Stabilize_B.

  (* Belief-scale nonpromotion (Prop-1): an epistemic-status function that
     depends only on the structural factors (independence, defects,
     calibration, objection channels) and NOT on the distribution scale —
     witnessed by exhibiting one such function and proving, directly from
     its definition, that varying the scale argument alone never changes
     the output. *)
  Definition CAN_122_sigma_K (factors : BeliefFactors) (g : BeliefFactors -> Q)
             (_scale : Q) : Q := g factors.

  Theorem CAN_122_belief_scale_nonpromotion :
    forall (factors : BeliefFactors) (g : BeliefFactors -> Q) (scale1 scale2 : Q),
      CAN_122_sigma_K factors g scale1 = CAN_122_sigma_K factors g scale2.
  Proof. intros. reflexivity. Qed.

End CAN_122_BeliefRelation.

(* ==================================================================== *)
(** ** CAN-123 — collective-readout

    (* CAN-123 — root: Z_G=<{Z_Ai},T_G,A_G,C_G>; m^G_{t+1}=rho m^G_t+sigma_t(e) — domain: social — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "definition". A group's retained state and
    semantic readout, without positing a group mind: the group state is
    typed as an explicit aggregate structure over a finite list of
    individual states, and its "readout" a declared function of that
    structure — never a shared internal state of its own. *)

Section CAN_123_CollectiveReadout.

  Variables IndZ TimeT AggT CouplT SemVal EventT : Type.

  Record CAN_123_GroupState : Type := mkGroupState
    { gs_individuals : list IndZ
    ; gs_time        : TimeT
    ; gs_aggregator  : AggT
    ; gs_coupling    : CouplT
    }.

  Variable q_sem_G : CAN_123_GroupState -> SemVal.

  Definition CAN_123_group_readout (Z : CAN_123_GroupState) : SemVal := q_sem_G Z.

  (* m^G_{t+1} = rho * m^G_t + sigma_t(e) — a genuinely finite [Q]-valued
     recurrence, one memory-trace update per event. *)
  Definition CAN_123_memory_update (rho m_t : Q) (sigma_t_e : Q) : Q :=
    rho * m_t + sigma_t_e.

  (* Witness (tier: Th_coqc): a sanity specialisation — with zero incoming
     signal the memory trace update is exactly the decayed prior trace,
     confirming the recurrence is genuinely the declared linear shape and
     not a silently-different update. *)
  Theorem CAN_123_memory_update_zero_signal :
    forall rho m_t : Q, CAN_123_memory_update rho m_t 0 == rho * m_t.
  Proof. intros. unfold CAN_123_memory_update. ring. Qed.

End CAN_123_CollectiveReadout.

(* ==================================================================== *)
(** ** CAN-124 — power-live-gap

    (* CAN-124 — root: L^live_{A,g}=max_{z in J_feas} D_L(L^z_A(g),L^z0_A(g)) — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "proposition". [canonical_source] prose cites
    "Master Equation River v1.4 eq.(26)" but [in_master_river] is [null]
    in CANONICAL.json itself — a registry drift disclosed in the ledger,
    not silently resolved here. Since [canonical_text] is symbol-identical
    to CAN-134's (below), this id is aliased to the same already-compiled,
    axiom-free [MR_Live.live_field_gap] rather than re-derived. *)

Definition CAN_124_power_live_gap := @MR_Live.live_field_gap.

(* ==================================================================== *)
(** ** CAN-125 — DCP-relational-route

    (* CAN-125 — root: Experience->Interpretations->Absent Perspective->Observable Evidence->Direct Human Conversation — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "definition". Where the primary source (another
    person's mind) is unavailable to AI, route back to direct human
    conversation. Discrete replacement: the five named stages are a
    five-constructor [Inductive] with an injective [nat] index — exactly
    [MRC_root_spine.v]'s [CAN_004_Stage]/[CAN_004_index] pattern — never an
    informal prose ordering. *)

Inductive CAN_125_DCPStage : Type :=
  | DCP_Experience | DCP_Interpretations | DCP_AbsentPerspective
  | DCP_ObservableEvidence | DCP_DirectHumanConversation.

Definition CAN_125_index (s : CAN_125_DCPStage) : nat :=
  match s with
  | DCP_Experience => 0 | DCP_Interpretations => 1
  | DCP_AbsentPerspective => 2 | DCP_ObservableEvidence => 3
  | DCP_DirectHumanConversation => 4
  end.

Theorem CAN_125_index_injective :
  forall s1 s2 : CAN_125_DCPStage, CAN_125_index s1 = CAN_125_index s2 -> s1 = s2.
Proof. intros [] []; simpl; try reflexivity; try discriminate. Qed.

Theorem CAN_125_route_is_strictly_ordered :
  (CAN_125_index DCP_Experience < CAN_125_index DCP_Interpretations)%nat /\
  (CAN_125_index DCP_Interpretations < CAN_125_index DCP_AbsentPerspective)%nat /\
  (CAN_125_index DCP_AbsentPerspective < CAN_125_index DCP_ObservableEvidence)%nat /\
  (CAN_125_index DCP_ObservableEvidence < CAN_125_index DCP_DirectHumanConversation)%nat.
Proof. simpl. repeat split; lia. Qed.

(* ==================================================================== *)
(** ** CAN-126 — OLW-falsifier

    (* CAN-126 — root: no H_org,n+1<>H_org,n attributable to the processing — domain: social — tier: Open — occurrences: 1 *)

    CANONICAL.json tier: "hypothesis/Open". If no traceable residue
    appears in later organisational readout/policy/practice, the claimed
    retention event reduces to ordinary information throughput. Typed as
    a [Prop]-valued [Definition] over an abstract organisational-state
    trajectory and an abstract attributability predicate, and
    deliberately left un-proved — tier: Open. *)

Section CAN_126_OLWFalsifier.

  Variable OrgState : Type.
  Variable H_org : nat -> OrgState.
  Variable attributable_to_processing : nat -> Prop.

  Definition CAN_126_falsifier_condition : Prop :=
    forall n : nat, attributable_to_processing n -> H_org (S n) <> H_org n.

End CAN_126_OLWFalsifier.

(* ==================================================================== *)
(** ** CAN-127 — OLW-propositions

    (* CAN-127 — root: P1..P8 [Open] — domain: social — tier: Open — occurrences: 8 *)

    CANONICAL.json tier: "hypothesis/Open". Eight organisation-scale
    hypotheses (connectivity quality, activation clarity, reconfiguration
    cadence, reviewer diversity, over-reliance, minimization trade-off,
    dissent protocols, SECI complementarity), kept as one enumerated
    cluster per the collapse instruction rather than eight singletons.
    Each is typed as an abstract Section-discharged [Prop]-valued
    predicate over the enumeration — never asserted true or false. *)

Inductive CAN_127_OLWProposition : Type :=
  OLW_P1 | OLW_P2 | OLW_P3 | OLW_P4 | OLW_P5 | OLW_P6 | OLW_P7 | OLW_P8.

Section CAN_127_OLWPropositions.
  Variable CAN_127_holds : CAN_127_OLWProposition -> Prop.
End CAN_127_OLWPropositions.

(* ==================================================================== *)
(** ** CAN-128 — B-SOC-LIVEPOSS

    (* CAN-128 — root: Pi^live subseteq Pi^feas subseteq Pi^phys; possible<>feasible<>live<>chosen<>enacted<>observed — domain: social — tier: Th_coqc — occurrences: 7 *)

    CANONICAL.json tier: "definition". [in_master_river]: eq.(19)-(24),
    already formalised, axiom-free, in [../coq/MR_Live.v]
    ([Section LivePossibility]/[Section EnactmentObservation]). Discharged
    here by aliasing, never redefining. *)

Definition CAN_128_Pi_live := @MR_Live.Pi_live.
Definition CAN_128_live_field := @MR_Live.live_field.
Definition CAN_128_is_valid_choice := @MR_Live.is_valid_choice.
Definition CAN_128_live_full_nesting := @MR_Live.eq19_full_nesting.
Definition CAN_128_enactment_may_differ_from_choice := @MR_Live.eq23_enactment_may_differ_from_choice.
Definition CAN_128_observation_loses_information := @MR_Live.eq23_observation_loses_information.
Definition CAN_128_six_level_non_collapse := @MR_Live.eq24_stage_chain_non_collapse.

(* ==================================================================== *)
(** ** CAN-129 — B-SOC-NCLIST

    (* CAN-129 — root: 17-item non-collapse role-separation list — domain: social — tier: Th_coqc — occurrences: 3 *)

    CANONICAL.json tier: "definition". The fullest, most general
    non-collapse statement in this group's corpus, restated as a
    17-constructor [Inductive] with an injective [nat] index — the same
    [MRC_root_spine.v] [CAN_004_Stage]/[CAN_004_index] pattern, scaled up:
    injectivity of the index is the single witnessed fact that makes "17
    named things, none collapsing into another" a checked claim rather
    than an assertion. *)

Inductive CAN_129_NCItem : Type :=
  | NC_ObjPossVsFeas | NC_FeasVsLive | NC_LiveVsStatedPref
  | NC_StatedPrefVsFreeConsent | NC_ChoiceVsEnactment | NC_EnactmentVsEvalVisible
  | NC_OptionCountVsEffectiveAgency | NC_AccessibilityVsWarrant
  | NC_ResonanceVsConsent | NC_RepetitionVsLegitimacy | NC_RetentionVsImprovement
  | NC_NormConformityVsAbsenceOfAgency | NC_ResistanceVsAgency
  | NC_MeaningShapingVsDomination | NC_LiveNarrowingVsStructuralViolence
  | NC_AIInfluenceVsManipulation | NC_CoupledPerformanceVsHumanReturn.

Definition CAN_129_index (i : CAN_129_NCItem) : nat :=
  match i with
  | NC_ObjPossVsFeas => 0 | NC_FeasVsLive => 1 | NC_LiveVsStatedPref => 2
  | NC_StatedPrefVsFreeConsent => 3 | NC_ChoiceVsEnactment => 4
  | NC_EnactmentVsEvalVisible => 5 | NC_OptionCountVsEffectiveAgency => 6
  | NC_AccessibilityVsWarrant => 7 | NC_ResonanceVsConsent => 8
  | NC_RepetitionVsLegitimacy => 9 | NC_RetentionVsImprovement => 10
  | NC_NormConformityVsAbsenceOfAgency => 11 | NC_ResistanceVsAgency => 12
  | NC_MeaningShapingVsDomination => 13 | NC_LiveNarrowingVsStructuralViolence => 14
  | NC_AIInfluenceVsManipulation => 15 | NC_CoupledPerformanceVsHumanReturn => 16
  end.

Theorem CAN_129_index_injective :
  forall i1 i2 : CAN_129_NCItem, CAN_129_index i1 = CAN_129_index i2 -> i1 = i2.
Proof. intros [] []; simpl; try reflexivity; try discriminate. Qed.

(* ==================================================================== *)
(** ** CAN-130 — B-SOC-MEANPROP

    (* CAN-130 — root: P1..P5 meaning-shaped practical possibility — domain: social — tier: Open — occurrences: 5 *)

    CANONICAL.json tier: "proposition". Prose propositions, not formal
    equations, tagged readout R only loosely (per CANONICAL.json's own
    note). Typed as an abstract enumeration with an abstract,
    Section-discharged holds-predicate, exactly as CAN-127 above, and
    deliberately left un-proved — tier: Open. *)

Inductive CAN_130_MeanPropItem : Type := MP_P1 | MP_P2 | MP_P3 | MP_P4 | MP_P5.

Section CAN_130_MeaningProps.
  Variable CAN_130_holds : CAN_130_MeanPropItem -> Prop.
End CAN_130_MeaningProps.

(* ==================================================================== *)
(** ** CAN-131 — B-SOC-LIVEHYP

    (* CAN-131 — root: H1..H8 live-field empirical programme — domain: social — tier: Open — occurrences: 8 *)

    CANONICAL.json tier: "hypothesis/Open". Eight falsifiable hypotheses
    testing whether the live-field model has incremental empirical value;
    kept as one cluster (an empirical programme, not a single object).
    Typed exactly as CAN-127/CAN-130 above and deliberately left
    un-proved — tier: Open. *)

Inductive CAN_131_LiveHyp : Type :=
  LH_H1 | LH_H2 | LH_H3 | LH_H4 | LH_H5 | LH_H6 | LH_H7 | LH_H8.

Section CAN_131_LiveHypotheses.
  Variable CAN_131_holds : CAN_131_LiveHyp -> Prop.
End CAN_131_LiveHypotheses.

(* ==================================================================== *)
(** ** CAN-132 — B-SOC-POTENTIAL

    (* CAN-132 — root: p*_{A,g}(h,z;T,B,P)=max_{pi in Pi^wit} Pr^pi_P(...) — domain: social — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition". [in_master_river]: eq.(25), already
    formalised, axiom-free, in [../coq/MR_Live.v]
    ([Section PotentialEnvelope], [p_star]/[p_star_upper_bound]).
    Discharged here by aliasing. *)

Definition CAN_132_p_star := @MR_Live.p_star.
Definition CAN_132_p_star_upper_bound := @MR_Live.p_star_upper_bound.

(* ==================================================================== *)
(** ** CAN-133 — B-SOC-RECOVENV

    (* CAN-133 — root: p*(2):=max_z p*(h,z); L^recoverable=max_z A^corr(h,z)-A^corr(h,z0) — domain: social — tier: Th_coqc — occurrences: 2 *)

    CANONICAL.json tier: "definition". Not itself a Master River eq
    ([in_master_river: null]) — freshly formalised, in the same finite-max
    shape as [MR_Live.p_star]/[live_field_gap]: the layer-2 potential is
    a [fold_right Qmax] over a declared finite list of feasible structural
    conditions [J_feas], and the recoverable-envelope gap is proved
    non-negative whenever the baseline condition [z0] is itself feasible —
    a genuine Th_coqc fact, by the same [Qmax] upper-bound technique
    [MR_Live.p_star_upper_bound] uses. *)

Section CAN_133_RecoverableEnvelope.

  Variables Cond : Type.
  Variable A_corr : Cond -> Q.
  Variable J_feas : list Cond.

  Definition CAN_133_p_star2 (p_of : Cond -> Q) : Q :=
    fold_right Qmax 0 (map p_of J_feas).

  Definition CAN_133_recoverable_gap (z0 : Cond) : Q :=
    (fold_right Qmax 0 (map A_corr J_feas)) - A_corr z0.

  (* Th_coqc: the recoverable gap is non-negative whenever the baseline
     [z0] is itself among the declared feasible conditions — a max over a
     list containing [A_corr z0] cannot fall below [A_corr z0]. *)
  Theorem CAN_133_recoverable_gap_nonneg :
    forall z0 : Cond, In z0 J_feas -> 0 <= CAN_133_recoverable_gap z0.
  Proof.
    intros z0 Hin.
    unfold CAN_133_recoverable_gap.
    assert (Hle : A_corr z0 <= fold_right Qmax 0 (map A_corr J_feas)).
    { revert Hin. induction J_feas as [| c cs IH]; simpl; intros Hin.
      - contradiction.
      - destruct Hin as [-> | Hin'].
        + apply Q.le_max_l.
        + apply Qle_trans with (y := fold_right Qmax 0 (map A_corr cs)).
          * apply IH. exact Hin'.
          * apply Q.le_max_r. }
    apply Qle_minus_iff in Hle.
    (* Qle_minus_iff : x <= y <-> 0 <= y - x, in the shape we need directly. *)
    exact Hle.
  Qed.

End CAN_133_RecoverableEnvelope.

(* ==================================================================== *)
(** ** CAN-134 — B-SOC-RECOVLIVE

    (* CAN-134 — root: L^live_{A,g}=max_{z in J_feas} D_L(L^z_A(g),L^z0_A(g)) — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "definition". [in_master_river]: eq.(26), already
    formalised, axiom-free, in [../coq/MR_Live.v]
    ([Section PotentialEnvelope], [live_field_gap]). Discharged here by
    aliasing, plus a fresh Th_coqc non-negativity witness (distance-to-
    self is zero, so the max-gap over a list containing the baseline
    condition is never negative) — the diagnosis-only reading Master
    River's own commentary (NC-79) gives this object. *)

Definition CAN_134_live_field_gap := @MR_Live.live_field_gap.

Section CAN_134_NonNegWitness.

  Variables Cond : Type.
  Variable L_z : Cond -> Q.
  Variable D_L : Q -> Q -> Q.
  Hypothesis D_L_self_zero : forall q : Q, D_L q q == 0.
  Hypothesis D_L_nonneg : forall q1 q2 : Q, 0 <= D_L q1 q2.

  Theorem CAN_134_gap_nonneg :
    forall (z0 : Cond) (feasible_conditions : list Cond),
      0 <= CAN_134_live_field_gap L_z D_L z0 feasible_conditions.
  Proof.
    intros z0 feasible_conditions.
    unfold CAN_134_live_field_gap, MR_Live.live_field_gap.
    induction feasible_conditions as [| c cs IH]; simpl.
    - apply Qle_refl.
    - apply Qle_trans with (y := fold_right Qmax 0 (map (fun z => D_L (L_z z) (L_z z0)) cs)).
      + exact IH.
      + apply Q.le_max_r.
  Qed.

End CAN_134_NonNegWitness.

(* ==================================================================== *)
(** ** CAN-135 — B-SOC-CORRIG

    (* CAN-135 — root: Delta_spec(R_i)>0 iff channel_i=open and Rdot_i<>0 — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "definition". Uses the symbol Delta_spec also
    used, with a DIFFERENT formal meaning, in CAN-118 (B-SOC-ETHLOAD) —
    per rule 1 these are NOT merged, kept as two separate CAN identifiers
    over two separate typed objects (flagged here, not silently unified,
    matching CANONICAL.json's own note). *)

Inductive CAN_135_Channel : Type := Chan135_Open | Chan135_Closed.

Definition CAN_135_corrigible (channel : CAN_135_Channel) (repair_rate : Q) : Prop :=
  channel = Chan135_Open /\ ~ (repair_rate == 0).

(* Witness (tier: Th_coqc): the biconditional shape is satisfiable both
   ways — a genuinely corrigible instance (open channel, non-zero repair
   rate) and a genuinely non-corrigible one (closed channel). *)
Theorem CAN_135_corrigible_satisfiable :
  CAN_135_corrigible Chan135_Open 1
  /\ ~ CAN_135_corrigible Chan135_Closed 1.
Proof.
  split.
  - split. reflexivity. intro Hc. discriminate Hc.
  - intros [Hc _]. discriminate Hc.
Qed.

(* ==================================================================== *)
(** ** CAN-136 — B-SOC-PSEUDOPEACE

    (* CAN-136 — root: Y_obs=calm and p*wit=low and F=blocked — domain: social — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition; falsifiable proposition P-A tests
    it, tier hypothesis/Open". Direct social-domain instance of
    readout-not-truth: the evaluator's calm readout is explicitly not
    accepted as evidence of low compression unless the potential and
    feedback-channel readouts are checked independently. P-A (the
    falsification test) is typed as an abstract Open [Prop] and left
    un-proved. *)

Inductive CAN_136_Observation : Type := Obs136_Calm | Obs136_NotCalm.
Inductive CAN_136_ChannelStatus : Type := Chan136_Open | Chan136_Blocked.

Definition CAN_136_pseudo_peace_signature
           (obs : CAN_136_Observation) (p_wit low_threshold : Q) (chan : CAN_136_ChannelStatus) : Prop :=
  obs = Obs136_Calm /\ p_wit <= low_threshold /\ chan = Chan136_Blocked.

(* Witness (tier: Th_coqc): the signature is satisfiable by a genuine
   concrete instance — calm observation, witnessed potential at or below
   a declared low threshold, blocked feedback channel. *)
Theorem CAN_136_pseudo_peace_satisfiable :
  CAN_136_pseudo_peace_signature Obs136_Calm 0 (1#10) Chan136_Blocked.
Proof. repeat split; lra. Qed.

Section CAN_136_PA_Open.
  Variable CAN_136_P_A_falsification_test : Prop.
End CAN_136_PA_Open.

(* ==================================================================== *)
(** ** CAN-137 — B-SOC-SEVENDIST

    (* CAN-137 — root: D1..D7 seven distinctions anatomy of "potential" — domain: social — tier: Th_coqc — occurrences: 7 *)

    CANONICAL.json tier: "definition". Seven non-collapsing pairs
    dissecting the single word "potential" — the formal justification
    underlying B-SOC-POTENTIAL/B-SOC-RECOVENV/B-SOC-RECOVLIVE above —
    restated, exactly as CAN-129, as a 7-constructor [Inductive] with an
    injective [nat] index. *)

Inductive CAN_137_Distinction : Type :=
  | D1_PotentialVsExercisedVsObserved | D2_DeclaredVsWitnessedSet
  | D3_Layer1VsLayer2 | D4_TaskVsAggregatePotential
  | D5_FeasibleVsPermitted | D6_DiagnosisVsAttribution
  | D7_RecoverableGapVsAccumulatedLoss.

Definition CAN_137_index (d : CAN_137_Distinction) : nat :=
  match d with
  | D1_PotentialVsExercisedVsObserved => 0 | D2_DeclaredVsWitnessedSet => 1
  | D3_Layer1VsLayer2 => 2 | D4_TaskVsAggregatePotential => 3
  | D5_FeasibleVsPermitted => 4 | D6_DiagnosisVsAttribution => 5
  | D7_RecoverableGapVsAccumulatedLoss => 6
  end.

Theorem CAN_137_index_injective :
  forall d1 d2 : CAN_137_Distinction, CAN_137_index d1 = CAN_137_index d2 -> d1 = d2.
Proof. intros [] []; simpl; try reflexivity; try discriminate. Qed.

(* ==================================================================== *)
(** ** CAN-138 — B-SOC-FALSIF

    (* CAN-138 — root: P-B (channel shift), P-C (excluded path), P-D (layer-2 dominates) — domain: social — tier: Open — occurrences: 3 *)

    CANONICAL.json tier: "hypothesis/Open". Empirical falsification tests
    of B-SOC-POTENTIAL/B-SOC-RECOVENV/B-SOC-SEVENDIST's D3 layer
    distinction. Typed exactly as CAN-127/CAN-130/CAN-131 above and
    deliberately left un-proved — tier: Open. *)

Inductive CAN_138_Falsif : Type := PF_PB_ChannelShift | PF_PC_ExcludedPath | PF_PD_Layer2Dominates.

Section CAN_138_Falsifiers.
  Variable CAN_138_holds : CAN_138_Falsif -> Prop.
End CAN_138_Falsifiers.

(* ==================================================================== *)
(** ** CAN-139 — B-SOC-IDCERT

    (* CAN-139 — root: two models agree on Pr(complaint)=1/10, imply a five-fold difference in true potential — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "measurement". The single sharpest, most
    concrete instance in this group's corpus of readout-not-truth stated
    as a checkable numeric fact: P1 (r=d=x=9/10, f=1) gives p*_P1=729/1000;
    P2 (same r,d,x, f=1/5) gives p*_P2=729/5000; both are consistent with
    the identical observed record, yet the record alone only bounds the
    true potential to the interval [729/5000, 729/1000] — a genuinely
    finite, exactly computable [Q] fact, no [Reals] involved. *)

Theorem CAN_139_identifiability_certificate :
  ((9#10) * (9#10) * (9#10) * 1 == 729#1000)
  /\ ((9#10) * (9#10) * (9#10) * (1#5) == 729#5000)
  /\ (729#5000 <= 729#1000)
  /\ (729#5000 <> 729#1000).
Proof.
  repeat split; try lra.
  intro Hc. discriminate Hc.
Qed.
