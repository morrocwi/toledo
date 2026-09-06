(** * MR_Prompt.v — Master Equation River, Block B: eq. (27)-(34)

    Source of record: research/society-justice-peace/master-river/v1_3/main.tex
    (Master Equation River v1.3), Section 3.8 "Human-AI Coupling Begins
    Before the Prompt" (\label{sec:humanai1}, eq. 27-30) and Section 3.9
    "Within-Session Amplification, Retention, and Epistemic Direction"
    (\label{sec:humanai2}, eq. 31-34; eq. 35/36 = \label{eq:lowrank}/
    \label{eq:gate} and eq. 37-42 continue in MR_Retention.v).

    Tier source: Table 2 (\label{tab:status}) rows "Domain definitions" (the
    prompt as bounded articulation) and "Finite diagnostics / proved on a
    stated model" (chi_recip, frozen session descendant counts); the prose
    after eq. 32 stating chi_recip "measures the finite reciprocal-descendant
    gain ... it is not warrant or a truth score" (a *bounded ratio* claim,
    which is exactly what is proved here); the prose after eq. 30 ("if a
    residue persists, it is then possible that L_{A,t+1} <> L_{A,t}") which
    is a witnessed-possibility, not a universal, claim; and the "accounting
    identity" reading of the difference-in-differences estimand RET (eq. 34).

    DISCIPLINE: readout-first, as in MR_Live.v — no [Reals], no classical
    axioms, [Q]-valued/finite-cardinality content only, Section+Variables/
    Hypotheses for abstract objects, no top-level [Parameter]/[Axiom], no
    [Admitted].
*)

From Coq Require Import QArith.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

(* ------------------------------------------------------------------ *)
(** ** Section: the pre-prompt transport and its recursive update
       (eq. 27-29) *)

Section PrePromptCoupling.

  Variables HState Prompt AIOutput Experience WorldDelta OtherFactor : Type.

  (* eq. (27) — tier: Definition *)
  (** H_t --L_H--> Q_t.  The Pre-Prompt Human State Principle: the AI
      receives a bounded transport [Q_t] of the retained human state
      [H_t], never the whole of [H_t] itself — typed here as a (generally
      non-injective, i.e. lossy) map. *)
  Variable L_H : HState -> Prompt.

  (* eq. (28) — tier: Definition *)
  (** Q_t -> AI_t -> Y_t --R_H--> E^AI_{H,t}.  Composition of the AI's
      processing of the prompt into an output, and the human's readout of
      that output as an experience. *)
  Variable AI_step : Prompt -> AIOutput.
  Variable R_H_readout : AIOutput -> Experience.

  Definition ai_turn (h : HState) : Experience :=
    R_H_readout (AI_step (L_H h)).

  (* eq. (29) — tier: Definition *)
  (** H_{t+1} = U_H(H_t, E^AI_{H,t}, delta^world, X^other).  The same
      state-update shape as eq. (8) in MR_Foundation.v, specialised to a
      human-AI-turn experience. *)
  Variable U_H : HState -> Experience -> WorldDelta -> OtherFactor -> HState.

  Definition next_state (h : HState) (delta : WorldDelta) (other : OtherFactor) : HState :=
    U_H h (ai_turn h) delta other.

End PrePromptCoupling.

(* ------------------------------------------------------------------ *)
(** ** Section: the live-weight may change across one turn (eq. 30) *)

Section LiveWeightMayChange.

  (* eq. (30) — tier: Th_coqc *)
  (** "if a residue persists, it is then possible that L_{A,t+1} <>
      L_{A,t}" before the next prompt: the live-field accessibility weight
      *can* change across one human-AI-turn update. This is a witnessed
      possibility claim (not a universal one), so we give a minimal
      concrete instantiation of [HState] and the update/weight maps of
      [PrePromptCoupling] above — [nat] states, additive update, and a
      weight function that reads the state value directly — on which the
      weight genuinely differs before and after a non-trivial update. *)
  Definition toy_update (h bump : nat) : nat := h + bump.
  Definition toy_lambda_live (h : nat) : Q := inject_Z (Z.of_nat h).

  Theorem eq30_live_weight_may_change :
    exists h bump : nat, toy_lambda_live h <> toy_lambda_live (toy_update h bump).
  Proof.
    exists 0%nat, 1%nat.
    unfold toy_lambda_live, toy_update.
    simpl.
    intro Hcontra.
    unfold inject_Z in Hcontra.
    discriminate Hcontra.
  Qed.

