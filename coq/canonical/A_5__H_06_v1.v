(* A.5/H.06.v1 — CAN-061 — Definition — parents: A.5/M.01.v1 — occurrences 2 *)

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
(** ** CAN-061 — live-possibility-dynamics

    (* CAN-061 — root: L_{A,t+1}<>L_{A,t} (if residue retained); Lambdadot^live_H = sum lambda_i x_i - delta.Lambda^live — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition / hypothesis-Open (dynamic law
    explicitly Open)". The witnessed-possibility half is the same object
    as CAN-045's tail clause — reused, not reproved, via
    [MR_Prompt.eq30_live_weight_may_change]. The world-system-scale
    continuous-looking dynamic law (After Labour eq. 33) is the id's own
    Open content: a discrete-difference [Prop] (never a continuum ODE),
    left un-proved. *)

Definition CAN_061_live_weight_may_change_witness := MR_Prompt.eq30_live_weight_may_change.

Section CAN_061_LiveFieldDynamicsOpen.

  Definition CAN_061_Open_live_field_dynamic
             (Lambda_live driver1 driver2 driver3 driver4 driver5 driver6 : nat -> Q)
             (decay : Q) (n : nat) : Prop :=
    Lambda_live (S n) - Lambda_live n ==
      driver1 n + driver2 n + driver3 n + driver4 n
      - driver5 n - driver6 n - decay * Lambda_live n.

End CAN_061_LiveFieldDynamicsOpen.

