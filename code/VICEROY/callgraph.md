# VICEROY.EXE — Call graph

Direct CALL/LCALL relationships, recovered from capstone-decoded operands. Calls whose target lands inside a discovered function are captured; calls into orphan bytes are tallied separately as `unknown_targets`.

## Most-called functions (high in-degree = popular utilities)

| Function | Callers | Callees | Status | Purpose |
|----------|--------:|--------:|--------|---------|
| 0x01A5F0 `rtlink_overlay_thunk_table` | 431 | 2 | MANUAL |  |
| 0x00FDB4 `strcpy_near` | 38 | 0 | MANUAL |  |
| 0x00FD74 `strcat_near` | 34 | 0 | MANUAL |  |
| 0x005BFA `is_xy_in_map_bounds` | 24 | 0 | MANUAL |  |
| 0x0066BA `unit_field_lookup_simple` | 18 | 0 | MANUAL |  |
| 0x01074E `strcpy_far` | 17 | 0 | MANUAL |  |
| 0x010784 `strcat_far` | 16 | 0 | MANUAL |  |
| 0x006672 `unit_chain_resolve` | 15 | 0 | MANUAL |  |
| 0x00E4C6 `read_far_dword_via_267A` | 14 | 0 | MANUAL |  |
| 0x00FECA `itoa_radix_dispatch` | 12 | 0 | MANUAL |  |
| 0x00F9C4 `fclose_or_remove` | 11 | 7 | MANUAL |  |
| 0x010226 `strchr_near` | 10 | 0 | MANUAL |  |
| 0x00863E `wrapper_with_global_8DC6` | 9 | 1 | MANUAL |  |
| 0x00FAAA `printf_to_str` | 9 | 1 | MANUAL |  |
| 0x00FE12 `strlen_near` | 9 | 0 | MANUAL |  |
| 0x01037E `memset_near` | 8 | 0 | MANUAL |  |
| 0x010E66 `unknown` | 7 | 2 | RAW |  |
| 0x005F04 `map_xy_bounds_or_neg1` | 7 | 1 | MANUAL |  |
| 0x00FAF8 `unknown` | 7 | 1 | RAW |  |
| 0x005CFE `map_tile_read_layer_15C` | 7 | 0 | MANUAL |  |
| 0x00E51C `unknown` | 7 | 0 | RAW |  |
| 0x00E68A `set_global_269E_byte_pair` | 7 | 0 | MANUAL |  |
| 0x010496 `unknown` | 7 | 0 | RAW |  |
| 0x0066CC `unknown` | 6 | 2 | RAW |  |
| 0x00DDEA `unknown` | 6 | 2 | RAW |  |
| 0x005FD4 `map_xy_bounds_or_neg1_alt` | 6 | 1 | MANUAL |  |
| 0x0090C8 `current_unit_field_at_20` | 6 | 0 | MANUAL |  |
| 0x009102 `current_unit_field_at_40` | 6 | 0 | MANUAL |  |
| 0x00BC10 `is_arg2_negative` | 6 | 0 | MANUAL |  |
| 0x0106BA `strrchr_far` | 6 | 0 | MANUAL |  |
| 0x005E90 `unknown` | 5 | 3 | RAW |  |
| 0x0062B4 `is_tile_walkable_or_special` | 5 | 1 | MANUAL |  |
| 0x005D32 `map_tile_read_layer_160` | 5 | 0 | MANUAL |  |
| 0x00E6A6 `unknown` | 5 | 0 | RAW |  |
| 0x00E76A `unknown` | 5 | 0 | RAW |  |
| 0x01070C `strlen_far` | 5 | 0 | MANUAL |  |
| 0x002544 `unknown` | 4 | 1 | RAW |  |
| 0x00260E `format_to_buffer_2D54` | 4 | 1 | MANUAL |  |
| 0x008956 `lookup_byte_from_pair` | 4 | 1 | MANUAL |  |
| 0x00BF3C `unknown` | 4 | 1 | RAW |  |
| 0x003436 `terrain_id_normalize_to_8` | 4 | 0 | MANUAL |  |
| 0x0069D2 `unknown` | 4 | 0 | RAW |  |
| 0x006CCA `unit_table_offset_calc` | 4 | 0 | MANUAL |  |
| 0x0087F4 `power_record_read_dword` | 4 | 0 | MANUAL |  |
| 0x008892 `find_pair_in_table_C8_DE` | 4 | 0 | MANUAL |  |
| 0x008B96 `unit_field_test_at_3146` | 4 | 0 | MANUAL |  |
| 0x008D9C `lookup_table_2F4_signed` | 4 | 0 | MANUAL |  |
| 0x00D272 `kbhit` | 4 | 0 | MANUAL |  |
| 0x010582 `unknown` | 4 | 0 | RAW |  |
| 0x0106E8 `unknown` | 4 | 0 | RAW |  |

## Most-calling functions (high out-degree = orchestrators)

