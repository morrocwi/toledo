(* =====================================================================
   RDL_StarRigMatrixN_Step2.v
   ---------------------------------------------------------------------
   Discharging the GENERAL theorem (RDL_StarRigCPTP_General.v) for LITERAL
   n x n integer matrices -- step 2: the MULTIPLICATIVE *-ring completes.

   Step 1 (RDL_StarRigMatrixN.v) discharged trace_add, trace_cyc (trace
   cyclicity for all n), adj_mul, mul_add_l, mul_0_l.  This file adds:

        mul_1_l , mul_1_r   (mmul_one_l , mmul_one_r)  -- identity law,
                                                          via a Kronecker
                                                          delta sum lemma
        mul_assoc           (mmul_assoc)               -- associativity,
                                                          via sum-mul push
                                                          + finite Fubini

   Only the POSITIVE CONE (psd_* ) then remains for full CPTP at n x n
   (step 3, the quadratic-form conjugation identity).  RDL_StarRigMatrix3.v
   already exhibits all of it for n = 3.

   SELF-CONTAINED; FUNEXT-FREE (pointwise meq).  Identity carries the
   dimension bound (i,j < n), as the function representation requires.

   STATUS: candidate.  Must pass `coqc 8.18.0`; `Print Assumptions` must
   report "Closed under the global context".  mmul_assoc uses a
   `setoid_rewrite` choreography -- the highest-syntax-risk part.
   ===================================================================== *)

Require Import ZArith.
Require Import Arith.
Require Import Lia.
Require Import Setoid.
Open Scope Z_scope.

(* =====================================================================
   Finite-sum engine.
   ===================================================================== *)
Fixpoint sumZ (n : nat) (f : nat -> Z) : Z :=
  match n with O => 0 | S k => sumZ k f + f k end.

Lemma sumZ_ext : forall n f g,
  (forall i, (i < n)%nat -> f i = g i) -> sumZ n f = sumZ n g.
Proof.
  induction n; intros f g H; simpl.
  - reflexivity.
  - rewrite (H n) by lia. f_equal. apply IHn. intros i Hi. apply H. lia.
Qed.

Lemma sumZ_zero : forall n, sumZ n (fun _ => 0) = 0.
Proof. induction n; simpl; [reflexivity | rewrite IHn; ring]. Qed.

Lemma sumZ_add : forall n f g,
  sumZ n (fun i => f i + g i) = sumZ n f + sumZ n g.
Proof. induction n; intros; simpl; [ring | rewrite IHn; ring]. Qed.

Lemma sumZ_mul_l : forall n c f,
  sumZ n (fun k => c * f k) = (c * sumZ n f)%Z.
Proof. intros n c f. induction n; simpl; [ring | rewrite IHn; ring]. Qed.

Lemma sumZ_mul_r : forall n c f,
  sumZ n (fun k => f k * c) = (sumZ n f * c)%Z.
Proof. intros n c f. induction n; simpl; [ring | rewrite IHn; ring]. Qed.

(* finite Fubini *)
Lemma sumZ_swap : forall n m f,
  sumZ n (fun i => sumZ m (fun j => f i j))
  = sumZ m (fun j => sumZ n (fun i => f i j)).
Proof.
  induction n; intros m f; simpl.
  - symmetry. apply sumZ_zero.
  - rewrite (IHn m f).
    rewrite <- (sumZ_add m (fun j => sumZ n (fun i => f i j)) (fun j => f n j)).
    apply sumZ_ext. intros j Hj. reflexivity.
Qed.

(* =====================================================================
   Kronecker-delta sum lemmas (the heart of the identity law).
   ===================================================================== *)
Lemma sumZ_delta_out : forall n j g,
  (n <= j)%nat ->
  sumZ n (fun k => g k * (if Nat.eqb k j then 1 else 0)) = 0.
Proof.
  induction n; intros j g H; simpl.
  - reflexivity.
  - rewrite IHn by lia.
    assert (Nat.eqb n j = false) as E by (apply Nat.eqb_neq; lia).
    rewrite E. ring.
Qed.

Lemma sumZ_delta : forall n j g,
  (j < n)%nat ->
  sumZ n (fun k => g k * (if Nat.eqb k j then 1 else 0)) = g j.
