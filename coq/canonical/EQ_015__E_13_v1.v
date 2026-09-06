(* EQ-015/E.13.v1 — CAN-207 — Definition — parents: EQ-015/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-207 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** S_{A,t} := q_{sem,A,Omega_t}(Z_t): the live semantic-field state as a
    declared quotient of the raw readout stream. *)
Section CAN207_SemanticQuotientReading.
  Variables RawStream SemanticField : Type.
  Variable q_sem : RawStream -> SemanticField.
  Definition CAN207_S_A := q_sem.
End CAN207_SemanticQuotientReading.

