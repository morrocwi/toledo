(* =====================================================================
   RDL_MetricReadoutLimit.v
   ---------------------------------------------------------------------
   TIER-1 BRIDGE (over Coq's R; reals axioms DISCLOSED — NOT axiom-free).
   The Δθ→0 (h→0) readout-LIMIT of the operator-first metric, in
   ARBITRARY dimension n.

   TIER-0 (RDL_MetricReadout.v, axiom-free / Q) proved the directional
   symmetric second difference reads off the Hessian quadratic form
   EXACTLY on the quadratic LOCAL model.  This file lifts that to a
   GENERAL smooth n-D field F: R^n -> R via its 2nd-order directional
   Peano expansion, and proves the metric form is recovered IN THE LIMIT:

       [F(x+hv) - 2F(x) + F(x-hv)] / h^2  --h→0-->  2*q

   where q is the directional 2nd-order coefficient (= v^T H v = the
   Hessian quadratic form = the principal symbol gⁱʲv_iv_j).

   It reduces to the 1-D RDL_ContinuumLimit pattern applied to the
   directional restriction g(t) = F(x + t v): n-D because v ranges over
   ALL directions in R^n; sweeping v over a basis + polarisation recovers
   the full metric tensor.

   HONEST AXIOM STATUS: over Coq's classical reals (epsilon-delta limit).
   The Print Assumptions at the bottom disclose exactly which reals axioms
   are used.  This is the TIER-1 readout layer, by design NOT axiom-free —
   the axiom-free content is the discrete TIER-0 root.

   The general-curved-manifold convergence (Belkin–Niyogi / Hein) is a
   separate, declared TIER-2 IMPORT and is NOT proved here.
   ===================================================================== *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Open Scope R_scope.

(* ---- n-D vectors over R ---- *)
Definition Vec : Type := nat -> R.
Definition vadd   (u v : Vec) : Vec := fun i => u i + v i.
Definition vscale (a : R) (v : Vec) : Vec := fun i => a * v i.

(* self-contained "g(h) → L as h→0 through h≠0" (epsilon–delta) *)
Definition tends0 (g : R -> R) (L : R) : Prop :=
  forall eps, eps > 0 -> exists del, del > 0 /\
    forall h, h <> 0 -> Rabs h < del -> Rabs (g h - L) < eps.

(* directional symmetric second difference of an n-D field F along v at base x *)
Definition D2dir (F : Vec -> R) (x v : Vec) (h : R) : R :=
  F (vadd x (vscale h v)) - 2 * F x + F (vadd x (vscale (- h) v)).

Section DSSD.
  Variable F : Vec -> R.
  Variable x v : Vec.
  Variable Lslope q : R.          (* directional 1st-order slope and 2nd-order coeff *)
  Variable r : R -> R.
  (* 2nd-order directional Peano expansion of F along v at x *)
  Hypothesis Hexp : forall h,
    F (vadd x (vscale h v)) = F x + Lslope * h + q * (h * h) + r h.
  Hypothesis Hrem : tends0 (fun h => r h / (h * h)) 0.

  (* the symmetric directional difference cancels the odd (1st-order) term *)
  Lemma D2dir_expand :
    forall h, D2dir F x v h = 2 * q * (h * h) + (r h + r (- h)).
  Proof.
    intro h. unfold D2dir. rewrite (Hexp h).
    assert (Hm : F (vadd x (vscale (- h) v))
                 = F x + Lslope * (- h) + q * ((- h) * (- h)) + r (- h))
      by apply (Hexp (- h)).
    rewrite Hm. ring.
  Qed.

  (* MAIN (TIER-1, n-D): the scaled directional 2nd difference -> 2q in the limit *)
  Theorem directional_second_difference_limit :
    tends0 (fun h => D2dir F x v h / (h * h)) (2 * q).
  Proof.
    intros eps Heps.
    assert (Hhalf : eps / 2 > 0) by lra.
    destruct (Hrem (eps / 2) Hhalf) as [del [Hdel Hb]].
    exists del. split; [exact Hdel|].
    intros h Hh Hhd.
    assert (Hq : D2dir F x v h / (h * h) - 2 * q
                 = r h / (h * h) + r (- h) / (h * h)).
    { rewrite D2dir_expand. field. exact Hh. }
    cbn beta. rewrite Hq.
    assert (Hh'  : - h <> 0) by (intro Hc; apply Hh; lra).
    assert (Hhd' : Rabs (- h) < del) by (rewrite Rabs_Ropp; exact Hhd).
    pose proof (Hb h Hh Hhd) as B1.
    pose proof (Hb (- h) Hh' Hhd') as B2.
    replace ((- h) * (- h)) with (h * h) in B2 by ring.
    replace (r h / (h * h) - 0) with (r h / (h * h)) in B1 by ring.
    replace (r (- h) / (h * h) - 0) with (r (- h) / (h * h)) in B2 by ring.
    apply Rle_lt_trans with (Rabs (r h / (h * h)) + Rabs (r (- h) / (h * h))).
    - apply Rabs_triang.
    - lra.
  Qed.
End DSSD.

(* =====================================================================
   BRIDGE to TIER-0: when the directional restriction is EXACTLY quadratic
   (r ≡ 0, i.e. F is the local quadratic model along v), the limit is the
   exact value 2q with no remainder — the continuous reading agrees with
   the discrete TIER-0 reading D2dir = 2 h^2 q (RDL_MetricReadout).  Here q
   IS the Hessian directional form v^T H v = the principal symbol.
   ===================================================================== *)
Section ExactQuadratic.
  Variable F : Vec -> R.
  Variable x v : Vec.
  Variable Lslope q : R.
  Hypothesis Hquad : forall h,
    F (vadd x (vscale h v)) = F x + Lslope * h + q * (h * h).

  Theorem directional_quadratic_limit :
    tends0 (fun h => D2dir F x v h / (h * h)) (2 * q).
  Proof.
    apply (directional_second_difference_limit F x v Lslope q (fun _ => 0)).
    - intro h. rewrite Hquad. ring.
    - intros eps Heps. exists 1. split; [lra|]. intros h _ _.
      replace (0 / (h * h)) with 0 by (unfold Rdiv; rewrite Rmult_0_l; reflexivity).
      replace (0 - 0) with 0 by ring. rewrite Rabs_R0. exact Heps.
  Qed.
End ExactQuadratic.

(* --- HONEST DISCLOSURE: which reals axioms do these rest on? --- *)
Print Assumptions directional_second_difference_limit.
Print Assumptions directional_quadratic_limit.

(* End RDL_MetricReadoutLimit.v *)
