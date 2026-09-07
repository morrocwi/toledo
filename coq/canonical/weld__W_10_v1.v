(* weld/W.10.v1 -- not_yet_formalised -> definition -- University Pareto-efficient portfolio objective and its constraint set *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \left\{ Y_K, \Delta R_H^{return}, W, T, N_v \right\} \\ \text{Budget}\leq\bar B,\ \text{Safety risk}\leq\bar S,\ \text{Protocol burden}\leq\bar U,\ \text{Provenance and legitimacy gates passed},\ \text{Open-exploration capacity protected}. *)
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

Section weld__W_10_v1_sec.
  Parameter Budget SafetyRisk ProtocolBurden Bbar Sbar Ubar : Q.
  Parameter ProvenanceGatesPassed OpenExplorationProtected : Prop.
  Definition weld__W_10_v1_def : Prop :=
    (Budget <= Bbar)%Q /\ (SafetyRisk <= Sbar)%Q /\ (ProtocolBurden <= Ubar)%Q /\
    ProvenanceGatesPassed /\ OpenExplorationProtected.
  (* The optimisation OBJECT itself -- {Y_K, Delta R_H^return, W, T, N_v}
     -- is the portfolio tuple being Pareto-optimised subject to exactly
     these five named constraints; the source states no objective
     function beyond naming this tuple, so none is invented here. *)
End weld__W_10_v1_sec.
