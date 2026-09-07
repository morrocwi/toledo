(* EQ-001/P.64.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Unruh calculator identity: tau_c = pi * c / a (declared, not derived).
   [pi] here is a free rational formal parameter of the calculator
   template, not an assertion that the transcendental constant pi is
   typed as Q -- consistent with the finite/discrete-only discipline. *)
Definition EQ001_P64_tau_c (pi_param c a : Q) : Q := pi_param * c / a.
