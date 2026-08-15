#!/usr/bin/env python3
"""gen_sd_pack.py — C-port Phase 6: build the Teensy microSD asset pack.

Converts the original DOS assets (raw/COLONIZE/, rebuilt by
bin/reconstitute.py) into ONE packed file COLOPY.PAK plus a generated C
header cport/data/colopy_pak.h describing the table of contents.

Codec provenance (per CLAUDE.md — no guessed formats):
  * .SS / .PIK  MADSPACK 2.0 + FAB + sprite RLE via tools/ssdec.py, the
                byte-verified port of the in-EXE madspack_load /
                fab_decompress / rle_decode (formats/SS.md, formats/PIK.md).
  * .PIK layout section 0 -> h,w u16le; pixel section = the one sized w*h;
                palette = last section >= 768 bytes of 6-bit RGB
                (port/tools/build_assets.py, viceroy_cpp/src/pik.cpp).
  * .FF         single FAB section -> the engine-native font payload
                [H][maxw][128 width bytes][128 u16 offsets][2bpp bitmaps]
                (formats/FF.md, CRACKED 2026-06-21; ch-1 slot mapping per
                func_00E51C @0x00E5DA).  Stored VERBATIM — the C reader
                indexes it exactly like the EXE does.
  * VICEROY.PAL 768 bytes of 6-bit RGB, widened (v<<2)|(v>>4) like the
                engine's DAC upload (formats/PAL.md).
  * TEXT        the display-text members of the JS DATA (the same content
                gen_c_data.py emits as cport/data/colopy_text.c), packed as
                a flat key/value string table so a flash-constrained Teensy
                build can drop colopy_text.o and serve the strings from SD
                (MEMORY_BUDGET.md).
  * CYCLE       the VGA colour-cycling band from CYCLE.DAT as decoded by
                port/tools/build_assets.py into port/assets/manifest.json
                (start/len/delay).

Pack format (little-endian; mirrored in cport/data/colopy_pak.h):
  header   'CPAK' u16 count
  TOC      count * { char name[12] (NUL-padded, no NUL when len==12);
                     u32 offset; u32 len; u16 w, h, frames }
  payloads per kind:
    .SS   u16 nframes, u16 flags (bit0 = 768-byte RGB888 palette appended),
          nframes * { i16 x, i16 y, u16 w, u16 h, u32 off }, pixel blobs
          (8-bit indexed, w*h each, 0xFD transparent; off is payload-rel.)
    .PIK  w*h 8-bit pixels, then 768-byte RGB888 palette when the file
          embeds one (len == w*h + 768 distinguishes)
    .FF   the decompressed font payload verbatim
    .PAL  768 bytes RGB888
    CYCLE u16 start, u16 len, u16 delay
    TEXT  u32 n, n * { u32 key_off, u32 val_off }, NUL-terminated pool

Sheet set = the port's census (port/assets/manifest.json) minus the derived
PHYS0C atlas (a re-keyed copy of PHYS0 the JS renderer builds; the C
renderer re-derives it) — BDARK.SS is never packed (CLAUDE.md hard rule 5).
Every sheet/font is cross-checked against the manifest at generation time
so the pak census and the JS DATA census cannot drift silently.

Usage:  python3 tools/gen_sd_pack.py [--out cport/pak/COLOPY.PAK]
"""
from __future__ import annotations

import argparse
import json
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "port" / "tools"))
import ssdec  # noqa: E402

COLONIZE = ROOT / "raw" / "COLONIZE"
MANIFEST = ROOT / "port" / "assets" / "manifest.json"
HDR_OUT = ROOT / "cport" / "data" / "colopy_pak.h"

MAGIC = b"CPAK"
NAME_LEN = 12

# display-text members — keep in lockstep with gen_c_data.py TEXT_MEMBERS
TEXT_MEMBERS = ("dialogs", "diplotext", "events", "pedia", "scorenames",
                "text", "woodcuts")


def u16(b, o):
    return b[o] | (b[o + 1] << 8)


def load_pik(data: bytes):
    """(w, h, pixels, rgb888-or-None) — port/tools/build_assets.py layout."""
    secs = [d for _, d in ssdec.madspack_load(data)]
    h, w = u16(secs[0], 0), u16(secs[0], 2)
    npx = w * h
    pix = next(i for i in range(1, len(secs)) if len(secs[i]) == npx)
    pal = None
    for i in range(len(secs)):
        if i != pix and len(secs[i]) >= 768:
            pal = secs[i]
    rgb = None
    if pal is not None:
        rgb = bytes(((v << 2) | (v >> 4)) & 0xFF for v in pal[:768])
    return w, h, bytes(secs[pix]), rgb


def load_ff(data: bytes) -> bytes:
    """The engine-native font payload (formats/FF.md), verbatim."""
    secs = [d for _, d in ssdec.madspack_load(data)]
    payload = max(secs, key=len)          # the single content section
    if len(payload) < 386:
        raise ValueError("FF payload shorter than its fixed tables")
    return bytes(payload)


