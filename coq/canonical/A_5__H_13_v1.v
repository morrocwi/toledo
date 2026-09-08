(* A.5/H.13.v1 — CAN-093 — Definition — parents: A.5/M.01.v1 — occurrences 7 *)

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
(** ** CAN-093 — event-translation-core

    (* CAN-093 — root: E:=event; C_e:=(Se,Re,Ae,taue); That:=I(E|Cacc); That<>E — domain: human–AI — tier: Definition — occurrences: 7 *)

    CANONICAL.json tier: "definition/proposition". No Master River eq.
    citation. The event-context record and the interpretation function
    are typed abstractly; the interpretation-is-not-the-event non-
    collapse is discharged as a witnessed instance: an interpretation
    map that is not the identity on a concrete finite carrier. *)

Section CAN_093_EventTranslationCore.

  Variables SeT ReT AeT TaueT AccessCtxT InterpT : Type.

  Record EventContext : Type := mkEventContext
    { ec_S : SeT ; ec_R : ReT ; ec_A : AeT ; ec_tau : TaueT }.

  Variable I_interp : InterpT -> AccessCtxT -> InterpT.

  Definition CAN_093_interpretation (e : InterpT) (c : AccessCtxT) : InterpT :=
    I_interp e c.

End CAN_093_EventTranslationCore.

Section CAN_093_EventTranslationWitness.

  (* Witness (not a universal claim): a concrete carrier and a concrete
     interpretation map on which the interpretation genuinely differs
     from the event it interprets — [T-hat <> E] is possible, not
     vacuous. *)
  Theorem CAN_093_interpretation_ne_event_witness :
    exists (Ev : Type) (I2 : Ev -> Ev -> Ev) (e c : Ev),
      I2 e c <> e.
  Proof.
    exists nat, (fun _ _ => 1%nat), 0%nat, 0%nat.
    discriminate.
  Qed.

End CAN_093_EventTranslationWitness.

