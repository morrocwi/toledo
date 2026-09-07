(* EQ-001/P.10.v1 -- Toledo v1.1 lane B2 -- Th_coqc *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* seed torsion genuine mixing: a nonzero SkewOff block, exact witness *)
Definition EQ001_P10_R0 (i j : nat) : Q :=
  match i, j with 0%nat, 1%nat => 5 | 1%nat, 0%nat => -1 | _, _ => 0 end.
Definition EQ001_P10_SkewOff (i j : nat) : Q :=
  if Nat.eqb i j then 0 else (EQ001_P10_R0 i j - EQ001_P10_R0 j i) / 2.

Theorem EQ001_P10_genuine_mixing : ~ (EQ001_P10_SkewOff 0 1 == 0).
Proof.
  unfold EQ001_P10_SkewOff, EQ001_P10_R0. simpl. intro H.
  assert (Hb : Qeq_bool ((5 - -1)/2) 0 = true) by (apply Qeq_bool_iff; exact H).
  vm_compute in Hb. discriminate Hb.
Qed.
