# Manual PDF pipeline — build notes

Implements the uploaded `MANUAL_BUILD_SPEC_1.md` for this repository.

```
python3 tools/manual_pdf/build.py
# source: docs/COLONIZATION_TECHNICAL_REFERENCE.md
# output: docs/Viceroy_Technical_Reference.pdf  (cover + 106 body pages)
```

Dependencies: `pip install markdown beautifulsoup4 playwright pypdf pdfplumber`
plus a Chromium for Playwright (this environment: `/opt/pw-browsers/chromium`).

## What the builder does (per the spec)

- **Preprocess** — drops the source title block and hand contents; defensive
  re-implementation-citation strips (the source is authored clean).
- **DOM transforms** — `typedef struct` listings → **byte plates** (16
  bytes/row, category-coloured fields, start ticks, labels on runs ≥ 4,
  mapped/unmapped caption, full key table); variable-length structs →
  proportional **ribbons**; `regions = [...]` listings → **UI wireframes**
  (320×200 frame scaled to the measure, numbered regions, key table —
  regions with runtime-computed `-1` bounds are listed but *never drawn*);
  comment-majority listings → annotation blocks; per-column mono/numeric
  **table dressing** (compact class over 18 rows); `.hex` styling with greyed
  `0x` prefix; single-pass code highlighting.
- **Layout** — US Letter portrait, margins 0.82/0.78/0.90/0.75 in, measure
  6.85 in, 660 px SVG viewBox; eight parts with divider pages; section ledes.
- **Two-pass render** — pass 1 measures where every part/section lands
  (pdfplumber, large-glyph matching, NFKD-normalised because extracted PDF
  text drops spaces and keeps fi/fl ligatures); pass 2 renders the real
  contents list; a third pass fires only if pagination shifted.
- **Running heads + folios** — stamped from a separate zero-margin overlay
  PDF (section title left / game title right, 6.4 pt; bold outer folio),
  merged page-by-page with pypdf; content streams recompressed after the
  stamp (pypdf's `merge_page` leaves them uncompressed — 35 MB → 3.4 MB).
- **Cover** — its own zero-margin single-page PDF merged in front; folio 1
  is the first text page. PDF bookmarks (parts → sections) and metadata.

## Face substitutions (network policy blocks font downloads)

| Spec face | Used here | Relationship |
|---|---|---|
| TeX Gyre Adventor (Display) | **URW Gothic** | Adventor is the TeX Gyre extension *of* URW Gothic — same outlines |
| TeX Gyre Heros Cn (Heading) | **Nimbus Sans Narrow** | Heros Cn is the TeX Gyre extension *of* Nimbus Sans Narrow |
| Bitstream Charter (Body) | **Charter RE** | true Bitstream Charter outlines; the system copy is Type 1 (`.pfb`), which Chromium refuses, so `t1_to_otf.py` converts it to OTF (AFDKO `tx` → fontTools wrap) into `~/.fonts` |
| DejaVu Sans Mono (Data) | DejaVu Sans Mono | as specified |

Run `python3 tools/manual_pdf/t1_to_otf.py` once per environment (needs
`pip install afdko`), then `fc-cache -f`.

## QA (spec §8) — all pass

1. no element wider than the body — 0
2. no SVG child outside its parent rect — 0
3. every figure title present in extracted PDF text — 49/49
4. no page under ~120 chars — 4 hits, all part-divider pages (by design)
5. no double-escaped entities — 0

Known deviations from the spec document: the hand-authored extras that the
spec describes for the *original* pipeline (insert registry diagrams,
key-fact strips, the separate Turn-Cycle extract booklet) are not
reproduced — the automatic notation (plates, ribbons, wireframes, dressed
tables) is complete. The spec's §20-retitle preprocessing step targets the
old manual's coverage section and does not apply to this source.
