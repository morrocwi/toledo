(* weld/E.03.v1 — CAN-031 — Definition — parents: weld/M.03.v1 — occurrences 18 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-031 — root: readout-admission-order (CAN-005) reading — domain:
   epistemic — tier: Definition — occurrences: 2 *)
(** sigma_K(p) in {ADMITTED, LOCAL, TRANSPORTABLE, UNRESOLVED, OBSTRUCTED,
    RETRACTED, SUPERSEDED}: knowledge as an auditable bounded status, not
    inherited from speaker identity — a finite, closed, decidable status
    enumeration. *)
Inductive CAN031_Status :=
  | CAN031_Admitted | CAN031_Local | CAN031_Transportable
  | CAN031_Unresolved | CAN031_Obstructed | CAN031_Retracted | CAN031_Superseded.

Definition CAN031_status_eq_dec : forall s1 s2 : CAN031_Status, {s1 = s2} + {s1 <> s2}.
Proof. decide equality. Defined.

Record CAN031_Admission (Claim : Type) : Type := mkCAN031Admission
  { c031_claim : Claim
  ; c031_status : CAN031_Status
  }.

