# Next-wave targets — highest-value still-UNKNOWN functions

> ## ✅ OVERLAY C-PORT COMPLETE (2026-05-30)
>
> The breadth sweep (all 23 overlay files) + the finish-wave (8 files of deferred
> hard-tail reals) are done. **All 629 authoritative overlay functions** (reseg
> page list) are represented in `src/` — the orphan audit reports **0 orphans**,
> and **0 un-ported skeleton stubs** remain. Many rows in the table below are now
> DONE (e.g. 0x4CC50, 0x5E9B0, 0x69D8C, 0x61F02 were finished in the wave).
>
> ### Bounded residue: 12 functions carry cited `TBD-inner` sub-regions
> Each has a byte-faithful OUTER structure + all citations; only an inner part is
> deferred (never fabricated). Grouped by ROOT CAUSE = how each closes:
>
> **A. Cross-page overlay-target opacity** — inner calls a 0x191F/0x1A1F target in
> another page. Closeable via Phase-B linkage (the target pages are already ported):
> ~~`func_04CC50` (cs:0x7A71/0x7ABC→pg0x12 score payloads)~~ **RESOLVED 2026-06-08**
> → All 4 trampolines (cs:0x7A71/0x7A76/0x7ABC/0x7AD5) trace via segid=13
> (base=0x4C1F0 STRONG) to functions WITHIN page_0D itself: 0x7A71→func_04C35A
> (queue_a_find_or_insert), 0x7A76→func_04CAF6 (find_nearest_target),
> 0x7ABC→func_04C4AE (table_c_insert), 0x7AD5→func_04C50C (table_c_clear).
> Banner updated with BYTE_VERIFIED chain; call sites now cite resolved names.
> Remaining TBD-inner: score-leaf interiors (0x181F:0x8BC/0x2EE/0x37A) only.
> `func_052F7E`
> (cs:0x7AD0/0x7ADF war-matrix) · `func_065D26` (0x1A1F:0x88A property reads) ·
> ~~`func_0749E0` (0x1A1F:0xD20 per-entry name sub-loader)~~ **DECODED 2026-05-31**
> → NAMES.TXT data-table loader, full section→DS-base map in `docs/NAMES_LOADER.md`;
> residue narrowed to the orphan `func_07637F` terrain-name sub-loader · `func_0772FA`
> (0x1A1F:0xEE4 cursor-walk gate).
>
> **B. DGROUP data-table contents** — inner reads a fixed table whose VALUES are
> data, not code. Closeable by byte-extracting the table (a data pass; the user
> deprioritized data-extraction until the C port is done):
> `func_061F02` (terrain-cost table DS:0x2F76) · `func_06F0F4` (10 @-directive
> keyword tables DS:0x1FC7+).
>
> **C. Far-record struct field semantics** — ~~inner walks the `*(0x842)` stride-0x24
> UI-list record / `.SS` sub-record whose layout isn't yet modeled. Closeable by
> identifying that record struct:
> `func_06A700` (site-list) · `func_06AA88` (terrain-detail) · `func_076642` (.SS
> +0x42..+0x4C accumulation).~~ **RESOLVED 2026-06-08**
> → The "stride-0x24" estimate was wrong; correct stride is **0x0C** (12 bytes/elem),
> confirmed from disassembly at 0x06AB6C/0x06A7EC. `TerrainUIRec` struct added to
> `overlay_068A14_06C1CC.c`; func_06A700 + func_06AA88 BYTE_VERIFIED via
> g_terrain_ui_8F82[node].link_next chain walk. func_076642 .SS accumulation loop
> BYTE_VERIFIED in `overlay_0745F0_077A6A.c`.
>
> **D. Dense UI input hit-scan / arithmetic** — ~~recoverable with careful tracing
> (deferred to avoid fabricating coordinate math):
> `func_06E3D0` (panel-modal per-key cell math + cursor hit-scan) · `func_070060`
> (report-screen key-nav rotation + 3×4 mouse hit-scan).~~ **RESOLVED 2026-06-08**
> → func_06E3D0 hit-scan Phase 0/1/2 + key-switch (edit/non-edit paths) BYTE_VERIFIED;
> func_070060 key-nav row%4/col%3 + 3×4 mouse grid (w=0x30 h=0x48) BYTE_VERIFIED.
> Both in `overlay_06D938_0702D5.c`.
>
> Group **A** is the most tractable next step and overlaps Phase B (extern↔def
> linkage). Group **B** is pure data. Groups **C/D** need a little more tracing.

