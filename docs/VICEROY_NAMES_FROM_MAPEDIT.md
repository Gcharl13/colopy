# VICEROY function names carried over from MAPEDIT's symbol table

`MAPEDIT.EXE` ships an **NB02 CodeView publics table** — 1071 names across 203
modules, mined 2026-07-30 into `data_extracted/mapedit_symbols.json`.
`VICEROY.EXE` ships none. But the two programs were built by the same team
against the same in-house C library, so a good deal of MAPEDIT's *named* code is
the same compiled source sitting in VICEROY under no name at all.

That had already been established by hand three times — `menu.obj`
(RULINGS 2026-07-30), then `cycle_1.c` / `timer_1.c` / `timer_3.ASM`
(RULINGS 2026-08-05). This document is the systematic version.

Generator: **`tools/xmatch_mapedit_viceroy.py`** → `data_extracted/viceroy_named_from_mapedit.json`.

## 1. Method

The builds differ in memory model and in **every absolute address** — DGROUP
offsets, segment values in far calls, address-valued immediates. What does not
differ, for the same source through the same compiler, is the instruction
sequence: opcode, ModRM, SIB, in order. So an instruction is fingerprinted as
its encoding **with the displacement and immediate fields deleted** (deleted,
not zeroed, so the 2-byte and 4-byte forms of an operand still compare equal).

Matching runs in two stages, and the second is the one that matters:

1. **Candidates** — index both sides on the fingerprint of their first 16
   instructions.
2. **Verification by extension** — disassemble both sides forward from their
   entry points, **ignoring the recorded function boundaries**, and count how
   many leading instructions agree.

Stage 2 exists because both boundary sources lie. VICEROY's function extents
come from a scan and are frequently short; MAPEDIT's come from the CodeView
table and are exact. Meanwhile a shared compiler prologue makes *unrelated*
functions look identical for a dozen instructions. Measuring the agreed run
settles both problems with a number instead of an assumption.

A match is **exact** only when the agreed run covers MAPEDIT's entire function,
and only when the fingerprint is unique on both sides. Anything shorter is
recorded as `partial` in the JSON and is **not** a name assignment — those are
leads, mostly shared prologues.

The first pass of this tool, before stage 2 existed, produced 153 "matches" on
whole-function and prefix fingerprints. Verification cut that to **89**. The
worst casualty is instructive: `_strings` (1026 bytes) "matched"
`rt_far_strlen` (45 bytes) on a 16-instruction prologue. Prefix agreement is not
identity.

## 2. What this is, and is not

Per `CLAUDE.md`, this is **evidence, not a ruling**. An exact match is a fact
about bytes: these two functions are the same code. It does **not** say the
VICEROY copy is *reached* the same way — that still needs the call-site trace.
`cycle_colors` is the cautionary case: same C, but VICEROY reaches it through a
different thunk and installs it from a different caller.

The names are therefore recorded here and in the JSON. They have **not** been
bulk-applied to `code/VICEROY/functions.json`, which is a generated artifact;
the single exception is the corrected name in §4, which fixes a demonstrated
error rather than adding a new claim.

## 3. Corroborations

Four exact matches land on addresses the tree already cites, and confirm them
from a completely independent direction — a symbol table, not a trace:

| VICEROY | CodeView name | corroborates |
|---|---|---|
| `0x006204` | `_terrain_fix_2` (`map.obj`) | **`CLAUDE.md` hard rule 3** — the auto-forest fold, "byte-verified at file `0x6204`". The rule's address is right, and the shipped name for it is `_terrain_fix_2`. |
| `0x00C8AB` | `_TIMER_ACTIVATE_LOW_PRIORITY` (`timer_3.ASM`) | RULINGS 2026-08-05, which derived this address by hand from `lcall 0x0A29:0x21B` @`0x04B62` and the constant `0x22` offset between the two timer modules. |
| `0x00E702` | `@mcga_setpal_range` (`mcga_b.c`) | the same ruling's identification of the cycling upload, `lcall 0x0C2E:0x22` @`0x0C637`. |
| `0x044A5A` | `_menu_bar_hide` (`menu.obj`) | `spec/ui/debug_screens.md` §, where `func_044A5A` is what the cheat-bit-clear path calls via `0x191F:0x45C`. Hiding the bar is exactly what that branch should do. |

