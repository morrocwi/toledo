(* ============================================================================
   UPL_Sorites_OneReversal.v -- scoping probe, NOT part of the committed corpus
   Narrow extension attempt beyond UPL_Sorites.v's declared monotone-only scope.

   Question: does T2 (flip_unique) survive if g is allowed EXACTLY ONE
   reversal -- i.e. g is monotone on [0,k) and monotone on [k,infinity),
   but the single adjacent pair (k-1,k) that straddles the split carries
   NO monotonicity constraint at all (g may drop arbitrarily there)?

   Result: flip points are confined to at most THREE candidates: at most
   one inside [0,k-2] (region 0), the single unconstrained straddling pair
   at a = k-1 itself (region 1, necessarily a single point), and at most
   one inside [k,infinity) (region 2). I.e. among any four flip points,
   two must coincide.
   ============================================================================ *)

Require Import Arith Lia.

Section SoritesOneReversal.
  Variable g : nat -> nat.
  Variable k : nat.                                 (* the single reversal site *)
  Hypothesis g_mono_left  : forall m n, m <= n -> n < k -> g m <= g n.
  Hypothesis g_mono_right : forall m n, k <= m -> m <= n -> g m <= g n.
  Variable Pi : nat.

  Definition H (n : nat) : bool := Nat.leb Pi (g n).
  Definition flip_at (a : nat) : Prop := H a = false /\ H (S a) = true.

  Lemma H_mono_left : forall m n, m <= n -> n < k -> H m = true -> H n = true.
  Proof.
    intros m n Hmn Hnk Hm. unfold H in *.
    apply Nat.leb_le. apply Nat.leb_le in Hm.
    eapply Nat.le_trans; [exact Hm | apply (g_mono_left m n); assumption].
  Qed.

  Lemma H_mono_right : forall m n, k <= m -> m <= n -> H m = true -> H n = true.
  Proof.
    intros m n Hkm Hmn Hm. unfold H in *.
    apply Nat.leb_le. apply Nat.leb_le in Hm.
    eapply Nat.le_trans; [exact Hm | apply (g_mono_right m n); assumption].
  Qed.

  (* Two flips strictly inside the left piece coincide. *)
  Lemma flip_unique_left :
    forall a b, S a < k -> S b < k -> flip_at a -> flip_at b -> a = b.
  Proof.
    intros a b Hak Hbk [Ha1 Ha2] [Hb1 Hb2].
    destruct (Nat.lt_trichotomy a b) as [Hlt | [Heq | Hgt]]; auto.
    - exfalso.
      assert (Hb : H b = true) by (apply (H_mono_left (S a) b); [lia | lia | exact Ha2]).
      congruence.
    - exfalso.
      assert (Ha : H a = true) by (apply (H_mono_left (S b) a); [lia | lia | exact Hb2]).
      congruence.
  Qed.

  (* Two flips inside the right piece coincide. *)
  Lemma flip_unique_right :
    forall a b, k <= a -> k <= b -> flip_at a -> flip_at b -> a = b.
  Proof.
    intros a b Hka Hkb [Ha1 Ha2] [Hb1 Hb2].
    destruct (Nat.lt_trichotomy a b) as [Hlt | [Heq | Hgt]]; auto.
    - exfalso.
      assert (Hb : H b = true) by (apply (H_mono_right (S a) b); [lia | lia | exact Ha2]).
      congruence.
    - exfalso.
      assert (Ha : H a = true) by (apply (H_mono_right (S b) a); [lia | lia | exact Hb2]).
      congruence.
  Qed.

  (* Classify a candidate flip index into one of 3 regions:
     0 = strictly left piece, 1 = the single straddling site, 2 = right piece. *)
  Definition region (a : nat) : nat :=
    if Nat.ltb (S a) k then 0 else if Nat.leb k a then 2 else 1.

  Lemma region_bound : forall a, region a < 3.
  Proof. intro a; unfold region; destruct (Nat.ltb (S a) k), (Nat.leb k a); lia. Qed.

  (* Decode each region value back into the arithmetic fact it certifies. *)
  Lemma region_zero_iff : forall a, region a = 0 -> S a < k.
  Proof.
    intros a Hr. unfold region in Hr.
    destruct (Nat.ltb (S a) k) eqn:F1.
    - apply Nat.ltb_lt in F1. exact F1.
    - destruct (Nat.leb k a) eqn:F2; simpl in Hr; discriminate.
  Qed.

  Lemma region_two_iff : forall a, region a = 2 -> k <= a.
  Proof.
    intros a Hr. unfold region in Hr.
    destruct (Nat.ltb (S a) k) eqn:F1.
    - simpl in Hr. discriminate.
    - destruct (Nat.leb k a) eqn:F2; simpl in Hr.
      + apply Nat.leb_le in F2. exact F2.
      + discriminate.
  Qed.

  (* Region 1 is a single point: k - 1 (only reachable when k >= 1). *)
  Lemma region_one_is_k1 : forall a, region a = 1 -> a = k - 1.
  Proof.
    intros a Hr. unfold region in Hr.
    destruct (Nat.ltb (S a) k) eqn:F1.
    - simpl in Hr. discriminate.
    - destruct (Nat.leb k a) eqn:F2; simpl in Hr.
      + discriminate.
      + apply Nat.ltb_ge in F1. apply Nat.leb_gt in F2. lia.
  Qed.

  Lemma same_region_same_flip :
    forall a b, flip_at a -> flip_at b -> region a = region b -> a = b.
  Proof.
    intros a b Fa Fb Hreg.
    destruct (Nat.eq_dec (region a) 0) as [E0|E0].
    - assert (Hb0 : region b = 0) by (rewrite <- Hreg; exact E0).
      apply (flip_unique_left a b (region_zero_iff a E0) (region_zero_iff b Hb0) Fa Fb).
    - destruct (Nat.eq_dec (region a) 1) as [E1|E1].
      + assert (Hb1 : region b = 1) by (rewrite <- Hreg; exact E1).
        rewrite (region_one_is_k1 a E1). rewrite (region_one_is_k1 b Hb1). reflexivity.
      + assert (E2 : region a = 2) by (pose proof (region_bound a); lia).
        assert (Hb2 : region b = 2) by (rewrite <- Hreg; exact E2).
        apply (flip_unique_right a b (region_two_iff a E2) (region_two_iff b Hb2) Fa Fb).
  Qed.

  (* T2' -- the one-reversal generalization of flip_unique: among any four
     flip points, at least two coincide (pigeonhole over 3 regions). *)
  Theorem flip_bound_three :
    forall a b c d,
      flip_at a -> flip_at b -> flip_at c -> flip_at d ->
      a = b \/ a = c \/ a = d \/ b = c \/ b = d \/ c = d.
  Proof.
    intros a b c d Fa Fb Fc Fd.
    pose proof (region_bound a) as Ra.
    pose proof (region_bound b) as Rb.
    pose proof (region_bound c) as Rc.
    pose proof (region_bound d) as Rd.
    assert (Hpigeon :
      region a = region b \/ region a = region c \/ region a = region d \/
      region b = region c \/ region b = region d \/ region c = region d) by lia.
    destruct Hpigeon as [Hp|[Hp|[Hp|[Hp|[Hp|Hp]]]]].
    - left. apply (same_region_same_flip a b Fa Fb Hp).
    - right; left. apply (same_region_same_flip a c Fa Fc Hp).
    - right; right; left. apply (same_region_same_flip a d Fa Fd Hp).
    - right; right; right; left. apply (same_region_same_flip b c Fb Fc Hp).
    - right; right; right; right; left. apply (same_region_same_flip b d Fb Fd Hp).
    - right; right; right; right; right. apply (same_region_same_flip c d Fc Fd Hp).
  Qed.

End SoritesOneReversal.

Print Assumptions flip_bound_three.
