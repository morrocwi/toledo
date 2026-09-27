(* ===================================================================== *)
(*  PROP_FLOOD_06_outlet_coping_tier.v                                   *)
(*  Area-generic outlet-headroom / drainage-coping tier-ladder function   *)
(*  (Toledo proposal PROP-FLOOD-06, code weld/M.??.v1).                   *)
(*                                                                         *)
(*  Source: FloodConnect readout application; founder instructions         *)
(*  2026-09-27 (coping indicator generalised to any drainage unit U,       *)
(*  then to a >=5-level tier ladder combining severity (S_H) and urgency   *)
(*  (T_act), then to (lat,lon)-resolved units).                            *)
(*                                                                         *)
(*  Scope of THIS file: only the pure numeric tier function over Q        *)
(*  (the two retained readouts S_H and T_act, once already computed and   *)
(*  present) is formalised here -- proved TOTAL (a plain Gallina function *)
(*  is total by construction) and DECIDABLE (every comparison is decided   *)
(*  by Qle_bool, a computable boolean predicate on Q, per QArith's own     *)
(*  Qle_bool_iff). The refusal-code precedence (UNIT_NOT_DECLARED,         *)
(*  MISSING_INPUT, ..., LR dominance), the unit-resolution graph walk      *)
(*  (lat,lon -> U), and the L5 "system already exhausted" pre-check are    *)
(*  NOT formalised here -- they are graph/IO-shaped, not arithmetic, and   *)
(*  remain OPEN per this proposal's own honest_caveats. This file proves   *)
(*  nothing about real hydrology; it proves only that the declared         *)
(*  numeric ladder is a total, decidable function of its two Q inputs.     *)
(* ===================================================================== *)

Require Import QArith.
Require Import Coq.Bool.Bool.

(* ----------------------------------------------------------------------
   The five numeric levels L0..L4 (severity/urgency bands only). L5 and
   LR are declared OUT OF SCOPE of this pure function -- see header.
   ---------------------------------------------------------------------- *)
Inductive tier_level : Set := L0 | L1 | L2 | L3 | L4.

Definition level_to_nat (l : tier_level) : nat :=
  match l with
  | L0 => 0%nat | L1 => 1%nat | L2 => 2%nat | L3 => 3%nat | L4 => 4%nat
  end.

Definition nat_to_level (n : nat) : tier_level :=
  match n with
  | 0%nat => L0 | 1%nat => L1 | 2%nat => L2 | 3%nat => L3 | _ => L4
  end.

(* ----------------------------------------------------------------------
   Severity band on S_H(U) : Q, thresholds 3/10, 6/10, 9/10, 12/10.
   OPEN-for-founder-tuning per the proposal's honest_caveats -- these
   four constants are exactly the declared, not derived, boundaries.
   ---------------------------------------------------------------------- *)
Definition s_band (s : Q) : tier_level :=
  if Qle_bool s (3 # 10)%Q then L0
  else if Qle_bool s (6 # 10)%Q then L1
  else if Qle_bool s (9 # 10)%Q then L2
  else if Qle_bool s (12 # 10)%Q then L3
  else L4.

(* ----------------------------------------------------------------------
   Urgency band on T_act(U). T_act is represented as `option Q`:
     Some t  -- the crossing hour, t : Q, t >= 0
     None    -- the declared ">H" outcome (no crossing within horizon),
                a determinate non-refused result, NOT a missing value.
   Thresholds 6, 24, 48 hours, also OPEN-for-founder-tuning.
   ---------------------------------------------------------------------- *)
Definition t_band (t : option Q) : tier_level :=
  match t with
  | None => L0
  | Some tq =>
      if Qle_bool tq (6 # 1)%Q then L4
      else if Qle_bool tq (24 # 1)%Q then L3
      else if Qle_bool tq (48 # 1)%Q then L2
      else L1
  end.

Definition max_level (a b : tier_level) : tier_level :=
  nat_to_level (Nat.max (level_to_nat a) (level_to_nat b)).

(* The combined numeric tier: "the higher of the two sub-readouts
   governs", per the proposal statement -- both bands are still
   reported separately by the caller; this is only the governing level. *)
Definition combined_tier (s : Q) (t : option Q) : tier_level :=
  max_level (s_band s) (t_band t).

(* ----------------------------------------------------------------------
   TOTALITY: combined_tier is an ordinary Gallina function, defined on
   every (s, t) : Q * option Q with no partial match arm -- total by
   construction. Stated explicitly as a lemma for the registry record.
   ---------------------------------------------------------------------- *)
Theorem combined_tier_total :
  forall (s : Q) (t : option Q), exists l : tier_level, combined_tier s t = l.
Proof.
  intros s t. exists (combined_tier s t). reflexivity.
Qed.

(* ----------------------------------------------------------------------
   DECIDABILITY: tier_level has decidable equality (a finite enumerated
   type), and every band boundary is decided by the computable Qle_bool,
   whose correctness against the Prop-level Qle is QArith's own
   Qle_bool_iff. Both witnessed here explicitly.
   ---------------------------------------------------------------------- *)
Theorem tier_level_eq_dec : forall x y : tier_level, {x = y} + {x <> y}.
Proof. decide equality. Qed.

Theorem s_band_reflects_Qle_bool :
  forall s : Q,
    s_band s = L0 <-> Qle_bool s (3 # 10)%Q = true.
Proof.
  intro s. unfold s_band. destruct (Qle_bool s (3 # 10)%Q) eqn:H0.
  - split; intro; [reflexivity | reflexivity].
  - destruct (Qle_bool s (6 # 10)%Q) eqn:H1;
    destruct (Qle_bool s (9 # 10)%Q) eqn:H2;
    destruct (Qle_bool s (12 # 10)%Q) eqn:H3;
    split; intro Hc; try discriminate; try congruence.
Qed.

(* Sanity check: the boundary itself (S_H = 3/10) lands in L0 (<=, not <),
   matching the proposal's declared closed-lower-band convention. *)
Example boundary_lands_L0 : s_band (3 # 10)%Q = L0.
Proof. reflexivity. Qed.

Example none_urgency_is_L0 : t_band None = L0.
Proof. reflexivity. Qed.

Example six_hours_is_L4 : t_band (Some (6 # 1)%Q) = L4.
Proof. reflexivity. Qed.

(* Governing level takes the higher of a mild severity and an urgent
   T_act: L1-severity but 4h-to-exhaustion must still report L4. *)
Example urgency_can_dominate_severity :
  combined_tier (2 # 10)%Q (Some (4 # 1)%Q) = L4.
Proof. reflexivity. Qed.

(* ----------------------------------------------------------------------
   WHAT THIS FILE DOES NOT PROVE (see header): the refusal-code
   precedence order, the (lat,lon) unit-resolution graph walk, the L5
   "system already exhausted" pre-check, and any claim that the declared
   thresholds correctly predict real flooding (see the proposal's own
   falsifier). This file's only claim is: given S_H, T_act already
   computed as Q values, the tier readout is a total, decidable function
   of them.
   ---------------------------------------------------------------------- *)
