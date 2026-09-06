(* EQ-002/E.10.v1 — CAN-204 — Definition — parents: EQ-002/M.03.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-204 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** O_A[n] = Pi_A(E[n]); enc_A(O_A)[n] = T_A(O_A[n]): selection-then-
    encoding decomposition of an observation into a translated record. *)
Section CAN204_EncoderPipeline.
  Variables Event Observation Encoded : Type.
  Variable Pi_A : Event -> Observation.
  Variable T_A : Observation -> Encoded.
  Definition CAN204_O_A := Pi_A.
  Definition CAN204_enc_A (e : Event) : Encoded := T_A (Pi_A e).
End CAN204_EncoderPipeline.

