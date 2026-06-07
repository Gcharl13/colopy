# Debug menu / cheat features — byte-traced

Built 2026-05-30 from a user question ("SPRING = make all nations human", debug
menu key, treasure = 0 gold). All offsets cite `raw/COLONIZE/VICEROY.EXE`.
DGROUP rule: file = handle + 0x1D9A0.

## The debug command set

The debug commands are GAME.TXT-keyed cases dispatched inside **func_0235D6**
(the master command dispatcher, file 0x0235D6, page 0x01). Each is invoked via
`lcall 0x181F:0x998` with two string keys in ax/bx (the suffix + the "DEBUG"
prefix). Key strings live in the DGROUP cluster handles 0x0B0A..0x0B7F:

| command | keys | effect |
|---|---|---|
| DEBUGCREATE / CREATE2 | 0x0B1E/0x0B10 | create a unit (by type — see treasure note) |
| DEBUGCSHIP | 0x0B2B | create a ship |
| DEBUGFOREIGN / FOREIGN2 | 0x0B37/0x0B45 | foreign-power debug |
| DEBUGSETVIEW | 0x0B54 | reveal / set map view |
| **DEBUGSETHUMAN** | 0x0B62 | **make a chosen power human-controlled** (the "SPRING" feature) |
| DEBUGSETAUTO | 0x0B71 | hand a power back to the AI |
| DEBUGFORCED | 0x0B03 | forced action |
| DEBUGSETEUROPE | 0x0AE3 | jump to Europe screen |
| DEBUGSETREPORT | 0x0AF3 | force a report |
| DEBUGFINDCITY / NOCITY | 0x0A51/0x0A5A | colony locate |
| DEBUGMEMORY | 0x0A43 | memory readout |

(Adjacent non-debug menu strings: GAMEOPTIONS 0x0A61, COLONYOPTIONS 0x0A6D,
SOUNDOPTIONS 0x0A7B, OPTIONS 0x0ABB, RETIRE 0x0AC9, DOS 0x0AD0.)

The literal word "SPRING" is **not** in the EXE (NAMES.TXT only has the season
"Spring"), so it is a typed enable-trigger / the user's term, not a stored key.
The functional feature it names is **DEBUGSETHUMAN**.

## DEBUGSETHUMAN — byte-exact (this is "SPRING")

Handler at file 0x023D06..0x023D58:

```
023D06  mov [0x1F5E], 3                 ; debug sub-mode
023D0C  lea bx,[0x0B6B] ("DEBUG")
023D10  lea ax,[0x0B62] ("SETHUMAN")
023D16  lcall 0x181F:0x998              ; run debug command -> ax = chosen power+1 (0 = cancel)
023D1B  mov [bp-2], ax ; or ax,ax; jz cancel ; dec ax -> selected power index
023D29  mov [bp-0xA], 0                 ; i = 0
023D2E  imul bx,[bp-0xA],0x34           ; bx = i * 0x34   (AIPersonality stride; base 0x540E)
023D32  mov byte [bx+0x543F], 1         ;   controller[i] = 1 (AI)        -- loop body
023D37  inc [bp-0xA]; cmp [bp-0xA],4; jl 0x36BE   ; for i in 0..3 -> ALL powers set to AI
023D46  imul bx,[bp-2],0x34             ; bx = selected * 0x34
023D4A  mov byte [bx+0x543F], 0         ; controller[selected] = 0 (HUMAN)
023D52  mov [0x5398], ax               ; chosen-nation global = selected
023D55  mov [0x5394], ax               ; debug/active power = selected
023D58  mov [0x5396], ax
```

**Mechanism:** the **controller byte at `0x543F + power*0x34`** (AIPersonality
record +0x31) is `0 = human`, `1 = AI`. SETHUMAN sets every power to AI, then the
chosen power to human, and points the active-power globals at it. This is the
SAME controller flag whose `==0` (human) gate drives the starting-gold ladder
(RULINGS 2026-05-30) — cross-consistent. DEBUGSETAUTO is the inverse write.

So "make any nation human-playable" = pick a power, SETHUMAN flips its controller
to 0; repeat to hot-seat between nations.

## Why a debug-created treasure has 0 gold

`@CASHTREASURE` (GAME.TXT) = *"Treasure sold to foreign agents for {%NUMBER0$}."*
`%NUMBER0` is read from the treasure unit's stored **gold-amount field** at
cash-in time. The debug **CREATE** command (`lcall 0x181F:0x998` with the
CREATE/DEBUG keys) spawns a unit **by type only** — it sets type/owner/position
and nothing else. It never rolls or writes the treasure's gold value. In normal
play that value is assigned solely by the lost-city-rumor / burial-mound treasure
generator (a `random_int` roll, cf. the CHIEFKILL native-raze formula family).

**Result:** a debug-spawned treasure train carries amount = 0, so cashing it
reports "sold for 0." This is expected — debug-created units come blank; the
amount is not a property of the unit *type*, it's rolled by the event that
normally creates the treasure. (Byte-pinning the exact amount field offset +
the LCR generator write site is the open follow-up.)

## Open item — the keystroke that OPENS the debug menu

The debug commands are reached when func_0235D6 is entered with the matching
command code in `[bp+6]`. That code is produced UPSTREAM by the keyboard/menu-bar
input handler, which is **not** in the page-01 dispatcher (no `int 0x16` there —
key reads go through a resident helper). The exact opening key combination is
therefore **not yet byte-pinned**; tracing the keyboard-scancode → command map
(and any debug-enable flag the typed trigger sets) is the next step. Not guessed
here, per the project's cite-or-stop rule.