| Function | Callees | Callers | Status | Purpose |
|----------|--------:|--------:|--------|---------|
| 0x009318 `unknown` | 17 | 2 | RAW |  |
| 0x009B9C `unknown` | 12 | 1 | RAW |  |
| 0x008982 `unknown` | 10 | 2 | RAW |  |
| 0x00A994 `unknown` | 10 | 0 | RAW |  |
| 0x004B72 `unknown` | 8 | 1 | RAW |  |
| 0x004D1E `unknown` | 8 | 0 | RAW |  |
| 0x007D3E `unknown` | 8 | 0 | RAW |  |
| 0x009FFC `unknown` | 8 | 1 | RAW |  |
| 0x00A3E1 `unknown` | 8 | 0 | RAW |  |
| 0x011F6E `load_game_state` | 8 | 1 | MANUAL |  |
| 0x076642 `unknown` | 8 | 0 | RAW |  |
| 0x00F9C4 `fclose_or_remove` | 7 | 11 | MANUAL |  |
| 0x012102 `unknown` | 7 | 1 | RAW |  |
| 0x00768C `unknown` | 6 | 1 | RAW |  |
| 0x00E2B0 `unknown` | 6 | 0 | RAW |  |
| 0x03ADA6 `unknown` | 6 | 0 | RAW |  |
| 0x06E2DE `unknown` | 6 | 0 | RAW |  |
| 0x06E3D0 `unknown` | 6 | 0 | RAW |  |
| 0x070EBA `unknown` | 6 | 0 | RAW |  |
| 0x076E50 `unknown` | 6 | 0 | RAW |  |
| 0x002E4E `unknown` | 5 | 2 | RAW |  |
| 0x00543C `unknown` | 5 | 0 | RAW |  |
| 0x00772E `unknown` | 5 | 2 | RAW |  |
| 0x00A222 `unknown` | 5 | 0 | RAW |  |
| 0x00E1D2 `unknown` | 5 | 0 | RAW |  |
| 0x00F72D `cstart` | 5 | 0 | MANUAL |  |
| 0x011B56 `unknown` | 5 | 1 | RAW |  |
| 0x030F76 `unknown` | 5 | 0 | RAW |  |
| 0x031BE6 `unknown` | 5 | 1 | RAW |  |
| 0x05C878 `unknown` | 5 | 0 | RAW |  |

## Detail for named functions

### 0x00260E `format_to_buffer_2D54`

- Status: `MANUAL`
- Callers (4):
    - 0x002632 `unknown` (RAW)
    - 0x002648 `unknown` (RAW)
    - 0x002668 `unknown` (RAW)
    - 0x00268C `unknown` (RAW)
- Callees (1):
    - 0x010784 `strcat_far` (MANUAL)

### 0x0028B0 `call_overlay_with_80`

- Status: `MANUAL`
- Callers (3):
    - 0x0028C0 `unknown` (RAW)
    - 0x002D28 `unknown` (RAW)
    - 0x008074 `unknown` (RAW)
- Callees (1):
    - 0x00FD74 `strcat_near` (MANUAL)

### 0x003436 `terrain_id_normalize_to_8`

- Status: `MANUAL`
- Callers (4):
    - 0x003460 `unknown` (RAW)
    - 0x0034C4 `unknown` (RAW)
    - 0x003536 `unknown` (RAW)
    - 0x0035EC `unknown` (RAW)
- Callees: none

### 0x004A5C `wait_for_keypress`

- Status: `MANUAL`
- Callers: none
- Callees (3):
    - 0x004EE6 `unknown` (RAW)
    - 0x00D272 `kbhit` (MANUAL)
    - 0x00D286 `getch` (MANUAL)

### 0x004AFA `drain_keyboard_buffer`

- Status: `MANUAL`
- Callers (2):
    - 0x0024C6 `unknown` (RAW)
    - 0x004D1E `unknown` (RAW)
- Callees (2):
    - 0x00D272 `kbhit` (MANUAL)
    - 0x00D286 `getch` (MANUAL)

### 0x005BFA `is_xy_in_map_bounds`

- Status: `MANUAL`
- Callers (24):
    - 0x005E90 `unknown` (RAW)
    - 0x005F04 `map_xy_bounds_or_neg1` (MANUAL)
    - 0x005F82 `unknown` (RAW)
    - 0x005FD4 `map_xy_bounds_or_neg1_alt` (MANUAL)
    - 0x00603A `unknown` (RAW)
    - 0x00627A `unknown` (RAW)
    - 0x0063D5 `unknown` (RAW)
    - 0x006468 `unknown` (RAW)
    - 0x0066CC `unknown` (RAW)
    - 0x0068AA `unknown` (RAW)
    - 0x00726E `unknown` (RAW)
    - 0x0079A0 `unknown` (RAW)
    - 0x007A80 `unknown` (RAW)
    - 0x008352 `unknown` (RAW)
    - 0x008770 `unknown` (RAW)
    - 0x008D26 `unknown` (RAW)
    - 0x0099AE `unknown` (RAW)
    - 0x009A32 `unknown` (RAW)
    - 0x00A6A2 `unknown` (RAW)
    - 0x00A994 `unknown` (RAW)
    - 0x00BD28 `unknown` (RAW)
    - 0x00BD4A `unknown` (RAW)
    - 0x00BEDE `unknown` (RAW)
    - 0x00C00A `unknown` (RAW)
