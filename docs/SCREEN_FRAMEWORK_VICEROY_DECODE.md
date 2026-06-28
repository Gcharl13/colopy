# SCREEN-VIEW FRAMEWORK — VICEROY.EXE byte-level decode

> **Mandate:** every claim cites a `VICEROY.EXE` file offset. Un-verifiable →
> **TBD** + blocker. DGROUP base **0x1D9A0**; static datum at DG offset `D` →
> file `0x1D9A0+D`. BSS/heap (DS ≥ 0x2CC6) values are runtime → TBD.

---

## 0. MAJOR CORRECTION — `0x181F:0x772` is NOT `enter_screen_view`

The brief named `enter_screen_view = 0x181F:0x772` and called `bx` a *screen-id*
dispatched into a modal loop. **The bytes refute this.** Resolved
(`tools/follow_thunk.py 0x181f 0x772`), the thunk lands in overlay page 29 at
file **0x077D5E**, whose entire code segment (code_offset 0x77990, size 1136 B =
0x77990–0x77E00) is an **error-reporting / assert module**:

- `0x077D5E` formats the screen-tag (`si=ax`, `di=bx`) into strings via the
  sprintf helper `0x077990` and conditionally logs (guarded by trace-level
  `[0x2476]`), referencing DGROUP strings **`"*ERRORS.DB"`** (DG+0x2592),
  **`"*MODULES.DB"`** (DG+0x259D).
- `0x077B10` (called from `0x077D5E`) builds the message
  **`Error "<…>" in module "<…>" data: <…>`** (DG+0x24CF/0x24D7/0x24E5) and
  **`Tried to allocate <…>`** (DG+0x24F0).

So at every cited call site the shape is an **error-exit tail**, e.g. colony
`0x025EE5`, europe `0x030DEB`, map `0x076871`, boot-menu `0x07661F`:

```
025ECB  lcall 0x191F:0x87A      ; error-condition probe (builds an error string,
                                ;   target 0x076AEC; emits via 0x1A1F:0xA94)
025ED3  or ax,ax / je 25EED     ; no error -> skip, return normally
025ED7  push 0; push 0; push 0; push 0
025EDF  mov ax,0xFFAD           ; ax = -83 (error data)
025EE2  mov dx,2
025EE5  mov bx,0x2C             ; bx = *error-context tag* (colony=0x2C)
025EE8  lcall 0x181F:0x772      ; LOG THE ERROR
025EED  retf
```

`bx` (0x2C colony, 0x2B europe, 0xD map, 0x2A boot-menu, 0x28/0x29/0x18…) is an
**error-context tag**, **not** a runtime dispatch key. There is **no single
`enter_screen_view(screen-id)` function.** (Tracker row 19's old premise is
corrected here.)

---

## 1. The real framework — an INLINED modal-loop template

Every full screen is its **own function** that contains a **byte-identical clone**
of one modal-loop skeleton. The *shared* parts are the RTLink input/pump thunks
(via segment `0x181F`) and a per-screen "running" sentinel global; the
*per-screen* parts (mouse hit-test, key handler, paint) are **near-call callbacks**
the loop hard-codes into its own `0x191F:` thunk-jump table. It is a template,
not a callee — so it is documented by its **canonical instance** (colony) with the
europe twin proving the skeleton is shared.

### Canonical instance — COLONY runner `func_02C5D4`, loop `0x02C85C`–0x02C932

Byte-verified (`scratchpad/disv.py 0x02C85C`):

