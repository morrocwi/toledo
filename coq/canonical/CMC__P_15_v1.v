(* CMC/P.15.v1 -- mapped_not_wrapped -> wrapped -- restates fourier_heat_singular_memoryless_face_not_refuter (solver arc (private)@961151db33b0491cba8fabade69f594238d33f84:coq/solver-arc/formal/CMC_PhysicsClass_Instances.v) -- parents: CMC *)
(* name: fourier_heat_singular_memoryless_face_not_refuter (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias.
   The type is obtained from Coq's own `type of fourier_heat_singular_memoryless_face_not_refuter` (see this
   script's build_wrapper_text docstring for why: Section-variable
   auto-generalization in the source makes a hand-copied type
   text from statement.latest unreliable for some of these 119
   entries). The proof is `exact fourier_heat_singular_memoryless_face_not_refuter.` against the
   already-verified import below -- no new proof technique,
   no new claim. *)

From RDL.formal Require Import CMC_TargetClass_Definitions.
From MRC Require Import _cmc_mirror_CMC_Bridge_Decomposition.
From MRC Require Import _cmc_mirror_CMC_PhysicsClass_Instances.

Definition CMC__P_15_v1_restates_fourier_heat_singular_memoryless_face_not_refuter_type := ltac:(let t := type of fourier_heat_singular_memoryless_face_not_refuter in exact t).
Theorem CMC__P_15_v1_restates_fourier_heat_singular_memoryless_face_not_refuter : CMC__P_15_v1_restates_fourier_heat_singular_memoryless_face_not_refuter_type.
Proof. exact fourier_heat_singular_memoryless_face_not_refuter. Qed.

Print Assumptions CMC__P_15_v1_restates_fourier_heat_singular_memoryless_face_not_refuter.
