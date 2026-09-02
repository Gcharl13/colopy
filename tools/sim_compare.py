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


M_FIELDS = ["gold", "fund", "market", "accum", "tons", "tgold"]


def run_js_market():
    out = subprocess.run([sys.executable, ROOT / "tools/sim_trace.py",
                          "market"], capture_output=True, text=True,
                         check=True).stdout
    return {r["step"]: r for r in json.loads(out)}


def run_c_market():
    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host", check=True)
    out = subprocess.run(["./smoke", "--market"], cwd=ROOT / "cport/host",
                         capture_output=True, text=True, check=True).stdout
    return {json.loads(l)["step"]: json.loads(l) for l in out.splitlines()}


def compare_market():
    js, cc = run_js_market(), run_c_market()
    bad = 0
    for step in js:
        for f in M_FIELDS:
            if js[step][f] != cc.get(step, {}).get(f):
                print("%s .%s:\n  JS %s\n  C  %s"
                      % (step, f, js[step][f], cc.get(step, {}).get(f)))
                bad += 1
    print("%d steps compared, %d disagreement(s)" % (len(js), bad))
    sys.exit(1 if bad else 0)


import random
import tempfile


def sweep_cases(mode):
    rnd = random.Random(1653)          # fixed seed: both sides see one list
    if mode == "movecost":
        DIRS = [(0, -1), (1, 0), (0, 1), (-1, 0), (-1, -1), (1, -1), (1, 1), (-1, 1)]
        cases = []
        for _ in range(400):
            x, y = rnd.randrange(1, 57), rnd.randrange(1, 71)
            dx, dy = rnd.choice(DIRS)
            cases.append([rnd.random() < 0.2, x, y, x + dx, y + dy])
        return [[int(c[0])] + c[1:] for c in cases]
    # combat: types x tiles x flag combinations
    TYPES = [0, 1, 4, 11, 13, 16, 17]   # Colonists Soldiers Dragoons Artillery
                                        # Caravel Privateer Frigate
    coords = [(rnd.randrange(1, 57), rnd.randrange(1, 71)) for _ in range(10)]
    cases = []
    for ty in TYPES:
        for (x, y) in coords:
            for de in (0, 1):
                for orders in (0, 5):
                    for fat in (0, 1, 2):
                        dam = rnd.random() < 0.3
                        holds = rnd.choice([0, 0, 3]) if ty >= 13 else 0
                        vet = 1 if (ty in (1, 4) and rnd.random() < 0.5) else 0
                        cases.append([ty, x, y, de, orders, fat, int(dam),
                                      holds, vet])
    return cases


def compare_sweep(mode):
    cases = sweep_cases(mode)
    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
        json.dump(cases, f)
        path = f.name
    js = json.loads(subprocess.run(
        [sys.executable, ROOT / "tools/sim_trace.py", mode, path],
        capture_output=True, text=True, check=True).stdout)
    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host", check=True)
    feed = "\n".join(" ".join(str(v) for v in c) for c in cases)
    cc = [int(x) for x in subprocess.run(
        ["./smoke", "--" + mode], cwd=ROOT / "cport/host", input=feed,
        capture_output=True, text=True, check=True).stdout.split()]
    bad = 0
    for i, (a, b) in enumerate(zip(js, cc)):
        if a != b:
            print("case %d %s: JS %s != C %s" % (i, cases[i], a, b))
            bad += 1
            if bad > 15:
                print("...")
                break
    print("%d cases compared, %d disagreement(s)" % (len(cases), bad))
    sys.exit(1 if bad else 0)


def compare_turns(save, n, extra=()):
    extra = list(extra)
    js = json.loads(subprocess.run(
        [sys.executable, ROOT / "tools/sim_trace.py", "turns", save, str(n)]
        + extra, capture_output=True, text=True, check=True).stdout)
    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host", check=True)
    cc = [json.loads(l) for l in subprocess.run(
        ["./smoke", "--turns", save, str(n)] + extra, cwd=ROOT / "cport/host",
        capture_output=True, text=True, check=True).stdout.splitlines()]
    # SCOPE-REASON: B4.2 -- the C has no tutorial bindings (tutOnce), so the
    # TUTORIAL* events exist on the JS side only; dropped from both lists.
    tut = lambda evs: [e for e in evs if not e.startswith("TUTORIAL")]
    bad = 0
    for i, (j, c) in enumerate(zip(js, cc)):
        j["events"] = tut(j["events"])
        c["events"] = tut(c["events"])
        if j == c:
            continue
        for f in j:
            if j[f] != c.get(f):
                print("turn %d .%s:\n  JS %s\n  C  %s" % (i + 1, f, j[f], c.get(f)))
                bad += 1
        if bad > 12:
            print("...")
            break
    print("%s: %d turns compared, %d field disagreement(s)" % (save, len(cc), bad))
    return bad


