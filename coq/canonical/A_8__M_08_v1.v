(* A.8/M.08.v1 — CAN-181 — finite_diagnostic — parents: A.8/M.01.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-181 — root: historical-invariance (CAN-009) — domain: method —
   tier: Th_coqc / Definition — occurrences: 4 *)
(** Lambda = min over the named bottleneck rates, instantiating shared
    device 2 ([mr_qmin_fold]): a genuine lower-bound theorem, dualising
    [MR_Live.v]'s [p_star_upper_bound]. The cube-root aggregator [V_c] is
    left as an abstract Section operation (never [Coq.Reals]' real cube
    root); [D_e] and the velocity constraint are typed Definitions, not
    proved (the source states them as governance heuristics, not
    theorems). *)
Definition CAN181_Lambda (l : list Q) (d : Q) : Q := mr_qmin_fold l d.
Definition CAN181_Lambda_le_each := mr_qmin_fold_le.

Section CAN181_Extra.
  Variables H_bn L_bn T_bn A_bn : Q.
  Variable cbrt181 : Q -> Q.
  Definition CAN181_Vc : Q := cbrt181 (H_bn * L_bn * T_bn).
  Definition CAN181_De : Q := A_bn * (1 - CAN181_Vc).
  Variables PublicOutputVelocity VerificationCapacity : Q.
  Definition CAN181_velocity_constraint : Prop := PublicOutputVelocity <= VerificationCapacity.
End CAN181_Extra.

(* ==================================================================== *)
(** ** Group 6 — the DVP protocol, programme legibility, recognition
    conversion, and credit-velocity governance (CAN-182..185) *)

