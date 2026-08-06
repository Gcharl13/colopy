#!/usr/bin/env python3
"""Read the colony-placement state out of a RUNNING DOSBox (tools/dosbox_harness).

Dumps the tables `func_025D34 @0x025D34` reads and writes, so the algorithm can
be replayed offline and checked against what the game actually produced:

    [0x8D80] dword   the session seed base -- the BIOS clock at startup (@0x075FF5)
    [0x224]/[0x22A]  per-category plot counts / start indices
    [0x266]          the 15 plot positions (x,y as word pairs, stride 4)
    [0x260]          per-category empty-plot decoration frames
    [0x8D62][15]     category per plot           (rebuilt each open, deterministic)
    [0x8E92][15]     plot -> shuffle slot        (the RNG output)
    [0x8E82][15]     plot -> building def id     (0xFF = empty)
    [0x8542]         the current-colony record pointer; +0 x, +1 y, +0x1F population

Usage: python3 tools/colony_seed_probe.py [--out probe.json]
"""
import json, re, struct, subprocess, sys, argparse

MIN_REGION = 12 << 20            # DOSBox's emulated RAM mmap, memsize=16


def dosbox_pid():
    out = subprocess.run(['pgrep', '-f', 'dosbox -conf'], capture_output=True, text=True)
    pids = [int(p) for p in out.stdout.split()]
    if not pids:
        sys.exit('no running dosbox found -- boot tools/dosbox_harness/boot.sh first')
    return pids[0]


def read_ram(pid):
    """Find the emulated-RAM mapping and return it. DOS phys addr P is at offset P."""
    maps = open(f'/proc/{pid}/maps').read().splitlines()
    mem = open(f'/proc/{pid}/mem', 'rb', 0)
    best = None
    for line in maps:
        m = re.match(r'([0-9a-f]+)-([0-9a-f]+) (\S+)', line)
        if not m:
            continue
        lo, hi, perms = int(m.group(1), 16), int(m.group(2), 16), m.group(3)
        if hi - lo < MIN_REGION or not perms.startswith('rw'):
            continue
        try:
            mem.seek(lo)
            buf = mem.read(hi - lo)
        except OSError:
            continue
        # The emulated conventional memory holds the loaded EXE's data segment.
        if b'UNIT\x00ORDERS\x00ACTIONS\x00' in buf[:1 << 20]:
            return buf
        if best is None and b'MADSPACK' in buf:
            best = buf
    return best


def probe(buf):
    hit = buf.find(b'UNIT\x00ORDERS\x00ACTIONS\x00')
    if hit < 0:
        sys.exit('DGROUP anchor not found in emulated RAM')
    ds = hit - 0x2258
    u8 = lambda o: buf[ds + o]
    u16 = lambda o: struct.unpack_from('<H', buf, ds + o)[0]
    u32 = lambda o: struct.unpack_from('<I', buf, ds + o)[0]
    colony = u16(0x8542)
    out = {
        'dgroup': ds,
        'seed_base': u32(0x8D80),
        'counts': [u8(0x224 + i) for i in range(5)],
        'starts': [u8(0x22A + i) for i in range(5)],
        'decor': [u8(0x260 + i) for i in range(6)],
        'plots': [[u16(0x266 + i * 4), u16(0x268 + i * 4)] for i in range(15)],
        'category': [u8(0x8D62 + i) for i in range(15)],
        'shuffle': [u8(0x8E92 + i) for i in range(15)],
        'present': [u8(0x8E82 + i) for i in range(15)],
        'colony_ptr': colony,
        # The 42 building-def records, stride 12 based at 0x8F87: +0 category,
        # +1 group (`[bx-0x7079]` / `[bx-0x7078]` @0x025E1A/0x025E2C).
        'defs': [[u8(0x8F87 + i * 12), u8(0x8F88 + i * 12)] for i in range(42)],
    }
    if colony:
        out['colony'] = {'x': u8(colony), 'y': u8(colony + 1), 'pop': u8(colony + 0x1F)}
    return out


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--out')
    a = ap.parse_args()
    buf = read_ram(dosbox_pid())
    if buf is None:
        sys.exit('emulated RAM region not found')
    r = probe(buf)
    print(json.dumps(r, indent=2))
    if a.out:
        open(a.out, 'w').write(json.dumps(r, indent=2))
