(* ===================================================================== *)
(*  PROP_FLOOD_06_outlet_coping_tier.v                                   *)
(*  Area-generic outlet-headroom / drainage-coping tier-ladder function   *)
(*  (Toledo proposal PROP-FLOOD-06.v3, code weld/M.??.v1, proposals-lane, *)
(*  not yet canonicalized -- see registry/LINEAGE.jsonl code PROP-FLOOD-06)*)
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
