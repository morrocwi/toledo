(* ===================================================================== *)
(*  PROP_FLOOD_11_acceleration_eta.v                                      *)
(*  Acceleration-aware time-to-bank-level (time-to-threshold) over a      *)
(*  finite rational tick series: an ALREADY_AT_BANK outcome checked       *)
(*  first, the second difference D2_k, the quadratic persistence-         *)
(*  extrapolation recursion, least-n search over a declared finite        *)
(*  horizon, an EXTENDED relation to PROP-FLOOD-02's linear ceiling at    *)
(*  D2=0, monotonicity in D2, and the interval-enclosure form reusing     *)
(*  PROP-FLOOD-10a directly (not re-derived).                             *)
(*  (Toledo proposal PROP-FLOOD-11.v3, code weld/M.??.v1, proposals lane, *)
(*  NOT yet canonicalized -- registry/proposals/flood_acceleration_eta.json*)
(*  registry/LINEAGE.jsonl code PROP-FLOOD-11.)                           *)
(*  NEW DERIVATION / PROPOSAL -- not yet in Toledo.                       *)
(*  v3: revised after independent review. See registry LINEAGE.jsonl     *)
(*  for the full before/after.                                           *)
(*                                                                         *)
(*  Parents (read, not keyword-matched):                                  *)
(*    PROP-FLOOD-01 (lag-k retained difference Delta_k, resolution eps,   *)
(*      derived_via instance_of);                                         *)
(*    PROP-FLOOD-02 (linear time-to-threshold T_k, REFUSED discipline,    *)
(*      derived_via EXTENDED -- not merely generalised. Explicit map:    *)
(*      02 UNRESOLVED -> NO_RISE; 02 NOT_APPLICABLE(falling) -> NO_RISE;  *)
(*      02 NOT_APPLICABLE(h>=theta) -> EtaAtBank; 02 NOT_APPLICABLE       *)
(*      (NO_READOUT input) -> NO_READOUT. Added outright, no PROP-FLOOD- *)
(*      02 counterpart: PUMP_STATE_CHANGED, PUMP_STATE_UNDECLARED,       *)
(*      SPARSE_SERIES, NOT_WITHIN_HORIZON);                               *)
(*    WP.S8.SecondDifference (delta_t^2 X_n = X_{n+1}-2X_n+X_{n-1} /      *)
(*      Delta t^2, REGISTERED_CURRENT -- generalised here from lag 1 to   *)
(*      lag k and kept as an un-normalized retained second difference,    *)
(*      never divided by a continuum Delta t^2);                          *)
(*    PROP-FLOOD-10a (monotone endpoint enclosure; itself an open         *)
(*      proposal, PR #64; its enclosure_sound theorem and Coq file are    *)
(*      imported and compiled directly below, not re-derived).            *)
(*  Neighbour (no statement reused, cited for context only --             *)
(*    unregistered, never a parent): PROP-FLOOD-03 (water-balance S_b;    *)
(*    this object uses an OBSERVED level h(t) in the role an earlier      *)
(*    backtest of PROP-FLOOD-03 found its undeclared S_b(0) blocking).    *)
(*  Sibling (context only, not a parent): weld/M.41.v1 (Dirichlet-energy  *)
(*    discrete Laplacian / second-difference stencil on a weighted graph  *)
(*    -- the same [1,-2,1] stencil shape, a different domain: a spatial   *)
(*    graph, not a tick series).                                          *)
(*  Genesis gate: readout_genesis Part V-A A.13 Gate 2 (three-valued      *)
(*  admissibility, quoted with its own bracket glyph 【...】). EtaAtBank   *)
(*  is the resolved 1-branch; NO_RISE / SPARSE_SERIES / NOT_WITHIN_HORIZON*)
(*  / PUMP_STATE_CHANGED / PUMP_STATE_UNDECLARED / NO_READOUT are each a  *)
(*  determinate refusal (the ⊥/0 branch, six ways) -- never a guessed     *)
(*  number, never silently averaged into a biased ETA, checked in a      *)
(*  fixed precedence: ALREADY_AT_BANK > NO_READOUT > PUMP > SPARSE_SERIES *)
(*  > NO_RISE > NOT_WITHIN_HORIZON.                                       *)
(*                                                                         *)
(*  PRECONDITION: h(t), the current retained sample, is a precondition   *)
(*  of this whole construction, not a NO_READOUT case -- without it     *)
(*  there is no readout at all. NO_READOUT covers only a missing        *)
(*  h(t-k) or h(t-2k), i.e. Delta_k(t) or Delta_k(t-k) itself undefined. *)
(*                                                                         *)
(*  Everything is on Q at finite, declared ticks t in N; k in N, k>=1; n  *)
(*  (the number of k-tick strides forward) is a nat; ETA in ticks = n*k.  *)
(*  No derivative, no limit, no continuum h->0.  This is a persistence    *)
(*  EXTRAPOLATION readout of the two most recently retained differences,  *)
(*  never a physical forecast: holding Delta_k(t) and D2_k(t) constant    *)
(*  forward is an assumption this construction makes visible, not a      *)
(*  claim that it will hold. A pump-state change (or an undeclared pump  *)
(*  state) inside the extrapolated window breaks the persistence         *)
(*  assumption outright (PUMP_STATE_CHANGED / PUMP_STATE_UNDECLARED). The *)
(*  declared window is the retained samples [t-2k,t] used to form        *)
(*  Delta_k(t)/Delta_k(t-k), plus any change declared on the operator's   *)
(*  own schedule for the forward window (t, t+N_max*k].                   *)
(*  No axioms: every theorem is checked by Print Assumptions at the       *)
(*  bottom of the scratch audit.                                          *)
(* ===================================================================== *)

Require Import QArith.
Require Import Coq.QArith.Qminmax.
Require Import Coq.micromega.Lqa.
Require Import Lia.
From IDM.formal Require Import IDM_ReadoutMinimality IDM_ResolvedCount.
From MRC Require Import PROP_FLOOD_10_enclosure_nested_box.

Local Open Scope Q_scope.

(* ------------------------------------------------------------------
   0. nat -> Q embedding by recursion on nat (keeps induction on n
      elementary; no Z-conversion lemmas are needed).
   ------------------------------------------------------------------ *)

Fixpoint Qnat (n : nat) : Q :=
  match n with
  | O => 0
  | S n' => Qnat n' + 1
  end.

Lemma Qnat_nonneg : forall n, 0 <= Qnat n.
Proof. induction n; simpl; lra. Qed.

Lemma Qnat_S : forall n, Qnat (S n) = Qnat n + 1.
Proof. intros; reflexivity. Qed.

Lemma Qnat_le_mono : forall m n, (m <= n)%nat -> Qnat m <= Qnat n.
Proof.
  intros m n H. induction H.
  - lra.
  - rewrite Qnat_S. lra.
Qed.

(* ------------------------------------------------------------------
   1. D2_k(t) := Delta_k(t) - Delta_k(t-k) (PROP-FLOOD-01's retained
      difference applied to itself one lag back -- the generalisation
      of WP.S8.SecondDifference, REGISTERED_CURRENT, from lag 1 to lag
      k, with the continuum /Delta t^2 normalisation dropped: this
      stays a retained difference of retained differences, not a rate).
      Both Delta_k(t) and D2_k(t) are supplied as already-computed Q
      inputs below (PROP-FLOOD-01 is the single source of the retained
      differences; it is not re-derived here).
   ------------------------------------------------------------------ *)

Definition D2 (Delta_now Delta_prev : Q) : Q := Delta_now - Delta_prev.

(* ------------------------------------------------------------------
   2. The quadratic persistence-extrapolation level at n k-tick
      strides forward from the current retained tick t:
        level(h0, D1, D2v, n) := h0 + n*D1 + (n(n+1)/2)*D2v
      with h0 = h(t), D1 = Delta_k(t), D2v = D2_k(t).  n(n+1)/2 is
      always a nonnegative rational since n ranges over nat.
   ------------------------------------------------------------------ *)

Definition tri (n : nat) : Q := (Qnat n) * (Qnat n + 1) * (1 # 2).

Lemma tri_nonneg : forall n, 0 <= tri n.
Proof.
  intros n. unfold tri.
  assert (H := Qnat_nonneg n).
  nra.
Qed.

Definition level (h0 D1 D2v : Q) (n : nat) : Q :=
  h0 + (Qnat n) * D1 + (tri n) * D2v.

Lemma level_D2_zero : forall h0 D1 n, level h0 D1 0 n == h0 + Qnat n * D1.
Proof. intros. unfold level. ring. Qed.

Lemma level_mono_D2 : forall h0 D1 D2a D2b n,
  D2a <= D2b -> level h0 D1 D2a n <= level h0 D1 D2b n.
Proof.
  intros h0 D1 D2a D2b n H. unfold level.
  assert (Ht := tri_nonneg n).
  nra.
Qed.

Lemma level_mono_joint : forall h0 D1a D1b D2a D2b n,
  D1a <= D1b -> D2a <= D2b -> level h0 D1a D2a n <= level h0 D1b D2b n.
Proof.
  intros h0 D1a D1b D2a D2b n H1 H2. unfold level.
  assert (Ht := tri_nonneg n).
  assert (Hn := Qnat_nonneg n).
  nra.
Qed.

(* ------------------------------------------------------------------
   3. Least-n search over a declared finite horizon (fuel = N_max).
      Returns Some n (the first k-tick stride count n>=1 at which the
      level reaches theta) or None (NOT_WITHIN_HORIZON, within the
      declared horizon starting at n0).
   ------------------------------------------------------------------ *)

Fixpoint search (h0 D1 D2v theta : Q) (fuel n : nat) : option nat :=
  match fuel with
  | O => None
  | S fuel' =>
      match Qlt_le_dec (level h0 D1 D2v n) theta with
      | left _ => search h0 D1 D2v theta fuel' (S n)
      | right _ => Some n
      end
  end.

Definition eta_search (h0 D1 D2v theta : Q) (Nmax : nat) : option nat :=
  search h0 D1 D2v theta Nmax 1.

(* ---- THEOREM: soundness. The returned n reaches theta, and no smaller
   n (within the searched range, starting at n0) does. *)
Theorem search_sound : forall h0 D1 D2v theta fuel n0 n,
  search h0 D1 D2v theta fuel n0 = Some n ->
  theta <= level h0 D1 D2v n /\
  (n0 <= n)%nat /\
  (forall m, (n0 <= m)%nat -> (m < n)%nat -> level h0 D1 D2v m < theta).
Proof.
  intros h0 D1 D2v theta fuel.
  induction fuel as [| fuel' IH]; intros n0 n Hs.
  - simpl in Hs. discriminate.
  - simpl in Hs. destruct (Qlt_le_dec (level h0 D1 D2v n0) theta) as [Hlt | Hge].
    + apply IH in Hs. destruct Hs as [Hv [Hle Hall]].
      repeat split.
      * exact Hv.
      * lia.
      * intros m Hm1 Hm2.
        destruct (Nat.eq_dec m n0) as [-> | Hne].
        -- exact Hlt.
        -- apply Hall; lia.
    + inversion Hs; subst.
      repeat split; [exact Hge | lia | intros m Hm1 Hm2; exfalso; lia].
Qed.

(* ---- THEOREM: a None result means the level stays below theta at
   every n inside the searched horizon (what licenses NOT_WITHIN_HORIZON). *)
Theorem search_none_horizon : forall h0 D1 D2v theta fuel n0,
  search h0 D1 D2v theta fuel n0 = None ->
  forall m, (n0 <= m)%nat -> (m < n0 + fuel)%nat -> level h0 D1 D2v m < theta.
Proof.
  intros h0 D1 D2v theta fuel.
  induction fuel as [| fuel' IH]; intros n0 Hs m Hm1 Hm2.
  - exfalso. lia.
  - simpl in Hs. destruct (Qlt_le_dec (level h0 D1 D2v n0) theta) as [Hlt | Hge].
    + destruct (Nat.eq_dec m n0) as [-> | Hne].
      * exact Hlt.
      * apply IH with (n0 := S n0); [exact Hs | lia | lia].
    + discriminate.
Qed.

(* ---- THEOREM: at D2v=0, eta_search's defining property reduces exactly
   to PROP-FLOOD-02's own defining property -- the least k-tick stride
   count n with the LINEAR extension h0 + n*D1 reaching theta (the
   discretised form of PROP-FLOOD-02's ceiling(T_k): T_k/k k-tick
   strides, rounded up to the first n that actually reaches theta). *)
Theorem eta_D2_zero_matches_linear :
  forall h0 D1 theta Nmax n,
    eta_search h0 D1 0 theta Nmax = Some n ->
    theta <= h0 + Qnat n * D1 /\
    (forall m, (1 <= m)%nat -> (m < n)%nat -> h0 + Qnat m * D1 < theta).
Proof.
  intros h0 D1 theta Nmax n H.
  unfold eta_search in H.
  apply search_sound in H. destruct H as [Hv [_ Hall]].
  rewrite level_D2_zero in Hv.
  split.
  - exact Hv.
  - intros m Hm1 Hm2. specialize (Hall m Hm1 Hm2). rewrite level_D2_zero in Hall. exact Hall.
Qed.

(* ---- THEOREM: monotonicity in D2. A higher (more accelerating) second
   difference reaches theta no later -- a smaller or equal n. *)
Theorem eta_search_mono_joint :
  forall h0 D1a D1b D2a D2b theta Nmax na nb,
    D1a <= D1b -> D2a <= D2b ->
    eta_search h0 D1a D2a theta Nmax = Some na ->
    eta_search h0 D1b D2b theta Nmax = Some nb ->
    (nb <= na)%nat.
Proof.
  intros h0 D1a D1b D2a D2b theta Nmax na nb HD1 HD2 Ha Hb.
  unfold eta_search in Ha, Hb.
  apply search_sound in Ha. apply search_sound in Hb.
  destruct Ha as [Hva [H1a Halla]].
  destruct Hb as [Hvb [H1b Hallb]].
  destruct (le_lt_dec nb na) as [Hok | Hbad]; [exact Hok |].
  exfalso.
  assert (Hcontra : level h0 D1b D2b na < theta) by (apply Hallb; lia).
  assert (Hmono : level h0 D1a D2a na <= level h0 D1b D2b na)
    by (apply level_mono_joint; assumption).
  lra.
Qed.

Theorem eta_search_mono_D2 :
  forall h0 D1 D2a D2b theta Nmax na nb,
    D2a <= D2b ->
    eta_search h0 D1 D2a theta Nmax = Some na ->
    eta_search h0 D1 D2b theta Nmax = Some nb ->
    (nb <= na)%nat.
Proof.
  intros h0 D1 D2a D2b theta Nmax na nb HD2 Ha Hb.
  apply (eta_search_mono_joint h0 D1 D1 D2a D2b theta Nmax na nb);
    [apply Qle_refl | exact HD2 | exact Ha | exact Hb].
Qed.

(* ------------------------------------------------------------------
   3b. Qeq-congruence of level/search in D2 (needed below to relate a
       D2_k(t) that is merely Qeq, not syntactically, 0 to the literal
       D2=0 case already proved in eta_D2_zero_matches_linear), and a
       finite upper bound on a returned n (needed for the "a slower
       case finding Some propagates to a faster case finding Some"
       corollary).
   ------------------------------------------------------------------ *)

Lemma level_qeq_D2 : forall h0 D1 D2a D2b n, D2a == D2b -> level h0 D1 D2a n == level h0 D1 D2b n.
Proof. intros h0 D1 D2a D2b n H. unfold level. rewrite H. reflexivity. Qed.

Lemma search_qeq : forall h0 D1 D2a D2b theta fuel n0,
  D2a == D2b -> search h0 D1 D2a theta fuel n0 = search h0 D1 D2b theta fuel n0.
Proof.
  intros h0 D1 D2a D2b theta fuel. induction fuel as [| fuel' IH]; intros n0 Heq.
  - reflexivity.
  - simpl.
    assert (Hlev : level h0 D1 D2a n0 == level h0 D1 D2b n0) by (apply level_qeq_D2; exact Heq).
    destruct (Qlt_le_dec (level h0 D1 D2a n0) theta) as [Ha | Ha];
    destruct (Qlt_le_dec (level h0 D1 D2b n0) theta) as [Hb | Hb].
    + apply IH; exact Heq.
    + rewrite Hlev in Ha. exfalso. lra.
    + rewrite <- Hlev in Hb. exfalso. lra.
    + reflexivity.
Qed.

Corollary eta_search_qeq : forall h0 D1 D2a D2b theta Nmax,
  D2a == D2b -> eta_search h0 D1 D2a theta Nmax = eta_search h0 D1 D2b theta Nmax.
Proof. intros. unfold eta_search. apply search_qeq. assumption. Qed.

Lemma search_upper_bound : forall h0 D1 D2v theta fuel n0 n,
  search h0 D1 D2v theta fuel n0 = Some n -> (n < n0 + fuel)%nat.
Proof.
  intros h0 D1 D2v theta fuel. induction fuel as [| fuel' IH]; intros n0 n Hs.
  - simpl in Hs. discriminate.
  - simpl in Hs. destruct (Qlt_le_dec (level h0 D1 D2v n0) theta) as [Hlt | Hge].
    + apply IH in Hs. lia.
    + inversion Hs; subst. lia.
Qed.

Corollary eta_search_upper_bound : forall h0 D1 D2v theta Nmax n,
  eta_search h0 D1 D2v theta Nmax = Some n -> (n <= Nmax)%nat.
Proof. intros h0 D1 D2v theta Nmax n H. unfold eta_search in H. apply search_upper_bound in H. lia. Qed.

(* if the level reaches theta at some declared n0 inside the horizon,
   the search itself must succeed, at or before n0 *)
Lemma search_succeeds_by : forall h0 D1 D2v theta Nmax n0,
  (1 <= n0)%nat -> (n0 <= Nmax)%nat -> theta <= level h0 D1 D2v n0 ->
  exists n, eta_search h0 D1 D2v theta Nmax = Some n /\ (n <= n0)%nat.
Proof.
  intros h0 D1 D2v theta Nmax n0 H1 H2 H3.
  destruct (eta_search h0 D1 D2v theta Nmax) as [n | ] eqn:Hs.
  - exists n. split; [reflexivity |].
    unfold eta_search in Hs. apply search_sound in Hs.
    destruct Hs as [_ [_ Hall]].
    destruct (le_lt_dec n n0) as [Hok | Hbad]; [exact Hok |].
    exfalso. specialize (Hall n0 H1 Hbad). lra.
  - exfalso. unfold eta_search in Hs. apply search_none_horizon with (m := n0) in Hs; [lra | lia | lia].
Qed.

(* ---- THEOREM: a slower (smaller D1,D2) case that
   already finds Some within the horizon forces a faster (larger
   D1,D2) case to also find Some, no later. *)
Theorem eta_search_mono_joint_some_propagates :
  forall h0 D1a D1b D2a D2b theta Nmax na,
    D1a <= D1b -> D2a <= D2b ->
    eta_search h0 D1a D2a theta Nmax = Some na ->
    exists nb, eta_search h0 D1b D2b theta Nmax = Some nb /\ (nb <= na)%nat.
Proof.
  intros h0 D1a D1b D2a D2b theta Nmax na HD1 HD2 Ha.
  assert (Hna : (1 <= na)%nat /\ (na <= Nmax)%nat).
  { unfold eta_search in Ha. split.
    - apply search_sound in Ha. apply Ha.
    - apply eta_search_upper_bound in Ha. exact Ha. }
  destruct Hna as [Hna1 Hna2].
  assert (Hva : theta <= level h0 D1a D2a na).
  { unfold eta_search in Ha. apply search_sound in Ha. apply Ha. }
  assert (Hvb : theta <= level h0 D1b D2b na)
    by (eapply Qle_trans; [exact Hva | apply level_mono_joint; assumption]).
  apply (search_succeeds_by h0 D1b D2b theta Nmax na); assumption.
Qed.

(* ------------------------------------------------------------------
   4. Interval-enclosure form, reusing PROP-FLOOD-10a directly.
      level, viewed as a 2-coordinate vector map (D1, D2v) with both
      coordinates non-decreasing, IS a sigma_monotone map in 10a's own
      sense; 10a's enclosure_sound theorem is applied to it UNCHANGED
      (not re-derived) to enclose the LEVEL value at any point of a
      declared (D1,D2v) box between its two corners.
   ------------------------------------------------------------------ *)

Definition level_vec (h0 : Q) (n : nat) (x : vec) : Q := level h0 (x 0%nat) (x 1%nat) n.

Definition sg_rise : nat -> bool := fun _ => true.

Theorem level_vec_sigma_monotone : forall h0 n, sigma_monotone 2 sg_rise (level_vec h0 n).
Proof.
  intros h0 n x y H. unfold level_vec.
  assert (H0 := H 0%nat ltac:(lia)).
  assert (H1 := H 1%nat ltac:(lia)).
  unfold sg_rise in H0, H1. simpl in H0, H1.
  apply level_mono_joint; assumption.
Qed.

(* ---- COROLLARY (10a's enclosure_sound applied, not re-derived): the
   LEVEL at any point of a declared (D1,D2v) box lies between its values
   at the box's two declared corners. *)
Corollary level_box_enclosure :
  forall h0 n B x,
    in_box 2 B x ->
    level_vec h0 n (corner_lo sg_rise B) <= level_vec h0 n x /\
    level_vec h0 n x <= level_vec h0 n (corner_hi sg_rise B).
Proof.
  intros h0 n B x Hx.
  apply (enclosure_sound 2 sg_rise (level_vec h0 n) B x);
    [apply level_vec_sigma_monotone | exact Hx].
Qed.

(* ---- THEOREM: ETA interval enclosure. With Delta_k(t) in [D1lo,D1hi]
   and D2_k(t) in [D2lo,D2hi] (a declared box, e.g. from PROP-FLOOD-10a's
   own upstream interval sources), the actual ETA n is enclosed by the
   ETA computed at the box's two corners: the fastest-rise corner
   (D1hi,D2hi) gives the EARLIEST possible crossing (a lower bound on n),
   the slowest-rise corner (D1lo,D2lo) gives the LATEST (an upper bound).
   This is the search-level packaging of level_box_enclosure: the same
   corner-value enclosure, carried through the well-ordered least-n
   search by eta_search_mono_joint, exactly mirroring 10a's own
   iterated_enclosure pattern (a one-shot value enclosure propagated to
   a derived finite-horizon readout) rather than a second, independent
   enclosure object. *)
Theorem eta_interval_enclosure :
  forall h0 D1lo D1 D1hi D2lo D2v D2hi theta Nmax nlo n nhi,
    D1lo <= D1 -> D1 <= D1hi -> D2lo <= D2v -> D2v <= D2hi ->
    eta_search h0 D1hi D2hi theta Nmax = Some nlo ->
    eta_search h0 D1 D2v theta Nmax = Some n ->
    eta_search h0 D1lo D2lo theta Nmax = Some nhi ->
    (nlo <= n)%nat /\ (n <= nhi)%nat.
Proof.
  intros h0 D1lo D1 D1hi D2lo D2v D2hi theta Nmax nlo n nhi
         HD1lo HD1hi HD2lo HD2hi Hlo Hmid Hhi.
  split.
  - apply (eta_search_mono_joint h0 D1 D1hi D2v D2hi theta Nmax n nlo);
      assumption.
  - apply (eta_search_mono_joint h0 D1lo D1 D2lo D2v theta Nmax nhi n);
      assumption.
Qed.


(* ------------------------------------------------------------------
   5. Total refusal wrapper. Every call
      returns exactly one of a determinate outcome -- an already-at-
      or-over-the-bank readout (NOT a refusal: it is a real, positive
      answer the founder needs), a determinate ETA, or a determinate,
      named refusal -- never a silently defaulted or averaged number.

      Precedence, checked in this fixed order:
        ALREADY_AT_BANK > NO_READOUT > PUMP (CHANGED/UNDECLARED) >
        SPARSE_SERIES > NO_RISE > NOT_WITHIN_HORIZON.

      Delta_now/Delta_prev are now option Q: None means the retained
      sample PROP-FLOOD-01's own construction needs is itself missing
      (e.g. h(t-2k) absent, so Delta_k(t-k) cannot be formed) --
      NO_READOUT, a determinate refusal, never silently treated as a
      zero difference.

      pump is a 3-way flag, never a bare bool:
      PumpChanged / PumpUnchanged / PumpUndeclared. PumpUndeclared is
      itself an explicit, checked state -- it is never silently read
      as "unchanged". The declared window this flag covers is the
      retained samples [t-2k, t] used to compute Delta_k(t)/Delta_k(t-k)
      PLUS any change declared on the operator's own schedule for the
      forward extrapolation window (t, t+N_max*k] -- the same wording
      is used in the registry record and the doc.
   ------------------------------------------------------------------ *)

Inductive pump_flag : Set := PumpChanged | PumpUnchanged | PumpUndeclared.

Inductive eta_reason : Set :=
  | NO_READOUT
  | PUMP_STATE_CHANGED
  | PUMP_STATE_UNDECLARED
  | SPARSE_SERIES
  | NO_RISE
  | NOT_WITHIN_HORIZON.

Inductive eta_result : Type :=
  | EtaAtBank : eta_result               (* theta <= h0: already at/over the bank, a real answer *)
  | EtaOk : nat -> eta_result
  | EtaRefused : eta_reason -> eta_result.

(* Delta_now: PROP-FLOOD-01's Delta_k(t), as Some value only when h(t) and
   h(t-k) are both retained samples. Delta_prev: Delta_k(t-k), Some only
   when h(t-k) and h(t-2k) are both retained. eps: PROP-FLOOD-01's own
   resolution constant. gap/max_gap: declared spacing / staleness bound.
   pump: the 3-way flag above. *)
Definition eta_readout
    (h0 : Q) (Delta_now Delta_prev : option Q) (theta eps max_gap gap : Q)
    (pump : pump_flag) (Nmax : nat) : eta_result :=
  match Qlt_le_dec h0 theta with
  | right _ => EtaAtBank
  | left _ =>
      match Delta_now, Delta_prev with
      | None, _ => EtaRefused NO_READOUT
      | _, None => EtaRefused NO_READOUT
      | Some D1, Some D1p =>
          match pump with
          | PumpChanged => EtaRefused PUMP_STATE_CHANGED
          | PumpUndeclared => EtaRefused PUMP_STATE_UNDECLARED
          | PumpUnchanged =>
              match Qlt_le_dec max_gap gap with
              | left _ => EtaRefused SPARSE_SERIES
              | right _ =>
                  match Qlt_le_dec eps D1 with
                  | left _ =>
                      match eta_search h0 D1 (D2 D1 D1p) theta Nmax with
                      | Some n => EtaOk n
                      | None => EtaRefused NOT_WITHIN_HORIZON
                      end
                  | right _ => EtaRefused NO_RISE
                  end
              end
          end
      end
  end.

(* ---- THEOREM: EtaAtBank is returned exactly when theta <= h0 -- the
   check that fires first, before any retained-difference input is even
   inspected. This is the gate's HIGH-finding fix: "already at/over the
   bank" is a real, positive answer, never folded into NOT_WITHIN_HORIZON
   or any other refusal. *)
Theorem eta_readout_at_bank_iff :
  forall h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax,
    eta_readout h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax = EtaAtBank
    <-> theta <= h0.
Proof.
  intros h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax.
  unfold eta_readout. destruct (Qlt_le_dec h0 theta) as [Hlt | Hge].
  - split.
    + intros H.
      destruct Delta_now as [D1 | ]; destruct Delta_prev as [D1p | ]; try discriminate H.
      destruct pump eqn:Hp; try discriminate H.
      destruct (Qlt_le_dec max_gap gap) as [Hg | Hg]; try discriminate H.
      destruct (Qlt_le_dec eps D1) as [Hr | Hr]; try discriminate H.
      destruct (eta_search h0 D1 (D2 D1 D1p) theta Nmax); discriminate H.
    + intros Hge'. exfalso. lra.
  - split; [intros _; exact Hge | intros _; reflexivity].
Qed.

(* ---- THEOREM: NO_READOUT fires exactly when h0 has not yet reached
   theta AND at least one of the two retained differences this
   construction needs is itself missing. h(t) itself is a PRECONDITION
   of the whole construction, never a NO_READOUT case. *)
Theorem eta_readout_no_readout_iff :
  forall h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax,
    h0 < theta ->
    eta_readout h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax = EtaRefused NO_READOUT
    <-> (Delta_now = None \/ Delta_prev = None).
Proof.
  intros h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax Hlt0.
  unfold eta_readout. destruct (Qlt_le_dec h0 theta) as [Hlt | Hge]; [| exfalso; lra].
  destruct Delta_now as [D1 | ]; destruct Delta_prev as [D1p | ].
  - split.
    + intros H.
      destruct pump eqn:Hp; try discriminate H.
      destruct (Qlt_le_dec max_gap gap) as [Hg | Hg]; try discriminate H.
      destruct (Qlt_le_dec eps D1) as [Hr | Hr]; try discriminate H.
      destruct (eta_search h0 D1 (D2 D1 D1p) theta Nmax); discriminate H.
    + intros [H | H]; discriminate H.
  - split; [intros _; right; reflexivity | intros _; reflexivity].
  - split; [intros _; left; reflexivity | intros _; reflexivity].
  - split; [intros _; left; reflexivity | intros _; reflexivity].
Qed.

(* ---- THEOREM: an EtaOk n readout is sound. It carries its own
   admissibility (not yet at bank, both retained differences present,
   pump unchanged, spacing within bound, rising above resolution) AND
   the underlying search's own soundness (h0 < theta is
   now part of this statement, not assumed silently). *)
Theorem eta_readout_ok_sound :
  forall h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax n,
    eta_readout h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax = EtaOk n ->
    h0 < theta /\
    exists D1 D1p,
      Delta_now = Some D1 /\ Delta_prev = Some D1p /\
      pump = PumpUnchanged /\ gap <= max_gap /\ eps < D1 /\
      theta <= level h0 D1 (D2 D1 D1p) n /\
      (forall m, (1 <= m)%nat -> (m < n)%nat -> level h0 D1 (D2 D1 D1p) m < theta).
Proof.
  intros h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax n H.
  unfold eta_readout in H.
  destruct (Qlt_le_dec h0 theta) as [Hlt | Hge]; [| discriminate].
  destruct Delta_now as [D1 | ]; [| discriminate].
  destruct Delta_prev as [D1p | ]; [| discriminate].
  destruct pump eqn:Hp; [discriminate | | discriminate].
  destruct (Qlt_le_dec max_gap gap) as [Hg | Hg]; [discriminate |].
  destruct (Qlt_le_dec eps D1) as [Hr | Hr]; [| discriminate].
  destruct (eta_search h0 D1 (D2 D1 D1p) theta Nmax) eqn:Hs; [| discriminate].
  inversion H; subst.
  unfold eta_search in Hs. apply search_sound in Hs.
  destruct Hs as [Hv [_ Hall]].
  split; [exact Hlt |]. exists D1, D1p.
  repeat split; try assumption; reflexivity.
Qed.

(* ---- THEOREM: at D2=0, with h0 < theta
   and eps < D1 (PROP-FLOOD-02's own defined-ness condition for T_k:
   Delta_k(t) > eps AND h(t) < theta), eta_readout returns EtaOk n
   EXACTLY when the underlying linear search succeeds -- and that n is
   the least stride reaching theta (eta_D2_zero_matches_linear already
   characterises it). This "extends" PROP-FLOOD-02 rather than merely
   generalising it: PROP-FLOOD-02's single REFUSED is split here into
   UNRESOLVED/NOT_APPLICABLE on PROP-FLOOD-02's own side (unchanged)
   and, on this object's side, NO_RISE (Delta_k(t) <= eps) plus the
   four further named reasons NO_READOUT/PUMP/SPARSE/HORIZON this
   object's own search and declared inputs add. *)
Theorem eta_readout_D2_zero_matches_T_k :
  forall h0 D1 D1p theta eps max_gap gap Nmax,
    D1 - D1p == 0 ->
    gap <= max_gap ->
    forall n,
      eta_readout h0 (Some D1) (Some D1p) theta eps max_gap gap PumpUnchanged Nmax = EtaOk n
      <-> (h0 < theta /\ eps < D1 /\ eta_search h0 D1 0 theta Nmax = Some n).
Proof.
  intros h0 D1 D1p theta eps max_gap gap Nmax Hz Hgap n.
  unfold eta_readout.
  assert (Hqeq : eta_search h0 D1 (D2 D1 D1p) theta Nmax = eta_search h0 D1 0 theta Nmax)
    by (apply eta_search_qeq; unfold D2; exact Hz).
  destruct (Qlt_le_dec h0 theta) as [Hlt | Hge].
  - destruct (Qlt_le_dec max_gap gap) as [Hg | Hg]; [exfalso; lra |].
    destruct (Qlt_le_dec eps D1) as [Hr | Hr].
    + rewrite Hqeq. split.
      * intros H. destruct (eta_search h0 D1 0 theta Nmax) as [n' | ] eqn:Hs; [| discriminate H].
        inversion H; subst. split; [exact Hlt | split; [exact Hr | reflexivity]].
      * intros [_ [_ Heq]]. rewrite Heq. reflexivity.
    + split.
      * intros H; discriminate H.
      * intros [_ [Hr' _]]. exfalso. lra.
  - split.
    + intros H; discriminate H.
    + intros [Hlt' _]. exfalso. lra.
Qed.

(* ---- Per-reason cause lemmas, replacing the earlier
   tautological "every refusal is one of these four" lemma with an
   exact characterisation of each named reason. *)

Theorem eta_readout_pump_changed_iff :
  forall h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax,
    eta_readout h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax = EtaRefused PUMP_STATE_CHANGED
    <-> (h0 < theta /\ (exists D1, Delta_now = Some D1) /\ (exists D1p, Delta_prev = Some D1p) /\
         pump = PumpChanged).
Proof.
  intros h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax.
  unfold eta_readout. destruct (Qlt_le_dec h0 theta) as [Hlt | Hge].
  - destruct Delta_now as [D1 | ]; destruct Delta_prev as [D1p | ];
      try (split; [intros H; discriminate H | intros [_ [[D1' H1] _]]; discriminate H1]);
      try (split; [intros H; discriminate H | intros [_ [_ [[D1p' H2] _]]]; discriminate H2]).
    destruct pump eqn:Hp.
    + split; [intros _; repeat split; eauto | intros _; reflexivity].
    + destruct (Qlt_le_dec max_gap gap) as [Hg | Hg].
      * split; [intros H; discriminate H | intros [_ [_ [_ H]]]; discriminate H].
      * destruct (Qlt_le_dec eps D1) as [Hr | Hr].
        -- destruct (eta_search h0 D1 (D2 D1 D1p) theta Nmax) as [n | ];
             (split; [intros H; discriminate H | intros [_ [_ [_ H]]]; discriminate H]).
        -- split; [intros H; discriminate H | intros [_ [_ [_ H]]]; discriminate H].
    + split; [intros H; discriminate H | intros [_ [_ [_ H]]]; discriminate H].
  - split; [intros H; discriminate H | intros [H _]; exfalso; lra].
Qed.

Theorem eta_readout_pump_undeclared_iff :
  forall h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax,
    eta_readout h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax = EtaRefused PUMP_STATE_UNDECLARED
    <-> (h0 < theta /\ (exists D1, Delta_now = Some D1) /\ (exists D1p, Delta_prev = Some D1p) /\
         pump = PumpUndeclared).
Proof.
  intros h0 Delta_now Delta_prev theta eps max_gap gap pump Nmax.
  unfold eta_readout. destruct (Qlt_le_dec h0 theta) as [Hlt | Hge].
  - destruct Delta_now as [D1 | ]; destruct Delta_prev as [D1p | ];
      try (split; [intros H; discriminate H | intros [_ [[D1' H1] _]]; discriminate H1]);
      try (split; [intros H; discriminate H | intros [_ [_ [[D1p' H2] _]]]; discriminate H2]).
    destruct pump eqn:Hp.
    + split; [intros H; discriminate H | intros [_ [_ [_ H]]]; discriminate H].
    + destruct (Qlt_le_dec max_gap gap) as [Hg | Hg];
        [ split; [intros H; discriminate H | intros [_ [_ [_ H]]]; discriminate H] | ].
      destruct (Qlt_le_dec eps D1) as [Hr | Hr];
        [ destruct (eta_search h0 D1 (D2 D1 D1p) theta Nmax) as [n | ];
          (split; [intros H; discriminate H | intros [_ [_ [_ H]]]; discriminate H])
        | split; [intros H; discriminate H | intros [_ [_ [_ H]]]; discriminate H] ].
    + split; [intros _; repeat split; eauto | intros _; reflexivity].
  - split; [intros H; discriminate H | intros [H _]; exfalso; lra].
Qed.

Theorem eta_readout_sparse_iff :
  forall h0 Delta_now Delta_prev theta eps max_gap gap Nmax,
    eta_readout h0 Delta_now Delta_prev theta eps max_gap gap PumpUnchanged Nmax = EtaRefused SPARSE_SERIES
    <-> (h0 < theta /\ (exists D1, Delta_now = Some D1) /\ (exists D1p, Delta_prev = Some D1p) /\
         max_gap < gap).
Proof.
  intros h0 Delta_now Delta_prev theta eps max_gap gap Nmax.
  unfold eta_readout. destruct (Qlt_le_dec h0 theta) as [Hlt | Hge].
  - destruct Delta_now as [D1 | ]; destruct Delta_prev as [D1p | ];
      try (split; [intros H; discriminate H | intros [_ [[D1' H1] _]]; discriminate H1]);
      try (split; [intros H; discriminate H | intros [_ [_ [[D1p' H2] _]]]; discriminate H2]).
    destruct (Qlt_le_dec max_gap gap) as [Hg | Hg].
    + split; [intros _; repeat split; eauto | intros _; reflexivity].
    + destruct (Qlt_le_dec eps D1) as [Hr | Hr];
        [ destruct (eta_search h0 D1 (D2 D1 D1p) theta Nmax) as [n | ];
          (split; [intros H; discriminate H | intros [_ [_ [_ H]]]; exfalso; lra])
        | split; [intros H; discriminate H | intros [_ [_ [_ H]]]; exfalso; lra] ].
  - split; [intros H; discriminate H | intros [H _]; exfalso; lra].
Qed.

Theorem eta_readout_no_rise_iff :
  forall h0 Delta_now Delta_prev theta eps max_gap gap Nmax,
    eta_readout h0 Delta_now Delta_prev theta eps max_gap gap PumpUnchanged Nmax = EtaRefused NO_RISE
    <-> (h0 < theta /\ (exists D1, Delta_now = Some D1 /\ D1 <= eps) /\
         (exists D1p, Delta_prev = Some D1p) /\ gap <= max_gap).
Proof.
  intros h0 Delta_now Delta_prev theta eps max_gap gap Nmax.
  unfold eta_readout. destruct (Qlt_le_dec h0 theta) as [Hlt | Hge].
  - destruct Delta_now as [D1 | ]; destruct Delta_prev as [D1p | ];
      try (split; [intros H; discriminate H | intros [_ [[D1' [H1 _]] _]]; discriminate H1]);
      try (split; [intros H; discriminate H | intros [_ [_ [[D1p' H2] _]]]; discriminate H2]).
    destruct (Qlt_le_dec max_gap gap) as [Hg | Hg].
    + split; [intros H; discriminate H | intros [_ [_ [_ H]]]; exfalso; lra].
    + destruct (Qlt_le_dec eps D1) as [Hr | Hr].
      * destruct (eta_search h0 D1 (D2 D1 D1p) theta Nmax) as [n | ];
          (split; [intros H; discriminate H | intros [_ [[D1' [H1 Hr']] _]]; inversion H1; subst; exfalso; lra]).
      * split; [intros _; repeat split; eauto | intros _; reflexivity].
  - split; [intros H; discriminate H | intros [H _]; exfalso; lra].
Qed.

Theorem eta_readout_horizon_iff :
  forall h0 Delta_now Delta_prev theta eps max_gap gap Nmax,
    eta_readout h0 Delta_now Delta_prev theta eps max_gap gap PumpUnchanged Nmax = EtaRefused NOT_WITHIN_HORIZON
    <-> (h0 < theta /\ exists D1 D1p,
           Delta_now = Some D1 /\ Delta_prev = Some D1p /\
           gap <= max_gap /\ eps < D1 /\
           eta_search h0 D1 (D2 D1 D1p) theta Nmax = None).
Proof.
  intros h0 Delta_now Delta_prev theta eps max_gap gap Nmax.
  unfold eta_readout. destruct (Qlt_le_dec h0 theta) as [Hlt | Hge].
  - destruct Delta_now as [D1 | ]; destruct Delta_prev as [D1p | ];
      try (split; [intros H; discriminate H | intros [_ [D1' [D1p' [H1 _]]]]; discriminate H1]);
      try (split; [intros H; discriminate H | intros [_ [D1' [D1p' [_ [H2 _]]]]]; discriminate H2]).
    destruct (Qlt_le_dec max_gap gap) as [Hg | Hg].
    + split; [intros H; discriminate H | intros [_ [D1' [D1p' [H1 [H2 [H3 _]]]]]]; inversion H1; subst; exfalso; lra].
    + destruct (Qlt_le_dec eps D1) as [Hr | Hr].
      * destruct (eta_search h0 D1 (D2 D1 D1p) theta Nmax) as [n | ] eqn:Hs.
        -- split.
           ++ intros H; discriminate H.
           ++ intros [_ [D1' [D1p' [H1 [H2 [_ [_ Hnone]]]]]]].
              injection H1 as HeqD1. injection H2 as HeqD1p.
              subst D1' D1p'. rewrite Hs in Hnone. discriminate Hnone.
        -- split; [intros _; split; [exact Hlt | exists D1, D1p; repeat split; eauto] | intros _; reflexivity].
      * split; [intros H; discriminate H
                | intros [_ [D1' [D1p' [H1 [H2 [_ [H3 _]]]]]]]; inversion H1; subst; exfalso; lra].
  - split; [intros H; discriminate H | intros [H _]; exfalso; lra].
Qed.

(* the None case links directly to search_none_horizon, carried
   through eta_search (n0=1), confirming the refusal's own witness. *)
Corollary eta_readout_horizon_none_horizon :
  forall h0 D1 D2v theta Nmax,
    eta_search h0 D1 D2v theta Nmax = None ->
    forall m, (1 <= m)%nat -> (m <= Nmax)%nat -> level h0 D1 D2v m < theta.
Proof.
  intros h0 D1 D2v theta Nmax H m Hm1 Hm2.
  unfold eta_search in H. apply (search_none_horizon h0 D1 D2v theta Nmax 1 H m Hm1). lia.
Qed.
