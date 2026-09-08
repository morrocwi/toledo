.PHONY: coq verify library test build site catalogue mcp resistance executable

coq: ; cd coq/master-river && coq_makefile -f _CoqProject -o Makefile >/dev/null && $(MAKE) -s
verify: coq ; cd coq/master-river && bash verify.sh | tail -1
library: ; python3 scripts/build_eq_library.py
test: ; python3 -m pytest -q tests

# MCP server (mcp/toledo_mcp/) — fast search/status/lookup over the registry
# files for any MCP-capable agent, stdio transport. Founder rule: look an
# equation up here before using it. Requires the `mcp` package
# (mcp/requirements-mcp.txt); everything else it uses is the stdlib.
mcp: ; python3 mcp/toledo_mcp/server.py

# Resistance Ladder + Reproduction Ledger (S3, design/RESISTANCE_LADDER_v0_1.md,
# founder ruling BBL-2026-09-07-229): computes/writes the `resistance` block into
# registry/CANONICAL.json + registry/genesis_root.json IN PLACE (never touches any
# other content field, never touches LINEAGE.jsonl). Must run BEFORE `build` below,
# which only PROPAGATES this field — it never computes a rung itself.
resistance: ; python3 scripts/compute_resistance.py

# Executable Equations (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.3.1/sec.10, S3):
# computes/writes the `executable` block into registry/CANONICAL.json IN PLACE
# from registry/executable/*.json IR sidecars (a human registrar's own files,
# never written here), plus registry/executable/INDEX.json. Same in-place-write
# discipline as `resistance` above, never touches registry/LINEAGE.jsonl. Runs
# BEFORE `build` below (scripts/compute_executable.py's own docstring), which
# only PROPAGATES this field into registry/entries/*.json — it never computes
# the block itself.
executable: ; python3 scripts/compute_executable.py

# GENERATOR + TOOLING layer (registry/CANONICAL.json + registry/genesis_root.json
# -> registry/entries, registry/TOLEDO.json, graph/, site/index.json, vault/, latex/catalogue_body.tex)
# Also (re)builds mcp/state/index.sqlite3 (mcp/scripts/build_index.py, DEBT #48
# lane E, 2026-09-07) so a release zip ships a prebuilt index instead of every
# MCP cold start paying an avoidable rebuild — see mcp/BENCHMARKS.md.
build: resistance executable ; python3 scripts/toledo_build.py && python3 mcp/scripts/build_index.py

# Static docs site (reads what `make build` wrote)
site: build ; python3 site/build_site.py

# Printable catalogue PDF; skipped (not an error) if docs/RAM_LOW exists (RAM watchdog gate).
# One pdflatex process at a time via latexmk -pdf. scripts/latex_pdf_safe.py first derives
# latex/catalogue_body.pdf.tex from the generated catalogue_body.tex (Thai/Cyrillic runs ->
# a disclosed placeholder; everything else passes through) and latex/unicode_pdf_fallback.sty
# maps the remaining literal Unicode (math alphanumerics, arrows, relations, ...) to standard
# LaTeX constructs — see latex/catalogue.tex for why.
catalogue: build
	@if [ -f docs/RAM_LOW ]; then \
		echo "docs/RAM_LOW present — skipping pdflatex (RAM watchdog gate)"; \
	else \
		python3 scripts/latex_pdf_safe.py && cd latex && latexmk -pdf -interaction=nonstopmode catalogue.tex; \
	fi
