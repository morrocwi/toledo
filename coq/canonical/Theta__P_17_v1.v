(* Theta/P.17.v1 -- mapped_not_wrapped -> wrapped -- restates diffRec_taylor_identity (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaLivingOrientationSign_attempt.v) -- parents: Theta *)
(* name: diffRec_taylor_identity (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of diffRec_taylor_identity` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact diffRec_taylor_identity.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaLivingOrientationSign_attempt.

Definition Theta__P_17_v1_restates_diffRec_taylor_identity_type := ltac:(let t := type of diffRec_taylor_identity in exact t).
Theorem Theta__P_17_v1_restates_diffRec_taylor_identity : Theta__P_17_v1_restates_diffRec_taylor_identity_type.
Proof. exact diffRec_taylor_identity. Qed.

Print Assumptions Theta__P_17_v1_restates_diffRec_taylor_identity.
