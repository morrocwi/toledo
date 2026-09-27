(* ===================================================================== *)
(*  PROP_FLOOD_06_outlet_coping_tier.v                                   *)
(*  Area-generic outlet-headroom / drainage-coping tier-ladder function   *)
(*  (Toledo proposal PROP-FLOOD-06.v5, code weld/M.??.v1, proposals-lane, *)
(*  not yet canonicalized -- see registry/LINEAGE.jsonl code PROP-FLOOD-06)*)
(*                                                                         *)
(*  v5 AMENDMENT (per founder instruction 2026-09-27, "ถึงจะแม่นยำและ      *)
(*  ใช้ได้กับทุกสถานที่", and thailand_flood_kg's second falsifier         *)
(*  backtest BACKTEST_PROP_FLOOD_06_v1.md): three LEADING coverage        *)
(*  components (upstream_rise_rate/basin_rain_accum/forecast_rain_72h),   *)
(*  a lead_time_h field (PROP-FLOOD-02 reused a second time, shifted by a *)
(*  declared travel time tau_up), a per-unit calibration procedure, and a *)
(*  hysteresis/persistence rule -- see the v5 section at the bottom of    *)
(*  this file. `coverage_vector_v5`/`readout_v5` EXTEND (embed) v4's      *)
(*  `coverage_vector`/`readout` by wrapping, never modifying: every v1-v4 *)
(*  type, definition and theorem above this file's v5 section is         *)
(*  UNCHANGED and still holds exactly as before.                         *)
(*                                                                         *)
(*  v4 AMENDMENT (per independent review round 2, REVIEW_PROP_FLOOD_06_r2 *)
(*  .md, both MUST-FIX findings): (1) promoters are now a FLOOR under      *)
(*  every mode -- FULL mode no longer ignores the promoter table, so a    *)
(*  fully-resolved ledger can never report a lower tier than the PARTIAL   *)
(*  reading the same promoter inputs would give (see `full_tier_v4`,      *)
(*  `full_tier_v4_promoter_monotone`, `full_tier_v4_full_ge_partial` at    *)
(*  the bottom of this file); (2) the top-level return type is now a      *)
(*  single inseparable `readout` record (tier, mode, coverage, based_on,  *)
(*  missing, promoters_fired), not a bare `tier_level6` a consumer could   *)
(*  drop everything else from.                                            *)
(*                                                                         *)
(*  Source: FloodConnect readout application; founder instructions         *)
(*  2026-09-27 (coping indicator generalised to any drainage unit U,       *)
(*  then to a >=5-level tier ladder combining severity (S_H) and urgency   *)
(*  (T_act), then to (lat,lon)-resolved units). Amended per independent    *)
(*  review (REVIEW_PROP_FLOOD_06.md, blocking findings 2 and 3):           *)
(*    (2) s_band boundary values now land in the UPPER band (0.3/0.6/0.9/  *)
(*        1.2 are closed-lower for L1/L2/L3/L4 respectively), matching     *)
(*        the JSON/MD's declared convention exactly, not the inverse.      *)
(*    (3) the former ambiguity between the 'S_H:=0, OK' case and the L5    *)
(*        pre-check when min(D_H,R_H)=0 is now resolved by an explicit     *)
(*        total function `full_tier` over (refused, D_H, R_H, F_H, S_H,    *)
(*        T_act): L5's zero-capacity disjunct is conditioned on F_H > 0    *)
(*        (this absorbs the former ZERO_CAPACITY_NONZERO_INFLOW refusal    *)
(*        code -- it is now the L5 tier, never a refusal); the case        *)
(*        min(D_H,R_H)=0 AND F_H=0 falls through to the ordinary band      *)
(*        rule, where the caller is required to have set S_H:=0 for that   *)
(*        case (JSON `definitions.S_H(U)`), landing it in L0.              *)
(*                                                                         *)
(*  v3 AMENDMENT (founder ruling 2026-09-27, verbatim: "ทำทั้งหมดให้ระดับโลก *)
(*  แต่พอใช้ได้แม้ข้อมูลไม่ครบ ... ขอแค่ข้อมูลจริงแม้เล็กที่สุดในบางสถานการณ์  *)
(*  ก็ยังดี", plus the thailand_flood_kg falsifier backtest which found a    *)
(*  no-pump contradiction: RELAYED, read-only, this repo does not own that *)
(*  data). Two further total functions are added below, reusing the        *)
(*  existing `tier_level6` type (LR still dominates) plus an explicit      *)
(*  `mode`-selecting top-level function:                                   *)
(*    - `c_h` : the total case split fixing min(D_H,R_H)'s no-pump         *)
(*      contradiction (JSON `definitions.C_H(U)`): NO_PUMPS_IN_UNIT => R_H;*)
(*      pumps declared but no known outlet capacity => D_H (PARTIAL flag,  *)
(*      represented here by the `terms` output, not by refusing); both     *)
(*      known => min(D_H,R_H), identical to v1/v2.                         *)
(*    - `promoter_max` / `full_tier_v3` : PARTIAL mode -- a total max over  *)
(*      a finite, explicit list of boolean promoter triggers (the pure     *)
(*      numeric shape of JSON `readout_classes.promoter_table`), each       *)
(*      gated by its own `avail : bool` (whether its required coverage-    *)
(*      vector component is present) so an absent input is excluded from   *)
(*      the max rather than contributing a false negative.                 *)
(*  NOT formalised here (same as v2, unchanged scope): refusal-code         *)
(*  precedence, the (lat,lon) graph walk, the 'gauged level above          *)
(*  threshold' L5 disjunct, and the coverage-vector's own staleness-window  *)
(*  IO logic (cov component present/stale/absent is taken here as an       *)
(*  already-computed opaque `bool` "is this promoter's input available").  *)
(*                                                                         *)
(*  Scope of THIS file: the pure numeric tier function over Q (the two     *)
(*  retained readouts S_H and T_act, once already computed, plus the       *)
(*  refused flag and the raw D_H/R_H/F_H volumes needed for the L5 pre-    *)
(*  check) is formalised here -- proved TOTAL (a plain Gallina function    *)
(*  is total by construction) and DECIDABLE (every comparison is decided   *)
(*  by Qle_bool/Qeq_bool, computable boolean predicates on Q, per QArith's  *)
(*  own Qle_bool_iff/Qeq_bool_iff). NOT formalised here: the refusal-code    *)
(*  precedence order among UNIT_NOT_DECLARED/MISSING_INPUT/etc (the        *)
(*  `refused` flag here is an opaque input, not derived from those codes), *)
(*  the unit-resolution graph walk (lat,lon -> U), and the 'gauged level    *)
(*  already above threshold' disjunct of L5 (IO-shaped, not arithmetic).   *)
(*  This file proves nothing about real hydrology; it proves only that     *)
(*  the declared numeric ladder is a total, decidable function of its      *)
(*  declared Q/bool inputs.                                                *)
(* ===================================================================== *)

Require Import QArith.
Require Import Coq.QArith.Qminmax.
Require Import Coq.Bool.Bool.

(* ----------------------------------------------------------------------
   Strict less-than as a computable boolean, since QArith's stdlib gives
   Qle_bool but not Qlt_bool directly: a < b  <->  not (b <= a).
   ---------------------------------------------------------------------- *)
Definition Qlt_bool (a b : Q) : bool := negb (Qle_bool b a).

Lemma Qlt_bool_iff : forall a b : Q, Qlt_bool a b = true <-> (a < b)%Q.
Proof.
  intros a b. unfold Qlt_bool.
  rewrite negb_true_iff.
  rewrite <- not_true_iff_false.
  rewrite Qle_bool_iff.
  split.
  - intro H. apply Qnot_le_lt. intro Hle. apply H. exact Hle.
  - intros H Hle. apply Qle_not_lt in Hle. contradiction.
Qed.

(* ----------------------------------------------------------------------
   The five numeric levels L0..L4 (severity/urgency bands only). L5 and
   LR are declared OUT OF SCOPE of this pure sub-function -- see
   `tier_level6`/`full_tier` below, which lift into the complete ladder.
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
   Declared convention (JSON `readout_classes.tier_ladder`):
     S_H < 0.3          -> L0   (strict, lower band owns the open end)
     0.3 <= S_H < 0.6    -> L1   (boundary value belongs to the UPPER band)
     0.6 <= S_H < 0.9    -> L2
     0.9 <= S_H < 1.2    -> L3
     S_H >= 1.2          -> L4
   ---------------------------------------------------------------------- *)
Definition s_band (s : Q) : tier_level :=
  if Qlt_bool s (3 # 10)%Q then L0
  else if Qlt_bool s (6 # 10)%Q then L1
  else if Qlt_bool s (9 # 10)%Q then L2
  else if Qlt_bool s (12 # 10)%Q then L3
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

(* The combined numeric tier: 'the higher of the two sub-readouts
   governs', per the proposal statement -- both bands are still
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
   type), and every band boundary is decided by the computable Qle_bool/
   Qlt_bool, whose correctness against the Prop-level Qle/Qlt is QArith's
   own Qle_bool_iff / this file's Qlt_bool_iff. Both witnessed here.
   ---------------------------------------------------------------------- *)
Theorem tier_level_eq_dec : forall x y : tier_level, {x = y} + {x <> y}.
Proof. decide equality. Qed.

Theorem s_band_reflects_Qlt_bool :
  forall s : Q,
    s_band s = L0 <-> Qlt_bool s (3 # 10)%Q = true.
Proof.
  intro s. unfold s_band. destruct (Qlt_bool s (3 # 10)%Q) eqn:H0.
  - split; intro; reflexivity.
  - destruct (Qlt_bool s (6 # 10)%Q) eqn:H1;
    destruct (Qlt_bool s (9 # 10)%Q) eqn:H2;
    destruct (Qlt_bool s (12 # 10)%Q) eqn:H3;
    split; intro Hc; try discriminate; try congruence.
Qed.

(* ----------------------------------------------------------------------
   Boundary lemmas, one per band edge (MUST-FIX #2 per independent
   review): each boundary value now lands in the UPPER band, and the
   value immediately below it still lands in the lower band.
   ---------------------------------------------------------------------- *)
Example just_below_L0_L1 : s_band (29 # 100)%Q = L0.
Proof. reflexivity. Qed.

Example boundary_0_3_is_L1 : s_band (3 # 10)%Q = L1.
Proof. reflexivity. Qed.

Example just_below_L1_L2 : s_band (59 # 100)%Q = L1.
Proof. reflexivity. Qed.

Example boundary_0_6_is_L2 : s_band (6 # 10)%Q = L2.
Proof. reflexivity. Qed.

Example just_below_L2_L3 : s_band (89 # 100)%Q = L2.
Proof. reflexivity. Qed.

Example boundary_0_9_is_L3 : s_band (9 # 10)%Q = L3.
Proof. reflexivity. Qed.

Example just_below_L3_L4 : s_band (119 # 100)%Q = L3.
Proof. reflexivity. Qed.

Example boundary_1_2_is_L4 : s_band (12 # 10)%Q = L4.
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

(* ========================================================================
   FULL LADDER (MUST-FIX #3 per independent review): a single total
   function over (refused, D_H, R_H, F_H, S_H, T_act) resolving the
   precedence the proposal's prose left ambiguous:
     (i)   LR   if `refused` (any refusal code fired -- opaque bool here,
                the code-level precedence among refusal reasons is OPEN,
                see file header);
     (ii)  L5   else if min(D_H, R_H) = 0 AND F_H > 0 -- the exhausted-
                system case (this IS the former ZERO_CAPACITY_NONZERO_
                INFLOW condition; per this proposal's v2 amendment it is
                now a TIER, never a refusal code -- 'the system is
                already exceeded' is a valid readout for residents);
     (iii) else the ordinary band rule (`combined_tier`), lifted into
                the 7-level type. This covers both remaining cases:
                min(D_H,R_H) > 0 (the general case), and min(D_H,R_H) = 0
                with F_H = 0 (the caller has set S_H := 0 per this
                proposal's own convention, so combined_tier's S_H-band
                puts it in L0 exactly as `definitions.S_H(U)` requires).
   ======================================================================== *)

Inductive tier_level6 : Set := T_L0 | T_L1 | T_L2 | T_L3 | T_L4 | T_L5 | T_LR.

Definition lift_level (l : tier_level) : tier_level6 :=
  match l with
  | L0 => T_L0 | L1 => T_L1 | L2 => T_L2 | L3 => T_L3 | L4 => T_L4
  end.

(* min(D_H, R_H) = 0, decided computably via QArith's Qmin + Qeq_bool. *)
Definition zero_capacity (D R : Q) : bool := Qeq_bool (Qmin D R) 0%Q.

Definition full_tier
  (refused : bool) (D R F : Q) (s : Q) (t : option Q) : tier_level6 :=
  if refused then T_LR
  else if andb (zero_capacity D R) (Qlt_bool 0%Q F) then T_L5
  else lift_level (combined_tier s t).

(* ----------------------------------------------------------------------
   TOTALITY of the full 7-level ladder: same argument as combined_tier
   above -- an ordinary Gallina function, no partial match arm.
   ---------------------------------------------------------------------- *)
Theorem full_tier_total :
  forall (refused : bool) (D R F s : Q) (t : option Q),
    exists l : tier_level6, full_tier refused D R F s t = l.
Proof.
  intros refused D R F s t. exists (full_tier refused D R F s t). reflexivity.
Qed.

(* ----------------------------------------------------------------------
   DECIDABILITY of the full 7-level type's equality (finite enumerated
   type), by the same `decide equality` witness as tier_level above.
   ---------------------------------------------------------------------- *)
Theorem tier_level6_eq_dec : forall x y : tier_level6, {x = y} + {x <> y}.
Proof. decide equality. Qed.

(* LR always dominates, regardless of every other input. *)
Theorem refused_is_always_LR :
  forall (D R F s : Q) (t : option Q), full_tier true D R F s t = T_LR.
Proof. intros. reflexivity. Qed.

(* L5 fires exactly on the exhausted-system-with-inflow case, never on
   the 'no capacity needed' case (F_H = 0) -- resolving the review's
   §4 ambiguity explicitly, by example on both branches of that fork. *)
Example zero_capacity_nonzero_inflow_is_L5 :
  full_tier false 0%Q 0%Q (1 # 2)%Q 0%Q None = T_L5.
Proof. reflexivity. Qed.

Example zero_capacity_zero_inflow_is_L0 :
  full_tier false 0%Q 0%Q 0%Q 0%Q None = T_L0.
Proof. reflexivity. Qed.

(* Positive capacity never triggers L5 regardless of F_H. *)
Example positive_capacity_never_L5 :
  full_tier false (5 # 1)%Q (5 # 1)%Q (100 # 1)%Q (12 # 10)%Q None = T_L4.
Proof. reflexivity. Qed.

(* ----------------------------------------------------------------------
   WHAT THIS FILE DOES NOT PROVE (see header): the refusal-CODE
   precedence order among UNIT_NOT_DECLARED/MISSING_INPUT/etc (only an
   opaque `refused : bool` is taken here), the (lat,lon) unit-resolution
   graph walk, the 'gauged level already above declared flood threshold'
   disjunct of L5 (IO-shaped, not arithmetic), and any claim that the
   declared thresholds correctly predict real flooding (see the
   proposal's own falsifier). This file's only claim is: given `refused`,
   D_H, R_H, F_H, S_H, T_act already computed/declared, the tier readout
   is a total, decidable function of them, with L5 vs. the S_H:=0/L0 case
   disambiguated exactly as this proposal's v2 text now states.
   ---------------------------------------------------------------------- *)

(* ========================================================================
   v3 ADDITION -- C_H(U): total case split fixing the no-pump contradiction
   (thailand_flood_kg BACKTEST_PROP_FLOOD_06_v0.md sec.2.1, RELAYED,
   read-only source: this repo does not own that data, only records the
   finding). JSON: definitions.C_H(U).
   ======================================================================== *)

Inductive terms_present : Set := T_R | T_D | T_RD.

(* c_h no_pumps D R_opt:
     no_pumps = true   (NO_PUMPS_IN_UNIT)      -> uses R_opt alone
     no_pumps = false, R_opt = None (outlet
       capacity unknown but pumps declared)     -> uses D alone (PARTIAL flag,
                                                    not a refusal)
     no_pumps = false, R_opt = Some R           -> min(D,R), unchanged from v1/v2
     no_pumps = true,  R_opt = None             -> None (still REFUSED
                                                    OUTLET_CAPACITY_UNKNOWN --
                                                    neither term resolves) *)
Definition c_h (no_pumps : bool) (D : Q) (R_opt : option Q) : option (Q * terms_present) :=
  match no_pumps, R_opt with
  | true, Some R => Some (R, T_R)
  | true, None => None
  | false, Some R => Some (Qmin D R, T_RD)
  | false, None => Some (D, T_D)
  end.

(* TOTALITY: an ordinary Gallina function, defined (as an option) on every
   input -- total by construction, exactly as with `combined_tier` above. *)
Theorem c_h_total :
  forall (no_pumps : bool) (D : Q) (R_opt : option Q),
    exists r : option (Q * terms_present), c_h no_pumps D R_opt = r.
Proof. intros. exists (c_h no_pumps D R_opt). reflexivity. Qed.

(* c_h is None exactly in the one genuinely non-resolvable case: no pumps
   declared AND no known outlet capacity -- neither R_H nor D_H is usable. *)
Theorem c_h_none_iff_no_pumps_and_no_outlet :
  forall (D : Q) (R_opt : option Q),
    c_h true D R_opt = None <-> R_opt = None.
Proof.
  intros D R_opt. split.
  - destruct R_opt as [R|]; simpl; intro H; [discriminate | reflexivity].
  - intro H. rewrite H. reflexivity.
Qed.

(* The former contradiction, refuted directly: with no pumps declared
   (D_H:=0 by definition, `no_pumps=true`) and a resolvable outlet
   (R_opt = Some R with R > 0), c_h now yields R itself (via T_R), never the
   old literal `min(0, R) = 0` that produced AYUTTHAYA_BANGBAN's spurious
   REFUSED/L5 result in the backtest. *)
Example no_pump_contradiction_fixed :
  c_h true 0%Q (Some (100 # 1)%Q) = Some ((100 # 1)%Q, T_R).
Proof. reflexivity. Qed.

(* Pumps declared but outlet capacity unknown: D_H alone is used, PARTIAL
   flag T_D, never a whole-unit refusal on this term. *)
Example pumps_only_partial_flag :
  c_h false (30 # 1)%Q None = Some ((30 # 1)%Q, T_D).
Proof. reflexivity. Qed.

(* Both resolve: unchanged min(D,R) behaviour from v1/v2. *)
Example both_terms_min_unchanged :
  c_h false (30 # 1)%Q (Some (100 # 1)%Q) = Some ((30 # 1)%Q, T_RD).
Proof. reflexivity. Qed.

(* Neither resolves: genuinely REFUSED (OUTLET_CAPACITY_UNKNOWN), not a
   silent zero. *)
Example neither_term_refused :
  c_h true (0 # 1)%Q None = None.
Proof. reflexivity. Qed.

(* ========================================================================
   v3 ADDITION -- graceful PARTIAL mode: mode in {FULL, PARTIAL, LR}.
   JSON: readout_classes.mode, readout_classes.promoter_table.
   Founder ruling 2026-09-27 (verbatim, translated context in the .md/.json):
   a tier must be returned whenever ANY real input exists; refusal (LR) is
   reserved for when cov(U) is entirely absent/stale.
   ======================================================================== *)

Require Import Coq.Lists.List.
Import ListNotations.

(* Reuses the `tier_level6` type (constructors T_L0..T_LR) already declared
   above for the v2 `full_tier` construction -- shared, not re-declared,
   by both the v2 machinery and this v3 PARTIAL-mode machinery. *)

Definition level6_to_nat (l : tier_level6) : nat :=
  match l with
  | T_L0 => 0%nat | T_L1 => 1%nat | T_L2 => 2%nat | T_L3 => 3%nat
  | T_L4 => 4%nat | T_L5 => 5%nat | T_LR => 6%nat
  end.

Definition nat_to_level6 (n : nat) : tier_level6 :=
  match n with
  | 0%nat => T_L0 | 1%nat => T_L1 | 2%nat => T_L2 | 3%nat => T_L3
  | 4%nat => T_L4 | 5%nat => T_L5 | _ => T_LR
  end.

Definition max_level6 (a b : tier_level6) : tier_level6 :=
  nat_to_level6 (Nat.max (level6_to_nat a) (level6_to_nat b)).

(* A promoter list entry: (applies, level) -- `applies` is already the
   caller-reduced `avail && fires` (JSON: the promoter's required cov(U)
   component is present AND its trigger condition holds); a promoter whose
   input is absent/stale is excluded from the max, never contributing a
   default level. Empty/all-inapplicable list -> T_L0 (a genuine, non-
   refused "no promoter fired on what we do have" readout). *)
Definition promoter_max (ps : list (bool * tier_level6)) : tier_level6 :=
  fold_right (fun (p : bool * tier_level6) (acc : tier_level6) =>
                if fst p then max_level6 (snd p) acc else acc) T_L0 ps.

(* TOTALITY: fold_right over a finite list is total by construction. *)
Theorem promoter_max_total :
  forall ps : list (bool * tier_level6), exists l : tier_level6, promoter_max ps = l.
Proof. intros. exists (promoter_max ps). reflexivity. Qed.

Example promoter_max_empty_is_L0 : promoter_max [] = T_L0.
Proof. reflexivity. Qed.

(* Hat Yai worked example (JSON worked_example_partial_hatyai_v3): only two
   promoters applicable (rain-24h-exceeds-design -> L3, canal-at-warning ->
   L2), every other promoter's input absent (excluded, not zero) -> L3. *)
Example promoter_max_hatyai_partial :
  promoter_max [(true, T_L3); (true, T_L2); (false, T_L5); (false, T_L4)] = T_L3.
Proof. reflexivity. Qed.

(* No promoter's required input is present even though SOME cov(U)
   component is present (e.g. rain below every trigger) -> L0, not LR. *)
Example promoter_max_none_fired_is_L0 :
  promoter_max [(false, T_L4); (false, T_L3)] = T_L0.
Proof. reflexivity. Qed.

(* The vulnerable-unit +1 promotion rule (JSON promoter_table.
   VULNERABLE_UNIT_PROMOTION): bumps the already-computed tier by exactly
   one level, capped at T_L5, and is a no-op on T_LR (refusal is never
   promoted -- there is nothing to promote past). *)
Definition promote_one (l : tier_level6) : tier_level6 :=
  match l with
  | T_L0 => T_L1 | T_L1 => T_L2 | T_L2 => T_L3 | T_L3 => T_L4
  | T_L4 => T_L5 | T_L5 => T_L5 | T_LR => T_LR
  end.

Theorem promote_one_total :
  forall l : tier_level6, exists l' : tier_level6, promote_one l = l'.
Proof. intros. exists (promote_one l). reflexivity. Qed.

Theorem promote_one_never_creates_LR :
  forall l : tier_level6, l <> T_LR -> promote_one l <> T_LR.
Proof. intros l H. destruct l; simpl; try discriminate. contradiction. Qed.

Theorem promote_one_LR_is_noop : promote_one T_LR = T_LR.
Proof. reflexivity. Qed.

(* The single total function replacing v2's `full_tier` as the top-level
   entry point once PARTIAL mode exists: mode is decided first
   (cov_all_absent -> LR; else ledger_resolves -> FULL, reusing the v2
   `full_tier` machinery unchanged with refused:=false; else -> PARTIAL,
   the promoter max), then the vulnerable-unit +1 rule is applied to
   whichever tier resulted, except when the result is LR (never promoted).
   This is the pure-numeric shape of JSON readout_classes.mode. *)
Definition full_tier_v3
  (cov_all_absent ledger_resolves vulnerable_promote : bool)
  (D R F s : Q) (t : option Q) (promoters : list (bool * tier_level6))
  : tier_level6 :=
  let base :=
    if cov_all_absent then T_LR
    else if ledger_resolves then full_tier false D R F s t
    else promoter_max promoters
  in
  if vulnerable_promote then promote_one base else base.

(* TOTALITY of the v3 top-level function: same argument as `full_tier`
   above -- an ordinary Gallina function, no partial match arm. *)
Theorem full_tier_v3_total :
  forall (cov_all_absent ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q) (promoters : list (bool * tier_level6)),
    exists l : tier_level6,
      full_tier_v3 cov_all_absent ledger_resolves vulnerable_promote D R F s t promoters = l.
Proof.
  intros. exists (full_tier_v3 cov_all_absent ledger_resolves vulnerable_promote D R F s t promoters).
  reflexivity.
Qed.

(* DECIDABILITY: tier_level6 (as re-scoped in this v3 section) has decidable
   equality -- a finite enumerated type. *)
Theorem tier_level6_v3_eq_dec : forall x y : tier_level6, {x = y} + {x <> y}.
Proof. decide equality. Qed.

(* cov(U) entirely absent/stale dominates every other input, exactly like
   v2's `refused` flag -- vulnerable-unit promotion never fires on LR
   because `promote_one T_LR = T_LR` (checked above), so this holds
   regardless of `vulnerable_promote`'s value. *)
Theorem cov_all_absent_is_always_LR :
  forall (ledger_resolves vulnerable_promote : bool) (D R F s : Q) (t : option Q)
         (promoters : list (bool * tier_level6)),
    full_tier_v3 true ledger_resolves vulnerable_promote D R F s t promoters = T_LR.
Proof.
  intros. unfold full_tier_v3.
  destruct vulnerable_promote; simpl; reflexivity.
Qed.

(* Vulnerable-unit promotion example: a PARTIAL-mode L2 tier (from a single
   applicable promoter) becomes L3 once the unit declares a vulnerable
   population and the promotion condition holds. *)
Example vulnerable_promotion_partial_L2_to_L3 :
  full_tier_v3 false false true 0%Q 0%Q 0%Q 0%Q None [(true, T_L2)] = T_L3.
Proof. reflexivity. Qed.

(* Without promotion, the same PARTIAL inputs stay at L2. *)
Example no_promotion_stays_L2 :
  full_tier_v3 false false false 0%Q 0%Q 0%Q 0%Q None [(true, T_L2)] = T_L2.
Proof. reflexivity. Qed.

(* FULL mode still reuses v2's full_tier unchanged when the ledger resolves,
   e.g. an ordinary L4 severity case, no promotion. *)
Example full_mode_reuses_v2_full_tier :
  full_tier_v3 false true false (5#1)%Q (5#1)%Q (100#1)%Q (12#10)%Q None [] = T_L4.
Proof. reflexivity. Qed.

(* ----------------------------------------------------------------------
   WHAT THIS v3 ADDITION DOES NOT PROVE: which cov(U) component is
   "present/stale/absent" (an IO-shaped classification against a
   staleness window, not arithmetic); the promoter trigger conditions
   themselves (e.g. `rain_24h_mm > 80`) as anything beyond a caller-
   supplied boolean `fires`; and any claim that a PARTIAL-mode tier
   correctly predicts real flooding -- see the proposal's own falsifier,
   unchanged by this addition. This file's v3 claim is only: given
   `cov_all_absent`, `ledger_resolves`, a promoter list already reduced to
   (applies, level) pairs, and the vulnerable-unit flag, the mode-aware
   tier readout is a total, decidable function of them, and LR still
   dominates every other input exactly as in v2.
   ---------------------------------------------------------------------- *)

(* ========================================================================
   v4 ADDITION -- monotonic promoters in every mode, and an inseparable
   readout record (PROP-FLOOD-06.v4, per independent review round 2,
   REVIEW_PROP_FLOOD_06_r2.md, both MUST-FIX findings).

   MUST-FIX (round 2) #1 -- "PARTIAL can silently outrank FULL,
   undocumented": v3's `full_tier_v3` was EXCLUSIVE on mode -- FULL mode
   consulted only the S_H/T_act bands (`full_tier`) and never the
   promoter table, so a unit with a fully-resolved ledger but a raw
   physical promoter fact (rain > design capacity, zero pumps running
   above the critical line) could report a LOWER tier than an otherwise-
   identical unit that was merely missing one input (hence PARTIAL) on
   the very same physical signal. v4 fixes this by making promoters a
   FLOOR under every mode, never something only PARTIAL consults:

     final tier := promote_one_if(vulnerable_promote,
                     max_level6 band_tier (promoter_max applicable_promoters))
   where
     band_tier := full_tier false D R F s t   if the ledger resolves (FULL)
                  T_L0                         otherwise (PARTIAL/no ledger)
   and LR (cov(U) entirely absent/stale) is checked LAST, overriding this
   result unconditionally -- unchanged from v3's LR-dominates discipline.
   This is exactly the task's stated order: band_tier (FULL only, else
   L0), then promoter_max, then the vulnerable +1 rule, then LR iff
   coverage is all-absent/stale.

   ข้อมูลเพิ่มไม่เคยลดระดับ ("more real data never lowers the reported
   level") is proved below as two theorems:
     (a) `full_tier_v4_promoter_monotone` -- for the SAME promoter table
         and the same ledger inputs, widening the coverage vector (any
         `cov` component that was present stays present) never lowers
         the tier, as long as the unit was not already LR (LR is a
         refusal state, not a severity comparison, and is excluded from
         this claim by hypothesis -- exactly the "monotonicity in the
         coverage vector for promoter inputs" scope the task names).
     (b) `full_tier_v4_full_ge_partial` -- for the SAME promoters and the
         same non-LR coverage, the FULL-mode tier (ledger_resolves=true)
         is >= the PARTIAL-mode tier the identical promoter inputs would
         give (ledger_resolves=false), because FULL only ADDS the band
         term into the same max, it never substitutes for it.

   MUST-FIX (round 2) #2 -- "coverage_score/mode are not structurally
   mandatory": v3's `full_tier_v3` returned a bare `tier_level6`, with
   mode/coverage/based_on/missing left as prose-only JSON conventions a
   consumer could silently drop, reproducing exactly the false "ปกติ"
   reassurance the founder's crisis-usability ruling was meant to avoid.
   v4 fixes this by making the return type itself a `readout` record --
   tier, mode, coverage_present, coverage_total, based_on, missing,
   promoters_fired are ONE inseparable value, never independently
   droppable by a consumer that pattern-matches only on `tier`. Mirrors
   JSON `readout_schema` (see registry/proposals/flood_outlet_coping.json)
   and the MD's explicit consumer-contract sentence ("a consumer MUST
   render tier together with mode and coverage").
   ======================================================================== *)

Require Import Coq.Arith.PeanoNat.
Require Import Lia.

(* ------------------------------------------------------------------
   Finite enumerations for the record's structured fields.
   ------------------------------------------------------------------ *)

Inductive mode3 : Set := M_FULL | M_PARTIAL | M_LR.

Theorem mode3_eq_dec : forall x y : mode3, {x = y} + {x <> y}.
Proof. decide equality. Qed.

(* The seven coverage-vector components, JSON definitions.cov, fixed order. *)
Inductive input_kind : Set :=
  | IK_rain_obs
  | IK_rain_fcst
  | IK_canal_level_vs_lines
  | IK_river_flow_vs_cap
  | IK_dam_release
  | IK_pumps_state
  | IK_upstream_inflow.

Theorem input_kind_eq_dec : forall x y : input_kind, {x = y} + {x <> y}.
Proof. decide equality. Qed.

(* The declared promoter_table ids (JSON readout_classes.promoter_table),
   VULNERABLE_UNIT_PROMOTION excluded -- it is not a max-table entry, it is
   the separate +1 rule already formalised above as `promote_one`. *)
Inductive promoter_id : Set :=
  | P_RAIN_24H_EXCEEDS_DESIGN
  | P_CANAL_AT_WARNING_LINE
  | P_CANAL_AT_CRITICAL_LINE
  | P_CANAL_AT_BANK_LEVEL
  | P_DAM_RELEASE_ABOVE_SPILL_THRESHOLD
  | P_PUMPS_ZERO_RUNNING_ABOVE_THRESHOLD.

Theorem promoter_id_eq_dec : forall x y : promoter_id, {x = y} + {x <> y}.
Proof. decide equality. Qed.

(* ------------------------------------------------------------------
   Coverage vector cov(U): a 7-field record, one bool per component,
   `true` = present (within its declared staleness window), `false` =
   stale-or-absent (this file does not distinguish stale from absent,
   exactly as the v3 section above already declared for its opaque
   `cov_all_absent` bool -- see that section's header). Fixed arity by
   construction, so `coverage_total` below is exactly 7, always, never a
   runtime-computed list length that could drift.
   ------------------------------------------------------------------ *)

Record coverage_vector := mkCov {
  cov_rain_obs               : bool;
  cov_rain_fcst              : bool;
  cov_canal_level_vs_lines   : bool;
  cov_river_flow_vs_cap      : bool;
  cov_dam_release            : bool;
  cov_pumps_state            : bool;
  cov_upstream_inflow        : bool
}.

Definition cov_get (cv : coverage_vector) (k : input_kind) : bool :=
  match k with
  | IK_rain_obs => cov_rain_obs cv
  | IK_rain_fcst => cov_rain_fcst cv
  | IK_canal_level_vs_lines => cov_canal_level_vs_lines cv
  | IK_river_flow_vs_cap => cov_river_flow_vs_cap cv
  | IK_dam_release => cov_dam_release cv
  | IK_pumps_state => cov_pumps_state cv
  | IK_upstream_inflow => cov_upstream_inflow cv
  end.

Definition all_input_kinds : list input_kind :=
  IK_rain_obs :: IK_rain_fcst :: IK_canal_level_vs_lines :: IK_river_flow_vs_cap
  :: IK_dam_release :: IK_pumps_state :: IK_upstream_inflow :: nil.

Definition cov_present_kinds (cv : coverage_vector) : list input_kind :=
  filter (fun k => cov_get cv k) all_input_kinds.

Definition cov_missing_kinds (cv : coverage_vector) : list input_kind :=
  filter (fun k => negb (cov_get cv k)) all_input_kinds.

Definition bool_to_nat (b : bool) : nat := if b then 1%nat else 0%nat.

Definition coverage_present (cv : coverage_vector) : nat :=
  ( bool_to_nat (cov_rain_obs cv) + bool_to_nat (cov_rain_fcst cv)
  + bool_to_nat (cov_canal_level_vs_lines cv) + bool_to_nat (cov_river_flow_vs_cap cv)
  + bool_to_nat (cov_dam_release cv) + bool_to_nat (cov_pumps_state cv)
  + bool_to_nat (cov_upstream_inflow cv) )%nat.

Definition coverage_total : nat := 7%nat.

(* coverage_total is exactly the length of the fixed 7-element component
   list, tying the constant to the actual enumeration rather than leaving
   it a bare unchecked literal. *)
Theorem coverage_total_is_7 : coverage_total = 7%nat.
Proof. reflexivity. Qed.

Theorem coverage_total_eq_all_kinds_length :
  coverage_total = length all_input_kinds.
Proof. reflexivity. Qed.

(* coverage_present is a sum of exactly 7 boolean-to-{0,1} terms, hence
   never exceeds 7 -- proved directly, not merely by example. *)
Theorem coverage_present_le_total :
  forall cv : coverage_vector, (coverage_present cv <= coverage_total)%nat.
Proof.
  intro cv. unfold coverage_present, coverage_total, bool_to_nat.
  destruct (cov_rain_obs cv), (cov_rain_fcst cv), (cov_canal_level_vs_lines cv),
           (cov_river_flow_vs_cap cv), (cov_dam_release cv), (cov_pumps_state cv),
           (cov_upstream_inflow cv);
  simpl; lia.
Qed.

Definition cov_all_absent (cv : coverage_vector) : bool :=
  Nat.eqb (coverage_present cv) 0%nat.

Lemma exists_true_component :
  forall cv : coverage_vector, coverage_present cv <> 0%nat -> exists k, cov_get cv k = true.
Proof.
  intros cv Hne.
  destruct (cov_rain_obs cv) eqn:E1. { exists IK_rain_obs; exact E1. }
  destruct (cov_rain_fcst cv) eqn:E2. { exists IK_rain_fcst; exact E2. }
  destruct (cov_canal_level_vs_lines cv) eqn:E3. { exists IK_canal_level_vs_lines; exact E3. }
  destruct (cov_river_flow_vs_cap cv) eqn:E4. { exists IK_river_flow_vs_cap; exact E4. }
  destruct (cov_dam_release cv) eqn:E5. { exists IK_dam_release; exact E5. }
  destruct (cov_pumps_state cv) eqn:E6. { exists IK_pumps_state; exact E6. }
  destruct (cov_upstream_inflow cv) eqn:E7. { exists IK_upstream_inflow; exact E7. }
  exfalso. apply Hne. unfold coverage_present, bool_to_nat.
  rewrite E1, E2, E3, E4, E5, E6, E7. reflexivity.
Qed.

Lemma coverage_present_pos_of_true :
  forall cv k, cov_get cv k = true -> coverage_present cv <> 0%nat.
Proof.
  intros cv k Hk. unfold coverage_present, bool_to_nat.
  destruct k; simpl in Hk; rewrite Hk; simpl; lia.
Qed.

Lemma cov_all_absent_false_mono :
  forall cv1 cv2, cov_all_absent cv1 = false ->
    (forall k, cov_get cv1 k = true -> cov_get cv2 k = true) ->
    cov_all_absent cv2 = false.
Proof.
  intros cv1 cv2 H1 Hmono.
  unfold cov_all_absent in *.
  apply Nat.eqb_neq. apply Nat.eqb_neq in H1.
  destruct (exists_true_component cv1 H1) as [k Hk].
  apply Hmono in Hk.
  eapply coverage_present_pos_of_true; eauto.
Qed.

(* ------------------------------------------------------------------
   A promoter entry: its id, which cov(U) component it requires, and the
   caller-supplied boolean trigger outcome ("fires") for that component's
   declared condition (e.g. rain_24h_mm > 80) -- the arithmetic condition
   itself is IO-shaped/data-dependent, exactly as the v3 section above
   already left `fires` an opaque caller-supplied bool.  `p_applies` is
   `avail && fires`: a promoter never contributes unless its own required
   input is actually present.
   ------------------------------------------------------------------ *)

Record promoter := mkPromoter {
  p_id       : promoter_id;
  p_requires : input_kind;
  p_fires    : bool;
  p_level    : tier_level6
}.

Definition promoter_applies (cv : coverage_vector) (p : promoter) : bool :=
  andb (cov_get cv (p_requires p)) (p_fires p).

Definition promoters_that_apply (cv : coverage_vector) (ps : list promoter) : list promoter :=
  filter (promoter_applies cv) ps.

(* ------------------------------------------------------------------
   The inseparable readout record (MUST-FIX #2): tier is never returned
   on its own -- mode, coverage, based_on/missing and which promoters
   fired travel with it as one value.  Mirrors JSON `readout_schema`.
   ------------------------------------------------------------------ *)

Record readout := mkReadout {
  tier                     : tier_level6;
  mode                     : mode3;
  readout_coverage_present : nat;
  readout_coverage_total   : nat;
  based_on                 : list input_kind;
  missing                  : list input_kind;
  promoters_fired          : list promoter_id
}.

(* DECIDABILITY of the record's equality: every field type is a finite
   enumeration or a list thereof; `list_eq_dec` (Coq.Lists.List) lifts
   the finite base-type decisions to the two list-valued fields. *)
Theorem readout_eq_dec : forall x y : readout, {x = y} + {x <> y}.
Proof.
  decide equality.
  - apply (list_eq_dec promoter_id_eq_dec).
  - apply (list_eq_dec input_kind_eq_dec).
  - apply (list_eq_dec input_kind_eq_dec).
  - apply Nat.eq_dec.
  - apply Nat.eq_dec.
  - apply mode3_eq_dec.
  - apply tier_level6_eq_dec.
Qed.

(* ------------------------------------------------------------------
   full_tier_v4 -- the single top-level entry point replacing v3's
   `full_tier_v3`.  Promoters are now a FLOOR under every mode (MUST-FIX
   #1).
   ------------------------------------------------------------------ *)

Definition full_tier_v4
  (cv : coverage_vector)
  (ledger_resolves vulnerable_promote : bool)
  (D R F s : Q) (t : option Q)
  (promoters : list promoter)
  : readout :=
  let band := if ledger_resolves then full_tier false D R F s t else T_L0 in
  let applies_list :=
    map (fun p => (promoter_applies cv p, p_level p)) promoters in
  let pm := promoter_max applies_list in
  let base := max_level6 band pm in
  let promoted := if vulnerable_promote then promote_one base else base in
  let cov_absent := cov_all_absent cv in
  let final_tier := if cov_absent then T_LR else promoted in
  let final_mode :=
    if cov_absent then M_LR
    else if ledger_resolves then M_FULL else M_PARTIAL in
  {| tier := final_tier;
     mode := final_mode;
     readout_coverage_present := coverage_present cv;
     readout_coverage_total := coverage_total;
     based_on := cov_present_kinds cv;
     missing := cov_missing_kinds cv;
     promoters_fired := map p_id (promoters_that_apply cv promoters) |}.

(* TOTALITY: an ordinary Gallina function building a record literal from
   already-total sub-computations -- total by construction, same argument
   as every prior top-level function in this file. *)
Theorem full_tier_v4_total :
  forall (cv : coverage_vector) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q) (promoters : list promoter),
    exists r : readout,
      full_tier_v4 cv ledger_resolves vulnerable_promote D R F s t promoters = r.
Proof. intros. eexists. reflexivity. Qed.

(* readout's own coverage fields inherit the two bounds already proved
   above -- restated on the record's own projections for direct use by a
   consumer that only has a `readout` value in hand. *)
Theorem full_tier_v4_coverage_total_is_7 :
  forall (cv : coverage_vector) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q) (promoters : list promoter),
    readout_coverage_total (full_tier_v4 cv ledger_resolves vulnerable_promote D R F s t promoters)
    = 7%nat.
Proof. intros. reflexivity. Qed.

Theorem full_tier_v4_coverage_present_le_7 :
  forall (cv : coverage_vector) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q) (promoters : list promoter),
    (readout_coverage_present (full_tier_v4 cv ledger_resolves vulnerable_promote D R F s t promoters)
     <= 7)%nat.
Proof. intros. simpl. apply coverage_present_le_total. Qed.

(* LR iff coverage_present = 0 (the record's own `mode` field, not just
   the internal `cov_all_absent` helper): restated at the top-level entry
   point so a consumer can check either the mode tag or the coverage
   count and get the same answer. *)
Theorem full_tier_v4_LR_iff_coverage_present_0 :
  forall (cv : coverage_vector) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q) (promoters : list promoter),
    mode (full_tier_v4 cv ledger_resolves vulnerable_promote D R F s t promoters) = M_LR
    <-> readout_coverage_present (full_tier_v4 cv ledger_resolves vulnerable_promote D R F s t promoters) = 0%nat.
Proof.
  intros. unfold full_tier_v4, cov_all_absent. simpl.
  destruct (Nat.eqb (coverage_present cv) 0%nat) eqn:E.
  - apply Nat.eqb_eq in E. split; intro; [exact E | reflexivity].
  - apply Nat.eqb_neq in E.
    destruct ledger_resolves, vulnerable_promote; simpl;
    split; intro H; try discriminate; try (exfalso; apply E; exact H).
Qed.

(* ------------------------------------------------------------------
   Arithmetic monotonicity helpers on tier_level6, all proved by finite
   case analysis (a 7-constructor enumerated type).
   ------------------------------------------------------------------ *)

Lemma level6_to_nat_le6 : forall l : tier_level6, (level6_to_nat l <= 6)%nat.
Proof. intro l. destruct l; simpl; lia. Qed.

Lemma nat_to_level6_spec : forall n : nat, level6_to_nat (nat_to_level6 n) = Nat.min n 6.
Proof.
  intros n.
  destruct n as [|[|[|[|[|[|n]]]]]]; simpl; try reflexivity.
  lia.
Qed.

Lemma max_level6_mono_l :
  forall a a' b : tier_level6,
    (level6_to_nat a <= level6_to_nat a')%nat ->
    (level6_to_nat (max_level6 a b) <= level6_to_nat (max_level6 a' b))%nat.
Proof.
  intros a a' b H. unfold max_level6.
  rewrite !nat_to_level6_spec.
  pose proof (level6_to_nat_le6 a). pose proof (level6_to_nat_le6 a').
  pose proof (level6_to_nat_le6 b). lia.
Qed.

Lemma max_level6_mono_r :
  forall a b b' : tier_level6,
    (level6_to_nat b <= level6_to_nat b')%nat ->
    (level6_to_nat (max_level6 a b) <= level6_to_nat (max_level6 a b'))%nat.
Proof.
  intros a b b' H. unfold max_level6.
  rewrite !nat_to_level6_spec.
  pose proof (level6_to_nat_le6 a). pose proof (level6_to_nat_le6 b). pose proof (level6_to_nat_le6 b').
  lia.
Qed.

Lemma max_level6_ge_r :
  forall a b : tier_level6, (level6_to_nat b <= level6_to_nat (max_level6 a b))%nat.
Proof.
  intros a b. unfold max_level6. rewrite nat_to_level6_spec.
  pose proof (level6_to_nat_le6 a). pose proof (level6_to_nat_le6 b). lia.
Qed.

Lemma promote_one_mono :
  forall l1 l2 : tier_level6,
    (level6_to_nat l1 <= level6_to_nat l2)%nat ->
    (level6_to_nat (promote_one l1) <= level6_to_nat (promote_one l2))%nat.
Proof. intros l1 l2 H. destruct l1, l2; simpl in *; lia. Qed.

Lemma promote_one_mono_if :
  forall (flag : bool) (l1 l2 : tier_level6),
    (level6_to_nat l1 <= level6_to_nat l2)%nat ->
    (level6_to_nat (if flag then promote_one l1 else l1)
     <= level6_to_nat (if flag then promote_one l2 else l2))%nat.
Proof. intros flag l1 l2 H. destruct flag; [apply promote_one_mono|]; exact H. Qed.

(* ------------------------------------------------------------------
   promoter_max is monotone under a pointwise relation that only ever
   flips an `applies` flag from false to true while holding the level
   fixed ("the same promoter list, but with more inputs now present/
   firing").
   ------------------------------------------------------------------ *)

Inductive promoters_mono : list (bool * tier_level6) -> list (bool * tier_level6) -> Prop :=
  | pm_nil : promoters_mono nil nil
  | pm_cons :
      forall b1 b2 l ps1 ps2,
        (b1 = true -> b2 = true) ->
        promoters_mono ps1 ps2 ->
        promoters_mono ((b1, l) :: ps1) ((b2, l) :: ps2).

Lemma promoter_max_monotone :
  forall ps1 ps2, promoters_mono ps1 ps2 ->
    (level6_to_nat (promoter_max ps1) <= level6_to_nat (promoter_max ps2))%nat.
Proof.
  intros ps1 ps2 H. induction H as [| b1 b2 l ps1 ps2 Himp Hmono IH].
  - simpl. lia.
  - simpl.
    destruct b1 eqn:Eb1, b2 eqn:Eb2.
    + apply max_level6_mono_r. exact IH.
    + specialize (Himp eq_refl). discriminate.
    + apply (Nat.le_trans _ (level6_to_nat (promoter_max ps2)) _).
      * exact IH.
      * apply max_level6_ge_r.
    + exact IH.
Qed.

(* ------------------------------------------------------------------
   MONOTONICITY THEOREMS (round-2 MUST-FIX #1) --
   "ข้อมูลเพิ่มไม่เคยลดระดับ" (more real data never lowers the level).
   ------------------------------------------------------------------ *)

(* (a) Same promoter table, same ledger inputs: widening the coverage
   vector (every present component stays present) never lowers the
   reported tier, provided the unit was not already LR -- LR is a
   refusal state, not a severity comparison, and is intentionally
   excluded from this claim (see file-header discussion). *)
Theorem full_tier_v4_promoter_monotone :
  forall (cv1 cv2 : coverage_vector) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q) (promoters : list promoter),
    cov_all_absent cv1 = false ->
    (forall k, cov_get cv1 k = true -> cov_get cv2 k = true) ->
    (level6_to_nat (tier (full_tier_v4 cv1 ledger_resolves vulnerable_promote D R F s t promoters))
     <= level6_to_nat (tier (full_tier_v4 cv2 ledger_resolves vulnerable_promote D R F s t promoters)))%nat.
Proof.
  intros cv1 cv2 ledger_resolves vulnerable_promote D R F s t promoters Habs1 Hmono.
  assert (Habs2 : cov_all_absent cv2 = false) by (eapply cov_all_absent_false_mono; eauto).
  unfold full_tier_v4, tier. simpl.
  rewrite Habs1, Habs2.
  apply promote_one_mono_if.
  apply max_level6_mono_r.
  apply promoter_max_monotone.
  induction promoters as [| p ps IH].
  - simpl. constructor.
  - simpl. constructor.
    + intro Hp1. unfold promoter_applies in *.
      apply andb_true_iff in Hp1 as [Hc Hf].
      apply andb_true_iff. split; [apply Hmono; exact Hc | exact Hf].
    + exact IH.
Qed.

(* (b) Same promoters, same non-LR coverage: the FULL-mode tier is >= the
   PARTIAL-mode tier the identical promoter inputs would give -- FULL
   only ADDS the S_H/T_act band term into the same max, it never
   substitutes for the promoter floor. *)
Theorem full_tier_v4_full_ge_partial :
  forall (cv : coverage_vector) (vulnerable_promote : bool)
         (D R F s : Q) (t : option Q) (promoters : list promoter),
    cov_all_absent cv = false ->
    (level6_to_nat (tier (full_tier_v4 cv false vulnerable_promote D R F s t promoters))
     <= level6_to_nat (tier (full_tier_v4 cv true vulnerable_promote D R F s t promoters)))%nat.
Proof.
  intros cv vulnerable_promote D R F s t promoters Habs.
  unfold full_tier_v4, tier. simpl.
  rewrite Habs.
  apply promote_one_mono_if.
  apply max_level6_mono_l.
  simpl. apply Nat.le_0_l.
Qed.

(* ------------------------------------------------------------------
   Worked examples, re-cast against the v4 top-level function.
   ------------------------------------------------------------------ *)

Definition ex_cov_hatyai : coverage_vector :=
  {| cov_rain_obs := true; cov_rain_fcst := false;
     cov_canal_level_vs_lines := true; cov_river_flow_vs_cap := false;
     cov_dam_release := false; cov_pumps_state := false;
     cov_upstream_inflow := false |}.

Definition ex_promoters_hatyai : list promoter :=
  {| p_id := P_RAIN_24H_EXCEEDS_DESIGN; p_requires := IK_rain_obs;
     p_fires := true; p_level := T_L3 |}
  :: {| p_id := P_CANAL_AT_WARNING_LINE; p_requires := IK_canal_level_vs_lines;
        p_fires := true; p_level := T_L2 |}
  :: {| p_id := P_CANAL_AT_CRITICAL_LINE; p_requires := IK_canal_level_vs_lines;
        p_fires := false; p_level := T_L4 |}
  :: {| p_id := P_DAM_RELEASE_ABOVE_SPILL_THRESHOLD; p_requires := IK_dam_release;
        p_fires := false; p_level := T_L3 |}
  :: nil.

Example hatyai_v4_partial_L3 :
  tier (full_tier_v4 ex_cov_hatyai false false 0%Q 0%Q 0%Q 0%Q None ex_promoters_hatyai) = T_L3.
Proof. reflexivity. Qed.

Example hatyai_v4_mode_partial :
  mode (full_tier_v4 ex_cov_hatyai false false 0%Q 0%Q 0%Q 0%Q None ex_promoters_hatyai) = M_PARTIAL.
Proof. reflexivity. Qed.

Example hatyai_v4_coverage_2_of_7 :
  readout_coverage_present (full_tier_v4 ex_cov_hatyai false false 0%Q 0%Q 0%Q 0%Q None ex_promoters_hatyai) = 2%nat.
Proof. reflexivity. Qed.

(* Round-2 MUST-FIX #1, concretely: a FULLY-resolved ledger with a low
   S_H band (T_L0) but a firing rain promoter no longer reports L0 --
   the promoter floor now applies under FULL mode too. *)
Example full_mode_promoter_floor_not_ignored :
  tier (full_tier_v4 ex_cov_hatyai true false 0%Q 0%Q 0%Q (1 # 10)%Q None ex_promoters_hatyai) = T_L3.
Proof. reflexivity. Qed.

(* The former v3 asymmetry directly refuted: the same promoters/coverage,
   once with the ledger unresolved (PARTIAL) and once resolved (FULL,
   band T_L0 from a low S_H), now give the SAME tier -- FULL never drops
   below what PARTIAL already established. *)
Example full_never_drops_below_partial_hatyai :
  tier (full_tier_v4 ex_cov_hatyai false false 0%Q 0%Q 0%Q (1 # 10)%Q None ex_promoters_hatyai)
  = tier (full_tier_v4 ex_cov_hatyai true false 0%Q 0%Q 0%Q (1 # 10)%Q None ex_promoters_hatyai).
Proof. reflexivity. Qed.

(* Vulnerable-unit promotion still composes on top of the v4 floor. *)
Example hatyai_v4_vulnerable_promotes_to_L4 :
  tier (full_tier_v4 ex_cov_hatyai false true 0%Q 0%Q 0%Q 0%Q None ex_promoters_hatyai) = T_L4.
Proof. reflexivity. Qed.

(* cov entirely absent still overrides everything, per the task's stated
   order ("then LR only if coverage is all-absent/stale"). *)
Definition ex_cov_none : coverage_vector :=
  {| cov_rain_obs := false; cov_rain_fcst := false;
     cov_canal_level_vs_lines := false; cov_river_flow_vs_cap := false;
     cov_dam_release := false; cov_pumps_state := false;
     cov_upstream_inflow := false |}.

Example all_absent_is_LR_even_with_firing_promoters :
  tier (full_tier_v4 ex_cov_none true true (5 # 1)%Q (5 # 1)%Q (100 # 1)%Q (12 # 10)%Q None ex_promoters_hatyai) = T_LR.
Proof. reflexivity. Qed.

Example all_absent_mode_is_LR :
  mode (full_tier_v4 ex_cov_none true true (5 # 1)%Q (5 # 1)%Q (100 # 1)%Q (12 # 10)%Q None ex_promoters_hatyai) = M_LR.
Proof. reflexivity. Qed.

(* ----------------------------------------------------------------------
   WHAT THIS v4 ADDITION DOES NOT PROVE: the arithmetic promoter trigger
   conditions themselves (e.g. `rain_24h_mm > 80`, `canal_water_level_m
   >= canal_warning_m`) as anything beyond a caller-supplied boolean
   `p_fires`; which cov(U) component is "present/stale/absent" against a
   real staleness window (an IO-shaped classification, not arithmetic);
   the VULNERABLE_UNIT_PROMOTION condition itself (`vulnerable_promote`
   remains an opaque caller-supplied bool, unchanged from v3); and any
   claim that a v4 tier correctly predicts real flooding -- see the
   proposal's own falsifier, unchanged by this addition. This file's v4
   claim is only: given a 7-component coverage vector, a fixed promoter
   list already reduced to (id, requires, fires, level), the ledger
   inputs, and the vulnerable-unit flag, the mode-aware tier readout is
   a single total, decidable record value, monotone in the coverage
   vector for promoter inputs (Theorem full_tier_v4_promoter_monotone)
   and never lower in FULL mode than the PARTIAL tier the same promoter
   inputs would give (Theorem full_tier_v4_full_ge_partial), with LR
   still dominating every other input exactly as in v2/v3.
   ---------------------------------------------------------------------- *)

(* ========================================================================
   v5 ADDITION -- LEADING promoters (upstream rise-rate, basin rain
   accumulation, forecast rain), declared travel time tau_up, per-unit
   calibration, and hysteresis/persistence.  PROP-FLOOD-06.v5.
   ======================================================================== *)

(* ------------------------------------------------------------------
   1. Ten-component coverage vector cov5(U), by EMBEDDING v4's 7-field
      `coverage_vector` (reused unchanged, per Toledo-first reuse
      discipline) plus the 3 new leading components.
   ------------------------------------------------------------------ *)

Inductive input_kind_v5 : Set :=
  | IK5_base (k : input_kind)
  | IK5_upstream_rise_rate
  | IK5_basin_rain_accum
  | IK5_forecast_rain_72h.

Theorem input_kind_v5_eq_dec : forall x y : input_kind_v5, {x = y} + {x <> y}.
Proof. decide equality. apply input_kind_eq_dec. Qed.

Record coverage_vector_v5 := mkCovV5 {
  cv5_base                 : coverage_vector;
  cv5_upstream_rise_rate    : bool;
  cv5_basin_rain_accum      : bool;
  cv5_forecast_rain_72h     : bool
}.

Definition all_input_kinds_v5 : list input_kind_v5 :=
  map IK5_base all_input_kinds
  ++ IK5_upstream_rise_rate :: IK5_basin_rain_accum :: IK5_forecast_rain_72h :: nil.

Definition coverage_total_v5 : nat := 10%nat.

Theorem coverage_total_v5_is_10 : coverage_total_v5 = 10%nat.
Proof. reflexivity. Qed.

Theorem coverage_total_v5_ge_9 : (coverage_total_v5 >= 9)%nat.
Proof. unfold coverage_total_v5. lia. Qed.

Theorem coverage_total_v5_eq_all_kinds_v5_length :
  coverage_total_v5 = length all_input_kinds_v5.
Proof. reflexivity. Qed.

Definition cov5_get (cv5 : coverage_vector_v5) (k : input_kind_v5) : bool :=
  match k with
  | IK5_base k' => cov_get (cv5_base cv5) k'
  | IK5_upstream_rise_rate => cv5_upstream_rise_rate cv5
  | IK5_basin_rain_accum => cv5_basin_rain_accum cv5
  | IK5_forecast_rain_72h => cv5_forecast_rain_72h cv5
  end.

Definition cov5_present_kinds (cv5 : coverage_vector_v5) : list input_kind_v5 :=
  filter (fun k => cov5_get cv5 k) all_input_kinds_v5.

Definition cov5_missing_kinds (cv5 : coverage_vector_v5) : list input_kind_v5 :=
  filter (fun k => negb (cov5_get cv5 k)) all_input_kinds_v5.

Definition coverage_present_v5 (cv5 : coverage_vector_v5) : nat :=
  ( coverage_present (cv5_base cv5)
  + bool_to_nat (cv5_upstream_rise_rate cv5)
  + bool_to_nat (cv5_basin_rain_accum cv5)
  + bool_to_nat (cv5_forecast_rain_72h cv5) )%nat.

Theorem coverage_present_v5_le_total :
  forall cv5 : coverage_vector_v5, (coverage_present_v5 cv5 <= coverage_total_v5)%nat.
Proof.
  intro cv5. unfold coverage_present_v5, coverage_total_v5.
  pose proof (coverage_present_le_total (cv5_base cv5)) as Hb.
  unfold coverage_total in Hb.
  destruct (cv5_upstream_rise_rate cv5), (cv5_basin_rain_accum cv5), (cv5_forecast_rain_72h cv5);
  simpl; lia.
Qed.

Definition cov5_all_absent (cv5 : coverage_vector_v5) : bool :=
  Nat.eqb (coverage_present_v5 cv5) 0%nat.

Lemma exists_true_component_v5 :
  forall cv5 : coverage_vector_v5, coverage_present_v5 cv5 <> 0%nat -> exists k, cov5_get cv5 k = true.
Proof.
  intros cv5 Hne.
  destruct (cv5_upstream_rise_rate cv5) eqn:E1. { exists IK5_upstream_rise_rate; exact E1. }
  destruct (cv5_basin_rain_accum cv5) eqn:E2. { exists IK5_basin_rain_accum; exact E2. }
  destruct (cv5_forecast_rain_72h cv5) eqn:E3. { exists IK5_forecast_rain_72h; exact E3. }
  destruct (Nat.eqb (coverage_present (cv5_base cv5)) 0) eqn:E4.
  - exfalso. apply Hne. unfold coverage_present_v5, bool_to_nat.
    rewrite E1, E2, E3. apply Nat.eqb_eq in E4. rewrite E4. reflexivity.
  - apply Nat.eqb_neq in E4.
    destruct (exists_true_component (cv5_base cv5) E4) as [k Hk].
    exists (IK5_base k). simpl. exact Hk.
Qed.

Lemma coverage_present_v5_pos_of_true :
  forall cv5 k, cov5_get cv5 k = true -> coverage_present_v5 cv5 <> 0%nat.
Proof.
  intros cv5 k Hk.
  destruct k as [k' | | | ]; simpl in Hk; unfold coverage_present_v5, bool_to_nat.
  - pose proof (coverage_present_pos_of_true (cv5_base cv5) k' Hk) as Hb.
    lia.
  - rewrite Hk. simpl. lia.
  - rewrite Hk. simpl. lia.
  - rewrite Hk. simpl. lia.
Qed.

Lemma cov5_all_absent_false_mono :
  forall cv1 cv2 : coverage_vector_v5, cov5_all_absent cv1 = false ->
    (forall k, cov5_get cv1 k = true -> cov5_get cv2 k = true) ->
    cov5_all_absent cv2 = false.
Proof.
  intros cv1 cv2 H1 Hmono.
  unfold cov5_all_absent in *.
  apply Nat.eqb_neq. apply Nat.eqb_neq in H1.
  destruct (exists_true_component_v5 cv1 H1) as [k Hk].
  apply Hmono in Hk.
  eapply coverage_present_v5_pos_of_true; eauto.
Qed.

(* ------------------------------------------------------------------
   2. Leading promoters (new promoter_id_v5 constructors + promoter_v5
      record over input_kind_v5), reusing `promoter_max`/`max_level6`/
      `promote_one` UNCHANGED (Toledo-first reuse: no new max/promotion
      primitive is derived, only the missing piece -- 3 new promoter
      rows -- is added).
   ------------------------------------------------------------------ *)

Inductive promoter_id_v5 : Set :=
  | P5_base (p : promoter_id)
  | P5_UPSTREAM_RISE_RATE_EXCEEDS
  | P5_BASIN_RAIN_ACCUM_EXCEEDS
  | P5_FORECAST_RAIN_72H_EXCEEDS.

Theorem promoter_id_v5_eq_dec : forall x y : promoter_id_v5, {x = y} + {x <> y}.
Proof. decide equality. apply promoter_id_eq_dec. Qed.

Record promoter_v5 := mkPromoterV5 {
  p5_id       : promoter_id_v5;
  p5_requires : input_kind_v5;
  p5_fires    : bool;
  p5_level    : tier_level6
}.

Definition promoter_applies_v5 (cv5 : coverage_vector_v5) (p5 : promoter_v5) : bool :=
  andb (cov5_get cv5 (p5_requires p5)) (p5_fires p5).

Definition promoters_v5_that_apply (cv5 : coverage_vector_v5) (ps : list promoter_v5) : list promoter_v5 :=
  filter (promoter_applies_v5 cv5) ps.

(* ------------------------------------------------------------------
   3. readout_v5 -- SAME shape as v4's `readout` record plus the two
      new fields (`calibrated`, `lead_time_h`).  v4's `readout` type
      itself is UNCHANGED; this is a fresh, additive record, not a
      replacement (Coq has no record subtyping/inheritance, so an
      "extension" is expressed as a new record with the same field
      shape plus the delta).
   ------------------------------------------------------------------ *)

Record readout_v5 := mkReadoutV5 {
  tier_v5                     : tier_level6;
  mode_v5                     : mode3;
  readout_coverage_present_v5 : nat;   (* 0..10 *)
  readout_coverage_total_v5   : nat;   (* always 10 *)
  based_on_v5                 : list input_kind_v5;
  missing_v5                  : list input_kind_v5;
  promoters_fired_v5          : list promoter_id_v5;
  calibrated                  : bool;
  lead_time_h                 : option Q
}.

Theorem Q_eq_dec : forall x y : Q, {x = y} + {x <> y}.
Proof.
  intros x y. decide equality.
  - apply Pos.eq_dec.
  - apply Z.eq_dec.
Qed.

Theorem option_Q_eq_dec : forall x y : option Q, {x = y} + {x <> y}.
Proof. decide equality. apply Q_eq_dec. Qed.

Theorem readout_v5_eq_dec : forall x y : readout_v5, {x = y} + {x <> y}.
Proof.
  decide equality.
  - apply option_Q_eq_dec.
  - apply Bool.bool_dec.
  - apply (list_eq_dec promoter_id_v5_eq_dec).
  - apply (list_eq_dec input_kind_v5_eq_dec).
  - apply (list_eq_dec input_kind_v5_eq_dec).
  - apply Nat.eq_dec.
  - apply Nat.eq_dec.
  - apply mode3_eq_dec.
  - apply tier_level6_eq_dec.
Qed.

(* ------------------------------------------------------------------
   4. full_tier_v5 -- the single top-level entry point for v5, same
      band-then-promoter-floor-then-vulnerable-then-LR order as v4's
      `full_tier_v4`, over the widened vector and the CONCATENATED
      base+leading promoter lists.
   ------------------------------------------------------------------ *)

Definition full_tier_v5
  (cv5 : coverage_vector_v5)
  (ledger_resolves vulnerable_promote : bool)
  (D R F s : Q) (t : option Q)
  (promoters_base : list promoter)
  (promoters_leading : list promoter_v5)
  (calibrated_flag : bool)
  (lead_time : option Q)
  : readout_v5 :=
  let band := if ledger_resolves then full_tier false D R F s t else T_L0 in
  let applies_base :=
    map (fun p => (andb (cov_get (cv5_base cv5) (p_requires p)) (p_fires p), p_level p))
        promoters_base in
  let applies_leading :=
    map (fun p5 => (promoter_applies_v5 cv5 p5, p5_level p5)) promoters_leading in
  let pm := promoter_max (applies_base ++ applies_leading) in
  let base_tier := max_level6 band pm in
  let promoted := if vulnerable_promote then promote_one base_tier else base_tier in
  let cov_absent := cov5_all_absent cv5 in
  let final_tier := if cov_absent then T_LR else promoted in
  let final_mode :=
    if cov_absent then M_LR
    else if ledger_resolves then M_FULL else M_PARTIAL in
  {| tier_v5 := final_tier;
     mode_v5 := final_mode;
     readout_coverage_present_v5 := coverage_present_v5 cv5;
     readout_coverage_total_v5 := coverage_total_v5;
     based_on_v5 := cov5_present_kinds cv5;
     missing_v5 := cov5_missing_kinds cv5;
     promoters_fired_v5 :=
       map (fun p => P5_base (p_id p))
           (filter (fun p => andb (cov_get (cv5_base cv5) (p_requires p)) (p_fires p)) promoters_base)
       ++ map p5_id (filter (promoter_applies_v5 cv5) promoters_leading);
     calibrated := calibrated_flag;
     lead_time_h := lead_time |}.

Theorem full_tier_v5_total :
  forall (cv5 : coverage_vector_v5) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q)
         (promoters_base : list promoter) (promoters_leading : list promoter_v5)
         (calibrated_flag : bool) (lead_time : option Q),
    exists r : readout_v5,
      full_tier_v5 cv5 ledger_resolves vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time = r.
Proof. intros. eexists. reflexivity. Qed.

Theorem full_tier_v5_coverage_total_is_10 :
  forall (cv5 : coverage_vector_v5) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q)
         (promoters_base : list promoter) (promoters_leading : list promoter_v5)
         (calibrated_flag : bool) (lead_time : option Q),
    readout_coverage_total_v5
      (full_tier_v5 cv5 ledger_resolves vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time)
    = 10%nat.
Proof. intros. reflexivity. Qed.

Theorem full_tier_v5_coverage_present_le_10 :
  forall (cv5 : coverage_vector_v5) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q)
         (promoters_base : list promoter) (promoters_leading : list promoter_v5)
         (calibrated_flag : bool) (lead_time : option Q),
    (readout_coverage_present_v5
      (full_tier_v5 cv5 ledger_resolves vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time)
     <= 10)%nat.
Proof. intros. simpl. apply coverage_present_v5_le_total. Qed.

Theorem full_tier_v5_LR_iff_coverage_present_0 :
  forall (cv5 : coverage_vector_v5) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q)
         (promoters_base : list promoter) (promoters_leading : list promoter_v5)
         (calibrated_flag : bool) (lead_time : option Q),
    mode_v5 (full_tier_v5 cv5 ledger_resolves vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time) = M_LR
    <-> readout_coverage_present_v5 (full_tier_v5 cv5 ledger_resolves vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time) = 0%nat.
Proof.
  intros. unfold full_tier_v5, cov5_all_absent. simpl.
  destruct (Nat.eqb (coverage_present_v5 cv5) 0%nat) eqn:E.
  - apply Nat.eqb_eq in E. split; intro; [exact E | reflexivity].
  - apply Nat.eqb_neq in E.
    destruct ledger_resolves, vulnerable_promote; simpl;
    split; intro H; try discriminate; try (exfalso; apply E; exact H).
Qed.

(* ------------------------------------------------------------------
   5. MONOTONICITY (v4-style), extended to the widened vector and the
      concatenated base+leading promoter list.
   ------------------------------------------------------------------ *)

Lemma promoters_mono_app :
  forall ps1 ps2 qs1 qs2,
    promoters_mono ps1 ps2 -> promoters_mono qs1 qs2 ->
    promoters_mono (ps1 ++ qs1) (ps2 ++ qs2).
Proof.
  intros ps1 ps2 qs1 qs2 H1 H2.
  induction H1 as [| b1 b2 l ps1' ps2' Himp Hmono IH].
  - simpl. exact H2.
  - simpl. constructor; [exact Himp | exact IH].
Qed.

Lemma applies_base_mono_v5 :
  forall (cv1 cv2 : coverage_vector) (ps : list promoter),
    (forall k, cov_get cv1 k = true -> cov_get cv2 k = true) ->
    promoters_mono (map (fun p => (andb (cov_get cv1 (p_requires p)) (p_fires p), p_level p)) ps)
                   (map (fun p => (andb (cov_get cv2 (p_requires p)) (p_fires p), p_level p)) ps).
Proof.
  intros cv1 cv2 ps Hmono.
  induction ps as [| p ps' IH].
  - simpl. constructor.
  - simpl. constructor.
    + intro Hp1. apply andb_true_iff in Hp1 as [Hc Hf].
      apply andb_true_iff. split; [apply Hmono; exact Hc | exact Hf].
    + exact IH.
Qed.

Lemma applies_leading_mono_v5 :
  forall (cv1 cv2 : coverage_vector_v5) (ps : list promoter_v5),
    (forall k, cov5_get cv1 k = true -> cov5_get cv2 k = true) ->
    promoters_mono (map (fun p => (promoter_applies_v5 cv1 p, p5_level p)) ps)
                   (map (fun p => (promoter_applies_v5 cv2 p, p5_level p)) ps).
Proof.
  intros cv1 cv2 ps Hmono.
  induction ps as [| p ps' IH].
  - simpl. constructor.
  - simpl. constructor.
    + intro Hp1. unfold promoter_applies_v5 in *. apply andb_true_iff in Hp1 as [Hc Hf].
      apply andb_true_iff. split; [apply Hmono; exact Hc | exact Hf].
    + exact IH.
Qed.

Theorem full_tier_v5_promoter_monotone :
  forall (cv1 cv2 : coverage_vector_v5) (ledger_resolves vulnerable_promote : bool)
         (D R F s : Q) (t : option Q)
         (promoters_base : list promoter) (promoters_leading : list promoter_v5)
         (calibrated_flag : bool) (lead_time : option Q),
    cov5_all_absent cv1 = false ->
    (forall k, cov5_get cv1 k = true -> cov5_get cv2 k = true) ->
    (level6_to_nat (tier_v5 (full_tier_v5 cv1 ledger_resolves vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time))
     <= level6_to_nat (tier_v5 (full_tier_v5 cv2 ledger_resolves vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time)))%nat.
Proof.
  intros cv1 cv2 ledger_resolves vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time Habs1 Hmono5.
  assert (Habs2 : cov5_all_absent cv2 = false) by (eapply cov5_all_absent_false_mono; eauto).
  unfold full_tier_v5, tier_v5. simpl.
  rewrite Habs1, Habs2.
  apply promote_one_mono_if.
  apply max_level6_mono_r.
  apply promoter_max_monotone.
  apply promoters_mono_app.
  - apply applies_base_mono_v5. intros k Hk. specialize (Hmono5 (IK5_base k)). simpl in Hmono5. apply Hmono5. exact Hk.
  - apply applies_leading_mono_v5. exact Hmono5.
Qed.

Theorem full_tier_v5_full_ge_partial :
  forall (cv5 : coverage_vector_v5) (vulnerable_promote : bool)
         (D R F s : Q) (t : option Q)
         (promoters_base : list promoter) (promoters_leading : list promoter_v5)
         (calibrated_flag : bool) (lead_time : option Q),
    cov5_all_absent cv5 = false ->
    (level6_to_nat (tier_v5 (full_tier_v5 cv5 false vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time))
     <= level6_to_nat (tier_v5 (full_tier_v5 cv5 true vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time)))%nat.
Proof.
  intros cv5 vulnerable_promote D R F s t promoters_base promoters_leading calibrated_flag lead_time Habs.
  unfold full_tier_v5, tier_v5. simpl.
  rewrite Habs.
  apply promote_one_mono_if.
  apply max_level6_mono_l.
  simpl. apply Nat.le_0_l.
Qed.

(* ------------------------------------------------------------------
   6. Hysteresis / persistence (false-alarm control): a raise must hold
      for `p` consecutive raw hourly readouts, a step-down for `q`.
      FALSIFIER-RELEVANT GUARANTEE: persistence never fabricates a
      tier absent from the raw history -- `persisted_is_some_historical_raw`.
   ------------------------------------------------------------------ *)

Fixpoint recent_raw_ge (raw : nat -> tier_level6) (n p : nat) (L : tier_level6) : bool :=
  match p with
  | 0%nat => true
  | S p' =>
    andb (Nat.leb (level6_to_nat L) (level6_to_nat (raw n)))
      (match n with
       | 0%nat => Nat.eqb p' 0%nat
       | S n' => recent_raw_ge raw n' p' L
       end)
  end.

Fixpoint recent_raw_le (raw : nat -> tier_level6) (n q : nat) (L : tier_level6) : bool :=
  match q with
  | 0%nat => true
  | S q' =>
    andb (Nat.leb (level6_to_nat (raw n)) (level6_to_nat L))
      (match n with
       | 0%nat => Nat.eqb q' 0%nat
       | S n' => recent_raw_le raw n' q' L
       end)
  end.

Definition tier_level6_eqb (a b : tier_level6) : bool :=
  Nat.eqb (level6_to_nat a) (level6_to_nat b).

Fixpoint persisted (raw : nat -> tier_level6) (p q : nat) (n : nat) : tier_level6 :=
  match n with
  | 0%nat => raw 0%nat
  | S n' =>
    let prev := persisted raw p q n' in
    let cand := raw (S n') in
    if tier_level6_eqb cand prev then prev
    else if Nat.ltb (level6_to_nat prev) (level6_to_nat cand) then
      (if recent_raw_ge raw (S n') p cand then cand else prev)
    else
      (if recent_raw_le raw (S n') q cand then cand else prev)
  end.

Theorem persisted_total :
  forall (raw : nat -> tier_level6) (p q n : nat), exists l, persisted raw p q n = l.
Proof. intros. eexists. reflexivity. Qed.

Theorem persisted_is_some_historical_raw :
  forall (raw : nat -> tier_level6) (p q n : nat),
    exists m : nat, (m <= n)%nat /\ persisted raw p q n = raw m.
Proof.
  intros raw p q n.
  induction n as [| n' IH].
  - exists 0%nat. split; [lia | reflexivity].
  - assert (Hcase : persisted raw p q (S n') = persisted raw p q n'
                    \/ persisted raw p q (S n') = raw (S n')).
    { cbn [persisted].
      destruct (tier_level6_eqb (raw (S n')) (persisted raw p q n')) eqn:Heq.
      - left. reflexivity.
      - destruct (Nat.ltb (level6_to_nat (persisted raw p q n')) (level6_to_nat (raw (S n')))).
        + destruct (recent_raw_ge raw (S n') p (raw (S n'))).
          * right. reflexivity.
          * left. reflexivity.
        + destruct (recent_raw_le raw (S n') q (raw (S n'))).
          * right. reflexivity.
          * left. reflexivity. }
    destruct Hcase as [Hprev | Hcand].
    + destruct IH as [m [Hm Heqm]]. exists m. split; [lia | rewrite Hprev; exact Heqm].
    + exists (S n'). split; [lia | exact Hcand].
Qed.

(* ---- worked examples: default p=2, q=3 ---- *)

Definition ex_raw_spike (n : nat) : tier_level6 :=
  match n with
  | 3%nat => T_L4
  | _ => T_L0
  end.

Example spike_not_immediately_raised_p2 :
  persisted ex_raw_spike 2%nat 3%nat 3%nat = T_L0.
Proof. reflexivity. Qed.

Definition ex_raw_sustained (n : nat) : tier_level6 :=
  match n with
  | 3%nat => T_L4
  | 4%nat => T_L4
  | _ => T_L0
  end.

Example sustained_rise_raised_after_p2 :
  persisted ex_raw_sustained 2%nat 3%nat 4%nat = T_L4.
Proof. reflexivity. Qed.

Definition ex_raw_drop (n : nat) : tier_level6 :=
  match n with
  | 0%nat => T_L4 | 1%nat => T_L4 | 2%nat => T_L4
  | 3%nat => T_L0
  | _ => T_L0
  end.

(* one low reading alone (n=3, q=3 needed) does not step down yet *)
Example single_drop_not_immediately_lowered_q3 :
  persisted ex_raw_drop 2%nat 3%nat 3%nat = T_L4.
Proof. reflexivity. Qed.

(* ----------------------------------------------------------------------
   WHAT THIS v5 ADDITION DOES NOT PROVE: the arithmetic promoter
   conditions themselves (`rain_24h_mm > 80`-shaped, or the new leading
   promoters' own thresholds) remain opaque caller-supplied booleans,
   unchanged in kind from v3/v4; which cov5(U) component is
   present/stale/absent (IO-shaped); tau_up(U)'s actual numeric value for
   any unit (declared OPEN-until-measured, never asserted here); that a
   confirmed upstream gauge (N.64) or an unconfirmed one named only
   conditionally (P.67/P.75, X.90/X.173-as-upstream, C.2) actually
   produces real lead time against ground truth -- that is exactly the
   next falsifier step (re-running BACKTEST_PROP_FLOOD_06_v1.md-style
   against v5), not yet executed; and calibration_procedure's own
   arithmetic (grid search, FA-rate ceiling) is a declared procedure over
   caller-supplied data, not itself formalised here. This file's v5 claim
   is only: given a 10-component coverage vector, a fixed base+leading
   promoter list, the ledger inputs, and the vulnerable-unit/calibration/
   lead-time flags, the mode-aware v5 readout is a single total,
   decidable record value, monotone in the coverage vector for promoter
   inputs and never lower in FULL mode than the PARTIAL tier the same
   promoters would give (same two-theorem shape as v4, re-proved over the
   widened vector), with LR still dominating every other input; and that
   a hysteresis/persistence layer over any raw tier sequence never
   reports a level absent from that raw sequence's own history at some
   earlier-or-same hour (`persisted_is_some_historical_raw`) -- it can
   only delay a raise/lowering, never fabricate one. `coqc -q` clean,
   `Print Assumptions` closed under the global context (no axioms) on
   every theorem in this file, v1 through v5.

   v6 TODO -- NOT YET IMPLEMENTED, per founder instruction received
   during this v5 registration (verbatim): "อย่าลืมว่าไม่มีทางมีข้อมูล
   พอ แต่ใช้การอนุมานจากข้อมูลที่แข็งแรงเป็นหลัก" (there is never enough
   data; use inference from strong-enough data as the main tool). This
   asks for a THIRD coverage state, `inferred` (besides present/absent),
   derived from declared consistency rules over connected anchors (e.g.
   "downstream reach at normal level + no pumps running + no drop for N
   hours => inner link stalled"), counted in coverage at a LOWER rank
   than `present`, always listed in `based_on` together with the anchor
   ids that licensed the inference; a new `confidence : strength` field
   on the readout carrying the ORDINAL confidence of the weakest anchor
   used; `LR` narrowed further to "nothing present AND nothing inferable"
   (not merely "nothing present"); and a THIRD monotonicity theorem,
   `inferred -> present never lowers the tier` (an inferred component
   later confirmed present must never cause a drop). This is a genuinely
   new primitive (an inference/anchor-consistency rule, not a retained
   difference or a promoter threshold) and, per this repository's own
   Toledo-first reuse gate (EQUATION_SOURCE_POLICY.md TG-RFG-01), it
   needs its own Toledo lookup / Genesis-compatibility pass before being
   derived and formalised -- it is deliberately NOT rushed into this v5
   commit. Recorded here, in the JSON's honest_caveats, and in the MD as
   the explicit next version's scope; v5's existing `present`/`absent`
   two-state cov5(U) and its coverage/promoter/monotonicity apparatus are
   unaffected and remain valid as declared. *)
