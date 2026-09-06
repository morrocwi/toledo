(* weld/H.05.v1 — CAN-064 — Definition — parents: weld/M.03.v1 — occurrences 2 *)

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
(** ** CAN-064 — human-ai-transport

    (* CAN-064 — root: T_{H<-AI}.K_AI =~ K_H.T_C, with defects (semantic loss, source omission, authority laundering, uncertainty compression, context mismatch) — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition (transport condition, Maker-Checker
    firewall)". No Master River eq. citation (Readout Genesis Standalone
    Synthesis eq.(87)-(88), record 21529456). The commuting-square
    transport condition is typed as a [Prop] equation between two
    composed maps; the five named defect kinds are typed as a closed
    finite [Inductive] enumeration, never an open-ended classifier. *)

Section CAN_064_HumanAITransport.

  Inductive TransportDefect : Type :=
    | DSemanticLoss | DSourceOmission | DAuthorityLaundering
    | DUncertaintyCompression | DContextMismatch.

  Variables AISide HumanSide Shared : Type.
  Variable K_AI : AISide -> Shared.
  Variable K_H : HumanSide -> Shared.
  Variable T_HfromAI : AISide -> HumanSide.
  Variable T_C : Shared -> Shared.

  Definition CAN_064_transport_condition : Prop :=
    forall a : AISide, K_H (T_HfromAI a) = T_C (K_AI a).

End CAN_064_HumanAITransport.

