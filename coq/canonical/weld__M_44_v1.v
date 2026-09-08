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

Module URCF01SuccInj.

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

Theorem RD4_succ_inj : forall x y : D, succ x = succ y -> x = y.
Proof. intros x y H. congruence. Qed.

(* ================== AXIOM-FREEDOM CHECK ================== *)
Print Assumptions RD4_succ_inj.

End URCF01SuccInj.
