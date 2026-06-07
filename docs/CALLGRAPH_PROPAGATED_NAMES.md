# Callgraph-Propagated Function Names (auto-derived 2026-05-08)

This catalog lists VICEROY.EXE functions whose **role can be inferred**
from the function(s) they call. Each entry is a *suggestion* for
semantic naming — verify by hand-tracing before applying in Ghidra.

Total currently-named functions: **144**
Total unknown-name functions making ≥1 near-CALL: **381**

---

## Section A — Single-call wrappers (28 functions)

These functions make EXACTLY ONE near-CALL, all to a named target.
Likely role: argument-massaging wrapper or alternate-context invocation
of the named function. Suggested name: `<target_name>__wrapper_<offset>`.

| File offset | Size | Calls | Suggested name |
|------------:|-----:|-------|----------------|
| 0x003460 | 99 B | 0x003436 (terrain_id_normalize_to_8) | `terrain_id_normalize_to_8__wrapper_003460` |
| 0x0034C4 | 114 B | 0x003436 (terrain_id_normalize_to_8) | `terrain_id_normalize_to_8__wrapper_0034C4` |
| 0x003536 | 53 B | 0x003436 (terrain_id_normalize_to_8) | `terrain_id_normalize_to_8__wrapper_003536` |
| 0x0035EC | 53 B | 0x003436 (terrain_id_normalize_to_8) | `terrain_id_normalize_to_8__wrapper_0035EC` |
| 0x005F82 | 31 B | 0x005BFA (is_xy_in_map_bounds) | `is_xy_in_map_bounds__wrapper_005F82` |
| 0x00603A | 33 B | 0x005BFA (is_xy_in_map_bounds) | `is_xy_in_map_bounds__wrapper_00603A` |
| 0x0067F0 | 44 B | 0x006672 (unit_chain_resolve) | `unit_chain_resolve__wrapper_0067F0` |
| 0x006AAE | 103 B | 0x0066BA (unit_field_lookup_simple) | `unit_field_lookup_simple__wrapper_006AAE` |
| 0x0072E2 | 40 B | 0x0066BA (unit_field_lookup_simple) | `unit_field_lookup_simple__wrapper_0072E2` |
| 0x0073A8 | 99 B | 0x006672 (unit_chain_resolve) | `unit_chain_resolve__wrapper_0073A8` |
| 0x0079A0 | 119 B | 0x006CCA (unit_table_offset_calc) | `unit_table_offset_calc__wrapper_0079A0` |
| 0x007A20 | 83 B | 0x006CCA (unit_table_offset_calc) | `unit_table_offset_calc__wrapper_007A20` |
| 0x007A80 | 143 B | 0x006CCA (unit_table_offset_calc) | `unit_table_offset_calc__wrapper_007A80` |
| 0x007BCE | 25 B | 0x006CCA (unit_table_offset_calc) | `unit_table_offset_calc__wrapper_007BCE` |
| 0x00864E | 31 B | 0x00863E (wrapper_with_global_8DC6) | `wrapper_with_global_8DC6__wrapper_00864E` |
| 0x0086E4 | 34 B | 0x00863E (wrapper_with_global_8DC6) | `wrapper_with_global_8DC6__wrapper_0086E4` |
| 0x008806 | 63 B | 0x0087F4 (power_record_read_dword) | `power_record_read_dword__wrapper_008806` |
| 0x008862 | 25 B | 0x0087F4 (power_record_read_dword) | `power_record_read_dword__wrapper_008862` |
| 0x00887C | 21 B | 0x0087F4 (power_record_read_dword) | `power_record_read_dword__wrapper_00887C` |
| 0x0088D0 | 71 B | 0x008892 (find_pair_in_table_C8_DE) | `find_pair_in_table_C8_DE__wrapper_0088D0` |
| 0x008BD4 | 73 B | 0x008B96 (unit_field_test_at_3146) | `unit_field_test_at_3146__wrapper_008BD4` |
| 0x0097D6 | 28 B | 0x00863E (wrapper_with_global_8DC6) | `wrapper_with_global_8DC6__wrapper_0097D6` |
| 0x009876 | 62 B | 0x008D9C (lookup_table_2F4_signed) | `lookup_table_2F4_signed__wrapper_009876` |
| 0x0098F6 | 85 B | 0x008956 (lookup_byte_from_pair) | `lookup_byte_from_pair__wrapper_0098F6` |
| 0x00AB2E | 73 B | 0x008982 (update_and_render_tile_at) | `update_and_render_tile_at__wrapper_00AB2E` |
| 0x00AB95 | 78 B | 0x008D00 (step_100_or_level_scaled) | `step_100_or_level_scaled__wrapper_00AB95` |
| 0x044FA4 | 107 B | 0x044540 (clamp_byte_at_far_ptr_to_5) | `clamp_byte_at_far_ptr_to_5__wrapper_044FA4` |
| 0x0458EC | 87 B | 0x044540 (clamp_byte_at_far_ptr_to_5) | `clamp_byte_at_far_ptr_to_5__wrapper_0458EC` |

## Section B — Multi-call attributions (34 functions)

These functions call multiple named targets. Inferred role: dispatcher
or sequenced helper using the named subsystem(s).

