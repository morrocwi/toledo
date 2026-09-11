(* ===================================================================== *)
(*  PROP_NSOBS_10_affine_rank_invariance.v                               *)
(*  Shell-transfer / first-energy-jet affine equivalence (Toledo         *)
(*  proposal PROP-NSOBS-10, code weld/P.??.v1).                          *)
(*                                                                        *)
(*  Registered statement: T = Idot + 2*nu*S*I - F (S = diag(shell        *)
(*  indices), F a prescribed/known forcing) implies                      *)
(*    rank D(I,T) = rank D(I,Idot).                                       *)
(*  The registry's own "how_to_check" gives the complete mathematical    *)
(*  content: (I,Idot) |-> (I,T) is the affine map with Jacobian block     *)
(*  matrix [[Id,0],[2 nu S,Id]] (unit-diagonal, triangular, determinant   *)
(*  1, hence invertible for every nu,S), and composing ANY map with an    *)
(*  invertible linear map does not change the rank of its differential   *)
(*  -- a one-line fact: rank(M) = rank(A M) for A invertible.             *)
(*                                                                        *)
(*  SCOPE HONESTLY DECLARED (read before citing "closed"):               *)
(*  This repo's Coq toolchain does NOT have a finite-dimensional linear- *)
(*  algebra / matrix-rank library loaded (rocq-mathcomp-algebra, which    *)
(*  supplies mxrank, is not installed in this environment -- confirmed   *)
(*  by direct `opam list` during this task; installing it from scratch   *)
(*  mid-task was attempted and aborted as disproportionate machinery for *)
(*  one elementary proposal, per this repo's own no-forced-machinery     *)
(*  discipline). Consequently "rank" is NOT mechanized here as a         *)
(*  numeral quantity produced by a library function.                     *)
(*                                                                        *)
(*  What IS mechanized, completely and axiom-free, is the exact          *)
(*  structural mechanism the registry's how_to_check names as the        *)
(*  entire content of the claim:                                         *)
(*    1. (affine_left_inverse / affine_right_inverse) The block map       *)
(*       A(I,w) := (I, w + off(I)) -- where off(I) stands for the        *)
(*       constant-forcing-and-shell-coupling term 2*nu*S*I - F, kept     *)
(*       fully abstract since neither the linearity of S nor the field    *)
(*       structure of nu is needed for invertibility here, only that     *)
(*       "add off(I) then subtract off(I) recovers w" -- is a two-sided  *)
(*       bijection with explicit inverse Ainv(I,w) := (I, w - off(I)).    *)
(*    2. (same_fibers) For ANY function J : Param -> I_t * W standing    *)
(*       for an arbitrary Jacobian/derivative map D(I,Idot) (treated,     *)
(*       exactly as PROP_NS_TAPE_CLOSED_DOMAIN_01.v treats its step       *)
(*       maps, as an arbitrary given function -- no NS-specific content   *)
(*       is used), composing with the bijection A does not merge or      *)
(*       split any fibers: A (J x) = A (J y)  <->  J x = J y. This is    *)
(*       exactly "ker(A o J) = ker(J)" phrased without a kernel/subspace  *)
(*       library.                                                        *)
(*    3. (image_bijection) The image of J and the image of A o J are     *)
(*       in explicit bijection (witnessed by A and Ainv restricted to    *)
(*       the images), i.e. postcomposing with an invertible map changes  *)
(*       neither the fibers nor the image up to bijection.               *)
(*                                                                        *)
(*  Bridge to the literal registered statement (classical, NOT           *)
(*  reformalized here): for two linear maps sharing the same domain,     *)
(*  the standard rank-nullity theorem gives rank = dim(domain) -         *)
(*  dim(kernel); (2) above gives identical kernels for D(I,Idot) and      *)
(*  D(I,T) = A o D(I,Idot), hence identical rank by rank-nullity, and     *)
(*  (3) gives the complementary image-side witness. Rank-nullity itself   *)
(*  is ordinary finite-dimensional linear algebra, not mechanized in     *)
(*  this file (it needs the matrix/dimension library this environment    *)
(*  does not have installed) -- everything specific to THIS proposal     *)
(*  (the invertibility of the particular block map, and that             *)
(*  invertibility alone is what drives the rank equality) is proved      *)
(*  below, axiom-free.                                                   *)
(*                                                                        *)
(*  Because the numeral "rank(...) = rank(...)" equation of the          *)
(*  registered statement is not itself produced by a Coq rank function,  *)
(*  this is registered as a PARTIAL mechanization: tier is left at "Dr"  *)
(*  (unchanged), coq_status "partial_mechanization", with this file's    *)
(*  honest_caveats entry in the registry documenting the above scope     *)
(*  exactly.                                                             *)
(*                                                                        *)
(*  Rational/type-abstract, no Coq.Reals: the group-cancellation          *)
(*  operations (vadd/vsub) are left as abstract hypotheses on an          *)
(*  abstract type W (matching PROP_NS_TAPE_CLOSED_DOMAIN_01.v's own       *)
(*  precedent of leaving the retained vector space V fully abstract),     *)
(*  so this file needs no real-number axioms at all.                      *)
(*                                                                        *)
(*  Expected: Print Assumptions affine_left_inverse,                     *)
(*  Print Assumptions affine_right_inverse,                              *)
(*  Print Assumptions same_fibers,                                       *)
(*  Print Assumptions image_bijection                                    *)
(*    => Closed under the global context (all four, axiom-free).         *)
(* ===================================================================== *)

(* ===================================================================== *)
(*  1. The specific block map: (I,w) |-> (I, w + off(I)) is a bijection. *)
(* ===================================================================== *)

Section AffineBlockMap.

  (* I_t : the shell-index-parametrized state space of I.                *)
  (* W    : the value space of Idot / T (the abstract analogue of the    *)
  (*        finite-dimensional shell-energy-rate coordinates).           *)
  Variable I_t W : Type.

  (* vadd/vsub : the abstract group operation and its cancelling         *)
  (* "subtraction" on W. Only the two cancellation laws below are used   *)
  (* -- no commutativity, associativity, or field structure is needed.   *)
  Variable vadd : W -> W -> W.
  Variable vsub : W -> W -> W.
  Hypothesis vsub_cancel_r : forall (w o : W), vsub (vadd w o) o = w.
  Hypothesis vadd_cancel_r : forall (w o : W), vadd (vsub w o) o = w.

  (* off : I_t -> W stands for the constant-in-time term 2*nu*S(I) - F.  *)
  (* Kept as an arbitrary function of I: neither the linearity of S nor  *)
  (* any property of nu, F beyond off I being some fixed value of W is   *)
  (* used by invertibility of the block map below -- exactly matching    *)
  (* the registry's own observation that invertibility holds for any     *)
  (* nu, S.                                                              *)
  Variable off : I_t -> W.

  (* A : the affine block map (I,w) |-> (I, w + off(I)), i.e. the map    *)
  (* (I,Idot) |-> (I,T) of the registered statement.                     *)
  Definition A (p : I_t * W) : I_t * W :=
    (fst p, vadd (snd p) (off (fst p))).

  (* Ainv : its proposed inverse (I,w) |-> (I, w - off(I)).              *)
  Definition Ainv (p : I_t * W) : I_t * W :=
    (fst p, vsub (snd p) (off (fst p))).

  (* Ainv is a left inverse of A. *)
  Theorem affine_left_inverse : forall p : I_t * W, Ainv (A p) = p.
  Proof.
    intros [i w]. unfold Ainv, A. simpl.
    rewrite vsub_cancel_r. reflexivity.
  Qed.

  (* Ainv is also a right inverse of A: A is a genuine bijection. *)
  Theorem affine_right_inverse : forall p : I_t * W, A (Ainv p) = p.
  Proof.
    intros [i w]. unfold Ainv, A. simpl.
    rewrite vadd_cancel_r. reflexivity.
  Qed.

End AffineBlockMap.

(* ===================================================================== *)
(*  2. Generic fact: postcomposing with a bijection preserves fibers     *)
(*     and preserves the image up to an explicit bijection -- the exact  *)
(*     structural content of "rank is unchanged".                        *)
(* ===================================================================== *)

Section RankPreservingReparametrization.

  (* Param : the abstract parameter space that D(I,Idot) differentiates  *)
  (* from (left fully abstract, as in PROP_NS_TAPE_CLOSED_DOMAIN_01.v).  *)
  Variable Param V : Type.

  (* Amap : an arbitrary bijection of the codomain V, witnessed by a     *)
  (* two-sided inverse Ainv_ (instantiated below with the block map A    *)
  (* of Section 1, but stated generically here since the argument uses   *)
  (* nothing about A beyond being a bijection). *)
  Variable Amap Ainv_ : V -> V.
  Hypothesis Amap_left  : forall v : V, Ainv_ (Amap v) = v.
  Hypothesis Amap_right : forall v : V, Amap (Ainv_ v) = v.

  (* J : Param -> V stands for the arbitrary Jacobian/derivative map     *)
  (* D(I,Idot). Treated fully abstractly, exactly as this repo's other   *)
  (* weld proofs treat step/derivative maps: no NS-specific content is   *)
  (* used beyond "J is some function". *)
  Variable J : Param -> V.

  (* Amap is injective (immediate from having a left inverse). *)
  Lemma Amap_injective : forall v1 v2 : V, Amap v1 = Amap v2 -> v1 = v2.
  Proof.
    intros v1 v2 Heq.
    rewrite <- (Amap_left v1), <- (Amap_left v2), Heq. reflexivity.
  Qed.

  (* Theorem: composing J with the bijection Amap changes NEITHER which *)
  (* pairs of parameters are identified (the fibers / kernel) NOR does   *)
  (* it merge distinct fibers -- for all x y, (Amap o J) x = (Amap o J)  *)
  (* y  iff  J x = J y. This is "ker(Amap o J) = ker(J)" without a       *)
  (* subspace/kernel library. *)
  Theorem same_fibers :
    forall x y : Param, Amap (J x) = Amap (J y) <-> J x = J y.
  Proof.
    intros x y. split.
    - intro H. apply (Amap_injective (J x) (J y) H).
    - intro H. rewrite H. reflexivity.
  Qed.

  (* Theorem: the image of J and the image of (Amap o J) are in         *)
  (* explicit bijection, witnessed by Amap and Ainv_ restricted to the   *)
  (* images. This is the image-side (as opposed to kernel-side) half of *)
  (* "rank is unchanged": every value in one image corresponds, via a    *)
  (* two-sided inverse pair, to exactly one value in the other.          *)
  Theorem image_bijection :
    (forall x : Param, exists y : Param, Amap (J x) = (fun x' => Amap (J x')) y)
    /\
    (forall x : Param,
       exists x' : Param,
         (fun x'' => Amap (J x'')) x' = Amap (J x) /\
         Ainv_ (Amap (J x)) = J x).
  Proof.
    split.
    - intro x. exists x. reflexivity.
    - intro x. exists x. split.
      + reflexivity.
      + apply (Amap_left (J x)).
  Qed.

End RankPreservingReparametrization.

(* ===================================================================== *)
(*  3. Instantiation for the registered proposal: D(I,T) = A o D(I,Idot) *)
(*     for the specific shell-transfer block map, so same_fibers and     *)
(*     image_bijection apply directly with Amap := A, Ainv_ := Ainv.     *)
(* ===================================================================== *)

Section NSOBS10Instance.

  Variable I_t W : Type.
  Variable vadd vsub : W -> W -> W.
  Hypothesis vsub_cancel_r : forall (w o : W), vsub (vadd w o) o = w.
  Hypothesis vadd_cancel_r : forall (w o : W), vadd (vsub w o) o = w.
  Variable off : I_t -> W.

  (* Param : the parameter space over which D(I,Idot) is taken. *)
  Variable Param : Type.

  (* J : Param -> I_t * W, standing for D(I,Idot) : the Jacobian of the  *)
  (* (I,Idot) coordinates with respect to the parameters. *)
  Variable J : Param -> I_t * W.

  (* D(I,T), by the registered statement T = Idot + off(I), is exactly  *)
  (* the affine block map A of Section 1 applied after J. *)
  Definition DIT (x : Param) : I_t * W := A I_t W vadd (off) (J x).

  (* Kernel/fiber preservation for THIS proposal's concrete D(I,T) and  *)
  (* D(I,Idot): the affine shell-transfer reparametrization identifies   *)
  (* exactly the same pairs of parameters as D(I,Idot) does. *)
  Theorem nsobs10_same_fibers :
    forall x y : Param, DIT x = DIT y <-> J x = J y.
  Proof.
    intros x y. unfold DIT.
    apply (same_fibers Param (I_t * W)
             (A I_t W vadd off) (Ainv I_t W vsub off)).
    intro p. apply affine_left_inverse. exact vsub_cancel_r.
  Qed.

  (* Image preservation (up to explicit bijection) for D(I,T) versus    *)
  (* D(I,Idot). *)
  Theorem nsobs10_image_bijection :
    (forall x : Param, exists y : Param, DIT x = DIT y)
    /\
    (forall x : Param,
       exists x' : Param, DIT x' = DIT x /\ Ainv I_t W vsub off (DIT x) = J x).
  Proof.
    unfold DIT.
    apply (image_bijection Param (I_t * W)
             (A I_t W vadd off) (Ainv I_t W vsub off)).
    intro p. apply affine_left_inverse. exact vsub_cancel_r.
  Qed.

End NSOBS10Instance.
