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

Module URCF04Iso.

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


Theorem mul_comm : forall x y, mul x y = mul y x.
Proof. intros x y. rewrite <- (iso_of_to (mul x y)), <- (iso_of_to (mul y x)).
  rewrite !toNat_mul, (Nat.mul_comm (toNat x) (toNat y)). reflexivity. Qed.
Theorem mul_assoc : forall x y z, mul (mul x y) z = mul x (mul y z).
Proof. intros x y z. rewrite <- (iso_of_to (mul (mul x y) z)), <- (iso_of_to (mul x (mul y z))).
  rewrite !toNat_mul, (Nat.mul_assoc (toNat x) (toNat y) (toNat z)). reflexivity. Qed.

Definition one : D := succ zero.
Theorem mul_one : forall x, mul x one = x.
Proof. intro x. unfold one. rewrite mul_succ, mul_zero, zero_add. reflexivity. Qed.
Theorem one_mul : forall x, mul one x = x.
Proof. intro x. rewrite mul_comm. apply mul_one. Qed.
Theorem add_mul : forall x y z, mul (add x y) z = add (mul x z) (mul y z).
Proof. intros x y z. rewrite (mul_comm (add x y) z), mul_add, (mul_comm z x), (mul_comm z y). reflexivity. Qed.

Definition le (x y : D) : Prop := exists z, add x z = y.

Theorem le_refl : forall x, le x x.
Proof. intro x. exists zero. apply add_zero. Qed.
Theorem le_trans : forall x y z, le x y -> le y z -> le x z.
Proof. intros x y z [a Ha] [b Hb]. exists (add a b).
  rewrite <- add_assoc, Ha, Hb. reflexivity. Qed.

Theorem le_toNat : forall x y, le x y -> toNat x <= toNat y.
Proof. intros x y [z Hz]. rewrite <- Hz, toNat_add. apply Nat.le_add_r. Qed.
Theorem toNat_le : forall x y, toNat x <= toNat y -> le x y.
Proof. intros x y H. exists (ofNat (toNat y - toNat x)). apply toNat_inj.
  rewrite toNat_add, iso_to_of, Nat.add_comm. apply Nat.sub_add. exact H. Qed.

Theorem le_antisym : forall x y, le x y -> le y x -> x = y.
Proof. intros x y Hxy Hyx. apply toNat_inj. apply Nat.le_antisymm.
  - apply le_toNat, Hxy. - apply le_toNat, Hyx. Qed.
Theorem le_total : forall x y, le x y \/ le y x.
Proof. intros x y. destruct (Nat.le_ge_cases (toNat x) (toNat y)) as [H | H].
  - left. apply toNat_le, H. - right. apply toNat_le, H. Qed.

Theorem add_cancel_r : forall x y z, add x z = add y z -> x = y.
Proof. intros x y z H. apply toNat_inj.
  apply (proj1 (Nat.add_cancel_r (toNat x) (toNat y) (toNat z))).
  rewrite <- !toNat_add, H. reflexivity. Qed.


(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions iso_to_of.
Print Assumptions iso_of_to.
Print Assumptions toNat_inj.
Print Assumptions toNat_add.
Print Assumptions toNat_mul.
Print Assumptions le_toNat.
Print Assumptions toNat_le.

End URCF04Iso.