- Callees: none

### 0x005CFE `map_tile_read_layer_15C`

- Status: `MANUAL`
- Callers (7):
    - 0x0060A0 `unknown` (RAW)
    - 0x00627A `unknown` (RAW)
    - 0x0062B4 `is_tile_walkable_or_special` (MANUAL)
    - 0x0062E2 `unknown` (RAW)
    - 0x0099AE `unknown` (RAW)
    - 0x009B9C `unknown` (RAW)
    - 0x00A222 `unknown` (RAW)
- Callees: none

### 0x005D32 `map_tile_read_layer_160`

- Status: `MANUAL`
- Callers (5):
    - 0x005F48 `unknown` (RAW)
    - 0x0088D0 `unknown` (RAW)
    - 0x009A32 `unknown` (RAW)
    - 0x009B9C `unknown` (RAW)
    - 0x00A222 `unknown` (RAW)
- Callees: none

### 0x005F04 `map_xy_bounds_or_neg1`

- Status: `MANUAL`
- Callers (7):
    - 0x006018 `unknown` (RAW)
    - 0x0066CC `unknown` (RAW)
    - 0x00704C `unknown` (RAW)
    - 0x007120 `unknown` (RAW)
    - 0x007178 `unknown` (RAW)
    - 0x00726E `unknown` (RAW)
    - 0x008982 `unknown` (RAW)
- Callees (1):
    - 0x005BFA `is_xy_in_map_bounds` (MANUAL)

### 0x005FD4 `map_xy_bounds_or_neg1_alt`

- Status: `MANUAL`
- Callers (6):
    - 0x006018 `unknown` (RAW)
    - 0x00704C `unknown` (RAW)
    - 0x007178 `unknown` (RAW)
    - 0x00723E `unknown` (RAW)
    - 0x00772E `unknown` (RAW)
    - 0x008982 `unknown` (RAW)
- Callees (1):
    - 0x005BFA `is_xy_in_map_bounds` (MANUAL)

### 0x0062B4 `is_tile_walkable_or_special`

- Status: `MANUAL`
- Callers (5):
    - 0x005E90 `unknown` (RAW)
    - 0x00704C `unknown` (RAW)
    - 0x007178 `unknown` (RAW)
    - 0x008352 `unknown` (RAW)
    - 0x00A994 `unknown` (RAW)
- Callees (1):
    - 0x005CFE `map_tile_read_layer_15C` (MANUAL)

### 0x006672 `unit_chain_resolve`

- Status: `MANUAL`
- Callers (15):
    - 0x0037BE `unknown` (RAW)
    - 0x00386A `unknown` (RAW)
    - 0x0067F0 `unknown` (RAW)
    - 0x00684C `unknown` (RAW)
    - 0x006874 `unknown` (RAW)
    - 0x006A10 `unknown` (RAW)
    - 0x006A7C `unknown` (RAW)
    - 0x006B46 `unknown` (RAW)
    - 0x006FD8 `unknown` (RAW)
    - 0x00701C `unknown` (RAW)
    - 0x0073A8 `unknown` (RAW)
    - 0x0075A0 `unknown` (RAW)
    - 0x00768C `unknown` (RAW)
    - 0x0078F4 `unknown` (RAW)
    - 0x007936 `unknown` (RAW)
- Callees: none

### 0x0066BA `unit_field_lookup_simple`

- Status: `MANUAL`
- Callers (18):
    - 0x0037BE `unknown` (RAW)
    - 0x00386A `unknown` (RAW)
    - 0x00684C `unknown` (RAW)
    - 0x006874 `unknown` (RAW)
    - 0x006A10 `unknown` (RAW)
    - 0x006A7C `unknown` (RAW)
    - 0x006AAE `unknown` (RAW)
    - 0x006B46 `unknown` (RAW)
    - 0x006FD8 `unknown` (RAW)
    - 0x00701C `unknown` (RAW)
    - 0x0072E2 `unknown` (RAW)
    - 0x0075A0 `unknown` (RAW)
    - 0x00768C `unknown` (RAW)
    - 0x0078F4 `unknown` (RAW)
    - 0x007936 `unknown` (RAW)
    - 0x008BD4 `unknown` (RAW)
    - 0x008C1E `unknown` (RAW)
    - 0x009818 `unknown` (RAW)
- Callees: none

### 0x006CCA `unit_table_offset_calc`

- Status: `MANUAL`
- Callers (4):
    - 0x0079A0 `unknown` (RAW)
    - 0x007A20 `unknown` (RAW)
    - 0x007A80 `unknown` (RAW)
    - 0x007BCE `unknown` (RAW)
