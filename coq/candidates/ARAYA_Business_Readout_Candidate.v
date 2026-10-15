(** ARAYA Captain / Toledo business readout candidate — local domain adapter.
    DRAFT ONLY.  NOT a canonical Toledo equation; not Coq-verified in this
    environment unless CI evidence is attached. Original Toledo parents:
      EQ-015/M.02.v1 (state transition), weld/M.02.v1 (domain commutation).
    Theorem statements are about these DECLARED finite records only; they
    establish neither empirical completeness nor financial performance. *)
From Coq Require Import ZArith Bool List Lia.
Import ListNotations.
Open Scope Z_scope.

Record World := mkWorld { cash_real : Z; refunds_due : Z; irrelevant_trace : nat }.
Record Ledger := mkLedger { cash_seen : Z; refunds_seen : Z }.
Definition q_business (w : World) : Ledger :=
  mkLedger (cash_real w) (refunds_due w).
Definition F_world (w : World) (receipts : Z) : World :=
  mkWorld (cash_real w + receipts - refunds_due w) 0 (S (irrelevant_trace w)).
Definition F_ledger (s : Ledger) (receipts : Z) : Ledger :=
  mkLedger (cash_seen s + receipts - refunds_seen s) 0.

Theorem declared_readout_commutes :
  forall (w : World) (receipts : Z),
    q_business (F_world w receipts) = F_ledger (q_business w) receipts.
Proof.
  intros [c r tr] receipts. reflexivity.
Qed.

(* Dropping refunds makes a cash-only reading NOT transition-closed. *)
Example cash_only_readout_fails :
  exists w1 w2 : World,
    cash_real w1 = cash_real w2 /\
    cash_real (F_world w1 0) <> cash_real (F_world w2 0).
Proof.
  exists (mkWorld 100 10 0), (mkWorld 100 20 1).
  simpl. split; lia.
Qed.

Record Gates := mkGates {
  legal_ok : bool;
  safeguarding_ok : bool;
  authority_ok : bool;
  privacy_ok : bool;
  mission_ok : bool
}.
Definition admissible (g : Gates) : bool :=
  legal_ok g && safeguarding_ok g && authority_ok g &&
  privacy_ok g && mission_ok g.
Definition award_if_admissible (g : Gates) (wealth_score : Z) : option Z :=
  if admissible g then Some wealth_score else None.

Theorem forbidden_action_never_awarded :
  forall g wealth_score, admissible g = false ->
    award_if_admissible g wealth_score = None.
Proof.
  intros g wealth_score H.
  unfold award_if_admissible. rewrite H. reflexivity.
Qed.

Theorem illegal_action_never_awarded :
  forall g wealth_score, legal_ok g = false ->
    award_if_admissible g wealth_score = None.
Proof.
  intros [l s a p m] wealth_score H. simpl in *.
  subst l. reflexivity.
Qed.

Theorem mission_failure_never_awarded :
  forall g wealth_score, mission_ok g = false ->
    award_if_admissible g wealth_score = None.
Proof.
  intros [l s a p m] wealth_score H. simpl in *.
  subst m. destruct l, s, a, p; reflexivity.
Qed.

Definition owner_book_gain (distributed equity paid_in : Z) : Z :=
  distributed + equity - paid_in.
Theorem capital_injection_is_not_new_owner_gain :
  forall distribution equity paid_in injection,
    owner_book_gain distribution (equity + injection) (paid_in + injection)
    = owner_book_gain distribution equity paid_in.
Proof. intros. unfold owner_book_gain. lia. Qed.
Theorem owner_distribution_does_not_mint_wealth :
  forall distribution equity paid_in payout,
    owner_book_gain (distribution + payout) (equity - payout) paid_in
    = owner_book_gain distribution equity paid_in.
Proof. intros. unfold owner_book_gain. lia. Qed.

Fixpoint cash_run_guarded (floor cash : Z) (cash_steps : list Z) : option Z :=
  match cash_steps with
  | [] => if Z.leb floor cash then Some cash else None
  | delta :: rest =>
      if Z.leb floor (cash + delta)
      then cash_run_guarded floor (cash + delta) rest
      else None
  end.
Theorem declared_cash_floor_preserved :
  forall cash_steps floor cash finish,
    cash_run_guarded floor cash cash_steps = Some finish -> floor <= finish.
Proof.
  induction cash_steps as [|delta rest IH]; intros floor cash finish H.
  - simpl in H. destruct (Z.leb floor cash) eqn:Hle; try discriminate.
    inversion H; subst. apply Z.leb_le in Hle. assumption.
  - simpl in H. destruct (Z.leb floor (cash + delta)); try discriminate.
    eapply IH. exact H.
Qed.

(** Claim ceiling: the two proofs of commutation and cash safety hold ONLY
    within the explicitly declared World, Ledger, transition and guarded-run
    definitions. They do NOT demonstrate that live ARAYA finances are an
    adequate quotient of real-world dynamics; this needs empirical tests. *)