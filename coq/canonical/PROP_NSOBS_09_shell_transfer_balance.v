(* ===================================================================== *)
(*  PROP_NSOBS_09_shell_transfer_balance.v                                *)
(*  Finite shell-energy transfer balance and conservation (Toledo         *)
(*  proposal PROP-NSOBS-09, code weld/P.??.v1).                           *)
(*                                                                        *)
(*  Statement being mechanized (registry/proposals/                       *)
(*  ns_energy_observability_extensions.json and                           *)
(*  ns_energy_transfer_observability_bridge.json):                        *)
(*    Idot_s = T_s - 2 nu s I_s + F_s                                     *)
(*    sum_s T_s = 0  in the unforced (F = 0) closed finite Galerkin       *)
(*    system.                                                             *)
(*                                                                        *)
(*  TIER-MISMATCH NOTE (per survey instruction): the extensions.json      *)
(*  copy tags this "Dr"; the bridge.json copy tags it "Definition". Dr    *)
(*  is correct -- the balance equation itself is a pure definitional      *)
(*  identity (T_s is *defined* as whatever remains once dissipation and   *)
(*  forcing are subtracted from the shell-energy rate), but                *)
(*  sum_s T_s = 0 is a real conservation claim that needs the             *)
(*  antisymmetry of the pressure-projected convective nonlinearity as an   *)
(*  input -- it does not hold for an arbitrary T_s. Both source files     *)
(*  should read "Dr"; this file's registry update fixes the "Definition"   *)
(*  copy.                                                                 *)
(*                                                                        *)
(*  WHAT IS MECHANIZED (honest, and this is the whole of the intended     *)
(*  Coq-tractable content per the proposal's own "how_to_check"):          *)
(*    1. shell_balance_is_definitional: for I_s, F_s, nu, s given          *)
(*       arbitrarily and T_s *defined* as Idot_s + 2 nu s I_s - F_s, the   *)
(*       stated balance Idot_s = T_s - 2 nu s I_s + F_s holds identically  *)
(*       -- pure algebra, no physics content (Print Assumptions:           *)
(*       axiom-free).                                                     *)
(*    2. antisym_double_sum_zero: the finite combinatorial telescoping     *)
(*       argument the proposal names explicitly as its Coq strategy --     *)
(*       'the bilinear coupling coefficients are antisymmetric under       *)
(*       exchange within each interacting triad ... summing the per-      *)
(*       triad contributions grouped by shell therefore telescopes to      *)
(*       zero'. This is formalized as: given ANY finite shell index list   *)
(*       and ANY pairwise shell-to-shell transfer coefficient X : Shell -> *)
(*       Shell -> Q satisfying the antisymmetry X(s,s') = - X(s',s) (the   *)
(*       shell-coarsened image of the mode-triad antisymmetry              *)
(*       C(k;p,q) = -C(p;k,q) the proposal cites, i.e. the standard         *)
(*       shell-to-shell transfer antisymmetry T_{s->s'} = -T_{s'->s} of    *)
(*       Fourier-Galerkin NS energy-transfer bookkeeping), the total       *)
(*       double sum sum_s sum_s' X(s,s') is exactly 0 -- by finite double- *)
(*       sum exchange (Fubini for finite lists, proved below by            *)
(*       induction) plus S = -S => S = 0 in Q. (Print Assumptions:         *)
(*       axiom-free.)                                                     *)
(*    3. shell_transfer_conserved: instantiating T_s := sum_s' X(s,s')     *)
(*       (the standard shell-to-shell transfer decomposition), the         *)
(*       proposal's headline claim sum_s T_s = 0 follows directly from     *)
(*       (2). (Print Assumptions: axiom-free.)                            *)
(*                                                                        *)
(*  WHAT THIS DOES NOT PROVE (honest_caveats -- read together with the     *)
(*  registry entry, not silently dropped):                                *)
(*    - This does NOT derive the antisymmetry hypothesis X(s,s')=-X(s',s)  *)
(*      from the actual Navier-Stokes convective term, the incompressible  *)
(*      pressure projection, or a concrete per-triad coefficient           *)
(*      C(k;p,q) built from the Fourier-Galerkin equations themselves --   *)
(*      that instantiation step (going from 'sum_k u_k . (u.grad u)_k = 0  *)
(*      exactly' to a specific shell-indexed X) is cited from standard NS  *)
(*      shell-energy bookkeeping, not re-derived here from first           *)
(*      principles of the PDE. The mechanized content is exactly the       *)
(*      combinatorial step the proposal's own "how_to_check" isolates as   *)
(*      the Coq-tractable part: antisymmetric pairwise coefficients ==>    *)
(*      the grouped/summed total vanishes.                                *)
(*    - The proposal's literal statement groups contributions by explicit  *)
(*      wavevector TRIADS (k,p,q) rather than by a shell-to-shell pairwise *)
(*      coefficient X(s,s'). The two are mathematically equivalent ways    *)
(*      to encode 'the total nonlinear energy exchange telescopes to       *)
(*      zero once summed over all retained structure' for the standard     *)
(*      Fourier-Galerkin shell decomposition (a triad (k,p,q) with          *)
(*      shell(k)=s, shell(p)=s', shell(q)=s'' contributes with the same     *)
(*      antisymmetric-exchange structure that a pairwise shell flux         *)
(*      X(s,s') = -X(s',s) captures once coarse-grained to two-shell        *)
(*      exchanges), but a literal three-index triad formalization with an   *)
(*      explicit finite wavevector cube K_N is a strictly larger            *)
(*      mechanization task left OPEN here.                                  *)
(*    - Idot_s (the time derivative of I_s along the true PDE/ODE           *)
(*      trajectory) is never given a concrete definition here; item (1)     *)
(*      is a pure identity in Idot_s, T_s, I_s, F_s as free variables,      *)
(*      exactly mirroring that the balance equation is definitional.        *)
(*                                                                        *)
(*  Rational-native (no Coq.Reals), matching this repo's existing          *)
(*  precedent (PROP_CONF_03_union_bound.v, PROP_NS_TAPE_CLOSED_DOMAIN_01.v):*)
(*  every quantity here (I_s, T_s, F_s, nu, X(s,s')) is stated over Q,      *)
(*  since nothing in the mechanized content needs the reals.                *)
(*                                                                        *)
(*  Expected: Print Assumptions shell_balance_is_definitional,             *)
(*  Print Assumptions antisym_double_sum_zero,                             *)
(*  Print Assumptions shell_transfer_conserved                             *)
(*    => Closed under the global context (all three, axiom-free).          *)
(* ===================================================================== *)

Require Import Coq.Lists.List.
Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Import ListNotations.
Local Open Scope Q_scope.

(* ===================================================================== *)
(*  1. The balance equation is definitional (pure algebra).               *)
(* ===================================================================== *)

Section BalanceDefinitional.

  Variables Idot_s I_s F_s nu s : Q.

  (* T_s is *defined* as whatever remains once viscous dissipation and    *)
  (* declared forcing are subtracted from the shell-energy rate -- this   *)
  (* is exactly what 'T_s is the finite nonlinear triad transfer into     *)
  (* shell s' means operationally in the source bookkeeping. *)
  Definition T_s : Q := Idot_s + 2 * nu * s * I_s - F_s.

  Theorem shell_balance_is_definitional :
    Idot_s == T_s - 2 * nu * s * I_s + F_s.
  Proof.
    unfold T_s. ring.
  Qed.

End BalanceDefinitional.

(* ===================================================================== *)
(*  2. Finite double-sum exchange (Fubini for finite lists).              *)
(* ===================================================================== *)

Section DoubleSumExchange.

  (* sum of a zero-valued map over any list is 0. *)
  Lemma sum_zero_map : forall (A : Type) (l : list A),
    fold_right Qplus 0 (map (fun _ => 0) l) == 0.
  Proof.
    induction l as [| a l IH]; simpl.
    - reflexivity.
    - rewrite IH. ring.
  Qed.

  (* sum of a pointwise sum equals the sum of the two separate sums. *)
  Lemma sum_add_distrib : forall (A : Type) (g h : A -> Q) (l : list A),
    fold_right Qplus 0 (map g l) + fold_right Qplus 0 (map h l)
    == fold_right Qplus 0 (map (fun a => g a + h a) l).
  Proof.
    induction l as [| a l IH]; simpl.
    - ring.
    - rewrite <- IH. ring.
  Qed.

  (* sum of a pointwise negation equals the negation of the sum. *)
  Lemma sum_opp : forall (A : Type) (g : A -> Q) (l : list A),
    fold_right Qplus 0 (map (fun a => - g a) l) == - fold_right Qplus 0 (map g l).
  Proof.
    induction l as [| a l IH]; simpl.
    - ring.
    - rewrite IH. ring.
  Qed.

  (* Pointwise Qeq of the summands (not Leibniz equal functions, since
     the summands here are only known Qeq to each other) still gives
     Qeq of the finite sums -- the setoid analogue of List.map_ext. *)
  Lemma sum_ext_qeq : forall (A : Type) (g h : A -> Q) (l : list A),
    (forall a, In a l -> g a == h a) ->
    fold_right Qplus 0 (map g l) == fold_right Qplus 0 (map h l).
  Proof.
    induction l as [| a l IH]; intros Hext; simpl.
    - reflexivity.
    - rewrite (Hext a (or_introl eq_refl)).
      rewrite (IH (fun a' Ha' => Hext a' (or_intror Ha'))).
      reflexivity.
  Qed.

  (* The double-sum exchange lemma: two nested finite sums over the same
     pair of (possibly different) index lists commute, exactly the
     "finite combinatorial telescoping" step the proposal's how_to_check
     names as the required re-indexing of the grouped-by-shell double
     sum. *)
  Lemma double_sum_exchange :
    forall (A B : Type) (f : A -> B -> Q) (la : list A) (lb : list B),
      fold_right Qplus 0 (map (fun a => fold_right Qplus 0 (map (fun b => f a b) lb)) la)
      == fold_right Qplus 0 (map (fun b => fold_right Qplus 0 (map (fun a => f a b) la)) lb).
  Proof.
    intros A B f la lb.
    induction la as [| a la IH]; simpl.
    - symmetry. apply sum_zero_map.
    - rewrite IH.
      apply sum_add_distrib.
  Qed.

End DoubleSumExchange.

(* ===================================================================== *)
(*  3. Antisymmetric pairwise coefficients: the grouped total vanishes.   *)
(* ===================================================================== *)

Section AntisymDoubleSum.

  Variable Shell : Type.
  Variable X : Shell -> Shell -> Q.
  Variable shells : list Shell.

  (* The shell-coarsened image of the per-triad convective-coupling
     antisymmetry C(k;p,q) = -C(p;k,q) the proposal cites: energy flux
     from shell s to shell s' is the exact negative of the flux from s'
     to s (the standard shell-to-shell Fourier-Galerkin NS transfer
     antisymmetry, T_{s->s'} = -T_{s'->s}). *)
  Hypothesis X_antisym : forall s s' : Shell, X s s' == - X s' s.

  Definition total_double_sum : Q :=
    fold_right Qplus 0 (map (fun s => fold_right Qplus 0 (map (fun s' => X s s') shells)) shells).

  Theorem antisym_double_sum_zero : total_double_sum == 0.
  Proof.
    (* Step 1: replace every X s s' by -(X s' s), pointwise inside the
       inner sum, for each fixed outer s. *)
    assert (Hpointwise : forall s : Shell,
      fold_right Qplus 0 (map (fun s' => X s s') shells)
      == - fold_right Qplus 0 (map (fun s' => X s' s) shells)).
    { intro s.
      rewrite <- (sum_opp Shell (fun s' => X s' s) shells).
      apply sum_ext_qeq. intros s' _. apply X_antisym. }
    (* Step 2: lift Step 1 across the outer sum. *)
    assert (Hstep1 :
      fold_right Qplus 0 (map (fun s => fold_right Qplus 0 (map (fun s' => X s s') shells)) shells)
      == fold_right Qplus 0 (map (fun s => - fold_right Qplus 0 (map (fun s' => X s' s) shells)) shells)).
    { apply sum_ext_qeq. intros s _. apply Hpointwise. }
    (* Step 3: pull the pointwise negation out of the outer sum. *)
    assert (Hstep2 :
      fold_right Qplus 0 (map (fun s => - fold_right Qplus 0 (map (fun s' => X s' s) shells)) shells)
      == - fold_right Qplus 0 (map (fun s => fold_right Qplus 0 (map (fun s' => X s' s) shells)) shells)).
    { apply (sum_opp Shell (fun s => fold_right Qplus 0 (map (fun s' => X s' s) shells)) shells). }
    (* Step 4: the remaining inner double sum is total_double_sum itself,
       by the finite double-sum exchange lemma applied to f a b := X b a. *)
    assert (Hstep3 :
      fold_right Qplus 0 (map (fun s => fold_right Qplus 0 (map (fun s' => X s' s) shells)) shells)
      == total_double_sum).
    { unfold total_double_sum.
      apply (double_sum_exchange Shell Shell (fun a b => X b a) shells shells). }
    (* Chain: total_double_sum == -(total_double_sum). *)
    assert (Hself : total_double_sum == - total_double_sum).
    { unfold total_double_sum at 1.
      rewrite Hstep1, Hstep2, Hstep3.
      reflexivity. }
    (* A value equal to its own negation in Q is 0. *)
    lra.
  Qed.

End AntisymDoubleSum.

(* ===================================================================== *)
(*  4. The headline claim: sum_s T_s = 0 for the shell-to-shell           *)
(*     transfer decomposition T_s := sum_s' X(s,s').                      *)
(* ===================================================================== *)

Section ShellTransferConservation.

  Variable Shell : Type.
  Variable X : Shell -> Shell -> Q.
  Variable shells : list Shell.
  Hypothesis X_antisym : forall s s' : Shell, X s s' == - X s' s.

  (* T_s := sum over all retained shells s' of the pairwise transfer
     coefficient X(s,s') -- the standard shell-to-shell decomposition of
     the finite nonlinear triad transfer into shell s. *)
  Definition Tshell (s : Shell) : Q :=
    fold_right Qplus 0 (map (fun s' => X s s') shells).

  Theorem shell_transfer_conserved :
    fold_right Qplus 0 (map Tshell shells) == 0.
  Proof.
    unfold Tshell.
    exact (antisym_double_sum_zero Shell X shells X_antisym).
  Qed.

End ShellTransferConservation.
