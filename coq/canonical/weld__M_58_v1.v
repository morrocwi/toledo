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

Module URCF15Leibniz.

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

(* ===== Z as the Grothendieck completion of (D,+):  (a,b) represents a-b ===== *)
Definition Zr := (D * D)%type.
Definition zeq (z w:Zr) : Prop :=
  toNat (fst z) + toNat (snd w) = toNat (snd z) + toNat (fst w).
Definition z0 : Zr := (zero, zero).
Definition z1 : Zr := (succ zero, zero).
Definition zadd (z w:Zr) : Zr := (add (fst z)(fst w), add (snd z)(snd w)).
Definition zneg (z:Zr) : Zr := (snd z, fst z).
Definition zmul (z w:Zr) : Zr :=
  (add (mul (fst z)(fst w)) (mul (snd z)(snd w)),
   add (mul (fst z)(snd w)) (mul (snd z)(fst w))).
Definition zsub (z w:Zr) : Zr := zadd z (zneg w).

(* value homomorphism into the standard integers: proves Zr/zeq ~= Z (a ring) *)
Definition zval (z:Zr) : Z := (Z.of_nat (toNat (fst z)) - Z.of_nat (toNat (snd z)))%Z.

Lemma zeq_zval : forall z w, zeq z w <-> zval z = zval w.
Proof.
  intros z w; unfold zeq, zval; split; intro H.
  - assert (Z.of_nat (toNat (fst z) + toNat (snd w)) = Z.of_nat (toNat (snd z) + toNat (fst w))) by (rewrite H; reflexivity).
    rewrite !Nat2Z.inj_add in *; lia.
  - apply Nat2Z.inj; rewrite !Nat2Z.inj_add; lia.
Qed.
Lemma zval_z0 : zval z0 = 0%Z. Proof. reflexivity. Qed.
Lemma zval_z1 : zval z1 = 1%Z. Proof. reflexivity. Qed.
Lemma zval_add : forall z w, zval (zadd z w) = (zval z + zval w)%Z.
Proof. intros z w; unfold zval, zadd; simpl; rewrite !toNat_add, !Nat2Z.inj_add; lia. Qed.
Lemma zval_neg : forall z, zval (zneg z) = (- zval z)%Z.
Proof. intros z; unfold zval, zneg; simpl; lia. Qed.
Lemma zval_mul : forall z w, zval (zmul z w) = (zval z * zval w)%Z.
Proof. intros z w; unfold zval, zmul; simpl; rewrite !toNat_add, !toNat_mul, !Nat2Z.inj_add, !Nat2Z.inj_mul; ring. Qed.

Ltac zE := apply (proj2 (zeq_zval _ _));
  repeat (rewrite zval_add || rewrite zval_mul || rewrite zval_neg || rewrite zval_z0 || rewrite zval_z1).

(* equivalence *)
Theorem zeq_refl : forall z, zeq z z. Proof. intro z; apply zeq_zval; reflexivity. Qed.
Theorem zeq_sym  : forall z w, zeq z w -> zeq w z. Proof. intros z w; rewrite !zeq_zval; intro H; symmetry; exact H. Qed.
Theorem zeq_trans: forall z w u, zeq z w -> zeq w u -> zeq z u. Proof. intros z w u; rewrite !zeq_zval; intros H1 H2; rewrite H1; exact H2. Qed.

(* congruences *)
Theorem zadd_cong: forall z z' w w', zeq z z' -> zeq w w' -> zeq (zadd z w)(zadd z' w').
Proof. intros z z' w w'; rewrite !zeq_zval; intros H1 H2; rewrite !zval_add, H1, H2; reflexivity. Qed.
Theorem zneg_cong: forall z z', zeq z z' -> zeq (zneg z)(zneg z').
Proof. intros z z'; rewrite !zeq_zval; intro H; rewrite !zval_neg, H; reflexivity. Qed.
Theorem zmul_cong: forall z z' w w', zeq z z' -> zeq w w' -> zeq (zmul z w)(zmul z' w').
Proof. intros z z' w w'; rewrite !zeq_zval; intros H1 H2; rewrite !zval_mul, H1, H2; reflexivity. Qed.

(* commutative RING axioms (up to zeq) *)
Theorem zadd_comm : forall z w, zeq (zadd z w)(zadd w z). Proof. intros; zE; ring. Qed.
Theorem zadd_assoc: forall z w u, zeq (zadd (zadd z w) u)(zadd z (zadd w u)). Proof. intros; zE; ring. Qed.
Theorem zadd_0_l  : forall z, zeq (zadd z0 z) z. Proof. intros; zE; ring. Qed.
Theorem zadd_neg  : forall z, zeq (zadd z (zneg z)) z0. Proof. intros; zE; ring. Qed.
Theorem zmul_comm : forall z w, zeq (zmul z w)(zmul w z). Proof. intros; zE; ring. Qed.
Theorem zmul_assoc: forall z w u, zeq (zmul (zmul z w) u)(zmul z (zmul w u)). Proof. intros; zE; ring. Qed.
Theorem zmul_1_l  : forall z, zeq (zmul z1 z) z. Proof. intros; zE; ring. Qed.
Theorem zmul_distrib_l : forall z w u, zeq (zmul z (zadd w u)) (zadd (zmul z w)(zmul z u)).
Proof. intros; zE; ring. Qed.

(* ===== DISCRETE CALCULUS over Z-valued sequences  f : D -> Zr ===== *)
Definition Delta (f:D->Zr)(n:D) : Zr := zsub (f (succ n)) (f n).

Lemma zval_sub : forall z w, zval (zsub z w) = (zval z - zval w)%Z.
Proof. intros z w; unfold zsub; rewrite zval_add, zval_neg; ring. Qed.
Lemma zval_Delta : forall f n, zval (Delta f n) = (zval (f (succ n)) - zval (f n))%Z.
Proof. intros f n; unfold Delta; apply zval_sub. Qed.

(* discrete LEIBNIZ (product) rule *)
Theorem Leibniz :
  forall f g n,
    zeq (Delta (fun k => zmul (f k) (g k)) n)
        (zadd (zmul (f (succ n)) (Delta g n)) (zmul (Delta f n) (g n))).
Proof.
  intros f g n; apply (proj2 (zeq_zval _ _)).
  rewrite (zval_Delta (fun k => zmul (f k) (g k)) n).
  rewrite !zval_mul. rewrite zval_add, !zval_mul, !zval_Delta. ring.
Qed.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions Leibniz.

End URCF15Leibniz.
