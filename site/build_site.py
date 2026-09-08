#!/usr/bin/env python3
"""
site/build_site.py — Toledo public site generator (stream S1, site/DESIGN.md).

Founder instruction BBL-2026-09-07-222: the site at
https://morrocwi.github.io/toledo/ must be a presentable public website a
human reader understands at once and an AI agent can use immediately. Full
specification: site/DESIGN.md; the exact placeholder contract this module
fills is site/templates/PLACEHOLDERS.md (stream S2's own contract doc) —
every context builder below is named and shaped to match it field for
field. This module implements stream S1 only (DESIGN.md sec.11): the
generator itself, plus the generated data files under site/data/. Templates
(site/templates/, site/assets/) are stream S2's files; the CI wiring and
/agents/ authored copy are stream S3's; tests and checks are stream S4's —
this module never writes to any of those paths, and reads them only as
inputs.

`{{root}}` (PLACEHOLDERS.md's own explanation, restated here since it drives
this file's `root_prefix()`): the site is served under a project subpath
(morrocwi.github.io/toledo/), not a domain root, so every internal link is
prefixed with a relative `..`-count computed from how many directories deep
the page being written sits below the site root — never a literal
`/assets/...`-style absolute path.

No third-party template engine (stdlib-only `{{field}}` substitution, no
loops/conditionals inside a template — any repeated content is assembled as
one HTML string in Python first, per one placeholder). No network calls at
build time. Every number is computed here from the registry / mcp/README.md
/ CITATION.cff at build time; nothing is hand-typed into a template.
"""
from __future__ import annotations

import argparse
import collections
import datetime
import glob
import html
import json
import pathlib
import re
import subprocess
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
SITE_DIR = REPO_ROOT / "site"
DEFAULT_OUT = SITE_DIR / "dist"
DEFAULT_DATA_DIR = SITE_DIR / "data"
DEFAULT_TEMPLATES_DIR = SITE_DIR / "templates"

# --------------------------------------------------------------------------
# sec.5 — the mangling fix. Two distinct, deliberately different manglings:
#   site-slug   (hyphen kept)    — human-facing site URLs, on-disk vault/
#                                  and registry/entries/ file names.
#   api-mangled (hyphen stripped) — mcp/toledo_mcp/export_static.py's own
#                                  /v1/entries/<...>.json file names.
# Any link into /v1/... MUST use api-mangled (mangle_code, imported below),
# never site-slug. Zero edits to export_static.py: it already exports the
# function this module needs.
# --------------------------------------------------------------------------
try:
    from mcp.toledo_mcp.export_static import mangle_code
except ImportError:
    sys.path.insert(0, str(REPO_ROOT / "mcp"))
    from toledo_mcp.export_static import mangle_code  # noqa: E402


def _old_vault_mangle(code: str) -> str:
    """Renamed from this file's original `code_safe()` (DESIGN.md sec.5).
    This is the **site-slug** mangling (hyphen kept) — the existing vault/
    and registry/entries/ on-disk convention, reused unchanged for the
    human-facing /entries/<site-slug>.html URL and for a bare root code's
    own /by-root/<root-slug>/ directory name. Must NEVER be used to
    construct a /v1/... URL — use the imported `mangle_code` for that."""
    return code.replace("/", "__").replace(".", "_")


site_slug = _old_vault_mangle


# --------------------------------------------------------------------------
# Natural code order (DESIGN.md sec.3): "root, then domain letter, then
# sequence number, then revision — the same order registry/SCHEMA.md's code
# grammar implies and the catalogue PDF already uses." Mirrors
# scripts/toledo_build.py::natural_key (reimplemented here rather than
# imported — that script is a standalone tool, not a package, outside this
# stream's read/import contract).
# --------------------------------------------------------------------------
_DIGIT_RUN_RE = re.compile(r"(\d+)")


def natural_key(code: str):
    key = []
    for part in _DIGIT_RUN_RE.split(code):
        if part == "":
            continue
        key.append((1, int(part)) if part.isdigit() else (0, part.lower()))
    return key


DOMAIN_NAMES = {
    "E": "epistemic", "H": "human–AI", "S": "social", "W": "world-system",
    "M": "method", "P": "physics", "C": "chemistry", "B": "biology/health",
}


# --------------------------------------------------------------------------
# Plain-language glossary (R1 re-review finding tier-status-jargon-unexplained):
# a reader landing on a badge like "Ax", "root_layer_unwired", or "unverified"
# with zero explanation cannot tell a proved theorem from an open hypothesis.
# Every sentence below is a restatement of wording already published in
# README.md ("The coq_status ladder" section) or registry/SCHEMA.md (the
# tier/coq/status enum rows and their v1.1/v1.2 addenda) — no new meaning is
# introduced here, only the existing one surfaced on the site itself. Used as
# a badge `title` attribute, the /about/ definition list, and the top-of-page
# note on every /by-tier/<v>/ and /by-status/<v>/ listing page.
# --------------------------------------------------------------------------
TIER_DEFINITIONS = {
    "Th_coqc": "Machine-checked and axiom-free: closed under the global context in Coq's own "
               "Print Assumptions output — an internal-consistency check, never an empirical or "
               "physical truth claim (README, \"The coq_status ladder\").",
    "Definition": "A formal Definition/Fixpoint/Inductive-style restatement, with no theorem "
                  "attached — nothing here is \"closed\" or \"open\", it is a restatement, not a "
                  "claim (registry/SCHEMA.md).",
    "Dr": "An Open/Dr hypothesis: the source itself proposes this as a reasoned claim without a "
          "machine-checked proof, carried forward exactly as stated (registry/SCHEMA.md's "
          "open_prop addendum).",
    "Open": "An open, unresolved hypothesis or question, carried forward exactly as open, never "
            "forced to a proof (registry/SCHEMA.md's open_prop addendum).",
    "Ax": "The source states this as an axiom (assumed, not derived), or a proved result whose "
          "closure depends on a disclosed axiom — never claimed as unconditionally closed "
          "(docs/EQ_CODE_SCHEME.md's Theta/CMC addendum).",
    "finite_diagnostic": "A diagnostic check confirmed over a finite model or dataset, distinct "
                         "from a machine-checked proof — the source's own tag, preserved as "
                         "stated.",
    "untagged": "The source gave no tier at all for this reading — recorded honestly as untagged "
                "rather than guessed (README.md).",
    "RETRACTED": "The source itself retracted this root; the code stays reserved and is shown, "
                 "never silently removed, so the correction stays visible "
                 "(docs/MEETING_2026-09-06_toledo_design.md, T14).",
}

COQ_STATUS_DEFINITIONS = {
    "closed": "The entry's own Toledo-native Coq file states at least one Theorem/Lemma/"
              "Corollary/Example/Remark that verify.sh reports \"Closed under the global "
              "context\" for the entry's own statement — the only status that certifies a proof "
              "(README, \"The coq_status ladder\").",
    "definition": "The entry's own file states a typed Definition/Record in a finite model, with "
                  "no theorem attached; there is nothing here to be \"closed\" or \"open\" — a "
                  "formal restatement, not a claim (README, \"The coq_status ladder\").",
    "wrapped_related": "A Toledo-named wrapper file exists and builds, but it only aliases or "
                       "specialises an identifier imported from another repository; it does not "
                       "independently close the entry's own statement (README, \"The coq_status "
                       "ladder\").",
    "mapped_not_wrapped": "An evidence-backed match against an imported Coq identifier exists, "
                          "but no Toledo-native wrapper file has been written yet — an honest "
                          "middle state between no evidence at all and a wrapped/closed proof "
                          "(README, \"The coq_status ladder\").",
    "open_prop": "An Open/Dr hypothesis stated as an unproved Definition …_hyp : Prop, carried "
                "forward exactly as open, never forced to a proof (README, \"The coq_status "
                "ladder\").",
    "not_formalisable": "No formal content exists in the source for this entry; the reason is "
                        "recorded per-entry rather than asserted without it (README, \"The "
                        "coq_status ladder\").",
    "axioms": "This is a literal Coq Axiom declaration, disclosed and quoted from its source — "
             "assumed, not derived, and never pushed to closed/wrapped_related/mapped_not_wrapped "
             "without further evidence (registry/SCHEMA.md's root-layer addendum).",
    "root_layer_unwired": "This Layer-0 root has no Coq wiring of its own yet — a separate, "
                          "not-yet-done stream from the readings' own resolved ladder, never "
                          "itself evidence of closed/wrapped_related/mapped_not_wrapped "
                          "(registry/SCHEMA.md's root-layer addendum).",
    "none": "No Coq status has been recorded for this entry — Coq assessment has not yet reached "
           "it (registry/SCHEMA.md's base coq_status enum).",
}

# The `status` field's own enum (registry/SCHEMA.md line 38) — shown on the
# /by-status/<v>/ listing pages, whose axis is this field, not coq_status.
STATUS_DEFINITIONS = {
    "current": "This entry's statement is the standing wording, with no caveat on record.",
    "superseded_by": "A newer entry replaces this one; see status_note / the referenced code for "
                     "which one.",
    "split": "This entry's content has been reorganised into more than one entry; see status_note.",
    "not_an_equation": "This record points to prose, not a formula — never presented as one "
                       "(README's verdict rule 4).",
    "historical": "Kept for the historical record; not the standing statement — see status_note.",
    "unverified": "The source stated a tier for this reading, but no Coq identifier for it was "
                 "located, so the tier is kept as the source states and the status is marked "
                 "unverified (registry/SCHEMA.md's tier_evidence addendum).",
    "imprecise_as_stated": "The statement as recorded is imprecise; see status_note for the "
                          "detail.",
}

# --------------------------------------------------------------------------
# Resistance Ladder (design/RESISTANCE_LADDER_v0_1.md sec.1/sec.5, founder
# ruling BBL-2026-09-07-229): R0-R6, a SET of rungs held per entry, each
# backed by a file on disk — never a single collapsed score. Every sentence
# below is the same "what it does NOT certify" wording the design doc's own
# sec.1 table states, restated on the site as a badge `title=` attribute the
# same way TIER_DEFINITIONS/COQ_STATUS_DEFINITIONS already are. The `held`
# value itself is never computed here — it is read verbatim from the
# `resistance` block scripts/compute_resistance.py wrote into
# registry/CANONICAL.json / registry/genesis_root.json; this module only
# renders what that field already says.
# --------------------------------------------------------------------------
RESISTANCE_DEFINITIONS = {
    "R0": "Stated: a written statement exists for this code. Certifies nothing beyond \"this was "
          "written down\" — every entry holds R0 trivially, so a reader never mistakes a bare "
          "stated equation for a checked one.",
    "R1": "Pre-registered falsifier or claim boundary, declared before the run/observation it "
          "constrains. Certifies only that a boundary was drawn ahead of the evidence — not that "
          "it is a good one, or that anyone has tried to defeat the claim yet.",
    "R2": "Coq-closed: a machine-checked proof whose kernel sits outside the AI/human authoring "
          "loop. Certifies internal consistency of a finite formal model — never that the model "
          "matches the world.",
    "R3": "Reproducible run: a hash-frozen command with recorded input/output hashes and AI = 0 "
          "at runtime. Certifies the run is pinned and independently re-runnable — not that its "
          "result matched anything; a card can hold R3 even when its own result is a disclosed "
          "FAIL.",
    "R4": "External oracle: the run's output was compared to a published value, an independent "
          "implementation, or a public dataset, against a tolerance declared before the run. "
          "Certifies the comparison itself happened, honestly, PASS or FAIL alike — never that "
          "it passed.",
    "R5": "Independent reviewer (I2 or above) or interactional-expert record naming this code. "
          "Certifies that an independent human/route actually looked — not that they reached a "
          "favourable verdict.",
    "R6": "AOWC world record: an external-oracle card additionally frozen before the run, AI = 0 "
          "for both execution and evaluation, with a tolerance able to genuinely count against "
          "the claim. Certifies the test could have failed the claim — never that the outcome "
          "was the one hoped for.",
}

RUNG_ORDER = ["R0", "R1", "R2", "R3", "R4", "R5", "R6"]


# --------------------------------------------------------------------------
# Executable equations — site try-it widget (S4, docs/EXECUTABLE_EQUATIONS_
# v0_1.md sec.7). A narrow, opt-in, human-reviewed subset: the widget is
# rendered ONLY on an entry page whose computed `executable.status` (sec.3.1,
# written by scripts/compute_executable.py, S3) is one of the two values
# below — every other entry page is unchanged, no stub, no "coming soon"
# placeholder (sec.13 item 3).
# --------------------------------------------------------------------------
EXECUTABLE_WIDGET_STATUSES = frozenset({"reviewed_eligible", "built"})

# The one and only domain-honesty sentence (sec.1.4), quoted verbatim
# wherever an `executable` coverage number is shown (once per page, per
# sec.1.4's own "not a footnote nobody reads" requirement) — /browse/'s new
# column and /about/'s corpus-wide tally both use this exact string so
# neither can drift from the other.
EXECUTABLE_DOMAIN_HONESTY_NOTE = (
    "S (social), E (epistemic), W (world-system) and H (human&ndash;AI) are legitimately mostly "
    "comparative, definitional, and relational statements, not numeric relations — a low or zero "
    "executable count there is not a quality or completeness signal relative to P/B/C/M."
)

