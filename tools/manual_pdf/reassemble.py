#!/usr/bin/env python3
"""Reassemble the manual from the polished mechanics chunks and append the
Appendix C symbol map generated from symbols.py."""
import re
import sys

sys.path.insert(0, "/home/user/colopy/tools/manual_pdf")
import symbols as S

P = "/home/user/colopy/docs/COLONIZATION_TECHNICAL_REFERENCE.md"
SCRATCH = ("/tmp/claude-0/-home-user-colopy/"
           "0da58ed1-4071-53d7-89b8-553b96f987cf/scratchpad")
GROUPS = {"A": ["5", "8", "9"], "B": ["10", "11", "12", "13", "14"],
          "C": ["15", "16", "17", "18"], "D": ["19", "20", "21", "23"]}


def split_secs(text):
    parts = re.split(r"(?m)^(## (?:\d+|[ABC])\. .*)$", text)
    head = parts[0]
    secs, order = {}, []
    for i in range(1, len(parts), 2):
        key = re.match(r"## (\d+|[ABC])\.", parts[i]).group(1)
        secs[key] = parts[i] + parts[i + 1]
        order.append(key)
    return head, secs, order


def main():
    head, secs, order = split_secs(open(P).read())
    for g, keys in GROUPS.items():
        chunk = open(f"{SCRATCH}/polish_{g}.md").read()
        _, csecs, corder = split_secs(chunk)
        missing = [k for k in keys if k not in csecs]
        if missing:
            print(f"chunk {g}: MISSING sections {missing} — keeping originals")
        for k in keys:
            if k in csecs:
                secs[k] = csecs[k]
    # Appendix C
    lines = ["## C. Appendix — symbol map\n",
             "\nThe mechanics chapters use friendly names. This table binds "
             "every name back to the shipped binary, preserving the byte-level "
             "provenance the rest of the project is built on.\n",
             "\n### C.1 Functions\n",
             "\n| Name | Binary routine |\n|---|---|\n"]
    for label, name in sorted(S.FUNCS.items(), key=lambda kv: kv[1]):
        lines.append(f"| `{name}()` | `{label}` (file {label[5:].lower()}) |\n")
    lines.append("\n### C.2 Globals\n\n| Variable | Storage |\n|---|---|\n")
    for addr, name in sorted(S.GLOBALS.items(), key=lambda kv: kv[1]):
        lines.append(f"| `{name}` | DGROUP `[{addr}]` |\n")
    lines.append("\n### C.3 Record fields\n\n| Variable | Storage |\n|---|---|\n")
    for (rec, off), name in sorted(S.FIELDS.items(),
                                   key=lambda kv: (kv[0][0], kv[1])):
        scope = S.FIELD_SCOPES.get(rec, rec.lower())
        lines.append(f"| `{scope}.{name}` | `{rec} +{off}` |\n")
    lines.append("\n")
    secs["Cx"] = "".join(lines)
    if "C" in order:
        secs["C"] = secs.pop("Cx")
    else:
        order.append("C")
        secs["C"] = secs.pop("Cx")
    open(P, "w").write(head + "".join(secs[k] for k in order))
    print("reassembled", len(order), "sections (incl. Appendix C)")


if __name__ == "__main__":
    main()
