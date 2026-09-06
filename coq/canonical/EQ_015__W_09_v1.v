(* EQ-015/W.09.v1 — CAN-149 — Definition — parents: EQ-015/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-149 — relational-class-position

    (* CAN-149 — root: C_{i,t} = <O,G,Gamma,A^access,X,D,R^rent> — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(30), record 22481924) — freshly formalised. A typed
    7-tuple record over abstractly-declared coordinate types — a stable
    class position requires persistent clustering across all seven, not
    one observation, per the source's own reading; the clustering claim
    itself is prose, not restated as a further Coq obligation here. *)

Section CAN_149_RelationalClassPosition.

  Variables Ownership GateControl Claim2 Access2 Exit2 Dependency2 Rent2 : Type.

  Record RelationalClassPosition : Type := mkRelationalClassPosition
    { rcp_O : Ownership
    ; rcp_G : GateControl
    ; rcp_Gamma : Claim2
    ; rcp_A : Access2
    ; rcp_X : Exit2
    ; rcp_D : Dependency2
    ; rcp_R : Rent2
    }.

  Definition CAN_149_RelationalClassPosition := RelationalClassPosition.
  Definition CAN_149_mk_relational_class_position := mkRelationalClassPosition.

End CAN_149_RelationalClassPosition.

