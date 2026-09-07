(* EQ-001/C.12.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section EQ001_C12.
  Variable k : nat.

  Definition EQ001_C12_count (w : list nat) : list nat :=
    map (fun i => count_occ Nat.eq_dec w i) (seq 0 k).

  Theorem EQ001_C12_empty_word :
    EQ001_C12_count [] = map (fun _ => 0%nat) (seq 0 k).
  Proof. reflexivity. Qed.

  Theorem EQ001_C12_concat_additive :
    forall xs ys : list nat,
      EQ001_C12_count (xs ++ ys) =
      map (fun p => (fst p + snd p)%nat) (combine (EQ001_C12_count xs) (EQ001_C12_count ys)).
  Proof.
    intros xs ys. unfold EQ001_C12_count.
    induction (seq 0 k) as [| i rest IH]; simpl.
    - reflexivity.
    - f_equal.
      + apply count_occ_app.
      + exact IH.
  Qed.
End EQ001_C12.
