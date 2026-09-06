(* weld/M.13.v1 — CAN-210 — Definition — parents: weld/M.02.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-210 — root: domain-weld (CAN-006) — domain: method —
   tier: Definition / Th_coqc — occurrences: 2 *)
(** A nested ladder of admissible identification sets A0 subset A1 subset
    ... subset Am, read as a [bool] membership sequence per candidate
    point (true = still inside the set at that rung); [CAN210_level]
    locates the first rung the point falls out of by a finite (fuel-free,
    structurally recursive on the list) search, and the search is proved
    correct: the located index genuinely marks a rung with [false]
    membership. *)
Fixpoint CAN210_first_false (l : list bool) (idx : nat) : option nat :=
  match l with
  | [] => None
  | b :: rest => if b then CAN210_first_false rest (S idx) else Some idx
  end.

Definition CAN210_level (membership : list bool) : option nat :=
  CAN210_first_false membership 0.

Theorem CAN210_level_correct : forall l idx j,
  CAN210_first_false l idx = Some j -> (idx <= j)%nat /\ nth (j - idx) l true = false.
Proof.
  induction l as [| b rest IH]; intros idx j H.
  - simpl in H. discriminate.
  - simpl in H. destruct b eqn:Hb.
    + apply IH in H. destruct H as [Hle Hnth].
      split.
      * lia.
      * assert (Heq : (j - idx = S (j - S idx))%nat) by lia.
        rewrite Heq. simpl. exact Hnth.
    + injection H as Heq. subst j.
      split.
      * lia.
      * assert (Heq0 : (idx - idx = 0)%nat) by lia.
        rewrite Heq0. simpl. reflexivity.
Qed.

