(* EQ-002/E.08.v1 — CAN-040 — Definition — parents: EQ-002/M.03.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-040 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition / Th_coqc — occurrences: 1 *)
(** k_epi(t) = |New_{t+1}| / max(1,|F_t|); k_epi<1 contractive, k_epi=~1
    critical, k_epi>1 expanding. [|New|]/[|F_t|] are readout-first [nat]
    cardinalities; the ratio is a [Q] built via [Qmake] over a strictly
    positive denominator (never a continuum division), and the
    contractive-regime classification is proved correct against its
    defining inequality. *)
Inductive CAN040_Regime := CAN040_Contractive | CAN040_Critical | CAN040_Expanding.

Definition CAN040_k_epi (new_count frontier_count : nat) : Q :=
  Qmake (Z.of_nat new_count) (Pos.of_nat (max 1 frontier_count)).

Definition CAN040_classify (k : Q) : CAN040_Regime :=
  match Qlt_le_dec k 1 with
  | left _ => CAN040_Contractive
  | right _ =>
      match Qeq_dec k 1 with
      | left _ => CAN040_Critical
      | right _ => CAN040_Expanding
      end
  end.

Theorem CAN040_classify_contractive_correct :
  forall k : Q, k < 1 -> CAN040_classify k = CAN040_Contractive.
Proof.
  intros k Hk. unfold CAN040_classify.
  destruct (Qlt_le_dec k 1) as [Hlt | Hle].
  - reflexivity.
  - exfalso. exact (Qlt_not_le k 1 Hk Hle).
Qed.

(* ==================================================================== *)
(** ** Group 4 — the mission-stepper reading and its provenance pipeline
    (CAN-202..CAN-209): new content, sourced from "Readout Genesis
    Standalone Synthesis", "Genesis Constraint-First Alignment
    Epistemology", "Experience Is the Human LoRA", "From Problem to
    Hypothesis", "The Standalone Scholar". *)

