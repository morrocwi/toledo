(* A.8/M.09.v1 — CAN-184 — finite_diagnostic — parents: A.8/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-184 — root: historical-invariance (CAN-009) — domain: method —
   tier: finite_diagnostic / Open — occurrences: 3 *)
Section CAN184_RecognitionConversion.
  Variables AuthorTy ProblemTy : Type.
  Variable A_s : AuthorTy -> ProblemTy -> nat -> Q.
  Definition CAN184_monotone_increase_Open : Prop :=
    forall (a : AuthorTy) (p : ProblemTy) (t : nat), A_s a p t < A_s a p (S t).
End CAN184_RecognitionConversion.
Inductive CAN184_PaperRole :=
  | CAN184_Paper1_Theme | CAN184_Paper2_SameThemeNewMechanism
  | CAN184_Paper3_EmpiricalTest | CAN184_Paper4_BoundaryExtension.

