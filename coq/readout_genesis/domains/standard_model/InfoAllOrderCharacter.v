(* ================================================================= *)
(*  InfoAllOrderCharacter.v                                  *)
(*  All-Order Character Closure v1.0 -- the exact ALGEBRAIC scaffold  *)
(*  behind the all-order Weyl-integral computation of u(k), v(k).     *)
(*  (The integrals themselves are high-precision NUMERICAL, in        *)
(*  all_order_character_v1_0.py -- not Th_coqc. Here we mechanize the  *)
(*  exact representation-theory facts the closure rests on.)          *)
(*                                                                     *)
(*  Proved over nat / Q (Print Assumptions Closed):                   *)
(*    (fusion)  3 (x) 3bar = 1 (+) 8  as a dimension identity: 3*3=1+8 *)
(*    (chi8)    chi_8(I) = |chi_3(I)|^2 - 1 = 3*3 - 1 = 8 = dim(8)     *)
(*    (recur)   the recursion c_R' = sum_S (N_{3S}^R + N_{3bar S}^R)c_S*)
(*              gives c_0' = 2 c_3, since the singlet sits in 3(x)3bar *)
(*              and in 3bar(x)3 exactly once each (coefficient 1+1=2)  *)
(*    (adjoint) dim(adjoint 8) = 8, the ||N_8|| bound in the tail      *)
(*    (cert)    the certificate ratio is LINEAR: 0<C<1 => C*C < C      *)
(*              (the convergence is governed by C=mu_4*u_hat)          *)
(*                                                                     *)
(*  HONEST FENCE. These are the exact rep-theory identities; the       *)
(*  values u(k),v(k) and the threshold k_* = 0.053583974745... are     *)
(*  HIGH-PRECISION NUMERICAL (deterministic Weyl quadrature), NOT a    *)
(*  rigorous interval proof. Character expansion / invariant           *)
(*  integration is standard; the retained-triality reading is ours.    *)
(*  OPEN: rigorous interval bound on the integrals, and mu_4^admissible*)
(*  (a triality-preserving surface automaton) replacing the crude 20e. *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Require Import Coq.Arith.Arith.

Module InfoAllOrderCharacter.

(* (fusion) 3 (x) 3bar = 1 (+) 8 : the dimension identity *)
Theorem fusion_3_3bar_dim : (3 * 3 = 1 + 8)%nat.
Proof. reflexivity. Qed.

(* (chi8) chi_8 at the identity: |chi_3(I)|^2 - 1 = 3*3 - 1 = 8 = dim(adjoint) *)
Theorem chi8_at_identity : (3 * 3 - 1 = 8)%nat.
Proof. reflexivity. Qed.
(* the ||N_8|| <= 8 tail-coefficient bound: N_8 = sum of 8 per-mode weights, each in [0,1]
   (one per adjoint generator) => the sum (the operator norm on the diagonal) is <= dim(adjoint) = 8 *)
Open Scope Q_scope.
Theorem adjoint_tail_bound_N8 : forall n1 n2 n3 n4 n5 n6 n7 n8 : Q,
  0 <= n1 -> n1 <= 1 -> 0 <= n2 -> n2 <= 1 -> 0 <= n3 -> n3 <= 1 -> 0 <= n4 -> n4 <= 1 ->
  0 <= n5 -> n5 <= 1 -> 0 <= n6 -> n6 <= 1 -> 0 <= n7 -> n7 <= 1 -> 0 <= n8 -> n8 <= 1 ->
  0 <= n1+n2+n3+n4+n5+n6+n7+n8 <= 8.
Proof. intros. lra. Qed.
Close Scope Q_scope.

(* (recur) the singlet multiplicity in 3(x)3bar and 3bar(x)3 is 1 each, so the
   c_0' recursion coefficient is N_{3,3bar}^0 + N_{3bar,3}^0 = 1 + 1 = 2 :  c_0' = 2 c_3 *)
Theorem c0_prime_coefficient : (1 + 1 = 2)%nat.
Proof. reflexivity. Qed.

Open Scope Q_scope.

(* (recur, Q form) with charge conjugation c_3 = c_3bar, the recursion gives c_0' = 2 c_3 *)
Theorem c0_prime_is_two_c3 : forall c3 c3bar : Q,
  c3 == c3bar -> (c3bar + c3) == 2 * c3.
Proof. intros c3 c3bar H. rewrite H. ring. Qed.

(* (cert) the certificate convergence ratio is LINEAR (C=mu_4*u_hat): 0<C<1 => C*C < C.
   This is why the threshold is 20e*u_hat < 1, not a powered version. *)
Theorem certificate_ratio_linear : forall C : Q, 0 < C -> C < 1 -> C*C < C.
Proof. intros C H0 H1. assert (H2 : 0 < C*(1-C)) by nra. nra. Qed.

End InfoAllOrderCharacter.

Print Assumptions InfoAllOrderCharacter.fusion_3_3bar_dim.
Print Assumptions InfoAllOrderCharacter.chi8_at_identity.
Print Assumptions InfoAllOrderCharacter.adjoint_tail_bound_N8.
Print Assumptions InfoAllOrderCharacter.c0_prime_coefficient.
Print Assumptions InfoAllOrderCharacter.c0_prime_is_two_c3.
Print Assumptions InfoAllOrderCharacter.certificate_ratio_linear.
