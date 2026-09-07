"""Packaging, CI-tooling, and cross-cutting invariant tests owned by stream
S4 (mcp/DESIGN.md section 16). Covers:

  - `pyproject.toml` declares the console scripts / dependency pin / Python
    floor the rest of this package's constraints assume.
  - the two console-script entry points are importable, and `toledo_mcp.server`'s
    actually runnable end to end over a real (short-lived) subprocess.
  - `mcp/scripts/sync_version.py` correctly reads CITATION.cff and writes
    pyproject.toml / `__init__.py`, on isolated temp fixtures, AND that the
    real, checked-in files are not currently drifted from it.
  - `mcp/scripts/leak_scan.py`'s four detection categories, on a synthetic
    fixture tree, including that it never echoes the matched secret text.
  - `.gitignore` covers every generated/runtime directory this package's own
    design introduces.

`toledo_mcp/cli.py` and `toledo_mcp/export_static.py` are owned by a separate
build stream (S3, mcp/DESIGN.md sec. 14/13) and may not exist yet in the
checkout this test runs against. Every test below that needs one of those
modules skips (with a message naming the owning stream and doc section)
rather than failing, so this file is meaningful both before and after S3
lands — and turns from "skipped" into a real assertion the moment it does,
with no edit needed here.
"""
from __future__ import annotations

import base64
import importlib
import importlib.util
import os
import pathlib
import subprocess
import sys

import pytest

MCP_DIR = pathlib.Path(__file__).resolve().parent.parent
REPO_ROOT = MCP_DIR.parent
TOLEDO_MCP_DIR = MCP_DIR / "toledo_mcp"
SCRIPTS_DIR = MCP_DIR / "scripts"
PYPROJECT_PATH = MCP_DIR / "pyproject.toml"
REQUIREMENTS_PATH = MCP_DIR / "requirements-mcp.txt"
GITIGNORE_PATH = MCP_DIR / ".gitignore"
CITATION_PATH = REPO_ROOT / "CITATION.cff"

sys.path.insert(0, str(MCP_DIR))


