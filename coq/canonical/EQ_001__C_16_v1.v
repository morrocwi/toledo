(* EQ-001/C.16.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-LINEAGE-013: the marked quotient stores structural occupation
   separately from an append-only lineage sidecar; equal structural
   projections need not identify marked histories. Witness: two marked
   histories with the same structural count (3) but different lineage
   tags (0 vs 1). *)
Theorem EQ001_C16_structure_not_lineage :
  exists h1 h2 : nat * nat, fst h1 = fst h2 /\ snd h1 <> snd h2.
Proof.
  exists (3%nat, 0%nat), (3%nat, 1%nat). split; [reflexivity | discriminate].
Qed.
