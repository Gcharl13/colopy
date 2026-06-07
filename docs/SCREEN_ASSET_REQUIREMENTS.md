# Screen → Asset requirements

For every UI state observed in the session, this doc lists exactly
which sprites, backgrounds, text strings, and memory addresses the
renderer needs.

Created 2026-05-05 from `SESSION_UI_CATALOG.md` + `RENDERER_GEOMETRY.md`.

---

## Map view (default gameplay)

**Frame example**: 1310262984

| Asset | Source |
|-------|--------|
| Background tiles | PHYS0.SS + TERRAIN.SS (per-tile from .MP map data) |
| Right sidebar bg | WOODPANL.PIK |
| Top menu bar | (chrome rect, no asset) — text from LABELS.TXT @MISC |
| Unit sprites on map | ICONS.SS (per UnitRecord +0x00 type) |
| Colony sprites on map | ICONS.SS for occupied marker + name |
| Native village sprites | ICONS.SS or specific village sheet |
| Selected-unit highlight | ICONS.SS slot ~96+ (red rect variants) |
| Cursor | CURSOR.SS |
| Minimap | runtime-rendered miniature of map |

| Text | Source |
|------|--------|
| GAME / VIEW / ORDERS / REPORTS / TRADE / CHEAT / COLONIZOPEDIA | LABELS.TXT @MISC menu items |
| "Spring %YEAR" | NAMES.TXT @SEASONS[0] + dynamic year |
| "Gold: NNNN%" | LABELS.TXT @MISC "Gold" |
| "Tax: N%" | LABELS.TXT @MISC "Tax:" |
| "Moves: N", "Locat: (x, y)" | LABELS.TXT @INFO |
| Unit type label | NAMES.TXT @UNIT[type] |
| Unit skill | NAMES.TXT @JOB[skill] |
| Order status (No Orders / Sentry / etc.) | LABELS.TXT @MISC |
| Terrain label "(Tropical Forest)" | NAMES.TXT @FORESTED[idx] |

| Memory | Field |
|--------|-------|
| PowerRecord +0x2A | gold |
| PowerRecord +0x01 | tax % |
| DGROUP 0x538A | year |
| DGROUP 0x538E | turn |
| UnitRecord at 0x3146 + N×28 | per-unit data (type at +0x00, pos at +0x07/+0x08) |

---

## Colony view

**Frame example**: 1310196718

| Asset | Source |
|-------|--------|
| Colony scene | composed from BUILDING.SS sprites + colonist ICONS |
| Inventory bar bg | COLONY.PIK strip at y=128..200 |
| Building selected slots | BUILDING.SS per index |
| Worker tile sprites | tile-based with PHYS0/TERRAIN |
| Colonist sprites at work tiles | ICONS.SS unit types |
| Production icons (bell/cross/hammer) | ICONS.SS UI markers |
| Right sidebar bg | WOODPANL.PIK |
| EXIT button | EXIT.SS |

| Text | Source |
|------|--------|
| "%COLONY%, %SEASON %YEAR%, Gold: NNNN%" | dynamic format using LABELS.TXT @CTITLE |
| "Pop:" / "Gold:" | LABELS.TXT @CTITLE |
| "BUY" / "CHANGE" buttons | LABELS.TXT @CTITLE |
| Colonist count display "102 (0)" / "902 (5)" | runtime computed |
| "Loading: %SHIP%" | LABELS.TXT @MISC "Loading" |
| "(Outside Colony)" marker | LABELS.TXT @MISC line 138 |
| Commodity stockpile counts | per-good byte from ColonyRecord |

| Memory | Field |
|--------|-------|
| ColonyRecord at 0x8542 (active) | per-colony state (size 202+174 bytes) |
| ColonyRecord +0x00 | map_x |
| ColonyRecord +0x01 | map_y |
| ColonyRecord +0x02..0x19 | name (NUL-terminated) |
| ColonyRecord +0x1A | owner_power_idx |
| ColonyRecord +0x1F | size |
| ColonyRecord +0xC2 | wealth/accumulator |

---

## Build menu overlay

**Frame example**: 1310206750

| Asset | Source |
|-------|--------|
| Overlay frame | WOODFRAM (or runtime rect) |
| (overlay over colony view) | colony screen still rendered behind |

