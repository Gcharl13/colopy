# Live DOSBox UI check — 2026-08-05

The real game, booted in this container under DOSBox 0.74-3 on a headless Xvfb
display, driven with xdotool, and captured through DOSBox's own Ctrl-F5
framebuffer dump (the emulated 320×200, no X compositing, no scaling, no aspect
correction — the same geometry `port/_shots/*.png` use).

Captures: `docs/screens/live_2026-08-05/`. Harness: `tools/dosbox_harness/`.

## 0. Getting it to run — two things worth recording

**The game will not start without an emulated Sound Blaster.** With
`sbtype=none` the opening runs, sets mode 13h, and renders a **black screen
forever** — no error, no exit. `CONFIG.COL`'s 20 bytes select SB at port
`0x220` / IRQ 7 (`20 02 | 20 00 | 07 00 | …`), and the boot path blocks on the
card. `sbtype=sb16` + `nosound=true` + `SDL_AUDIODRIVER=dummy` runs it silently.
This cost the first hour and is the single most useful fact for anyone
reproducing this.

**Clicks need the press and release in different emulated frames.** A single
`xdotool click` puts both edges in one tick and the DOS `INT 33h` polling loop
never sees the button down — motion tracks, nothing else responds. `mousedown`,
sleep, `mouseup`. A window manager also has to be running (bare Xvfb gives SDL
no input focus).

`VICEROY -g` starts straight at the main menu, skipping `OPENING.EXE`'s long
map-pan cinematic.

## 1. What was checked

| screen | live capture | verdict |
|---|---|---|
| Main menu | `01_main_menu.png` | matches |
| Map-source prompt | `02_map_source_prompt.png` | **not in the port** |
| Difficulty picker | `03_difficulty.png` | layout matches, **one real difference** (§2) |
| Nation picker | `04_nation.png` | matches |
| Name entry | `05_name_entry.png` | matches |
| Nation briefing | `06_briefing_england.png` | matches |
| Map view | `07`, `08`, `09` | matches; **sidebar unit labels differ** (§3) |
| REPORTS / ORDERS / pedia / CHEAT pulldowns | `10`–`13` | match |
| F2 Religious Advisor | `21_report_F2_religious.png` | real reference captured |
| F3 Continental Congress | `22_report_F3_congress.png` | real reference captured |
| F4 Labor Advisor | `20_report_F4_labor.png` | real reference captured |
| Europe | `30_europe.png` | close match |
| Colonizopedia terrain index | `40_pedia_terrain_index.png` | **port is wrong** (§4) |
| `@SETVIEW`, `@CREATE` cheat dialogs | `50`, `51` | confirm `spec/ui/debug_screens.md` |
| `@LANDFALL` | `60_landfall_dialog.png` | **port omits the speaker portrait** (§5) |
| Arawak first contact | `61_arawak_first_contact.png` | real reference captured |

Side-by-side sheets: `_compare_boot_sequence.png`, `_compare_in_game.png`.

**Not reached: the colony screen.** See §7 — this is an honest gap, not a pass.

## 2. Difficulty picker — the label is drawn in the wrong place

Both render the same 3×2 grid with the title text in cell 0 and the five levels
in cells 1–5, and the per-level outline ink matches (`{0x0A, 9, 0x0E, 0x0D,
0x0C}` — Discoverer green, Explorer blue, confirmed live by clicking between
them).

The difference: **the real game paints the selected level's name over the
selected portrait itself** (green text across the top of the portrait art). The
port instead draws a separate framed plaque reading `CONQUISTADOR / Moderate` in
the **bottom-left grid cell**, which in the real game holds the Conquistador
*portrait*. So the port both loses a portrait and puts the caption somewhere the
original never puts it.

## 3. Map sidebar — cargo units are labelled by equipment, not by type

Real, carried in the caravel on turn 1:

```
Veteran      Sentry
100 Tools    Sentry
```

Port:

