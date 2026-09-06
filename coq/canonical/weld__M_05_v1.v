(* weld/M.05.v1 — CAN-167 — Definition — parents: weld/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-167 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition — occurrences: 3 *)
(** A problem is a retained residual (r_t = A*eps_t - delta_t, a finite
    [Q]-valued discrepancy, with the quadratic cost V_t = (1/2) w r_t^2 as
    its scalar bookkeeping surrogate for the source's r^T W r); a question
    is an abstract selection out of the retained residual. *)
Definition CAN167_residual (A eps delta : Q) : Q := A * eps - delta.
Definition CAN167_cost (w r : Q) : Q := (1#2) * w * r * r.

Section CAN167_Retention.
  Variables ResidualTy RetainedProblem ContrastTy : Type.
  Variable Retain_Pi : ResidualTy -> RetainedProblem.
  Variable Question_Pi : RetainedProblem -> ContrastTy.
  Definition CAN167_problem := Retain_Pi.
  Definition CAN167_question_selects := Question_Pi.
End CAN167_Retention.

