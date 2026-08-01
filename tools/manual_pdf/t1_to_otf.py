#!/usr/bin/env python3
"""Convert a Type1 .pfb to an installable OTF: tx -cff, then wrap with fontTools."""
import subprocess, sys, io
from fontTools.cffLib import CFFFontSet
from fontTools.fontBuilder import FontBuilder
from fontTools.pens.boundsPen import BoundsPen
from fontTools.agl import toUnicode

def convert(pfb, out, family, style):
    cff_bytes = subprocess.run(["tx", "-cff", "+b", pfb], capture_output=True).stdout
    if not cff_bytes.startswith(b"\x01"):
        raise SystemExit(f"tx failed on {pfb}: {cff_bytes[:200]}")
    cff = CFFFontSet()
    cff.decompile(io.BytesIO(cff_bytes), None)
    td = cff[cff.fontNames[0]]
    cs = td.CharStrings
    order = td.getGlyphOrder()
    if ".notdef" not in order:
        raise SystemExit("no .notdef")

    glyphs, metrics, cmap = {}, {}, {}
    for name in order:
        g = cs[name]
        bp = BoundsPen(cs)
        g.draw(bp)  # also computes g.width
        w = int(round(g.width))
        lsb = int(round(bp.bounds[0])) if bp.bounds else 0
        glyphs[name] = g
        metrics[name] = (w, lsb)
        u = toUnicode(name)
        if len(u) == 1 and ord(u) not in cmap and name != ".notdef":
            cmap[ord(u)] = name

    upm = 1000
    fb = FontBuilder(upm, isTTF=False)
    fb.setupGlyphOrder(order)
    fb.setupCharacterMap(cmap)
    ps = f"{family.replace(' ', '')}-{style.replace(' ', '')}"
    fb.setupCFF(ps, {"FullName": f"{family} {style}", "FamilyName": family,
                     "Weight": style}, glyphs, {})
    fb.setupHorizontalMetrics(metrics)
    asc, desc = 980, -240
    fb.setupHorizontalHeader(ascent=asc, descent=desc)
    bold = "Bold" in style
    italic = "Italic" in style
    styl = style if style != "Regular" else "Regular"
    fb.setupNameTable({"familyName": family, "styleName": styl,
                       "psName": ps, "fullName": f"{family} {style}",
                       "version": "1.0", "uniqueFontIdentifier": ps})
    fb.setupOS2(sTypoAscender=asc, sTypoDescender=desc, sTypoLineGap=0,
                usWinAscent=asc, usWinDescent=-desc,
                usWeightClass=700 if "Bold" in style else 400,
                fsSelection=(0x20 if bold else 0) | (1 if italic else 0) | (0x40 if not bold and not italic else 0),
                achVendID="RECN")
    fb.setupPost()
    if bold:
        fb.font["head"].macStyle |= 1
    if italic:
        fb.font["head"].macStyle |= 2
    fb.save(out)
    print(f"OK {out}: {len(order)} glyphs, {len(cmap)} mapped")

JOBS = [
    ("/usr/share/fonts/X11/Type1/c0648bt_.pfb", "CharterRE-Regular.otf", "Charter RE", "Regular"),
    ("/usr/share/fonts/X11/Type1/c0649bt_.pfb", "CharterRE-Italic.otf", "Charter RE", "Italic"),
    ("/usr/share/fonts/X11/Type1/c0632bt_.pfb", "CharterRE-Bold.otf", "Charter RE", "Bold"),
    ("/usr/share/fonts/X11/Type1/c0633bt_.pfb", "CharterRE-BoldItalic.otf", "Charter RE", "Bold Italic"),
]
for pfb, out, fam, sty in JOBS:
    convert(pfb, out, fam, sty)
