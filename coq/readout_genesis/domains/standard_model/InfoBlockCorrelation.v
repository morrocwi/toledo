(* ================================================================= *)
(*  InfoBlockCorrelation.v                                   *)
(*  Full 4D Block Closure v0.7 -- the b=2 block: exact structure of   *)
(*  the FIRST correlated shell (single cube-bumps). NOT the full      *)
(*  all-representation tensor contraction (Delta_multi, Delta_rep     *)
(*  remain open -- this is a first-shell DIAGNOSTIC).                 *)
(*                                                                     *)
(*  Proved over nat / Q (Print Assumptions Closed):                   *)
(*    (geom)   D=4 first shell: 2(D-2)=4 bump dirs/plaquette,          *)
(*             A_min=4 => 16 single-bumps; a bump takes area 4 -> 8    *)
(*    (rho)    rho_{1,geom}(u) = u^4(1+16u^4) = u^4 + 16u^8            *)
(*    (help)   0<u => u^4 < u^4(1+16u^4)  (correlations INCREASE       *)
(*             triality survival: alternative surfaces, not fewer)     *)
(*    (planar) D=2 control: 2(D-2)=0 => no bumps => rho = u^4 exactly  *)
(*    (cert)   a rational first-shell certificate: with mu_4 < 55,     *)
(*             55 * u^4(1+16u^4) < 1 at u=1/10 (certifies)             *)
(*                                                                     *)
(*  HONEST FENCE. First correlated shell only. The correction is       *)
(*  16u^8 = O(u^4) relative to the u^4 primitive, so in strong         *)
(*  disorder (small u) the primitive contraction still dominates and   *)
(*  the first shell does NOT close the gap by itself. STILL OPEN:      *)
(*  Delta_multi (many bumps), Delta_rep (representation branching      *)
(*  3<->6bar<->15 within the block), a representation-tail bound, and  *)
(*  the full numerical tensor contraction. A plain Metropolis          *)
(*  estimator FAILED (signal ~ noise) -- no MC value is asserted.      *)
(*  Character/tensor-network blocking is standard non-Abelian lattice  *)
(*  method; the retained-triality reading is ours.                     *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.
Require Import Coq.Arith.Arith.

Module InfoBlockCorrelation.

(* (geom) first-shell bump counting in D=4 *)
Theorem transverse_axes  : (4 - 2)%nat = 2%nat.               Proof. reflexivity. Qed.
Theorem bump_dirs_per_plaq : (2 * (4 - 2))%nat = 4%nat.       Proof. reflexivity. Qed.
Theorem single_bump_count  : (4 * (2 * (4 - 2)))%nat = 16%nat. Proof. reflexivity. Qed.
Theorem bump_area          : (4 + (5 - 1))%nat = 8%nat.       Proof. reflexivity. Qed.
Theorem planar_control_D2  : (2 * (2 - 2))%nat = 0%nat.       Proof. reflexivity. Qed.

Open Scope Q_scope.

Definition p4 (u : Q) : Q := u*u*u*u.
Definition p8 (u : Q) : Q := (u*u*u*u)*(u*u*u*u).
Definition rho_geom (u : Q) : Q := p4 u * (1 + 16 * p4 u).

(* (rho) the first-shell retention factors as u^4 + 16 u^8 *)
Theorem rho_geom_expand : forall u : Q, rho_geom u == p4 u + 16 * p8 u.
Proof. intro u. unfold rho_geom, p4, p8. ring. Qed.

(* (help) correlations INCREASE survival: rho_geom > u^4 for u>0 *)
Theorem correlations_increase_survival : forall u : Q,
  0 < u -> p4 u < rho_geom u.
Proof.
  intros u H. unfold rho_geom, p4.
  set (A := u*u*u*u).
  assert (HA : 0 < A) by (unfold A; repeat apply Qmult_lt_0_compat; exact H).
  assert (Heq : A * (1 + 16 * A) == A + 16 * (A * A)) by ring.
  rewrite Heq.
  assert (Hpos : 0 < 16 * (A * A)) by nra.
  lra.
Qed.

(* (planar) D=2: with 0 bump directions the retention is exactly the planar u^4 *)
Definition rho_geom_gen (nbumps : nat) (u : Q) : Q :=
  p4 u * (1 + (inject_Z (Z.of_nat nbumps)) * p4 u).
Theorem planar_recovers_serial : forall u : Q, rho_geom_gen 0 u == p4 u.
Proof. intro u. unfold rho_geom_gen, p4. ring. Qed.

(* (cert) a rational first-shell certificate at u=1/10 with mu_4 < 55 *)
Theorem first_shell_cert_witness :
  55 * rho_geom (1#10) < 1.
Proof.
  assert (E : rho_geom (1#10) == (10016 # 100000000)) by (vm_compute; reflexivity).
  rewrite E. lra.
Qed.

End InfoBlockCorrelation.

Print Assumptions InfoBlockCorrelation.single_bump_count.
Print Assumptions InfoBlockCorrelation.rho_geom_expand.
Print Assumptions InfoBlockCorrelation.correlations_increase_survival.
Print Assumptions InfoBlockCorrelation.planar_recovers_serial.
Print Assumptions InfoBlockCorrelation.first_shell_cert_witness.