- Callees: none

### 0x0085B2 `test_bit_at_8a`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x0085D6 `set_or_clear_bit_at_8a`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x00863E `wrapper_with_global_8DC6`

- Status: `MANUAL`
- Callers (9):
    - 0x007BE8 `unknown` (RAW)
    - 0x00864E `unknown` (RAW)
    - 0x0086E4 `unknown` (RAW)
    - 0x009794 `unknown` (RAW)
    - 0x0097D6 `unknown` (RAW)
    - 0x009B9C `unknown` (RAW)
    - 0x009FFC `unknown` (RAW)
    - 0x00A3E1 `unknown` (RAW)
    - 0x00B704 `unknown` (RAW)
- Callees (1):
    - 0x00860E `unknown` (RAW)

### 0x0087F4 `power_record_read_dword`

- Status: `MANUAL`
- Callers (4):
    - 0x008806 `unknown` (RAW)
    - 0x008862 `unknown` (RAW)
    - 0x00887C `unknown` (RAW)
    - 0x008982 `unknown` (RAW)
- Callees: none

### 0x008892 `find_pair_in_table_C8_DE`

- Status: `MANUAL`
- Callers (4):
    - 0x0088D0 `unknown` (RAW)
    - 0x008918 `blit_at_origin_if_pair_visible` (MANUAL)
    - 0x008956 `lookup_byte_from_pair` (MANUAL)
    - 0x008982 `unknown` (RAW)
- Callees: none

### 0x008918 `blit_at_origin_if_pair_visible`

- Status: `MANUAL`
- Callers (1):
    - 0x008982 `unknown` (RAW)
- Callees (2):
    - 0x005D4E `unknown` (RAW)
    - 0x008892 `find_pair_in_table_C8_DE` (MANUAL)

### 0x008956 `lookup_byte_from_pair`

- Status: `MANUAL`
- Callers (4):
    - 0x0098F6 `unknown` (RAW)
    - 0x009B9C `unknown` (RAW)
    - 0x00A3E1 `unknown` (RAW)
    - 0x00A994 `unknown` (RAW)
- Callees (1):
    - 0x008892 `find_pair_in_table_C8_DE` (MANUAL)

### 0x008B96 `unit_field_test_at_3146`

- Status: `MANUAL`
- Callers (4):
    - 0x008BD4 `unknown` (RAW)
    - 0x008C1E `unknown` (RAW)
    - 0x008C70 `unknown` (RAW)
    - 0x009818 `unknown` (RAW)
- Callees: none

### 0x008D00 `step_100_or_level_scaled`

- Status: `MANUAL`
- Callers (2):
    - 0x00A3E1 `unknown` (RAW)
    - 0x00AB95 `unknown` (RAW)
- Callees: none

### 0x008D9C `lookup_table_2F4_signed`

- Status: `MANUAL`
- Callers (4):
    - 0x008E84 `unknown` (RAW)
    - 0x009876 `unknown` (RAW)
    - 0x009FFC `unknown` (RAW)
    - 0x00B704 `unknown` (RAW)
- Callees: none

### 0x008E02 `set_commodity_band_at_index`

- Status: `MANUAL`
- Callers (1):
    - 0x008E46 `dispatch_via_8e02_with_band` (MANUAL)
- Callees: none

### 0x008E46 `dispatch_via_8e02_with_band`

- Status: `MANUAL`
- Callers (2):
    - 0x008E84 `unknown` (RAW)
    - 0x00A3E1 `unknown` (RAW)
- Callees (1):
    - 0x008E02 `set_commodity_band_at_index` (MANUAL)

### 0x008F02 `check_total_exceeds_threshold`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x008F2A `unpack_nibble_at_60`

- Status: `MANUAL`
- Callers (2):
    - 0x008FB4 `unknown` (RAW)
    - 0x009184 `nibble_to_4_tier_quantity` (MANUAL)
- Callees: none

### 0x008F6C `pack_nibble_at_60`

- Status: `MANUAL`
- Callers (2):
    - 0x008FB4 `unknown` (RAW)
    - 0x009318 `unknown` (RAW)
- Callees: none

### 0x0090C8 `current_unit_field_at_20`

- Status: `MANUAL`
- Callers (6):
    - 0x0091CC `unknown` (RAW)
    - 0x009318 `unknown` (RAW)
    - 0x009626 `unknown` (RAW)
    - 0x009692 `unknown` (RAW)
    - 0x009FFC `unknown` (RAW)
    - 0x00B150 `unknown` (RAW)
- Callees: none

### 0x009102 `current_unit_field_at_40`

- Status: `MANUAL`
- Callers (6):
    - 0x0091CC `unknown` (RAW)
    - 0x009318 `unknown` (RAW)
    - 0x00965C `unknown` (RAW)
    - 0x009692 `unknown` (RAW)
    - 0x009B9C `unknown` (RAW)
    - 0x009FFC `unknown` (RAW)
