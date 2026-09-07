(* BiologyDomain_living_unit/B.26.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Price equation, selection-only term: Delta_zbar = Cov(w,z) / wbar.
   Cov(w,z) and wbar are taken as already-computed Q inputs (their own
   definitions are standard statistics, not part of this equation's own
   statement, and are not re-derived here). *)
Definition B26_v1_price_equation (Cov_w_z wbar : Q) : Q := Cov_w_z / wbar.
