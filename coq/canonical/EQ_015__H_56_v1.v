(* EQ-015/H.56.v1 -- NEW DERIVATION / PROPOSAL -- not yet in Toledo -- corrigibility loop vs. closure loop: a two-branch finite automaton *)
(* source: "Human Learning as Epistemic Architecture", Zenodo 10.5281/zenodo.22341297 *)
(* candidate report: no structural match; the one lexical hit, weld/S.09.v1
   ("corrigibility predicts durable agency", an empirical hypothesis
   statement), is a sibling theme, not the same object -- a hypothesis is
   not a branching state machine. Cited below only as relates-to. This
   file states the FORM of the candidate: a closed two-state type (the
   two named loops/branches) plus an abstract transition/signal function
   between them, per the EQ_015__M_11_v1.v (CAN211_AugmentationKind) house
   pattern, again re-using its precedent's pairwise-distinctness theorem
   as the one thing a closed two-way Inductive gives for free. *)

Require Import List.
Set Implicit Arguments.

Section EQ_015_H_56_v1_sec.

  (* The two named branches of the automaton. *)
  Inductive EQ_015_H_56_v1_Loop :=
    | EQ_015_H_56_v1_CorrigibilityLoop
    | EQ_015_H_56_v1_ClosureLoop.

  Theorem EQ_015_H_56_v1_loop_pairwise_distinct :
    EQ_015_H_56_v1_CorrigibilityLoop <> EQ_015_H_56_v1_ClosureLoop.
  Proof. discriminate. Qed.

  (* Signal : the input alphabet driving a branch transition (e.g. a
     correction accepted/rejected, a challenge answered/refused); left
     abstract, as the source paper does not fix a closed alphabet. *)
  Variable Signal : Type.

  (* The automaton's abstract transition function, of exactly the arity a
     two-branch finite automaton requires: current loop + signal -> next
     loop. Nothing about which signals move which way is asserted. *)
  Definition EQ_015_H_56_v1_step_type : Type := EQ_015_H_56_v1_Loop -> Signal -> EQ_015_H_56_v1_Loop.
  Variable EQ_015_H_56_v1_step : EQ_015_H_56_v1_step_type.

  (* A finite run of the automaton over a signal trace, starting from a
     given loop -- the direct fold that "a two-branch finite automaton"
     denotes once a transition function and a start state are fixed. *)
  Fixpoint EQ_015_H_56_v1_run
      (start : EQ_015_H_56_v1_Loop) (trace : list Signal) : EQ_015_H_56_v1_Loop :=
    match trace with
    | nil => start
    | s :: rest => EQ_015_H_56_v1_run (EQ_015_H_56_v1_step start s) rest
    end.

  Theorem EQ_015_H_56_v1_run_nil :
    forall start : EQ_015_H_56_v1_Loop, EQ_015_H_56_v1_run start nil = start.
  Proof. intros start; reflexivity. Qed.

End EQ_015_H_56_v1_sec.

Print Assumptions EQ_015_H_56_v1_loop_pairwise_distinct.
Print Assumptions EQ_015_H_56_v1_run_nil.
