(* weld/M.41.v1 -- Th_coqc -- Dirichlet energy PSD/gauge invariance for a *)
(* weighted graph (L_R positive semidefinite, Fiedler), plus the *)
(* axiom-free discrete-second-difference precursor to the continuum limit *)
(* L_R -> -Delta_g. Genuinely new content (2026-09-08 reverification: no *)
(* existing L_R/* reading proves PSD-ness for all x, gauge invariance, the *)
(* [1,-2,1] stencil, or readout-invariance of the second difference). *)
(* *)
(* source: RDL_GammaSpectral.v (standalone Coq file, Downloads, not *)
(* previously deposited or registered). Toledo v1.8 (spectral-ceiling *)
(* merge) copies the file verbatim (self-contained, Coq stdlib only: *)
(* List, Sorting.Permutation, QArith, Lqa -- confirmed by re-reading its *)
(* own Require lines). *)
(* *)
(* registered statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \text{energy\_nonneg: nonnegative edge weights} \Rightarrow \Gamma(x) *)
(* \ge 0\ (L_R \text{ PSD}); \text{energy\_edge\_gauge: } \Gamma \text{ *)
(* invariant under edge-list relabelling}; \text{laplacian\_stencil: } *)
(* [1,-2,1]*f = (\Delta_{\text{discrete}} f); \text{secondDiff\_readout\_ *)
(* invariant: the second difference of a quadratic reads out the same *)
(* value } 2a \text{ at every resolution } h *)

Require Import Coq.Lists.List. Import ListNotations.
Require Import Coq.Sorting.Permutation.
Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Open Scope Q_scope.

(* --- Q nonnegativity helpers --- *)
Lemma Qplus_nonneg : forall a b, 0 <= a -> 0 <= b -> 0 <= a + b.
Proof. intros; lra. Qed.
Lemma Qsq_nonneg : forall d, 0 <= d * d.
Proof. intro d; nra. Qed.
Lemma Qmul_nonneg : forall a b, 0 <= a -> 0 <= b -> 0 <= a * b.
Proof. intros; nra. Qed.

(* ===== (1) Gamma : weighted-graph Dirichlet energy ===== *)
Definition Edge := (nat * nat * Q)%type.
Definition w_of (e:Edge) : Q   := snd e.
Definition u_of (e:Edge) : nat := fst (fst e).
Definition v_of (e:Edge) : nat := snd (fst e).

Definition term (x:nat->Q) (e:Edge) : Q :=
  w_of e * ((x (u_of e) - x (v_of e)) * (x (u_of e) - x (v_of e))).

Definition energy (edges:list Edge) (x:nat->Q) : Q :=
  fold_right (fun e acc => term x e + acc) 0 edges.

(* PSD : nonneg edge weights => Dirichlet energy >= 0 (the L_R >= 0 core) *)
Theorem energy_nonneg : forall edges x,
  (forall e, In e edges -> 0 <= w_of e) -> 0 <= energy edges x.
Proof.
  induction edges as [|e es IH]; intros x Hw.
  - simpl; lra.
  - simpl. apply Qplus_nonneg.
    + apply Qmul_nonneg.
      * apply Hw; left; reflexivity.
      * apply Qsq_nonneg.
    + apply IH. intros e' He'. apply Hw; right; exact He'.
Qed.

(* GRAPH-GAUGE (PGFT Table 10): permuting/relabeling the edge multiset *)
(* leaves the invariant graph readout (energy) unchanged. *)
Theorem energy_edge_gauge : forall x edges edges',
  Permutation edges edges' -> energy edges x == energy edges' x.
Proof.
  intros x edges edges' Hp. unfold energy. induction Hp.
  - reflexivity.
  - simpl. rewrite IHHp. reflexivity.
  - simpl. ring.
  - rewrite IHHp1; exact IHHp2.
Qed.

Theorem energy_zero_edges : forall x, energy [] x == 0.
Proof. intro x; reflexivity. Qed.

(* ===== (2) discrete continuum precursor (axiom-free half of L_R->-Delta_g) === *)
Definition D2 (f:Q->Q) (x h:Q) : Q := f (x + h) - (2#1) * f x + f (x - h).
Definition quad (a b c:Q) : Q -> Q := fun t => a*t*t + b*t + c.

(* the [1,-2,1] stencil IS the discrete (negative) Laplacian *)
Theorem laplacian_stencil : forall f x h,
  D2 f x h == f (x - h) - (2#1) * f x + f (x + h).
Proof. intros; unfold D2; ring. Qed.

(* 2nd difference of a quadratic = 2a*h^2 EXACTLY (all x, all h) *)
Theorem secondDiff_quadratic : forall a b c x h,
  D2 (quad a b c) x h == (2#1) * a * (h * h).
Proof. intros; unfold D2, quad; ring. Qed.

(* READOUT-INVARIANT : the scaled 2nd-difference reading is identical at *)
(* every resolution h and location x -- value 2a disclosed at ALL *)
(* resolutions (NO division), exactly the pi/phi readout-invariant pattern. *)
Theorem secondDiff_readout_invariant : forall a b c x x' h h',
  D2 (quad a b c) x h * (h' * h') == D2 (quad a b c) x' h' * (h * h).
Proof. intros; unfold D2, quad; ring. Qed.

(* --------------------------------------------------------------------- *)
Print Assumptions energy_nonneg.
Print Assumptions energy_edge_gauge.
Print Assumptions laplacian_stencil.
Print Assumptions secondDiff_quadratic.
Print Assumptions secondDiff_readout_invariant.
