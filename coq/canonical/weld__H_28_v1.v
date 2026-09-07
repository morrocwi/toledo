(* weld/H.28.v1 -- not_yet_formalised -> definition -- Core Epistemic Registration object (experience-based expert, interactional expert or empty, AI model set) *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathcal R_p = \left\langle E_p^{exp}, E_p^{int}, \mathcal M_p^{AI} \right\rangle \\ E_p^{int}=\varnothing \\ \mathcal M_p^{AI}=\{M_1,M_2,\ldots,M_k\} *)
(* Toledo v1.5 lane B (DEBT #45 part 2): finite-model definition --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   A defining equation/notion, not a theorem -- no proof obligation. *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__H_28_v1_sec.
  Parameter ExpHolder AIModel : Type.
  Parameter E_p_exp : ExpHolder.
  Parameter E_p_int : option ExpHolder.
  Parameter M_p_AI : list AIModel.
  Definition weld__H_28_v1_def : Prop :=
    E_p_int = None /\ M_p_AI <> nil.
End weld__H_28_v1_sec.
