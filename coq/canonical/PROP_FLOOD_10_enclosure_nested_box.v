(* ===================================================================== *)
(*  PROP_FLOOD_10_enclosure_nested_box.v                                  *)
(*  Monotone endpoint enclosure over a declared finite box on Q, its      *)
(*  iterated (per-tick recursion) form, the nested-box condition, the     *)
(*  interval three-state readout as an exact renaming of D/M.71-76, and   *)
(*  the fail-closed BOUND_MISSING rule.                                   *)
(*  (Toledo proposal PROP-FLOOD-10a.v1.1, code weld/M.??.v1, proposals-lane,*)
(*  not yet canonicalized -- see registry/LINEAGE.jsonl code             *)
(*  PROP-FLOOD-10a.)  NEW DERIVATION / PROPOSAL -- not yet in Toledo.     *)
(*                                                                         *)
(*  This is the "Delta 2" of the FloodConnect reuse card: it is written  *)
(*  ONCE, domain-generic (nothing in this file mentions water), and is    *)
(*  imported by PROP_FLOOD_08 (interval form of the load ratio and of the *)
(*  storage exceedance) and by PROP_FLOOD_10 (zoom levels 0-3), so the    *)
(*  enclosure is never registered twice under two names.                  *)
(*                                                                         *)
(*  Parents (read, not keyword-matched):                                  *)
(*    R/M.30.v1 Qmult_le_l_nonneg, R/M.25.v1 mono_step (monotone bricks); *)
(*    Z/M.15-17.v1, Z/M.22.v1 (max-plus algebra of max(0, .));           *)
(*    A2/M.12-14.v1 (fold-max bounds: every source value lies below the   *)
(*    max, and the max is attained);                                      *)
(*    D/M.71-76.v1 classify (imported below from the IDM mirror, not      *)
(*    restated): the interval three-state readout IS classify with        *)
(*    floor := (hi-lo)/2 and v := (lo+hi)/2 - theta (exact renaming);     *)
(*    D/M.77.v1 bot_monotone_in_floor is the same-centre special case of  *)
(*    the nested-box theorem below (it fixes v and widens the floor; a    *)
(*    nested child interval moves BOTH v and floor, which is exactly why  *)
(*    the nested-box condition is a delta and not a renaming of D/M.77).  *)
(*  Genesis gate: readout_genesis A.13 Gate 2 (three-valued admissibility:*)
(*  a missing bound is recorded as unresolved -- REFUSED for that layer   *)
(*  only -- never guessed and never replaced by an infinity; Q has none). *)
(*                                                                         *)
(*  All quantities are finite rationals at declared ticks; no limit, no   *)
(*  continuum, no +/- infinity.  No axioms: every theorem is checked by   *)
(*  Print Assumptions at the bottom of the scratch audit.                 *)
(* ===================================================================== *)

Require Import QArith.
Require Import Coq.QArith.Qminmax.
Require Import Coq.micromega.Lqa.
Require Import Lia.
From IDM.formal Require Import IDM_ReadoutMinimality IDM_ResolvedCount.

Local Open Scope Q_scope.

(* ------------------------------------------------------------------
   1. Declared finite box and sign pattern.
      A point is a finite vector x : nat -> Q read on coordinates
      0..n-1.  sg i = true  : the map is non-decreasing in coordinate i
                   sg i = false : the map is non-increasing in coordinate i
   ------------------------------------------------------------------ *)

Definition vec := nat -> Q.

Record box := mkBox { b_lo : vec; b_hi : vec }.

Definition box_wf (n : nat) (B : box) : Prop :=
  forall i, (i < n)%nat -> b_lo B i <= b_hi B i.

Definition in_box (n : nat) (B : box) (x : vec) : Prop :=
  forall i, (i < n)%nat -> b_lo B i <= x i /\ x i <= b_hi B i.

