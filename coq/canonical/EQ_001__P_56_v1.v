(* EQ-001/P.56.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* null-transport factorization: B = diag(a,b) = N diag(1/chi, chi),
   N = sqrt(ab), chi = sqrt(b/a). Exact witness a=2,b=8: N=4, chi=2
   (avoiding literal sqrt: verified via N*N=a*b and chi*chi*a=b, plus
   the diagonal reconstruction a = N/chi, b = N*chi). *)
Theorem EQ001_P56_witness :
  4 * 4 == 2 * 8 /\ 2 * 2 * 2 == 8 /\ (4 / 2 == 2) /\ (4 * 2 == 8).
Proof. repeat split; lra. Qed.
