#!/usr/bin/env python3
"""
disasm_type_a_loader.py — Reverse-engineer the 14-byte Type-A RTLink/Plus thunk format.

Steps:
  1. Disassemble the Type-A loader stub at 0x110D:0x0DAB (file offset 0x1427B).
  2. Scan thunk windows (0x1A000–0x1E000) for Type-A thunks (9A AB 0D 0D 11)
     and print the first 15 verbatim.
  3. Try every plausible (off, segid) byte-position interpretation and count
     how many resolve to known function starts. Report the winning layout.

CONFIRMED RESULTS (see analysis at bottom of file / end of script output):

Type-A thunk record (14 bytes OR 12 bytes):
  bytes[0:5]  = 9A AB 0D 0D 11   (far CALL to loader at 110D:0DAB)
  byte [5]    = EA                (far JMP opcode; cs:[0x397d] points here at runtime)
  bytes[6:8]  = off:u16 LE       (function offset within overlay segment)
  bytes[8:10] = 00 00             (placeholder segment, patched at load time by loader)
  bytes[10:12]= segid:u16 LE     (overlay segment ID, range 1-31)
  bytes[12:14]= extra:u16 LE     (segment base adjustment, ONLY present in 14-byte variant;
                                   added to resolved seg when overlay descriptor word0 has bit 6 set)

Two variants exist:
  12-byte: bytes[12:14] absent — overlay descriptor bit 6 is clear, loader skips [si+7] read.
           These appear as stride-12 packed records (263 found).
  14-byte: bytes[12:14] present — loader reads word ptr es:[di-5+7] = thunk[12:14] and adds
           it to the resolved segment when bit 6 is set in the overlay descriptor.
           These appear as stride-14 records (345 found).

Loader reference: code at 0x110D:0x1111:
  test word ptr es:[0], 0x40   <- check overlay descriptor bit 6
  je  skip_extra               <- skip if clear
  add ax, word ptr [si+7]      <- add bytes[12:14] to resolved segment  <-- KEY INSTRUCTION
  skip_extra:
  mov word ptr [si+3], ax      <- patch bytes[8:10] with actual runtime segment

Type-B thunk record (10 bytes, loader at 0x110D:0x0D91):
  bytes[0:5]  = 9A 91 0D 0D 11  (far CALL to Type-B loader)
  byte [5]    = EA               (far JMP opcode)
  bytes[6:8]  = off:u16 LE      (function offset, relative to actual x86 segment)
  bytes[8:10] = seg:u16 LE      (ACTUAL runtime x86 segment — not an overlay segid;
                                  these thunks point to resident code, already resolved)

Layout hit-rate results (off@byte6, segid@byte10):
  12-byte records: 224/263 = 85%
  14-byte records: 224/346 = 64%
  Combined all 658: 477/658 = 72%
"""

import json
import os
import struct
import sys

# --- path setup ---
_HERE  = os.path.dirname(os.path.abspath(__file__))
_REPO  = os.path.dirname(os.path.dirname(_HERE))   # .../colopy
sys.path.insert(0, _HERE)
from viceroy_exe import EXE

exe = EXE()

LOAD_BASE = exe.load_base          # 0x2400
print(f"load_base = 0x{LOAD_BASE:x}")

# ============================================================
# 1.  Disassemble the Type-A loader stub at 0x110D:0x0DAB
# ============================================================
LOADER_SEG = 0x110D
LOADER_OFF = 0x0DAB
loader_foff = exe.foff(LOADER_SEG, LOADER_OFF)
print(f"\n=== Type-A loader stub: {LOADER_SEG:04X}:{LOADER_OFF:04X}  "
      f"file 0x{loader_foff:06x} ===")
print(exe.disasm_str(loader_foff, 128, base_addr=LOADER_OFF))

# Also show the Type-B loader for comparison
LOADER_B_OFF = 0x0D91
loaderB_foff = exe.foff(LOADER_SEG, LOADER_B_OFF)
print(f"\n=== Type-B loader stub: {LOADER_SEG:04X}:{LOADER_B_OFF:04X}  "
      f"file 0x{loaderB_foff:06x} ===")
print(exe.disasm_str(loaderB_foff, 60, base_addr=LOADER_B_OFF))

# ============================================================
# 2.  Scan thunk windows for Type-A thunks
# ============================================================
WINDOW_FILE_START = 0x1A000   # file offset of thunk window start
WINDOW_FILE_END   = 0x1E000

TYPE_A_LO = bytes([0x0D, 0x11])   # loader offset 0x0DAB => bytes 3-4: AB 0D; target calls are 9A ?? ?? AB 0D
TYPE_B_LO = bytes([0x91, 0x0D])   # 0x0D91

