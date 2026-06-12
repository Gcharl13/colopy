#!/usr/bin/env python3
"""arg_restore.py -- mechanically restore thunk call-site arguments from the
EXE bytes (Phase 4.3 mass pass).

For every weak-stub call site in src/ whose comment carries an @asm address:
  1. disassemble the EXE around that address and locate the lcall/near call
  2. walk the preceding contiguous push run (+ simple AX-load idioms)
  3. translate each push into C:
       push IMM                 -> literal
       push word [0xNNNN]       -> (int16_t)DG16(0xNNNN)
       mov al,[0xNNNN](+cbw/xor)-> (int16_t)DG8(0xNNNN)  (via push ax)
       push word [bp+disp]      -> enclosing C param named *_bp_XX
       push word [bp-disp]      -> FLAG (local; manual)
       lea ax,[bp-disp]; push ax-> FLAG (local buffer; manual)
  4. emit a rewrite plan: tier1 = fully translated sites (auto-appliable),
     flagged = sites needing the manual pass, with the decoded pushes shown.

The canonical replacement symbol is the thunk's own overlay_call_SEG_OFF name
(read from the lcall operands themselves -- this also untangles externs that
multiplex one name across different thunks per site).

Usage: python3 tools/arg_restore.py [--apply] [--file SUBSTR]
Writes /tmp/arg_restore_plan.json + a readable /tmp/arg_restore_plan.txt
"""
import glob, json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EXE = os.path.join(os.path.dirname(ROOT), 're_work', 'VICEROY.EXE')

try:
    from capstone import Cs, CS_ARCH_X86, CS_MODE_16
except ImportError:
    sys.exit("capstone required")

DATA = open(EXE, 'rb').read()
MD = Cs(CS_ARCH_X86, CS_MODE_16)
MD.detail = False

CITE_RX = re.compile(r'@(?:asm )?0x([0-9A-Fa-f]{5,6})\b')
CALL_RX = re.compile(r'\b([A-Za-z_]\w*)\s*\(')
FUNCDEF_RX = re.compile(r'^[A-Za-z_][\w \t\*]*?\b([A-Za-z_]\w*)\s*\(([^;{]*)\)\s*$')

def disasm_window(addr, back=0x40, fwd=0x10):
    start = max(0, addr - back)
    ins = list(MD.disasm(DATA[start:addr + fwd], start))
    return ins

