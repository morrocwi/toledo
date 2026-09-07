(* EQ-015/H.49.v1 -- not_yet_formalised -> open_prop -- Session reset does not entail epistemic reset *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* SessionReset \not\Rightarrow EpistemicReset *)
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

Section EQ_015__H_49_v1_sec.
  Parameter Session : Type.
  Parameter SessionReset EpistemicReset : Session -> Prop.
  Definition EQ_015__H_49_v1_hyp : Prop :=
    ~ (forall s : Session, SessionReset s -> EpistemicReset s).
End EQ_015__H_49_v1_sec.
