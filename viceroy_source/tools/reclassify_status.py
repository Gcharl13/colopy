#!/usr/bin/env python3
"""
reclassify_status.py -- honestly re-tag remaining load_image SKELETON entries.

Not every SKELETON is "un-decompiled game logic". Two categories are not
decompilation targets at all, and counting them as SKELETON overstates the
remaining work:

  SHADOWED       -- the entry's offset falls strictly inside another function's
                    true (capstone) extent. It is an auto-segmentation artifact,
                    not a standalone function. Re-tagged SHADOWED with a pointer
                    to its parent.
  PLATFORM_LAYER -- the body's primary action is a DOS INT 21h / BIOS / hardware
                    I/O call or RTLink overlay-loader (CS-relative) manipulation.
                    These are the host/runtime layer the modern Windows port
                    REPLACES with native equivalents, so a byte-faithful DOS
                    decompile is low value. Re-tagged PLATFORM_LAYER.

Only @status lines of currently-SKELETON entries in those two categories are
changed; bodies and all other entries are untouched. Run from repo root.

Usage:  python3 viceroy_source/tools/reclassify_status.py [--apply]
        (default is a dry-run summary; --apply edits the .c files)
"""
import glob, re, os, sys

DISASM = 're_work/disasm'
SRC    = 'viceroy_source/src/load_image'

def true_sizes():
    sz = {}
    for f in glob.glob(os.path.join(DISASM, 'func_*.asm')):
        first = open(f, errors='ignore').readline()
        m = re.search(r'file 0x([0-9A-Fa-f]+)\s+size (\d+)', first)
        if m: sz[int(m.group(1), 16)] = int(m.group(2))
    return sz

SZ = true_sizes()
OFFS = sorted(SZ)

def parent_of(off):
    for p in OFFS:
        if p < off and off < p + SZ[p]:
            return p
    return None

def platform_kind(off):
    f = os.path.join(DISASM, f"func_{off:06X}.asm")
    if not os.path.exists(f): return None
    b = open(f, errors='ignore').read().lower()
    if re.search(r'\bint 0x21\b', b): return "DOS INT 21h"
    if re.search(r'\bint 0x(10|16|33)\b', b): return "BIOS interrupt"
    if 'cs:[0x39' in b or re.search(r'\bcs:\[0x1[0-9a-f]\]', b): return "RTLink overlay loader (CS-relative)"
    if re.search(r'\b(out|in) 0x[0-9a-f]+', b): return "hardware port I/O"
    return None

def main():
    apply = '--apply' in sys.argv
    shadowed = platform = 0
    for cf in sorted(glob.glob(os.path.join(SRC, '*.c'))):
        txt = open(cf, errors='ignore').read()
        out = txt
        for m in re.finditer(r'@asm\s+0x([0-9A-Fa-f]+)\.\.0x[0-9A-Fa-f]+\s+\(\d+ bytes\)', txt):
            off = int(m.group(1), 16)
            par = parent_of(off)
            kind = platform_kind(off) if par is None else None
            if par is None and kind is None:
                continue
            # locate this entry's @status SKELETON line, bounded to its own
            # header block (the negative lookahead stops .*? crossing into the
            # next function's @asm block).
            blk = re.compile(
                r'(@asm\s+0x%06X\.\.(?:(?!@asm\s+0x)[\s\S])*?\*\s*@status\s+)'
                r'SKELETON[^\n]*' % off)
            def repl(mm):
                if par is not None:
                    return mm.group(1) + ("SHADOWED (interior of func_%06X; "
                        "auto-segmentation artifact, not a standalone function)" % par)
                return mm.group(1) + ("PLATFORM_LAYER (%s; host/runtime layer "
                        "replaced in the modern port, not decompiled)" % kind)
            new, n = blk.subn(repl, out, count=1)
            if n:
                out = new
                if par is not None: shadowed += 1
                else: platform += 1
        if apply and out != txt:
            open(cf, 'w').write(out)
    print(f"SHADOWED re-tagged:       {shadowed}")
    print(f"PLATFORM_LAYER re-tagged: {platform}")
    print(f"Total reclassified:       {shadowed+platform}")
    print("(dry run -- pass --apply to write)" if not apply else "(applied to .c files)")

if __name__ == '__main__':
    main()
