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
    """Return (seg, off, [push-exprs], nargs, err) for the lcall AT or
    FORWARD-NEAR addr (cites often mark the start of the push run)."""
    win = disasm_window(addr, back=0x40, fwd=0x30)
    idx = next((i for i, x in enumerate(win) if x.address == addr), None)
    if idx is None:
        return None
    # accept the lcall at the cite, else the FIRST lcall within +0x24 bytes
    call = None
    for j in range(idx, len(win)):
        if win[j].address > addr + 0x24:
            break
        if win[j].mnemonic == 'lcall':
            call = win[j]; idx = j; break
    if call is None:
        return None
    m = re.match(r'0x([0-9a-f]+), 0x([0-9a-f]+)', call.op_str)
    if not m:
        return None
    seg, off = int(m.group(1), 16), int(m.group(2), 16)
    # cleanup
    cleanup = 0
    if idx + 1 < len(win):
        m = re.match(r'sp, (0x[0-9a-f]+|\d+)', win[idx+1].op_str) \
            if win[idx+1].mnemonic == 'add' else None
        if m:
            cleanup = int(m.group(1), 0)
    nargs = cleanup // 2
    # FORWARD-SIMULATE the push run: walk back to a barrier instruction,
    # then replay forward tracking simple register loads (so `mov si,X ...
    # push si` resolves in execution order).
    def classify_src(src, allow_byte_ax=False):
        if re.match(r'^-?(0x[0-9a-f]+|\d+)$', src):
            return {'kind': 'imm', 'c': src}
        if re.match(r'^word ptr \[0x[0-9a-f]+\]$', src):
            a = re.search(r'0x[0-9a-f]+', src).group(0)
            return {'kind': 'dg16', 'c': f'(int16_t)DG16({a})'}
        if allow_byte_ax and re.match(r'^byte ptr \[0x[0-9a-f]+\]$', src):
            a = re.search(r'0x[0-9a-f]+', src).group(0)
            return {'kind': 'dg8', 'c': f'(int16_t)DG8({a})'}
        if re.match(r'^word ptr \[bp \+ (0x[0-9a-f]+|\d+)\]$', src):
            d = int(re.search(r'bp \+ (0x[0-9a-f]+|\d+)', src).group(1), 0)
            return {'kind': 'param', 'bp': d}
        if re.match(r'^word ptr \[bp - ', src):
            return {'kind': 'local', 'c': None, 'raw': src}
        return None

    barrier = idx
    j = idx - 1
    budget = 24
    while j >= 0 and budget:
        mn, op = win[j].mnemonic, win[j].op_str
        ok = (mn == 'push' or mn == 'nop' or mn in ('cwde', 'cbw')
              or (mn in ('sub', 'xor') and op in ('ah, ah', 'dh, dh', 'bh, bh'))
              or (mn == 'mov' and re.match(r'^(ax|al|bx|cx|dx|si|di), ', op)))
        if not ok:
            break
        barrier = j
        j -= 1
        budget -= 1
    pushes = []
    regs = {}
    for k in range(barrier, idx):
        mn, op = win[k].mnemonic, win[k].op_str
        if mn == 'mov':
            m2 = re.match(r'^(ax|al|bx|cx|dx|si|di), (.+)$', op)
            if m2:
                r2, src = m2.groups()
                if r2 == 'al':
                    e = classify_src(src, allow_byte_ax=True)
                    regs['ax'] = e if e else {'kind': 'other', 'c': None, 'raw': op}
                else:
                    e = classify_src(src)
                    regs[r2] = e if e else {'kind': 'other', 'c': None, 'raw': op}
            continue
        if mn == 'push':
            e = classify_src(op.replace('word ptr ', 'word ptr ')) \
                if not re.match(r'^(ax|bx|cx|dx|si|di|ds|ss|es|cs)$', op) else None
            if e is None and re.match(r'^(ax|bx|cx|dx|si|di)$', op):
                e = regs.get(op) or {'kind': 'reg', 'c': None, 'raw': op}
            elif e is None and op in ('ds', 'ss', 'es', 'cs'):
                e = {'kind': 'seg', 'c': None, 'raw': op}
            elif e is None:
                e = classify_src(op)
                if e is None:
                    e = {'kind': 'other', 'c': None, 'raw': op}
            pushes.append(e)
            continue
        # cwde/cbw/sub ah,ah/nop: no effect on word-level model
    # MERGED-TAIL GUARD: if any jump in/around the window lands INSIDE the
    # push run, two control paths push different args into one call site --
    # a linear read would hard-code one path.  Flag such sites.
    run_lo = win[barrier].address
    run_hi = win[idx].address
    for ins3 in win:
        if ins3.mnemonic.startswith('j'):
            mt = re.match(r'^0x([0-9a-f]+)$', ins3.op_str)
            if mt:
                tgt = int(mt.group(1), 16)
                if run_lo < tgt <= run_hi and not (run_lo <= ins3.address < run_hi):
                    return (seg, off, None, nargs, 'merged-tail join')
    pushes = pushes[-nargs:] if nargs else pushes
    # cdecl: last nargs pushes before the call, left-to-right = arg order
    # (pushes list is in EXECUTION order: first pushed = rightmost arg)
    pushes = list(reversed(pushes))
    if nargs == 0:
        # register convention: AX=arg0, DX=arg1, BX=arg2 from the forward regs
        order = []
        for rname in ('ax', 'dx', 'bx'):
            e = regs.get(rname)
            if e is None or e.get('kind') in (None, 'other', 'reg', 'seg') or e.get('c') is None and e.get('kind') not in ('param','local'):
                break
            order.append(e)
        if order:
            return (seg, off, order, len(order), 'REGCONV')
    if len(pushes) != nargs:
        return (seg, off, None, nargs, 'push-walk-short')
    # walking BACK from the call, the first push met was pushed LAST = arg0,
    # so the collected list is ALREADY in cdecl order -- do not reverse.
    return (seg, off, pushes, nargs, None)

