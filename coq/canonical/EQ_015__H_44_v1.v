(* EQ-015/H.44.v1 -- not_yet_formalised -> definition -- Recursive Epistemic Tunnel (RET) *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* RET \neq Falsehood; \quad RET \neq Consensus *)
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

Section EQ_015__H_44_v1_sec.
  Parameter Category : Type.
  Parameter RET Falsehood Consensus : Category.
  Definition EQ_015__H_44_v1_def : Prop :=
    RET <> Falsehood /\ RET <> Consensus.
End EQ_015__H_44_v1_sec.