- Callees: none

### 0x00913C `set_field_at_40_or_unit_byte`

- Status: `MANUAL`
- Callers (1):
    - 0x009318 `unknown` (RAW)
- Callees (1):
    - 0x008BD4 `unknown` (RAW)

### 0x009184 `nibble_to_4_tier_quantity`

- Status: `MANUAL`
- Callers: none
- Callees (1):
    - 0x008F2A `unpack_nibble_at_60` (MANUAL)

### 0x00929A `classify_pair_bounds`

- Status: `MANUAL`
- Callers (1):
    - 0x009318 `unknown` (RAW)
- Callees: none

### 0x00B2F0 `unit_table_3154_byte`

- Status: `MANUAL`
- Callers (3):
    - 0x00B368 `unknown` (RAW)
    - 0x00B42C `unknown` (RAW)
    - 0x00B550 `unknown` (RAW)
- Callees: none

### 0x00BC10 `is_arg2_negative`

- Status: `MANUAL`
- Callers (6):
    - 0x006608 `unknown` (RAW)
    - 0x009318 `unknown` (RAW)
    - 0x009B9C `unknown` (RAW)
    - 0x009FFC `unknown` (RAW)
    - 0x00A3E1 `unknown` (RAW)
    - 0x00A994 `unknown` (RAW)
- Callees: none

### 0x00D272 `kbhit`

- Status: `MANUAL`
- Callers (4):
    - 0x0024C6 `unknown` (RAW)
    - 0x004A5C `wait_for_keypress` (MANUAL)
    - 0x004AFA `drain_keyboard_buffer` (MANUAL)
    - 0x004D1E `unknown` (RAW)
- Callees: none

### 0x00D286 `getch`

- Status: `MANUAL`
- Callers (3):
    - 0x004A5C `wait_for_keypress` (MANUAL)
    - 0x004AFA `drain_keyboard_buffer` (MANUAL)
    - 0x004D1E `unknown` (RAW)
- Callees: none

### 0x00E454 `normalize_far_pointer`

- Status: `MANUAL`
- Callers (3):
    - 0x00DDEA `unknown` (RAW)
    - 0x00DEA6 `unknown` (RAW)
    - 0x00E146 `unknown` (RAW)
- Callees: none

### 0x00E4C6 `read_far_dword_via_267A`

- Status: `MANUAL`
- Callers (14):
    - 0x0024C6 `unknown` (RAW)
    - 0x0026D4 `unknown` (RAW)
    - 0x004A80 `unknown` (RAW)
    - 0x004D1E `unknown` (RAW)
    - 0x00C4A4 `unknown` (RAW)
    - 0x00C51A `unknown` (RAW)
    - 0x00D106 `unknown` (RAW)
    - 0x00D1CA `unknown` (RAW)
    - 0x024342 `unknown` (RAW)
    - 0x0246E2 `unknown` (RAW)
    - 0x024A48 `unknown` (RAW)
    - 0x02C5D4 `unknown` (RAW)
    - 0x035B06 `unknown` (RAW)
    - 0x06BE92 `unknown` (RAW)
- Callees: none

### 0x00E68A `set_global_269E_byte_pair`

- Status: `MANUAL`
- Callers (7):
    - 0x002AFE `unknown` (RAW)
    - 0x002B38 `unknown` (RAW)
    - 0x002B72 `unknown` (RAW)
    - 0x002C0C `unknown` (RAW)
    - 0x002C4A `unknown` (RAW)
    - 0x002C82 `unknown` (RAW)
    - 0x002E4E `unknown` (RAW)
- Callees: none

### 0x00F720 `dos_version_check_stub`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x00F72D `cstart`

- Status: `MANUAL`
- Callers: none
- Callees (5):
    - 0x00F8DD `exit` (MANUAL)
    - 0x010812 `unknown` (RAW)
    - 0x0109F0 `unknown` (RAW)
    - 0x010A99 `unknown` (RAW)
    - 0x01A5F0 `rtlink_overlay_thunk_table` (MANUAL)

### 0x00F8DD `exit`

- Status: `MANUAL`
- Callers (2):
    - 0x004D1E `unknown` (RAW)
    - 0x00F72D `cstart` (MANUAL)
- Callees: none

### 0x00F8E4 `exit_abort`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x00F9C4 `fclose_or_remove`

- Status: `MANUAL`
- Callers (11):
    - 0x00E1D2 `unknown` (RAW)
    - 0x00E2B0 `unknown` (RAW)
    - 0x03ADA6 `unknown` (RAW)
    - 0x070DE8 `unknown` (RAW)
    - 0x071106 `unknown` (RAW)
    - 0x071246 `unknown` (RAW)
    - 0x0713D4 `unknown` (RAW)
    - 0x07706C `unknown` (RAW)
    - 0x078184 `unknown` (RAW)
    - 0x0781DE `unknown` (RAW)
    - 0x0783E4 `unknown` (RAW)
