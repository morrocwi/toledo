(* ===================================================================== *)
(*  PROP_NSOBS_12_n2_shell_arithmetic.v                                   *)
(*                                                                         *)
(*  Toledo registry object: PROP-NSOBS-12 (family NSOBS, Exact N=2       *)
(*  shell-energy earliest-order saturation), registered from             *)
(*  registry/proposals/ns_energy_observability_n2_shell.json and          *)
(*  ns_energy_observability_extensions.json.                              *)
(*                                                                         *)
(*  Full registered statement (tier finite_diagnostic):                   *)
(*    d_2 = 248,  m_2 = 9  (shells {1,2,3,4,5,6,8,9,12}),                 *)
(*    rank D J_{2,30} = 245 = d_2 - 3,   rank D J_{2,29} = 241 < 245.      *)
(*                                                                         *)
(*  WHAT THIS FILE MECHANIZES (the arithmetic layer only):              *)
(*    1. d_2 = 2*((2*2+1)^3 - 1) = 248, the N=2 instance of the finite     *)
(*       Fourier-Galerkin dimension formula (Toledo PROP-NSOBS-01,        *)
(*       tier Definition, d_N = 2((2N+1)^3-1)).                           *)
(*    2. m_2 = 9: a finite, fully decidable enumeration of every sum of   *)
(*       three squares k1^2+k2^2+k3^2 with k1,k2,k3 in {-2,-1,0,1,2}      *)
(*       (the N=2 cubic Fourier-mode index cube), showing the set of      *)
(*       distinct NONZERO values is exactly {1,2,3,4,5,6,8,9,12}.         *)
(*    3. The shell-rank ceiling formula from Toledo PROP-NSOBS-03,        *)
(*       rank D J_R <= min(m_N + (m_N-1)*R, d_N-3) and                    *)
(*       R_min = ceil((d_N-3-m_N)/(m_N-1)), instantiated at N=2, gives     *)
(*       exactly R_min = 30, ceiling(29) = 241, ceiling(30) = 245 --       *)
(*       i.e. the four numbers in the PROP-NSOBS-12 statement are          *)
(*       arithmetically consistent with the *formulas* already registered *)
(*       (PROP-NSOBS-01, PROP-NSOBS-03), for this one instance N=2.        *)
(*                                                                         *)
(*  WHAT THIS FILE DOES NOT MECHANIZE (left open, honest_caveats in the   *)
(*  registry JSON): that rank D J_{2,30} and rank D J_{2,29} -- the        *)
(*  ACTUAL rank of the concrete 245-by-(9*31)-ish Jacobian of the real     *)
(*  N=2 incompressible Fourier-Galerkin quadratic vector field shell-   *)
(*  energy observation jet -- equal 245 and 241 respectively. That is a   *)
(*  genuine linear-algebra computation over the concrete N=2 Navier-      *)
(*  Stokes ODE system (250-ish coordinates, nu=1/200, per the registry  *)
(*  origin note) which was reportedly run once in                        *)
(*  reproduction/checks/check_k2_shell_energy_observability.py via GitHub *)
(*  Actions run 34505502747 (2026-09-10) -- but that script does NOT      *)
(*  exist in this repo local clone of                                    *)
(*  github.com/morrocwi/readout-problem-navier-stokes as of 2026-09-11,   *)
(*  and no NS_ENERGY_OBSERVABILITY_ALL_K_FINAL.tex construction was       *)
(*  found locally either (checked: ~/ANSE.ASIA/readout-problem-navier-    *)
(*  stokes/{paper,reproduction/checks,registry,scripts,verification}/).   *)
(*  Reconstructing the explicit N=2 quadratic system, its Jacobian, and   *)
(*  a verified rank computation (e.g. Gaussian elimination over Q with a  *)
(*  certified pivot sequence) is real remaining work this file does NOT   *)
(*  attempt -- doing so here would be forcing an unjustified claim.       *)
(*  This file closes exactly, and only, the arithmetic layer -- the part  *)
(*  the registry how_to_check field calls verified, safe to Coq-close     *)
(*  now -- and leaves the rank layer explicitly open.                     *)
(*                                                                         *)
(*  Q/Z-native throughout (no Coq.Reals): every quantity here is an       *)
(*  integer count or an integer dimension, so plain Z arithmetic and      *)
(*  vm_compute-decidable finite enumeration suffice; nothing here needs   *)
(*  real numbers, so no Coq.Reals import and no risk of an unintended     *)
(*  classical axiom (cf. the Q-over-R lesson in                          *)
(*  PROP_NS_TAPE_CLOSED_DOMAIN_01.v).                                     *)
(*                                                                         *)
(*  Expected: Print Assumptions => Closed under the global context.       *)
(* ===================================================================== *)

Require Import Coq.ZArith.ZArith.
Require Import Coq.Lists.List.
Import ListNotations.
Local Open Scope Z_scope.

