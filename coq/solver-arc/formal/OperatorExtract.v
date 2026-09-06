(* Extract the verified computational readouts to a runnable OCaml module.
   The extracted code IS the kernel — the strongest bridge (verified executable). *)
Require Import URCF_RD_All.
Require Import Extraction.
Extraction Language OCaml.
Set Extraction Output Directory "../extracted".
Extraction "operator.ml"
  InfoEcon.excess_demand
  InfoFinance.variance
  InfoSpectral2.char_poly
  InfoLorentzInvariance.box_quad.
