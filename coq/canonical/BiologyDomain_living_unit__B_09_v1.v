(* BiologyDomain_living_unit/B.09.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Chi-square goodness-of-fit statistic: chi2 = sum((O_i - E_i)^2 / E_i),
   over paired finite lists of observed/expected counts. *)
Definition B09_v1_chi2 (O E : list Q) : Q :=
  fold_right Qplus 0 (map (fun p => let '(o, e) := p in (o - e) * (o - e) / e) (combine O E)).
