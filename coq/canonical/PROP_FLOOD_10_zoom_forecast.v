(* ===================================================================== *)
(*  PROP_FLOOD_10_zoom_forecast.v                                         *)
(*  Zoom forecast by level (0 screen -> 1 sub-polder/district -> 2 node   *)
(*  -> 3 point): the three-state interval readout (D/M.71-76 via 10a),    *)
(*  the three deltas of PROP-FLOOD-10 --                                  *)
(*    Delta 10.1 compute gate (a child never inherits a verdict or a      *)
(*               refusal; BELOW stops descent; bounded cell ceiling),     *)
(*    Delta 10.2 single-source guard (a degenerate one-source interval is *)
(*               never reported as determinate unless its spread is      *)
(*               declared),                                               *)
(*    Delta 10.3 verification ledger (HIT / MISS / FALSE_ALARM /          *)
(*               CORRECT_NEG / UNRESOLVED; UNRESOLVED is never counted    *)
(*               as CORRECT_NEG; lead in integer ticks with a left-       *)
(*               censored onset reported as a bound; FEW_EVENTS refusal), *)
(*  and the level-3 point depth as an occurrence of PROP-FLOOD-08 E_k.    *)
(*  (Toledo proposal PROP-FLOOD-10.v2.1, code weld/M.??.v1, proposals-lane, *)
(*  not yet canonicalized -- see registry/LINEAGE.jsonl code             *)
(*  PROP-FLOOD-10.)  NEW DERIVATION / PROPOSAL -- not yet in Toledo.      *)
(*                                                                         *)
(*  Imports (reuse, not restatement): PROP-FLOOD-10a (enclosure, nested   *)
(*  box, cl = classify renamed), PROP-FLOOD-08 (refusal codes, `worst`,   *)
(*  E_k monotonicity), PROP-FLOOD-09 (inbound debt term and its           *)
(*  TAU_UNDECLARED code), IDM classify (D/M.71-76).  The statements are   *)
(*  area-generic; the MVP test scope (Bangkok + Sammakorn) is a registry  *)
(*  note, not a restriction of any definition below.                      *)
(* ===================================================================== *)

Require Import QArith.
Require Import Coq.QArith.Qminmax.
Require Import Coq.micromega.Lqa.
Require Import Coq.Lists.List.
Require Import Lia.
Import ListNotations.
From IDM.formal Require Import IDM_ReadoutMinimality IDM_ResolvedCount.
From MRC Require Import PROP_FLOOD_10_enclosure_nested_box.
From MRC Require Import PROP_FLOOD_08_load_ratio_drawdown_exceedance.
From MRC Require Import PROP_FLOOD_09_edge_booking_delay.

Local Open Scope Q_scope.

(* ------------------------------------------------------------------
   0. Readout vocabulary.  Refusal codes are the parents' own codes
      (wrapped, never renamed) plus the ones this object adds.
   ------------------------------------------------------------------ *)

Inductive zreason : Set :=
  | ZR08 : r08 -> zreason            (* PROP-FLOOD-03/08 codes, incl. MISSING_INPUT *)
  | ZR09 : r09 -> zreason            (* TAU_UNDECLARED *)
  | ZR10a : enc_reason -> zreason    (* BOUND_MISSING, BOUND_ORDER, NOT_NESTED *)
  | FEW_EVENTS
  | DUPLICATE_SOURCE.                (* v2: one named source counted once (review A11) *)

Inductive zstate : Set :=
  | ROBUST          (* Sp : whole interval strictly above theta *)
  | AT_THRESHOLD    (* Sz : degenerate interval exactly at theta *)
  | POSSIBLE        (* Sbot : theta inside a non-degenerate interval *)
  | BELOW           (* Sm : whole interval strictly below theta *)
  | ZREFUSED : zreason -> zstate.

Definition of_S4 (s : S4) : zstate :=
  match s with Sp => ROBUST | Sz => AT_THRESHOLD | Sbot => POSSIBLE | Sm => BELOW end.

Definition missing_input : zstate := ZREFUSED (ZR08 (Inherited03 MISSING_INPUT)).

(* ------------------------------------------------------------------
   1. Source interval (C1): I = [min over sources, max over sources],
      max reported first (worst first), never a mean.
   ------------------------------------------------------------------ *)

Fixpoint best (xs : list Q) : option Q :=
  match xs with
  | [] => None
  | x :: rest => match best rest with
                 | None => Some x
                 | Some b => Some (Qmin x b)
                 end
  end.

Theorem best_bounds_every_source :
  forall xs b x, best xs = Some b -> In x xs -> b <= x.
Proof.
  induction xs as [|y ys IH]; intros b x Hb Hin; [destruct Hin|].
  simpl in Hb. destruct (best ys) as [b'|] eqn:E.
  - injection Hb as <-. destruct Hin as [<- | Hin].
    + apply Q.le_min_l.
    + apply Qle_trans with b'; [apply Q.le_min_r | exact (IH b' x eq_refl Hin)].
  - injection Hb as <-. destruct Hin as [<- | Hin]; [apply Qle_refl|].
    destruct ys as [|z zs]; [destruct Hin|]. simpl in E. destruct (best zs); discriminate.
Qed.

Lemma best_none_iff : forall xs, best xs = None <-> xs = [].
Proof.
  intros xs. split; [|intros ->; reflexivity].
  destruct xs as [|x xs]; [reflexivity|]. simpl. destruct (best xs); discriminate.
Qed.

Theorem source_interval_encloses :
  forall xs lo hi x, best xs = Some lo -> worst xs = Some hi -> In x xs ->
    lo <= x /\ x <= hi.
