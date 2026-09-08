(* weld/M.11.v1 — CAN-179 — Definition — parents: weld/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-179 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition — occurrences: 3 *)
(** K0<K1<K2<K3: a finite, closed [Inductive] staged order, injectively
    coded into [nat]; the ladder is strictly increasing at every step, a
    genuine (if small) [nat]-arithmetic theorem. *)
Inductive CAN179_KState := CAN179_K0 | CAN179_K1 | CAN179_K2 | CAN179_K3.
Definition CAN179_code (k : CAN179_KState) : nat :=
  match k with
  | CAN179_K0 => 0 | CAN179_K1 => 1 | CAN179_K2 => 2 | CAN179_K3 => 3
  end.
Definition CAN179_lt (k1 k2 : CAN179_KState) : Prop := (CAN179_code k1 < CAN179_code k2)%nat.
Theorem CAN179_ladder_strictly_increasing :
  CAN179_lt CAN179_K0 CAN179_K1 /\ CAN179_lt CAN179_K1 CAN179_K2 /\ CAN179_lt CAN179_K2 CAN179_K3.
Proof. unfold CAN179_lt; simpl; repeat split; lia. Qed.