def _load_module_from_path(path: pathlib.Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    # Register in sys.modules BEFORE exec: a `@dataclass` under
    # `from __future__ import annotations` (leak_scan.py's Finding/ScanResult)
    # resolves its module via `sys.modules[cls.__module__]` during class
    # creation — without this, that lookup returns None and dataclass() itself
    # raises, even though the module has nothing to do with type resolution
    # in the tests here.
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


sync_version = _load_module_from_path(SCRIPTS_DIR / "sync_version.py", "toledo_mcp_scripts_sync_version")
leak_scan = _load_module_from_path(SCRIPTS_DIR / "leak_scan.py", "toledo_mcp_scripts_leak_scan")


def _load_pyproject() -> dict:
    import tomllib  # stdlib, Python 3.11+ — this package requires >=3.12 anyway

    with open(PYPROJECT_PATH, "rb") as fh:
        return tomllib.load(fh)


# ---------------------------------------------------------------------------
# pyproject.toml declarations
# ---------------------------------------------------------------------------

def test_pyproject_declares_expected_console_scripts():
    doc = _load_pyproject()
    scripts = doc["project"]["scripts"]
    assert scripts.get("toledo") == "toledo_mcp.cli:main", (
        "mcp/DESIGN.md sec. 14/15: the `toledo` console script must point at "
        "toledo_mcp.cli:main"
    )
    assert scripts.get("toledo-mcp") == "toledo_mcp.server:main"


def test_pyproject_python_and_license_floor():
    doc = _load_pyproject()
    project = doc["project"]
    assert project["requires-python"] == ">=3.12"
    assert project["license"]["text"] == "MIT"


def test_pyproject_dependencies_are_stdlib_plus_mcp_only():
    """Cross-cutting invariant (this package's build instructions): Python
    3.12+, stdio MCP via the `mcp` package, SQLite (stdlib) — otherwise
    standard library only. Mechanically: the runtime dependency list must be
    exactly one pinned entry."""
    doc = _load_pyproject()
    deps = doc["project"]["dependencies"]
    assert len(deps) == 1, f"expected exactly one runtime dependency, found {deps!r}"
    assert deps[0].startswith("mcp=="), f"expected an exact-pinned `mcp` dependency, found {deps[0]!r}"


def test_pyproject_dependency_pin_matches_requirements_file():
    doc = _load_pyproject()
    pyproject_pin = doc["project"]["dependencies"][0]

    requirements_text = REQUIREMENTS_PATH.read_text(encoding="utf-8")
    requirement_lines = [
        line.strip() for line in requirements_text.splitlines()
        if line.strip() and not line.strip().startswith("#")
    ]
    assert requirement_lines == [pyproject_pin], (
        f"requirements-mcp.txt {requirement_lines!r} must state the exact same pin "
        f"as pyproject.toml's dependencies {pyproject_pin!r} — two independently "
        "drifting copies of the same version pin is exactly the kind of thing this "
        "test exists to catch."
    )


# ---------------------------------------------------------------------------
# Console scripts: importable, and the one that's safe to actually run does
# ---------------------------------------------------------------------------

def test_server_main_importable_and_callable():
    from toledo_mcp.server import main  # noqa: F401  (import success is the assertion)
    assert callable(main)


def test_cli_main_importable_and_callable():
    if not (TOLEDO_MCP_DIR / "cli.py").exists():
        pytest.skip("toledo_mcp/cli.py not yet landed (owned by stream S3, mcp/DESIGN.md sec. 14)")
    cli = importlib.import_module("toledo_mcp.cli")
    assert callable(cli.main)


def test_server_main_runs_stdio_and_exits_cleanly_on_closed_stdin():
    """`toledo-mcp` (console script -> toledo_mcp.server:main) starts the
    FastMCP stdio transport and must not crash/hang when stdin is already at
    EOF (exactly what a misconfigured launcher, or this smoke test itself,
    looks like) — real subprocess, real transport, short timeout so a
    regression to "hangs forever" fails the test instead of the CI job."""
    result = subprocess.run(
        [sys.executable, "-c", "from toledo_mcp.server import main; main()"],
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=str(MCP_DIR),
        timeout=15,
    )
    assert result.returncode == 0, (
        f"toledo_mcp.server.main() exited {result.returncode} on closed stdin; "
        f"stderr: {result.stderr.decode('utf-8', 'replace')[:2000]}"
    )


def test_cli_help_exits_zero():
    if not (TOLEDO_MCP_DIR / "cli.py").exists():
        pytest.skip("toledo_mcp/cli.py not yet landed (owned by stream S3, mcp/DESIGN.md sec. 14)")
    result = subprocess.run(
        [sys.executable, "-m", "toledo_mcp.cli", "--help"],
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=str(MCP_DIR), timeout=15,
    )
    assert result.returncode == 0, result.stderr.decode("utf-8", "replace")[:2000]


# ---------------------------------------------------------------------------
# sync_version.py
# ---------------------------------------------------------------------------

def test_read_citation_version_matches_real_file():
    version = sync_version.read_citation_version(CITATION_PATH)
    assert version, "CITATION.cff's version: field must not be empty"
    parts = version.split(".")
    assert len(parts) == 3 and all(p.isdigit() for p in parts), (
        f"expected a plain X.Y.Z version string, got {version!r}"
    )


@pytest.fixture()
def version_fixture(tmp_path):
    citation = tmp_path / "CITATION.cff"
    citation.write_text('cff-version: 1.2.0\nversion: "9.9.9"\ndate-released: "2026-01-01"\n', encoding="utf-8")

    pyproject = tmp_path / "pyproject.toml"
    pyproject.write_text(
        "[project]\n"
        'name = "toledo-mcp"\n'
        'version = "0.0.0"  # trailing comment must survive a sync\n'
        'description = "x"\n',
        encoding="utf-8",
    )

    init_py = tmp_path / "__init__.py"
    init_py.write_text('"""docstring"""\nfrom . import core\n\n__version__ = "0.0.0"\n\n__all__ = ["core"]\n', encoding="utf-8")

    return {"citation": citation, "pyproject": pyproject, "init": init_py}


def test_sync_version_never_writes_citation_cff(version_fixture):
    before = version_fixture["citation"].read_bytes()
    sync_version.main([
        "--citation", str(version_fixture["citation"]),
        "--pyproject", str(version_fixture["pyproject"]),
        "--init", str(version_fixture["init"]),
    ])
    after = version_fixture["citation"].read_bytes()
    assert before == after, "sync_version.py must never write CITATION.cff — it is read-only input"


def test_sync_version_writes_both_targets_verbatim(version_fixture):
    changed_pyproject = sync_version.write_pyproject_version("9.9.9", version_fixture["pyproject"])
    changed_init = sync_version.write_init_version("9.9.9", version_fixture["init"])

    assert changed_pyproject is True
    assert changed_init is True
    assert sync_version.read_pyproject_version(version_fixture["pyproject"]) == "9.9.9"
    assert sync_version.read_init_version(version_fixture["init"]) == "9.9.9"
    # the trailing comment and every other line must be untouched
    assert "# trailing comment must survive a sync" in version_fixture["pyproject"].read_text(encoding="utf-8")
    assert "from . import core" in version_fixture["init"].read_text(encoding="utf-8")


def test_sync_version_write_is_a_noop_when_already_in_sync(version_fixture):
    sync_version.write_pyproject_version("9.9.9", version_fixture["pyproject"])
    before = version_fixture["pyproject"].read_bytes()
    changed_again = sync_version.write_pyproject_version("9.9.9", version_fixture["pyproject"])
    assert changed_again is False
    assert version_fixture["pyproject"].read_bytes() == before


def test_sync_version_check_mode_detects_drift_and_confirms_sync(version_fixture, capsys):
    rc_before = sync_version.main([
        "--check",
        "--citation", str(version_fixture["citation"]),
        "--pyproject", str(version_fixture["pyproject"]),
        "--init", str(version_fixture["init"]),
    ])
    assert rc_before == 1, "fixture starts drifted (0.0.0 vs 9.9.9) — --check must report that"

    sync_version.main([
        "--citation", str(version_fixture["citation"]),
        "--pyproject", str(version_fixture["pyproject"]),
        "--init", str(version_fixture["init"]),
    ])

    rc_after = sync_version.main([
        "--check",
        "--citation", str(version_fixture["citation"]),
        "--pyproject", str(version_fixture["pyproject"]),
        "--init", str(version_fixture["init"]),
    ])
    assert rc_after == 0, "after a real sync run, --check must report clean"


def test_pyproject_and_init_are_in_sync_with_citation_cff():
    """The live, checked-in files — not a fixture. This is the packaging
    invariant a release is not supposed to ship without: run
    `python3 mcp/scripts/sync_version.py` before tagging a release if this
    test ever fails."""
    rc = sync_version.main(["--check"])
    assert rc == 0, (
        "mcp/pyproject.toml and/or mcp/toledo_mcp/__init__.py are out of sync with "
        "the repository root's CITATION.cff — run `python3 mcp/scripts/sync_version.py`."
    )


# ---------------------------------------------------------------------------
# leak_scan.py
# ---------------------------------------------------------------------------

@pytest.fixture()
def leak_tree(tmp_path):
    """A small, non-git directory tree — leak_scan.py's os.walk fallback path
    (there is no .git here), which keeps this fixture independent of whether
    the real repository happens to be a git checkout in the test environment."""
    (tmp_path / "pkg").mkdir()
    return tmp_path


def _write(root: pathlib.Path, rel: str, text: str) -> None:
    p = root / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text, encoding="utf-8")