```
LOOP TOP 0x02C85C:
02C85C  lcall 0x181F:0x470        ; frame/pump prologue (begin input frame)
02C861  sub ax,ax
02C863  lcall 0x181F:0x466        ; pump
02C868  lcall 0xC0C:6             ; read mouse / blit cursor -> dx:ax = cursor x,y
02C86D  mov [bp-0x18],ax          ; cursor x
02C870  mov [bp-0x16],dx          ; cursor y
02C873  cmp [0x7EC],0 / ...       ; (drag-offset bookkeeping -> [0x8D58..0x8D60])
02C88D  ... compares cursor vs [0x8D5A]/[0x8D5C] (last-handled point)
02C8A0  push cs; call 0x2CA37     ; <<< MOUSE callback (per-screen hit-test/handler)
02C8AA  add ax,0x14 ...           ; bump the "handled" threshold by 20px
EVENT/KEY:
02C8B7  lcall 0x181F:0xF6         ; event-pending? -> ax
02C8BC  or ax,ax / je 0x2C8DD     ; nothing waiting -> skip key dispatch
02C8C0  lcall 0x181F:0x3E0        ; <<< GET KEY -> ax = keycode
02C8C5  mov [bp-0x1A],ax
02C8C8  cmp [0x334],0 / jne ...   ; (modifier/state) -> maybe re-run mouse cb 0x2CA37
02C8D3  push [bp-0x1A]
02C8D7  push cs; call 0x2C9E2     ; <<< KEY callback (per-screen key dispatch)
TIMERS / SECONDARY:
02C8DD  cmp [0x344],0 ... call 0x2C9F1   ; per-screen periodic cb (when [0x7EE]==0)
02C8EF  cmp [0x7EC],0 ... lcall 0x181F:0x56 ; (drag/scroll) ; call 0x2CAE6 redraw
02C909  lcall 0x181F:0x9C        ; secondary input poll -> ax
02C910  or ax,ax / jne -> call 0x2CAE6      ; -> redraw
PAINT + YIELD:
02C91B  call 0x2C546             ; <<< PAINT/redraw callback (drives colony composer
                                 ;     func_028592 via dirty-region redraw)
02C91E  sub ax,ax
02C920  mov dx,[0x346]           ; running sentinel
02C924  lcall 0x181F:0x45C       ; yield / frame-pump (dx = sentinel)
EXIT TEST:
02C929  cmp [0x346],0            ; <<< running sentinel
02C92E  je 0x2C933               ;   == 0  -> EXIT
02C930  jmp 0x2C85C              ;   != 0  -> loop
EXIT 0x2C933:
02C933  push cs; call 0x2C9F1    ; final per-screen cb
02C939  lcall 0x181F:0x56        ; teardown
```

### EUROPE twin (proves the skeleton is cloned)

Reported byte-identical skeleton, `func` loop top **0x035CAE**, exit **0x035D73**:
same `0x181F:0x470`/`0x466`/`0xC0C:6` prologue, `0x181F:0xF6` event-pending,
`0x181F:0x3E0` get-key, `0x181F:0x45C` yield, with europe's own callbacks
(mouse `call 0x36949`, key `call 0x368B3`, paint `call 0x35AD0` → drives europe
paint `func_031E4C`) and its own running sentinel **`[0x9E38]`**
(`cmp [0x9E38],0; je 0x35D7D`). (Twin reported by trace; colony instance above is
the one I disassembled and byte-verified this pass.)

---

## 2. Shared verbs (resolved thunks) — the backbone every screen reuses

| Role | Thunk | Target / notes | Sites |
|------|-------|----------------|-------|
| **Get key** (blocking-ish) | **`0x181F:0x3E0`** | returns keycode in `ax`. ESC = `0x1B`: explicit in map-options `cmp ax,0x1B; je exit` @0x07010B | 17 |
| **Event-pending** | **`0x181F:0xF6`** | `or ax,ax; je` skips key dispatch when none waiting | 15 |
| **Mouse rect hit-test** | **`0x181F:0x3CA`** | push x,y,w,h → returns hit flag; used inside per-screen hit-test cbs (e.g. colony widget sweep 0x0299D2–0x029A52) | 22 |
| **Yield / frame-pump** | **`0x181F:0x45C`** | per-iteration; `dx` = running sentinel | 14 |
| **Frame prologue** | **`0x181F:0x470`** + **`0x181F:0x466`** | begin-input-frame / pump | — |
| **Read mouse + cursor blit** | **`0xC0C:6`** | returns cursor x,y in dx:ax | — |
| **Secondary input poll** | **`0x181F:0x9C`** | returns nonzero → triggers redraw | — |
| **Present / blit** | **`0x181F:0xE2`** (file 0x00DB3A) | generic screen blit | 85 |
| **Begin-frame / clear** | **`0x181F:0xC22`** (file 0x00BC06) | used at composer starts | 8 |
| **Error-condition probe** | **`0x191F:0x87A`** (file 0x076AEC) | the error-string builder behind the §0 tails | 7 |
| **Error log** | **`0x181F:0x772`** (file 0x077D5E) | the assert/error logger — *not* a screen runner | 11 |

