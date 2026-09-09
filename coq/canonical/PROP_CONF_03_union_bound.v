(* ===================================================================== *)
(*  PROP_CONF_03_union_bound.v                                            *)
(*  Finite Bonferroni / union-bound lemma over Q, underlying the          *)
(*  Bonferroni-corrected multi-checkpoint conformal band (Toledo          *)
(*  weld/M.??.v1, PROP-CONF-03), registered from task-conditioned-6d-     *)
(*  pose-stop's GLS-2026-005 diagnosis (glosa) -- Toledo-first: this       *)
(*  registers the union-bound argument BEFORE it is used in that repo's   *)
(*  code.                                                                  *)
(*                                                                         *)
(*  What this proves: given a finite list of events E_1..E_K' on a common  *)
(*  measure mu that is (a) monotone (A subseteq B -> mu A <= mu B) and     *)
(*  (b) pairwise subadditive (mu (A cup B) <= mu A + mu B) -- both         *)
(*  ordinary properties of any probability measure -- and given rational   *)
(*  upper bounds p_1..p_K' with mu(E_m) <= p_m for each m, then             *)
(*  mu(union of all E_m) <= sum of all p_m.                                 *)
(*                                                                         *)
(*  What this does NOT prove: that pairwise subadditivity/monotonicity     *)
(*  hold for the specific conformal-coverage events in PROP-CONF-03 (that   *)
(*  is an instance of the ordinary axioms of any probability measure,      *)
(*  assumed here, not re-derived from first principles) -- nor that the    *)
(*  per-stage conformal quantile construction (PROP-CONF-01) itself        *)
(*  achieves mu(E_m) <= alpha/K' (that is the standard split-conformal      *)
(*  exchangeability argument, cited, not mechanized here). This file       *)
(*  mechanizes exactly the combinatorial step: K' separate alpha/K'-level   *)
(*  guarantees combine, by finite induction, into one alpha-level whole-    *)
(*  trajectory guarantee.                                                  *)
(*                                                                         *)
(*  Rational-native (no Coq.Reals): probabilities are represented only as  *)
(*  their declared upper bounds p_m : Q, never as a concrete real-valued    *)
(*  measure -- the lemma is stated generically over an abstract mu with    *)
(*  the two named properties, which any finite/discrete or continuous       *)
(*  probability measure satisfies.                                         *)
(*                                                                         *)
(*  Expected: Print Assumptions => Closed under the global context.        *)
(* ===================================================================== *)

Require Import Coq.Lists.List.
Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lia.
Import ListNotations.
Local Open Scope Q_scope.

Section UnionBound.

  (* An abstract "event space" with a union operation and an abstract measure
     mu into Q, satisfying monotonicity and pairwise subadditivity -- the two
     ordinary properties of any probability (or sub-probability) measure. *)
  Variable Event : Type.
  Variable union2 : Event -> Event -> Event.
  Variable mu : Event -> Q.
  Variable empty : Event.

  Hypothesis mu_nonneg : forall e, 0 <= mu e.
  Hypothesis mu_empty : mu empty = 0.
  Hypothesis mu_subadd : forall a b, mu (union2 a b) <= mu a + mu b.

  (* Fold a finite list of events into their union, starting from empty. *)
  Fixpoint union_all (l : list Event) : Event :=
    match l with
    | [] => empty
    | e :: rest => union2 e (union_all rest)
    end.

  (* Given per-event upper bounds (as a parallel list of Q), the measure of
     the union is bounded by the sum of the bounds -- finite Bonferroni. *)
  Theorem finite_union_bound :
    forall (events : list Event) (bounds : list Q),
      length events = length bounds ->
      Forall2 (fun e p => mu e <= p) events bounds ->
      mu (union_all events) <= fold_right Qplus 0 bounds.
  Proof.
    induction events as [| e events IH]; intros bounds Hlen Hall.
    - destruct bounds as [| p bounds]; simpl in Hlen; try discriminate.
      simpl. rewrite mu_empty. apply Qle_refl.
    - destruct bounds as [| p bounds]; simpl in Hlen; try discriminate.
      inversion Hall as [| e' p' events' bounds' Hep Hrest]; subst.
      simpl.
      apply Qle_trans with (y := mu e + mu (union_all events)).
      + apply mu_subadd.
      + apply Qplus_le_compat.
        * exact Hep.
        * apply IH; [congruence | exact Hrest].
  Qed.

  (* Corollary in the shape PROP-CONF-03 actually uses: K' checkpoints, each
     with a declared bound alpha/K', combine to an overall bound alpha. *)
  (* Direct helper: a list of n events each bounded by p has union bounded by n*p. *)
  Lemma union_bound_uniform :
    forall (events : list Event) (p : Q),
      Forall (fun e => mu e <= p) events ->
      mu (union_all events) <= inject_Z (Z.of_nat (length events)) * p.
  Proof.
    induction events as [| e events IH]; intros p Hall.
    - simpl. rewrite mu_empty. rewrite Qmult_0_l. apply Qle_refl.
    - inversion Hall as [| e' events' He Hrest]; subst.
      simpl length. rewrite Nat2Z.inj_succ. simpl union_all.
      apply Qle_trans with (y := mu e + mu (union_all events)).
      + apply mu_subadd.
      + apply Qle_trans with (y := p + inject_Z (Z.of_nat (length events)) * p).
        * apply Qplus_le_compat; [exact He | apply IH; exact Hrest].
        * setoid_replace (inject_Z (Z.succ (Z.of_nat (length events))))
            with (inject_Z (Z.of_nat (length events)) + 1)
            by (unfold Z.succ; rewrite inject_Z_plus; reflexivity).
          ring_simplify. apply Qle_refl.
  Qed.

  Corollary bonferroni_checkpoints :
    forall (K' : nat) (alpha : Q) (events : list Event),
      (0 < K')%nat ->
      0 <= alpha ->
      length events = K' ->
      Forall (fun e => mu e <= alpha / inject_Z (Z.of_nat K')) events ->
      mu (union_all events) <= alpha.
  Proof.
    intros K' alpha events HKpos Halpha Hlen Hall.
    assert (Hpos : (0 < Z.of_nat K')%Z) by lia.
    rewrite Zlt_Qlt in Hpos.
    change (inject_Z 0) with (0 # 1) in Hpos.
    assert (Hnz : ~ inject_Z (Z.of_nat K') == 0).
    { intro Heq. apply (Qlt_not_eq 0 (inject_Z (Z.of_nat K')) Hpos).
      symmetry. exact Heq. }
    apply Qle_trans with (y := inject_Z (Z.of_nat (length events)) * (alpha / inject_Z (Z.of_nat K'))).
    - apply union_bound_uniform. exact Hall.
    - rewrite Hlen.
      unfold Qdiv.
      rewrite Qmult_assoc.
      rewrite (Qmult_comm (inject_Z (Z.of_nat K')) alpha).
      rewrite <- Qmult_assoc.
      rewrite Qmult_inv_r by exact Hnz.
      rewrite Qmult_1_r.
      apply Qle_refl.
  Qed.

End UnionBound.
