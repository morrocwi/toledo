# Licence note — solver arc (private) import

The upstream source for this directory is a **private** repository ("solver arc (private)",
name withheld per BBL-195/198). Its own `LICENSE` at the anchored commit is a proprietary,
all-rights-reserved licence ("Copyright (c) 2026 ANSE.ASIA / yaoharee.lt. All rights reserved.").

**Founder authorisation.** The owner (founder) explicitly authorised copying the private
solver arc's canonical Coq sources (the files listed in `PROVENANCE.json`) into Toledo under
**MIT**, recorded as decision **DEC-toledo-solver-arc-copy-2026-0906**. Under that authorisation:

- The `.v` files in `formal/` in this directory are relicensed **MIT** for their presence in
  this Toledo repository, per the founder's explicit grant.
- Provenance for every copied file is `"solver arc (private)"` plus the upstream commit and
  git blob hash — the private repository's own name is never written into this file or any
  other Toledo file (see `PROVENANCE.json`'s `redactions` for the two verbatim occurrences of
  the private repo's own name that were found inside copied source comments and replaced with
  `"solver arc (private)"` before commit).
- This authorisation covers exactly the files copied under this directory as of the commit in
  `PROVENANCE.json`; it is not a blanket relicense of the private repository's entire tree.

See also `docs/MEETING_2026-09-06_toledo_design.md` decision T9 for the full design rationale
(cite/copy split, exclusion of non-canonical `*_attempt.v` files, and the
`coq_source_redistributed` flag downstream consumers must respect).
