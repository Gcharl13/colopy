# Game System Anchors — Function Identification

This doc maps each major game system to its canonical entry-point
function, identified via STRING ANALYSIS (the methodology lesson from
the SMITEINDIANS misidentification). Every entry below cites the
PUSH-site of a verified message-key string.

---

## Verified function-to-system mappings

| Game system | Function | Identifying string | Detected size | Real size (est.) | Status |
|-------------|----------|-------------------|--------------|------------------|--------|
| Treasure transport (King's Galleon) | `func_05C878` | CASHTREASURE @0x1be0 (PUSH at file 0x05C8A1) | 518 bytes | 518 bytes ✓ | BYTE_VERIFIED — see [src/native/raze_treasure.c](src/native/raze_treasure.c) |
| Colony burn / capture + LAND-COMBAT decider | `func_05CA7E` | BURNED @0x1c28 (PUSH at file 0x05DAE6) | 429 bytes | ~7437 bytes (body ends RETF @0x5E709; "7521" was an overshoot, corrected 2026-05-30) | structure understood; land-odds decoded (unit_ai_leaf.c); see VERIFICATION_LEDGER |
| Diplomacy meeting / SMITE | `func_057F4E` | SMITEINDIANS @0x1a1a (PUSH at file 0x59974) | 355 bytes | ~6,640 bytes | gold formula BYTE_VERIFIED — see [diplomacy_smite_gold.c](src/native/diplomacy_smite_gold.c) |
| Buy commodity | `func_02B744` | BUYME0 @0x0d29 (PUSH at file 0x02B862) | not yet decoded | not yet decoded | not yet decompiled |
| Market price drift | `func_0305A8` | PRICEUP/PRICEDOWN @0x0fa8/0x0fb0 | 87 bytes | larger | structure understood (see below) |
| King events / REFIT | `func_02F052` | KINGTAX @0x0f01, REFIT @0x0eef | not yet decoded | not yet decoded | not yet decompiled |
| King event handler #2 | `func_0349F4` | KINGTAX2 @0x1094 | not yet decoded | not yet decoded | not yet decompiled |
| **King tax raise/lower** | `func_034AE0` | KINGRAISE/KINGLOWER @0x10A8/0x10B2 | 100 bytes | ~158 bytes | **BYTE_VERIFIED** — see [src/king/king_tax_raise.c](src/king/king_tax_raise.c) |
| Tea Party / tax application | `func_034318` | TEAPARTY @0x106a, TAXOPTIONS @0x105f | 289 bytes | larger | structure understood (see below) |
| Independence event | `func_03DE46` | INDEPENDENCE @0x130b | not yet decoded | not yet decoded | not yet decompiled |
| Declare war / declare independence | `func_03E984` | DECLARE @0x1397 | not yet decoded | not yet decoded | not yet decompiled |
| **SOL display** (Sons of Liberty %) | `func_03E844` | REBELUP/REBELDOWN @0x1362/0x136a | 63 bytes | larger | structure understood (display only — actual SOL math elsewhere) |
| Intervention | `func_03D948` | INTERVENTION @0x12db | not yet decoded | not yet decoded | not yet decompiled |
| Ship combat | `func_03FDDE` | SHIPCOMBAT @0x1415 | not yet decoded | not yet decoded | not yet decompiled |

---

## BYTE_VERIFIED finding: king tax cap = 75 (0x4B)

In `func_034318` (the tea-party / tax-application function), the king's
tax rate stored at `[0x84FC].byte_+1` is capped at **0x4B = 75**. After
applying any change, if `tax > 75`, it's clamped back to 75 (and the
excess is saved as "leftover" for later use).

```asm
@asm 0x03434C  ADD byte [bx+1], al        ; apply tax change
@asm 0x03434F  CMP byte [bx+1], 0x4B      ; vs 75
@asm 0x034353  JLE +0x19                  ; if <= 75, skip clamp
@asm 0x034355..0x03436C  ; tax = 75; leftover = old_excess
```

Reference: [`func_034318_unknown.asm`](code/VICEROY/disasm/func_034318_unknown.asm) lines 30..40.

---

## BYTE_VERIFIED finding: King's tax raise formula

In `func_034AE0`:

```
proposed_change = ((player_or_diff & 0xFE) * 2 + 4) × ((turn_count / 400) + 1)
```

Per-tier amounts (assuming `[0x53A6]` is difficulty 0..4):

| Difficulty | Era 1 (turns 0..399) | Era 2 (400..799) | Era 3 (800..1199) | Era 4 (1200+) |
|-----------|----------------------|-------------------|-------------------|----------------|
| 0 (Discoverer) | +4 | +8 | +12 | +16 |
| 1 (Explorer)   | +4 | +8 | +12 | +16 |
| 2 (Conquistador) | +8 | +16 | +24 | +32 |
| 3 (Governor)   | +8 | +16 | +24 | +32 |
| 4 (Viceroy)    | +12 | +24 | +36 | +48 |

(Pairs share base because of `& 0xFE`.) Cap is 75 (per the tea-party
function above). 5-point safety margin prevents raise when current tax
would put proposed >= current.

See [src/king/king_tax_raise.c](src/king/king_tax_raise.c) for the full
byte-trace.

---

## Market price update structure (`func_0305A8`)

The function loops 4 times outer (per-power?) and 4 times inner.
Reads/writes:
- `[BX + 0x53EA]` — 16-bit per-player base value (4 entries assumed)
- `[BX - 0x76FC]` (= `[BX + 0x8904]`) — DWORD table with stride 79 (×4)