(* ----------------------------------------------------------------- *)
(*  1. d_2 : N=2 instance of the PROP-NSOBS-01 dimension formula      *)
(*     d_N = 2*((2N+1)^3 - 1).                                        *)
(* ----------------------------------------------------------------- *)

Definition N_cutoff : Z := 2.

Definition d_N (N : Z) : Z := 2 * ((2 * N + 1) ^ 3 - 1).

Definition d_2 : Z := d_N N_cutoff.

Lemma d_2_value : d_2 = 248.
Proof. vm_compute. reflexivity. Qed.

(* ----------------------------------------------------------------- *)
(*  2. m_2 : finite, decidable enumeration of the distinct nonzero    *)
(*     values of k1^2+k2^2+k3^2 over the N=2 index cube {-2..2}^3.    *)
(* ----------------------------------------------------------------- *)

Definition k_range : list Z := [-2; -1; 0; 1; 2].

Definition triples : list (Z * Z * Z) :=
  flat_map (fun k1 =>
    flat_map (fun k2 =>
      map (fun k3 => (k1, k2, k3)) k_range)
      k_range)
    k_range.

Definition sumsq (t : Z * Z * Z) : Z :=
  let '(k1, k2, k3) := t in k1 * k1 + k2 * k2 + k3 * k3.

Definition nonzero_sums : list Z :=
  filter (fun s => negb (Z.eqb s 0)) (map sumsq triples).

Definition distinct_sums : list Z := nodup Z.eq_dec nonzero_sums.

Definition canonical_shells : list Z := [1; 2; 3; 4; 5; 6; 8; 9; 12].

Definition set_eqb (l1 l2 : list Z) : bool :=
  forallb (fun x => existsb (Z.eqb x) l2) l1 &&
  forallb (fun x => existsb (Z.eqb x) l1) l2.

(* Every distinct nonzero sum-of-three-squares value reachable from the
   N=2 index cube is exactly the claimed 9-element shell set, both
   directions (soundness + completeness of the enumeration), decided by
   direct computation over the 125 concrete triples. *)
Lemma distinct_sums_is_canonical : set_eqb distinct_sums canonical_shells = true.
Proof. vm_compute. reflexivity. Qed.

Lemma distinct_sums_nodup : NoDup distinct_sums.
Proof. apply NoDup_nodup. Qed.

Definition m_2 : Z := Z.of_nat (length distinct_sums).

Lemma m_2_value : m_2 = 9.
Proof. vm_compute. reflexivity. Qed.

(* ----------------------------------------------------------------- *)
(*  3. Shell-rank ceiling formula (PROP-NSOBS-03) instantiated at     *)
(*     N=2: rank <= min(m_2 + (m_2-1)*R, d_2-3),                      *)
(*     R_min = ceil((d_2-3-m_2)/(m_2-1)).                             *)
(* ----------------------------------------------------------------- *)

(* Integer ceiling division for positive divisor b: ceil(a/b) = (a+b-1)/b. *)
Definition ceil_div (a b : Z) : Z := (a + b - 1) / b.

Definition rank_ceiling (m d R : Z) : Z := Z.min (m + (m - 1) * R) (d - 3).

Definition R_min : Z := ceil_div (d_2 - 3 - m_2) (m_2 - 1).

Lemma R_min_value : R_min = 30.
Proof. vm_compute. reflexivity. Qed.

Lemma rank_ceiling_at_29 : rank_ceiling m_2 d_2 29 = 241.
Proof. vm_compute. reflexivity. Qed.

Lemma rank_ceiling_at_30 : rank_ceiling m_2 d_2 30 = 245.
Proof. vm_compute. reflexivity. Qed.

(* ----------------------------------------------------------------- *)
(*  Main theorem: the four numbers stated in PROP-NSOBS-12 are        *)
(*  exactly what the already-registered PROP-NSOBS-01/PROP-NSOBS-03   *)
(*  formulas produce at N=2 -- the arithmetic layer only. This does    *)
(*  NOT assert that the concrete Jacobian rank of the real N=2         *)
(*  Navier-Stokes shell-energy jet attains this ceiling; it asserts    *)
(*  only that the ceiling numbers themselves are self-consistent.      *)
(* ----------------------------------------------------------------- *)

Theorem PROP_NSOBS_12_arithmetic_layer :
  d_2 = 248 /\
  m_2 = 9 /\
  set_eqb distinct_sums canonical_shells = true /\
  NoDup distinct_sums /\
  R_min = 30 /\
  rank_ceiling m_2 d_2 29 = 241 /\
  rank_ceiling m_2 d_2 30 = 245.
Proof.
  split; [exact d_2_value |].
  split; [exact m_2_value |].
  split; [exact distinct_sums_is_canonical |].
  split; [exact distinct_sums_nodup |].
  split; [exact R_min_value |].
  split; [exact rank_ceiling_at_29 | exact rank_ceiling_at_30].
Qed.
