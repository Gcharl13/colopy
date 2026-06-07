# DOS visual reference — observed from DOSBox screenshots

User-supplied 2026 screenshots of VICEROY.EXE (DOS Colonization 1994) showing
real layout, fonts, colors, and structure for each UI screen. This document
is the ground truth for tasks #62, #69, #70, and any future UI work.

## Global observations

- The status bar at the bottom of the main map view **does not exist**.
  The map viewport runs to the bottom of the screen. My fabricated
  `_render_status_bar` showing "B COLONY F FORT…" is a complete invention
  with no DOS counterpart and must be removed.
- The MAIN map view DOES have a top menu bar (BLACK strip with
  yellow/orange caps), and it DOES have a wood-textured right info panel.
  No other chrome.
- Cursor is a small white-and-black arrow. Single bitmap.
- Wood-panel background is used for: the right info panel on map view,
  and ALSO as a full-screen background for: name entry, nation select,
  difficulty select, encyclopedia/PEDIA entries, nation bonus screen.

## Title screen / Main Menu

```
+-----------------------------------------+
|  [gold ornamental rope border, top]     |
|                                          |
|     Sid Meier's                          |
|     COLONIZATION    (huge ornate gold    |
|                      title with dark     |
|                      blue outline)       |
|                                          |
|        +-----------------------------+   |
|        |COLONIZATION Version 3.0 -- 7-Feb-95 |  <- yellow-orange title row
|        |Start a Game in NEW WORLD     |   <- WHITE highlighted (selected)
|        |Start a Game in AMERICA       |   <- green
|        |CUSTOMIZE New World           |   <- green
|        |LOAD Game                     |   <- green
|        |View Hall of Fame             |   <- green
|        +-----------------------------+   |
|                                          |
|  [gold ornamental rope border, bottom]  |
+-----------------------------------------+
```

Background under the title is OPENMENU.PIK (water + green forest scene).
Title text "Sid Meier's COLONIZATION" is its own bitmap, not rendered text.
Menu options use FONTSMAL (or maybe FONTINTR), green by default, white
when highlighted, on a dark wood box with red border.

**NOTE: The "Quit" option is NOT shown in the original. coltext0 id=25
includes "Quit" but the DOS version drops it.**

## Opening narration

Six successive frames over a NIGHT-SKY ship-leaving-port background
(stars + clouds + dark blue sea + London silhouette + caravel sailing).
Each frame fades in/out one line at a time. Background does NOT change
between lines — the same image just displays different text overlays.

Order (from natural English sentence):
```
1. "In the Year of Our Lord One Thousand Four Hundred Ninety-Two,"   (id=27)
2. "an Expedition led by the Great Explorer,"                         (id=29)
   "Walter Raleigh,"   (continues, second line of id=29)
3. "Commissioned and Blessed by the King of England,"                 (id=31)
4. "left London on a Voyage of Discovery."                            (id=30)
5. "to Explore the Ocean Sea,"                                        (id=32)
6. "A New World!"                                                     (id=28)
```

**My current code orders them (28, 27, 29, 30, 31, 32) — WRONG.
Correct order: (27, 29, 31, 30, 32, 28).**

Text style: yellow with darker outline, FONTINTR-class ornate font.
Position: top-third of frame, centered horizontally.
Background image: not just OPENING.PIK (which is daytime panorama) —
this is a DEDICATED night-sky scene. May be a different PIK or
OPENING.PIK with a palette swap.

## Name entry

```
+--------------------- WOOD ----------------------+
|                                                  |
|                                                  |
|              Please Enter Your Name.             |
|              +---------------------+             |
|              |Walter Raleigh_       |             |
|              +---------------------+             |
|                                                  |
+--------------------------------------------------+
```

- "Please Enter Your Name." in green, FONTSMAL or FONTINTR
- Input box: GREEN-OUTLINED, larger than mine (~220×16 maybe), centered
  horizontally, filled with default leader name (Walter Raleigh for
  English) ready for backspace.
