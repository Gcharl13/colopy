# Event dispatch & the European-events cluster

Built 2026-05-30 from the byte-verified overlay decompile + a new RTLink thunk
cross-reference. Companion visual: **`docs/event_flow.html`** (open in a browser).

## How game events reach the player

```
Game turn loop (resident)
  -> end-of-turn processing
       -> per-turn European-politics check  (enqueues an event id when a condition holds)
  -> Report / Event dispatcher  func_0235D6   (resident, ENTER 0x1E, 2374 B)
       27-case switch on an event/screen id (0..0x1A); each case is gated on
       event-pending flags + game-state counters, then calls a page-06 handler
       through the overlay thunk table (lcall 0x191F:0x3AA/0x39C/.../0x348).
  -> page-06 European-event handler  -> changes game state + shows the GAME.TXT message
```

Flags / counters the dispatcher reads (verified):
- `[0x5381] bit 0x80` = **multiplayer flag** (set when >=2 human powers; disables the
  single-player auto events and shows "@MULTIREV" on a revolution attempt).
- `[0x5382] bits 1 / 2 / ...` = **event-pending flags** (each selects a handler case).
- `[0x53D0]` = **national rebel-sentiment %** (Sons of Liberty support); the
  independence gate compares it to **50** (`cmp [0x53D0],0x32` -> "@TOOTORY" below).
- `[0x539C]` = unit count; `[0x53D2]` = a secondary event counter.

## The "dispatch-only" cluster (no direct caller)

These handlers are **never called by name** in the overlay code (no call/jmp/thunk
targets them); they are reached only through the dispatcher above. This is why an
"exact firing turn" question is hard for *any* of them, not just the succession.

| Event (GAME.TXT) | Handler | Effect (plain) |
|---|---|---|
| @SUCCESSION | func_03C638 | War of Spanish Succession: strongest crown annexes weakest crown's colonies (single-player only) |
| @SEIZURE | func_03C5A8 | King's Royal Navy seizes your ship at sea |
| @SEIZURELAND | func_03C932 | Royal Army captures your land unit |
| @INVASION | func_03CDA2 | Royal Expeditionary Force lands near a colony |
| @TORYUPRISING | func_03CAC6 | Parliament arms Tory Militia near a colony |
| @INTERVENE | func_03D510 | Foreign Intervention Force arrives to help rebels |
| @FRIEND | func_03D948 | Foreign general/admiral joins (Lafayette, Cornwallis, de Ruyter) |
| @MOBILIZE | func_03E2EA | Your Veterans promoted to Continental Army |
| @INDEPENDENCE | func_03DE46 | Declaration of Independence; King dispatches the REF |
| @MERCENARIES | func_03E442 | King offers trained mercenaries for gold |
| @KINGBUY | func_03E162 | King adds units to the Royal Expeditionary Force |
| @REBELDOWN | func_03E844 | Tory propaganda: rebel sentiment falls |
| @DECLARE/@TOOTORY/@MULTIREV | func_03E984 | Declare-independence handler (gate = rebel % >= 50) |
| @KINGTAX | func_02F052 | King raises your tax rate by N% |
| @KINGLOSE | func_02F3A2 | King concedes; you win independence |

## Spanish Succession firing time -- conclusion

- **What:** single-player-only; ranks the 4 crowns by a weighted strength score;
  strongest annexes weakest; shows @SUCCESSION. (byte-verified)
- **Shown by:** dispatcher `func_0235D6`, the 27-case event/report switch. (traced
  via the thunk cross-reference: the dispatcher's `lcall 0x191F:0x364/0x356/0x348`
  reach the page-06 European handlers at 0x3BB18 / 0x3D326 / 0x3CE28).
- **Open last hop:** the end-of-turn code that *enqueues* the succession's event id
  (its exact schedule/probability) is not isolated -- the reseg function boundaries
  in this page are mis-segmented; pinning it needs a CFG rebuild of page 0x06.
- **NOT related to the player's independence path** -- independence is gated solely
  by rebel sentiment >= 50% (see `docs/RULINGS.md`, 2026-05-30).

## Tools (reusable cross-reference)

- `tools/rtlink/xref.py build` -> `thunk_xref.json` (target file-offset -> the
  `lcall window:off` thunk[s] that reach it; 1023 thunks -> 649 targets).
- `tools/rtlink/xref.py callers 0xNNNNN` -> prints the thunk + greps the image for
  caller sites of a target.
- `tools/rtlink/event_map.py` -> `event_emitters.json` (every GAME.TXT @key ->
  emitter function, with a `reachable` flag = thunk-reachable vs dispatch-only).
