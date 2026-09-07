(* Theta/P.07.v1 -- mapped_not_wrapped -> wrapped -- restates agreement_is_dead (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaFixedPointBalance_attempt.v) -- parents: Theta *)
(* name: agreement_is_dead (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of agreement_is_dead` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact agreement_is_dead.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaFixedPointBalance_attempt.

Definition Theta__P_07_v1_restates_agreement_is_dead_type := ltac:(let t := type of agreement_is_dead in exact t).
Theorem Theta__P_07_v1_restates_agreement_is_dead : Theta__P_07_v1_restates_agreement_is_dead_type.
Proof. exact agreement_is_dead. Qed.

Print Assumptions Theta__P_07_v1_restates_agreement_is_dead.
