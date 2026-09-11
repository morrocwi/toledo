(* ===================================================================== *)
(*  PROP_EPSC_05_terminal_nonidentifiability.v                           *)
(*  Toledo PROP-EPSC-05, Terminal finite-Fourier-readout                 *)
(*  non-identifiability obstruction, registered in                       *)
(*  registry/proposals/discrete_epsilon_completion.json                  *)
(*                                                                        *)
(*  Registered claim: P_K v = 0 does NOT imply ||(I-P_K)v||_2 = 0 -- a    *)
(*  divergence-free conjugate pair at a mode q = (K+1,0,0) just outside   *)
(*  the retained cube K changes the omitted tail without the truncated   *)
(*  projection P_K ever seeing it.                                       *)
(*                                                                        *)
(*  What this file mechanizes: an EXPLICIT finite witness over Z^3        *)
(*  (concrete integers, no L2/sqrt machinery needed for the logical       *)
(*  content). Fix K. Let q := (K+1, 0, 0) and a := (0, 1, 0) (so q is     *)
(*  outside the retained cube {i : |i.1|<=K /\ |i.2|<=K /\ |i.3|<=K}, and *)
(*  the divergence-free side condition q . a = 0 holds exactly: q.1*a.1  *)
(*  + q.2*a.2 + q.3*a.3 = (K+1)*0 + 0*1 + 0*0 = 0). Define v as the       *)
(*  Fourier coefficient function that is a at q, and 0 everywhere else.  *)
(*  Then: (1) P_K v is the zero function everywhere (v is supported only *)
(*  at q, which the cutoff discards); (2) v itself is NOT the zero       *)
(*  function (v q = a =/= (0,0,0)). This is the rational-native,         *)
(*  discrete surrogate for: P_K v = 0 does not imply v = 0 -- for a      *)
(*  finitely-supported coefficient function, the L2 norm of the tail     *)
(*  being nonzero and the tail function not being identically zero       *)
(*  coincide;                                                             *)
(*  the literal sqrt(sum of squares) computation itself is not           *)
(*  mechanized here (not needed for the logical content, and would pull  *)
(*  in Coq.Reals for no added rigor).                                    *)
(*                                                                        *)
(*  This file does NOT address the L2-norm/continuum reading directly,   *)
(*  nor whether Navier-Stokes dynamics can realize this perturbation at  *)
(*  a prescribed time (the source's own stated claim_boundary).          *)
(*                                                                        *)
(*  Integer-native (Z), no Coq.Reals.                                    *)
(*  Expected: Print Assumptions => Closed under the global context.      *)
(* ===================================================================== *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.micromega.Lia.
Open Scope Z_scope.

Section TerminalNonIdentifiability.

  Variable K : Z.
  Hypothesis K_nonneg : 0 <= K.

  Definition mode := (Z * Z * Z)%type.

  Definition in_cutoff (i : mode) : Prop :=
    let '(i1, i2, i3) := i in
    -K <= i1 <= K /\ -K <= i2 <= K /\ -K <= i3 <= K.

  Definition q : mode := (K + 1, 0, 0).
  Definition a : mode := (0, 1, 0).

  Definition dot (u v : mode) : Z :=
    let '(u1, u2, u3) := u in
    let '(v1, v2, v3) := v in
    u1 * v1 + u2 * v2 + u3 * v3.

  (* The witness is a nonzero, divergence-free coefficient sitting        *)
  (* exactly one mode outside the retained cube. *)
  Lemma q_outside_cutoff : ~ in_cutoff q.
  Proof.
    unfold in_cutoff, q. intros [H1 [H2 H3]]. lia.
  Qed.

  Lemma a_divergence_free : dot q a = 0.
  Proof. unfold dot, q, a. ring. Qed.

  Lemma a_nonzero : a <> (0, 0, 0).
  Proof.
    unfold a. intro H.
    apply (f_equal (fun p => snd (fst p))) in H.
    simpl in H. lia.
  Qed.

  (* v : the Fourier coefficient function, supported only at q. *)
  Definition v (i : mode) : mode :=
    if (Z.eq_dec (fst (fst i)) (fst (fst q))) then
      if (Z.eq_dec (snd (fst i)) (snd (fst q))) then
        if (Z.eq_dec (snd i) (snd q)) then a else (0,0,0)
      else (0,0,0)
    else (0,0,0).

  Definition in_cutoff_dec (i : mode) : bool :=
    let '(i1, i2, i3) := i in
    andb (andb (andb (Z.leb (-K) i1) (Z.leb i1 K))
               (andb (Z.leb (-K) i2) (Z.leb i2 K)))
         (andb (Z.leb (-K) i3) (Z.leb i3 K)).

  Definition P_K (f : mode -> mode) (i : mode) : mode :=
    if (in_cutoff_dec i) then f i else (0,0,0).

  Lemma in_cutoff_dec_correct : forall i, in_cutoff_dec i = true <-> in_cutoff i.
  Proof.
    intros [[i1 i2] i3]. unfold in_cutoff_dec, in_cutoff.
    repeat rewrite Bool.andb_true_iff.
    repeat rewrite Z.leb_le.
    split; intros; lia.
  Qed.

  Lemma q_not_in_cutoff_dec : in_cutoff_dec q = false.
  Proof.
    destruct (in_cutoff_dec q) eqn:E.
    - exfalso. apply q_outside_cutoff. apply in_cutoff_dec_correct. exact E.
    - reflexivity.
  Qed.

  (* Main theorem: P_K v is the zero function everywhere, yet v is not   *)
  (* the zero function -- the exact registered non-identifiability claim,*)
  (* at the discrete/coefficient-function level. *)
  Theorem epsc05_terminal_nonidentifiability :
    (forall i, P_K v i = (0, 0, 0)) /\ (exists i, v i <> (0, 0, 0)).
  Proof.
    split.
    - intro i. unfold P_K.
      destruct (in_cutoff_dec i) eqn:E.
      + (* i is in the cutoff, so i <> q (since q is not in the cutoff),  *)
        (* hence v i = (0,0,0) by definition of v (supported only at q). *)
        unfold v.
        destruct (Z.eq_dec (fst (fst i)) (fst (fst q))) as [E1|]; [ | reflexivity].
        destruct (Z.eq_dec (snd (fst i)) (snd (fst q))) as [E2|]; [ | reflexivity].
        destruct (Z.eq_dec (snd i) (snd q)) as [E3|]; [ | reflexivity].
        exfalso.
        assert (Hi : i = q).
        { destruct i as [[i1 i2] i3]. unfold q in *. simpl in *.
          rewrite E1, E2, E3. reflexivity. }
        rewrite Hi in E. rewrite q_not_in_cutoff_dec in E. discriminate.
      + reflexivity.
    - exists q. unfold v.
      destruct (Z.eq_dec (fst (fst q)) (fst (fst q))) as [_|Hc]; [ | congruence].
      destruct (Z.eq_dec (snd (fst q)) (snd (fst q))) as [_|Hc]; [ | congruence].
      destruct (Z.eq_dec (snd q) (snd q)) as [_|Hc]; [ | congruence].
      apply a_nonzero.
  Qed.

End TerminalNonIdentifiability.
