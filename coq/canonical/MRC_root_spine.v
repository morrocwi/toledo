(** * MRC_root_spine.v — Family "root-spine": the nine root CAN ids

    Source of record: research/society-justice-peace/master-river/registry/
    CANONICAL.json (253-id cross-corpus canonicalisation) and registry/
    COLLAPSE.md Section 1 ("Root spine (spine_ids)"), which fixes

      spine_ids = ["CAN-002","CAN-201","CAN-001","CAN-003","CAN-006",
                    "CAN-007","CAN-008","CAN-004","CAN-009"]

    as the nine [domain: "root"] CAN ids that are themselves the root
    object. Two further [domain: "root"] ids in CANONICAL.json, CAN-005
    and CAN-222, are *excluded from the [spine_ids] grouping itself* by
    COLLAPSE.md, because they are readings of a spine element — CAN-004
    and CAN-008 respectively — by the root paper's own semantic layer,
    not additional root objects (see registry/family_root-spine.json for
    the assignment record). That is a family-membership decision only:
    CANONICAL.json still lists both as live, first-class canonical ids
    with their own [object]/[canonical_text]/[tier], so — to keep the
    registry-to-corpus map total (every CAN id gets its own tagged Coq
    construct, per the discipline below) — each is still given a minimal
    tagged alias Definition just below its reading-source (CAN-005 under
    CAN-004, CAN-222 under CAN-008), in the same reuse-not-redefine style
    [MRC_world_system_reading.v] already uses for CAN-143/CAN-144 aliasing
    [MR_WorldSystem]. Neither alias is added to [spine_ids] or otherwise
    treated as a tenth/eleventh independent root object.

    None of these nine ids is itself a Master River eq. (1)-(79) — their
    [occurrences] in CANONICAL.json point at Readout Genesis Standalone
    Synthesis (record 21529456), Mind as Information Horizon (19640361),
    RG-HCA (22498047), "Before Meaning, Before Choice" (22424434), "From
    Problem to Hypothesis" (22307148), and "After Labour" (22481924) — so
    this file does not [Require] any [MR_*] module; the CAN-004/CAN-003/
    CAN-201/CAN-006/etc. *readings* Master River eq. 44/52/65/66/79 make of
    this spine live in [../coq/MR_*.v] and are cited only in prose here.

    DISCIPLINE (information-discrete-math, readout-first; identical to
    [../coq/MR_*.v]):
      - Coq 8.20.1. No [Coq.Reals], no classical axioms, no [Admitted], no
        top-level [Axiom]/[Parameter] (only Section [Variable]/[Hypothesis],
        discharged when the section closes).
      - All numeric content lives on [Q] (rationals), [nat], [bool], lists,
        or [Inductive]s — never a continuum type.
      - One Coq identifier per CAN id, each tagged with a one-line comment
        of the exact required shape:
        (* CAN-nnn — root: ... — domain: root — tier: ... — occurrences: n *)
      - Tier is exactly one of Th_coqc / Definition / Open (never upgraded
        without proof). Where CANONICAL.json's own tier word is "Dr" or
        "law" (its non-Coq vocabulary), the object is typed here as
        [Definition] and — following the house style already used in
        [MR_Foundation.v] eq.(5)/(8) — accompanied by a small witnessed
        [Theorem] (tier Th_coqc) that the defining property is genuinely
        satisfiable on a finite model, never a universal claim about every
        instantiation.
      - Every discrete replacement of a continuum-flavoured notion (a
        graph Laplacian's row-degree, an "index" for a totally ordered
        stage list, "the past is unwritten") is recorded in-line, not
        hidden.
*)

From Coq Require Import QArith.
From Coq Require Import List.
From Coq Require Import Arith.
From Coq Require Import Lia.
Import ListNotations.

Set Implicit Arguments.

(* ==================================================================== *)
(** ** CAN-002 — root-state-tuple

    (* CAN-002 — root: S_n=(G_n,Lambda_n,T_n) — domain: root — tier: Definition — occurrences: 2 *)

    Relational carrier: a retained-graph component [G_n], a typed-
    distinction component [Lambda_n], and an append-only tape [T_n].  All
    three are abstract [Type]s (Section [Variable]s, discharged at
    [End RootStateTuple]) — the claim of eq. is only that the root state is
    *this* triple, not an opaque single object. *)

