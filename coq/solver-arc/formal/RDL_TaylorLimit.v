(* ===================================================================== *)
(*  RDL_TaylorLimit.v                                                     *)
(*                                                                        *)
(*  Closing the discrete -> continuum link by an order-2 Taylor-Young     *)
(*  (Peano) expansion, derived from Coq's Mean Value Theorem and          *)
(*  composed with symmetric_second_difference_limit (RDL_ContinuumLimit). *)
(*                                                                        *)
(*  HONESTY NOTE.  Unlike the discrete RD core (RDL_GammaSpectral, over Q,*)
(*  axiom-free), this file lives in the ANALYTIC stratum: it imports the  *)
(*  classical real numbers and therefore depends on Coq's Reals axioms.   *)
(*  This is disclosed by `Print Assumptions` at the bottom.  The result   *)
(*  is the readout-LIMIT layer, exactly where the axiom-free core ends.   *)
(*                                                                        *)
(*  Pure mathematics; no physics vocabulary is used anywhere.             *)
(* ===================================================================== *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Require Import RDL_ContinuumLimit.   (* tends0, D2sym, symmetric_second_difference_limit *)
Open Scope R_scope.

(* --------------------------------------------------------------------- *)
(*  Small reusable derivative facts, each with a clean derivative value.  *)
(*  (Explicit arguments / scal avoid brittle higher-order unification.)   *)
(* --------------------------------------------------------------------- *)

Lemma d_shift : forall x0 t, derivable_pt_lim (fun u => u - x0) t 1.
Proof.
  intros x0 t. replace 1 with (1 - 0) by ring.
  apply derivable_pt_lim_minus.
  - apply derivable_pt_lim_id.
  - apply derivable_pt_lim_const.
Qed.

Lemma d_sq_shift : forall x0 t,
  derivable_pt_lim (fun u => (u - x0) * (u - x0)) t (2 * (t - x0)).
Proof.
  intros x0 t.
  replace (2 * (t - x0)) with (1 * (t - x0) + (t - x0) * 1) by ring.
  apply (derivable_pt_lim_mult (fun u => u - x0) (fun u => u - x0) t 1 1);
    apply d_shift.
Qed.

Lemma d_lin_shift : forall k x0 t,
  derivable_pt_lim (fun u => k * (u - x0)) t (k * 1).
Proof.
  intros k x0 t.
  apply (derivable_pt_lim_scal (fun u => u - x0) k t 1). apply d_shift.
Qed.

Lemma d_sqterm : forall k x0 t,
  derivable_pt_lim (fun u => k * ((u - x0) * (u - x0))) t (k * (2 * (t - x0))).
Proof.
  intros k x0 t.
  apply (derivable_pt_lim_scal (fun u => (u - x0) * (u - x0)) k t (2 * (t - x0))).
  apply d_sq_shift.
Qed.

(* --------------------------------------------------------------------- *)
(*  The order-2 remainder, the auxiliary g, and g's derivative.           *)
(*                                                                        *)
(*    Rem2 h = f(x+h) - f x - f1 x . h - (f2x/2) . h^2                     *)
(*    g(t)   = f t   - f x - f1 x .(t-x) - (f2x/2).(t-x)^2                 *)
(*    g'(t)  = f1 t  - f1 x - f2x.(t-x)                                    *)
(* --------------------------------------------------------------------- *)

Definition Rem2 (f f1 : R -> R) (x f2x h : R) : R :=
  f (x + h) - f x - f1 x * h - (f2x / 2) * (h * h).

Definition Gfun (f f1 : R -> R) (x f2x : R) : R -> R :=
  fun t => f t - f x - f1 x * (t - x) - (f2x / 2) * ((t - x) * (t - x)).

Definition Gder (f1 : R -> R) (x f2x : R) : R -> R :=
  fun t => f1 t - f1 x - f2x * (t - x).

Lemma Gfun_x : forall (f f1 : R -> R) (x f2x : R),
  Gfun f f1 x f2x x = 0.
Proof. intros f f1 x f2x. unfold Gfun. field. Qed.

Lemma Gfun_xh : forall (f f1 : R -> R) (x f2x h : R),
  Gfun f f1 x f2x (x + h) = Rem2 f f1 x f2x h.
Proof. intros f f1 x f2x h. unfold Gfun, Rem2. field. Qed.

Lemma G_deriv : forall (f f1 : R -> R) (x f2x : R),
  (forall y, derivable_pt_lim f y (f1 y)) ->
  forall t, derivable_pt_lim (Gfun f f1 x f2x) t (Gder f1 x f2x t).
Proof.
  intros f f1 x f2x Hf1 t. unfold Gfun, Gder.
  replace (f1 t - f1 x - f2x * (t - x))
     with (((f1 t - 0) - (f1 x * 1)) - (f2x / 2) * (2 * (t - x))) by field.
  apply derivable_pt_lim_minus.
  - apply derivable_pt_lim_minus.
    + apply derivable_pt_lim_minus.
      * apply Hf1.
      * apply derivable_pt_lim_const.
    + apply d_lin_shift.
  - apply d_sqterm.
Qed.

(* --------------------------------------------------------------------- *)
(*  One application of the (Lagrange) Mean Value Theorem MVT_cor2 to g,    *)
(*  in "absolute" form: f appears directly, no chain-rule/shift.          *)
(*  For h <> 0 there is an interior point x+s, 0 < |s| < |h|, with         *)
(*      Rem2 h = g'(x+s) . h.                                             *)
(* --------------------------------------------------------------------- *)

Lemma mvt_pack : forall (f f1 : R -> R) (x f2x : R),
  (forall y, derivable_pt_lim f y (f1 y)) ->
  forall h, h <> 0 ->
  exists s, s <> 0 /\ Rabs s < Rabs h /\
            Rem2 f f1 x f2x h = Gder f1 x f2x (x + s) * h.
Proof.
  intros f f1 x f2x Hf1 h Hh.
  destruct (Rtotal_order h 0) as [Hneg | [Hz | Hpos]].
  - (* h < 0 : apply MVT on [x+h, x] *)
    destruct (MVT_cor2 (Gfun f f1 x f2x) (Gder f1 x f2x) (x + h) x)
      as [c [Hval Hbtw]].
    + lra.
    + intros cc _. apply G_deriv. exact Hf1.
    + exists (c - x). destruct Hbtw as [H1 H2].
      assert (Hcx : x + (c - x) = c) by ring.
      rewrite (Gfun_x f f1 x f2x) in Hval.
      rewrite (Gfun_xh f f1 x f2x h) in Hval.
      repeat split.
      * lra.
      * rewrite (Rabs_left (c - x)) by lra.
        rewrite (Rabs_left h) by lra. lra.
      * rewrite Hcx. nra.
  - exfalso. apply Hh. exact Hz.
  - (* h > 0 : apply MVT on [x, x+h] *)
    destruct (MVT_cor2 (Gfun f f1 x f2x) (Gder f1 x f2x) x (x + h))
      as [c [Hval Hbtw]].
    + lra.
    + intros cc _. apply G_deriv. exact Hf1.
    + exists (c - x). destruct Hbtw as [H1 H2].
      assert (Hcx : x + (c - x) = c) by ring.
      rewrite (Gfun_x f f1 x f2x) in Hval.
      rewrite (Gfun_xh f f1 x f2x h) in Hval.
      repeat split.
      * lra.
      * rewrite (Rabs_pos_eq (c - x)) by lra.
        rewrite (Rabs_pos_eq h) by lra. lra.
      * rewrite Hcx. nra.
Qed.

(* --------------------------------------------------------------------- *)
(*  Helper: |s/h| <= 1 whenever |s| < |h|.                                *)
(* --------------------------------------------------------------------- *)

Lemma Rabs_ratio_le_1 : forall s h,
  h <> 0 -> Rabs s < Rabs h -> Rabs (s / h) <= 1.
Proof.
  intros s h Hh Hlt.
  unfold Rdiv. rewrite Rabs_mult, Rabs_inv.
  assert (Hh' : 0 < Rabs h) by (apply Rabs_pos_lt; exact Hh).
  apply Rmult_le_reg_r with (Rabs h).
  - exact Hh'.
  - rewrite Rmult_assoc, Rinv_l by lra.
    rewrite Rmult_1_r, Rmult_1_l. lra.
Qed.

(* --------------------------------------------------------------------- *)
(*  Taylor-Young (order 2): the remainder is o(h^2).                      *)
(*                                                                        *)
(*  Hypotheses (sharp; no continuity of f'' assumed):                     *)
(*    Hf1 : f differentiable everywhere with derivative f1                *)
(*    Hf2 : f1 differentiable at x  (= f twice-differentiable at x)       *)
(* --------------------------------------------------------------------- *)

Lemma taylor_young2 : forall (f f1 : R -> R) (x f2x : R),
  (forall y, derivable_pt_lim f y (f1 y)) ->
  derivable_pt_lim f1 x f2x ->
  tends0 (fun h => Rem2 f f1 x f2x h / (h * h)) 0.
Proof.
  intros f f1 x f2x Hf1 Hf2.
  unfold tends0. intros eps Heps.
  destruct (Hf2 eps Heps) as [delta Hdelta].
  exists (pos delta). split.
  - apply (cond_pos delta).
  - intros h Hh0 Hhd.
    destruct (mvt_pack f f1 x f2x Hf1 h Hh0) as [s [Hs0 [Hsh Hrem]]].
    assert (Hsd : Rabs s < delta) by (apply Rlt_trans with (Rabs h); assumption).
    rewrite Hrem.
    replace (Gder f1 x f2x (x + s) * h / (h * h) - 0)
       with ((s / h) * ((f1 (x + s) - f1 x) / s - f2x))
       by (unfold Gder; field; split; assumption).
    rewrite Rabs_mult.
    apply Rle_lt_trans with (1 * Rabs ((f1 (x + s) - f1 x) / s - f2x)).
    + apply Rmult_le_compat_r.
      * apply Rabs_pos.
      * apply Rabs_ratio_le_1; assumption.
    + rewrite Rmult_1_l. apply Hdelta; assumption.
Qed.

(* --------------------------------------------------------------------- *)
(*  Final link.  For f twice-differentiable at x (derivative f1 every-    *)
(*  where, f1 differentiable at x with value f2x), the symmetric second   *)
(*  difference quotient D2sym f x h / h^2 converges to f''(x) = f2x.       *)
(*                                                                        *)
(*  This is obtained by feeding the order-2 Taylor-Young expansion         *)
(*  (a2 = f2x/2, remainder Rem2) into symmetric_second_difference_limit,   *)
(*  whose conclusion is the limit 2*a2 = f2x.                              *)
(* --------------------------------------------------------------------- *)

Theorem twice_diff_secondDiff_limit : forall (f f1 : R -> R) (x f2x : R),
  (forall y, derivable_pt_lim f y (f1 y)) ->
  derivable_pt_lim f1 x f2x ->
  tends0 (fun h => D2sym f x h / (h * h)) f2x.
Proof.
  intros f f1 x f2x Hf1 Hf2.
  replace f2x with (2 * (f2x / 2)) by field.
  apply (symmetric_second_difference_limit
           f x (f1 x) (f2x / 2) (Rem2 f f1 x f2x)).
  - intro h. unfold Rem2. field.
  - apply taylor_young2; assumption.
Qed.

(* ===================================================================== *)
(*  CONNECTION TO THE DISCRETE LAYER  (pure mathematics).                 *)
(*                                                                        *)
(*  In RDL_GammaSpectral.v (over Q, AXIOM-FREE) the discrete object        *)
(*                                                                        *)
(*      laplacian_stencil :  D2 f x h  =  f(x+h) - 2 f x + f(x-h)          *)
(*                                                                        *)
(*  is the [1, -2, 1] second-difference stencil, i.e. the discrete        *)
(*  negative-Laplacian acting on a 1-D distinction field, and             *)
(*  secondDiff_quadratic / secondDiff_readout_invariant pin down its      *)
(*  exact value on quadratics (D2 (quad a b c) x h = 2 a h^2), gauge /     *)
(*  edge invariant.                                                       *)
(*                                                                        *)
(*  The continuum counterpart over R is D2sym (RDL_ContinuumLimit.v),      *)
(*  the SAME stencil read on the reals.  twice_diff_secondDiff_limit       *)
(*  above proves precisely that, after the canonical h^2 normalisation,    *)
(*                                                                        *)
(*      lim_{h->0}  D2sym f x h / h^2  =  f''(x).                          *)
(*                                                                        *)
(*  In one dimension the continuum negative-Laplacian operator IS the      *)
(*  second derivative f''.  Hence this is the operator-convergence         *)
(*  statement                                                             *)
(*                                                                        *)
(*      (normalised discrete [1,-2,1] stencil)  -->  (continuum f'')       *)
(*                                                                        *)
(*  the discrete->continuum gate, stated and proved entirely within        *)
(*  real analysis.  The exact-quadratic instance is the meeting point of   *)
(*  the two strata: discretely it is secondDiff_quadratic (value 2 a h^2,  *)
(*  axiom-free); continuously it is the a2 = a case of                     *)
(*  quadratic_symmetric_limit / this theorem (value 2 a, modulo the Reals  *)
(*  axioms).  Both manuscripts that share this spine inherit the gate via  *)
(*  this single analytic fact and nothing more.                           *)
(* ===================================================================== *)

Print Assumptions twice_diff_secondDiff_limit.
