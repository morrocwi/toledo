(* ===================================================================== *)
(*  RDL_SpineGraphCoupled.v                                               *)
(*  COUPLED spine energy in the NODE basis — removes the eigenbasis /      *)
(*  mode-decoupling assumption of RDL_SpineGraphEnergy §11.                *)
(*                                                                        *)
(*  We build the discrete inner product and the Dirichlet bilinear form    *)
(*  B(Φ,Ψ) = <diff Φ, diff Ψ> directly on lists of node values, and prove  *)
(*    - B is SYMMETRIC and POSITIVE-SEMIDEFINITE on the whole graph        *)
(*      (no spectral decomposition);                                       *)
(*    - the COUPLED energy rate Ė = −Damp·|v|² ≤ 0 from the power-balance   *)
(*      (weak) form of the equation of motion.                             *)
(*  All axiom-free (Th_coqc).                                              *)
(*                                                                        *)
(*  HONEST RESIDUAL: the power-balance EOM is taken as a hypothesis here;   *)
(*  deriving it from the strong per-node EOM (M v̇ = −Damp v − K LΦ) needs   *)
(*  the summation-by-parts identity  <v, LΦ> = B(Φ,v)  — named as the next  *)
(*  lemma, not faked. What IS proved is fully coupled in the node basis.    *)
(* ===================================================================== *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Psatz.
Require Import Coq.Lists.List.
Import ListNotations.

(* ---- discrete inner product on node-value lists ---- *)
Fixpoint inner (u w : list Q) : Q :=
  match u, w with
  | a :: u', b :: w' => a * b + inner u' w'
  | _, _ => 0
  end.

Lemma inner_sym : forall u w, inner u w == inner w u.
Proof.
  induction u as [| a u' IH]; intros w; destruct w as [| b w']; simpl; try ring.
  rewrite (IH w'). ring.
Qed.

Lemma inner_self_nonneg : forall u, 0 <= inner u u.
Proof.
  induction u as [| a u' IH]; simpl.
  - apply Qle_refl.
  - assert (0 <= a * a) by nra. lra.
Qed.

(* ---- discrete gradient (forward difference) and Dirichlet bilinear form ---- *)
Fixpoint diff (l : list Q) : list Q :=
  match l with
  | a :: ((b :: _) as t) => (b - a) :: diff t
  | _ => []
  end.

Definition B (u w : list Q) : Q := inner (diff u) (diff w).

Theorem B_sym : forall u w, B u w == B w u.
Proof. intros u w. unfold B. apply inner_sym. Qed.

(* the coupled Dirichlet energy is PSD on the WHOLE graph (node basis) *)
Theorem B_self_nonneg : forall u, 0 <= B u u.
Proof. intro u. unfold B. apply inner_self_nonneg. Qed.

(* ---- summation-by-parts: the named residual of §12, now PROVEN ---- *)
(*  Adjoint (backward difference with boundary) of the forward difference. *)
Fixpoint codiff_aux (prev : Q) (w : list Q) : list Q :=
  match w with
  | [] => [prev]
  | x :: w' => (prev - x) :: codiff_aux x w'
  end.

Definition codiff (w : list Q) : list Q :=
  match w with
  | [] => [0]
  | x :: w' => (- x) :: codiff_aux x w'
  end.

(* the graph Laplacian as adjoint(diff) ∘ diff *)
Definition lap (Phi : list Q) : list Q := codiff (diff Phi).

Lemma diff_length : forall l, length (diff l) = pred (length l).
Proof.
  induction l as [| a l' IH].
  - reflexivity.
  - destruct l' as [| b t].
    + reflexivity.
    + simpl. simpl in IH. rewrite IH. reflexivity.
Qed.

(* controlled cons-equations (definitional; avoid simpl over-unfolding diff into a match) *)
Lemma inner_cons : forall a u b w, inner (a :: u) (b :: w) = a * b + inner u w.
Proof. reflexivity. Qed.
Lemma diff_cons : forall a b t, diff (a :: b :: t) = (b - a) :: diff (b :: t).
Proof. reflexivity. Qed.
Lemma codiff_aux_cons : forall p x w, codiff_aux p (x :: w) = (p - x) :: codiff_aux x w.
Proof. reflexivity. Qed.
Lemma codiff_cons : forall w0 w, codiff (w0 :: w) = (- w0) :: codiff_aux w0 w.
Proof. reflexivity. Qed.

(* Abel-summation kernel *)
Lemma aux_law :
  forall w u c prev, length u = length w ->
    inner (c :: u) (codiff_aux prev w) == c * prev + inner (diff (c :: u)) w.
Proof.
  induction w as [| x w' IHw]; intros u c prev Hlen.
  - destruct u; [| simpl in Hlen; discriminate]. simpl. ring.
  - destruct u as [| d u']; [simpl in Hlen; discriminate |].
    simpl in Hlen. injection Hlen as Hlen.
    rewrite codiff_aux_cons, inner_cons, (IHw u' d x Hlen), diff_cons, inner_cons.
    ring.
Qed.

(* discrete integration by parts: <diff u, w> = <u, codiff w> *)
Lemma diff_adjoint :
  forall u w, length u = S (length w) ->
    inner (diff u) w == inner u (codiff w).
Proof.
  intros u w. revert u. induction w as [| w0 w' IHw]; intros u Hlen.
  - destruct u as [| a [| b u'']]; simpl in Hlen; try discriminate. simpl. ring.
  - destruct u as [| a [| b u'']]; simpl in Hlen; try discriminate.
    injection Hlen as Hlen.
    rewrite diff_cons, codiff_cons, inner_cons, inner_cons,
            (aux_law w' u'' b w0 Hlen).
    ring.
Qed.

(* SUMMATION-BY-PARTS:  <v, LΦ> = B(v,Φ)  for equal-length node fields *)
Theorem sbp :
  forall v Phi, length v = length Phi -> inner v (lap Phi) == B v Phi.
Proof.
  intros v Phi Hlen. destruct Phi as [| p Phi'].
  - destruct v as [| a v']; [| simpl in Hlen; discriminate]. reflexivity.
  - unfold lap, B. symmetry. apply diff_adjoint.
    rewrite diff_length. simpl. simpl in Hlen. exact Hlen.
Qed.

(* ---- coupled energy non-increase (node basis, no eigendecomposition) ---- *)
Section CoupledEnergy.
  Variables M Damp K : Q.
  Variables Phi v vdot : list Q.

  (* power-balance (weak) form of the coupled EOM, contracted with v:
        <v, M v̇> = −Damp <v,v> − K B(Φ,v).
     The K B(Φ,v) term is <v, K LΦ> via summation-by-parts (the named residual). *)
  Hypothesis power_balance :
    inner v (map (fun a => M * a) vdot) == - (Damp * inner v v) - K * B Phi v.

  (* total energy rate: kinetic power + potential power (= K·B(Φ,v)) *)
  Definition Edot_total : Q :=
    (inner v (map (fun a => M * a) vdot) + K * B Phi v)%Q.

  Theorem coupled_energy_rate : Edot_total == - (Damp * inner v v).
  Proof. unfold Edot_total. rewrite power_balance. ring. Qed.

  Theorem coupled_energy_nonincreasing : 0 <= Damp -> Edot_total <= 0.
  Proof.
    intro HD. rewrite coupled_energy_rate.
    assert (0 <= inner v v) by apply inner_self_nonneg. nra.
  Qed.

End CoupledEnergy.

(* ---- STRONG form: power_balance is now DISCHARGED by sbp (no residual) ---- *)
(*  The only hypothesis is the physical EOM (the strong per-node law M v̇ =
    −Damp v − K LΦ, contracted with v); summation-by-parts converts the
    Laplacian-force power ⟨v, LΦ⟩ into the Dirichlet form B(Φ,v). *)
Section StrongEnergy.
  Variables M Damp K : Q.
  Variables Phi v vdot : list Q.
  Hypothesis Hlen : length v = length Phi.

  Hypothesis strong_eom :
    inner v (map (fun a => M * a) vdot)
      == - (Damp * inner v v) - K * inner v (lap Phi).

  Theorem strong_energy_rate :
    (inner v (map (fun a => M * a) vdot) + K * B Phi v) == - (Damp * inner v v).
  Proof.
    rewrite strong_eom, (sbp v Phi Hlen), (B_sym v Phi). ring.
  Qed.

  Theorem strong_energy_nonincreasing :
    0 <= Damp ->
    (inner v (map (fun a => M * a) vdot) + K * B Phi v) <= 0.
  Proof.
    intro HD. rewrite strong_energy_rate.
    assert (0 <= inner v v) by apply inner_self_nonneg. nra.
  Qed.

End StrongEnergy.

(* ---- final residual closed: inner bilinearity ⇒ EOM as a per-node LIST ---- *)
Definition vscale (k : Q) (l : list Q) : list Q := map (fun a => k * a) l.
Lemma vscale_cons : forall k a l, vscale k (a :: l) = (k * a) :: vscale k l.
Proof. reflexivity. Qed.

Fixpoint vsub (a b : list Q) : list Q :=
  match a, b with
  | x :: a', y :: b' => (x - y) :: vsub a' b'
  | _, _ => []
  end.
Lemma vsub_cons : forall x a y b, vsub (x :: a) (y :: b) = (x - y) :: vsub a b.
Proof. reflexivity. Qed.

(* bilinearity: contracting a linear combination with v *)
Lemma inner_linear_combo :
  forall u a b p q, length a = length u -> length b = length u ->
    inner u (vsub (vscale p a) (vscale q b)) == p * inner u a - q * inner u b.
Proof.
  induction u as [| c u' IH]; intros a b p q Ha Hb.
  - simpl. ring.
  - destruct a as [| ax a']; [simpl in Ha; discriminate |].
    destruct b as [| bx b']; [simpl in Hb; discriminate |].
    simpl in Ha, Hb. injection Ha as Ha. injection Hb as Hb.
    rewrite vscale_cons, vscale_cons, vsub_cons, inner_cons,
            (IH a' b' p q Ha Hb), inner_cons, inner_cons.
    ring.
Qed.

(* length of the graph Laplacian (nonempty) *)
Lemma codiff_aux_length : forall w prev, length (codiff_aux prev w) = S (length w).
Proof. induction w as [| x w' IH]; intro prev; [reflexivity | simpl; rewrite IH; reflexivity]. Qed.
Lemma codiff_length : forall w, length (codiff w) = S (length w).
Proof. destruct w as [| x w']; [reflexivity | simpl; rewrite codiff_aux_length; reflexivity]. Qed.
Lemma lap_length_cons : forall p Phi', length (lap (p :: Phi')) = length (p :: Phi').
Proof. intros p Phi'. unfold lap. rewrite codiff_length, diff_length. reflexivity. Qed.

(* spine stability from the GENUINE per-node EOM (a list equality), no contraction assumed *)
Section StrongEnergyList.
  Variables M Damp K : Q.
  Variables Phi v vdot : list Q.
  Hypothesis HlenP : length v = length Phi.

  (* per-node law:  M·v̇ = (−Damp)·v − K·(LΦ)   as a list equation *)
  Hypothesis eom_list :
    vscale M vdot = vsub (vscale (- Damp) v) (vscale K (lap Phi)).

  Theorem list_energy_nonincreasing :
    0 <= Damp -> (inner v (vscale M vdot) + K * B Phi v) <= 0.
  Proof.
    intro HD.
    assert (Hc : inner v (vscale M vdot)
                 == - (Damp * inner v v) - K * inner v (lap Phi)).
    { rewrite eom_list. destruct Phi as [| p Phi'].
      - destruct v as [| a v']; [simpl; ring | simpl in HlenP; discriminate].
      - assert (Hlap : length (lap (p :: Phi')) = length v)
          by (rewrite lap_length_cons; symmetry; exact HlenP).
        rewrite (inner_linear_combo v v (lap (p :: Phi')) (- Damp) K eq_refl Hlap).
        ring. }
    rewrite Hc, (sbp v Phi HlenP), (B_sym v Phi).
    assert (0 <= inner v v) by apply inner_self_nonneg. nra.
  Qed.

End StrongEnergyList.
