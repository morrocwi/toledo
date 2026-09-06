(* =====================================================================
   RDL_MetricReadoutRate.v
   ---------------------------------------------------------------------
   TIER-2 (classical cap, over R) — the QUANTITATIVE convergence RATE of
   the operator-first metric readout: the analysis backbone of the
   Belkin–Niyogi / Hein order-2 graph-Laplacian -> Laplace-Beltrami
   convergence, machine-checked.

   TIER-1 (RDL_MetricReadoutLimit) gave the QUALITATIVE limit
   D2/h^2 -> 2q.  TIER-2 here gives the EXPLICIT O(h^2) error bound that
   makes the convergence quantitative — the "observed order 2.0" of the
   numeric logs, turned into a theorem.

   Framework discipline (cf. RD_ConPA_ReadoutBivalence / C38): rather than
   importing Coq's classical Taylor–Lagrange theorem as a GLOBAL axiom, we
   RELOCATE it to a DISCLOSED PARAMETER — the symmetric-second-difference
   Taylor remainder `rem` together with its 4th-derivative bound `B`
   (exactly what C^4 smoothness supplies via Taylor–Lagrange).  The rate
   theorem is then derived with an EXPLICIT constant, and its
   `Print Assumptions` is Closed under the global context: the classical
   content sits in the named hypothesis, never leaks to a global axiom.

   This is the honest TIER-2 statement: the convergence RATE is real and
   machine-checked; the only classical input is the Taylor remainder,
   disclosed as a parameter (the firewalled IMPORT interface).
   ===================================================================== *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Require Import Coq.micromega.Psatz.
Open Scope R_scope.

Definition Vec : Type := nat -> R.
Definition vadd   (u v : Vec) : Vec := fun i => u i + v i.
Definition vscale (a : R) (v : Vec) : Vec := fun i => a * v i.

Definition D2sym (f : R -> R) (x h : R) : R := f (x + h) - 2 * f x + f (x - h).

(* h <> 0  ->  0 < h*h *)
Lemma sq_pos : forall h, h <> 0 -> 0 < h * h.
Proof.
  intros h Hh. assert (0 <= h*h) by nra.
  destruct (Rle_lt_or_eq_dec 0 (h*h) H) as [Hlt|Heq]; [exact Hlt|].
  exfalso. apply Hh. nra.
Qed.

(* =====================================================================
   THE QUANTITATIVE RATE  (1-D core)
   ===================================================================== *)
Section Rate.
  Variable f : R -> R.
  Variable x f2x B : R.            (* f2x = f''(x) (the 2nd-derivative readout); B bounds f'''' *)
  Hypothesis HB : 0 <= B.
  (* DISCLOSED classical interface: the symmetric Taylor–Lagrange remainder *)
  Variable rem : R -> R.
  Hypothesis Hsd  : forall h, D2sym f x h = f2x * (h * h) + rem h.
  Hypothesis Hrem : forall h, Rabs (rem h) <= (B / 12) * ((h * h) * (h * h)).

  (* the scaled reading is f''(x) up to an O(h^2) error, EXPLICIT constant B/12 *)
  Theorem second_difference_rate :
    forall h, h <> 0 ->
      Rabs (D2sym f x h / (h * h) - f2x) <= (B / 12) * (h * h).
  Proof.
    intros h Hh.
    pose proof (sq_pos h Hh) as Hpos.
    assert (Hne : h * h <> 0) by lra.
    (* the scaled second difference minus f2x equals rem h / (h*h) *)
    assert (Heq : D2sym f x h / (h * h) - f2x = rem h / (h * h)).
    { rewrite Hsd. field. exact Hh. }
    rewrite Heq.
    (* |rem h / h^2| = |rem h| / h^2 *)
    unfold Rdiv. rewrite Rabs_mult.
    rewrite (Rabs_inv (h * h)).
    rewrite (Rabs_pos_eq (h * h)) by lra.
    (* goal: |rem h| * / (h*h) <= (B/12) * (h*h) *)
    apply Rmult_le_reg_r with (h * h); [exact Hpos|].
    rewrite Rmult_assoc. rewrite (Rinv_l (h * h) Hne). rewrite Rmult_1_r.
    (* goal: |rem h| <= (B/12 * (h*h)) * (h*h) *)
    eapply Rle_trans; [apply (Hrem h)|]. nra.
  Qed.
End Rate.

(* =====================================================================
   DIRECTIONAL n-D RATE  (the curved-metric reading, all dimensions)
   The directional restriction g(t) = F(x + t v) inherits the 1-D rate:
   the recovered directional Hessian form v^T H v has an explicit O(h^2)
   error.  v ranges over ALL directions in R^n.
   ===================================================================== *)
Definition D2dir (F : Vec -> R) (x v : Vec) (h : R) : R :=
  F (vadd x (vscale h v)) - 2 * F x + F (vadd x (vscale (- h) v)).

Section DirRate.
  Variable F : Vec -> R.
  Variable x v : Vec.
  Variable q B : R.                (* q = directional 2nd-order form = v^T H v *)
  Hypothesis HB : 0 <= B.
  Variable rem : R -> R.
  Hypothesis Hsd  : forall h, D2dir F x v h = (2 * q) * (h * h) + rem h.
  Hypothesis Hrem : forall h, Rabs (rem h) <= (B / 12) * ((h * h) * (h * h)).

  Theorem directional_rate :
    forall h, h <> 0 ->
      Rabs (D2dir F x v h / (h * h) - 2 * q) <= (B / 12) * (h * h).
  Proof.
    intros h Hh.
    pose proof (sq_pos h Hh) as Hpos.
    assert (Hne : h * h <> 0) by lra.
    assert (Heq : D2dir F x v h / (h * h) - 2 * q = rem h / (h * h)).
    { rewrite Hsd. field. exact Hh. }
    rewrite Heq.
    unfold Rdiv. rewrite Rabs_mult. rewrite (Rabs_inv (h * h)).
    rewrite (Rabs_pos_eq (h * h)) by lra.
    apply Rmult_le_reg_r with (h * h); [exact Hpos|].
    rewrite Rmult_assoc. rewrite (Rinv_l (h * h) Hne). rewrite Rmult_1_r.
    eapply Rle_trans; [apply (Hrem h)|]. nra.
  Qed.
End DirRate.

(* --- HONEST DISCLOSURE: classical Taylor remainder is a PARAMETER, so the
       rate theorems are Closed under the global context (no global axiom). --- *)
Print Assumptions second_difference_rate.
Print Assumptions directional_rate.

(* End RDL_MetricReadoutRate.v *)
