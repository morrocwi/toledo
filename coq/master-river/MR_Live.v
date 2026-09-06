(** * MR_Live.v — Master Equation River, Block B: eq. (19)-(26)

    Source of record: research/society-justice-peace/master-river/v1_3/main.tex
    (Master Equation River v1.3), Section 3.7 "From Accessibility to the Live
    Possibility Field" (\label{sec:live1}), Section 3.8's Potential-as-a-Readout
    subsection start (\label{sec:potential1}, eq. 25), and Section "Power
    Before Choice" (\label{sec:power}, eq. 26).

    Tier source: Table 2 (\label{tab:status}) rows "Domain definitions" (live
    possibility set/profile, witnessed option set) and "Measurement
    architecture" (Potential as a Readout, recoverable gaps); the genealogy
    table row "Live -> choice -> action -> observation" naming the
    possible/feasible/live/chosen/enacted/observed non-collapse chain
    explicitly (NC-78); and the assignment task's own worked examples: the
    nesting Pi^live subseteq Pi^feas subseteq Pi^phys is proved from the
    definitions (eq. 19), and "possible <> feasible <> live <> chosen <>
    enacted <> observed" is pairwise witnessed distinctness (eq. 24).

    DISCIPLINE: readout-first, as in MR_Foundation.v/MR_Resonance.v — no
    [Reals], no classical axioms, [Q]-valued weights, finite lists model
    finite/witnessed sets, Section+Variables/Hypotheses for abstract
    objects, no top-level [Parameter]/[Axiom], no [Admitted]. The paper's
    "max over a set" (eq. 25, eq. 26) is modelled as a max over a finite
    list via the stdlib total order [Qminmax.Qmax], never a sup over an
    unbounded set.
*)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

(* ------------------------------------------------------------------ *)
(** ** Section: the live possibility field and its nesting (eq. 19-22) *)

Section LivePossibility.

  Variables Agent Goal Policy : Type.

  (** Pi^feas_{A,t}(g) and Pi^phys_t(g): finite, agent/time/goal-indexed
      policy sets, modelled as finite lists (readout-first: a finite,
      witnessed enumeration, not an unbounded set-comprehension). *)
  Variable Pi_feas : Agent -> nat -> Goal -> list Policy.
  Variable Pi_phys : nat -> Goal -> list Policy.

  (** The paper's own claim that Pi^feas is *structurally* feasible relative
      to Pi^phys: every structurally feasible policy is physically possible.
      This is the half of the eq. (19) chain that is a modelling hypothesis
      about how the two source-level sets relate (Choice Begins Before
      Choice does not derive this from anything more primitive); the other
      half (Pi^live subseteq Pi^feas) is derived below purely from the
      eq. (21) definition, with no further hypothesis needed. *)
  Hypothesis feas_subset_phys :
    forall (a : Agent) (t : nat) (g : Goal) (pi : Policy),
      In pi (Pi_feas a t g) -> In pi (Pi_phys t g).

  (* eq. (20) — tier: Definition *)
  (** L_{A,t}(g) = {(pi, lambda^live_{A,t}(pi|g)) : pi in Pi^feas_{A,t}(g)}.
      The Live Possibility Field: pair every structurally feasible policy
      with its practical accessibility weight. *)
  Variable lambda_live : Agent -> nat -> Policy -> Goal -> Q.

  Definition live_field (a : Agent) (t : nat) (g : Goal) : list (Policy * Q) :=
    map (fun pi => (pi, lambda_live a t pi g)) (Pi_feas a t g).

  (* eq. (21) — tier: Definition *)
  (** Pi^live_{A,t}(g) = {pi : lambda^live_{A,t}(pi|g) >= tau_live}.  The
      operational live set: a decidable threshold-cut filter of Pi^feas,
      using the stdlib decidable [Qle_bool] rather than a classical
      set-comprehension. *)
  Variable tau_live : Q.

  Definition live_ge_threshold (a : Agent) (t : nat) (g : Goal) (pi : Policy) : bool :=
    Qle_bool tau_live (lambda_live a t pi g).

  Definition Pi_live (a : Agent) (t : nat) (g : Goal) : list Policy :=
    filter (live_ge_threshold a t g) (Pi_feas a t g).

  (* eq. (19) — tier: Th_coqc *)
  (** Pi^live_{A,t}(g) subseteq Pi^feas_{A,t}(g) subseteq Pi^phys_t(g).
      Proved from the definitions: [Pi_live] is by construction a [filter]
      of [Pi_feas] (so membership in it entails membership in [Pi_feas], via
      the stdlib [filter_In]), and [Pi_feas subseteq Pi_phys] is exactly the
      declared hypothesis [feas_subset_phys]. Chaining the two gives the
      full nesting — no additional axiom is needed beyond the one
      structural hypothesis about how the source sets relate. *)
  Theorem eq19_live_subset_feas :
    forall (a : Agent) (t : nat) (g : Goal) (pi : Policy),
      In pi (Pi_live a t g) -> In pi (Pi_feas a t g).
  Proof.
    intros a t g pi Hin.
    unfold Pi_live in Hin.
    apply filter_In in Hin.
    destruct Hin as [Hin _].
    exact Hin.
  Qed.

  Theorem eq19_live_subset_phys :
    forall (a : Agent) (t : nat) (g : Goal) (pi : Policy),
      In pi (Pi_live a t g) -> In pi (Pi_phys t g).
  Proof.
    intros a t g pi Hin.
    apply (feas_subset_phys a t g pi).
    exact (eq19_live_subset_feas a t g pi Hin).
  Qed.

  Theorem eq19_full_nesting :
    forall (a : Agent) (t : nat) (g : Goal) (pi : Policy),
      In pi (Pi_live a t g) ->
      In pi (Pi_feas a t g) /\ In pi (Pi_phys t g).
  Proof.
    intros a t g pi Hin.
    split.
    - exact (eq19_live_subset_feas a t g pi Hin).
    - exact (eq19_live_subset_phys a t g pi Hin).
  Qed.

  (* eq. (22) — tier: Definition *)
  (** pi^choice_{A,t} in Pi^live_{A,t}(g).  Overt choice is a downstream
      object: a policy counts as a *valid* choice at (a,t,g) exactly when it
      is drawn from the live set, not from the wider feasible or physical
      sets. This types the constraint the paper states; it is not itself a
      further claim to prove. *)
  Definition is_valid_choice (a : Agent) (t : nat) (g : Goal) (pi_choice : Policy) : Prop :=
    In pi_choice (Pi_live a t g).

