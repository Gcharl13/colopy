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

Soak: --smoke=500 passes (year 1992; REF 228 units split 131/44/21/32
reg/cav/mow/art -- the byte-verified arm-deficit ratios holding across
500 iterations; no faults, no leaks observed).

RE-BASELINED 2026-06-11 (AI19 LIVE -- ROUTE_B_PLAN 0.4): the euro-AI
fixture units now run the real 0x4E2D6 decision ladder, and the smoke
pins their exact deterministic end-state instead of the stub-era
tail-only expectations:
  units 1+2 (type 0): AI15a wander dispatch -> prof '8', orders 0x0B;
    zero @UNIT tables make the wander deltas 0, so dest == pos and the
    in-flight early-out (@asm 0x050C6E) holds the state stable.
  unit 3 (ship 0x0E): AI9/AI10 fall through, AI18 scores no dirs for
    ships off colony tiles, AI19 parks it: prof '9', orders 5.
REF end-state is IDENTICAL to the stub-era baseline (228 = 131/44/21/32),
confirming evaluator/REF independence.

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

1. EUROPEAN AI UNIT CHOOSER — func_04E2D6: head dispatch + EXIT TAIL
   (0x51C68: auto-sentry / at-war wake-scan / goto-arrival) BYTE_VERIFIED,
   wired per-unit for AI powers (viceroy_ai_unit_turns) and smoke-asserted.
   The ~13.5KB SCORING BODY (0x4E50C..0x51C68) that chooses NEW moves is
   the remaining bulk. NB: the func_04E2D6 thunk (0x1A1F:0x4F4) has no
   static lcall site in the EXE — the per-unit loop is shell-sequenced
   until the runtime dispatcher is located.
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
