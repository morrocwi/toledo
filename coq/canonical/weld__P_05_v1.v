(* weld/P.05.v1 -- open_prop -- Retained-information relaxation-inertia *)
(* turbulence prediction equation: instance_of weld/S.01.v1 (Finite-Memory *)
(* Laplacian/Telegraph Generator) applied to a new domain (turbulence *)
(* structural state I_R), and a structural (not author-cited) match to *)
(* IDM/Genesis root EQ-008's L_R := D_W - W. Does NOT resolve Genesis root *)
(* gap T2 (this is the linear/time-invariant L_R sub-case only). *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \tau_R \frac{dI_R}{dt} + L_R I_R = S_R + \eta_R *)
(* Toledo v1.8 (URCF merge): finite-model open_prop -- I_R, S_R, eta_R are *)
(* abstract Section Parameters over a declared state space; L_R is a *)
(* declared positive-semidefinite linear operator on that space (per the *)
(* source's own zero-mode-policy declaration); tau_R > 0. Unproved by *)
(* design (source's own "Definition", not a proved theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section weld__P_05_v1_sec.
  Variable Time : Type.
  Variable State : Type.        (* the declared state space I_R lives in *)
  Variable zero : State.
  Variable add sub : State -> State -> State.
  Variable scale : Q -> State -> State.
  Variable L_R : State -> State.        (* declared linear operator *)
  Variable positive_semidefinite : (State -> State) -> Prop.
  Variable I_R S_R eta_R : Time -> State.
  Variable dI_R_dt : Time -> State.
  Variable tau_R : Q.

  Definition weld__P_05_v1_hyp : Prop :=
    tau_R > 0 /\
    positive_semidefinite L_R /\
    forall t : Time,
      add (scale tau_R (dI_R_dt t)) (L_R (I_R t)) = add (S_R t) (eta_R t).
End weld__P_05_v1_sec.
