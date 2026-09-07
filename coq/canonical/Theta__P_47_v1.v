(* Theta/P.47.v1 -- mapped_not_wrapped -> wrapped -- restates family_A_witness_original_value (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaQuartetSquareObstruction_attempt.v) -- parents: Theta *)
(* name: family_A_witness_original_value (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of family_A_witness_original_value` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact family_A_witness_original_value.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaQuartetSquareObstruction_attempt.

Definition Theta__P_47_v1_restates_family_A_witness_original_value_type := ltac:(let t := type of family_A_witness_original_value in exact t).
Theorem Theta__P_47_v1_restates_family_A_witness_original_value : Theta__P_47_v1_restates_family_A_witness_original_value_type.
Proof. exact family_A_witness_original_value. Qed.

Print Assumptions Theta__P_47_v1_restates_family_A_witness_original_value.