Produced by the wave-11 flat-image completeness cross-check (2026-05-30), now that
the RTLink overlay wall is down (every function below is statically reachable via
`tools/rtlink/rtlink_decode.py resolve`). Each was confirmed a REAL function (valid
`ENTER`/`PUSH BP` prologue, not a jump table) sized from the reseg table. Spot-check
the true RETF when porting (a few have reseg `terminal: page-end` size inflation).

| # | Offset | ~Size | Page | Reach | Role (string/global evidence) | Why it matters |
|---|--------|-------|------|-------|-------------------------------|----------------|
| 1 | ~~0x53B7E~~ DONE | 9999 | 0x0E | 0x1A1F:0x35E | **= per-colony AI auto-manage** (work re-alloc + build planner + status flags); the "KINGTAX" tag was a FALSE attribution (pushes no king handle) — corrected. Ported wave-12 → src/colony/auto_manage.c | — |
| 2 | 0x4CC50 | 5733 | 0x0D | 0x1A1F:0xA60 | ENTER 0x1E4 | Big LARGE_LOGIC by the AI dispatcher (0x4E2D6) |
| 3 | **0x2D658** | 5220 | 0x03 | 0x191F:0x688 | colony_t*, difficulty, REBELMAJORITY/TORYMAJORITY/SONSUP/TRAINPROFESSION/FOOD1 | **Colony SoL/Tory% + colonist-training handler** — long-standing backlog item |
| 4 | ~~0x43074~~ DONE | 4950 | 0x09 | 0x181F:0x424 | **= cursor-tile / unit-stack INFO PANEL renderer** (read-only draw; "turn dispatcher" guess was FALSE — no turn/rebel/tax write). Ported wave-14 → src/render/tile_info_panel.c | — |
| 5 | 0x5E9B0 | 4371 | 0x11 | 0x1A1F:0x0 | ENTER 0xCC; DISPATCHER | First fn of page 0x11 (combat/consequence neighbourhood) |
| 6 | ~~0x49600~~ DONE | 3451 | 0x0C | thunk @0x1CA3C | Native trade haggling resolver (BUY/SELL prices) — ported wave-13 → src/native/haggle.c | — |
| 7 | 0x2BC72 | 2259 | 0x02 | 0x191F:0x6372 | ENTER 0x18 | Large UI/colony-screen-segment fn |
| 8 | 0x69D8C | 2420 | 0x16 | 0x191F:0xEAC | "TERRAIN" | Terrain/mapgen LARGE_LOGIC (mapgen mostly TBD) |
| 9 | 0x61F02 | 2067 | 0x13 | 0x1A1F:0xF2 | rect `(%d,%d)-(%d,%d)` | Geometry/region engine (underpins UI/report draw) |
| 10 | 0x48F34 | 1740 | 0x0C | 0x1A1F:0x2154 | colony_t* 0x8542; `%Fs %d %d` | Colony-struct toucher (native/colony page) |
| 11 | 0x4B308 | ~1861 | 0x0C | 0x1A1F:0x4528 | HAPPY/MEDIUM/SAVAGE/MADATSHIPS/VILLAGE | Tribe-attitude compute (5 levels) |

**False positive to avoid:** `0x33F6A` (would-be #1 at ~10788B) is a CS-relative
JUMP TABLE (`8e 38 a2 38 b0 38 …` = word offsets), a reseg page-0x04 catch-all that
swallowed a switch table + the king functions — NOT a function.

**Top 3 for the next wave:** 0x53B7E (KINGTAX engine spine), 0x2D658 (SoL/Tory +
training — closes a named backlog item), 0x4CC50 (AI-neighbourhood logic).