| File offset | Size | Calls (named targets) | Inferred subsystem |
|------------:|-----:|----------------------|--------------------|
| 0x0029AC | 49 B | dispatch_overlay_op_62, dispatch_overlay_op_64 | overlay-dispatch |
| 0x002D28 | 75 B | call_overlay_with_80 | overlay-dispatch |
| 0x004D1E | 217 B | drain_keyboard_buffer |  |
| 0x005E90 | 64 B | is_xy_in_map_bounds | map / tile |
| 0x005F48 | 58 B | map_tile_read_layer_160 | map / tile |
| 0x006018 | 33 B | map_xy_bounds_or_neg1, map_xy_bounds_or_neg1_alt | map / tile |
| 0x0060A0 | 128 B | map_tile_read_layer_15C | map / tile |
| 0x00684C | 39 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x006874 | 53 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x006A10 | 108 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x006A7C | 50 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x006B46 | 71 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x006FD8 | 42 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x00701C | 48 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x0075A0 | 51 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x00768C | 161 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x0078F4 | 66 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x007936 | 48 B | unit_chain_resolve, unit_field_lookup_simple | unit-table |
| 0x008E84 | 120 B | dispatch_via_8e02_with_band, lookup_table_2F4_signed |  |
| 0x008FB4 | 138 B | pack_nibble_at_60, unpack_nibble_at_60 |  |
| 0x0091CC | 181 B | current_unit_field_at_20, current_unit_field_at_40 | unit-table |
| 0x009794 | 39 B | wrapper_with_global_8DC6 |  |
| 0x009818 | 66 B | unit_field_test_at_3146 | unit-table |
| 0x00994C | 40 B | update_and_render_tile_at | map / tile |
| 0x009FFC | 550 B | current_unit_field_at_20, current_unit_field_at_40, lookup_table_2F4_signed, ... | unit-table |
| 0x00A994 | 293 B | lookup_byte_from_pair |  |
| 0x00B42C | 139 B | unit_cargo_slot_kind_or_neg1, unit_cargo_slot_set_quantity, unit_table_3154_byte | unit-table |
| 0x00B550 | 88 B | unit_cargo_slot_kind_or_neg1, unit_table_3154_byte | unit-table |
| 0x00B704 | 41 B | lookup_table_2F4_signed, wrapper_with_global_8DC6 |  |
| 0x010B26 | 149 B | read |  |
| 0x021D32 | 320 B | BYTE_VERIFIED_at_020F50 |  |
| 0x024A48 | 183 B | BYTE_VERIFIED_at_020F50 |  |
| 0x044E7C | 230 B | clamp_byte_at_far_ptr_to_5 |  |
| 0x0681A8 | 165 B | BYTE_VERIFIED_at_067DC8 |  |

## Section C — Leaf / no-call helpers (size ≤ 30 bytes, 186 candidates)

Tiny functions with no near-CALLs (LCALL thunks may exist) — likely
arithmetic helpers, accessors, or no-op stubs. First 50 listed:

| File offset | Size |
|------------:|-----:|
| 0x00273E | 10 B |
| 0x002783 | 13 B |
| 0x003710 | 20 B |
| 0x004314 | 14 B |
| 0x0048CC | 13 B |
| 0x0048EA | 21 B |
| 0x004900 | 15 B |
| 0x00493C | 14 B |
| 0x004984 | 12 B |
| 0x0049B4 | 14 B |
| 0x0049FC | 20 B |
| 0x004B48 | 25 B |
| 0x0050F0 | 11 B |
| 0x0050FC | 11 B |
| 0x005296 | 22 B |
| 0x005418 | 30 B |
| 0x005CE6 | 24 B |
| 0x005D1A | 23 B |
| 0x005D84 | 23 B |
| 0x005D9C | 29 B |
| 0x005ED0 | 23 B |
| 0x005EE8 | 28 B |
| 0x00624E | 8 B |
| 0x0063B6 | 14 B |
| 0x00679E | 16 B |
| 0x00693A | 14 B |
| 0x0069D2 | 12 B |
| 0x006FC4 | 20 B |
| 0x007002 | 26 B |
| 0x00738E | 26 B |
| 0x0075D4 | 16 B |
| 0x0075E4 | 26 B |
| 0x0075FE | 17 B |
| 0x007F34 | 27 B |
| 0x007F62 | 30 B |
| 0x0080C8 | 14 B |
| 0x008110 | 14 B |
| 0x008158 | 14 B |
| 0x00817E | 14 B |
| 0x0081A4 | 28 B |
| 0x008262 | 20 B |
| 0x0082A0 | 18 B |
| 0x0084C8 | 19 B |
| 0x008508 | 9 B |
| 0x008524 | 18 B |
| 0x00860E | 15 B |
| 0x0086C0 | 19 B |
| 0x008BB2 | 20 B |
| 0x008BC6 | 13 B |
| 0x00975A | 25 B |

---

## Methodology

Generated by walking all `func_*_unknown.asm` files and parsing each
function's near-CALL targets (encoded as `CALL  0xNNNN ; CALL_NEAR`
in the disasm output). Cross-referenced against currently-named
functions (file naming convention `func_OFFSET_<name>.asm`).

**Caveat**: this is *callgraph propagation*, not byte-trace. Each
suggested name is a *hint* based on what the function calls, not a
byte-level proof of the function's purpose. Apply in Ghidra only
after spot-checking a few entries with hand-decode.