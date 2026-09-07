(* EQ-001/B.11.v1 -- finite_diagnostic -- parents: EQ-001 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* From licensed replication-count matrix B and initial counts N0, N1 = B.N0
   gives a frequency readout p1 = N1/sum(N1). Exact witness reproduced here:
   B = diag(2,1), N0 = (1,1) -> N1 = (2,1) -> p1 = (2/3, 1/3). *)
Definition EQ001_B11_v1_matvec_diag (b1 b2 n1 n2 : Q) : Q * Q := (b1 * n1, b2 * n2).

Theorem EQ001_B11_v1_N1_witness :
  let '(n1', n2') := EQ001_B11_v1_matvec_diag 2 1 1 1 in n1' == 2 /\ n2' == 1.
Proof. simpl. split; reflexivity. Qed.

Theorem EQ001_B11_v1_p1_witness :
  2 / (2 + 1) == 2 # 3 /\ 1 / (2 + 1) == 1 # 3.
Proof. compute. split; reflexivity. Qed.
