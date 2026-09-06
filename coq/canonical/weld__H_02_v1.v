(* weld/H.02.v1 — CAN-051 — Definition — parents: weld/M.02.v1 — occurrences 7 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Require Import MR.MR_Prompt.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-051 — horizon-triad

    (* CAN-051 — root: Hdyn: Delta_A(lam)=0; Hinfo(A); Hphen(A); Hdyn--DI_K-->Hinfo--IP_K-->Hphen — domain: human–AI — tier: Open — occurrences: 7 *)

    CANONICAL.json tier: "definition / hypothesis-Open (the weld itself,
    bridge IP_K explicitly open)". No Master River eq. citation (Readout
    Genesis Standalone Synthesis eq.(50)-(55), record 21529456). The three
    horizons are typed as [Prop]-valued readout predicates on an agent
    state; the two connecting bridges are typed but, per the source's own
    explicit "bridge IP_K explicitly open" tag, left un-proved [Prop]s
    (house rule: never upgrade Open -> Prop, no proof). *)

Section CAN_051_HorizonTriad.

  Variables AgentSt : Type.
  Variable H_dyn H_info H_phen : AgentSt -> Prop.

  Definition CAN_051_horizon_triad (a : AgentSt) : Prop :=
    H_dyn a \/ H_info a \/ H_phen a.

  Definition CAN_051_Open_dynamic_to_information_bridge : Prop :=
    forall a : AgentSt, H_dyn a -> H_info a.

  Definition CAN_051_Open_information_to_phenomenal_bridge : Prop :=
    forall a : AgentSt, H_info a -> H_phen a.

End CAN_051_HorizonTriad.

