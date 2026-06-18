#!/usr/bin/env python3
"""extract_txt_sections.py -- faithful parser for Colonization .TXT data files.

The original game ships its data + message templates as @-section .TXT files
(GAME.TXT, NAMES.TXT, LABELS.TXT, ...). Each section is:

    @KEY
    @width=220              ; optional directive line(s) (contain '=')
    body line 1             ; verbatim text, may contain %STRING0../%NUMBER/{braces}
    body line 2
                            ; blank line / next @KEY ends the section
    ; comment lines         ; self-document the columns of the NEXT section

This produces, per file:
  * data_extracted/text/<NAME>_sections.json   flat { "@KEY": "body" } (back-compat,
    now WITH full bodies and WITHOUT directives-as-keys -- the old ad-hoc dump
    dropped bodies and mis-recorded @width=/@default= directives as sections)
  * data_extracted/text/<NAME>.full.json        rich { file, sections: { "@KEY": {
    legend, directives, body, rows } } } -- `rows` present for CSV data sections.

Encoding is DOS cp437; CRLF normalised to LF. No interpretation of meaning here
-- this is the primary BASIS. Column *semantics* are byte-grounded separately.
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

DIRECTIVE_RE = re.compile(r"^@[A-Za-z0-9_]+=")     # @width=220, @y=5, @default=2
SECTION_RE = re.compile(r"^@[A-Za-z0-9_]+\s*$")     # @SUCCESSION


def parse_txt(text: str) -> "list[dict]":
    # Normalise line endings; decode already done by caller.
    lines = text.replace("\r\n", "\n").replace("\r", "\n").split("\n")
    sections: list[dict] = []
    cur: dict | None = None
    pending_legend: list[str] = []

    def finalize(sec: dict | None) -> None:
        if sec is None:
            return
        body_lines = sec.pop("_body_lines")
        # strip leading/trailing blank lines, keep internal structure
        while body_lines and body_lines[0].strip() == "":
            body_lines.pop(0)
        while body_lines and body_lines[-1].strip() == "":
            body_lines.pop()
        sec["body"] = "\n".join(body_lines)
        # CSV detection: a data section is mostly comma-rows
        nonblank = [b for b in body_lines if b.strip()]
        if len(nonblank) >= 2 and sum("," in b for b in nonblank) >= 0.6 * len(nonblank):
            sec["rows"] = [[c.strip() for c in b.split(",")] for b in nonblank]
        sections.append(sec)

    for raw in lines:
        line = raw.rstrip("\n")
        stripped = line.strip()
        if stripped.startswith(";"):
            pending_legend.append(stripped.lstrip(";").strip())
            continue
        if DIRECTIVE_RE.match(stripped):
            if cur is not None:
                k, _, v = stripped[1:].partition("=")
                cur["directives"][k] = v
            continue
        if SECTION_RE.match(stripped):
            finalize(cur)
            cur = {
                "key": stripped,
                "legend": [l for l in pending_legend if l],
                "directives": {},
                "_body_lines": [],
            }
            pending_legend = []
            continue
        # body line (text or blank)
        if cur is not None:
            cur["_body_lines"].append(line)
        # else: preamble before first section -> ignore (it's the license header)
    finalize(cur)
    return sections


def process(txt_path: Path, text_dir: Path) -> dict:
    raw = txt_path.read_bytes()
    text = raw.decode("cp437", errors="replace")
    sections = parse_txt(text)
    stem = txt_path.stem.upper()

    # back-compat flat dump: { "@KEY": "body" } (first occurrence wins)
    flat: dict[str, str] = {}
    for s in sections:
        flat.setdefault(s["key"], s["body"])
    (text_dir / f"{stem}_sections.json").write_text(
        json.dumps(flat, indent=2, ensure_ascii=False), encoding="utf-8"
    )

    # rich dump: full structure incl. legend/directives/rows
    rich = {
        "file": txt_path.name,
        "section_count": len(sections),
        "sections": {
            s["key"]: {
                k: v for k, v in s.items() if k != "key"
            }
            for s in sections
        },
    }
    (text_dir / f"{stem}.full.json").write_text(
        json.dumps(rich, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    csv_sections = sum(1 for s in sections if "rows" in s)
    return {"file": txt_path.name, "sections": len(sections), "csv": csv_sections}


def main() -> int:
    ap = argparse.ArgumentParser(description="Parse Colonization .TXT into section JSON (the primary text basis).")
    ap.add_argument("--root", default=str(Path(__file__).resolve().parent.parent))
    ap.add_argument("--src", default=None, help="dir of .TXT (default raw/COLONIZE)")
    ap.add_argument("--files", nargs="*", default=None)
    args = ap.parse_args()

    root = Path(args.root)
    src = Path(args.src) if args.src else root / "raw" / "COLONIZE"
    text_dir = root / "data_extracted" / "text"
    text_dir.mkdir(parents=True, exist_ok=True)

    txts = (
        [src / f for f in args.files]
        if args.files
        else sorted(src.glob("*.TXT"))
    )
    for p in txts:
        if not p.is_file():
            print(f"WARN missing {p}")
            continue
        r = process(p, text_dir)
        print(f"[txt] {r['file']:14s} {r['sections']:4d} sections  ({r['csv']} CSV)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
