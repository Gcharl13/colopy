# DATA -> C manifest (generated)

Every member of the JS port's DATA object and what the C build did
with it. Nothing is dropped silently.

| Member | Disposition |
|---|---|
| `palette` | EXCLUDED: render: VGA palette |
| `difficulty` | emitted |
| `seasons` | emitted |
| `terrain` | emitted |
| `nations` | emitted |
| `orders` | emitted |
| `units` | emitted |
| `dialogs` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `woodcuts` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `colonynames` | emitted |
| `cargo` | emitted |
| `classes` | emitted |
| `jobtrain` | emitted |
| `buildings` | emitted |
| `defensive` | emitted |
| `terrainmove` | emitted |
| `improvework` | emitted |
| `yields` | emitted |
| `jobs` | emitted |
| `jobexpert` | emitted |
| `jobtier` | emitted |
| `actions` | emitted |
| `missionpre` | emitted |
| `attitude` | emitted |
| `attitudinal` | emitted |
| `values` | emitted |
| `scorenames` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `levelname` | emitted |
| `regionname` | emitted |
| `eurolabel` | emitted |
| `tradenames` | emitted |
| `pedia` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `fathers` | emitted |
| `founding` | emitted |
| `independent` | emitted |
| `tribes` | emitted |
| `tribesites` | emitted |
| `menus` | emitted -> colopy_ui.c (interface layout; render-layer only) |
| `events` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `text` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `diplotext` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `sav1653` | fixture -> cport/host/fixtures.h |
| `savRaleigh` | fixture -> cport/host/fixtures.h |
| `savStart` | fixture -> cport/host/fixtures.h |
| `savNewColony` | fixture -> cport/host/fixtures.h |
| `briefings` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `cards` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `viceroy` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `myleader` | emitted -> colopy_text.c (display text; SD-able on Teensy) |
| `starts` | emitted |
| `map` | emitted (uint8 tiles + W/H) |
| `sheets` | EXCLUDED: render: sprite-sheet geometry |
| `cycle` | EXCLUDED: render: palette-cycling animation |
| `palettes` | EXCLUDED: render: per-screen palettes |
| `pikidx` | emitted |
| `fonts` | EXCLUDED: render: glyph atlases |
