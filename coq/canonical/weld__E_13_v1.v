(* weld/E.13.v1 -- Definition -- FAQR applicability gate.                     *)
(* NEW DERIVATION / PROPOSAL. Claim boundary: facts/options projection; not a *)
(* fatwa, ruling, mediation, or religious verdict; EQ-015 CE structural only. *)
(* ResolveLaw returns candidate laws or Undetermined; an answer is released   *)
(* only when all four readiness conditions hold, else comparison-only or      *)
(* undetermined. Definition only: no theorem, no legal-decision algorithm.   *)

Require Import List.

Section weld__E_13_v1_sec.
  Parameter Law Forum Issue Party Connection Exception : Type.

  Inductive Resolution : Type :=
    | Candidates : list Law -> Resolution
    | Undetermined : Resolution.

  Inductive Outcome : Type :=
    | CaseAnswer : Outcome
    | LawComparisonOnly : Outcome
    | ApplicabilityUndetermined : Outcome.

  (* L*_{i,f,t} := ResolveLaw(ConflictRules(f,t), P, K_i, {L(c,s,t)}, X_f) *)
  Parameter ResolveLaw : Forum -> list Party -> list Connection
                         -> list Exception -> Resolution.

  Definition CaseAnswerReady (verified_law verified_factors verified_forum
                              competent_review : Prop) : Prop :=
    verified_law /\ verified_factors /\ verified_forum /\ competent_review.

  Definition weld__E_13_v1_outcome (ready : bool) (r : Resolution) : Outcome :=
    match ready, r with
    | true, Candidates _ => CaseAnswer
    | false, Candidates _ => LawComparisonOnly
    | _, Undetermined => ApplicabilityUndetermined
    end.
End weld__E_13_v1_sec.
