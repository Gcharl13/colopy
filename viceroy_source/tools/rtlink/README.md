# RTLink/Plus v2 overlay flattener

`flatten.py` statically recovers the overlay **segment-id → file-offset** map for
`re_work/VICEROY.EXE`, so overlay-only call targets (reached through the thunk
table) resolve to a concrete file offset **without a runtime memory dump**. This
is the tool the coverage notes referred to as the "missing RTLink V2 flattener".

## The problem

Inter-segment calls go through thunks in the table block at file
`0x1A5F0` (aliased as seg `0x181F` / `0x191F` / `0x1A1F`):

```
RESIDENT target (10 B):   9A <loader>   EA <off:u16> <seg:u16>     ; jmp far, resolves now
OVERLAY Type-B (12 B):    9A 91 0D 0D 11  EA <off:u16> 00 00  <segid:u16>
OVERLAY Type-A (14 B):    9A AB 0D 0D 11  EA <off:u16> 00 00  <segid:u16>  <extra:u16>
```

For overlay targets the `EA` segment is a **placeholder (0x0000)** patched at load
time, so the file location of the target cannot be read from the thunk alone — you
need to know which file region each `segid` occupies.

### Type-A vs Type-B loaders (CONFIRMED 2026-06-08)

Two loaders coexist (both at `0x110D`):
- **Type-B loader (0x0D91):** handles 10-byte (resident) and 12-byte (overlay) thunks.
  Field layout: `off@[6:8]`, `segid@[10:12]`.
- **Type-A loader (0x0DAB):** handles 14-byte overlay thunks.
  Field layout: **identical** — `off@[6:8]`, `segid@[10:12]`, plus a 2-byte `extra` field at `[12:14]`.

The `extra` field is a paragraph count added to the resolved runtime segment
when the overlay descriptor's bit 6 is set (confirmed by disassembling the
post-load patching code at `0x110D:0x1111`):
```asm
add  ax, word ptr es:[di+7]   ; di = EA byte offset -> [di+7] = thunk[12]
mov  word ptr es:[di+3], ax   ; patch the placeholder with runtime seg
```

**Type-A resolution formula:**
```
file_offset = base[segid] + extra * 16 + off
```

**CONFIRMED EXAMPLE — `raw_power_score` (func_039EE2):**
```
thunk at file 0x1B99A (alias 0x191F:0x3AA):
  off=0x0092, segid=5, extra=0x02B1
  base[5] = 0x037340
  0x037340 + 0x02B1*16 + 0x0092 = 0x039EE2  ← func_039EE2 confirmed function start
```

## The fingerprint

Overlay code already sits at fixed file offsets (`funcscan.py` finds 706 overlay
functions). Each overlay segment is a contiguous file region, and the thunk
**offsets** targeting a `segid` are its segment-relative call targets — most of
which are **function starts**. So for each `segid` we take its thunk-offset set
`{o_i}` from thunks with `extra=0` and pick the file base `F` that maximises
`|{F + o_i} ∩ function_starts|`.

Thunks with `extra≠0` target a different effective base (`base + extra*16`) and
are collected separately for per-thunk resolution.

```
file_offset(segid, off, extra=0) = base[segid] + extra*16 + off
```

## Validation (two independent checks)

- **Overlay fingerprint:** 23/31 segments resolve **STRONG** (≥50 % of thunk
  offsets hit exact function starts, and the base is dominant) — e.g. seg 23 =
  37/40, seg 13 = 26/27, seg 10 = 21/21. Coincidence is statistically excluded.
- **Resident-thunk control:** the `EA` real-seg thunks (which we can resolve
  directly) land on resident function starts **323/362 (89 %)** — an independent
  confirmation that the thunk model and `foff` translation are correct.

## Usage

```
cd viceroy_source/tools
python3 rtlink/flatten.py                    # print the map; writes re_work/overlay_segmap.json
python3 rtlink/flatten.py 5 0x92            # resolve overlay seg 5:0x92 (extra=0)
python3 rtlink/flatten.py 5 0x92 0x2b1      # resolve with explicit extra paragraph (Type-A)
```

## Caveats

- Low-thunk segments (`weak`/`AMBIG` in the table) are not reliable — they have too
  few offsets to pin a unique base; treat only `STRONG` rows as resolved.
- Thunks with `extra≠0` (Type-A) target a different effective base than the primary
  fingerprint base; use `resolve(exe, segmap, segid, off, extra)` or pass `extra` on
  the CLI.
- Needs `re_work/VICEROY.EXE` (gitignored) and `re_work/functions.json`
  (`funcscan.py`). Output `re_work/overlay_segmap.json` is regenerable.
