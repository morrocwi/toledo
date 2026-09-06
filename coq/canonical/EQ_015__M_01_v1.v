(* EQ-015/M.01.v1 — CAN-002 — Definition — parents: EQ-015 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-002 — root-state-tuple

    (* CAN-002 — root: S_n=(G_n,Lambda_n,T_n) — domain: root — tier: Definition — occurrences: 2 *)

    Relational carrier: a retained-graph component [G_n], a typed-
    distinction component [Lambda_n], and an append-only tape [T_n].  All
    three are abstract [Type]s (Section [Variable]s, discharged at
    [End RootStateTuple]) — the claim of eq. is only that the root state is
    *this* triple, not an opaque single object. *)

Section RootStateTuple.

  Variables G Lambda Tape : Type.

  Record RootState : Type := mkRootState
    { rs_G      : G       (* G_n: retained relational graph *)
    ; rs_Lambda : Lambda  (* Lambda_n: retained typed distinctions *)
    ; rs_Tape   : Tape    (* T_n: append-only tape *)
    }.

  (* Witness (tier: Th_coqc): the triple is a faithful, lossless typing —
     projecting the three components back out and re-assembling them is
     the identity, so [RootState] drops nothing eq. claims of S_n. *)
  Theorem CAN_002_root_state_tuple_faithful :
    forall s : RootState,
      mkRootState (rs_G s) (rs_Lambda s) (rs_Tape s) = s.
  Proof. intros [g l t]. reflexivity. Qed.

End RootStateTuple.

