(* weld/E.13.v1 -- Definition -- FAQR applicability gate.                     *)
(* NEW DERIVATION / PROPOSAL. Claim boundary: facts/options projection; not a *)
(* fatwa, ruling, mediation, or religious verdict; EQ-015 CE structural only. *)
(* ResolveLaw returns candidate laws or Undetermined. The outcome function    *)
(* releases CaseAnswer only when a non-empty candidate set is returned AND a  *)
(* decision of CaseAnswerReady (all four readiness conditions) is supplied as *)
(* a sumbool; a failed decision gives LawComparisonOnly; an empty or          *)
(* undetermined candidate set gives ApplicabilityUndetermined. Definition     *)
(* only: no theorem, no legal-decision algorithm.                             *)

Require Import List.

Section weld__E_13_v1_sec.
  Parameter Law Forum Issue Party Connection Exception Time ConflictRule : Type.

  Inductive Resolution : Type :=
    | Candidates : list Law -> Resolution
    | Undetermined : Resolution.

  Inductive Outcome : Type :=
    | CaseAnswer : Outcome
    | LawComparisonOnly : Outcome
    | ApplicabilityUndetermined : Outcome.

  (* ConflictRules(f,t) *)
  Parameter ConflictRules : Forum -> Time -> list ConflictRule.

  (* L*_{i,f,t} := ResolveLaw(ConflictRules(f,t), P, K_i, {L(c,s,t)}, X_f)
     The law set {L(c,s,t)} is the list of Law argument; f and t enter via
     ConflictRules f t. *)
  Parameter ResolveLaw : list ConflictRule -> list Party -> list Connection
                         -> list Law -> list Exception -> Resolution.

  Definition CaseAnswerReady (verified_law verified_factors verified_forum
                              competent_review : Prop) : Prop :=
    verified_law /\ verified_factors /\ verified_forum /\ competent_review.

  Definition weld__E_13_v1_outcome
             (verified_law verified_factors verified_forum
              competent_review : Prop)
             (ready : {CaseAnswerReady verified_law verified_factors
                                       verified_forum competent_review}
                      + {~ CaseAnswerReady verified_law verified_factors
                                           verified_forum competent_review})
             (r : Resolution) : Outcome :=
    match r with
    | Undetermined => ApplicabilityUndetermined
    | Candidates nil => ApplicabilityUndetermined
    | Candidates _ =>
        match ready with
        | left _ => CaseAnswer
        | right _ => LawComparisonOnly
        end
    end.
End weld__E_13_v1_sec.
