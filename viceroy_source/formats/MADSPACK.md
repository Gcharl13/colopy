# MADSPACK Format — MicroProse MADS Compression (LZ77 variant / FAB)

## What it is

MADSPACK is the MicroProse MADS engine's LZ77-style compression scheme.
Based on the `pfabcomp.asm` / `pfabexp.asm` modules that appear in
MAPEDIT.EXE's CodeView NB02 symbol table, MADSPACK is implemented by
the FAB (Fast Adaptive Block?) compression library that ships with the
MADS engine.

## Files using MADSPACK

In VICEROY.EXE proper, the MADS compression is used for:
- The intro/outro animation data (possibly within OPENING.EXE)
- Compressed sprite-sheet payloads in the Win16 build
  (where MS_SPRITE bodies are MADSPACK-compressed before the
  sprite-row stream)

In the DOS VICEROY.EXE:
- The .SS files we have are uncompressed MS_SPRITE (no MADSPACK wrapper)
- MADSPACK appears in the Win16-side coldata\*.dll resources but those
  are out of scope per user rule

## Decoder

The Python port has a `madspack.py` decoder in `tools/` that handles
MADSPACK-compressed streams from coldata\*.dll. It's a port of the
`pfabexp.asm` algorithm.

## Algorithm summary

LZ77 variant:
- Sliding-window dictionary (size TBD; likely 4 KB based on similar formats)
- Match length / distance encoded as a short pair (likely 2-3 bytes)
- Literal runs marked with a flag byte every 8 tokens

The exact token encoding requires the `pfabexp.asm` source which would
be in the original MADS library; we have the high-level behavior
verified against extracted assets.

## Citations

- @python    ../../../tools/madspack.py
- @ref       MAPEDIT.EXE NB02 symbol table mentions `pfabcomp.asm` and
              `pfabexp.asm` modules in madsdev.lib
- @rule      Per scope reduction: we do NOT hand-port the Win16 side;
              the DOS .SS files are not MADSPACK-wrapped, so the DOS
              loader path doesn't exercise this codec.