- Cursor: blinking underscore at end of pre-filled name.
- Background: full-screen WOODPANL.PIK
- Text inside box is GREEN, not white.

## Nation select

```
+--------------------- WOOD ----------------------+
|                                                  |
|                          [ENG flag]   [FRA flag] |
|   Select                  +RED border-           |
|   European Power          ENGLAND:               |
|                           Immigration            |
|                                                  |
|                          [SPA flag]   [NL flag]  |
|                                                  |
|   (Click Here When Finished)                     |
|                                                  |
+--------------------------------------------------+
```

- "Select European Power" in green, LEFT-ALIGNED in upper-left area
- "(Click Here When Finished)" green, BOTTOM-LEFT
- Four flag bitmaps in a 2×2 grid filling the right ~75% of screen
  - Top-left: England (red/yellow lions on quadrants)
  - Top-right: France (blue with gold fleurs-de-lis)
  - Bottom-left: Spain (yellow/red with castles + lions)
  - Bottom-right: Netherlands (orange/white/blue tricolor)
- Selected flag overlay: RED border + RED text "ENGLAND:" above flag,
  "Immigration" below flag (the bonus type)
- Bonus types per nation: England=Immigration, France=Cooperation,
  Spain=Conquest, Netherlands=Trade

## Difficulty select

```
+--------------------- WOOD ----------------------+
|                                                  |
|   Choose                  [Discoverer] [Explorer]<- BLUE BORDER selected
|   Difficulty Level                       EXPLORER:|
|                                          Easy   |
|   (Click Here                                    |
|   When Finished)  [Conqui] [Governor]  [Viceroy]|
|                                                  |
+--------------------------------------------------+
```

- "Choose Difficulty Level" green, LEFT-ALIGNED upper-left
- "(Click Here When Finished)" green, LEFT-MIDDLE
- 5 PORTRAIT CARDS (NOT a text list) showing each difficulty's iconic figure
  - Top row: 2 cards (Discoverer, Explorer)
  - Bottom row: 3 cards (Conquistador, Governor, Viceroy)
- Each card: full-figure painted portrait in period costume + flag
- Selected card has BLUE BORDER + blue overlay showing name + label
  (e.g. "EXPLORER: Easy" or "CONQUISTADOR: Moderate" etc.)

The labels (Easy/Moderate/Tough/Toughest/Easiest) come from DOS data —
see LABELS_sections.json @MISC.

## Map view (the canonical playing screenshot)

```
+----+---+------+-------+-----+-------------+--+
|GAME|VIEW|ORDERS|REPORTS|TRADE|         COLONIZOPEDIA |  <- YELLOW on BLACK menu bar
+----+---+------+-------+-----+-------------+--+
|                                  |              |
|                                  | [BLACK MM]   |  <- Minimap window
|                                  |  ORANGE bdr  |
|                                  |              |
|                                  +              |
|         (MAP VIEWPORT)           |Spring 1492  |  <- yellow stack
|         deep blue ocean          |Gold: 3000   |
|         + sea-lane tile          |Tax: 0%      |
|         + caravel sprite         |              |
|         w/ red flag overlay      |[ship] Moves: 4 |  <- unit + 2-line text
|                                  |       Locat: (56, 42)|
|                                  |              |
|                                  |Eng. Caravel  |  <- yellow
|                                  |No Orders     |  <- green
|                                  |(Sea Lane)    |  <- dim cream
|                                  +              |
|                                  |[port]Veteran |  <- cargo: portrait+text
|                                  |      Sentry  |
|                                  |              |
|                                  |[port]100 Tools|
|                                  |      Sentry  |
+----------------------------------+--------------+
```

**KEY DIFFERENCES from my current main.py implementation:**

1. **NO bottom status bar.** Mine fabricates "B COLONY F FORT..." — delete.
2. Sidebar text format: `Spring 1492` / `Gold: 3000` / `Tax: 0%` —
   THREE separate lines, not "GOLD 1500 / TAX 0" formatted as I have.
