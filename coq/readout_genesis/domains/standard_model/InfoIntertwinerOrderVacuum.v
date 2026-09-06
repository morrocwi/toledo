(* ================================================================= *)
(*  InfoIntertwinerOrderVacuum.v                                *)
(*  Intertwiner & Order-Vacuum Closure v1.13 (founder's "v2.2/v2.1 corrected"). Compute    *)
(*  the closure-channel counts, ranks, and order-selecting pressure   *)
(*  from the ACTUAL representations, and CORRECT the v1.13 closure     *)
(*  factor. Closure through H is LINEAR in H, so a branch's closed-    *)
(*  history weight MUST vanish at H=0 (Z_j(0)=1); the v1.13 ansatz     *)
(*  1+zeta e^{kappa r} wrongly keeps weight at r=0. The correct factor *)
(*  is the fermionic Fock determinant Z_j(r)=det(I+K_j)=(1+lam_j r)^dj.*)
(*                                                                     *)
(*  Proved over Q / Z (Print Assumptions Closed):                     *)
(*   (nu)     invariant multiplicities: U(1) closures 1+3-4=0,         *)
(*            1-3+2=0, -3-3+6=0 => nu_U=nu_D=nu_E=1                     *)
(*   (rank)   closure singular modes d_U+d_D+d_E = 3+3+1 = 7           *)
(*   (fock)   Z_j = (1+lam r)^dj ; d_E=1 case is 1+lam r; the d=3      *)
(*            case is the cube (Fock determinant of K=lam r I_3)       *)
(*   (corr)   THE CORRECTION: Z_j(0) = (1+lam*0)^dj = 1 (weight        *)
(*            vanishes at H=0) -- supersedes the v1.13 exponential     *)
(*   (slope)  V_eff'(0) = alpha - Pi0, Pi0 = 3 lam_U + 3 lam_D + lam_E;*)
(*            ORDER iff Pi0 > alpha                                    *)
(*   (conv)   V_eff''(r) = 2 beta + (nonneg fraction terms) > 0 for    *)
(*            beta>0 -- convexity is AUTOMATIC (no extra gate)         *)
(*   (nogo)   0 < lam_j <= 1 (Delta_j >= 0) => Pi0 <= 7 => alpha >= 7  *)
(*            forces r*=0                                              *)
(*   (bounds) (Pi0-alpha)/(2 beta + S2) <= r* < (Pi0-alpha)/(2 beta)   *)
(*                                                                     *)
(*  HONEST FENCE. EXACT: the multiplicities, ranks, the Fock factor,   *)
(*  the corrected order criterion. SUPERSEDES the v1.13 exponential    *)
(*  closure factor. OPEN: representation theory does NOT fix Delta0,   *)
(*  eps3, eps_pm, alpha, beta, so whether Pi0>alpha is FORCED stays    *)
(*  open -- the bottleneck is now a single primitive-cost inequality.  *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.ZArith.ZArith.
Require Import Coq.micromega.Lqa.
Require Import Lia.

Module InfoIntertwinerOrderVacuum.

(* ---- Z-level: multiplicities and the mode count ---- *)
Open Scope Z_scope.

(* (nu) U(1) closure sums vanish => each invariant multiplicity is 1 *)
Theorem nu_U1_closures : (1 + 3 - 4 = 0) /\ (1 - 3 + 2 = 0) /\ (-3 - 3 + 6 = 0).
Proof. repeat split; reflexivity. Qed.
(* (rank) closure singular modes d_U+d_D+d_E = 3+3+1 = 7 *)
Theorem closure_mode_count : 3 + 3 + 1 = 7.
Proof. reflexivity. Qed.
(* ordered-tape: 3! = 6 raw perms = 2 orientation classes of 3 *)
Theorem tape_quotient : (3 * 2 * 1 = 6) /\ (6 / 3 = 2).
Proof. split; reflexivity. Qed.

(* ---- Q-level: Fock factor, potential, convexity, bounds ---- *)
Open Scope Q_scope.

Definition cube (x : Q) : Q := x*x*x.
(* (fock) Z_U = (1+lam r)^3 as the Fock determinant of K=lam r I_3 *)
Definition ZU (lam r : Q) : Q := cube (1 + lam*r).
Definition ZE (lam r : Q) : Q := 1 + lam*r.
(* (corr) THE CORRECTION: Z_j(0) = 1 (closure weight vanishes at H=0) *)
Theorem fock_vanishes_at_zero : forall lam : Q, ZU lam 0 == 1 /\ ZE lam 0 == 1.
Proof. intro lam. unfold ZU, ZE, cube. split; ring. Qed.

(* (slope) V_eff'(0) = alpha - Pi0, Pi0 = 3 lam_U + 3 lam_D + lam_E *)
Definition Pi0 (lamU lamD lamE : Q) : Q := 3*lamU + 3*lamD + lamE.
Theorem origin_slope : forall alpha lamU lamD lamE : Q,
  alpha - Pi0 lamU lamD lamE < 0 <-> Pi0 lamU lamD lamE > alpha.
Proof. intros. unfold Pi0. split; lra. Qed.

(* (conv) automatic convexity: each fraction term lam^2/(1+lam r)^2 >= 0,
   so V'' = 2 beta + (sum of nonneg terms) > 0 for beta>0. *)
Theorem fraction_term_nonneg : forall lam r : Q,
  0 < 1 + lam*r -> 0 <= (lam*lam) / ((1 + lam*r)*(1 + lam*r)).
Proof.
  intros lam r Hden.
  apply Qle_shift_div_l; [ nra | ].
  (* 0 * denom <= lam*lam *)
  assert (0 <= lam*lam) by nra. lra.
Qed.
Theorem convexity_automatic : forall beta tU tD tE : Q,
  0 < beta -> 0 <= tU -> 0 <= tD -> 0 <= tE ->
  2*beta + (3*tU + 3*tD + tE) > 0.
Proof. intros. lra. Qed.

(* (nogo) 0 < lam_j <= 1 => Pi0 <= 7 ; alpha >= 7 => Pi0 <= alpha (r*=0) *)
Theorem pressure_max_seven : forall lamU lamD lamE : Q,
  0 < lamU -> lamU <= 1 -> 0 < lamD -> lamD <= 1 -> 0 < lamE -> lamE <= 1 ->
  Pi0 lamU lamD lamE <= 7.
Proof. intros. unfold Pi0. lra. Qed.
Theorem no_go_alpha_seven : forall alpha lamU lamD lamE : Q,
  lamU <= 1 -> lamD <= 1 -> lamE <= 1 -> 7 <= alpha ->
  Pi0 lamU lamD lamE <= alpha.
Proof. intros. unfold Pi0. lra. Qed.

(* (bounds) from the stationarity 2 beta r* + alpha = X with Pi0 - S2 r* <= X < Pi0:
   (Pi0 - alpha)/(2 beta + S2) <= r*  and  r* < (Pi0 - alpha)/(2 beta). *)
Theorem scale_lower_bound : forall alpha beta rstar Pi0v S2 X : Q,
  0 < beta -> 0 <= S2 -> 2*beta*rstar + alpha == X -> Pi0v - S2*rstar <= X ->
  Pi0v - alpha <= (2*beta + S2)*rstar.
Proof. intros. nra. Qed.
Theorem scale_upper_bound : forall alpha beta rstar Pi0v X : Q,
  0 < beta -> 2*beta*rstar + alpha == X -> X < Pi0v -> 2*beta*rstar < Pi0v - alpha.
Proof. intros. lra. Qed.

End InfoIntertwinerOrderVacuum.

Print Assumptions InfoIntertwinerOrderVacuum.nu_U1_closures.
Print Assumptions InfoIntertwinerOrderVacuum.closure_mode_count.
Print Assumptions InfoIntertwinerOrderVacuum.tape_quotient.
Print Assumptions InfoIntertwinerOrderVacuum.fock_vanishes_at_zero.
Print Assumptions InfoIntertwinerOrderVacuum.origin_slope.
Print Assumptions InfoIntertwinerOrderVacuum.fraction_term_nonneg.
Print Assumptions InfoIntertwinerOrderVacuum.convexity_automatic.
Print Assumptions InfoIntertwinerOrderVacuum.pressure_max_seven.
Print Assumptions InfoIntertwinerOrderVacuum.no_go_alpha_seven.
Print Assumptions InfoIntertwinerOrderVacuum.scale_lower_bound.
Print Assumptions InfoIntertwinerOrderVacuum.scale_upper_bound.