(* the partial order induced by the declared sign pattern *)
Definition sgn_le (n : nat) (sg : nat -> bool) (x y : vec) : Prop :=
  forall i, (i < n)%nat -> if sg i then x i <= y i else y i <= x i.

Definition sigma_monotone (n : nat) (sg : nat -> bool) (f : vec -> Q) : Prop :=
  forall x y, sgn_le n sg x y -> f x <= f y.

(* the two worst/best corners: lo* = (lower on I+, upper on I-), hi* = reverse *)
Definition corner_lo (sg : nat -> bool) (B : box) : vec :=
  fun i => if sg i then b_lo B i else b_hi B i.
Definition corner_hi (sg : nat -> bool) (B : box) : vec :=
  fun i => if sg i then b_hi B i else b_lo B i.

Lemma corner_lo_below :
  forall n sg B x, in_box n B x -> sgn_le n sg (corner_lo sg B) x.
Proof.
  intros n sg B x Hx i Hi. unfold corner_lo.
  destruct (Hx i Hi) as [H1 H2]. destruct (sg i); assumption.
Qed.

Lemma corner_hi_above :
  forall n sg B x, in_box n B x -> sgn_le n sg x (corner_hi sg B).
Proof.
  intros n sg B x Hx i Hi. unfold corner_hi.
  destruct (Hx i Hi) as [H1 H2]. destruct (sg i); assumption.
Qed.

(* ---- THEOREM (Delta 2, one-shot form): monotone endpoint enclosure.
   For every point of the declared box, f lies between its values at the
   two declared corners. *)
Theorem enclosure_sound :
  forall n sg f B x,
    sigma_monotone n sg f -> in_box n B x ->
    f (corner_lo sg B) <= f x /\ f x <= f (corner_hi sg B).
Proof.
  intros n sg f B x Hf Hx. split.
  - apply Hf. apply corner_lo_below. exact Hx.
  - apply Hf. apply corner_hi_above. exact Hx.
Qed.

(* the enclosure is tight: both corners are themselves points of a
   well-formed box, so both endpoints are attained values, not padding *)
Theorem corners_in_box :
  forall n sg B, box_wf n B ->
    in_box n B (corner_lo sg B) /\ in_box n B (corner_hi sg B).
Proof.
  intros n sg B Hwf. split; intros i Hi; unfold corner_lo, corner_hi;
  specialize (Hwf i Hi); destruct (sg i); split; lra.
Qed.

(* box-restricted form (v1.1, review A1): many real maps (products such as
   P*A*c) are monotone only on part of Q^n, e.g. the non-negative orthant.
   Monotonicity is then required only between points OF THE BOX. *)
Definition box_monotone (n : nat) (sg : nat -> bool) (B : box) (f : vec -> Q) : Prop :=
  forall x y, in_box n B x -> in_box n B y -> sgn_le n sg x y -> f x <= f y.

Theorem enclosure_sound_box :
  forall n sg f B x,
    box_wf n B -> box_monotone n sg B f -> in_box n B x ->
    f (corner_lo sg B) <= f x /\ f x <= f (corner_hi sg B).
Proof.
  intros n sg f B x Hwf Hf Hx. destruct (corners_in_box n sg B Hwf) as [Hlo Hhi]. split.
  - apply Hf; [exact Hlo | exact Hx | apply corner_lo_below; exact Hx].
  - apply Hf; [exact Hx | exact Hhi | apply corner_hi_above; exact Hx].
Qed.

(* global monotonicity is the special case *)
Lemma sigma_monotone_box : forall n sg B f, sigma_monotone n sg f -> box_monotone n sg B f.
Proof. intros n sg B f Hf x y _ _ H. apply Hf. exact H. Qed.

(* ------------------------------------------------------------------
   2. Iterated form: a per-tick recursion D(t+1) = g(D(t), u(t)) that is
      non-decreasing in D and sigma-monotone in the tick input.  Running
      the recursion at the lower corners and at the upper corners of the
      per-tick declared boxes encloses every admissible trajectory at
      every tick t (finite horizon; induction on the tick count only).
   ------------------------------------------------------------------ *)

