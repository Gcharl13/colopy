# Integration status & verification runbook (2026-06-10)

## What runs today (no game data required)

    cmake -S viceroy_source -B viceroy_source/build_modern -DVICEROY_MODERN=1
    cmake --build viceroy_source/build_modern
    ./viceroy_source/build_modern/viceroy_modern --smoke=60

The smoke boots the DGROUP layer, builds a synthetic 32x32 world (one
colony, one native brave) and runs 60 full WORLD TURNS through the real,
byte-verified engines, asserting:

  - per-power pipeline: census rebuild (func_042138) -> colony production +
    SoL/Tory (func_02D658, single-interleaved-loop structure) -> Europe
    market drift (func_0305A8) -> crown sentiment/REF buildup (func_03E162)
    -> royal-event cadence -> AI asset census (func_052F7E)
  - native AI: every tribe unit runs the full native_unit_ai brain per turn
  - economy round-trip: sell 100 @ bid(level-1): gross 500, tax 50 -> crown
    pool king[+0x22] (the REF feed), net 450 -> gold
  - REF growth: 42 sentiment/turn at Viceroy difficulty -> 4 units by turn
    60 (3 regulars + 1 cavalry; the byte-verified arm ratios)
  - SAVE/LOAD: original COLONIZE format round-trip; PowerRecord window +
    year byte-identical after save -> trash -> load

## With the user's own game files (`game_data/` or $VICEROY_DATA)

Drop the original install's files next to the binary (NOTHING is committed;
the directory is gitignored):

  VICEROY.EXE            DGROUP init window (loaded at runtime, anchor-checked)
  NAMES.TXT, GAME.TXT,   rules tables, menu text, labels
  LABELS.TXT
  FONTSMAL.FF (fonts)    OPENMENU/NATIONS/DIFFICUL/EUROPE/COLONY .PIK
  TERRAIN.SS, PHYS0.SS,  sprite sheets (RLE codec cross-validated against
  ICONS.SS               the EXE's own blitter func_00E76A)
  AMER2.MP               the premade America map

Then the shell plays: title menu (GAME.TXT @BEGINMENU) -> nation ->
difficulty -> live map (real renderer plumbing, real UnitRecord moves,
follow-cam, minimap + tile info panels) with:

  arrows  move ship (real classify/commit pipeline)
  SPACE   end turn (full world step above)
  b       found colony (real creator func_02EB78)
  ENTER   open colony screen; 1..9 colony services (func_02883E)
  e       EUROPE dock: live 16-good bid/ask strip; B/S trade 100 units
          through market_buy/market_sell (tax + crown writes live)
  F1      terrain report (func_069D8C)   F5/F7  save/load (original format)
  F12     PPM screenshot (also the headless verification path)

Pixel verification: run headless (no display), F12-dump PPMs, compare
against DOSBox captures of the same state.

## Honest gaps (the remaining fidelity queue)

1. EUROPEAN AI UNIT CHOOSER — func_04E2D6 (4867 disasm lines) unported;
   AI European units hold standing orders only. THE major remaining port.
2. LCR trigger — lcr_resolve (ported) needs its movement-trigger call site
   traced (the feature-layer rumour bit test in the arrival path).
3. Colony mid-band painters (field workers / colonist rows) — sub-renderer
   bodies func_0264A8 / func_0270D0 pending; title/stockpile/flag/minimap/
   SoL panels are ported.
4. seg-0x1B22 save block (0x378 bytes): zero in the EXE (runtime BSS);
   identity needs a runtime-writer trace. Saves preserve it via a host
   buffer (correct for fresh games).
5. Random per-turn events breadth (mercenary offers func_03E664/03E442 are
   decoded as comments; need C bodies wired into the aid turn).
6. Asset-dependent pixel pass once real captures are available.
