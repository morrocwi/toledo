(* EQ-002/M.03.v1 — CAN-201 — Definition — parents: EQ-002 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-201 — root-readout-gate

    (* CAN-201 — root: Readout_{Q,O,c}(S)=z, z<>S — domain: root — tier: Definition — occurrences: 1 *)

    A bounded, reader/operator-conditioned map that never returns the
    source unchanged.  Typed exactly as MR_WorldSystem.v's eq.(52) reading
    of this same root gate (After Labour eq. 2), but under its own CAN-201
    identifier and its own discharged [Hypothesis] — this file does not
    [Require] [MR_WorldSystem] since CAN-201 is not itself a Master River
    equation. *)

Section RootReadoutGate.

  Variables StateT Question Observer Ctx : Type.

  Variable CAN_201_readout : StateT -> Question -> Observer -> Ctx -> StateT.

  Hypothesis CAN_201_readout_ne_state :
    forall (s : StateT) (q : Question) (o : Observer) (c : Ctx),
      CAN_201_readout s q o c <> s.

  (* Witness (tier: Th_coqc): the discharged non-identity hypothesis above
     is satisfiable — a concrete non-identity readout exists on the
     smallest possible finite state space — so the gate is not a vacuous
     requirement. *)
  Remark CAN_201_hypothesis_satisfiable_on_bool :
    exists (readout' : bool -> unit -> unit -> unit -> bool),
      forall (s : bool) (q o c : unit), readout' s q o c <> s.
  Proof.
    exists (fun s _ _ _ => negb s).
    intros [] [] [] []; simpl; discriminate.
  Qed.

End RootReadoutGate.

