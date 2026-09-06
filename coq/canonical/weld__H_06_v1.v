(* weld/H.06.v1 — CAN-065 — Definition — parents: weld/M.02.v1 — occurrences 2 *)

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
(** ** CAN-065 — domain-weld-defect

    (* CAN-065 — root: eps_H = Def(qtilde_H.F, F#_H.qtilde_H, O_H, Inv_H) — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. A
    domain-weld defect readout: a [Q]-valued measure of how far a
    candidate translation [q_tilde_H] is from satisfying the CAN-006
    admissibility condition it is being tested against — typed as an
    abstract declared function of the four named ingredients, Definition
    tier only, no proof obligation. *)

Section CAN_065_DomainWeldDefect.

  Variables ZH_T InvT : Type.
  Variable q_tilde_H F_H F_hash_H : ZH_T -> ZH_T.
  Variable O_H2 : ZH_T -> ZH_T.
  Variable Inv_H : ZH_T -> InvT.
  Variable Def : (ZH_T -> ZH_T) -> (ZH_T -> ZH_T) -> (ZH_T -> ZH_T) -> (ZH_T -> InvT) -> Q.

  Definition CAN_065_domain_weld_defect : Q :=
    Def (fun z => q_tilde_H (F_H z)) (fun z => F_hash_H (q_tilde_H z)) O_H2 Inv_H.

End CAN_065_DomainWeldDefect.

