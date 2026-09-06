(* A.8/M.01.v1 — CAN-009 — Dr — parents: A.8 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-009 — historical-invariance

    (* CAN-009 — root: Delta A_past = 0 — domain: root — tier: Definition — occurrences: 1 *)

    The historical occurrence itself is not rewritten by later
    reinterpretation; only bindings among trace/meaning/experience/memory
    change.  Discrete replacement: history is a finite append-only list
    (the same "tape" carrier as CAN-002's [T_n]); "the past is unwritten"
    becomes the genuine, provable list fact that every already-recorded
    index is unchanged by any future append. *)

Section HistoricalInvariance.

  Variable Event : Type.

  Definition CAN_009_extends (h h' : list Event) : Prop :=
    exists suffix : list Event, h' = h ++ suffix.

  (* Th_coqc: appending a suffix never changes an index already inside the
     original history — [Delta A_past = 0] read as an exact, checkable
     [nth_error] stability fact on the finite list model. *)
  Theorem CAN_009_extension_preserves_past :
    forall (h h' : list Event) (i : nat),
      CAN_009_extends h h' -> (i < length h)%nat ->
      nth_error h' i = nth_error h i.
  Proof.
    intros h h' i [suffix ->] Hi.
    apply nth_error_app1. exact Hi.
  Qed.

  (* Witness (tier: Th_coqc): the invariance is not vacuous — a genuine
     one-event append is an extension and does change the *length* while
     leaving every past index untouched, on a two-element finite model. *)
  Example CAN_009_witness_append_preserves_first_event :
    forall e0 e1 : Event,
      CAN_009_extends [e0] [e0; e1] /\ nth_error [e0; e1] 0 = nth_error [e0] 0.
  Proof.
    intros e0 e1. split.
    - exists [e1]. reflexivity.
    - reflexivity.
  Qed.

End HistoricalInvariance.
