(* ===================================================================== *)
(*  PROP_EPSC_17_orthogonal_composition.v                                *)
(*  Toledo PROP-EPSC-17, Observable-to-continuum orthogonal composition   *)
(*  certificate, registered in                                           *)
(*  registry/proposals/discrete_epsilon_completion_relative_energy.json  *)
(*                                                                        *)
(*  Registered claim: inf_g ||u(T) - g*xhat_N||_2 <= sqrt(rho_N^2+beta_N^2) *)
(*  given a retained-projection certificate of radius rho_N (modulo a     *)
(*  symmetry group G) and an EPSC omitted-tail bound beta_N, using         *)
(*  orthogonality of P_N and (I-P_N).                                     *)
(*                                                                        *)
(*  What this file mechanizes: the SQUARED form of the underlying         *)
(*  Pythagorean bound, which is what actually does the work and stays     *)
(*  rational-native (no square root in Q): if a and b are orthogonal      *)
(*  components (||a+b||^2 = ||a||^2 + ||b||^2, the Pythagorean identity   *)
(*  for any inner-product space) and ||a|| <= rho, ||b|| <= beta          *)
(*  (both nonnegative), then ||a+b||^2 <= rho^2 + beta^2. This is the     *)
(*  exact rational content the sqrt-form bound needs; taking square       *)
(*  roots of both sides (a monotone, order-preserving operation on        *)
(*  nonnegative reals) recovers the registered statement, but that last  *)
(*  step needs Coq.Reals' sqrt and is NOT mechanized here -- flagged      *)
(*  honestly, not silently assumed.                                      *)
(*                                                                        *)
(*  This file does NOT construct the infimum over the symmetry group G,   *)
(*  nor derive rho_N/beta_N for any concrete system -- both are taken as  *)
(*  already-certified inputs, exactly as the source states.               *)
(*                                                                        *)
(*  Rational-native (Q), no Coq.Reals.                                    *)
(*  Expected: Print Assumptions => Closed under the global context.       *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Section OrthogonalComposition.

  (* Abstract squared-norm quantities: na2 = ||a||^2, nb2 = ||b||^2,      *)
  (* nab2 = ||a+b||^2, all nonnegative rationals, with the Pythagorean    *)
  (* identity given as a hypothesis (the defining property of a and b    *)
  (* being orthogonal components in an inner-product space). *)
  Variables na2 nb2 nab2 rho2 beta2 : Q.

  Hypothesis na2_nonneg : 0 <= na2.
  Hypothesis nb2_nonneg : 0 <= nb2.
  Hypothesis pythagoras : nab2 == na2 + nb2.

  Hypothesis rho_cert : na2 <= rho2.
  Hypothesis beta_cert : nb2 <= beta2.

  Theorem epsc17_squared_composition_bound : nab2 <= rho2 + beta2.
  Proof.
    rewrite pythagoras.
    lra.
  Qed.

End OrthogonalComposition.