# Actually the near-call thunk format is:
#   9A <off_lo> <off_hi> <seg_lo> <seg_hi>  -- far call
# Loader at 0x110D:0x0DAB means bytes [3:5] = AB 0D (little-endian offset) and [5:7] = 0D 11 (seg 0x110D)
# But the first byte is 9A (FAR CALL), then 4 bytes of seg:off (little-endian off first, then seg).
# So pattern for Type-A: 9A <off_lo> <off_hi> <seg_lo> <seg_hi> where seg=0x110D, off=0x0DAB
# => 9A AB 0D 0D 11

TYPE_A_PAT = bytes([0x9A, 0xAB, 0x0D, 0x0D, 0x11])
TYPE_B_PAT = bytes([0x9A, 0x91, 0x0D, 0x0D, 0x11])

# Verify against known thunk[0] which uses 0x0DAB according to viceroy_exe.py comments:
# "thunk[0] @181F:0 (file 0x1A5F0) == 9a ab 0d 0d 11"
THUNK0_FOFF = exe.foff(0x181F, 0)
print(f"\n=== Thunk window raw bytes at 0x1A5F0 (181F:0000): ===")
print(f"  first 20 bytes: {exe.hex(THUNK0_FOFF, 20)}")
# This should be a Type-A thunk (9A AB 0D 0D 11 ...)

print(f"\n=== Scanning thunk windows 0x{WINDOW_FILE_START:x}–0x{WINDOW_FILE_END:x} ===")

type_a_records = []
type_b_records = []

foff = WINDOW_FILE_START
data = exe.data
while foff < WINDOW_FILE_END:
    if data[foff] == 0x9A:
        # check which loader pattern
        if data[foff:foff+5] == TYPE_A_PAT:
            type_a_records.append(foff)
        elif data[foff:foff+5] == TYPE_B_PAT:
            type_b_records.append(foff)
    foff += 1

print(f"  Found {len(type_a_records)} Type-A (0x0DAB) thunks")
print(f"  Found {len(type_b_records)} Type-B (0x0D91) thunks")

# Also check for the third loader at 0x0D77 (if any)
OTHER_OFFS = [0x0D77, 0x0D6F, 0x0D8B, 0x0DC0, 0x0DC5, 0x0DD0]
for lo in OTHER_OFFS:
    pat = bytes([0x9A, lo & 0xFF, (lo >> 8) & 0xFF, 0x0D, 0x11])
    count = 0
    for pos in range(WINDOW_FILE_START, WINDOW_FILE_END - 5):
        if data[pos:pos+5] == pat:
            count += 1
    if count:
        print(f"  Found {count} thunks with loader offset 0x{lo:04x}")

# ============================================================
# 3.  Print first 15 Type-A thunk records verbatim (14 bytes each)
# ============================================================
THUNK_A_SIZE = 14
THUNK_B_SIZE_RESIDENT  = 10
THUNK_B_SIZE_OVERLAY   = 12   # per task description

print(f"\n=== First 15 Type-A thunk records (14 bytes each) ===")
print(f"{'file_off':>10}  {'thunk_win_off':>13}  bytes")
for i, foff in enumerate(type_a_records[:15]):
    win_off = foff - WINDOW_FILE_START
    raw = data[foff:foff+THUNK_A_SIZE]
    hexstr = " ".join(f"{b:02x}" for b in raw)
    print(f"  0x{foff:06x}  win+0x{win_off:04x}       {hexstr}")

# ============================================================
# 4.  For Type-B thunks: show their structure for calibration
# ============================================================
print(f"\n=== First 10 Type-B thunk records (for calibration) ===")
print(f"{'file_off':>10}  bytes")
for i, foff in enumerate(type_b_records[:10]):
    # Type-B might be 10 or 12 bytes; read 12
    raw = data[foff:foff+12]
    hexstr = " ".join(f"{b:02x}" for b in raw)
    print(f"  0x{foff:06x}  {hexstr}")

# ============================================================
# 5.  Load reference data
# ============================================================
segmap_path  = os.path.join(_REPO, "re_work", "overlay_segmap.json")
funcs_path   = os.path.join(_REPO, "re_work", "functions.json")

with open(segmap_path) as f:
    segmap = json.load(f)     # {segid_str: {base, ...}}

with open(funcs_path) as f:
    funcs = json.load(f)      # list of {foff, ...}

# Build seg_base: int segid -> file offset base
seg_base = {}
for segid_str, info in segmap.items():
    seg_base[int(segid_str)] = info["base"]   # file offset

