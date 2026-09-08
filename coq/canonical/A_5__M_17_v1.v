(* A.5/M.17.v1 — CAN-240 — untagged — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-240 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: untagged — occurrences: 1 *)
Theorem CAN240_correspondence_not_peer_review :
  CAN2xx_Correspondence <> CAN2xx_PeerReview.
Proof. discriminate. Qed.