Proof.
  intros xs lo hi x Hl Hh Hin. split.
  - exact (best_bounds_every_source xs lo x Hl Hin).
  - exact (worst_bounds_every_model xs hi x Hh Hin).
Qed.

Lemma best_le_worst :
  forall xs lo hi, best xs = Some lo -> worst xs = Some hi -> lo <= hi.
Proof.
  intros xs lo hi Hl Hh. destruct (worst_is_attained xs hi Hh) as [x [Hin Hx]].
  apply Qle_trans with x; [exact (best_bounds_every_source xs lo x Hl Hin)|].
  rewrite Hx. apply Qle_refl.
Qed.

(* ------------------------------------------------------------------
   2. Delta 10.2 -- single-source guard (C3).
      Sources are NAMED: (name, value).  A name may appear once only --
      a repeated name is REFUSED DUPLICATE_SOURCE, so two copies of one
      reading can never pose as two sources (v2, review A11).
      |M_u| = 0  -> REFUSED MISSING_INPUT
      |M_u| = 1  -> the interval is degenerate and its true width is
                    unknown: use the declared per-source-class spread
                    eps_src if declared (>= 0); if undeclared the strict
                    state is POSSIBLE (flag UNKNOWN_SINGLE_SOURCE) and the
                    raw value is carried as the bounds [x, x]
      |M_u| >= 2 -> cl over [min, max]
      A refused readout carries NO bounds (v2, review A7: no placeholder).
   ------------------------------------------------------------------ *)

Record zreadout := mkZ {
  z_state : zstate;
  z_bounds : option (Q * Q);        (* (lo, hi); hi is the worst-first value *)
  z_single_unknown_spread : bool    (* UNKNOWN_SINGLE_SOURCE flag *)
}.

Definition refused_readout (r : zreason) : zreadout := mkZ (ZREFUSED r) None false.

Definition zoom_vals (xs : list Q) (eps_src : option Q) (theta : Q) : zreadout :=
  match xs with
  | [] => refused_readout (ZR08 (Inherited03 MISSING_INPUT))
  | [x] =>
      match eps_src with
      | Some e => if Qle_bool 0 e
                  then mkZ (of_S4 (cl (x - e) (x + e) theta)) (Some (x - e, x + e)) false
                  else mkZ POSSIBLE (Some (x, x)) true
      | None => mkZ POSSIBLE (Some (x, x)) true
      end
  | _ :: _ :: _ =>
      match best xs, worst xs with
      | Some lo, Some hi => mkZ (of_S4 (cl lo hi theta)) (Some (lo, hi)) false
      | _, _ => refused_readout (ZR08 (Inherited03 MISSING_INPUT))   (* unreachable *)
      end
  end.

Fixpoint memb (n : nat) (l : list nat) : bool :=
  match l with [] => false | m :: r => orb (Nat.eqb n m) (memb n r) end.
Fixpoint nodupb (l : list nat) : bool :=
  match l with [] => true | m :: r => andb (negb (memb m r)) (nodupb r) end.

Definition zoom_state (srcs : list (nat * Q)) (eps_src : option Q) (theta : Q) : zreadout :=
  if nodupb (map fst srcs) then zoom_vals (map snd srcs) eps_src theta
  else refused_readout DUPLICATE_SOURCE.

Theorem zoom_duplicate_refused :
  forall srcs eps theta, nodupb (map fst srcs) = false ->
    z_state (zoom_state srcs eps theta) = ZREFUSED DUPLICATE_SOURCE.
Proof. intros srcs eps theta H. unfold zoom_state. rewrite H. reflexivity. Qed.

Example same_reading_twice_refused :
  z_state (zoom_state [(7%nat, 90); (7%nat, 90)] None 80) = ZREFUSED DUPLICATE_SOURCE.
Proof. reflexivity. Qed.

Theorem zoom_no_source_refused :
  forall eps theta, z_state (zoom_vals [] eps theta) = missing_input.
Proof. reflexivity. Qed.

Theorem refused_has_no_bounds :
  forall xs eps theta r,
    z_state (zoom_vals xs eps theta) = ZREFUSED r -> z_bounds (zoom_vals xs eps theta) = None.
Proof.
  intros xs eps theta r. destruct xs as [|x [|y rest]]; [reflexivity| |].
  - simpl. destruct eps as [e|]; [destruct (Qle_bool 0 e)|]; simpl; intros H; try discriminate.
    destruct (cl (x - e) (x + e) theta); discriminate.
  - unfold zoom_vals. destruct (best (x :: y :: rest)); destruct (worst (x :: y :: rest));
      simpl; intros H; try reflexivity; destruct (cl _ _ theta); discriminate.
Qed.

(* ---- THEOREM (Delta 10.2): one source with undeclared spread is never
   reported as a determinate ROBUST or BELOW. *)
Theorem single_source_never_determinate :
  forall x theta,
    z_state (zoom_vals [x] None theta) = POSSIBLE /\
    z_single_unknown_spread (zoom_vals [x] None theta) = true.
Proof. intros. split; reflexivity. Qed.

(* why the guard is needed: WITHOUT it a degenerate interval [x, x] is
   always determinate (never Sbot) -- classify at floor 0 has no band *)
Theorem degenerate_interval_always_determinate :
  forall x theta, cl x x theta <> Sbot.
Proof.
  intros x theta H. apply (cl_bot_iff x x theta (Qle_refl x)) in H.
  destruct H as [_ [_ H]]. apply H. reflexivity.
Qed.

