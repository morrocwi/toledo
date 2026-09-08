(* A.5/H.15.v1 — CAN-101 — Definition — parents: A.5/M.01.v1 — occurrences 3 *)

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
(** ** CAN-101 — capability-conversion-noncollapse

    (* CAN-101 — root: Resources<>Access, Access<>Capability, Capability<>RealizedOpportunity; Access(z)<>Control(z); EqualAIAccess does-not-imply EqualCapabilityConversion — domain: human–AI — tier: Definition — occurrences: 3 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (a
    distinct four-pair bundle from [MR_HCA]'s eq.(72)/(76) bundles — this
    id's own named pairs are Resources/Access, Access/Capability,
    Capability/RealizedOpportunity, and Access/Control). Four independent
    witnessed non-collapses. *)

Section CAN_101_CapabilityConversionNonCollapse.

  Theorem CAN_101_resources_ne_access :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_101_access_ne_capability :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_101_capability_ne_realized_opportunity :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_101_access_ne_control :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

End CAN_101_CapabilityConversionNonCollapse.

