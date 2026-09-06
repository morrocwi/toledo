(* ===================================================================== *)
(*  InfoThetaTopologyReadout_attempt.v — topology is a readout, step 5.2a  *)
(*  of THETA_ROOT_PROGRAM.md (companion to theta_topology_readout_v1.py). *)
(*                                                                         *)
(*  Machine-checked here, all over Q, axiom-free (Print Assumptions):      *)
(*                                                                         *)
(*   R1 edge_source_bilinear_01/02/12 — the per-edge Gate-D geometry       *)
(*      source is exactly the product of retained differences:             *)
(*      Phi^T L_e Psi = (Phi_i - Phi_j)(Psi_i - Psi_j), each 3-vertex      *)
(*      edge, arbitrary rational profiles (entrywise convention).          *)
(*   R2 clipped_stationarity_absent / clipped_stationarity_present —       *)
(*      for quadratic edge cost (mu/2)w^2 with mu>0, K>0 on the census     *)
(*      cone w>=0: if the discordance s>=0 the cost is minimized at w=0    *)
(*      (edge ABSENT); if s<0 the interior stationary point w*=-Ks/mu is   *)
(*      strictly positive and minimizes the cost (edge PRESENT).           *)
(*      Together: stationary support = the discordance pattern.            *)
(*   R3 discordance_complement_flip — negating the record profile flips    *)
(*      the sign of every pairwise discordance (so realizable supports     *)
(*      are closed under complement); plus two exact witnesses:            *)
(*      total reversal realizes the all-discordant (K3) support, and a     *)
(*      named partial-disorder profile realizes exactly two discordant     *)
(*      pairs (a P3-shape support).                                        *)
(*                                                                         *)
(*  READING (Dr, comment only): the family topology is never an input —    *)
(*  it is the readout of the reader/record discordance pattern under the   *)
(*  root's own Gate-D stationarity + the Theta edge census.  Which         *)
(*  pattern the coupled dynamics SELECTS is step 5.2b, open.               *)
(*                                                                         *)
(*  HONESTY NOTE (same convention as the census files): statements are     *)
(*  ENTRYWISE transliterations; the matrix<->entry mapping is fixed by     *)
(*  the canonical single-edge-Laplacian constants in comments, checked by  *)
(*  inspection, not inside Coq.  STATIC/FIXED-POINT CASE ONLY: at a fixed  *)
(*  point of Gate D's dynamic law the M_Theta second-difference term       *)
(*  vanishes, reducing the law to grad U(w) = -K s per edge at FROZEN      *)
(*  (Phi,Psi); the dynamic transient and (Phi,Psi) co-evolution are        *)
(*  untouched (step 5.2b).  Minimality is machine-checked in NON-STRICT    *)
(*  form only; uniqueness of the cone-minimizer (hence THE stationary      *)
(*  weight) follows from strict convexity mu>0 by inspection, not inside   *)
(*  Coq.  The quadratic cost is the simplest admissible declared choice    *)
(*  (Gate D's own fixture is quadratic); cost-independence of the support  *)
(*  rule is EXPECTED only for coercive strictly convex U with U'(0)=0 and  *)
(*  is OPEN beyond one checked instance (a bounded-slope convex U admits   *)
(*  no minimizer at all for s<0 — the coercivity hypothesis is required).  *)
(*                                                                         *)
(*  CRRC guard (binding): no vertex/edge/support is identified with        *)
(*  generations or any physics quantity here.                              *)
(* ===================================================================== *)

Require Import QArith.
Require Import Psatz.

(* ---------------------------------------------------------------------- *)
(*  R1 · the bilinear edge identity.  Profiles Phi=(p0,p1,p2),             *)
(*  Psi=(s0,s1,s2).  For edge (i,j), Phi^T L_e Psi expands entrywise to    *)
(*  p_i s_i - p_i s_j - p_j s_i + p_j s_j.                                 *)
(* ---------------------------------------------------------------------- *)
Theorem edge_source_bilinear_01 :
  forall p0 p1 s0 s1 : Q,
    (p0*s0 - p0*s1 - p1*s0 + p1*s1 == (p0 - p1) * (s0 - s1))%Q.
Proof. intros; ring. Qed.

Theorem edge_source_bilinear_02 :
  forall p0 p2 s0 s2 : Q,
    (p0*s0 - p0*s2 - p2*s0 + p2*s2 == (p0 - p2) * (s0 - s2))%Q.
Proof. intros; ring. Qed.

Theorem edge_source_bilinear_12 :
  forall p1 p2 s1 s2 : Q,
    (p1*s1 - p1*s2 - p2*s1 + p2*s2 == (p1 - p2) * (s1 - s2))%Q.
Proof. intros; ring. Qed.

(* ---------------------------------------------------------------------- *)
(*  R2 · clipped stationarity on the census cone w >= 0, edge cost         *)
(*  f(w) = (mu/2) w^2 + K s w, discordance s := (Phi_i-Phi_j)(Psi_i-Psi_j).*)
(* ---------------------------------------------------------------------- *)

(* helper lemmas (explicit, no nonlinear-arithmetic tactic needed).         *)
Lemma Qmult_pos_pos : forall a b : Q, (0 < a)%Q -> (0 < b)%Q -> (0 < a * b)%Q.
Proof.
  intros a b Ha Hb.
  setoid_replace 0%Q with (0 * b)%Q by ring.
  apply Qmult_lt_compat_r; assumption.
Qed.

Lemma Qsquare_nonneg : forall d : Q, (0 <= d * d)%Q.
Proof.
  intro d. destruct (Qlt_le_dec d 0) as [H | H].
  - setoid_replace (d * d)%Q with ((- d) * (- d))%Q by ring.
    apply Qmult_le_0_compat; lra.
  - apply Qmult_le_0_compat; lra.
Qed.

(* both statements are given in the DOUBLED, division-free form: the cost   *)
(* is written as 2f(w) = mu w^2 + 2 K s w (same minimizers, no Q-division   *)
(* — keeps every proof inside polynomial arithmetic), and the interior      *)
(* stationary point is characterized implicitly by mu w* = -K s.            *)

(* concordant or tied pair (s >= 0): w = 0 minimizes on the cone — ABSENT. *)
Theorem clipped_stationarity_absent :
  forall mu K s w : Q,
    (0 < mu)%Q -> (0 < K)%Q -> (0 <= s)%Q -> (0 <= w)%Q ->
    (0 <= mu * w * w + (2#1) * K * s * w)%Q.
Proof.
  intros mu K s w Hmu HK Hs Hw.
  assert (H1 : (0 <= mu * (w * w))%Q)
    by (apply Qmult_le_0_compat; [ lra | apply Qsquare_nonneg ]).
  assert (HKs : (0 <= K * s)%Q) by (apply Qmult_le_0_compat; lra).
  assert (H2 : (0 <= (K * s) * w)%Q) by (apply Qmult_le_0_compat; lra).
  setoid_replace (mu * w * w + (2#1) * K * s * w)%Q
    with (mu * (w * w) + (2#1) * ((K * s) * w))%Q by ring.
  lra.
Qed.

(* discordant pair (s < 0): the stationary weight w* (characterized by      *)
(* mu w* = -K s) is strictly positive and minimizes the cost over ALL w     *)
(* (a fortiori on the cone) — PRESENT.                                      *)
Theorem clipped_stationarity_present :
  forall mu K s w wstar : Q,
    (0 < mu)%Q -> (0 < K)%Q -> (s < 0)%Q ->
    (mu * wstar == - (K * s))%Q ->
    (0 < wstar)%Q /\
    (mu * wstar * wstar + (2#1) * K * s * wstar
     <= mu * w * w + (2#1) * K * s * w)%Q.
Proof.
  intros mu K s w wstar Hmu HK Hs Heq.
  assert (HKs : (K * s < 0)%Q).
  { setoid_replace (K * s)%Q with (- (K * (- s)))%Q by ring.
    assert (0 < K * (- s))%Q by (apply Qmult_pos_pos; lra). lra. }
  assert (Hws : (0 < wstar)%Q).
  { destruct (Qlt_le_dec 0 wstar) as [H | H]; [ exact H |].
    (* wstar <= 0 with mu > 0 gives mu*wstar <= 0, contradicting Heq = -Ks > 0 *)
    assert (Hle : (mu * wstar <= mu * 0)%Q)
      by (apply Qmult_le_l; [ exact Hmu | exact H ]).
    lra. }
  split; [ exact Hws |].
  assert (Hmusq : (0 <= mu * ((w - wstar) * (w - wstar)))%Q)
    by (apply Qmult_le_0_compat; [ lra | apply Qsquare_nonneg ]).
  (* 2f(w) - 2f(wstar) = mu (w-wstar)^2 + 2 (mu wstar + K s)(w - wstar),
     and the second term vanishes by the stationarity characterization Heq.  *)
  assert (Hzero : (mu * wstar + K * s == 0)%Q) by lra.
  assert (Hid : (mu * w * w + (2#1) * K * s * w
                 - (mu * wstar * wstar + (2#1) * K * s * wstar)
                 == mu * ((w - wstar) * (w - wstar))
                    + (2#1) * ((mu * wstar + K * s) * (w - wstar)))%Q) by ring.
  rewrite Hzero in Hid. ring_simplify in Hid. lra.
Qed.

(* ---------------------------------------------------------------------- *)
(*  R3 · complement closure + witnesses.                                   *)
(* ---------------------------------------------------------------------- *)

(* negating the record flips every pairwise discordance product.           *)
Theorem discordance_complement_flip :
  forall pi pj si sj : Q,
    ((pi - pj) * ((- si) - (- sj)) == - ((pi - pj) * (si - sj)))%Q.
Proof. intros; ring. Qed.

(* witness: total reversal Phi=(1,2,3), Psi=(3,2,1) makes ALL three pairs  *)
(* discordant — the K3 (complete) support is realizable.                   *)
Theorem witness_total_disorder_K3 :
  ((1 - 2) * (3 - 2) < 0)%Q /\
  ((1 - 3) * (3 - 1) < 0)%Q /\
  ((2 - 3) * (2 - 1) < 0)%Q.
Proof. repeat split; reflexivity. Qed.

(* witness: partial disorder Phi=(3,1,2), Psi=(-2,-1,-5) makes exactly the *)
(* pairs (0,1) and (1,2) discordant and (0,2) concordant — a P3-shape      *)
(* support is realizable.                                                  *)
Theorem witness_partial_disorder_P3 :
  ((3 - 1) * ((-2) - (-1)) < 0)%Q /\
  (0 < (3 - 2) * ((-2) - (-5)))%Q /\
  ((1 - 2) * ((-1) - (-5)) < 0)%Q.
Proof. repeat split; reflexivity. Qed.
