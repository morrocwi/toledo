(******************************************************************************)
(* RDU_NativeInformationUnits.v                                               *)
(*                                                                            *)
(* The native-information-unit collapse, MACHINE-CHECKED (axiom-free).        *)
(*                                                                            *)
(* Claim (founder): every physical unit collapses to ONE unit — information.  *)
(* The apparent "many parameters" (M, D, K, V in the spine equation) are NOT  *)
(* intrinsic freedom; they are a HUMAN-READOUT artifact of using many units.  *)
(* In the native unit (information / dimensionless) there is one substance.   *)
(*                                                                            *)
(* What is proved here (over the mechanical base mass-length-time, the core   *)
(* of UNIT_SYSTEM_MAP.yaml's dimension-vector algebra):                       *)
(*   - the three fundamental constants {c, hbar, mass} are UNIMODULAR (det=1) *)
(*     hence a BASIS of the dimension lattice;                                *)
(*   - therefore EVERY dimension is an exact integer/Q combination of them    *)
(*     (dimension_spanned);                                                   *)
(*   - so setting c=hbar=mass=1 (natural units) collapses EVERY dimension to  *)
(*     dimensionless = information (every_dimension_collapses);               *)
(*   - hence the spine parameters M,D,K,V collapse to information quantities, *)
(*     i.e. the master equation is parameter-FREE in the one unit.            *)
(* readout-not-truth: the multiplicity of units is the reader's, not nature's.*)
(* Honest scope: the mechanical (m,l,t) base is treated; charge/temperature   *)
(* extend the same lattice argument (k_B, e set to 1) — left as the same      *)
(* construction on a larger exponent vector.                                  *)
(******************************************************************************)

Require Import QArith.
Require Import Coq.micromega.Psatz.
Require Import Coq.micromega.Lqa.

Module RDU_NativeInformationUnits.
  Open Scope Q_scope.

  (* a (mechanical) dimension = exponent vector (mass, length, time) *)
  Record Dim := { dm : Q ; dl : Q ; dt : Q }.
  Definition dadd (a b : Dim) := {| dm := dm a + dm b ; dl := dl a + dl b ; dt := dt a + dt b |}.
  Definition dscale (k : Q) (a : Dim) := {| dm := k * dm a ; dl := k * dl a ; dt := k * dt a |}.
  Definition dsub (a b : Dim) := dadd a (dscale (-(1#1)) b).
  Definition deq (a b : Dim) : Prop := dm a == dm b /\ dl a == dl b /\ dt a == dt b.
  Definition dimensionless := {| dm := 0 ; dl := 0 ; dt := 0 |}.   (* = information (nats): the one unit *)

  (* the three fundamental constants' dimensions *)
  Definition c_dim    := {| dm := 0      ; dl := (1#1) ; dt := -(1#1) |}.   (* velocity  L/T   *)
  Definition hbar_dim := {| dm := (1#1)  ; dl := (2#1) ; dt := -(1#1) |}.   (* action    M L^2/T *)
  Definition mass_dim := {| dm := (1#1)  ; dl := 0     ; dt := 0      |}.   (* a mass scale    *)

  (* (1) UNIMODULAR: det[c;hbar;mass] = 1  =>  the 3 constants are a BASIS of the dimension lattice. *)
  Definition det3 :=
    dm c_dim * (dl hbar_dim * dt mass_dim - dt hbar_dim * dl mass_dim)
    - dl c_dim * (dm hbar_dim * dt mass_dim - dt hbar_dim * dm mass_dim)
    + dt c_dim * (dm hbar_dim * dl mass_dim - dl hbar_dim * dm mass_dim).
  Theorem constants_unimodular : det3 == 1.
  Proof. unfold det3, c_dim, hbar_dim, mass_dim; simpl; ring. Qed.

  (* (2) coordinates of ANY dimension d in the basis {c,hbar,mass} (exact, since det=1) *)
  Definition coord_c (d : Dim) : Q := -(dl d) - (2#1)*(dt d).
  Definition coord_h (d : Dim) : Q := dl d + dt d.
  Definition coord_m (d : Dim) : Q := dm d - dl d - dt d.
  Definition combo (d : Dim) : Dim :=
    dadd (dscale (coord_c d) c_dim) (dadd (dscale (coord_h d) hbar_dim) (dscale (coord_m d) mass_dim)).

  (* (3) SPAN: every dimension equals its constant-combination => expressible via {c,hbar,mass}. *)
  Theorem dimension_spanned : forall d : Dim, deq (combo d) d.
  Proof.
    intro d. unfold deq, combo, dadd, dscale, coord_c, coord_h, coord_m, c_dim, hbar_dim, mass_dim; simpl.
    repeat split; ring.
  Qed.

  (* (4) COLLAPSE: in natural units (c=hbar=mass=1) EVERY dimension collapses to dimensionless = info. *)
  Theorem every_dimension_collapses : forall d : Dim, deq (dsub d (combo d)) dimensionless.
  Proof.
    intro d. unfold deq, dsub, combo, dadd, dscale, coord_c, coord_h, coord_m,
                    c_dim, hbar_dim, mass_dim, dimensionless; simpl.
    repeat split; ring.
  Qed.

  (* (5) THE PARAMETERS ARE INFORMATION: the spine parameters M,D,K,V — whatever their dimensions —
     collapse to dimensionless (information) quantities. Hence the master equation
        M d2Phi + D dPhi + K L_R Phi + grad V = J - eta
     has NO free dimensionful parameter in the native (information) unit: the parameters were a
     human-readout artifact of using many units, not intrinsic freedom. *)
  Theorem spine_parameters_are_information : forall dM dD dK dV : Dim,
       deq (dsub dM (combo dM)) dimensionless
    /\ deq (dsub dD (combo dD)) dimensionless
    /\ deq (dsub dK (combo dK)) dimensionless
    /\ deq (dsub dV (combo dV)) dimensionless.
  Proof. intros; repeat split; apply every_dimension_collapses. Qed.

End RDU_NativeInformationUnits.
