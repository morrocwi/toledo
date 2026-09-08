Require Coq.Arith.PeanoNat.
Require Coq.Bool.Bool.
Require Coq.Classes.Morphisms.
Require Coq.Classes.RelationClasses.
Require Coq.Lists.List.
Require Coq.Logic.Classical.
Require Coq.QArith.QArith.
Require Coq.Setoids.Setoid.
Require Coq.Sorting.Permutation.
Require Coq.ZArith.ZArith.
Require Coq.micromega.Lia.
Require Coq.micromega.Lqa.
Require Field.
Require Lia.
Require List.
Require PeanoNat.
Require Permutation.
Require QArith.
Require Qabs.
Require Qminmax.
Require Qround.
Require Wf_nat.
Require ZArith.

Module URCF13Metric.

Import PeanoNat.
Import Wf_nat.
Import Lia.
Import ZArith.
Import QArith.
Import Field.
Import Qabs.
Import Qminmax.
Import Qround.
Import Coq.micromega.Lqa.
Open Scope nat_scope.

Inductive D : Type :=
  | zero : D
  | succ : D -> D.

Theorem RD3_succ_ne_zero : forall x : D, succ x <> zero.
Proof. intros x H. discriminate H. Qed.

Theorem RD4_succ_inj : forall x y : D, succ x = succ y -> x = y.
Proof. intros x y H. congruence. Qed.

Fixpoint add (x y : D) : D :=
  match y with zero => x | succ y' => succ (add x y') end.

Lemma add_zero : forall x, add x zero = x. Proof. reflexivity. Qed.
Lemma add_succ : forall x y, add x (succ y) = succ (add x y). Proof. reflexivity. Qed.
Lemma zero_add : forall x, add zero x = x.
Proof. induction x as [| x IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.
Lemma succ_add : forall x y, add (succ x) y = succ (add x y).
Proof. intros x y. induction y as [| y IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.
Theorem add_assoc : forall x y z, add (add x y) z = add x (add y z).
Proof. intros x y z. induction z as [| z IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.
Theorem add_comm : forall x y, add x y = add y x.
Proof. intros x y. induction y as [| y IH].
  - rewrite add_zero, zero_add. reflexivity.
  - rewrite add_succ, IH, succ_add. reflexivity. Qed.

Fixpoint mul (x y : D) : D :=
  match y with zero => zero | succ y' => add (mul x y') x end.

Lemma mul_zero : forall x, mul x zero = zero. Proof. reflexivity. Qed.
Lemma mul_succ : forall x y, mul x (succ y) = add (mul x y) x. Proof. reflexivity. Qed.
Lemma zero_mul : forall x, mul zero x = zero.
Proof. induction x as [| x IH]. - reflexivity. - rewrite mul_succ, IH, add_zero. reflexivity. Qed.
Theorem mul_add : forall x y z, mul x (add y z) = add (mul x y) (mul x z).
Proof. intros x y z. induction z as [| z IH].
  - rewrite add_zero, mul_zero, add_zero. reflexivity.
  - rewrite add_succ, mul_succ, IH, mul_succ, add_assoc. reflexivity. Qed.


Fixpoint toNat (x : D) : nat := match x with zero => O | succ x' => S (toNat x') end.
Fixpoint ofNat (n : nat) : D := match n with O => zero | S n' => succ (ofNat n') end.

Theorem iso_to_of : forall n, toNat (ofNat n) = n.
Proof. induction n as [| n IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.
Theorem iso_of_to : forall x, ofNat (toNat x) = x.
Proof. induction x as [| x IH]. - reflexivity. - simpl. rewrite IH. reflexivity. Qed.

Theorem toNat_inj : forall x y, toNat x = toNat y -> x = y.
Proof. intros x y H. rewrite <- (iso_of_to x), <- (iso_of_to y), H. reflexivity. Qed.

Theorem toNat_add : forall x y, toNat (add x y) = toNat x + toNat y.
Proof. intros x y. induction y as [| y IH].
  - simpl. rewrite Nat.add_0_r. reflexivity.
  - simpl. rewrite IH, Nat.add_succ_r. reflexivity. Qed.
Theorem toNat_mul : forall x y, toNat (mul x y) = toNat x * toNat y.
Proof. intros x y. induction y as [| y IH].
  - simpl. rewrite Nat.mul_0_r. reflexivity.
  - simpl. rewrite toNat_add, IH, Nat.mul_succ_r. reflexivity. Qed.


Definition dist (x y:D) : nat := (toNat x - toNat y) + (toNat y - toNat x).

Theorem dist_self : forall x, dist x x = 0.
Proof. intro x; unfold dist; lia. Qed.
Theorem dist_eq0  : forall x y, dist x y = 0 -> x = y.
Proof. intros x y H; apply toNat_inj; unfold dist in H; lia. Qed.
Theorem dist_pos  : forall x y, x <> y -> 0 < dist x y.
Proof. intros x y H; unfold dist; assert (toNat x <> toNat y) by (intro K; apply H, toNat_inj, K); lia. Qed.
Theorem dist_sym  : forall x y, dist x y = dist y x.
Proof. intros x y; unfold dist; lia. Qed.
Theorem dist_tri  : forall x y z, dist x z <= dist x y + dist y z.
Proof. intros x y z; unfold dist; lia. Qed.

Definition Betw (x y z:D) : Prop := dist x y + dist y z = dist x z.
Theorem Betw_id     : forall x y, Betw x y x -> x = y.
Proof. intros x y H; apply dist_eq0; unfold Betw in H; rewrite (dist_self x) in H; lia. Qed.
Theorem Betw_sym    : forall x y z, Betw x y z -> Betw z y x.
Proof. intros x y z H; unfold Betw in *.
  rewrite (dist_sym z y), (dist_sym y x), (dist_sym z x); lia. Qed.
Theorem Betw_refl_l : forall x z, Betw x x z.
Proof. intros x z; unfold Betw; rewrite (dist_self x); lia. Qed.

Definition dist2 (p q : D*D) : nat := dist (fst p)(fst q) + dist (snd p)(snd q).
Theorem dist2_self : forall p, dist2 p p = 0.
Proof. intros [a b]; unfold dist2; simpl; rewrite !dist_self; reflexivity. Qed.
Theorem dist2_eq0  : forall p q, dist2 p q = 0 -> p = q.
Proof. intros [a b][c d] H; unfold dist2 in H; simpl in H.
  assert (dist a c = 0) by lia. assert (dist b d = 0) by lia.
  rewrite (dist_eq0 a c), (dist_eq0 b d); auto. Qed.
Theorem dist2_sym  : forall p q, dist2 p q = dist2 q p.
Proof. intros [a b][c d]; unfold dist2; simpl; rewrite (dist_sym a c),(dist_sym b d); reflexivity. Qed.
Theorem dist2_tri  : forall p q r, dist2 p r <= dist2 p q + dist2 q r.
Proof. intros [a b][c d][e f]; unfold dist2; simpl.
  pose proof (dist_tri a c e); pose proof (dist_tri b d f); lia. Qed.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions dist_self.
Print Assumptions dist_eq0.
Print Assumptions dist_pos.
Print Assumptions dist_sym.
Print Assumptions dist_tri.
Print Assumptions Betw_id.
Print Assumptions Betw_sym.
Print Assumptions Betw_refl_l.
Print Assumptions dist2_self.
Print Assumptions dist2_eq0.
Print Assumptions dist2_sym.
Print Assumptions dist2_tri.

End URCF13Metric.
