(* EQ-015/H.40.v1 -- not_yet_formalised -> definition -- Recursive epistemic network state *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathcal G_t = (\mathcal A_t, \mathcal E_t, \mathcal P_t) *)
(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model definition --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   A defining equation/notion, not a theorem -- no proof obligation. *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section EQ_015__H_40_v1_sec.
  Parameter AgentSet EdgeSet ProvStruct : Type.
  Parameter A_t : nat -> AgentSet.
  Parameter E_t : nat -> EdgeSet.
  Parameter P_t : nat -> ProvStruct.
  Definition EQ_015__H_40_v1_def (t : nat) : AgentSet * EdgeSet * ProvStruct :=
    (A_t t, E_t t, P_t t).
End EQ_015__H_40_v1_sec.
