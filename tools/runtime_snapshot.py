#!/usr/bin/env python3
"""Runtime memory-snapshot harness for VICEROY (DOSBox, headless).

Why this exists
---------------
Most remaining UI/input TBDs are blocked on *runtime* state: RTLink overlays are
paged in on demand and type-A thunks are patched at load time, so the live
addresses don't exist in the static EXE. This harness boots the game headless
under stock DOSBox 0.74 and snapshots the emulated DOS RAM straight out of the
DOSBox process (no debugger build required), so static reverse-engineering can be
cross-checked against — and extended from — the real loaded image.

It needs NO DOSBox debugger build and NO symbols: DOSBox keeps its emulated RAM as
one big anonymous mmap in its own address space, which we locate in
/proc/<pid>/maps (the region that contains the 'MADSPACK'+'ORDERS' signatures) and
read via /proc/<pid>/mem. Emulated physical address 0 maps to the start of that
region, so DOS phys addr P is at region_offset P.

Verified 2026-06-25: the live DGROUP sits at segment 0x1CFD (phys base 0x1CFD0).
Sanity anchors (all exact): DGROUP:0x225d='ORDERS\\0', 0x2258='UNIT\\0',
0x2264='ACTIONS\\0', and the order accelerator/status table DGROUP:0x54de[13]=
'-STGLFFBPR---' (= the @ORDERS column-2 letters, confirming the static Track-6
finding at runtime).

Usage
-----
  python3 tools/runtime_snapshot.py [--exe VICEROY.EXE] [--wait 12] [--out dosmem.bin]
  # then, in Python:
  from runtime_snapshot import Snapshot
  s = Snapshot('dosmem.bin')           # or Snapshot.capture(...)
  s.find_dgroup()                       # -> dgroup phys base (auto: anchors on the section-name table)
  s.peek_dgroup(0x54de, 13)             # live bytes at DGROUP:0x54de
  s.search(b'-STGLFFBPR---')            # offsets of a byte pattern in DOS RAM

NOTE: stock DOSBox renders the DOS console to the emulated video surface, not host
stdout, and gameplay input is not automated here — so this snapshots the boot/menu
state. Reaching a specific in-game state (e.g. an open orders menu) still needs
scripted input or a debugger build; this harness gives the live image + DGROUP for
everything resident at snapshot time.
"""
import os, sys, time, subprocess, signal, re, argparse

COLONIZE = os.path.join(os.path.dirname(__file__), '..', 'raw', 'COLONIZE')

DB_CONF = """[sdl]
output=surface
autolock=false
[dosbox]
machine=vgaonly
memsize=16
[cpu]
cycles=20000
[autoexec]
mount c {colonize}
c:
{exe}
"""


def _find_emulated_ram(pid):
    """Return (host_start, bytes) of the DOSBox emulated-RAM region."""
    with open(f'/proc/{pid}/mem', 'rb') as mem:
        for ln in open(f'/proc/{pid}/maps'):
            parts = ln.split()
            a = parts[0].split('-')
            start = int(a[0], 16); end = int(a[1], 16); sz = end - start
            if not (15 * 1024 * 1024 <= sz <= 20 * 1024 * 1024):
                continue
            if 'r' not in parts[1]:
                continue
            try:
                mem.seek(start); buf = mem.read(sz)
            except OSError:
                continue
            if b'MADSPACK' in buf and b'ORDERS' in buf:
                return start, buf
    return None, None


class Snapshot:
    def __init__(self, path_or_bytes):
        if isinstance(path_or_bytes, (bytes, bytearray)):
            self.buf = bytes(path_or_bytes)
        else:
            self.buf = open(path_or_bytes, 'rb').read()
        self.dgroup = None

    @classmethod
    def capture(cls, exe='VICEROY.EXE', wait=12, out='dosmem.bin'):
        conf = os.path.abspath('_rsnap.conf')
        open(conf, 'w').write(DB_CONF.format(colonize=os.path.abspath(COLONIZE), exe=exe))
        env = dict(os.environ, SDL_VIDEODRIVER='dummy', SDL_AUDIODRIVER='dummy')
        p = subprocess.Popen(['dosbox', '-conf', conf], env=env,
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        try:
            time.sleep(wait)
            start, buf = _find_emulated_ram(p.pid)
            if buf is None:
                raise RuntimeError('emulated RAM region not found (game may not have loaded)')
            if out:
                open(out, 'wb').write(buf)
        finally:
            p.send_signal(signal.SIGTERM)
            try: p.wait(timeout=5)
            except Exception: p.kill()
        return cls(buf)

    def search(self, pat):
        return [m.start() for m in re.finditer(re.escape(pat), self.buf)]

    def find_dgroup(self):
        """Locate the live DGROUP base by anchoring on the contiguous section-name
        table 'UNIT\\0ORDERS\\0ACTIONS\\0' (DGROUP:0x2258). Returns phys base or None."""
        hits = self.search(b'UNIT\x00ORDERS\x00ACTIONS\x00')
        if hits:
            self.dgroup = hits[0] - 0x2258
            return self.dgroup
        # fallback: anchor on the order accel/status table at 0x54de
        hits = self.search(b'-STGLFFBPR---')
        if hits:
            self.dgroup = hits[0] - 0x54de
            return self.dgroup
        return None

    def peek_dgroup(self, off, n=16):
        if self.dgroup is None and self.find_dgroup() is None:
            raise RuntimeError('DGROUP base not found')
        a = self.dgroup + off
        return self.buf[a:a + n]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--exe', default='VICEROY.EXE')
    ap.add_argument('--wait', type=int, default=12)
    ap.add_argument('--out', default='dosmem.bin')
    args = ap.parse_args()
    s = Snapshot.capture(exe=args.exe, wait=args.wait, out=args.out)
    print(f'captured {len(s.buf)//1048576}MB -> {args.out}')
    dg = s.find_dgroup()
    if dg is None:
        print('DGROUP base: NOT FOUND'); return
    print(f'DGROUP phys base = 0x{dg:x} (seg 0x{dg>>4:x})')
    checks = [(0x54de, 13, b'-STGLFFBPR---', 'order accel/status table'),
              (0x225d, 7, b'ORDERS\x00', '@ORDERS name'),
              (0x2258, 5, b'UNIT\x00', '@UNIT name'),
              (0x2264, 8, b'ACTIONS\x00', '@ACTIONS name')]
    for off, n, want, label in checks:
        v = s.peek_dgroup(off, n)
        ok = 'OK' if v[:len(want)] == want else 'MISMATCH'
        print(f'  [{ok}] DGROUP:0x{off:04x} {label}: {v!r}')


if __name__ == '__main__':
    main()
