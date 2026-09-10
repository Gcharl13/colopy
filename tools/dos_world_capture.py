#!/usr/bin/env python3
"""dos_world_capture.py -- dump a RUNNING DOSBox Colonization game's world.

The DOS oracle for the new-game builders (2026-09-10): once the original sits
on a fresh map under tools/dosbox_harness, this reads the emulated RAM straight
out of the dosbox process (the tools/peek_live.py technique: the emulated
physical memory is one anonymous mmap; DGROUP is anchored on the section-name
table) and files everything the port's own new game produces --

  * the four map layers through their far pointers [0x15C]/[0x160]/[0x164]/
    [0x168] (offset:segment pairs; phys = seg*16 + off), W*H bytes each
    ([0x853A] x [0x853C]);
  * the builder's salt [0x190] (= its first random_int(1,0x7FFF) draw @0x64A16,
    which pins the clock seed srand() @0x075793 handed it -- the seed is
    the 15-bit clock word, so 32768 candidates at most);
  * the five Customize words [0x1E7E..0x1E86];
  * the settlement records (0x54EC, stride 0x12, count [0x539A]), the unit
    records (0x3144, stride 0x1C, count [0x539C]), the eight tribe records
    (0x5AD6, stride 0x4E) and the four AIPersonality records (0x5426, stride
    0x34 -- controller byte +0x19);
  * the globals block 0x5380..0x540E and the plot base [0x8D80].

Usage: python3 tools/dos_world_capture.py OUT_PREFIX  ->  OUT_PREFIX.bin (the
four planes back to back, terrain/improve/region/fog) and OUT_PREFIX.json.
"""
import json
import os
import sys

import subprocess

ANCHOR = b'UNIT\x00ORDERS\x00ACTIONS\x00'


def dosbox_pid():
    out = subprocess.check_output(['pgrep', '-x', 'dosbox']).split()
    return int(out[-1])


def find_ram(pid):
    """The emulated physical memory: DOSBox keeps it as one anonymous rw
    mapping (33.7 MB with memsize=16 on 0.74-3 -- NOT the 15..20 MB window
    tools/peek_live.py assumes); emulated phys 0 is the region's start."""
    with open('/proc/%d/mem' % pid, 'rb') as mem:
        for ln in open('/proc/%d/maps' % pid):
            parts = ln.split()
            a = parts[0].split('-')
            start, end = int(a[0], 16), int(a[1], 16)
            if end - start < 8 * 1024 * 1024 or 'rw' not in parts[1]:
                continue
            if len(parts) > 5 and parts[5].startswith('/'):
                continue
            try:
                mem.seek(start)
                buf = mem.read(end - start)
            except OSError:
                continue
            if ANCHOR in buf:
                return buf
    return None


def main() -> int:
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    out = sys.argv[1]
    pid = dosbox_pid()
    buf = find_ram(pid)
    if buf is None:
        print('ERROR: emulated RAM not found')
        return 1
    at = buf.find(ANCHOR)
    if at < 0:
        print('ERROR: DGROUP anchor not found')
        return 1
    dg = at - 0x2258

    def w(off):
        return int.from_bytes(buf[dg + off:dg + off + 2], 'little')

    def b(off, n):
        return buf[dg + off:dg + off + n]

    # the region is not phys 0: DGROUP's live segment is 0x1CFD (verified
    # 2026-06-25, tools/runtime_snapshot.py), so phys P sits at region
    # offset P + (dg - 0x1CFD0)
    base = dg - 0x1CFD0

    def far(off):
        return base + w(off + 2) * 16 + w(off)

    # ...but the load segment moves by a paragraph or two between DOSBox
    # configurations, so align on the plane itself: the builder's outline
    # leaves row 0 Arctic (0x18) and column 0 Sea Lane (0x1A) on every
    # world it makes (@0x65941..).
    W, H = w(0x853A), w(0x853C)

    def border_ok(t):
        return (len(t) == W * H and
                all((t[x] & 0x1F) == 0x18 for x in range(1, W - 1)) and
                all((t[y * W] & 0x1F) == 0x1A for y in range(1, H - 1)))

    if 8 <= W <= 128 and 8 <= H <= 128:
        for delta in sorted(range(-4096, 4097, 16), key=abs):
            base = dg - 0x1CFD0 + delta
            if border_ok(buf[far(0x15C):far(0x15C) + W * H]):
                if delta:
                    print('note: live DGROUP segment is 0x%X (delta %+d)' % ((dg - base) >> 4, delta))
                break
        else:
            base = dg - 0x1CFD0

    if not (8 <= W <= 128 and 8 <= H <= 128):
        print('ERROR: implausible map size %dx%d -- not on a map yet?' % (W, H))
        return 1
    planes = [buf[far(0x15C + 4 * i):far(0x15C + 4 * i) + W * H] for i in range(4)]
    # the mapping check: the builder's outline leaves row 0 Arctic (0x18)
    # and column 0 Sea Lane (0x1A) on every world it makes (@0x65941..)
    t = planes[0]
    if not (all((t[x] & 0x1F) == 0x18 for x in range(1, W - 1)) and
            all((t[y * W] & 0x1F) == 0x1A for y in range(1, H - 1))):
        print('WARNING: the terrain plane border is not Arctic/Sea Lane -- '
              'far-pointer mapping suspect (DGROUP at region offset 0x%x)' % dg)
    nvill, nunit, ncol = w(0x539A), w(0x539C), w(0x539E)
    info = {
        'w': W, 'h': H,
        'salt': w(0x190), 'salt_hi': w(0x192),
        'custom': [w(0x1E7E + 2 * i) for i in range(5)],
        'premade_flag_5388': w(0x5388), 'flag_2174': w(0x2174),
        'difficulty': buf[dg + 0x53A6], 'player': w(0x5398),
        'wedding_53a7': buf[dg + 0x53A7], 'kingwar_53a8': buf[dg + 0x53A8],
        'plot_8d80': int.from_bytes(b(0x8D80, 4), 'little'),
        'n_villages': nvill, 'n_units': nunit, 'n_colonies': ncol,
        'controllers': [buf[dg + 0x5426 + 0x34 * p + 0x19] for p in range(4)],
        'globals': b(0x5380, 0x8E).hex(),
        'villages': [list(b(0x54EC + 0x12 * i, 0x12)) for i in range(min(nvill, 84))],
        'units': [list(b(0x3144 + 0x1C * i, 0x1C)) for i in range(min(nunit, 256))],
        'tribes': [list(b(0x5AD6 + 0x4E * i, 0x4E)) for i in range(8)],
        'plane_ptrs': [(w(0x15C + 4 * i), w(0x15E + 4 * i)) for i in range(4)],
    }
    with open(out + '.bin', 'wb') as f:
        for p in planes:
            f.write(p)
    with open(out + '.json', 'w') as f:
        json.dump(info, f, indent=1)
    print('DGROUP phys 0x%x, map %dx%d, salt %d, custom %s, villages %d, units %d'
          % (dg, W, H, info['salt'], info['custom'], nvill, nunit))
    print('wrote %s.bin (%d B) and %s.json' % (out, 4 * W * H, out))
    return 0


if __name__ == '__main__':
    sys.exit(main())