def decode_site(addr):
    """Return (seg, off, [push-exprs], cleanup_bytes) for the call AT addr,
    or None.  push-exprs are dicts {kind, value} in PUSH ORDER (so REVERSED
    for cdecl arg order)."""
    win = disasm_window(addr)
    idx = next((i for i, x in enumerate(win) if x.address == addr), None)
    if idx is None:
        return None
    call = win[idx]
    if call.mnemonic == 'lcall':
        m = re.match(r'0x([0-9a-f]+), 0x([0-9a-f]+)', call.op_str)
        if not m:
            return None
        seg, off = int(m.group(1), 16), int(m.group(2), 16)
    else:
        return None
    # cleanup
    cleanup = 0
    if idx + 1 < len(win):
        m = re.match(r'sp, (0x[0-9a-f]+|\d+)', win[idx+1].op_str) \
            if win[idx+1].mnemonic == 'add' else None
        if m:
            cleanup = int(m.group(1), 0)
    nargs = cleanup // 2
    # walk back collecting pushes (allowing the AX-load idioms between)
    pushes = []
    i = idx - 1
    pending_ax = None   # expression currently in AX, if simply derivable
    while i >= 0 and len(pushes) < nargs:
        ins = win[i]
        mn, op = ins.mnemonic, ins.op_str
        if mn == 'push':
            if re.match(r'^-?(0x[0-9a-f]+|\d+)$', op):
                pushes.append({'kind': 'imm', 'c': op})
            elif re.match(r'^word ptr \[0x[0-9a-f]+\]$', op):
                a = re.search(r'0x[0-9a-f]+', op).group(0)
                pushes.append({'kind': 'dg16', 'c': f'(int16_t)DG16({a})'})
            elif re.match(r'^word ptr \[bp \+ (0x[0-9a-f]+|\d+)\]$', op):
                d = int(re.search(r'bp \+ (0x[0-9a-f]+|\d+)', op).group(1), 0)
                pushes.append({'kind': 'param', 'bp': d})
            elif re.match(r'^word ptr \[bp - ', op):
                pushes.append({'kind': 'local', 'c': None, 'raw': op})
            elif op == 'ax' and pending_ax:
                pushes.append(pending_ax); pending_ax = None
            elif op in ('ax','bx','cx','dx','si','di','ds','ss','es','cs'):
                pushes.append({'kind': 'reg', 'c': None, 'raw': op})
            else:
                pushes.append({'kind': 'other', 'c': None, 'raw': op})
            i -= 1
            continue
        # simple AX loads feeding a later push ax
        if mn == 'mov' and re.match(r'^al, byte ptr \[0x[0-9a-f]+\]$', op):
            a = re.search(r'0x[0-9a-f]+', op).group(0)
            pending_ax = {'kind': 'dg8', 'c': f'(int16_t)DG8({a})'}
            i -= 1; continue
        if mn == 'mov' and re.match(r'^ax, word ptr \[0x[0-9a-f]+\]$', op):
            a = re.search(r'0x[0-9a-f]+', op).group(0)
            pending_ax = {'kind': 'dg16', 'c': f'(int16_t)DG16({a})'}
            i -= 1; continue
        if (mn, op) in (('sub','ah, ah'), ('xor','ah, ah')) or mn == 'cwde' or mn == 'cbw':
            i -= 1; continue
        if mn == 'nop':
            i -= 1; continue
        break
    if len(pushes) != nargs:
        return (seg, off, None, nargs, 'push-walk-short')
    # walking BACK from the call, the first push met was pushed LAST = arg0,
    # so the collected list is ALREADY in cdecl order -- do not reverse.
    return (seg, off, pushes, nargs, None)

def enclosing_func(lines, ln):
    """Find the enclosing C function definition above line ln (0-based)."""
    for i in range(ln, -1, -1):
        m = FUNCDEF_RX.match(lines[i])
        if m and not lines[i].lstrip().startswith(('extern', 'typedef')):
            params = {}
            for p in m.group(2).split(','):
                pm = re.search(r'(\w*bp_([0-9A-Fa-f]{2}))\s*(?:/\*.*?\*/)?\s*$', p.strip())
                if pm:
                    params[int(pm.group(2), 16)] = pm.group(1)
            return m.group(1), params
    return None, {}