def compare_pak():
    """COLOPY.PAK census (smoke --pak) vs the JS DATA census
    (port/assets/manifest.json — the source of DATA.sheets/fonts/cycle).
    PHYS0C is the JS renderer's derived re-key of PHYS0 and has no pak
    entry; the C renderer re-derives it (tools/gen_sd_pack.py)."""
    pak = ROOT / "cport/pak/COLOPY.PAK"
    if not pak.exists():
        subprocess.run([sys.executable, ROOT / "tools/gen_sd_pack.py"],
                       check=True)
    subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host", check=True)
    cen = json.loads(subprocess.run(
        ["./smoke", "--pak", str(pak)], cwd=ROOT / "cport/host",
        capture_output=True, text=True, check=True).stdout)
    man = json.load(open(ROOT / "port/assets/manifest.json"))
    ent = {e["name"]: e for e in cen["entries"]}
    bad = 0 if cen["ok"] else 1

    for nm, meta in sorted(man["sheets"].items()):
        # SCOPE-REASON: structural -- PHYS0C is the JS renderer's derived
        # re-key of PHYS0; it has no pak entry and the C re-derives it.
        if nm == "PHYS0C":
            continue
        e = ent.get(nm + ".SS")
        if e is None:
            print("MISSING sheet:", nm); bad += 1; continue
        mf = meta["frames"]
        if e["frames"] != len(mf):
            print("%s: frames C %d JS %d" % (nm, e["frames"], len(mf)))
            bad += 1
            continue
        for i, f in enumerate(mf):
            if (e["fw"][i], e["fh"][i]) != (f["w"], f["h"]):
                print("%s frame %d: C %dx%d JS %dx%d"
                      % (nm, i, e["fw"][i], e["fh"][i], f["w"], f["h"]))
                bad += 1
        if e["pal"] != 1:      # every sheet packs its embedded palette
            print("%s: palette missing from pak" % nm)
            bad += 1
    for nm, meta in sorted(man["backgrounds"].items()):
        e = ent.get(nm + ".PIK")
        if e is None:
            print("MISSING background:", nm); bad += 1; continue
        if (e["w"], e["h"]) != (meta["w"], meta["h"]):
            print("%s.PIK: C %dx%d JS %dx%d"
                  % (nm, e["w"], e["h"], meta["w"], meta["h"]))
            bad += 1
    for nm, meta in sorted(man["fonts"].items()):
        e = ent.get(nm + ".FF")
        if e is None:
            print("MISSING font:", nm); bad += 1; continue
        if e["h"] != meta["h"]:
            print("%s.FF: cell height C %d JS %d" % (nm, e["h"], meta["h"]))
            bad += 1
        for ch, wd in meta["widths"].items():
            if e["widths"].get(str(ch)) != wd:
                print("%s.FF width(%s): C %s JS %s"
                      % (nm, ch, e["widths"].get(str(ch)), wd))
                bad += 1
    cy = man["cycle"]
    e = ent.get("CYCLE")
    if e is None or e.get("cycle") != [cy["start"], cy["len"], cy["delay"]]:
        print("CYCLE: C %s JS %s" % (e and e.get("cycle"),
                                     [cy["start"], cy["len"], cy["delay"]]))
        bad += 1
    for req in ("VICEROY.PAL", "TEXT"):
        if req not in ent:
            print("MISSING:", req); bad += 1
    if "TEXT" in ent and ent["TEXT"].get("text", 0) < 1000:
        print("TEXT: suspiciously few pairs:", ent["TEXT"].get("text"))
        bad += 1
    print("pak census: %d entries, %d disagreement(s)" % (cen["count"], bad))
    sys.exit(1 if bad else 0)


def main():
    if sys.argv[1:2] == ["pak"]:
        compare_pak()
    if sys.argv[1:2] == ["newgame"]:
        # colopy_new_game vs beginGame: entry 0 = the fresh state, then N
        # full endTurn()s — across all four nations at two difficulties
        n = int(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[2].isdigit() else 10
        subprocess.run(["make", "-s", "smoke"], cwd=ROOT / "cport/host", check=True)
        # SCOPE-REASON: B4.2 -- tutorial bindings unported in the C; the
        # TUTORIAL* events are JS-only and dropped from both lists.
        tut = lambda evs: [e for e in evs if not e.startswith("TUTORIAL")]
        bad = 0
        for nation in range(4):
            for diff in (0, 2):
                js = json.loads(subprocess.run(
                    [sys.executable, ROOT / "tools/sim_trace.py", "newgame",
                     str(nation), str(diff), str(n)],
                    capture_output=True, text=True, check=True).stdout)
                cc = [json.loads(l) for l in subprocess.run(
                    ["./smoke", "--newgame", str(nation), str(diff), str(n)],
                    cwd=ROOT / "cport/host",
                    capture_output=True, text=True, check=True).stdout.splitlines()]
                nbad = 0
                for i, (j, c) in enumerate(zip(js, cc)):
                    j["events"] = tut(j["events"])
                    c["events"] = tut(c["events"])
                    if j == c:
                        continue
                    for f in j:
                        if j[f] != c.get(f):
                            print("n%d d%d entry %d .%s:\n  JS %s\n  C  %s"
                                  % (nation, diff, i, f, j[f], c.get(f)))
                            nbad += 1
                    if nbad > 8:
                        print("...")
                        break
                print("newgame n%d d%d: %d entries compared, %d disagreement(s)"
                      % (nation, diff, len(cc), nbad))
                bad += nbad
        sys.exit(1 if bad else 0)
    if sys.argv[1:2] == ["turns"]:
        extra = [f for f in ("agitate", "script") if f in sys.argv[2:]]
        bad = 0
        for save in ("savnewcolony", "savraleigh", "sav1653"):
            bad += compare_turns(save, int(sys.argv[2]) if len(sys.argv) > 2
                                 and sys.argv[2].isdigit() else 20, extra)
        sys.exit(1 if bad else 0)
    if sys.argv[1:2] == ["market"]:
        compare_market()
    if sys.argv[1:2] in (["movecost"], ["combat"]):
        compare_sweep(sys.argv[1])
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