| Text | Source |
|------|--------|
| "Select An Item To Build" | LABELS.TXT @CTITLE line 4 |
| Each option name | NAMES.TXT @BUILDING[N] (note: differs from PEDIA which has 42 entries) |
| "(N Hammers)" / "(N Tools)" | runtime numbers |
| "(F1 for Help)" | LABELS.TXT @MISC line 204 |
| "(No Production)" | LABELS.TXT @CTITLE |
| "Wagon Train" "(40 Hammers)" | NAMES.TXT @UNIT[12] for name |

Cost table (from session frame 1310206750 — the 15 player-buildable
options at TIER 1 in Plymouth):

```python
BUILD_COSTS = {  # PEDIA index : (hammers, tools)
    0:  (64,  0),   # Stockade
    3:  (52,  0),   # Armory
    6:  (52,  0),   # Docks
    12: (64,  0),   # Schoolhouse
    15: (80,  0),   # Warehouse
    17: (64,  0),   # Stables
    19: (52, 20),   # Printing Press
    22: (64, 20),   # Weaver's Shop
    25: (64, 20),   # Tobacconist's Shop
    28: (64, 20),   # Rum Distillery
    33: (56, 20),   # Fur Trader's Shop
    36: (52,  0),   # Lumber Mill
    37: (64,  0),   # Church
    40: (64, 20),   # Blacksmith's Shop
    "wagon": (40, 0),  # Wagon Train (UNIT, not building)
}
```

These need byte-verification against the cost table in
`func_02D658` disasm.

---

## Continental Congress Activities

**Frame example**: 1310124562

| Asset | Source |
|-------|--------|
| Background | CCBKGD.PIK (orange-toned scene with white-wigged figure) |
| US flag sprite (next to bell sprites) | TBD — likely small flag in ICONS or dedicated |
| Bell sprites (one per bells/turn) | TBD — possibly in ICONS or separate "BELL.SS" |
| REF Regulars unit sprite | ICONS.SS soldier (red uniform) |
| REF Cavalry unit sprite | ICONS.SS dragoon (white/blue) |
| REF Artillery unit sprite | ICONS.SS artillery (cannon) |
| REF Man-O-War sprite | ICONS.SS ship type |
| FF portrait sprites (acquired) | CC-NN per FF index |

| Text | Source |
|------|--------|
| "CONTINENTAL CONGRESS ACTIVITIES" | LABELS.TXT @MISC line 52 |
| "Next Continental Congress Session:" | LABELS.TXT @MISC line 127 |
| FF name in parentheses | NAMES.TXT @FATHERS[next_FF_idx] |
| "(NN in MM)" progress | runtime computed from PowerRecord +0x0C |
| "Rebel Sentiment: NN%" | LABELS.TXT @MISC + PowerRecord +0x02 |
| "Tory Sentiment: NN%" | derived = 100 - Rebel |
| "%NATION% Expeditionary Force:" | LABELS.TXT "Expeditionary Force" + nation prefix |
| "Founding Fathers:" | LABELS.TXT @MISC line 104 |
| Acquired FF list | NAMES.TXT @FATHERS filtered by acquired bitmask |
| "OK" button | LABELS.TXT @MISC line 61 |

| Memory | Field |
|--------|-------|
| PowerRecord +0x02 byte | rebel_sentiment_pct |
| PowerRecord +0x0C u16 | bells_lifetime |
| PowerRecord +0x0E u16 | bells_per_turn |
| PowerRecord +0x14 u16 | founding_father_count |
| DGROUP 0x53DA u16 | REF Regulars |
| DGROUP 0x53DC u16 | REF Cavalry |
| DGROUP 0x53DE u16 | REF Man-O-War |
| DGROUP 0x53E0 u16 | REF Artillery |
| ??? | acquired FF bitmask (TBD location) |

---

## Europe trade port

**Frame example**: 1310291187

| Asset | Source |
|-------|--------|
| Sky / harbor background | EUROPE.PIK |
| Inventory bar strip | COLONY.PIK overlay y=128..200 |
| Ship sprites on dock | ICONS.SS per ship type |
| Cargo crates | ICONS.SS commodity slots |
| RECRUIT/PURCHASE/TRAIN buttons | runtime drawn rects with text |
| 16 commodity icons | ICONS.SS slots ~12-27 |
| Boycott red X overlay | ICONS.SS slot 043 |
| EXIT red E button | EXIT.SS |

