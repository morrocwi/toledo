(* A.8/M.23.v1 -- not_yet_formalised -> definition -- AOWC gate conditions *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* Freeze(H,\tau),\ Predeclare(T,\mathcal A_H),\ AI_{\mathrm{decisive\ execution}}(T)=0,\ AI_{\mathrm{primary\ evaluation}}(T)=0,\ Record(W_T)\ \text{before recursive reinterpretation},\ T\ \text{allowed to count against}\ H *)
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

Section A_8__M_23_v1_sec.
  Parameter Hyp_ Test AcceptRegion WorldRecordT : Type.
  Parameter Freeze : Hyp_ -> nat -> Prop.
  Parameter Predeclare : Test -> AcceptRegion -> Prop.
  Parameter AI_decisive_execution AI_primary_evaluation : Test -> nat.
  Parameter Record_before_reinterp : WorldRecordT -> Prop.
  Parameter W_of : Test -> WorldRecordT.
  Parameter CountsAgainst : Test -> Hyp_ -> Prop.
  Definition A_8__M_23_v1_def (H : Hyp_) (T : Test) (A_H : AcceptRegion) (tau : nat) : Prop :=
    Freeze H tau /\
    Predeclare T A_H /\
    AI_decisive_execution T = 0%nat /\
    AI_primary_evaluation T = 0%nat /\
    Record_before_reinterp (W_of T) /\
    CountsAgainst T H.
End A_8__M_23_v1_sec.
