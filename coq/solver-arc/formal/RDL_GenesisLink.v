(* ===================================================================== *)
(*  RDL_GenesisLink.v                                                     *)
(*  M2 (integration) + CG-05A (readout direction), both AXIOM-FREE.        *)
(*                                                                        *)
(*  M2 — bundle the whole machine-checked cosmogenesis chain into ONE      *)
(*  reachable theorem: `genesis_chain_realized` states that RD's object    *)
(*  system D is a concrete MODEL in which every genesis-order edge holds   *)
(*  (δ_R · asymmetry · temporal order · seed · discrete tick · atomic      *)
(*  floor · causal order). One object a reader can Require and cite.        *)
(*                                                                        *)
(*  CG-05A — the READOUT DIRECTION, formalized axiom-free: a readout map    *)
(*  can be MANY-TO-ONE (lossy), so `accessibility ≠ existence` — the        *)
(*  structural backbone of readout-not-truth and of mass is a (lossy)     *)
(*  READOUT of τ_c. (The physical content m = ħ/(2c²τ_c) stays Dr.)        *)
(*                                                                        *)
(*  NOTE on linking to Genesis_PhysicsDAG_Canon_v2_4_0.v: that file is an   *)
(*  ABSTRACT physics DAG over Parameter types C/Ket/Op/etc. -- a            *)
(*  separate layer that shares no type with RD concrete D. A type-level     *)
(*  import would NOT connect them; giving its abstract Parameters a         *)
(*  concrete RD construction is the (much larger) physics-derivation task,  *)
(*  NOT a quick win. So the link here is the concrete MODEL below; the      *)
(*  abstract-canon bridge stays an explicit open item.                     *)
(* ===================================================================== *)

Require Import RD.
Require Import PeanoNat.
Require Import RDL_Distinguishability.
Require Import RDL_CausalOrder.

(* ---- M2: the whole cosmogenesis chain, realized in RD, as one object ---- *)
Theorem genesis_chain_realized :
     (exists a b : D, Distinguishable a b)                                       (* δ_R realized *)
  /\ (forall a b : D, Distinguishable a b ->
        (lt a b /\ ~ lt b a) \/ (lt b a /\ ~ lt a b))                            (* asymmetry *)
  /\ well_founded lt                                                              (* temporal order *)
  /\ (exists t : D, t <> zero)                                                    (* nonzero seed (τ tick) *)
  /\ (forall x : D, lt x (succ x))                                                (* discrete clock tick *)
  /\ (forall x : D, ~ (exists z : D, lt x z /\ lt z (succ x)))                    (* atomic / discrete floor *)
  /\ (forall a b : D, prec a b -> ~ prec b a).                                    (* causal order asymmetric *)
Proof.
  split. exact primordial_difference_exists.
  split. exact distinguishable_implies_asymmetry.
  split. exact temporal_ordering_well_founded.
  split. exact nonzero_seed_exists.
  split. exact discrete_clock_tick.
  split. exact atomicity.
  exact prec_asymm.
Qed.

(* ---- CG-05A: the readout direction is LOSSY (many-to-one), axiom-free ---- *)
(*  A readout map (here: parity of the index) collapses distinct retained
    differences to the same value. So from a readout you CANNOT in general
    recover the primitive: accessibility ≠ existence. This is the formal
    floor under mass is a readout of τ_c (the readout loses information;
    energy can only be back-defined). *)
Definition readout (x : D) : bool := Nat.even (toNat x).

Theorem readout_is_lossy :
  exists a b : D, a <> b /\ readout a = readout b.
Proof.
  exists zero, (succ (succ zero)). split.
  - intro H. discriminate H.
  - unfold readout. simpl. reflexivity.
Qed.

(* Corollary: knowing a readout value does NOT pin down the primitive
   (existence of two distinct preimages) — accessibility ≠ existence. *)
Corollary accessibility_neq_existence :
  exists a b : D, a <> b /\ readout a = readout b.
Proof. exact readout_is_lossy. Qed.
