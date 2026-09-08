Require Coq.Arith.PeanoNat.
Require Coq.Bool.Bool.
Require Coq.Classes.Morphisms.
Require Coq.Classes.RelationClasses.
Require Coq.Lists.List.
Require Coq.Logic.Classical.
Require Coq.QArith.QArith.
Require Coq.Setoids.Setoid.
Require Coq.Sorting.Permutation.
Require Coq.ZArith.ZArith.
Require Coq.micromega.Lia.
Require Coq.micromega.Lqa.
Require Field.
Require Lia.
Require List.
Require PeanoNat.
Require Permutation.
Require QArith.
Require Qabs.
Require Qminmax.
Require Qround.
Require Wf_nat.
Require ZArith.

Module URCF12Categoricity.

Import PeanoNat.
Import Wf_nat.
Import Lia.
Import ZArith.
Import QArith.
Import Field.
Import Qabs.
Import Qminmax.
Import Qround.
Import Coq.micromega.Lqa.
Open Scope nat_scope.

Inductive D : Type :=
  | zero : D
  | succ : D -> D.

Section Categoricity.
  Variable M : Type.
  Variable zM : M.
  Variable sM : M -> M.
  Hypothesis sM_inj  : forall x y, sM x = sM y -> x = y.
  Hypothesis sM_ne_z : forall x, sM x <> zM.
  Hypothesis M_ind   : forall (P:M->Prop), P zM -> (forall x, P x -> P (sM x)) -> forall x, P x.

  Fixpoint emb (n:D) : M := match n with zero => zM | succ n' => sM (emb n') end.

  Lemma emb_surj : forall m, exists n, emb n = m.
  Proof.
    apply (M_ind (fun m => exists n, emb n = m)).
    - exists zero. reflexivity.
    - intros x [n Hn]. exists (succ n). simpl. rewrite Hn. reflexivity.
  Qed.

  Lemma emb_inj : forall n1 n2, emb n1 = emb n2 -> n1 = n2.
  Proof.
    intros n1 n2; revert n2; induction n1 as [|n1 IH]; intros [|n2] H; simpl in H.
    - reflexivity.
    - exfalso; symmetry in H; exact (sM_ne_z _ H).
    - exfalso; exact (sM_ne_z _ H).
    - f_equal; apply IH; apply sM_inj; exact H.
  Qed.

  Theorem categoricity :
    (emb zero = zM)
    /\ (forall n, emb (succ n) = sM (emb n))
    /\ (forall n1 n2, emb n1 = emb n2 -> n1 = n2)
    /\ (forall m, exists n, emb n = m).
  Proof.
    repeat split.
    - intros n1 n2 H. apply emb_inj. exact H.
    - apply emb_surj.
  Qed.
End Categoricity.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions categoricity.

End URCF12Categoricity.
