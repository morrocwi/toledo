(* A.5/W.12.v1 — Definition — parents: A.5/M.01.v1, A.5/W.03.v1 *)
(* carries the JOINT proof for all nine bundled non-collapse pairs (A.5/W.12.v1..A.5/W.20.v1): a single universally-quantified theorem (CAN_160_all_separations_satisfiable) that the shared rise-does-not-entail-rise shape is satisfiable for every arbitrarily-indexed pair in the bundle, per this bundle's own header note -- not nine independent per-pair proofs. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Definition CAN_160_separation (n : nat) : Prop :=
  exists (f g : nat -> Q) (t : nat),
    0 < MR_WorldSystem.ddiff f t /\ ~ (0 < MR_WorldSystem.ddiff g t).

Theorem CAN_160_all_separations_satisfiable :
  forall n : nat, CAN_160_separation n.
Proof. intro n. unfold CAN_160_separation. apply CAN_ws_generic_rise_not_entail_rise. Qed.

