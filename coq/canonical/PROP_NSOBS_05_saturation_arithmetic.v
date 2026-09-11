(* ===================================================================== *)
(*  PROP_NSOBS_05_saturation_arithmetic.v                                 *)
(*  Exact finite saturation records for energy readers (Toledo proposal   *)
(*  PROP-NSOBS-05, family NSOBS, code weld/P.??.v1).                      *)
(*                                                                        *)
(*  Source: github.com/morrocwi/readout-problem-navier-stokes            *)
(*  paper/NS_ENERGY_OBSERVABILITY_ALL_K_FINAL.tex (not present in this    *)
(*  local checkout -- this file mechanizes only what the registry's own   *)
(*  survey ("how_to_check") already spells out precisely enough to        *)
(*  reconstruct independently: the finite arithmetic layer).              *)
(*                                                                        *)
(*  SCOPE, STATED HONESTLY:                                               *)
(*  The registered claim is a pair of things bundled into one statement:  *)
(*    (a) an ARITHMETIC layer -- four exact numeric identities relating   *)
(*        d_N (a pure formula), m_N (a finite exhaustive count over a     *)
(*        cube of side 2N+1), a derived minimum-depth quantity (either    *)
(*        R_E^min = d_N-4, or R_I^min = a ceiling-division formula), and  *)
(*        a "ceiling" quantity (min of a linear expression and d_N-3);    *)
(*    (b) a RANK-ATTAINMENT layer -- the claim that the *actual* rank of  *)
(*        a concrete Lie-jet Jacobian of the finite Fourier-Galerkin NS   *)
(*        ODE system equals that arithmetic ceiling (i.e. the ceiling is  *)
(*        attained, not just an upper bound).                             *)
(*                                                                        *)
(*  THIS FILE MECHANIZES ONLY LAYER (a). Layer (b) needs the explicit     *)
(*  quadratic Fourier-Galerkin NS coefficients on the real, divergence-   *)
(*  free/reality-constrained coordinate basis of dimension d_N, evaluated *)
(*  at a witness state, with an exact-rational rank computation of a      *)
(*  Jacobian up to 40x681 in size (N=3). None of that construction is     *)
(*  present in this repo, nor in the cited .tex locally, and reproducing  *)
(*  it correctly (in particular the reality/divergence-free basis) is a   *)
(*  nontrivial derivation in its own right -- see honest_caveats in the   *)
(*  registry entry this file's compile updates. It is NOT attempted here. *)
(*                                                                        *)
(*  What "mechanized" means for layer (a) here: d_N is proved equal to    *)
(*  its closed form by direct computation; m_N is not merely asserted --  *)
(*  it is COMPUTED inside Coq by literal enumeration of the (2N+1)^3      *)
(*  integer cube {-N,...,N}^3, filtering the nonzero values of            *)
(*  k_x^2+k_y^2+k_z^2, and counting the distinct values that occur (a     *)
(*  decidable finite check, run via vm_compute -- exactly the             *)
(*  List-based finite-set count the registry's own how_to_check calls     *)
(*  for). The two derived quantities (minimum depth, ceiling) are then    *)
(*  computed from d_N and m_N by the same formulas the registry states,   *)
(*  and the four (N, reader, R, rank) records are checked by exact        *)
(*  integer computation, not re-typed by hand.                            *)
(*                                                                        *)
(*  Integer-native (Z), no Coq.Reals, no Coq.QArith needed either -- all  *)
(*  quantities here are counts/dimensions, so Z.of_nat/Z suffices and     *)
(*  pulls in no classical axiom (matching the Q-over-R lesson already on  *)
(*  file in this repo: PROP_NS_TAPE_CLOSED_DOMAIN_01.v).                  *)
(*                                                                        *)
(*  Expected: Print Assumptions nsobs05_four_certified_cases              *)
(*    => Closed under the global context (axiom-free).                   *)
(* ===================================================================== *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Import ListNotations.
Local Open Scope Z_scope.

(* ----------------------------------------------------------------- *)
(*  1. d_N : the total real coordinate dimension after the reality/    *)
(*     divergence-free reduction, a pure counting formula.             *)
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

(* The integer range {-N, -N+1, ..., N}, as a list of Z. *)
Definition zrange (N : Z) : list Z :=
  map (fun n : nat => Z.of_nat n - N) (seq 0 (Z.to_nat (2 * N + 1))).

(* The full integer cube {-N,...,N}^3, as a list of triples. *)
Definition cube (N : Z) : list (Z * Z * Z) :=
  flat_map (fun x => flat_map (fun y => map (fun z => (x, y, z)) (zrange N))
                               (zrange N))
           (zrange N).

Definition normsq (t : Z * Z * Z) : Z :=
  let '(x, y, z) := t in x * x + y * y + z * z.

(* Remove duplicates from a list of Z, keeping one representative of    *)
(* each value -- a plain decidable finite-set count, using Z.eqb.       *)
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
(*  3. The derived minimum-depth and ceiling quantities, exactly as    *)
(*     the registry states them.                                       *)
(*        R_E^min(N)      := d_N - 4                                    *)
(*        scalar_ceiling   := min(R+1, d_N-3)                           *)
(*        R_I^min(N)      := ceil( (d_N - 3 - m_N) / (m_N - 1) )        *)
(*        shell_ceiling    := min(m_N + (m_N-1)*R, d_N-3)               *)
(*     Ceiling division on positive integers: ceil(a/b) = (a+b-1)/b.    *)
(* ----------------------------------------------------------------- *)

Definition ceildiv (a b : Z) : Z := (a + b - 1) / b.

Definition R_E_min (N : Z) : Z := dN N - 4.

Definition scalar_ceiling (N R : Z) : Z := Z.min (R + 1) (dN N - 3).

Definition R_I_min (N : Z) : Z := ceildiv (dN N - 3 - mN N) (mN N - 1).

Definition shell_ceiling (N R : Z) : Z :=
  Z.min (mN N + (mN N - 1) * R) (dN N - 3).

(* ----------------------------------------------------------------- *)
(*  4. The four registered (N, reader, R, rank) records, as exact       *)
(*     integer facts: for each record, the claimed R equals the         *)
(*     structural minimum-depth quantity for that reader, and the       *)
(*     claimed rank equals the corresponding ceiling evaluated at that   *)
(*     R. This is the arithmetic layer of PROP-NSOBS-05 -- NOT a claim   *)
(*     that the concrete Jacobian rank attains this ceiling (see the     *)
(*     file header).                                                     *)
(* ----------------------------------------------------------------- *)

Theorem nsobs05_case_1E : R_E_min 1 = 48 /\ scalar_ceiling 1 48 = 49.
Proof. split; vm_compute; reflexivity. Qed.

Theorem nsobs05_case_1I : R_I_min 1 = 23 /\ shell_ceiling 1 23 = 49.
Proof. split; vm_compute; reflexivity. Qed.

Theorem nsobs05_case_2E : R_E_min 2 = 244 /\ scalar_ceiling 2 244 = 245.
Proof. split; vm_compute; reflexivity. Qed.

Theorem nsobs05_case_3I : R_I_min 3 = 39 /\ shell_ceiling 3 39 = 681.
Proof. split; vm_compute; reflexivity. Qed.

(* Combined statement, in the shape the registry records it: the four   *)
(* (N, reader, R, rank) tuples are each exactly consistent with the      *)
(* formula layer (d_N, m_N, minimum depth, ceiling) -- arithmetic only.  *)
Theorem nsobs05_four_certified_cases :
  (R_E_min 1 = 48 /\ scalar_ceiling 1 48 = 49) /\
  (R_I_min 1 = 23 /\ shell_ceiling 1 23 = 49) /\
  (R_E_min 2 = 244 /\ scalar_ceiling 2 244 = 245) /\
  (R_I_min 3 = 39 /\ shell_ceiling 3 39 = 681).
Proof.
  repeat split; vm_compute; reflexivity.
Qed.