(* consistency of an unflagged readout: its state IS cl of its bounds *)
Theorem unflagged_state_is_cl :
  forall xs eps theta lo hi,
    z_bounds (zoom_vals xs eps theta) = Some (lo, hi) ->
    z_single_unknown_spread (zoom_vals xs eps theta) = false ->
    lo <= hi /\ z_state (zoom_vals xs eps theta) = of_S4 (cl lo hi theta).
Proof.
  intros xs eps theta lo hi Hb Hf.
  destruct xs as [|x1 [|x2 rest]]; [discriminate| |].
  - simpl in *. destruct eps as [e|]; [|discriminate].
    destruct (Qle_bool 0 e) eqn:Ee; simpl in *; [|discriminate].
    injection Hb as <- <-. apply Qle_bool_iff in Ee. split; [lra | reflexivity].
  - unfold zoom_vals in *.
    destruct (best (x1 :: x2 :: rest)) as [l|] eqn:El;
    destruct (worst (x1 :: x2 :: rest)) as [h|] eqn:Eh; simpl in Hb; try discriminate.
    injection Hb as <- <-. split; [apply (best_le_worst _ l h El Eh) | reflexivity].
Qed.

(* with >= 2 sources, a ROBUST readout is sound for EVERY source *)
Theorem multi_source_robust_sound :
  forall x1 x2 rest theta y,
    z_state (zoom_vals (x1 :: x2 :: rest) None theta) = ROBUST ->
    In y (x1 :: x2 :: rest) -> theta < y.
Proof.
  intros x1 x2 rest theta y H Hin.
  unfold zoom_vals in H.
  destruct (best (x1 :: x2 :: rest)) as [lo|] eqn:El;
  destruct (worst (x1 :: x2 :: rest)) as [hi|] eqn:Eh; simpl in H; try discriminate.
  assert (Hw : lo <= hi) by (apply (best_le_worst _ lo hi El Eh)).
  destruct (cl lo hi theta) eqn:Ec; simpl in H; try discriminate.
  apply (cl_plus_sound_members lo hi theta y Hw Ec).
  exact (proj1 (source_interval_encloses _ lo hi y El Eh Hin)).
Qed.

Theorem multi_source_below_sound :
  forall x1 x2 rest theta y,
    z_state (zoom_vals (x1 :: x2 :: rest) None theta) = BELOW ->
    In y (x1 :: x2 :: rest) -> y < theta.
Proof.
  intros x1 x2 rest theta y H Hin.
  unfold zoom_vals in H.
  destruct (best (x1 :: x2 :: rest)) as [lo|] eqn:El;
  destruct (worst (x1 :: x2 :: rest)) as [hi|] eqn:Eh; simpl in H; try discriminate.
  assert (Hw : lo <= hi) by (apply (best_le_worst _ lo hi El Eh)).
  destruct (cl lo hi theta) eqn:Ec; simpl in H; try discriminate.
  apply (cl_minus_sound_members lo hi theta y Hw Ec).
  exact (proj2 (source_interval_encloses _ lo hi y El Eh Hin)).
Qed.

(* ------------------------------------------------------------------
   3. Delta 10.1 -- compute gate (C5), stated ONCE (review A3):
      evaluate a child cell iff
        (a) the parent is ROBUST, AT_THRESHOLD or POSSIBLE, or
        (b) the parent is REFUSED -- for ANY reason -- and the child has
            its own inputs.
      BELOW stops descent for that window.  The child's readout is
      computed from the child's OWN inputs only.  Every evaluated child
      also carries the strict-refinement check against its parent
      (10a refine_check, v2 review A2): Ok only for well-ordered nested
      bounds; otherwise NOT_NESTED / BOUND_ORDER / BOUND_MISSING, and the
      child is then a cross-partition readout only.
   ------------------------------------------------------------------ *)

Definition descend (parent : zstate) (child_has_inputs : bool) : bool :=
  match parent with
  | ROBUST | AT_THRESHOLD | POSSIBLE => true
  | BELOW => false
  | ZREFUSED _ => child_has_inputs
  end.

Definition has_inputs {A : Type} (xs : list A) : bool :=
  match xs with [] => false | _ => true end.

Definition refinement (child parent : zreadout) : enc_result unit :=
  match z_bounds child, z_bounds parent with
  | Some (loc, hic), Some (lop, hip) => refine_check loc hic lop hip
  | _, _ => EncRefused BOUND_MISSING
  end.

(* v2.1 (review R2-A11): ladder children are NAMED sources and go through
   zoom_state, so the duplicate-source guard applies to every child too *)
Definition zoom_child (parent : zreadout) (child_srcs : list (nat * Q)) (eps : option Q) (theta : Q)
  : option (zreadout * enc_result unit) :=
  if descend (z_state parent) (has_inputs child_srcs)
  then let c := zoom_state child_srcs eps theta in Some (c, refinement c parent)
  else None.

Lemma zoom_state_nodup :
  forall srcs eps theta, nodupb (map fst srcs) = true ->
    zoom_state srcs eps theta = zoom_vals (map snd srcs) eps theta.
Proof. intros srcs eps theta H. unfold zoom_state. rewrite H. reflexivity. Qed.

Theorem ladder_child_is_zoom_state :
  forall p srcs eps theta r k,
    zoom_child p srcs eps theta = Some (r, k) -> r = zoom_state srcs eps theta.
Proof.
  intros p srcs eps theta r k H. unfold zoom_child in H.
  destruct (descend _ _); [|discriminate]. injection H as <- _. reflexivity.
Qed.

(* ---- THEOREM (R2-A11): a ladder child with a repeated source name is
   REFUSED DUPLICATE_SOURCE, exactly like a top-level unit. *)