Nine further exact matches landed on VICEROY functions that already carried an
independently-derived name, and **all nine agree**: `_strcat`/`strcat_near`,
`__fstrcat`/`strcat_far`, `_strcpy`/`strcpy_near`, `__fstrcpy`/`strcpy_far`,
`_strchr`/`strchr_near`, `__fstrrchr`/`strrchr_far`, `_open`/`rt_dos_open`,
`__dos_findfirst`/`find_file`, `_on_map`/`is_xy_in_map_bounds`,
`_tile_id`/`terrain_id_normalize_to_8`, `_spacer`/`rt_emit_repeat_n`.

## 4. One correction

`func_078548` is named **`vga_palette_dac_write`** in
`code/VICEROY/functions.json`, and `docs/RAW_FUNCTION_AUDIT.md` rates it **B**
with the gloss "writes the 256-colour palette to the DAC (OUT 0x3C7/0x3C9)".

CodeView calls it **`@mcga_getpal`**, and the bytes side with CodeView:

```
078548  push bp …
07854D  mov word ptr [0x808], 1      ; the DAC-busy lock
078559  les di, [bp+6]               ; caller's destination buffer
07855C  mov dx, 0x3c7                ; DAC *read* index  (0x3C8 is the write index)
07855F  xor al, al
078561  out dx, al
078572  mov dx, 0x3c9
07857E  insb byte ptr es:[di], dx    ; reads FROM the port INTO the buffer
```

`0x3C7` is the read-index register and `insb` transfers port → memory. The
function **reads** the palette out of the DAC. Its writing counterpart is the
`@mcga_setpal_range` in §3: `out 0x3C8` (write index) at `0x00E730`, then
`outsb`. The audit entry noticed port `0x3C7` and drew the opposite conclusion.

Corrected in `code/VICEROY/functions.json` and `docs/RAW_FUNCTION_AUDIT.md`.

## 5. Coverage

| | |
|---|---|
| MAPEDIT named functions with extents | 606 |
| VICEROY functions in the inventory | 1250 |
| candidate fingerprints | 212 |
| **exact (whole function verified)** | **89** |
| — of which VICEROY had no name | 76 |
| — of which VICEROY had a name | 13 (12 agree, 1 corrected) |
| partial (prologue only — leads, not names) | 110 |
| ambiguous (n:m fingerprint) | 13 |

66 of the 89 are in the resident load image, 23 in overlays.

Coverage is limited by three things, all of them honest limits rather than
tool defects: MAPEDIT's table only covers what MAPEDIT links; a function
compiled in a different memory model is genuinely different code (VICEROY's
`cycle_colors` reaches its palette through `lds si,[0x36E]` where MAPEDIT uses
`mov si, 0x6048`, so it correctly does **not** match); and functions below 16
instructions are skipped because stubs collide.

The matcher also flags **bad VICEROY extents** as a side effect — where a match
is exact but the recorded size is far shorter than MAPEDIT's, VICEROY's boundary
is wrong. `0x00E702` is recorded as 21 bytes and is really 52 instructions;
`0x011D30` (`_open`) is recorded as 105 bytes against MAPEDIT's 401.

## 6. The matches

`agreed` is the number of instructions verified identical, which for an exact
match is MAPEDIT's whole function.