3. Sidebar sub-block: small unit sprite on left, two text lines to its
   right (`Moves: 4` and `Locat: (56, 42)`).
4. Below that sub-block: nation-abbreviated unit type ("Eng. Caravel")
   in yellow, then status ("No Orders") in green, then terrain hint
   in parens ("(Sea Lane)") in dim cream.
5. Cargo / units in the same tile shown below as MORE sub-blocks with
   small portrait + 2-line label ("Veteran / Sentry", "100 Tools / Sentry").
6. Menu bar text is YELLOW on BLACK (not white as my code uses).
7. "Locat:" not "Loc:" — abbreviation matters.

## King audience (KINGLSS1.PIK?)

```
+--------------------------------+
|  [throne room background]      |
|  [tapestries with lion crest]  |
|  [seated KING in red coat]     |    [parchment scroll →]
|  [gray dog beside throne]      |
|                                |    Year of Our Lord
|                                |    1492
|                                |
|                                |    An Audience With
|                                |    The King of England
|                                |
|                                |    "For the greater glory
|                                |     of England, we dub thee
|                                |     Viceroy of the New
|                                |     World. Go and explore..."
+--------------------------------+
```

- King figure: red velvet coat, white stockings, jeweled buttons,
  brown hair, seated on ornate throne with lion-decorated arms
- Companion: gray wolfhound at throne base
- Background tapestries: red/yellow striped + lion/eagle crests
- Parchment scroll on RIGHT side, brown sepia text in cursive font
  (FONTKING) — this is the King's speech
- Top of scroll: smaller text "Year of Our Lord 1492" then "An
  Audience With The King of England"
- Body in italics: greeting + dub-as-Viceroy + go-explore

Substitutions: "King of England" varies by player nation (King of
France, King of Spain, Stadtholder of the Netherlands).

## Encyclopedia / PEDIA entry (Rain Forest example)

```
+--------------------- WOOD ----------------------+
|         ENCYCLOPEDIA OF COLONIZATION             |
|         (Rain Forest: Terrain Type)              |
|                                                  |
|  [terrain |  [unit] Farmer: 2  Plow/River: +1  Expert: x2  |
|  preview  |  [unit] Sugar Planter: 1 ...                   |
|  64×64]   |  [unit] Fur Trapper: 1 ...                     |
|           |  [unit] Lumberjack: 4 ...                     |
|           |  [unit] Ore Miner: 1 [icon] Minerals: +3 ...   |
|                                                  |
|         Move Cost: 3   Defense or Ambush Bonus: +75% |
|  ----------------------                          |
|  RAIN FOREST                                     |
|  This is Tropical jungle country that is good    |
|  for woodcutting, some sugar, and ore.           |
|                                                  |
|  Becomes Swamp (good for ore) if cleared.        |
+--------------------------------------------------+
```

- Title at TOP, green caps centered
- Subtitle in parens, green smaller
- Left: 64×64 mini-terrain preview with sample tile
- Middle column: small unit sprite + production stat lines
- "Move Cost: X  Defense or Ambush Bonus: +Y%" line
- Horizontal divider line
- Big yellow heading (the term being explained)
- Body green text with yellow words for emphasis
  (e.g. "good for woodcutting" appears in green; specific terms
  like "tropical jungle" stay green; the entry's main subject like
  "Becomes Swamp" stays green; emphasized values like "+75%" are
  yellow)

## Nation bonus / similar stand-alone PEDIA pages (ENGLAND example)

```
+--------------------- WOOD ----------------------+
|                                                  |
|                                                  |
|                    ENGLAND                       |
|                                                  |
|  To reflect the great flow of religious immigrants |
|  into English colonies, the English player requires |
|  only 2/3 the normal number of "Crosses" to       |
|  generate immigrants.                             |
+--------------------------------------------------+
```

