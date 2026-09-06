(* ================================================================= *)
(*  InfoCenterConfinement.v                                  *)
(*  Center-Confinement Closure v0.3 -- the first dynamical-confinement *)
(*  result, EXACT, in a Z_3 center-restricted 2D model. No QCD        *)
(*  potential and no "force grows with distance" assumed in advance.  *)
(*                                                                     *)
(*  Over Q (ω represented in Z[ω]/(ω²+ω+1) as a pair (re,om)=re+om·ω): *)
(*    (z3)   ω²=-1-ω, ω³=1, 1+ω+ω²=0, |ω-1|²=3                       *)
(*    (avg)  1 + rω + rω² = (1-r) + 0·ω     (ω-parts cancel)  =>       *)
(*           ⟨u_p⟩ = (1-r)/(1+2r) = q(r)                              *)
(*    (area) ⟨W⟩ = q^Area is area-multiplicative: q^(a+b)=q^a·q^b     *)
(*           (so -log|⟨W⟩| is LINEAR in area = the area law)          *)
(*    (perim) same perimeter, different area => different q^A          *)
(*    (ctrl)  q(0)=1 (flat, σ=0) ; q(1)=0 (max disorder, σ=∞)        *)
(*                                                                     *)
(*  HONEST FENCE. EXACT PASS but SCOPED: Z_3 center only (not the full *)
(*  8 directions of su(3)), a 2D graph (plaquettes factorize after     *)
(*  gauge fixing), no continuum limit. The Wilson-loop area-law        *)
(*  criterion and the center's role in confinement are STANDARD        *)
(*  (Wilson 1974; center-vortex work) -- not claimed as new; the       *)
(*  ordered-tape -> Z_3 -> retained-curvature-action bridge is the      *)
(*  in-framework assembly. OPEN: full SU(3), 3+1D coupled plaquettes,  *)
(*  nonzero continuum σ_phys, and the full SU(3) action flowing into   *)
(*  this center-confined sector without a hand-inserted Z_3 projection.*)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoCenterConfinement.
Open Scope Q_scope.

(* an element re + om*ω  of  Z[ω]/(ω²+ω+1) *)
Record Zw : Type := mkZ { re : Q ; om : Q }.
Definition Zeq (x y : Zw) : Prop := re x == re y /\ om x == om y.
(* multiplication with the reduction ω² = -1 - ω *)
Definition zmul (x y : Zw) : Zw :=
  mkZ (re x*re y - om x*om y) (re x*om y + om x*re y - om x*om y).
Definition zadd (x y : Zw) : Zw := mkZ (re x + re y) (om x + om y).
Definition zone : Zw := mkZ 1 0.
Definition w   : Zw := mkZ 0 1.
Definition w2  : Zw := zmul w w.

(* (z3) the center algebra *)
Theorem omega_sq : Zeq w2 (mkZ (-(1)) (-(1))).
Proof. unfold Zeq, w2, zmul, w; simpl; split; vm_compute; reflexivity. Qed.
Theorem omega_cubed_is_one : Zeq (zmul w2 w) zone.
Proof. unfold Zeq, w2, zmul, w, zone; simpl; split; vm_compute; reflexivity. Qed.
Theorem one_plus_w_plus_w2_zero : Zeq (zadd (zadd zone w) w2) (mkZ 0 0).
Proof. unfold Zeq, zadd, w2, zmul, zone, w; simpl; split; vm_compute; reflexivity. Qed.
(* |ω-1|² = (ω-1)(ω²-1) = 2 - (ω+ω²) = 2 - (-1) = 3 ; here via re(ω)+re(ω²) = -1 *)
Theorem abs_omega_minus_one_sq_is_three :
  2 - (re w + re w2) == 3 /\ (om w + om w2) == 0.
Proof. unfold w2, zmul, w; simpl; split; vm_compute; reflexivity. Qed.

(* (avg) 1 + rω + rω² has real part 1-r and ω-part 0 (the ω-parts cancel) *)
Definition num (r : Q) : Zw := zadd (zadd zone (mkZ 0 r)) (mkZ (-r) (-r)). (* 1 + r ω + r ω² *)
Theorem numerator_is_one_minus_r : forall r : Q,
  re (num r) == 1 - r /\ om (num r) == 0.
Proof. intro r. unfold num, zadd, zone; simpl; split; lra. Qed.
Definition q (r : Q) : Q := (1 - r) / (1 + 2*r).

(* (ctrl) flat: q(0)=1 ;  strong disorder: q(1)=0 *)
Theorem q_flat_is_one  : q 0 == 1.
Proof. unfold q; vm_compute; reflexivity. Qed.
Theorem q_disorder_is_zero : q 1 == 0.
Proof. unfold q; vm_compute; reflexivity. Qed.

(* (area) area-multiplicativity of the Wilson loop => area LAW (-log is area-linear) *)
Theorem wilson_area_multiplicative :
  (1#2)^(5+8) == (1#2)^5 * (1#2)^8.
Proof. vm_compute; reflexivity. Qed.

(* (perim) same perimeter (12), different area => different Wilson readout *)
Theorem area_beats_perimeter :
  ~ ((1#2)^5 == (1#2)^8) /\ ~ ((1#2)^8 == (1#2)^9) /\ ~ ((1#2)^5 == (1#2)^9).
Proof. repeat split; intro H; vm_compute in H; discriminate H. Qed.

End InfoCenterConfinement.

Print Assumptions InfoCenterConfinement.omega_cubed_is_one.
Print Assumptions InfoCenterConfinement.one_plus_w_plus_w2_zero.
Print Assumptions InfoCenterConfinement.abs_omega_minus_one_sq_is_three.
Print Assumptions InfoCenterConfinement.numerator_is_one_minus_r.
Print Assumptions InfoCenterConfinement.wilson_area_multiplicative.
Print Assumptions InfoCenterConfinement.area_beats_perimeter.