| VICEROY | CodeView name | module | agreed | note |
|---|---|---|---|---|
| `0x0028C0` | `_spacer` | `write.obj` | 19 | agrees with `rt_emit_repeat_n` |
| `0x002BC8` | `_write_centered` | `write.obj` | 36 |  |
| `0x002CE0` | `_write_big_centered` | `write.obj` | 38 |  |
| `0x002D28` | `_say_terrain` | `write.obj` | 36 |  |
| `0x003436` | `_tile_id` | `tile.obj` | 18 | agrees with `terrain_id_normalize_to_8`; VICEROY extent short (25 B) |
| `0x004900` | `_xy_dist` | `stuff.obj` | 35 | VICEROY extent short (15 B) |
| `0x004984` | `_xy_dist_2` | `stuff.obj` | 27 | VICEROY extent short (12 B) |
| `0x0049FC` | `_bearing_adjacent` | `stuff.obj` | 18 | VICEROY extent short (20 B) |
| `0x005BFA` | `_on_map` | `map.obj` | 19 | agrees with `is_xy_in_map_bounds` |
| `0x005C2C` | `_on_colony_map` | `map.obj` | 49 |  |
| `0x005D4E` | `_feature_set` | `map.obj` | 22 | VICEROY extent short (40 B) |
| `0x006204` | `_terrain_fix_2` | `map.obj` | 34 | VICEROY extent short (46 B) |
| `0x00624E` | `_terrain_type` | `terrain.obj` | 22 | VICEROY extent short (8 B) |
| `0x00C8AB` | `_TIMER_ACTIVATE_LOW_PRIORITY` | `timer_3.ASM.obj` | 19 |  |
| `0x00C8FC` | `@buffer_conform` | `buffer_i.c.obj` | 65 | VICEROY extent short (88 B) |
| `0x00CD0B` | `_mouse_get_status` | `mouse_1.ASM.obj` | 27 |  |
| `0x00D0B6` | `@mouse_in_box` | `mouse_2.c.obj` | 19 |  |
| `0x00DFCC` | `@buffer_hline` | `buffer_9.c.obj` | 47 | VICEROY extent short (39 B) |
| `0x00E036` | `@buffer_vline` | `buffer_a.c.obj` | 48 | VICEROY extent short (24 B) |
| `0x00E702` | `@mcga_setpal_range` | `mcga_b.c.obj` | 52 | VICEROY extent short (21 B) |
| `0x00F450` | `@sort_insertion_8` | `sort_3.c.obj` | 100 | VICEROY extent short (44 B) |
| `0x00FD74` | `_strcat` | `strcat.asm.obj` | 30 | agrees with `strcat_near` |
| `0x00FDB4` | `_strcpy` | `strcpy.asm.obj` | 26 | agrees with `strcpy_near` |
| `0x00FDE6` | `_strcmp` | `strcmp.asm.obj` | 21 |  |
| `0x00FE2E` | `_strncat` | `strncat.asm.obj` | 30 |  |
| `0x00FE64` | `_strncpy` | `strncpy.asm.obj` | 24 |  |
| `0x00FE8C` | `_strncmp` | `strncmp.asm.obj` | 32 | VICEROY extent short (27 B) |
| `0x00FF9A` | `_fgets` | `fgets.asm.obj` | 65 | VICEROY extent short (34 B) |
| `0x010226` | `_strchr` | `strchr.asm.obj` | 24 | agrees with `strchr_near` |
| `0x010292` | `_strnicmp` | `strnicmp.asm.obj` | 48 | VICEROY extent short (54 B) |
| `0x010352` | `_memcpy` | `memcpy.asm.obj` | 23 |  |
| `0x010433` | `__dos_findfirst` | `dos_d_find.asm.obj` | 28 | agrees with `find_file` |
| `0x01046D` | `__dos_write` | `dos_d_rdwr.asm.obj` | 16 | agrees with `_write`; VICEROY extent short (5 B) |
| `0x010496` | `__aFldiv` | `ldiv.asm.obj` | 73 |  |
| `0x010530` | `__aFulmul` | `lmul.asm.obj` | 23 | VICEROY extent short (25 B) |
| `0x010582` | `__fmemcpy` | `hmemcpy.asm.obj` | 50 | VICEROY extent short (28 B) |
| `0x0105E0` | `__fstrchr` | `strchr.asm.obj` | 24 |  |
| `0x01060E` | `__fstricmp` | `stricmp.asm.obj` | 36 |  |
| `0x010654` | `__fstrncmp` | `strncmp.asm.obj` | 32 | VICEROY extent short (26 B) |
| `0x010690` | `__fstrncpy` | `strncpy.asm.obj` | 25 | VICEROY extent short (33 B) |
| `0x0106BA` | `__fstrrchr` | `strrchr.asm.obj` | 26 | agrees with `strrchr_far` |
| `0x0106E8` | `__fstrupr` | `strupr.asm.obj` | 20 |  |
| `0x01074E` | `__fstrcpy` | `strcpy.asm.obj` | 29 | agrees with `strcpy_far` |
| `0x010784` | `__fstrcat` | `strcat.asm.obj` | 34 | agrees with `strcat_far` |
| `0x0107CA` | `__fmemset` | `hmemset.asm.obj` | 35 | VICEROY extent short (49 B) |
| `0x010812` | `__FF_MSGBANNER` | `dos_crt0msg.asm.obj` | 16 |  |
| `0x0109F0` | `__setenvp` | `dos_stdenvp.asm.obj` | 65 | VICEROY extent short (15 B) |
| `0x010A6E` | `__NMSG_TEXT` | `dos_nmsghdr.asm.obj` | 26 | VICEROY extent short (18 B) |
| `0x010A99` | `__NMSG_WRITE` | `dos_nmsghdr.asm.obj` | 25 | VICEROY extent short (12 B) |
| `0x010B26` | `__filbuf` | `_filbuf.asm.obj` | 65 |  |
| `0x010BBC` | `__flsbuf` | `_flsbuf.asm.obj` | 103 | VICEROY extent short (151 B) |
| `0x010E27` | `__ftbuf` | `_sftbuf.asm.obj` | 29 |  |
| `0x010F3E` | `__output` | `output.asm.obj` | 518 | VICEROY extent short (448 B) |
| `0x01146A` | `_lseek` | `dos_lseek.asm.obj` | 46 |  |
| `0x0114E4` | `_read` | `dos_read.asm.obj` | 94 | VICEROY extent short (125 B) |
| `0x01180C` | `__catox` | `atox.asm.obj` | 47 | VICEROY extent short (46 B) |
| `0x011D30` | `_open` | `dos_open.asm.obj` | 157 | agrees with `rt_dos_open`; VICEROY extent short (105 B) |
| `0x012214` | `__nfree` | `nmalloc.asm.obj` | 17 |  |
| `0x012235` | `__nmalloc` | `nmalloc.asm.obj` | 21 |  |
| `0x01287A` | `_SOUND_DRIVER_LOAD` | `sound_1.ASM.obj` | 79 | VICEROY extent short (136 B) |
| `0x012928` | `_SOUND_DRIVER_INIT` | `sound_1.ASM.obj` | 25 |  |
| `0x012DAA` | `@xtoi` | `btype_3.c.obj` | 44 |  |
| `0x0132B0` | `PFABEXP2` | `pfabexp2.ASM.obj` | 166 | VICEROY extent short (26 B) |
| `0x01340E` | `_xms_umb_get_avail` | `XMS_2.C.obj` | 21 | VICEROY extent short (32 B) |
| `0x01343A` | `_xms_umb_get` | `XMS_3.C.obj` | 28 |  |
| `0x01347C` | `_xms_umb_free` | `XMS_3.C.obj` | 24 | VICEROY extent short (21 B) |
| `0x04497E` | `_menu_bar_item` | `menu.obj` | 33 |  |
| `0x0449C4` | `_menu_item` | `menu.obj` | 59 |  |
| `0x044A5A` | `_menu_bar_hide` | `menu.obj` | 24 |  |
| `0x0458EC` | `@menu_bar_mouse_parse` | `menu.obj` | 64 |  |
| `0x045A1E` | `@menu_key_parse` | `menu.obj` | 75 |  |
| `0x066E0C` | `_conform_to_view` | `map_2.obj` | 29 |  |
| `0x066E52` | `_conform_to_view_size` | `map_2.obj` | 52 |  |
| `0x06C7AA` | `_popup_release_all_grey` | `popup.obj` | 17 |  |
| `0x06C7DA` | `_popup_read_check` | `popup.obj` | 18 |  |
| `0x06C80A` | `_popup_write_check` | `popup.obj` | 16 |  |
| `0x06CA38` | `_popup_add_check` | `popup.obj` | 22 |  |
| `0x06E2DE` | `_popup_draw` | `popup.obj` | 73 |  |
| `0x06F554` | `@pop_set` | `popup.obj` | 20 |  |
| `0x06FABA` | `_text_item_binary` | `text.obj` | 20 |  |
| `0x06FAE8` | `_text_search` | `text.obj` | 26 |  |
| `0x0710C2` | `@map_check` | `map_9.obj` | 20 |  |
| `0x0772BA` | `_far_to_near` | `pack_6.c.obj` | 18 | VICEROY extent short (10 B) |
| `0x0776F4` | `@pack_raw_copy` | `pack_5.c.obj` | 51 |  |
| `0x077772` | `@pack_a_packet` | `pack_5.c.obj` | 88 |  |
| `0x078548` | `@mcga_getpal` | `mcga_8.c.obj` | 40 | **name corrected — see §4** |
| `0x078A4A` | `@mem_adjust` | `mem_2.c.obj` | 23 |  |
| `0x078BCE` | `@heap_declare` | `heap_1.c.obj` | 19 |  |
| `0x078CB2` | `@heap_shrink` | `heap_1.c.obj` | 49 |  |