This means there's a **DGROUP:0x8904 market table** with stride
~316 bytes per "row". The structure suggests:
- 4 powers × 4 states × per-commodity tracking
- Or 16 commodities × 79 bytes of price/volume history per power

The 87-byte detected boundary is too small — the function continues past.

```asm
@asm 0x0305AC..0x0305FF  visible portion (one full inner-loop iteration)
@asm 0x305FD  JL 0x305CE   ; loop back (4 iterations)
```

The full per-turn market update is the next decompile target. The
strong anchor: `[DGROUP:0x8904]` is the **market price-state table**.

---

## Sons of Liberty display (`func_03E844`)

This is the SHORT message-display function, NOT the SOL math. It checks
`[BP+6]` against `[0x5398]` and `[0x53D2]` (current player and "self"
player markers). If matching, sets a flag and dispatches REBELUP/
REBELUP50/REBELDOWN message.

The actual SOL percentage threshold logic lives in the function this
display function is CALLED FROM — chasing that requires finding the
near-call CALL sites at 0x3EA4C (per the disasm).

---

## DGROUP anchor table (refined)

| DGROUP address | Meaning | Confidence |
|----------------|---------|-----------|
| `0x18E` | terrain-display mode word | BYTE_VERIFIED via `func_006204` |
| `0x53A6` | current player idx OR difficulty | BYTE_VERIFIED via SMITEINDIANS + king tax |
| `0x538E` | turn counter (16-bit) | BYTE_VERIFIED via king tax raise formula |
| `0x5382` | game state flags (bit 0 = endgame/demo) | BYTE_VERIFIED via SMITE + SOL display |
| `0x5398` | "current human player" marker | BYTE_VERIFIED via SOL display |
| `0x53D2` | "self power" marker | BYTE_VERIFIED via SOL display |
| `0x53EA` | per-player base for market (4 words) | INFERRED via market function |
| `0x84FC` | far ptr to "king/payer record" | BYTE_VERIFIED via SMITE + king tax |
| `0x8542` | far ptr to current colony | BYTE_VERIFIED (anchor_map) |
| `0x880F + N*0x13C` | PowerRecord[N] attribute bitfield | BYTE_VERIFIED via power_attribute_bit |
| `0x8809 + N*0x13C` | PowerRecord[N] base | BYTE_VERIFIED |
| `0x8832 + N*0x13C` | PowerRecord[N].field_29 (treasury/score field) | BYTE_VERIFIED via SMITE + colony burn |
| `0x8904 + ...` | Market price-state table (stride 79*4) | INFERRED via PRICEUP function |
| `0x8CFC + N` | per-power active unit count | BYTE_VERIFIED via destroy_unit (`ovly_181F_0808`) |
| `0x9298 + N` | per-power something (mutated on colony capture) | BYTE_VERIFIED via colony burn |
| `0x940C + N` | per-power stockpile (mutated on colony capture) | BYTE_VERIFIED via colony burn |
| `0x941C + N*2` | per-power word table (used in SMITE factor) | INFERRED |
| `0x942C + N` | per-power byte table (used in SMITE factor) | INFERRED |
| `0x3146 + N*0x1C` | UnitRecord[N] base (CORRECTED — not 0x315E) | BYTE_VERIFIED |
| `0x540E + N*0x34` | AIPersonality[N] | BYTE_VERIFIED |
| `0x543F + N*0x34` | AIPersonality[N].byte_at_+0x31 (active flag) | BYTE_VERIFIED via diplomacy + colony burn |
| `0x84FC + ?` | King's record byte 1 = current tax rate (capped 75) | BYTE_VERIFIED via tea party |
| **`0x59D8 + N*78`** | **TRIBE_DATA[N]** (8 native tribes × 78 bytes) | **BYTE_VERIFIED via `get_per_power_byte` at file 0x7F34** |
| `0x8C7C + N*6` | per-power word table (read by ovly_181F_09A4 = `get_power_name_word`) | BYTE_VERIFIED |
| `0x8DC6` | global pointer used in `ovly_181F_09FC` forwarder | BYTE_VERIFIED |

---

## NEW: Universal per-power accessor (BYTE_VERIFIED)

`func_007F34` (= `LCALL 0x181F:0x0A38`) is `get_per_power_byte(power, offset)`:
- if `power < 4` (European/human): returns `PowerRecord[power].byte_at_+0x33 + offset`
  (base 0x883C = 0x8809 + 0x33)
- if `power >= 4` (native tribe 4..11): returns `TribeData[power - 4].byte_at_offset`
  (base 0x59D8, stride 78)

This is the SINGLE accessor that any game-system function uses to read
per-power state. Both struct sizes (PowerRecord=0x13C for EU, TribeData=78
for natives) and bases (0x8809 vs 0x59D8) are now BYTE_VERIFIED.

Implication: `tribe_data` table is FULLY LOCATABLE — DGROUP:0x59D8,
stride 78, 8 records (powers 4..11). The 78-byte tribe record contains
fields like aggression, treasure_pool, default_attitude etc. — ready
for byte-by-byte interpretation in a follow-up session.

---

## Next high-leverage targets

1. **Independence declaration** (`func_03DE46`) — when player declares
   independence, what changes in PowerRecord? Any threshold check?
2. **King recruit** function — when the king sends new REF units. This
   contains the REF growth rate.
3. **LCR (Lost City Rumor)** outcome dispatcher — find via "RUMOR" or
   "FOUNTAIN" string. The 11-outcome distribution is here.
4. **Founding Father effects** — find via FF name strings (CORTES,
   WASHINGTON, etc.) to map each FF to its effect-trigger code.
5. **Combat resolver** — find via PROMOTED / KILLED strings; expected
   to contain the RNG-driven combat formula.
