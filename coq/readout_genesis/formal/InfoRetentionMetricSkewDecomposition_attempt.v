(* InfoRetentionMetricSkewDecomposition_attempt.v
   Target: READOUT_GENESIS_CORE.md V.13a / II.8a "T1" -- the metric-G / operator-(+/-) split.
   V.13a states, currently tagged [Dr]/[Open], "PROPOSED, pending test T1. Do not assert as proven":
     split the transport operator by the RETENTION METRIC G (not naive transpose):
       Top_sym  = (Top + Top_adjG) / 2      (G-self-adjoint part)
       Top_skew = (Top - Top_adjG) / 2      (G-skew-adjoint part)
     with the target identity  ip z (Top_skew z) = 0  for all z
     ("skew part carries oriented transfer/rotation, no self-diagonal contribution" under the
     retention inner product ip x y := <x,y>_G).

   Fully abstract: F is any scalar type with an abelian-group addition and a vector-level halving
   witness (half, Half) -- the explicit "characteristic not 2" hypothesis needed to reconstruct the
   operator from its two halves. V is any F-module, additive abelian group under addV. ip is any
   symmetric F-bilinear form on V. (T,Tadj) is any pair satisfying the DEFINING adjoint equation
   w.r.t. ip, plus adjoint-of-adjoint = T (true automatically for the concrete Tadj = G^-1 T^T G
   construction whenever G is invertible; stated here as an explicit premise, not silently
   assumed). No Section, no Variable, no Hypothesis -- every theorem states its own explicit
   forall-premises, matching this arc's house style (InfoGaugeAutomorphismGroup.v /
   InfoGaugeLocalizationConnectionHolonomy.v). Numerically verified first on a concrete G<>I
   rational fixture, including the negative control that the naive-transpose split does NOT have
   this property when G<>I (t1_metric_g_skew_verify.py, PASS). *)

(* ---------- abelian-group helper lemmas ---------- *)

Lemma group_right_id (G:Type) (add:G->G->G) (zero:G)
  (comm : forall x y, add x y = add y x)
  (idl  : forall x, add zero x = x) :
  forall x, add x zero = x.
Proof. intros x. rewrite comm. apply idl. Qed.

Lemma group_right_inv (G:Type) (add:G->G->G) (zero:G) (opp:G->G)
  (comm : forall x y, add x y = add y x)
  (invl : forall x, add (opp x) x = zero) :
  forall x, add x (opp x) = zero.
Proof. intros x. rewrite comm. apply invl. Qed.

(* the double-a cancellation:  (a+b)+(a+(-b)) = a+a  -- the combinatorial core of the split *)
Lemma double_regroup (V:Type) (addV:V->V->V) (zeroV:V) (oppV:V->V)
  (Vassoc : forall x y z, addV (addV x y) z = addV x (addV y z))
  (Vcomm  : forall x y, addV x y = addV y x)
  (Vidl   : forall x, addV zeroV x = x)
  (Vinvl  : forall x, addV (oppV x) x = zeroV) :
  forall a b, addV (addV a b) (addV a (oppV b)) = addV a a.
Proof.
  intros a b.
  assert (Vinvr : forall y, addV y (oppV y) = zeroV) by (apply group_right_inv; assumption).
  assert (step1 : addV b (addV a (oppV b)) = a).
  { rewrite (Vcomm a (oppV b)).
    rewrite <- (Vassoc b (oppV b) a).
    rewrite (Vinvr b).
    rewrite (Vidl a).
    reflexivity. }
  rewrite (Vassoc a b (addV a (oppV b))).
  rewrite step1.
  reflexivity.
Qed.

(* ip-symmetry lets first-argument linearity / scalar-linearity / opp-linearity transport to the
   second argument, so we only ever have to state each law once, on the first argument. *)
