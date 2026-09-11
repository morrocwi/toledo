(* ===================================================================== *)
(*  PROP_EPSC_08_lipschitz_tail_lift.v                                    *)
(*  Toledo PROP-EPSC-08, Lipschitz readout lift of an epsilon tail         *)
(*  certificate, registered in                                            *)
(*  registry/proposals/discrete_epsilon_completion.json.                  *)
(*                                                                         *)
(*  What this proves: if Q is L_Q-Lipschitz on Y (||Q(a)-Q(b)|| <=        *)
(*  L_Q*||a-b|| for all a,b in Y) and ||u - P_K u|| <= beta, then          *)
(*  ||Q(u) - Q(P_K u)|| <= L_Q * beta -- an immediate instance of the      *)
(*  Lipschitz condition at the two points (u, P_K u), monotone in the     *)
(*  distance bound. Rational-native (Q), no Coq.Reals.                    *)
(*                                                                         *)
(*  What this does NOT prove: that any concrete readout Q used elsewhere  *)
(*  in this workspace is actually Lipschitz, nor that beta (the omitted-  *)
(*  tail certificate itself) is small for a real signal -- both are       *)
(*  separate, per-instance obligations exactly as the source states.      *)
(*                                                                         *)
(*  Expected: Print Assumptions => Closed under the global context.       *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.

Section LipschitzTailLift.

  (* An abstract metric space (Y, dist) given only by its distance      *)
  (* function and the two properties actually used: nonnegativity is    *)
  (* not needed, only monotonicity of the Lipschitz bound in the input  *)
  (* distance, which is immediate substitution. *)
  Variable Y : Type.
  Variable dist : Y -> Y -> Q.

  Variable Q_map : Type.
  Variable Qdist : Q_map -> Q_map -> Q.
  Variable Qread : Y -> Q_map.

  Variable L_Q : Q.
  Hypothesis L_Q_nonneg : 0 <= L_Q.

  (* L_Q-Lipschitz hypothesis for the readout Q_read on Y. *)
  Hypothesis lipschitz :
    forall a b : Y, Qdist (Qread a) (Qread b) <= L_Q * dist a b.

  Variable u PKu : Y.
  Variable beta : Q.
  Hypothesis tail_bound : dist u PKu <= beta.

  Theorem epsc08_lipschitz_tail_lift :
    Qdist (Qread u) (Qread PKu) <= L_Q * beta.
  Proof.
    apply Qle_trans with (y := L_Q * dist u PKu).
    - apply lipschitz.
    - rewrite (Qmult_comm L_Q (dist u PKu)).
      rewrite (Qmult_comm L_Q beta).
      apply Qmult_le_compat_r; assumption.
  Qed.

End LipschitzTailLift.