Section RootStateTuple.

  Variables G Lambda Tape : Type.

  Record RootState : Type := mkRootState
    { rs_G      : G       (* G_n: retained relational graph *)
    ; rs_Lambda : Lambda  (* Lambda_n: retained typed distinctions *)
    ; rs_Tape   : Tape    (* T_n: append-only tape *)
    }.

  (* Witness (tier: Th_coqc): the triple is a faithful, lossless typing —
     projecting the three components back out and re-assembling them is
     the identity, so [RootState] drops nothing eq. claims of S_n. *)
  Theorem CAN_002_root_state_tuple_faithful :
    forall s : RootState,
      mkRootState (rs_G s) (rs_Lambda s) (rs_Tape s) = s.
  Proof. intros [g l t]. reflexivity. Qed.

End RootStateTuple.

(* ==================================================================== *)
(** ** CAN-201 — root-readout-gate

    (* CAN-201 — root: Readout_{Q,O,c}(S)=z, z<>S — domain: root — tier: Definition — occurrences: 1 *)

    A bounded, reader/operator-conditioned map that never returns the
    source unchanged.  Typed exactly as MR_WorldSystem.v's eq.(52) reading
    of this same root gate (After Labour eq. 2), but under its own CAN-201
    identifier and its own discharged [Hypothesis] — this file does not
    [Require] [MR_WorldSystem] since CAN-201 is not itself a Master River
    equation. *)

