(* ===================================================================== *)
(*  InfoThetaCPSquareObstruction_attempt.v — the admissibility-square      *)
(*  obstruction: a REAL mixing matrix retains no CP-signed readout.        *)
(*  Item 2 Attempt 4 / Theta program step 5.4 (companion:                  *)
(*  theta_cp_square_v1.py).                                                *)
(*                                                                         *)
(*  CONTEXT: two independent machine-checked arrows give N >= 3 — the      *)
(*  root-native minimal-living bound (InfoThetaMinimalLiving_attempt.v)    *)
(*  and the CP-conditional bound                                           *)
(*  (InfoCPEquivariantGenerationBound_attempt.v).  Identifying their two   *)
(*  N's needs a bridge from the living Theta-graphs to a mixing structure  *)
(*  that retains a CP-signed difference.  The natural bridge (eigenbasis   *)
(*  mismatch of two living sector Laplacians) produces a REAL orthogonal   *)
(*  mixing matrix — and this file proves that is not enough:               *)
(*                                                                         *)
(*   O1 real_quartet_no_cp_readout — the Jarlskog-type quartet of a        *)
(*      matrix whose entries are all REAL (zero imaginary parts, in the    *)
(*      Q-pair complex representation of                                   *)
(*      InfoCPEquivariantGenerationBound_attempt.v) has imaginary part     *)
(*      exactly 0: the CP-signed readout reads the NEUTRAL value on every  *)
(*      real mixing configuration.  Trivial to prove and load-bearing to   *)
(*      state — the whole real-weighted Theta architecture sits in the     *)
(*      neutral fibre of the CP readout.                                   *)
(*                                                                         *)
(*  CONSEQUENCE (comment, Dr): real mixing angles between living sectors   *)
(*  exist natively (a genuine rotation — see the Python companion), but    *)
(*  the PHASE slot is structurally empty.  Making A_CP's premise           *)
(*  root-realizable requires an oriented/skew edge structure — the         *)
(*  corpus's own G-adjoint split G^(-) and omega pairing are the named     *)
(*  candidates.  NOT built here.                                           *)
(*                                                                         *)
(*  CRRC guard (binding): nothing here identifies the two N's, or slots/   *)
(*  levels with generations.  The square is recorded as HALF-CLOSED:       *)
(*  legitimate intersection of two necessary conditions on the same        *)
(*  declared slot count, plus this proven obstruction to full closure.     *)
(* ===================================================================== *)

Require Import QArith.

(* the same Gaussian-rational complex representation as the CP-bound file. *)
Record Cq : Type := mkC { cre : Q; cim : Q }.
Definition Cmul (x y : Cq) : Cq :=
  mkC (cre x * cre y - cim x * cim y) (cre x * cim y + cim x * cre y).
Definition Cconj (x : Cq) : Cq := mkC (cre x) (- cim x).

(* O1 · a quartet of REAL entries has zero imaginary part: the CP-signed   *)
(* readout is NEUTRAL on every real mixing configuration.                  *)
Theorem real_quartet_no_cp_readout :
  forall a b c d : Q,
    (cim (Cmul (Cmul (mkC a 0) (mkC b 0))
               (Cmul (Cconj (mkC c 0)) (Cconj (mkC d 0)))) == 0)%Q.
Proof. intros. simpl. ring. Qed.
