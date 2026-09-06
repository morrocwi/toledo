(* EQ-015/H.30.v1 — CAN-099 — Definition — parents: EQ-015/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_HCA.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-099 — HCA-candidate-state

    (* CAN-099 — root: Z_{HCA,i,n} = <P^live,K^life,B^bar,C^cand,C^live,h,R^return_H,Omega^real> — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation for
    this exact bundling id (its own eight components are individually
    covered by CAN-057/100/102/103/077/105). A typed eight-field record
    composing those already-typed components. *)

Section CAN_099_HCACandidateState.

  Variables PLiveT KLifeT BBarT CCandT CLiveT HT RReturnT OmegaRealT : Type.

  Record HCACandidateState : Type := mkHCACandidateState
    { hcs_Plive : PLiveT ; hcs_Klife : KLifeT ; hcs_Bbar : BBarT
    ; hcs_Ccand : CCandT ; hcs_Clive : CLiveT ; hcs_h : HT
    ; hcs_Rreturn : RReturnT ; hcs_OmegaReal : OmegaRealT }.

  Definition CAN_099_hca_candidate_state := HCACandidateState.
  Definition CAN_099_mk_hca_candidate_state := mkHCACandidateState.

End CAN_099_HCACandidateState.

