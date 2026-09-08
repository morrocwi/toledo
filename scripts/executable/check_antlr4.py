#!/usr/bin/env python3
"""scripts/executable/check_antlr4.py — S1, antlr4 precondition check.

docs/EXECUTABLE_EQUATIONS_v0_1.md sec.1.1: `sympy.parsing.latex.parse_latex`
needs `antlr4-python3-runtime`. This script fails closed (non-zero exit, no
silent skip) whenever the classifier's own precondition does not hold, and
gives the two failure cases named in sec.1.1 visibly different messages so
"the runtime actually is present but broken in some other way" is never
silently folded into the "not installed" branch the way
`scripts/toledo_build.py::content_mathml` itself does today.

sympy's OWN stated requirement (not this document's guess): the generated
ANTLR parser sympy ships
(`sympy/parsing/latex/_antlr/latexparser.py::checkVersion("4.11.1")`) and
sympy's sibling autolev parser
(`sympy/parsing/autolev/_parse_autolev_antlr.py`) both gate on
`importlib.metadata.version("antlr4-python3-runtime").startswith("4.11")` —
this is the exact check reused here, read directly from the installed sympy
package, not assumed from memory.

Exit codes: 0 = precondition holds. 1 = antlr4 not importable at all.
2 = antlr4 importable but its resolved package version does not satisfy
sympy's own "startswith 4.11" requirement (a distinct failure from case 1 —
imported yet broken/wrong-version, never folded into the "not installed"
message).

Called by classify.py (and, per sec.1.1, meant to be called from `make
build` before `content_mathml` is attempted) — never silently bypassed.
"""
from __future__ import annotations

import sys

REQUIRED_PREFIX = "4.11"  # sympy's own check: version(...).startswith("4.11")
PACKAGE_NAME = "antlr4-python3-runtime"


def check() -> tuple[bool, str]:
    """Returns (ok, message). Never raises — every failure is reported."""
    try:
        import antlr4  # noqa: F401
    except ImportError as exc:
        return False, (
            f"FAIL (case 1: not importable) — `import antlr4` raised {exc!r}. "
            f"antlr4 runtime not installed. Fix: "
            f"pip3 install {PACKAGE_NAME}==4.11.0 (or the conda equivalent), "
            f"per docs/EXECUTABLE_EQUATIONS_v0_1.md sec.1.1."
        )

    try:
        from importlib.metadata import PackageNotFoundError, version
    except ImportError:  # pragma: no cover — py3.8+ always has this
        return False, (
            "FAIL (case 2: version unresolvable) — this Python has no "
            "importlib.metadata; cannot confirm antlr4's resolved version."
        )

    try:
        resolved = version(PACKAGE_NAME)
    except PackageNotFoundError:
        return False, (
            "FAIL (case 2: version unresolvable) — `import antlr4` succeeded "
            f"but no installed-package metadata exists for '{PACKAGE_NAME}' "
            "(e.g. a vendored/editable antlr4 with no matching distribution "
            "record). This is NOT case 1 (module truly absent) — antlr4 IS "
            "importable, but its version cannot be confirmed against "
            "sympy's own requirement, so this fails closed rather than "
            "assuming it is fine."
        )

    if not resolved.startswith(REQUIRED_PREFIX):
        return False, (
            f"FAIL (case 2: wrong version) — antlr4 IS importable and "
            f"'{PACKAGE_NAME}' resolves to version {resolved}, but sympy's "
            f"own generated parser "
            f"(sympy/parsing/latex/_antlr/latexparser.py checkVersion) and "
            f"its sibling autolev-parser guard both require a version "
            f"starting with '{REQUIRED_PREFIX}'. This is a real precondition "
            f"failure, distinct from 'not installed' (case 1) — the runtime "
            f"is present but broken for sympy's purposes."
        )

    return True, (
        f"OK — antlr4 importable, '{PACKAGE_NAME}' resolves to version "
        f"{resolved}, satisfies sympy's own requirement "
        f"(startswith '{REQUIRED_PREFIX}')."
    )


def main() -> int:
    ok, message = check()
    print(message)
    if not ok:
        return 1 if message.startswith("FAIL (case 1") else 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