def flatten(prefix: str, v, out: list):
    if isinstance(v, dict):
        for k in sorted(v, key=str):
            flatten(f"{prefix}.{k}" if prefix else str(k), v[k], out)
    elif isinstance(v, list):
        for i, e in enumerate(v):
            flatten(f"{prefix}.{i}", e, out)
    elif isinstance(v, bool):
        out.append((prefix, "1" if v else "0"))
    elif v is None:
        out.append((prefix, ""))
    else:
        out.append((prefix, str(v)))


def build_text_section() -> tuple[bytes, int]:
    import bundle  # port/tools — builds the JS DATA from data_extracted/
    D, _ = bundle.build_data()
    pairs: list[tuple[str, str]] = []
    for m in TEXT_MEMBERS:
        if m in D:
            flatten(m, D[m], pairs)
    pool = bytearray()
    offs = []
    for k, v in pairs:
        ko = len(pool); pool += k.encode("utf-8") + b"\0"
        vo = len(pool); pool += v.encode("utf-8") + b"\0"
        offs.append((ko, vo))
    base = 4 + 8 * len(pairs)
    blob = struct.pack("<I", len(pairs))
    for ko, vo in offs:
        blob += struct.pack("<II", base + ko, base + vo)
    return blob + bytes(pool), len(pairs)


