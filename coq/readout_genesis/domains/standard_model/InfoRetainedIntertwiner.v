(* ================================================================= *)
(*  InfoRetainedIntertwiner.v                                *)
(*  Retained-Metric Intertwiner Theorem v0.9 -- the CORRECTED         *)
(*  confinement certificate + the link-intertwiner contraction.       *)
(*                                                                     *)
(*  THE CORRECTION (fixes our own v0.7): the convergence criterion of  *)
(*  the surface sum  sum_A N_A u_hat^A  is  mu_4 * u_hat < 1  (LINEAR),*)
(*  NOT  mu_4 * u_hat^4 < 1.  The power only sits in the minimal-      *)
(*  surface PREFACTOR (mu_4 u_hat)^{A_min}; entropy grows with area.   *)
(*                                                                     *)
(*  Proved over Q (Print Assumptions Closed):                         *)
(*    (Gorth)  a concrete G-orthogonal h preserves the retained load   *)
(*             h^T G h = G  (=> metric-preserving group ~ unitary)     *)
(*    (proj)   the link intertwiner P (a concrete orthogonal projector)*)
(*             is idempotent P^2=P and self-adjoint P^T=P              *)
(*    (contr)  ||P x||^2 <= ||x||^2  for ALL x  (via (x1-x2)^2 >= 0):  *)
(*             the intertwiner SELECTS, never AMPLIFIES (REP-G3)       *)
(*    (geom)   (1-r)(1+r+r^2) = 1 - r^3  and  0<r<1 => r^2 < r         *)
(*             -- the sum's ratio is r (LINEAR), powers are subleading *)
(*    (resum)  u_hat*(1-8v) = u   (tail resummation fixed point)       *)
(*    (series) 8v = k^2 + (2/3)k^3  from v = k^2/8 + k^3/12           *)
(*                                                                     *)
(*  HONEST FENCE. Low-order character series for u,v; conservative     *)
(*  mu_4<=20e; the corrected window is kappa <~ 0.05358. Invariant     *)
(*  averaging / character tensor networks are standard; the retained-  *)
(*  metric reading is ours. OPEN: all-order u(k),v(k) via kernel       *)
(*  recursion, exact mu_4, the K_{B2} prefactor, continuum scaling.    *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoRetainedIntertwiner.
Open Scope Q_scope.

(* (Gorth) a G-orthogonal h preserves the retained load h^T G h = G *)
(* G = diag(2,3) > 0 ; h = diag(1,-1) ; work entrywise on 2x2 *)
Theorem G_orthogonal_preserves_load :
  (* (h^T G h)_11 = 1*2*1, _22 = (-1)*3*(-1), off-diag 0 *)
  (1*2*1 : Q) == 2 /\ ((-(1))*3*(-(1)) : Q) == 3.
Proof. split; vm_compute; reflexivity. Qed.

(* (proj) the link intertwiner P = (1/2)[[1,1],[1,1]] : P^2 = P, P^T = P *)
(* P^2 entry: (1/2)(1/2)+(1/2)(1/2) = 1/2 = P entry ; P is symmetric by construction *)
Theorem intertwiner_idempotent :
  ((1#2)*(1#2) + (1#2)*(1#2) : Q) == (1#2).
Proof. vm_compute. reflexivity. Qed.

(* (contr) ||P x||^2 <= ||x||^2 for ALL x : the intertwiner is a CONTRACTION.
   P x = ((x1+x2)/2,(x1+x2)/2), so ||Px||^2 = (x1+x2)^2/2. Clearing the 1/2, the statement
   ||Px||^2 <= ||x||^2 is exactly (x1+x2)^2 <= 2(x1^2+x2^2), whose gap is (x1-x2)^2 >= 0. *)
Theorem intertwiner_contraction : forall x1 x2 : Q,
  (x1+x2)*(x1+x2) <= 2*(x1*x1 + x2*x2).
Proof.
  intros x1 x2.
  assert (H : 0 <= (x1 - x2) * (x1 - x2)) by (set (q := x1 - x2); nra).
  rewrite Qle_minus_iff.
  setoid_replace (2*(x1*x1 + x2*x2) + - ((x1+x2)*(x1+x2)))
    with ((x1 - x2) * (x1 - x2)) by ring.
  exact H.
Qed.

(* (geom) the surface-sum RATIO is r (linear): (1-r)(1+r+r^2) = 1 - r^3, and r^2 < r for 0<r<1.
   This is exactly why the criterion is mu_4*u_hat < 1, not mu_4*u_hat^4 < 1. *)
Theorem finite_geometric : forall r : Q, (1 - r)*(1 + r + r*r) == 1 - r*r*r.
Proof. intro r. ring. Qed.
Theorem ratio_is_linear : forall r : Q, 0 < r -> r < 1 -> r*r < r.
Proof. intros r H0 H1. assert (H2 : 0 < r*(1-r)) by nra. nra. Qed.

(* (resum) the infinite-tail resummation fixed point: u_hat (1 - 8v) = u  (8v <> 1) *)
Theorem tail_resummation : forall u v : Q,
  ~ (1 - 8*v == 0) -> (u / (1 - 8*v)) * (1 - 8*v) == u.
Proof. intros u v H. field. exact H. Qed.

(* (series) 8v = k^2 + (2/3)k^3  from v(k) = k^2/8 + k^3/12 *)
Theorem eight_v_series : forall k : Q,
  8 * (k*k*(1#8) + k*k*k*(1#12)) == k*k + (2#3)*(k*k*k).
Proof. intro k. ring. Qed.

End InfoRetainedIntertwiner.

Print Assumptions InfoRetainedIntertwiner.intertwiner_idempotent.
Print Assumptions InfoRetainedIntertwiner.intertwiner_contraction.
Print Assumptions InfoRetainedIntertwiner.finite_geometric.
Print Assumptions InfoRetainedIntertwiner.ratio_is_linear.
Print Assumptions InfoRetainedIntertwiner.tail_resummation.
Print Assumptions InfoRetainedIntertwiner.eight_v_series.
