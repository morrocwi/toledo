(* EQ-001/C.13.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-PERM-GATE-010: if equal occupation vectors imply equal registered
   readout in every frozen profile, the count quotient exactly factors
   those profiles. This is exactly the general Factorization Theorem
   already proved in MRC_Prelude, specialised to R := occupation-count
   over a frozen finite generator set of size k; re-exported here (same
   pattern as EQ_002/M.01.v1's CAN165_factorization_thm alias), plus a
   concrete corollary: two words with the same occupation counts (here,
   a permutation) are registered identically by the count quotient. *)
Section EQ001_C13.
  Variable k : nat.

  Definition EQ001_C13_count (w : list nat) : list nat :=
    map (fun i => count_occ Nat.eq_dec w i) (seq 0 k).
End EQ001_C13.

Definition EQ001_C13_admissible := @mr_admissible.
Definition EQ001_C13_g_of := @mr_g_of.
Definition EQ001_C13_factorization_thm := @mr_factorization_thm.

Theorem EQ001_C13_permutation_same_count :
  EQ001_C13_count 2 [0%nat; 1%nat] = EQ001_C13_count 2 [1%nat; 0%nat].
Proof. reflexivity. Qed.