---

## 3. How a screen dispatches mouse / key / paint (no fn-ptr args)

Callbacks are **not parameters**. Each screen's loop hard-codes **near-calls into
its own RTLink thunk-jump table** (`ljmp 0x191F:0xNNNN` stubs that resolve to the
screen's handlers):

- **Colony**: mouse `call 0x2CA37` → `0x191F:0x69C` → `func_02861C`; key
  `call 0x2C9E2` → `0x191F:0x5D0` → `func_02BC72`; paint `call 0x2C546`
  (dirty-region redraw, internally runs colony composer `func_028592` =
  `0x191F:0x648` → 0x2CA14).
- **Europe**: mouse `call 0x36949`; key `call 0x368B3`; paint `call 0x35AD0`
  (runs europe paint `func_031E4C` = `lcall 0x191F:0x0DD4`).

The **mouse hit-test** is reached only when the cursor moved past a threshold
(colony tracks last-handled point in `[0x8D5A]/[0x8D5C]`, bumps by 0x14=20px each
hit @0x2C8AA). Inside the per-screen hit-test, widgets are tested with the shared
rectangle thunk `0x181F:0x3CA`.

---

## 4. How a screen EXITS

Each screen owns a **"running" sentinel global**; the loop's tail compares it to 0:

| Screen | Sentinel | Exit test | Loop top |
|--------|----------|-----------|----------|
| Colony | **`[0x346]`** | `cmp [0x346],0; je 0x2C933` @**0x2C929** | 0x2C85C |
| Europe | **`[0x9E38]`** | `cmp [0x9E38],0; je 0x35D7D` @**0x35D73** | 0x35CAE |

A screen's key/mouse handler zeroes the sentinel to exit (e.g. on ESC, or a "done"
button). **ESC** itself is a normal keycode `0x1B` returned by `0x181F:0x3E0`; the
per-screen key callback decides whether ESC clears the sentinel. The map-options
sub-loop `func_06FE1C` shows the explicit pattern:
`lcall 0x181F:0x3E0; cmp ax,0x1B; je <exit>` @0x07010B.

After the loop the screen runs a teardown cb (colony `call 0x2C9F1`) and
`0x181F:0x56`, then `retf`s to its caller (the menu/turn driver that invoked it).

---

## 5. The map screen

The map uses the **same input thunks** (`0x181F:0x3E0` key, `0x181F:0xF6`
event-pending, `0x181F:0x3CA` mouse hit-test) but a **structurally different**
loop (it is the persistent in-game view, not a modal sub-screen). Sub-loops live
among `0x06B43D` / `0x06E72F` / `func_06FE1C`. **TBD: the exact top-level map
main-loop function start** — blocker: the map overlay page has several get-key
sites and the function index is sparse there; needs a dedicated trace of the
`func_06B398` region. The map's error-tail tag is `bx=0xD` @0x076871 (§0).

---

## 6. Residual / TBD

- **Map main-loop function start** — TBD (blocker §5).
- **Per-screen sentinel write sites** (which handler zeroes `[0x346]`/`[0x9E38]`,
  i.e. the exact "Return to map / done" button) — TBD (inside the key/mouse cbs
  `func_02BC72`/`func_02861C`); the *exit mechanism* (sentinel→0) is verified, the
  *trigger* is per-screen and not traced this pass.
- **Runtime sentinel values** `[0x346]`/`[0x9E38]` are runtime → TBD by rule;
  only the locations and the test are static (verified above).
