(* ===================================================================== *)
(*  RDL_SingleHopHierarchy.v                                              *)
(*  Multi-hop = a HIERARCHY of single-hop reads over a KG.                *)
(*                                                                        *)
(*  Carrier: entities/tokens = nodes (nat); a single-hop fact = one edge  *)
(*  E u t.  `hop E k s t` = a depth-k walk s ->...-> t where EACH step    *)
(*  uses exactly ONE edge (one single-hop READ).  This is the discrete    *)
(*  K-step propagation of the spine coupling K·L_R Φ from source J at the  *)
(*  seed s (cf. RDL_SpineGraphEnergy): traversal, not in-weights compose. *)
(*                                                                        *)
(*  We prove the two facts our measurements isolate:                      *)
(*   (1) faithful_reaches : on a faithful chain, depth-k traversal REACHES *)
(*       the answer node n at k=n — single hops COMPOSE into the n-hop     *)
(*       answer with NO parameter, NO in-weights composition.  (clean      *)
(*       graph K=3 -> 0.917, measured.)                                    *)
(*   (2) hole_blocks : delete ONE edge (an IE-dropped bridge fact) and the *)
(*       answer node is UNREACHABLE at ANY depth k — depth cannot          *)
(*       compensate for a missing edge.  (real-text ladder flat across K,  *)
(*       measured.)  => the ONLY lever is EDGE-RECALL.                     *)
(*  All axiom-free (Th_coqc): Print Assumptions at the foot is empty.      *)
(* ===================================================================== *)

Require Import Coq.Arith.Arith.
Require Import Coq.micromega.Lia.

(* a single-hop fact relation between entity nodes *)
Definition Rel := nat -> nat -> Prop.

(* depth-k hierarchy of single-hop reads: each [hopS] consumes ONE edge. *)
Inductive hop (E : Rel) : nat -> nat -> nat -> Prop :=
  | hop0 : forall s, hop E 0 s s
  | hopS : forall k s u t, hop E k s u -> E u t -> hop E (S k) s t.

(* ---- 1. FAITHFUL graph: single hops compose into the multi-hop answer ---- *)
(* the faithful chain: edge i -> i+1 for every i (no fact dropped). *)
Definition chain : Rel := fun i j => j = S i.

Theorem faithful_reaches : forall n, hop chain n 0 n.
Proof.
  induction n as [| n IH].
  - apply hop0.
  - eapply hopS. exact IH. unfold chain. reflexivity.
Qed.

(* ---- 2. HOLEY graph: one dropped edge => answer unreachable at any depth ---- *)
(* chain with the single edge (gap -> gap+1) DELETED — the IE-recall miss. *)
Definition holed (gap : nat) : Rel := fun i j => j = S i /\ i <> gap.

(* nothing past the gap is reachable from a seed at/under the gap, ever. *)
Lemma blocked :
  forall gap k s t, s <= gap -> hop (holed gap) k s t -> t <= gap.
Proof.
  intros gap k s t Hs H. induction H as [s0 | k s0 u t Hk IH Hedge].
  - exact Hs.
  - destruct Hedge as [Ht Hu]. specialize (IH Hs). lia.
Qed.

Theorem hole_blocks : forall gap k, ~ hop (holed gap) k 0 (S gap).
Proof.
  intros gap k H. assert (S gap <= gap) as Hbad.
  { eapply blocked. 2: exact H. lia. }
  lia.
Qed.

(* COROLLARY (the engineering verdict): on a faithful graph depth k=n solves
   the n-hop question (faithful_reaches); a single missing edge makes it
   unsolvable at EVERY depth (hole_blocks).  Therefore scaling hop-depth K is
   NOT the lever on real text (the graph is holey) — EDGE-RECALL is.  This is
   exactly the measured split: clean-graph ladder K=3 -> 0.917 vs real-text
   ladder flat at ~0.33 across K. readout-not-truth. *)

Print Assumptions faithful_reaches.
Print Assumptions hole_blocks.
