(* ============================================================================
   UPL_Sorites.v -- UPL brick 1 (target tier: Th_coqc, axiom-free over nat)
   Machine-checked core of LTP2 / book chapter 8:
     world-side: a MONOTONE graded quantity g : nat -> nat
     knower-side: binary threshold readout  H(n) := (Pi <=? g n)
   Theorems:
     T1 readout_monotone          : the readout never flips back
     T2 flip_unique               : at most ONE flip point exists
     T3 tolerance_violation_iff_flip : the 'sorites step' (H n <> H (S n))
                                       happens EXACTLY at the flip point
     T4 threshold_order           : a higher threshold can only delay truth
   Reading: the paradoxical step is a property of the Pi-READOUT, provably not
   of the graded world-side g. (Discrete core; no Reals, no classical axioms.)
   ============================================================================ *)

Require Import Arith Lia.

Section Sorites.
  Variable g  : nat -> nat.                       (* world-side graded quantity *)
  Hypothesis g_mono : forall m n, m <= n -> g m <= g n.
  Variable Pi : nat.                              (* retention threshold (RAR: Pi) *)

  Definition H (n : nat) : bool := Nat.leb Pi (g n).

  (* T1 *)
  Lemma readout_monotone : forall m n, m <= n -> H m = true -> H n = true.
  Proof.
    intros m n Hmn Hm. unfold H in *.
    apply Nat.leb_le. apply Nat.leb_le in Hm.
    eapply Nat.le_trans; [exact Hm | apply g_mono; exact Hmn].
  Qed.

  Definition flip_at (a : nat) : Prop := H a = false /\ H (S a) = true.

  (* T2 -- the sorites 'cut' exists at most once *)
  Theorem flip_unique : forall a b, flip_at a -> flip_at b -> a = b.
  Proof.
    intros a b [Ha1 Ha2] [Hb1 Hb2].
    destruct (Nat.lt_trichotomy a b) as [Hlt | [Heq | Hgt]]; auto.
    - exfalso.
      assert (Hb : H b = true).
      { apply (readout_monotone (S a) b); [lia | exact Ha2]. }
      congruence.
    - exfalso.
      assert (Ha : H a = true).
      { apply (readout_monotone (S b) a); [lia | exact Hb2]. }
      congruence.
  Qed.

  (* T3 -- the 'paradoxical step' is located EXACTLY at the flip *)
  Theorem tolerance_violation_iff_flip :
    forall n, H n <> H (S n) <-> flip_at n.
  Proof.
    intro n. unfold flip_at.
    destruct (H n) eqn:E1; destruct (H (S n)) eqn:E2.
    - split; [congruence | intros [F _]; congruence].
    - (* true -> false is impossible: readout is monotone *)
      exfalso.
      assert (Hs : H (S n) = true).
      { apply (readout_monotone n (S n)); [lia | exact E1]. }
      congruence.
    - split; [intros _; auto | congruence].
    - split; [congruence | intros [_ F]; congruence].
  Qed.

End Sorites.

Section TwoThresholds.
  Variable g : nat -> nat.
  Variables Pi1 Pi2 : nat.
  Hypothesis HPi : Pi1 <= Pi2.

  (* T4 -- the flip point tracks the threshold ordering (LTP2-C3, proof-grade) *)
  Theorem threshold_order :
    forall n, Nat.leb Pi2 (g n) = true -> Nat.leb Pi1 (g n) = true.
  Proof.
    intros n Hn. apply Nat.leb_le. apply Nat.leb_le in Hn. lia.
  Qed.
End TwoThresholds.

(* axiom audit -- must print 'Closed under the global context' for Th_coqc *)
Print Assumptions flip_unique.
Print Assumptions tolerance_violation_iff_flip.
Print Assumptions threshold_order.
