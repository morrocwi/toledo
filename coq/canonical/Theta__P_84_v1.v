(* Theta/P.84.v1 -- mapped_not_wrapped -> wrapped -- restates neutral_J_zero (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoCPEquivariantGenerationBound_attempt.v) -- parents: Theta *)
(* name: neutral_J_zero (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of neutral_J_zero` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact neutral_J_zero.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoCPEquivariantGenerationBound_attempt.

Definition Theta__P_84_v1_restates_neutral_J_zero_type := ltac:(let t := type of neutral_J_zero in exact t).
Theorem Theta__P_84_v1_restates_neutral_J_zero : Theta__P_84_v1_restates_neutral_J_zero_type.
Proof. exact neutral_J_zero. Qed.

Print Assumptions Theta__P_84_v1_restates_neutral_J_zero.