Theorem ladder_child_duplicate_refused :
  forall p srcs eps theta r k,
    zoom_child p srcs eps theta = Some (r, k) ->
    nodupb (map fst srcs) = false -> z_state r = ZREFUSED DUPLICATE_SOURCE.
Proof.
  intros p srcs eps theta r k H Hd. apply ladder_child_is_zoom_state in H. subst r.
  apply zoom_duplicate_refused. exact Hd.
Qed.

Theorem gate_below_stops :
  forall p xs eps theta, z_state p = BELOW -> zoom_child p xs eps theta = None.
Proof. intros p xs eps theta H. unfold zoom_child. rewrite H. reflexivity. Qed.

(* a child never inherits its parent's VERDICT: any two descending
   parents give the identical child readout *)
Theorem child_independent_of_parent_verdict :
  forall p1 p2 xs eps theta r1 r2 k1 k2,
    zoom_child p1 xs eps theta = Some (r1, k1) -> zoom_child p2 xs eps theta = Some (r2, k2) ->
    r1 = r2.
Proof.
  intros p1 p2 xs eps theta r1 r2 k1 k2 H1 H2.
  rewrite (ladder_child_is_zoom_state _ _ _ _ _ _ H1), (ladder_child_is_zoom_state _ _ _ _ _ _ H2).
  reflexivity.
Qed.

Lemma zoom_vals_nonempty_not_missing :
  forall x rest eps theta, z_state (zoom_vals (x :: rest) eps theta) <> missing_input.
Proof.
  intros x rest eps theta.
  destruct rest as [|y rest]; simpl.
  - destruct eps as [e|]; simpl; [|discriminate].
    destruct (Qle_bool 0 e); simpl; [|discriminate].
    destruct (cl (x - e) (x + e) theta); discriminate.
  - destruct (best rest) as [b|] eqn:Eb;
    destruct (worst rest) as [w|] eqn:Ew; simpl;
      destruct (cl _ _ theta); discriminate.
Qed.

(* a child never inherits its parent's REFUSAL: a refused parent with a
   child that has inputs yields the child's own readout, never the
   missing-input refusal *)
Theorem child_does_not_inherit_refusal :
  forall p rsn s rest eps theta,
    z_state p = ZREFUSED rsn ->
    exists r k, zoom_child p (s :: rest) eps theta = Some (r, k) /\
                z_state r <> missing_input.
Proof.
  intros p rsn s rest eps theta Hp. unfold zoom_child. rewrite Hp. simpl.
  eexists; eexists. split; [reflexivity|].
  unfold zoom_state. destruct (nodupb (map fst (s :: rest))); [|discriminate].
  simpl. apply zoom_vals_nonempty_not_missing.
Qed.

Theorem refused_parent_without_child_inputs_stops :
  forall p rsn eps theta, z_state p = ZREFUSED rsn -> zoom_child p [] eps theta = None.
Proof. intros p rsn eps theta H. unfold zoom_child. rewrite H. reflexivity. Qed.

(* ---- THEOREM (C4 mechanised): when the refinement check passes and
   neither readout is a flagged single source, a determinate parent is
   inherited by the child and never flipped. *)
Theorem checked_child_keeps_parent_side :
  forall pxs peps cxs ceps theta,
    let p := zoom_vals pxs peps theta in
    let c := zoom_vals cxs ceps theta in
    refinement c p = EncOk tt ->
    z_single_unknown_spread p = false -> z_single_unknown_spread c = false ->
    (z_state p = ROBUST -> z_state c = ROBUST) /\ (z_state p = BELOW -> z_state c = BELOW).
Proof.
  intros pxs peps cxs ceps theta p c Hr Hfp Hfc.
  unfold refinement in Hr.
  destruct (z_bounds c) as [[loc hic]|] eqn:Ebc; [|discriminate].
  destruct (z_bounds p) as [[lop hip]|] eqn:Ebp; [|discriminate].
  destruct (unflagged_state_is_cl cxs ceps theta loc hic Ebc Hfc) as [_ Hsc].
  destruct (unflagged_state_is_cl pxs peps theta lop hip Ebp Hfp) as [_ Hsp].
  destruct (checked_refinement_no_flip loc hic lop hip theta Hr) as [Hplus Hminus].
  fold p c in Hsc, Hsp. rewrite Hsp, Hsc. split; intros H.
  - destruct (cl lop hip theta) eqn:E; simpl in H; try discriminate.
    rewrite (Hplus eq_refl). reflexivity.
  - destruct (cl lop hip theta) eqn:E; simpl in H; try discriminate.
    rewrite (Hminus eq_refl). reflexivity.
Qed.

(* bounded refinement: at most N_cells children are ever evaluated for
   one parent (EQ-001/C.18.v1 supplies termination of the whole ladder) *)
Definition evaluate_children (parent : zreadout) (cells : list (list (nat * Q)))
           (N_cells : nat) (eps : option Q) (theta : Q) : list (option (zreadout * enc_result unit)) :=
  map (fun xs => zoom_child parent xs eps theta) (firstn N_cells cells).

Theorem evaluated_cells_bounded :
  forall parent cells N eps theta,
    (length (evaluate_children parent cells N eps theta) <= N)%nat.
Proof.
  intros. unfold evaluate_children. rewrite length_map, length_firstn. lia.
Qed.

(* ------------------------------------------------------------------
   4. Delta 10.3 -- verification ledger.
   ------------------------------------------------------------------ *)

Inductive truth : Set := EVENT | NO_EVENT | T_UNRESOLVED.
Inductive vcell : Set := HIT | MISS | FALSE_ALARM | CORRECT_NEG | C_UNRESOLVED.
Inductive fire_rule : Set := STRICT | WORST_FIRST.

