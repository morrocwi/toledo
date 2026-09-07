(* EQ-015/H.47.v1 -- not_yet_formalised -> open_prop -- Consensus does not entail validation *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* Consensus_{\mathcal M}(c)\uparrow \not\Rightarrow Validation(c)\uparrow *)
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

Section EQ_015__H_47_v1_sec.
  Parameter Claim : Type.
  Parameter ConsensusIncreases ValidationIncreases : Claim -> Claim -> Prop.
  Definition EQ_015__H_47_v1_hyp : Prop :=
    ~ (forall c c' : Claim, ConsensusIncreases c c' -> ValidationIncreases c c').
End EQ_015__H_47_v1_sec.
