(* Theta/P.39.v1 -- mapped_not_wrapped -> wrapped -- restates tree_gauge_fixable_P4 (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaOrientedSkewObstruction_attempt.v) -- parents: Theta *)
(* name: tree_gauge_fixable_P4 (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of tree_gauge_fixable_P4` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact tree_gauge_fixable_P4.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaOrientedSkewObstruction_attempt.

Definition Theta__P_39_v1_restates_tree_gauge_fixable_P4_type := ltac:(let t := type of tree_gauge_fixable_P4 in exact t).
Theorem Theta__P_39_v1_restates_tree_gauge_fixable_P4 : Theta__P_39_v1_restates_tree_gauge_fixable_P4_type.
Proof. exact tree_gauge_fixable_P4. Qed.

Print Assumptions Theta__P_39_v1_restates_tree_gauge_fixable_P4.