def build_sheet(path: Path, want_pal: bool):
    sh = ssdec.load_sheet(path)
    frames = sh["frames"]
    hdr = struct.pack("<HH", len(frames), 1 if want_pal else 0)
    table = b""
    blob = bytearray()
    pix_base = 4 + 12 * len(frames)
    for (x, y, w, h, pixels) in frames:
        table += struct.pack("<hhHHI", x, y, w, h, pix_base + len(blob))
        blob += pixels
    payload = hdr + table + bytes(blob)
    if want_pal:
        payload += sh["pal"]              # 768 bytes RGB888 (widened by ssdec)
    maxw = max((f[2] for f in frames), default=0)
    maxh = max((f[3] for f in frames), default=0)
    return payload, len(frames), maxw, maxh


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(ROOT / "cport" / "pak" / "COLOPY.PAK"))
    args = ap.parse_args()

    if not COLONIZE.is_dir():
        sys.exit("raw/COLONIZE missing — run bin/reconstitute.py first")
    man = json.load(open(MANIFEST))

    entries = []                          # (name, payload, w, h, frames)

    # ---- sprite sheets: the port's census minus the derived PHYS0C ----
    sheet_names = sorted(k for k in man["sheets"] if k != "PHYS0C")
    for nm in sheet_names:
        assert nm != "BDARK", "BDARK.SS is an orphan — never load (rule 5)"
        # every sheet carries its embedded palette (768 B each): the
        # speaker-figure ramps (MSS/MYR/IND/KING) live at indices >= 128
        # and are streamed into the upper DAC when a portrait shows —
        # the single-DAC model the dialog renderer implements.
        want_pal = True
        payload, nfr, w, h = build_sheet(COLONIZE / f"{nm}.SS", want_pal)
        mf = man["sheets"][nm]["frames"]
        if len(mf) != nfr:
            sys.exit(f"{nm}.SS: {nfr} frames but manifest has {len(mf)}")
        sh = ssdec.load_sheet(COLONIZE / f"{nm}.SS")
        for i, f in enumerate(mf):
            if (f["w"], f["h"]) != (sh["frames"][i][2], sh["frames"][i][3]):
                sys.exit(f"{nm}.SS frame {i}: dims disagree with manifest")
        entries.append((f"{nm}.SS", payload, w, h, nfr))

    # ---- backgrounds ----
    for nm in sorted(man["backgrounds"]):
        w, h, pix, rgb = load_pik((COLONIZE / f"{nm}.PIK").read_bytes())
        mb = man["backgrounds"][nm]
        if (mb["w"], mb["h"]) != (w, h):
            sys.exit(f"{nm}.PIK: {w}x{h} but manifest says {mb['w']}x{mb['h']}")
        payload = pix + (rgb if rgb is not None else b"")
        entries.append((f"{nm}.PIK", payload, w, h, 1))

    # ---- fonts ----
    for nm in sorted(man["fonts"]):
        payload = load_ff((COLONIZE / f"{nm}.FF").read_bytes())
        H, maxw = payload[0], payload[1]
        if H != man["fonts"][nm]["h"]:
            sys.exit(f"{nm}.FF: cell height {H} != manifest {man['fonts'][nm]['h']}")
        # manifest widths are width(ch) = table[ch-1] (formats/FF.md mapping)
        for ch, wd in man["fonts"][nm]["widths"].items():
            got = payload[2 + int(ch) - 1]
            if got != wd:
                sys.exit(f"{nm}.FF: width({ch}) {got} != manifest {wd}")
        entries.append((f"{nm}.FF", payload, maxw, H, 128))

    # ---- master palette ----
    pal6 = (COLONIZE / "VICEROY.PAL").read_bytes()[:768]
    pal8 = bytes(((v << 2) | (v >> 4)) & 0xFF for v in pal6)
    entries.append(("VICEROY.PAL", pal8, 0, 0, 256))

    # ---- colour-cycling band (CYCLE.DAT via the manifest) ----
    cy = man["cycle"]
    entries.append(("CYCLE", struct.pack("<HHH", cy["start"], cy["len"],
                                         cy["delay"]), 0, 0, 1))

    # ---- display text ----
    text_blob, n_text = build_text_section()
    entries.append(("TEXT", text_blob, 0, 0, 1))

    # ---- assemble ----
    count = len(entries)
    toc_size = 6 + 26 * count
    off = toc_size
    toc = bytearray(MAGIC + struct.pack("<H", count))
    body = bytearray()
    for name, payload, w, h, frames in entries:
        nb = name.encode("ascii")
        assert len(nb) <= NAME_LEN, name
        toc += nb.ljust(NAME_LEN, b"\0")
        toc += struct.pack("<IIHHH", off, len(payload), w, h,
                           min(frames, 0xFFFF))
        body += payload
        off += len(payload)

    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_bytes(bytes(toc) + bytes(body))

    # ---- generated TOC header ----
    names = [e[0] for e in entries]
    hdr = [
        "/* Generated by tools/gen_sd_pack.py — DO NOT hand-edit.",
        " * COLOPY.PAK layout (little-endian). Codec provenance and the",
        " * per-kind payload formats are documented in the generator's",
        " * docstring; the container is the microSD asset pack for the",
        " * Teensy build (C-port Phase 6). */",
        "#ifndef COLOPY_PAK_H",
        "#define COLOPY_PAK_H",
        "",
        "#ifdef __cplusplus",
        'extern "C" {',
        "#endif",
        "#include <stdint.h>",
        "",
        '#define COLOPY_PAK_MAGIC   "CPAK"',
        "#define COLOPY_PAK_COUNT   %d" % count,
        "#define COLOPY_PAK_NAMELEN %d" % NAME_LEN,
        "#define COLOPY_PAK_HDRLEN  6           /* magic + u16 count */",
        "#define COLOPY_PAK_TOCENT  26          /* name[12] u32 off u32 len u16 w,h,frames */",
        "#define COLOPY_SS_TRANSPARENT 0xFD     /* rle_decode sentinel */",
        "",
        "/* TOC entry, parsed field-wise (the on-disk record is unaligned):",
        " *   +0  char name[12]   NUL-padded (no NUL when the name is 12 chars)",
        " *   +12 u32  offset     from the start of the pak file",
        " *   +16 u32  len        payload length in bytes",
        " *   +20 u16  w, h       sheets: max frame dims; PIK: image dims;",
        " *                       FF: max glyph width / cell height H",
        " *   +24 u16  frames     sheets: frame count; FF: 128; PAL: 256",
        " *",
        " * Sheet payload:  u16 nframes, u16 flags (bit0 = 768-byte RGB888",
        " *   palette appended), nframes * { i16 x, i16 y, u16 w, u16 h,",
        " *   u32 off (payload-relative) }, 8-bit pixels (0xFD transparent).",
        " * PIK payload:    w*h 8-bit pixels [+ 768-byte RGB888 palette].",
        " * FF payload:     [H][maxw][128 width bytes][128 u16 offsets]",
        " *   [2bpp MSB-first bitmaps] — width(ch) = table[ch-1], per",
        " *   formats/FF.md and func_00E51C @0x00E5DA.",
        " * VICEROY.PAL:    768 bytes RGB888 ((v6<<2)|(v6>>4)).",
        " * CYCLE:          u16 start, u16 len, u16 delay (CYCLE.DAT band).",
        " * TEXT:           u32 n, n * { u32 key_off, u32 val_off },",
        " *   NUL-terminated UTF-8 pool (offsets payload-relative) — the",
        " *   colopy_text.c content, SD-served when flash drops that unit. */",
        "",
        "static const char *const COLOPY_PAK_NAMES[COLOPY_PAK_COUNT] = {",
    ]
    for i in range(0, count, 4):
        hdr.append("    " + " ".join('"%s",' % n for n in names[i:i + 4]))
    hdr += ["};", "", "#ifdef __cplusplus", "}", "#endif",
           "#endif /* COLOPY_PAK_H */", ""]
    HDR_OUT.write_text("\n".join(hdr))

    total = toc_size + len(body)
    print(f"COLOPY.PAK: {count} entries, {total} bytes "
          f"({len(sheet_names)} sheets, {len(man['backgrounds'])} backgrounds, "
          f"{len(man['fonts'])} fonts, {n_text} text pairs)")
    print(f"wrote {out} + {HDR_OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
