(* weld/M.15.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.9: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathfrak{M}_Q(r_n) := \{\, m \in \mathfrak{M}_Q^{adm} : O_Q^G(m) = r_n \,\} *)
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

Section weld__M_15_v1_sec.
  Parameter Mech Readout : Type.
  Parameter M_Q_adm : Mech -> Prop.
  Parameter O_Q_G : Mech -> Readout.
  Parameter r_n : nat -> Readout.
  Definition weld__M_15_v1_def (n : nat) (m : Mech) : Prop :=
    M_Q_adm m /\ O_Q_G m = r_n n.
End weld__M_15_v1_sec.
