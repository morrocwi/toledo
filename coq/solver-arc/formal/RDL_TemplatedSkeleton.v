(* ===================================================================== *)
(*  RDL_TemplatedSkeleton.v                                               *)
(*  The STRUCTURAL core of the spectral-skeleton oracle map: a knowledge  *)
(*  graph whose compositional structure is a small MOTIF repeated across  *)
(*  many "domains" (+ cross-domain bridges) has all its reachability       *)
(*  certified by the SMALL skeleton — the motif + the bridges — NOT by the *)
(*  full node set.  This is the combinatorial analog of "low-rank L_R":    *)
(*  the numerical spectral truncation (verified empirically in            *)
(*  exp_spectral_skeleton_theory.py: structured elbow 5% vs random 54%) is *)
(*  its linear-algebra realisation; here we certify the structure itself.  *)
(*                                                                        *)
(*  Node = (domain, position).  Edge = a same-domain MOTIF edge OR an      *)
(*  explicit cross-domain BRIDGE.  We prove:                              *)
(*   1. skeleton_sufficient : motif-reachability i⇝j lifts to EVERY domain *)
(*      d — the one small motif certifies intra-domain reach for all N      *)
(*      nodes (this is the minimum-parameter win: store the motif, not the *)
(*      per-node graph).                                                    *)
(*   2. no_bridge_isolates  : with NO bridges, reach never leaves its       *)
(*      domain — cross-domain answers REQUIRE a bridge (the high-meaning-   *)
(*      density edges).  The hole_blocks analog for the cross-domain axis.  *)
(*  All axiom-free (Th_coqc): Print Assumptions is empty at the foot.       *)
(* ===================================================================== *)

Require Import Coq.Arith.Arith.

Definition node := (nat * nat)%type.          (* (domain, motif-position) *)

(* motif-internal reachability over positions (the small skeleton) *)
Inductive mreach (mr : nat -> nat -> Prop) : nat -> nat -> Prop :=
  | mr0 : forall i, mreach mr i i
  | mrS : forall i j k, mreach mr i j -> mr j k -> mreach mr i k.

(* the full templated graph: a same-domain motif edge, OR a cross-domain bridge *)
Definition E (mr : nat -> nat -> Prop) (br : node -> node -> Prop) (n m : node) : Prop :=
  (fst n = fst m /\ mr (snd n) (snd m)) \/ br n m.

(* reachability in the full graph *)
Inductive reach (Ed : node -> node -> Prop) : node -> node -> Prop :=
  | reach0 : forall n, reach Ed n n
  | reachS : forall a b c, reach Ed a b -> Ed b c -> reach Ed a c.

(* ---- 1. the SMALL motif certifies intra-domain reach in EVERY domain ---- *)
Theorem skeleton_sufficient :
  forall (mr : nat -> nat -> Prop) (br : node -> node -> Prop) (d i j : nat),
    mreach mr i j -> reach (E mr br) (d, i) (d, j).
Proof.
  intros mr br d i j H. induction H as [i | i j k Hij IH Hjk].
  - apply reach0.
  - eapply reachS. exact IH. left. simpl. split. reflexivity. exact Hjk.
Qed.

(* ---- 2. with no bridges, reachability stays inside its domain ---- *)
Definition no_bridge : node -> node -> Prop := fun _ _ => False.

Lemma domain_preserved :
  forall (mr : nat -> nat -> Prop) (a m : node),
    reach (E mr no_bridge) a m -> fst m = fst a.
Proof.
  intros mr a m H. induction H as [n | a b c Hab IH Hbc].
  - reflexivity.
  - destruct Hbc as [[Hfst _] | Hbot].
    + rewrite <- Hfst. exact IH.
    + destruct Hbot.
Qed.

Theorem no_bridge_isolates :
  forall (mr : nat -> nat -> Prop) (d1 i d2 j : nat),
    reach (E mr no_bridge) (d1, i) (d2, j) -> d1 = d2.
Proof.
  intros mr d1 i d2 j H.
  apply domain_preserved in H. simpl in H. symmetry. exact H.
Qed.

(* COROLLARY (the minimum-parameter map): all reachability of a D-domain templated
   graph is decided by the skeleton = (one motif on M positions) + (the bridge set).
   Intra-domain reach is the SAME motif everywhere (skeleton_sufficient); cross-domain
   reach exists only through bridges (no_bridge_isolates).  So the map you must STORE is
   the motif + bridges (size ~ M + #bridges), NOT the full N = D·M graph — the structural
   certificate that a small skeleton suffices. readout-not-truth: this certifies the
   STRUCTURE; the numerical rank-K elbow is measured, not proven. *)

Print Assumptions skeleton_sufficient.
Print Assumptions no_bridge_isolates.
