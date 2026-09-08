(* weld/M.43.v1 -- Th_coqc -- Kernel of the graph Laplacian equals the *)
(* constants on a connected graph (lambda_2 > 0 zero-mode characterization). *)
(* This entry's OWN registered statement is the reverse-inclusion direction *)
(* only ('connected implies (energy V x == 0 implies x constant on V)', theorem *)
(* `kernel_connected`) -- the forward direction ('constants are in the *)
(* kernel', `energy_const`) is a DUPLICATE of L_R/M.22.v1 *)
(* (`laplacian_ones_in_kernel`, closed, no connectivity needed) and is NOT *)
(* re-registered as new content here; see this entry's relations[] *)
(* (refines -> L_R/M.22.v1) and drift_note for the disclosed overlap. The *)
(* `energy_nonneg`/`energy_const`/`energy_zero_edge` lemmas are kept in *)
(* this file only as the load-bearing support `kernel_connected` is built *)
(* on, not as a second independent registration of already-covered facts. *)
(* *)
(* source: URCF_RD_All.v, Module Graph (lines 885-1058; originally from *)
(* RDL_Graph.v), standalone Coq file, Downloads, not previously deposited *)
(* or registered. Toledo v1.8 (spectral-ceiling merge) extracts this one *)
(* self-contained module verbatim (Coq stdlib only: List, QArith, Lqa -- *)
(* confirmed by re-reading the module's own Import lines; it depends on no *)
(* other module of URCF_RD_All.v). *)
(* *)
(* registered statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \text{Graph connected} \Rightarrow \ker(L_R) = \{\text{constant *)
(* vectors}\}\ (\lambda_2>0) \quad\text{(reverse inclusion only: kernel *)
(* \subseteq constants, given connectivity)} *)

Require Import Coq.Lists.List. Import ListNotations.
Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module Graph.

(* ---- Q square helpers (each a tiny `nra`, no axioms) ----------------- *)
Lemma Qsq_nonneg : forall a:Q, 0 <= a * a.
Proof. intro a. nra. Qed.
Lemma Qsq_eq0 : forall a:Q, a * a == 0 -> a == 0.
Proof. intros a H. nra. Qed.
Lemma Qmult_pos_eq0 : forall p a:Q, 0 < p -> p * a == 0 -> a == 0.
Proof. intros p a Hp H. nra. Qed.

Section Graph.
Variable w : nat -> nat -> Q.                 (* edge weights *)
Hypothesis wsym : forall i j, w i j == w j i.  (* symmetric (undirected) *)
Hypothesis wpos : forall i j, 0 <= w i j.      (* nonnegative *)

(* finite vertex carrier = a list of indices; sums fold over it *)
Definition sumV (V:list nat) (f:nat->Q) : Q := fold_right Qplus 0 (map f V).

Lemma sumV_nil  : forall f, sumV [] f = 0.                       Proof. reflexivity. Qed.
Lemma sumV_cons : forall a V f, sumV (a::V) f = (f a + sumV V f). Proof. reflexivity. Qed.

Lemma sumV_nonneg : forall V f, (forall i, In i V -> 0 <= f i) -> 0 <= sumV V f.
Proof.
  induction V as [|a V IH]; intros f H.
  - rewrite sumV_nil. lra.
  - rewrite sumV_cons.
    assert (0 <= f a) by (apply H; left; reflexivity).
    assert (0 <= sumV V f) by (apply IH; intros i Hi; apply H; right; exact Hi).
    lra.
Qed.

Lemma sumV_eq0 : forall V f, (forall i, In i V -> f i == 0) -> sumV V f == 0.
Proof.
  induction V as [|a V IH]; intros f H.
  - rewrite sumV_nil. reflexivity.
  - rewrite sumV_cons.
    assert (Ha : f a == 0) by (apply H; left; reflexivity).
    assert (HV : sumV V f == 0) by (apply IH; intros i Hi; apply H; right; exact Hi).
    rewrite Ha, HV. ring.
Qed.

Lemma sumV_zero_each : forall V f, (forall i, In i V -> 0 <= f i) -> sumV V f == 0 ->
                       forall i, In i V -> f i == 0.
Proof.
  induction V as [|a V IH]; intros f Hpos Hsum i Hi.
  - inversion Hi.
  - rewrite sumV_cons in Hsum.
    assert (Ha : 0 <= f a) by (apply Hpos; left; reflexivity).
    assert (HV : 0 <= sumV V f) by (apply sumV_nonneg; intros j Hj; apply Hpos; right; exact Hj).
    assert (Hfa : f a == 0) by lra.
    assert (HsV : sumV V f == 0) by lra.
    destruct Hi as [Hia | Hi'].
    + rewrite Hia in Hfa. exact Hfa.
    + apply (IH f); [ intros j Hj; apply Hpos; right; exact Hj | exact HsV | exact Hi' ].
Qed.

(* ---- Dirichlet energy = quadratic form of the Laplacian L_R = D_W - W -- *)
Definition energy (V:list nat) (x:nat->Q) : Q :=
  sumV V (fun i => sumV V (fun j => w i j * (x i - x j) * (x i - x j))).

(* L_R is positive semidefinite (already covered by L_R/M.22.v1's own *)
(* proof effort on the same operator, and by weld/M.41.v1's energy_nonneg; *)
(* kept only as this proof's own load-bearing support). *)
Theorem energy_nonneg : forall V x, 0 <= energy V x.
Proof.
  intros V x. apply sumV_nonneg. intros i Hi. apply sumV_nonneg. intros j Hj.
  pose proof (wpos i j). pose proof (Qsq_nonneg (x i - x j)). nra.
Qed.

(* constant vectors are in the kernel -- DUPLICATE of L_R/M.22.v1 *)
(* (laplacian_ones_in_kernel); kept only as kernel_connected's own *)
(* load-bearing support, NOT re-registered as new content. *)
Theorem energy_const : forall V c, energy V (fun _ => c) == 0.
Proof.
  intros V c. unfold energy.
  apply sumV_eq0. intros i Hi. cbv beta.
  apply sumV_eq0. intros j Hj. cbv beta. ring.
Qed.

(* ---- connectivity ---------------------------------------------------- *)
Definition edge (i j:nat) : Prop := 0 < w i j.

Inductive reach (V:list nat) : nat -> nat -> Prop :=
| reach0 : forall i,     In i V -> reach V i i
| reachS : forall i j k, In i V -> edge i j -> reach V j k -> reach V i k.

Lemma reach_inL : forall V a b, reach V a b -> In a V.
Proof. intros V a b H. induction H; assumption. Qed.

Definition connected (V:list nat) : Prop :=
  forall i j, In i V -> In j V -> reach V i j.

(* zero energy forces equality across every (positively-weighted) edge *)
Theorem energy_zero_edge : forall V x, energy V x == 0 ->
   forall i j, In i V -> In j V -> edge i j -> x i == x j.
Proof.
  intros V x Hen i j Hi Hj Hedge.
  assert (Hinner : sumV V (fun b => w i b * (x i - x b) * (x i - x b)) == 0).
  { apply (sumV_zero_each V (fun a => sumV V (fun b => w a b * (x a - x b) * (x a - x b)))).
    - intros a Ha. apply sumV_nonneg. intros b Hb. pose proof (wpos a b). pose proof (Qsq_nonneg (x a - x b)). nra.
    - exact Hen.
    - exact Hi. }
  assert (Hterm : w i j * (x i - x j) * (x i - x j) == 0).
  { apply (sumV_zero_each V (fun b => w i b * (x i - x b) * (x i - x b))).
    - intros b Hb. pose proof (wpos i b). pose proof (Qsq_nonneg (x i - x b)). nra.
    - exact Hinner.
    - exact Hj. }
  assert (Hwdd : w i j * ((x i - x j) * (x i - x j)) == 0) by (rewrite <- Hterm; ring).
  apply (Qmult_pos_eq0 _ _ Hedge) in Hwdd.
  apply Qsq_eq0 in Hwdd. lra.
Qed.

(* equality propagates along any causal/reachable path *)
Lemma reach_eq : forall V x, energy V x == 0 ->
   forall i k, reach V i k -> x i == x k.
Proof.
  intros V x Hen i k Hr. induction Hr as [i Hi | i j k Hi Hedge Hr IHr].
  - reflexivity.
  - assert (Hj : In j V) by (eapply reach_inL; eauto).
    assert (Hxij : x i == x j)
      by (apply (energy_zero_edge V x Hen i j); [exact Hi | exact Hj | exact Hedge]).
    rewrite Hxij. exact IHr.
Qed.

(* ALGEBRAIC CONNECTIVITY / FIEDLER (kernel form), THIS entry's own *)
(* registered content: on a connected graph the Laplacian's null space is *)
(* exactly the constants <=> the spectral margin lambda_2 is strictly *)
(* positive. Only the 'kernel subset of constants under connectivity' *)
(* direction is new; 'constants subset of kernel' is L_R/M.22.v1. *)
Theorem kernel_connected : forall V x, connected V -> energy V x == 0 ->
   forall i j, In i V -> In j V -> x i == x j.
Proof.
  intros V x Hconn Hen i j Hi Hj.
  apply (reach_eq V x Hen). apply Hconn; assumption.
Qed.

End Graph.

(* ====================================================================== *)
(* AXIOM-FREEDOM CHECK  (coqc, exit 0) -- 'Closed under the global   *)
(* context'.  PSD + zero-mode + edge-rigidity + Fiedler-kernel, all over   *)
(* Q, no axioms (the section hypotheses wsym/wpos became arguments).       *)
(* ====================================================================== *)
Print Assumptions energy_nonneg.
Print Assumptions energy_const.
Print Assumptions energy_zero_edge.
Print Assumptions kernel_connected.

End Graph.