Proof.
  induction n; intros j g H; simpl.
  - lia.
  - destruct (Nat.eq_dec j n) as [E | E].
    + subst j. rewrite sumZ_delta_out by lia.
      assert ((if Nat.eqb n n then 1 else 0) = 1%Z) as E1
        by (rewrite Nat.eqb_refl; reflexivity).
      rewrite E1. ring.
    + assert (Nat.eqb n j = false) as E2 by (apply Nat.eqb_neq; lia).
      rewrite E2. rewrite IHn by lia. cbn. ring.
Qed.

Lemma sumZ_delta_l : forall n i g,
  (i < n)%nat ->
  sumZ n (fun k => (if Nat.eqb i k then 1 else 0) * g k) = g i.
Proof.
  intros n i g H.
  rewrite (sumZ_ext n
             (fun k => (if Nat.eqb i k then 1 else 0) * g k)
             (fun k => g k * (if Nat.eqb k i then 1 else 0))).
  - apply sumZ_delta. exact H.
  - intros k Hk. rewrite (Nat.eqb_sym i k). ring.
Qed.

(* =====================================================================
   n x n integer matrices.
   ===================================================================== *)
Definition Mat := nat -> nat -> Z.
Definition mmul (n : nat) (A B : Mat) : Mat :=
  fun i j => sumZ n (fun k => A i k * B k j).
Definition mid : Mat := fun i j => if Nat.eqb i j then 1 else 0.
Definition meq (A B : Mat) : Prop := forall i j, A i j = B i j.

Lemma mmul_unfold : forall n A B i j,
  mmul n A B i j = sumZ n (fun k => A i k * B k j).
Proof. reflexivity. Qed.

(* =====================================================================
   IDENTITY LAW (discharges mul_1_l, mul_1_r), with the dimension bound.
   ===================================================================== *)
Theorem mmul_one_r : forall n A i j,
  (j < n)%nat -> mmul n A mid i j = A i j.
Proof.
  intros n A i j H. rewrite mmul_unfold. unfold mid. cbn.
  apply sumZ_delta. exact H.
Qed.

Theorem mmul_one_l : forall n A i j,
  (i < n)%nat -> mmul n mid A i j = A i j.
Proof.
  intros n A i j H. rewrite mmul_unfold. unfold mid. cbn.
  apply (sumZ_delta_l n i (fun k => A k j) H).
Qed.

(* =====================================================================
   ASSOCIATIVITY (discharges mul_assoc) -- pointwise for all i,j.
   (A B) C = A (B C):  both collapse to sum_{k,l} A i l * B l k * C k j.
   ===================================================================== *)
Theorem mmul_assoc : forall n A B C,
  meq (mmul n (mmul n A B) C) (mmul n A (mmul n B C)).
Proof.
  intros n A B C i j.
  (* After unfolding, LHS = sumZ n (fun k => mmul n A B i k * C k j)
                      RHS = sumZ n (fun l => A i l * mmul n B C l j) *)
  rewrite !mmul_unfold.
  (* Rewrite mmul_unfold inside LHS sum *)
  transitivity (sumZ n (fun k => sumZ n (fun l => A i l * B l k) * C k j)).
  { apply sumZ_ext; intros k Hk. rewrite mmul_unfold. reflexivity. }
  (* Push C k j inside the inner sum: sumZ n (fun k => sumZ n (fun l => A i l * B l k * C k j)) *)
  transitivity (sumZ n (fun k => sumZ n (fun l => A i l * B l k * C k j))).
  { apply sumZ_ext; intros k Hk. rewrite <- sumZ_mul_r.
    apply sumZ_ext; intros l Hl. ring. }
  (* Swap summation order *)
  transitivity (sumZ n (fun l => sumZ n (fun k => A i l * B l k * C k j))).
  { apply sumZ_swap. }
  (* Pull A i l outside the inner sum *)
  transitivity (sumZ n (fun l => A i l * sumZ n (fun k => B l k * C k j))).
  { apply sumZ_ext; intros l Hl. rewrite <- sumZ_mul_l.
    apply sumZ_ext; intros k Hk. ring. }
  (* Fold mmul_unfold for RHS *)
  apply sumZ_ext; intros l Hl. rewrite mmul_unfold. reflexivity.
Qed.

(* =====================================================================
   AXIOM AUDIT.
   ===================================================================== *)
Print Assumptions mmul_one_r.
Print Assumptions mmul_one_l.
Print Assumptions mmul_assoc.
Print Assumptions sumZ_delta.

(* End RDL_StarRigMatrixN_Step2.v *)
