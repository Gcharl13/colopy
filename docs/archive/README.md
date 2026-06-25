# docs/archive — superseded decode/decompile docs

These are full-content snapshots of docs that were **parallel** to the canonical `spec/`
layer — multiple files decoding the same subsystem, which is a primary driver of the
project's re-litigation churn (the same fact written, corrected, and re-written across
several docs). They are kept here for history; a **stub at the original `docs/` path**
redirects to the canonical source so existing links don't dangle.

## Policy (the consolidation rule)
- **One canonical doc per subsystem = the `spec/` file.** Corrections **edit the spec**; they
  do not spawn or update a parallel decode doc.
- New byte-facts cite the disassembly/Ghidra C directly, or a line in `notes/SETTLED.md`.
- Do **not** add new content to anything under `docs/archive/` or to a redirect stub.

## What moved (and its canonical replacement)
| Archived doc | Canonical source |
|---|---|
| `COLONY_SCREEN_COMPLETE_DECODE.md` | `spec/ui/colony_screen.md` |
| `COLONY_SCREEN_VICEROY_DECODE.md` | `spec/ui/colony_screen.md` |
| `COLONY_SCREEN_PANELS_DECOMPILE.md` | `spec/ui/colony_screen.md` |
| `INGAME_MAP_RENDER_TRACE.md` | `spec/systems/map_system.md` |
| `UI_RENDER_MAP.md` | `spec/systems/map_system.md` |
| `MAPVIEW_SCREEN_VICEROY_DECODE.md` | `spec/ui/map_view.md` |

See `notes/SETTLED.md` for the closed-fact digest and `tools/churn_metric.py` for the
churn trend this consolidation is meant to bend downward.
