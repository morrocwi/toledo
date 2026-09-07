(* weld/H.29.v1 -- not_yet_formalised -> definition -- Live-problem coupled epistemic system research architecture *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \text{Live Problem} \rightarrow \text{Core Respondent / Practitioner} + \text{Researcher} + \text{Interactional Expert if present} + \text{AI Model(s)} \rightarrow \text{Question} \rightarrow \text{Candidate Set} \rightarrow \text{Discrimination} \rightarrow \text{World Test} \rightarrow \text{Feedback} \rightarrow \text{Revision}. *)
(* Toledo v1.5 lane B (DEBT #45 part 2): finite-model definition --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   A defining equation/notion, not a theorem -- no proof obligation. *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__H_29_v1_sec.
  Parameter LiveProblem Actor Question CandidateSet Discrimination WorldTest Feedback Revision : Type.
  Parameter to_actors : LiveProblem -> Actor.
  Parameter to_question : Actor -> Question.
  Parameter to_candidates : Question -> CandidateSet.
  Parameter to_discrimination : CandidateSet -> Discrimination.
  Parameter to_worldtest : Discrimination -> WorldTest.
  Parameter to_feedback : WorldTest -> Feedback.
  Parameter to_revision : Feedback -> Revision.
  Definition weld__H_29_v1_def (p : LiveProblem) : Revision :=
    to_revision (to_feedback (to_worldtest (to_discrimination (to_candidates (to_question (to_actors p)))))).
End weld__H_29_v1_sec.
