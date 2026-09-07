(* Theta/P.22.v1 -- mapped_not_wrapped -> wrapped -- restates c4_edge12_locus_excluded (readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a:coq/readout_genesis/formal/InfoThetaLivingOrientationSign_attempt.v) -- parents: Theta *)
(* name: c4_edge12_locus_excluded (Corollary) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of c4_edge12_locus_excluded` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact c4_edge12_locus_excluded.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.
From ReadoutGenesis.Formal Require Import InfoThetaLivingOrientationSign_attempt.

Definition Theta__P_22_v1_restates_c4_edge12_locus_excluded_type := ltac:(let t := type of c4_edge12_locus_excluded in exact t).
Corollary Theta__P_22_v1_restates_c4_edge12_locus_excluded : Theta__P_22_v1_restates_c4_edge12_locus_excluded_type.
Proof. exact c4_edge12_locus_excluded. Qed.

Print Assumptions Theta__P_22_v1_restates_c4_edge12_locus_excluded.