LOCAL_ANN_RX = re.compile(r'\b(?:int(?:16_t|32_t|8_t)?|uint(?:16|32|8)_t|char|long|short)\s+'
                          r'(\w+)\s*(?:=[^;]*)?;\s*/\*\s*(?:@asm\s*)?\[bp\s*-\s*(0x[0-9A-Fa-f]+|\d+)\]')

def enclosing_func(lines, ln):
    """Find the enclosing C function definition above line ln (0-based);
    return (name, {bp_plus_off: param}, {bp_minus_off: local}).
    A column-0 '}' between the candidate def and the call line means the
    def regex skipped over a function boundary (multiline definition) --
    bail with empty maps so the site is flagged, not mis-mapped."""
    fdef = None
    for i in range(ln, -1, -1):
        if lines[i].startswith('}'):
            # previous function ended before we found a def -> multiline def
            return None, {}, {}
        m = FUNCDEF_RX.match(lines[i])
        if m and not lines[i].lstrip().startswith(('extern', 'typedef')):
            fdef = i
            params = {}
            plist = [q.strip() for q in m.group(2).split(',')] if m.group(2).strip() not in ('', 'void') else []
            for k, q in enumerate(plist):
                pm = re.search(r'(\w*bp_([0-9A-Fa-f]{2}))\s*(?:/\*.*?\*/)?\s*$', q)
                if pm:
                    params[int(pm.group(2), 16)] = pm.group(1)
                else:
                    # positional fallback: far-call frame -> arg k at bp+6+2k.
                    nm2 = re.search(r'([A-Za-z_]\w*)\s*(?:/\*.*?\*/)?\s*$', q)
                    if nm2 and nm2.group(1) not in ('void',):
                        params.setdefault(6 + 2 * k, nm2.group(1))
            locals_ = {}
            for j in range(i + 1, min(i + 40, ln + 1)):
                lm = LOCAL_ANN_RX.search(lines[j])
                if lm:
                    locals_[int(lm.group(2), 0)] = lm.group(1)
            return m.group(1), params, locals_
    return None, {}, {}

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
                cite = (CITE_RX.search(ln)
                        or (CITE_RX.search(lines[n-1]) if n >= 1 else None)
                        or (CITE_RX.search(lines[n-2]) if n >= 2 else None)
                        or (CITE_RX.search(lines[n+1]) if n+1 < len(lines) else None))
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
                seg, off, args, nargs, tag = r
                want = blocked[name]['arity']
                if tag == 'REGCONV':
                    if nargs < want:
                        flagged.append({'file': f, 'line': n+1, 'stub': name,
                                        'why': f'reg-conv: derived {nargs} of {want} reg args',
                                        'addr': hex(addr)})
                        continue
                    args = args[:want]; nargs = want
                elif nargs == 0 and want > 0:
                    flagged.append({'file': f, 'line': n+1, 'stub': name,
                                    'why': f'register-convention (cleanup 0, target wants {want})',
                                    'addr': hex(addr)})
                    continue
                fn, params, locs = enclosing_func(lines, n)
                cargs, bad = [], None
                for a in args:
                    if a['kind'] in ('imm', 'dg16', 'dg8'):
                        cargs.append(a['c'])
                    elif a['kind'] == 'param' and a['bp'] in params:
                        cargs.append(params[a['bp']])
                    elif a['kind'] == 'local' and a.get('raw'):
                        dm = re.search(r'bp - (0x[0-9a-f]+|\d+)', a['raw'])
                        d = int(dm.group(1), 0) if dm else None
                        if d in locs:
                            cargs.append(locs[d])
                        else:
                            bad = a; break
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