- Centered green ENGLAND heading
- Body in green
- Quoted "Crosses" appears in YELLOW

The longer-form ENGLAND entry shows the FULL backstory paragraph with
multiple yellow-emphasis words: "religious strife", "Puritans",
"religious freedom".

## Colony screen (Jamestown example)

NOT just a text dump — has graphical sub-zones:

```
+-------- "Jamestown.  Spring, 1494.  Gold: 3000" --------+ <- title strip
|                                            |              |
|  [3×3 work-area showing real terrain       | [BIG MINIMAP]|
|   illustrations: trees, buildings, fields, |              |
|   river — like a proper postcard]          |              |
|                                            |              |
+------+---------------+--------------+------+--------------+
|cargo |               |              |        |building   |
|bays  | [100% (1) ♔] | No Ships In  |  +icons| icons      |
|      |               |    Port      |        | × 3       |
|      |  [ramparts +  |              |        |           |
|      |   bridge]     | [docks +     |        |           |
|      |               | crates]      |        |           |
+------+---------------+--------------+--------+-----------+
|[16 cargo type icons in horizontal strip with quantities below each]| Exit
+--------------------------------------------------------------------+
```

The work-area at top-left is a FANCY illustrated mini-scene of the
colony's surrounding tiles + buildings, NOT a tile grid. This is its
own complex render pipeline.

## Europe screen (London example)

```
+--- "London, England. Spring, 1493. Tax: 0% Gold: 3000" ----+
|                                                              |
|  [sky w/ clouds]                              RECRUIT ←btn   |
|                                              PURCHASE        |
|                                              TRAIN           |
|                                                              |
|                  [london skyline + dock buildings]           |
+--------+----------+----------+--------------------+----------+
|Expected| Bound For| No Ships |     [docks]       |          |
|  Soon  | New England |  In Port  |                |          |
|        |          |          | [crates × N]     |          |
|        |          |          |                  |          |
+--------+----------+----------+--------------------+----------+
|[16 cargo icons w/ ratio numbers below: 1/9, 6/8, 3/5, ...]   | Exit
+--------------------------------------------------------------+
```

- 3 right-side buttons: RECRUIT (yellow), PURCHASE (yellow), TRAIN (white)
- Center: 4 ship-status text panels (Expected Soon, Bound For X, No
  Ships In Port, [docks scene with crates])
- Bottom: 16 cargo icons in horizontal strip with HAVE/MAX ratio below
- "Exit" with red E circle, bottom-right corner

## Fonts observed

- **FONTINTR (9px)** — used for menu bar items (yellow caps), page
  titles ("Encyclopedia of Colonization"), main menu options
- **FONTSMAL (6px)** — body text on most screens (green), sidebar info
- **FONTKING (7px)** — King's speech in scroll (sepia/brown cursive)
- **FONTTINY (6px)** — has not been positively identified yet in any
  screenshot; likely used for status-bar (which doesn't exist) or
  cargo-strip number labels
- **FONT-NP (8px)** — Newspaper / report text (not seen yet)

## Color palette observations

| Element                    | Color       | Notes                       |
|----------------------------|-------------|-----------------------------|
| Body text on wood          | green       | mid-saturation, ~RGB(80,180,80) |
| Headings on wood           | yellow      | bright, ~RGB(255,220,80)    |
| Emphasis words on wood     | yellow      | same as headings            |
| Selected/highlighted row   | white       | pure RGB(255,255,255)       |
| Menu bar text (yellow)     | yellow caps | on black ~RGB(20,15,5)      |
| Sidebar info ("Spring 1492")| yellow     | bright                      |
| Sidebar status ("No Orders")| green      | mid-saturation              |
| Sidebar terrain ("(Sea Lane)")| dim cream | desaturated                 |
| Selected nation flag border| red         | thick                       |
| Selected difficulty card border | blue   | thick                       |
| King's parchment text      | brown sepia | on cream parchment          |
