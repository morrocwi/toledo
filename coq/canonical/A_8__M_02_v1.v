(* A.8/M.02.v1 — CAN-171 — Definition — parents: A.8/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-171 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 2 *)
Section CAN171_ProvenanceLedger.
  Variables ProvTy TierTy DefectTy ReaderTy FalsifierTy : Type.
  Record CAN171_LedgerEntry := CAN171_mkEntry {
    can171_prov : ProvTy;
    can171_tier : TierTy;
    can171_defect : DefectTy;
    can171_reader : ReaderTy;
    can171_falsifier : FalsifierTy
  }.
End CAN171_ProvenanceLedger.

