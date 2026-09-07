(* EQ-001/P.08.v1 -- Toledo v1.1 lane B2 -- Th_coqc *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section EQ001_P08.
  Variable R : nat -> nat -> Q.
  Definition EQ001_P08_Diag (i j : nat) : Q := if Nat.eqb i j then R i j else 0.
  Definition EQ001_P08_Sym  (i j : nat) : Q := if Nat.eqb i j then 0 else (R i j + R j i) / 2.
  Definition EQ001_P08_Skew (i j : nat) : Q := if Nat.eqb i j then 0 else (R i j - R j i) / 2.

  Theorem EQ001_P08_decompose :
    forall i j, EQ001_P08_Diag i j + EQ001_P08_Sym i j + EQ001_P08_Skew i j == R i j.
  Proof.
    intros i j. unfold EQ001_P08_Diag, EQ001_P08_Sym, EQ001_P08_Skew.
    destruct (Nat.eqb i j); field.
  Qed.
End EQ001_P08.

(* exact rational witness with a genuinely nonzero SkewOff entry *)
Definition EQ001_P08_R0 (i j : nat) : Q :=
  match i, j with 0%nat, 1%nat => 3 | 1%nat, 0%nat => 1 | _, _ => 0 end.

Theorem EQ001_P08_skew_nonzero : ~ (EQ001_P08_Skew EQ001_P08_R0 0 1 == 0).
Proof.
  unfold EQ001_P08_Skew, EQ001_P08_R0. simpl. intro H.
  assert (Hb : Qeq_bool ((3-1)/2) 0 = true) by (apply Qeq_bool_iff; exact H).
  vm_compute in Hb. discriminate Hb.
Qed.
