(* weld/S.41.v1 — Definition — parents: weld/M.02.v1, weld/S.03.v1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section CAN_120_MoralCost.

  Variable Vplus : nat -> Q.       (* per-tick worsening-load indicator, >= 0 *)
  Variable chi_causal chi_spec : Q. (* per-regime causal-memory / spectral violation indicators *)
  Variable alpha beta gamma : Q.
  Hypothesis Halpha : alpha > 0.
  Hypothesis Hbeta  : beta  > 0.
  Hypothesis Hgamma : gamma > 0.

  (* Tragic regime class: every regime in a declared finite list is either
     inadmissible or incurs strictly positive unavoidable cost. *)
  Definition CAN_120_Tragic
             (regimes : list nat) (admissible : nat -> bool) (cost : nat -> Q) : Prop :=
    Forall (fun r => admissible r = false \/ cost r > 0) regimes.

  (* Witness (tier: Definition): Tragic is satisfiable on a finite two-regime
     model, one inadmissible and one admissible-but-costly. *)
  Theorem CAN_120_tragic_satisfiable :
    exists (regimes : list nat) (admissible : nat -> bool) (cost : nat -> Q),
      CAN_120_Tragic regimes admissible cost.
  Proof.
    exists [0%nat; 1%nat],
           (fun r => if Nat.eqb r 0%nat then false else true),
           (fun r => if Nat.eqb r 0%nat then 0 else 3).
    unfold CAN_120_Tragic.
    apply Forall_cons.
    - left. reflexivity.
    - apply Forall_cons; [right; simpl; lra | apply Forall_nil].
  Qed.

  (* CE-32, Cost-Survival Link: lim_{T->infty} C=infty implies
     lim_{n->infty} ||P_{S_A} M(t'+n)||^2 = 0 — a paper-internal theorem
     about a continuum/infinite limit, NOT independently machine-checked
     here (and not restated on [Q]/[nat] since a faithful discrete
     restatement would require an unbounded-limit apparatus this file
     does not build). Typed as an abstract, Section-discharged [Prop] and
     deliberately left un-proved — tier: Open. *)
  Variable CAN_120_cost_survival_link : Prop.

End CAN_120_MoralCost.
