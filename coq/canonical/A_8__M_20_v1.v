(* A.8/M.20.v1 -- not_yet_formalised -> definition -- Typed provenance DAG *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \Pi(c) = (V_c, E_c, \tau_c) *)
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

Section A_8__M_20_v1_sec.
  Parameter Claim VertexSet EdgeSet TypeMap : Type.
  Parameter V_c : Claim -> VertexSet.
  Parameter E_c : Claim -> EdgeSet.
  Parameter tau_c : Claim -> TypeMap.
  Definition A_8__M_20_v1_def (c : Claim) : VertexSet * EdgeSet * TypeMap :=
    (V_c c, E_c c, tau_c c).
End A_8__M_20_v1_sec.
