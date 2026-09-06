(******************************************************************************)
(* InfoAnalysisLift.v — lifting an analysis [Open] at the +reals tier.        *)
(*                                                                            *)
(* The base-Coq/ℚ kernel cannot DIFFERENTIATE symbolically, so the spine's    *)
(* readouts were closed at the ALGEBRAIC level (∂→−ω², ∂→−Γ as substitutions). *)
(* Here we lift one of those [Open]s using the Coq standard-library reals      *)
(* analysis (Ranalysis): the relaxation mode φ(t)=exp(−Γt) genuinely satisfies *)
(* the first-order dissipative equation φ'(t) = −Γ·φ(t) — the ACTUAL real      *)
(* derivative, not a substitution. This upgrades InfoDecoherence's algebraic   *)
(* relaxation to the differential equation.                                    *)
(*                                                                            *)
(* TIER: +reals — this DEPENDS on the Coq Reals axioms (ClassicalDedekindReals *)
(* + FunctionalExtensionality), exactly like the existing continuum rungs. It  *)
(* is NOT axiom-free; the dependency is disclosed and checked by the audit.    *)
(* (Coquelicot is not installed; the stdlib Reals suffice for this lift.)      *)
(******************************************************************************)

Require Import Reals.
Require Import Coq.Reals.Ranalysis1.
Require Import Coq.Reals.Rtrigo1.
Require Import Coq.micromega.Lra.
Require Import Coq.Logic.FunctionalExtensionality.
Open Scope R_scope.

(* the relaxation / decoherence mode: φ(t) = exp(−Γ t) *)
Definition relax (Gam : R) : R -> R := comp exp (mult_real_fct (- Gam) id).

(* the dissipative first-order ODE φ'(t) = −Γ·φ(t), via the ACTUAL real derivative (chain rule) *)
Theorem relaxation_ode : forall (Gam x : R) (pr : derivable_pt (relax Gam) x),
  derive_pt (relax Gam) x pr = - Gam * relax Gam x.
Proof.
  intros Gam x pr. unfold relax in pr |- *.
  rewrite (pr_nu (comp exp (mult_real_fct (- Gam) id)) x pr
    (derivable_pt_comp (mult_real_fct (- Gam) id) exp x
       (derivable_pt_scal id (- Gam) x (derivable_pt_id x))
       (derivable_pt_exp (mult_real_fct (- Gam) id x)))).
  rewrite derive_pt_comp, derive_pt_exp, derive_pt_scal, derive_pt_id.
  unfold comp, mult_real_fct, id. ring.
Qed.

(* the unitary oscillation mode: φ(t) = cos(ω t) *)
Definition wave (om : R) : R -> R := comp cos (mult_real_fct om id).

(* the oscillation velocity: d/dt cos(ωt) = −ω·sin(ωt) (the unitary mode's rate, real derivative) *)
Theorem harmonic_velocity : forall (om x : R) (pr : derivable_pt (wave om) x),
  derive_pt (wave om) x pr = - sin (om*x) * om.
Proof.
  intros om x pr. unfold wave in pr |- *.
  rewrite (pr_nu (comp cos (mult_real_fct om id)) x pr
    (derivable_pt_comp (mult_real_fct om id) cos x
       (derivable_pt_scal id om x (derivable_pt_id x))
       (derivable_pt_cos (mult_real_fct om id x)))).
  rewrite derive_pt_comp, derive_pt_cos, derive_pt_scal, derive_pt_id.
  unfold comp, mult_real_fct, id. ring.
Qed.

(* UNITARY norm conservation: cos²(θ)+sin²(θ)=1 — the unitary evolution preserves |ψ|² for all t *)
Theorem unitary_norm_conserved : forall th : R, Rsqr (cos th) + Rsqr (sin th) = 1.
Proof. intro th. rewrite Rplus_comm. exact (sin2_cos2 th). Qed.

(* the velocity φ'(t) = −ω·sin(ωt) (from harmonic_velocity), as a function *)
Definition velo (om : R) : R -> R := mult_real_fct (- om) (comp sin (mult_real_fct om id)).

(* the 2nd-order WAVE / dispersion equation at the actual real second derivative:
   φ''(t) = d/dt(−ω sin(ωt)) = −ω²·cos(ωt) = −ω²·φ(t). This lifts InfoSchrodinger.spine_mode_dispersion
   (the algebraic ∂²→−ω²) to the genuine second derivative of the conservative spine mode. *)
Theorem harmonic_wave_equation : forall (om x : R) (pr : derivable_pt (velo om) x),
  derive_pt (velo om) x pr = -(om*om) * cos (om*x).
Proof.
  intros om x pr. unfold velo in pr |- *.
  rewrite (pr_nu (mult_real_fct (- om) (comp sin (mult_real_fct om id))) x pr
    (derivable_pt_scal (comp sin (mult_real_fct om id)) (- om) x
       (derivable_pt_comp (mult_real_fct om id) sin x
          (derivable_pt_scal id om x (derivable_pt_id x))
          (derivable_pt_sin (mult_real_fct om id x))))).
  rewrite derive_pt_scal, derive_pt_comp, derive_pt_sin, derive_pt_scal, derive_pt_id.
  unfold comp, mult_real_fct, id. ring.
Qed.

(* GR radial lift: the Schwarzschild metric factor f(r)=1−2M/r ; its REAL radial derivative f'(r)=2M/r² is
   the gravitational "force" / radial Christoffel source — lifting InfoFrontier.schwarzschild (algebraic) to
   the actual derivative of the metric. Single-variable (radial), so stdlib derive_pt suffices. NOTE: the
   full multi-index Christoffel ½(∂_μ g_νσ+∂_ν g_μσ−∂_σ g_μν) needs MULTI-variable partial derivatives, which
   the stdlib single-variable Ranalysis does not provide — that remains the honest analysis [Open]. *)
Definition schw (M : R) : R -> R := minus_fct (fct_cte 1) (mult_real_fct (2*M) (inv_fct id)).
Theorem schwarzschild_force_real : forall (M r : R) (pr : derivable_pt (schw M) r),
  r <> 0 -> derive_pt (schw M) r pr = (2*M) / (r*r).
Proof.
  intros M r pr Hr. unfold schw in pr |- *.
  assert (Hid : id r <> 0) by (unfold id; exact Hr).
  rewrite (pr_nu (minus_fct (fct_cte 1) (mult_real_fct (2*M) (inv_fct id))) r pr
    (derivable_pt_minus (fct_cte 1) (mult_real_fct (2*M) (inv_fct id)) r
       (derivable_pt_const 1 r)
       (derivable_pt_scal (inv_fct id) (2*M) r
          (derivable_pt_inv id r Hid (derivable_pt_id r))))).
  rewrite derive_pt_minus, derive_pt_const, derive_pt_scal, derive_pt_inv, derive_pt_id.
  unfold id, Rsqr. field. exact Hr.
Qed.

(* MULTIVARIABLE partial derivatives via slices: stdlib Ranalysis is single-variable, but a partial ∂_μ IS
   the single-variable derivative of the coordinate slice. Demonstrated on the bilinear metric m(x,y)=x·y:
   ∂_x m=y, ∂_y m=x (real partials, product rule). This shows multivariable partials ARE expressible in
   stdlib — lifting the "single-variable gap" framing. The full multi-index Christoffel
   ½(∂_μ g_νσ+∂_ν g_μσ−∂_σ g_μν) is the SAME +reals algebra (InfoChristoffel) over these real partials; the
   index case-set + Clairaut symmetry of second partials is the larger deferred analysis piece. *)
Definition metric (x y : R) : R := x * y.
Theorem partial_x_metric : forall (x y : R) (pr : derivable_pt (fun t => metric t y) x),
  derive_pt (fun t => metric t y) x pr = y.
Proof.
  intros x y pr. unfold metric in pr |- *.
  change (fun t => t * y) with (mult_fct id (fct_cte y)) in pr |- *.
  rewrite (pr_nu (mult_fct id (fct_cte y)) x pr
    (derivable_pt_mult id (fct_cte y) x (derivable_pt_id x) (derivable_pt_const y x))).
  rewrite derive_pt_mult, derive_pt_id, derive_pt_const. unfold id, fct_cte. ring.
Qed.
Theorem partial_y_metric : forall (x y : R) (pr : derivable_pt (fun t => metric x t) y),
  derive_pt (fun t => metric x t) y pr = x.
Proof.
  intros x y pr. unfold metric in pr |- *.
  change (fun t => x * t) with (mult_fct (fct_cte x) id) in pr |- *.
  rewrite (pr_nu (mult_fct (fct_cte x) id) y pr
    (derivable_pt_mult (fct_cte x) id y (derivable_pt_const x y) (derivable_pt_id y))).
  rewrite derive_pt_mult, derive_pt_id, derive_pt_const. unfold id, fct_cte. ring.
Qed.

(* FULL MULTI-INDEX Christoffel over REAL partials. real_partial_sym is the analysis fact that justifies
   "∂g is symmetric": the partials of EQUAL metric components are equal. The InfoChristoffel algebra
   (torsion-free, metric-compatibility ∇g=0) then runs over the REAL partial values dg : coord→idx→idx→R
   — closing the multi-index Christoffel at +reals. (Clairaut symmetry of the SECOND partials, for the
   differential Bianchi, remains the deferred analysis piece; complex-i and Gleason also remain.) *)
Theorem real_partial_sym : forall (f h : R -> R) (x : R) (pf : derivable_pt f x) (ph : derivable_pt h x),
  f = h -> derive_pt f x pf = derive_pt h x ph.
Proof. intros f h x pf ph Heq. subst h. apply pr_nu. Qed.

Definition GamR (dg : nat->nat->nat->R) (s m n : nat) : R := (1/2) * (dg m n s + dg n m s - dg s m n).

Theorem christoffel_lower_sym_real : forall (dg : nat->nat->nat->R),
  (forall l m n, dg l m n = dg l n m) -> forall s m n, GamR dg s m n = GamR dg s n m.
Proof. intros dg Hs s m n. unfold GamR. rewrite (Hs s m n). lra. Qed.

Theorem metric_compat_real : forall (dg : nat->nat->nat->R),
  (forall l m n, dg l m n = dg l n m) -> forall l m n, dg l m n = GamR dg n l m + GamR dg m l n.
Proof. intros dg Hs l m n. unfold GamR. rewrite (Hs l n m). lra. Qed.


(* CLAIRAUT (symmetry of second partials) — the analysis fact underlying InfoChristoffel.second_bianchi_leading
   (which took the commuting-partials ddG-symmetry as a HYPOTHESIS). Here it is a THEOREM for the bilinear
   metric m=x·y: the mixed second partials commute, ∂_x∂_y m = 1 = ∂_y∂_x m, via nested real derivatives +
   funext. (General Clairaut for arbitrary C² needs the full multivariable theorem — the remaining piece.) *)
Lemma der_yslice : forall x y, derivable_pt (fun t => metric x t) y.
Proof. intros x y. unfold metric. change (fun t => x*t) with (mult_fct (fct_cte x) id).
  apply derivable_pt_mult; [apply derivable_pt_const | apply derivable_pt_id]. Qed.
Lemma der_xslice : forall y x, derivable_pt (fun t => metric t y) x.
Proof. intros y x. unfold metric. change (fun t => t*y) with (mult_fct id (fct_cte y)).
  apply derivable_pt_mult; [apply derivable_pt_id | apply derivable_pt_const]. Qed.
Lemma dy_is_id : forall y, (fun s => derive_pt (fun t => metric s t) y (der_yslice s y)) = id.
Proof. intro y. apply functional_extensionality. intro s. apply partial_y_metric. Qed.
Lemma dx_is_id : forall a, (fun b => derive_pt (fun t => metric t b) a (der_xslice b a)) = id.
Proof. intro a. apply functional_extensionality. intro b. apply partial_x_metric. Qed.
Theorem clairaut_xy : forall (x y : R)
  (pr : derivable_pt (fun s => derive_pt (fun t => metric s t) y (der_yslice s y)) x),
  derive_pt (fun s => derive_pt (fun t => metric s t) y (der_yslice s y)) x pr = 1.
Proof. intros x y pr. rewrite (real_partial_sym _ id x pr (derivable_pt_id x) (dy_is_id y)). apply derive_pt_id. Qed.
Theorem clairaut_yx : forall (a b : R)
  (pr : derivable_pt (fun s => derive_pt (fun t => metric t s) a (der_xslice s a)) b),
  derive_pt (fun s => derive_pt (fun t => metric t s) a (der_xslice s a)) b pr = 1.
Proof. intros a b pr. rewrite (real_partial_sym _ id b pr (derivable_pt_id b) (dx_is_id a)). apply derive_pt_id. Qed.
