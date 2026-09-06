(* EQ-015/W.19.v1 — CAN-163 — Definition — parents: EQ-015/M.01.v1 — occurrences 6 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-163 — reversibility-window-urgency

    (* CAN-163 — root: W_j={t: C^rec<=Cbar /\ tau^rec<=taubar}; Delta g=[gtilde_M-gtilde_C]_+; U=Delta g L S tau^rec — domain: world-system — tier: Definition — occurrences: 6 *)

    CANONICAL.json tier: "definition (Reversibility Principle itself
    [Open])". Master River v1.4 eq.(63)-(64) [human_conversion_imperative].
    Direct reuse of [MR_WorldSystem.v]'s [reversibility_window]/
    [in_reversibility_window] (Definition, eq.63) and [urgency_term]
    (Definition, eq.64) — no redefinition. The Reversibility Principle
    itself (that restoration remains genuinely feasible for every
    dimension inside its own window) is exactly the source's own
    tagged-Open claim and is typed here as a fresh [Prop]-valued
    Definition, deliberately un-proved. *)

Definition CAN_163_reversibility_window := MR_WorldSystem.reversibility_window.
Definition CAN_163_in_reversibility_window := MR_WorldSystem.in_reversibility_window.
Definition CAN_163_urgency_term := MR_WorldSystem.urgency_term.

Definition CAN_163_Open_reversibility_principle
           (C_rec_j tau_rec_j : nat -> Q) (Cbar_j taubar_j : Q) (t : nat) : Prop :=
  CAN_163_in_reversibility_window C_rec_j tau_rec_j Cbar_j taubar_j t = true ->
  exists t' : nat, (t <= t')%nat.

