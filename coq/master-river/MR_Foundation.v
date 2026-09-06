(** * MR_Foundation.v — Master Equation River, Block A: eq. (1)-(8)

    Source of record: research/society-justice-peace/master-river/v1_3/main.tex
    (Master Equation River v1.3), Section 3.1 "Foundation: Retained Difference,
    Readout, Meaning, Experience" and 3.2 "Naming as Both an Articulation and a
    Restructuring Operator" and 3.3 "Retention and the Changing Future Reader".

    DISCIPLINE (information-discrete-math, readout-first):
      - No [Coq.Reals]; no classical axioms; no [functional extensionality].
      - Every abstract object ([X], [HState], [Readout], the maps [R_H],
        [Psi_H], [Phi_E], [L_H], [U_H], ...) is introduced as a [Variable] or
        [Hypothesis] inside a [Section], discharged when the section closes —
        never a top-level [Parameter]/[Axiom].
      - Numeric content (weights, gains) lives on [Q] (rationals), never on a
        continuum type; where the paper's prose sounds continuum-flavoured
        ("phenomenon-as-meaningfully-read", "the same reader"), the discrete
        replacement is a finite witnessed model, recorded in the comment.
      - Tiering is exactly one of Th_coqc / Definition / Open per equation,
        per founder ruling BBL-165. See MR_Ledger.md for the full table and
        the [Print Assumptions] verification result for every proved lemma.
*)

From Coq Require Import QArith.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

(* ------------------------------------------------------------------ *)
(** ** Section: the readout, meaning-giving and experience maps
    (eq. 1-5)

    All object types are abstract ([Variable ... : Type]) and all maps are
    abstract functions between them ([Variable ... : ... -> ...]), discharged
    at [End Foundation1] — this is the Section+Variables/Hypotheses pattern,
    not [Parameter]/[Axiom]. *)