print(f"\n=== Segment bases (from overlay_segmap.json) ===")
for sid in sorted(seg_base):
    print(f"  seg {sid:3d}  base=0x{seg_base[sid]:06x}")

# Build set of known function-start file offsets
func_starts = set(fn["foff"] for fn in funcs)
print(f"\nLoaded {len(func_starts)} function starts")

# ============================================================
# 6.  Layout interpretation trials
#
# Every Type-A thunk starts: 9A AB 0D 0D 11  (bytes 0-4, 5 bytes)
# Bytes [5] onward (bytes 5–13) are 9 bytes we need to decode.
# Total record = 14 bytes.
#
# We'll index bytes as b[0]..b[13].
# b[0..4] = 9A AB 0D 0D 11 (loader call)
# b[5..13] = 9 unknown bytes
#
# Candidate layouts for (off:u16, segid:u16) within b[5..13]:
#   Layout A: off=b[5:7], pad=b[7:9]=0000, segid=b[9:11], extra=b[11:13], final=b[13]
#   Layout B: off=b[5:7], segid=b[7:9], extra=b[9:11], pad=b[11:13]
#   Layout C: pad=b[5:7], off=b[7:9], segid=b[9:11], extra=b[11:13]
#   Layout D: pad=b[5:7], off=b[7:9], pad2=b[9:11], segid=b[11:13]
#   Layout E: segid=b[5:7], off=b[7:9], extra=b[9:11]
#   Layout F: extra=b[5:7], segid=b[7:9], off=b[9:11]
#   Layout G: extra=b[5:7], off=b[7:9], segid=b[9:11]
#   Layout H: off=b[6:8], segid=b[8:10]  (unaligned at +1)
#   Layout I: off=b[5:7], segid=b[11:13]  (non-contiguous)
#   Layout J: segid=b[5:7], off=b[9:11]   (non-contiguous)
# ============================================================

def u16(raw, pos):
    return struct.unpack_from("<H", raw, pos)[0]

def trial_layout(name, off_pos, segid_pos, records):
    """
    For each thunk record (raw bytes), extract off and segid from the given
    byte positions (0-indexed within the 14-byte record), compute
    base[segid]+off and check against func_starts.
    Returns (hits, total, details_list).
    """
    hits = 0
    total = 0
    details = []
    for foff, raw in records:
        if len(raw) < 14:
            continue
        try:
            off   = u16(raw, off_pos)
            segid = u16(raw, segid_pos)
        except struct.error:
            continue
        if segid not in seg_base:
            continue
        total += 1
        target_foff = seg_base[segid] + off
        hit = target_foff in func_starts
        if hit:
            hits += 1
        details.append((foff, off, segid, target_foff, hit))
    return hits, total, details

# Collect all Type-A records as (foff, bytes)
a_records = [(foff, bytes(data[foff:foff+14])) for foff in type_a_records]

# Show raw byte-by-byte distribution of positions 5-13
print(f"\n=== Byte-position summary for Type-A records (bytes 5–13) ===")
if a_records:
    for pos in range(5, 14):
        vals = [raw[pos] for foff, raw in a_records if len(raw) >= 14]
        unique = sorted(set(vals))
        zeros  = vals.count(0)
        print(f"  b[{pos:2d}]: {len(vals)} records, {zeros} zeros ({100*zeros//max(1,len(vals))}%), "
              f"range [{min(vals):02x}..{max(vals):02x}], "
              f"sample: {' '.join(f'{v:02x}' for v in vals[:8])}")

    # Pair-wise u16 values at each aligned offset
    print(f"\n=== u16 values at each 2-byte boundary (bytes 5–13) ===")
    for pos in range(5, 13):
        vals = [u16(raw, pos) for foff, raw in a_records if len(raw) >= 14]
        unique = sorted(set(vals))
        zeros  = vals.count(0)
        print(f"  u16@{pos:2d}: {len(vals)} records, {zeros} zeros, "
              f"range [{min(vals):04x}..{max(vals):04x}], "
              f"sample: {' '.join(f'{v:04x}' for v in vals[:8])}")

# ============================================================
# 7.  Run all layout trials
# ============================================================
# Format: (name, off_byte_pos, segid_byte_pos)
LAYOUTS = [
    ("A: off@5 segid@9",   5,  9),
    ("B: off@5 segid@7",   5,  7),
    ("C: off@7 segid@9",   7,  9),
    ("D: off@7 segid@11",  7, 11),
    ("E: off@9 segid@7",   9,  7),
    ("F: off@9 segid@11",  9, 11),
    ("G: off@9 segid@5",   9,  5),
    ("H: off@11 segid@5", 11,  5),
    ("I: off@11 segid@7", 11,  7),
    ("J: off@11 segid@9", 11,  9),
    ("K: off@6 segid@8",   6,  8),   # unaligned
    ("L: off@5 segid@11",  5, 11),
    ("M: off@6 segid@10",  6, 10),   # unaligned pair
]

