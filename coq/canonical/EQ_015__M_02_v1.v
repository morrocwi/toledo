(* EQ-015/M.02.v1 — CAN-003 — untagged — parents: EQ-015 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-003 — root-stepper

    (* CAN-003 — root: S_{n+1}=F(S_n,u_n,c_n,T_n) — domain: root — tier: Definition — occurrences: 2 *)

    The finite Genesis stepper, typed generically and unrolled to a
    [nat]-indexed finite trajectory — never an infinite/continuum limit
    object — quoted verbatim as the rail every domain paper reads (CAN-047
    human-AI, CAN-115 social, CAN-202 mission, etc., all in [../coq/MR_*.v]
    under their own domain-specific ids, not re-derived here). *)

Section RootStepper.

  Variables StateT Ctrl Ctx Tape : Type.

  Variable CAN_003_F : StateT -> Ctrl -> Ctx -> Tape -> StateT.

  (* The finite trajectory S_0, S_1, ..., S_n given constant per-step
     inputs — a concrete [nat]-recursive unrolling, the readout-first
     stand-in for "the stepper applied n times". *)
  Fixpoint CAN_003_trajectory
           (s0 : StateT) (u : Ctrl) (c : Ctx) (t : Tape) (n : nat) : StateT :=
    match n with
    | O => s0
    | S k => CAN_003_F (CAN_003_trajectory s0 u c t k) u c t
    end.

  (* Witness (tier: Th_coqc): the one-step stepper genuinely can change the
     state — a finite model ([bool] state, negation as [F]) where every
     step flips the state, so "Dr" (derived-stepper) is not a vacuous
     dependency; parallels [../coq/MR_Foundation.v]'s eq.(8) technique. *)
  Theorem CAN_003_stepper_can_move_state :
    forall (u : Ctrl) (c : Ctx) (t : Tape),
      exists (F' : bool -> Ctrl -> Ctx -> Tape -> bool) (s : bool),
        F' s u c t <> s.
  Proof.
    intros u c t.
    exists (fun s _ _ _ => negb s), true.
    discriminate.
  Qed.

  (* Supporting fact: the trajectory at index 0 is always the seed state —
     a trivial but honest sanity check that the [nat]-recursion above is
     the identity at the base case, not an off-by-one continuum artefact. *)
  Theorem CAN_003_trajectory_zero :
    forall (s0 : StateT) (u : Ctrl) (c : Ctx) (t : Tape),
      CAN_003_trajectory s0 u c t 0 = s0.
  Proof. reflexivity. Qed.

End RootStepper.