def order_match():
    """For canonical-named stubs (unambiguous seg:off) whose sites lack a
    usable cite: within each C function's @asm span, find every
    `lcall seg,off` for that stub in the EXE and pair them to the C call
    sites IN ORDER.  Only when counts match exactly is the pairing sound."""
    blocked = json.load(open(os.path.join(ROOT, 'tools/generated/thunk_arity_blocked.json')))
    stubs = {s for s in blocked if re.match(r'overlay_call_[0-9A-F]{4}_[0-9A-F]{4}$', s)}
    span_rx = re.compile(r'@asm\s+(?:func_\w+\s+@\s+)?(?:file\s+)?0x([0-9A-Fa-f]{5,6})\.\.0x([0-9A-Fa-f]{5,6})')
    plan, flagged = [], []
    for f in sorted(glob.glob(os.path.join(ROOT, 'src/**/*.c'), recursive=True)):
        raw = open(f, errors='replace').read()
        if not any(s in raw for s in stubs):
            continue
        lines = raw.splitlines()
        # function definition lines
        defs = []
        for n, ln in enumerate(lines):
            m = FUNCDEF_RX.match(ln)
            if m and not ln.lstrip().startswith(('extern', 'typedef')):
                defs.append((n, m.group(1)))
        defs.append((len(lines), '_EOF_'))
        for di in range(len(defs) - 1):
            d0, fname = defs[di]
            d1 = defs[di + 1][0]
            # span: search the 40 lines above the def for a range cite
            span = None
            for j in range(max(0, d0 - 40), d0 + 1):
                sm = span_rx.search(lines[j])
                if sm:
                    span = (int(sm.group(1), 16), int(sm.group(2), 16))
            if not span:
                continue
            lo, hi = span
            if hi <= lo or hi - lo > 0x8000:
                continue
            body = DATA[lo:hi]
            for stub in stubs:
                # C sites of this stub inside [d0,d1)
                csites = []
                for n in range(d0, d1):
                    if re.search(r'\b' + stub + r'\s*\(', lines[n]) and 'extern' not in lines[n]:
                        csites.append(n)
                if not csites:
                    continue
                seg = int(stub[13:17], 16); off = int(stub[18:22], 16)
                pat = bytes([0x9A, off & 0xFF, off >> 8, seg & 0xFF, seg >> 8])
                exe_sites = []
                k = body.find(pat)
                while k != -1:
                    exe_sites.append(lo + k)
                    k = body.find(pat, k + 1)
                if len(exe_sites) != len(csites):
                    continue
                # span-anchored alignment: disassemble once from the span
                # start (a true boundary) and accept only addresses that
                # fall on instruction starts in that stream.
                boundaries = set()
                for ins in MD.disasm(DATA[lo:hi + 0x10], lo):
                    boundaries.add(ins.address)
                for n, addr in zip(csites, exe_sites):
                    if addr not in boundaries:
                        continue
                    r = decode_site(addr)
                    if not r or r[2] is None:
                        continue
                    s2, o2, args, nargs, tag = r
                    want = blocked[stub]['arity']
                    if tag == 'REGCONV':
                        if nargs < want:
                            continue
                        args = args[:want]; nargs = want
                    elif nargs == 0 and want > 0:
                        continue
                    fn2, params, locs = enclosing_func(lines, n)
                    cargs, bad = [], None
                    for a in args:
                        if a['kind'] in ('imm', 'dg16', 'dg8'):
                            cargs.append(a['c'])
                        elif a['kind'] == 'param' and a['bp'] in params:
                            cargs.append(params[a['bp']])
                        elif a['kind'] == 'local' and a.get('raw'):
                            dm = re.search(r'bp - (0x[0-9a-f]+|\d+)', a['raw'])
                            dd = int(dm.group(1), 0) if dm else None
                            if dd in locs:
                                cargs.append(locs[dd])
                            else:
                                bad = a; break
                        else:
                            bad = a; break
                    if bad:
                        continue
                    plan.append({'file': f, 'line': n + 1, 'stub': stub,
                                 'addr': hex(addr), 'thunk': stub,
                                 'nargs': nargs, 'args': cargs})
    print(f"ORDER-MATCHED tier-1: {len(plan)}")
    json.dump({'plan': plan, 'flagged': []}, open('/tmp/arg_restore_plan.json', 'w'), indent=1)
    with open('/tmp/arg_restore_plan.txt', 'w') as out:
        for r in plan:
            out.write(f"OM  {r['file']}:{r['line']} {r['stub']}({', '.join(r['args'])})\n")

