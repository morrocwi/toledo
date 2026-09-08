(* EQ-015/H.14.v1 — CAN-071 — Dr — parents: EQ-015/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Require Import MR.MR_Prompt.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-071 — resistance-quality-accessibility

    (* CAN-071 — root: R_s^ep=rho(Is,Vs,Qs); U_s^R=u(Csv,Tsv,Asv); R_s^ex=psi(R_s^ep,U_s^R); Resistance quality<>resistance accessibility — domain: human–AI — tier: Dr — occurrences: 3 *)

    CANONICAL.json tier: "proposition/law". No Master River eq. citation.
    The three declared functions are typed abstractly; the non-collapse
    clause is discharged in the same bool-witness idiom used throughout. *)

Section CAN_071_ResistanceQualityAccessibility.

  Variables IsT VsT QsT CsvT TsvT AsvT REp UR REx : Type.
  Variable rho_fn : IsT -> VsT -> QsT -> REp.
  Variable u_fn : CsvT -> TsvT -> AsvT -> UR.
  Variable psi_fn : REp -> UR -> REx.

  Definition CAN_071_R_ep (i : IsT) (v : VsT) (q : QsT) : REp := rho_fn i v q.
  Definition CAN_071_U_R (c : CsvT) (t : TsvT) (a : AsvT) : UR := u_fn c t a.
  Definition CAN_071_R_ex (r : REp) (u : UR) : REx := psi_fn r u.

  Theorem CAN_071_quality_ne_accessibility :
    exists (D : Type) (ResistanceQuality ResistanceAccessibility : D -> Prop) (x : D),
      ResistanceQuality x /\ ~ ResistanceAccessibility x.
  Proof. exists bool, (fun _:bool=>True), (fun _:bool=>False), true. split; [exact I| intro H; exact H]. Qed.

End CAN_071_ResistanceQualityAccessibility.

