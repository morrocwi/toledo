(* EQ-001/C.06.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section EQ001_C06.
  Variable k : nat.
  Variable genval : nat -> Q.

  (* free-commutative-monoid element represented by its occupation counts,
     as a finite-support function nat -> nat over indices 0..k-1 *)
  Definition EQ001_C06_R (c : nat -> nat) : Q :=
    fold_right (fun i acc => (Z.of_nat (c i) # 1) * genval i + acc) 0 (seq 0 k).

  Theorem EQ001_C06_additive :
    forall c d : nat -> nat,
      EQ001_C06_R (fun i => (c i + d i)%nat) == EQ001_C06_R c + EQ001_C06_R d.
  Proof.
    intros c d. unfold EQ001_C06_R.
    induction (seq 0 k) as [| i rest IH]; simpl.
    - lra.
    - rewrite Nat2Z.inj_add. rewrite IH.
      assert (H : (Z.of_nat (c i) + Z.of_nat (d i) # 1) ==
                  (Z.of_nat (c i) # 1) + (Z.of_nat (d i) # 1)) by (unfold Qeq; simpl; ring).
      rewrite H. ring.
  Qed.
End EQ001_C06.
