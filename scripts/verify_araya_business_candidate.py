#!/usr/bin/env python3
"""Source-scoped structural sanity checks, not Coq or empirical verification."""
import re
from pathlib import Path
p=Path(__file__).with_name('ARAYA_Business_Readout_Candidate.v')
s=p.read_text()
claims=['declared_readout_commutes','cash_only_readout_fails','forbidden_action_never_awarded',
'illegal_action_never_awarded','mission_failure_never_awarded',
'capital_injection_is_not_new_owner_gain','owner_distribution_does_not_mint_wealth',
'declared_cash_floor_preserved']
assert len(re.findall(r'\bQed\.',s)) == len(claims)
assert all(s.count(k)==1 for k in claims)
assert 'Admitted.' not in s and 'Axiom ' not in s
print(f'STATIC PASS: {len(claims)} proof statements, no Admitted/Axiom tokens')
print('UNVERIFIED: coqc must compile this file, and a human must assess assumptions.')