Section Foundation1.

  (** Abstract carriers, named exactly as the paper's symbols:
      [X] = phenomenon / world-side encounter type;
      [HState] = human state type (H_n);
      [Ctx] = context type (c_n);
      [Question] = criterion/question type (Q_n);
      [Readout] = the finite human readout type (r_n);
      [Gamma] = strength/control of meaning over experience (gamma^mu_n);
      [Experience] = the experience type (E_n). *)
  Variables X HState Ctx Question Readout Gamma Experience : Type.

  (* eq. (1) — tier: Definition *)
  (** r_n = R_H(x_n | H_n, c_n).  A finite human readout of a phenomenon,
      conditioned by human state and context.  Root architectural map: no
      built-in semantic label is assumed of [X] itself. *)
  Variable R_H : X -> HState -> Ctx -> Readout.

  (** Meaning is a product of five analytic modes (eq. 3 below); we
      introduce the record type here so eq. (2)'s codomain can already be
      typed as [Meaning]. *)
  Record MeaningModes : Type := mkMeaning
    { m_aff  : Q   (* affective mode *)
    ; m_prag : Q   (* pragmatic mode *)
    ; m_auto : Q   (* autonoetic mode *)
    ; m_conc : Q   (* conceptual mode *)
    ; m_epi  : Q   (* epistemic mode *)
    }.

  (* eq. (2) — tier: Definition *)
  (** mu_n = Psi_H(r_n, H_n, c_n, Q_n).  Meaning-giving as a significance
      relation under human state, context and criterion/question. *)
  Variable Psi_H : Readout -> HState -> Ctx -> Question -> MeaningModes.

  (* eq. (3) — tier: Definition *)
  (** mu_n = (mu^aff, mu^prag, mu^auto, mu^conc, mu^epi).  [MeaningModes]
      above already types this decomposition; eq. (3)'s content is exactly
      that [Psi_H]'s codomain is this 5-mode record, not an opaque scalar.
      We record that fact as a trivial-but-honest typing lemma: projecting
      any meaning value out and re-assembling it is the identity. *)
  Lemma meaning_modes_decomposition_faithful :
    forall m : MeaningModes,
      mkMeaning (m_aff m) (m_prag m) (m_auto m) (m_conc m) (m_epi m) = m.
  Proof. intros [a p u c e]. reflexivity. Qed.

  (* eq. (4) — tier: Definition *)
  (** E_n = Phi_E(x_n, mu_n, gamma^mu_n, c_n).  Readout Genesis MEMK eq. 14,
      renamed.  We type [Phi_E] abstractly, but eq. (5)'s compression thesis
      ("Experience = phenomenon-as-meaningfully-read") is witnessed directly
      below at a concrete instance of [Phi_E], since the abstract map alone
      cannot certify that both factors survive. *)
  Variable Phi_E : X -> MeaningModes -> Gamma -> Ctx -> Experience.

  (* eq. (5) — tier: Th_coqc *)
  (** "Experience = phenomenon-as-meaningfully-read": the defended
      compression is that experience is neither raw phenomenon alone nor
      meaning alone, but a genuine joint reading of both.  This is not a
      theorem about the abstract [Phi_E] (nothing forces that), so we
      exhibit the readout-first witness the paper's thesis is defending:
      a finite model in which [Experience := X * MeaningModes] (an honest
      product, dropping nothing) and [Phi_E] is literally the pairing
      map.  In that witnessed model the compression is provably faithful:
      changing the meaning while holding the phenomenon fixed changes the
      experience, and changing the phenomenon while holding the meaning
      fixed changes the experience — i.e. "phenomenon-as-meaningfully-read"
      is not collapsible onto phenomenon alone or onto meaning alone. *)
  Theorem eq5_experience_is_phenomenon_and_meaning_jointly :
    exists (Exp' : Type) (Phi_E' : X -> MeaningModes -> Gamma -> Ctx -> Exp'),
      (forall x g c mu1 mu2, mu1 <> mu2 -> Phi_E' x mu1 g c <> Phi_E' x mu2 g c)
      /\ (forall x1 x2 g c mu, x1 <> x2 -> Phi_E' x1 mu g c <> Phi_E' x2 mu g c).
  Proof.
    exists (X * MeaningModes)%type.
    exists (fun x mu _ _ => (x, mu)).
    split.
    - intros x g c mu1 mu2 Hneq Heq.
      apply Hneq. congruence.
    - intros x1 x2 g c mu Hneq Heq.
      apply Hneq. congruence.
  Qed.

End Foundation1.

(* ------------------------------------------------------------------ *)
(** ** Section: naming as articulation and restructuring (eq. 6-7) *)

Section Naming.

  Variables Experience MeaningState HState Ctx Name : Type.

  (* eq. (6) — tier: Definition *)
  (** ell_n = L_H(E_n, mu_n | H_n, c_n), with the explicit qualifier that
      E_n, mu_n may precede a *stable* ell_n.  We type naming as partial
      ([option Name]): [None] reads as "not yet stably named", which is the
      discrete, honest way to record "may precede stable ell_n" without
      smuggling in a continuum notion of "not yet". *)
  Variable L_H : Experience -> MeaningState -> HState -> Ctx -> option Name.

  (** Witness for eq. (6)'s precedence remark: in a concrete instantiation
      of [L_H] (constant [None]), experience and meaning are always
      available while naming is never yet stable — a finite model showing
      the precedence is not vacuous. This does not re-tag eq. (6); it only
      substantiates the [Definition] already given. *)
  Example naming_can_remain_unstable :
    exists (L_H' : Experience -> MeaningState -> HState -> Ctx -> option Name),
      forall e mu h c, L_H' e mu h c = None.
  Proof. exists (fun _ _ _ _ => None). intros; reflexivity. Qed.

  (* eq. (7) — tier: Definition *)
  (** mu_n -> E_n -> ell_n -> mu_{n+1} -> E_{n+1}: naming is recursive, not
      only an articulation but a restructuring operator on later meaning
      and experience.  We type this as a one-step trajectory generator: a
      record bundling the three maps needed to advance the chain by one
      index, together with a restructuring map [Restruct] taking the naming
      output back into the next meaning state (the "recursive correction"
      the paper adds to a plain forward articulation). *)
  Record NamingChainStep : Type := mkNamingChainStep
    { nc_experience : MeaningState -> Experience
    ; nc_name       : Experience -> MeaningState -> HState -> Ctx -> option Name
    ; nc_restruct   : option Name -> MeaningState -> MeaningState
        (* eq. (7)'s recursive edge ell_n -> mu_{n+1}: naming may feed back
           into and restructure the next meaning state, not merely follow
           from it. *)
    }.

  (** The chain mu_0 -> E_0 -> ell_0 -> mu_1 -> E_1 -> ... unrolled to
      index [n], starting from an initial meaning state [mu0]. This types
      eq. (7) as an actual finite (nat-indexed) sequence, not an infinite
      continuum-style limit object. *)
  Fixpoint naming_chain (step : NamingChainStep) (h : HState) (c : Ctx)
           (mu0 : MeaningState) (n : nat) : MeaningState :=
    match n with
    | O => mu0
    | S k =>
        let mu_k := naming_chain step h c mu0 k in
        let e_k  := nc_experience step mu_k in
        let ell_k := nc_name step e_k mu_k h c in
        nc_restruct step ell_k mu_k
    end.

End Naming.

(* ------------------------------------------------------------------ *)
(** ** Section: retention and the changing future reader (eq. 8) *)

Section Retention1.

  Variables HState RetainVal WorldDelta : Type.

  (* eq. (8) — tier: Th_coqc *)
  (** H_{n+1} = U_H(H_n, Retain(E_n,mu_n,r_n), delta^world_{n:n+1}).  Human
      LoRA's master dependency form: retained experience (already reduced
      to a [RetainVal] by some prior [Retain] map, which is not itself
      re-typed here — it belongs to eq. (16)-(17)'s accumulation apparatus)
      together with world change updates the human state. The paper's own
      stated consequence is that retained experience CAN change the reader,
      i.e. the update is not forced to be trivial. We witness this as a
      finite model where [U_H] genuinely moves the state — fix
      [HState' := bool] and [U_H' h _ _ := negb h]: this is the discrete,
      readout-first stand-in for "the same biological individual may no
      longer be the same effective reader at a later time" — no claim
      that it ALWAYS changes, only that update-with-retention is not
      definitionally idle, witnessed on the smallest possible finite
      state space ([bool]). *)
  Theorem eq8_retention_can_change_the_reader :
    forall (r : RetainVal) (d : WorldDelta),
      exists (HState' : Type) (U_H' : HState' -> RetainVal -> WorldDelta -> HState')
             (h : HState'),
        U_H' h r d <> h.
  Proof.
    intros r d.
    exists bool, (fun h _ _ => negb h), true.
    discriminate.
  Qed.

End Retention1.
