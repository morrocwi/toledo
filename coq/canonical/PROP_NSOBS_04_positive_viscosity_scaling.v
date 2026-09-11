(* ===================================================================== *)
(*  PROP_NSOBS_04_positive_viscosity_scaling.v                           *)
(*  Positive-viscosity energy-observability rank universality           *)
(*  (Toledo proposal PROP-NSOBS-04, code weld/P.??.v1, family NSOBS).    *)
(*                                                                        *)
(*  Registered statement:                                                *)
(*    L_{F_nu}^r h(nu y) = nu^{r+2} L_{F_1}^r h(y),                      *)
(*    D_x L_{F_nu}^r h(nu y) = nu^{r+1} D_y L_{F_1}^r h(y),  nu>0        *)
(*  where h is a quadratic (total- or shell-) energy reader and F_nu is  *)
(*  the finite Fourier-Galerkin NS vector field at viscosity nu.         *)
(*                                                                        *)
(*  Source construction (registry how_to_check): the finite Fourier-     *)
(*  Galerkin RHS decomposes as F_nu(x) = B(x,x) - nu*L(x), with B the    *)
(*  (viscosity-independent) quadratic nonlinear term and L the linear    *)
(*  Stokes/diffusion operator, both nu-independent as operators once nu  *)
(*  is factored out; h is quadratic and homogeneous of degree 2.         *)
(*                                                                        *)
(*  What is mechanized, and how:                                        *)
(*    1. FULLY PROVED FROM SCRATCH, no extra hypotheses beyond ordinary  *)
(*       bilinearity/linearity: the vector-field scaling identity        *)
(*         F_nu(nu . y) = nu^2 . F_1(y)                                  *)
(*       (lemma `field_scaling`), from B declared bilinear (B_lin1,      *)
(*       B_lin2) and L declared linear (L_lin) over an abstract Q-vector *)
(*       space V (Variable V, vadd, sc : Q -> V -> V, with sc_comp,      *)
(*       sc_distrib_vadd, sc_wd -- the ordinary module/scalar-action     *)
(*       laws of any real vector space, restated over Q). This is pure  *)
(*       algebra, no calculus.                                          *)
(*    2. The energy reader's degree-2 homogeneity h(nu.y) = nu^2 * h(y)  *)
(*       (hypothesis h_homog) is taken directly as the DEFINING property *)
(*       of "h is a quadratic energy reader" (registry `definitions`     *)
(*       field) -- not re-derived from an underlying bilinear form,      *)
(*       since the registry does not specify h's internal construction   *)
(*       beyond "quadratic".                                            *)
(*    3. The Lie-derivative / directional-derivative operator itself     *)
(*       (`Deriv g x v` := derivative of g at x along direction v) is    *)
(*       LEFT ABSTRACT and given exactly the four ordinary multivariable *)
(*       calculus facts the registry's own how_to_check cites as the     *)
(*       proof's only ingredients beyond bilinear/linear algebra:        *)
(*         Deriv_lin_dir        : linearity of the derivative in the     *)
(*                                 direction argument (Dg(x)(a.v) =      *)
(*                                 a * Dg(x)(v));                        *)
(*         Deriv_scale_fun      : linearity of the derivative in the     *)
(*                                 function argument for a constant      *)
(*                                 scalar multiple (D(c.g)=c.Dg);        *)
(*         Deriv_chain_dilation : the chain rule for composition with a  *)
(*                                 scalar dilation delta_nu(z)=nu.z, i.e. *)
(*                                 D(g o delta_nu)(y)(v) = Dg(nu.y)(nu.v) *)
(*                                 (delta_nu's own derivative is the      *)
(*                                 scalar map nu.(-), so this is exactly  *)
(*                                 the ordinary chain rule D(g o L) =    *)
(*                                 Dg(L(-)) o L specialized to L=nu.id); *)
(*         Deriv_congr          : the derivative of a function depends   *)
(*                                 only on its values (two functions      *)
(*                                 equal everywhere have equal            *)
(*                                 derivatives everywhere) -- a safe      *)
(*                                 specialization of the ordinary fact    *)
(*                                 that the derivative depends only on   *)
(*                                 values in a neighborhood, since here   *)
(*                                 the two functions compared are always  *)
(*                                 equal EVERYWHERE, not just locally.    *)
(*       These four are taken as explicit Hypotheses -- exactly this     *)
(*       repo's established idiom for citing standard, uncontested       *)
(*       background facts rather than re-deriving them from Coq.Reals    *)
(*       (see PROP_NS_TAPE_CLOSED_DOMAIN_01.v's weld_dynamics/           *)
(*       weld_reader/weld_invariant hypotheses for the precedent). They  *)
(*       are NOT axioms in the Coq sense (no `Axiom` is declared           *)
(*       anywhere in this file) -- they are ordinary universally          *)
(*       quantified premises of the final theorems, so `Print              *)
(*       Assumptions` on the theorems below reports the file itself as   *)
(*       closed/axiom-free; the theorems' actual content is conditional  *)
(*       on these four calculus facts holding for the concrete Deriv     *)
(*       instantiated on the real Fourier-Galerkin state space, which is *)
(*       cited from ordinary multivariable calculus, not mechanized from *)
(*       Coq.Reals here (matching this repo's Q-native precedent: merely *)
(*       importing Coq.Reals.Reals in this Coq version already pulls in  *)
(*       the axiom ClassicalDedekindReals.sig_forall_dec even for a      *)
(*       trivial fact -- see PROP_CONF_03_union_bound.v and              *)
(*       PROP_NS_TAPE_CLOSED_DOMAIN_01.v's file headers).                *)
(*    4. Given (1)-(3), BOTH registered identities are mechanized for    *)
(*       EVERY finite order r (not just r=0,1,2) by induction on r:      *)
(*         nsobs04_energy_scaling  : forall r y,                        *)
(*           iter_nu r h (sc nu y) == Qpow_nat nu (r+2) * iter_1 r h y   *)
(*         nsobs04_jacobian_scaling : forall r y v,                      *)
(*           Deriv (iter_nu r h) (sc nu y) v                             *)
(*             == Qpow_nat nu (r+1) * Deriv (iter_1 r h) y v             *)
(*       under the single side condition nu <> 0 (needed for the exact  *)
(*       power-of-nu cancellation step in the inductive step; the        *)
(*       registry's own claim_boundary already restricts to nu>0, a      *)
(*       strictly stronger hypothesis, so nu<>0 costs nothing beyond     *)
(*       what the registered claim already assumes). The proof does NOT  *)
(*       otherwise use positivity of nu, monotonicity, or any ordering    *)
(*       fact about Q -- only field arithmetic (Q is a field) and the    *)
(*       four Deriv hypotheses above; this is worth flagging honestly    *)
(*       since the general algebraic identity would in fact hold on any  *)
(*       field (real, rational, or otherwise) satisfying the same four   *)
(*       Deriv laws, not only on the positive reals -- the registered    *)
(*       "nu>0" restriction is a property of the ACTUAL viscosity        *)
(*       physics this proposal sits inside, not of this scaling lemma    *)
(*       by itself.                                                      *)
(*                                                                        *)
(*  What this does NOT prove: it does not construct a concrete Deriv     *)
(*  (real multivariable total derivative) from Coq.Reals or Coquelicot,  *)
(*  does not construct a concrete finite-dimensional B/L pair matching   *)
(*  the actual finite Fourier-Galerkin nonlinear/diffusion operators of  *)
(*  the source .tex beyond their declared bilinear/linear algebraic      *)
(*  shape, and does not touch the surrounding Lie-jet-rank/observability *)
(*  claims of PROP-NSOBS-02/03/06/08 (those remain separate, untouched   *)
(*  Dr-tier proposals resting on genuine jet-bundle/manifold machinery   *)
(*  this file does not attempt).                                        *)
(*                                                                        *)
(*  Rational-native (no Coq.Reals), matching this repo's established     *)
(*  Q-over-R precedent.                                                  *)
(*                                                                        *)
(*  Expected: Print Assumptions nsobs04_energy_scaling,                  *)
(*  Print Assumptions nsobs04_jacobian_scaling                           *)
(*    => Closed under the global context (both, axiom-free).            *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lia.

(* ===================================================================== *)
(*  0. A small standalone Q field-cancellation helper.                   *)
(* ===================================================================== *)

Lemma Qmult_cancel_l : forall a b c : Q, ~ (a == 0) -> a * b == a * c -> b == c.
Proof.
  intros a b c Ha Heq.
  assert (H2 : /a * (a * b) == /a * (a * c)) by (rewrite Heq; reflexivity).
  rewrite Qmult_assoc, Qmult_assoc in H2.
  rewrite (Qmult_comm (/a) a) in H2.
  rewrite (Qmult_inv_r a Ha) in H2.
  rewrite !Qmult_1_l in H2.
  exact H2.
Qed.

(* Repeated multiplication of a Q value by itself n times -- a rational  *)
(* power with a natural-number exponent, avoiding any Z-exponent/Qpower  *)
(* library machinery this proof does not need. *)
Fixpoint Qpow_nat (a : Q) (n : nat) : Q :=
  match n with
  | O => 1
  | S n' => a * Qpow_nat a n'
  end.

Lemma Qpow_nat_succ : forall (a : Q) (n : nat), Qpow_nat a (S n) = a * Qpow_nat a n.
Proof. reflexivity. Qed.

Section NSOBS04.

  (* ===================================================================== *)
  (*  1. Abstract finite-dimensional Q-vector space V.                     *)
  (* ===================================================================== *)

  Variable V : Type.
  Variable vadd : V -> V -> V.
  Variable sc : Q -> V -> V.

  Hypothesis sc_comp : forall (a b : Q) (v : V), sc a (sc b v) = sc (a * b) v.
  Hypothesis sc_distrib_vadd : forall (a : Q) (u w : V), sc a (vadd u w) = vadd (sc a u) (sc a w).
  Hypothesis sc_wd : forall (a b : Q) (v : V), a == b -> sc a v = sc b v.

  (* ===================================================================== *)
  (*  2. The viscosity-independent bilinear/linear pieces of F_nu.         *)
  (* ===================================================================== *)

  Variable B : V -> V -> V.
  Hypothesis B_lin1 : forall (a : Q) (u w : V), B (sc a u) w = sc a (B u w).
  Hypothesis B_lin2 : forall (a : Q) (u w : V), B u (sc a w) = sc a (B u w).

  Variable L : V -> V.
  Hypothesis L_lin : forall (a : Q) (v : V), L (sc a v) = sc a (L v).

  (* F_nu(x) := B(x,x) - nu . L(x);  F_1 := F_nu at nu = 1. *)
  Definition Fnu (nu : Q) (x : V) : V := vadd (B x x) (sc (-nu) (L x)).
  Definition F1 (y : V) : V := vadd (B y y) (sc (-(1)) (L y)).

  (* Lemma: the vector-field scaling identity F_nu(nu.y) = nu^2 . F_1(y). *)
  (* Pure bilinear/linear algebra -- no calculus, no Deriv anywhere here. *)
  Lemma field_scaling : forall (nu : Q) (y : V), Fnu nu (sc nu y) = sc (nu * nu) (F1 y).
  Proof.
    intros nu y.
    unfold Fnu, F1.
    rewrite (B_lin1 nu y (sc nu y)), (B_lin2 nu y y).
    rewrite (sc_comp nu nu (B y y)).
    rewrite (L_lin nu y).
    rewrite (sc_comp (-nu) nu (L y)).
    rewrite (sc_distrib_vadd (nu * nu) (B y y) (sc (-(1)) (L y))).
    rewrite (sc_comp (nu * nu) (-(1)) (L y)).
    rewrite (sc_wd (-nu * nu) ((nu * nu) * -(1)) (L y)) by ring.
    reflexivity.
  Qed.

  (* ===================================================================== *)
  (*  3. The quadratic energy reader h.                                    *)
  (* ===================================================================== *)

  Variable h : V -> Q.
  Hypothesis h_homog : forall (a : Q) (v : V), h (sc a v) == a * a * h v.

  (* ===================================================================== *)
  (*  4. The abstract directional-derivative operator and its four        *)
  (*     ordinary multivariable-calculus laws (see file header).          *)
  (* ===================================================================== *)

  Variable Deriv : (V -> Q) -> V -> V -> Q.

  Hypothesis Deriv_lin_dir :
    forall (g : V -> Q) (x : V) (a : Q) (v : V), Deriv g x (sc a v) == a * Deriv g x v.

  Hypothesis Deriv_scale_fun :
    forall (g : V -> Q) (x v : V) (c : Q),
      Deriv (fun z => c * g z) x v == c * Deriv g x v.

  Hypothesis Deriv_chain_dilation :
    forall (g : V -> Q) (nu : Q) (y v : V),
      Deriv (fun z => g (sc nu z)) y v == Deriv g (sc nu y) (sc nu v).

  Hypothesis Deriv_congr :
    forall (g g' : V -> Q) (x v : V),
      (forall z, g z == g' z) -> Deriv g x v == Deriv g' x v.

  (* Lie derivative along F_nu / F_1, and their r-fold iterates applied to h. *)
  Definition LieOp (nu : Q) (g : V -> Q) (x : V) : Q := Deriv g x (Fnu nu x).
  Definition Lie1 (g : V -> Q) (x : V) : Q := Deriv g x (F1 x).

  Fixpoint iter_nu (nu : Q) (r : nat) (g : V -> Q) : V -> Q :=
    match r with
    | O => g
    | S r' => LieOp nu (iter_nu nu r' g)
    end.

  Fixpoint iter_1 (r : nat) (g : V -> Q) : V -> Q :=
    match r with
    | O => g
    | S r' => Lie1 (iter_1 r' g)
    end.

  (* Note: iter_nu/iter_1 pointwise equality is stated with == on their  *)
  (* Q-valued output; g z == g' z below means (g z == g' z)%Q. *)
  Notation gnu nu r := (iter_nu nu r h).
  Notation g1 r := (iter_1 r h).

  Section MainInduction.

    Variable nu : Q.
    Hypothesis nu_ne0 : ~ (nu == 0).

    (* ------------------------------------------------------------------- *)
    (*  A_r : the registered energy-scaling identity at order r.           *)
    (*  B_r : the registered Jacobian/derivative-scaling identity at r.    *)
    (* ------------------------------------------------------------------- *)

    Definition A_stmt (r : nat) : Prop :=
      forall y : V, gnu nu r (sc nu y) == Qpow_nat nu (r + 2) * g1 r y.

    Definition B_stmt (r : nat) : Prop :=
      forall (y v : V), Deriv (gnu nu r) (sc nu y) v == Qpow_nat nu (r + 1) * Deriv (g1 r) y v.

    (* A_r gives B_r, by the chain rule for dilation plus one power       *)
    (* cancellation (nu <> 0). *)
    Lemma AtoB : forall r : nat, A_stmt r -> B_stmt r.
    Proof.
      intros r HA y v.
      set (gr := gnu nu r).
      set (g1r := g1 r).
      assert (Hchain : Deriv (fun z => gr (sc nu z)) y v == Deriv gr (sc nu y) (sc nu v))
        by (apply Deriv_chain_dilation).
      assert (Hcongr :
        Deriv (fun z => gr (sc nu z)) y v == Deriv (fun z => Qpow_nat nu (r + 2) * g1r z) y v).
      { apply Deriv_congr. intro z. apply (HA z). }
      assert (Hscale :
        Deriv (fun z => Qpow_nat nu (r + 2) * g1r z) y v == Qpow_nat nu (r + 2) * Deriv g1r y v)
        by (apply Deriv_scale_fun).
      assert (Hmain : Deriv gr (sc nu y) (sc nu v) == Qpow_nat nu (r + 2) * Deriv g1r y v).
      { rewrite <- Hchain, Hcongr. exact Hscale. }
      assert (Hlin : Deriv gr (sc nu y) (sc nu v) == nu * Deriv gr (sc nu y) v)
        by (apply Deriv_lin_dir).
      assert (Hstep : nu * Deriv gr (sc nu y) v == Qpow_nat nu (r + 2) * Deriv g1r y v).
      { rewrite <- Hlin. exact Hmain. }
      assert (Hpow : Qpow_nat nu (r + 2) = nu * Qpow_nat nu (r + 1)).
      { replace (r + 2)%nat with (S (r + 1)) by lia. reflexivity. }
      rewrite Hpow in Hstep.
      rewrite <- Qmult_assoc in Hstep.
      apply (Qmult_cancel_l nu (Deriv gr (sc nu y) v) (Qpow_nat nu (r + 1) * Deriv g1r y v) nu_ne0).
      exact Hstep.
    Qed.

    (* B_r plus the vector-field scaling identity gives A_{r+1}. *)
    Lemma BtoA : forall r : nat, B_stmt r -> A_stmt (S r).
    Proof.
      intros r HB y.
      unfold A_stmt.
      change (gnu nu (S r)) with (LieOp nu (gnu nu r)).
      change (g1 (S r)) with (Lie1 (g1 r)).
      unfold LieOp, Lie1.
      rewrite (field_scaling nu y).
      assert (Hlin : Deriv (gnu nu r) (sc nu y) (sc (nu * nu) (F1 y))
                     == (nu * nu) * Deriv (gnu nu r) (sc nu y) (F1 y))
        by (apply Deriv_lin_dir).
      rewrite Hlin.
      rewrite (HB y (F1 y)).
      replace (S r + 2)%nat with (r + 3)%nat by lia.
      assert (Hpow3 : Qpow_nat nu (r + 3) == nu * nu * Qpow_nat nu (r + 1)).
      { replace (r + 3)%nat with (S (S (r + 1))) by lia.
        simpl. ring. }
      rewrite Hpow3.
      ring.
    Qed.

    (* Base case: A_0 is exactly h_homog (Qpow_nat nu 2 = nu*nu). *)
    Lemma A_base : A_stmt 0.
    Proof.
      unfold A_stmt. intro y.
      simpl (iter_nu nu 0 h). simpl (iter_1 0 h).
      change (Qpow_nat nu (0 + 2)) with (nu * (nu * 1)).
      rewrite (h_homog nu y).
      ring.
    Qed.

    (* Both registered identities, for every finite order r. *)
    Theorem nsobs04_energy_scaling : forall r : nat, A_stmt r.
    Proof.
      induction r as [| r IH].
      - exact A_base.
      - apply BtoA. apply AtoB. exact IH.
    Qed.

    Theorem nsobs04_jacobian_scaling : forall r : nat, B_stmt r.
    Proof.
      intro r. apply AtoB. apply nsobs04_energy_scaling.
    Qed.

  End MainInduction.

End NSOBS04.