Fixpoint iter (g : Q -> vec -> Q) (D0 : Q) (u : nat -> vec) (t : nat) : Q :=
  match t with
  | O => D0
  | S t' => g (iter g D0 u t') (u t')
  end.

Theorem iterated_enclosure :
  forall n sg (g : Q -> vec -> Q) (Bt : nat -> box) (u : nat -> vec)
         (Dlo D0 Dhi : Q),
    (forall d1 d2 x, d1 <= d2 -> g d1 x <= g d2 x) ->
    (forall d x y, sgn_le n sg x y -> g d x <= g d y) ->
    (forall t, in_box n (Bt t) (u t)) ->
    Dlo <= D0 -> D0 <= Dhi ->
    forall t,
      iter g Dlo (fun k => corner_lo sg (Bt k)) t <= iter g D0 u t /\
      iter g D0 u t <= iter g Dhi (fun k => corner_hi sg (Bt k)) t.
Proof.
  intros n sg g Bt u Dlo D0 Dhi HgD Hgx Hu Hlo Hhi t.
  induction t as [| t IH]; simpl.
  - split; assumption.
  - destruct IH as [IH1 IH2]. split.
    + apply Qle_trans with (g (iter g D0 u t) (corner_lo sg (Bt t))).
      * apply HgD. exact IH1.
      * apply Hgx. apply corner_lo_below. apply Hu.
    + apply Qle_trans with (g (iter g D0 u t) (corner_hi sg (Bt t))).
      * apply Hgx. apply corner_hi_above. apply Hu.
      * apply HgD. exact IH2.
Qed.

(* ------------------------------------------------------------------
   3. Instances actually used downstream (proved monotone, so they are
      legal inputs of section 1/2; no new arithmetic is claimed).
   ------------------------------------------------------------------ *)

(* excess over a declared reference on ONE declared unit/datum:
   e(s, r) = max(0, s - r); coordinate 0 = reading (sg true),
   coordinate 1 = reference (sg false).  PROP-FLOOD-08 E_k (volume) and
   PROP-FLOOD-10 level-3 point depth (length) are both this map. *)
Definition excess (s r : Q) : Q := Qmax 0 (s - r).

Definition excess_vec (x : vec) : Q := excess (x 0%nat) (x 1%nat).
Definition sg_excess (i : nat) : bool :=
  match i with O => true | _ => false end.

Theorem excess_sigma_monotone : sigma_monotone 2 sg_excess excess_vec.
Proof.
  intros x y H. unfold excess_vec, excess.
  assert (H0 := H 0%nat ltac:(lia)). assert (H1 := H 1%nat ltac:(lia)).
  simpl in H0, H1. apply Q.max_le_compat_l. lra.
Qed.

Theorem excess_nonneg : forall s r, 0 <= excess s r.
Proof. intros. unfold excess. apply Q.le_max_l. Qed.

(* screening step max(0, D + P - C): non-decreasing in D and P (coord 0),
   non-increasing in C (coord 1).  Recorded only as a monotone INSTANCE:
   it stays a screening heuristic (PROP-FLOOD-08 non-claims). *)
Definition screen_step (d : Q) (x : vec) : Q := Qmax 0 (d + x 0%nat - x 1%nat).

Theorem screen_step_mono_D :
  forall d1 d2 x, d1 <= d2 -> screen_step d1 x <= screen_step d2 x.
Proof. intros. unfold screen_step. apply Q.max_le_compat_l. lra. Qed.

Theorem screen_step_sigma :
  forall d x y, sgn_le 2 sg_excess x y -> screen_step d x <= screen_step d y.
Proof.
  intros d x y H. unfold screen_step.
  assert (H0 := H 0%nat ltac:(lia)). assert (H1 := H 1%nat ltac:(lia)).
  simpl in H0, H1. apply Q.max_le_compat_l. lra.
Qed.

(* PROP-FLOOD-03 step at box endpoints (the "L1 FULL" line of the zoom):
   S + P*A*c + Qin*tau - Qout*tau with declared A >= 0, tau >= 0 and a
   non-negative box for P and c.  Proved directly (the product needs the
   non-negative orthant, which a bare sign pattern does not carry). *)
Definition wb_step (S P A c Qin Qout tau : Q) : Q :=
  S + P * A * c + Qin * tau - Qout * tau.

Theorem wb_step_enclosure :
  forall A tau Slo S Shi Plo P Phi clo c chi Ilo I Ihi Olo O Ohi,
    0 <= A -> 0 <= tau ->
    Slo <= S <= Shi -> 0 <= Plo -> Plo <= P <= Phi -> 0 <= clo -> clo <= c <= chi ->
    Ilo <= I <= Ihi -> Olo <= O <= Ohi ->
    wb_step Slo Plo A clo Ilo Ohi tau <= wb_step S P A c I O tau /\
    wb_step S P A c I O tau <= wb_step Shi Phi A chi Ihi Olo tau.
Proof.
  intros A tau Slo S Shi Plo P Phi clo c chi Ilo I Ihi Olo O Ohi
         HA Htau HS HP0 HP Hc0 Hc HI HO.
  unfold wb_step.
  assert (HPA1 : Plo * A <= P * A)
    by (apply Qmult_le_compat_nonneg; split; lra).
  assert (HPA2 : P * A <= Phi * A)
    by (apply Qmult_le_compat_nonneg; split; lra).
  assert (HPA0 : 0 <= Plo * A)
    by (apply Qmult_le_0_compat; lra).
  assert (HPAc1 : Plo * A * clo <= P * A * c)
    by (apply Qmult_le_compat_nonneg; split; lra).
  assert (HPAc2 : P * A * c <= Phi * A * chi)
    by (apply Qmult_le_compat_nonneg; split; try lra;
        apply Qmult_le_0_compat; lra).
  assert (HI1 : Ilo * tau <= I * tau) by (apply Qmult_le_compat_r; lra).
  assert (HI2 : I * tau <= Ihi * tau) by (apply Qmult_le_compat_r; lra).
  assert (HO1 : Olo * tau <= O * tau) by (apply Qmult_le_compat_r; lra).
  assert (HO2 : O * tau <= Ohi * tau) by (apply Qmult_le_compat_r; lra).
  split; lra.
Qed.

(* ------------------------------------------------------------------
   4. Nested-box condition.  A finer layer's box is NESTED in a coarser
      layer's box when, on every shared coordinate, the child's interval
      lies inside the parent's.  Then the child's enclosure lies inside
      the parent's enclosure.  A non-nested pair is REFUSED NOT_NESTED for
      strict refinement (section 6), never silently compared.
   ------------------------------------------------------------------ *)

Definition nested (n : nat) (Bc Bp : box) : Prop :=
  forall i, (i < n)%nat -> b_lo Bp i <= b_lo Bc i /\ b_hi Bc i <= b_hi Bp i.

Theorem nested_enclosure :
  forall n sg f Bc Bp,
    sigma_monotone n sg f -> nested n Bc Bp ->
    f (corner_lo sg Bp) <= f (corner_lo sg Bc) /\
    f (corner_hi sg Bc) <= f (corner_hi sg Bp).
Proof.
  intros n sg f Bc Bp Hf Hn. split; apply Hf; intros i Hi;
  unfold corner_lo, corner_hi; destruct (Hn i Hi) as [H1 H2];
  destruct (sg i); assumption.
Qed.

(* ------------------------------------------------------------------
   5. Interval three-state readout = D/M.71-76 classify, renamed.
      cl lo hi theta := classify ((hi-lo)/2) ((lo+hi)/2 - theta).
      Characterisations on a well-formed interval (lo <= hi):
        Sp   <-> theta < lo              ("ROBUST above theta", strict)
        Sm   <-> hi < theta              ("BELOW")
        Sz   <-> lo == theta == hi       ("AT_THRESHOLD", degenerate)
        Sbot <-> lo <= theta <= hi, lo<>hi ("POSSIBLE")
      Boundary convention (declared, conservative): lo == theta with
      hi > theta is POSSIBLE, not ROBUST.
   ------------------------------------------------------------------ *)

Definition cl (lo hi theta : Q) : S4 :=
  classify ((hi - lo) * (1 # 2)) ((lo + hi) * (1 # 2) - theta).

Theorem cl_plus_iff :
  forall lo hi theta, lo <= hi -> (cl lo hi theta = Sp <-> theta < lo).
Proof.
  intros lo hi theta Hw. unfold cl, classify. split.
  - destruct (Qlt_le_dec _ _) as [H|H]; [intros _; lra|].
    destruct (Qlt_le_dec _ _); [discriminate|].
    destruct (Qeq_dec _ _); discriminate.
  - intros Ht. destruct (Qlt_le_dec _ _) as [H|H]; [reflexivity|]. lra.
Qed.

Theorem cl_minus_iff :
  forall lo hi theta, lo <= hi -> (cl lo hi theta = Sm <-> hi < theta).
Proof.
  intros lo hi theta Hw. unfold cl, classify. split.
  - destruct (Qlt_le_dec _ _) as [H|H]; [discriminate|].
    destruct (Qlt_le_dec _ _) as [H'|H']; [intros _; lra|].
    destruct (Qeq_dec _ _); discriminate.
  - intros Ht. destruct (Qlt_le_dec _ _) as [H|H]; [lra|].
    destruct (Qlt_le_dec _ _) as [H'|H']; [reflexivity|]. lra.
Qed.

Theorem cl_zero_iff :
  forall lo hi theta, lo <= hi ->
    (cl lo hi theta = Sz <-> (lo == theta /\ hi == theta)).
Proof.
  intros lo hi theta Hw. unfold cl, classify. split.
  - destruct (Qlt_le_dec _ _) as [H|H]; [discriminate|].
    destruct (Qlt_le_dec _ _) as [H'|H']; [discriminate|].
    destruct (Qeq_dec _ _) as [E|E]; [|discriminate].
    intros _. split; lra.
  - intros [E1 E2]. destruct (Qlt_le_dec _ _) as [H|H]; [lra|].
    destruct (Qlt_le_dec _ _) as [H'|H']; [lra|].
    destruct (Qeq_dec _ _) as [E|E]; [reflexivity|]. exfalso. apply E. lra.
Qed.

Theorem cl_bot_iff :
  forall lo hi theta, lo <= hi ->
    (cl lo hi theta = Sbot <-> (lo <= theta /\ theta <= hi /\ ~ lo == hi)).
Proof.
  intros lo hi theta Hw. unfold cl, classify. split.
  - destruct (Qlt_le_dec _ _) as [H|H]; [discriminate|].
    destruct (Qlt_le_dec _ _) as [H'|H']; [discriminate|].
    destruct (Qeq_dec _ _) as [E|E]; [discriminate|].
    intros _. split; [lra|split; [lra|]]. intro C. apply E. lra.
  - intros [H1 [H2 H3]]. destruct (Qlt_le_dec _ _) as [H|H]; [lra|].
    destruct (Qlt_le_dec _ _) as [H'|H']; [lra|].
    destruct (Qeq_dec _ _) as [E|E]; [|reflexivity].
    exfalso. apply H3. lra.
Qed.

(* soundness for every member: a ROBUST (resp. BELOW) interval readout
   never mis-states the side of theta of ANY value inside the interval --
   the interval form of classify_plus_sound / classify_minus_sound. *)
Theorem cl_plus_sound_members :
  forall lo hi theta x, lo <= hi -> cl lo hi theta = Sp ->
    lo <= x -> theta < x.
Proof.
  intros lo hi theta x Hw H Hx. apply (cl_plus_iff lo hi theta Hw) in H. lra.
Qed.

Theorem cl_minus_sound_members :
  forall lo hi theta x, lo <= hi -> cl lo hi theta = Sm ->
    x <= hi -> x < theta.
Proof.
  intros lo hi theta x Hw H Hx. apply (cl_minus_iff lo hi theta Hw) in H. lra.
Qed.

(* ---- THEOREM (nested box, readout form): a determinate parent readout
   is inherited by every nested child; a nested child can never flip it.
   Refinement can only RESOLVE a POSSIBLE, never contradict a ROBUST or
   BELOW of its nested parent. *)
Theorem nested_preserves_plus :
  forall loc hic lop hip theta,
    loc <= hic -> lop <= hip -> lop <= loc -> hic <= hip ->
    cl lop hip theta = Sp -> cl loc hic theta = Sp.
Proof.
  intros loc hic lop hip theta Hc Hp H1 H2 Hpar.
  apply (cl_plus_iff lop hip theta Hp) in Hpar.
  apply (cl_plus_iff loc hic theta Hc). lra.
Qed.

Theorem nested_preserves_minus :
  forall loc hic lop hip theta,
    loc <= hic -> lop <= hip -> lop <= loc -> hic <= hip ->
    cl lop hip theta = Sm -> cl loc hic theta = Sm.
Proof.
  intros loc hic lop hip theta Hc Hp H1 H2 Hpar.
  apply (cl_minus_iff lop hip theta Hp) in Hpar.
  apply (cl_minus_iff loc hic theta Hc). lra.
Qed.

Theorem nested_no_flip :
  forall loc hic lop hip theta,
    loc <= hic -> lop <= hip -> lop <= loc -> hic <= hip ->
    ~ (cl lop hip theta = Sp /\ cl loc hic theta = Sm) /\
    ~ (cl lop hip theta = Sm /\ cl loc hic theta = Sp).
Proof.
  intros loc hic lop hip theta Hc Hp H1 H2. split; intros [A B].
  - apply (cl_plus_iff lop hip theta Hp) in A.
    apply (cl_minus_iff loc hic theta Hc) in B. lra.
  - apply (cl_minus_iff lop hip theta Hp) in A.
    apply (cl_plus_iff loc hic theta Hc) in B. lra.
Qed.

(* without nesting the guarantee is gone: a concrete counterexample,
   recorded as first-class provenance (why NOT_NESTED is refused). *)
Example not_nested_can_flip :
  cl 81 90 80 = Sp /\ cl 10 20 80 = Sm.
Proof.
  split.
  - apply (cl_plus_iff 81 90 80); [lra|lra].
  - apply (cl_minus_iff 10 20 80); [lra|lra].
Qed.

(* ------------------------------------------------------------------
   6. Fail-closed bounds.  An interval endpoint is an option: an
      undeclared endpoint is None.  Q has no infinity, so a missing upper
      edge (e.g. an open-ended top rainfall class) cannot be filled -- the
      layer that needs it is REFUSED BOUND_MISSING, and only that layer.
   ------------------------------------------------------------------ *)

Inductive enc_reason : Set := BOUND_MISSING | BOUND_ORDER | NOT_NESTED.

Inductive enc_result (A : Type) : Type :=
  | EncOk : A -> enc_result A
  | EncRefused : enc_reason -> enc_result A.
Arguments EncOk {A} _.
Arguments EncRefused {A} _.

Definition declared_interval (lo hi : option Q) : enc_result (Q * Q) :=
  match lo, hi with
  | Some l, Some h => if Qle_bool l h then EncOk (l, h) else EncRefused BOUND_ORDER
  | _, _ => EncRefused BOUND_MISSING
  end.

Theorem declared_interval_missing_iff :
  forall lo hi,
    declared_interval lo hi = EncRefused BOUND_MISSING <-> (lo = None \/ hi = None).
Proof.
  intros lo hi. unfold declared_interval. split.
  - destruct lo as [l|], hi as [h|]; try (intros; auto; fail).
    destruct (Qle_bool l h); discriminate.
  - intros [-> | ->]; [reflexivity|]. destruct lo; reflexivity.
Qed.

Theorem declared_interval_ok_wf :
  forall lo hi l h, declared_interval lo hi = EncOk (l, h) -> l <= h.
Proof.
  intros lo hi l h H. unfold declared_interval in H.
  destruct lo as [l'|], hi as [h'|]; try discriminate.
  destruct (Qle_bool l' h') eqn:E; [|discriminate].
  inversion H; subst. apply Qle_bool_imp_le. exact E.
Qed.

(* strict refinement between two layers: only for well-ordered, nested
   intervals (v1.1, review A2: reversed endpoints are BOUND_ORDER) *)
Definition refine_check (loc hic lop hip : Q) : enc_result unit :=
  if negb (andb (Qle_bool loc hic) (Qle_bool lop hip)) then EncRefused BOUND_ORDER
  else if andb (Qle_bool lop loc) (Qle_bool hic hip) then EncOk tt
  else EncRefused NOT_NESTED.

Theorem refine_check_ok_nested :
  forall loc hic lop hip,
    refine_check loc hic lop hip = EncOk tt ->
    loc <= hic /\ lop <= hip /\ lop <= loc /\ hic <= hip.
Proof.
  intros loc hic lop hip H. unfold refine_check in H.
  destruct (Qle_bool loc hic) eqn:E1, (Qle_bool lop hip) eqn:E2; simpl in H; try discriminate.
  destruct (Qle_bool lop loc) eqn:E3, (Qle_bool hic hip) eqn:E4; simpl in H; try discriminate.
  repeat split; apply Qle_bool_imp_le; assumption.
Qed.

Theorem refine_check_bound_order :
  forall loc hic lop hip,
    ~ (loc <= hic /\ lop <= hip) -> refine_check loc hic lop hip = EncRefused BOUND_ORDER.
Proof.
  intros loc hic lop hip Hn. unfold refine_check.
  destruct (Qle_bool loc hic) eqn:E1, (Qle_bool lop hip) eqn:E2; simpl; try reflexivity.
  exfalso. apply Hn. split; apply Qle_bool_imp_le; assumption.
Qed.

Theorem refine_check_refuses_non_nested :
  forall loc hic lop hip,
    loc <= hic -> lop <= hip -> ~ (lop <= loc /\ hic <= hip) ->
    refine_check loc hic lop hip = EncRefused NOT_NESTED.
Proof.
  intros loc hic lop hip Hc Hp Hn. unfold refine_check.
  rewrite (proj2 (Qle_bool_iff loc hic) Hc), (proj2 (Qle_bool_iff lop hip) Hp). simpl.
  destruct (Qle_bool lop loc) eqn:E1, (Qle_bool hic hip) eqn:E2; simpl; try reflexivity.
  exfalso. apply Hn. split; apply Qle_bool_imp_le; assumption.
Qed.

(* the checked refinement licenses the nested-box readout theorems *)
Theorem checked_refinement_no_flip :
  forall loc hic lop hip theta,
    refine_check loc hic lop hip = EncOk tt ->
    (cl lop hip theta = Sp -> cl loc hic theta = Sp) /\
    (cl lop hip theta = Sm -> cl loc hic theta = Sm).
Proof.
  intros loc hic lop hip theta H. apply refine_check_ok_nested in H.
  destruct H as [Hc [Hp [H1 H2]]]. split.
  - apply nested_preserves_plus; assumption.
  - apply nested_preserves_minus; assumption.
Qed.
