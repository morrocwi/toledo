(* weld/M.01.v1 — CAN-001 — Th_coqc — parents: weld — occurrences 7 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

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