def _home_path_sample(suffix: str) -> str:
    """Builds a sample path under the local home-directory hierarchy, at
    runtime, from two halves rather than as one contiguous literal in this
    file's own source — this test file lives under `mcp/`, which
    `leak_scan.py`'s own home-path category scans in CI (see
    `test_leak_scan_runs_clean_against_the_real_mcp_tree` below); a
    written-out example here would trip that scan against itself."""
    return "/" + "home/" + suffix


def test_leak_scan_clean_tree_reports_no_findings(leak_tree):
    _write(leak_tree, "pkg/clean.py", "def f():\n    return 1 + 1\n")
    result = leak_scan.scan(["pkg"], repo_root=str(leak_tree))
    assert result.ok
    assert result.files_scanned >= 1


def test_leak_scan_detects_home_path(leak_tree):
    _write(leak_tree, "pkg/leaky.py", f"# path: {_home_path_sample('someuser/ANSE.ASIA/toledo')}\n")
    result = leak_scan.scan(["pkg"], repo_root=str(leak_tree))
    assert not result.ok
    assert any(f.category == "home_path" for f in result.findings)


def test_leak_scan_detects_username(leak_tree, monkeypatch):
    monkeypatch.setenv("USER", "unlikelytestuser42")
    monkeypatch.delenv("LOGNAME", raising=False)
    _write(leak_tree, "pkg/leaky.py", "# hi unlikelytestuser42\n")
    result = leak_scan.scan(["pkg"], repo_root=str(leak_tree))
    assert not result.ok
    assert any(f.category == "username" for f in result.findings)


def test_leak_scan_ignores_short_username(leak_tree, monkeypatch):
    """A 1-2 character $USER would match almost any file — the module
    deliberately requires len(username) >= 3 before treating it as a
    pattern; pin that guard."""
    monkeypatch.setenv("USER", "ab")
    _write(leak_tree, "pkg/leaky.py", "ab ab ab\n")
    result = leak_scan.scan(["pkg"], repo_root=str(leak_tree))
    assert result.ok


