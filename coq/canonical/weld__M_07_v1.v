(* weld/M.07.v1 — CAN-169 — Definition — parents: weld/M.03.v1 — occurrences 19 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-169 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition / Open — occurrences: 19 *)
(** Discovery time as a first-passage stopping time: the bounded
    (fuel-indexed) search [CAN169_tau_U_bounded] is fully computable
    (Definition tier); the unbounded infimum over all [n] is left as an
    unproved existential [Prop] (Open — no finite Coq model decides an
    unbounded search without a supplied fuel bound). "usable<>true" is
    witnessed as a minimal two-valued instance: membership in the usable
    set and boolean truth are different notions, so they may diverge. *)
Section CAN169_FirstPassage.
  Variable St : Type.
  Variable in_target : St -> bool.
  Variable step_seq : nat -> St.

  Fixpoint CAN169_first_hit (fuel start : nat) : option nat :=
    match fuel with
    | O => None
    | S f => if in_target (step_seq start) then Some start else CAN169_first_hit f (S start)
    end.

  Definition CAN169_tau_U_bounded (fuel : nat) : option nat := CAN169_first_hit fuel 0.
End CAN169_FirstPassage.

Definition CAN169_tau_U_unbounded_Open (St : Type) (in_target : St -> bool) (step_seq : nat -> St) : Prop :=
  exists n : nat, in_target (step_seq n) = true.

Theorem CAN169_usable_ne_actually_true :
  exists is_usable is_true_claim : bool, is_usable = true /\ is_true_claim = false.
Proof. exists true, false. auto. Qed.