Definition is_refused (s : zstate) : bool :=
  match s with ZREFUSED _ => true | _ => false end.

(* "fires" is declared twice and both are reported:
   STRICT      : state = ROBUST
   WORST_FIRST : not refused and hi >= theta (raw value under C3) *)
Definition fires (rule : fire_rule) (r : zreadout) (theta : Q) : bool :=
  match rule with
  | STRICT => match z_state r with ROBUST => true | _ => false end
  | WORST_FIRST =>
      if is_refused (z_state r) then false
      else match z_bounds r with Some (_, hi) => Qle_bool theta hi | None => false end
  end.

Definition cell (rule : fire_rule) (r : zreadout) (theta : Q) (o : truth) : vcell :=
  if is_refused (z_state r) then C_UNRESOLVED else
  match o with
  | T_UNRESOLVED => C_UNRESOLVED
  | EVENT => if fires rule r theta then HIT else MISS
  | NO_EVENT => if fires rule r theta then FALSE_ALARM else CORRECT_NEG
  end.

(* ---- THEOREM (Delta 10.3): UNRESOLVED is never counted as CORRECT_NEG. *)
Theorem unresolved_never_correct_negative :
  forall rule r theta, cell rule r theta T_UNRESOLVED <> CORRECT_NEG.
Proof.
  intros rule r theta. unfold cell. destruct (is_refused _); discriminate.
Qed.

Theorem refused_forecast_never_correct_negative :
  forall rule r theta o, is_refused (z_state r) = true -> cell rule r theta o = C_UNRESOLVED.
Proof. intros rule r theta o H. unfold cell. rewrite H. reflexivity. Qed.

Theorem correct_negative_sound :
  forall rule r theta o,
    cell rule r theta o = CORRECT_NEG ->
    o = NO_EVENT /\ is_refused (z_state r) = false /\ fires rule r theta = false.
Proof.
  intros rule r theta o H. unfold cell in H.
  destruct (is_refused (z_state r)) eqn:Er; [discriminate|].
  destruct o; [destruct (fires rule r theta); discriminate | | discriminate].
  destruct (fires rule r theta) eqn:Ef; [discriminate|]. auto.
Qed.

Theorem cell_unresolved_iff :
  forall rule r theta o,
    cell rule r theta o = C_UNRESOLVED <->
    (is_refused (z_state r) = true \/ o = T_UNRESOLVED).
Proof.
  intros rule r theta o. unfold cell. split.
  - destruct (is_refused (z_state r)); [left; reflexivity|].
    destruct o; [destruct (fires rule r theta); discriminate
               | destruct (fires rule r theta); discriminate
               | right; reflexivity].
  - intros [H | ->]; [rewrite H; reflexivity|]. destruct (is_refused _); reflexivity.
Qed.

Lemma flagged_is_possible :
  forall xs eps theta,
    z_single_unknown_spread (zoom_vals xs eps theta) = true ->
    z_state (zoom_vals xs eps theta) = POSSIBLE.
Proof.
  intros xs eps theta. destruct xs as [|x [|y rest]].
  - simpl. discriminate.
  - simpl. destruct eps as [e|]; [destruct (Qle_bool 0 e)|]; simpl; intros H;
      [discriminate | reflexivity | reflexivity].
  - unfold zoom_vals. destruct (best (x :: y :: rest)); destruct (worst (x :: y :: rest));
      simpl; discriminate.
Qed.

Lemma bounds_present_unless_refused :
  forall xs eps theta,
    z_bounds (zoom_vals xs eps theta) = None -> is_refused (z_state (zoom_vals xs eps theta)) = true.
Proof.
  intros xs eps theta. destruct xs as [|x [|y rest]].
  - reflexivity.
  - simpl. destruct eps as [e|]; [destruct (Qle_bool 0 e)|]; simpl; discriminate.
  - unfold zoom_vals. destruct (best (x :: y :: rest)); destruct (worst (x :: y :: rest));
      simpl; intros H; try discriminate; reflexivity.
Qed.

(* strict firing implies worst-first firing, for EVERY zoom readout
   (v2: any declared spread, not only eps = None -- review A4) *)
Theorem strict_implies_worst_first :
  forall xs eps theta,
    fires STRICT (zoom_vals xs eps theta) theta = true ->
    fires WORST_FIRST (zoom_vals xs eps theta) theta = true.
Proof.
  intros xs eps theta H.
  destruct (z_bounds (zoom_vals xs eps theta)) as [[lo hi]|] eqn:Eb.
  - destruct (z_single_unknown_spread (zoom_vals xs eps theta)) eqn:Ef.
    + exfalso. unfold fires in H. rewrite (flagged_is_possible xs eps theta Ef) in H.
      discriminate.
    + destruct (unflagged_state_is_cl xs eps theta lo hi Eb Ef) as [Hw Hs].
      unfold fires in *. rewrite Hs in *. rewrite Eb.
      destruct (cl lo hi theta) eqn:Ec; simpl in *; try discriminate.
      apply (cl_plus_iff lo hi theta Hw) in Ec. apply Qle_bool_iff. lra.
  - exfalso. unfold fires in H.
    destruct (z_state (zoom_vals xs eps theta)) eqn:Es; try discriminate.
    apply (bounds_present_unless_refused xs eps theta) in Eb. rewrite Es in Eb. discriminate.
Qed.

(* ledger counting: every row lands in exactly one cell (nothing dropped,
   nothing averaged), and CORRECT_NEG never exceeds the resolved
   NO_EVENT rows *)
