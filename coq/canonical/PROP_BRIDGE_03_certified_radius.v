(* ===================================================================== *)
(*  PROP_BRIDGE_03_certified_radius.v                                    *)
(*  Discrete-Continuum Readout Bridge -- S3 RADIUS + S5 GATE             *)
(*  (proposal lane; every object defined or proved here is               *)
(*   NEW DERIVATION / PROPOSAL -- not yet in Toledo -- unless the line    *)
(*   says "occurrence of <code>", in which case the registered theorem   *)
(*   is Required and applied, never re-proved)                           *)
(* ===================================================================== *)
(*
  Bridge lines covered (DISCRETE_CONTINUUM_BRIDGE_DESIGN_v0.1.md, section 2, S3 and S5,
  under the section 11b rulings 1, 3, 4, 9):

    S3  RADIUS   over an abstract (Y, d_Y : Y -> Y -> Q), axioms declared PER CLAUSE
        d_Y(x, Lambda_K(q_K x)) <= beta_K  ,  d_Y(Lambda_K(q_K x), x^_K) <= rho_K
        r_K := rho_K + beta_K            [triangle inequality on d_Y declared for the clause]
        r_K^2 := rho_K^2 + beta_K^2      [Pythagorean identity carried as a scalar hypothesis;
                                          occurrence of PROP-EPSC-17, Required, not re-proved]
        contracting-family instance (S1): beta_K = |Delta g N| / (1 - rho), rho < 1 witnessed,
                                          from IDM_ReadoutTower.plateau_radius (Required)
        bridge_radius: |P x - P x^_K| <= L_P * r_K   [occurrence of PROP-EPSC-08, Required]
    S5  GATE     Certificate' := { r2 : Q | delta_K <= eps /\ (eps - delta_K)^2 >= r2 }
        gate' None = HOLD ; gate' (Some c) = ACCEPT r2 ; fail_closed' ; equiv_to_sum
        (the squared certificate is an OCCURRENCE of PROP-EPSC-03 -- ruling 11b-9: the
        Verdict type ACCEPT/HOLD is PROP_EPSC_03's own, reused; the two certificate types
        interconvert exactly when a rational root r, r*r == r2, exists: cert_of_epsc03 /
        epsc03_of_cert below are that interconversion as Coq terms)
    S5  ACCEPT theorem (ruling 11b-4, fixed statement):
        under a declared triangle inequality on d_Y,  0 <= r_K,
        cert : delta_K <= eps /\ (eps - delta_K)^2 >= r_K^2,
        d_Y(x, Lambda_K(q_K x)) <= r_K,  d_Y(Lambda_K(res_K x_{K+1}), Lambda_K(q_K x)) <= delta_K
          ==>  d_Y(x, Lambda_K(res_K x_{K+1})) <= eps.
        Proved here as `accept_certified` (delta_K bound oriented (Lambda_K(q_K x), y) --
        needs only the triangle inequality), `accept_certified_ruling_11b4` (the ruling's
        literal orientation -- needs symmetry of d_Y as one more declared clause axiom) and
        `gate_accept_certified` (the same through gate': an ACCEPT of the gate entails the
        bound on the object; Genesis V.14 "a gate whose pass entails nothing is a
        convention" is thereby discharged for this gate).  ACCEPT is NOT re-tiered.

  Typing (ruling 11b-1): q_K : Y -> R_K, Lambda_K : R_K -> Y, res_K : R_{K+1} -> R_K,
  P_K := Lambda_K o q_K; the object x and every distance live in the declared target Y.
  No P_K / R_K conflation; no bundle row (11b-5); no lineage_survives (11b-6).

  Genesis sections instantiated (READOUT_GENESIS_CORE.md): A.8 (Lambda o Sigma = I, the
  typed split), A.12 (a bridge carries a STATED non-zero recovery error r_K), A.13 defect
  vector (beta <-> eps_suff, rho <-> eps_read/eps_inv), A.13 Gate 1 (No-Free-Domain-Law:
  beta comes from a declared class -- here the S1 contracting family, never from R_K alone),
  A.13 Gate 2 Three-Valued Admissibility (no certificate ==> HOLD, never 0, never ACCEPT),
  V.14 / VI.7 fail-able gate law (gate'_fail_control: above tolerance only HOLD is
  constructible; gate'_pass_control: a concrete ACCEPT).

  Toledo parents by code (registry/CANONICAL.json + registry/proposals/*.json, read in the
  proposals/readout-bridge worktree @ b2413324; statements re-read in the .v files):
    R/M.32.v1        IDM-0057  refine_stable (IDM_Certified.v)  -> engine of the S1 beta supplier
                                (via IDM_ReadoutTower.plateau_certificate / plateau_radius)
    Keystone/P.08.v1 IDM-0140  pythagoras_orthogonal (IDM_Hilbert.v) -> discharges the scalar
                                Pythagorean hypothesis of squared_orthogonal when Y is a finite
                                Q inner-product space; cited, not Required (no IDM_Hilbert here)
    weld/H.06.v1     CAN-065   eps_H = Def(q~_H o F, F#_H o q~_H, O_H, Inv_H)  -> parent of the
                                composed radius (defect vector), Definition tier
    weld/E.05.v1     CAN-033   chi_G in {1,0,bot}         -> verdict alphabet (ACCEPT / HOLD)
    weld/E.06.v1     CAN-034   Suff in {1,0,bot}          -> why beta must be bounded, not assumed
    weld/E.08.v1     CAN-036   eps_bridge                 -> parent of delta_K (the observed defect)
    EQ-015/M.17.v1   RIVER-06  tolerance eps declared before the run
    Z/M.03.v1 (Delta), Z/M.08.v1 (telescope) via IDM_Calculus / IDM_ReadoutTower
  Proposal-lane parents (NOT yet in Toledo, codes weld/M.??.v1 / weld/P.??.v1):
    PROP-EPSC-03  PROP_EPSC_03_fail_closed_gate.v      (Verdict, gate, epsc03_fail_closed)
                  registry: tier Definition / status unverified; scratch Print Assumptions
                  Closed (inventory stage)
    PROP-EPSC-08  PROP_EPSC_08_lipschitz_tail_lift.v   (epsc08_lipschitz_tail_lift)
                  registry: Th_coqc / verified_by_coq; compiled here (no in-file Print Assumptions)
    PROP-EPSC-17  PROP_EPSC_17_orthogonal_composition.v (epsc17_squared_composition_bound)
                  registry: Dr / unverified (sqrt form not mechanised); the SQUARED form is
                  what is Required here.  READOUT (About, 2026-09-18): the exported theorem is
                    forall na2 nb2 nab2 rho2 beta2, nab2 == na2 + nb2 -> na2 <= rho2 ->
                    nb2 <= beta2 -> nab2 <= rho2 + beta2
                  -- its two nonnegativity hypotheses were never used by the proof and are
                  NOT abstracted; the file comment's "both nonnegative" is stronger than the
                  mechanised object.  Nonnegativity re-enters here only through sq_monotone
                  (to pass from d <= rho to d^2 <= rho^2).
    PROP-EPSC-05  negative control (P_K v = 0, v <> 0): cited only -- it is why beta is never
                  computed from R_K alone.  PROP-EPSC-23/39: the only registered rho suppliers;
                  cited only (ruling 11b-10) -- rho_K is a DECLARED datum here.

  REUSE record (EPIS-REUSE-PIPELINE steps 1-2, per new object):
    sq_monotone, sq_le_root           Toledo lookup: no row (keyword scan: one unrelated hit,
                                       q_formal/M.31.v1 EIV); stdlib parents Qmult_le_compat_r,
                                       Qmult_lt_compat_r.  Genesis: number-ladder arithmetic on Q.
    triangle_composition              no row; parent weld/H.06.v1 (defect vector), A.12.
    squared_triangle                  no row; = sq_monotone o triangle_composition.
    squared_orthogonal                OCCURRENCE of PROP-EPSC-17 (instantiated at squared d_Y).
    bridge_radius                     OCCURRENCE of PROP-EPSC-08 at beta := rho_K + beta_K.
    beta_S1, contracting_beta         OCCURRENCE of IDM_ReadoutTower.plateau_radius (itself an
                                       occurrence of R/M.32.v1); Y := Q, d_Y := dQ.
    contracting_radius                composition S1-supplier o triangle_composition in (Q, dQ).
    Certificate', gate', fail_closed', no_certificate_holds'
                                      OCCURRENCE of PROP-EPSC-03 (ruling 11b-9; Verdict reused).
    equiv_to_sum, cert_of_epsc03, epsc03_of_cert, gate_of_epsc03, gate_of_cert
                                      the occurrence relation as Coq terms (rational root needed).
    P_K, P_K_unfold                   typed split of ruling 11b-1 (A.8).
    accept_certified, gate_accept_certified, accept_certified_ruling_11b4, accept_certified_dQ
                                      ruling 11b-4; no row.
    dQ, dQ_nonneg, dQ_sym, dQ_triangle
                                      the Q-metric instance discharging the clause axioms
                                      (positive control that the Section hypotheses are
                                      satisfiable); stdlib parent Qabs_triangle; no row.
    gate'_fail_control, gate'_pass_control
                                      Fail-Able Gate Law witnesses (structural, in Q).

  What is NOT proved here (Open ledger, stance + falsifier in the stage result):
    (a) that the squared gate and the sum gate are NOT interderivable in general -- they
        agree exactly when a rational root exists (equiv_to_sum); for r2 with no rational
        root (e.g. r2 = 2) the squared form is the DEFINITION of the certificate.  The
        irrationality witness is not re-proved here.
    (b) any rho-supplier: rho_K is a declared datum (ruling 11b-3); where absent the domain
        defaults to HOLD.  Nothing here upgrades a beta or rho supplier's tier.

  Infinity audit: I1 refused (r2 = r_K^2 carried in Q, no square root formed anywhere;
  equiv_to_sum takes the root as a WITNESS r with r*r == r2); I2/I4 refused (every bound
  at the declared K / N; no limit); Z2 refused (r_K = 0, delta_K = 0 never assumed);
  Z4 refused (no certificate ==> HOLD, typed, never 0).  Division appears in this file only
  in beta_S1 := |Delta g N| / (1 - rho), a TOTAL Definition (Coq's Qdiv is total:
  beta_S1 g 1 N == 0 is provable and beta_S1 evaluates to -1 at rho = 2 -- scratch readout
  chk_indep3, 2026-09-18); it is meaningful only under the premise rho < 1, which every
  theorem using it carries (contracting_beta, contracting_radius, accept_certified_dQ).
  Corrected wording, fixer pass 2026-09-18, independent refuter finding.

  Compile mapping (ruling 11b-8 -- the LIVE IDM worktree is the source of truth, never
  Toledo's stale coq/information-discrete-math mirror):
    cd <toledo worktree>/coq/canonical &&
    coqc -q -Q . MRC -R <live IDM worktree> IDM PROP_BRIDGE_03_certified_radius.v
  (logical names: MRC.PROP_EPSC_* for the canonical files, IDM.formal.IDM_* for IDM).
  Memory floor: `free -g` before each compile, skip if available < 3 G, one coqc at a time
  under a memory cap; no verify.sh, no background jobs.

  Tier: every theorem below is Th_coqc only after the in-file `Print Assumptions` (end of
  file) and an independent scratch run printed "Closed under the global context".  Section
  hypotheses (d_triangle, d_sym, d_nonneg_*, pythagoras_dY, beta_cert, rho_cert, L_P_nonneg,
  P_lipschitz, r_K_nonneg, radius_cert, defect_cert*, Hrho1, Hcontr) are DISCLOSED here and
  become premises of the exported statements.  Nothing classical, no Reals, no unfinished proof.
*)

Require Import Coq.QArith.QArith.
Require Import Coq.QArith.Qabs.
Require Import Coq.micromega.Lqa.
From MRC Require Import PROP_EPSC_03_fail_closed_gate.
From MRC Require Import PROP_EPSC_08_lipschitz_tail_lift.
From MRC Require Import PROP_EPSC_17_orthogonal_composition.
From IDM.formal Require Import IDM_Calculus.
From IDM.formal Require Import IDM_ReadoutTower.

Open Scope Q_scope.

(* ===================================================================== *)
(*  Part 0 -- two elementary Q facts about squares (not yet in Toledo)     *)
(* ===================================================================== *)

(** Squaring is monotone on nonnegative rationals.  Parents: stdlib Qmult_le_compat_r. *)
Lemma sq_monotone : forall a b : Q, 0 <= a -> a <= b -> a * a <= b * b.
Proof.
  intros a b Ha Hab.
  assert (Hb : 0 <= b) by lra.
  pose proof (Qmult_le_compat_r a b a Hab Ha) as H1.
  pose proof (Qmult_le_compat_r a b b Hab Hb) as H2.
  lra.
Qed.

(** A nonnegative rational whose square is below a^2 (a >= 0) is below a.  This is the only
    place a "root" is ever compared, and it is compared as a WITNESS, never extracted. *)
Lemma sq_le_root : forall a r : Q, 0 <= a -> 0 <= r -> r * r <= a * a -> r <= a.
Proof.
  intros a r Ha Hr H.
  apply Qnot_lt_le. intro Hlt.
  pose proof (Qmult_le_compat_r a r a (Qlt_le_weak _ _ Hlt) Ha) as H1.
  assert (Hrpos : 0 < r) by lra.
  pose proof (Qmult_lt_compat_r a r r Hrpos Hlt) as H2.
  lra.
Qed.

(* ===================================================================== *)
(*  Part A -- S3 RADIUS over an abstract (Y, d_Y), axioms per clause       *)
(* ===================================================================== *)

Section CertifiedRadius.
  Variable Y : Type.
  Variable d_Y : Y -> Y -> Q.

  (* ---- clause 1: r_K := rho_K + beta_K under the triangle inequality ---- *)
  Section TriangleComposition.
    Hypothesis d_triangle : forall a b c : Y, d_Y a c <= d_Y a b + d_Y b c.
    Variables x xhat Px : Y.          (* x : object ; Px = Lambda_K (q_K x) ; xhat = x^_K *)
    Variables rho_K beta_K : Q.
    Hypothesis beta_cert : d_Y x Px <= beta_K.     (* outer: omitted by the record *)
    Hypothesis rho_cert  : d_Y Px xhat <= rho_K.   (* inner: reconstruction radius *)

    Theorem triangle_composition : d_Y x xhat <= rho_K + beta_K.
    Proof.
      pose proof (d_triangle x Px xhat) as H. lra.
    Qed.

    Hypothesis d_nonneg_x_xhat : 0 <= d_Y x xhat.

    Corollary squared_triangle :
      d_Y x xhat * d_Y x xhat <= (rho_K + beta_K) * (rho_K + beta_K).
    Proof.
      apply sq_monotone; [ exact d_nonneg_x_xhat | exact triangle_composition ].
    Qed.
  End TriangleComposition.

  (* ---- clause 2: r_K^2 := rho_K^2 + beta_K^2 -- OCCURRENCE of PROP-EPSC-17 ---- *)
  Section SquaredOrthogonal.
    Variables x xhat Px : Y.
    Variables rho_K beta_K : Q.
    Hypothesis d_nonneg_inner : 0 <= d_Y Px xhat.
    Hypothesis d_nonneg_outer : 0 <= d_Y x Px.
    (* The Pythagorean identity as the scalar hypothesis PROP_EPSC_17 carries; discharged
       by Keystone/P.08.v1 when Y is a finite Q inner-product space; Dr per domain else. *)
    Hypothesis pythagoras_dY :
      d_Y x xhat * d_Y x xhat == d_Y Px xhat * d_Y Px xhat + d_Y x Px * d_Y x Px.
    Hypothesis beta_cert : d_Y x Px <= beta_K.
    Hypothesis rho_cert  : d_Y Px xhat <= rho_K.

    Theorem squared_orthogonal :
      d_Y x xhat * d_Y x xhat <= rho_K * rho_K + beta_K * beta_K.
    Proof.
      exact (epsc17_squared_composition_bound
               (d_Y Px xhat * d_Y Px xhat) (d_Y x Px * d_Y x Px)
               (d_Y x xhat * d_Y x xhat) (rho_K * rho_K) (beta_K * beta_K)
               pythagoras_dY
               (sq_monotone _ _ d_nonneg_inner rho_cert)
               (sq_monotone _ _ d_nonneg_outer beta_cert)).
    Qed.
  End SquaredOrthogonal.

  (* ---- bridge_radius: the readout-side radius -- OCCURRENCE of PROP-EPSC-08 ---- *)
  Section BridgeRadius.
    Hypothesis d_triangle : forall a b c : Y, d_Y a c <= d_Y a b + d_Y b c.
    Variables x xhat Px : Y.
    Variables rho_K beta_K : Q.
    Hypothesis beta_cert : d_Y x Px <= beta_K.
    Hypothesis rho_cert  : d_Y Px xhat <= rho_K.
    Variable V : Type.                 (* the reader's value space *)
    Variable d_V : V -> V -> Q.
    Variable P : Y -> V.               (* the reader *)
    Variable L_P : Q.
    Hypothesis L_P_nonneg : 0 <= L_P.
    Hypothesis P_lipschitz : forall a b : Y, d_V (P a) (P b) <= L_P * d_Y a b.

    Theorem bridge_radius : d_V (P x) (P xhat) <= L_P * (rho_K + beta_K).
    Proof.
      apply (epsc08_lipschitz_tail_lift Y d_Y V d_V P L_P L_P_nonneg P_lipschitz
               x xhat (rho_K + beta_K)).
      apply triangle_composition with (Px := Px); assumption.
    Qed.
  End BridgeRadius.
End CertifiedRadius.

(** The registered scalar theorem itself, unchanged -- the occurrence relation made literal. *)
Definition squared_orthogonal_scalar := epsc17_squared_composition_bound.

(* ===================================================================== *)
(*  Part B -- S5 GATE: the squared certificate (OCCURRENCE of PROP-EPSC-03) *)
(* ===================================================================== *)

Section SquaredGate.
  Variable delta_K eps : Q.

  (* r2 = r_K^2, carried in Q; no square root anywhere.  `>=` is Q's parsing-only
     notation: (eps - delta_K)^2 >= r2  IS  r2 <= (eps - delta_K) * (eps - delta_K). *)
  Definition Certificate' :=
    { r2 : Q | delta_K <= eps /\ (eps - delta_K) * (eps - delta_K) >= r2 }.

  (* Same Verdict type as PROP_EPSC_03 (ACCEPT carries the certified r2). *)
  Definition gate' (cert : option Certificate') : Verdict :=
    match cert with
    | Some (exist _ r2 _) => ACCEPT r2
    | None => HOLD
    end.

  Theorem fail_closed' : forall (cert : option Certificate') (r2 : Q),
    gate' cert = ACCEPT r2 ->
    delta_K <= eps /\ (eps - delta_K) * (eps - delta_K) >= r2.
  Proof.
    intros cert r2 H. unfold gate' in H.
    destruct cert as [[c Hc] | ].
    - injection H as ->. exact Hc.
    - discriminate H.
  Qed.

  Theorem no_certificate_holds' : gate' None = HOLD.
  Proof. reflexivity. Qed.

  (** The squared certificate equals PROP-EPSC-03's sum certificate delta_K + r <= eps
      EXACTLY when a rational root r >= 0 with r * r == r2 is exhibited (ruling 11b-9). *)
  Lemma equiv_to_sum : forall r r2 : Q, 0 <= r -> r * r == r2 ->
    ((delta_K <= eps /\ (eps - delta_K) * (eps - delta_K) >= r2) <-> delta_K + r <= eps).
  Proof.
    intros r r2 Hr Hroot. split.
    - intros [Hle Hsq].
      assert (Hnn : 0 <= eps - delta_K) by lra.
      assert (Hrr : r * r <= (eps - delta_K) * (eps - delta_K)) by lra.
      pose proof (sq_le_root (eps - delta_K) r Hnn Hr Hrr) as Hle2.
      lra.
    - intro Hsum.
      assert (Hrr : r * r <= (eps - delta_K) * (eps - delta_K)) by (apply sq_monotone; lra).
      split; lra.
  Qed.

  (** Interconversion of the two certificate types, as terms (transparent). *)
  Definition cert_of_epsc03 (c : Certificate delta_K eps) (Hnn : 0 <= proj1_sig c)
    : Certificate' :=
    exist _ (proj1_sig c * proj1_sig c)
          (proj2 (equiv_to_sum (proj1_sig c) (proj1_sig c * proj1_sig c) Hnn (Qeq_refl _))
                 (proj2_sig c)).

  Theorem gate_of_epsc03 : forall (c : Certificate delta_K eps) (Hnn : 0 <= proj1_sig c),
    gate' (Some (cert_of_epsc03 c Hnn)) = ACCEPT (proj1_sig c * proj1_sig c).
  Proof. intros c Hnn. reflexivity. Qed.

  Definition epsc03_of_cert (c : Certificate') (r : Q) (Hr : 0 <= r)
    (Hroot : r * r == proj1_sig c) : Certificate delta_K eps :=
    exist _ r (proj1 (equiv_to_sum r (proj1_sig c) Hr Hroot) (proj2_sig c)).

  Theorem gate_of_cert : forall (c : Certificate') (r : Q) (Hr : 0 <= r)
    (Hroot : r * r == proj1_sig c),
    gate delta_K eps (Some (epsc03_of_cert c r Hr Hroot)) = ACCEPT r.
  Proof. intros. reflexivity. Qed.
End SquaredGate.

(** Fail-Able Gate Law witnesses (Genesis V.14 / VI.7).  Negative: above tolerance no
    ACCEPT is constructible, every input HOLDs.  Positive: a concrete ACCEPT. *)
Example gate'_fail_control : forall (delta_K eps : Q), eps < delta_K ->
  forall cert : option (Certificate' delta_K eps), gate' delta_K eps cert = HOLD.
Proof.
  intros delta_K eps Hlt cert.
  destruct cert as [[r2 [Hle Hsq]] | ]; [ exfalso; lra | reflexivity ].
Qed.

Example gate'_pass_control : exists c : Certificate' 1 2, gate' 1 2 (Some c) = ACCEPT 1.
Proof.
  assert (H : 1 <= 2 /\ (2 - 1) * (2 - 1) >= 1) by (split; lra).
  exists (exist _ 1 H). reflexivity.
Qed.

(* ===================================================================== *)
(*  Part C -- S5 ACCEPT theorem (ruling 11b-4) with the 11b-1 typing split *)
(* ===================================================================== *)

Section AcceptCertified.
  Variable Y : Type.
  Variable d_Y : Y -> Y -> Q.
  Hypothesis d_triangle : forall a b c : Y, d_Y a c <= d_Y a b + d_Y b c.

  Variable RK RK1 : Type.              (* R_K and R_{K+1} *)
  Variable q_K : Y -> RK.              (* forward map (occurrence of weld/M.02 + M.03) *)
  Variable Lambda_K : RK -> Y.         (* section: read the record back into Y *)
  Variable res_K : RK1 -> RK.          (* restriction from the next resolution *)

  Definition P_K (y : Y) : Y := Lambda_K (q_K y).
  Lemma P_K_unfold : forall y : Y, P_K y = Lambda_K (q_K y).
  Proof. reflexivity. Qed.

  Variable x : Y.                      (* the object *)
  Variable xK1 : RK1.                  (* the next-resolution record x_{K+1} *)
  Variable delta_K eps r_K : Q.
  Hypothesis r_K_nonneg : 0 <= r_K.
  Hypothesis radius_cert : d_Y x (Lambda_K (q_K x)) <= r_K.          (* S3 *)

  Section Oriented.
    Hypothesis defect_cert : d_Y (Lambda_K (q_K x)) (Lambda_K (res_K xK1)) <= delta_K.

    Theorem accept_certified :
      delta_K <= eps -> (eps - delta_K) * (eps - delta_K) >= r_K * r_K ->
      d_Y x (Lambda_K (res_K xK1)) <= eps.
    Proof.
      intros Hle Hsq.
      assert (Hsum : delta_K + r_K <= eps).
      { exact (proj1 (equiv_to_sum delta_K eps r_K (r_K * r_K) r_K_nonneg (Qeq_refl _))
                     (conj Hle Hsq)). }
      pose proof (d_triangle x (Lambda_K (q_K x)) (Lambda_K (res_K xK1))) as Ht.
      lra.
    Qed.

    (** Through the gate: an ACCEPT of gate' entails the bound on the object. *)
    Theorem gate_accept_certified : forall cert : option (Certificate' delta_K eps),
      gate' delta_K eps cert = ACCEPT (r_K * r_K) ->
      d_Y x (Lambda_K (res_K xK1)) <= eps.
    Proof.
      intros cert Hg.
      destruct (fail_closed' delta_K eps cert (r_K * r_K) Hg) as [Hle Hsq].
      exact (accept_certified Hle Hsq).
    Qed.
  End Oriented.

  Section RulingForm.
    Hypothesis d_sym : forall a b : Y, d_Y a b == d_Y b a.
    Hypothesis defect_cert_ruling :
      d_Y (Lambda_K (res_K xK1)) (Lambda_K (q_K x)) <= delta_K.

    Theorem accept_certified_ruling_11b4 :
      delta_K <= eps -> (eps - delta_K) * (eps - delta_K) >= r_K * r_K ->
      d_Y x (Lambda_K (res_K xK1)) <= eps.
    Proof.
      intros Hle Hsq.
      apply accept_certified; [ | exact Hle | exact Hsq ].
      pose proof (d_sym (Lambda_K (q_K x)) (Lambda_K (res_K xK1))) as Hs.
      lra.
    Qed.
  End RulingForm.
End AcceptCertified.

(* ===================================================================== *)
(*  Part D -- the Q-metric instance: clause axioms discharged, S1 supplier *)
(* ===================================================================== *)

Definition dQ (a b : Q) : Q := Qabs (a - b).

Lemma dQ_nonneg : forall a b : Q, 0 <= dQ a b.
Proof. intros a b. apply Qabs_nonneg. Qed.

Lemma dQ_sym : forall a b : Q, dQ a b == dQ b a.
Proof.
  intros a b. unfold dQ.
  apply Qeq_trans with (y := Qabs (- (a - b))).
  - symmetry. apply Qabs_opp.
  - apply Qabs_wd. ring.
Qed.

Lemma dQ_triangle : forall a b c : Q, dQ a c <= dQ a b + dQ b c.
Proof.
  intros a b c. unfold dQ.
  pose proof (Qabs_triangle (a - b) (b - c)) as H.
  assert (He : a - b + (b - c) == a - c) by ring.
  rewrite (Qabs_wd _ _ He) in H.
  exact H.
Qed.

(** S3 contracting-family instance: beta_K from S1 (occurrence of plateau_radius). *)
Section ContractingBeta.
  Variable g : nat -> Q.
  Variable rho : Q.
  Hypothesis Hrho1 : rho < 1.
  Hypothesis Hcontr : forall k, Qabs (Delta g (S k)) <= rho * Qabs (Delta g k).
  Variable N : nat.

  Definition beta_S1 : Q := Qabs (Delta g N) / (1 - rho).

  Theorem contracting_beta : forall M : nat, dQ (g (N + M)%nat) (g N) <= beta_S1.
  Proof.
    intro M. unfold dQ, beta_S1. apply plateau_radius; assumption.
  Qed.
End ContractingBeta.

(** S1 supplier composed with clause 1 in (Q, dQ): the record g N, the object g (N+M),
    any reconstruction xhat within rho_K of the record. *)
Corollary contracting_radius : forall (g : nat -> Q) (rho : Q),
  rho < 1 ->
  (forall k, Qabs (Delta g (S k)) <= rho * Qabs (Delta g k)) ->
  forall (N M : nat) (xhat rho_K : Q),
    dQ (g N) xhat <= rho_K ->
    dQ (g (N + M)%nat) xhat <= rho_K + beta_S1 g rho N.
Proof.
  intros g rho Hrho Hcontr N M xhat rho_K Hrho_cert.
  apply triangle_composition with (Px := g N).
  - exact dQ_triangle.
  - apply contracting_beta; assumption.
  - exact Hrho_cert.
Qed.

(** The ACCEPT theorem with every clause axiom discharged in (Q, dQ). *)
Corollary accept_certified_dQ :
  forall (RK RK1 : Type) (q_K : Q -> RK) (Lambda_K : RK -> Q) (res_K : RK1 -> RK)
         (x : Q) (xK1 : RK1) (delta_K eps r_K : Q),
    0 <= r_K ->
    dQ x (Lambda_K (q_K x)) <= r_K ->
    dQ (Lambda_K (res_K xK1)) (Lambda_K (q_K x)) <= delta_K ->
    delta_K <= eps -> (eps - delta_K) * (eps - delta_K) >= r_K * r_K ->
    dQ x (Lambda_K (res_K xK1)) <= eps.
Proof.
  intros RK RK1 q_K Lambda_K res_K x xK1 delta_K eps r_K Hr Hrad Hdef Hle Hsq.
  apply (accept_certified_ruling_11b4 Q dQ dQ_triangle RK RK1 q_K Lambda_K res_K x xK1
           delta_K eps r_K Hr Hrad dQ_sym Hdef Hle Hsq).
Qed.

(* ===================================================================== *)
(*  In-file readout: Print Assumptions for every object above              *)
(* ===================================================================== *)
Print Assumptions sq_monotone.
Print Assumptions sq_le_root.
Print Assumptions triangle_composition.
Print Assumptions squared_triangle.
Print Assumptions squared_orthogonal.
Print Assumptions squared_orthogonal_scalar.
Print Assumptions bridge_radius.
Print Assumptions Certificate'.
Print Assumptions gate'.
Print Assumptions fail_closed'.
Print Assumptions no_certificate_holds'.
Print Assumptions equiv_to_sum.
Print Assumptions cert_of_epsc03.
Print Assumptions gate_of_epsc03.
Print Assumptions epsc03_of_cert.
Print Assumptions gate_of_cert.
Print Assumptions gate'_fail_control.
Print Assumptions gate'_pass_control.
Print Assumptions P_K.
Print Assumptions P_K_unfold.
Print Assumptions accept_certified.
Print Assumptions gate_accept_certified.
Print Assumptions accept_certified_ruling_11b4.
Print Assumptions dQ.
Print Assumptions dQ_nonneg.
Print Assumptions dQ_sym.
Print Assumptions dQ_triangle.
Print Assumptions beta_S1.
Print Assumptions contracting_beta.
Print Assumptions contracting_radius.
Print Assumptions accept_certified_dQ.
