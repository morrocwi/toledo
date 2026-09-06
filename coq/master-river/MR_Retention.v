(** * MR_Retention.v — Master Equation River, Block B: eq. (35)-(42)
    (= \label{eq:lowrank}/\label{eq:gate}, per the task's own numbering
    "eq:lowrank/eq:gate = (35)/(36)", plus eq. 37-42)

    Source of record: research/society-justice-peace/master-river/v1_3/main.tex
    (Master Equation River v1.3), Section 3.9 "Within-Session Amplification,
    Retention, and Epistemic Direction" (\label{sec:humanai2}, the
    "Session retention" paragraph and eq. 37-40) and Section 3.10 "Human
    Return and CTSA as the Upper Measurement Boundary" (\label{sec:return1},
    eq. 41-42).

    Tier source: the paper's own text at \label{eq:lowrank}-\label{eq:gate}:
    "Equations \eqref{eq:lowrank}-\eqref{eq:gate} are Master's own proposal
    ... they are not v8.1's own text" — a notation proposal, i.e.
    Definition-tier, not a re-derivation of anything already proved in the
    cited source. Table 2 (\label{tab:status}) lists "Candidate status and
    direction ... kept separate from fluency/amplification" (eq. 38) and the
    "three-axis outcome that v8.1 forbids collapsing into a single score"
    (eq. 40) among the constitutive/non-collapse content; the closing
    non-collapse of Section 3.10 (eq. 42) is stated in the same pairwise
    "<>" form as eq. (11) and eq. (24).

    DISCIPLINE: readout-first, as in MR_Live.v/MR_Prompt.v — no [Reals], no
    classical axioms, [Q]-valued content, Section+Variables/Hypotheses for
    abstract objects, no top-level [Parameter]/[Axiom], no [Admitted]. The
    low-rank structural condition (eq. 35) is modelled with an abstract
    [nat]-valued rank function and a strict [nat] bound, never a continuum
    matrix norm.
*)

From Coq Require Import QArith.
From Coq Require Import Lqa.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

(* ------------------------------------------------------------------ *)
(** ** Section: the candidate restricted update and the retention gate
       (eq. 35-36) *)

