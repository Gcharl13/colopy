#!/usr/bin/env python3
"""
reconstitute.py -- rebuild the original DOS executables from their base64
byte-records, so the disassembly can be continued on the real bytes.

These .b64 files are the *transformed* (non-runnable, non-original-format) byte
record of the executables this project disassembles. Run this once after cloning
to materialize the real .EXE files locally (they are git-ignored and never
committed in original form).

Usage:
    python reconstitute.py [outdir]      # default outdir = ./bin
Verifies every output against SHA256SUMS.txt.
"""
import base64, hashlib, sys, pathlib

here = pathlib.Path(__file__).resolve().parent
repo = here.parent
# Default outdir = <repo>/raw/COLONIZE/ -- the path the disasm tool suite
# (tools/disasm_mz.py, tools/rtlink/rtlink_decode.py, callgraph.py, parse_thunks.py,
# find_missed_funcs.py, ...) already looks in. So `python bin/reconstitute.py` with
# NO args makes the whole bench find the bytes. Pass an explicit dir to override.
out = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else (repo / "raw" / "COLONIZE")
out.mkdir(parents=True, exist_ok=True)

sums = {}
sumfile = here / "SHA256SUMS.txt"
if sumfile.exists():
    for line in sumfile.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("MISSING"):
            h, n = line.split(None, 1)
            sums[n.strip()] = h.strip()

# col.zip (repo root — the AUDIT.md §3.6 policy exception, kept per user
# decision) carries the FULL original file set: the asset files
# (.SS/.PIK/.FF/.SAV/CYCLE.DAT/...) that the .b64 records here do not
# cover, and that tools/gen_sd_pack.py + port/tools/build_assets.py
# read.  Extract it first; the .b64 loop below then overwrites its
# members with the SHA-verified bytes.
colzip = repo / "col.zip"
if colzip.exists():
    import zipfile
    n_ext = 0
    with zipfile.ZipFile(colzip) as z:
        for m in z.namelist():
            base = pathlib.PurePosixPath(m).name
            if (m.startswith("__MACOSX/") or m.endswith("/") or
                    not base or base.startswith("._")):
                continue                  # macOS resource-fork junk
            (out / base).write_bytes(z.read(m))
            n_ext += 1
    print(f"extracted col.zip: {n_ext} files -> {out}")
else:
    print("NOTE: col.zip not found — only the .b64 records will be "
          "materialized (the .SS/.PIK/.FF assets will be missing)")

rc = 0
for b64 in sorted(here.glob("*.b64")):
    name = b64.stem                       # e.g. "VICEROY.EXE"
    data = base64.b64decode(b64.read_text())
    (out / name).write_bytes(data)
    got = hashlib.sha256(data).hexdigest()
    exp = sums.get(name)
    if exp is None:
        status = "no checksum on file"
    elif got == exp:
        status = "sha256 OK"
    else:
        status = f"SHA256 MISMATCH (expected {exp}, got {got})"; rc = 1
    print(f"{name:18} {len(data):>7} bytes  {status}")

print(f"\nReconstituted into: {out}")
sys.exit(rc)
