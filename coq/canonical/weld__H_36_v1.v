(* weld/H.36.v1 -- not_yet_formalised -> open_prop -- Agreeing agents does not entail independent epistemic routes (network Epistemic Mirror Effect) *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* N_A(c)\uparrow \not\Rightarrow N_P(c)\uparrow *)
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

Section weld__H_36_v1_sec.
  Parameter Claim : Type.
  Parameter AgentCountIncreases ProvRouteCountIncreases : Claim -> Claim -> Prop.
  Definition weld__H_36_v1_hyp : Prop :=
    ~ (forall c c' : Claim, AgentCountIncreases c c' -> ProvRouteCountIncreases c c').
End weld__H_36_v1_sec.