Section RetentionGate.

  Variables Matrix Bmat Amat : Type.

  (* eq. (35) = \label{eq:lowrank} — tier: Definition *)
  (** Delta-Omega-tilde^H_s = B_s A_s, rank(B_s A_s) << d_H.  Master's own
      proposal for a candidate restricted update: a declared product of two
      abstract factor matrices, constrained to have rank strictly below the
      full state dimension [d_H].  Rank is a discrete [nat]-valued readout
      of the (abstract) matrix, never a continuum norm. *)
  Variable mat_mul : Bmat -> Amat -> Matrix.
  Variable rank_of : Matrix -> nat.

  Definition candidate_update (Bs : Bmat) (As : Amat) : Matrix := mat_mul Bs As.

  Definition is_low_rank (Bs : Bmat) (As : Amat) (d_H : nat) : Prop :=
    (rank_of (candidate_update Bs As) < d_H)%nat.

  (* eq. (36) = \label{eq:gate} — tier: Definition *)
  (** Omega^H_{s+1,0} = Omega^H_{s,0} + eta_s * Delta-Omega-tilde^H_s,
      0<=eta_s<=1.  The retention gate: the candidate restricted update is
      applied once, scaled by a single gate weight [eta_s] in [0,1] — by
      construction *not* the doubled-eta form of the undeposited draft
      discussed in \Cref{sec:etagate} (no eq. label of its own), which the
      supporting theorem below records explicitly. *)
  Variables OmegaState : Type.
  Variable omega_plus : OmegaState -> Matrix -> OmegaState.
  Variable scale_matrix : Q -> Matrix -> Matrix.

  Definition retention_gate_update (omega_s0 : OmegaState) (eta_s : Q)
             (Bs : Bmat) (As : Amat) : OmegaState :=
    omega_plus omega_s0 (scale_matrix eta_s (candidate_update Bs As)).

  Definition gate_weight_valid (eta_s : Q) : Prop := 0 <= eta_s <= 1.

  (** Supporting fact (not itself a new equation number): Master's
      single-eta gate genuinely CAN differ from the rejected double-eta
      draft form (which would scale by [eta_s] a second time) — a concrete
      witnessed instance that the correction in \Cref{sec:etagate} is a
      real, checkable difference and not a purely cosmetic rewrite, for a
      gate weight strictly between 0 and 1 (the very range the gate's own
      [0<=eta_s<=1] typing allows). *)
  Theorem gate_avoids_eta_doubling_witness :
    exists eta_s delta : Q, eta_s * delta <> (eta_s * eta_s) * delta.
  Proof.
    exists (1 # 2), 1.
    vm_compute. congruence.
  Qed.

End RetentionGate.

(* ------------------------------------------------------------------ *)
(** ** Section: AI-side momentum reset, candidate status, and sign-matched
       expansion (eq. 37-39) *)

Section MomentumCandidateSign.

  (* eq. (37) — tier: Definition *)
  (** m^AI_{s+1,0} = 0.  AI-side semantic momentum resets across sessions —
      an explicit scope condition of the Fusion/Tunnel model, stated here
      as a [Prop]-valued predicate on a momentum trace, not a universal
      fact about every AI architecture (the paper is explicit on this
      point). *)
  Definition ai_momentum_resets (m : nat -> Q) (s : nat) : Prop := m s = 0.

  (* eq. (38) — tier: Th_coqc *)
  (** AI(Q) = K_like, K_like <> K_validated.  Candidate status and
      validated status are two distinct readouts — a witnessed non-collapse
      on a 2-point enumerated model, exactly as MR_Resonance.v's eq. (11)
      pattern. *)
  Inductive KnowledgeStatus : Type := K_like | K_validated.

  Definition status_value (k : KnowledgeStatus) : nat :=
    match k with K_like => 0 | K_validated => 1 end.

  Theorem eq38_candidate_status_non_collapse :
    status_value K_like <> status_value K_validated.
  Proof. unfold status_value. discriminate. Qed.

  (* eq. (39) — tier: Th_coqc *)
  (** Delta_s := G_s - T_s, sign(Delta P_H(s)) = sign(eta_s * Delta_s),
      eta_s >= 0.  We prove the case the paper's sign-matching identity
      actually asserts something non-trivial about: for a strictly
      positive gate weight, scaling by [eta_s] preserves the strict sign
      of [Delta_s] (both the positive and the negative case), proved over
      [Q] using the stdlib order-compatibility lemmas for multiplication —
      an accounting identity about how the gate weight and the
      gain-minus-tunnel balance jointly determine the direction of net
      human-performance change, not a claim about what causes that
      change. *)
  Definition Delta_gt (G_s T_s : Q) : Q := G_s - T_s.

  Theorem eq39_sign_scale_pos_case :
    forall eta_s delta : Q, 0 < eta_s -> 0 < delta -> 0 < eta_s * delta.
  Proof. intros. apply Qmult_lt_0_compat; assumption. Qed.

  Theorem eq39_sign_scale_neg_case :
    forall eta_s delta : Q, 0 < eta_s -> delta < 0 -> eta_s * delta < 0.
  Proof.
    intros eta_s delta Heta Hdelta.
    apply (Qmult_lt_compat_r delta 0 eta_s Heta) in Hdelta.
    rewrite Qmult_0_l in Hdelta.
    rewrite Qmult_comm in Hdelta.
    exact Hdelta.
  Qed.

  Theorem eq39_sign_scale_zero_case :
    forall delta : Q, 0 * delta == 0.
  Proof. intro. apply Qmult_0_l. Qed.

End MomentumCandidateSign.

(* ------------------------------------------------------------------ *)
(** ** Section: the three-axis outcome (eq. 40) *)

Section ThreeAxisOutcome.

  Variables Pjoint PH PAI : Q.

  (* eq. (40) — tier: Th_coqc *)
  (** J*_s = (AUG_s, SYN_s, RET_s), AUG_s = P^joint_s - P^H_s, SYN_s =
      P^joint_s - max(P^H_s, P^AI_s).  v8.1 "forbids collapsing into a
      single score": we prove this is a real, checkable non-collapse —
      AUG and SYN genuinely differ whenever the AI alone outperforms the
      human alone (P^AI_s > P^H_s), since then max(P^H_s,P^AI_s) = P^AI_s
      <> P^H_s, so the two axes subtract different quantities from the
      same P^joint_s. Proved over [Q] with the stdlib [Qmax] order facts,
      not assumed. *)
  Definition AUG (Pjoint_s PH_s : Q) : Q := Pjoint_s - PH_s.

  Definition SYN (Pjoint_s PH_s PAI_s : Q) : Q :=
    Pjoint_s - (if Qle_bool PH_s PAI_s then PAI_s else PH_s).

  Theorem eq40_aug_syn_non_collapse :
    forall Pjoint_s PH_s PAI_s : Q,
      PH_s < PAI_s ->
      ~ (AUG Pjoint_s PH_s == SYN Pjoint_s PH_s PAI_s).
  Proof.
    intros Pjoint_s PH_s PAI_s Hlt Heq.
    unfold AUG, SYN in Heq.
    assert (Hle : Qle_bool PH_s PAI_s = true).
    { apply Qle_bool_iff. apply Qlt_le_weak. exact Hlt. }
    rewrite Hle in Heq.
    lra.
  Qed.

End ThreeAxisOutcome.

(* ------------------------------------------------------------------ *)
(** ** Section: Human Return and the closing non-collapse (eq. 41-42) *)

Section HumanReturn.

  Variables Gains Losses MetaReg Provenance Warrant EpiDirection : Type.

  (* eq. (41) — tier: Definition *)
  (** H_return = <G_CTSA, L, M, P, W, Delta_dir>.  CTSA's audit record,
      renamed from R_H (\Cref{sec:rcollide}) so as not to collide with R's
      other roles: a typed 6-tuple. *)
  Definition HReturn : Type :=
    Gains * Losses * MetaReg * Provenance * Warrant * EpiDirection.

  Definition mk_h_return (g : Gains) (l : Losses) (m : MetaReg) (p : Provenance)
             (w : Warrant) (d : EpiDirection) : HReturn := (g, l, m, p, w, d).

  (* eq. (42) — tier: Th_coqc *)
  (** "Exposure <> Retention <> Improvement, Accessibility <> Warrant <>
      Truth."  Two independent triples of pairwise-distinct notions,
      formalised exactly as MR_Resonance.v's eq. (11)/MR_Live.v's eq. (24)
      pattern: enumerated notions valued injectively into [nat]. *)
  Inductive EndChainNotion : Type :=
    NExposure | NRetention2 | NImprovement2 | NAccessibility | NWarrant | NTruth2.

  Definition end_chain_value (n : EndChainNotion) : nat :=
    match n with
    | NExposure       => 0
    | NRetention2     => 1
    | NImprovement2   => 2
    | NAccessibility  => 3
    | NWarrant        => 4
    | NTruth2         => 5
    end.

  Theorem eq42_end_chain_non_collapse :
    end_chain_value NExposure <> end_chain_value NRetention2 /\
    end_chain_value NRetention2 <> end_chain_value NImprovement2 /\
    end_chain_value NAccessibility <> end_chain_value NWarrant /\
    end_chain_value NWarrant <> end_chain_value NTruth2.
  Proof.
    unfold end_chain_value.
    repeat split; discriminate.
  Qed.

End HumanReturn.