Lemma ip_linear_arg2 (V F:Type) (addV:V->V->V) (addF:F->F->F) (ip:V->V->F)
  (ip_symm : forall x y, ip x y = ip y x)
  (ip_lin1 : forall x y z, ip (addV x y) z = addF (ip x z) (ip y z)) :
  forall x y z, ip x (addV y z) = addF (ip x y) (ip x z).
Proof.
  intros x y z.
  rewrite (ip_symm x (addV y z)).
  rewrite (ip_lin1 y z x).
  rewrite (ip_symm y x). rewrite (ip_symm z x).
  reflexivity.
Qed.

Lemma ip_scalar_arg2 (V F:Type) (smul:F->V->V) (mulF:F->F->F) (ip:V->V->F)
  (ip_symm : forall x y, ip x y = ip y x)
  (ip_scal1 : forall a x y, ip (smul a x) y = mulF a (ip x y)) :
  forall a x y, ip x (smul a y) = mulF a (ip x y).
Proof.
  intros a x y.
  rewrite (ip_symm x (smul a y)).
  rewrite (ip_scal1 a y x).
  rewrite (ip_symm y x).
  reflexivity.
Qed.

Lemma ip_opp_arg2 (V F:Type) (oppV:V->V) (addF:F->F->F) (zeroF:F) (ip:V->V->F)
  (ip_symm : forall x y, ip x y = ip y x)
  (ip_opp1 : forall a b, addF (ip a b) (ip (oppV a) b) = zeroF) :
  forall a b, addF (ip a b) (ip a (oppV b)) = zeroF.
Proof.
  intros a b.
  rewrite (ip_symm a b).
  rewrite (ip_symm a (oppV b)).
  apply (ip_opp1 b a).
Qed.

(* ================= main development ================= *)

(* THEOREM 1: the split reconstructs the original operator, Tsym x + Tskew x = T x. *)
Theorem retention_split_reconstructs_operator :
  forall (F V : Type)
         (addF : F -> F -> F) (oneF half : F)
         (addV : V -> V -> V) (zeroV : V) (oppV : V -> V)
         (smul : F -> V -> V)
         (T Tadj : V -> V)
         (Vassoc : forall x y z, addV (addV x y) z = addV x (addV y z))
         (Vcomm  : forall x y, addV x y = addV y x)
         (Vidl   : forall x, addV zeroV x = x)
         (Vinvl  : forall x, addV (oppV x) x = zeroV)
         (Sdist_V : forall a x y, smul a (addV x y) = addV (smul a x) (smul a y))
         (Sdist_F : forall a b x, smul (addF a b) x = addV (smul a x) (smul b x))
         (Sone    : forall x, smul oneF x = x)
         (Half    : addF half half = oneF),
  forall x,
    addV (smul half (addV (T x) (Tadj x)))
         (smul half (addV (T x) (oppV (Tadj x))))
    = T x.
Proof.
  intros F V addF oneF half addV zeroV oppV smul T Tadj
         Vassoc Vcomm Vidl Vinvl Sdist_V Sdist_F Sone Half x.
  rewrite <- (Sdist_V half (addV (T x) (Tadj x)) (addV (T x) (oppV (Tadj x)))).
  rewrite (double_regroup V addV zeroV oppV Vassoc Vcomm Vidl Vinvl (T x) (Tadj x)).
  rewrite (Sdist_V half (T x) (T x)).
  rewrite <- (Sdist_F half half (T x)).
  rewrite Half.
  apply Sone.
Qed.