| Text | Source |
|------|--------|
| "Selling %GOOD% at NN%/ton Gold: (NNNN)" | dynamic — banner top |
| "Sold N %GOOD% at N%/ton" | LABELS.TXT @CMESSAGE "sold for"/"at"/"$/ton" |
| "Price:" / "% Tax:" / "Net:" | LABELS.TXT @CMESSAGE |
| "Expected Soon" | LABELS.TXT @MISC |
| "Bound For %COLONY%" | LABELS.TXT @MISC + colony name |
| "Loading: %SHIP%" | LABELS.TXT @MISC |
| "RECRUIT" | LABELS.TXT @EUROLABEL[0] |
| "PURCHASE" | LABELS.TXT @EUROLABEL[1] |
| "TRAIN" | LABELS.TXT @EUROLABEL[2] |
| Cargo current/max | runtime per-good ColonyRecord values |

| Memory | Field |
|--------|-------|
| PowerRecord +0x2A | player gold |
| PowerRecord +0x20 u16 | boycott bitfield (bit i = good i) |
| PowerRecord +0x4C+i byte | per-good price/sensitivity (0xC8 = saturated) |
| PowerRecord +0x5C + i*2 word | per-good market pool |

---

## Banner popups (PRICEDOWN / PRICERISE / SHIPSAILING / etc.)

**Frame example**: 1310280609 (Sugar fallen to 17)

| Asset | Source |
|-------|--------|
| Background | live map view (composited under) |
| Speaker sprite (MSS2 merchant) | MSS2/MSS2.SS.000.png |
| Wood frame border | WOODFRAM.SS (stretched/tiled) |

| Text | Source |
|------|--------|
| Body | GAME.TXT @PRICEDOWN / @PRICERISE template |
| %STRING0 substitute | NAMES.TXT @CARGO[good_idx] |
| %STRING1 substitute | "London" / nation home port |
| %NUMBER0 substitute | runtime-computed price |

| Memory | Field |
|--------|-------|
| (price at remote market) | likely DGROUP price-state arrays |
| (popup-rect) | computed at runtime from cursor + @width directive |

---

## Advisor warning popup (NOOCEAN)

**Frame example**: 1310261859

| Asset | Source |
|-------|--------|
| Background | live map view |
| Speaker sprite (MSS3 pioneer) | MSS3/MSS3.SS.000.png |
| Wood frame | WOODFRAM.SS |

| Text | Source |
|------|--------|
| Body | GAME.TXT @NOOCEAN... template |
| Response option 1 | quoted line in GAME.TXT |
| Response option 2 (highlighted as default) | quoted line + @default=2 directive |

---

## Foreign colony info sidebar

**Frame example**: 1310321000 (Santo Domingo, Spanish)

| Asset | Source |
|-------|--------|
| Background | live map (left) + WOODPANL sidebar (right) |
| Foreign nation flag | NAMES.TXT @COUNTRY display |
| With/Ask commodity icons | ICONS.SS commodity slots |
| Ship sprites (in foreign port) | ICONS.SS per ship type |

| Text | Source |
|------|--------|
| Coords + size "Locat: (x, y) NN" | LABELS.TXT @INFO + runtime |
| Nation name "New Spain" | NAMES.TXT @COUNTRY[2] |
| Tile attributes "(Tropical Forest)(Road)" | NAMES.TXT @FORESTED + LABELS.TXT @MISC "Road" |
| Colony name | from foreign ColonyRecord |
| "With:" / "Ask:" labels | LABELS.TXT @INFO + @MISC |
| Unit names + status | NAMES.TXT @UNIT + LABELS.TXT @MISC orders |
| "+ More +" | LABELS.TXT @MISC line 120 |

---

## Asset usage summary

Total distinct asset categories used across all observed UI states:

| Category | Count used in session | Total in library |
|----------|---------------------:|-----------------:|
| MSS / MYR portraits | 2 of 10 | 10 |
| WDCUT scenes | 0 of 13 | 13 |
| CC-NN portraits | 0 of 25 (text only) | 25 |
| IND tribe sprites | 0 of 8 | 8 |
| Nation flags | 0 of 8 | 8 |
| KING sprites | 0 of 5 | 5 |
| PIK backgrounds | 4 of 35 (CCBKGD, EUROPE, COLONY, WOODPANL) | 35 |
| ICONS sprites | many (units + commodities) | 266 |
| BUILDING sprites | many (colony interior) | 48 |

The 90% of unused assets need triggering events to verify in
context — but the visual identification is now complete via direct
.png inspection of each sprite.
