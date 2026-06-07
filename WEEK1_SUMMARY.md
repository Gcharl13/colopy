# Week 1 Disasm Sprint — Verified Findings

Generated 2026-05-03 at end of Week-1 work session.

## Tooling delivered (reusable)

- `tools/resolve_lcall.py` — resolves every `LCALL <seg>:<off>` in
  disasm to its thunk's file offset and overlay target. Annotates
  .asm files in place with `; THUNK -> ...` comments.
- `viceroy_source/lcall_resolution_VICEROY.json` — full resolution
  table (8,869 LCALL sites; 79.5% resolved).
- `viceroy_source/overlay_directory.json` — 34/82 overlay segments
  resolved to file offsets via empirical thunk-anchor matching.
- `viceroy_source/overlay_thunks_resolved.json` — 967/1020 thunks
  with candidate file_offset; 177 of those verified by landing on
  detected function entries.
- `viceroy_source/all_call_targets.json` — every CALL/LCALL target
  in disasm (841 distinct LCALL targets, 814 distinct near-CALL).

## Key code-decode breakthroughs

### LCALL → thunk file_offset formula

```
thunk_file_offset = 0x2400 + (lcall_seg << 4) + lcall_off
```

This formula resolves any `LCALL 0xSSSS:0xOOOO` in load-image code to
the corresponding thunk in the table at file `0x1A5F0..0x1D5E6`.
Verified by exact-match check on 7,048 LCALL sites.

### Dialog rect compute function (BYTE_VERIFIED)

`func_067DC8` at file `0x067DC8..0x067E09` (65 bytes) computes the
popup rect args from cursor position + char dimensions + font cell
dimensions, then calls overlay 0x0C36:0x000A as the setter. Full
line-by-line annotation in
`code/VICEROY/disasm/func_067DC8_unknown.asm`. Data-flow doc at
`docs/DIALOG_GEOMETRY.md`.

The compute formula:
- `rect_x = font_cell_width + char_width_cols - 8`
- `rect_y = font_cell_height + char_height_rows - 0x0F`
- plus `cursor_x` from `[0x174]`, `cursor_y` from `[0x176]`

### Char dimension writers identified

Writers of `[0x1EA4]` (char_width_cols) and `[0x1EA5]`
(char_height_rows) found at file offsets 0x0684CC, 0x0684D7,
0x0684F9, 0x0684FC, 0x068504, 0x068507. All in an undecoded
function in the gap between func_0681A8 and func_0685DC. Full
annotation pending Week-2 work.

### Render-chain functions located

| Function | File offset |
|----------|-------------|
| `screen_blit_helper` | 0x025902 |
| `load_PIK` | 0x02590C |
| `load_sprite_struct` | 0x025954 |
| `popup_finalizer` | 0x027954 |
| `random_int` (BYTE_VERIFIED) | 0x027DB2 |

## Statistics

| Metric | Value |
|--------|-------|
| VICEROY .asm files | 1,243 |
| Files with BYTE_VERIFIED header | 4 (was 3 before Week 1) |
| Files with `; THUNK ->` annotations | 432 |
| Total `; THUNK ->` annotation lines added | 7,048 |
| VICEROY ledger identified-line % | 3.99% (was 0.53%) |
| MAPEDIT ledger identified-line % | 0.00% (5 functions auto-promoted to BYTE_VERIFIED via sigmatch) |

## What did NOT meet plan targets

- Plan Week-1 target: ≥25% of lines annotated. Actual: 3.99%.
  The annotation was tooling-driven (LCALL pass) which captured
  only LCALL lines. Other identified instruction types (MOV, CMP,
  ADD, etc.) are still RAW. To hit 25% will require sigmatch
  signature library expansion (Borland C++ runtime helpers — only
  17 helpers indexed so far, need ~50–100) and bulk pattern
  classifiers (ENTER/LEAVE pairs, prologue/epilogue templates).

- Day-1 verification gate (every LCALL resolves to a file_offset):
  79.5% achieved. Remaining 20% are LCALLs to non-thunk targets
  (RTLink runtime entries, direct overlay-to-overlay calls).

- Day-5 verification gate (popup x/y/w/h byte-cited end-to-end):
  Compute traced (BYTE_VERIFIED). Setter (overlay 0x0C36:0x000A)
  unresolved due to single-thunk segment. Char-dim parser
  unresolved (writers found but enclosing function undecoded).

## Recommended Week-2 priorities

1. Extend `disasm_mz.py` prologue heuristics to detect the
   undetected functions (e.g. the one containing 0x0684CC writes).
2. Decode the actual RTLink directory format at file 0x20670 to
   resolve all 82 segments authoritatively.
3. Hand-annotate the 6 render-chain functions at the resolved
   offsets (load_PIK at 0x025900, etc.).
4. Build sigmatch corpus to cover Borland C++ 3.1/4.x stdlib
   functions — that pass alone should raise ledger-identified % by
   2-3x.