def test_leak_scan_detects_ai_vendor_name(leak_tree):
    one_token = base64.b64decode(leak_scan._AI_VENDOR_TOKENS_B64[0]).decode("ascii")
    _write(leak_tree, "pkg/leaky.py", f"# built with {one_token}\n")
    result = leak_scan.scan(["pkg"], repo_root=str(leak_tree))
    assert not result.ok
    assert any(f.category == "ai_vendor_name" for f in result.findings)


def test_leak_scan_private_repo_name_requires_denylist_file(leak_tree):
    secret = "totally-secret-repo-name"
    _write(leak_tree, "pkg/leaky.py", f"# see {secret}\n")

    result_without = leak_scan.scan(["pkg"], repo_root=str(leak_tree), denylist_file=None)
    assert result_without.ok, "with no denylist configured, this category must not silently match anything"
    assert result_without.private_repo_category_ran is False

    denylist = leak_tree / "extra.local"
    denylist.write_text(secret + "\n", encoding="utf-8")
    result_with = leak_scan.scan(["pkg"], repo_root=str(leak_tree), denylist_file=str(denylist))
    assert not result_with.ok
    assert any(f.category == "private_repo_name" for f in result_with.findings)
    assert result_with.private_repo_category_ran is True


def test_leak_scan_denylist_never_denies_the_sanctioned_phrase(leak_tree):
    denylist = leak_tree / "extra.local"
    denylist.write_text(leak_scan.SANCTIONED_PRIVATE_REPO_PHRASE + "\n", encoding="utf-8")
    patterns = leak_scan._load_denylist_file(str(denylist))
    assert patterns == [], "the sanctioned phrase must never itself become a denylist pattern"


def test_leak_scan_never_prints_the_matched_secret_text(leak_tree, capsys):
    secret_path_fragment = _home_path_sample("somebodyverysecret")
    _write(leak_tree, "pkg/leaky.py", f"# {secret_path_fragment}/data\n")
    rc = leak_scan.main(["pkg", "--repo-root", str(leak_tree)])
    captured = capsys.readouterr()
    assert rc == 1
    assert secret_path_fragment not in captured.out
    assert secret_path_fragment not in captured.err
    assert "pkg/leaky.py:1: home_path match" in captured.out


def test_leak_scan_cli_exit_codes(leak_tree):
    _write(leak_tree, "pkg/clean.py", "x = 1\n")
    assert leak_scan.main(["pkg", "--repo-root", str(leak_tree)]) == 0

    _write(leak_tree, "pkg/leaky.py", f"# {_home_path_sample('x')}\n")
    assert leak_scan.main(["pkg", "--repo-root", str(leak_tree)]) == 1

    assert leak_scan.main(["does-not-exist", "--repo-root", str(leak_tree)]) == 2


def test_leak_scan_skips_binary_and_generated_files(leak_tree):
    one_token = base64.b64decode(leak_scan._AI_VENDOR_TOKENS_B64[0]).decode("ascii")
    _write(leak_tree, "pkg/data.sqlite3", one_token)  # wrong suffix for a text scan
    _write(leak_tree, "pkg/__pycache__/data.pyc", one_token)
    result = leak_scan.scan(["pkg"], repo_root=str(leak_tree))
    assert result.ok


def test_leak_scan_runs_clean_against_the_real_mcp_tree():
    """The actual point of this whole script: run it against this package's
    own real, checked-in source tree and confirm it is clean. No
    denylist-file is configured here (this test does not know, and must
    not try to discover, the private solver-arc repository's real name —
    see leak_scan.py's own module docstring) — this run therefore checks
    the three categories that do not need one, honestly, not all four."""
    result = leak_scan.scan(["toledo_mcp", "scripts", "tests"], repo_root=str(MCP_DIR))
    assert result.ok, [
        f"{f.path}:{f.line}: {f.category}" for f in result.findings
    ]


# ---------------------------------------------------------------------------
# .gitignore
# ---------------------------------------------------------------------------

def test_gitignore_covers_generated_and_runtime_directories():
    text = GITIGNORE_PATH.read_text(encoding="utf-8")
    for pattern in ("proposals/", "dist/", "__pycache__/", ".pytest_cache/", "state/*.sqlite3"):
        assert pattern in text, f"mcp/.gitignore is missing the {pattern!r} pattern"
