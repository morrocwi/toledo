(* Theta/P.52.v1 -- mapped_not_wrapped -> wrapped -- restates symmetric_source_not_switching_covariant (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaQuartetSquareObstruction_attempt.v) -- parents: Theta *)
(* name: symmetric_source_not_switching_covariant (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of symmetric_source_not_switching_covariant` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact symmetric_source_not_switching_covariant.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaQuartetSquareObstruction_attempt.

Definition Theta__P_52_v1_restates_symmetric_source_not_switching_covariant_type := ltac:(let t := type of symmetric_source_not_switching_covariant in exact t).
Theorem Theta__P_52_v1_restates_symmetric_source_not_switching_covariant : Theta__P_52_v1_restates_symmetric_source_not_switching_covariant_type.
Proof. exact symmetric_source_not_switching_covariant. Qed.

Print Assumptions Theta__P_52_v1_restates_symmetric_source_not_switching_covariant.
