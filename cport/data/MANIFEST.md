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
| `dialogs` | emitted |
| `woodcuts` | emitted |
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
| `scorenames` | emitted |
| `levelname` | emitted |
| `regionname` | emitted |
| `eurolabel` | emitted |
| `tradenames` | emitted |
| `pedia` | emitted |
| `fathers` | emitted |
| `founding` | emitted |
| `independent` | emitted |
| `tribes` | emitted |
| `tribesites` | emitted |
| `menus` | EXCLUDED: interface: pulldown layout/accelerators (menu ACTIONS are core commands, defined in colopy_core.h) |
| `events` | emitted |
| `text` | emitted |
| `diplotext` | emitted |
| `sav1653` | fixture -> cport/host/fixtures.h |
| `savRaleigh` | fixture -> cport/host/fixtures.h |
| `savStart` | fixture -> cport/host/fixtures.h |
| `savNewColony` | fixture -> cport/host/fixtures.h |
| `briefings` | EXCLUDED: interface: intro briefing text |
| `cards` | EXCLUDED: interface: score-card art captions |
| `viceroy` | EXCLUDED: interface: title strings |
| `myleader` | EXCLUDED: interface: name-entry prompts |
| `starts` | emitted |
| `map` | emitted (uint8 tiles + W/H) |
| `sheets` | EXCLUDED: render: sprite-sheet geometry |
| `cycle` | EXCLUDED: render: palette-cycling animation |
| `palettes` | EXCLUDED: render: per-screen palettes |
| `fonts` | EXCLUDED: render: glyph atlases |
