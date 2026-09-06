(* weld/M.02.v1 — CAN-006 — Definition — parents: weld — occurrences 5 — includes the master-equation per-domain weld witnesses (from MRC_master.v) *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From Coq Require Import ZArith.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-006 — domain-weld

    (* CAN-006 — root: q_{D,n+1} o F_n = F#_{D,n} o q_{D,n} ; O_D = O#_D o q_D — domain: root — tier: Definition — occurrences: 5 *)

    The admissibility condition a translation [q_D] must satisfy to count
    as a domain reading at all: it must commute with the root stepper and
    with the root readout.  This is exactly the pair of equations
    [MRC_master.v]'s [weld_holds] specialises to state-transition only;
    here both halves (state and readout) are typed together, as
    CANONICAL.json's own canonical_text states them jointly. *)

Section DomainWeld.

  Variables RootSt DomSt Ctrl Ctx Tape Question Observer Val : Type.

  Variable F   : RootSt -> Ctrl -> Ctx -> Tape -> RootSt.
  Variable F_D : DomSt  -> Ctrl -> Ctx -> Tape -> DomSt.
  Variable O   : RootSt -> Question -> Observer -> Val.
  Variable O_D : DomSt  -> Question -> Observer -> Val.
  Variable q_D : RootSt -> DomSt.

  Definition CAN_006_domain_admissible : Prop :=
    (forall s u c t, q_D (F s u c t) = F_D (q_D s) u c t)
    /\ (forall s Qq o, O s Qq o = O_D (q_D s) Qq o).

  (* Witness (tier: Th_coqc): admissibility is satisfiable by a genuinely
     non-trivial domain reading, not only by the trivial identity domain —
     project a paired root state [A * B] onto its first coordinate, with
     [F] acting componentwise and [O] reading only the first coordinate;
     the projection then commutes with both the stepper and the readout. *)
  Theorem CAN_006_domain_weld_satisfiable_on_pair_projection :
    forall (A B Ctrl' Ctx' Tape' Question' Observer' Val' : Type)
           (fA : A -> Ctrl' -> Ctx' -> Tape' -> A)
           (fB : B -> Ctrl' -> Ctx' -> Tape' -> B)
           (oA : A -> Question' -> Observer' -> Val'),
      exists (F' : (A * B) -> Ctrl' -> Ctx' -> Tape' -> (A * B))
             (F_D' : A -> Ctrl' -> Ctx' -> Tape' -> A)
             (O' : (A * B) -> Question' -> Observer' -> Val')
             (O_D' : A -> Question' -> Observer' -> Val')
             (q' : (A * B) -> A),
        (forall s u c t, q' (F' s u c t) = F_D' (q' s) u c t)
        /\ (forall s Qq o, O' s Qq o = O_D' (q' s) Qq o).
  Proof.
    intros A B Ctrl' Ctx' Tape' Question' Observer' Val' fA fB oA.
    exists (fun s u c t => (fA (fst s) u c t, fB (snd s) u c t)).
    exists fA.
    exists (fun s Qq o => oA (fst s) Qq o).
    exists oA.
    exists fst.
    split.
    - intros [a b] u c t. reflexivity.
    - intros [a b] Qq o. reflexivity.
  Qed.

End DomainWeld.



(* ==================================================================== *)
(* -- appended from coq/canonical/_mrc_pre_split/MRC_master.v: the master-equation's per-domain DomainReading/weld_holds apparatus and the five domain witnesses (CAN_006_epistemic_weld_witness, CAN_006_human_ai_weld_witness, CAN_006_social_weld_witness, CAN_006_world_system_weld_witness, CAN_006_method_weld_witness) -- *)
From Coq Require Import QArith.
From Coq Require Import ZArith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.

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
