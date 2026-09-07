(* EQ-002/M.04.v1 -- not_yet_formalised -> open_prop -- Simulation success does not entail world validation *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* Simulation\ Success \not\Rightarrow World\ Validation *)
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

Section EQ_002__M_04_v1_sec.
  Parameter Sim : Type.
  Parameter SimulationSuccess WorldValidation : Sim -> Prop.
  Definition EQ_002__M_04_v1_hyp : Prop :=
    ~ (forall s : Sim, SimulationSuccess s -> WorldValidation s).
End EQ_002__M_04_v1_sec.
