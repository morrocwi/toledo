(* weld/M.06.v1 — CAN-168 — Definition — parents: weld/M.03.v1 — occurrences 10 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-168 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition / Th_coqc — occurrences: 10 *)
(** Reachability is not accessibility: [CAN168_path_prob] is the
    finite-product path measure over a [Q]-valued access kernel (never a
    supremum over an unbounded path set — a genuine sup is left Open where
    it would appear); the non-collapse content ("reachable does not force
    high accessibility") is witnessed concretely: a strictly positive but
    small path value is neither zero (reachable) nor [CAN168_high]. *)
Section CAN168_DiscoveryAccessibility.
  Variable Sem : Type.
  Variable kappa : nat -> Sem -> Sem -> Q.

  Fixpoint CAN168_path_prob (t : nat) (s : Sem) (path : list Sem) : Q :=
    match path with
    | [] => 1
    | s' :: rest => kappa t s s' * CAN168_path_prob t s' rest
    end.

  Definition CAN168_reachable (t : nat) (s : Sem) (path : list Sem) : Prop :=
    ~ Qeq (CAN168_path_prob t s path) 0.
End CAN168_DiscoveryAccessibility.

Definition CAN168_high (q : Q) : Prop := (1#2) <= q.

Theorem CAN168_positive_but_not_high : exists q : Q, ~ Qeq q 0 /\ ~ CAN168_high q.
Proof.
  exists (1#100). split.
  - intro Hc. apply Qeq_bool_iff in Hc. vm_compute in Hc. discriminate.
  - intro Hc. assert (Hb : Qle_bool (1#2) (1#100) = true) by (apply Qle_bool_iff; exact Hc).
    vm_compute in Hb. discriminate.
Qed.

