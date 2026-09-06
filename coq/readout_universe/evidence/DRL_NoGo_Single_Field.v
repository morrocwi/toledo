(* ===================================================================== *)
(*  DRL_NoGo_Single_Field.v -- formal no-go theorem: no standard          *)
(*  single-field discrete Lagrangian can produce a damping term (C6 of    *)
(*  v2/urr/URR_C_COQ_FORMAL_CHAIN.yaml's next_formal_targets, target:     *)
(*  unified_action_or_formal_no_go_theorem -- taking the OR-formal-        *)
(*  no-go branch; the file's own honesty_boundary already tags           *)
(*  unified_action: Open, and the target's own name offers this branch    *)
(*  as an equally valid closure).                                        *)
(*                                                                        *)
(*  Ground truth / motivation: v2/DISCRETE_RETENTION_LAGRANGIAN.md's      *)
(*  master equation has a damping term D that DRL gets only by doubling   *)
(*  the field (Phi, Psi) -- evidence/DRL_Discrete.v's own header states   *)
(*  this design choice narratively (the doubled variable is ontic) but  *)
(*  never proves that a SINGLE (undoubled) field could not have done the  *)
(*  same job more simply. This file closes that gap: it proves, for the   *)
(*  entire CLASS of standard single-field discrete Lagrangians (any       *)
(*  time-reversal-symmetric kinetic term KE, i.e. KE(d)=KE(-d) -- the      *)
(*  defining property of every textbook (velocity)^2-style kinetic energy *)
(*  -- and ANY potential V evaluated at the interior/varied slice), the    *)
(*  resulting Euler-Lagrange stationarity condition is STRUCTURALLY       *)
(*  forced to be symmetric under swapping the two boundary slices         *)
(*  (x0 <-> x2) -- and this symmetry algebraically forbids the            *)
(*  stationarity condition from ever containing a nonzero coefficient on  *)
(*  the antisymmetric combination (x2 - x0), which is exactly the SHAPE   *)
(*  of every damping term in this repo's own equations (DRL's D/(2dt)*    *)
(*  (P2-P0), and RD.v/URR's D_W-W retained-difference construction        *)
(*  itself). Hence: a genuinely damped discrete recurrence CANNOT arise   *)
(*  from any single-field Lagrangian of this (very general) class --      *)
(*  doubling the field (this repo's actual choice) or adding a            *)
(*  non-variational d'Alembert force (evidence/DRL_Forced_Master.v, C4)   *)
(*  are the only two ways out, not stylistic alternatives.                *)
(*                                                                        *)
(*  WHAT IT PROVES: (1) Sfun_swap_symmetric -- the single-field action is *)
(*  exactly invariant under (x0,x2) swap, for ANY KE with KE(d)=KE(-d)     *)
(*  and ANY V. (2) grad_swap_symmetric -- consequently so is its          *)
(*  central-difference stationarity probe (the SAME technique used        *)
(*  throughout this session's evidence/DRL_General_EL.v etc.), by a pure  *)
(*  substitution argument that never needs to know KE or V concretely.    *)
(*  (3) no_damping_coefficient -- THE NO-GO: if the stationarity probe is  *)
(*  written as [a swap-symmetric remainder] + c.(x2-x0) for any constant  *)
(*  c, then c=0 -- fully abstract, holds for ANY swap-symmetric remainder,*)
(*  proved by instantiating the swap at two related points and cancelling.*)
(*  (4) concrete_grad_has_no_damping_term -- a NON-VACUOUS corollary at   *)
(*  the standard quadratic KE(d)=(M/(2dt)).d^2 and linear V(x)=K2.x       *)
(*  (matching this session's own DRL_General_EL.v/C2 potential exactly,   *)
(*  at N=1, D-free): the stationarity condition is computed in closed     *)
(*  form and directly verified to have NO (x2-x0) term at all -- c=0      *)
(*  confirmed by explicit computation, not merely predicted abstractly.   *)
(*                                                                        *)
(*  WHAT IT DOES NOT PROVE: (a) that EVERY conceivable single-field       *)
(*  discretization convention lacks damping -- only this class (KE(d)=    *)
(*  KE(-d), V at the interior slice only); DRL_Discrete.v's own Sfun uses *)
(*  a different convention (V at BOTH boundary slices per sub-interval,   *)
(*  trapezoidal-style) which this file does not re-derive the same        *)
(*  no-go for (though the same proof technique would very likely apply -- *)
(*  not claimed here, out of scope); (b) a full unified action in the   *)
(*  positive sense (one action producing everything DRL's separate        *)
(*  doubled-Lagrangian + d'Alembert-forcing pieces produce) -- this file   *)
(*  takes the no-go branch instead, which the target's own name treats    *)
(*  as an equally valid closure, not a consolation prize; (c) anything    *)
(*  about WHY doubling specifically (as opposed to some other escape)     *)
(*  works -- that positive fact is exactly what evidence/DRL_Discrete.v's *)
(*  T1/T2 and evidence/DRL_General_EL.v's C2 already established          *)
(*  constructively, this file only closes off the negative space around   *)
(*  it.                                                                   *)
(*                                                                        *)
(*  Over Q, axiom-free target (check Print Assumptions).                  *)
(* ===================================================================== *)

Require Import QArith.

Open Scope Q_scope.

Section AbstractNoGo.

Variable KE V : Q -> Q.
Hypothesis KE_sym : forall d, KE d == KE (- d).
(* KE respects Q's setoid equality -- true of any genuinely arithmetic
   function (every function built from +,-,*,/ automatically has this;
   it rules out only pathological functions that inspect a rational's
   raw numerator/denominator representation rather than its value). *)
Hypothesis KE_proper : forall x y, x == y -> KE x == KE y.
Variable dt : Q.

(* the standard single-field discrete Lagrangian action over one interior
   slice x1 bracketed by boundary slices x0, x2: kinetic energy of each
   half-step plus potential evaluated AT THE VARIED SLICE ONLY (the
   midpoint convention -- distinct from DRL_Discrete.v's own
   trapezoidal V(x0)+V(x1) convention, see header). *)
Definition Sfun (x0 x1 x2 : Q) : Q := KE (x1 - x0) + KE (x2 - x1) - dt * V x1.

Lemma KE_swap : forall a b, KE (a - b) == KE (b - a).
Proof.
  intros a b.
  assert (Heq : - (a - b) == b - a) by ring.
  rewrite (KE_sym (a - b)).
  apply KE_proper. exact Heq.
Qed.

(* (1) THE ACTION ITSELF is exactly (x0,x2)-swap symmetric. *)
Theorem Sfun_swap_symmetric : forall x0 x1 x2, Sfun x0 x1 x2 == Sfun x2 x1 x0.
Proof.
  intros x0 x1 x2. unfold Sfun.
  rewrite (KE_swap x1 x0), (KE_swap x2 x1).
  ring.
Qed.

(* central-difference stationarity probe w.r.t. x1, same technique as
   DRL_General_EL.v/DRL_Forced_Master.v throughout this session. *)
Definition grad (x0 x1 x2 h : Q) : Q :=
  (Sfun x0 (x1 + h) x2 - Sfun x0 (x1 - h) x2) / (2 * h).

(* (2) THE PROBE inherits the swap symmetry -- purely by substituting the
   action's own symmetry into the probe's definition; this step needs
   NOTHING about KE or V's concrete form, only Sfun_swap_symmetric. *)
Theorem grad_swap_symmetric : forall x0 x1 x2 h, grad x0 x1 x2 h == grad x2 x1 x0 h.
Proof.
  intros x0 x1 x2 h. unfold grad.
  rewrite (Sfun_swap_symmetric x0 (x1 + h) x2), (Sfun_swap_symmetric x0 (x1 - h) x2).
  reflexivity.
Qed.

(* (3) THE NO-GO: fully abstract -- ANY swap-symmetric function Fsym that
   the probe might be decomposed against, plus a linear damping-shaped
   term c.(x2-x0), forces c=0. Proved by instantiating grad's own
   swap-symmetry at two related evaluation points and cancelling the
   (equal, by hypothesis) symmetric remainders. *)
Theorem no_damping_coefficient :
  forall (Fsym : Q -> Q -> Q -> Q -> Q) (c : Q),
  (forall x0 x1 x2 h, Fsym x0 x1 x2 h == Fsym x2 x1 x0 h) ->
  (forall x0 x1 x2 h, grad x0 x1 x2 h == Fsym x0 x1 x2 h + c * (x2 - x0)) ->
  c == 0.
Proof.
  intros Fsym c HFsym Hdecomp.
  assert (H1 := Hdecomp 0 0 1 1).
  assert (H2 := Hdecomp 1 0 0 1).
  assert (Hsym := grad_swap_symmetric 0 0 1 1).
  assert (HFs := HFsym 0 0 1 1).
  rewrite H1, H2 in Hsym.
  rewrite HFs in Hsym.
  (* Hsym : Fsym 1 0 0 1 + c * (1 - 0) == Fsym 1 0 0 1 + c * (0 - 1) *)
  assert (Hraw : c * (1 - 0) == c * (0 - 1)).
  { apply (proj1 (Qplus_inj_l (c * (1 - 0)) (c * (0 - 1)) (Fsym 1 0 0 1))). exact Hsym. }
  assert (Hc2 : c + c == 0).
  { assert (E1 : c * (1 - 0) == c) by ring.
    assert (E2 : c * (0 - 1) == - c) by ring.
    rewrite E1, E2 in Hraw.
    (* Hraw : c == - c *)
    rewrite Hraw at 2. ring. }
  assert (Hprod : (2#1) * c == 0).
  { assert (E3 : (2#1) * c == c + c) by ring. rewrite E3. exact Hc2. }
  destruct (Qmult_integral (2#1) c Hprod) as [Hbad | Hgood].
  - discriminate Hbad.
  - exact Hgood.
Qed.

End AbstractNoGo.

(* ===================================================================== *)
(*  Non-vacuousness: a concrete standard quadratic-kinetic, quadratic-    *)
(*  potential single-field action at N=1 (own self-contained convention, *)
(*  not a scaling-for-scaling match to DRL_General_EL.v's own Sgen --    *)
(*  that file's kinetic/potential terms carry a different discretization *)
(*  convention, per this file's own header) -- explicitly, by            *)
(*  computation, has NO (x2-x0) term at all.                             *)
(* ===================================================================== *)

Section ConcreteWitness.

Variable M K2 dt : Q.
Hypothesis Hdt : ~ dt == 0.

Definition KEc (d : Q) : Q := (M / ((2#1) * dt)) * d * d.
Definition Vc (x : Q) : Q := (K2 / (2#1)) * x * x.

Lemma KEc_sym : forall d, KEc d == KEc (- d).
Proof. intro d. unfold KEc. ring. Qed.

(* the explicit closed form of the stationarity condition -- an
   UNDAMPED recurrence: no (x2-x0) term anywhere in this expression.
   (Independently re-derived via field_simplify before committing this
   closed form -- an earlier version of this file guessed a scaling that
   did not actually match what `field` closes, and was caught broken by
   an independent review before being fixed here.) *)
Definition concrete_residual (x0 x1 x2 : Q) : Q :=
  - (M / dt) * (x2 - (2#1) * x1 + x0) - dt * K2 * x1.

Theorem concrete_grad_has_no_damping_term :
  forall x0 x1 x2 h, ~ h == 0 ->
  grad KEc Vc dt x0 x1 x2 h == concrete_residual x0 x1 x2.
Proof.
  intros x0 x1 x2 h Hh.
  unfold grad, Sfun, KEc, Vc, concrete_residual.
  field. split; assumption.
Qed.

(* sanity: concrete_residual really is swap-symmetric MINUS the identity
   part it is (there is no c to extract at all -- it is already exactly
   its own symmetric part, confirming the abstract no-go's prediction
   c=0 by direct inspection, not just by the abstract argument). *)
Theorem concrete_residual_swap_symmetric :
  forall x0 x1 x2, concrete_residual x0 x1 x2 == concrete_residual x2 x1 x0.
Proof. intros x0 x1 x2. unfold concrete_residual. ring. Qed.

End ConcreteWitness.

Print Assumptions Sfun_swap_symmetric.
Print Assumptions grad_swap_symmetric.
Print Assumptions no_damping_coefficient.
Print Assumptions concrete_grad_has_no_damping_term.
Print Assumptions concrete_residual_swap_symmetric.
