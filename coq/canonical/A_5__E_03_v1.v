(* A.5/E.03.v1 — CAN-209 — Definition — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-209 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Definition — occurrences: 1 *)
(** D_Phi(x0) = {d = (x0,x') : Phi(x') <> Phi(x0)}; P(d) = (V_d,E_d,
    tau_d): a unit of distinction as a filtered pair-list, and its
    provenance path as a labeled graph record. Soundness of the filter
    (every returned candidate really witnesses a Phi-difference) is
    proved directly. *)
Section CAN209_ProvenanceDistinction.
  Variables Xty Label : Type.
  Variable Phi : Xty -> Label.
  Variable label_eq_dec : forall l1 l2 : Label, {l1 = l2} + {l1 <> l2}.

  Definition CAN209_distinguishes (x0 x' : Xty) : bool :=
    if label_eq_dec (Phi x') (Phi x0) then false else true.

  Definition CAN209_D_Phi (x0 : Xty) (candidates : list Xty) : list Xty :=
    filter (CAN209_distinguishes x0) candidates.

  Theorem CAN209_D_Phi_sound :
    forall (x0 x' : Xty) (candidates : list Xty),
      In x' (CAN209_D_Phi x0 candidates) -> Phi x' <> Phi x0.
  Proof.
    intros x0 x' candidates Hin.
    unfold CAN209_D_Phi in Hin.
    apply filter_In in Hin. destruct Hin as [_ Hb].
    unfold CAN209_distinguishes in Hb.
    destruct (label_eq_dec (Phi x') (Phi x0)) as [Heq | Hneq].
    - discriminate Hb.
    - exact Hneq.
  Qed.

  Record CAN209_Path (V E : Type) : Type := mkCAN209Path
    { c209_vertices : list V
    ; c209_edges : list E
    ; c209_labels : E -> Label
    }.
End CAN209_ProvenanceDistinction.

(* ==================================================================== *)
(** ** Group 5 — provenance principles ("Written by AI. Still True.")
    (CAN-217..CAN-221, CAN-223, CAN-224). *)

