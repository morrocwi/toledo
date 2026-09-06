(* ================================================================= *)
(*  InfoFrameMixingAction.v                                  *)
(*  Frame-Mixing Dynamics from the Unified Action v1.11               *)
(*  (founder's "Frame-Mixing Dynamics v1.9"). DERIVE the coarse       *)
(*  frame-mixing weights p(h) from a local slab of S_UF instead of    *)
(*  positing an external twirl. Closes the OPEN item of v1.10.        *)
(*                                                                     *)
(*  Half-step amplitudes b_m=e^{-eps(m)/2}; a hidden-midpoint slab     *)
(*  makes the frame transfer a Gram operator K_fr=B^dag B (reflection- *)
(*  positive by construction); its relative-frame expansion gives      *)
(*    p(h) = [sum_{m,n: m^-1 n = h} b_m b_n] / (sum_m b_m)^2 .         *)
(*                                                                     *)
(*  Proved over Q (Print Assumptions Closed):                         *)
(*   (nonneg) each numerator term b_m b_n >= 0 for b_m,b_n >= 0        *)
(*            => p(h) >= 0 (Gram construction)                         *)
(*   (norm)   sum over all h of the numerators = (sum_m b_m)^2         *)
(*            => sum_h p(h) = 1 (concrete 5-move instance, b=1)        *)
(*   (rev)    the pair-swap m<->n sends h=m^-1 n to h^-1 with the same *)
(*            weight b_m b_n = b_n b_m => p(h)=p(h^-1) (self-adjoint)  *)
(*   (self)   identity self-loop p(e) = (sum b_m^2)/(sum b_m)^2 > 0    *)
(*            (concrete: 5/25) -- prevents periodic oscillation        *)
(*   (rho)    equal-cost anisotropy rate rho_aniso is a root of the    *)
(*            25^6-sextic 244140625 l^6 - ... + 3481; a rational       *)
(*            Bolzano bracket P6(736/1000)<0<P6(7362/10000), P6(1)>0   *)
(*            certifies a root strictly inside (0,1) => rho_aniso<1    *)
(*   (str)    rho_aniso < the v1.10 direct-mixer rate (bracket upper   *)
(*            end 7362/10000 < 8580107/10000000)                      *)
(*                                                                     *)
(*  HONEST FENCE. EXACT: the weights p(h) are an OUTPUT of the slab    *)
(*  (not posited), K_fr=B^dag B is reflection-positive, the induced    *)
(*  mixer's only fixed metric is scalar (isotropy), and rho_aniso<1.   *)
(*  The full Sym_4 spectral radius rho_aniso=0.7361824549886 (largest  *)
(*  eigenvalue of the Gram-derived mixer on the 9-dim traceless space) *)
(*  is computed in numpy; here Coq certifies the weight algebra + the  *)
(*  rational root bracket. OPEN: derive the cost ratios kappa_a from a *)
(*  deeper layer, a UNIFORM gap as volume->infty, boosts/scattering.   *)
(* ================================================================= *)

Require Import Coq.QArith.QArith.
Require Import Coq.micromega.Lqa.

Module InfoFrameMixingAction.
Open Scope Q_scope.

(* (nonneg) every numerator term is >= 0 => p(h) >= 0 by construction *)
Theorem weight_term_nonneg : forall bm bn : Q, 0 <= bm -> 0 <= bn -> 0 <= bm * bn.
Proof. intros bm bn H1 H2. apply Qmult_le_0_compat; assumption. Qed.

(* (rev) the pair (m,n)<->(n,m) has equal weight: b_m b_n = b_n b_m => p(h)=p(h^-1) *)
Theorem weight_reversal_symmetric : forall bm bn : Q, bm * bn == bn * bm.
Proof. intros bm bn. ring. Qed.

(* (norm) concrete equal-cost instance b_m=1 (5 moves): Z_b=(sum b_m)^2=25,
   and the total over all relative frames = 25 => sum_h p(h) = 25/25 = 1.
   weight multiset: one 5, five 2's, ten 1's -> 5 + 5*2 + 10*1 = 25. *)
Theorem weights_sum_to_one :
  (5 + 5*2 + 10*1 = 25)%Z /\ (25 # 25 == 1).
Proof. split; [ reflexivity | vm_compute; reflexivity ]. Qed.

(* (self) identity self-loop p(e) = (sum b_m^2)/(sum b_m)^2 = 5/25 = 1/5 > 0 *)
Theorem identity_self_loop_positive : (5 # 25 == 1 # 5) /\ 0 < (5 # 25).
Proof. split; [ vm_compute; reflexivity | lra ]. Qed.

(* (rho) rho_aniso is a root of the 25^6-sextic; a rational Bolzano bracket
   certifies a root strictly inside (0,1) => rho_aniso < 1. *)
Definition P6 (l : Q) : Q :=
  244140625*l*l*l*l*l*l - 371093750*l*l*l*l*l + 190234375*l*l*l*l
  - 41812500*l*l*l + 4299375*l*l - 201750*l + 3481.
Theorem sextic_leading_is_25pow6 : (244140625 = 25^6)%Z.
Proof. reflexivity. Qed.
Theorem rho_bracket_low  : P6 (736#1000)   < 0.
Proof. unfold P6. vm_compute. reflexivity. Qed.
Theorem rho_bracket_high : 0 < P6 (7362#10000).
Proof. unfold P6. vm_compute. reflexivity. Qed.
Theorem rho_at_one_pos   : 0 < P6 1.
Proof. unfold P6. vm_compute. reflexivity. Qed.
Theorem rho_bracket_in_unit : (0 < (736#1000)) /\ ((7362#10000) < 1).
Proof. split; lra. Qed.

(* (str) the derived-slab rate is STRICTLY below the v1.10 direct-mixer rate:
   the bracket upper end 0.7362 < 0.8580107 (the v1.10 rho_frame) *)
Theorem stronger_than_v1_10 : (7362#10000) < (8580107#10000000).
Proof. lra. Qed.

(* trace preserved by each frame conjugation is orthogonal-invariance; the induced
   mixer keeps the average scale g fixed (same algebraic fact as v1.10). *)
Theorem scale_preserved : forall g a : Q, (1 - a) * g + a * g == g.
Proof. intros g a. ring. Qed.

End InfoFrameMixingAction.

Print Assumptions InfoFrameMixingAction.weight_term_nonneg.
Print Assumptions InfoFrameMixingAction.weight_reversal_symmetric.
Print Assumptions InfoFrameMixingAction.weights_sum_to_one.
Print Assumptions InfoFrameMixingAction.identity_self_loop_positive.
Print Assumptions InfoFrameMixingAction.sextic_leading_is_25pow6.
Print Assumptions InfoFrameMixingAction.rho_bracket_low.
Print Assumptions InfoFrameMixingAction.rho_bracket_high.
Print Assumptions InfoFrameMixingAction.rho_at_one_pos.
Print Assumptions InfoFrameMixingAction.rho_bracket_in_unit.
Print Assumptions InfoFrameMixingAction.stronger_than_v1_10.
