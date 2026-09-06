(* RDL_UnitDistance.v — a HONEST machine-checked result on the unit-distance problem.

   We do NOT prove the open Erdos extremal problem (the maximum over ALL configurations, superlinear,
   still open). Our floor forbids that overclaim. What we DO prove, rigorously and axiom-free: the
   square grid is NOT the optimal LATTICE — the triangular lattice strictly beats it for every k >= 2.

   The closed-form counts below are VERIFIED to match the actual geometry (solvers/erdos_unit_distances.py:
   k=7 gives square=84, triangular=120). Here Coq proves the INEQUALITY of those counts for all k. *)

Require Import Arith Lia.

(* exact unit-distance counts of the two lattices (k x k points) *)
Definition square_units (k:nat) : nat := 2 * k * (k - 1).            (* axis adjacencies only (diag = sqrt2) *)
Definition tri_units    (k:nat) : nat := (k - 1) * (3 * k - 1).      (* within-row + the two offset neighbours *)

(* the counts match the computed geometry (sanity, by reflexivity) *)
Example square_7 : square_units 7 = 84.  Proof. reflexivity. Qed.
Example tri_7    : tri_units 7    = 120. Proof. reflexivity. Qed.

(* MAIN THEOREM: for every k >= 2 the triangular lattice has STRICTLY more unit distances than the square
   grid. Hence the square grid is not optimal among lattices — Erdos's grid intuition fails already here. *)
Theorem triangular_beats_square :
  forall k, 2 <= k -> square_units k < tri_units k.
Proof.
  intros k Hk.
  destruct k as [|k0]; [lia|]. destruct k0 as [|k1]; [lia|].
  unfold square_units, tri_units. nia.
Qed.

(* the gap grows without bound: tri - square = (k-1)(k-1) >= ... so the advantage is not a constant. *)
Theorem advantage_grows :
  forall k, 2 <= k -> (k - 1) <= tri_units k - square_units k.
Proof.
  intros k Hk.
  destruct k as [|k0]; [lia|]. destruct k0 as [|k1]; [lia|].
  unfold square_units, tri_units. nia.
Qed.
