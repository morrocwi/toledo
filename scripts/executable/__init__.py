"""scripts/executable — S1 (classifier + IR extraction) package marker.

Empty on purpose: this file exists only so `from scripts.executable import
ir_eval` (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.8, the MCP toledo_eval
import path) resolves once S2 lands ir_eval.py. S1 owns
check_antlr4.py / classify.py / extract_ir.py in this directory; it does not
own, and does not write, ir_kernel.py / ir_eval.py (S2, per sec.10's
ownership table).
"""