# The widget's own inline computation script — one shared template string,
# never generated per entry (sec.5/sec.13 item 1); only `__WIDGET_ID_JSON__`
# varies per entry page, substituted via a plain string replace (never
# `.format`/an f-string here — the JS body's own literal `{`/`}` pairs would
# have to be doubled everywhere otherwise, which is exactly the kind of
# per-entry hand-editing this feature is designed to avoid). Calls the two
# shared kernel files' own real exported API (site/static/js/_qfrac.js's
# `QFrac.fromString`/`toDecimalString`, site/static/js/_ir_eval.js's
# `ToledoIREval.evalNode`/`DEFAULT_TERMS`, both S2) — never a re-implemented
# third walker (sec.13 item 4).
_EXECUTABLE_WIDGET_JS = """
(function () {
  var widget = document.getElementById(__WIDGET_ID_JSON__);
  if (!widget || !window.QFrac || !window.ToledoIREval) { return; }
  var irScript = widget.querySelector('script[data-executable-ir]');
  var form = widget.querySelector('form[data-executable-form]');
  var out = widget.querySelector('[data-executable-result]');
  if (!irScript || !form || !out) { return; }
  var ir = JSON.parse(irScript.textContent);
  form.addEventListener('submit', function (ev) {
    ev.preventDefault();
    try {
      var env = {};
      var inputs = widget.querySelectorAll('input[data-exec-var]');
      for (var i = 0; i < inputs.length; i++) {
        var name = inputs[i].getAttribute('data-exec-var');
        var raw = inputs[i].value.trim();
        if (!raw) { throw new Error('"' + name + '" is empty'); }
        env[name] = window.QFrac.fromString(raw);
      }
      var terms = (ir.transcendental && ir.transcendental.default_terms)
        || window.ToledoIREval.DEFAULT_TERMS;
      var result = window.ToledoIREval.evalNode(ir.rhs, env, terms);
      var exact = result.toString();
      var approx = result.toDecimalString(20);
      out.textContent = 'result = ' + exact
        + ' (decimal display only, not the computed value: ' + approx + ')';
    } catch (e) {
      out.textContent = 'could not compute: ' + (e && e.message ? e.message : e);
    }
  });
})();
"""


def render_executable_widget_html(entry: dict, root: pathlib.Path, depth: int) -> str:
    """The site try-it widget (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.7).
    Offline-first, per site/DESIGN.md's own standing constraint: a plain
    `<form>` that does nothing with JavaScript disabled; with it enabled,
    computes in-browser via the two permanent, same-origin kernel files
    (never fetched again per entry) against the entry's own IR, embedded
    inline at BUILD TIME — never fetched over the network at widget run
    time. Reads S1's IR sidecar via the entry's own `executable.ir_ref`
    (read-only; this module never writes registry/executable/); returns ""
    (no section at all) unless `executable.status` is `reviewed_eligible`/
    `built` AND that sidecar file actually resolves and parses — a dangling
    reference is a data problem for S1/S3 to fix, never a broken page."""
    executable = entry.get("executable") or {}
    if executable.get("status") not in EXECUTABLE_WIDGET_STATUSES:
        return ""
    ir_ref = executable.get("ir_ref")
    if not ir_ref:
        return ""
    try:
        ir = json.loads((root / ir_ref).read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError, UnicodeDecodeError):
        return ""

    input_vars = [v for v in (ir.get("variables") or []) if v.get("role") == "input" and v.get("name")]
    if not input_vars:
        return ""
    sample = (ir.get("sample_inputs") or [{}])
    sample0 = sample[0] if sample else {}

    prefix = root_prefix(depth)
    fields_html = "".join(
        '<p class="executable-field">'
        f'<label for="exec-in-{html.escape(v["name"])}"><code>{html.escape(v["name"])}</code> '
        f'<span class="note">(domain {html.escape(v.get("domain", "Q"))})</span></label> '
        f'<input type="text" id="exec-in-{html.escape(v["name"])}" '
        f'data-exec-var="{html.escape(v["name"])}" '
        f'value="{html.escape(str(sample0.get(v["name"], "")))}" '
        'autocomplete="off" inputmode="text"></p>'
        for v in input_vars
    )
    ir_json_safe = json.dumps(ir, ensure_ascii=False).replace("</script", "<\\/script")

    reproduction_card = executable.get("reproduction_card") or {}
    citation = reproduction_card.get("citation") or {}
    if citation.get("path"):
        commit = str(citation.get("commit") or "")[:12]
        card_note = (
            f'filed Reproduction Card: <code>{html.escape(str(citation.get("repo", "")))}'
            f'{"@" + html.escape(commit) if commit else ""} '
            f'{html.escape(str(citation.get("path", "")))}</code>'
        )
    else:
        card_note = "no filed Reproduction Card yet for this entry"

    widget_id = f"executable-widget-{html.escape(mangle_code(entry['code']))}"
    widget_js = _EXECUTABLE_WIDGET_JS.replace("__WIDGET_ID_JSON__", json.dumps(widget_id))

    return (
        '<h2>Try it</h2>'
        f'<div class="executable-widget" id="{widget_id}">'
        f'<script type="application/json" data-executable-ir="true">{ir_json_safe}</script>'
        '<form data-executable-form="true" autocomplete="off">'
        f'{fields_html}'
        '<button type="submit">Compute</button>'
        '</form>'
        '<p class="executable-result" data-executable-result="true" aria-live="polite"></p>'
        '<p class="note">Not a Reproduction Card &mdash; a live convenience check. '
        f'The evidence for this entry is: {card_note}.</p>'
        '</div>'
        f'<script src="{prefix}/static/js/_qfrac.js"></script>'
        f'<script src="{prefix}/static/js/_ir_eval.js"></script>'
        f'<script>{widget_js}</script>'
    )


def _glossary_dl_html(*definition_groups: tuple[str, dict[str, str]]) -> str:
    """One `<dl>` per (heading, {value: sentence}) group, in dict order —
    the shared builder for the /about/ definition list and the landing
    page's "How to read a status" box, so the two can never drift apart."""
    parts = []
    for heading, values in definition_groups:
        rows = "".join(
            f"<dt><code>{html.escape(v)}</code></dt><dd>{html.escape(sentence)}</dd>"
            for v, sentence in values.items()
        )
        parts.append(f"<h3>{html.escape(heading)}</h3><dl>{rows}</dl>")
    return "".join(parts)


def _definition_title_attr(value: str | None, *definitions: dict[str, str]) -> str:
    """`title="..."` attribute text for a badge, looked up across one or more
    definition dicts in order — empty string when the value has no known
    definition (never a fabricated one)."""
    if not value:
        return ""
    for d in definitions:
        if value in d:
            return f' title="{html.escape(d[value])}"'
    return ""


def root_prefix(depth: int) -> str:
    """The `{{root}}` value for a page `depth` directories below the site
    root (0 = site root itself). Always relative (PLACEHOLDERS.md) — this
    site is deployed under a repository subpath, not a domain root."""
    return "." if depth == 0 else "/".join([".."] * depth)


# --------------------------------------------------------------------------
# IO helpers
# --------------------------------------------------------------------------
def _load_json(path: pathlib.Path):
    with open(path, encoding="utf-8") as fh:
        return json.load(fh)


