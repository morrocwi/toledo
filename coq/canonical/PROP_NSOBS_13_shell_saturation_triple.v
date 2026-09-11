(* ===================================================================== *)
(*  PROP_NSOBS_13_shell_saturation_triple.v                              *)
(*  Three consecutive finite shell-saturation witnesses (Toledo           *)
(*  proposal PROP-NSOBS-13, family NSOBS, code weld/P.??.v1).             *)
(*                                                                        *)
(*  Registered statement:                                                 *)
(*    (N, R_I^min, d_N-3) = (1,23,49), (2,30,245), (3,39,681)             *)
(*    -- all three attain the shell-reader structural ceiling.            *)
(*                                                                        *)
(*  Source: github.com/morrocwi/readout-problem-navier-stokes             *)
(*  paper/NS_ENERGY_OBSERVABILITY_ALL_K_FINAL.tex (not present in this     *)
(*  local checkout). The registry itself records PROP-NSOBS-13 as a       *)
(*  pure CONJUNCTION of PROP-NSOBS-05 s N=1 and N=3 shell-reader cases    *)
(*  and PROP-NSOBS-12 s N=2 case -- no new computation is needed beyond   *)
(*  what those two entries already require.                               *)
(*                                                                        *)
(*  SCOPE, STATED HONESTLY (same two-layer split as PROP-NSOBS-05/-12):   *)
(*    (a) an ARITHMETIC layer -- d_N (a pure formula), m_N (a finite       *)
(*        exhaustive count of distinct nonzero |k|^2 shells over the       *)
(*        cube {-N,...,N}^3), and R_I^min = ceil((d_N-3-m_N)/(m_N-1)),     *)
(*        a ceiling-division formula -- all closed-form/finite and        *)
(*        checkable by direct computation, independent of any Jacobian.   *)
(*    (b) a RANK-ATTAINMENT layer -- the claim that the *actual* rank of   *)
(*        the concrete finite Fourier-Galerkin NS shell-energy Jacobian    *)
(*        attains that arithmetic ceiling at each of N=1,2,3. That needs   *)
(*        the explicit quadratic NS coefficients on the real, divergence-  *)
(*        free/reality-constrained basis and an exact-rational rank        *)
(*        computation up to a 40x681 Jacobian (N=3) -- none of that        *)
(*        construction is present in this repo or in the cited .tex        *)
(*        locally, and it is NOT attempted here (same honest gap already   *)
(*        on file for PROP-NSOBS-05 and PROP-NSOBS-12).                    *)
(*                                                                        *)
(*  THIS FILE MECHANIZES ONLY LAYER (a), for all three of N=1,2,3 in one   *)
(*  packaged conjunction theorem -- exactly the no-new-computation         *)
(*  claim the registry makes for PROP-NSOBS-13: it is deliberately self-   *)
(*  contained (re-deriving d_N and m_N by the same finite enumeration      *)
(*  method, rather than importing another in-flight, not-yet-committed     *)
(*  file) so this proposal s closure does not depend on the fate of a      *)
(*  sibling proof still being iterated on elsewhere in this task family.   *)
(*                                                                        *)
(*  Integer-native (Z), no Coq.Reals, no Coq.QArith needed -- all          *)
(*  quantities are counts/dimensions (matching the Q-over-R lesson         *)
(*  already on file in this repo: PROP_NS_TAPE_CLOSED_DOMAIN_01.v, and     *)
(*  the Z-native precedent PROP_NSOBS_05_saturation_arithmetic.v).         *)
(*                                                                        *)
(*  TIER NOTE: the registry carries two duplicate entries for this id      *)
(*  with conflicting tiers (finite_diagnostic in                          *)
(*  ns_energy_observability_extensions.json vs Dr in                      *)
(*  ns_energy_observability_n2_shell.json). This file s compile settles    *)
(*  that in favour of finite_diagnostic: what is mechanized here is a      *)
(*  script/numerically-verified conjunction of finite closed-form cases,   *)
(*  not a hand-derivation (Dr) of new mathematics.                        *)
(*                                                                        *)
(*  Expected: Print Assumptions nsobs13_shell_saturation_triple            *)
(*    => Closed under the global context (axiom-free).                   *)
(* ===================================================================== *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Import ListNotations.
Local Open Scope Z_scope.

(* ----------------------------------------------------------------- *)
(*  1. d_N : the total real coordinate dimension after the reality/    *)
(*     divergence-free reduction (PROP-NSOBS-01, tier Definition):     *)
(*     d_N = 2*((2N+1)^3 - 1).                                         *)
(* ----------------------------------------------------------------- *)

Definition dN (N : Z) : Z := 2 * ((2 * N + 1) ^ 3 - 1).

Lemma dN_1 : dN 1 = 52.  Proof. vm_compute. reflexivity. Qed.
Lemma dN_2 : dN 2 = 248. Proof. vm_compute. reflexivity. Qed.
Lemma dN_3 : dN 3 = 684. Proof. vm_compute. reflexivity. Qed.

(* ----------------------------------------------------------------- *)
(*  2. m_N : the number of distinct nonzero values of                  *)
(*     k_x^2 + k_y^2 + k_z^2 over the finite cube {-N,...,N}^3.        *)
(*     Computed by literal enumeration, not asserted.                  *)
(* ----------------------------------------------------------------- *)

Definition zrange (N : Z) : list Z :=
  map (fun n : nat => Z.of_nat n - N) (seq 0 (Z.to_nat (2 * N + 1))).

Definition cube (N : Z) : list (Z * Z * Z) :=
  flat_map (fun x => flat_map (fun y => map (fun z => (x, y, z)) (zrange N))
                               (zrange N))
           (zrange N).

Definition normsq (t : Z * Z * Z) : Z :=
  let '(x, y, z) := t in x * x + y * y + z * z.

Fixpoint dedup (l : list Z) : list Z :=
  match l with
  | [] => []
  | x :: xs => if existsb (Z.eqb x) xs then dedup xs else x :: dedup xs
  end.

Definition mN (N : Z) : Z :=
  Z.of_nat (length (dedup (filter (fun v => negb (Z.eqb v 0))
                                   (map normsq (cube N))))).

Lemma mN_1 : mN 1 = 3.  Proof. vm_compute. reflexivity. Qed.
Lemma mN_2 : mN 2 = 9.  Proof. vm_compute. reflexivity. Qed.
Lemma mN_3 : mN 3 = 18. Proof. vm_compute. reflexivity. Qed.

(* ----------------------------------------------------------------- *)
(*  3. R_I^min(N) := ceil( (d_N - 3 - m_N) / (m_N - 1) ), exactly as    *)
(*     the registry states it. Ceiling division on positive integers:  *)
(*     ceil(a/b) = (a+b-1)/b.                                           *)
(* ----------------------------------------------------------------- *)

Definition ceildiv (a b : Z) : Z := (a + b - 1) / b.

Definition R_I_min (N : Z) : Z := ceildiv (dN N - 3 - mN N) (mN N - 1).

Lemma R_I_min_1 : R_I_min 1 = 23. Proof. vm_compute. reflexivity. Qed.
Lemma R_I_min_2 : R_I_min 2 = 30. Proof. vm_compute. reflexivity. Qed.
Lemma R_I_min_3 : R_I_min 3 = 39. Proof. vm_compute. reflexivity. Qed.

(* ----------------------------------------------------------------- *)
(*  4. The registered triple, packaged as one conjunction theorem:     *)
(*     for each of N=1,2,3, R_I^min(N) and d_N-3 exactly equal the      *)
(*     recorded (R_I^min, rank) pair -- the arithmetic layer of the     *)
(*     PROP-NSOBS-13 conjunction, over PROP-NSOBS-05 s N=1/N=3 shell    *)
(*     cases and PROP-NSOBS-12 s N=2 case. NOT a claim that the actual   *)
(*     Jacobian rank attains this ceiling (see file header, layer (b)).  *)
(* ----------------------------------------------------------------- *)

Theorem nsobs13_shell_saturation_triple :
  (R_I_min 1 = 23 /\ dN 1 - 3 = 49) /\
  (R_I_min 2 = 30 /\ dN 2 - 3 = 245) /\
  (R_I_min 3 = 39 /\ dN 3 - 3 = 681).
Proof.
  repeat split; vm_compute; reflexivity.
Qed.
