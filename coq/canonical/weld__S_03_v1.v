(* weld/S.03.v1 — CAN-120 — Definition — parents: weld/M.02.v1 — occurrences 12 *)

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

(* ==================================================================== *)
(** ** CAN-120 — B-SOC-MORALCOST

    (* CAN-120 — root: C_{A,R}[t1,t2]:=sum(alpha*Vplus+beta*chi_causal+gamma*chi_spec); choice-gate; Tragic — domain: social — tier: Definition — occurrences: 12 *)

    CANONICAL.json tier: "definition (...); theorem [paper-internal, not
    Coq-verified] (CE-32)". Discrete replacement: the moral-cost integral
    over $[t_1,t_2]$ becomes a finite [fold_right Qplus] over
    [List.seq t1 (t2-t1)] — a genuinely finite sum, never a continuum
    integral. The Cost-Survival Link (CE-32, an infinite-limit theorem) is
    the paper's own result, not independently machine-checked here, so it
    is typed as an abstract Open [Prop] and left un-proved. *)

Section CAN_120_MoralCost.

  Variable Vplus : nat -> Q.       (* per-tick worsening-load indicator, >= 0 *)
  Variable chi_causal chi_spec : Q. (* per-regime causal-memory / spectral violation indicators *)
  Variable alpha beta gamma : Q.
  Hypothesis Halpha : alpha > 0.
  Hypothesis Hbeta  : beta  > 0.
  Hypothesis Hgamma : gamma > 0.

  Definition CAN_120_moral_cost (t1 t2 : nat) : Q :=
    fold_right Qplus 0
      (map (fun _ => alpha * Vplus t1 + beta * chi_causal + gamma * chi_spec)
           (List.seq t1 (t2 - t1))).

  Definition CAN_120_Responsibility (t1 t2 : nat) : Q := CAN_120_moral_cost t1 t2.

  (* Choice-gate: with no instantiated choice of regime, no ethics,
     responsibility, or cost may be attributed at all. *)
  Definition CAN_120_choice_gate (has_choice : bool) (t1 t2 : nat) (attributed_cost : Q) : Prop :=
    has_choice = false -> attributed_cost = 0.

  (* Witness (tier: Th_coqc): the choice-gate is satisfiable both ways —
     an instance where it correctly fires (no choice, zero cost) and an
     instance where a genuine choice permits a non-zero attributed cost. *)
  Theorem CAN_120_choice_gate_satisfiable :
    CAN_120_choice_gate false 0%nat 0%nat 0
    /\ exists (has_choice : bool) (t1 t2 : nat) (c : Q),
         has_choice = true /\ c = 5 /\ CAN_120_choice_gate has_choice t1 t2 c.
  Proof.
    split.
    - unfold CAN_120_choice_gate. intro H. reflexivity.
    - exists true, 0%nat, 1%nat, 5. repeat split. unfold CAN_120_choice_gate. discriminate.
  Qed.

  (* Tragic regime class: every regime in a declared finite list is either
     inadmissible or incurs strictly positive unavoidable cost. *)
  Definition CAN_120_Tragic
             (regimes : list nat) (admissible : nat -> bool) (cost : nat -> Q) : Prop :=
    Forall (fun r => admissible r = false \/ cost r > 0) regimes.

  (* Witness (tier: Th_coqc): Tragic is satisfiable on a finite two-regime
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

