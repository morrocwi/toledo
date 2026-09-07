(* EQ-001/P.09.v1 -- Toledo v1.1 lane B2 -- Th_coqc *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Definition EQ001_P09_IsSkew (n : nat) (M : nat -> nat -> Q) : Prop :=
  forall i j, (i < n)%nat -> (j < n)%nat -> M i j == - M j i.

Theorem EQ001_P09_zero_skew : forall n, EQ001_P09_IsSkew n (fun _ _ => 0).
Proof. intros n i j _ _. lra. Qed.

Theorem EQ001_P09_add_skew :
  forall n M N, EQ001_P09_IsSkew n M -> EQ001_P09_IsSkew n N ->
    EQ001_P09_IsSkew n (fun i j => M i j + N i j).
Proof.
  intros n M N HM HN i j Hi Hj. rewrite (HM i j Hi Hj), (HN i j Hi Hj). ring.
Qed.

Theorem EQ001_P09_neg_skew :
  forall n M, EQ001_P09_IsSkew n M -> EQ001_P09_IsSkew n (fun i j => - M i j).
Proof. intros n M HM i j Hi Hj. rewrite (HM i j Hi Hj). ring. Qed.
