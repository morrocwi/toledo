(* EQ-015/H.42.v1 -- not_yet_formalised -> open_prop -- RET diagnostic state vector *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathfrak R_t = \left\langle \chi_{\mathrm{recip},t}^{\mathcal G}, D_{\mathcal G,t}^{\mathrm{eff}}, R_{\mathcal G,t}^{\mathrm{ex}}, P_{\mathcal G,t}^{\mathrm{ind}}, K_{\mathcal G,t}^{\mathrm{status}}, \kappa_{\mathcal G,t} \right\rangle *)
(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model open_prop --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   Unproved by design (Dr source label). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section EQ_015__H_42_v1_sec.
  Parameter ChiRecip DEff REx PInd Kappa : nat -> Q.
  Parameter KStatus : Type.
  Parameter K_status : nat -> KStatus.
  Definition EQ_015__H_42_v1_hyp (t : nat) : Prop :=
    exists v : Q * Q * Q * Q * KStatus * Q,
      v = (ChiRecip t, DEff t, REx t, PInd t, K_status t, Kappa t).
End EQ_015__H_42_v1_sec.
