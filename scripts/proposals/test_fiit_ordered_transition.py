#!/usr/bin/env python3
"""Algebra and fail-closed checks for FIIT-01. Run with python -m unittest."""
import unittest
import math
try:
    from scripts.proposals.fiit_ordered_transition import Phase, step, sequence, swap_witness, admit_readouts
except ImportError:
    from fiit_ordered_transition import Phase, step, sequence, swap_witness, admit_readouts

class FIITTests(unittest.TestCase):
    def test_order_identity(self):
        a=Phase('A',.8,.1,1); b=Phase('B',.1,.7,1)
        v=swap_witness(.5,a,b)
        self.assertAlmostEqual(v['identity_residual'],0,places=12)
        self.assertGreater(abs(v['delta']),1e-3)
    def test_zero_rates(self):
        self.assertEqual(step(.42,Phase('Z',0,0,2)),.42)
    def test_equal_equilibria_commute(self):
        self.assertAlmostEqual(swap_witness(.5,Phase('A',1,1,1),Phase('B',2,2,1))['delta'],0)
    def test_no_phase_rejected(self):
        with self.assertRaises(ValueError):sequence(.5,[])
    def test_mixed_time_rejected(self):
        with self.assertRaises(ValueError):sequence(.5,[Phase('A',1,0,1,'s'),Phase('B',1,0,1,'min')])
    def test_negative_rate_rejected(self):
        with self.assertRaises(ValueError):step(.5,Phase('A',-1,1,1))
    def test_nonfinite_rejected(self):
        with self.assertRaises(ValueError):step(.5,Phase('A',math.inf,0,1))
    def test_bounds(self):
        for p in [0,.5,1]:
            for u in [0,.1,10]:
                for v in [0,.1,10]:
                    self.assertTrue(-1e-12 <= step(p,Phase('A',u,v,3)) <= 1+1e-12)
    def test_gating(self):
        a=dict(entity='glucose',quantity='plasma_concentration',unit='mg/dL',assay='lab',
               specimen='plasma',population='cross_over',sampling_time=30,context='food',
               source='PMID:28989726',calibration_id='UNVERIFIED_LABEL')
        self.assertEqual(admit_readouts(a,dict(a))[0],'TYPED_ONLY_NOT_CALIBRATED')
        b=dict(a,entity='IL-6',unit='pg/mL')
        self.assertEqual(admit_readouts(a,b)[0],'HOLD')
        c=dict(a);c.pop('assay')
        self.assertEqual(admit_readouts(a,c)[0],'HOLD')

if __name__=='__main__':unittest.main()
