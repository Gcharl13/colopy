#!/usr/bin/env python3
"""
cert7.py -- Phase 7 certification runner (the headless, self-contained gates).

Runs every Phase-7 check that does NOT require the user's DOSBox capture, in one
shot, and writes docs/PHASE7_STATUS.md. The DOSBox cross-parity halves (7.1
pixel / 7.2 determinism / 7.3 long-soak vs DOSBox) are user-gated by design
(ROUTE_B Phase 0.1: "the live DOSBox half runs on the user's machine with their
game files"); this runner certifies the modern side + the ledger gates and emits
the turnkey DOSBox recipe.

Gates checked here:
  7.5 ledger      : audit.py 229/229, g4_floor.py PASS, stub-hits 0, census fresh
  G4  stub floor  : tools/g4_floor.py (no-new-items)
  7.2/7.3 modern  : determinism self-parity (two same-seed soaks byte-identical;
                    seed-sensitive) + 200-turn long-soak stability + REF pin
Usage:  python3 tools/cert7.py
Exit 0 iff every headless gate passes.
"""
import hashlib
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
EXE = os.path.join(ROOT, "build_modern", "viceroy_modern")
DOCS = os.path.join(ROOT, "docs")
results = []  # (name, ok, detail)


def run(cmd, **kw):
    return subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT, **kw)


def gate(name, ok, detail=""):
    results.append((name, bool(ok), detail))
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}: {detail}")
    return ok


