(* ===================================================================== *)
(*  PROP_FLOOD_07_flow_state.v                                            *)
(*  Flow-state classification (F1-F6) for a connected water-chain edge,   *)
(*  plus a generic "inferred" coverage-state primitive with declared      *)
(*  consistency rules (RULE-STALL-01, RULE-DIR-01).                      *)
(*  (Toledo proposal PROP-FLOOD-07.v1, code weld/M.??.v1, proposals-lane, *)
(*  not yet canonicalized -- see registry/LINEAGE.jsonl code PROP-FLOOD-07)*)
(*                                                                         *)
(*  Source: thailand_flood_kg/docs/FLOW_STALL_TYPOLOGY.md sec.8 (F1-F6    *)
(*  candidate typology, RELAYED-external-proposal, adopted here as this   *)
(*  repository's own Toledo-first derivation) plus its sec.4 inference    *)
(*  rules (RULE-STALL-01/RULE-DIR-01/RULE-COMMUNITY-01). Parents:         *)
(*  PROP-FLOOD-04 (edge head-gradient direction), PROP-FLOOD-01 (lag-k    *)
(*  trend), PROP-FLOOD-05a (control-state vocabulary, FAULT value added). *)
(*                                                                         *)
(*  This file also implements, as a GENERIC reusable primitive, the       *)
(*  "inferred" third coverage-state (alongside Present/Absent) that       *)
(*  PROP-FLOOD-06.v5's own honest_caveats explicitly deferred to a v6     *)
(*  pass -- registered HERE per this repository's Toledo-first reuse gate *)
(*  (EQUATION_SOURCE_POLICY.md TG-RFG-01: a genuinely new primitive needs *)
(*  its own lookup/Genesis-compatibility pass before derivation, not a    *)
(*  silent fold into an unrelated object's next version bump). A future   *)
(*  PROP-FLOOD-06.v6 can import `inferred_value`, `coverage3`, and the    *)
(*  two ordering facts below rather than re-deriving them.                *)
(*                                                                         *)
(*  HONEST LIMITATION (stated up front, not discovered later): the        *)
(*  general "adding inputs never un-rules a ruled-out class" claim is     *)
(*  FALSE for this classifier's two OVERRIDING rows (M=BACKFLOW forcing   *)
(*  F5; C=FAULT vetoing F1/F2) -- both can retract a previously-asserted  *)
(*  determinate class once new, contradicting information arrives. This  *)
(*  is disclosed via an explicit `Example` counterexample below, and the  *)
(*  monotonicity theorem actually proved (`flow_ruled_out_monotone`) is   *)
(*  correspondingly RESTRICTED to the fragment where the two overriding   *)
(*  conditions do not fire on either side of the comparison. Per this     *)
(*  repository's AGENTS.md ("Record counterexamples, retractions, ...     *)
(*  as first-class provenance") and per this task's own instruction to    *)
(*  weaken and say so rather than force an unprovable claim.              *)
(* ===================================================================== *)

Require Import Coq.Lists.List.
Require Import Coq.Arith.Arith.
Require Import Lia.
Require Import Coq.Bool.Bool.
Import ListNotations.

(* ------------------------------------------------------------------
   0. Evidence-strength ladder (thailand_flood_kg FLOW_STALL_TYPOLOGY.md
      sec.3): VERIFIED_LIVE(4) > VERIFIED_STALE(3) > RELAYED(2) >
      COMMUNITY(1) > INSTINCT(0). Combining several sources' strengths
      always takes the MINIMUM (weakest link), never an average.
   ------------------------------------------------------------------ *)

Inductive strength : Set :=
  | S_VERIFIED_LIVE
  | S_VERIFIED_STALE
  | S_RELAYED
  | S_COMMUNITY
  | S_INSTINCT.

Theorem strength_eq_dec : forall x y : strength, {x = y} + {x <> y}.
Proof. decide equality. Qed.

Definition strength_to_nat (s : strength) : nat :=
  match s with
  | S_VERIFIED_LIVE  => 4
  | S_VERIFIED_STALE => 3
  | S_RELAYED        => 2
  | S_COMMUNITY      => 1
  | S_INSTINCT       => 0
  end.

Definition strength_min (a b : strength) : strength :=
  if Nat.leb (strength_to_nat a) (strength_to_nat b) then a else b.

Definition strength_min3 (a b c : strength) : strength :=
  strength_min a (strength_min b c).

Theorem strength_min_is_min :
  forall a b, strength_to_nat (strength_min a b) <= strength_to_nat a /\
              strength_to_nat (strength_min a b) <= strength_to_nat b.
Proof.
  intros a b. unfold strength_min.
  destruct (Nat.leb (strength_to_nat a) (strength_to_nat b)) eqn:E.
  - apply Nat.leb_le in E. split; [apply Nat.le_refl | exact E].
  - apply Nat.leb_gt in E. split; [lia | apply Nat.le_refl].
Qed.

(* ------------------------------------------------------------------
   1. Generic "inferred" coverage-state primitive (the v6-deferred
      primitive, registered here in its own right).
   ------------------------------------------------------------------ *)

Inductive coverage3 : Set := Cov_Present | Cov_Absent | Cov_Inferred.

Theorem coverage3_eq_dec : forall x y : coverage3, {x = y} + {x <> y}.
Proof. decide equality. Qed.

(* Ordinal rank: Absent < Inferred < Present -- an inference is worth
   more than nothing, but never as much as a direct reading. *)
Definition coverage3_rank (c : coverage3) : nat :=
  match c with
  | Cov_Absent   => 0
  | Cov_Inferred => 1
  | Cov_Present  => 2
  end.

Theorem coverage3_rank_absent_lt_inferred :
  coverage3_rank Cov_Absent < coverage3_rank Cov_Inferred.
Proof. simpl. lia. Qed.

Theorem coverage3_rank_inferred_le_present :
  coverage3_rank Cov_Inferred <= coverage3_rank Cov_Present.
Proof. simpl. lia. Qed.

(* This is the reusable ordering fact a future PROP-FLOOD-06.v6 needs
   for its own "inferred -> present never lowers the tier" theorem:
   promoting Cov_Inferred to Cov_Present is always a rank increase (or
   equal), never a decrease. *)
Theorem coverage3_promote_never_lowers_rank :
  forall c1 c2 : coverage3,
    (c1 = Cov_Absent \/ c1 = c2) ->
    coverage3_rank c1 <= coverage3_rank c2.
Proof.
  intros c1 c2 [-> | ->].
  - simpl. destruct c2; simpl; lia.
  - lia.
Qed.

Record inferred_value (A : Set) := mkInferred {
  iv_state      : coverage3;
  iv_value      : option A;
  iv_confidence : option strength;
  iv_anchors    : list nat
}.

Arguments mkInferred {A} _ _ _ _.
Arguments iv_state {A} _.
Arguments iv_value {A} _.
Arguments iv_confidence {A} _.
Arguments iv_anchors {A} _.

Definition iv_wf {A : Set} (iv : inferred_value A) : Prop :=
  match iv_state iv with
  | Cov_Absent   => iv_value iv = None /\ iv_confidence iv = None /\ iv_anchors iv = nil
  | Cov_Present  => (exists v, iv_value iv = Some v) /\ iv_confidence iv <> None
  | Cov_Inferred => (exists v, iv_value iv = Some v) /\ iv_confidence iv <> None /\ iv_anchors iv <> nil
  end.

(* Resolve an inferred_value down to its plain payload for a classifier
   that only needs "what value, if any" and does not itself care
   whether it was Present or Inferred (the anchors/confidence still
   ride alongside for reporting, just not consulted by classify). *)
Definition iv_resolve {A : Set} (default_absent : A) (iv : inferred_value A) : A :=
  match iv_value iv with
  | Some v => v
  | None   => default_absent
  end.

(* ------------------------------------------------------------------
   2. RULE-STALL-01 / RULE-DIR-01 (declared consistency rules,
      INSTINCT-rule per thailand_flood_kg's own tagging -- not new
      Toledo arithmetic, only a declared way to produce an
      inferred_value from already-measured anchors).
   ------------------------------------------------------------------ *)

Inductive trend3 : Set := Tr_Rising | Tr_Falling | Tr_Stalled.

Theorem trend3_eq_dec : forall x y : trend3, {x = y} + {x <> y}.
Proof. decide equality. Qed.

(* RULE-STALL-01: far anchor persistently STALLED + zero pumps running
   + community report "not yet falling" => the whole intervening run
   is inferred STALLED. *)
Definition rule_stall_01
  (far_anchor_stalled : bool) (far_anchor_strength : strength) (far_anchor_id : nat)
  (pumps_running : nat) (pump_strength : strength) (pump_id : nat)
  (community_no_drop : bool) (community_strength : strength) (community_id : nat)
  : inferred_value trend3 :=
  if andb far_anchor_stalled (andb (Nat.eqb pumps_running 0) community_no_drop)
  then {| iv_state := Cov_Inferred;
          iv_value := Some Tr_Stalled;
          iv_confidence := Some (strength_min3 far_anchor_strength pump_strength community_strength);
          iv_anchors := far_anchor_id :: pump_id :: community_id :: nil |}
  else {| iv_state := Cov_Absent; iv_value := None; iv_confidence := None; iv_anchors := nil |}.

Theorem rule_stall_01_wf :
  forall fas fast fai pr ps pid cnd cs cid,
    iv_wf (rule_stall_01 fas fast fai pr ps pid cnd cs cid).
Proof.
  intros. unfold rule_stall_01, iv_wf.
  destruct (andb fas (andb (Nat.eqb pr 0) cnd)) eqn:E; simpl.
  - split; [now eexists | split; [discriminate | discriminate]].
  - repeat split; reflexivity.
Qed.

(* RULE-DIR-01: two bounding anchors agree in direction (both RISING or
   both FALLING) => the intervening run is inferred to move the same
   direction. Declared limitation: does not itself check for a hidden
   control structure mid-run (must be declared edge_kind=CONTROLLED and
   split first, per thailand_flood_kg's own typology doc). *)
Definition rule_dir_01
  (near_trend far_trend : trend3) (near_strength far_strength : strength)
  (near_id far_id : nat) : inferred_value trend3 :=
  match near_trend, far_trend with
  | Tr_Rising, Tr_Rising =>
      {| iv_state := Cov_Inferred; iv_value := Some Tr_Rising;
         iv_confidence := Some (strength_min near_strength far_strength);
         iv_anchors := near_id :: far_id :: nil |}
  | Tr_Falling, Tr_Falling =>
      {| iv_state := Cov_Inferred; iv_value := Some Tr_Falling;
         iv_confidence := Some (strength_min near_strength far_strength);
         iv_anchors := near_id :: far_id :: nil |}
  | _, _ =>
      {| iv_state := Cov_Absent; iv_value := None; iv_confidence := None; iv_anchors := nil |}
  end.

Theorem rule_dir_01_wf :
  forall nt ft ns fs nid fid, iv_wf (rule_dir_01 nt ft ns fs nid fid).
Proof.
  intros. unfold rule_dir_01, iv_wf.
  destruct nt, ft; simpl; try (repeat split; reflexivity).
  - split; [now eexists | split; discriminate].
  - split; [now eexists | split; discriminate].
Qed.

(* RULE-COMMUNITY-01 is NOT formalised as an inferred_value producer
   here -- it is already represented directly as the M input of the
   classifier below (a first-class, always-RELAYED input consulted by
   the decision table itself), not as a third way to produce D or T.
   See the JSON's inference_rules.RULE-COMMUNITY-01 note. *)

(* ------------------------------------------------------------------
   3. The four collapsed classifier inputs D, T, C, M.
   ------------------------------------------------------------------ *)

Inductive dh_state : Set := DH_Forward | DH_Reverse | DH_Unresolved | DH_Absent.
Inductive tr_state : Set := TR_Falling | TR_Rising | TR_Stalled | TR_Absent.
Inductive ctrl_state : Set := Ctrl_Open | Ctrl_Closed | Ctrl_Pumping | Ctrl_Fault | Ctrl_Absent.
Inductive comm_state : Set := Comm_Backflow | Comm_Rising | Comm_Steady | Comm_Falling | Comm_Absent.

Theorem dh_state_eq_dec : forall x y : dh_state, {x = y} + {x <> y}. Proof. decide equality. Qed.
Theorem tr_state_eq_dec : forall x y : tr_state, {x = y} + {x <> y}. Proof. decide equality. Qed.
Theorem ctrl_state_eq_dec : forall x y : ctrl_state, {x = y} + {x <> y}. Proof. decide equality. Qed.
Theorem comm_state_eq_dec : forall x y : comm_state, {x = y} + {x <> y}. Proof. decide equality. Qed.

Record flow_inputs := mkFlowInputs {
  fi_dh    : dh_state;
  fi_trend : tr_state;
  fi_ctrl  : ctrl_state;
  fi_comm  : comm_state
}.

Definition dh_present (d : dh_state) : bool :=
  match d with DH_Absent => false | _ => true end.
Definition tr_present (t : tr_state) : bool :=
  match t with TR_Absent => false | _ => true end.
Definition ctrl_present (c : ctrl_state) : bool :=
  match c with Ctrl_Absent => false | _ => true end.
Definition comm_present (m : comm_state) : bool :=
  match m with Comm_Absent => false | _ => true end.

Definition any_present (fi : flow_inputs) : bool :=
  orb (orb (dh_present (fi_dh fi)) (tr_present (fi_trend fi)))
      (orb (ctrl_present (fi_ctrl fi)) (comm_present (fi_comm fi))).

(* ------------------------------------------------------------------
   4. F1-F6 output type and the total classifier.
   ------------------------------------------------------------------ *)

Inductive flow_class6 : Set :=
  | F1_Free | F2_Delayed | F3_Blocked | F4_Backwater | F5_Surcharge | F6_Bounded.

Theorem flow_class6_eq_dec : forall x y : flow_class6, {x = y} + {x <> y}.
Proof. decide equality. Defined.

Inductive flow_result : Set :=
  | Refused
  | Classified (c : flow_class6) (ruled_out : list flow_class6).

Theorem flow_result_eq_dec : forall x y : flow_result, {x = y} + {x <> y}.
Proof.
  decide equality.
  - apply (list_eq_dec flow_class6_eq_dec).
  - apply flow_class6_eq_dec.
Qed.

Definition OTHERS : list flow_class6 :=
  [F1_Free; F2_Delayed; F3_Blocked; F4_Backwater; F5_Surcharge].

Definition remove_class (c : flow_class6) (l : list flow_class6) : list flow_class6 :=
  remove flow_class6_eq_dec c l.

Definition ruled_out_of (r : flow_result) : list flow_class6 :=
  match r with
  | Refused => nil
  | Classified _ ro => ro
  end.

Definition chosen_of (r : flow_result) : option flow_class6 :=
  match r with
  | Refused => None
  | Classified c _ => Some c
  end.

Definition control_is_fault (c : ctrl_state) : bool :=
  match c with Ctrl_Fault => true | _ => false end.

(* base_classify: the D/T-only decision, ignoring the two overriding
   inputs (community backflow, control fault) -- exposed separately so
   the restricted monotonicity theorem below can be stated over it. *)
Definition base_classify (d : dh_state) (t : tr_state) : flow_result :=
  match d with
  | DH_Reverse => Classified F4_Backwater (remove_class F4_Backwater OTHERS)
  | DH_Forward =>
      match t with
      | TR_Falling => Classified F1_Free (remove_class F1_Free OTHERS)
      | TR_Stalled => Classified F3_Blocked (remove_class F3_Blocked OTHERS)
      | TR_Rising  => Classified F2_Delayed (remove_class F2_Delayed OTHERS)
      | TR_Absent  => Classified F6_Bounded [F4_Backwater; F5_Surcharge]
      end
  | DH_Unresolved => Classified F6_Bounded [F4_Backwater]
  | DH_Absent => Classified F6_Bounded []
  end.

(* control_veto: rule 5 -- a faulted/unknown-state control structure
   must never license a free-flow (F1) or delayed-free (F2) claim on
   gradient/trend evidence alone. Does NOT touch F3/F4/F5/F6 -- those
   are not free-flow claims. *)
Definition control_veto (c : ctrl_state) (r : flow_result) : flow_result :=
  match r with
  | Classified F1_Free _ =>
      if control_is_fault c then Classified F6_Bounded [F1_Free; F2_Delayed] else r
  | Classified F2_Delayed _ =>
      if control_is_fault c then Classified F6_Bounded [F1_Free; F2_Delayed] else r
  | _ => r
  end.

Theorem control_veto_noop_when_not_fault :
  forall c r, control_is_fault c = false -> control_veto c r = r.
Proof.
  intros c r Hnf. unfold control_veto.
  destruct r as [| c' ro]; [reflexivity |].
  destruct c'; try reflexivity; rewrite Hnf; reflexivity.
Qed.

(* classify: the single total, deterministic top-level entry point. *)
Definition classify (fi : flow_inputs) : flow_result :=
  if negb (any_present fi) then Refused
  else
    match fi_comm fi with
    | Comm_Backflow => Classified F5_Surcharge (remove_class F5_Surcharge OTHERS)
    | _ => control_veto (fi_ctrl fi) (base_classify (fi_dh fi) (fi_trend fi))
    end.

(* ------------------------------------------------------------------
   5. Totality, decidability, and the refusal characterisation.
   ------------------------------------------------------------------ *)

Theorem classify_total :
  forall fi : flow_inputs, exists r : flow_result, classify fi = r.
Proof. intros. eexists. reflexivity. Qed.

Theorem base_classify_never_refused :
  forall d t, base_classify d t <> Refused.
Proof. intros d t. destruct d; simpl; try discriminate. destruct t; discriminate. Qed.

Theorem control_veto_never_refused :
  forall c r, r <> Refused -> control_veto c r <> Refused.
Proof.
  intros c r Hr. unfold control_veto.
  destruct r as [| c' ro]; [contradiction |].
  destruct c'; try discriminate; destruct (control_is_fault c); discriminate.
Qed.

(* The main "F6, not REFUSED, whenever any input is present" theorem:
   REFUSED occurs if and only if all four inputs are absent. *)
Theorem refused_iff_all_absent :
  forall fi : flow_inputs, classify fi = Refused <-> any_present fi = false.
Proof.
  intros fi. unfold classify. split.
  - intro H. destruct (any_present fi) eqn:E; [| reflexivity].
    destruct (fi_comm fi) eqn:Ecomm.
    + discriminate.
    + exfalso. eapply control_veto_never_refused; [| exact H].
      apply base_classify_never_refused.
    + exfalso. eapply control_veto_never_refused; [| exact H].
      apply base_classify_never_refused.
    + exfalso. eapply control_veto_never_refused; [| exact H].
      apply base_classify_never_refused.
    + exfalso. eapply control_veto_never_refused; [| exact H].
      apply base_classify_never_refused.
  - intro H. rewrite H. reflexivity.
Qed.

Corollary classify_never_refused_when_present :
  forall fi : flow_inputs, any_present fi = true -> classify fi <> Refused.
Proof.
  intros fi H Hr. apply refused_iff_all_absent in Hr. rewrite Hr in H. discriminate.
Qed.

(* ------------------------------------------------------------------
   6. Restricted monotonicity of the ruled-out set, and the honest
      counterexample to the UNRESTRICTED claim.
   ------------------------------------------------------------------ *)

Lemma base_classify_ruled_out_monotone :
  forall d1 d2 t1 t2,
    (d1 = DH_Absent \/ d1 = d2) ->
    (t1 = TR_Absent \/ t1 = t2) ->
    incl (ruled_out_of (base_classify d1 t1)) (ruled_out_of (base_classify d2 t2)).
Proof.
  intros d1 d2 t1 t2 Hd Ht.
  destruct Hd as [-> | ->].
  - (* d1 = DH_Absent: base_classify ignores t in this branch *)
    simpl. apply incl_nil_l.
  - destruct Ht as [-> | ->].
    + (* t1 = TR_Absent, d1 = d2 *)
      destruct d2.
      * (* Forward *) destruct t2; compute; intros a Ha; intuition congruence.
      * (* Reverse: t ignored on both sides *) apply incl_refl.
      * (* Unresolved: t ignored on both sides *) apply incl_refl.
      * (* Absent *) compute; intros a Ha; contradiction.
    + (* d1 = d2, t1 = t2 : identical inputs *) apply incl_refl.
Qed.

Lemma any_present_mono :
  forall fi1 fi2 : flow_inputs,
    (fi_dh fi1 = DH_Absent \/ fi_dh fi1 = fi_dh fi2) ->
    (fi_trend fi1 = TR_Absent \/ fi_trend fi1 = fi_trend fi2) ->
    (fi_ctrl fi1 = Ctrl_Absent \/ fi_ctrl fi1 = fi_ctrl fi2) ->
    (fi_comm fi1 = Comm_Absent \/ fi_comm fi1 = fi_comm fi2) ->
    any_present fi1 = true -> any_present fi2 = true.
Proof.
  intros fi1 fi2 Hdh Htr Hctrl Hcomm Hany.
  unfold any_present in Hany.
  apply Bool.orb_true_iff in Hany as [Hany | Hany];
    apply Bool.orb_true_iff in Hany as [Hany | Hany].
  - assert (Heq : fi_dh fi1 = fi_dh fi2)
      by (destruct Hdh as [Habs | Heq]; [rewrite Habs in Hany; discriminate | exact Heq]).
    unfold any_present. rewrite <- Heq, Hany. reflexivity.
  - assert (Heq : fi_trend fi1 = fi_trend fi2)
      by (destruct Htr as [Habs | Heq]; [rewrite Habs in Hany; discriminate | exact Heq]).
    unfold any_present. rewrite <- Heq, Hany.
    destruct (dh_present (fi_dh fi2)); reflexivity.
  - assert (Heq : fi_ctrl fi1 = fi_ctrl fi2)
      by (destruct Hctrl as [Habs | Heq]; [rewrite Habs in Hany; discriminate | exact Heq]).
    unfold any_present. rewrite <- Heq, Hany.
    destruct (dh_present (fi_dh fi2)), (tr_present (fi_trend fi2)); reflexivity.
  - assert (Heq : fi_comm fi1 = fi_comm fi2)
      by (destruct Hcomm as [Habs | Heq]; [rewrite Habs in Hany; discriminate | exact Heq]).
    unfold any_present. rewrite <- Heq, Hany.
    destruct (dh_present (fi_dh fi2)), (tr_present (fi_trend fi2)), (ctrl_present (fi_ctrl fi2)); reflexivity.
Qed.

Lemma ctrl_is_fault_false_of_neq :
  forall c, c <> Ctrl_Fault -> control_is_fault c = false.
Proof. intros c Hc. destruct c; try reflexivity. contradiction (Hc eq_refl). Qed.

Theorem flow_ruled_out_monotone :
  forall fi1 fi2 : flow_inputs,
    fi_comm fi2 <> Comm_Backflow ->
    fi_ctrl fi2 <> Ctrl_Fault ->
    (fi_dh fi1 = DH_Absent \/ fi_dh fi1 = fi_dh fi2) ->
    (fi_trend fi1 = TR_Absent \/ fi_trend fi1 = fi_trend fi2) ->
    (fi_ctrl fi1 = Ctrl_Absent \/ fi_ctrl fi1 = fi_ctrl fi2) ->
    (fi_comm fi1 = Comm_Absent \/ fi_comm fi1 = fi_comm fi2) ->
    incl (ruled_out_of (classify fi1)) (ruled_out_of (classify fi2)).
Proof.
  intros fi1 fi2 Hcomm2 Hctrl2 Hdh Htr Hctrl Hcomm.
  assert (Hcomm1 : fi_comm fi1 <> Comm_Backflow).
  { destruct Hcomm as [-> | ->]; [discriminate | exact Hcomm2]. }
  assert (Hctrl1 : fi_ctrl fi1 <> Ctrl_Fault).
  { destruct Hctrl as [-> | ->]; [discriminate | exact Hctrl2]. }
  pose proof (ctrl_is_fault_false_of_neq _ Hctrl1) as Hcif1.
  pose proof (ctrl_is_fault_false_of_neq _ Hctrl2) as Hcif2.
  unfold classify.
  destruct (any_present fi1) eqn:E1.
  2: { simpl. apply incl_nil_l. }
  assert (E2 : any_present fi2 = true) by (eapply any_present_mono; eauto).
  rewrite E2.
  destruct (fi_comm fi1) eqn:Ec1; try (exfalso; apply Hcomm1; reflexivity);
    destruct (fi_comm fi2) eqn:Ec2; try (exfalso; apply Hcomm2; reflexivity);
    rewrite (control_veto_noop_when_not_fault (fi_ctrl fi1) _ Hcif1);
    rewrite (control_veto_noop_when_not_fault (fi_ctrl fi2) _ Hcif2);
    apply base_classify_ruled_out_monotone; assumption.
Qed.

(* HONEST COUNTEREXAMPLE: the unrestricted claim ("adding any input
   never un-rules an already ruled-out class") is FALSE once the
   control-fault veto is allowed to fire. fi1: forward gradient +
   falling trend, no control declared => F1, ruled_out = {F2,F3,F4,F5}
   (F1 itself is NOT ruled out -- it is the asserted class). fi2: same
   fi1 but control is now known to be FAULT => F6, ruled_out =
   {F1,F2}. F1 is absent from ruled_out(fi1) but present in
   ruled_out(fi2): a class that was affirmatively asserted becomes
   ruled out once new (contradicting) information arrives. This is a
   real retraction, disclosed here as a first-class counterexample
   rather than hidden behind an unprovable general theorem. *)

Definition ex_fi1 : flow_inputs :=
  mkFlowInputs DH_Forward TR_Falling Ctrl_Absent Comm_Absent.
Definition ex_fi2 : flow_inputs :=
  mkFlowInputs DH_Forward TR_Falling Ctrl_Fault Comm_Absent.

Example monotonicity_fails_on_fault_veto :
  ~ incl (ruled_out_of (classify ex_fi1)) (ruled_out_of (classify ex_fi2)).
Proof.
  unfold ex_fi1, ex_fi2, classify, any_present, control_veto, base_classify.
  simpl. intro H.
  (* ruled_out(fi1) = [F2;F3;F4;F5], ruled_out(fi2) = [F1;F2].
     F3_Blocked is in the source list but not the target -- that is
     the concrete failure of monotonicity. *)
  specialize (H F3_Blocked (or_intror (or_introl eq_refl))).
  simpl in H. intuition congruence.
Qed.

(* ------------------------------------------------------------------
   7. Worked examples (sanity checks against the JSON decision table).
   ------------------------------------------------------------------ *)

Example wex_all_absent_refused :
  classify (mkFlowInputs DH_Absent TR_Absent Ctrl_Absent Comm_Absent) = Refused.
Proof. reflexivity. Qed.

Example wex_backflow_dominates :
  classify (mkFlowInputs DH_Forward TR_Falling Ctrl_Open Comm_Backflow) =
    Classified F5_Surcharge (remove_class F5_Surcharge OTHERS).
Proof. reflexivity. Qed.

Example wex_free_flow :
  classify (mkFlowInputs DH_Forward TR_Falling Ctrl_Open Comm_Absent) =
    Classified F1_Free (remove_class F1_Free OTHERS).
Proof. reflexivity. Qed.

Example wex_blocked_despite_gradient :
  classify (mkFlowInputs DH_Forward TR_Stalled Ctrl_Absent Comm_Absent) =
    Classified F3_Blocked (remove_class F3_Blocked OTHERS).
Proof. reflexivity. Qed.

Example wex_blocked_survives_fault :
  classify (mkFlowInputs DH_Forward TR_Stalled Ctrl_Fault Comm_Absent) =
    Classified F3_Blocked (remove_class F3_Blocked OTHERS).
Proof. reflexivity. Qed.

Example wex_fault_vetoes_free_flow :
  classify (mkFlowInputs DH_Forward TR_Falling Ctrl_Fault Comm_Absent) =
    Classified F6_Bounded [F1_Free; F2_Delayed].
Proof. reflexivity. Qed.

Example wex_dh_absent_still_f6_not_refused :
  classify (mkFlowInputs DH_Absent TR_Absent Ctrl_Open Comm_Absent) =
    Classified F6_Bounded [].
Proof. reflexivity. Qed.

Example wex_rule_stall_01_fires :
  rule_stall_01 true S_VERIFIED_LIVE 1 0 S_VERIFIED_LIVE 2 true S_COMMUNITY 3 =
    {| iv_state := Cov_Inferred; iv_value := Some Tr_Stalled;
       iv_confidence := Some S_COMMUNITY; iv_anchors := [1;2;3] |}.
Proof. reflexivity. Qed.

Example wex_rule_dir_01_fires :
  rule_dir_01 Tr_Falling Tr_Falling S_RELAYED S_VERIFIED_STALE 10 20 =
    {| iv_state := Cov_Inferred; iv_value := Some Tr_Falling;
       iv_confidence := Some S_RELAYED; iv_anchors := [10;20] |}.
Proof. reflexivity. Qed.

(* ----------------------------------------------------------------------
   WHAT THIS FILE DOES NOT PROVE: which of D/T/C/M holds for any real
   edge/node/tick (IO-shaped, resolved by thailand_flood_kg's own
   runtime code, not this Coq object); that RULE-STALL-01/RULE-DIR-01's
   own physical reliability holds in general (they are declared
   consistency conventions, INSTINCT-rule, falsifiable per this
   proposal's own falsifier clause, not proved sound here); that the
   community BACKFLOW override or the control FAULT veto is itself the
   *correct* precedence choice (an open calibration question, stated in
   honest_caveats); and the unrestricted monotonicity claim, which is
   affirmatively FALSE and demonstrated so by
   `monotonicity_fails_on_fault_veto` above, not merely unproved. This
   file's claim is only: given the four already-collapsed inputs D, T,
   C, M, `classify` is a single total, decidable function returning
   REFUSED if and only if all four are absent, otherwise one of F1-F6
   with an explicit ruled-out subset never conflated with REFUSED; that
   the ruled-out set is monotone in D/T alone (holding C away from
   FAULT and M away from BACKFLOW on both sides being compared); and
   that `inferred_value`/`coverage3` correctly rank Absent < Inferred
   <= Present, the reusable ordering fact a future PROP-FLOOD-06.v6
   needs. `coqc -q` clean, `Print Assumptions` closed under the global
   context (no axioms) on every theorem in this file. *)
