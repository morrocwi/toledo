(* EQ-002/H.04.v1 — CAN-111 — Definition — parents: EQ-002/M.03.v1 — occurrences 3 *)

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
(** ** CAN-111 — human-ai-attribution

    (* CAN-111 — root: alpha_t(o) in {HUMAN,AI,JOINT} for o in Omega={q_sem,PiP,PiQ,B,a,m,kappa,GammaQ,UD,PiR} — domain: human–AI — tier: Definition — occurrences: 3 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. A
    three-constructor attribution label and a declared function from a
    finite ten-element origin enumeration to that label. *)

Section CAN_111_HumanAIAttribution.

  Inductive AttributionLabel : Type := AttrHuman | AttrAI | AttrJoint.

  Inductive OriginObject : Type :=
    | OQsem | OPiP | OPiQ | OB | OA2 | OM | OKappa | OGammaQ | OUD | OPiR.

  Variable alpha_fn : OriginObject -> AttributionLabel.

  Definition CAN_111_attribution := alpha_fn.

End CAN_111_HumanAIAttribution.