- Callees (7):
    - 0x00FD74 `strcat_near` (MANUAL)
    - 0x00FDB4 `strcpy_near` (MANUAL)
    - 0x00FECA `itoa_radix_dispatch` (MANUAL)
    - 0x01041A `unlink` (MANUAL)
    - 0x010CA0 `unknown` (RAW)
    - 0x010E66 `unknown` (RAW)
    - 0x01144A `_close` (MANUAL)

### 0x00FAAA `printf_to_str`

- Status: `MANUAL`
- Callers (9):
    - 0x00C45A `unknown` (RAW)
    - 0x00E1D2 `unknown` (RAW)
    - 0x00E2B0 `unknown` (RAW)
    - 0x03ADA6 `unknown` (RAW)
    - 0x070DE8 `unknown` (RAW)
    - 0x0734F8 `unknown` (RAW)
    - 0x073AB0 `unknown` (RAW)
    - 0x073BB0 `unknown` (RAW)
    - 0x078184 `unknown` (RAW)
- Callees (1):
    - 0x00FA7E `unknown` (RAW)

### 0x00FD20 `putchar`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x00FD4E `getchar`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x00FD74 `strcat_near`

- Status: `MANUAL`
- Callers (34):
    - 0x0028B0 `call_overlay_with_80` (MANUAL)
    - 0x0028E2 `unknown` (RAW)
    - 0x0028F2 `unknown` (RAW)
    - 0x002902 `unknown` (RAW)
    - 0x002912 `unknown` (RAW)
    - 0x002922 `unknown` (RAW)
    - 0x002932 `unknown` (RAW)
    - 0x002942 `unknown` (RAW)
    - 0x002952 `unknown` (RAW)
    - 0x002962 `unknown` (RAW)
    - 0x002972 `unknown` (RAW)
    - 0x002982 `unknown` (RAW)
    - 0x004B72 `unknown` (RAW)
    - 0x00566E `unknown` (RAW)
    - 0x0056F2 `unknown` (RAW)
    - 0x00D8E4 `unknown` (RAW)
    - 0x00F9C4 `fclose_or_remove` (MANUAL)
    - 0x011B56 `unknown` (RAW)
    - 0x030F76 `unknown` (RAW)
    - 0x0317CC `unknown` (RAW)
    - 0x03471E `unknown` (RAW)
    - 0x039EE2 `unknown` (RAW)
    - 0x03ADA6 `unknown` (RAW)
    - 0x03BAA6 `unknown` (RAW)
    - 0x057A3A `unknown` (RAW)
    - 0x05C878 `unknown` (RAW)
    - 0x06927C `unknown` (RAW)
    - 0x069D8C `unknown` (RAW)
    - 0x06B722 `unknown` (RAW)
    - 0x06EEEC `unknown` (RAW)
    - … (+4 more)
- Callees: none

### 0x00FDB4 `strcpy_near`

- Status: `MANUAL`
- Callers (38):
    - 0x004B72 `unknown` (RAW)
    - 0x00566E `unknown` (RAW)
    - 0x0056F2 `unknown` (RAW)
    - 0x00E1D2 `unknown` (RAW)
    - 0x00E2B0 `unknown` (RAW)
    - 0x00F9C4 `fclose_or_remove` (MANUAL)
    - 0x012102 `unknown` (RAW)
    - 0x01225E `unknown` (RAW)
    - 0x031BE6 `unknown` (RAW)
    - 0x037340 `unknown` (RAW)
    - 0x03B2F8 `unknown` (RAW)
    - 0x03BAA6 `unknown` (RAW)
    - 0x03DA2A `unknown` (RAW)
    - 0x0404B0 `unknown` (RAW)
    - 0x040C1E `unknown` (RAW)
    - 0x057A3A `unknown` (RAW)
    - 0x05C878 `unknown` (RAW)
    - 0x067700 `unknown` (RAW)
    - 0x0694AE `unknown` (RAW)
    - 0x06AF1C `unknown` (RAW)
    - 0x06B722 `unknown` (RAW)
    - 0x06BE92 `unknown` (RAW)
    - 0x06BF12 `unknown` (RAW)
    - 0x06BF3C `unknown` (RAW)
    - 0x06C2D6 `unknown` (RAW)
    - 0x06F0F4 `unknown` (RAW)
    - 0x06F8FA `unknown` (RAW)
    - 0x070EBA `unknown` (RAW)
    - 0x072C78 `unknown` (RAW)
    - 0x072CC2 `unknown` (RAW)
    - … (+8 more)
- Callees: none

### 0x00FE12 `strlen_near`

- Status: `MANUAL`
- Callers (9):
    - 0x002A06 `unknown` (RAW)
    - 0x00FF12 `unknown` (RAW)
    - 0x011B56 `unknown` (RAW)
    - 0x011F6E `load_game_state` (MANUAL)
    - 0x012102 `unknown` (RAW)
    - 0x01225E `unknown` (RAW)
    - 0x031BE6 `unknown` (RAW)
    - 0x06BE50 `unknown` (RAW)
    - 0x072CC2 `unknown` (RAW)
