"""Mechanical guard (mcp/DESIGN.md grafts B2/C2, section 9 "S4"): `verdict.py`
is the ONLY module allowed to construct a `verdict.Verdict` object.

This turns "verdict.py is the single source of truth for the founder-rule
enforcement vocabulary" from a convention documented in a docstring into a
checked invariant that fails CI the moment a future change (e.g. a new tool
in `server.py`, or a new subcommand in `cli.py`) starts building its own ad
hoc verdict-shaped dict or a second `Verdict(...)` call instead of routing
through `verdict.verdict_for_entry`/`verdict_for_check`.

An AST walk (not a text grep) is used deliberately: a grep for the literal
substring `Verdict(` would also flag this test file's own docstring, any
future comment describing the class, and a dict literal that merely uses the
word — none of which is an actual construction. Walking `ast.Call` nodes
whose callee resolves to the name `Verdict` is precise about what "construct
an instance" means, regardless of whether it is imported as `Verdict`,
`verdict.Verdict`, or aliased.
"""
from __future__ import annotations

import ast
import pathlib

TOLEDO_MCP_DIR = pathlib.Path(__file__).resolve().parent.parent / "toledo_mcp"


def _callee_name(node: ast.Call) -> str | None:
    func = node.func
    if isinstance(func, ast.Name):
        return func.id
    if isinstance(func, ast.Attribute):
        return func.attr
    return None


def _verdict_construction_lines(path: pathlib.Path) -> list[int]:
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    return [
        node.lineno
        for node in ast.walk(tree)
        if isinstance(node, ast.Call) and _callee_name(node) == "Verdict"
    ]


def _all_source_files() -> list[pathlib.Path]:
    assert TOLEDO_MCP_DIR.is_dir(), f"expected {TOLEDO_MCP_DIR} to exist"
    return sorted(TOLEDO_MCP_DIR.glob("*.py"))


def test_verdict_py_itself_is_scanned_and_constructs_verdict():
    """Sanity check on the test's own method: verdict.py is expected to be
    the one file where `Verdict(...)` calls are found at all — if this ever
    goes to zero, the AST walk itself has broken silently, and the "no
    violations found" result of the real test below would be meaningless."""
    verdict_py = TOLEDO_MCP_DIR / "verdict.py"
    assert verdict_py.is_file()
    assert _verdict_construction_lines(verdict_py), (
        "expected at least one `Verdict(...)` construction inside verdict.py itself; "
        "the AST walk found none — check _callee_name/_verdict_construction_lines "
        "before trusting the no-violations result of "
        "test_only_verdict_py_constructs_verdict_objects."
    )


def test_only_verdict_py_constructs_verdict_objects():
    violations: dict[str, list[int]] = {}
    for path in _all_source_files():
        if path.name == "verdict.py":
            continue
        lines = _verdict_construction_lines(path)
        if lines:
            violations[path.name] = lines

    assert not violations, (
        "Verdict(...) constructed outside verdict.py: "
        + ", ".join(f"{name}:{lines}" for name, lines in sorted(violations.items()))
        + " — route every verdict through verdict.verdict_for_entry/verdict_for_check "
          "instead (mcp/DESIGN.md graft B2/C2); verdict.py must stay the single place "
          "this rule's vocabulary is spelled."
    )
