(* Theta/P.83.v1 -- mapped_not_wrapped -> wrapped -- restates neutral_unitary (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoCPEquivariantGenerationBound_attempt.v) -- parents: Theta *)
(* name: neutral_unitary (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of neutral_unitary` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact neutral_unitary.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoCPEquivariantGenerationBound_attempt.

Definition Theta__P_83_v1_restates_neutral_unitary_type := ltac:(let t := type of neutral_unitary in exact t).
Theorem Theta__P_83_v1_restates_neutral_unitary : Theta__P_83_v1_restates_neutral_unitary_type.
Proof. exact neutral_unitary. Qed.

Print Assumptions Theta__P_83_v1_restates_neutral_unitary.
