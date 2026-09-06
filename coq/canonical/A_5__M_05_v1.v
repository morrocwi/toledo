(* A.5/M.05.v1 — CAN-214 — Definition — parents: A.5/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-214 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Definition / Th_coqc — occurrences: 3 *)
(** Ess(d) as a finite intersection (fold) over the declared dependency
    paths' vertex sets; the misrouted-defeat corollary — if the actual and
    represented essential sets differ at some node, the two sets are
    themselves unequal — is exactly the general fact "a witnessed
    asymmetric membership forces list inequality", proved once and
    generically. *)
Section CAN214_EssentialDependency.
  Variable Vertex : Type.
  Variable vertex_dec : forall a b : Vertex, {a = b} + {a <> b}.

  Definition CAN214_intersect (l1 l2 : list Vertex) : list Vertex :=
    filter (fun v => if in_dec vertex_dec v l2 then true else false) l1.

  Definition CAN214_Ess (default : list Vertex) (paths_V : list (list Vertex)) : list Vertex :=
    fold_right CAN214_intersect default paths_V.

  Theorem CAN214_misrouted_defeat :
    forall (Ess Ess_hat : list Vertex) (v : Vertex),
      In v Ess -> ~ In v Ess_hat -> Ess <> Ess_hat.
  Proof. intros Ess Ess_hat v Hin Hnin Heq. subst. contradiction. Qed.
End CAN214_EssentialDependency.

(* ==================================================================== *)
(** ** Group 4 — the worked base-rate audit and the retained-record
    contamination route (CAN-215, CAN-216) *)

