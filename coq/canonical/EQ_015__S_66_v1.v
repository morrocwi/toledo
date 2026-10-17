(* EQ-015/S.66.v1 -- Definition -- CE diagnostic gate on a documented option. *)
(* NEW DERIVATION / PROPOSAL. Claim boundary: facts/options projection; not a *)
(* fatwa, ruling, mediation, or religious verdict; EQ-015 CE structural only. *)
(* The diagnostic is NotAssessed unless every CE input is independently      *)
(* specified; with no input the result is never Assessed true (PASS) and     *)
(* never any assessed value. The tier stays Definition: only this narrow     *)
(* gate-closure lemma is proved; the non-implication between CE structural   *)
(* admissibility and any religious classification is a stated boundary, not  *)
(* a proved theorem.                                                         *)

Inductive DStatus : Type :=
  | NotAssessed : DStatus
  | Assessed : bool -> DStatus.

Section EQ_015__S_66_v1_sec.
  Variable AssessedValue : Type.
  Variable value_to_bool : AssessedValue -> bool.

  (* specified := agency, regime, record M(t'), causal memory, V, tau'_c and *)
  (* Delta_spec all independently specified with disclosed calibration.      *)
  Definition D_CE (specified : bool) (v : AssessedValue) : DStatus :=
    if specified then Assessed (value_to_bool v) else NotAssessed.

  Lemma EQ_015__S_66_v1_unspecified_not_assessed :
    forall v : AssessedValue, D_CE false v = NotAssessed.
  Proof. intros v. reflexivity. Qed.

  Lemma EQ_015__S_66_v1_unspecified_never_pass :
    forall (v : AssessedValue) (b : bool), D_CE false v <> Assessed b.
  Proof. intros v b H. unfold D_CE in H. discriminate H. Qed.
End EQ_015__S_66_v1_sec.

Print Assumptions EQ_015__S_66_v1_unspecified_never_pass.
