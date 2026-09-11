(* ===================================================================== *)
(*  PROP_EPSC_39_self_map_budget_gate.v                                  *)
(*  Toledo PROP-EPSC-39, Finite direct-sample self-map budget gate,       *)
(*  registered in                                                        *)
(*  registry/proposals/discrete_epsilon_completion_direct_sample_branch.json *)
(*                                                                        *)
(*  What this proves: given rational q,normA,delta,r with q < 1, and     *)
(*  the self-map budget inequality normA*delta + q*r <= r, then           *)
(*  delta <= (1-q)*r / normA (whenever normA > 0), and the conditional    *)
(*  radius factor rho_cond := (normA/(1-q))*delta satisfies rho_cond<=r.  *)
(*  Both are exact finite algebraic rearrangements of the hypothesis --   *)
(*  no analysis beyond field arithmetic in Q. Rational-native, no         *)
(*  Coq.Reals.                                                            *)
(*                                                                        *)
(*  What this does NOT prove: that q, normA, delta, r are genuinely       *)
(*  certified quantities for any real finite-sample system -- those are  *)
(*  separate, per-instance obligations exactly as the source states.      *)
(*                                                                        *)
(*  Expected: Print Assumptions => Closed under the global context.       *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Section SelfMapBudgetGate.

  Variables q normA delta r : Q.
  Hypothesis q_lt_1 : q < 1.
  Hypothesis normA_pos : 0 < normA.
  Hypothesis budget : normA * delta + q * r <= r.

  Lemma one_minus_q_pos : 0 < 1 - q.
  Proof. lra. Qed.

  Theorem epsc39_delta_bound : delta <= (1 - q) * r / normA.
  Proof.
    apply Qle_shift_div_l; [assumption |].
    lra.
  Qed.

  Theorem epsc39_rho_cond_bound' : normA * delta <= r * (1 - q) ->
    (normA / (1 - q)) * delta <= r.
  Proof.
    intro H.
    assert (Hpos := one_minus_q_pos).
    assert (Heq : (normA / (1 - q)) * delta == (normA * delta) / (1 - q)).
    { unfold Qdiv. ring. }
    rewrite Heq.
    apply Qle_shift_div_r; assumption.
  Qed.

  Theorem epsc39_rho_cond : (normA / (1 - q)) * delta <= r.
  Proof.
    apply epsc39_rho_cond_bound'.
    lra.
  Qed.

End SelfMapBudgetGate.
