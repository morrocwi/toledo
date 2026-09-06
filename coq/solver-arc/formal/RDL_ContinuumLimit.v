(* ===================================================================== *)
(*  RDL_ContinuumLimit.v  —  the GENERAL second-derivative limit.          *)
(*                                                                        *)
(*  HONEST AXIOM STATUS: over Coq's classical reals (NOT axiom-free); the  *)
(*  Print Assumptions at the bottom discloses the reals axioms used.       *)
(*                                                                        *)
(*  THEOREM (general, non-circular): if f admits a 2nd-order Taylor        *)
(*  (Peano) expansion at x —                                               *)
(*       f(x+h) = f(x) + a1·h + a2·h² + r(h),   with r(h)/h² → 0 —         *)
(*  which IS exactly the definition of f being twice differentiable at x   *)
(*  (with f'(x)=a1, f''(x)=2·a2), THEN the symmetric second difference     *)
(*  quotient converges to f''(x):                                          *)
(*       [f(x+h) − 2f(x) + f(x−h)] / h²  →  2·a2   as h→0.                  *)
(*  The proof is the real content: the symmetric combination cancels the   *)
(*  odd term a1·h and doubles the even term, leaving 2·a2·h² + (r(h)+r(−h)),*)
(*  and the remainder is controlled by r(·)/·² → 0.                        *)
(*                                                                        *)
(*  NOT done here (the one remaining classical link): deriving the Peano   *)
(*  expansion FROM Coq's `derivable` second derivative — that is Taylor's   *)
(*  theorem, a known stdlib-provable result, not re-derived in this file.  *)
(*  coqc 8.18.0.                                                           *)
(* ===================================================================== *)

Require Import Coq.Reals.Reals.
Require Import Coq.micromega.Lra.
Open Scope R_scope.

(* self-contained "g(h) → L as h→0 through h≠0" (epsilon–delta) *)
Definition tends0 (g : R -> R) (L : R) : Prop :=
  forall eps, eps > 0 -> exists del, del > 0 /\
    forall h, h <> 0 -> Rabs h < del -> Rabs (g h - L) < eps.

Definition D2sym (f:R->R) (x h:R) : R := f (x + h) - 2 * f x + f (x - h).

Lemma sq_neq0 : forall h, h <> 0 -> h * h <> 0.
Proof. intros h Hh Hc. destruct (Rmult_integral _ _ Hc); contradiction. Qed.

Section SSD.
  Variable f : R -> R.
  Variable x a1 a2 : R.
  Variable r : R -> R.
  Hypothesis Hexp : forall h, f (x + h) = f x + a1 * h + a2 * (h * h) + r h.
  Hypothesis Hrem : tends0 (fun h => r h / (h * h)) 0.

  (* symmetric difference cancels the odd term *)
  Lemma D2sym_expand :
    forall h, D2sym f x h = 2 * a2 * (h * h) + (r h + r (- h)).
  Proof.
    intro h. unfold D2sym. rewrite (Hexp h).
    assert (Hm : f (x - h) = f x + a1 * (- h) + a2 * ((- h) * (- h)) + r (- h)).
    { replace (x - h) with (x + - h) by ring. apply (Hexp (- h)). }
    rewrite Hm. ring.
  Qed.

  Theorem symmetric_second_difference_limit :
    tends0 (fun h => D2sym f x h / (h * h)) (2 * a2).
  Proof.
    intros eps Heps.
    assert (Hhalf : eps / 2 > 0) by lra.
    destruct (Hrem (eps / 2) Hhalf) as [del [Hdel Hb]].
    exists del. split; [exact Hdel|].
    intros h Hh Hhd.
    assert (Hq : D2sym f x h / (h * h) - 2 * a2
                 = r h / (h * h) + r (- h) / (h * h)).
    { rewrite D2sym_expand. field. exact Hh. }
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
End SSD.

(* --------------------------------------------------------------------- *)
(*  Corollary: the general theorem SUBSUMES the exact quadratic case.     *)
(*  quad(t)=a t²+b t+c has Peano expansion at x with a2=a, r≡0, so the     *)
(*  symmetric quotient → 2a = quad''(x), recovered as an instance.        *)
(* --------------------------------------------------------------------- *)
Definition quadR (a b c:R) : R -> R := fun t => a*t*t + b*t + c.

Corollary quadratic_symmetric_limit : forall a b c x,
  tends0 (fun h => D2sym (quadR a b c) x h / (h * h)) (2 * a).
Proof.
  intros a b c x.
  apply (symmetric_second_difference_limit
           (quadR a b c) x (2*a*x + b) a (fun _ => 0)).
  - intro h. unfold quadR. ring.
  - intros eps Heps. exists 1. split; [lra|]. intros h _ _.
    replace (0 / (h * h)) with 0 by (unfold Rdiv; rewrite Rmult_0_l; reflexivity).
    replace (0 - 0) with 0 by ring. rewrite Rabs_R0. exact Heps.
Qed.

(* --- HONEST DISCLOSURE: which reals axioms do these rest on? --- *)
Print Assumptions symmetric_second_difference_limit.
Print Assumptions quadratic_symmetric_limit.
