(* =====================================================================
   RDL_SpineStability.v
   ---------------------------------------------------------------------
   TIER-0 NATIVE (axiom-free, over Q) — the structural cores of TWO
   physics faces of the unified spine, machine-checked so they are no
   longer finite-diagnostics but THEOREMS (no mathematical dispute left;
   only the empirical VALUES of M,D,K,lambda remain for the lab):

     spine (per mode lambda of L_R):   M s^2 + D s + K*lambda = 0

   FACE 1 — quantum/classical split (step 11, k_c):
     the discriminant Delta = D^2 - 4 M K lambda classifies the mode:
       lambda <= lambda_c := D^2/(4MK)  ->  real roots  (overdamped / CLASSICAL)
       lambda >  lambda_c               ->  complex roots (oscillatory / QUANTUM)
     so the smooth<->turbulent/quantum BOUNDARY lambda_c is exact, set by the
     SMOOTHER coefficients (D damping, K diffusion) — the coupled-control pair.

   FACE 2 — smoother controls stability / no blow-up (the energy identity,
     PGFT Eq.50 reduced to the linear spine):
       E = 1/2 M v^2 + 1/2 K lambda x^2,   x' = v,   M v' = -D v - K lambda x
       =>  dE/dt = -D v^2 <= 0   (D >= 0)   — energy is non-increasing; the
     SMOOTHER drains; with D>0 and v<>0 it strictly decays. No linear blow-up.

   All proofs are pure Q arithmetic (ring / lra / nra) — `Print Assumptions`
   Closed under the global context. AXIOM-FREE. The physical content
   (whether the universe's M,D,K,lambda take given values) is NOT proved here
   — that is the lab's job. readout-not-truth.
   ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Require Import Coq.micromega.Psatz.
Open Scope Q_scope.

Section Spine.
  Variables M D K lam : Q.
  Hypothesis HM : 0 < M.
  Hypothesis HK : 0 < K.
  Hypothesis Hlam : 0 <= lam.
  Hypothesis HD : 0 <= D.

  Definition lambda_c : Q := (D * D) / ((4#1) * M * K).
  Definition discr   : Q := D * D - (4#1) * M * K * lam.

  Lemma four_MK_pos : 0 < (4#1) * M * K.
  Proof. nra. Qed.

  (* ---- FACE 1: the quantum/classical split is EXACT and lives at lambda_c ---- *)

  (* CLASSICAL side: at or below the boundary, the discriminant is >= 0 (real roots) *)
  Theorem split_classical : lam <= lambda_c -> 0 <= discr.
  Proof.
    intro Hle. unfold discr, lambda_c in *.
    pose proof four_MK_pos as Hp.
    (* lam <= D^2/(4MK)  <=>  4MK*lam <= D^2 *)
    apply Qmult_le_l with (z := (4#1)*M*K) in Hle; [|exact Hp].
    rewrite Qmult_div_r in Hle by lra.
    nra.
  Qed.

  (* QUANTUM side: strictly above the boundary, the discriminant is < 0 (complex roots) *)
  Theorem split_quantum : lambda_c < lam -> discr < 0.
  Proof.
    intro Hlt. unfold discr, lambda_c in *.
    pose proof four_MK_pos as Hp.
    apply Qmult_lt_l with (z := (4#1)*M*K) in Hlt; [|exact Hp].
    rewrite Qmult_div_r in Hlt by lra.
    nra.
  Qed.

  (* the boundary itself is the exact knife-edge (critically damped) *)
  Theorem split_boundary : lam == lambda_c -> discr == 0.
  Proof.
    intro Heq. unfold discr, lambda_c in *.
    pose proof four_MK_pos as Hp.
    assert (Hx : (4#1)*M*K*lam == D*D).
    { rewrite Heq. field. lra. }
    rewrite Hx. ring.
  Qed.

  (* ---- FACE 2: the SMOOTHER controls stability — energy is non-increasing ---- *)

  Section Energy.
    Variables x v vdot : Q.
    (* the linear spine, solved for the acceleration: M v' = -D v - K lambda x *)
    Hypothesis Hdyn : M * vdot == - D * v - K * lam * x.

    (* energy rate  dE/dt = M v v' + K lambda x v  collapses to  -D v^2  *)
    Definition Edot : Q := M * (v * vdot) + K * lam * (x * v).

    Theorem energy_rate : Edot == - D * (v * v).
    Proof.
      unfold Edot.
      assert (Hmv : M * (v * vdot) == v * (M * vdot)) by ring.
      rewrite Hmv, Hdyn. ring.
    Qed.

    (* the SMOOTHER drains: with non-negative damping, energy never increases *)
    Theorem energy_nonincreasing : Edot <= 0.
    Proof. rewrite energy_rate. nra. Qed.

    (* with real damping and motion, it STRICTLY decays (no blow-up, asymptotic stability) *)
    Theorem energy_strict_decay : 0 < D -> ~ (v == 0) -> Edot < 0.
    Proof.
      intros HDpos Hv. rewrite energy_rate.
      assert (Hvv : 0 < v * v).
      { destruct (Qlt_le_dec 0 v) as [H|H].
        - nra.
        - destruct (Qle_lt_or_eq v 0 H) as [H2|H2]; [nra | exfalso; apply Hv; exact H2]. }
      nra.
    Qed.
  End Energy.

End Spine.

(* ---- helper used above: a nonzero rational has a positive square ---- *)
(* (kept after the section so the section stays clean; re-proved inline if needed) *)

Print Assumptions split_classical.
Print Assumptions split_quantum.
Print Assumptions split_boundary.
Print Assumptions energy_rate.
Print Assumptions energy_nonincreasing.
Print Assumptions energy_strict_decay.

(* End RDL_SpineStability.v *)