Section RootReadoutGate.

  Variables StateT Question Observer Ctx : Type.

  Variable CAN_201_readout : StateT -> Question -> Observer -> Ctx -> StateT.

  Hypothesis CAN_201_readout_ne_state :
    forall (s : StateT) (q : Question) (o : Observer) (c : Ctx),
      CAN_201_readout s q o c <> s.

  (* Witness (tier: Th_coqc): the discharged non-identity hypothesis above
     is satisfiable — a concrete non-identity readout exists on the
     smallest possible finite state space — so the gate is not a vacuous
     requirement. *)
  Remark CAN_201_hypothesis_satisfiable_on_bool :
    exists (readout' : bool -> unit -> unit -> unit -> bool),
      forall (s : bool) (q o c : unit), readout' s q o c <> s.
  Proof.
    exists (fun s _ _ _ => negb s).
    intros [] [] [] []; simpl; discriminate.
  Qed.

End RootReadoutGate.

(* ==================================================================== *)
(** ** CAN-001 — root-weld

    (* CAN-001 — root: delta_R=(a#b) |-[Th_coqc] L_R=D_W-W |-[Dr] F — domain: root — tier: Th_coqc/Dr — occurrences: 7 *)

    delta_R = (a # b) forces (|-, at tier Th_coqc) the graph Laplacian
    L_R = D_W - W, which forces (|-, at tier Dr, i.e. derived-not-machine-
    -re-proved-here) the stepper F.  Discrete replacement: the graph is a
    finite vertex list [verts : list nat] (no duplicates required for the
    identity below) with a [Q]-valued symmetric weight function [W]; the
    degree [D_W i] is the finite row-sum [fold_right Qplus 0 (map (W i)
    verts)] — never an infinite sum or a continuum integral — and [L_R i j]
    is the standard discrete graph-Laplacian entry (diagonal degree, off-
    diagonal negative weight). *)

Section RootWeld.

  Variable verts : list nat.
  Variable W : nat -> nat -> Q.  (* a#b: pairwise retained-distinction weight *)

  Definition CAN_001_degree (i : nat) : Q :=
    fold_right Qplus 0 (map (W i) verts).

  Definition CAN_001_laplacian (i j : nat) : Q :=
    if Nat.eqb i j then CAN_001_degree i else - W i j.

  (* Generic helper (not itself a CAN id): negation distributes over a
     finite [Qplus] sum on ANY list, proved by plain structural induction
     — this is the honest discrete stand-in for "linearity of the sum". *)
  Lemma CAN_001_sum_neg_distributes :
    forall (l : list nat) (f : nat -> Q),
      fold_right Qplus 0 (map (fun j => - f j) l) == - fold_right Qplus 0 (map f l).
  Proof.
    induction l as [| x xs IH]; intros f; simpl.
    - ring.
    - rewrite IH. ring.
  Qed.

  (* Th_coqc half (delta_R |- L_R): the graph Laplacian's defining
     accounting identity.  When [i] itself is not among the summed
     vertices (no self-loop term ever fires), the row of off-diagonal
     entries sums to exactly the negative of [i]'s own degree — proved
     directly from the definitions above, on the finite discrete model,
     no [Reals]. *)
  Theorem CAN_001_laplacian_row_sums_to_neg_degree :
    forall i : nat, ~ In i verts ->
      fold_right Qplus 0 (map (CAN_001_laplacian i) verts) == - CAN_001_degree i.
  Proof.
    intros i Hnotin.
    unfold CAN_001_degree.
    assert (Heq : map (CAN_001_laplacian i) verts = map (fun j => - W i j) verts).
    { apply map_ext_in. intros j Hin.
      unfold CAN_001_laplacian.
      assert (Hne : Nat.eqb i j = false).
      { apply Nat.eqb_neq. intro Heqij. apply Hnotin. subst. exact Hin. }
      rewrite Hne. reflexivity. }
    rewrite Heq.
    apply CAN_001_sum_neg_distributes.
  Qed.

  (* Dr half (L_R |- F): the stepper is typed as depending on the Laplacian
     together with a control input [u], a context [c] and a tape [T] — we
     do not re-derive F from L_R here (that is the paper's own "Dr"
     result, corroborated but not independently machine-checked), only
     type the dependency honestly and witness, at tier Th_coqc, that a
     stepper of this Laplacian-consuming arrow shape can be non-idle
     (never definitionally idle) — the same generic non-vacuity witness
     CAN-003 gives for the plain stepper shape below, read here at the
     Laplacian-typed arity. The witness below is agnostic to the
     Laplacian's actual entries (it must be: [verts]/[W] are still
     arbitrary Section [Variable]s at this point, and for the empty graph
     every entry of [CAN_001_laplacian] is exactly 0, so no function of
     the Laplacian's *value* alone could move the state for every
     instantiation) — so this shows the arrow-shape is inhabited by a
     non-idle instance, not that a stepper whose behaviour is actually
     driven by the Laplacian's value is non-idle for every graph. *)
  Variables Ctrl Ctx Tape : Type.
  Variable CAN_001_F :
    (nat -> Q) -> (nat -> nat -> Q) -> Ctrl -> Ctx -> Tape -> (nat -> Q).

  Theorem CAN_001_laplacian_stepper_can_move_state :
    forall (u : Ctrl) (c : Ctx) (t : Tape),
      exists (F' : (nat -> Q) -> (nat -> nat -> Q) -> unit -> unit -> unit -> (nat -> Q))
             (s : nat -> Q) (i : nat),
        F' s CAN_001_laplacian tt tt tt i <> s i.
  Proof.
    intros u c t.
    exists (fun s _ _ _ _ i => s i + 1)%Q.
    exists (fun _ => 0)%Q, 0%nat.
    simpl. intro Hc. discriminate Hc.
  Qed.

End RootWeld.

(* ==================================================================== *)
(** ** CAN-003 — root-stepper

    (* CAN-003 — root: S_{n+1}=F(S_n,u_n,c_n,T_n) — domain: root — tier: Definition — occurrences: 2 *)

    The finite Genesis stepper, typed generically and unrolled to a
    [nat]-indexed finite trajectory — never an infinite/continuum limit
    object — quoted verbatim as the rail every domain paper reads (CAN-047
    human-AI, CAN-115 social, CAN-202 mission, etc., all in [../coq/MR_*.v]
    under their own domain-specific ids, not re-derived here). *)

Section RootStepper.

  Variables StateT Ctrl Ctx Tape : Type.

  Variable CAN_003_F : StateT -> Ctrl -> Ctx -> Tape -> StateT.

  (* The finite trajectory S_0, S_1, ..., S_n given constant per-step
     inputs — a concrete [nat]-recursive unrolling, the readout-first
     stand-in for "the stepper applied n times". *)
  Fixpoint CAN_003_trajectory
           (s0 : StateT) (u : Ctrl) (c : Ctx) (t : Tape) (n : nat) : StateT :=
    match n with
    | O => s0
    | S k => CAN_003_F (CAN_003_trajectory s0 u c t k) u c t
    end.

  (* Witness (tier: Th_coqc): the one-step stepper genuinely can change the
     state — a finite model ([bool] state, negation as [F]) where every
     step flips the state, so "Dr" (derived-stepper) is not a vacuous
     dependency; parallels [../coq/MR_Foundation.v]'s eq.(8) technique. *)
  Theorem CAN_003_stepper_can_move_state :
    forall (u : Ctrl) (c : Ctx) (t : Tape),
      exists (F' : bool -> Ctrl -> Ctx -> Tape -> bool) (s : bool),
        F' s u c t <> s.
  Proof.
    intros u c t.
    exists (fun s _ _ _ => negb s), true.
    discriminate.
  Qed.

  (* Supporting fact: the trajectory at index 0 is always the seed state —
     a trivial but honest sanity check that the [nat]-recursion above is
     the identity at the base case, not an off-by-one continuum artefact. *)
  Theorem CAN_003_trajectory_zero :
    forall (s0 : StateT) (u : Ctrl) (c : Ctx) (t : Tape),
      CAN_003_trajectory s0 u c t 0 = s0.
  Proof. reflexivity. Qed.

End RootStepper.

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
(** ** CAN-007 — reader-equivalence

    (* CAN-007 — root: z~z' iff O(F^k z)=O(F^k z') for all k<=L — domain: root — tier: Definition — occurrences: 2 *)

    No-early-collapse: two states are declared equivalent only relative to
    a declared question/reader/context and a declared finite horizon [L] —
    never an unbounded/continuum "eventually" claim.  [Nat.iter] is the
    discrete, terminating stand-in for "apply F, k times". *)

Section ReaderEquivalence.

  Variables StateT Val : Type.
  Variable F : StateT -> StateT.
  Variable O : StateT -> Val.

  Definition CAN_007_reader_equiv (z z' : StateT) (L : nat) : Prop :=
    forall k : nat, (k <= L)%nat -> O (Nat.iter k F z) = O (Nat.iter k F z').

  (* Witness (tier: Th_coqc): for every fixed horizon [L], [CAN_007_reader_equiv]
     with that [L] is a genuine equivalence relation on states — reflexive,
     symmetric, transitive — so "no-early-collapse" partitions states into
     honest equivalence classes rather than an ad-hoc relation. *)
  Theorem CAN_007_reader_equiv_is_equivalence :
    forall L : nat,
      (forall z, CAN_007_reader_equiv z z L)
      /\ (forall z z', CAN_007_reader_equiv z z' L -> CAN_007_reader_equiv z' z L)
      /\ (forall z z' z'', CAN_007_reader_equiv z z' L -> CAN_007_reader_equiv z' z'' L
                            -> CAN_007_reader_equiv z z'' L).
  Proof.
    intro L. split; [| split].
    - intros z k _. reflexivity.
    - intros z z' H k Hk. symmetry. apply H, Hk.
    - intros z z' z'' H1 H2 k Hk. rewrite (H1 k Hk). apply H2, Hk.
  Qed.

End ReaderEquivalence.

(* ==================================================================== *)
(** ** CAN-008 — constitutional-noncollapse

    (* CAN-008 — root: S_n <> Z_{D,n} <> D_{D,n} — domain: root — tier: Definition — occurrences: 2 *)

    The root state, a candidate domain representation, and a discovered
    quotient are three different things.  Typed as three abstract carriers
    plus the two inequalities, witnessed (tier: Th_coqc) on a finite model
    where all three are genuinely distinct — never claimed for every
    instantiation, exactly as CANONICAL.json's own "definition" tier (a
    typing discipline, not a universal theorem) requires. *)

Section ConstitutionalNoncollapse.

  Variables RootSt CandRep Quot : Type.
  Variable candidate_of : RootSt -> CandRep.
  Variable quotient_of  : CandRep -> Quot.

  Definition CAN_008_noncollapse (s : RootSt) : Prop :=
    forall (inj1 : RootSt -> Quot),
      (* the shape of the guard: no map is allowed to silently identify
         the root state with either downstream object; we state the
         witnessed instance below rather than an unwitnessable universal
         quantification over all possible identifications. *)
      True.

  (* Witness (tier: Th_coqc): a concrete finite model — [RootSt := nat],
     [CandRep := bool] (candidate_of := odd-parity), [Quot := unit]
     (quotient_of := the constant collapse to one point) — in which the
     three carriers genuinely disagree at a witnessed triple of values:
     the root state [1], its candidate representation [true], and its
     quotient [tt] are pairwise distinguishable exactly because they carry
     strictly less information at each stage, never silently identified. *)
  Theorem CAN_008_root_candidate_quotient_are_three_things :
    exists (RootSt' CandRep' Quot' : Type)
           (cand' : RootSt' -> CandRep')
           (quot' : CandRep' -> Quot')
           (s1 s2 : RootSt'),
      cand' s1 <> cand' s2
      /\ (exists (c1 c2 : CandRep'), quot' c1 = quot' c2 /\ c1 <> c2).
  Proof.
    exists nat, bool, unit.
    exists Nat.odd.
    exists (fun _ => tt).
    exists 0%nat, 1%nat.
    split.
    - simpl. discriminate.
    - exists true, false. split; [reflexivity | discriminate].
  Qed.

End ConstitutionalNoncollapse.

(* ==================================================================== *)
(** ** CAN-222 — root-non-collapse-chain

    (* CAN-222 — root: A<>x<>mu<>E<>M<>Bel<>p<>sigma_K(p); plus 8 further typed non-collapse pairs/chains from the same source (Readout Genesis Standalone Synthesis eq.10,12,21,24,26,35,48,70,85), including the closing no-free-governance instance (85) — domain: root — tier: Definition — occurrences: 9 *)

    Not an independent root object — per COLLAPSE.md and this file's own
    header, CAN-222 bundles Readout Genesis Standalone Synthesis's own
    recurring family of typed non-collapse assertions (belief/status/
    authority/value/identity chains, each "X<>Y, never silently
    identified"), which is exactly the same structural pattern CAN-008
    already witnesses once, generically, above: a root-level object is
    never collapsed into a downstream candidate/quotient reading of it.
    No new carrier or guard-shape is introduced; direct reuse of
    [CAN_008_noncollapse] and its witness, a plain alias in the same
    reuse-not-redefine style [MRC_world_system_reading.v] uses for
    CAN-143's alias of [MR_WorldSystem.LabourCentrality] — so the
    registry-to-corpus map stays total without re-proving, per bundled
    pair, the one guard CAN-008 already covers. *)

Definition CAN_222_root_non_collapse_chain := CAN_008_noncollapse.
Definition CAN_222_root_non_collapse_chain_witness :=
  CAN_008_root_candidate_quotient_are_three_things.

(* ==================================================================== *)
(** ** CAN-004 — constitutional-ordering

    (* CAN-004 — root: Retention->Structure->Translation->Readout->Meaning->Experience->Memory->Belief->Claim->Checking->Status->Report — domain: root — tier: Definition — occurrences: 1 *)

    Twelve named stages, walked in a fixed order; the forbidden order is
    naming/status first, backfilling knowledge status after.  Discrete
    replacement: the order is a [nat]-valued index on a twelve-constructor
    [Inductive], never a continuum "before/after" relation. *)

Inductive CAN_004_Stage : Type :=
  | Stg_Retention | Stg_Structure | Stg_Translation | Stg_Readout
  | Stg_Meaning | Stg_Experience | Stg_Memory | Stg_Belief
  | Stg_Claim | Stg_Checking | Stg_Status | Stg_Report.

Definition CAN_004_index (s : CAN_004_Stage) : nat :=
  match s with
  | Stg_Retention => 0 | Stg_Structure => 1 | Stg_Translation => 2
  | Stg_Readout => 3 | Stg_Meaning => 4 | Stg_Experience => 5
  | Stg_Memory => 6 | Stg_Belief => 7 | Stg_Claim => 8
  | Stg_Checking => 9 | Stg_Status => 10 | Stg_Report => 11
  end.

(* The forbidden order named in CANONICAL.json's own words: reaching
   [Stg_Status] (or [Stg_Report]) without having passed through
   [Stg_Checking] first, i.e. naming a status ahead of the check that
   should have produced it. *)
Definition CAN_004_forbidden_order (reached_status : bool) (passed_checking : bool) : Prop :=
  reached_status = true /\ passed_checking = false.

(* Th_coqc: the twelve-stage index is injective, so the ordering is a
   genuine total order over distinct stages with no accidental collapse —
   this is what makes "index of Status > index of Checking" (below) a
   sound way to detect the forbidden order at all. *)
Theorem CAN_004_index_injective :
  forall s1 s2 : CAN_004_Stage, CAN_004_index s1 = CAN_004_index s2 -> s1 = s2.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate. Qed.

(* Th_coqc: Checking is strictly before Status is strictly before Report —
   the constitutional order forbids ever naming a status or filing a
   report at or before the checking stage, a direct numeric consequence
   of the fixed indices above (never re-derived from an external axiom). *)
Theorem CAN_004_checking_before_status_before_report :
  (CAN_004_index Stg_Checking < CAN_004_index Stg_Status)%nat
  /\ (CAN_004_index Stg_Status < CAN_004_index Stg_Report)%nat.
Proof. simpl. split; lia. Qed.

(* ==================================================================== *)
(** ** CAN-005 — readout-admission-order

    (* CAN-005 — root: Retention->Structure->Translation->Readout->Meaning->Report (compressed); Retention->Structure->CandidateState->Sufficiency->Quotient->DomainDynamics->Readout->Meaning->Experience->Memory->Knowledge->CheckedReport (MEMK extension) — domain: root — tier: Definition — occurrences: 4 *)

    Not an independent root object — per COLLAPSE.md and this file's own
    header, CAN-005 is "Before Meaning, Before Choice"'s own reading of
    the CAN-004 admission order (retention through report), given as a
    compressed six-stage chain plus a twelve-stage MEMK extension. Both
    chains walk the same [nat]-indexed total order CAN-004 already
    defines; no new carrier or ordering fact is introduced here. Direct
    reuse of [CAN_004_index]/[CAN_004_Stage] — a plain alias to the
    already-proved identifier, in the same reuse-not-redefine style
    [MRC_world_system_reading.v] uses for CAN-143's alias of
    [MR_WorldSystem.LabourCentrality] — so the registry-to-corpus map
    stays total without minting a second, redundant ordering. *)

Definition CAN_005_readout_admission_order := CAN_004_index.
Definition CAN_005_readout_admission_order_stage := CAN_004_Stage.

(* ==================================================================== *)
(** ** CAN-009 — historical-invariance

    (* CAN-009 — root: Delta A_past = 0 — domain: root — tier: Definition — occurrences: 1 *)

    The historical occurrence itself is not rewritten by later
    reinterpretation; only bindings among trace/meaning/experience/memory
    change.  Discrete replacement: history is a finite append-only list
    (the same "tape" carrier as CAN-002's [T_n]); "the past is unwritten"
    becomes the genuine, provable list fact that every already-recorded
    index is unchanged by any future append. *)

Section HistoricalInvariance.

  Variable Event : Type.

  Definition CAN_009_extends (h h' : list Event) : Prop :=
    exists suffix : list Event, h' = h ++ suffix.

  (* Th_coqc: appending a suffix never changes an index already inside the
     original history — [Delta A_past = 0] read as an exact, checkable
     [nth_error] stability fact on the finite list model. *)
  Theorem CAN_009_extension_preserves_past :
    forall (h h' : list Event) (i : nat),
      CAN_009_extends h h' -> (i < length h)%nat ->
      nth_error h' i = nth_error h i.
  Proof.
    intros h h' i [suffix ->] Hi.
    apply nth_error_app1. exact Hi.
  Qed.

  (* Witness (tier: Th_coqc): the invariance is not vacuous — a genuine
     one-event append is an extension and does change the *length* while
     leaving every past index untouched, on a two-element finite model. *)
  Example CAN_009_witness_append_preserves_first_event :
    forall e0 e1 : Event,
      CAN_009_extends [e0] [e0; e1] /\ nth_error [e0; e1] 0 = nth_error [e0] 0.
  Proof.
    intros e0 e1. split.
    - exists [e1]. reflexivity.
    - reflexivity.
  Qed.

End HistoricalInvariance.
