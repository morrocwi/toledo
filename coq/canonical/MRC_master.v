(** * MRC_master.v — the master equation as one typed composition of the
      root-spine, and per-domain weld witnesses

    Source of record: registry/COLLAPSE.md Section 1 ("the whole 946-
    equation, 40-chapter corpus is, at the root level, one weld
    (delta_R |- L_R |- F) read through five domain lenses (epistemic,
    human-AI, social, world-system) plus one cross-cutting audit lens
    (method)"), and the nine spine ids formalised individually in
    [MRC_root_spine.v] (CAN-002, CAN-201, CAN-001, CAN-003, CAN-006,
    CAN-007, CAN-008, CAN-004, CAN-009, in the reading order COLLAPSE.md
    fixes: state -> readout -> weld/stepper -> domain admission -> quotient
    -> non-collapse guard -> semantic ordering -> historical closure).

    This file does NOT introduce new CAN ids: [master_equation] is the
    single composed object the nine spine ids already name jointly, typed
    here as one function so the composition itself can be a proof
    obligation ([master_equation_is_segment_composition]) rather than only
    a prose claim.  [DomainReading]/[weld_holds] give the general shape of
    "a domain q_D commutes with the root stepper F" (CAN-006, specialised
    to the state-transition half only, matching the assignment brief's
    exact requested shape); the five [Th_coqc] witnesses that follow are
    each a genuine, checked instance on a small finite model — never a
    universal claim that every domain reading is admissible (most are
    not; COLLAPSE.md's own 244-id "domain/method readings" table is full
    of readings that are NOT literal q_D-commuting welds of this root
    stepper, only *thematic* instances of the pattern).

    DISCIPLINE: identical to [MRC_root_spine.v] — Coq 8.20.1, no [Reals],
    no classical axioms, no [Admitted], no top-level [Axiom]/[Parameter],
    [Q]/[nat]/[bool]/lists/[Inductive]s only, every [Theorem] [Closed under
    the global context]. *)

From Coq Require Import QArith.
From Coq Require Import ZArith.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

(* ==================================================================== *)
(** ** The master equation: one typed composition of the spine

    The spine, read in COLLAPSE.md's own order, is a pipeline: a root
    state (CAN-002) is read (CAN-201) into a readout value; the weld
    (CAN-001) forces a stepper (CAN-003) that advances the state; the
    result must satisfy the domain-admissibility weld (CAN-006) to count
    as a domain reading at all; readings are only ever compared up to a
    declared reader-equivalence horizon (CAN-007); the root state, its
    candidate representation and its discovered quotient stay three
    distinct things throughout (CAN-008); every stage is visited in the
    fixed constitutional order (CAN-004); and the historical trace already
    laid down is never rewritten by any of the above (CAN-009).

    [master_equation] types this as ONE composed function on a single
    finite model: state advance (the CAN-001/CAN-003 stepper) followed by
    readout (CAN-201) — the two spine segments that are actually
    composable as functions on the same carrier type; CAN-006/007/008/004/
    009 are typing disciplines *on* this composition (given below as
    [DomainReading]/[weld_holds] and, per domain, a witnessed instance),
    not further arrows to chain into the same pipeline value. *)

Section MasterEquation.

  Variables StateT Ctrl Ctx Tape Question Observer Val : Type.

  (** CAN-001/CAN-003 segment: the weld-forced stepper. *)
  Variable F : StateT -> Ctrl -> Ctx -> Tape -> StateT.

  (** CAN-201 segment: the root readout gate. *)
  Variable O : StateT -> Question -> Observer -> Val.

  (** The master equation: advance one step, then read the result — the
      typed composition of the two function-shaped spine segments into a
      single object, on one finite model. *)
  Definition master_equation
             (s : StateT) (u : Ctrl) (c : Ctx) (t : Tape) (q : Question) (o : Observer)
    : Val :=
    O (F s u c t) q o.

  (** Th_coqc: [master_equation] genuinely IS the sequential application
      of its two spine segments — stepping with [F] and then reading with
      [O] — not a re-derived or independently-defined shortcut.  This is
      the composition claim made checkable: by construction the two sides
      are definitionally the same finite computation, so the proof is
      exactly [reflexivity], which is itself the honest content of the
      claim (there is no hidden step in between). *)
  Theorem master_equation_is_segment_composition :
    forall (s : StateT) (u : Ctrl) (c : Ctx) (t : Tape) (q : Question) (o : Observer),
      master_equation s u c t q o = O (F s u c t) q o.
  Proof. intros. reflexivity. Qed.

End MasterEquation.

(* ==================================================================== *)
(** ** Per-domain readings: [DomainReading] and [weld_holds]

    The exact shape the assignment brief requests: a domain reading is a
    pair of maps (a state-translation [q_D] and a domain-local stepper
    [F_D]), and it "welds" onto a root stepper [F] exactly when translating
    then stepping-in-the-domain agrees with stepping-at-the-root then
    translating (CAN-006's state-transition half, specialised to a single
    stepper argument [s] — the general 4-argument form
    [q_D (F s u c t) = F_D (q_D s) u c t] lives already in
    [MRC_root_spine.v]'s [CAN_006_domain_admissible]; here [F]/[F_D] are
    taken as already-closed one-argument steppers, e.g. [F := fun s => F0
    s u0 c0 t0] at fixed control/context/tape, matching the brief's
    [weld_holds q F F_D := forall s, q (F s) = F_D (q s)] literally). *)

Record DomainReading (S Sd : Type) : Type := mkDomainReading
  { q_D : S -> Sd
  ; F_D : Sd -> Sd
  }.

Definition weld_holds (S Sd : Type) (q : S -> Sd) (F : S -> S) (F_D : Sd -> Sd) : Prop :=
  forall s : S, q (F s) = F_D (q s).

(* ------------------------------------------------------------------ *)
(** *** Domain 1/5 — epistemic

    Finite model: root state is a pair (belief : bool, checked : bool);
    the epistemic reading keeps only [checked] (CAN-201's own most-read
    domain per COLLAPSE.md Section "5 domain lenses"), i.e. epistemic
    status is a genuine coarsening of the full state, not the whole
    state.  [F] flips belief on every step but never silently marks a
    flipped belief as checked; [F_D] (the epistemic-domain stepper)
    correspondingly leaves "checked" alone.  This is a witnessed q_D that
    both commutes AND is a strict information loss (belief is dropped) —
    the honest epistemic reading COLLAPSE.md's CAN-004/CAN-005 chain
    describes. *)

Definition Epistemic_State : Type := bool * bool.  (* (belief, checked) *)

Definition epistemic_F (s : Epistemic_State) : Epistemic_State :=
  (negb (fst s), snd s).

Definition epistemic_q (s : Epistemic_State) : bool := snd s.

Definition epistemic_F_D (checked : bool) : bool := checked.

Theorem CAN_006_epistemic_weld_witness :
  weld_holds epistemic_q epistemic_F epistemic_F_D.
Proof. intros [b c]. reflexivity. Qed.

(* ------------------------------------------------------------------ *)
(** *** Domain 2/5 — human-AI (CAN-003's own most-read domain)

    Finite model: root state is a session tally [nat] (turns taken); the
    human-AI reading is turn-parity (whose "turn" it structurally is),
    the [Q_{HAI}] instance COLLAPSE.md eq.(44)/(65) describe for
    CAN-003/CAN-004.  [F] advances the tally by one; the domain stepper
    flips parity — exactly the commuting square a genuine session-turn
    reading must satisfy. *)

Definition HAI_State : Type := nat.

Definition hai_F (s : HAI_State) : HAI_State := S s.

Definition hai_q (s : HAI_State) : bool := Nat.odd s.

Definition hai_F_D (p : bool) : bool := negb p.

Theorem CAN_006_human_ai_weld_witness :
  weld_holds hai_q hai_F hai_F_D.
Proof.
  intro s. unfold hai_q, hai_F, hai_F_D.
  rewrite Nat.odd_succ, Nat.negb_odd. reflexivity.
Qed.

(* ------------------------------------------------------------------ *)
(** *** Domain 3/5 — social (CAN-001's own most-read domain)

    Finite model: root state is a pair of finite relational-class scores
    [(Z * Z)] (self, other) — [Z], not [Q], so the weld equation below is
    a literal Leibniz [=] on a canonical discrete representation, never a
    setoid [==] (a [Q]-valued score would only satisfy the weld up to
    [Qeq], not [=], since unnormalised fractions are not made canonical
    by [Qplus]/[Qminus] — recorded here as the readout-first reason this
    domain's carrier is [Z]).  The social reading is the score
    *difference* (After Labour / B-SOC's relational-class-position
    instance of q_D).  [F] adds a fixed increment [d] to both coordinates
    equally (a shared "world moves forward" step); the domain stepper
    leaves the difference untouched — witnessing that a genuinely shared
    increment is invisible to the *relational* reading, the discrete
    honesty COLLAPSE.md's B-SOC non-collapse family is built on (S_n
    itself changes; the social-difference quotient need not). *)

Definition Social_State : Type := Z * Z.

Section SocialDomain.
  Variable d : Z.

  Definition social_F (s : Social_State) : Social_State := ((fst s + d)%Z, (snd s + d)%Z).

  Definition social_q (s : Social_State) : Z := (fst s - snd s)%Z.

  Definition social_F_D (diff : Z) : Z := diff.

  Theorem CAN_006_social_weld_witness :
    weld_holds social_q social_F social_F_D.
  Proof. intros [a b]. unfold social_q, social_F, social_F_D. simpl. ring. Qed.

End SocialDomain.

(* ------------------------------------------------------------------ *)
(** *** Domain 4/5 — world-system (CAN-002's own most-read domain)

    Finite model: root state is a finite list of per-sector [nat] counts
    (a discrete [Human Systemic Position] vector, CAN-002's [G_n]/[Lambda_n]
    read as "which sectors" rather than one scalar); the world-system
    reading is the sector *count* (length) — the audit-index typing
    After Labour/HCI use throughout Section "World-System Layer".  [F]
    appends one more zero-initialised sector; the domain stepper
    increments the count — the exact commuting square a genuine
    "how many sectors are tracked" audit index must satisfy. *)

Definition WorldSystem_State : Type := list nat.

Definition worldsystem_F (s : WorldSystem_State) : WorldSystem_State := s ++ [0]%nat.

Definition worldsystem_q (s : WorldSystem_State) : nat := length s.

Definition worldsystem_F_D (n : nat) : nat := S n.

Theorem CAN_006_world_system_weld_witness :
  weld_holds worldsystem_q worldsystem_F worldsystem_F_D.
Proof.
  intro s. unfold worldsystem_q, worldsystem_F, worldsystem_F_D.
  rewrite length_app. simpl. rewrite Nat.add_1_r. reflexivity.
Qed.

(* ------------------------------------------------------------------ *)
(** *** Domain 5/5 — method (the cross-cutting audit lens, CAN-009's own
      most-read domain)

    Finite model: root state is a finite provenance trace [list bool]
    (each entry: was this step independently checked); the method reading
    is whether EVERY step so far was checked (the maker-checker audit
    fold CAN-009's historical-invariance and CAN-208's "provenance-
    governing maxim" both cash out to).  [F] appends one more checked-or-
    not flag; the domain stepper folds the new flag in with [andb] — a
    genuine, checkable audit-accumulator weld: the moment one step is
    unchecked, the domain reading can never silently become [true] again,
    which is exactly the "no unverified claim becomes verified by later
    dilution" discipline this whole family is enforcing on itself. *)

Definition Method_State : Type := list bool.

Definition method_F (flag : bool) (s : Method_State) : Method_State := s ++ [flag].

Definition method_q (s : Method_State) : bool := fold_right andb true s.

Definition method_F_D (flag : bool) (all_checked_so_far : bool) : bool :=
  andb all_checked_so_far flag.

Theorem CAN_006_method_weld_witness :
  forall flag : bool, weld_holds method_q (method_F flag) (method_F_D flag).
Proof.
  intros flag s. unfold method_q, method_F, method_F_D.
  induction s as [| b bs IH]; simpl.
  - apply Bool.andb_true_r.
  - rewrite IH. rewrite Bool.andb_assoc. reflexivity.
Qed.
