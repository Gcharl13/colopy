#!/usr/bin/env python3
"""
verify_assets.py — decode/encode round-trip of every file in raw/COLONIZE/.

For each file:
  * a format with a codec in tools/asset_codecs.py (PAL, MP, DAT, COL, MOV)
    is DECODED to its documented fields and RE-ENCODED; the result must be
    BIT-EXACT against the raw file (and against verification/
    golden_manifest.json when the file is listed there).  Fields the engine
    never reads are carried verbatim by the codec, and the format doc says
    which (formats/*.md "opaque").
  * a MADSPACK container (SS, PIK, FF) is DECODED through tools/ssdec.py --
    every section must expand to its directory size -- but not re-encoded:
    FAB compression is not byte-deterministic (formats/SS.md).  Pixel-level
    decoding is tools/extract_visuals.py's gate (G7), run beside this one.
  * everything else (TXT, SAV, EXE, BIN, GIF, ...) is byte-identity only: it
    is hashed against the manifest, nothing is claimed about its structure.

Exit 0 only when every codec round-trip is exact, every container decodes,
and nothing disagrees with the manifest.  Run under `make test` (assets).

Status before 2026-09-02 (REMAINING_WORK.md G6): this script printed an
inventory table with a hard-coded "TBD" per format and exit 0 -- it verified
nothing, cited a `tools/mpskit` that does not exist and a `verify_pal.py`
that does not exist, and listed a "PART" format of which no file exists
(RTLink overlay parts live INSIDE VICEROY.EXE, formats/RTLINK.md).

Usage:
    python3 tools/verify_assets.py                 # full report
    python3 tools/verify_assets.py --quiet         # one line per format
    python3 tools/verify_assets.py --emit DIR      # also write <NAME>.json per codec'd file
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COLONIZE = ROOT / "raw" / "COLONIZE"
GOLDEN = ROOT / "verification" / "golden_manifest.json"
STATUS = ROOT / "verification" / "verify_assets_status.json"

sys.path.insert(0, str(ROOT / "tools"))
import asset_codecs  # noqa: E402
import ssdec  # noqa: E402

CONTAINER_EXTS = {"SS", "PIK", "FF"}


def sha(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def check_file(f: Path, manifest: dict, emit: Path | None) -> dict:
    data = f.read_bytes()
    digest = sha(data)
    row = {"name": f.name, "size": len(data), "sha256": digest,
           "in_manifest": f.name in manifest, "manifest_ok": None,
           "mode": "identity", "codec": None, "ok": True, "note": ""}
    if f.name in manifest:
        row["manifest_ok"] = (manifest[f.name]["sha256"] == digest
                              and manifest[f.name]["size"] == len(data))
        if not row["manifest_ok"]:
            row["ok"] = False
            row["note"] = "raw file differs from golden manifest"

    ext = f.name.rsplit(".", 1)[-1].upper() if "." in f.name else ""
    c = asset_codecs.codec_for(f.name)
    if c is not None:
        key, dec, enc, opaque = c
        row["mode"] = "round-trip"
        row["codec"] = key
        try:
            obj = dec(data)
            back = enc(obj)
        except Exception as exc:           # a codec fault IS a failure
            row["ok"] = False
            row["note"] = "codec raised %s: %s" % (type(exc).__name__, exc)
            return row
        if back != data:
            row["ok"] = False
            row["note"] = "re-encode differs (%d vs %d bytes)" % (len(back), len(data))
        row["opaque"] = opaque
        if emit is not None:
            emit.mkdir(parents=True, exist_ok=True)
            (emit / (f.name + ".json")).write_text(json.dumps(
                {"source_file": f.name, "source_sha256": digest, "codec": key, **obj}, indent=1))
    elif ext in CONTAINER_EXTS:
        row["mode"] = "decode-only"
        row["codec"] = "ssdec.madspack_load"
        try:
            secs = ssdec.madspack_load(data)
            row["note"] = "%d sections" % len(secs)
        except Exception as exc:
            row["ok"] = False
            row["note"] = "container decode failed: %s: %s" % (type(exc).__name__, exc)
    return row


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--quiet", action="store_true", help="one summary line per format")
    ap.add_argument("--emit", type=Path, help="write the decoded JSON of every codec'd file here")
    ap.add_argument("--format", help="limit to one extension (e.g. COL)")
    args = ap.parse_args()

    if not COLONIZE.is_dir():
        print("verify_assets: %s is missing -- run bin/reconstitute.py (raw/ is git-ignored)"
              % COLONIZE)
        return 2
    manifest = json.loads(GOLDEN.read_text()) if GOLDEN.exists() else {}

    files = sorted(p for p in COLONIZE.iterdir() if p.is_file())
    if args.format:
        want = args.format.upper().lstrip(".")
        files = [p for p in files if p.name.upper().endswith("." + want)]

    rows = [check_file(f, manifest, args.emit) for f in files]

    by_ext: dict[str, list] = {}
    for r in rows:
        ext = r["name"].rsplit(".", 1)[-1].upper() if "." in r["name"] else "(none)"
        by_ext.setdefault(ext, []).append(r)

    bad = [r for r in rows if not r["ok"]]
    missing = [r["name"] for r in rows if not r["in_manifest"]]

    print("verify_assets: %d files in %s, %d in the golden manifest"
          % (len(rows), COLONIZE.relative_to(ROOT), len(manifest)))
    for ext in sorted(by_ext):
        grp = by_ext[ext]
        modes = sorted({r["mode"] for r in grp})
        n_ok = sum(1 for r in grp if r["ok"])
        codecs = sorted({r["codec"] for r in grp if r["codec"]})
        print("  %-6s %4d files  %-12s %s  %d/%d ok"
              % (ext, len(grp), "/".join(modes), ",".join(codecs) or "-", n_ok, len(grp)))
        if not args.quiet:
            for r in grp:
                if r["mode"] != "identity" or not r["ok"]:
                    print("      %-14s %-11s %s%s" % (r["name"], "OK" if r["ok"] else "FAIL",
                                                     r["codec"] or "", (" -- " + r["note"]) if r["note"] else ""))
    for r in bad:
        print("  FAIL %s: %s" % (r["name"], r["note"]))
    if missing:
        print("  not in golden manifest (%d): %s%s" % (len(missing), ", ".join(missing[:8]),
                                                       " ..." if len(missing) > 8 else ""))

    STATUS.parent.mkdir(parents=True, exist_ok=True)
    STATUS.write_text(json.dumps({
        "total": len(rows),
        "round_trip_pass": sum(1 for r in rows if r["mode"] == "round-trip" and r["ok"]),
        "round_trip_fail": sum(1 for r in rows if r["mode"] == "round-trip" and not r["ok"]),
        "decode_only_pass": sum(1 for r in rows if r["mode"] == "decode-only" and r["ok"]),
        "identity": sum(1 for r in rows if r["mode"] == "identity"),
        "not_in_manifest": missing,
        "details": rows,
    }, indent=1))
    if bad:
        print("verify_assets: FAIL (%d)" % len(bad))
        return 1
    print("verify_assets: OK (%d round-trip, %d decode-only, %d identity)"
          % (sum(1 for r in rows if r["mode"] == "round-trip"),
             sum(1 for r in rows if r["mode"] == "decode-only"),
             sum(1 for r in rows if r["mode"] == "identity")))
    return 0


if __name__ == "__main__":
    sys.exit(main())
