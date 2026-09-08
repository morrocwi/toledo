"""scripts — package marker only.

Exists so `from scripts.executable import ir_eval` (the import path
docs/EXECUTABLE_EQUATIONS_v0_1.md sec.8 specifies for `toledo_eval`, and
that scripts/executable/ir_eval.py's own relative `from . import ir_kernel`
requires to resolve at all) works from the repository root. Not owned by
any one build stream in sec.10's ownership table; added because the
package layout the spec itself requires cannot function without it.
"""
