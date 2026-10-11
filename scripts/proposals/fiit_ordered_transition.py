#!/usr/bin/env python3
"""FIIT-01 — ordered-input typed readout, proposed research model (NOT a clinical fit).

Toledo parents: CAN-003/006/007, B.07, C.07; biology B.29/B.30 OPEN.
"""
from __future__ import annotations
import math
from dataclasses import dataclass

@dataclass(frozen=True)
class Phase:
    name: str
    forward: float
    reverse: float
    duration: float
    time_unit: str = 'min'

def step(p: float, a: Phase) -> float:
    vals = (p, a.forward, a.reverse, a.duration)
    if not all(math.isfinite(x) for x in vals) or not 0 <= p <= 1:
        raise ValueError('HOLD: invalid or nonfinite state')
    if min(vals[1:]) < 0:
        raise ValueError('HOLD: rates and duration must be nonnegative')
    rate = a.forward + a.reverse
    if rate == 0:
        return p
    peq = a.forward / rate
    return peq + (p - peq) * math.exp(-rate * a.duration)

def sequence(p: float, phases: list[Phase]) -> float:
    if not phases or len({a.time_unit for a in phases}) != 1:
        raise ValueError('HOLD: missing phase or mixed time unit')
    if phases[0].time_unit not in {'s', 'ms', 'min', 'h', 'day'}:
        raise ValueError('HOLD: undeclared time unit')
    for a in phases:
        p = step(p, a)
    return p

def swap_witness(p:float, a:Phase, b:Phase) -> dict:
    ab = sequence(p, [a,b]); ba = sequence(p,[b,a])
    la, lb = a.forward+a.reverse, b.forward+b.reverse
    pa = a.forward/la if la else p
    pb = b.forward/lb if lb else p
    exact = (-math.expm1(-la*a.duration)) * (-math.expm1(-lb*b.duration)) * (pb-pa)
    return {'A_then_B': ab,'B_then_A':ba,'delta':ab-ba,'derived_delta':exact,
            'identity_residual':ab-ba-exact,
            'claim_tier':'EXACT_IN_DECLARED_MODEL, NOT BIOLOGICAL_PREDICTION'}

REQUIRED = ('entity','quantity','unit','assay','specimen','population','sampling_time',
            'context','source','calibration_id')

def admit_readouts(observation:dict, target:dict)->tuple[str,list[str]]:
    errors=[]
    for tag,rec in [('source',observation),('target',target)]:
        for field in REQUIRED:
            if field not in rec or rec[field] is None or rec[field]=='':
                errors.append(f'{tag}: missing {field}')
    if errors:
        return 'HOLD',errors
    for field in ('entity','quantity','unit','assay','specimen','population','context',
                  'calibration_id'):
        if observation[field]!=target[field]:
            errors.append(f'{field} mismatch')
    if errors:
        return 'HOLD',errors
    return 'TYPED_ONLY_NOT_CALIBRATED',[]

if __name__=='__main__':
    import json
    A=Phase('A',0.8,0.1,1)
    B=Phase('B',0.1,0.7,1)
    result=swap_witness(0.5,A,B)
    result['data_status']='ILLUSTRATIVE_RATES_NOT_FITTED'
    print(json.dumps(result,indent=2))
