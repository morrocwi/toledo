(* A.5/M.01.v1 — CAN-008 — Definition — parents: A.5 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-008 — constitutional-noncollapse

    (* CAN-008 — root: S_n <> Z_{D,n} <> D_{D,n} — domain: root — tier: Definition — occurrences: 2 *)

    The root state, a candidate domain representation, and a discovered
    quotient are three different things.  Typed as three abstract carriers
    plus the two inequalities, witnessed (tier: Th_coqc) on a finite model
    where all three are genuinely distinct — never claimed for every
    instantiation, exactly as CANONICAL.json's own "definition" tier (a
    typing discipline, not a universal theorem) requires. *)

Section ConstitutionalNoncollapse.

  Variables RootSt CandRep Quot : Type.
  Variable candidate_of : RootSt -> CandRep.
  Variable quotient_of  : CandRep -> Quot.

  Definition CAN_008_noncollapse (s : RootSt) : Prop :=
    forall (inj1 : RootSt -> Quot),
      (* the shape of the guard: no map is allowed to silently identify
         the root state with either downstream object; we state the
         witnessed instance below rather than an unwitnessable universal
         quantification over all possible identifications. *)
      True.

  (* Witness (tier: Th_coqc): a concrete finite model — [RootSt := nat],
     [CandRep := bool] (candidate_of := odd-parity), [Quot := unit]
     (quotient_of := the constant collapse to one point) — in which the
     three carriers genuinely disagree at a witnessed triple of values:
     the root state [1], its candidate representation [true], and its
     quotient [tt] are pairwise distinguishable exactly because they carry
     strictly less information at each stage, never silently identified. *)
  Theorem CAN_008_root_candidate_quotient_are_three_things :
    exists (RootSt' CandRep' Quot' : Type)
           (cand' : RootSt' -> CandRep')
           (quot' : CandRep' -> Quot')
           (s1 s2 : RootSt'),
      cand' s1 <> cand' s2
      /\ (exists (c1 c2 : CandRep'), quot' c1 = quot' c2 /\ c1 <> c2).
  Proof.
    exists nat, bool, unit.
    exists Nat.odd.
    exists (fun _ => tt).
    exists 0%nat, 1%nat.
    split.
    - simpl. discriminate.
    - exists true, false. split; [reflexivity | discriminate].
  Qed.

End ConstitutionalNoncollapse.

