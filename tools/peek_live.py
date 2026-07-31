#!/usr/bin/env python3
"""Attach to a RUNNING dosbox, find emulated RAM + DGROUP, peek offsets, optionally dump.

Usage: peek_live.py [--pid N] [--dump FILE] [OFF:LEN ...]
OFF:LEN are DGROUP-relative hex offsets. Special form ptr:OFF:LEN follows the
word at DGROUP:OFF as a near pointer in DS and dumps LEN bytes there.
"""
import sys, re, subprocess

def dosbox_pid():
    out = subprocess.check_output(['pgrep', '-x', 'dosbox']).split()
    return int(out[-1])

def find_ram(pid):
    with open(f'/proc/{pid}/mem', 'rb') as mem:
        for ln in open(f'/proc/{pid}/maps'):
            parts = ln.split()
            a = parts[0].split('-')
            start = int(a[0], 16); end = int(a[1], 16); sz = end - start
            if not (15*1024*1024 <= sz <= 20*1024*1024):
                continue
            if 'r' not in parts[1]:
                continue
            try:
                mem.seek(start); buf = mem.read(sz)
            except OSError:
                continue
            if b'MADSPACK' in buf and b'ORDERS' in buf:
                return buf
    return None

def main():
    args = sys.argv[1:]
    pid = None; dump = None; offs = []
    i = 0
    while i < len(args):
        if args[i] == '--pid': pid = int(args[i+1]); i += 2
        elif args[i] == '--dump': dump = args[i+1]; i += 2
        else: offs.append(args[i]); i += 1
    if pid is None: pid = dosbox_pid()
    buf = find_ram(pid)
    if buf is None:
        print('ERROR: emulated RAM not found'); sys.exit(1)
    if dump:
        open(dump, 'wb').write(buf)
        print(f'dumped {len(buf)} bytes -> {dump}')
    hits = [m.start() for m in re.finditer(re.escape(b'UNIT\x00ORDERS\x00ACTIONS\x00'), buf)]
    if not hits:
        print('ERROR: DGROUP anchor not found'); sys.exit(1)
    dg = hits[0] - 0x2258
    print(f'DGROUP phys base = 0x{dg:x} (seg 0x{dg>>4:x}), anchor hits={len(hits)}')
    # sanity
    v = buf[dg+0x54de:dg+0x54de+13]
    print(f'  sanity DGROUP:0x54de = {v!r}')
    for spec in offs:
        parts = spec.split(':')
        if parts[0] == 'ptr':
            off = int(parts[1], 16); n = int(parts[2], 16) if len(parts) > 2 else 24
            p = int.from_bytes(buf[dg+off:dg+off+2], 'little')
            data = buf[dg+p:dg+p+n]
            print(f'DGROUP:0x{off:04x} -> near ptr 0x{p:04x} (phys 0x{dg+p:x}): {data.hex()} {data!r}')
        else:
            off = int(parts[0], 16); n = int(parts[1], 16) if len(parts) > 1 else 2
            data = buf[dg+off:dg+off+n]
            w = int.from_bytes(data[:2], 'little') if len(data) >= 2 else None
            print(f'DGROUP:0x{off:04x} (phys 0x{dg+off:x}) [{n}B]: {data.hex()}  word={w} (0x{w:04x})' if w is not None else f'DGROUP:0x{off:04x}: {data.hex()}')

if __name__ == '__main__':
    main()
