(* A.8/H.04.v1 — CAN-112 — Definition — parents: A.8/M.01.v1 — occurrences 7 *)

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
(** ** CAN-112 — decisive-record-argmax

    (* CAN-112 — root: u*^diag=argmax_u[IGB(u)-lambdaC.Cost(u)-rho.Risk(u)]; u*^adv=argmin_u E[...]; pi*=argmax_pi E[DeltaH|pi] — domain: human–AI — tier: Open — occurrences: 7 *)

    CANONICAL.json tier: "hypothesis/Open (definitions of the
    optimization objective; not validated policies)". No Master River
    eq. citation. Each optimization objective is typed as a [Prop]
    stating that a candidate is an (arg)optimum of its declared
    [Q]-valued objective over a finite candidate list — Definition-tier
    typing of the objective shape, but the source itself explicitly
    marks the resulting policies unvalidated, so no instance is asserted
    to exist or to be optimal beyond this typed predicate. *)

Section CAN_112_DecisiveRecordArgmax.

  Variables Cand : Type.
  Variable objective : Cand -> Q.

  Definition CAN_112_is_argmax (candidates : list Cand) (u_star : Cand) : Prop :=
    In u_star candidates /\
    forall u : Cand, In u candidates -> objective u <= objective u_star.

  Definition CAN_112_Open_is_argmin (candidates : list Cand) (u_star : Cand) : Prop :=
    In u_star candidates /\
    forall u : Cand, In u candidates -> objective u_star <= objective u.

End CAN_112_DecisiveRecordArgmax.