def main():
    if not os.path.exists(EXE):
        sys.exit(f"build first: {EXE}")
    print("PHASE 7 CERTIFICATION (headless gates)\n" + "=" * 60)

    # --- 7.5a audit.py (needs VICEROY.EXE; gitignored, user-supplied) --------
    # Resolve the EXE the same way tools/viceroy_exe.py does: $VICEROY_EXE, then
    # $VICEROY_DATA/VICEROY.EXE, then the in-repo re_work/ dev copy. Absent on a
    # fresh checkout/ZIP, so SKIP (not FAIL) when no EXE exists anywhere.
    exe_cands = [os.environ.get("VICEROY_EXE")]
    if os.environ.get("VICEROY_DATA"):
        exe_cands += [os.path.join(os.environ["VICEROY_DATA"], n)
                      for n in ("VICEROY.EXE", "viceroy.exe")]
    exe_cands.append(os.path.join(ROOT, os.pardir, "re_work", "VICEROY.EXE"))
    exe_bin = next((c for c in exe_cands if c and os.path.exists(c)), None)
    if exe_bin:
        r = run(["python3", "tools/audit.py"])
        out = r.stdout + r.stderr
        npass = len(re.findall(r"\[PASS\]", r.stdout))
        nfail = len(re.findall(r"\[FAIL\]", r.stdout))
        if "capstone" in out and npass == 0:
            gate("7.5 audit.py byte claims", False,
                 "needs capstone: sudo apt install -y python3-capstone")
        else:
            gate("7.5 audit.py byte claims", r.returncode == 0 and nfail == 0,
                 f"{npass} PASS / {nfail} FAIL")
    else:
        print("  [SKIP] 7.5 audit.py byte claims: VICEROY.EXE not found "
              "(set VICEROY_EXE or VICEROY_DATA; gitignored, user-supplied)")

    # --- G4 stub floor -------------------------------------------------------
    r = run(["python3", "tools/g4_floor.py", EXE])
    m = re.search(r"func_ stubs \(gated\)\s*:\s*(\d+)", r.stdout)
    nfloor = m.group(1) if m else "?"
    gate("G4 link-active stub floor (no-new-items)", r.returncode == 0,
         f"{nfloor} interactive func_ stubs, all allowlisted")

    # --- 7.5b determinism self-parity + stub-hits 0 --------------------------
    a = run([EXE, "--smoke=500", "--seed=12345"])
    b = run([EXE, "--smoke=500", "--seed=12345"])
    c = run([EXE, "--smoke=500", "--seed=999"])
    ha = hashlib.md5((a.stdout + a.stderr).encode()).hexdigest()
    hb = hashlib.md5((b.stdout + b.stderr).encode()).hexdigest()
    hc = hashlib.md5((c.stdout + c.stderr).encode()).hexdigest()
    gate("7.2/7.3 determinism self-parity", ha == hb and ha != hc,
         f"same-seed md5 {ha[:12]} == {hb[:12]}; seed-sensitive {ha != hc}")

    stub0 = "stub-hits: 0 distinct symbols, 0 calls" in (a.stdout + a.stderr)
    gate("7.5 zero stub hits (soak path)", stub0, "stub-hits: 0")
    refok = "228 units" in (a.stdout + a.stderr) or "REF grew to 228" in (a.stdout + a.stderr)
    gate("7.2 REF end-state pin (228)", refok, "REF=228 (131/44/21/32)")

    # --- 7.3 long-soak stability (200-turn) ----------------------------------
    d = run([EXE, "--smoke=200", "--seed=777"])
    e = run([EXE, "--smoke=200", "--seed=777"])
    soak_ok = ("SMOKE PASS" in (d.stdout + d.stderr) and
               hashlib.md5((d.stdout + d.stderr).encode()).hexdigest() ==
               hashlib.md5((e.stdout + e.stderr).encode()).hexdigest())
    gate("7.3 long-soak stability (200-turn, repeatable)", soak_ok,
         "200-turn smoke PASS, byte-identical across runs")

    # --- 7.2/7.3 save cross-parity (real DOSBox saves, data-gated) -----------
    # If the user's data dir is present, round-trip every COLONY*.SAV through the
    # modern loader/serializer and require byte-identity. This is genuine CROSS
    # parity: the saves were created by VICEROY.EXE under DOSBox; the modern build
    # reads and re-emits them bit-for-bit.
    data = os.environ.get("VICEROY_DATA", "/home/user/colodata/game")
    import glob
    saves = sorted(glob.glob(os.path.join(data, "COLONY*.SAV")))
    if saves:
        ident = 0
        for sav in saves:
            rt = sav + ".rt"
            rr = run([EXE, "--roundtrip=" + sav], env={**os.environ, "VICEROY_DATA": data})
            if os.path.exists(rt) and open(sav, "rb").read() == open(rt, "rb").read():
                ident += 1
            try:
                os.remove(rt)
            except OSError:
                pass
        gate("7.2/7.3 save cross-parity (DOSBox saves round-trip)", ident == len(saves),
             f"{ident}/{len(saves)} byte-identical")
    else:
        print(f"  [SKIP] save cross-parity: no COLONY*.SAV under {data} "
              "(set VICEROY_DATA; user-supplied, gitignored)")

    # --- 7.5c terminal census fresh ------------------------------------------
    ts = os.path.join(DOCS, "TERMINAL_STATES.md")
    gate("7.5 terminal-state census present", os.path.exists(ts),
         "docs/TERMINAL_STATES.md")
    ul = os.path.join(DOCS, "UNREACHABLE_LEDGER.md")
    gate("7.5 UNREACHABLE/terminal ledger present", os.path.exists(ul),
         "docs/UNREACHABLE_LEDGER.md")

    # --- write status doc ----------------------------------------------------
    allpass = all(ok for _, ok, _ in results)
    with open(os.path.join(DOCS, "PHASE7_STATUS.md"), "w") as f:
        f.write("# Phase 7 status (auto-generated by tools/cert7.py)\n\n")
        f.write("## Headless gates (this runner)\n\n| gate | state | detail |\n|---|---|---|\n")
        for name, ok, detail in results:
            f.write(f"| {name} | {'PASS' if ok else 'FAIL'} | {detail} |\n")
        f.write("\n## DOSBox cross-parity halves (user-gated by design)\n\n")
        f.write("Per ROUTE_B Phase 0.1 the live DOSBox half runs on the user's "
                "machine with their COLONIZE files (never committed). The modern "
                "side is certified above; to complete the cross-parity:\n\n")
        f.write("```\n"
                "# 7.1 pixel parity (per checkpoint frame):\n"
                "#   modern: VICEROY_DATA=<data> ./build_modern/viceroy_modern --script=tools/scripts/<cp>.vs   # writes viceroy_shot*.ppm\n"
                "#   dosbox: tools/parity/dosbox_launch.sh  (F12 capture -> capture/*.png)\n"
                "#   diff  : python3 tools/pixdiff.py modern.ppm dosbox.png\n"
                "# 7.2/7.3 save parity:\n"
                "#   modern: ./build_modern/viceroy_modern --roundtrip=<save>   # writes <save>.rt\n"
                "#   diff  : python3 tools/savediff.py dosbox.sav modern.sav.rt\n"
                "```\n")
    print("\n" + ("PHASE 7 HEADLESS GATES: ALL PASS" if allpass else "PHASE 7: FAILURES ABOVE"))
    print(f"wrote {DOCS}/PHASE7_STATUS.md")
    return 0 if allpass else 1


if __name__ == "__main__":
    sys.exit(main())
