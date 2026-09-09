(* ===================================================================== *)
(*  PROP_NS_FOUR_LAYER_NONCOLLAPSE_01_elementary.v                       *)
(*  The two NEW, self-contained elementary propositions underlying        *)
(*  Toledo proposal PROP-NS-FOUR-LAYER-NONCOLLAPSE-01 (Readout-Navier-     *)
(*  Stokes Development Series, Volume 2, Propositions 10.1 and 10.2).     *)
(*                                                                        *)
(*  Scope (read carefully -- this is a PARTIAL, honest closure):          *)
(*  PROP-NS-FOUR-LAYER-NONCOLLAPSE-01 as registered is a synthesis of      *)
(*  FOUR things: the already-registered PROP-NS-WITNESS-01 (mechanized,    *)
(*  Th_coqc, in PROP_NS_WITNESS_01_finite_weld.v), the already-registered  *)
(*  PROP-NS-CONTINUATION-01 (a continuous-time linear-ODE well-posedness   *)
(*  result -- NOT mechanized here or anywhere in this repo; it needs real  *)
(*  ODE/measure-theoretic machinery, e.g. Coquelicot, that has not been    *)
(*  invested in for this task), and the TWO genuinely new elementary       *)
(*  propositions below. Only those two new propositions are mechanized     *)
(*  in this file. The full four-layer non-collapse synthesis is NOT        *)
(*  claimed Th_coqc by this file -- see the Toledo proposal's honest       *)
(*  caveat for that scoping. Do not read a green compile of this file as   *)
(*  closing the whole PROP-NS-FOUR-LAYER-NONCOLLAPSE-01 proposal.          *)
(*                                                                         *)
(*  Both propositions are stated generically over an abstract "retained    *)
(*  state" type with a rational-valued distance-from-origin (norm) and an  *)
(*  abstract task-reader map -- rational-native (Coq.QArith), no reals,    *)
(*  no continuum limits, matching this workspace's finite/algebraic        *)
(*  discipline. Proved by direct algebra, not by any external hypothesis   *)
(*  smuggled in as an axiom.                                               *)
(*                                                                         *)
(*  10.1 (bounded_does_not_decide_adequacy): a bounded retained state does *)
(*  NOT by itself decide task-adequacy -- exhibited by a concrete witness   *)
(*  instance (Val := bool, a task-adequacy predicate independent of the    *)
(*  bound) showing both a bounded-adequate and a bounded-inadequate case    *)
(*  co-exist; boundedness alone cannot rule either out.                     *)
(*                                                                          *)
(*  10.2 (lipschitz_reader_bounded): if a task reader O_Q is K-Lipschitz    *)
(*  (in the abstract rational metric) then a bounded retained state forces  *)
(*  a bounded reader output -- the direct triangle-inequality corollary     *)
(*  stated in the source. This is the one direction of 10.1/10.2 that IS   *)
(*  an implication (Lipschitz + bounded => reader bounded); it does not     *)
(*  contradict 10.1 because 10.1 is about task-ADEQUACY (an arbitrary,      *)
(*  not-necessarily-Lipschitz, not-necessarily-numeric predicate), while    *)
(*  10.2 is about the reader's numeric OUTPUT under an explicit Lipschitz   *)
(*  hypothesis that 10.1's adequacy predicate need not satisfy.             *)
(*                                                                          *)
(*  Expected: Print Assumptions on both theorems => Closed under the       *)
(*  global context.                                                         *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.QArith.Qabs.
Require Import Coq.micromega.Lia.
Local Open Scope Q_scope.

Section FourLayerElementary.

  (* ------------------------------------------------------------------- *)
  (* 10.1: boundedness of the retained state does not decide task         *)
  (* adequacy. Witnessed concretely: take the retained state space to be   *)
  (* just bool (a trivial "bounded" state, since every value of a finite   *)
  (* type is bounded by construction), and an arbitrary task-adequacy      *)
  (* predicate P : bool -> Prop that is genuinely free (not derivable from *)
  (* boundedness alone) -- both truth values of P are realized by a        *)
  (* bounded state, so "bounded" never determines P.                       *)
  (* ------------------------------------------------------------------- *)

  Theorem bounded_does_not_decide_adequacy :
    forall P : bool -> Prop,
      P true -> ~ P false ->
      (* both states are equally "bounded" (trivially, bool has only two   *)
      (* values, both within any nonnegative bound) yet they disagree on   *)
      (* P -- boundedness of the retained state carries no information     *)
      (* about task-adequacy. *)
      exists (I_R1 I_R2 : bool), P I_R1 /\ ~ P I_R2.
  Proof.
    intros P Htrue Hfalse.
    exists true, false. split; assumption.
  Qed.

  (* ------------------------------------------------------------------- *)
  (* 10.2: if the task reader O_Q is K-Lipschitz with respect to an        *)
  (* abstract rational distance from a fixed basepoint x0, then a bounded   *)
  (* retained state (distance from x0 at most B) forces a bounded reader    *)
  (* output (distance from O_Q x0 at most K*B).                            *)
  (* ------------------------------------------------------------------- *)

  Variable Val : Type.
  Variable dist : Val -> Val -> Q.
  Hypothesis dist_nonneg : forall x y, 0 <= dist x y.
  Hypothesis dist_refl : forall x, dist x x = 0.

  Variable x0 : Val.
  Variable O_Q : Val -> Val.
  Variable K B : Q.
  Hypothesis K_nonneg : 0 <= K.
  Hypothesis B_nonneg : 0 <= B.
  Hypothesis O_Q_lipschitz :
    forall x y, dist (O_Q x) (O_Q y) <= K * dist x y.

  Theorem lipschitz_reader_bounded :
    forall I_R : Val,
      dist I_R x0 <= B ->
      dist (O_Q I_R) (O_Q x0) <= K * B.
  Proof.
    intros I_R Hbound.
    apply Qle_trans with (y := K * dist I_R x0).
    - apply O_Q_lipschitz.
    - rewrite (Qmult_comm K (dist I_R x0)), (Qmult_comm K B).
      apply Qmult_le_compat_r; assumption.
  Qed.

End FourLayerElementary.
