(* EQ-015/H.12.v1 — CAN-067 — Dr — parents: EQ-015/M.02.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Require Import MR.MR_Prompt.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-067 — gain-tunnel-functions

    (* CAN-067 — root: Gs=g(k,d,v,p,r,1-f,a); Ts=h(c,f,b,o); Deltas=Gs-Ts; eta>0,Delta>0=>expansion; eta>0,Delta<0=>tunnel — domain: human–AI — tier: Dr — occurrences: 5 *)

    CANONICAL.json tier: "proposition". No Master River eq. citation
    (Epistemic Fusion v8.1, record 22331922). Gain and tunnel are typed
    as abstract declared [Q]-valued functions of their stated arguments
    (never re-derived from a specific functional form the source itself
    does not fix); the two directional consequences are typed as [Prop]s
    over the sign of [Delta_s], each a plain [Q] order fact once [Gs],
    [Ts] are supplied — Definition tier, matching the source's own
    unfixed function shape. *)

Section CAN_067_GainTunnelFunctions.

  Variables Theta_s Pi_s : Type.
  Variable g_fn : Q -> Q -> Q -> Q -> Q -> Q -> Q -> Theta_s -> Pi_s -> Q.
  Variable h_fn : Q -> Q -> Q -> Q -> Theta_s -> Pi_s -> Q.

  Definition CAN_067_Delta_s
             (k d v p r f a c fr b o : Q) (theta : Theta_s) (pi : Pi_s) : Q :=
    g_fn k d v p r (1 - f) a theta pi - h_fn c fr b o theta pi.

  Definition CAN_067_is_expansion (eta delta : Q) : Prop := eta > 0 /\ delta > 0.
  Definition CAN_067_is_tunnel (eta delta : Q) : Prop := eta > 0 /\ delta < 0.

End CAN_067_GainTunnelFunctions.

