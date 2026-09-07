"""File-hash helpers used for index invalidation (never for equivalence
matching — that lives in equivalence.py and is deliberately not a hash)."""
from __future__ import annotations

import hashlib
import pathlib


def sha256_file(path: pathlib.Path, chunk_size: int = 1 << 20) -> str | None:
    if not path.exists():
        return None
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        while True:
            chunk = fh.read(chunk_size)
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest()


def file_fingerprint(path: pathlib.Path) -> dict:
    """Cheap fingerprint used to decide, without re-hashing every call,
    whether a full sha256 comparison is even worth doing: size + mtime_ns.
    ``needs_rebuild`` in index.py compares this first and only falls back to
    sha256 when it differs, since sha256 over a multi-MB JSON file on every
    tool call would dominate latency for no benefit once mtime/size already
    prove the file changed or is unchanged."""
    if not path.exists():
        return {"exists": False, "size": None, "mtime_ns": None}
    st = path.stat()
    return {"exists": True, "size": st.st_size, "mtime_ns": st.st_mtime_ns}
