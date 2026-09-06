(* EQ-015/S.16.v1 — Definition — parents: EQ-015/M.02.v1, EQ-015/S.01.v1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import weld__S_02_v1.
From MRC Require Import MRC_Prelude.

Section CAN_117_Regime.

  Variable Event : Type.

  Definition CAN_117_Record := CAN_116_ManifestedRecord Event.

  Record CAN_117_Regime : Type := mkRegime
    { reg_T_R : CAN_117_Record -> CAN_117_Record                    (* translation operator: updates M *)
    ; reg_I_R : CAN_117_Record -> CAN_117_Record -> CAN_117_Record  (* interaction operator: updates A given M *)
    }.

  Definition CAN_117_record_updates (R : CAN_117_Regime) (M M' : CAN_117_Record) : Prop :=
    M' = reg_T_R R M.

  Definition CAN_117_agency_updates (R : CAN_117_Regime) (A M A' : CAN_117_Record) : Prop :=
    incl A' (reg_I_R R A M).

  (* CE-08: Etic(A;t') — the minimal admissibility layer: some admissible
     regime exists under which A is a genuine agency in M and both update
     laws hold for one tick. [R_adm] is the declared admissible-regime set
     (a finite list, never an unbounded comprehension). *)
  Definition CAN_117_Etic
             (R_adm : list CAN_117_Regime) (A M M' A' : CAN_117_Record) : Prop :=
    exists R : CAN_117_Regime,
      In R R_adm
      /\ CAN_116_is_agency A M
      /\ CAN_117_record_updates R M M'
      /\ CAN_117_agency_updates R A M A'.

  (* Witness (tier: Th_coqc): Etic is satisfiable by the identity regime
     (T_R and I_R both act as the identity on the record component), on a
     one-event finite model — the minimal admissibility layer is not
     vacuous. *)
  Theorem CAN_117_etic_satisfiable :
    forall e : Event,
      exists (R_adm : list CAN_117_Regime) (A M M' A' : CAN_117_Record),
        CAN_117_Etic R_adm A M M' A'.
  Proof.
    intro e.
    pose (R0 := mkRegime (fun M => M) (fun A M => M)).
    exists [R0], [e], [e], [e], [e], R0.
    assert (H1 : In R0 [R0]) by (left; reflexivity).
    assert (H2 : CAN_116_is_agency [e] [e]) by (intros x Hx; exact Hx).
    assert (H3 : CAN_117_record_updates R0 [e] [e]) by reflexivity.
    assert (H4 : CAN_117_agency_updates R0 [e] [e] [e]) by (intros x Hx; exact Hx).
    exact (conj H1 (conj H2 (conj H3 H4))).
  Qed.

End CAN_117_Regime.