def _write_json(path: pathlib.Path, doc: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(doc, fh, indent=2, ensure_ascii=False, sort_keys=False)
        fh.write("\n")


def _utc_now_iso() -> str:
    return datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _human_date(iso_ts: str | None) -> str:
    if not iso_ts:
        return "unknown"
    try:
        dt = datetime.datetime.strptime(iso_ts, "%Y-%m-%dT%H:%M:%SZ")
    except ValueError:
        return iso_ts
    return dt.strftime("%Y-%m-%d %H:%M UTC")


def _git_commit(root: pathlib.Path) -> str | None:
    """Best-effort, read-only `git rev-parse HEAD`. Never raises — mirrors
    export_static.py's own tolerant pattern, reimplemented here rather than
    imported (that helper is underscore-private; sec.5's import allowance
    names `mangle_code` only)."""
    try:
        proc = subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=str(root), capture_output=True,
            text=True, timeout=5, check=False,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    if proc.returncode != 0:
        return None
    return proc.stdout.strip() or None


def _citation_field(root: pathlib.Path, field: str) -> str | None:
    """Read-only parse of one top-level `field:` line from root CITATION.cff
    — the same technique export_static.py uses independently for `version:`.
    Used for `version:` (registry_release_version) and `doi:` (the Zenodo
    concept DOI on /about/). Deliberately NOT read from mcp/dist/static-api:
    build-site and export-static are two separate CI jobs (sec.8) precisely
    so neither can block the other."""
    p = root / "CITATION.cff"
    if not p.exists():
        return None
    pattern = r"^{field}:\s*\"?([^\"\n]+)\"?\s*$".format(field=re.escape(field))
    m = re.search(pattern, p.read_text(encoding="utf-8"), re.MULTILINE)
    return m.group(1) if m else None


# --------------------------------------------------------------------------
# Registry reads
# --------------------------------------------------------------------------
def load_entries(root: pathlib.Path) -> tuple[list[dict], dict[str, str]]:
    """Every registry/entries/<site-slug>.json file — the single read this
    module performs to render every /entries/ page, every listing row, the
    search index, and the sec.9 coverage tallies (no second pass over the
    registry for any of those). Returns (entries, raw_text_by_code): the
    raw file text is kept so the entry page's embedded JSON-LD can embed
    the file's own bytes verbatim (PLACEHOLDERS.md: "do not re-serialize or
    reformat it") rather than a Python re-dump of the parsed dict."""
    files = sorted(glob.glob(str(root / "registry" / "entries" / "*.json")))
    entries: list[dict] = []
    raw_by_code: dict[str, str] = {}
    for f in files:
        path = pathlib.Path(f)
        raw_text = path.read_text(encoding="utf-8")
        e = json.loads(raw_text)
        if "code" not in e:
            raise SystemExit(f"registry/entries file missing 'code': {f}")
        entries.append(e)
        raw_by_code[e["code"]] = raw_text
    return entries, raw_by_code


def load_canonical_counts(root: pathlib.Path) -> dict:
    """registry/CANONICAL.json's own `counts{}` block only — never the full
    canonical[] array. sec.4: "every field read from registry/CANONICAL.json's
    own counts{}". This block counts canonical[] (layer=="reading") entries
    only; a by-tier/by-status enum value that only ever occurs on a Layer-0
    root row (e.g. `RETRACTED` tier, `historical` status) is therefore never
    one of this dict's keys — driving listing-page existence from these
    keys (see build_pages) is what keeps a /by-tier/ or /by-status/ page
    from ever existing for a value with zero *readings*, even when some
    *root* row happens to carry it."""
    p = root / "registry" / "CANONICAL.json"
    doc = _load_json(p)
    return doc.get("counts", {})


def _parse_tools_table_from_readme(root: pathlib.Path) -> list[dict]:
    """Parse mcp/README.md's own `## Tools (N)` markdown table — sec.4:
    "parsed at build time ..., not hand-copied". Deliberately the exact
    same cell-splitting algorithm tests/test_site.py's own independent
    re-parse uses (naive `str.split("|")`, no backslash-escape awareness:
    a purpose cell containing a literal `\\|` is truncated at that pipe),
    so this file and that test's from-scratch parse of the same input can
    never disagree — matching the test's own contract takes precedence
    here over a "more correct" escape-aware split."""
    text = (root / "mcp" / "README.md").read_text(encoding="utf-8")
    m = re.search(r"## Tools \(\d+\)\n\n(\|.*?\n)(?:\n|\Z)", text, re.DOTALL)
    if not m:
        raise SystemExit("mcp/README.md: '## Tools (N)' section not found")
    rows: list[dict] = []
    for line in m.group(1).splitlines():
        if not line.startswith("|"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if len(cells) < 2:
            continue
        tool, purpose = cells[0], cells[1]
        if tool in ("Tool", "---") or set(tool) <= {"-"}:
            continue
        rows.append({"tool": tool.strip("`"), "purpose": purpose})
    _m = re.search(r"^## Tools \((\d+)\)", text, flags=re.M)
    expected = int(_m.group(1)) if _m else len(rows)
    if len(rows) != expected:
        raise SystemExit(
            f"mcp/README.md '## Tools (N)' table parsed to {len(rows)} rows, but its heading says {expected} "
            "— build_tools_table()'s regex and the README table have drifted apart"
        )
    for row in rows:
        if not re.match(r"^toledo_[a-z_]+$", row["tool"]):
            raise SystemExit(f"mcp/README.md Tools table: unexpected tool name {row['tool']!r}")
    return rows


# --------------------------------------------------------------------------
# sec.9 — honest coverage disclosure, computed from the same entries list
# this module already loaded to render pages (no second pass).
# --------------------------------------------------------------------------
def compute_coverage(entries: list[dict]) -> dict:
    mathml_present = 0
    mathml_reason_only = 0
    fmt_counts: collections.Counter = collections.Counter()
    for e in entries:
        if e.get("presentation_mathml"):
            mathml_present += 1
        elif e.get("presentation_mathml_reason"):
            mathml_reason_only += 1
        fmt = (e.get("statement") or {}).get("format")
        if fmt:
            fmt_counts[fmt] += 1
    return {
        "mathml_present": mathml_present,
        "mathml_reason_only": mathml_reason_only,
        "statement_format_counts": dict(fmt_counts),
    }


def coverage_html(coverage: dict, total: int) -> str:
    """Shared /about/ + /agents/ fragment (PLACEHOLDERS.md: "identical
    fragment ... build it once, reuse it") — computed from live counts,
    never a rounded-up claim. No priority/marketing words."""
    mathml = (
        f"<p>{coverage['mathml_present']} of {total} entries carry pre-generated MathML; "
        "the rest fall back to KaTeX&rsquo;s own MathML output at render time, or plain text "
        "with no JavaScript.</p>"
    )
    fc = coverage["statement_format_counts"]
    order = ["ascii-math", "latex+ascii", "latex", "coq", "prose"]
    parts = " &middot; ".join(f"{html.escape(k)} {fc.get(k, 0)}" for k in order if k in fc)
    fmt = f"<p>By statement format (of {total} entries): {parts}.</p>"
    return mathml + fmt


def coverage_sentences(coverage: dict, total: int) -> dict[str, str]:
    """Same two facts as `coverage_html`, as plain (unwrapped-in-`<p>`)
    sentences — one observed about/agents template shape wants them as two
    separate `{{mathml_sentence}}`/`{{statement_format_sentence}}`
    placeholders it wraps in its own `<p class="lede">`, rather than the
    single combined `{{coverage_html}}` fragment."""
    mathml = (
        f"{coverage['mathml_present']} of {total} entries carry pre-generated MathML; "
        "the rest fall back to KaTeX's own MathML output at render time, or plain text "
        "with no JavaScript."
    )
    fc = coverage["statement_format_counts"]
    order = ["ascii-math", "latex+ascii", "latex", "coq", "prose"]
    parts = " · ".join(f"{k} {fc.get(k, 0)}" for k in order if k in fc)
    fmt = f"By statement format (of {total} entries): {parts}."
    return {"mathml_sentence": mathml, "statement_format_sentence": fmt}


# --------------------------------------------------------------------------
# Manifest (sec.4)
# --------------------------------------------------------------------------
def build_manifest(canonical_counts: dict, coverage: dict, registry_release_version: str | None,
                    generated_from_commit: str | None) -> dict:
    return {
        "generated_at": _utc_now_iso(),
        "generated_from_commit": generated_from_commit,
        "registry_release_version": registry_release_version,
        "entry_count": canonical_counts.get("entries", 0),
        "counts_by_status": dict(canonical_counts.get("by_status", {})),
        "counts_by_domain": dict(canonical_counts.get("by_domain", {})),
        "counts_by_tier": dict(canonical_counts.get("by_tier", {})),
        "counts_by_coq_status": dict(canonical_counts.get("by_coq_status", {})),
        "mathml_present": coverage["mathml_present"],
        "mathml_reason_only": coverage["mathml_reason_only"],
        "statement_format_counts": coverage["statement_format_counts"],
    }


# --------------------------------------------------------------------------
# Search index (sec.4 / sec.12)
# --------------------------------------------------------------------------
_LATEX_MACRO_RE = re.compile(r"\\[a-zA-Z]+")
_WS_RE = re.compile(r"\s+")


def _strip_markup(text: str) -> str:
    """Mechanical LaTeX/ascii-math markup stripper for a search excerpt —
    not a renderer, just enough to leave plain words for substring
    matching (sec.4: "LaTeX/ascii-math markup stripped to plain words")."""
    text = _LATEX_MACRO_RE.sub(" ", text)
    text = text.translate(str.maketrans("", "", "{}$\\"))
    return _WS_RE.sub(" ", text).strip()


def build_search_index(entries: list[dict]) -> list[dict]:
    rows = []
    for e in entries:
        coq_status = (e.get("coq") or {}).get("coq_status", "")
        latest = (e.get("statement") or {}).get("latest", "") or ""
        rows.append({
            "code": e["code"], "name": e.get("name", ""), "root": e.get("root", ""),
            "domain": e.get("domain"), "tier": e.get("tier", ""),
            "status": e.get("status", ""), "coq_status": coq_status,
            "excerpt": _strip_markup(latest)[:140],
        })
    return rows


# --------------------------------------------------------------------------
# Template substitution helper — "a small stdlib-only substitution helper
# (no Jinja2)". A template is plain text; `{{name}}` is replaced by
# str(context[name]) verbatim (the caller is responsible for escaping
# whatever HTML it puts in the context — every builder below does that).
# --------------------------------------------------------------------------
_PLACEHOLDER_RE = re.compile(r"\{\{\s*([a-zA-Z0-9_]+)\s*\}\}")


def substitute(template_text: str, context: dict) -> tuple[str, list[str]]:
    unresolved: list[str] = []

    def _sub(m: re.Match) -> str:
        key = m.group(1)
        if key not in context:
            unresolved.append(key)
            return m.group(0)
        val = context[key]
        return "" if val is None else str(val)

    return _PLACEHOLDER_RE.sub(_sub, template_text), unresolved


class TemplateStore:
    """Loads site/templates/*.tmpl.html on demand, caching each file and
    collecting which ones were missing so a partial build still produces a
    clear, actionable report instead of a bare traceback."""

    def __init__(self, templates_dir: pathlib.Path):
        self.dir = templates_dir
        self._cache: dict[str, str] = {}
        self.missing: set[str] = set()

    def get(self, name: str) -> str | None:
        if name in self._cache:
            return self._cache[name]
        path = self.dir / name
        if not path.exists():
            self.missing.add(name)
            return None
        text = path.read_text(encoding="utf-8")
        self._cache[name] = text
        return text

    def render(self, name: str, context: dict) -> tuple[str | None, list[str]]:
        text = self.get(name)
        if text is None:
            return None, []
        return substitute(text, context)

    def render_with_base(self, inner_name: str, inner_context: dict,
                          base_context: dict) -> tuple[str | None, list[str]]:
        # base_context's own fields (title/description/root/page_class/
        # katex_*/generated_at*) are also passed into the INNER template's
        # own render call, since several observed inner-template shapes
        # reference {{root}} (and similar) directly in their own body, not
        # only inside base.tmpl.html — inner_context values win on overlap.
        inner_full_context = {**base_context, **inner_context}
        inner_html, inner_unresolved = self.render(inner_name, inner_full_context)
        if inner_html is None:
            return None, inner_unresolved
        merged = dict(base_context)
        merged["content"] = inner_html
        page_html, base_unresolved = self.render("base.tmpl.html", merged)
        return page_html, inner_unresolved + base_unresolved


# --------------------------------------------------------------------------
# Founder constraint: every index-shaped page (home, browse, search,
# agents, about, every listing page) stays under 200 KB uncompressed HTML.
# Duplicated intentionally rather than imported from site/checks/
# check_perf_budget.py — that module is stream S4's, checking this one's
# output; sharing a constant across the two would let one silently drift
# without the other noticing (the same reasoning natural_key() above
# gives for not importing scripts/toledo_build.py).
PERF_BUDGET_BYTES = 200 * 1024

# KaTeX assets (founder constraint: "self-hosted except KaTeX from a CDN
# with SRI"; `output: 'htmlAndMathml'` explicit, never the library default).
# Version + both SRI hashes are exactly PLACEHOLDERS.md's own verified
# block (independently re-verified in this session: direct byte download +
# SHA-512 recompute against all three files at cdnjs, matched exactly).
# --------------------------------------------------------------------------
KATEX_HEAD = (
    '<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.css"\n'
    '  integrity="sha512-eLvr2vghJzBvLDxpgIyx3qrDj1chzZfD4SPOE4otnJPa6GsyJ/lBDGFhZO8OsmyYNnqqjqXOSjHAV1cBax33oA=="\n'
    '  crossorigin="anonymous">'
)
KATEX_SCRIPTS = (
    '<script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.js"\n'
    '  integrity="sha512-yRrA0fXbfdjHDJXBxj4ABSlaLGZk5HOm5qpvXx6GEjR1t5yCLdenOvN9hzHZhrznHyHVKuIK+QltSR4gc//lQA=="\n'
    '  crossorigin="anonymous"></script>\n'
    '<script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/contrib/auto-render.min.js"\n'
    '  integrity="sha512-0HzJcHCD+wBh9kNUUcm3DWH9IbNDfudsYyMD5EHwSuFK6aEsaa/UEPqqk4t0pm4bbmwR6A11yNsD7Q+nz6XF+Q=="\n'
    '  crossorigin="anonymous"></script>\n'
    "<script>\n"
    "document.addEventListener('DOMContentLoaded', function () {\n"
    "  if (window.renderMathInElement) {\n"
    "    renderMathInElement(document.body, {\n"
    "      delimiters: [\n"
    "        {left: '\\\\[', right: '\\\\]', display: true},\n"
    "        {left: '$', right: '$', display: false}\n"
    "      ],\n"
    "      output: 'htmlAndMathml',\n"
    "      throwOnError: false\n"
    "    });\n"
    "  }\n"
    "});\n"
    "</script>"
)

# Mermaid, same CDN-with-SRI carve-out as KaTeX above (DESIGN.md's own
# "every asset is self-hosted except KaTeX from a CDN with SRI" constraint
# is extended here for the one other diagram-rendering library the site
# needs, /ecosystem/'s flowchart — same cdnjs host already allow-listed for
# KaTeX, pinned version, SRI verified by direct byte download + SHA-512
# recompute against the actual served file, same discipline as
# PLACEHOLDERS.md's KaTeX block above). No mermaid-CLI (`mmdc`) is
# installed on this machine to pre-render the diagram to a static SVG at
# build time instead (checked: `which mmdc` — not found), so this is
# client-side rendering, not a build-time SVG — the page's raw diagram
# source stays visible as ordinary text inside the `<pre class="mermaid">`
# element for no-JS readers, matching every other statement-rendering path
# on this site (KaTeX's own `\[...\]` raw-text fallback, above).
MERMAID_HEAD = ""
MERMAID_SCRIPTS = (
    '<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/10.9.1/mermaid.min.js"\n'
    '  integrity="sha512-6a80OTZVmEJhqYJUmYd5z8yHUCDlYnj6q9XwB/gKOEyNQV/Q8u+XeSG59a2ZKFEHGTYzgfOQKYEBtrZV7vBr+Q=="\n'
    '  crossorigin="anonymous"></script>\n'
    "<script>\n"
    "document.addEventListener('DOMContentLoaded', function () {\n"
    "  if (window.mermaid) {\n"
    "    var prefersDark = window.matchMedia && "
    "window.matchMedia('(prefers-color-scheme: dark)').matches;\n"
    "    mermaid.initialize({ startOnLoad: true, securityLevel: 'strict',\n"
    "      theme: prefersDark ? 'dark' : 'default' });\n"
    "  }\n"
    "});\n"
    "</script>"
)


# --------------------------------------------------------------------------
# Row / badge rendering (shared by browse + every listing page)
# --------------------------------------------------------------------------
def _truncate(text: str, n: int) -> str:
    return text if len(text) <= n else text[: n - 1].rstrip() + "…"


def _s(v) -> str:
    """Coerce a possibly-null registry field to a string for html.escape() —
    several SCHEMA.md fields are legitimately `null` (e.g. an occurrence
    `label`, a relation `note`/`type`), not merely absent."""
    return v if isinstance(v, str) else ("" if v is None else str(v))


def _status_variant(status: str) -> str:
    """PLACEHOLDERS.md's own mapping: `current` -> `--current`;
    `unverified`/`historical`/`imprecise_as_stated` -> `--caution`;
    `superseded_by`/`split`/`not_an_equation` -> `--bad`."""
    if status == "current":
        return "current"
    if status in ("split", "not_an_equation", "superseded_by"):
        return "bad"
    return "caution"


def _executable_column_value(e: dict) -> str:
    """`/browse/`'s own `executable: yes/no` column (docs/EXECUTABLE_
    EQUATIONS_v0_1.md sec.7) — computed straight from `executable.status`
    (sec.3.1), never from any other field: "yes" only for the two statuses
    the site widget itself renders on (`reviewed_eligible`/`built`); every
    other status (`candidate`, `reviewed_rejected`) or no `executable` block
    at all is "no" — a plain binary column, the domain-honesty note (sec.1.4)
    is carried once per page, never per row."""
    status = (e.get("executable") or {}).get("status")
    return "yes" if status in EXECUTABLE_WIDGET_STATUSES else "no"


def render_listing_row(e: dict, depth: int, *, band_id: str | None = None, show_executable: bool = False) -> str:
    """No `title="<full name>"` attribute: an earlier revision duplicated
    the full (untruncated) name into a `title` attribute on every row —
    on a large listing (e.g. 899 status=="current" rows, names averaging
    ~140 escaped characters) that alone pushed the page tens of KB over
    the 200 KB index-page budget for no accessibility gain the full name
    one click away on the entry page doesn't already give. The visible
    cell still shows the truncated name; nothing here is lost, only the
    duplicate copy."""
    prefix = root_prefix(depth)
    code = e["code"]
    href = html.escape(f"{prefix}/entries/{site_slug(code)}.html")
    name = e.get("name", "") or ""
    name_short = html.escape(_truncate(name, 90))
    tier_value = _s(e.get("tier"))
    tier = html.escape(tier_value)
    tier_title = _definition_title_attr(tier_value, TIER_DEFINITIONS)
    domain = e.get("domain") or "—"
    status_value = e.get("status", "") or ""
    status_title = _definition_title_attr(status_value, STATUS_DEFINITIONS)
    status = html.escape(status_value)
    id_attr = f' id="{html.escape(band_id)}"' if band_id else ""
    executable_td = (
        f'<td class="executable-cell">{_executable_column_value(e)}</td>' if show_executable else ""
    )
    return (
        f"<tr{id_attr}>"
        f'<td class="code-cell"><a href="{href}">{html.escape(code)}</a></td>'
        f'<td data-verbatim-source="true">{name_short}</td>'
        f'<td><span class="badge badge-tier"{tier_title}>{tier}</span></td>'
        f"<td>{html.escape(str(domain))}</td>"
        f'<td><span{status_title}>{status}</span></td>'
        f"{executable_td}"
        "</tr>"
    )


TABLE_HEADER_ROW = (
    '<thead><tr><th scope="col" class="code-cell">Code</th><th scope="col">Name</th>'
    '<th scope="col">Tier</th><th scope="col">Domain</th><th scope="col">Status</th></tr></thead>'
)

# /browse/ only (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.7: "/browse/ gains
# one column") — every /by-root/, /by-domain/, /by-tier/, /by-status/
# listing page keeps the plain TABLE_HEADER_ROW above, unchanged.
TABLE_HEADER_ROW_WITH_EXECUTABLE = (
    '<thead><tr><th scope="col" class="code-cell">Code</th><th scope="col">Name</th>'
    '<th scope="col">Tier</th><th scope="col">Domain</th><th scope="col">Status</th>'
    '<th scope="col">Executable</th></tr></thead>'
)


def wrap_full_table(bare_rows_html: str, caption: str, *, header_html: str = TABLE_HEADER_ROW) -> str:
    """Wraps bare `<tr>` rows into a complete `<table>` with its own
    `<thead>`/`<caption>` — needed only when the *template itself* has no
    `<thead>` of its own for `{{rows_html}}` to drop into (this repository's
    site/templates/ has been observed mid-session in two different shapes
    for the same page: one where the template supplies `<table><thead>...`
    and `{{rows_html}}` fills only `<tbody>`, another where it does not and
    expects a complete `<table>`; `rows_html_for_table()` below detects
    which is actually on disk at build time rather than assuming one).
    `header_html` defaults to the plain 5-column header; `/browse/` passes
    `TABLE_HEADER_ROW_WITH_EXECUTABLE` for its own extra column."""
    return f"<table><caption>{html.escape(caption)}</caption>{header_html}<tbody>{bare_rows_html}</tbody></table>"


def render_rows(entries: list[dict], depth: int) -> str:
    """Bare `<tr>` concatenation — the enclosing `<table><thead>...`
    markup already lives in browse.tmpl.html / listing.tmpl.html, when that
    template supplies its own (see `wrap_full_table`)."""
    return "".join(render_listing_row(e, depth) for e in entries)


def render_rows_with_bands(entries: list[dict], depth: int, *, show_executable: bool = False) -> tuple[str, str]:
    """browse.tmpl.html: bare `<tr>` rows, each first-character band's
    first row carrying `id="band-<CHAR>"`, plus the jump-nav HTML linking
    to each band (PLACEHOLDERS.md naming: `#band-X` / `id="band-X"`).
    `show_executable` (browse-only, docs/EXECUTABLE_EQUATIONS_v0_1.md
    sec.7) adds the extra `executable: yes/no` cell to every row."""
    seen_bands: list[str] = []
    rows = []
    for e in entries:
        band = (e["code"][:1] or "?").upper()
        band_id = None
        if band not in seen_bands:
            seen_bands.append(band)
            band_id = f"band-{band}"
        rows.append(render_listing_row(e, depth, band_id=band_id, show_executable=show_executable))
    jump_nav = "".join(f'<a href="#band-{html.escape(b)}">{html.escape(b)}</a>' for b in seen_bands)
    return "".join(rows), jump_nav


# --------------------------------------------------------------------------
# Entry page context
# --------------------------------------------------------------------------
def build_reverse_relations(entries: list[dict]) -> dict:
    rev: dict = collections.defaultdict(list)
    for e in entries:
        for rel in e.get("relations") or []:
            target = rel.get("target")
            if target:
                rev[target].append({
                    "from": e["code"], "type": _s(rel.get("type")), "note": _s(rel.get("note")),
                })
    return dict(rev)


def _looks_like_real_latex(text: str) -> bool:
    """Heuristic guard against a registry `statement.format` of "latex"/
    "latex+ascii" that is actually plain English prose (a data-mislabeling
    found live on the built site, see EQUATION_SOURCE_POLICY.md's sibling
    review note and CHANGELOG): a genuine LaTeX statement almost always
    carries a backslash macro; failing that, a short symbol-only expression
    has few English words and few stopwords, while mislabeled prose reads
    like a sentence (many words, at least a couple of common stopwords).
    Registry data itself is out of scope for this module — this only
    changes how a statement already read from the registry is *rendered*."""
    if "\\" in text:
        return True
    words = re.findall(r"[A-Za-z]+", text)
    if len(words) < 6:
        return True
    stopword_hits = re.findall(
        r"\b(?:the|is|are|then|if|and|of|that|with|on|as|under|only|for|"
        r"every|not|by|per|used|here|follows|this|which)\b",
        text, re.IGNORECASE,
    )
    return len(stopword_hits) < 2


def render_statement_html(statement: dict, presentation_mathml: str | None) -> tuple[str, str, bool]:
    """Returns (statement_html_with_mathml_included, mathml_block_alone,
    needs_katex), per PLACEHOLDERS.md's "Statement rendering". The
    `\\[ ... \\]`-wrapped escaped text is itself the no-JS/no-KaTeX-CDN
    fallback (auto-render replaces it in place; a reader without it sees
    the literal source). `presentation_mathml`, when present, is a
    `<noscript>` MathML block — browsers strip `<noscript>` content when
    scripting is enabled, so it never duplicates KaTeX's own
    `htmlAndMathml` output; it exists purely for the no-JS/no-KaTeX path,
    the only source of real MathML semantics for a screen reader there.
    The mathml block is returned separately too (not only folded into the
    first value) since one observed template shape keeps it as its own
    `{{presentation_mathml_block}}` placeholder inside `.statement` rather
    than folded into `{{statement_html}}` itself."""
    fmt = statement.get("format", "")
    latest = statement.get("latest", "") or ""
    is_real_latex = fmt in ("latex", "latex+ascii") and _looks_like_real_latex(
        statement.get("latex") or latest
    )
    # `presentation_mathml` (registry/SCHEMA.md) is already a complete
    # `<math xmlns="...">...</math>` document, not an inner fragment — wrap
    # it in <noscript> only, never in a second <math> root (that would
    # nest <math><math>...</math></math>, invalid MathML). Gated on
    # `is_real_latex`: for the 81 canonical entries that are both
    # mislabeled-prose (format=="latex"/"latex+ascii" but text is a plain
    # English sentence) AND carry a pre-generated `presentation_mathml`,
    # that MathML was itself generated by mechanically wrapping the prose
    # letter-by-letter (a registry-side artefact of the same mislabeling,
    # e.g. "<mi>I</mi><mi>f</mi><mi>t</mi>..." for "If the declared..."),
    # which renders as unreadable run-together gibberish. That garbled
    # block previously still reached the no-JS/no-KaTeX `<noscript>` path
    # even after the visible statement itself was corrected to plain text
    # (R1 re-review finding nojs-mathml-mislabeled-prose-still-garbled) —
    # dropping it here for every non-real-latex branch (ascii-math, the
    # mislabeled-prose fallback, coq, prose) means those pages carry the
    # plain-text statement alone, with no duplicate garbled MathML in
    # either the JS or no-JS path.
    mathml_block = (
        f'<noscript data-verbatim-source="true">{presentation_mathml}</noscript>'
        if presentation_mathml and is_real_latex
        else ""
    )
    if is_real_latex:
        latex_src = statement.get("latex") or latest
        # Every `statement.latex` value written for `format=="latex+ascii"`
        # (registry/SCHEMA.md's 2026-09-07 v1.2-lane-S addendum; the same
        # convention scripts/toledo_build.py::statement_tex_lines documents
        # and strips before its own \[ \] wrap) is a complete, self-delimited
        # inline-math string ("$...$"), meant to stand on its own -- not a
        # bare expression for insertion into an already-open math
        # environment. Verified directly against the registry (all 424
        # `latex+ascii` entries' `latex` fields are $-wrapped; the other
        # `format=="latex"` entries carry no separate `latex` field at all,
        # so `latex_src` there is `latest` itself, never $-wrapped -- this
        # strip is therefore a no-op for that case). Left unstripped, KaTeX's
        # auto-render sees `\[ $...$ \]` and silently renders nothing (found
        # by direct headless-browser check: 0 `.katex` elements produced).
        # A display-typesetting decision only -- the registry/JSON/site
        # `statement.latex` value itself is read here, never modified.
        if len(latex_src) >= 2 and latex_src.startswith("$") and latex_src.endswith("$"):
            latex_src = latex_src[1:-1]
        block = f'<div class="math-display" data-verbatim-source="true">\\[ {html.escape(latex_src)} \\]</div>' + mathml_block
        return block, mathml_block, True
    if fmt == "ascii-math" or fmt in ("latex", "latex+ascii"):
        # Reached for "ascii-math" itself, or for a "latex"/"latex+ascii"
        # statement that failed `_looks_like_real_latex` above — a registry
        # mislabeling (plain prose tagged as LaTeX), rendered here as plain
        # wrapped text instead of being squashed/error'd by KaTeX.
        html_ = f'<pre class="statement-ascii" data-verbatim-source="true">{html.escape(latest)}</pre>' + mathml_block
        return html_, mathml_block, False
    if fmt == "coq":
        return f'<pre class="statement-coq" data-verbatim-source="true"><code>{html.escape(latest)}</code></pre>', "", False
    # "prose" — the one entry pointing at prose, per README's verdict rule 4:
    # never presented as a formula.
    return (
        f'<p class="statement-prose" data-verbatim-source="true">{html.escape(latest)}</p>'
        "<p><em>This record points to prose, not a formula "
        "(status: not_an_equation).</em></p>"
    ), "", False


def render_ancestry_html(entry: dict, by_code: dict, depth: int) -> str:
    prefix = root_prefix(depth)
    chain = [entry]
    seen = {entry["code"]}
    cur = entry
    while cur.get("parents"):
        parent_code = cur["parents"][0].get("code")
        if not parent_code or parent_code in seen:
            break
        parent = by_code.get(parent_code)
        if not parent:
            break
        chain.append(parent)
        seen.add(parent_code)
        cur = parent
    chain.reverse()  # root first, entry last
    items = []
    for i, node in enumerate(chain):
        code = html.escape(node["code"])
        if i == len(chain) - 1:
            items.append(f"<li><strong>{code}</strong> (this entry)</li>")
        else:
            href = html.escape(f"{prefix}/entries/{site_slug(node['code'])}.html")
            items.append(f'<li><a href="{href}">{code}</a></li>')
    return '<ol class="relation-list">' + "".join(items) + "</ol>"


def render_relations_html(entry: dict, by_code: dict, reverse_rel: dict, depth: int) -> str:
    """The *inner* content of entry.tmpl.html's own `<details>` block —
    PLACEHOLDERS.md: do not add another `<details>` wrapper here."""
    prefix = root_prefix(depth)

    def link(code: str) -> str:
        safe = html.escape(code)
        if code in by_code:
            href = html.escape(f"{prefix}/entries/{site_slug(code)}.html")
            return f'<a href="{href}">{safe}</a>'
        return safe

    parents = entry.get("parents") or []
    parents_html = "".join(
        f"<li>{link(_s(p.get('code')))} <span>({html.escape(_s(p.get('derived_via')))})</span></li>"
        for p in parents
    ) or "<li>none</li>"

    children = entry.get("children") or []
    children_html = "".join(f"<li>{link(c)}</li>" for c in children) or "<li>none</li>"

    relations = entry.get("relations") or []
    relations_html = "".join(
        f"<li>{html.escape(_s(r.get('type')))} &rarr; {link(_s(r.get('target')))}"
        f" <span data-verbatim-source=\"true\">{html.escape(_s(r.get('note')))}</span></li>"
        for r in relations
    ) or "<li>none</li>"

    reverse = reverse_rel.get(entry["code"], [])
    reverse_html = "".join(
        f"<li>{link(r['from'])} &mdash; {html.escape(_s(r.get('type')))}</li>" for r in reverse
    ) or "<li>none</li>"

    return (
        f"<h3>Parents</h3><ul class=\"relation-list\">{parents_html}</ul>"
        f"<h3>Children</h3><ul class=\"relation-list\">{children_html}</ul>"
        f"<h3>Relations</h3><ul class=\"relation-list\">{relations_html}</ul>"
        f"<h3>Reverse relations (entries pointing here)</h3><ul class=\"relation-list\">{reverse_html}</ul>"
    )


def render_occurrences_html(entry: dict) -> str:
    """`<div class="table-wrap"><table>…</table></div>` of occurrences[]
    rows, per PLACEHOLDERS.md, or a plain `<p>` when none are recorded."""
    occ = entry.get("occurrences") or []
    if not occ:
        return "<p>none recorded</p>"
    rows = []
    for o in occ:
        label = html.escape(_s(o.get("label")))
        doi = o.get("doi") or ""
        record_id = o.get("record_id")
        section = html.escape(_s(o.get("section")))
        cite = html.escape(doi) if doi else (f"record {record_id}" if record_id is not None else "")
        rows.append(
            f'<tr><td data-verbatim-source="true">{label}</td><td>{cite}</td><td>{section}</td></tr>'
        )
    table = (
        '<table><thead><tr><th scope="col">Label</th><th scope="col">Source</th>'
        '<th scope="col">Section</th></tr></thead><tbody>' + "".join(rows) + "</tbody></table>"
    )
    return f'<div class="table-wrap">{table}</div>'


def render_coq_html(entry: dict) -> str:
    coq = entry.get("coq") or {}
    status = html.escape(_s(coq.get("coq_status")))
    rows = [f'<li>status: <span class="badge badge-coq">{status}</span></li>']
    if coq.get("file"):
        rows.append(f"<li>file: <code>{html.escape(coq['file'])}</code></li>")
    if coq.get("identifier"):
        rows.append(f"<li>identifier: <code>{html.escape(coq['identifier'])}</code></li>")
    if coq.get("assumptions"):
        rows.append(f"<li>assumptions: {html.escape(coq['assumptions'])}</li>")
    if coq.get("imported_from"):
        # Already written as "solver arc (private)@<ref>" at the registry
        # layer for that source — display verbatim, never re-derive.
        rows.append(f"<li>imported from: {html.escape(coq['imported_from'])}</li>")
    axioms = coq.get("coq_axioms") or []
    if axioms:
        rows.append("<li>axioms: " + ", ".join(html.escape(a) for a in axioms) + "</li>")
    identifiers = coq.get("identifiers") or []
    if identifiers:
        idlist = "".join(
            f"<li><code>{html.escape(_s(i.get('identifier')))}</code> in <code>{html.escape(_s(i.get('file')))}</code></li>"
            for i in identifiers
        )
        rows.append(f"<li>mapped identifiers:<ul>{idlist}</ul></li>")
    return '<ul class="relation-list">' + "".join(rows) + "</ul>"


def render_origin_html(entry: dict) -> str:
    """origin{} (source, repo_anchor, doi/record/section — same
    private-repo verbatim-display rule as coq's `imported_from`), plus
    `first_assigned`, `dateCreated`, `dateModified`, and the three-state
    `owner_year`/`drift_note` fields — rendered only when the key exists,
    never a literal "null" (PLACEHOLDERS.md)."""
    origin = entry.get("origin") or {}
    parts = [f'<li>source: <span data-verbatim-source="true">{html.escape(_s(origin.get("source")))}</span></li>']
    anchor = origin.get("repo_anchor")
    if anchor:
        parts.append(
            "<li>anchor: "
            f"{html.escape(_s(anchor.get('repo')))}@{html.escape(_s(anchor.get('commit')))}"
            f':<span data-verbatim-source="true">{html.escape(_s(anchor.get("path")))}</span></li>'
        )
    if origin.get("doi"):
        parts.append(f"<li>DOI: {html.escape(origin['doi'])}</li>")
    if origin.get("record_id") is not None:
        parts.append(f"<li>record id: {html.escape(str(origin['record_id']))}</li>")
    if origin.get("section"):
        parts.append(f'<li>section: <span data-verbatim-source="true">{html.escape(origin["section"])}</span></li>')
    if entry.get("first_assigned"):
        parts.append(f"<li>assigned on: {html.escape(entry['first_assigned'])}</li>")
    if entry.get("dateCreated"):
        parts.append(f"<li>created: {html.escape(_s(entry.get('dateCreated')))}</li>")
    if entry.get("dateModified"):
        parts.append(f"<li>modified: {html.escape(_s(entry.get('dateModified')))}</li>")
    if entry.get("owner_year"):
        parts.append(f"<li>owner/year: {html.escape(_s(entry.get('owner_year')))}</li>")
    if entry.get("drift_note"):
        parts.append(f'<li>drift note: <span data-verbatim-source="true">{html.escape(entry["drift_note"])}</span></li>')
    return '<ul class="relation-list">' + "".join(parts) + "</ul>"


def render_status_note_html(entry: dict, depth: int) -> str:
    note = _s(entry.get("status_note"))
    if not note:
        return ""
    prefix = root_prefix(depth)
    bit = f'<span data-verbatim-source="true">{html.escape(note)}</span>'
    superseded = entry.get("superseded_by")
    if superseded:
        href = html.escape(f"{prefix}/entries/{site_slug(superseded)}.html")
        bit += f' Use <a href="{href}">{html.escape(superseded)}</a> instead.'
    return f'<p class="note">{bit}</p>'


def render_aliases_html(entry: dict) -> str:
    """An alias frequently quotes the source's own heading verbatim (e.g.
    "PART I — ROOT AXIOMS: WHAT IS FIRST? > I") — marked
    `data-verbatim-source="true"` per its own `<code>` element so a banned
    marketing word occurring inside a quoted heading (a real, observed
    case: "FIRST" in that exact heading) is reported as a warning, never a
    hard failure, matching every other quoted-source field on this page."""
    aliases = entry.get("aliases") or []
    if not aliases:
        return ""
    items = ", ".join(
        f'<code data-verbatim-source="true">{html.escape(a)}</code>' for a in aliases
    )
    return f'<p class="lede">Also known as: {items}</p>'


def render_badge(value: str | None, css_class: str, *definitions: dict[str, str]) -> str:
    if not value:
        return ""
    title_attr = _definition_title_attr(value, *definitions)
    return f'<span class="badge {css_class}"{title_attr}>{html.escape(value)}</span>'


def render_resistance_badges_html(resistance: dict | None) -> str:
    """Seven R0-R6 badges (design/RESISTANCE_LADDER_v0_1.md sec.5): held
    rungs get the `badge-resistance--held` accent, unheld rungs
    `badge-resistance--unheld` — an unheld rung is rendered exactly as
    visibly as a held one, never omitted (sec.0's design principle: "never
    a single number that hides a missing rung"). `resistance` is `None`
    when scripts/compute_resistance.py has not yet run against this
    checkout's registry files — rendered as one disclosed sentence, never
    as seven fabricated `unheld` badges (that would assert "checked, not
    held" for a rung that was, honestly, simply never checked yet)."""
    if not resistance:
        return (
            '<p class="note">Resistance ladder not yet computed for this entry '
            "(scripts/compute_resistance.py has not run against this build).</p>"
        )
    rungs = resistance.get("rungs") or {}
    spans = []
    for r in RUNG_ORDER:
        row = rungs.get(r) or {}
        held = bool(row.get("held"))
        variant = "held" if held else "unheld"
        definition = RESISTANCE_DEFINITIONS.get(r, "")
        evidence = row.get("evidence") or []
        if held:
            detail = f"held — {len(evidence)} evidence file(s)"
        else:
            detail = f"not held — {row.get('reason', 'no reason recorded')}"
        title_attr = html.escape(f"{definition} ({detail})".strip())
        spans.append(
            f'<span class="badge badge-resistance badge-resistance--{variant}" '
            f'title="{title_attr}">{html.escape(r)}</span>'
        )
    computed_at = html.escape(str(resistance.get("computed_at") or "unknown"))
    # <fieldset>/<legend>, not a `role="group"` <div> — DESIGN.md sec.14's
    # own accessibility checklist ("every interactive control is a native
    # element... no re-implemented ARIA widget") and check_a11y.py's rule
    # both read any `role="..."` attribute as a violation regardless of
    # which role, so this uses the native grouping element instead; the
    # legend is visually hidden (`.sr-only`, toledo.css) since the visible
    # "R0"…"R6" badge labels already convey the group to a sighted reader.
    return (
        '<fieldset class="resistance-ladder"><legend class="sr-only">Resistance ladder, '
        "R0 through R6</legend>"
        + "".join(spans)
        + f'<p class="note">Resistance ladder computed {computed_at}. A rung is held only when a '
        "file on disk backs it, never by assertion; an unheld rung means no such file was found "
        "yet — it does not mean the underlying claim is false.</p></fieldset>"
    )


def build_entry_context(entry: dict, by_code: dict, reverse_rel: dict, raw_text: str,
                         depth: int, root: pathlib.Path | None = None) -> tuple[dict, bool]:
    """Supplies the union of every entry-page placeholder observed across
    this session's several site/templates/entry.tmpl.html revisions (see
    the module docstring's note on concurrent-editing robustness): whatever
    subset the on-disk template actually declares, this context has it.
    Two genuinely different-shaped pairs are computed from one shared
    source rather than guessed independently: `name`/`name_html` (same
    escaped text) and `relations_html` (inner content, for a template that
    supplies its own `<details>` wrapper) / `relations_details_html` (the
    same content pre-wrapped in `<details>`, for a template that does not)."""
    code = entry["code"]
    statement_html_, mathml_block, needs_katex = render_statement_html(
        entry.get("statement") or {}, entry.get("presentation_mathml"),
    )
    status = entry.get("status", "current") or "current"
    domain = entry.get("domain")
    tier = entry.get("tier")
    coq_status = (entry.get("coq") or {}).get("coq_status")
    prefix = root_prefix(depth)
    root_code = entry.get("root", "") or ""
    root_href = html.escape(f"{prefix}/by-root/{site_slug(root_code)}/")
    entry_root_link = f'<a href="{root_href}">{html.escape(root_code)}</a>'
    name_escaped = html.escape(entry.get("name", "") or "")
    breadcrumb_html = (
        f'<p class="breadcrumb"><a href="{html.escape(prefix + "/")}">Toledo</a> / '
        f'{entry_root_link} / {html.escape(code)}</p>'
    )
    domain_badge = render_badge(domain, "badge-domain")
    tier_badge = render_badge(tier, "badge-tier", TIER_DEFINITIONS)
    status_title = _definition_title_attr(status, STATUS_DEFINITIONS)
    status_badge = (
        f'<span class="badge badge-status badge-status--{_status_variant(status)}"{status_title}>'
        f'{html.escape(status)}</span>'
    )
    coq_badge = render_badge(coq_status, "badge-coq", COQ_STATUS_DEFINITIONS)
    resistance_badges_html = render_resistance_badges_html(entry.get("resistance"))
    relations_inner = render_relations_html(entry, by_code, reverse_rel, depth)
    relations_wrapped = (
        "<details><summary>Full relations (all parents, children, and cross-references)</summary>"
        '<p class="lede">The complete parent/child/relation graph, not just the single chain above.</p>'
        f"{relations_inner}</details>"
    )
    api_mangled = mangle_code(code)
    api_url = f"https://morrocwi.github.io/toledo/v1/entries/{api_mangled}.json"
    # PLACEHOLDERS.md: embed the source file's own bytes verbatim, never a
    # re-serialization; only defensively neutralise a literal "</script"
    # so the JSON can never break out of its containing <script> tag.
    jsonld_safe = raw_text.replace("</script", "<\\/script")
    executable_widget_html = render_executable_widget_html(entry, root, depth) if root is not None else ""
    context = {
        "code": html.escape(code),
        "entry_root": html.escape(root_code),
        "entry_root_link": entry_root_link,
        "breadcrumb_html": breadcrumb_html,
        "name": name_escaped,
        "name_html": name_escaped,
        "domain_badge_html": domain_badge,
        "tier_badge_html": tier_badge,
        "status_badge_html": status_badge,
        "coq_status_badge_html": coq_badge,
        "resistance_badges_html": resistance_badges_html,
        "executable_widget_html": executable_widget_html,
        "badges_html": domain_badge + tier_badge + status_badge + coq_badge,
        "status_note_html": render_status_note_html(entry, depth),
        "aliases_html": render_aliases_html(entry),
        "statement_html": statement_html_,
        "presentation_mathml_block": mathml_block,
        "ancestry_html": render_ancestry_html(entry, by_code, depth),
        "relations_html": relations_inner,
        "relations_details_html": relations_wrapped,
        "occurrences_html": render_occurrences_html(entry),
        "coq_html": render_coq_html(entry),
        "origin_html": render_origin_html(entry),
        "jsonld": jsonld_safe,
        "jsonld_json": jsonld_safe,
        "api_mangled_code": api_mangled,
        "api_footer_href": html.escape(api_url),
    }
    return context, needs_katex


# --------------------------------------------------------------------------
# Site-level page contexts
# --------------------------------------------------------------------------
def build_domain_links_html(reading_entries: list[dict], depth: int) -> str:
    prefix = root_prefix(depth)
    counts = collections.Counter(e["domain"] for e in reading_entries if e.get("domain"))
    items = []
    for letter in sorted(counts):
        href = html.escape(f"{prefix}/by-domain/{letter}/")
        name = html.escape(DOMAIN_NAMES.get(letter, letter))
        items.append(f'<a class="pill-link" href="{href}">{html.escape(letter)} &mdash; {name} ({counts[letter]})</a>')
    return "".join(items)


def build_home_context(manifest: dict, root_rows: int, reading_entries: list[dict]) -> dict:
    depth = 0
    by_status = manifest["counts_by_status"]
    by_coq = manifest["counts_by_coq_status"]
    return {
        "entry_count": str(manifest["entry_count"]),
        "root_count": str(root_rows),
        "current_count": str(by_status.get("current", 0)),
        "closed_count": str(by_coq.get("closed", 0)),
        "domain_links_html": build_domain_links_html(reading_entries, depth),
        "registry_release_version": html.escape(manifest.get("registry_release_version") or "unreleased"),
        "generated_at": manifest["generated_at"],
        "generated_at_human": _human_date(manifest["generated_at"]),
        # tier-status-jargon-unexplained (R1 re-review): a newcomer's very
        # first landing page gets a plain-language "how to read a status"
        # box, built from the same shared glossary /about/'s own definition
        # list uses, so the two can never carry different wording.
        "how_to_read_html": _glossary_dl_html(
            ("Tier", TIER_DEFINITIONS), ("Coq status", COQ_STATUS_DEFINITIONS),
            ("Resistance ladder (R0-R6)", RESISTANCE_DEFINITIONS),
        ),
    }


def build_browse_context(entries_sorted: list[dict], depth: int, *, bare_rows: bool) -> dict:
    rows_html, jump_nav_html = render_rows_with_bands(entries_sorted, depth, show_executable=True)
    if not bare_rows:
        rows_html = wrap_full_table(
            rows_html, "Every Toledo code, sorted in natural code order.",
            header_html=TABLE_HEADER_ROW_WITH_EXECUTABLE,
        )
    return {
        "entry_count": str(len(entries_sorted)),
        "jump_nav_html": jump_nav_html,
        "rows_html": rows_html,
        # docs/EXECUTABLE_EQUATIONS_v0_1.md sec.1.4/sec.7: the domain-honesty
        # note carried once per page (never per row) next to the new column.
        "executable_domain_note_html": f'<p class="note">{EXECUTABLE_DOMAIN_HONESTY_NOTE}</p>',
    }


def build_listing_context(short_axis_label: str, axis_value: str, axis_index_path: str,
                           axis_description: str, entries: list[dict], *,
                           bare_rows: bool, short_axis: bool) -> dict:
    depth = 2
    ordered = sorted(entries, key=lambda e: natural_key(e["code"]))
    n = len(ordered)
    noun = "entry" if n == 1 else "entries"
    rows_html = render_rows(ordered, depth)
    full_label = f"{short_axis_label}: {axis_value}"
    if not bare_rows:
        rows_html = wrap_full_table(rows_html, f"{full_label} — {n} {noun}.")
    return {
        # One observed template shape wants a short axis name
        # ("Domain") plus a separate {{axis_value}} ("P — physics"); another
        # wants one pre-combined {{axis_label}} ("Domain: P — physics").
        # `short_axis` (detected from whether listing.tmpl.html itself
        # declares {{axis_value}}) picks which this key means.
        "axis_label": html.escape(short_axis_label if short_axis else full_label),
        "axis_value": html.escape(axis_value),
        "axis_index_path": html.escape(axis_index_path),
        "axis_description": html.escape(axis_description),
        "entry_count": str(n),
        "row_count": str(n),
        "row_count_noun": noun,
        "rows_html": rows_html,
        # tier-status-jargon-unexplained: a /by-tier/<v>/ page shows that
        # tier value's own one-sentence definition; a /by-status/<v>/ page
        # (this axis is the `status` field, not coq_status — DESIGN.md
        # sec.1's URL scheme) shows that status value's definition. Empty
        # for /by-domain/ and /by-root/, which carry no jargon to define.
        "axis_definition_html": (
            f'<p class="note">{html.escape(TIER_DEFINITIONS[axis_value])}</p>'
            if short_axis_label == "Tier" and axis_value in TIER_DEFINITIONS
            else f'<p class="note">{html.escape(STATUS_DEFINITIONS[axis_value])}</p>'
            if short_axis_label == "Status" and axis_value in STATUS_DEFINITIONS
            else ""
        ),
    }


def build_agents_context(manifest: dict, tools_table: list[dict], mcp_json_text: str,
                          coverage: dict, root_rows: int, *, bare_tools_rows: bool) -> dict:
    # The Python example, curl line, and crawler JSON-LD are fixed, static,
    # non-registry-dependent boilerplate baked directly into agents.tmpl.html
    # in every observed revision (PLACEHOLDERS.md: "fixed in the template
    # ... should not need a new placeholder for them") — this function
    # supplies only the registry-derived placeholders.
    tools_rows = "".join(
        f"<tr><td class=\"code-cell\"><code>{html.escape(t['tool'])}</code></td><td>{html.escape(t['purpose'])}</td></tr>"
        for t in tools_table
    )
    tools_table_html = tools_rows if bare_tools_rows else (
        '<table><caption>Every Toledo MCP tool, parsed at build time from mcp/README.md’s own table.</caption>'
        '<thead><tr><th scope="col" class="code-cell">Tool</th><th scope="col">Purpose</th></tr></thead>'
        f"<tbody>{tools_rows}</tbody></table>"
    )
    total_pages = manifest["entry_count"] + root_rows
    cov = coverage_sentences(coverage, total_pages)
    return {
        "mcp_json_snippet": html.escape(mcp_json_text.strip()),
        "tools_table_rows": tools_rows,
        "tools_table_html": tools_table_html,
        "coverage_html": coverage_html(coverage, total_pages),
        "mathml_sentence": html.escape(cov["mathml_sentence"]),
        "statement_format_sentence": html.escape(cov["statement_format_sentence"]),
        "entry_count": str(manifest["entry_count"]),
        "registry_release_version": html.escape(manifest.get("registry_release_version") or "unreleased"),
        "generated_at": manifest["generated_at"],
        "generated_at_human": _human_date(manifest["generated_at"]),
    }


def _breakdown_html(counts: dict) -> str:
    return "<ul>" + "".join(
        f"<li>{html.escape(str(k))}: {v}</li>" for k, v in sorted(counts.items(), key=lambda kv: str(kv[0]))
    ) + "</ul>"


def _breakdown_li_only(counts: dict) -> str:
    return "".join(
        f"<li>{html.escape(str(k))}: {v}</li>" for k, v in sorted(counts.items(), key=lambda kv: str(kv[0]))
    )


POLICY_SUMMARY = (
    "This registry is the sole source Toledo work cites for an existing equation. "
    "A missing equation is inspected for here before any new derivation, and derived only if genuinely "
    "absent, and any new derivation is labelled as a proposal, never presented as "
    "an existing entry (see EQUATION_SOURCE_POLICY.md)."
)


def compute_resistance_coverage(entries: list[dict]) -> dict:
    """Corpus-wide tally of rungs HELD across every loaded entry page (S3,
    design/RESISTANCE_LADDER_v0_1.md sec.0's own "the score is a SET of
    rungs held ... never a single number" principle, extended here to a
    corpus-level summary the same way sec.9's `compute_coverage` already
    reports per-format counts rather than one aggregate percentage): a
    plain per-rung count, never a percentage or a combined index.
    `computed` is how many of the loaded entries carry a `resistance` block
    at all — the honest denominator that keeps "checked and unheld" from
    ever being confused with "not yet checked"."""
    held = {r: 0 for r in RUNG_ORDER}
    computed = 0
    for e in entries:
        res = e.get("resistance")
        if not res:
            continue
        computed += 1
        rungs = res.get("rungs") or {}
        for r in RUNG_ORDER:
            if (rungs.get(r) or {}).get("held"):
                held[r] += 1
    return {"computed": computed, "total": len(entries), "held": held}


def resistance_coverage_html(rc: dict) -> str:
    computed, total = rc["computed"], rc["total"]
    rows = "".join(
        f"<li><code>{html.escape(r)}</code> — {rc['held'][r]} of {computed} computed entries "
        f"({RESISTANCE_DEFINITIONS.get(r, '').split('.')[0]})</li>"
        for r in RUNG_ORDER
    )
    return (
        f'<p class="note">Resistance ladder computed for {computed} of {total} pages. Counts below '
        "are entries HOLDING each rung — a rung not held may simply not have been checked yet; "
        "these counts are never combined into one score.</p>"
        f"<ul>{rows}</ul>"
    )


def compute_executable_coverage(entries: list[dict]) -> dict:
    """Corpus-wide tally of the computed `executable{}` block (docs/
    EXECUTABLE_EQUATIONS_v0_1.md sec.1.4/sec.3.1/sec.8), mirroring
    `compute_resistance_coverage`'s own shape and honesty convention: a
    plain per-status count, `computed` distinguishing "no executable form
    for this entry, by design — most of the corpus" from "not yet computed
    on this build" (`scripts/compute_executable.py`, S3, has not run)."""
    by_status: dict[str, int] = {}
    computed = 0
    for e in entries:
        ex = e.get("executable")
        if not ex:
            continue
        computed += 1
        status = ex.get("status") or "unknown"
        by_status[status] = by_status.get(status, 0) + 1
    return {"computed": computed, "total": len(entries), "by_status": by_status}


def executable_coverage_html(ec: dict) -> str:
    computed, total = ec["computed"], ec["total"]
    if computed == 0:
        body = (
            '<p class="note">No entry carries a computed <code>executable</code> block yet on this '
            "build (<code>scripts/compute_executable.py</code> has not run against this checkout).</p>"
        )
    else:
        rows = "".join(
            f"<li><code>{html.escape(status)}</code> — {count} of {computed} computed entries</li>"
            for status, count in sorted(ec["by_status"].items())
        )
        body = (
            f'<p class="note">{computed} of {total} entries/root rows carry a computed '
            "<code>executable</code> status; the rest carry none at all, by design — most of this "
            "corpus is not a numeric relation to begin with.</p>"
            f"<ul>{rows}</ul>"
        )
    return body + f'<p class="note">{EXECUTABLE_DOMAIN_HONESTY_NOTE}</p>'


def build_about_context(manifest: dict, root_rows: int, coverage: dict, concept_doi: str | None,
                         resistance_coverage: dict | None = None,
                         executable_coverage: dict | None = None) -> dict:
    total_pages = manifest["entry_count"] + root_rows
    cov = coverage_sentences(coverage, total_pages)
    resistance_coverage = resistance_coverage or {"computed": 0, "total": total_pages,
                                                   "held": {r: 0 for r in RUNG_ORDER}}
    executable_coverage = executable_coverage or {"computed": 0, "total": total_pages, "by_status": {}}
    return {
        "entry_count": str(manifest["entry_count"]),
        "root_count": str(root_rows),
        "status_breakdown_html": _breakdown_html(manifest["counts_by_status"]),
        "domain_breakdown_html": _breakdown_html(manifest["counts_by_domain"]),
        "tier_breakdown_html": _breakdown_html(manifest["counts_by_tier"]),
        "coq_status_breakdown_html": _breakdown_html(manifest["counts_by_coq_status"]),
        # A second observed template shape wants only the status breakdown,
        # as bare <li> rows with the template supplying its own <ul>.
        "counts_by_status_html": _breakdown_li_only(manifest["counts_by_status"]),
        "coverage_html": coverage_html(coverage, total_pages),
        "mathml_sentence": html.escape(cov["mathml_sentence"]),
        "statement_format_sentence": html.escape(cov["statement_format_sentence"]),
        # tier-status-jargon-unexplained: the same shared builder home's
        # "how to read a status" box uses, plus the status field's own
        # ladder (not shown on the landing page's shorter box).
        "glossary_html": _glossary_dl_html(
            ("Tier", TIER_DEFINITIONS), ("Coq status", COQ_STATUS_DEFINITIONS),
            ("Status", STATUS_DEFINITIONS), ("Resistance ladder (R0-R6)", RESISTANCE_DEFINITIONS),
        ),
        "resistance_coverage_html": resistance_coverage_html(resistance_coverage),
        "executable_coverage_html": executable_coverage_html(executable_coverage),
        "policy_summary": html.escape(POLICY_SUMMARY),
        "concept_doi": html.escape(concept_doi or "unreleased"),
        "registry_release_version": html.escape(manifest.get("registry_release_version") or "unreleased"),
        "generated_at": manifest["generated_at"],
        "generated_at_human": _human_date(manifest["generated_at"]),
        "generated_from_commit": html.escape(manifest.get("generated_from_commit") or "unknown"),
    }


def render_axis_index_content(title: str, description: str, items: list[tuple[str, str, int]]) -> str:
    """A minimal index page for one axis (/by-root/, /by-domain/, /by-tier/,
    /by-status/) linking to every populated value's own listing page. No
    dedicated .tmpl.html exists for this — home.tmpl.html itself links to
    these bare axis paths (e.g. `{{root}}/by-tier/`), so something must
    resolve there; content is assembled directly here and rendered through
    base.tmpl.html only."""
    rows = "".join(
        f'<li><a href="{html.escape(href)}">{html.escape(label)}</a> &mdash; {count} '
        f'{"entry" if count == 1 else "entries"}</li>'
        for label, href, count in items
    )
    return (
        f"<h1>{html.escape(title)}</h1>"
        f'<p class="lede">{html.escape(description)}</p>'
        f"<ul>{rows}</ul>"
    )


_MD_INLINE_LINK_RE = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")
_MD_INLINE_BOLD_RE = re.compile(r"\*\*([^*]+)\*\*")
_MD_INLINE_CODE_RE = re.compile(r"`([^`]+)`")


def _md_inline_html(text: str) -> str:
    """Inline markdown -> HTML for exactly the three inline forms
    `site/content/*.md` actually uses (bold, inline code, links) — escapes
    first so a literal `<`/`&` in source prose can never inject markup,
    then restores only the three patterns above. Not a general markdown
    engine (none is a repo dependency; see render_ecosystem_html's own
    docstring)."""
    escaped = html.escape(text)
    # Inline code first so a `[`/`]`/`*` inside a code span is never read
    # as link/bold syntax.
    parts = _MD_INLINE_CODE_RE.split(escaped)
    for i in range(1, len(parts), 2):
        parts[i] = f"<code>{parts[i]}</code>"
    escaped = "".join(parts)
    escaped = _MD_INLINE_LINK_RE.sub(
        lambda m: f'<a href="{m.group(2)}">{m.group(1)}</a>', escaped
    )
    escaped = _MD_INLINE_BOLD_RE.sub(lambda m: f"<strong>{m.group(1)}</strong>", escaped)
    return escaped


def render_ecosystem_html(md_text: str) -> str:
    """A small, purpose-built markdown -> HTML converter for exactly the
    constructs `site/content/ecosystem.md` uses (ATX headers, paragraphs,
    fenced code blocks incl. a ```mermaid block, pipe tables, numbered
    lists, and the three inline forms `_md_inline_html` handles) — not a
    general markdown library (none is a dependency of this stdlib-only
    build; DESIGN.md sec.0's own "no build-time network calls, no new
    dependency" constraint). A ```mermaid fence renders as
    `<pre class="mermaid">` (client-side rendering by the CDN+SRI script
    the caller wires in via `needs_mermaid=True` — see MERMAID_HEAD/
    MERMAID_SCRIPTS above and this repo's own render_all_docs, no
    mermaid-CLI available on this machine to pre-render an SVG instead);
    every other fenced block renders as an ordinary `<pre><code>`. The
    raw diagram/code source is HTML-escaped into the page exactly like
    every other `<pre>` block this generator already writes
    (render_coq_html, render_statement_html) — a no-JS reader, or mermaid
    itself reading `.textContent`, both get the literal source back."""
    lines = md_text.split("\n")
    out: list[str] = []
    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]
        stripped = line.strip()
        if not stripped:
            i += 1
            continue
        # ATX headers
        m = re.match(r"^(#{1,3})\s+(.*)$", stripped)
        if m:
            level = len(m.group(1))
            out.append(f"<h{level}>{_md_inline_html(m.group(2).strip())}</h{level}>")
            i += 1
            continue
        # Fenced code block
        m = re.match(r"^```(\S*)\s*$", stripped)
        if m:
            lang = m.group(1)
            body_lines: list[str] = []
            i += 1
            while i < n and lines[i].strip() != "```":
                body_lines.append(lines[i])
                i += 1
            i += 1  # skip closing fence
            body = html.escape("\n".join(body_lines))
            if lang == "mermaid":
                out.append(f'<pre class="mermaid">{body}</pre>')
            else:
                out.append(f"<pre><code>{body}</code></pre>")
            continue
        # Pipe table: header row, then a |---|---| separator row
        if stripped.startswith("|") and i + 1 < n and re.match(
            r"^\|?[\s:|-]+\|?$", lines[i + 1].strip()
        ):
            def _cells(row: str) -> list[str]:
                row = row.strip()
                if row.startswith("|"):
                    row = row[1:]
                if row.endswith("|"):
                    row = row[:-1]
                return [c.strip() for c in row.split("|")]

            header_cells = _cells(stripped)
            i += 2  # skip header + separator
            body_rows: list[list[str]] = []
            while i < n and lines[i].strip().startswith("|"):
                body_rows.append(_cells(lines[i]))
                i += 1
            thead = "".join(
                f'<th scope="col">{_md_inline_html(c)}</th>' for c in header_cells
            )
            tbody = "".join(
                "<tr>" + "".join(f"<td>{_md_inline_html(c)}</td>" for c in row) + "</tr>"
                for row in body_rows
            )
            out.append(
                '<div class="table-wrap"><table>'
                f"<thead><tr>{thead}</tr></thead><tbody>{tbody}</tbody>"
                "</table></div>"
            )
            continue
        # Numbered list (consumes consecutive "N. " lines, incl. any
        # immediately-indented continuation lines of the same item)
        if re.match(r"^\d+\.\s+", stripped):
            items: list[str] = []
            while i < n:
                mm = re.match(r"^\d+\.\s+(.*)$", lines[i].strip())
                if not mm:
                    break
                item_text = [mm.group(1)]
                i += 1
                while i < n and lines[i].strip() and not re.match(
                    r"^\d+\.\s+", lines[i].strip()
                ) and not lines[i].strip().startswith("#"):
                    item_text.append(lines[i].strip())
                    i += 1
                items.append(" ".join(item_text))
            out.append("<ol>" + "".join(f"<li>{_md_inline_html(t)}</li>" for t in items) + "</ol>")
            continue
        # Paragraph: consume consecutive non-blank, non-special lines
        para_lines = [stripped]
        i += 1
        while i < n and lines[i].strip() and not lines[i].strip().startswith(("#", "```", "|")) \
                and not re.match(r"^\d+\.\s+", lines[i].strip()):
            para_lines.append(lines[i].strip())
            i += 1
        out.append(f"<p>{_md_inline_html(' '.join(para_lines))}</p>")
    return "\n".join(out)


# --------------------------------------------------------------------------
# Orchestration
# --------------------------------------------------------------------------
def build_data_files(root: pathlib.Path, data_dir: pathlib.Path) -> dict:
    """Writes site/data/manifest.json, search-index.json, tools-table.json.
    Independent of any template — this half of the build always completes."""
    entries, raw_by_code = load_entries(root)
    canonical_counts = load_canonical_counts(root)
    # clean-checkout-site-build-empty (engineering re-review finding): a
    # checkout that has not yet run `scripts/toledo_build.py` (registry/
    # entries/ is .gitignore'd — see registry/SCHEMA.md and the Makefile's
    # own `site: build ; python3 site/build_site.py` sequencing) previously
    # produced a silent, near-empty skeleton site (exit 0, 0 registry
    # entries) instead of failing loud. registry/CANONICAL.json's own
    # counts{}.entries is always present and non-zero on a real registry, so
    # a zero-entries load while that count says otherwise is unambiguous
    # evidence of a missing build step, never a legitimately empty registry.
    expected_min = canonical_counts.get("entries", 0)
    if expected_min and not entries:
        raise SystemExit(
            f"site/build_site.py: loaded 0 entries from {root / 'registry' / 'entries'} but "
            f"registry/CANONICAL.json's own counts.entries says {expected_min} — "
            "registry/entries/ is almost certainly missing because `python3 scripts/"
            "toledo_build.py` (or `make build`) has not been run yet on this checkout. "
            "Run that first, or use `make site` which sequences it automatically."
        )
    coverage = compute_coverage(entries)
    registry_release_version = _citation_field(root, "version")
    generated_from_commit = _git_commit(root)

    manifest = build_manifest(canonical_counts, coverage, registry_release_version, generated_from_commit)
    search_index = build_search_index(entries)
    tools_table = _parse_tools_table_from_readme(root)

    _write_json(data_dir / "manifest.json", manifest)
    _write_json(data_dir / "search-index.json", search_index)
    _write_json(data_dir / "tools-table.json", tools_table)

    return {
        "entries": entries,
        "raw_by_code": raw_by_code,
        "manifest": manifest,
        "canonical_counts": canonical_counts,
        "coverage": coverage,
        "tools_table": tools_table,
    }


def build_pages(root: pathlib.Path, out_dir: pathlib.Path, templates_dir: pathlib.Path,
                 data: dict) -> dict:
    entries = data["entries"]
    raw_by_code = data["raw_by_code"]
    manifest = data["manifest"]
    canonical_counts = data["canonical_counts"]
    coverage = data["coverage"]
    tools_table = data["tools_table"]
    by_code = {e["code"]: e for e in entries}
    reverse_rel = build_reverse_relations(entries)
    reading_entries = [e for e in entries if e.get("layer") == "reading"]
    root_entries = [e for e in entries if e.get("layer") == "root"]
    root_rows = len(root_entries)
    concept_doi = _citation_field(root, "doi")

    ts = TemplateStore(templates_dir)
    pages_written: list[str] = []
    pages_skipped: list[str] = []
    unresolved_report: dict[str, list[str]] = {}

    # This repository's site/templates/ has been observed mid-session in
    # more than one shape for the same page (a concurrent-editing stream
    # this build cannot control) — detect, per template, which shape is
    # actually on disk right now rather than assuming one, so the build
    # stays correct across a template revision landing between two runs.
    # Signal: does the template already carry its own `<table><thead>`
    # (rows_html/tools_table_rows then wants bare `<tr>` rows), and does
    # listing.tmpl.html itself use `{{axis_value}}` as its own placeholder
    # (then `{{axis_label}}` means a short axis name, not a pre-combined
    # "Axis: value" string).
    browse_text = ts.get("browse.tmpl.html") or ""
    listing_text = ts.get("listing.tmpl.html") or ""
    agents_text = ts.get("agents.tmpl.html") or ""
    browse_bare_rows = "<thead>" in browse_text
    listing_bare_rows = "<thead>" in listing_text
    listing_short_axis = "{{axis_value}}" in listing_text
    agents_bare_tools = "<thead>" in agents_text

    def emit(rel_path: str, title: str, description: str, page_class: str, depth: int,
              inner_template: str, inner_context: dict, *, needs_katex: bool = False):
        base_context = {
            # Union of every base.tmpl.html shape observed this session.
            "title": html.escape(title),
            "page_title": html.escape(title),
            "description": html.escape(description),
            "meta_description": html.escape(description),
            "root": root_prefix(depth),
            "page_class": page_class,
            "katex_head": KATEX_HEAD if needs_katex else "",
            "katex_scripts": KATEX_SCRIPTS if needs_katex else "",
            "katex_assets": (KATEX_HEAD + "\n" + KATEX_SCRIPTS) if needs_katex else "",
            "mermaid_head": "", "mermaid_scripts": "",
            "generated_at": manifest["generated_at"],
        }
        html_out, unresolved = ts.render_with_base(inner_template, inner_context, base_context)
        if html_out is None:
            pages_skipped.append(rel_path)
            return
        if unresolved:
            unresolved_report[rel_path] = unresolved
        dest = out_dir / rel_path
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(html_out, encoding="utf-8")
        pages_written.append(rel_path)

    def emit_raw(rel_path: str, title: str, description: str, page_class: str, depth: int,
                 content_html: str, *, needs_mermaid: bool = False):
        base_context = {
            "title": html.escape(title), "page_title": html.escape(title),
            "description": html.escape(description), "meta_description": html.escape(description),
            "root": root_prefix(depth), "page_class": page_class,
            "katex_head": "", "katex_scripts": "", "katex_assets": "",
            "mermaid_head": MERMAID_HEAD if needs_mermaid else "",
            "mermaid_scripts": MERMAID_SCRIPTS if needs_mermaid else "",
            "generated_at": manifest["generated_at"], "content": content_html,
        }
        page_html, unresolved = ts.render("base.tmpl.html", base_context)
        if page_html is None:
            pages_skipped.append(rel_path)
            return
        if unresolved:
            unresolved_report[rel_path] = unresolved
        dest = out_dir / rel_path
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_text(page_html, encoding="utf-8")
        pages_written.append(rel_path)

    def emit_listing(rel_dir: str, title: str, description: str, short_axis_label: str,
                       axis_value: str, axis_index_path: str, axis_description: str,
                       group: list[dict], depth: int):
        """Emits one `/<rel_dir>/index.html` listing page — or, only if the
        actually-rendered page would exceed the founder's 200 KB
        index-page budget (measured directly, never guessed from a row
        count), shards it by initial-letter band exactly the way `/browse/`
        is sharded above (sec.3's own named technique — a general fallback
        for any index-shaped page the registry has grown past budget, not
        a special case invented for one axis)."""
        ctx = build_listing_context(
            short_axis_label, axis_value, axis_index_path, axis_description, group,
            bare_rows=listing_bare_rows, short_axis=listing_short_axis,
        )
        base_context = {
            "title": html.escape(title), "page_title": html.escape(title),
            "description": html.escape(description), "meta_description": html.escape(description),
            "root": root_prefix(depth), "page_class": "page-listing",
            "katex_head": "", "katex_scripts": "", "katex_assets": "",
            "mermaid_head": "", "mermaid_scripts": "",
            "generated_at": manifest["generated_at"],
        }
        html_out, unresolved = ts.render_with_base("listing.tmpl.html", ctx, base_context)
        rel_path = f"{rel_dir}/index.html"
        if html_out is None:
            pages_skipped.append(rel_path)
            return
        if len(html_out.encode("utf-8")) <= PERF_BUDGET_BYTES:
            if unresolved:
                unresolved_report[rel_path] = unresolved
            dest = out_dir / rel_path
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_text(html_out, encoding="utf-8")
            pages_written.append(rel_path)
            return

        # Over budget as actually rendered: shard by initial-letter band.
        band_order: list[str] = []
        band_groups: dict[str, list[dict]] = {}
        for e in sorted(group, key=lambda e: natural_key(e["code"])):
            b = (e["code"][:1] or "?").upper()
            if b not in band_groups:
                band_order.append(b)
                band_groups[b] = []
            band_groups[b].append(e)
        for b in band_order:
            emit(
                f"{rel_dir}/{b}/index.html", f"{title} ({b})",
                f"{description} Initial-letter band {b}.", "page-listing", depth + 1,
                "listing.tmpl.html",
                build_listing_context(
                    short_axis_label, axis_value, axis_index_path,
                    f"{axis_description} Initial-letter band {b}.", band_groups[b],
                    bare_rows=listing_bare_rows, short_axis=listing_short_axis,
                ),
            )
        band_links = "".join(
            f'<li><a href="{html.escape(b)}/">{html.escape(b)}</a> ({len(band_groups[b])})</li>'
            for b in band_order
        )
        emit_raw(
            rel_path, title, f"{description} Sharded by initial-letter band.", "page-listing", depth,
            f"<h1>{html.escape(short_axis_label)}: {html.escape(axis_value)}</h1>"
            f'<p class="lede">{html.escape(axis_description)} Sharded by initial-letter band to stay '
            "under the page-size budget.</p>"
            f'<nav class="jump-nav" aria-label="Browse by initial letter"><ul>{band_links}</ul></nav>',
        )

    # / (depth 0)
    emit(
        "index.html", "Toledo — equation library",
        "The coded equation registry of the Human–AI Readout Programme.",
        "page-home", 0, "home.tmpl.html",
        build_home_context(manifest, root_rows, reading_entries),
    )

    # /browse/ — sharded by first-character band (DESIGN.md sec.3's own
    # named contingency: at the current registry size a single flat page
    # exceeds the 200 KB index-page budget — verified by check_perf_budget,
    # not assumed — so this is the specified fallback, not a new design
    # decision: "/browse/<band>/ ... /browse/index.html reduced to the
    # band links". Never a silent truncation of the listing.
    all_sorted = sorted(entries, key=lambda e: natural_key(e["code"]))
    band_order: list[str] = []
    band_groups: dict[str, list[dict]] = {}
    for e in all_sorted:
        b = (e["code"][:1] or "?").upper()
        if b not in band_groups:
            band_order.append(b)
            band_groups[b] = []
        band_groups[b].append(e)
    for b in band_order:
        group = band_groups[b]
        emit(
            f"browse/{b}/index.html", f"Browse {b} — Toledo",
            f"Every Toledo code starting with {b}, one flat table.",
            "page-browse", 2, "browse.tmpl.html",
            build_browse_context(group, 2, bare_rows=browse_bare_rows),
        )
    band_links = "".join(
        f'<li><a href="{html.escape(b)}/">{html.escape(b)}</a> ({len(band_groups[b])})</li>' for b in band_order
    )
    emit_raw(
        "browse/index.html", "Browse — Toledo",
        "Every coded entry in the Toledo registry, sharded by initial-letter band.",
        "page-browse", 1,
        f'<h1>Browse — every entry</h1><p class="lede">All {len(all_sorted)} coded entries and root '
        "rows, sharded by initial-letter band to stay under the page-size budget (natural code order "
        "within each band). Each band page needs no JavaScript to read or search.</p>"
        f'<nav class="jump-nav" aria-label="Browse by initial letter"><ul>{band_links}</ul></nav>',
    )

    # /by-root/<root-slug>/ (depth 2, root row + every reading under it) +
    # /by-root/ index (depth 1)
    root_groups: dict = collections.defaultdict(list)
    for e in entries:
        r = e.get("root")
        if r:
            root_groups[r].append(e)
    for root_code in sorted(root_groups, key=natural_key):
        group = root_groups[root_code]
        emit_listing(
            f"by-root/{site_slug(root_code)}",
            f"Root: {root_code} — Toledo", f"Every Toledo entry under root {root_code}.",
            "Root", root_code, "by-root",
            f"The root row and every reading under Layer-0 root {root_code}.", group, 2,
        )
    root_index_items = [
        (r, f"{site_slug(r)}/", len(root_groups[r])) for r in sorted(root_groups, key=natural_key)
    ]
    emit_raw(
        "by-root/index.html", "By root — Toledo", "Every Layer-0 root in the Toledo registry.",
        "page-axis-index", 1,
        render_axis_index_content("By root", "Every Layer-0 root — the root row plus every reading under it.", root_index_items),
    )

    # /by-domain/<letter>/ (depth 2) + /by-domain/ index (depth 1)
    domain_values = sorted(canonical_counts.get("by_domain", {}).keys())
    for letter in domain_values:
        group = [e for e in reading_entries if e.get("domain") == letter]
        label = f"{letter} — {DOMAIN_NAMES.get(letter, letter)}"
        emit_listing(
            f"by-domain/{letter}", f"Domain: {label} — Toledo",
            f"Every Toledo entry in domain {label}.",
            "Domain", label, "by-domain", f"Every entry in domain {label}.", group, 2,
        )
    domain_index_items = [
        (f"{d} — {DOMAIN_NAMES.get(d, d)}", f"{d}/", canonical_counts["by_domain"][d])
        for d in domain_values
    ]
    emit_raw(
        "by-domain/index.html", "By domain — Toledo", "Every domain letter in the Toledo registry.",
        "page-axis-index", 1,
        render_axis_index_content("By domain", "Each entry belongs to one of eight domains.", domain_index_items),
    )

    # /by-tier/<tier>/ (depth 2, verbatim tier value as slug) + index (depth 1)
    tier_values = sorted(canonical_counts.get("by_tier", {}).keys())
    for tier in tier_values:
        group = [e for e in reading_entries if e.get("tier") == tier]
        emit_listing(
            f"by-tier/{tier}", f"Tier: {tier} — Toledo", f"Every Toledo entry tagged tier {tier}.",
            "Tier", tier, "by-tier", f"Every entry tagged tier {tier}.", group, 2,
        )
    tier_index_items = [(t, f"{t}/", canonical_counts["by_tier"][t]) for t in tier_values]
    emit_raw(
        "by-tier/index.html", "By tier — Toledo", "Every tier value present in the Toledo registry.",
        "page-axis-index", 1,
        render_axis_index_content("By tier", "Every populated tier value.", tier_index_items),
    )

    # /by-status/<status>/ (depth 2, verbatim status value as slug) + index (depth 1)
    status_values = sorted(canonical_counts.get("by_status", {}).keys())
    for status in status_values:
        group = [e for e in reading_entries if e.get("status") == status]
        emit_listing(
            f"by-status/{status}", f"Status: {status} — Toledo",
            f"Every Toledo entry with status {status}.",
            "Status", status, "by-status", f"Every entry with status {status}.", group, 2,
        )
    status_index_items = [(s, f"{s}/", canonical_counts["by_status"][s]) for s in status_values]
    emit_raw(
        "by-status/index.html", "By status — Toledo", "Every status value present in the Toledo registry.",
        "page-axis-index", 1,
        render_axis_index_content("By status", "Every populated status value.", status_index_items),
    )

    # /entries/<site-slug>.html (depth 1)
    for e in entries:
        ctx, needs_katex = build_entry_context(e, by_code, reverse_rel, raw_by_code[e["code"]], 1, root)
        emit(
            f"entries/{site_slug(e['code'])}.html", f"{e['code']} — Toledo",
            _truncate(e.get("name", "") or "", 150), "page-entry", 1, "entry.tmpl.html",
            ctx, needs_katex=needs_katex,
        )

    # /search/ (depth 1)
    emit(
        "search/index.html", "Search — Toledo",
        "Text search over the Toledo registry (JavaScript-enhanced; every entry is always at /browse/).",
        "page-search", 1, "search.tmpl.html", {},
    )

    # /agents/ (depth 1)
    mcp_json_text = (root / ".mcp.json").read_text(encoding="utf-8")
    emit(
        "agents/index.html", "For agents — Toledo",
        "How an AI agent looks up a Toledo equation before using it.",
        "page-agents", 1, "agents.tmpl.html",
        build_agents_context(manifest, tools_table, mcp_json_text, coverage, root_rows,
                              bare_tools_rows=agents_bare_tools),
    )

    # /about/ (depth 1)
    emit(
        "about/index.html", "About — Toledo",
        "Licence, citation, coverage and policy summary for the Toledo registry.",
        "page-about", 1, "about.tmpl.html",
        build_about_context(manifest, root_rows, coverage, concept_doi,
                             compute_resistance_coverage(entries),
                             compute_executable_coverage(entries)),
    )

    # /ecosystem/ (depth 1) — site/content/ecosystem.md rendered through
    # render_ecosystem_html() (a purpose-built markdown->HTML pass, see
    # that function's own docstring) and emitted via emit_raw() the same
    # way every other hand-authored index-shaped page above already is
    # (browse/index.html, by-*/index.html). The page's own mermaid
    # flowchart renders client-side (needs_mermaid=True wires MERMAID_HEAD/
    # MERMAID_SCRIPTS into base.tmpl.html's {{mermaid_head}}/
    # {{mermaid_scripts}} slots) — no mermaid-CLI is installed on this
    # machine to pre-render an SVG at build time instead (checked).
    # Read relative to `templates_dir` (its sibling `content/`), not
    # `root` — `root` is the registry checkout under test in
    # tests/test_build.py's fixture build (which carries no site/content/
    # of its own, same reason that test passes the *real* site/templates/
    # in for templates_dir rather than a fixture copy).
    ecosystem_md_path = templates_dir.parent / "content" / "ecosystem.md"
    if ecosystem_md_path.exists():
        ecosystem_html = render_ecosystem_html(ecosystem_md_path.read_text(encoding="utf-8"))
        emit_raw(
            "ecosystem/index.html", "Ecosystem — Toledo",
            "How Toledo relates to the other public repositories in the same programme.",
            "page-ecosystem", 1, ecosystem_html, needs_mermaid=True,
        )
    else:
        pages_skipped.append("ecosystem/index.html")

    return {
        "pages_written": pages_written,
        "pages_skipped": pages_skipped,
        "templates_missing": sorted(ts.missing),
        "unresolved_placeholders": unresolved_report,
    }


def copy_data_into_dist(data_dir: pathlib.Path, out_dir: pathlib.Path) -> list[str]:
    """The URL scheme serves /data/*.json from the deployed tree; this
    copies the already-written site/data/ files verbatim into <out>/data/
    — a literal copy, not a second computation, so the two can never
    disagree."""
    copied = []
    dest_dir = out_dir / "data"
    dest_dir.mkdir(parents=True, exist_ok=True)
    for src in sorted(data_dir.glob("*.json")):
        dest = dest_dir / src.name
        dest.write_text(src.read_text(encoding="utf-8"), encoding="utf-8")
        copied.append(f"data/{src.name}")
    return copied


def copy_assets_into_dist(root: pathlib.Path, out_dir: pathlib.Path) -> list[str]:
    """Copies site/assets/ (stream S2's stylesheet + search script) into
    <out>/assets/ so the deployed tree is self-contained. This module does
    not author those files' content, only places them at the URL scheme's
    path (/assets/toledo.css, /assets/search.js)."""
    src_dir = root / "site" / "assets"
    if not src_dir.is_dir():
        return []
    copied = []
    dest_dir = out_dir / "assets"
    for src in sorted(src_dir.glob("*")):
        if not src.is_file():
            continue
        dest_dir.mkdir(parents=True, exist_ok=True)
        dest = dest_dir / src.name
        dest.write_bytes(src.read_bytes())
        copied.append(f"assets/{src.name}")
    return copied


def copy_executable_static_into_dist(root: pathlib.Path, out_dir: pathlib.Path) -> list[str]:
    """Copies `site/static/js/` (S2's own shared, unversioned kernel pair —
    `_qfrac.js`, `_ir_eval.js`, docs/EXECUTABLE_EQUATIONS_v0_1.md sec.5) into
    `<out>/static/js/` so the try-it widget's `<script src="{{root}}/
    static/js/...">` tags resolve in the deployed tree — the executable
    feature's own analogue of `copy_assets_into_dist` just above, kept as a
    separate function/output path (`/static/`, not `/assets/`) since
    `site/DESIGN.md`'s own URL scheme (predating this feature) never
    mentions `/static/` and this module must not blur the two. This module
    does not author those two files' content, only places them at the URL
    the widget already references."""
    src_dir = root / "site" / "static" / "js"
    if not src_dir.is_dir():
        return []
    copied = []
    dest_dir = out_dir / "static" / "js"
    for src in sorted(src_dir.glob("*.js")):
        if not src.is_file():
            continue
        dest_dir.mkdir(parents=True, exist_ok=True)
        dest = dest_dir / src.name
        dest.write_bytes(src.read_bytes())
        copied.append(f"static/js/{src.name}")
    return copied


def build_site(root: pathlib.Path, out_dir: pathlib.Path, data_dir: pathlib.Path,
                templates_dir: pathlib.Path, *, strict: bool = False) -> dict:
    data = build_data_files(root, data_dir)
    page_report = build_pages(root, out_dir, templates_dir, data)
    data_copied = copy_data_into_dist(data_dir, out_dir) if page_report["pages_written"] else []
    assets_copied = copy_assets_into_dist(root, out_dir) if page_report["pages_written"] else []
    executable_static_copied = (
        copy_executable_static_into_dist(root, out_dir) if page_report["pages_written"] else []
    )

    report = {
        "entry_count_canonical": data["manifest"]["entry_count"],
        "total_pages_in_registry": len(data["entries"]),
        "data_files_written": [
            str(data_dir / "manifest.json"),
            str(data_dir / "search-index.json"),
            str(data_dir / "tools-table.json"),
        ],
        "pages_written": len(page_report["pages_written"]),
        "pages_skipped": len(page_report["pages_skipped"]),
        "templates_missing": page_report["templates_missing"],
        "data_copied_into_dist": data_copied,
        "assets_copied_into_dist": assets_copied,
        "executable_static_copied_into_dist": executable_static_copied,
        "unresolved_placeholders": page_report["unresolved_placeholders"],
    }
    if strict and (page_report["templates_missing"] or page_report["unresolved_placeholders"]):
        raise SystemExit(
            "build_site --strict: missing templates or unresolved placeholders — "
            f"see report: {json.dumps(report, indent=2)}"
        )
    return report


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--root", type=pathlib.Path, default=REPO_ROOT, help="Toledo repo root")
    ap.add_argument("--out", type=pathlib.Path, default=DEFAULT_OUT, help="output directory for rendered pages")
    ap.add_argument("--data-dir", type=pathlib.Path, default=DEFAULT_DATA_DIR, help="site/data/ output directory")
    ap.add_argument("--templates-dir", type=pathlib.Path, default=DEFAULT_TEMPLATES_DIR,
                     help="site/templates/ input directory (stream S2)")
    ap.add_argument("--strict", action="store_true",
                     help="fail the build if any template is missing or a placeholder is unresolved")
    args = ap.parse_args(argv)
    report = build_site(args.root, args.out, args.data_dir, args.templates_dir, strict=args.strict)
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
