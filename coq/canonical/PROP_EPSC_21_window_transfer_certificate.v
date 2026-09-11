(* ===================================================================== *)
(*  PROP_EPSC_21_window_transfer_certificate.v                           *)
(*  Derivative-free finite-window shell-transfer uncertainty certificate  *)
(*  (Toledo proposal PROP-EPSC-21, code weld/P.??.v1).                   *)
(*                                                                        *)
(*  Source: github.com/morrocwi/readout-problem-navier-stokes/           *)
(*  reproduction/NS_ENERGY_TRANSFER_OBSERVABILITY_BRIDGE.md;             *)
(*  implementation in github.com/morrocwi/information-discrete-math/     *)
(*  idm/ns_transfer_observability.py. Parents: PROP-EPSC-19 (partial     *)
(*  noise-stability closure) and PROP-NSOBS-09 (the exact finite ODE     *)
(*  d I_s/dt = T_s - 2 nu s I_s + F_s for the shell energy I_s).         *)
(*                                                                        *)
(*  Registered statement: integrating PROP-NSOBS-09's exact shell        *)
(*  balance from t0 to t1 gives the exact rearrangement                  *)
(*    int_{t0}^{t1} T_s dt = I_s(t1) - I_s(t0)                           *)
(*                            + 2 nu s int_{t0}^{t1} I_s dt               *)
(*                            - int_{t0}^{t1} F_s dt,                    *)
(*  with radius bound                                                    *)
(*    rad(int T_s dt) <= r_1 + r_0 + 2 nu s r_I + r_F.                   *)
(*                                                                        *)
(*  Scope actually mechanized here (honest split of the two claims):     *)
(*                                                                        *)
(*    (a) The rearrangement itself is the fundamental theorem of         *)
(*        calculus applied to a continuum ODE on I_s -- genuine          *)
(*        real-analysis content (an antiderivative/integral identity     *)
(*        for a function of a real time variable) that this repo has     *)
(*        no Coq.Reals/Coquelicot infrastructure for, and PROP-NSOBS-09  *)
(*        itself is not yet mechanized (coq_status: open_prop at time    *)
(*        of writing) -- so it is NOT re-derived from an actual integral  *)
(*        here. It is instead taken, exactly as the source states it,    *)
(*        as an EXACT DEFINING IDENTITY: the transfer-window quantity    *)
(*        int T_s dt is, by definition/construction (via PROP-NSOBS-09's *)
(*        ODE and FTC, cited not mechanized), the affine combination of  *)
(*        the four other window quantities below -- for both the exact   *)
(*        ("true", unprimed-prime) values and the certified/measured     *)
(*        (reported) values alike, since it is the same deterministic    *)
(*        functional form applied to whichever inputs are given. This    *)
(*        matches the repo's existing precedent of taking a cited        *)
(*        source identity as an explicit Definition/Hypothesis rather    *)
(*        than re-deriving prerequisite continuum machinery (see         *)
(*        PROP_NS_TAPE_CLOSED_DOMAIN_01.v's treatment of A_{M,n} and      *)
(*        chi_{M,n}).                                                     *)
(*                                                                        *)
(*    (b) The radius bound is exactly the part the proposal's own        *)
(*        "how_to_check" field flags as "completely generic, no          *)
(*        PDE/manifold content": a fixed affine combination of four      *)
(*        independently-radius-certified rational quantities has an      *)
(*        output radius bounded by the corresponding weighted sum of     *)
(*        the input radii, by the triangle inequality applied            *)
(*        term-by-term. THIS is proved as a real theorem below, from     *)
(*        first principles (Qabs triangle inequality only), for          *)
(*        arbitrary rational "computed" and "true" quantities and        *)
(*        arbitrary rational error bounds -- no PDE, manifold, jet, or   *)
(*        Navier-Stokes content of any kind, and no axioms.               *)
(*                                                                        *)
(*  Rational-native (no Coq.Reals), matching this repo's precedent        *)
(*  (PROP_CONF_03_union_bound.v, PROP_NS_TAPE_CLOSED_DOMAIN_01.v):        *)
(*  every quantity here -- the four window observables, their radii,     *)
(*  and the coefficient 2 nu s -- is modeled as a rational number, since  *)
(*  nothing about the radius-composition argument itself needs the       *)
(*  reals; merely `Require`-ing Coq.Reals.Reals has already been shown   *)
(*  in this repo to pull in a classical axiom even for trivial facts.    *)
(*                                                                        *)
(*  What this file does NOT prove: that PROP-NSOBS-09's ODE holds for    *)
(*  any actual Navier-Stokes shell-energy trajectory, that the           *)
(*  rearranged identity follows from that ODE by an actually-mechanized  *)
(*  fundamental theorem of calculus, or that the four input radii        *)
(*  r_0, r_1, r_I, r_F are themselves correctly certified by whatever     *)
(*  upstream measurement procedure produces them -- all of that is       *)
(*  exactly PROP-EPSC-21's own stated claim_boundary ("partial EPSC-19   *)
(*  closure only ... a certified map from noisy window observations to   *)
(*  a full quotient-state radius rho_N is still required").              *)
(*                                                                        *)
(*  Expected: Print Assumptions window_transfer_radius_bound             *)
(*    => Closed under the global context (axiom-free).                  *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.QArith.Qabs.

Local Open Scope Q_scope.

Section WindowTransferCertificate.

  (* The physical coefficient 2*nu*s from the shell-energy ODE           *)
  (* d I_s/dt = T_s - 2 nu s I_s + F_s, left as an arbitrary rational      *)
  (* (its sign/value plays no role in the radius argument). *)
  Variable coeff : Q.

  (* Reported (certified/measured) window quantities: I_s(t1), I_s(t0),   *)
  (* int I_s dt, int F_s dt. *)
  Variable I1 I0 Iint Fint : Q.

  (* Exact ("true") counterparts of the same four quantities. *)
  Variable I1' I0' Iint' Fint' : Q.

  (* Certified nonnegative radii for each of the four reported            *)
  (* quantities, i.e. the declared bounds r_1, r_0, r_I, r_F. *)
  Variable r1 r0 rI rF : Q.

  Hypothesis r1_bound : Qabs (I1 - I1') <= r1.
  Hypothesis r0_bound : Qabs (I0 - I0') <= r0.
  Hypothesis rI_bound : Qabs (Iint - Iint') <= rI.
  Hypothesis rF_bound : Qabs (Fint - Fint') <= rF.

  (* The transfer-window quantity int T_s dt, defined -- for both the     *)
  (* reported and the exact inputs -- by the same affine combination      *)
  (* dictated by integrating PROP-NSOBS-09's ODE (fundamental theorem     *)
  (* of calculus on a known finite ODE; cited, not mechanized here, per   *)
  (* the file header). This is the "exact identity, not an                *)
  (* approximation" half of PROP-EPSC-21's statement. *)
  Definition Tint : Q := I1 - I0 + coeff * Iint - Fint.
  Definition Tint' : Q := I1' - I0' + coeff * Iint' - Fint'.

  (* The registered radius bound:                                        *)
  (*   rad(int T_s dt) <= r_1 + r_0 + 2 nu s * r_I + r_F.                 *)
  (* This is the fully generic interval/radius-composition half of       *)
  (* PROP-EPSC-21's statement -- an affine combination of four            *)
  (* independently-radius-certified quantities, bounded term-by-term by  *)
  (* the triangle inequality. No PDE, manifold, or Navier-Stokes content. *)
  Theorem window_transfer_radius_bound :
    Qabs (Tint - Tint') <= r1 + r0 + Qabs coeff * rI + rF.
  Proof.
    unfold Tint, Tint'.
    (* Rewrite the difference of the two affine combinations as the       *)
    (* corresponding affine combination of the four per-term differences: *)
    (*   (I1-I0+c*Iint-Fint) - (I1'-I0'+c*Iint'-Fint')                    *)
    (* = (I1-I1') - (I0-I0') + c*(Iint-Iint') - (Fint-Fint').             *)
    assert (Hrw :
      (I1 - I0 + coeff * Iint - Fint) - (I1' - I0' + coeff * Iint' - Fint')
      == (I1 - I1') - (I0 - I0') + coeff * (Iint - Iint') - (Fint - Fint')).
    { ring. }
    rewrite Hrw.
    (* Peel the four-term sum apart with the triangle inequality,         *)
    (* |a - b + c - d| <= |a| + |b| + |c| + |d|, applied step by step.    *)
    eapply Qle_trans.
    { apply Qabs_triangle. }
    apply Qplus_le_compat.
    - eapply Qle_trans.
      { apply Qabs_triangle. }
      apply Qplus_le_compat.
      + eapply Qle_trans.
        { apply Qabs_triangle. }
        apply Qplus_le_compat.
        * exact r1_bound.
        * rewrite Qabs_opp. exact r0_bound.
      + rewrite Qabs_Qmult.
        rewrite (Qmult_comm (Qabs coeff) (Qabs (Iint - Iint'))).
        rewrite (Qmult_comm (Qabs coeff) rI).
        apply Qmult_le_compat_r.
        * exact rI_bound.
        * apply Qabs_nonneg.
    - rewrite Qabs_opp. exact rF_bound.
  Qed.

End WindowTransferCertificate.
