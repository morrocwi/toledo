(* ===================================================================== *)
(*  DRL_Discrete.v -- Coq lift of the Discrete Retention Lagrangian (DRL) *)
(*  core, GATE 1 of the DRL three-gates program (2026-07-19).            *)
(*                                                                        *)
(*  Ground truth: v2/DISCRETE_RETENTION_LAGRANGIAN.md (equation) and     *)
(*  ap/ap5_drl.py (executed discretization -- action() is the reference  *)
(*  implementation this file formalizes). TOY TIER, declared: a 3-node   *)
(*  ring (N=3, matching ap5's np.roll Laplacian structure) modeled over  *)
(*  the minimum number of time slices each claim needs.                  *)
(*                                                                        *)
(*  What this file PROVES (and nothing more):                            *)
(*   (T1) EL-identity: for the discrete doubled action, modeled over 3   *)
(*        consecutive time slices (the minimum EL needs to see an        *)
(*        interior stationarity point), the central-difference           *)
(*        stationarity condition dS/dPsi_i = 0 at the interior slice is  *)
(*        ALGEBRAICALLY EQUIVALENT (an iff, proved by field/ring over R, *)
(*        no approximation) to the damped recurrence of ap5_drl.py's     *)
(*        el_trajectories(); dS/dPhi_i = 0 gives the sign-flipped        *)
(*        (anti-damped) recurrence. Proved at node 1 and node 2 of the   *)
(*        ring for the Psi-variation (showing the identity is not        *)
(*        node-1-special-cased) and at node 1 for the Phi-variation.     *)
(*        Node 3 is symmetric under the ring's node-relabeling and is    *)
(*        NOT separately claimed here (would be a routine repeat).       *)
(*   (T2) D-cancellation: the discrete Legendre transform H = p_phi.vPhi *)
(*        + p_psi.vPsi - ell is, algebraically, exactly the D-free        *)
(*        expression M vPhi.vPsi + K Phi.L_R.Psi + k2 Phi.Psi -- proved   *)
(*        generically (vPhi, vPsi, Phi, Psi free real vectors, no        *)
(*        recurrence assumed) by `ring`, i.e. it holds for ANY state,     *)
(*        not just on-shell trajectories.                                *)
(*   (T3, bonus) D=0 exact leapfrog invariant: the (dt^2-cleared) D=0     *)
(*        conservative recurrence is linear, hence (M<>0) solves          *)
(*        uniquely for the next slice; substituting two such steps and    *)
(*        proving the shadow energy E = (M/2) d^n.d^{n-1} + (dt^2/2)      *)
(*        x^n.A.x^n is exactly conserved one step, by `field` over R.     *)
(*                                                                        *)
(*  What this file DOES NOT claim (forbidden by the handoff, and true):  *)
(*   - NOT claimed: exact conservation of the discrete distinction charge*)
(*     H along a FULL trajectory of ap5_drl.el_trajectories. Numerics     *)
(*     (ap/ap5_drl.py, test_charge_drift_scales_as_dt_squared) show O(dt^2)*)
(*     drift over long runs; that is a genuine truncation-error residual,*)
(*     not formalized or claimed away here. T3's exact one-step invariant*)
(*     is the D=0 (conservative) special case only, which is the case    *)
(*     ap5_drl.py's own test_reduction_d_zero_conservative also checks    *)
(*     numerically (rel. drift < 1e-3 there; here it is exact, by         *)
(*     construction of the special case D=0, not a claim about D<>0).    *)
(*   - NOT claimed: any of this generalizes off the 3-ring / to nonlinear *)
(*     potentials or per-node parameters (that is Gate 2's job,          *)
(*     ap/ap6_drl_general.py, out of scope for this file).               *)
(*   - NOT claimed: novelty. Kinship (Bateman 1931, CTP/Keldysh doubling, *)
(*     discrete variational integrators) is declared in                  *)
(*     v2/DISCRETE_RETENTION_LAGRANGIAN.md and not repeated here.         *)
(* ===================================================================== *)

Require Import Reals.
Require Import Lra.
Open Scope R_scope.

(* ===================================================================== *)
(*  Common ring-Laplacian helper: 3-node ring / complete graph K3.        *)
(*  L_R = 2I - roll(I,1) - roll(I,-1) on N=3 collapses to the K3          *)
(*  Laplacian [[2,-1,-1],[-1,2,-1],[-1,-1,2]] (checked by hand against    *)
(*  ap5_drl.py's `L_R = 2*np.eye(N) - np.roll(np.eye(N),1,0)              *)
(*  - np.roll(np.eye(N),-1,0)` at N=3).                                   *)
(* ===================================================================== *)
Definition LR1 (a b c : R) : R := 2 * a - b - c.

(* ===================================================================== *)
(*  T1 -- EL-identity on the 3-ring, modeled over 3 consecutive time      *)
(*  slices (indices 0,1,2 -- slice 1 is the interior stationarity point).*)
(*  Sfun is the literal discretization of ap5_drl.action() restricted to *)
(*  N=3 nodes and T=3 slices (two consecutive pairs: (0,1) and (1,2)).   *)
(* ===================================================================== *)
Section EL_Identity.

Definition Sfun (M D K K2 dt
                  P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
                  S0_1 S0_2 S0_3 S1_1 S1_2 S1_3 S2_1 S2_2 S2_3 : R) : R :=
  let kin :=
    (M / dt) *
      ( (P1_1 - P0_1) * (S1_1 - S0_1) + (P1_2 - P0_2) * (S1_2 - S0_2)
        + (P1_3 - P0_3) * (S1_3 - S0_3)
        + (P2_1 - P1_1) * (S2_1 - S1_1) + (P2_2 - P1_2) * (S2_2 - S1_2)
        + (P2_3 - P1_3) * (S2_3 - S1_3) ) in
  let damp :=
    (D / 2) *
      ( (P0_1 * (S1_1 - S0_1) - S0_1 * (P1_1 - P0_1))
        + (P0_2 * (S1_2 - S0_2) - S0_2 * (P1_2 - P0_2))
        + (P0_3 * (S1_3 - S0_3) - S0_3 * (P1_3 - P0_3))
        + (P1_1 * (S2_1 - S1_1) - S1_1 * (P2_1 - P1_1))
        + (P1_2 * (S2_2 - S1_2) - S1_2 * (P2_2 - P1_2))
        + (P1_3 * (S2_3 - S1_3) - S1_3 * (P2_3 - P1_3)) ) in
  let pot :=
    dt *
      ( K * (P0_1 * LR1 S0_1 S0_2 S0_3 + P0_2 * LR1 S0_2 S0_1 S0_3
             + P0_3 * LR1 S0_3 S0_1 S0_2)
        + K2 * (P0_1 * S0_1 + P0_2 * S0_2 + P0_3 * S0_3)
        + K * (P1_1 * LR1 S1_1 S1_2 S1_3 + P1_2 * LR1 S1_2 S1_1 S1_3
               + P1_3 * LR1 S1_3 S1_1 S1_2)
        + K2 * (P1_1 * S1_1 + P1_2 * S1_2 + P1_3 * S1_3) ) in
  kin + damp - pot.

(* ---- variation w.r.t. Psi at the interior slice, node 1 ---- *)

Definition grad_S1_1 (M D K K2 dt
                       P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
                       S0_1 S0_2 S0_3 S1_2 S1_3 S2_1 S2_2 S2_3 h : R) : R :=
  ( Sfun M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 (0 + h) S1_2 S1_3 S2_1 S2_2 S2_3
    - Sfun M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
           S0_1 S0_2 S0_3 (0 - h) S1_2 S1_3 S2_1 S2_2 S2_3 ) / (2 * h).

(** The central-difference derivative of S at Psi-node1-slice1 is, exactly
    (for any nonzero probe h -- S is affine in this variable so h cancels),
    the literal analytic coefficient; and that coefficient vanishing is
    algebraically equivalent (dt<>0) to the damped recurrence of
    el_trajectories() for node 1: `Phi[n+1]=ip@(-(a_mid Phi[n])-a_minus Phi[n-1])`. *)
Theorem T1_el_psi_node1 :
  forall M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 S1_2 S1_3 S2_1 S2_2 S2_3 h,
  h <> 0 -> dt <> 0 ->
  ( grad_S1_1 M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
              S0_1 S0_2 S0_3 S1_2 S1_3 S2_1 S2_2 S2_3 h = 0
    <->
    (M / dt^2) * (P2_1 - 2 * P1_1 + P0_1)
    + (D / (2 * dt)) * (P2_1 - P0_1)
    + K * LR1 P1_1 P1_2 P1_3 + K2 * P1_1 = 0 ).
Proof.
  intros M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 S1_2 S1_3 S2_1 S2_2 S2_3 h Hh Hdt.
  unfold LR1.
  assert (Hkey :
    grad_S1_1 M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
              S0_1 S0_2 S0_3 S1_2 S1_3 S2_1 S2_2 S2_3 h
    = - dt * ( (M / dt^2) * (P2_1 - 2 * P1_1 + P0_1)
               + (D / (2 * dt)) * (P2_1 - P0_1)
               + K * (2 * P1_1 - P1_2 - P1_3) + K2 * P1_1 )).
  { unfold grad_S1_1, Sfun, LR1. field. split; assumption. }
  rewrite Hkey.
  split.
  - intro Heq.
    apply (Rmult_integral (- dt)
             ((M / dt ^ 2) * (P2_1 - 2 * P1_1 + P0_1) +
              D / (2 * dt) * (P2_1 - P0_1) + K * (2 * P1_1 - P1_2 - P1_3) + K2 * P1_1))
      in Heq.
    destruct Heq as [Hz | Hz]; [ lra | assumption ].
  - intro Heq. rewrite Heq. ring.
Qed.

(* ---- variation w.r.t. Psi at the interior slice, node 2 (same shape,   *)
(*      different neighbor pair -- shows the identity is generic on the   *)
(*      ring, not special-cased to node 1). ---- *)

Definition grad_S1_2 (M D K K2 dt
                       P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
                       S0_1 S0_2 S0_3 S1_1 S1_3 S2_1 S2_2 S2_3 h : R) : R :=
  ( Sfun M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 S1_1 (0 + h) S1_3 S2_1 S2_2 S2_3
    - Sfun M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
           S0_1 S0_2 S0_3 S1_1 (0 - h) S1_3 S2_1 S2_2 S2_3 ) / (2 * h).

Theorem T1_el_psi_node2 :
  forall M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 S1_1 S1_3 S2_1 S2_2 S2_3 h,
  h <> 0 -> dt <> 0 ->
  ( grad_S1_2 M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
              S0_1 S0_2 S0_3 S1_1 S1_3 S2_1 S2_2 S2_3 h = 0
    <->
    (M / dt^2) * (P2_2 - 2 * P1_2 + P0_2)
    + (D / (2 * dt)) * (P2_2 - P0_2)
    + K * LR1 P1_2 P1_1 P1_3 + K2 * P1_2 = 0 ).
Proof.
  intros M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 S1_1 S1_3 S2_1 S2_2 S2_3 h Hh Hdt.
  unfold LR1.
  assert (Hkey :
    grad_S1_2 M D K K2 dt P0_1 P0_2 P0_3 P1_1 P1_2 P1_3 P2_1 P2_2 P2_3
              S0_1 S0_2 S0_3 S1_1 S1_3 S2_1 S2_2 S2_3 h
    = - dt * ( (M / dt^2) * (P2_2 - 2 * P1_2 + P0_2)
               + (D / (2 * dt)) * (P2_2 - P0_2)
               + K * (2 * P1_2 - P1_1 - P1_3) + K2 * P1_2 )).
  { unfold grad_S1_2, Sfun, LR1. field. split; assumption. }
  rewrite Hkey.
  split.
  - intro Heq.
    apply (Rmult_integral (- dt)
             ((M / dt ^ 2) * (P2_2 - 2 * P1_2 + P0_2) +
              D / (2 * dt) * (P2_2 - P0_2) + K * (2 * P1_2 - P1_1 - P1_3) + K2 * P1_2))
      in Heq.
    destruct Heq as [Hz | Hz]; [ lra | assumption ].
  - intro Heq. rewrite Heq. ring.
Qed.

(* ---- variation w.r.t. Phi at the interior slice, node 1: the           *)
(*      sign-flipped (anti-damped) recurrence, EL_Phi. ---- *)

Definition grad_P1_1 (M D K K2 dt
                       P0_1 P0_2 P0_3 P1_2 P1_3 P2_1 P2_2 P2_3
                       S0_1 S0_2 S0_3 S1_1 S1_2 S1_3 S2_1 S2_2 S2_3 h : R) : R :=
  ( Sfun M D K K2 dt P0_1 P0_2 P0_3 (0 + h) P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 S1_1 S1_2 S1_3 S2_1 S2_2 S2_3
    - Sfun M D K K2 dt P0_1 P0_2 P0_3 (0 - h) P1_2 P1_3 P2_1 P2_2 P2_3
           S0_1 S0_2 S0_3 S1_1 S1_2 S1_3 S2_1 S2_2 S2_3 ) / (2 * h).

Theorem T1_el_phi_node1 :
  forall M D K K2 dt P0_1 P0_2 P0_3 P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 S1_1 S1_2 S1_3 S2_1 S2_2 S2_3 h,
  h <> 0 -> dt <> 0 ->
  ( grad_P1_1 M D K K2 dt P0_1 P0_2 P0_3 P1_2 P1_3 P2_1 P2_2 P2_3
              S0_1 S0_2 S0_3 S1_1 S1_2 S1_3 S2_1 S2_2 S2_3 h = 0
    <->
    (M / dt^2) * (S2_1 - 2 * S1_1 + S0_1)
    - (D / (2 * dt)) * (S2_1 - S0_1)
    + K * LR1 S1_1 S1_2 S1_3 + K2 * S1_1 = 0 ).
Proof.
  intros M D K K2 dt P0_1 P0_2 P0_3 P1_2 P1_3 P2_1 P2_2 P2_3
         S0_1 S0_2 S0_3 S1_1 S1_2 S1_3 S2_1 S2_2 S2_3 h Hh Hdt.
  unfold LR1.
  assert (Hkey :
    grad_P1_1 M D K K2 dt P0_1 P0_2 P0_3 P1_2 P1_3 P2_1 P2_2 P2_3
              S0_1 S0_2 S0_3 S1_1 S1_2 S1_3 S2_1 S2_2 S2_3 h
    = - dt * ( (M / dt^2) * (S2_1 - 2 * S1_1 + S0_1)
               - (D / (2 * dt)) * (S2_1 - S0_1)
               + K * (2 * S1_1 - S1_2 - S1_3) + K2 * S1_1 )).
  { unfold grad_P1_1, Sfun, LR1. field. split; assumption. }
  rewrite Hkey.
  split.
  - intro Heq.
    apply (Rmult_integral (- dt)
             ((M / dt ^ 2) * (S2_1 - 2 * S1_1 + S0_1) -
              D / (2 * dt) * (S2_1 - S0_1) + K * (2 * S1_1 - S1_2 - S1_3) + K2 * S1_1))
      in Heq.
    destruct Heq as [Hz | Hz]; [ lra | assumption ].
  - intro Heq. rewrite Heq. ring.
Qed.

End EL_Identity.

(* ===================================================================== *)
(*  T2 -- D-cancellation: the discrete Legendre transform of the DRL      *)
(*  Lagrangian density ell = L^n/dt is D-free. This holds for ANY free    *)
(*  state and velocity (Phi,Psi,vPhi,vPsi) -- no on-shell / recurrence    *)
(*  hypothesis is needed, it is a pure algebraic identity of the          *)
(*  Legendre transform of ell, proved by `ring` alone (no division).      *)
(* ===================================================================== *)
Section Legendre.

Variables M D K K2 : R.
Variables q1 q2 q3 r1 r2 r3 vq1 vq2 vq3 vr1 vr2 vr3 : R.

(* ell = L^n / dt, i.e. the Lagrangian rewritten in velocities
   vq = (Phi^{n+1}-Phi^n)/dt, vr = (Psi^{n+1}-Psi^n)/dt (matches ap5_drl's
   action() after factoring out the shared dt scale of each term). *)
Definition ell : R :=
  M * (vq1 * vr1 + vq2 * vr2 + vq3 * vr3)
  + (D / 2) * ( (q1 * vr1 + q2 * vr2 + q3 * vr3)
                - (r1 * vq1 + r2 * vq2 + r3 * vq3) )
  - K * (q1 * LR1 r1 r2 r3 + q2 * LR1 r2 r1 r3 + q3 * LR1 r3 r1 r2)
  - K2 * (q1 * r1 + q2 * r2 + q3 * r3).

(* momenta conjugate to Phi (p_phi := d ell / d vq) and to Psi
   (p_psi := d ell / d vr), read directly off ell's affine dependence on
   the velocities (ell is affine, in fact linear, in each of vq_i, vr_i
   separately -- same structure as the T1 action, so the "derivative" is
   again just the literal coefficient, here computed by hand and then
   checked to reconstruct ell exactly, see ell_reconstructs below). *)
Definition p_phi1 : R := M * vr1 - (D / 2) * r1.
Definition p_phi2 : R := M * vr2 - (D / 2) * r2.
Definition p_phi3 : R := M * vr3 - (D / 2) * r3.
Definition p_psi1 : R := M * vq1 + (D / 2) * q1.
Definition p_psi2 : R := M * vq2 + (D / 2) * q2.
Definition p_psi3 : R := M * vq3 + (D / 2) * q3.

Definition H : R :=
  (p_phi1 * vq1 + p_phi2 * vq2 + p_phi3 * vq3)
  + (p_psi1 * vr1 + p_psi2 * vr2 + p_psi3 * vr3)
  - ell.

(** THE claim: p_phi.vPhi + p_psi.vPsi - ell is D-free -- exactly
    M vPhi.vPsi + K Phi.L_R.Psi + k2 Phi.Psi, with no D anywhere. Pure
    polynomial identity: `ring` closes it without any side condition. *)
Theorem T2_D_cancellation :
  H = M * (vq1 * vr1 + vq2 * vr2 + vq3 * vr3)
      + K * (q1 * LR1 r1 r2 r3 + q2 * LR1 r2 r1 r3 + q3 * LR1 r3 r1 r2)
      + K2 * (q1 * r1 + q2 * r2 + q3 * r3).
Proof. unfold H, ell, p_phi1, p_phi2, p_phi3, p_psi1, p_psi2, p_psi3, LR1. ring. Qed.

(* Sanity check that p_phi/p_psi as defined really do reconstruct ell as
   a Legendre-consistent momentum pair (p_phi.vq + p_psi.vr agrees with
   2*(the velocity-bilinear part of ell) as it must for genuinely affine
   momenta) -- an internal consistency check, not an extra physical claim. *)
Remark momenta_are_ells_velocity_coefficients :
  p_phi1 * vq1 + p_phi2 * vq2 + p_phi3 * vq3
  + p_psi1 * vr1 + p_psi2 * vr2 + p_psi3 * vr3
  = 2 * (M * (vq1 * vr1 + vq2 * vr2 + vq3 * vr3))
    + (D / 2) * ( (q1 * vr1 + q2 * vr2 + q3 * vr3)
                  - (r1 * vq1 + r2 * vq2 + r3 * vq3) ).
Proof. unfold p_phi1, p_phi2, p_phi3, p_psi1, p_psi2, p_psi3. ring. Qed.

End Legendre.

(* ===================================================================== *)
(*  T3 (bonus) -- D=0 exact leapfrog invariant on the 3-ring.             *)
(*  The D=0 recurrence M*(next-2cur+prev) + dt^2*(K*(L_R cur)+k2*cur) = 0 *)
(*  is LINEAR, so (given M<>0) it determines `next` uniquely as an       *)
(*  explicit linear function of (prev,cur); we take two such steps       *)
(*  (x0,x1 -> x2, then x1,x2 -> x3) and prove the shadow energy           *)
(*  E = (M/2) d^n.d^{n-1} + (dt^2/2) x^n.A.x^n is EXACTLY conserved       *)
(*  across the step -- a polynomial identity (quadratic in x0,x1 once    *)
(*  x2,x3 are substituted in, since the recurrence is linear), closed by *)
(*  `field` over R given M<>0, dt<>0. D=0 special case only -- matches   *)
(*  the boundary ap5_drl.py's test_reduction_d_zero_conservative checks  *)
(*  numerically (rel. drift < 1e-3 there; here it is exact by            *)
(*  construction of the D=0 case, not a claim about D<>0).               *)
(* ===================================================================== *)
Section Leapfrog_D0.

Variables M K K2 dt : R.

Definition Escaled (prev1 prev2 prev3 cur1 cur2 cur3 next1 next2 next3 : R) : R :=
  (M / 2) * ( (next1 - cur1) * (cur1 - prev1) + (next2 - cur2) * (cur2 - prev2)
              + (next3 - cur3) * (cur3 - prev3) )
  + (dt^2 / 2) * ( cur1 * (K * LR1 cur1 cur2 cur3 + K2 * cur1)
                   + cur2 * (K * LR1 cur2 cur1 cur3 + K2 * cur2)
                   + cur3 * (K * LR1 cur3 cur1 cur2 + K2 * cur3) ).

(* the unique D=0 recurrence step, solved for `next` (M<>0): this is the
   SAME recurrence as Rec1 in the EL-identity section, M*(next-2cur+prev)
   + dt^2*(K*(L_R cur)+k2*cur) = 0, just rearranged as an explicit formula
   for `next` rather than an implicit relation -- equivalent given M<>0. *)
Definition step1 (prev1 prev2 prev3 cur1 cur2 cur3 : R) : R :=
  2 * cur1 - prev1 - (dt^2 / M) * (K * LR1 cur1 cur2 cur3 + K2 * cur1).
Definition step2 (prev1 prev2 prev3 cur1 cur2 cur3 : R) : R :=
  2 * cur2 - prev2 - (dt^2 / M) * (K * LR1 cur2 cur1 cur3 + K2 * cur2).
Definition step3 (prev1 prev2 prev3 cur1 cur2 cur3 : R) : R :=
  2 * cur3 - prev3 - (dt^2 / M) * (K * LR1 cur3 cur1 cur2 + K2 * cur3).

Theorem T3_leapfrog_D0_invariant :
  forall x0_1 x0_2 x0_3 x1_1 x1_2 x1_3,
  M <> 0 -> dt <> 0 ->
  let x2_1 := step1 x0_1 x0_2 x0_3 x1_1 x1_2 x1_3 in
  let x2_2 := step2 x0_1 x0_2 x0_3 x1_1 x1_2 x1_3 in
  let x2_3 := step3 x0_1 x0_2 x0_3 x1_1 x1_2 x1_3 in
  let x3_1 := step1 x1_1 x1_2 x1_3 x2_1 x2_2 x2_3 in
  let x3_2 := step2 x1_1 x1_2 x1_3 x2_1 x2_2 x2_3 in
  let x3_3 := step3 x1_1 x1_2 x1_3 x2_1 x2_2 x2_3 in
  Escaled x0_1 x0_2 x0_3 x1_1 x1_2 x1_3 x2_1 x2_2 x2_3
  = Escaled x1_1 x1_2 x1_3 x2_1 x2_2 x2_3 x3_1 x3_2 x3_3.
Proof.
  intros x0_1 x0_2 x0_3 x1_1 x1_2 x1_3 HM Hdt.
  unfold Escaled, step1, step2, step3, LR1.
  field. auto.
Qed.

End Leapfrog_D0.
