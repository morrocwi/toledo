(* A.5/M.12.v1 — CAN-235 — untagged — parents: A.5/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-235 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 3 *)
(** Registry tier: "identity (non-collapse)" despite the source's own
    "=/=>" connective (DVP does not force reaching K2) — formalised, per
    the registry's own classification, as the same notion-distinctness
    shape as every other id in this block. *)
Theorem CAN235_dvp_not_k2 : CAN2xx_DVP <> CAN2xx_K2.
Proof. discriminate. Qed.

