(* ===================================================================== *)
(*  PROP_FLOOD_09_edge_booking_delay.v                                    *)
(*  Delta 1 only: ONE edge value booked in TWO node ledgers with a        *)
(*  declared integer delay d_e (ticks), plus the inbound ("stacked")      *)
(*  debt D_in it induces, and the TAU_UNDECLARED refusal.                 *)
(*  (Toledo proposal PROP-FLOOD-09.v1.1, code weld/M.??.v1, proposals-lane, *)
(*  not yet canonicalized -- see registry/LINEAGE.jsonl code             *)
(*  PROP-FLOOD-09.)  NEW DERIVATION / PROPOSAL -- not yet in Toledo.      *)
(*                                                                         *)
(*  Everything else a "network coupling" rule needs is a COMPOSITION of   *)
(*  registered or proposed objects and is NOT restated here (see the      *)
(*  registry JSON composition table): the capacity bound |Q_e| <= cap_e  *)
(*  is EQ-001/C.04.v1 admissibility + A2/M.24-25.v1 clamp; the sign       *)
(*  consistency with PROP-FLOOD-04 is D/M.71-76.v1 o PROP-FLOOD-04; a     *)
(*  storage-free junction is PROP-FLOOD-03 with S == 0; the outfall       *)
(*  boundary is PROP-FLOOD-06 R_H / g_U with 03's tide-lock gate_flag;    *)
(*  cancellation of interior edges when nodes are summed is A2/M.11.v1   *)
(*  (fold_add_split, re-proved below on Q as `qsum_add`) and             *)
(*  EQ-001/C.01.v1 (closed-boundary ledger conservation).                *)
(*                                                                         *)
(*  What no registered object says (the delta): the SAME value Q_e(k) is  *)
(*  a summand of Q_out,u(k) and of Q_in,v(k + d_e), with d_e a DECLARED   *)
(*  natural number of ticks; an undeclared delay is REFUSED, never 0.     *)
(*  Values q(k) below are per-tick volumes (Q_e(k) * tau), finite Q.      *)
(* ===================================================================== *)

Require Import QArith.
Require Import Coq.micromega.Lqa.
Require Import Coq.Lists.List.
Require Import Lia.
Import ListNotations.

Local Open Scope Q_scope.

(* finite sum over ticks 0..n-1 *)
Fixpoint qsum (f : nat -> Q) (n : nat) : Q :=
  match n with
  | O => 0
  | S n' => qsum f n' + f n'
  end.

Lemma qsum_S : forall f n, qsum f (S n) = qsum f n + f n.
Proof. reflexivity. Qed.

Lemma qsum_zero : forall n, qsum (fun _ => 0) n == 0.
Proof. intros n. induction n as [|n IH]; simpl; [reflexivity|]. rewrite IH. ring. Qed.

Lemma qsum_ext :
  forall f g n, (forall i, (i < n)%nat -> f i == g i) -> qsum f n == qsum g n.
Proof.
  intros f g n H. induction n as [|n IH]; simpl; [reflexivity|].
  rewrite IH by (intros; apply H; lia). rewrite (H n) by lia. reflexivity.
Qed.

(* the Q occurrence of A2/M.11.v1 fold_add_split *)
Lemma qsum_add : forall f g n, qsum (fun i => f i + g i) n == qsum f n + qsum g n.
Proof. intros f g n. induction n as [|n IH]; simpl; [reflexivity|]. rewrite IH. ring. Qed.

Lemma qsum_nonneg : forall f n, (forall i, 0 <= f i) -> 0 <= qsum f n.
Proof. intros f n H. induction n as [|n IH]; simpl; [lra|]. specialize (H n). lra. Qed.

(* ------------------------------------------------------------------
   1. The booking identity (Delta 1).
      booked_out q k   = q k                     (summand of Q_out,u(k))
      booked_in d q j  = q (j - d) if d <= j     (summand of Q_in,v(j))
                         0         otherwise     (nothing has arrived yet)
   ------------------------------------------------------------------ *)

Definition booked_out (q : nat -> Q) (k : nat) : Q := q k.

Definition booked_in (d : nat) (q : nat -> Q) (j : nat) : Q :=
  if Nat.leb d j then q (j - d)%nat else 0.

Theorem booking_same_value :
  forall d q k, booked_in d q (k + d) = booked_out q k.
Proof.
  intros d q k. unfold booked_in, booked_out.
  destruct (Nat.leb d (k + d)) eqn:E.
  - f_equal. lia.
  - apply Nat.leb_gt in E. lia.
Qed.

Lemma booked_in_before_delay :
  forall d q m, (m <= d)%nat -> qsum (booked_in d q) m == 0.
Proof.
  intros d q m. induction m as [|m IH]; intros Hm; simpl; [reflexivity|].
  rewrite IH by lia. unfold booked_in.
  destruct (Nat.leb d m) eqn:E; [apply Nat.leb_le in E; lia|]. ring.
Qed.

(* ---- THEOREM: booking with delay conserves total volume across the two
   ledgers.  Everything booked out of u during ticks 0..t-1 is booked
   into v during ticks 0..t+d-1: no value is created, lost, or counted
   twice by the delay. *)
Theorem booking_conserves :
  forall d q t, qsum (booked_in d q) (t + d) == qsum (booked_out q) t.
Proof.
  intros d q t. induction t as [|t IH].
  - simpl. apply booked_in_before_delay. lia.
  - change (S t + d)%nat with (S (t + d)). simpl. rewrite IH.
    rewrite booking_same_value. reflexivity.
Qed.

(* the same statement as a two-ledger balance over SHIFTED windows: what
   ledger v books during ticks 0..t+d-1 minus what ledger u books during
   ticks 0..t-1 is exactly zero -- the EQ-001/C.01.v1 shape with the
   receiving window extended by the delay d (review A14) *)
Corollary two_ledger_balance :
  forall d q t, qsum (booked_in d q) (t + d) - qsum (booked_out q) t == 0.
Proof. intros. rewrite booking_conserves. ring. Qed.

(* ------------------------------------------------------------------
   2. Inbound ("stacked") debt at the receiving node, from ONE edge:
        D_in(k_now, H) := sum of q(k) with k <= k_now and
                          k_now < k + d <= k_now + H
      = volume already released (measured) upstream that will arrive at
        the receiving node within the horizon H.  Indexed by arrival tick
        j = k_now + 1 + i, i < H.
   ------------------------------------------------------------------ *)

Definition d_in (d : nat) (q : nat -> Q) (know H : nat) : Q :=
  qsum (fun i => let j := (S know + i)%nat in
                 if andb (Nat.leb d j) (Nat.leb (j - d) know) then q (j - d)%nat else 0) H.

(* booked, not forecast: D_in depends only on values released at or
   before k_now *)
Theorem d_in_causal :
  forall d q1 q2 know H,
    (forall k, (k <= know)%nat -> q1 k == q2 k) ->
    d_in d q1 know H == d_in d q2 know H.
Proof.
  intros d q1 q2 know H Hq. unfold d_in. apply qsum_ext. intros i Hi.
  destruct (Nat.leb d (S know + i)) eqn:E1, (Nat.leb (S know + i - d) know) eqn:E2;
    simpl; try reflexivity.
  apply Hq. apply Nat.leb_le. exact E2.
Qed.

Theorem d_in_nonneg :
  forall d q know H, (forall k, 0 <= q k) -> 0 <= d_in d q know H.
Proof.
  intros d q know H Hq. unfold d_in. apply qsum_nonneg. intros i.
  destruct (andb _ _); [apply Hq | lra].
Qed.

(* zero delay: whatever was released has already arrived -- no stacked
   debt remains in transit *)
Theorem d_in_zero_delay : forall q know H, d_in 0 q know H == 0.
Proof.
  intros q know H. unfold d_in.
  apply Qeq_trans with (qsum (fun _ => 0) H); [|apply qsum_zero].
  apply qsum_ext. intros i Hi. cbv beta zeta.
  replace (Nat.leb (S know + i - 0) know) with false
    by (symmetry; apply Nat.leb_gt; lia).
  destruct (Nat.leb 0 (S know + i)); reflexivity.
Qed.

(* saturation: beyond the delay nothing more that is ALREADY released can
   arrive, so D_in(H) for any H >= d equals D_in(d) = the whole in-transit
   volume *)
Theorem d_in_saturates :
  forall d q know m, d_in d q know (d + m) == d_in d q know d.
Proof.
  intros d q know m. unfold d_in. induction m as [|m IH].
  - rewrite Nat.add_0_r. reflexivity.
  - rewrite Nat.add_succ_r. rewrite qsum_S. rewrite IH. cbv beta zeta.
    replace (Nat.leb (S know + (d + m) - d) know) with false
      by (symmetry; apply Nat.leb_gt; lia).
    destruct (Nat.leb d (S know + (d + m))); simpl; ring.
Qed.

Theorem d_in_monotone_H :
  forall d q know H m, (forall k, 0 <= q k) -> d_in d q know H <= d_in d q know (H + m).
Proof.
  intros d q know H m Hq. unfold d_in. induction m as [|m IH].
  - rewrite Nat.add_0_r. apply Qle_refl.
  - rewrite Nat.add_succ_r. rewrite qsum_S. cbv beta zeta.
    destruct (andb _ _); [specialize (Hq (S know + (H + m) - d)%nat) |]; lra.
Qed.

(* ------------------------------------------------------------------
   3. TAU_UNDECLARED: the delay is an option; undeclared is refused and is
      never silently read as 0 (EQ-001/P.61.v1: a propagation speed/delay
      is declared or measured, not derived).
   ------------------------------------------------------------------ *)

Inductive r09 : Set := TAU_UNDECLARED | INPUT_ABSENT.

Inductive res09 (A : Type) : Type :=
  | Ok09 : A -> res09 A
  | Refused09 : r09 -> res09 A.
Arguments Ok09 {A} _.
Arguments Refused09 {A} _.

Definition book (d : option nat) (q : nat -> Q) : res09 (nat -> Q) :=
  match d with
  | Some d' => Ok09 (booked_in d' q)
  | None => Refused09 TAU_UNDECLARED
  end.

