#!/usr/bin/env python3
"""dos_world_oracle.py -- the port's new-game builders against the REAL game.

Every other gate proves C == JS.  This one takes a world the ORIGINAL built
(tools/dos_world_capture.py's dump of a DOSBox session sitting on a fresh
NEW WORLD map) and asks whether the port builds the SAME world from the
same seed -- terrain, the plane-2 bits, the landmass labels, then the 84
native settlements and their braves.

The trick that makes it exact: VICEROY reseeds its C-runtime LCG from the
clock (func_00C31C: srand(time & 0x7FFF), the argument ignored) right before
the builder (@0x075793) and again at the natives placer's entry (@0x065D2F),
so each block runs on a stream that starts from a 15-BIT word.  The builder's
first draw is the salt [0x190] = random_int(1, 0x7FFF) (@0x64A16), which pins
its seed to (usually) one candidate out of 32768; the natives' seed is found
by running the port's placer from every candidate against the dumped
settlements.

    python3 tools/dos_world_oracle.py PREFIX            # both halves
    python3 tools/dos_world_oracle.py PREFIX --builder  # the builder only
    python3 tools/dos_world_oracle.py PREFIX --natives  # the natives only

PREFIX.bin / PREFIX.json come from dos_world_capture.py.  Exit 1 when either
half finds no seed that reproduces the DOS world.
"""
import json
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SMOKE = os.path.join(ROOT, 'cport', 'host', 'smoke')
W, H = 58, 72
P = W * H


def lcg_draw(state):
    state = (state * 214013 + 2531011) & 0xFFFFFFFF
    return state, (state >> 16) & 0x7FFF


def random_int(state, lo, hi):
    state, r = lcg_draw(state)
    return state, lo + ((r * (hi - lo + 1)) >> 15)


def builder_seeds(salt):
    out = []
    for s in range(0x8000):
        _, v = random_int(s, 1, 0x7FFF)
        if v == salt:
            out.append(s)
    return out


def run_world(seed, mode, words, out):
    subprocess.run([SMOKE, '--worldcheck', str(seed), str(mode)] +
                   [str(w) for w in words] + [out],
                   check=True, capture_output=True, text=True)
    return open(out, 'rb').read()