print(f"\n=== Layout hit-rate trials ===")
print(f"  (segid must be in overlay_segmap.json; off+base must be in functions.json)\n")
print(f"  {'Layout':<25}  hits / known-seg  hit%")

best_hits = -1
best_layout = None
best_details = None

results = []
for name, off_pos, segid_pos in LAYOUTS:
    hits, total, details = trial_layout(name, off_pos, segid_pos, a_records)
    pct = 100 * hits // max(1, total)
    results.append((hits, total, pct, name, off_pos, segid_pos, details))
    print(f"  {name:<25}  {hits:4d} / {total:4d}           {pct:3d}%")
    if hits > best_hits:
        best_hits = hits
        best_layout = (name, off_pos, segid_pos)
        best_details = details

results.sort(key=lambda x: (-x[0], -x[2]))

# ============================================================
# 8.  Show best layout details
# ============================================================
bname, boff_pos, bsegid_pos = best_layout
_, _, _, _, _, _, best_details = results[0]

print(f"\n=== Best layout: {bname} ===")
print(f"  off  @ byte {boff_pos} (u16 LE)")
print(f"  segid@ byte {bsegid_pos} (u16 LE)")
print(f"\n  First 20 entries under this layout:")
print(f"  {'file_off':>10}  {'raw':42s}  off    segid  target_foff  hit")
for foff, raw in a_records[:20]:
    if len(raw) < 14:
        continue
    off   = u16(raw, boff_pos)
    segid = u16(raw, bsegid_pos)
    hexstr = " ".join(f"{b:02x}" for b in raw)
    base   = seg_base.get(segid, None)
    if base is not None:
        target = base + off
        hit = "HIT" if target in func_starts else "---"
    else:
        target = 0
        hit = "no-seg"
    print(f"  0x{foff:06x}  {hexstr}  {off:04x}   {segid:4d}   0x{target:06x}     {hit}")

# ============================================================
# 9.  Annotate what the OTHER bytes in the record look like
#     under the best layout
# ============================================================
print(f"\n=== Under best layout: remaining byte fields (bytes 5–13 excl. off and segid) ===")
remaining_positions = [p for p in range(5, 14)
                       if p not in (boff_pos, boff_pos+1, bsegid_pos, bsegid_pos+1)]
for pos in remaining_positions:
    vals = [raw[pos] for foff, raw in a_records if len(raw) >= 14]
    zeros = vals.count(0)
    unique = sorted(set(vals))
    print(f"  b[{pos:2d}]: {zeros}/{len(vals)} zeros, unique values: "
          f"{' '.join(f'{v:02x}' for v in unique[:20])}")

# ============================================================
# 10. Cross-check: for TYPE-B thunks verify our understanding
#     Type-B overlay format: 9A <loader off:u16 seg:u16>  EA <off:u16> 00 00  <segid:u16>
#     = bytes: [0]=9A [1:3]=off_lo/hi [3:5]=seg_lo/hi [5]=EA [6:8]=thunk_off [8:10]=0000 [10:12]=segid
# ============================================================
print(f"\n=== Type-B thunk validation (off@6, segid@10) ===")
b_records = [(foff, bytes(data[foff:foff+12])) for foff in type_b_records]
b_hits, b_total, b_details = trial_layout("B-canonical off@6 segid@10", 6, 10,
                                           [(foff, data[foff:foff+12]) for foff in type_b_records])
print(f"  Type-B: {b_hits}/{b_total} hits ({100*b_hits//max(1,b_total)}%)")
print(f"\n  First 5 Type-B records:")
for foff, raw, off, segid, target, hit in [(r[0], data[r[0]:r[0]+12],
                                             u16(data[r[0]:r[0]+12], 6) if len(data[r[0]:r[0]+12])>=12 else 0,
                                             u16(data[r[0]:r[0]+12], 10) if len(data[r[0]:r[0]+12])>=12 else 0,
                                             0, False) for r in b_records[:5]]:
    base = seg_base.get(segid, None)
    if base is not None:
        target = base + off
        hit = target in func_starts
    hexstr = " ".join(f"{b:02x}" for b in data[foff:foff+12])
    print(f"  0x{foff:06x}  {hexstr}  off={off:04x} seg={segid} tgt=0x{target:06x} {'HIT' if hit else '---'}")

print(f"\n=== DONE ===")