Definition vcell_eqb (c x : vcell) : bool :=
  match x, c with
  | HIT, HIT | MISS, MISS | FALSE_ALARM, FALSE_ALARM
  | CORRECT_NEG, CORRECT_NEG | C_UNRESOLVED, C_UNRESOLVED => true
  | _, _ => false
  end.

Definition count_cell (c : vcell) (rows : list vcell) : nat :=
  length (filter (vcell_eqb c) rows).

Theorem ledger_partition :
  forall rows,
    (count_cell HIT rows + count_cell MISS rows + count_cell FALSE_ALARM rows +
     count_cell CORRECT_NEG rows + count_cell C_UNRESOLVED rows = length rows)%nat.
Proof.
  induction rows as [|c rows IH]; [reflexivity|].
  unfold count_cell in *. destruct c; simpl; lia.
Qed.

Definition ledger (rule : fire_rule) (theta : Q) (rows : list (zreadout * truth)) : list vcell :=
  map (fun p => cell rule (fst p) theta (snd p)) rows.

Definition is_resolved_no_event (p : zreadout * truth) : bool :=
  match snd p with
  | NO_EVENT => negb (is_refused (z_state (fst p)))
  | _ => false
  end.

Definition resolved_no_event (rows : list (zreadout * truth)) : nat :=
  length (filter is_resolved_no_event rows).

Theorem correct_negatives_bounded :
  forall rule theta rows,
    (count_cell CORRECT_NEG (ledger rule theta rows) <= resolved_no_event rows)%nat.
Proof.
  intros rule theta rows. unfold count_cell, resolved_no_event, ledger.
  induction rows as [|[r o] rows IH]; [simpl; lia|]. simpl map. simpl filter.
  destruct (is_resolved_no_event (r, o)) eqn:Er;
  destruct (vcell_eqb CORRECT_NEG (cell rule r theta o)) eqn:Ec; simpl length; try lia.
  exfalso. destruct (cell rule r theta o) eqn:Ec'; try discriminate.
  apply correct_negative_sound in Ec'. destruct Ec' as [Ho [Hr _]].
  unfold is_resolved_no_event in Er. simpl in Er. rewrite Ho, Hr in Er. discriminate.
Qed.

(* lead in integer ticks; a left-censored onset (first fetch already
   showed the event) is only an upper bound on the onset tick, so the
   lead is reported as an upper bound, never as a point *)
Inductive onset : Set :=
  | OnsetExact : Z -> onset
  | OnsetNoLaterThan : Z -> onset
  | OnsetUnknown : onset.

Inductive lead : Set :=
  | LeadExact : Z -> lead
  | LeadAtMost : Z -> lead
  | LeadRefused : lead.

Definition lead_of (t_alert : Z) (o : onset) : lead :=
  match o with
  | OnsetExact t => LeadExact (t - t_alert)
  | OnsetNoLaterThan t => LeadAtMost (t - t_alert)
  | OnsetUnknown => LeadRefused
  end.

Theorem censored_lead_is_upper_bound :
  forall t_alert t_obs t_true,
    (t_true <= t_obs)%Z ->
    lead_of t_alert (OnsetNoLaterThan t_obs) = LeadAtMost (t_obs - t_alert) /\
    (t_true - t_alert <= t_obs - t_alert)%Z.
Proof. intros. split; [reflexivity | lia]. Qed.

(* skill claims: refused below the declared minimum count of independent
   events; an undeclared minimum is refused too (fail closed) *)
Definition skill_claim (n_ind : nat) (N_min : option nat) : option zreason :=
  match N_min with
  | None => Some FEW_EVENTS
  | Some N => if Nat.ltb n_ind N then Some FEW_EVENTS else None
  end.

Theorem skill_claim_refused_iff :
  forall n N_min,
    skill_claim n N_min = Some FEW_EVENTS <->
    (N_min = None \/ exists N, N_min = Some N /\ (n < N)%nat).
