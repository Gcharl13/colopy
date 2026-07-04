# CLAUDE.md — orientation for new-colony

This is a **build-from-spec** project: implement a new *Colonization*-style game from the
complete, byte-verified specification in `spec/`. It is **not** a reverse-engineering project —
there is no disassembly here. The spec is finished; your job is the implementation.

## Orientation (read in this order)
1. `README.md` — what's in the repo.
2. `spec/README.md` → `spec/systems/*.md` + `spec/ui/*.md` — **the contract** (formulas, layouts,
   colors, data layouts). This is the source of truth.
3. `REWRITE_READINESS.md` — the implementation strategy: the **preserve-vs-modernize** fidelity
   policy, the architecture (pure sim core / thin presentation / offline asset bundle), and the
   validation approach (visual parity + behavioral golden-master tests).
4. `formats/*.md` + `data_extracted/**` + `docs/atlas/**` — the data and assets to build on.

## Working rules
- **The spec is the contract.** Reproduce the *documented output* of every formula/layout/color.
  The implementation form is free (any language, engine, int width, RNG) per `REWRITE_READINESS.md` §1.
- **Don't guess game behavior** — if it's in `spec/`, follow it; if it's genuinely unspecified,
  pick a sensible default and note it, don't invent a "fact."
- **Reuse the pipeline**, don't re-derive it: `bin/reconstitute.py` + `tools/*` regenerate data/assets;
  `viceroy_cpp/` is a working reference for the format loaders.

## Load-bearing data invariants (matter for any map/asset code)
- Terrain ids: base 0–7 unforested, **8..23 forested** variants, **24 Arctic / 25 Ocean / 26 Sea Lane**,
  27 Mountains / 28 Hills. `.MP` tile byte (func_0624E, byte-verified + AMER2.MP-confirmed): low 5 bits
  = terrain id (`& 0x1F`, never 27/28 in shipped maps), **bit 0x20 = special terrain (Hills; with
  bit 0x80 = Mountains)**, **bit 0x40 = river overlay** (bit 0x80 = major river). Forest is the id band
  8..23, not a bit. (`spec/systems/map_system.md` §8, `formats/MP_FORMAT.md`.)
- The right-edge map column is the **Sea Lane** (id 26), never desert.
- Sprite sheets: `TERRAIN.SS` is the base-ground sheet composited under `PHYS0.SS` overlays; skip
  placeholder frames 0/16/100; `BDARK.SS`/`FONTSMAL.FF` are orphans (don't load). (`spec/ui/map_view.md`.)
- The atlas/asset images are **24-bit BMPs** (user directive 2026-07-04: every asset ships as BMP,
  not PNG). Transparency = the pure-magenta colorkey (255,0,255 — not a `VICEROY.PAL` color, never
  used opaquely; verified repo-wide). The runtime quantizes RGB back to `VICEROY.PAL` indices at
  load (`native_assets.cpp read_png_quantized`), so index identity + palette cycling survive;
  `.png` siblings still load as a fallback. (`REWRITE_READINESS.md` §4a.)
