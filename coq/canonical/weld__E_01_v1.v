(* weld/E.01.v1 — CAN-025 — Definition — parents: weld/M.03.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-025 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 2 *)
(** Know_A(W) = 1 iff Dist(R_A[n], R_A^nu[n]) <= eps_K for all admissible
    variations nu on window W: knowledge as stability-achievement, made
    decidable given a decidable base distance-comparison and a finite
    list of admissible variations. *)
Section CAN025_KnowledgeStability.
  Variables Variation Reading : Type.
  Variable dist : Reading -> Reading -> Q.
  Variable R_A : Variation -> Reading.
  Variable eps_K : Q.

  Definition CAN025_stable_under (base : Reading) (variations : list Variation) : Prop :=
    Forall (fun nu => dist base (R_A nu) <= eps_K) variations.

  Definition CAN025_stable_under_dec
    (dist_dec : forall x y, {dist x y <= eps_K} + {~ dist x y <= eps_K})
    (base : Reading) (variations : list Variation) :
    {CAN025_stable_under base variations} + {~ CAN025_stable_under base variations}.
  Proof.
    unfold CAN025_stable_under.
    induction variations as [| nu rest IH].
    - left. constructor.
    - destruct (dist_dec base (R_A nu)) as [Hy | Hn].
      + destruct IH as [Hrest | Hrest].
        * left. constructor; assumption.
        * right. intro Hc. inversion Hc; contradiction.
      + right. intro Hc. inversion Hc; contradiction.
  Defined.
End CAN025_KnowledgeStability.

