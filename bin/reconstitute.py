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
out = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else here
out.mkdir(parents=True, exist_ok=True)

sums = {}
sumfile = here / "SHA256SUMS.txt"
if sumfile.exists():
    for line in sumfile.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("MISSING"):
            h, n = line.split(None, 1)
            sums[n.strip()] = h.strip()

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