if '--order-match' in sys.argv:
    order_match()

def near_match():
    """For unrestored canonical-stub sites: take ANY @asm cite within +-3
    lines and search the EXE for this thunk's lcall pattern within +-0x80
    of it; bind when EXACTLY ONE hit exists.  Iterates EVERY canonical
    overlay_call_* stub that is still WEAK in the binary (not just the
    arity-blocked set), with the target arity read from the wanted map
    when known, else from the cleanup bytes."""
    blocked = json.load(open(os.path.join(ROOT, 'tools/generated/thunk_arity_blocked.json')))
    import subprocess as sp
    nm = sp.run(['nm', os.path.join(ROOT, 'build_modern/viceroy_modern')],
                capture_output=True, text=True).stdout
    weakset = set(re.findall(r' W (overlay_call_[0-9A-F]{4}_[0-9A-F]{4})', nm))
    stubs = weakset | {s for s in blocked if re.match(r'overlay_call_[0-9A-F]{4}_[0-9A-F]{4}$', s)}
    plan = []
    for f in sorted(glob.glob(os.path.join(ROOT, 'src/**/*.c'), recursive=True)):
        raw = open(f, errors='replace').read()
        if not any(s in raw for s in stubs):
            continue
        lines = raw.splitlines()
        for n, ln in enumerate(lines):
            for cm in re.finditer(r'\b(overlay_call_[0-9A-F]{4}_[0-9A-F]{4})\s*\(([^)]*)\)', ln):
                stub = cm.group(1)
                if stub not in stubs or 'extern' in ln:
                    continue
                inner = re.sub(r'/\*.*?\*/', '', cm.group(2)).strip()
                if inner != '':
                    continue  # already restored
                cite = None
                for dn in (0, -1, 1, -2, 2, -3, 3):
                    j = n + dn
                    if 0 <= j < len(lines):
                        cmm = CITE_RX.search(lines[j])
                        if cmm:
                            cite = int(cmm.group(1), 16); break
                if cite is None:
                    continue
                seg = int(stub[13:17], 16); off = int(stub[18:22], 16)
                pat = bytes([0x9A, off & 0xFF, off >> 8, seg & 0xFF, seg >> 8])
                lo = max(0, cite - 0x80); hi = min(len(DATA), cite + 0x80)
                hits = []
                k = DATA.find(pat, lo, hi)
                while k != -1:
                    hits.append(k)
                    k = DATA.find(pat, k + 1, hi)
                if len(hits) != 1:
                    continue
                r = decode_site(hits[0])
                if not r or r[2] is None:
                    continue
                s2, o2, args, nargs, tag = r
                want = blocked[stub]['arity'] if stub in blocked else nargs
                if tag == 'REGCONV':
                    if nargs < want: continue
                    args = args[:want]; nargs = want
                elif nargs == 0 and want > 0:
                    continue
                fn2, params, locs = enclosing_func(lines, n)
                cargs, bad = [], None
                for a in args:
                    if a['kind'] in ('imm', 'dg16', 'dg8'):
                        cargs.append(a['c'])
                    elif a['kind'] == 'param' and a['bp'] in params:
                        cargs.append(params[a['bp']])
                    elif a['kind'] == 'local' and a.get('raw'):
                        dm = re.search(r'bp - (0x[0-9a-f]+|\d+)', a['raw'])
                        dd = int(dm.group(1), 0) if dm else None
                        if dd in locs: cargs.append(locs[dd])
                        else: bad = a; break
                    else:
                        bad = a; break
                if bad:
                    continue
                plan.append({'file': f, 'line': n + 1, 'stub': stub,
                             'addr': hex(hits[0]), 'thunk': stub,
                             'nargs': nargs, 'args': cargs})
    print(f"NEAR-MATCHED: {len(plan)}")
    json.dump({'plan': plan, 'flagged': []}, open('/tmp/arg_restore_plan.json', 'w'), indent=1)

if '--near-match' in sys.argv:
    near_match()
