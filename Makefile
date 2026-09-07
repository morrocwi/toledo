.PHONY: coq verify library test build site catalogue mcp

coq: ; cd coq/master-river && coq_makefile -f _CoqProject -o Makefile >/dev/null && $(MAKE) -s
verify: coq ; cd coq/master-river && bash verify.sh | tail -1
library: ; python3 scripts/build_eq_library.py
test: ; python3 -m pytest -q tests

# MCP server (mcp/toledo_mcp/) — fast search/status/lookup over the registry
# files for any MCP-capable agent, stdio transport. Founder rule: look an
# equation up here before using it. Requires the `mcp` package
# (mcp/requirements-mcp.txt); everything else it uses is the stdlib.
mcp: ; python3 mcp/toledo_mcp/server.py

# GENERATOR + TOOLING layer (registry/CANONICAL.json + registry/genesis_root.json
# -> registry/entries, registry/TOLEDO.json, graph/, site/index.json, vault/, latex/catalogue_body.tex)
build: ; python3 scripts/toledo_build.py

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
