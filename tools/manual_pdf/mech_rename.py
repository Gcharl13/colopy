#!/usr/bin/env python3
"""De-hex the mechanics chapters of the manual.

Within the mechanics sections only (5, 8..21, 23):
  - func_XXXXXX          -> friendly name from symbols.FUNCS (unknown -> ⟦func⟧ marker)
  - [0xNNNN] globals     -> scoped names from symbols.GLOBALS
  - Record +0xNN fields  -> scoped names from symbols.FIELDS
  - pure-citation parentheses removed; loose @0x / 'at 0xNNNNN' tokens removed
Unknown hex references are wrapped ⟦…⟧ so the language-polish pass can
humanize them. Map/UI/file-format sections are untouched.
"""
import re
import sys

sys.path.insert(0, "/home/user/colopy/tools/manual_pdf")
import symbols as S

P = "/home/user/colopy/docs/COLONIZATION_TECHNICAL_REFERENCE.md"
MECH = {"5", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18",
        "19", "20", "21", "23"}

CITE_WORDS = {
    "at", "set", "cleared", "clear", "gate", "gated", "gates", "loop", "loops",
    "reader", "readers", "writer", "writers", "read", "write", "writes",
    "inc", "dec", "call", "calls", "site", "sites", "via", "thunk", "push",
    "cmp", "mov", "jge", "jle", "jne", "je", "jl", "jg", "jae", "jbe", "imul",
    "idiv", "mul", "div", "shl", "shr", "sar", "test", "or", "and", "add",
    "sub", "sbb", "adc", "neg", "cwd", "cdq", "file", "offset", "ip", "seg",
    "byte", "word", "dword", "the", "a", "an", "to", "on", "in", "of", "ax",
    "bx", "cx", "dx", "al", "bl", "cl", "dl", "si", "di", "bp", "es", "ptr",
    "x", "both", "ways", "each", "per", "es:", "0", "1", "region", "block",
    "trace", "traced", "area", "helper", "checks", "check", "also", "cited",
    "as", "and", "with", "then", "from", "ff", "multiply", "divide", "store",
    "stored", "init", "reset", "zeroed", "latch", "emit", "emitted", "emits",
    "handle", "key", "roll", "rolls", "apply", "applied", "credit", "credited",
    "⟦addr⟧", "⟦state⟧", "⟦helper⟧", "spans", "body", "extent", "range",
}
HEXT = re.compile(r"@?0x[0-9A-Fa-f]+|func_[0-9A-Fa-f]{4,6}|@[0-9A-Fa-f]{4,6}")


def is_pure_cite(content):
    t = HEXT.sub(" ", content)
    t = t.replace("⟦addr⟧", " ⟦addr⟧ ").replace("⟦state⟧", " ⟦state⟧ ") \
         .replace("⟦helper⟧", " ⟦helper⟧ ")
    t2 = re.sub(r"[\d.,;:·×+\-–—/()\[\]`%…§]", " ",
                t.replace("⟦addr⟧", "MARK").replace("⟦state⟧", "MARK")
                 .replace("⟦helper⟧", "MARK"))
    words = [w.lower().strip("`'\"") for w in t2.split()]
    return all((w in CITE_WORDS or w == "mark" or not w) for w in words)


def strip_cites(text):
    # remove parenthetical groups that are pure citations (innermost first)
    for _ in range(4):
        out, changed = [], False
        i = 0
        while i < len(text):
            if text[i] == "(":
                depth, j = 1, i + 1
                while j < len(text) and depth:
                    if text[j] == "(":
                        depth += 1
                    elif text[j] == ")":
                        depth -= 1
                    j += 1
                inner = text[i + 1:j - 1]
                if depth == 0 and "(" not in inner and \
                        (re.search(r"0x[0-9A-Fa-f]{4,6}", inner)
                         or "⟦addr⟧" in inner) and \
                        is_pure_cite(inner):
                    while out and out[-1] in " \t":
                        out.pop()
                    changed = True
                    i = j
                    continue
            out.append(text[i])
            i += 1
        text = "".join(out)
        if not changed:
            break
    # loose citation tokens
    text = re.sub(r"\s*(?:at|@)\s*`?@?0x[0-9A-Fa-f]{5,6}`?(?:\.\.`?@?0x[0-9A-Fa-f]{2,6}`?)?", "", text)
    text = re.sub(r"`?@0x[0-9A-Fa-f]{4,6}`?", "", text)
    # bare 4-6 digit hex (file offsets) left in prose; keep known tables
    text = text.replace("0x2F7B", "the-yield-table").replace(
        "0x2F76", "the-movement-column").replace(
        "0x2F77", "the-defence-column").replace("0x2F78", "the-improvement-column")
    text = re.sub(r"`?\b0x[0-9A-Fa-f]{4,6}\b`?", "⟦addr⟧", text)
    text = text.replace("the-yield-table", "the yield table").replace(
        "the-movement-column", "the Movement column").replace(
        "the-defence-column", "the Defensive column").replace(
        "the-improvement-column", "the Improvement column")
    return text


def rename(text):
    # functions
    def frep(m):
        name = S.FUNCS.get("func_" + m.group(1).upper()) or \
            S.FUNCS.get("func_" + m.group(1))
        return f"{name}()" if name else "⟦helper⟧"
    text = re.sub(r"`?func_([0-9A-Fa-f]{4,6})`?", frep, text)
    # globals [0xNNNN]
    def grep_(m):
        key = "0x" + m.group(1).upper().lstrip("0")
        for k, v in S.GLOBALS.items():
            if k.upper().lstrip("0X").lstrip("0") == m.group(1).upper().lstrip("0"):
                return f"`{v}`"
        return "⟦state⟧"
    text = re.sub(r"`?\[0x([0-9A-Fa-f]{3,4})\]`?", grep_, text)
    # record fields "Record +0xNN" / "Record+0xNN" / "`+0xNN`" after record name
    def fld(m):
        rec, off = m.group(1), "0x" + m.group(2).upper()
        v = S.FIELDS.get((rec, off))
        scope = S.FIELD_SCOPES.get(rec, rec.lower())
        return f"`{scope}.{v}`" if v else f"⟦{scope} field⟧"
    text = re.sub(
        r"`?(UnitRecord|ColonyRecord|PowerRecord|NativeSettlement|TerrainRecord"
        r"|RouteRecord|StopRecord|AIPersonality|TribeData)\s*\+\s*0x([0-9A-Fa-f]{1,2})`?",
        fld, text)
    # possessive shorthand "+0xNN" immediately following a known scope word
    return text


def main():
    text = open(P).read()
    parts = re.split(r"(?m)^(## (?:\d+|[AB])\. .*)$", text)
    out = [parts[0]]
    changed = 0
    for i in range(1, len(parts), 2):
        head, body = parts[i], parts[i + 1]
        m = re.match(r"## (\d+|[AB])\.", head)
        key = m.group(1)
        if key in MECH:
            nb = strip_cites(rename(body))
            changed += 1 if nb != body else 0
            body = nb
        out.append(head)
        out.append(body)
    open(P, "w").write("".join(out))
    residual = len(re.findall(r"⟦", "".join(out)))
    print(f"sections transformed: {changed}; residual markers: {residual}")


if __name__ == "__main__":
    main()
