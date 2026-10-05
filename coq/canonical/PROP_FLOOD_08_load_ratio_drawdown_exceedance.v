(* ===================================================================== *)
(*  PROP_FLOOD_08_load_ratio_drawdown_exceedance.v                        *)
(*  Load-to-capacity ratio L against the owner's design depth declared   *)
(*  PER WINDOW (1 h, 24 h, ...; undeclared window REFUSED, no pro-rating),*)
(*  per model, worst first, interval form; storage exceedance             *)
(*  E_k = max(0, S_k - S_safe),                                           *)
(*  drawdown time T_dd = V / Q_out (a lower bound), and the capacity      *)
(*  reduction factor eta (absent until fitted), each with refusal.       *)
(*  (Toledo proposal PROP-FLOOD-08.v1.2, code weld/M.??.v1, proposals-lane, *)
(*  not yet canonicalized -- see registry/LINEAGE.jsonl code             *)
(*  PROP-FLOOD-08.)  NEW DERIVATION / PROPOSAL -- not yet in Toledo.      *)
(*                                                                         *)
(*  Parents (read, not keyword-matched): PROP-FLOOD-03 (state S_k, rates, *)
(*  refusal codes -- reused verbatim as the r03 type below), PROP-FLOOD-06*)
(*  v6.1 (S_H = F_H / C_H; multi_model_scenarios worst first, never       *)
(*  averaged; c_U bound pair; g_U(t) derating; running-pump count;        *)
(*  calibration_procedure), PROP-FLOOD-10a (monotone endpoint enclosure,  *)
(*  imported below: E_k monotonicity IS 10a excess_sigma_monotone; the    *)
(*  interval form of L is a direct proof in the same form as 10a, not a   *)
(*  corollary -- review A1), delta_R (every exceedance is a               *)
(*  retained difference against a declared constant), A2/M.12-14.v1       *)
(*  (fold-max: the worst model bounds every model and is attained).       *)
(*                                                                         *)
(*  Sign warning kept on purpose: in international hydrology usage a     *)
(*  "storage deficit" is AVAILABLE storage (free room), the opposite sign *)
(*  of E_k.  E_k is an EXCESS; see exceedance_zero_when_room_available.   *)
(*  "Water debt" is a public label for E_k only, never a second object.   *)
(* ===================================================================== *)

Require Import QArith.
Require Import Coq.QArith.Qminmax.
Require Import Coq.micromega.Lqa.
Require Import Coq.Lists.List.
Require Import Lia.
Import ListNotations.
From IDM.formal Require Import IDM_ReadoutMinimality.
From MRC Require Import PROP_FLOOD_10_enclosure_nested_box.

Local Open Scope Q_scope.

(* ------------------------------------------------------------------
   0. Refusal vocabulary.  PROP-FLOOD-03's five codes are reused
      verbatim (r03) and take precedence; 08 adds only its own four.
   ------------------------------------------------------------------ *)

Inductive r03 : Set :=
  | MISSING_INPUT | STALE_INPUT | UNDECLARED_AREA | UNDECLARED_EDGE | NEGATIVE_STORAGE.

Inductive r08 : Set :=
  | Inherited03 : r03 -> r08
  | SAFE_STORAGE_UNDECLARED
  | DATUM_UNDECLARED
  | DESIGN_DEPTH_UNDECLARED
  | ZERO_OUTFLOW
  | ETA_OUT_OF_RANGE.        (* v1.2: a fitted eta outside (0,1], review R2-A8 *)

Inductive res (A : Type) : Type :=
  | Ok : A -> res A
  | Refused : r08 -> res A.
Arguments Ok {A} _.
Arguments Refused {A} _.

Definition Qltb (a b : Q) : bool := negb (Qle_bool b a).

Lemma Qltb_iff : forall a b, Qltb a b = true <-> a < b.
Proof.
  intros a b. unfold Qltb. rewrite Bool.negb_true_iff. split.
  - intros H. apply Qnot_le_lt. intro C. apply Qle_bool_iff in C. congruence.
  - intros H. apply Bool.not_true_iff_false. intro C. apply Qle_bool_iff in C. lra.
Qed.

(* a PROP-FLOOD-03 state readout: a value, or 03's own refusal *)
Inductive state03 : Type :=
  | S03 : Q -> state03
  | Refused03 : r03 -> state03.

(* ------------------------------------------------------------------
   1. Storage exceedance E_k := max(0, S_k - S_safe)
      = PROP-FLOOD-10a `excess` on ONE declared unit/datum.
   ------------------------------------------------------------------ *)

Definition storage_exceedance (Sk : state03) (S_safe : option Q) (same_unit_datum : bool)
  : res Q :=
  match Sk with
  | Refused03 r => Refused (Inherited03 r)             (* 03 codes first *)
  | S03 s =>
      if Qltb s 0 then Refused (Inherited03 NEGATIVE_STORAGE)   (* v1.1 guard, review A8 *)
      else
      match S_safe with
      | None => Refused SAFE_STORAGE_UNDECLARED
      | Some r => if same_unit_datum then Ok (excess s r) else Refused DATUM_UNDECLARED
      end
  end.

Theorem exceedance_refused_when_safe_undeclared :
  forall s b, 0 <= s -> storage_exceedance (S03 s) None b = Refused SAFE_STORAGE_UNDECLARED.
Proof.
  intros s b Hs. unfold storage_exceedance.
  destruct (Qltb s 0) eqn:E; [apply Qltb_iff in E; lra | reflexivity].
Qed.

(* a numeric negative state is refused, never clipped to 0 (review A8) *)
Theorem exceedance_refuses_negative_numeric :
  forall s o b, s < 0 -> storage_exceedance (S03 s) o b = Refused (Inherited03 NEGATIVE_STORAGE).
Proof.
  intros s o b Hs. unfold storage_exceedance.
  rewrite (proj2 (Qltb_iff s 0) Hs). reflexivity.
Qed.

Theorem exceedance_inherits_03_refusal :
  forall r o b, storage_exceedance (Refused03 r) o b = Refused (Inherited03 r).
Proof. reflexivity. Qed.

(* a NEGATIVE_STORAGE ledger is never clipped to 0 by the positive part:
   the refusal passes through untouched *)
Corollary exceedance_never_clips_negative_ledger :
  forall o b, storage_exceedance (Refused03 NEGATIVE_STORAGE) o b
              = Refused (Inherited03 NEGATIVE_STORAGE).
Proof. reflexivity. Qed.

Theorem exceedance_refused_when_datum_differs :
  forall s r, 0 <= s -> storage_exceedance (S03 s) (Some r) false = Refused DATUM_UNDECLARED.
Proof.
  intros s r Hs. unfold storage_exceedance.
  destruct (Qltb s 0) eqn:E; [apply Qltb_iff in E; lra | reflexivity].
Qed.

Theorem exceedance_ok_iff :
  forall Sk o b e,
    storage_exceedance Sk o b = Ok e <->
    exists s r, Sk = S03 s /\ 0 <= s /\ o = Some r /\ b = true /\ e = excess s r.
Proof.
  intros Sk o b e. split.
  - destruct Sk as [s|r]; simpl; [|discriminate].
    destruct (Qltb s 0) eqn:E; [discriminate|].
    destruct o as [r|]; [|discriminate].
    destruct b; [|discriminate]. intros H; inversion H; subst.
    exists s, r. split; [reflexivity|]. split.
    + apply Qnot_lt_le. intro C. apply Qltb_iff in C. congruence.
    + auto.
  - intros [s [r [-> [Hs [-> [-> ->]]]]]]. simpl.
    destruct (Qltb s 0) eqn:E; [apply Qltb_iff in E; lra | reflexivity].
Qed.

Theorem exceedance_nonneg :
  forall Sk o b e, storage_exceedance Sk o b = Ok e -> 0 <= e.
Proof.
  intros Sk o b e H. apply exceedance_ok_iff in H.
  destruct H as [s [r [_ [_ [_ [_ ->]]]]]]. apply excess_nonneg.
Qed.

(* sign warning, formal: whenever there is available room (the
   "storage deficit" of international usage, S_safe - S_k > 0), the
   exceedance is 0 -- the two are opposite-signed readouts, not synonyms,
   and E_k = 0 means "no exceedance", not "safe". *)
Theorem exceedance_zero_when_room_available :
  forall s r, 0 < r - s -> excess s r == 0.
Proof.
  intros s r H. unfold excess.
  rewrite Q.max_l; [reflexivity|lra].
Qed.

(* monotonicity: non-decreasing in S_k, non-increasing in S_safe
   (an occurrence of 10a excess_sigma_monotone) *)
Theorem exceedance_monotone :
  forall s1 s2 r1 r2, s1 <= s2 -> r2 <= r1 -> excess s1 r1 <= excess s2 r2.
Proof.
  intros s1 s2 r1 r2 Hs Hr.
  apply (excess_sigma_monotone
           (fun i => match i with O => s1 | _ => r1 end)
           (fun i => match i with O => s2 | _ => r2 end)).
  intros i Hi. destruct i as [|[|i]]; simpl; [exact Hs|exact Hr|lia].
Qed.

(* ------------------------------------------------------------------
   2. Rational helpers (finite Q division by a positive declared value).
   ------------------------------------------------------------------ *)



Lemma div_le_num : forall a b d, 0 < d -> a <= b -> a / d <= b / d.
Proof.
  intros a b d Hd Hab. unfold Qdiv. apply Qmult_le_compat_r; [exact Hab|].
  apply Qlt_le_weak. apply Qinv_lt_0_compat. exact Hd.
Qed.

Lemma div_nonneg : forall a d, 0 <= a -> 0 < d -> 0 <= a / d.
Proof.
  intros a d Ha Hd. unfold Qdiv. apply Qmult_le_0_compat; [exact Ha|].
  apply Qlt_le_weak. apply Qinv_lt_0_compat. exact Hd.
Qed.

Lemma div_le_den : forall a d1 d2, 0 <= a -> 0 < d1 -> d1 <= d2 -> a / d2 <= a / d1.
Proof.
  intros a d1 d2 Ha Hd1 Hd12.
  assert (Hd2 : 0 < d2) by lra.
  apply Qle_shift_div_l; [exact Hd1|].
  apply Qle_trans with ((a / d2) * d2).
  - apply Qmult_le_compat_nonneg; split; try lra.
    apply div_nonneg; assumption.
  - assert (E : (a / d2) * d2 == a) by (field; lra).
    rewrite E. apply Qle_refl.
Qed.

(* ------------------------------------------------------------------
   3. Load-to-capacity ratio, design capacity C_des_H(U) (08-local; in
      place of 06's C_H, not a case of 06's case split), with the design
      depth declared PER WINDOW by the node owner:
        D_design(U, w)  for each declared window w (hours) -- a finite
                        table, e.g. Bangkok: w=1 -> 58.7 mm, w=24 -> 80 mm
                        (BMA drainage plan 2569 p.63, both VERIFIED
                        downstream);
        C_des_H(U) := D_design(U, H) * A_U     only if H is a declared window
        L^m_H(U) := (c_U * P^m_H + E_k / A_U) / D_design(U, H)
      A window WITHOUT an owner-declared depth is REFUSED
      DESIGN_DEPTH_UNDECLARED.  There is NO pro-rating between windows
      (no H/24 factor): the v0 draft's C_H (now this object's C_des_H)
      := (H/24) * D_design gave 80/24 = 3.33 mm at H = 1 h against the
      owner's own 58.7 mm, and bridged durations, which the downstream
      conversion rule R2 forbids.
      Per named model m; worst first; never averaged.  A missing E_k gives
      the rain-only ratio, reported as a MINIMUM (proved below).
   ------------------------------------------------------------------ *)

(* owner-declared (window hours, depth) pairs *)
Definition design_table := list (nat * Q).

Fixpoint design_lookup (tbl : design_table) (H : nat) : option Q :=
  match tbl with
  | [] => None
  | (w, d) :: rest => if Nat.eqb w H then Some d else design_lookup rest H
  end.

Definition design_depth (tbl : design_table) (H : nat) : res Q :=
  match design_lookup tbl H with
  | Some d => if Qltb 0 d then Ok d else Refused DESIGN_DEPTH_UNDECLARED
  | None => Refused DESIGN_DEPTH_UNDECLARED
  end.

Lemma design_lookup_in :
  forall tbl H d, design_lookup tbl H = Some d -> In (H, d) tbl.
Proof.
  induction tbl as [|[w d'] rest IH]; intros H d Hl; simpl in Hl; [discriminate|].
  destruct (Nat.eqb w H) eqn:E.
  - apply Nat.eqb_eq in E. subst. injection Hl as <-. left. reflexivity.
  - right. apply IH. exact Hl.
Qed.

Lemma design_lookup_none :
  forall tbl H, design_lookup tbl H = None -> forall d, ~ In (H, d) tbl.
Proof.
  induction tbl as [|[w d'] rest IH]; intros H Hl d Hin; [destruct Hin|].
  simpl in Hl. destruct (Nat.eqb w H) eqn:E; [discriminate|].
  destruct Hin as [Heq | Hin].
  - injection Heq as -> _. rewrite Nat.eqb_refl in E. discriminate.
  - exact (IH H Hl d Hin).
Qed.

(* ---- THEOREM: capacity is defined ONLY at a declared window; its value
   is the owner's own declared depth for exactly that window. *)
Theorem design_depth_only_at_declared_window :
  forall tbl H d, design_depth tbl H = Ok d -> In (H, d) tbl /\ 0 < d.
Proof.
  intros tbl H d Hd. unfold design_depth in Hd.
  destruct (design_lookup tbl H) as [d'|] eqn:El; [|discriminate].
  destruct (Qltb 0 d') eqn:Ep; [|discriminate]. injection Hd as <-.
  split; [apply design_lookup_in; exact El | apply Qltb_iff; exact Ep].
Qed.

(* ---- THEOREM: a window with no declared depth is REFUSED, whatever
   depths are declared for OTHER windows (no pro-rating, no bridging). *)
Theorem design_depth_refused_when_window_undeclared :
  forall tbl H, (forall d, ~ In (H, d) tbl) ->
    design_depth tbl H = Refused DESIGN_DEPTH_UNDECLARED.
Proof.
  intros tbl H Hno. unfold design_depth.
  destruct (design_lookup tbl H) as [d|] eqn:El; [|reflexivity].
  exfalso. apply (Hno d). apply design_lookup_in. exact El.
Qed.

(* the declared Bangkok table (boundary data, owner-published) *)
Definition bma_design_2569 : design_table := [(1%nat, 587 # 10); (24%nat, 80)].

Example bma_1h_declared : design_depth bma_design_2569 1 = Ok (587 # 10).
Proof. reflexivity. Qed.

Example bma_24h_declared : design_depth bma_design_2569 24 = Ok 80.
Proof. reflexivity. Qed.

Example bma_3h_refused :
  design_depth bma_design_2569 3 = Refused DESIGN_DEPTH_UNDECLARED.
Proof. reflexivity. Qed.

(* the retired v0 draft pro-rating contradicted the owner at H = 1 *)
Example draft_prorating_contradicts_owner :
  ~ ((1 # 24) * 80 == 587 # 10).
Proof. unfold Qeq. simpl. lia. Qed.

Definition load_ratio (Dd c P E A : Q) : Q := (c * P + E / A) / Dd.

Definition load_ratio_rain_only (Dd c P : Q) : Q := (c * P) / Dd.

(* guarded entry point (v1.1, review A8): the depth must be declared for
   exactly this window and positive, and the area must be positive *)
Definition load_ratio_checked (tbl : design_table) (H : nat) (c P E A : Q) : res Q :=
  match design_depth tbl H with
  | Refused r => Refused r
  | Ok d => if Qltb 0 A then Ok (load_ratio d c P E A) else Refused (Inherited03 UNDECLARED_AREA)
  end.

Theorem load_ratio_checked_ok :
  forall tbl H c P E A l,
    load_ratio_checked tbl H c P E A = Ok l ->
    exists d, In (H, d) tbl /\ 0 < d /\ 0 < A /\ l = load_ratio d c P E A.
Proof.
  intros tbl H c P E A l Hl. unfold load_ratio_checked in Hl.
  destruct (design_depth tbl H) as [d|r] eqn:Ed; [|discriminate].
  destruct (Qltb 0 A) eqn:EA; [|discriminate]. injection Hl as <-.
  destruct (design_depth_only_at_declared_window tbl H d Ed) as [Hin Hd].
  exists d. split; [exact Hin|]. split; [exact Hd|]. split; [apply Qltb_iff; exact EA | reflexivity].
Qed.

Theorem load_ratio_checked_refuses_undeclared_window :
  forall tbl H c P E A, (forall d, ~ In (H, d) tbl) ->
    load_ratio_checked tbl H c P E A = Refused DESIGN_DEPTH_UNDECLARED.
Proof.
  intros. unfold load_ratio_checked.
  rewrite design_depth_refused_when_window_undeclared by assumption. reflexivity.
Qed.

(* rain-only is a LOWER bound on the full ratio (E_k >= 0, A_U > 0) *)
Theorem rain_only_is_lower_bound :
  forall Dd c P E A, 0 < Dd -> 0 <= E -> 0 < A ->
    load_ratio_rain_only Dd c P <= load_ratio Dd c P E A.
Proof.
  intros Dd c P E A HD HE HA. unfold load_ratio_rain_only, load_ratio.
  apply div_le_num; [exact HD|].
  assert (0 <= E / A) by (apply div_nonneg; assumption). lra.
Qed.

(* interval form: a direct proof in the same form as the 10a enclosure
   (not a corollary of it -- review A1), stated on the
   declared box P in [Plo,Phi] >= 0, c in [clo,chi] >= 0, E in [Elo,Ehi]
   >= 0, and the SAME window's declared depth D in [Dlo,Dhi] > 0.  L is
   non-decreasing in P, c, E and non-increasing in D, so its range runs
   from L at the lower corner to L at the upper corner. *)
Theorem load_ratio_enclosure :
  forall A Plo P Phi clo c chi Elo E Ehi Dlo Dd Dhi,
    0 < A ->
    0 <= Plo -> Plo <= P <= Phi -> 0 <= clo -> clo <= c <= chi ->
    0 <= Elo -> Elo <= E <= Ehi -> 0 < Dlo -> Dlo <= Dd <= Dhi ->
    load_ratio Dhi clo Plo Elo A <= load_ratio Dd c P E A /\
    load_ratio Dd c P E A <= load_ratio Dlo chi Phi Ehi A.
Proof.
  intros A Plo P Phi clo c chi Elo E Ehi Dlo Dd Dhi
         HA HP0 HP Hc0 Hc HE0 HE HD0 HD.
  assert (HDd : 0 < Dd) by lra.
  assert (Hnum1 : clo * Plo + Elo / A <= c * P + E / A).
  { assert (clo * Plo <= c * P) by (apply Qmult_le_compat_nonneg; split; lra).
    assert (Elo / A <= E / A) by (apply div_le_num; lra). lra. }
  assert (Hnum2 : c * P + E / A <= chi * Phi + Ehi / A).
  { assert (c * P <= chi * Phi) by (apply Qmult_le_compat_nonneg; split; lra).
    assert (E / A <= Ehi / A) by (apply div_le_num; lra). lra. }
  assert (Hn0 : 0 <= clo * Plo + Elo / A).
  { assert (0 <= clo * Plo) by (apply Qmult_le_0_compat; lra).
    assert (0 <= Elo / A) by (apply div_nonneg; lra). lra. }
  unfold load_ratio. split.
  - apply Qle_trans with ((clo * Plo + Elo / A) / Dd).
    + apply div_le_den; [exact Hn0 | exact HDd | lra].
    + apply div_le_num; [exact HDd | exact Hnum1].
  - apply Qle_trans with ((chi * Phi + Ehi / A) / Dd).
    + apply div_le_num; [exact HDd | exact Hnum2].
    + apply div_le_den; [lra | exact HD0 | lra].
Qed.

(* mapping fact (not a new object): the plan's own "normal" late-season
   band 60-90 mm/h (plan p.22) lies wholly above the declared 1 h depth
   58.7 mm, so L_1 over that band is ROBUST above 1 (L_1 in 1.02 .. 1.53).
   Holds for c_U = 1 and rain only (E_k = 0), as written (review A10). *)
Example bma_p2_normal_band_exceeds_1h_capacity :
  cl (load_ratio_rain_only (587 # 10) 1 60) (load_ratio_rain_only (587 # 10) 1 90) 1 = Sp.
Proof.
  apply cl_plus_iff; unfold load_ratio_rain_only, Qdiv, Qle, Qlt; simpl; lia.
Qed.

(* per-model ratios, worst first: the reported worst bounds every model
   and is one of the models (never an average) *)
Fixpoint worst (xs : list Q) : option Q :=
  match xs with
  | [] => None
  | x :: rest => match worst rest with
                 | None => Some x
                 | Some w => Some (Qmax x w)
                 end
  end.

Theorem worst_bounds_every_model :
  forall xs w x, worst xs = Some w -> In x xs -> x <= w.
Proof.
  induction xs as [|y ys IH]; intros w x Hw Hin; [destruct Hin|].
  simpl in Hw. destruct (worst ys) as [w'|] eqn:E.
  - injection Hw as <-. destruct Hin as [<- | Hin].
    + apply Q.le_max_l.
    + apply Qle_trans with w'; [exact (IH w' x eq_refl Hin) | apply Q.le_max_r].
  - injection Hw as <-. destruct Hin as [<- | Hin]; [apply Qle_refl|].
    destruct ys as [|z zs]; [destruct Hin|]. simpl in E. destruct (worst zs); discriminate.
Qed.

Theorem worst_is_attained :
  forall xs w, worst xs = Some w -> exists x, In x xs /\ x == w.
Proof.
  induction xs as [|y ys IH]; intros w Hw; [discriminate|].
  simpl in Hw. destruct (worst ys) as [w'|] eqn:E.
  - injection Hw as <-. destruct (Q.max_spec y w') as [[Hlt Hm]|[Hle Hm]].
    + destruct (IH w' eq_refl) as [x [Hin Hx]]. exists x. split; [right; exact Hin|].
      rewrite Hm. exact Hx.
    + exists y. split; [left; reflexivity|]. rewrite Hm. reflexivity.
  - injection Hw as <-. exists y. split; [left; reflexivity| reflexivity].
Qed.

Theorem worst_refused_only_when_no_model :
  forall xs, worst xs = None <-> xs = [].
Proof.
  intros xs. split.
  - destruct xs as [|x xs]; [reflexivity|]. simpl. destruct (worst xs); discriminate.
  - intros ->. reflexivity.
Qed.

(* ------------------------------------------------------------------
   4. Capacity reduction eta (C_eff = C_0 * eta), 0 < eta <= 1.
      eta = g_U(t) * running-pump fraction (both PROP-FLOOD-06) * eta_canal;
      eta_canal is an option: None = ABSENT until fitted.  Whatever eta
      turns out to be, the ratio at RATED capacity is a lower bound.
   ------------------------------------------------------------------ *)

Theorem rated_ratio_is_lower_bound :
  forall num C0 eta, 0 <= num -> 0 < C0 -> 0 < eta -> eta <= 1 ->
    num / C0 <= num / (C0 * eta).
Proof.
  intros num C0 eta Hn HC He He1.
  apply div_le_den; [exact Hn | apply Qmult_lt_0_compat; assumption |].
  apply Qle_trans with (C0 * 1); [apply Qmult_le_compat_nonneg; split; lra |].
  rewrite Qmult_1_r. apply Qle_refl.
Qed.

(* three distinct outcomes (v1.2, review R2-A8): a value in (0,1]; ABSENT
   because eta_canal is not yet fitted; REFUSED ETA_OUT_OF_RANGE because
   the fitted product lies outside (0,1].  ABSENT and REFUSED are never
   the same readout. *)
Inductive eta_result : Type :=
  | EtaValue : Q -> eta_result
  | EtaAbsent : eta_result
  | EtaRefused : r08 -> eta_result.

Definition eta_total (g run_frac : Q) (eta_canal : option Q) : eta_result :=
  match eta_canal with
  | Some e => let eta := g * run_frac * e in
              if andb (Qltb 0 eta) (Qle_bool eta 1) then EtaValue eta
              else EtaRefused ETA_OUT_OF_RANGE
  | None => EtaAbsent           (* ABSENT until fitted: no default 1 *)
  end.

Theorem eta_absent_without_fit :
  forall g f, eta_total g f None = EtaAbsent.
Proof. reflexivity. Qed.

Theorem eta_total_in_range :
  forall g f e eta, eta_total g f e = EtaValue eta -> 0 < eta /\ eta <= 1.
Proof.
  intros g f e eta H. unfold eta_total in H. destruct e as [e|]; [|discriminate].
  destruct (Qltb 0 (g * f * e)) eqn:E1, (Qle_bool (g * f * e) 1) eqn:E2; simpl in H; try discriminate.
  injection H as <-. split; [apply Qltb_iff; exact E1 | apply Qle_bool_iff; exact E2].
Qed.

Theorem eta_out_of_range_refused :
  forall g f e, ~ (0 < g * f * e /\ g * f * e <= 1) ->
    eta_total g f (Some e) = EtaRefused ETA_OUT_OF_RANGE.
Proof.
  intros g f e Hn. unfold eta_total.
  destruct (Qltb 0 (g * f * e)) eqn:E1, (Qle_bool (g * f * e) 1) eqn:E2; simpl; try reflexivity.
  exfalso. apply Hn. split; [apply Qltb_iff; exact E1 | apply Qle_bool_iff; exact E2].
Qed.

(* "not yet fitted" never coincides with ANY outcome of a fitted value *)
Theorem eta_absent_is_not_refused :
  forall g f e, eta_total g f None <> eta_total g f (Some e).
Proof.
  intros g f e. simpl.
  destruct (andb (Qltb 0 (g * f * e)) (Qle_bool (g * f * e) 1)); discriminate.
Qed.


(* ------------------------------------------------------------------
   5. Drawdown time T_dd := V_stored / Q_out  (seconds): a LOWER bound
      only when Q_out is the declared maximum (rated) outflow -- the
      hypothesis `outflow j <= Qout` of drawdown_is_lower_bound; at an
      effective (current) outflow it is a readout, not a bound (review B4).
   ------------------------------------------------------------------ *)

Definition drawdown_time (V : option Q) (Qout : Q) : res Q :=
  match V with
  | None => Refused (Inherited03 MISSING_INPUT)
  | Some v =>
      if Qltb v 0 then Refused (Inherited03 NEGATIVE_STORAGE)
      else if Qle_bool Qout 0 then Refused ZERO_OUTFLOW     (* a non-value, never infinity *)
      else Ok (v / Qout)
  end.

Theorem drawdown_zero_outflow_refused :
  forall v Qout, 0 <= v -> Qout <= 0 -> drawdown_time (Some v) Qout = Refused ZERO_OUTFLOW.
Proof.
  intros v Qout Hv HQ. unfold drawdown_time.
  destruct (Qltb v 0) eqn:E1.
  - apply Qltb_iff in E1. lra.
  - destruct (Qle_bool Qout 0) eqn:E2; [reflexivity|].
    exfalso. apply Bool.not_true_iff_false in E2. apply E2. apply Qle_bool_iff. exact HQ.
Qed.

Theorem drawdown_missing_refused :
  forall Qout, drawdown_time None Qout = Refused (Inherited03 MISSING_INPUT).
Proof. reflexivity. Qed.

Theorem drawdown_ok_iff :
  forall V Qout t,
    drawdown_time V Qout = Ok t <-> exists v, V = Some v /\ 0 <= v /\ 0 < Qout /\ t = v / Qout.
Proof.
  intros V Qout t. unfold drawdown_time. split.
  - destruct V as [v|]; [|discriminate].
    destruct (Qltb v 0) eqn:E1; [discriminate|].
    destruct (Qle_bool Qout 0) eqn:E2; [discriminate|].
    intros H. inversion H; subst. exists v. split; [reflexivity|]. split.
    + apply Qnot_lt_le. intro C. apply Qltb_iff in C. congruence.
    + split; [|reflexivity]. apply Qnot_le_lt. intro C. apply Qle_bool_iff in C. congruence.
  - intros [v [-> [Hv [HQ ->]]]].
    destruct (Qltb v 0) eqn:E1; [apply Qltb_iff in E1; lra|].
    destruct (Qle_bool Qout 0) eqn:E2; [apply Qle_bool_iff in E2; lra|].
    reflexivity.
Qed.

(* rated outflow >= effective outflow  ==>  T_dd(rated) <= T_dd(effective) *)
Theorem drawdown_rated_le_effective :
  forall v Qeff Qrated, 0 <= v -> 0 < Qeff -> Qeff <= Qrated ->
    v / Qrated <= v / Qeff.
Proof. intros. apply div_le_den; assumption. Qed.

(* discrete lower bound on the real drawdown: with any non-negative
   inflow and an outflow never above Qout per second, the stored volume
   after k ticks of tau seconds is at least V - k*tau*Qout; so storage can
   only reach 0 at a tick k with k*tau >= V/Qout = T_dd. *)
Fixpoint stored (V : Q) (inflow outflow : nat -> Q) (tau : Q) (k : nat) : Q :=
  match k with
  | O => V
  | S k' => stored V inflow outflow tau k' + inflow k' * tau - outflow k' * tau
  end.

Lemma stored_lower :
  forall V inflow outflow tau Qout k,
    0 <= tau -> (forall j, 0 <= inflow j) -> (forall j, outflow j <= Qout) ->
    V - inject_Z (Z.of_nat k) * tau * Qout <= stored V inflow outflow tau k.
Proof.
  intros V inflow outflow tau Qout k Ht Hin Hout. induction k as [|k IH].
  - simpl. assert (E0 : inject_Z 0 * tau * Qout == 0) by ring. rewrite E0. lra.
  - simpl stored. rewrite Nat2Z.inj_succ. rewrite <- Z.add_1_r. rewrite inject_Z_plus.
    assert (0 <= inflow k * tau) by (apply Qmult_le_0_compat; [apply Hin|exact Ht]).
    assert (outflow k * tau <= Qout * tau) by (apply Qmult_le_compat_r; [apply Hout|exact Ht]).
    assert (E : (inject_Z (Z.of_nat k) + inject_Z 1) * tau * Qout
                == inject_Z (Z.of_nat k) * tau * Qout + Qout * tau) by ring.
    rewrite E. lra.
Qed.

Theorem drawdown_is_lower_bound :
  forall V inflow outflow tau Qout k,
    0 <= V -> 0 < Qout -> 0 <= tau ->
    (forall j, 0 <= inflow j) -> (forall j, outflow j <= Qout) ->
    stored V inflow outflow tau k <= 0 ->
    V / Qout <= inject_Z (Z.of_nat k) * tau.
Proof.
  intros V inflow outflow tau Qout k HV HQ Ht Hin Hout Hs.
  pose proof (stored_lower V inflow outflow tau Qout k Ht Hin Hout) as L.
  apply Qle_shift_div_r; [exact HQ|]. lra.
Qed.
