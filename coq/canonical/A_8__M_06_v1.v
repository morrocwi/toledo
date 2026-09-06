(* A.8/M.06.v1 — CAN-178 — Definition — parents: A.8/M.01.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-178 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 4 *)
Section CAN178_ScholarlyCapital.
  Variables I0 R0 N0 P0 : Q.
  Definition CAN178_K0_start : Q := I0 + R0 + N0 + P0.

  Variables Qv Cv Vv Uv Xv Tv : Q.
  Variable f178 : Q -> Q -> Q -> Q -> Q -> Q -> Q.
  Definition CAN178_E_t : Q := f178 Qv Cv Vv Uv Xv Tv.

  Variables Access LanguageQ SituatedObservation TranslationCapacity TrustQ : Q.
  Definition CAN178_PosCap : Q := Access * LanguageQ * SituatedObservation * TranslationCapacity * TrustQ.

  Variables P_A Co Bi : Q.
  Definition CAN178_NetPractice : Q := P_A - (Co + Bi).
End CAN178_ScholarlyCapital.

(* ==================================================================== *)
(** ** Group 5 — the knowledge-state ladder, epistemic isolation, and
    bottleneck inversion (CAN-179..181) *)

