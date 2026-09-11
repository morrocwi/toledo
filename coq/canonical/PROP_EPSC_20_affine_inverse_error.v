(* ===================================================================== *)
(*  PROP_EPSC_20_affine_inverse_error.v                                  *)
(*  Generic affine-formula error-propagation bound underlying the         *)
(*  reduced-triad quantitative retained inverse (Toledo weld/P.??.v1,     *)
(*  PROP-EPSC-20): r = (J_{1,a} + 2*nu*x) / (2*c_a), c_a = 3/10,           *)
(*  |r - rhat| <= (sigma_J + 2*nu*sigma_x) / (2*|c_a|).                    *)
(*                                                                         *)
(*  What this proves: r is, by construction, an affine function of the    *)
(*  two measured quantities J and x with a fixed nonzero rational          *)
(*  coefficient c_a and a fixed nonnegative rational coefficient 2*nu on   *)
(*  x. Given independent worst-case (triangle-inequality) error radii      *)
(*  sigma_J, sigma_x on J and x respectively -- i.e. |J-Jhat| <= sigma_J   *)
(*  and |x-xhat| <= sigma_x for the corresponding approximations Jhat,    *)
(*  xhat -- the induced error on r = (J+2*nu*x)/(2*c_a) versus            *)
(*  rhat = (Jhat+2*nu*xhat)/(2*c_a) is bounded by exactly the stated       *)
(*  formula. This is EXACT for an affine map (no linearization/           *)
(*  first-order truncation is involved, unlike error propagation through   *)
(*  a nonlinear function): the identity r-rhat = ((J-Jhat)+2*nu*(x-xhat))  *)
(*  /(2*c_a) is a plain algebraic rearrangement, and the bound is then      *)
(*  the ordinary triangle inequality plus homogeneity of the absolute      *)
(*  value under multiplication by a fixed scalar.                          *)
(*                                                                         *)
(*  What this does NOT prove: that the reduced-triad model itself is a     *)
(*  faithful reduction of the underlying Navier-Stokes shell-energy         *)
(*  system, that c_a = 3/10 is the correct value from that model's own      *)
(*  derivation (the source PROP-EPSC-20 entry cites its coefficient from    *)
(*  the reduced triad model; this file takes c_a as a GIVEN nonzero          *)
(*  rational parameter and re-derives only the error-propagation step),     *)
(*  or that J_{1,a} and x are actually observable/measurable with the        *)
(*  claimed independent radii sigma_J, sigma_x -- those are the calling      *)
(*  proposal's own measurement-model hypotheses, taken here exactly as       *)
(*  stated. The corollary at the end substitutes the specific ca = 3/10      *)
(*  reported by the source but is otherwise identical to the generic         *)
(*  theorem.                                                                 *)
(*                                                                         *)
(*  Rational-native (no Coq.Reals), matching this repo's existing           *)
(*  precedent (PROP_CONF_03_union_bound.v, PROP_NS_TAPE_CLOSED_DOMAIN_01.v): *)
(*  nu, c_a, J, x and their radii are declared as abstract Q parameters --   *)
(*  nothing here needs the reals.                                           *)
(*                                                                         *)
(*  Expected: Print Assumptions affine_inverse_error_bound,                *)
(*  Print Assumptions epsc20_reduced_triad_error_bound                     *)
(*    => Closed under the global context (both, axiom-free).               *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.QArith.Qabs.
Require Import Coq.micromega.Lia.
Local Open Scope Q_scope.

(* ------------------------------------------------------------------- *)
(*  Small reusable Q facts not already named in the standard library.   *)
(* ------------------------------------------------------------------- *)

Lemma Qabs_div : forall a b : Q, Qabs (a / b) == Qabs a / Qabs b.
Proof.
  intros a b. unfold Qdiv. rewrite Qabs_Qmult, Qabs_Qinv. reflexivity.
Qed.

Lemma Qabs_pos_of_nonzero : forall q : Q, ~ q == 0 -> 0 < Qabs q.
Proof.
  intros q Hq.
  destruct (Qlt_le_dec 0 (Qabs q)) as [Hlt | Hle].
  - exact Hlt.
  - exfalso. apply Hq.
    apply Qabs_Qle_condition in Hle.
    destruct Hle as [Hge Hle0].
    apply Qle_antisym.
    + exact Hle0.
    + assert (Hzero : - (0) == 0) by ring.
      rewrite Hzero in Hge.
      exact Hge.
Qed.

Lemma Qdiv_le_compat_r : forall A B D : Q, 0 < D -> A <= B -> A / D <= B / D.
Proof.
  intros A B D HD HAB.
  assert (HD0 : ~ D == 0) by (intro Heq; rewrite Heq in HD; apply (Qlt_irrefl 0); exact HD).
  apply Qle_shift_div_r; [exact HD |].
  rewrite Qmult_comm.
  rewrite Qmult_div_r by exact HD0.
  exact HAB.
Qed.

(* ------------------------------------------------------------------- *)
(*  The generic affine-formula error-propagation lemma.                 *)
(* ------------------------------------------------------------------- *)

Section AffineErrorPropagation.

  Variable ca nu : Q.
  Variable J Jhat x xhat sigmaJ sigmaX : Q.

  Hypothesis Hca_nonzero : ~ ca == 0.
  Hypothesis Hnu_nonneg  : 0 <= nu.
  Hypothesis HJ_bound    : Qabs (J - Jhat) <= sigmaJ.
  Hypothesis Hx_bound    : Qabs (x - xhat) <= sigmaX.

  Definition r    : Q := (J + 2 * nu * x) / (2 * ca).
  Definition rhat : Q := (Jhat + 2 * nu * xhat) / (2 * ca).

  Theorem affine_inverse_error_bound :
    Qabs (r - rhat) <= (sigmaJ + 2 * nu * sigmaX) / (2 * Qabs ca).
  Proof.
    unfold r, rhat.
    assert (Hdiff :
      (J + 2 * nu * x) / (2 * ca) - (Jhat + 2 * nu * xhat) / (2 * ca)
      == ((J - Jhat) + 2 * nu * (x - xhat)) / (2 * ca)).
    { unfold Qdiv. ring. }
    rewrite Hdiff.
    rewrite Qabs_div.
    assert (Hden : Qabs (2 * ca) == 2 * Qabs ca).
    { rewrite Qabs_Qmult. rewrite (Qabs_pos 2); [reflexivity | unfold Qle; simpl; lia]. }
    rewrite Hden.
    apply Qle_trans with (y := (sigmaJ + 2 * nu * sigmaX) / (2 * Qabs ca)).
    - apply Qdiv_le_compat_r.
      + apply Qmult_lt_0_compat; [unfold Qlt; simpl; lia | apply Qabs_pos_of_nonzero; exact Hca_nonzero].
      + apply Qle_trans with (y := Qabs (J - Jhat) + Qabs (2 * nu * (x - xhat))).
        * apply Qabs_triangle.
        * apply Qplus_le_compat.
          -- exact HJ_bound.
          -- rewrite Qabs_Qmult.
             rewrite (Qabs_pos (2 * nu)) by (apply Qmult_le_0_compat; [unfold Qle; simpl; lia | exact Hnu_nonneg]).
             apply Qmult_le_compat_nonneg.
             ++ split; [apply Qmult_le_0_compat; [unfold Qle; simpl; lia | exact Hnu_nonneg] | apply Qle_refl].
             ++ split; [apply Qabs_nonneg | exact Hx_bound].
    - apply Qle_refl.
  Qed.

End AffineErrorPropagation.

(* ------------------------------------------------------------------- *)
(*  Corollary instantiating the source's own coefficient c_a = 3/10.    *)
(* ------------------------------------------------------------------- *)

Theorem epsc20_reduced_triad_error_bound :
  forall (nu J Jhat x xhat sigmaJ sigmaX : Q),
    0 <= nu ->
    Qabs (J - Jhat) <= sigmaJ ->
    Qabs (x - xhat) <= sigmaX ->
    Qabs ((J + 2 * nu * x) / (2 * (3 # 10)) - (Jhat + 2 * nu * xhat) / (2 * (3 # 10)))
      <= (sigmaJ + 2 * nu * sigmaX) / (2 * Qabs (3 # 10)).
Proof.
  intros nu J Jhat x xhat sigmaJ sigmaX Hnu HJ Hx.
  apply (affine_inverse_error_bound (3 # 10) nu J Jhat x xhat sigmaJ sigmaX).
  - unfold Qeq. simpl. lia.
  - exact Hnu.
  - exact HJ.
  - exact Hx.
Qed.
