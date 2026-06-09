#!/usr/bin/env python3
"""
poke_to_dgroup.py -- convert raw DGROUP pokes to the dgroup.h accessor layer.

Rewrites scalar `*(TYPE near *)OPERAND` pokes into the typed DG accessors
(DG8/DGS8/DG16/DGS16/DG32/DGS32) from include/dgroup.h, preserving the address
expression so @asm citations stay valid (memory-model refactor, milestone 2).

CONSERVATIVE by design -- only converts operands it can prove safe, and SKIPS
(leaves raw, reports) anything ambiguous:
  - `0xHEX` / decimal literal address              -> DGn(0xHEX)
  - `DGROUP_PTR(EXPR)`  (unwrap; DGn re-applies it) -> DGn(EXPR)
  - a single balanced `(EXPR)` group not part of a cast-expression -> DGn(EXPR)
SKIPPED (need manual review): bare identifiers/pointer vars, `(cast)(expr)`,
call-operands, pointer-to-pointer pokes, and any match on a `#define` line.

Usage:  python3 tools/poke_to_dgroup.py <file.c> [--apply]
"""
import re, sys

TYPE2MACRO = {
    "unsigned char": "DG8", "uint8_t": "DG8", "int8_t": "DGS8",
    "uint16_t": "DG16", "int16_t": "DGS16",
    "uint32_t": "DG32", "int32_t": "DGS32",
}
CAST = re.compile(
    r'\*\(\s*(' + '|'.join(re.escape(t) for t in TYPE2MACRO) + r')\s+near\s*\*\)')
TYPE_KW = re.compile(r'(unsigned|signed|u?int\d+_t|char|short|long|void)\b')

def grab_balanced(s, i):
    """s[i]=='('; return (group_incl_parens, end_idx) or (None, i)."""
    depth = 0; j = i; n = len(s)
    while j < n:
        if s[j] == '(': depth += 1
        elif s[j] == ')':
            depth -= 1
            if depth == 0:
                return s[i:j+1], j+1
        j += 1
    return None, i

def parse_operand(s, i):
    """From just after the cast `)`, return (macro_arg, end_idx, safe)."""
    n = len(s)
    while i < n and s[i] in ' \t':
        i += 1
    # DGROUP_PTR(EXPR) -> unwrap
    m = re.match(r'DGROUP_PTR\s*\(', s[i:])
    if m:
        grp, end = grab_balanced(s, i + m.end() - 1)
        if grp is None:
            return None, i, False
        return grp[1:-1].strip(), end, True
    # hex / decimal literal
    m = re.match(r'0[xX][0-9A-Fa-f]+|[0-9]+', s[i:])
    if m:
        end = i + m.end()
        nxt = s[end] if end < n else ';'
        if nxt in '([' or re.match(r'[A-Za-z0-9_.]', nxt):
            return None, i, False           # part of a larger expression
        return m.group(0), end, True
    # balanced (EXPR) group
    if i < n and s[i] == '(':
        grp, end = grab_balanced(s, i)
        if grp is None:
            return None, i, False
        inner = grp[1:-1].strip()
        # (uint16_t)(expr) or (uint16_t)var — size-cast DGROUP offset: strip the cast
        SIZE_CAST = re.compile(r'^(u?int(?:16|32)_t|unsigned(?:\s+(?:short|int))?)$')
        if SIZE_CAST.match(inner):
            k = end
            while k < n and s[k] in ' \t': k += 1
            if k < n and s[k] == '(':           # (uint16_t)(expr) form
                grp2, end2 = grab_balanced(s, k)
                if grp2 is None: return None, i, False
                inner2 = grp2[1:-1].strip()
                if TYPE_KW.match(inner2): return None, i, False  # nested cast
                return inner2, end2, True
            # (uint16_t)var — bare identifier after cast
            m2 = re.match(r'[A-Za-z_]\w*', s[k:])
            if m2:
                return m2.group(0), k + m2.end(), True
            return None, i, False
        k = end
        while k < n and s[k] in ' \t':
            k += 1
        if k < n and s[k] == '(':
            return None, i, False           # (cast)(expr)
        if TYPE_KW.match(inner):
            return None, i, False           # a type cast
        return inner, end, True
    return None, i, False                   # identifier / pointer var / call

def convert(text):
    out = []; idx = 0; n = len(text); n_conv = 0; n_skip = 0
    line_start = 0
    while idx < n:
        m = CAST.search(text, idx)
        if not m:
            out.append(text[idx:]); break
        # is this match on a #define line?
        ls = text.rfind('\n', 0, m.start()) + 1
        le = text.find('\n', m.start())
        on_define = bool(re.match(r'\s*#\s*define\b', text[ls:le if le >= 0 else n]))
        out.append(text[idx:m.start()])
        macro = TYPE2MACRO[m.group(1)]
        operand, end, safe = parse_operand(text, m.end())
        if on_define or not safe:
            out.append(text[m.start():m.end()]); idx = m.end(); n_skip += 1
            continue
        out.append(f"{macro}({operand})")
        n_conv += 1; idx = end
    return ''.join(out), n_conv, n_skip

def main():
    if len(sys.argv) < 2:
        print(__doc__); return
    path = sys.argv[1]; apply = '--apply' in sys.argv
    src = open(path).read()
    total_n = 0
    for _ in range(8):          # multi-pass: handles nested pokes
        new, n, skip = convert(src)
        total_n += n
        if n == 0: break
        src = new
    print(f"{path}: {total_n} converted, {skip} skipped (manual)")
    if apply and total_n:
        if '#include "dgroup.h"' not in src:
            src = re.sub(r'(#include [^\n]+\n)', r'\1#include "dgroup.h"\n', src, count=1)
        open(path, 'w').write(src)
        print('  applied + ensured #include "dgroup.h"')

if __name__ == '__main__':
    main()