- Callees: none

### 0x00FECA `itoa_radix_dispatch`

- Status: `MANUAL`
- Callers (12):
    - 0x002648 `unknown` (RAW)
    - 0x0029DE `unknown` (RAW)
    - 0x002A06 `unknown` (RAW)
    - 0x002E4E `unknown` (RAW)
    - 0x00F9C4 `fclose_or_remove` (MANUAL)
    - 0x026DD4 `unknown` (RAW)
    - 0x0281D6 `unknown` (RAW)
    - 0x030F76 `unknown` (RAW)
    - 0x03471E `unknown` (RAW)
    - 0x06B722 `unknown` (RAW)
    - 0x06F698 `unknown` (RAW)
    - 0x077D5E `unknown` (RAW)
- Callees: none

### 0x00FEE6 `ltoa_dispatch`

- Status: `MANUAL`
- Callers (3):
    - 0x002668 `unknown` (RAW)
    - 0x002A6E `unknown` (RAW)
    - 0x077D5E `unknown` (RAW)
- Callees: none

### 0x010226 `strchr_near`

- Status: `MANUAL`
- Callers (10):
    - 0x0054DA `unknown` (RAW)
    - 0x011B56 `unknown` (RAW)
    - 0x012102 `unknown` (RAW)
    - 0x01225E `unknown` (RAW)
    - 0x0445EE `unknown` (RAW)
    - 0x06C2D6 `unknown` (RAW)
    - 0x06EEEC `unknown` (RAW)
    - 0x070EBA `unknown` (RAW)
    - 0x076642 `unknown` (RAW)
    - 0x076E50 `unknown` (RAW)
- Callees: none

### 0x01037E `memset_near`

- Status: `MANUAL`
- Callers (8):
    - 0x009318 `unknown` (RAW)
    - 0x028D8C `unknown` (RAW)
    - 0x03807E `unknown` (RAW)
    - 0x038418 `unknown` (RAW)
    - 0x03DA2A `unknown` (RAW)
    - 0x04CC50 `unknown` (RAW)
    - 0x063C58 `unknown` (RAW)
    - 0x0755CC `unknown` (RAW)
- Callees: none

### 0x01041A `unlink`

- Status: `MANUAL`
- Callers (2):
    - 0x00E2B0 `unknown` (RAW)
    - 0x00F9C4 `fclose_or_remove` (MANUAL)
- Callees: none

### 0x010433 `find_file`

- Status: `MANUAL`
- Callers (1):
    - 0x073270 `unknown` (RAW)
- Callees: none

### 0x010466 `_read`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x01046D `_write`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x0106BA `strrchr_far`

- Status: `MANUAL`
- Callers (6):
    - 0x00D3BE `unknown` (RAW)
    - 0x00D72E `unknown` (RAW)
    - 0x00D7F4 `unknown` (RAW)
    - 0x00D85E `unknown` (RAW)
    - 0x04477E `unknown` (RAW)
    - 0x06C492 `unknown` (RAW)
- Callees: none

### 0x01070C `strlen_far`

- Status: `MANUAL`
- Callers (5):
    - 0x00242C `unknown` (RAW)
    - 0x00C362 `unknown` (RAW)
    - 0x00D3EC `unknown` (RAW)
    - 0x012C8C `unknown` (RAW)
    - 0x012D4A `unknown` (RAW)
- Callees: none

### 0x01074E `strcpy_far`

- Status: `MANUAL`
- Callers (17):
    - 0x00242C `unknown` (RAW)
    - 0x00C410 `unknown` (RAW)
    - 0x00D7F4 `unknown` (RAW)
    - 0x00D85E `unknown` (RAW)
    - 0x00D8E4 `unknown` (RAW)
    - 0x030F76 `unknown` (RAW)
    - 0x0318D2 `unknown` (RAW)
    - 0x031BE6 `unknown` (RAW)
    - 0x0445EE `unknown` (RAW)
    - 0x06083A `unknown` (RAW)
    - 0x06921A `unknown` (RAW)
    - 0x06BE50 `unknown` (RAW)
    - 0x06C220 `unknown` (RAW)
    - 0x06C2D6 `unknown` (RAW)
    - 0x072F7A `unknown` (RAW)
    - 0x073158 `unknown` (RAW)
    - 0x0749E0 `unknown` (RAW)
- Callees: none

### 0x010784 `strcat_far`