def plane_report(name, a, b, mask=0xFF):
    diff = [(i % W, i // W, a[i], b[i]) for i in range(P) if (a[i] & mask) != (b[i] & mask)]
    print('  %-8s %5d/%d squares differ%s' % (name, len(diff), P,
          '' if not diff else '  e.g. ' + ', '.join('(%d,%d) dos %02X port %02X' % d for d in diff[:6])))
    return len(diff)


def bits_report(a, b):
    for bit in range(8):
        m = 1 << bit
        n = sum(1 for i in range(P) if (a[i] & m) != (b[i] & m))
        na = sum(1 for i in range(P) if a[i] & m)
        nb = sum(1 for i in range(P) if b[i] & m)
        if n or na or nb:
            print('    bit 0x%02X: dos %4d set, port %4d set, %4d differ' % (m, na, nb, n))


def check_builder(prefix, info, dos):
    salt = info['salt']
    words = info['custom']
    mode = 1 if info['premade_flag_5388'] else 0
    seeds = builder_seeds(salt)
    print('builder: salt %d -> %d candidate seed(s) %s; words %s, mode %d'
          % (salt, len(seeds), seeds[:8], words, mode))
    best = None
    for s in seeds:
        out = prefix + '.port_%d.bin' % s
        port = run_world(s, mode, words, out)
        nt = sum(1 for i in range(P) if port[i] != dos[i])
        if best is None or nt < best[1]:
            best = (s, nt, port)
    if best is None:
        print('builder: no seed reproduces the salt -- srand/rand model wrong?')
        return False
    s, nt, port = best
    print('builder: seed %d (port mseed %d)' % (s, salt))
    t = plane_report('terrain', dos[:P], port[:P])
    print('  improve (plane 2), by bit:')
    bits_report(dos[P:2 * P], port[P:2 * P])
    r = plane_report('region', dos[2 * P:3 * P], port[2 * P:3 * P], 0x0F)
    plane_report('owner', dos[2 * P:3 * P], port[2 * P:3 * P], 0xF0)
    starts = port[4 * P:4 * P + 8]
    print('  port starts %s' % [(starts[2 * i], starts[2 * i + 1]) for i in range(4)])
    ships = [(u[0], u[1]) for u in info['units'] if u[2] in (13, 14, 15) and (u[3] & 0x0F) < 4]
    print('  dos ships at %s (each power\'s first ship; equal to the starts only on a'
          ' capture taken before any unit moved)' % ships[:8])
    return t == 0 and r == 0


def run_natives(prefix, seed, nation, diff, mode):
    r = subprocess.run([SMOKE, '--nativescheck', prefix + '.bin', str(seed),
                        str(nation), str(diff), str(mode)],
                       capture_output=True, text=True)
    if r.returncode:
        return None
    return json.loads(r.stdout)


def check_natives(prefix, info):
    nation, diff = info['player'], info['difficulty']
    mode = 1 if info['premade_flag_5388'] else 0
    dos_v = [(v[0], v[1], v[2], v[3] & 0x04) for v in info['villages']]
    dos_set = set(dos_v)
    print('natives: %d DOS settlements, player %d, difficulty %d -- searching 32768 seeds'
          % (len(dos_v), nation, diff))

    def score(seed):
        res = run_natives(prefix, seed, nation, diff, mode)
        if not res:
            return (seed, -1, None)
        port_v = [(v[0], v[1], v[2], v[3] & 0x04) for v in res['villages']]
        # the first settlement is tribe 0's capital in both: a cheap prefix
        # match keeps the full comparison for the few real candidates
        hits = sum(1 for v in port_v if v in dos_set)
        return (seed, hits, res)

    best = (None, -1, None)
    with ThreadPoolExecutor(max_workers=os.cpu_count() or 4) as ex:
        for seed, hits, res in ex.map(score, range(0x8000), chunksize=64):
            if hits > best[1]:
                best = (seed, hits, res)
                if hits == len(dos_v):
                    break
    seed, hits, res = best
    print('natives: best seed %s reproduces %d/%d settlements' % (seed, hits, len(dos_v)))
    if res:
        port_v = [(v[0], v[1], v[2], v[3] & 0x04) for v in res['villages']]
        missing = [v for v in dos_v if v not in set(port_v)]
        extra = [v for v in port_v if v not in dos_set]
        if missing or extra:
            print('  dos-only %s' % missing[:10])
            print('  port-only %s' % extra[:10])
        # order matters too: the record index is the placer's sequence
        first_bad = next((i for i, (a, b) in enumerate(zip(dos_v, port_v)) if a != b), None)
        print('  record order agrees through index %s of %d'
              % ('all' if first_bad is None else first_bad, len(dos_v)))
        pops = sum(1 for a, b in zip(info['villages'], res['villages']) if a[4] != b[4])
        print('  population differs on %d record(s)' % pops)
        dos_b = sorted((u[0], u[1], u[3] & 0x0F) for u in info['units'] if u[2] == 0x13)
        port_b = sorted((u[0], u[1], u[3]) for u in res['units'] if u[2] == 0x13)
        print('  braves: dos %d, port %d, %d in common'
              % (len(dos_b), len(port_b), len(set(dos_b) & set(port_b))))
        dos_t = [[int.from_bytes(bytes(t[0x46 + 2 * p:0x48 + 2 * p]), 'little') for p in range(4)]
                 for t in info['tribes']]
        print('  tensions dos  %s' % dos_t)
        print('  tensions port %s' % res['tension'])
        # the HOMELAND claims: the owner nibble of plane 3 (tribes 4..11 only;
        # a European claim < 4 is an AI colony founded after the capture)
        out = prefix + '.port_region.bin'
        subprocess.run([SMOKE, '--nativescheck', prefix + '.bin', str(seed),
                        str(nation), str(diff), str(mode), out],
                       capture_output=True, text=True)
        try:
            preg = open(out, 'rb').read()
            dreg = open(prefix + '.bin', 'rb').read()[2 * P:3 * P]
            own = [(i % W, i // W, dreg[i] >> 4, preg[i] >> 4) for i in range(P)
                   if (dreg[i] >> 4) != (preg[i] >> 4) and (dreg[i] >> 4) >= 4]
            print('  owner nibbles (native claims): %d differ%s'
                  % (len(own), '' if not own else '  e.g. ' + str(own[:6])))
        except OSError:
            pass
    return hits == len(dos_v)


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    prefix = sys.argv[1]
    info = json.load(open(prefix + '.json'))
    dos = open(prefix + '.bin', 'rb').read()
    if (info['w'], info['h']) != (W, H):
        print('map is %dx%d, the port builds %dx%d' % (info['w'], info['h'], W, H))
        return 1
    ok = True
    if '--natives' not in sys.argv:
        ok &= check_builder(prefix, info, dos)
    if '--builder' not in sys.argv:
        ok &= check_natives(prefix, info)
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
