(* weld — root (Layer-0, Genesis id verbatim) — tier: mixed: δ_R⊢L_R is [Th_coqc]; the stepper F and the spine readout are [Dr]; the weld q_D∘F=F♯_D∘q_D is [finite_diagnostic] per registered domain and [Dr]/architecture as a universal theorem — parents: MQ08-stepper — occurrences 4 — 'The one-line master equation (the weld)', formalised as the typed composition of the root-spine segments in MRC_master.v (coq/canonical/_mrc_pre_split/MRC_master.v) *)

From Coq Require Import QArith.
From Coq Require Import ZArith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.

Section MasterEquation.

  Variables StateT Ctrl Ctx Tape Question Observer Val : Type.

  (** CAN-001/CAN-003 segment: the weld-forced stepper. *)
  Variable F : StateT -> Ctrl -> Ctx -> Tape -> StateT.

  (** CAN-201 segment: the root readout gate. *)
  Variable O : StateT -> Question -> Observer -> Val.

  (** The master equation: advance one step, then read the result — the
      typed composition of the two function-shaped spine segments into a
      single object, on one finite model. *)
  Definition master_equation
             (s : StateT) (u : Ctrl) (c : Ctx) (t : Tape) (q : Question) (o : Observer)
    : Val :=
    O (F s u c t) q o.

  (** Th_coqc: [master_equation] genuinely IS the sequential application
      of its two spine segments — stepping with [F] and then reading with
      [O] — not a re-derived or independently-defined shortcut.  This is
      the composition claim made checkable: by construction the two sides
      are definitionally the same finite computation, so the proof is
      exactly [reflexivity], which is itself the honest content of the
      claim (there is no hidden step in between). *)
  Theorem master_equation_is_segment_composition :
    forall (s : StateT) (u : Ctrl) (c : Ctx) (t : Tape) (q : Question) (o : Observer),
      master_equation s u c t q o = O (F s u c t) q o.
  Proof. intros. reflexivity. Qed.

End MasterEquation.