End LivePossibility.

(* ------------------------------------------------------------------ *)
(** ** Section: enactment, observation, and the non-collapse chain (eq. 23-24) *)

Section EnactmentObservation.

  Variables Agent Goal Policy : Type.

  (** eq. (23), part 1: "pi^act <> pi^choice possible".  We model this as:
      whichever policy was chosen, there genuinely exists another available
      policy that enactment could have followed instead — witnessed
      possibility, not necessity, given only that the policy space has at
      least two distinguishable members (a mild richness hypothesis, far
      weaker than the conclusion itself). *)
  Hypothesis policy_eq_dec : forall p1 p2 : Policy, {p1 = p2} + {p1 <> p2}.
  Hypothesis policy_has_two_distinct : exists p1 p2 : Policy, p1 <> p2.

  (* eq. (23) — tier: Th_coqc *)
  (** eq. (23) states two things: "pi^act <> pi^choice possible" (part 1,
      proved immediately below) and "Y_obs = O_q(H_{0:T}), Y_obs <>
      H_{0:T}" (part 2, proved just after [O_q] is defined) — both under
      the single Th_coqc tag given here, so the equation number is tagged
      exactly once even though it yields two Coq theorems. *)
  Theorem eq23_enactment_may_differ_from_choice :
    forall pi_choice : Policy, exists pi_act : Policy, pi_act <> pi_choice.
  Proof.
    intro pi_choice.
    destruct policy_has_two_distinct as [p1 [p2 Hneq]].
    destruct (policy_eq_dec p1 pi_choice) as [Heq1 | Hneq1].
    - exists p2. intro Hcontra. apply Hneq. congruence.
    - exists p1. exact Hneq1.
  Qed.

  (** eq. (23), part 2: "Y_obs = O_q(H_{0:T}), Y_obs <> H_{0:T})".  The
      evaluator's instrument readout [O_q] of a trajectory is, in general, a
      genuine reduction: it can send two distinct trajectories to the same
      observed record, so the observation does not determine (is not equal
      to, in the sense the paper intends) the full trajectory.  We give a
      concrete witnessed instance rather than merely hypothesising loss: a
      trajectory is a finite list of natural-number events and the
      instrument readout is a coarse summary (its length) — an honest,
      finite, readout-first stand-in for "the evaluator's instrument", not a
      claim that every real instrument is length-counting. *)
  Definition Trajectory : Type := list nat.
  Definition Obs : Type := nat.
  Definition O_q (h : Trajectory) : Obs := length h.

  (** eq. (23), part 2 continued (see the single tag above). *)
  Theorem eq23_observation_loses_information :
    exists h1 h2 : Trajectory, h1 <> h2 /\ O_q h1 = O_q h2.
  Proof.
    exists (1%nat :: nil)%list, (2%nat :: nil)%list.
    split.
    - discriminate.
    - reflexivity.
  Qed.

  (* eq. (24) — tier: Th_coqc *)
  (** "possible <> feasible <> live <> chosen <> enacted <> observed."  A
      witnessed finite model on six enumerated stages, valued injectively
      into [nat], exactly as MR_Resonance.v's eq. (11)/eq11 pattern: none of
      the six readouts collapse into one another. *)
  Inductive Stage : Type :=
    StPossible | StFeasible | StLive | StChosen | StEnacted | StObserved.

  Definition stage_value (s : Stage) : nat :=
    match s with
    | StPossible => 0
    | StFeasible => 1
    | StLive     => 2
    | StChosen   => 3
    | StEnacted  => 4
    | StObserved => 5
    end.

  Theorem stage_value_injective :
    forall s1 s2, stage_value s1 = stage_value s2 -> s1 = s2.
  Proof.
    intros [] []; simpl; try reflexivity; try discriminate.
  Qed.

  Theorem eq24_stage_chain_non_collapse :
    stage_value StPossible <> stage_value StFeasible /\
    stage_value StFeasible <> stage_value StLive /\
    stage_value StLive <> stage_value StChosen /\
    stage_value StChosen <> stage_value StEnacted /\
    stage_value StEnacted <> stage_value StObserved.
  Proof.
    unfold stage_value.
    repeat split; discriminate.
  Qed.