Theorem book_refused_iff :
  forall d q, book d q = Refused09 TAU_UNDECLARED <-> d = None.
Proof.
  intros d q. split; [destruct d; [discriminate|reflexivity] | intros ->; reflexivity].
Qed.

Theorem undeclared_is_not_zero_delay :
  forall q, book None q <> book (Some 0%nat) q.
Proof. intros q. simpl. discriminate. Qed.

(* inbound debt at node b over its declared inbound edges: every edge
   carries its own optional delay; ONE undeclared delay refuses the
   inbound term (only that term -- the rain term of the node is not
   touched by this refusal) *)
Fixpoint d_in_node (edges : list (option nat * (nat -> Q))) (know H : nat) : res09 Q :=
  match edges with
  | [] => Ok09 0
  | (Some d, q) :: rest =>
      match d_in_node rest know H with
      | Ok09 s => Ok09 (d_in d q know H + s)
      | Refused09 r => Refused09 r
      end
  | (None, _) :: _ => Refused09 TAU_UNDECLARED
  end.

Theorem d_in_node_refused_iff :
  forall edges know H,
    d_in_node edges know H = Refused09 TAU_UNDECLARED <->
    exists q, In (None, q) edges.
Proof.
  induction edges as [|[d q] rest IH]; intros know H; simpl.
  - split; [discriminate | intros [q []]].
  - destruct d as [d|].
    + destruct (d_in_node rest know H) as [s|r] eqn:E.
      * split; [discriminate|]. intros [q' [Hq|Hq]]; [discriminate|].
        assert (Hr : d_in_node rest know H = Refused09 TAU_UNDECLARED)
          by (apply (IH know H); exists q'; exact Hq).
        congruence.
      * destruct r.
        -- split; intros _; [|reflexivity].
           assert (Hr : exists q0, In (None, q0) rest) by (apply (IH know H); exact E).
           destruct Hr as [q0 Hq0]. exists q0. right. exact Hq0.
        -- split; [discriminate|]. intros [q' [Hq|Hq]]; [discriminate|].
           assert (Hr : d_in_node rest know H = Refused09 TAU_UNDECLARED)
             by (apply (IH know H); exists q'; exact Hq).
           congruence.
    + split; intros _; [exists q; left; reflexivity | reflexivity].
Qed.

Theorem d_in_node_nonneg :
  forall edges know H s,
    (forall d q, In (Some d, q) edges -> forall k, 0 <= q k) ->
    d_in_node edges know H = Ok09 s -> 0 <= s.
Proof.
  induction edges as [|[d q] rest IH]; intros know H s Hq Hs; simpl in Hs.
  - injection Hs as <-. lra.
  - destruct d as [d|]; [|discriminate].
    destruct (d_in_node rest know H) as [s'|r] eqn:E; [|discriminate].
    injection Hs as <-.
    assert (0 <= d_in d q know H)
      by (apply d_in_nonneg; apply (Hq d q); left; reflexivity).
    assert (0 <= s')
      by (apply (IH know H s'); [intros d' q' Hin; apply (Hq d' q'); right; exact Hin | exact E]).
    lra.
Qed.

(* ------------------------------------------------------------------
   4. Per-edge missing flow (v1.1, review A13).  A declared edge may have
      no flow readout at all (no discharge feed): its flow is an option.
      Precedence: TAU_UNDECLARED on ANY inbound edge refuses the whole
      inbound term first; otherwise a missing flow on any edge refuses it
      as INPUT_ABSENT; neither is ever replaced by 0.  Flows are per-tick
      volumes in the DECLARED orientation (s -> b); d_in_nonneg needs
      q >= 0, i.e. a reverse flow must be declared as its own edge.
   ------------------------------------------------------------------ *)

Definition delay_declared (e : option nat * option (nat -> Q)) : bool :=
  match fst e with Some _ => true | None => false end.
Definition flow_present (e : option nat * option (nat -> Q)) : bool :=
  match snd e with Some _ => true | None => false end.

Fixpoint strip_flows (edges : list (option nat * option (nat -> Q)))
  : list (option nat * (nat -> Q)) :=
  match edges with
  | [] => []
  | (d, Some q) :: rest => (d, q) :: strip_flows rest
  | (d, None) :: rest => strip_flows rest        (* unreachable after the checks *)
  end.

Definition d_in_node_full (edges : list (option nat * option (nat -> Q))) (know H : nat)
  : res09 Q :=
  if negb (forallb delay_declared edges) then Refused09 TAU_UNDECLARED
  else if negb (forallb flow_present edges) then Refused09 INPUT_ABSENT
  else d_in_node (strip_flows edges) know H.

Theorem d_in_node_full_tau_iff :
  forall edges know H,
    d_in_node_full edges know H = Refused09 TAU_UNDECLARED <->
    exists e, In e edges /\ delay_declared e = false.
Proof.
  intros edges know H. unfold d_in_node_full. split.
  - destruct (forallb delay_declared edges) eqn:E1; simpl.
    + destruct (forallb flow_present edges) eqn:E2; simpl; [|discriminate].
      intros Hd. exfalso.
      assert (Hall : forall e, In e edges -> delay_declared e = true)
        by (apply forallb_forall; exact E1).
      assert (Hf : forall e, In e edges -> flow_present e = true)
        by (apply forallb_forall; exact E2).
      apply d_in_node_refused_iff in Hd. destruct Hd as [q Hin].
      clear E1 E2. induction edges as [|[d o] rest IH]; [destruct Hin|].
      simpl in Hin. destruct o as [q'|].
      * destruct Hin as [Heq | Hin].
        -- injection Heq as -> _. specialize (Hall (None, Some q') (or_introl eq_refl)). discriminate.
        -- apply IH; [exact Hin | intros; apply Hall; right; assumption | intros; apply Hf; right; assumption].
      * specialize (Hf (d, None) (or_introl eq_refl)). discriminate.
    + intros _. apply Bool.not_true_iff_false in E1.
      destruct (existsb (fun e => negb (delay_declared e)) edges) eqn:E3.
      * apply existsb_exists in E3. destruct E3 as [e [Hin He]]. exists e. split; [exact Hin|].
        destruct (delay_declared e); [discriminate | reflexivity].
      * exfalso. apply E1. apply forallb_forall. intros e Hin.
        destruct (delay_declared e) eqn:Ed; [reflexivity|].
        assert (existsb (fun e => negb (delay_declared e)) edges = true)
          by (apply existsb_exists; exists e; rewrite Ed; auto).
        congruence.
  - intros [e [Hin He]].
    assert (Hf : forallb delay_declared edges = false).
    { apply Bool.not_true_iff_false. intro C. rewrite forallb_forall in C.
      rewrite (C e Hin) in He. discriminate. }
    rewrite Hf. reflexivity.
Qed.

Theorem d_in_node_full_input_absent :
  forall edges know H,
    forallb delay_declared edges = true ->
    (exists e, In e edges /\ flow_present e = false) ->
    d_in_node_full edges know H = Refused09 INPUT_ABSENT.
Proof.
  intros edges know H Hd [e [Hin He]]. unfold d_in_node_full. rewrite Hd. simpl.
  assert (Hf : forallb flow_present edges = false).
  { apply Bool.not_true_iff_false. intro C. rewrite forallb_forall in C.
    rewrite (C e Hin) in He. discriminate. }
  rewrite Hf. reflexivity.
Qed.
