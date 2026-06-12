#!/usr/bin/env python3
"""Triage the arity-blocked thunk rows: classify each stub's C call sites by
the argument count they actually pass; rows where EVERY site passes the
measured arity are safe to PROVIDE mechanically."""
import json, re, os, sys, glob

blocked = json.load(open('tools/generated/thunk_arity_blocked.json'))
src_files = glob.glob('src/**/*.c', recursive=True)
file_text = {f: open(f, errors='replace').read() for f in src_files}

def strip_noise(s):
    s = re.sub(r'/\*.*?\*/', '', s, flags=re.S)
    s = re.sub(r'//[^\n]*', '', s)
    s = re.sub(r'"(\\.|[^"\\])*"', '""', s)
    s = re.sub(r"'(\\.|[^'\\])*'", "''", s)
    return s

def count_args(text, idx):
    """text[idx] == '('; return number of top-level args."""
    depth, i, n = 0, idx, len(text)
    start = idx + 1
    args, cur = [], []
    while i < n:
        c = text[i]
        if c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
            if depth == 0:
                cur = ''.join(cur).strip()
                if cur: args.append(cur)
                break
        elif c == ',' and depth == 1:
            args.append(''.join(cur)); cur = []
            i += 1; continue
        if depth >= 1 and not (depth == 1 and c == '('):
            cur.append(c)
        i += 1
    args = [a for a in (x.strip() for x in args) if a and a != 'void']
    return len(args)

def target_returns_pointer(target):
    pat = re.compile(r'^[\w \t]*\*[ \t]*(far[ \t]*\*+[ \t]*)?' + re.escape(target) + r'\s*\(', re.M)
    pat2 = re.compile(r'^\s*(void|uint8_t|char|int\d*_t|unsigned|struct \w+)\s*(far\s*)?\*+\s*' + re.escape(target) + r'\s*\(', re.M)
    for t in file_text.values():
        if pat.search(t) or pat2.search(t):
            return True
    return False

safe, review, nosite = [], [], []
for stub, info in sorted(blocked.items()):
    target, arity = info['target'], info['arity']
    sites = []
    for f, raw in file_text.items():
        if stub not in raw: continue
        t = strip_noise(raw)
        for m in re.finditer(r'\b' + re.escape(stub) + r'\s*\(', t):
            # skip declarations: preceded by 'extern' on the same statement-ish
            back = t[max(0, m.start()-120):m.start()]
            if re.search(r'extern[^;{]*$', back): continue
            sites.append((f, count_args(t, m.end()-1)))
    if not sites:
        nosite.append((stub, target, arity))
    elif all(c == arity for _, c in sites):
        if target_returns_pointer(target):
            review.append((stub, target, arity, sites, 'ptr-return'))
        else:
            safe.append((stub, target, arity, len(sites)))
    else:
        review.append((stub, target, arity, sites, 'arg-count'))

print(f"SAFE (all sites pass measured arity): {len(safe)}")
print(f"REVIEW (mismatched/ptr): {len(review)}")
print(f"NO C call site found: {len(nosite)}")
print()
for s in safe:
    print("SAFE", s[0], "->", s[1], f"arity={s[2]} sites={s[3]}")
print()
for s in review[:40]:
    print("REVIEW", s[0], "->", s[1], f"want={s[2]}", s[4], [(os.path.basename(f), c) for f, c in s[3]][:4])
json.dump({'safe': [(a,b,c) for a,b,c,_ in safe],
           'review': [(a,b,c) for a,b,c,_,_ in review],
           'nosite': nosite}, open('/tmp/arity_triage.json','w'), indent=1)