End EnactmentObservation.

(* ------------------------------------------------------------------ *)
(** ** Section: the potential envelope and the recoverable live-field gap
       (eq. 25-26) *)

Section PotentialEnvelope.

  Variables PolicyW EventOutcome : Type.

  (** eq. (25): p*_{A,g}(h,z;T,B,P) = max_{pi in Pi^wit_A(g;h,z,T,B)}
      Pr^pi_P(Read_g cap D_g cap X_g cap F_g).  Readout-first replacement:
      the max is taken over a finite, witnessed list of policies (never a
      sup over an unbounded feasible set — that is exactly the eq. (25)
      point, per \Cref{sec:feaswit}/eq. 43), and the compound event
      probability Pr^pi_P(Read cap D cap X cap F) is abstracted as a single
      declared [Q]-valued evaluation of the declared model [P] on a policy
      (the four intersected event conditions are exactly what the source
      paper's own declared model [P] must supply; they are not re-derived
      here). *)
  Variable Pr_event : PolicyW -> Q.

  (* eq. (25) — tier: Definition *)
  Definition p_star (witnessed_policies : list PolicyW) : Q :=
    fold_right Qmax 0 (map Pr_event witnessed_policies).

  (** Supporting fact (not itself a new equation number, scaffolding for
      eq. 25): [p_star] genuinely is an upper bound of every witnessed
      policy's probability — confirming it is a *readout of a finite
      witnessed set* (a real max, provable from [Qmax]'s stdlib properties)
      and not a silently-injected unbounded supremum. *)
  Theorem p_star_upper_bound :
    forall (witnessed_policies : list PolicyW) (pi : PolicyW),
      In pi witnessed_policies -> Pr_event pi <= p_star witnessed_policies.
  Proof.
    intro witnessed_policies.
    induction witnessed_policies as [| p rest IH]; intros pi Hin.
    - simpl in Hin. contradiction.
    - simpl in Hin. destruct Hin as [Heq | Hin'].
      + subst. unfold p_star. simpl. apply Q.le_max_l.
      + unfold p_star. simpl.
        apply Qle_trans with (y := fold_right Qmax 0 (map Pr_event rest)).
        * apply IH. exact Hin'.
        * apply Q.le_max_r.
  Qed.

  (** eq. (26): L^live_{A,g} = max_{z in J_feas} D_L(L^z_A(g), L^{z0}_A(g)).
      The recoverable live-field gap: a finite max, over a declared finite
      set of feasible structural conditions [J_feas], of a declared distance
      between the live-field summary under condition [z] and under the
      baseline condition [z0].  Both the live-field summary [L_z] and the
      distance [D_L] are left abstract (declared per study, as the paper
      states); only the finite-max *shape* of eq. (26) is fixed here. *)
  Variables Cond : Type.
  Variable L_z : Cond -> Q.
  Variable D_L : Q -> Q -> Q.

  (* eq. (26) — tier: Definition *)
  Definition live_field_gap (z0 : Cond) (feasible_conditions : list Cond) : Q :=
    fold_right Qmax 0 (map (fun z => D_L (L_z z) (L_z z0)) feasible_conditions).

End PotentialEnvelope.