(* THEOREM 2: the symmetric part is G-self-adjoint: <Tsym x,y> = <x,Tsym y>. *)
Theorem retention_sym_part_is_self_adjoint :
  forall (F V : Type)
         (addF mulF : F -> F -> F) (half : F)
         (addV : V -> V -> V)
         (smul : F -> V -> V)
         (ip : V -> V -> F)
         (T Tadj : V -> V)
         (addF_comm  : forall a b, addF a b = addF b a)
         (ip_symm    : forall x y, ip x y = ip y x)
         (ip_lin1    : forall x y z, ip (addV x y) z = addF (ip x z) (ip y z))
         (ip_scal1   : forall a x y, ip (smul a x) y = mulF a (ip x y))
         (adjoint_eq  : forall x y, ip (T x) y = ip x (Tadj y))
         (adjoint_inv : forall x y, ip (Tadj x) y = ip x (T y)),
  forall x y,
    ip (smul half (addV (T x) (Tadj x))) y
    = ip x (smul half (addV (T y) (Tadj y))).
Proof.
  intros F V addF mulF half addV smul ip T Tadj
         addF_comm ip_symm ip_lin1 ip_scal1 adjoint_eq adjoint_inv x y.
  pose proof (ip_linear_arg2 V F addV addF ip ip_symm ip_lin1) as ip_lin2.
  pose proof (ip_scalar_arg2 V F smul mulF ip ip_symm ip_scal1) as ip_scal2.
  rewrite (ip_scal1 half (addV (T x) (Tadj x)) y).
  rewrite (ip_lin1 (T x) (Tadj x) y).
  rewrite (adjoint_eq x y).
  rewrite (adjoint_inv x y).
  rewrite (ip_scal2 half x (addV (T y) (Tadj y))).
  rewrite (ip_lin2 x (T y) (Tadj y)).
  rewrite (addF_comm (ip x (T y)) (ip x (Tadj y))).
  reflexivity.
Qed.

(* THEOREM 3 (the T1 target): the skew part's quadratic form vanishes under the retention
   inner product: ip z (Tskew z) = 0 for all z. This is the exact identity V.13a/II.8a state
   ("z^T G_n^(-) z = 0"), now with an explicit proof from the adjoint-equation premises alone --
   no matrices, no naive transpose, no assumption smuggled in about G itself beyond ip being a
   symmetric bilinear form and (T,Tadj) being an honest adjoint pair for it. *)
Theorem retention_skew_quadratic_form_vanishes :
  forall (F V : Type)
         (addF mulF : F -> F -> F) (zeroF half : F)
         (addV : V -> V -> V) (oppV : V -> V)
         (smul : F -> V -> V)
         (ip : V -> V -> F)
         (T Tadj : V -> V)
         (ip_symm     : forall x y, ip x y = ip y x)
         (ip_lin1     : forall x y z, ip (addV x y) z = addF (ip x z) (ip y z))
         (ip_scal1    : forall a x y, ip (smul a x) y = mulF a (ip x y))
         (ip_opp1     : forall a b, addF (ip a b) (ip (oppV a) b) = zeroF)
         (mulF_zero_r : forall a, mulF a zeroF = zeroF)
         (adjoint_eq  : forall x y, ip (T x) y = ip x (Tadj y)),
  forall z,
    ip z (smul half (addV (T z) (oppV (Tadj z)))) = zeroF.
Proof.
  intros F V addF mulF zeroF half addV oppV smul ip T Tadj
         ip_symm ip_lin1 ip_scal1 ip_opp1 mulF_zero_r adjoint_eq z.
  pose proof (ip_linear_arg2 V F addV addF ip ip_symm ip_lin1) as ip_lin2.
  pose proof (ip_scalar_arg2 V F smul mulF ip ip_symm ip_scal1) as ip_scal2.
  pose proof (ip_opp_arg2 V F oppV addF zeroF ip ip_symm ip_opp1) as ip_opp2.
  rewrite (ip_scal2 half z (addV (T z) (oppV (Tadj z)))).
  rewrite (ip_lin2 z (T z) (oppV (Tadj z))).
  assert (Asym : ip z (T z) = ip z (Tadj z)).
  { rewrite (ip_symm z (T z)). apply (adjoint_eq z z). }
  rewrite Asym.
  rewrite (ip_opp2 z (Tadj z)).
  apply mulF_zero_r.
Qed.
