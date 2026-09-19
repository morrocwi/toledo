(* EQ-015/M.19.v1 -- NEW DERIVATION / PROPOSAL -- not yet in Toledo -- constraint test as a status-transition function tau : (claim, D, Sigma) -> S *)
(* source: "Human Learning as Epistemic Architecture", Zenodo 10.5281/zenodo.22341297 *)
(* candidate report: no match anywhere in registry/CANONICAL.json for the
   {candidate, supported, revised, rejected} status vocabulary or a
   claim/evidence/context -> status transition function of this arity;
   Toledo's own Th_coqc/finite_diagnostic/Dr/Open tier ladder is a related
   but distinct object (the REGISTRY's own convention, not a claim-level
   status of an individual learner's belief), so it is cited only as a
   relates-to, never as the same object. This file states the FORM of the
   candidate: a closed four-way status type, and the transition function
   as an abstract Variable of the stated arity, per the
   EQ_015__M_11_v1.v (CAN211_AugmentationKind) house pattern -- including
   its precedent's pairwise-distinctness theorem, the one thing a closed
   finite Inductive of this kind actually proves for free. *)

Set Implicit Arguments.

Section EQ_015_M_19_v1_sec.

  (* Claim : the proposition/belief under test.
     Evidence : the source paper's D (the diagnostic/evidence bundle).
     Context : the source paper's Sigma (the surrounding constraint context). *)
  Variables Claim Evidence Context : Type.

  (* The closed four-way status codomain S named by the candidate. *)
  Inductive EQ_015_M_19_v1_Status :=
    | EQ_015_M_19_v1_Candidate
    | EQ_015_M_19_v1_Supported
    | EQ_015_M_19_v1_Revised
    | EQ_015_M_19_v1_Rejected.

  Theorem EQ_015_M_19_v1_status_pairwise_distinct :
    EQ_015_M_19_v1_Candidate <> EQ_015_M_19_v1_Supported
    /\ EQ_015_M_19_v1_Supported <> EQ_015_M_19_v1_Revised
    /\ EQ_015_M_19_v1_Revised <> EQ_015_M_19_v1_Rejected
    /\ EQ_015_M_19_v1_Candidate <> EQ_015_M_19_v1_Rejected.
  Proof. repeat split; discriminate. Qed.

  (* The constraint test itself: tau : (claim, D, Sigma) -> S, left as an
     abstract Variable of exactly this arity -- nothing about which claims
     it sends where is asserted. *)
  Definition EQ_015_M_19_v1_tau_type : Type := Claim -> Evidence -> Context -> EQ_015_M_19_v1_Status.
  Variable EQ_015_M_19_v1_tau : EQ_015_M_19_v1_tau_type.

End EQ_015_M_19_v1_sec.

Print Assumptions EQ_015_M_19_v1_status_pairwise_distinct.
