(* weld/S.52.v1 -- NEW DERIVATION / PROPOSAL -- not yet in Toledo -- falsification condition: not[E[T_M]>E[T_Y]] /\ not[E[C_M]>E[C_Y]] *)
(* source: "Human Learning as Epistemic Architecture", Zenodo 10.5281/zenodo.22341297 *)
(* candidate report: zero hits for "yoked", "disconfirm", "transfer task";
   "calibration" hits in registry/CANONICAL.json are all unrelated
   (physics/biology bridge-calibration objects, not this psychometric
   design). weld/S.09.v1 ("eight falsifiable hypotheses") is a sibling
   empirical-programme object, cited only as relates-to. Readout-first
   discipline (information-discrete-math): the expectations E[T_M],
   E[T_Y], E[C_M], E[C_Y] are each already a finite discrete readout (a
   sample mean over a finite executed run), so they are modelled directly
   as rationals (Q), never as a continuum real -- no h->0 / completeness
   is injected. The one genuine corollary this double-negation form
   supports is its restatement as the two non-strict Qle facts, proved
   below via the QArith library's own Qnot_lt_le. *)

Require Import QArith.

Section weld_S_52_v1_sec.

  (* ET_M, ET_Y : E[T_M], E[T_Y] -- the yoked-comparison "transfer task"
     score expectations for the Model-taught and Yoked-control arms.
     EC_M, EC_Y : E[C_M], E[C_Y] -- the matching "calibration" score
     expectations for the same two arms. Each is a finite readout (a
     rational), left as an abstract Variable of the run in question. *)
  Variables ET_M ET_Y EC_M EC_Y : Q.

  Definition weld_S_52_v1_falsification_condition : Prop :=
    ~ (ET_M > ET_Y) /\ ~ (EC_M > EC_Y).

  Theorem weld_S_52_v1_falsification_condition_as_le :
    weld_S_52_v1_falsification_condition -> ET_M <= ET_Y /\ EC_M <= EC_Y.
  Proof.
    intros [H1 H2]. split.
    - apply Qnot_lt_le. exact H1.
    - apply Qnot_lt_le. exact H2.
  Qed.

End weld_S_52_v1_sec.

Print Assumptions weld_S_52_v1_falsification_condition_as_le.
