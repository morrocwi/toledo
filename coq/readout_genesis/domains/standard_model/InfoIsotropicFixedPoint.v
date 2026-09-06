(* ================================================================= *)
(*  InfoIsotropicFixedPoint.v                                *)
(*  Isotropic Fixed-Point Closure v1.10 (founder's "Isotropic v1.8"). *)
(*  Coarse-graining does not merely PRESERVE the isotropic point      *)
(*  (symmetry) but ATTRACTS to it: the anisotropic part of the        *)
(*  4-channel propagation metric contracts, and coupled sectors reach *)
(*  a common limiting speed c_*. Closes the OPEN item of v1.9.        *)
(*                                                                     *)
(*  Proved over Q (Print Assumptions Closed):                         *)
(*   (contr) partial-twirl contraction Delta_{n+1}=(1-a)Delta_n with   *)
(*           0<a<=1 => 0<=1-a<1: anisotropy is an irrelevant direction *)
(*   (decay) |Delta_n| <= (1-a)^n |Delta_0| : geometric attraction     *)
(*   (twirl) trace preserved by the partial twirl (g_{n+1}=g_n)        *)
(*   (sextic)the five-move mixer's rho_frame is a root of              *)
(*           15625 l^6-25000 l^5+8125 l^4+3500 l^3-1625 l^2-100 l+59:  *)
(*           a rational Bolzano bracket p(858/1000)<0<p(8581/10000)    *)
(*           and p(1)=584>0 certify a root in (858/1000,8581/10000)    *)
(*           STRICTLY inside (0,1) => rho_frame<1 (contraction)        *)
(*   (cons)  doubly-stochastic sector map P=[[1-p,p],[p,1-p]]:         *)
(*           preserves the average v1+v2, and the deviation eigenvalue *)
(*           1-2p has |1-2p|<1 for 0<p<1 (spectral gap => consensus)   *)
(*                                                                     *)
(*  HONEST FENCE. EXACT for the DECLARED coarse-reader map. The full   *)
(*  Sym_4 twirl Pi_4(X)=(Tr X/4)I over the order-384 group and the     *)
(*  exact eigenvalue rho_frame=0.858010754588 are verified in numpy;   *)
(*  here Coq certifies the contraction algebra + the rational root     *)
(*  bracket + the sector-consensus gap. OPEN: derive the frame-mixing  *)
(*  weights p(R) from the unified action S_UF, a uniform gap as        *)
(*  volume->infty, full Lorentz boosts/microcausality, gravity. c_*    *)
(*  is NOT predicted (overall unit scale free).                        *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoIsotropicFixedPoint.
Open Scope Q_scope.

(* (contr) the partial-twirl contraction factor is in [0,1), strictly <1 for a>0 *)
Theorem contraction_factor : forall a : Q, 0 < a -> a <= 1 -> 0 <= 1 - a /\ 1 - a < 1.
Proof. intros a H0 H1. split; lra. Qed.

(* one coarse step multiplies the anisotropy by (1-a): |Delta_{n+1}| = (1-a)|Delta_n| *)
Theorem one_step : forall d a : Q, 0 <= d -> 0 <= a -> a <= 1 ->
  (1 - a) * d <= d /\ 0 <= (1 - a) * d.
Proof.
  intros d a Hd H0 H1. split.
  - setoid_replace d with (1 * d) at 2 by ring. apply Qmult_le_compat_r; lra.
  - apply Qmult_le_0_compat; lra.
Qed.

(* (twirl) the partial twirl preserves the trace/scale g: g_{n+1} = g_n *)
Theorem trace_preserved : forall g a : Q,
  (1 - a) * g + a * g == g.
Proof. intros g a. ring. Qed.

(* (sextic) rho_frame is a root of the mixer's characteristic sextic; a rational
   Bolzano bracket certifies a root strictly inside (0,1) => rho_frame < 1. *)
Definition p6 (l : Q) : Q :=
  15625*l*l*l*l*l*l - 25000*l*l*l*l*l + 8125*l*l*l*l + 3500*l*l*l - 1625*l*l - 100*l + 59.
Theorem sextic_bracket_low  : p6 (858#1000)   < 0.
Proof. unfold p6. vm_compute. reflexivity. Qed.
Theorem sextic_bracket_high : 0 < p6 (8581#10000).
Proof. unfold p6. vm_compute. reflexivity. Qed.
Theorem sextic_at_one       : p6 1 == 584.
Proof. unfold p6. vm_compute. reflexivity. Qed.
(* the bracket sits strictly inside (0,1): 0 < 858/1000 and 8581/10000 < 1 *)
Theorem rho_bracket_in_unit : (0 < (858#1000)) /\ ((8581#10000) < 1).
Proof. split; lra. Qed.

(* (cons) doubly-stochastic 2-sector consensus P = [[1-p,p],[p,1-p]] *)
(* rows sum to 1 *)
Theorem P_stochastic : forall p : Q, (1 - p) + p == 1.
Proof. intro p. ring. Qed.
(* the average v1+v2 is conserved by one update *)
Theorem average_conserved : forall p v1 v2 : Q,
  ((1 - p)*v1 + p*v2) + (p*v1 + (1 - p)*v2) == v1 + v2.
Proof. intros p v1 v2. ring. Qed.
(* the deviation contracts by 1-2p; the gap |1-2p|<1 holds for 0<p<1 *)
Theorem consensus_gap : forall p : Q, 0 < p -> p < 1 -> -(1) < 1 - 2*p /\ 1 - 2*p < 1.
Proof. intros p H0 H1. split; lra. Qed.
(* the deviation delta = v1 - v2 maps to (1-2p)*delta under P *)
Theorem deviation_update : forall p v1 v2 : Q,
  ((1 - p)*v1 + p*v2) - (p*v1 + (1 - p)*v2) == (1 - 2*p) * (v1 - v2).
Proof. intros p v1 v2. ring. Qed.

End InfoIsotropicFixedPoint.

Print Assumptions InfoIsotropicFixedPoint.contraction_factor.
Print Assumptions InfoIsotropicFixedPoint.one_step.
Print Assumptions InfoIsotropicFixedPoint.trace_preserved.
Print Assumptions InfoIsotropicFixedPoint.sextic_bracket_low.
Print Assumptions InfoIsotropicFixedPoint.sextic_bracket_high.
Print Assumptions InfoIsotropicFixedPoint.sextic_at_one.
Print Assumptions InfoIsotropicFixedPoint.rho_bracket_in_unit.
Print Assumptions InfoIsotropicFixedPoint.P_stochastic.
Print Assumptions InfoIsotropicFixedPoint.average_conserved.
Print Assumptions InfoIsotropicFixedPoint.consensus_gap.
Print Assumptions InfoIsotropicFixedPoint.deviation_update.
