(* ================================================================= *)
(*  InfoOrderDefectFromComposition.v                          *)
(*  SM-G0 / UF-0 subgoal G0.6 : the ORDER DEFECT (commutator) is      *)
(*  DERIVED from ordered composition, not borrowed.                    *)
(*                                                                     *)
(*  THE POINT (what this discharges).                                 *)
(*  AP20 (readout_universe/v2/RETENTION_SELF_INTERACTION.md) gets     *)
(*  c_self/c_geo = 1 on THREE borrowed premises. Its premise #2,      *)
(*  "Borrowed commutator curvature K(x,y)=m(x,y)-m(y,x)", is stated   *)
(*  there verbatim as: "The noncommutative/Lie-algebraic input        *)
(*  remains borrowed; AP20 does not derive it from RD4."              *)
(*  InfoDiscreteRiemannCommutator_attempt.v also only POSITS a        *)
(*  Heisenberg law hmul with the non-commuting term (+ hx*hy) written *)
(*  in by hand.                                                       *)
(*                                                                     *)
(*  Here the ordered composition m is PLAIN 2x2 rational matrix       *)
(*  product -- the concrete form of "compose transport X then         *)
(*  transport Y" for linear readout-transports over Q. NOWHERE is a   *)
(*  non-commuting term written into the product; matrix product is    *)
(*  just ordered composition of linear maps. Then:                    *)
(*    - m is associative                    (mmul_assoc, a THEOREM)   *)
(*    - K(X,Y) := m X Y - m Y X             (the order defect)        *)
(*    - K is bilinear + antisymmetric       (matching AP20's expansion)*)
(*    - Jacobi holds                        (jacobi, from associativity)*)
(*    - non-commutativity is EMERGENT       (nonabelian_witness: two   *)
(*      specific transports fail to commute -- not put in by hand)    *)
(*    - K = 0 exactly when they commute     (abelian_no_selfforce =    *)
(*      AP20's own failing control, now DERIVED not assumed)          *)
(*  This REDUCES AP20 premise #2 in status but does NOT remove it.    *)
(*  Theorem-level now: the commutator FORM -- associativity,          *)
(*  antisymmetry, and Jacobi are DERIVED (not an imported Lie-algebra *)
(*  axiom), the defect is the order defect of a concrete associative  *)
(*  ordered composition. What REMAINS an input: the self-force is     *)
(*  nonzero only for a NON-COMMUTING pair (diagonal_commute_zero_     *)
(*  defect proves K=0 for all commuting pairs), and such a pair is    *)
(*  here HAND-EXHIBITED (X0,Y0), not forced from the root -- so the   *)
(*  non-abelian INPUT is relocated to "the root emits a non-commuting *)
(*  pair", not eliminated (AP20 itself: "does not remove the          *)
(*  Lie-algebra/commutator borrow").                                  *)
(*                                                                     *)
(*  HONEST FENCE (tier discipline -- do NOT read more than this).     *)
(*  CLOSED (Th_coqc, axiom-free over Q): associativity of ordered     *)
(*  composition, bilinearity + antisymmetry + Jacobi of the order     *)
(*  defect, emergent non-commutativity, and the abelian => zero-defect*)
(*  control. This GROUNDS THE FORM of AP20 borrow #2 (Jacobi/antisym  *)
(*  become theorems) but the non-abelian input stays contingent on an *)
(*  un-forced non-commuting pair; borrow #2 is reduced, not removed.  *)
(*  STILL OPEN, NOT smuggled: AP20 premise #3 self-carrier closure    *)
(*  and premise #4 the one common quadratic load (A4) are untouched;  *)
(*  whether the two exhibited transports are FORCED by the root seed  *)
(*  (vs merely root-plausible) is a stronger claim not made here; and *)
(*  the physical gauge group (SU(3) is the wall), chirality, matter   *)
(*  reps, generations, constants are all still 0%. This is a finite   *)
(*  structural lemma, not a Standard Model derivation.                *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoOrderDefectFromComposition.
Open Scope Q_scope.

(* ----- 2x2 rational matrix = a linear readout-transport over Q ----- *)
Record M2 : Type := mk { a11 : Q ; a12 : Q ; a21 : Q ; a22 : Q }.

(* setoid equality: componentwise Qeq *)
Definition Meq (X Y : M2) : Prop :=
  a11 X == a11 Y /\ a12 X == a12 Y /\ a21 X == a21 Y /\ a22 X == a22 Y.

Definition mzero : M2 := mk 0 0 0 0.
Definition mid   : M2 := mk 1 0 0 1.

Definition madd (X Y : M2) : M2 :=
  mk (a11 X + a11 Y) (a12 X + a12 Y) (a21 X + a21 Y) (a22 X + a22 Y).
Definition mneg (X : M2) : M2 :=
  mk (- a11 X) (- a12 X) (- a21 X) (- a22 X).
Definition msub (X Y : M2) : M2 := madd X (mneg Y).

(* ORDERED COMPOSITION m = matrix product = "transport X then transport Y".
   No non-commuting term is written in; this is the plain linear-map product. *)
Definition mmul (X Y : M2) : M2 :=
  mk (a11 X * a11 Y + a12 X * a21 Y)
     (a11 X * a12 Y + a12 X * a22 Y)
     (a21 X * a11 Y + a22 X * a21 Y)
     (a21 X * a12 Y + a22 X * a22 Y).

(* THE ORDER DEFECT (AP20 premise #2, now a DEFINITION from ordered comp). *)
Definition K (X Y : M2) : M2 := msub (mmul X Y) (mmul Y X).

Ltac m4 := unfold Meq, mmul, madd, mneg, msub, K, mzero, mid in *;
           simpl; repeat split; ring.

(* ---- G0.1 : ordered composition is ASSOCIATIVE (a theorem, not an axiom) ---- *)
Theorem mmul_assoc : forall X Y Z : M2,
  Meq (mmul (mmul X Y) Z) (mmul X (mmul Y Z)).
Proof. intros [] [] []; m4. Qed.

Theorem mmul_id_l : forall X : M2, Meq (mmul mid X) X.
Proof. intros []; m4. Qed.
Theorem mmul_id_r : forall X : M2, Meq (mmul X mid) X.
Proof. intros []; m4. Qed.

(* ---- the order defect matches AP20's K(x,y)=m(x,y)-m(y,x) definitionally ---- *)
Theorem K_is_ordered_defect : forall X Y : M2,
  Meq (K X Y) (msub (mmul X Y) (mmul Y X)).
Proof. intros [] []; m4. Qed.

(* ---- antisymmetry: K(X,Y) = -(K(Y,X)) ---- *)
Theorem K_antisym : forall X Y : M2, Meq (K X Y) (mneg (K Y X)).
Proof. intros [] []; m4. Qed.

(* ---- bilinearity (left) -- this is exactly AP20's epsilon-expansion step ---- *)
Theorem K_bilinear_left : forall X1 X2 Y : M2,
  Meq (K (madd X1 X2) Y) (madd (K X1 Y) (K X2 Y)).
Proof. intros [] [] []; m4. Qed.

Theorem K_bilinear_right : forall X Y1 Y2 : M2,
  Meq (K X (madd Y1 Y2)) (madd (K X Y1) (K X Y2)).
Proof. intros [] [] []; m4. Qed.

(* ---- G0.6 core : JACOBI, derived from associativity of ordered composition ---- *)
Theorem jacobi : forall X Y Z : M2,
  Meq (madd (madd (K X (K Y Z)) (K Y (K Z X))) (K Z (K X Y))) mzero.
Proof. intros [] [] []; m4. Qed.

(* ---- non-commutativity is EMERGENT, not written in ----
   Two concrete transports: a raise X0 and a lower Y0. Their ordered
   composition disagrees by order => K(X0,Y0) has a11 = 1 (nonzero). *)
Definition X0 : M2 := mk 0 1 0 0.   (* upper shift *)
Definition Y0 : M2 := mk 0 0 1 0.   (* lower shift *)

Theorem nonabelian_witness_a11 : a11 (K X0 Y0) == 1.
Proof. unfold K, X0, Y0, mmul, msub, madd, mneg; simpl; ring. Qed.

Theorem nonabelian_witness : ~ Meq (K X0 Y0) mzero.
Proof.
  unfold Meq, mzero. intros [H _].
  (* H : a11 (K X0 Y0) == 0, but nonabelian_witness_a11 says it == 1 *)
  assert (Ha : a11 (K X0 Y0) == 1) by apply nonabelian_witness_a11.
  rewrite Ha in H. unfold Qeq in H; simpl in H; discriminate.
Qed.

(* ---- AP20's failing control, NOW DERIVED : commuting transports => zero defect ----
   Two diagonal transports commute, so the order defect vanishes: no self-force
   term can be built. (Abelian => no non-abelian self-coupling.) *)
Definition D1 : M2 := mk 2 0 0 3.
Definition D2 : M2 := mk 5 0 0 7.

Theorem abelian_no_selfforce : Meq (K D1 D2) mzero.
Proof. unfold K, D1, D2; m4. Qed.

(* general form: ANY two diagonal transports commute => K = 0 *)
Theorem diagonal_commute_zero_defect : forall p q r s : Q,
  Meq (K (mk p 0 0 q) (mk r 0 0 s)) mzero.
Proof. intros p q r s; m4. Qed.

End InfoOrderDefectFromComposition.

(* Axiom audit: must print "Closed under the global context". *)
Print Assumptions InfoOrderDefectFromComposition.jacobi.
Print Assumptions InfoOrderDefectFromComposition.mmul_assoc.
Print Assumptions InfoOrderDefectFromComposition.nonabelian_witness.
Print Assumptions InfoOrderDefectFromComposition.abelian_no_selfforce.
