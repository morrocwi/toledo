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

Module URCF16QField.

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

Open Scope Z_scope.

(* ===== Q from Z: pair (p,q) with q<>0 represents p/q (field of fractions) ===== *)
Definition Qf := (Z * Z)%type.
Definition qok (x:Qf) : Prop := snd x <> 0.
Definition q0 : Qf := (0, 1).
Definition q1 : Qf := (1, 1).
Definition qadd (x y:Qf) : Qf := (fst x * snd y + fst y * snd x, snd x * snd y).
Definition qmul (x y:Qf) : Qf := (fst x * fst y, snd x * snd y).
Definition qneg (x:Qf) : Qf := (- fst x, snd x).
Definition qinv (x:Qf) : Qf := (snd x, fst x).

Definition qval (x:Qf) : Q := inject_Z (fst x) / inject_Z (snd x).
Definition qeq (x y:Qf) : Prop := qval x == qval y.

Lemma injZ_neq0 : forall z:Z, z <> 0 -> ~ (inject_Z z == 0).
Proof. intros z H C. apply H. apply inject_Z_injective. rewrite C. reflexivity. Qed.

(* qok is closed under the operations (Z is an integral domain) *)
Lemma qok_add : forall x y, qok x -> qok y -> qok (qadd x y).
Proof. intros x y Hx Hy; unfold qok, qadd; simpl; intro H; apply Zmult_integral in H; destruct H; auto. Qed.
Lemma qok_mul : forall x y, qok x -> qok y -> qok (qmul x y).
Proof. intros x y Hx Hy; unfold qok, qmul; simpl; intro H; apply Zmult_integral in H; destruct H; auto. Qed.
Lemma qok_neg : forall x, qok x -> qok (qneg x).
Proof. intros x Hx; unfold qok, qneg; simpl; exact Hx. Qed.
Lemma qok_inv : forall x, fst x <> 0 -> qok (qinv x).
Proof. intros x Hx; unfold qok, qinv; simpl; exact Hx. Qed.

(* value homomorphism into Coq's standard rationals *)
Lemma qval_q0 : qval q0 == 0. Proof. reflexivity. Qed.
Lemma qval_q1 : qval q1 == 1. Proof. reflexivity. Qed.
Lemma qval_add : forall x y, qok x -> qok y -> qval (qadd x y) == qval x + qval y.
Proof. intros [a b][c d] Hb Hd; unfold qval, qadd; simpl in *.
  rewrite inject_Z_plus, !inject_Z_mult; field; split; apply injZ_neq0; assumption. Qed.
Lemma qval_mul : forall x y, qok x -> qok y -> qval (qmul x y) == qval x * qval y.
Proof. intros [a b][c d] Hb Hd; unfold qval, qmul; simpl in *.
  rewrite !inject_Z_mult; field; split; apply injZ_neq0; assumption. Qed.
Lemma qval_neg : forall x, qok x -> qval (qneg x) == - qval x.
Proof. intros [a b] Hb; unfold qval, qneg; simpl in *.
  rewrite inject_Z_opp; field; apply injZ_neq0; assumption. Qed.
Ltac qE := unfold qeq.

(* equivalence *)
Theorem qeq_refl : forall x, qeq x x. Proof. intro; qE; reflexivity. Qed.
Theorem qeq_sym  : forall x y, qeq x y -> qeq y x. Proof. unfold qeq; intros x y H; symmetry; exact H. Qed.
Theorem qeq_trans: forall x y z, qeq x y -> qeq y z -> qeq x z. Proof. unfold qeq; intros x y z H1 H2; rewrite H1; exact H2. Qed.

(* commutative-ring axioms up to qeq (operands assumed qok) *)
Theorem qadd_comm : forall x y, qok x -> qok y -> qeq (qadd x y) (qadd y x).
Proof. intros x y Hx Hy; qE; rewrite (qval_add x y Hx Hy),(qval_add y x Hy Hx); ring. Qed.
Theorem qadd_assoc: forall x y z, qok x -> qok y -> qok z -> qeq (qadd (qadd x y) z)(qadd x (qadd y z)).
Proof. intros x y z Hx Hy Hz; qE;
  rewrite (qval_add (qadd x y) z (qok_add x y Hx Hy) Hz),(qval_add x y Hx Hy),
          (qval_add x (qadd y z) Hx (qok_add y z Hy Hz)),(qval_add y z Hy Hz); ring. Qed.
Theorem qadd_0_l  : forall x, qok x -> qeq (qadd q0 x) x.
Proof. intros x Hx; qE; rewrite (qval_add q0 x (ltac:(unfold qok,q0;simpl;lia)) Hx), qval_q0; ring. Qed.
Theorem qadd_neg  : forall x, qok x -> qeq (qadd x (qneg x)) q0.
Proof. intros x Hx; qE; rewrite (qval_add x (qneg x) Hx (qok_neg x Hx)), (qval_neg x Hx), qval_q0; ring. Qed.
Theorem qmul_comm : forall x y, qok x -> qok y -> qeq (qmul x y)(qmul y x).
Proof. intros x y Hx Hy; qE; rewrite (qval_mul x y Hx Hy),(qval_mul y x Hy Hx); ring. Qed.
Theorem qmul_assoc: forall x y z, qok x -> qok y -> qok z -> qeq (qmul (qmul x y) z)(qmul x (qmul y z)).
Proof. intros x y z Hx Hy Hz; qE;
  rewrite (qval_mul (qmul x y) z (qok_mul x y Hx Hy) Hz),(qval_mul x y Hx Hy),
          (qval_mul x (qmul y z) Hx (qok_mul y z Hy Hz)),(qval_mul y z Hy Hz); ring. Qed.
Theorem qmul_1_l  : forall x, qok x -> qeq (qmul q1 x) x.
Proof. intros x Hx; qE; rewrite (qval_mul q1 x (ltac:(unfold qok,q1;simpl;lia)) Hx), qval_q1; ring. Qed.
Theorem qmul_distrib_l : forall x y z, qok x -> qok y -> qok z -> qeq (qmul x (qadd y z))(qadd (qmul x y)(qmul x z)).
Proof. intros x y z Hx Hy Hz; qE;
  rewrite (qval_mul x (qadd y z) Hx (qok_add y z Hy Hz)),(qval_add y z Hy Hz),
          (qval_add (qmul x y)(qmul x z)(qok_mul x y Hx Hy)(qok_mul x z Hx Hz)),
          (qval_mul x y Hx Hy),(qval_mul x z Hx Hz); ring. Qed.

(* FIELD axiom: every nonzero element has a multiplicative inverse *)
Theorem qmul_inv : forall x, qok x -> fst x <> 0 -> qeq (qmul x (qinv x)) q1.
Proof.
  intros [a b] Hb Ha; unfold qeq, qval, qmul, qinv, q1, qok in *; simpl in *.
  rewrite !inject_Z_mult; field; split; apply injZ_neq0; assumption.
Qed.

Open Scope nat_scope.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions qeq_refl.
Print Assumptions qeq_sym.
Print Assumptions qeq_trans.
Print Assumptions qadd_comm.
Print Assumptions qadd_assoc.
Print Assumptions qadd_0_l.
Print Assumptions qadd_neg.
Print Assumptions qmul_comm.
Print Assumptions qmul_assoc.
Print Assumptions qmul_1_l.
Print Assumptions qmul_distrib_l.
Print Assumptions qmul_inv.

End URCF16QField.
