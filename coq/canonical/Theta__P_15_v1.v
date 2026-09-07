(* Theta/P.15.v1 -- mapped_not_wrapped -> wrapped -- restates locus_Z0Z2_J_pos (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaLivingOrientationSign_attempt.v) -- parents: Theta *)
(* name: locus_Z0Z2_J_pos (Corollary) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of locus_Z0Z2_J_pos` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact locus_Z0Z2_J_pos.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaLivingOrientationSign_attempt.

Definition Theta__P_15_v1_restates_locus_Z0Z2_J_pos_type := ltac:(let t := type of locus_Z0Z2_J_pos in exact t).
Corollary Theta__P_15_v1_restates_locus_Z0Z2_J_pos : Theta__P_15_v1_restates_locus_Z0Z2_J_pos_type.
Proof. exact locus_Z0Z2_J_pos. Qed.

Print Assumptions Theta__P_15_v1_restates_locus_Z0Z2_J_pos.