End LiveWeightMayChange.

(* ------------------------------------------------------------------ *)
(** ** Section: the finite dialogue state and reciprocal-lineage ratio
       (eq. 31-32) *)

Section DialogueState.

  Variables DlgState HumanInput AIInput Ctx TurnBudget : Type.

  (* eq. (31) — tier: Definition *)
  (** Z_dlg[s,n+1] = F#_dlg(Z_dlg[s,n], u_H[s,n], u_AI[s,n], c[s,n],
      T[s,n]).  The finite dialogue-state stepper: one turn of the
      recursive human-AI dialogue. *)
  Variable F_hash_dlg : DlgState -> HumanInput -> AIInput -> Ctx -> TurnBudget -> DlgState.

  Definition dlg_step (z : DlgState) (uh : HumanInput) (uai : AIInput)
             (c : Ctx) (bud : TurnBudget) : DlgState :=
    F_hash_dlg z uh uai c bud.

  (* eq. (32) — tier: Th_coqc *)
  (** chi_recip[s,n,L] = |D_recip[s,n,L]| / |Sigma[s,n]|.  Reciprocal-
      lineage ratio: the finite cardinality of the reciprocal-descendant
      set over the finite cardinality of the whole descendant set.
      Readout-first: both cardinalities are [nat] (finite, countable
      descendant sets), and the ratio is built directly as a rational
      [Qmake] fraction (never a real-division limit); [Sigma]'s
      cardinality is required to be a genuine positive count (a session
      with a non-empty descendant set), never zero, so the ratio is always
      well-defined by construction. We prove the bounded-ratio fact the
      prose asserts implicitly by calling this a diagnostic *ratio* at
      all: whenever the reciprocal-descendant count does not exceed the
      total, the ratio lies in [0,1] — proved over [Q], not assumed. *)
  Definition chi_recip (d_recip : nat) (sigma_card : positive) : Q :=
    Qmake (Z.of_nat d_recip) sigma_card.

  Theorem eq32_chi_recip_bounds :
    forall (d_recip : nat) (sigma_card : positive),
      (Z.of_nat d_recip <= Zpos sigma_card)%Z ->
      0 <= chi_recip d_recip sigma_card /\ chi_recip d_recip sigma_card <= 1.
  Proof.
    intros d_recip sigma_card Hle.
    unfold chi_recip.
    pose proof (Nat2Z.is_nonneg d_recip) as Hnn.
    split.
    - unfold Qle. simpl. lia.
    - unfold Qle. simpl. lia.
  Qed.

End DialogueState.

(* ------------------------------------------------------------------ *)
(** ** Section: the unaided return battery and the RET estimand
       (eq. 33-34) *)

Section ReturnBattery.

  Variables Recalled Discriminated NewTransfer NextQuestion : Type.

  (* eq. (33) — tier: Definition *)
  (** Y^return_{s+Delta} = (R_rec, R_disc, T_new, Q_next).  The unaided
      return battery: a typed tuple recording what the human alone can
      still reconstruct, discriminate, transfer, and generate. *)
  Definition ReturnBattery : Type :=
    Recalled * Discriminated * NewTransfer * NextQuestion.

  Definition mk_return_battery (r : Recalled) (d : Discriminated)
             (t : NewTransfer) (q : NextQuestion) : ReturnBattery := (r, d, t, q).

  (* eq. (34) — tier: Th_coqc *)
  (** RET = (P^post_{H,AI} - P^pre_{H,AI}) - (P^post_{H,C} - P^pre_{H,C}).
      The difference-in-differences estimand for randomized study designs.
      We prove the accounting identity the paper's bookkeeping requires:
      RET rearranges, over [Q], into the difference of the two groups'
      post-scores minus the difference of their pre-scores — a genuine
      algebraic identity (by [ring] on [Q]), not an empirical claim about
      what RET measures. *)
  Definition RET (P_post_HAI P_pre_HAI P_post_HC P_pre_HC : Q) : Q :=
    (P_post_HAI - P_pre_HAI) - (P_post_HC - P_pre_HC).

  Theorem eq34_RET_rearrangement :
    forall P_post_HAI P_pre_HAI P_post_HC P_pre_HC : Q,
      RET P_post_HAI P_pre_HAI P_post_HC P_pre_HC
      == (P_post_HAI - P_post_HC) - (P_pre_HAI - P_pre_HC).
  Proof.
    intros. unfold RET. ring.
  Qed.

End ReturnBattery.
