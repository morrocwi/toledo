(* Theta/P.61.v1 -- mapped_not_wrapped -> wrapped -- restates p3_spectrum_mid (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaSectorSpectrum_attempt.v) -- parents: Theta *)
(* name: p3_spectrum_mid (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of p3_spectrum_mid` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact p3_spectrum_mid.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaSectorSpectrum_attempt.

Definition Theta__P_61_v1_restates_p3_spectrum_mid_type := ltac:(let t := type of p3_spectrum_mid in exact t).
Theorem Theta__P_61_v1_restates_p3_spectrum_mid : Theta__P_61_v1_restates_p3_spectrum_mid_type.
Proof. exact p3_spectrum_mid. Qed.

Print Assumptions Theta__P_61_v1_restates_p3_spectrum_mid.