```
Soldiers     Sentry
Pioneers     Sentry
```

The original labels a carried unit by its **veteran status / equipment load**
("Veteran", "100 Tools"), not by the unit-type name. The port uses `@UNIT`
names. Everything else in the sidebar — season+year, `Gold:`, `Tax:%`, the
active unit's moves and location, the `(Ocean)`/`Sea Lane` terrain line — lines
up.

## 4. Colonizopedia terrain index — one column, 21 entries, alphabetical

The live index is a **single column of 21 alphabetically-sorted names**:

> Arctic, Boreal Forest, Broadleaf Forest, Conifer Forest, Desert, Grassland,
> Hills, Marsh, Mixed Forest, Mountains, Ocean, Plains, Prairie, Rain Forest,
> Savannah, Scrub Forest, Sea Lane, Swamp, Tropical Forest, Tundra,
> Wetland Forest

The port builds its terrain index from `@UNFORESTED`+`@FORESTED`+`@OTHER`+
`@OTHER_NAMES` = 26 names against 29 `PEDIA.TXT` TERRAIN articles, shows ids
26–28 by number, and lays the index out in **three columns**.

This gives the standing "175 vs the spec's 162" question its first hard data:
the enumerator drops entries **and** sorts alphabetically, and at least for the
TERRAIN category the per-category index is **one column**, not three. The
three-column layout in `spec/ui/colonizopedia.md` presumably belongs to the
merged *Complete* index. Both need re-checking against this capture.

## 5. `@LANDFALL` — the port omits the speaker portrait

The real dialog draws a **large character portrait filling the right half of the
screen** behind/beside the text box. The port renders the text box alone.
`spec/ui/popups.md` already documents a speaker channel (`func_06BE92/BF12/BF3C`)
and a special-sprite slot with `func_06BF66`'s sprite x/y math marked TBD — this
capture is what that TBD looks like on screen, and the same applies to the
Arawak first-contact popup (`61`), which shows the chief portrait on the right.

## 6. Live confirmations of byte-derived findings

- **Alt-W-I-N** adds the `CHEAT` menu to the bar, exactly as
  `spec/ui/debug_screens.md` says (`xor [0x5383],0x20` @`0x023F9A`).
- The `@SETVIEW` dialog lists English/French/Spanish/Dutch/Complete/No-Special
  in that order, as documented.
- The `@CREATE` spawner lists the full documented unit family.
- Spawning a unit onto a native village raises the shipped debug assertion
  **"DANGER, WILL ROBINSON! Warning: Illegal entry into village"**, and then the
  error logger: `Error "VillageEntrySave" in module "<Map>" data: 46 30` with
  memory-check / DOS-error / stack-use lines. That is the error-exit path the
  tracker identifies at `0x181F:0x772` — seen live, in its own screen.
- Starting gold **1000** at Discoverer matches the difficulty table.
- The `Original America / Map Editor` prompt fires before difficulty select.

## 7. Not reached — the colony screen

Three attempts. The colony screen needs a landed colonist to execute Build
Colony, and the automation kept losing the active unit: creating a unit through
the cheat menu does not make it current, `b` acts on whatever the sidebar has
selected, and one attempt crashed the game via the village-entry assertion
above. The run that did land units (`61`) put them on a tile the sidebar still
reported as `(Ocean)`.

This is the screen the port has the most detailed reconstruction of
(RNG building placement, `func_025D34`, §12) and it is exactly the one still
unverified against a live frame. It needs a longer scripted playthrough or a
save file, not another few clicks.

## 8. What did NOT differ

Worth stating plainly, because it is the bulk of the check: the **main menu,
nation picker, name entry, briefing, map view, Europe screen, and all four
pulldown menus** match the port closely in layout, colour and text. The Europe
screen in particular — dock buildings, sky, the RECRUIT/PURCHASE/TRAIN button
stack, the three status panels, the bottom goods bar and the Exit button — is a
close match.