- Status: `MANUAL`
- Callers (16):
    - 0x00260E `format_to_buffer_2D54` (MANUAL)
    - 0x002992 `unknown` (RAW)
    - 0x0029AC `unknown` (RAW)
    - 0x0029DE `unknown` (RAW)
    - 0x002A06 `unknown` (RAW)
    - 0x002A6E `unknown` (RAW)
    - 0x002A98 `unknown` (RAW)
    - 0x00C362 `unknown` (RAW)
    - 0x00D72E `unknown` (RAW)
    - 0x00D8E4 `unknown` (RAW)
    - 0x027746 `unknown` (RAW)
    - 0x027BB6 `unknown` (RAW)
    - 0x030F76 `unknown` (RAW)
    - 0x0605F6 `unknown` (RAW)
    - 0x072CC2 `unknown` (RAW)
    - 0x072F7A `unknown` (RAW)
- Callees: none

### 0x01144A `_close`

- Status: `MANUAL`
- Callers (2):
    - 0x00F9C4 `fclose_or_remove` (MANUAL)
    - 0x011F6E `load_game_state` (MANUAL)
- Callees: none

### 0x011F6E `load_game_state`

- Status: `MANUAL`
- Callers (1):
    - 0x012102 `unknown` (RAW)
- Callees (8):
    - 0x00FE12 `strlen_near` (MANUAL)
    - 0x00FF12 `unknown` (RAW)
    - 0x01144A `_close` (MANUAL)
    - 0x01146A `unknown` (RAW)
    - 0x0114E4 `unknown` (RAW)
    - 0x011D16 `unknown` (RAW)
    - 0x01225E `unknown` (RAW)
    - 0x0124D6 `coreleft_total` (MANUAL)

### 0x0124D6 `coreleft_total`

- Status: `MANUAL`
- Callers (1):
    - 0x011F6E `load_game_state` (MANUAL)
- Callees: none

### 0x013BED `entry_point`

- Status: `MANUAL`
- Callers: none
- Callees (1):
    - 0x013BF7 `system_init` (MANUAL)

### 0x013BF7 `system_init`

- Status: `MANUAL`
- Callers (1):
    - 0x013BED `entry_point` (MANUAL)
- Callees: none

### 0x014261 `rtlink_loader_B`

- Status: `MANUAL`
- Callers (1):
    - 0x01A5F0 `rtlink_overlay_thunk_table` (MANUAL)
- Callees: none

### 0x01427B `rtlink_loader_A`

- Status: `MANUAL`
- Callers (1):
    - 0x01A5F0 `rtlink_overlay_thunk_table` (MANUAL)
- Callees: none

### 0x014293 `rtlink_loader_shared`

- Status: `MANUAL`
- Callers: none
- Callees (1):
    - 0x0164A2 `rtlink_segment_lookup` (MANUAL)

### 0x0164A2 `rtlink_segment_lookup`

- Status: `MANUAL`
- Callers (1):
    - 0x014293 `rtlink_loader_shared` (MANUAL)
- Callees: none

### 0x01A425 `dos_version_far`

- Status: `MANUAL`
- Callers: none
- Callees: none

### 0x01A5F0 `rtlink_overlay_thunk_table`

- Status: `MANUAL`
- Callers (431):
    - 0x002400 `unknown` (RAW)
    - 0x00242C `unknown` (RAW)
    - 0x00341E `unknown` (RAW)
    - 0x004566 `unknown` (RAW)
    - 0x004B72 `unknown` (RAW)
    - 0x004D1E `unknown` (RAW)
    - 0x005760 `unknown` (RAW)
    - 0x005E18 `unknown` (RAW)
    - 0x006F5A `unknown` (RAW)
    - 0x007D3E `unknown` (RAW)
    - 0x007F96 `unknown` (RAW)
    - 0x008000 `unknown` (RAW)
    - 0x008982 `unknown` (RAW)
    - 0x00A994 `unknown` (RAW)
    - 0x00BD4A `unknown` (RAW)
    - 0x00BEDE `unknown` (RAW)
    - 0x00E1D2 `unknown` (RAW)
    - 0x00F72D `cstart` (MANUAL)
    - 0x012BC2 `unknown` (RAW)
    - 0x020F50 `unknown` (RAW)
    - 0x021602 `unknown` (RAW)
    - 0x02165E `unknown` (RAW)
    - 0x0219E8 `unknown` (RAW)
    - 0x021A14 `unknown` (RAW)
    - 0x021D32 `unknown` (RAW)
    - 0x021E72 `unknown` (RAW)
    - 0x021EDE `unknown` (RAW)
    - 0x021FF2 `unknown` (RAW)
    - 0x02211E `unknown` (RAW)
    - 0x022334 `unknown` (RAW)
    - … (+401 more)
- Callees (2):
    - 0x014261 `rtlink_loader_B` (MANUAL)
    - 0x01427B `rtlink_loader_A` (MANUAL)

### 0x044540 `clamp_byte_at_far_ptr_to_5`

- Status: `MANUAL`
- Callers (3):
    - 0x044E7C `unknown` (RAW)
    - 0x044FA4 `unknown` (RAW)
    - 0x0458EC `unknown` (RAW)
- Callees: none

### 0x078AF2 `coreleft_max`

- Status: `MANUAL`
- Callers: none
- Callees: none
