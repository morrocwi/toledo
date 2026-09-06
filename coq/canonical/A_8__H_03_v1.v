(* A.8/H.03.v1 — CAN-106 — Definition — parents: A.8/M.01.v1 — occurrences 2 *)

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
(** ** CAN-106 — net-advancement-record

    (* CAN-106 — root: A^HCA_i=<Gain,Loss,Transfer,Own,Burden,BarrierChange,OpportunityChange,Provenance,Warrant>; ATE_HCA(x)=E[Y(1)-Y(0)|Klife=x] — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition/measurement". Direct reuse of
    [MR_HCA.v] eq.(77)-(78): [NetAdvancementRecord]/[mk_net_advancement_
    record] and the finite-population estimand [ATE_HCA_78]. *)

Definition CAN_106_NetAdvancementRecord := MR_HCA.NetAdvancementRecord.
Definition CAN_106_mk_net_advancement_record := MR_HCA.mk_net_advancement_record.
Definition CAN_106_ATE_HCA := MR_HCA.ATE_HCA_78.

