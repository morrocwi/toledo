(* weld/S.50.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Group warrant function W_{G,t}(H) = W_G(R_{G,<=t}, independence,
   defects, calibration, objection channels) -- an opaque function of
   its five declared inputs. *)
Section weld_S50.
  Variables RegimeHistory Independence Defects Calibration ObjectionChannels : Type.
  Variable W_G : RegimeHistory -> Independence -> Defects -> Calibration ->
                 ObjectionChannels -> Q.
  Definition weld_S50_W (r : RegimeHistory) (i : Independence) (d : Defects)
    (c : Calibration) (o : ObjectionChannels) : Q := W_G r i d c o.
End weld_S50.
