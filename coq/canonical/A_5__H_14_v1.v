(* A.5/H.14.v1 — CAN-095 — Definition — parents: A.5/M.01.v1 — occurrences 2 *)

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
(** ** CAN-095 — grounding-embodiment

    (* CAN-095 — root: G (referential grounding); Ge (experiential grounding); Emb (embodiment); G<>Emb — domain: human–AI — tier: Th_coqc — occurrences: 2 *)

    CANONICAL.json tier: "definition/hypothesis-Open". No Master River
    eq. citation. The three grounding notions are typed as [Prop]-valued
    predicates on a declared referent type; the non-collapse [G<>Emb] is
    the id's own tagged content and is discharged as a witnessed
    instance. *)

Section CAN_095_GroundingEmbodiment.

  Theorem CAN_095_referential_ne_embodiment :
    exists (D : Type) (G Emb : D -> Prop) (x : D), G x /\ ~ Emb x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Variables RefT : Type.
  Variable Ge : RefT -> Prop.

  Definition CAN_095_experiential_grounding := Ge.

End CAN_095_GroundingEmbodiment.

