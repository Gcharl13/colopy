# RTLink/Plus v2 overlay flattener

`flatten.py` statically recovers the overlay **segment-id → file-offset** map for
`re_work/VICEROY.EXE`, so overlay-only call targets (reached through the thunk
table) resolve to a concrete file offset **without a runtime memory dump**. This
is the tool the coverage notes referred to as the "missing RTLink V2 flattener".

## The problem

Inter-segment calls go through 10/12-byte thunks in the table block at file
`0x1A5F0` (aliased as seg `0x181F` / `0x191F` / `0x1A1F`):

```
RESIDENT target (10 B):   9A <loader>   EA <off:u16> <seg:u16>     ; jmp far, resolves now
OVERLAY  target (12 B):   9A <loader>   EA <off:u16> 00 00  <segid:u16>
```

For overlay targets the `EA` segment is a **placeholder (0x0000)** patched at load
time, so the file location of the target cannot be read from the thunk alone — you
need to know which file region each `segid` occupies.

## The fingerprint

Overlay code already sits at fixed file offsets (`funcscan.py` finds 706 overlay
functions). Each overlay segment is a contiguous file region, and the thunk
**offsets** targeting a `segid` are its segment-relative call targets — most of
which are **function starts**. So for each `segid` we take its thunk-offset set
`{o_i}` and pick the file base `F` that maximises `|{F + o_i} ∩ function_starts|`.
The winner is dominant and unambiguous wherever a segment has enough thunks.

```
file_offset(segid, off) = base[segid] + off
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
python3 rtlink/flatten.py            # print the map; writes re_work/overlay_segmap.json
python3 rtlink/flatten.py 5 0x92     # resolve overlay seg 5 : offset 0x92 (+ disasm)
```

## Caveats

- Low-thunk segments (`weak`/`AMBIG` in the table) are not reliable — they have too
  few offsets to pin a unique base; treat only `STRONG` rows as resolved.
- `0x181F`/`0x191F` use two loaders (`0x110D:0x0D91` "Type-B", `0x0DAB` "Type-A").
  Type-A fixup records occasionally point a few bytes into a routine (alternate
  entry); when a resolved offset lands mid-instruction, snap to the enclosing
  function start from `functions.json`.
- Needs `re_work/VICEROY.EXE` (gitignored) and `re_work/functions.json`
  (`funcscan.py`). Output `re_work/overlay_segmap.json` is regenerable.
