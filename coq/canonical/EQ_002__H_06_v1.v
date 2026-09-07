(* EQ-002/H.06.v1 -- not_yet_formalised -> open_prop -- Readout-of-readout recursion *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* z_{j,t+1} = R_{j,t+1}\left(z_{i,t}, c_{j,t+1}\right) *)
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

Section EQ_002__H_06_v1_sec.
  Parameter Readout Ctx Agent : Type.
  Parameter z : nat -> Agent -> Readout.
  Parameter c : nat -> Agent -> Ctx.
  Parameter R : nat -> Agent -> Readout -> Ctx -> Readout.
  Definition EQ_002__H_06_v1_hyp (t : nat) (i j : Agent) : Prop :=
    z (S t) j = R (S t) j (z t i) (c (S t) j).
End EQ_002__H_06_v1_sec.