Proof.
  intros n N_min. unfold skill_claim. destruct N_min as [N|].
  - destruct (Nat.ltb n N) eqn:E; split; intros H.
    + right. exists N. split; [reflexivity|]. apply Nat.ltb_lt. exact E.
    + reflexivity.
    + discriminate.
    + destruct H as [H | [N' [HN Hlt]]]; [discriminate|]. injection HN as <-.
      apply Nat.ltb_lt in Hlt. congruence.
  - split; intros _; [left; reflexivity | reflexivity].
Qed.

(* ------------------------------------------------------------------
   5. Level 3 -- point depth: E_k's `excess` (PROP-FLOOD-08) on a length
      unit and ONE declared datum, interval form; reversed endpoints are
      BOUND_ORDER and a missing common datum is DATUM_UNDECLARED (v2,
      review A2).
   ------------------------------------------------------------------ *)

Inductive zres (A : Type) : Type :=
  | ZOk : A -> zres A
  | ZRef : zreason -> zres A.
Arguments ZOk {A} _.
Arguments ZRef {A} _.

Definition point_depth_interval (Hlo Hhi zlo zhi : Q) (same_datum : bool) : zres (Q * Q) :=
  if negb same_datum then ZRef (ZR08 DATUM_UNDECLARED)
  else if andb (Qle_bool Hlo Hhi) (Qle_bool zlo zhi) then ZOk (excess Hlo zhi, excess Hhi zlo)
  else ZRef (ZR10a BOUND_ORDER).

Theorem point_depth_enclosure :
  forall Hlo H Hhi zlo z zhi lo hi,
    Hlo <= H <= Hhi -> zlo <= z <= zhi ->
    point_depth_interval Hlo Hhi zlo zhi true = ZOk (lo, hi) ->
    lo <= excess H z /\ excess H z <= hi.
Proof.
  intros Hlo H Hhi zlo z zhi lo hi HH Hz Hp. unfold point_depth_interval in Hp. simpl in Hp.
  destruct (andb _ _); [|discriminate]. injection Hp as <- <-. split.
  - apply exceedance_monotone; lra.
  - apply exceedance_monotone; lra.
Qed.

Theorem point_depth_refused_without_datum :
  forall Hlo Hhi zlo zhi, point_depth_interval Hlo Hhi zlo zhi false = ZRef (ZR08 DATUM_UNDECLARED).
Proof. reflexivity. Qed.

Theorem point_depth_refuses_reversed :
  forall Hlo Hhi zlo zhi, (Hhi < Hlo \/ zhi < zlo) ->
    point_depth_interval Hlo Hhi zlo zhi true = ZRef (ZR10a BOUND_ORDER).
Proof.
  intros Hlo Hhi zlo zhi H. unfold point_depth_interval. simpl.
  destruct (Qle_bool Hlo Hhi) eqn:E1, (Qle_bool zlo zhi) eqn:E2; simpl; try reflexivity.
  apply Qle_bool_iff in E1. apply Qle_bool_iff in E2. exfalso. destruct H; lra.
Qed.

(* ------------------------------------------------------------------
   6. Inbound (stacked) debt at level 1/2 is PROP-FLOOD-09's
      d_in_node_full, cited, not redefined; reported BESIDE the rain
      state, never merged: its refusal leaves the rain state untouched.
   ------------------------------------------------------------------ *)

Record level1 := mkL1 {
  l1_rain : zreadout;
  l1_inbound : res09 Q
}.

Definition level1_readout (rain_srcs : list (nat * Q)) (eps : option Q) (theta : Q)
           (edges : list (option nat * option (nat -> Q))) (know H : nat) : level1 :=
  mkL1 (zoom_state rain_srcs eps theta) (d_in_node_full edges know H).

Theorem inbound_refusal_leaves_rain_state :
  forall srcs eps theta edges1 edges2 know H,
    l1_rain (level1_readout srcs eps theta edges1 know H) =
    l1_rain (level1_readout srcs eps theta edges2 know H).
Proof. reflexivity. Qed.

(* ------------------------------------------------------------------
   7. Level 1 FULL (v2, review B2).  The storage interval [S_lo, S_hi]
      (PROP-FLOOD-03 at box endpoints, 10a wb_step_enclosure) is
      classified against the declared safe storage itself:
          state := cl(S_lo, S_hi; S_safe)      -- can be BELOW
      and the exceedance magnitude is reported beside it:
          E in [excess S_lo S_safe, excess S_hi S_safe].
      The v1 readout cl(E; 0) could never be BELOW (E >= 0), so it
      always fired worst-first and always descended -- retired.
   ------------------------------------------------------------------ *)

Definition l1_full (Slo Shi : Q) (S_safe : option Q) : zreadout * option (Q * Q) :=
  match S_safe with
  | None => (refused_readout (ZR08 SAFE_STORAGE_UNDECLARED), None)
  | Some ss =>
      if Qltb Slo 0 then (refused_readout (ZR08 (Inherited03 NEGATIVE_STORAGE)), None)
      else if Qle_bool Slo Shi
      then (mkZ (of_S4 (cl Slo Shi ss)) (Some (Slo, Shi)) false, Some (excess Slo ss, excess Shi ss))
      else (refused_readout (ZR10a BOUND_ORDER), None)
  end.

Theorem l1_full_below_reachable :
  forall Slo Shi ss, 0 <= Slo -> Slo <= Shi -> Shi < ss ->
    z_state (fst (l1_full Slo Shi (Some ss))) = BELOW /\
    snd (l1_full Slo Shi (Some ss)) = Some (excess Slo ss, excess Shi ss).
Proof.
  intros Slo Shi ss H0 Hw Hb. unfold l1_full.
  destruct (Qltb Slo 0) eqn:E0; [apply Qltb_iff in E0; lra|].
  rewrite (proj2 (Qle_bool_iff Slo Shi) Hw). simpl. split; [|reflexivity].
  rewrite (proj2 (cl_minus_iff Slo Shi ss Hw) Hb). reflexivity.
Qed.

Theorem l1_full_below_means_no_excess :
  forall Slo Shi ss, Slo <= Shi -> Shi < ss -> excess Shi ss == 0 /\ excess Slo ss == 0.
Proof.
  intros. split; apply exceedance_zero_when_room_available; lra.
Qed.

Theorem l1_full_robust_iff_certain_excess :
  forall Slo Shi ss, 0 <= Slo -> Slo <= Shi ->
    (z_state (fst (l1_full Slo Shi (Some ss))) = ROBUST <-> 0 < excess Slo ss).
Proof.
  intros Slo Shi ss H0 Hw. unfold l1_full.
  destruct (Qltb Slo 0) eqn:E0; [apply Qltb_iff in E0; lra|].
  rewrite (proj2 (Qle_bool_iff Slo Shi) Hw). simpl. unfold excess.
  split; intros H.
  - destruct (cl Slo Shi ss) eqn:Ec; simpl in H; try discriminate.
    apply (cl_plus_iff Slo Shi ss Hw) in Ec. rewrite Q.max_r; lra.
  - destruct (Q.max_spec 0 (Slo - ss)) as [[Hl Hm]|[Hl Hm]]; rewrite Hm in H; [|lra].
    rewrite (proj2 (cl_plus_iff Slo Shi ss Hw) ltac:(lra)). reflexivity.
Qed.

Theorem l1_full_refused_without_safe :
  forall Slo Shi, z_state (fst (l1_full Slo Shi None)) = ZREFUSED (ZR08 SAFE_STORAGE_UNDECLARED).
Proof. reflexivity. Qed.

(* ------------------------------------------------------------------
   8. Level 2 arrival lower bound (v2, review B3).  Every declared path
      from the source to v is a list of edge delays (option nat).  If ANY
      edge on ANY declared path has no declared delay the whole bound is
      REFUSED TAU_UNDECLARED -- a path is never dropped (dropping it would
      treat it as never arriving, a non-readout; an undeclared path may be the
      fastest).  Otherwise t_arr >= min over paths of the summed delays
      (Z/M.21, A2/M.07 on ticks).
   ------------------------------------------------------------------ *)

Fixpoint path_delay (p : list (option nat)) : option nat :=
  match p with
  | [] => Some 0%nat
  | None :: _ => None
  | Some d :: rest => match path_delay rest with Some s => Some (d + s)%nat | None => None end
  end.

Fixpoint min_delay (ps : list (list (option nat))) : zres nat :=
  match ps with
  | [] => ZRef (ZR08 (Inherited03 MISSING_INPUT))
  | [p] => match path_delay p with Some s => ZOk s | None => ZRef (ZR09 TAU_UNDECLARED) end
  | p :: rest =>
      match path_delay p, min_delay rest with
      | Some s, ZOk m => ZOk (Nat.min s m)
      | None, _ => ZRef (ZR09 TAU_UNDECLARED)
      | _, ZRef r => ZRef r
      end
  end.

Lemma path_delay_none_iff : forall p, path_delay p = None <-> In None p.
Proof.
  induction p as [|[d|] rest IH]; simpl.
  - split; [discriminate | intros []].
  - destruct (path_delay rest); split; intros H.
    + discriminate.
    + destruct H as [H|H]; [discriminate|]. apply IH in H. discriminate.
    + right. apply IH. reflexivity.
    + reflexivity.
  - split; intros _; [left; reflexivity | reflexivity].
Qed.

Theorem arrival_refused_iff_undeclared_edge :
  forall ps, ps <> [] ->
    (min_delay ps = ZRef (ZR09 TAU_UNDECLARED) <-> exists p, In p ps /\ In None p).
Proof.
  induction ps as [|p rest IH]; intros Hne; [congruence|].
  destruct rest as [|q rest'].
  - simpl. destruct (path_delay p) eqn:E; split; intros H.
    + discriminate.
    + destruct H as [p' [[<-|[]] Hn]]. apply path_delay_none_iff in Hn. congruence.
    + exists p. split; [left; reflexivity | apply path_delay_none_iff; exact E].
    + reflexivity.
  - assert (IH' := IH ltac:(discriminate)).
    change (min_delay (p :: q :: rest')) with
      (match path_delay p, min_delay (q :: rest') with
       | Some s, ZOk m => ZOk (Nat.min s m)
       | None, _ => ZRef (ZR09 TAU_UNDECLARED)
       | _, ZRef r => ZRef r end).
    destruct (path_delay p) as [s|] eqn:E.
    + destruct (min_delay (q :: rest')) as [m|r] eqn:Em; split; intros H.
      * discriminate.
      * destruct H as [p' [[<-|Hin] Hn]].
        -- apply path_delay_none_iff in Hn. congruence.
        -- assert (Hx : ZOk m = ZRef (ZR09 TAU_UNDECLARED))
             by (apply IH'; exists p'; split; assumption). discriminate.
      * rewrite H in IH'. destruct (proj1 IH' eq_refl) as [p' [Hin Hn]].
        exists p'. split; [right; exact Hin | exact Hn].
      * destruct H as [p' [[<-|Hin] Hn]].
        -- apply path_delay_none_iff in Hn. congruence.
        -- apply IH'. exists p'. split; assumption.
    + split; intros _; [|reflexivity].
      exists p. split; [left; reflexivity | apply path_delay_none_iff; exact E].
Qed.

Theorem arrival_bound_sound :
  forall ps m, min_delay ps = ZOk m ->
    forall p, In p ps -> exists s, path_delay p = Some s /\ (m <= s)%nat.
Proof.
  induction ps as [|p rest IH]; intros m Hm p' Hin; [destruct Hin|].
  destruct rest as [|q rest'].
  - simpl in Hm. destruct (path_delay p) as [s|] eqn:E; [|discriminate].
    injection Hm as Hm. subst m. destruct Hin as [<-|[]]. exists s. split; [exact E | lia].
  - change (min_delay (p :: q :: rest')) with
      (match path_delay p, min_delay (q :: rest') with
       | Some s, ZOk m => ZOk (Nat.min s m)
       | None, _ => ZRef (ZR09 TAU_UNDECLARED)
       | _, ZRef r => ZRef r end) in Hm.
    destruct (path_delay p) as [s|] eqn:E; [|discriminate].
    destruct (min_delay (q :: rest')) as [m'|r] eqn:Em; [|discriminate].
    injection Hm as <-. destruct Hin as [<-|Hin].
    + exists s. split; [exact E | lia].
    + destruct (IH m' eq_refl p' Hin) as [s' [Hs Hle]]. exists s'. split; [exact Hs | lia].
Qed.

Example undeclared_faster_path_refuses :
  min_delay [[Some 3%nat; Some 3%nat]; [None]] = ZRef (ZR09 TAU_UNDECLARED).
Proof. reflexivity. Qed.
