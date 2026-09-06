(* EQ-015/M.03.v1 — CAN-004 — Dr — parents: EQ-015 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-004 — constitutional-ordering

    (* CAN-004 — root: Retention->Structure->Translation->Readout->Meaning->Experience->Memory->Belief->Claim->Checking->Status->Report — domain: root — tier: Definition — occurrences: 1 *)

    Twelve named stages, walked in a fixed order; the forbidden order is
    naming/status first, backfilling knowledge status after.  Discrete
    replacement: the order is a [nat]-valued index on a twelve-constructor
    [Inductive], never a continuum "before/after" relation. *)

Inductive CAN_004_Stage : Type :=
  | Stg_Retention | Stg_Structure | Stg_Translation | Stg_Readout
  | Stg_Meaning | Stg_Experience | Stg_Memory | Stg_Belief
  | Stg_Claim | Stg_Checking | Stg_Status | Stg_Report.

Definition CAN_004_index (s : CAN_004_Stage) : nat :=
  match s with
  | Stg_Retention => 0 | Stg_Structure => 1 | Stg_Translation => 2
  | Stg_Readout => 3 | Stg_Meaning => 4 | Stg_Experience => 5
  | Stg_Memory => 6 | Stg_Belief => 7 | Stg_Claim => 8
  | Stg_Checking => 9 | Stg_Status => 10 | Stg_Report => 11
  end.

(* The forbidden order named in CANONICAL.json's own words: reaching
   [Stg_Status] (or [Stg_Report]) without having passed through
   [Stg_Checking] first, i.e. naming a status ahead of the check that
   should have produced it. *)
Definition CAN_004_forbidden_order (reached_status : bool) (passed_checking : bool) : Prop :=
  reached_status = true /\ passed_checking = false.

(* Th_coqc: the twelve-stage index is injective, so the ordering is a
   genuine total order over distinct stages with no accidental collapse —
   this is what makes "index of Status > index of Checking" (below) a
   sound way to detect the forbidden order at all. *)
Theorem CAN_004_index_injective :
  forall s1 s2 : CAN_004_Stage, CAN_004_index s1 = CAN_004_index s2 -> s1 = s2.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate. Qed.

(* Th_coqc: Checking is strictly before Status is strictly before Report —
   the constitutional order forbids ever naming a status or filing a
   report at or before the checking stage, a direct numeric consequence
   of the fixed indices above (never re-derived from an external axiom). *)
Theorem CAN_004_checking_before_status_before_report :
  (CAN_004_index Stg_Checking < CAN_004_index Stg_Status)%nat
  /\ (CAN_004_index Stg_Status < CAN_004_index Stg_Report)%nat.
Proof. simpl. split; lia. Qed.

