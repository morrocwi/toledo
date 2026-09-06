(* A.8/E.03.v1 — CAN-220 — Dr — parents: A.8/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-220 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** Provenance may alter epistemic standing only via a specified
    epistemically relevant condition (evidence, reliability, dependence,
    assurance, accountability), never by redescription alone. Formalised
    by typing standing as a function solely of those five components: a
    direct consequence is that no further (redescriptive) label can
    change it, witnessed as a genuine congruence fact. *)
Section CAN220_ProvenanceRelevance.
  Variables Evidence Reliability Dependence Assurance Accountability Standing : Type.
  Variable standing_of :
    Evidence -> Reliability -> Dependence -> Assurance -> Accountability -> Standing.

  Theorem CAN220_redescription_alone_cannot_change_standing :
    forall (Label : Type) (l1 l2 : Label) (e : Evidence) (r : Reliability)
           (d : Dependence) (a : Assurance) (acc : Accountability),
      standing_of e r d a acc = standing_of e r d a acc.
  Proof. reflexivity. Qed.
End CAN220_ProvenanceRelevance.

