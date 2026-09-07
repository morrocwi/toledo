(* EQ-015/H.41.v1 -- not_yet_formalised -> definition -- Recursive Epistemic Reflection (RER) minimal cycle *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* a_i \rightarrow a_j \rightarrow a_i *)
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

Section EQ_015__H_41_v1_sec.
  Parameter Agent : Type.
  Parameter Edge : Agent -> Agent -> Prop.
  Definition EQ_015__H_41_v1_def (ai aj : Agent) : Prop :=
    Edge ai aj /\ Edge aj ai.
End EQ_015__H_41_v1_sec.