def main():
    apply_mode = '--apply' in sys.argv
    fsub = None
    if '--file' in sys.argv:
        fsub = sys.argv[sys.argv.index('--file') + 1]
    blocked = json.load(open(os.path.join(ROOT, 'tools/generated/thunk_arity_blocked.json')))
    stubs = set(blocked)
    plan, flagged, nocite = [], [], 0
    for f in sorted(glob.glob(os.path.join(ROOT, 'src/**/*.c'), recursive=True)):
        if fsub and fsub not in f: continue
        raw = open(f, errors='replace').read()
        if not any(s in raw for s in stubs): continue
        lines = raw.splitlines()
        for n, ln in enumerate(lines):
            for cm in CALL_RX.finditer(ln):
                name = cm.group(1)
                if name not in stubs or 'extern' in ln: continue
                cite = CITE_RX.search(ln) or (CITE_RX.search(lines[n-1]) if n else None)
                if not cite:
                    nocite += 1
                    flagged.append({'file': f, 'line': n+1, 'stub': name, 'why': 'no @asm cite'})
                    continue
                addr = int(cite.group(1), 16)
                r = decode_site(addr)
                if not r or r[2] is None:
                    flagged.append({'file': f, 'line': n+1, 'stub': name,
                                    'why': r[4] if r else 'no lcall at cite',
                                    'addr': hex(addr)})
                    continue
                seg, off, args, nargs, _ = r
                want = blocked[name]['arity']
                if nargs == 0 and want > 0:
                    flagged.append({'file': f, 'line': n+1, 'stub': name,
                                    'why': f'register-convention (cleanup 0, target wants {want})',
                                    'addr': hex(addr)})
                    continue
                fn, params = enclosing_func(lines, n)
                cargs, bad = [], None
                for a in args:
                    if a['kind'] in ('imm', 'dg16', 'dg8'):
                        cargs.append(a['c'])
                    elif a['kind'] == 'param' and a['bp'] in params:
                        cargs.append(params[a['bp']])
                    else:
                        bad = a; break
                rec = {'file': f, 'line': n+1, 'stub': name, 'addr': hex(addr),
                       'thunk': f'overlay_call_{seg:04X}_{off:04X}',
                       'nargs': nargs,
                       'args': cargs if not bad else None,
                       'raw': [a.get('c') or a.get('raw') or f"bp+{a.get('bp'):#x}" for a in args]}
                if bad:
                    rec['why'] = f"untranslatable push: {bad}"
                    flagged.append(rec)
                else:
                    plan.append(rec)
    print(f"TIER-1 fully translated: {len(plan)}")
    print(f"FLAGGED for manual pass: {len(flagged)}  (no-cite: {nocite})")
    json.dump({'plan': plan, 'flagged': flagged}, open('/tmp/arg_restore_plan.json', 'w'), indent=1)
    with open('/tmp/arg_restore_plan.txt', 'w') as out:
        for r in plan:
            out.write(f"OK  {r['file']}:{r['line']} {r['stub']} -> {r['thunk']}({', '.join(r['args'])})\n")
        for r in flagged:
            out.write(f"--  {r.get('file','?')}:{r.get('line','?')} {r.get('stub','?')} "
                      f"{r.get('why','')} raw={r.get('raw','')}\n")
    # per-thunk completeness: which thunks have ALL their sites in tier1
    from collections import defaultdict
    per = defaultdict(lambda: [0, 0])
    for r in plan: per[r['stub']][0] += 1
    for r in flagged:
        if 'stub' in r: per[r['stub']][1] += 1
    complete = [s for s, (ok, fl) in per.items() if fl == 0 and ok > 0]
    print(f"stubs with ALL sites tier-1: {len(complete)}")

if __name__ == '__main__':
    main()

def apply_plan():
    """Rewrite tier-1 sites in place: stub(...) -> canonical_thunk(args...).
    Only single-line calls with a matching ')' are touched."""
    plan = json.load(open('/tmp/arg_restore_plan.json'))['plan']
    byfile = {}
    for r in plan:
        byfile.setdefault(r['file'], []).append(r)
    touched, skipped = 0, 0
    for f, rows in byfile.items():
        lines = open(f, errors='replace').read().splitlines(keepends=True)
        for r in sorted(rows, key=lambda r: -r['line']):
            ln = lines[r['line'] - 1]
            m = re.search(r'\b' + re.escape(r['stub']) + r'\s*\(', ln)
            if not m:
                skipped += 1; continue
            depth, j = 0, m.end() - 1
            while j < len(ln):
                if ln[j] == '(': depth += 1
                elif ln[j] == ')':
                    depth -= 1
                    if depth == 0: break
                j += 1
            if j >= len(ln):
                skipped += 1; continue
            new = ln[:m.start()] + r['thunk'] + '(' + ', '.join(r['args']) + ')' + ln[j+1:]
            lines[r['line'] - 1] = new
            touched += 1
        open(f, 'w').writelines(lines)
    print(f"applied {touched}, skipped {skipped}")

if '--apply' in sys.argv:
    apply_plan()
