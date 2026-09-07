(* Theta/P.73.v1 -- mapped_not_wrapped -> wrapped -- restates witness_partial_disorder_P3 (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaTopologyReadout_attempt.v) -- parents: Theta *)
(* name: witness_partial_disorder_P3 (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of witness_partial_disorder_P3` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact witness_partial_disorder_P3.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaTopologyReadout_attempt.

Definition Theta__P_73_v1_restates_witness_partial_disorder_P3_type := ltac:(let t := type of witness_partial_disorder_P3 in exact t).
Theorem Theta__P_73_v1_restates_witness_partial_disorder_P3 : Theta__P_73_v1_restates_witness_partial_disorder_P3_type.
Proof. exact witness_partial_disorder_P3. Qed.

Print Assumptions Theta__P_73_v1_restates_witness_partial_disorder_P3.
