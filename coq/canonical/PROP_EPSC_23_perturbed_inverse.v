(* ===================================================================== *)
(*  PROP_EPSC_23_perturbed_inverse.v                                      *)
(*  Exact rational interval preconditioned local-inverse certificate      *)
(*  core (Toledo proposal PROP-EPSC-23, code weld/P.??.v1), registered    *)
(*  in registry/proposals/ns_eps18_n1_local_inverse.json.                 *)
(*                                                                         *)
(*  Statement mechanized (source's own 'how_to_check'):                   *)
(*    q = ||I - A J(B)||_infty < 1                                        *)
(*      ==> ||x - z||_infty <= (||A||_infty / (1-q)) ||H(x) - H(z)||_infty *)
(*    on a certified common branch B.                                    *)
(*                                                                        *)
(*  The source's own 'how_to_check' already isolates this as 'a           *)
(*  completely generic, textbook finite-dimensional analysis lemma        *)
(*  independent of N or the NS system ... provable in isolation as a      *)
(*  standalone Coq lemma about finite-dimensional normed vector spaces    *)
(*  and does not need the NS construction at all, only the abstract       *)
(*  hypotheses (A, J(B), q<1) as given.' That is exactly what is          *)
(*  mechanized here: V is left fully abstract (no concrete R^n, no        *)
(*  concrete matrix/interval-Jacobian representation), M stands for the   *)
(*  composed operator A o J_avg (the 'average Jacobian' produced by the   *)
(*  mean-value/integral form of the fundamental theorem of calculus,      *)
(*  H(x)-H(z) = J_avg(x-z)), and Aop stands for the preconditioner A.     *)
(*  The two hypotheses actually used are precisely the two named in the   *)
(*  source: (1) a uniform defect bound ||v - M v|| <= q * ||v|| for every *)
(*  v in the space (the branch-wide operator-norm certification            *)
(*  ||I - A J(B)||_infty <= q, applied pointwise -- stronger in form but  *)
(*  faithful to 'uniformly over the certified branch B', see              *)
(*  honest_caveats below for the one simplification this makes), and     *)
(*  (2) a submultiplicative bound ||A d|| <= ||A|| * ||d|| for every d    *)
(*  (the definition of the operator norm ||A||_infty). No Neumann-series  *)
(*  convergence, no explicit construction of an inverse operator, and no   *)
(*  completeness/limit argument is needed at all: the bound follows by a  *)
(*  single application of the group identity v = (v - M v) + M v, the     *)
(*  triangle inequality, and finite-field (Q) arithmetic -- see the       *)
(*  proof of neumann_defect_bound below.                                  *)
(*                                                                        *)
(*  Rational-native (no Coq.Reals), matching this repo's existing         *)
(*  precedent (PROP_CONF_03_union_bound.v, PROP_NS_TAPE_CLOSED_DOMAIN_01. *)
(*  v): merely `Require`-ing Coq.Reals.Reals pulls in a classical axiom   *)
(*  in this Coq version even for a trivial fact, so every quantity here   *)
(*  (norms, q, the operator-norm bound, the final radius) is a rational   *)
(*  number, which is all that a finite-dimensional entrywise/interval     *)
(*  construction over Q ever produces in this repo's companion            *)
(*  (information-discrete-math's finite_interval_inverse.py /             *)
(*  certified_local_inverse.py, per this proposal's own 'origin' field).  *)
(*                                                                        *)
(*  What this does NOT prove: that any concrete finite Jacobian           *)
(*  enclosure J(B) built from the N=1 (or any N) Navier-Stokes energy-jet  *)
(*  chart actually satisfies the two hypotheses (H_close, H_opnorm) for   *)
(*  some computed q<1 and some computed ||A|| -- that is a separate,      *)
(*  per-instance numerical certification (interval arithmetic on the      *)
(*  concrete Jacobian box), not re-derived here. It also does not          *)
(*  establish branch containment/uniqueness (a certified common branch B  *)
(*  is assumed to already exist and to be the domain on which the         *)
(*  uniform defect bound holds, exactly as PROP-EPSC-22 supplies and as   *)
(*  the source's own claim_boundary states). This file mechanizes exactly *)
(*  the abstract perturbed-inverse/Krawczyk-type algebraic step, nothing  *)
(*  about Navier-Stokes, Sobolev spaces, or any specific N.               *)
(*                                                                        *)
(*  Expected: Print Assumptions PROP_EPSC_23_perturbed_inverse_bound,     *)
(*  Print Assumptions PROP_EPSC_23_division_form                         *)
(*    => Closed under the global context (both, axiom-free).             *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Local Open Scope Q_scope.

Section PerturbedInverse.

  (* The finite-dimensional normed vector space, left fully abstract: no  *)
  (* concrete R^n, no concrete matrix representation is needed for this   *)
  (* generic step. *)
  Variable V : Type.
  Variable vnorm : V -> Q.
  Variable vadd vsub : V -> V -> V.

  Hypothesis vnorm_nonneg : forall v : V, 0 <= vnorm v.
  Hypothesis vsub_add_cancel : forall a b : V, vadd (vsub a b) b = a.
  Hypothesis triangle : forall a b : V, vnorm (vadd a b) <= vnorm a + vnorm b.

  (* M stands for the composed operator A o J_avg acting on the domain    *)
  (* difference x - z (see file header); Aop stands for the fixed         *)
  (* rational preconditioner A acting on a codomain difference. *)
  Variable M : V -> V.
  Variable Aop : V -> V.

  (* q = ||I - A J(B)||_infty, the certified branch-wide defect bound,    *)
  (* and its two standing hypotheses (0 <= q < 1 is the source's own       *)
  (* fail-closed precondition). *)
  Variable q : Q.
  Hypothesis Hq_nonneg : 0 <= q.
  Hypothesis Hq_lt1 : q < 1.

  (* ||I - M|| <= q, applied uniformly (see honest_caveats in the JSON    *)
  (* update: the source certifies this over the branch B; this generic    *)
  (* lemma states it for the whole abstract space V, which is what 'the   *)
  (* branch is already a certified common domain' amounts to once B      *)
  (* itself is abstracted away). *)
  Hypothesis H_close : forall v : V, vnorm (vsub v (M v)) <= q * vnorm v.

  (* ||A||_infty, the preconditioner's operator norm, and its defining    *)
  (* submultiplicative bound. *)
  Variable opnorm_A : Q.
  Hypothesis Hopnorm_A_nonneg : 0 <= opnorm_A.
  Hypothesis H_opnorm : forall d : V, vnorm (Aop d) <= opnorm_A * vnorm d.

  (* ------------------------------------------------------------------- *)
  (*  The abstract algebraic core: if M v = w then                       *)
  (*  ||v|| * (1 - q) <= ||w||. No Neumann series, no explicit inverse:   *)
  (*  just v = (v - M v) + M v, the triangle inequality, and H_close.     *)
  (* ------------------------------------------------------------------- *)
  Lemma neumann_defect_bound :
    forall v w : V, M v = w -> vnorm v * (1 - q) <= vnorm w.
  Proof.
    intros v w Hw.
    assert (Htri2 : vnorm v <= vnorm (vsub v (M v)) + vnorm (M v)).
    { pose proof (triangle (vsub v (M v)) (M v)) as Ht.
      rewrite (vsub_add_cancel v (M v)) in Ht.
      exact Ht. }
    pose proof (H_close v) as Hc.
    (* Htri2 : vnorm v <= vnorm (vsub v (M v)) + vnorm (M v)              *)
    (* Hc    : vnorm (vsub v (M v)) <= q * vnorm v                       *)
    assert (Hstep0 : vnorm v <= q * vnorm v + vnorm (M v)).
    { apply (Qle_trans _ (vnorm (vsub v (M v)) + vnorm (M v)) _).
      - exact Htri2.
      - apply Qplus_le_compat.
        + exact Hc.
        + apply Qle_refl. }
    rewrite Hw in Hstep0.
    rename Hstep0 into Hstep.
    assert (Hfinal : vnorm v <= vnorm w + q * vnorm v).
    { rewrite Qplus_comm. exact Hstep. }
    assert (Hxz : vnorm v * (1 - q) + q * vnorm v == vnorm v) by ring.
    apply (proj1 (Qplus_le_l (vnorm v * (1 - q)) (vnorm w) (q * vnorm v))).
    rewrite Hxz.
    exact Hfinal.
  Qed.

  (* ------------------------------------------------------------------- *)
  (*  PROP-EPSC-23, multiplied form: instantiate w := Aop (Hx - Hz) via   *)
  (*  the mean-value link M(x-z) = A(H(x)-H(z)), then fold in the         *)
  (*  operator-norm bound on A.                                          *)
  (* ------------------------------------------------------------------- *)
  Theorem PROP_EPSC_23_perturbed_inverse_bound :
    forall x z Hx Hz : V,
      M (vsub x z) = Aop (vsub Hx Hz) ->
      vnorm (vsub x z) * (1 - q) <= opnorm_A * vnorm (vsub Hx Hz).
  Proof.
    intros x z Hx Hz Hlink.
    pose proof (neumann_defect_bound (vsub x z) (Aop (vsub Hx Hz)) Hlink) as Hcore.
    pose proof (H_opnorm (vsub Hx Hz)) as Hop.
    eapply Qle_trans; [exact Hcore | exact Hop].
  Qed.

  (* ------------------------------------------------------------------- *)
  (*  PROP-EPSC-23, division form, matching the registered LaTeX          *)
  (*  statement literally: ||x-z|| <= (||A||/(1-q)) ||H(x)-H(z)||.        *)
  (* ------------------------------------------------------------------- *)
  Theorem PROP_EPSC_23_division_form :
    forall x z Hx Hz : V,
      M (vsub x z) = Aop (vsub Hx Hz) ->
      vnorm (vsub x z) <= (opnorm_A / (1 - q)) * vnorm (vsub Hx Hz).
  Proof.
    intros x z Hx Hz Hlink.
    pose proof (PROP_EPSC_23_perturbed_inverse_bound x z Hx Hz Hlink) as Hmul.
    assert (Hpos : 0 < 1 - q) by lra.
    assert (Heq : opnorm_A / (1 - q) * vnorm (vsub Hx Hz)
                == (opnorm_A * vnorm (vsub Hx Hz)) / (1 - q)).
    { unfold Qdiv. ring. }
    rewrite Heq.
    apply Qle_shift_div_l; assumption.
  Qed.

End PerturbedInverse.
