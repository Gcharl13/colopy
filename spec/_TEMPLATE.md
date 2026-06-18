# <Subsystem / UI screen name>

> **Layer 2 — Specification.** Built from evidence (Layer 1), consumed by the
> implementation (Layer 3). See `/METHODOLOGY.md`. Every claim below is tagged
> with a confidence tier: `BYTE_VERIFIED` / `ANCHOR_VERIFIED` / `RECONSTRUCTED`
> / `TBD`. Do not assert anything ungrounded — an honest `TBD` over a guess.

**Overall confidence:** <tier> · **Last updated:** <date> ·
**Canonical evidence:** <key files / offsets>

## 1. Purpose & behavior
What this subsystem does, in plain language. The player-visible effect and the
role it plays in the game loop.

## 2. State & data layout
The records, globals, and fields this subsystem reads/writes. Use a table:

| Address / field | Type | Meaning | Tier | Evidence |
|-----------------|------|---------|------|----------|
| `PowerRecord +0xNN` | u16 | … | BYTE_VERIFIED | `docs/DATA_MODEL.md`; `@asm 0x…` |

## 3. Formulas & rules
The exact computation(s), as named arithmetic a re-implementer can code directly.
Cite each constant/threshold to its byte. Mark any inferred step's tier.

```
result = …            // @asm 0x…  (tier)
```

## 4. UI layout — "what is drawn where"
Which screen(s)/dialog(s) this surfaces in: panel positions, sprite/text at
which coordinates, the message keys (GAME.TXT/LABELS.TXT), button/hit-regions.
Cite the paint function and asset names.

## 5. Evidence (citations)
Bulleted list mapping each claim to its source:
- `@asm 0x……` (function `func_……`) — …
- `NAMES.TXT $SECTION` row N — …
- `docs/…` / `notes/rulings/RULINGS.md <date>` — …

## 6. Confidence summary
Per-claim tier rollup; what is solid vs reconstructed.

## 7. Open questions (TBD)
Explicit list of what is NOT known, each with the Layer-1 entry point that would
resolve it (so it can move to `spec/BACKLOG.md`). Cross-source conflicts noted
here and ruled in `notes/rulings/RULINGS.md`.
