(* weld/W.11.v1 -- not_yet_formalised -> open_prop -- Effective independent validation capacity *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mu_t^{eff} = \mu_t(1-\pi_t^{RET}) *)
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

Section weld__W_11_v1_sec.
  Parameter mu pi_RET mu_eff : nat -> Q.
  Definition weld__W_11_v1_hyp (t : nat) : Prop :=
    mu_eff t = mu t * (1 - pi_RET t).
End weld__W_11_v1_sec.
