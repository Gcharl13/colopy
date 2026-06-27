#!/usr/bin/env python3
"""harvest_roles.py — name the overlay thunks (and functions) from what the spec already says.

Many `lcall SEG:OFF` thunks are documented across spec/notes/docs with a human role
(e.g. "`0x181F:0x13C`=`func_002B38` is **draw-text-at-(x,y)**"). This harvests those role
phrases and stamps them onto the flat substrate so every resolved thunk/call carries a
meaning, not just `func_XXXXXX`. Hint layer for navigation (regenerable; high-precision patterns).

Emits code/VICEROY/flat/roles.json {thunks:{"SEG:OFF":role}, functions:{func_NAME:role}} and
re-runs the enrichment into functions.jsonl + thunk_resolve.json.
"""
import json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FLAT = ROOT / "code/VICEROY/flat"
SRC_DIRS = [ROOT / "spec", ROOT / "notes", ROOT / "docs"]

THUNK = re.compile(r"0x([0-9a-fA-F]{3,4}):0x([0-9a-fA-F]+)")
FUNC = re.compile(r"func_([0-9A-Fa-f]{4,6})")
BOLD = re.compile(r"\*\*([^*]{3,60}?)\*\*")
# status/marker words that are NOT roles
BLOCK = re.compile(r"^(B|A|R|TBD|DONE|PARTIAL|Caveat|Purpose|Note|Correction|Corrected|Resolved|"
                   r"Confirmed|Verified|BYTE.?VERIFIED|RUNTIME.*|RESOLVED.*|CORRECTED.*|NOT\b.*|"
                   r"was\b.*|now\b.*|inline|Canonical.*|primary|stale|amended.*|overturned.*)", re.I)

def norm_role(s):
    s = s.strip().strip(":.,;").strip()
    if not (3 <= len(s) <= 60):
        return None
    if BLOCK.match(s):
        return None
    # drop phrases that are really code/citations, not roles
    if any(t in s for t in ("func_", "0x", "=", "`", "@0", "·", "][")):
        return None
    return s

def positional_pairs(line, tokens_re):
    """yield (token_match, following_role) — pair each token with the next bold before the next token."""
    toks = list(tokens_re.finditer(line))
    bolds = [(m.start(), norm_role(m.group(1))) for m in BOLD.finditer(line)]
    bolds = [(pos, r) for pos, r in bolds if r]
    for i, tk in enumerate(toks):
        nxt = toks[i + 1].start() if i + 1 < len(toks) else len(line) + 1
        role = next((r for pos, r in bolds if tk.end() <= pos < nxt), None)
        if role:
            yield tk, role

thunk_role, func_role = {}, {}
for d in SRC_DIRS:
    for p in d.rglob("*.md"):
        for line in p.read_text(errors="replace").splitlines():
            if "**" not in line:
                continue
            for tk, role in positional_pairs(line, THUNK):
                seg, off = tk.groups()
                thunk_role.setdefault(f"{seg.upper()}:{off.upper().zfill(4)}", role)
            for tk, role in positional_pairs(line, FUNC):
                func_role.setdefault(f"func_{tk.group(1).upper()}", role)

# apply onto the substrate -----------------------------------------------------------------
recs = [json.loads(l) for l in open(FLAT / "functions.jsonl")]
by_name = {}
for r in recs:
    by_name.setdefault(r["name"], r)

def role_for(func_name, seg_off):
    return (thunk_role.get(seg_off) or func_role.get(func_name)
            or (by_name.get(func_name, {}) or {}).get("role"))

for r in recs:
    if not r.get("role"):
        r["role"] = func_role.get(r["name"])
    for c in r["calls"]:
        so = f"{c['seg']}:{c['off']}"
        c["thunk_role"] = role_for(c.get("target_name"), so)
with open(FLAT / "functions.jsonl", "w") as f:
    for r in recs:
        f.write(json.dumps(r) + "\n")

tr = json.load(open(FLAT / "thunk_resolve.json"))
for so, v in tr.items():
    v["role"] = thunk_role.get(so) or func_role.get(v.get("target_name"))
json.dump(tr, open(FLAT / "thunk_resolve.json", "w"), indent=0)

json.dump({"thunks": thunk_role, "functions": func_role},
          open(FLAT / "roles.json", "w"), indent=1)
named_thunks = sum(1 for v in tr.values() if v.get("role"))
print(f"harvest_roles: {len(thunk_role)} thunk roles + {len(func_role)} function roles from docs")
print(f"  {named_thunks}/{len(tr)} substrate thunk seg:off now carry a role -> flat/roles.json")
