(* weld/M.16.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.10: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* CSML_Q(M) = \mathsf{PASS} \iff M \in \mathfrak{M}_Q^{adm} \wedge \mathrm{Asm}(M,Q)\ \text{is explicit} *)
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

Section weld__M_16_v1_sec.
  Parameter Mech : Type.
  Parameter M_Q_adm : Mech -> Prop.
  Parameter AssumptionsExplicit : Mech -> Prop.
  Parameter CSML_Q : Mech -> Verdict.
  Definition weld__M_16_v1_def (m : Mech) : Prop :=
    CSML_Q m = PASS <-> (M_Q_adm m /\ AssumptionsExplicit m).
End weld__M_16_v1_sec.
