(* EQ-015/H.46.v1 -- not_yet_formalised -> open_prop -- Multi-model consensus readout *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* Consensus_{\mathcal M}(c) = \frac{1}{k}\sum_{j=1}^{k}\mathbf 1[M_j\ accepts\ c] *)
(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model open_prop --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   Unproved by design (Dr source label). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Require Import ZArith.
Section EQ_015__H_46_v1_sec.
  Parameter Claim : Type.
  Parameter k : nat.
  Parameter accept_count : Claim -> nat.
  Definition EQ_015__H_46_v1_hyp (c : Claim) : Prop :=
    exists consensus : Q,
      consensus = inject_Z (Z.of_nat (accept_count c)) / inject_Z (Z.of_nat k).
End EQ_015__H_46_v1_sec.
