(* ===================================================================== *)
(*  InfoCPEquivariantGenerationBound_attempt.v — item 2 Attempt 3 witness. *)
(*                                                                         *)
(*  Machine-checked content (all over Q, Gaussian-rational pairs, no reals, *)
(*  no axioms — check with Print Assumptions on each theorem):              *)
(*                                                                         *)
(*   T-A  two_gen_quartet_im_vanishes — for ANY 2x2 complex matrix (over    *)
(*        Q-pairs) satisfying the column-orthogonality relation of          *)
(*        unitarity,                                                        *)
(*        the imaginary part of the Jarlskog-type quartet product is 0.     *)
(*        This is the load-bearing vanishing theorem — N=2 mixing retains   *)
(*        NO CP-signed difference — proven in-house (not cited).            *)
(*   T-B  quartet_conj_flips_sign — elementwise conjugation (the CP action) *)
(*        flips the sign of the quartet's imaginary part, for ARBITRARY     *)
(*        entries: the signed readout is CP-EQUIVARIANT, generally.         *)
(*   T-C  witness_* — one concrete exact Q(i) 3x3 matrix (Pythagorean       *)
(*        rotations + unit Gaussian-rational phase (3+4i)/5, computed and   *)
(*        cross-checked in item2_cp_equivariant_lower_bound_v3.py) is       *)
(*        exactly unitary and has quartet imaginary part 110592/4151485,    *)
(*        nonzero: N=3 DOES retain a CP-signed difference.                  *)
(*   T-D  three_values_realized / values_pairwise_distinct — the sign       *)
(*        readout takes three pairwise-distinct values {+,-,0} on           *)
(*        {witness, CP(witness), a CP-fixed real unitary (I3)} — the        *)
(*        3-value minimality pattern instantiated LOCALLY on THIS           *)
(*        admissibility square (CP involution + sign-of-quartet readout).   *)
(*                                                                         *)
(*  SCOPE (honest fence — read before citing):                              *)
(*   - This file does NOT derive N=3. It proves the CONDITIONAL mechanism:  *)
(*     N=2 forces quartet-Im = 0 (T-A), N=3 admits quartet-Im <> 0 (T-C);   *)
(*     combined with the EMPIRICAL premise that a CP-signed difference is   *)
(*     retained in the world (fed in, not derived), this forces N >= 3.     *)
(*     Excluding N=4,5,... is NOT attempted (Attempt 2's declared           *)
(*     minimality postulate / external empirical cap, unchanged).           *)
(*   - NOVELTY: the physics content (2 generations admit no CKM-type CP     *)
(*     violation; observed CP violation implies >= 3) is KNOWN TEXTBOOK     *)
(*     PHYSICS (Kobayashi-Maskawa 1973), not a discovery of this file.      *)
(*     The contribution is only the in-house, exact, machine-checked        *)
(*     re-derivation and the equivariant-readout criterion analysis.        *)
(*   - CRRC guard (identity-by-role): the "3" here (generation lower bound  *)
(*     via CP-odd retained difference) and the "3" of the color argument    *)
(*     (SM master 2.2 cyclic tape closure) are DIFFERENT quantities with    *)
(*     different roles; neither is used to support the other. Nothing from  *)
(*     the cyclic-closure argument (or IDM_Harvest.v's re-proof of it) is   *)
(*     used anywhere in this file.                                          *)
(*   - Why an N-generation mixing structure exists at all is NOT addressed  *)
(*     (items 21-23; the family-slot ansatz stays an imported working       *)
(*     ansatz per item2 Attempt 1's review).                                *)
(* ===================================================================== *)

Require Import QArith.
Require Import List.
Import ListNotations.
Require Import Bool.

(* ---------------------------------------------------------------------- *)
(*  Gaussian-rational complex numbers: pairs of Q.                          *)
(* ---------------------------------------------------------------------- *)
Record Cq : Type := mkC { cre : Q; cim : Q }.

Definition C0 : Cq := mkC 0 0.
Definition C1 : Cq := mkC 1 0.
Definition Cadd (x y : Cq) : Cq := mkC (cre x + cre y) (cim x + cim y).
Definition Cmul (x y : Cq) : Cq :=
  mkC (cre x * cre y - cim x * cim y) (cre x * cim y + cim x * cre y).
Definition Cconj (x : Cq) : Cq := mkC (cre x) (- cim x).

(* ---------------------------------------------------------------------- *)
(*  T-A · the vanishing theorem.  Entries v00=(a,b) v01=(c,d) v10=(e,f)     *)
(*  v11=(g,h); the COLUMN-orthogonality relation of a 2x2 unitary (the      *)
(*  Hermitian inner product of columns (v00,v10) and (v01,v11)) is          *)
(*  v00*conj(v01) + v10*conj(v11) = 0, i.e. componentwise the two           *)
(*  hypotheses below.  The quartet is v00*v11*conj(v01)*conj(v10).          *)
(*                                                                          *)
(*  Proof shape (the same 3-step argument the Python file states):          *)
(*  Im(quartet) decomposes EXACTLY as a linear combination of the two       *)
(*  orthogonality components (quartet_decomp, a pure ring identity), so     *)
(*  when both vanish, so does Im(quartet).                                  *)
(* ---------------------------------------------------------------------- *)
Lemma quartet_decomp :
  forall a b c d e f g h : Q,
  (cim (Cmul (Cmul (mkC a b) (mkC g h)) (Cmul (Cconj (mkC c d)) (Cconj (mkC e f))))
   == (a*c + b*d + (e*g + f*h)) * (e*h - f*g)
      + ((b*c - a*d) + (f*g - e*h)) * (e*g + f*h))%Q.
Proof. intros. simpl. ring. Qed.

Theorem two_gen_quartet_im_vanishes :
  forall a b c d e f g h : Q,
  (a*c + b*d + (e*g + f*h) == 0)%Q ->
  ((b*c - a*d) + (f*g - e*h) == 0)%Q ->
  (cim (Cmul (Cmul (mkC a b) (mkC g h)) (Cmul (Cconj (mkC c d)) (Cconj (mkC e f))))
   == 0)%Q.
Proof.
  intros a b c d e f g h Hre Him.
  rewrite quartet_decomp. rewrite Hre, Him. ring.
Qed.

(* ---------------------------------------------------------------------- *)
(*  T-B · CP equivariance of the signed readout, for ARBITRARY entries:     *)
(*  conjugating every entry flips the sign of the quartet's Im part.        *)
(* ---------------------------------------------------------------------- *)
Theorem quartet_conj_flips_sign :
  forall z1 z2 z3 z4 : Cq,
  (cim (Cmul (Cmul (Cconj z1) (Cconj z2))
             (Cmul (Cconj (Cconj z3)) (Cconj (Cconj z4))))
   == - cim (Cmul (Cmul z1 z2) (Cmul (Cconj z3) (Cconj z4))))%Q.
Proof. intros [a b] [c d] [e f] [g h]. simpl. ring. Qed.

(* ---------------------------------------------------------------------- *)
(*  3x3 exact matrices as lists; boolean checks fully computable.           *)
(* ---------------------------------------------------------------------- *)
Definition mat := list (list Cq).
Definition idx3 : list nat := [0; 1; 2]%nat.
Definition entry (m : mat) (i j : nat) : Cq := nth j (nth i m []) C0.

Definition mmul3 (A B : mat) : mat :=
  map (fun i =>
    map (fun j =>
      fold_right Cadd C0 (map (fun k => Cmul (entry A i k) (entry B k j)) idx3))
      idx3) idx3.

Definition dag3 (A : mat) : mat :=
  map (fun i => map (fun j => Cconj (entry A j i)) idx3) idx3.

Definition conj3 (A : mat) : mat :=
  map (fun row => map Cconj row) A.

Definition I3 : mat := [[C1; C0; C0]; [C0; C1; C0]; [C0; C0; C1]].

Definition Ceqb (x y : Cq) : bool :=
  andb (Qeq_bool (cre x) (cre y)) (Qeq_bool (cim x) (cim y)).

Definition meq3 (A B : mat) : bool :=
  forallb (fun i => forallb (fun j => Ceqb (entry A i j) (entry B i j)) idx3) idx3.

Definition unitary3 (A : mat) : bool := meq3 (mmul3 (dag3 A) A) I3.

(* the CP-signed readout's raw value: Im(V01 * V12 * conj(V02) * conj(V11)) *)
Definition quartetJ (V : mat) : Q :=
  cim (Cmul (Cmul (entry V 0 1) (entry V 1 2))
            (Cmul (Cconj (entry V 0 2)) (Cconj (entry V 1 1)))).

(* ---------------------------------------------------------------------- *)
(*  T-C · the exact N=3 witness (entries computed & independently cross-    *)
(*  checked in item2_cp_equivariant_lower_bound_v3.py; V = R23 R13(d) R12   *)
(*  with cos/sin from Pythagorean triples 3-4-5, 5-12-13, 8-15-17 and       *)
(*  d = (3+4i)/5 a unit-modulus Gaussian rational).                         *)
(* ---------------------------------------------------------------------- *)
Definition V3w : mat :=
  [[ mkC (24 # 85)     0             ; mkC (32 # 85)      0             ; mkC (9 # 17)   (-12 # 17) ];
   [ mkC (-664 # 1105) (-432 # 1105) ; mkC (-177 # 1105)  (-576 # 1105) ; mkC (96 # 221) 0          ];
   [ mkC (681 # 1105)  (-36 # 221)   ; mkC (-792 # 1105)  (-48 # 221)   ; mkC (40 # 221) 0          ]].

Theorem witness_unitary : unitary3 V3w = true.
Proof. vm_compute. reflexivity. Qed.

Theorem witness_J_value : Qeq_bool (quartetJ V3w) (110592 # 4151485) = true.
Proof. vm_compute. reflexivity. Qed.

Theorem witness_J_nonzero : Qeq_bool (quartetJ V3w) 0 = false.
Proof. vm_compute. reflexivity. Qed.

Theorem witness_cp_unitary : unitary3 (conj3 V3w) = true.
Proof. vm_compute. reflexivity. Qed.

Theorem witness_cp_flips : Qeq_bool (quartetJ (conj3 V3w)) (- (110592 # 4151485)) = true.
Proof. vm_compute. reflexivity. Qed.

(* the CP-fixed neutral object: I3 is real (CP-fixed) unitary with J = 0.   *)
Theorem neutral_cp_fixed : meq3 (conj3 I3) I3 = true.
Proof. vm_compute. reflexivity. Qed.

Theorem neutral_unitary : unitary3 I3 = true.
Proof. vm_compute. reflexivity. Qed.

Theorem neutral_J_zero : Qeq_bool (quartetJ I3) 0 = true.
Proof. vm_compute. reflexivity. Qed.

(* ---------------------------------------------------------------------- *)
(*  T-D · the sign readout takes three pairwise-distinct values on          *)
(*  {witness, CP(witness), neutral} — the 3-value pattern realized on THIS  *)
(*  square.  (The abstract "3 values forced" mechanism is IDM's             *)
(*  minimal_three_values; here we do not cite it — we EXHIBIT the three     *)
(*  values concretely on the SM-side objects, which is the per-instance     *)
(*  content the abstract theorem's hypotheses require.)                     *)
(* ---------------------------------------------------------------------- *)
Inductive Sign3 : Type := SPlus | SMinus | SZero.

Definition sgnQ (q : Q) : Sign3 :=
  match (q ?= 0)%Q with
  | Gt => SPlus
  | Lt => SMinus
  | Eq => SZero
  end.

Theorem three_values_realized :
  sgnQ (quartetJ V3w) = SPlus
  /\ sgnQ (quartetJ (conj3 V3w)) = SMinus
  /\ sgnQ (quartetJ I3) = SZero.
Proof. repeat split; vm_compute; reflexivity. Qed.

Theorem values_pairwise_distinct :
  SPlus <> SMinus /\ SPlus <> SZero /\ SMinus <> SZero.
Proof. repeat split; discriminate. Qed.
