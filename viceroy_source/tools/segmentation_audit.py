#!/usr/bin/env python3
"""
segmentation_audit.py -- find mis-segmented load_image skeletons.

The auto-segmenter (tools/full_pipeline.py) sometimes cut a real function at a
false boundary (typically the first `retf` of an inlined tail), emitting a tiny
SKELETON stub that claims e.g. "29 bytes" when the real function at that offset
is 1496 bytes (func_00AB78). Those stubs cannot be ported as written -- the body
continues past the claimed span.

This tool compares each skeleton's claimed @asm span against the TRUE size from
the capstone-traced re_work/disasm/func_<OFF>.asm header, and reports:
  - MIS-SEGMENTED : true_size > claimed_span (real function is bigger; the stub
                    is a fragment -- needs full-function decompilation)
  - SHADOWED      : a function offset that falls strictly INSIDE another
                    function's true extent (an interior false-boundary stub that
                    should be folded into its parent)

Output guides the next porting phase: MIS-SEGMENTED entries need their @asm span
and signature corrected to the true extent before (or as part of) porting;
SHADOWED entries are spurious and should be removed in favor of their parent.

Usage:  python3 tools/segmentation_audit.py [--csv out.csv]
"""
import glob, re, os, sys

DISASM = 're_work/disasm'
SRC    = 'viceroy_source/src/load_image'

def true_sizes():
    sz = {}
    for f in glob.glob(os.path.join(DISASM, 'func_*.asm')):
        first = open(f, errors='ignore').readline()
        m = re.search(r'file 0x([0-9A-Fa-f]+)\s+size (\d+)', first)
        if m:
            sz[int(m.group(1), 16)] = int(m.group(2))
    return sz

def skeleton_entries():
    """Yield (offset, claimed_start, claimed_end, claimed_span, status, file)."""
    for cf in sorted(glob.glob(os.path.join(SRC, '*.c'))):
        txt = open(cf, errors='ignore').read()
        for m in re.finditer(
            r'@asm\s+0x([0-9A-Fa-f]+)\.\.0x([0-9A-Fa-f]+)\s+\((\d+) bytes\)'
            r'.*?@status\s+(\w+)', txt, re.S):
            s = int(m.group(1), 16); e = int(m.group(2), 16)
            span = int(m.group(3)); status = m.group(4)
            yield s, s, e, span, status, os.path.basename(cf)

def main():
    sz = true_sizes()
    entries = sorted(set(skeleton_entries()))
    offsets = sorted({s for s, *_ in entries})

    def parent_of(off):
        """Return the offset of a function whose true extent strictly contains off."""
        for p in offsets:
            if p < off and p in sz and off < p + sz[p]:
                return p
        return None

    misseg, shadowed, clean = [], [], []
    for off, s, e, span, status, cf in entries:
        true = sz.get(off)
        par = parent_of(off)
        if par is not None:
            shadowed.append((off, par, span, status, cf))
        elif true is not None and true > span * 1.5 and true > 60:
            misseg.append((off, span, true, status, cf))
        else:
            clean.append(off)

    print(f"Skeleton entries audited: {len(entries)}")
    print(f"  clean boundary:   {len(clean)}")
    print(f"  MIS-SEGMENTED:    {len(misseg)}  (true size >> claimed span)")
    print(f"  SHADOWED:         {len(shadowed)}  (interior of another function)")

    print("\n=== MIS-SEGMENTED (claimed -> true), worst first ===")
    for off, span, true, status, cf in sorted(misseg, key=lambda r: -r[2])[:40]:
        tag = '' if status != 'SKELETON' else ' [SKELETON]'
        print(f"  0x{off:06X}  {span:4d} -> {true:5d} B  {cf}{tag}")
    if len(misseg) > 40:
        print(f"  ... and {len(misseg)-40} more")

    print("\n=== SHADOWED (offset : parent function) ===")
    for off, par, span, status, cf in sorted(shadowed)[:25]:
        print(f"  0x{off:06X} inside 0x{par:06X} (true {sz.get(par,'?')}B)  {cf}")
    if len(shadowed) > 25:
        print(f"  ... and {len(shadowed)-25} more")

    if '--csv' in sys.argv:
        out = sys.argv[sys.argv.index('--csv')+1]
        with open(out, 'w') as fh:
            fh.write("offset,kind,claimed_span,true_size,parent,status,file\n")
            for off, span, true, status, cf in misseg:
                fh.write(f"0x{off:06X},MIS-SEGMENTED,{span},{true},,{status},{cf}\n")
            for off, par, span, status, cf in shadowed:
                fh.write(f"0x{off:06X},SHADOWED,{span},,0x{par:06X},{status},{cf}\n")
        print(f"\nWrote {out}")

if __name__ == '__main__':
    main()
