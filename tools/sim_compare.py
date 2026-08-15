#!/usr/bin/env python3
"""Diff the C core's sim numbers against the JS port's — the logic-side
render_diff. Exit 0 only on exact agreement.

    python3 tools/sim_compare.py produce

Runs tools/sim_trace.py (JS, headless chromium) and cport/host/smoke
--produce (C), joins per (save, colony), and prints every field that
disagrees.
"""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

FIELDS = ["pop", "sol", "centre", "eaten", "hammers", "bells", "crosses",
          "teaching", "out"]


def run_js():
    out = subprocess.run([sys.executable, ROOT / "tools/sim_trace.py",
                          "produce"], capture_output=True, text=True,
                         check=True).stdout
    data = json.loads(out)
    flat = {}
    for save, cols in data.items():
        for c in cols:
            flat[(save, c["name"])] = c
    return flat


def run_c():
    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host", check=True)
    out = subprocess.run(["./smoke", "--produce"], cwd=ROOT / "cport/host",
                         capture_output=True, text=True, check=True).stdout
    flat = {}
    for line in out.splitlines():
        c = json.loads(line)
        flat[(c["save"], c["name"])] = c
    return flat


def main():
    js, cc = run_js(), run_c()
    bad = 0
    for key in sorted(set(js) | set(cc)):
        j, c = js.get(key), cc.get(key)
        if j is None or c is None:
            print("ONLY IN %s: %s" % ("JS" if c is None else "C", key))
            bad += 1
            continue
        for f in FIELDS:
            if j[f] != c[f]:
                print("%s/%s .%s: JS %s != C %s"
                      % (key[0], key[1], f, j[f], c[f]))
                bad += 1
    n = len(set(js) | set(cc))
    print("%d colonies compared, %d disagreement(s)" % (n, bad))
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
