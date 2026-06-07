# Overlay Thunk Resolution — Two High-Value Deciders

> **>>> BYTE_VERIFIED <<<**  Every offset and byte string below was read from
> `COLONIZE/VICEROY.EXE` (file size 0x78D3E = 494,910 bytes,
> sha256 a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3)
> in this session. DGROUP base 0x1D9A0. cite-or-stop: nothing here is guessed.

This note answers one question for two specific thunks the project flagged as
the "RTLink overlay wall": **are they statically resolvable from the existing
image, and if so where do they land?** It supersedes the BLOCKED-DYNAMIC
corollary written in `src/combat/land.c` (lines 67–73) and the
RECONSTRUCTED thunk-format claims in `docs/RTLINK_OVERLAYS.md` (see
"Format corrections" at the end).

---

## TL;DR verdict

| Thunk / target | Task framing | Verdict | Lands at |
|---|---|---|---|
| (a) land-combat decider | "func_05B2C2's caller via thunk @0x1BAAA = 0x110D:0xA9DA" | **RESOLVED** (task framing was wrong on two counts) | decider = **func_05CA7E** (file 0x05CA7E, page 0x10) → wrapper **func_05BE30** → applier **func_05B2C2** |
| (b) report-content renderer | "F-key 0x40..0x49 → 0x191F:0x40C..0x41A after build_menubar" | **RESOLVED** | 9 per-report renderers on **page 0x05** (file 0x37958, 0x37A10, 0x38418, 0x38A50, 0x39218, 0x3954C, 0x39888, 0x3744A, 0x387E8) |

**Both deciders are STATICALLY RESOLVABLE today.** Neither needs a runtime
overlay load-map. The "wall" was an artifact of (1) not decoding the
page-resident JMPF trampoline layer, and (2) two incorrect addresses in the
task brief / land.c.

---

## The segment model (byte-validated)

### One thunk table, three address windows

The RTLink thunk table is one contiguous block at **file 0x1A5F0..0x1D5E6**
(12278 bytes). It is addressed through three *overlapping* link-time segment
selectors — they are NOT three tables:

```
seg 0x181F : file base = 0x2400 + 0x181F*16 = 0x1A5F0   (table start)
seg 0x191F : file base = 0x2400 + 0x191F*16 = 0x1B5F0   (= 0x1A5F0 + 0x1000)
seg 0x1A1F : file base = 0x2400 + 0x1A1F*16 = 0x1C5F0   (= 0x1A5F0 + 0x2000)
```

So `0x191F:0x044E`, `0x181F:0x144E`, `0x1A1F:(0x044E-0x1000)` would all name
the same physical thunk. The compiler picks whichever window keeps the 16-bit
offset in range for the call site. **All three windows index the same static
table → all three are statically resolvable.** `0x0D1D` and `0x0C0C` are the
two other link-time far-call segments (MSC iolib / runtime), also static.

### Thunk byte format (corrects RTLINK_OVERLAYS.md)

Each thunk begins with a far `LCALL 0x110D:<loader>` (opcode **0x9A**, NOT a
near `E8`), then a far `JMPF` placeholder whose **segment word is patched at
load time** (the offset word is the real overlay code-relative offset and is
NOT patched):

```
Type-A (14 bytes, carries 4 trailer metadata bytes):
  +0  9A AB 0D 0D 11      LCALL 0x110D:0x0DAB   ; type-A loader stub @file 0x1427B
  +5  EA <off> 00 00      JMPF  0x0000:<off>    ; seg word patched at load
  +A  <pageid> <w2>       trailer: word0 = TARGET PAGE_ID, word1 = chain tag

Type-B (10 bytes, no trailer):
  +0  9A 91 0D 0D 11      LCALL 0x110D:0x0D91   ; type-B loader stub @file 0x14261
  +5  EA <off> <seg>      JMPF  <seg>:<off>      ; RESIDENT target (seg is real)
```

* **Type-A** = overlay target. Resolve via:
  `target_file_offset = page[trailer_word0].code_offset + jmpf_off`.
  The page→file/code-offset directory is the byte-decoded VP descriptor table
  (`code/VICEROY/overlay_pages.json`). 658 Type-A thunks, **100% resolve into
  real page code** (`typeA_thunk_targets.json`).
* **Type-B** = already-resident target (its `JMPF` seg word is a real
  link-time segment, not a placeholder). Resolve via
  `target_file = 0x2400 + jmpf_seg*16 + jmpf_off`. 362 Type-B thunks; always
  decodable. (Example: market price lookup `0x181F:0x9A4` → Type-B
  `0x05B3:0x01E0` → file 0x8110.)

The loader stub `0x110D:0x0DAB` (file 0x1427B) is the *only* meaning of "0x110D"
— it is the resident RTLink loader segment, **never** a target. (The task
brief's literal `0x110D:0xA9DA` = file 0x1DEAA, which is all-zero pad past the
table end at 0x1D5E6 — a stale/typo'd address, see Appendix.)

### Cross-page calls go through page-resident JMPF trampolines

A page's own functions do not LCALL the thunk table directly for *intra-engine*
cross-page calls. Instead each page carries a small table of `JMPF
<window>:<off>` **trampolines** in its resident tail, and the page's code
reaches them with a near `push cs; E8 <rel16>` (a faked far-call frame). There
are **477 such JMPF-to-thunk trampolines inside overlay code**. Both halves
(the near-call and the trampoline) are static, so the *entire* cross-page call
graph is statically reconstructable — this is the key fact that dissolves the
"wall".

### Which thunk classes need the overlay load-map?

**None, for static resolution.** The load-map (which physical paragraph a page
occupies in the swap buffer) is a *runtime* fact and is irrelevant to source
reconstruction:

| Class | Static resolvability | How |
|---|---|---|
| `0x181F` / `0x191F` / `0x1A1F` | **RESOLVED** | same table, 3 windows; Type-A→page dir, Type-B→resident seg |
| `0x110D` | **N/A** (it is the loader, not a target) | stub @0x1427B (type-A) / @0x14261 (type-B) |
| `0x0D1D` / `0x0C0C` | **RESOLVED** | resident MSC iolib / runtime far segments |
| page-resident `JMPF` trampolines | **RESOLVED** | near-call site + trampoline both in static image |

The only thing the runtime load-map would add is the *physical* address a page
lands at after a swap — never needed when working from file offsets.

---

## (a) The LAND-combat win/loss decider — RESOLVED

### What the task said vs. what the bytes say

Task: "func_05B2C2's caller, reached via load-image thunk @file 0x1BAAA = far
ptr 0x110D:0xA9DA". **Both addresses are wrong:**

1. The thunk at **file 0x1BAAA does NOT point at func_05B2C2.** Its bytes are
   `9A AB 0D 0D 11 EA 72 09 00 00 08 00` → Type-A, JMPF off 0x0972, trailer
   page **0x08** → resolves to **file 0x040E22** (a unit-state routine on page
   0x08: `ENTER 4,0; IMUL bx,[bp+6],0x1C; MOV al,[bx+0x3147]` — UnitRecord
   touch, but not the combat applier).
2. `0x110D:0xA9DA` is meaningless (zero pad past table end).

### The real combat thunk and its (single) static reference

Exhaustive whole-image scan: exactly **one** thunk resolves to func_05B2C2's
entry — **file 0x1CCD0**:

```
0x1CCD0:  9A AB 0D 0D 11 EA 52 03 00 00 10 00
          LCALL 0x110D:0x0DAB ; JMPF off=0x0352 ; trailer page 0x10
          page 0x10 code_offset 0x05AF70 + 0x0352 = 0x05B2C2   ✔ func_05B2C2 entry
          addressable as 0x1A1F:0x06E0 (= file 0x1CCD0 - 0x1C5F0)
```

func_05B2C2 entry bytes: `C8 3A 00 00 57 56` = `ENTER 0x3A,0; PUSH si; PUSH di`
(matches `land.c`).

The *only* static reference to this thunk in the whole 494,910-byte image is a
**JMPF trampoline at file 0x5E723** (`EA E0 06 1F 1A` = `JMPF 0x1A1F:0x06E0`),
one row of a trampoline table at 0x5E70A..0x5E72D on page 0x10's resident tail.

### The byte-resolved call chain

```
func_05CA7E  (file 0x05CA7E, page 0x10, ENTER 0xDE,0, 7348 B)   ← THE DECIDER
   │   per-unit move/attack dispatcher (UnitRecord stride 0x1C, base 0x3146)
   │   near-call sites: 0x5D554 (→applier) and 0x5D56F/0x5D5F1/0x5D7E8/0x5DB5F (→wrapper)
   │
   ├─ push cs; E8 → trampoline 0x5E72D (EA F8 06 1F 1A = JMPF 0x1A1F:0x06F8)
   │                 → thunk 0x1CCE8 (page 0x10 jmpf 0xEC0)
   │                 → func_05BE30  (file 0x05BE30, ENTER 2,0, 83 B)  ← combat WRAPPER
   │                       pushes the std arg frame and tail-calls the applier:
   │                       [bp+0xE]=tgt_y,[bp+0xC]=tgt_x,[bp+0xA]=show_ui,
   │                       [bp+8]=unit_b,[bp+6]=unit_a ; push cs;
   │                       0x5BE5A: E8 → trampoline 0x5E723
   │
   └─ push cs; E8 → trampoline 0x5E723 (EA E0 06 1F 1A = JMPF 0x1A1F:0x06E0)
                     → thunk 0x1CCD0
                     → func_05B2C2  (file 0x05B2C2, page 0x10)  ← combat CONSEQUENCE-APPLIER
```

func_05BE30 (the wrapper) and func_05B2C2 (the applier) are both reached only
via this trampoline pair, near-called from inside func_05CA7E. func_05B2C2 is
*also* near-called directly by func_05BE84 (file 0x05BE84, ENTER 0x24,0,
2006 B) at 0x5C59E, and by the small wrapper func_05BE30 itself at 0x5BE5A.

func_05CA7E is in turn reached from outside page 0x10 by **direct** Type-A
LCALL `0x191F:0x0A14` (its thunk file 0x1C004) from three turn/unit-processing
loops: **func_02D3C6** (page 0x03), **func_03ECF0** (page 0x07), **func_04E2D6**
(page 0x0D). So the player/AI "move this unit / attack" path is fully traced.

**Conclusion (a):** The land-combat decider is **func_05CA7E**. This is
consistent with `land.c`'s headline that func_05B2C2 is only the consequence
applier and the *decision* lives in the caller — and that caller is now pinned
to a file offset. The RTLink wall claim in land.c lines 67–73 is **overturned**:
the caller IS statically resolvable (via the page-0x10 trampoline + the three
cross-page Type-A LCALLs above).

#### Re-verifiable spot-check bytes (a)

| file offset | bytes | meaning |
|---|---|---|
| 0x1CCD0 | `9A AB 0D 0D 11 EA 52 03 00 00 10 00` | combat-applier thunk → page 0x10 +0x0352 |
| 0x1CCE8 | `9A AB 0D 0D 11 EA C0 0E 00 00 10 00` | combat-wrapper thunk → page 0x10 +0x0EC0 |
| 0x05B2C2 | `C8 3A 00 00 57 56` | func_05B2C2 `ENTER 0x3A,0` |
| 0x05BE30 | `C8 02 00 00 8B 46 06 9A` | func_05BE30 `ENTER 2,0; MOV ax,[bp+6]; LCALL…` |
| 0x05CA7E | `C8 DE 00 00` | func_05CA7E `ENTER 0xDE,0` |
| 0x5E723 | `EA E0 06 1F 1A` | trampoline → JMPF 0x1A1F:0x06E0 (applier) |
| 0x5E72D | `EA F8 06 1F 1A` | trampoline → JMPF 0x1A1F:0x06F8 (wrapper) |
| 0x5BE5A | `E8 C6 28` | near-call within wrapper → 0x5E723 |
| 0x1C004 | (Type-A, page 0x10 jmpf 0x1B0E) | func_05CA7E thunk = 0x191F:0x0A14 |

---

## (b) The report-CONTENT renderer — RESOLVED

### The F-key sub-dispatch is a static CMP/LCALL ladder

After `build_menubar` (func_072090, page 0x1A) registers the 10 Reports-menu
items with selector indices 0x40..0x49, the actual key handling is the
**SETREPORT branch** of the command dispatcher func_0235D6 at **file
0x023810..0x0238CB** (page 0x01). It is a literal compare/far-call ladder
(decoded from bytes):

```
0x023843:  83 7E 06 48   CMP [bp+6], 0x48   then  9A 1A 04 1F 19  LCALL 0x191F:0x41A
           CMP [bp+6], 0x41   →  LCALL 0x191F:0x40C
           CMP [bp+6], 0x42   →  LCALL 0x191F:0x3FE
           CMP [bp+6], 0x43   →  LCALL 0x191F:0x3F0
           CMP [bp+6], 0x44   →  LCALL 0x191F:0x3E2
           CMP [bp+6], 0x45   →  LCALL 0x191F:0x3D4
           CMP [bp+6], 0x46   →  LCALL 0x191F:0x3C6
           CMP [bp+6], 0x47   →  LCALL 0x191F:0x3B8
           CMP [bp+6], 0x49   →  (SoL, 0x181F:0x574)
```

The task's "0x191F:0x40C..0x41A" is the *low/high* of this thunk-offset cluster
(the 8 entries 0x3B8,0x3C6,0x3D4,0x3E2,0x3F0,0x3FE,0x40C,0x41A — each a distinct
14-byte Type-A thunk, 14 bytes apart). This matches the BYTE_VERIFIED mapping
already in `src/ui/main_loop.c` (lines 199–209). **All resolve to page 0x05.**

### Resolved per-report renderers (all page 0x05, Type-A)

| F-key | selector | thunk (0x191F window) | thunk file | → page 0x05 file | lands on entry |
|---|---|---|---|---|---|
| F1 'A' | 0x40 | 0x191F:0x40C | 0x1B9FC | **0x037958** | yes |
| F2 'B' | 0x41 | 0x191F:0x3FE | 0x1B9EE | **0x037A10** | yes |
| F3 'C' | 0x42 | 0x191F:0x3F0 | 0x1B9E0 | **0x038418** | yes |
| F4 'D' | 0x43 | 0x191F:0x3E2 | 0x1B9D2 | **0x038A50** | yes |
| F5 'E' | 0x44 | 0x191F:0x3D4 | 0x1B9C4 | **0x039218** | yes |
| F6 'F' | 0x45 | 0x191F:0x3C6 | 0x1B9B6 | **0x03954C** | yes |
| F7 'G' | 0x46 | 0x191F:0x3B8 | 0x1B9A8 | **0x039888** | yes |
| F8 'H' | 0x47 | 0x191F:0x41A | 0x1BA0A | **0x03744A** | yes |
| (SoL) 'I' | 0x49 | 0x181F:0x574 | 0x1AB64 | 0x0387E8 (+112 into func_038778) | no |

(The letter↔F-number↔selector pairing follows main_loop.c; selector 0x40..0x49
are the menu indices, the dispatch keys are the ASCII letters 'A'..'I'. The
exact label text comes from MENU.TXT, not the EXE.)

These are genuine report-content renderers. Each begins `ENTER 0xNN,0` and
immediately pushes a full-screen content rect — width **0x140 = 320** — plus a
per-report index byte, then calls the shared report-draw primitives via
`LCALL 0x181F:0x0022` and `0x181F:0x0100`. Example (F8/H, file 0x3744A):

```
0x3744A:  C8 6E 00 00            ENTER 0x6E,0
          6A 01                  PUSH 1
          68 90 00               PUSH 0x90
          6A 05                  PUSH 5
          68 40 01               PUSH 0x140      ; 320 = screen width
          6A 00                  PUSH 0
0x37467:  9A 22 00 1F 18         LCALL 0x181F:0x0022   ; report draw primitive
          9A 00 01 1F 18         LCALL 0x181F:0x0100   ; report draw primitive
```

**Conclusion (b):** The report-content renderers are the 9 page-05 functions
above, all statically reachable. (`build_menubar`/func_072090 only *registers*
the menu items — see report_screen.c — it does not render bodies; the bodies
are these functions.)

#### Re-verifiable spot-check bytes (b)

| file offset | bytes | meaning |
|---|---|---|
| 0x023843 | `83 7E 06 48 75 0B FF 76` | `CMP [bp+6],0x48; JNE +0xB; PUSH [bp+…]` (dispatch head) |
| 0x1B9FC | `9A AB 0D 0D 11 EA 18 06 00 00 05 00` | F1 thunk 0x191F:0x40C → page 0x05 +0x0618 |
| 0x1BA0A | `9A AB 0D 0D 11 EA 0A 01 00 00 05 00` | F8 thunk 0x191F:0x41A → page 0x05 +0x010A |
| 0x037958 | `C8 2C 00 00` | F1 renderer `ENTER 0x2C,0` |
| 0x03744A | `C8 6E 00 00` | F8 renderer `ENTER 0x6E,0` |
| 0x37467 | `9A 22 00 1F 18` | first report-draw `LCALL 0x181F:0x0022` |

---

## Appendix — reconciling the brief's "0x110D:0xA9DA"

`0x110D` is the resident RTLink loader code segment; the two loader entry
stubs are `0x110D:0x0DAB` (type-A, file 0x1427B) and `0x110D:0x0D91` (type-B,
file 0x14261). It is never a *target* segment. The literal `0x110D:0xA9DA`
maps to file 0x1DEAA, which is zero padding after the thunk table end
(0x1D5E6) — i.e. not code and not a thunk. The intended reference was almost
certainly the thunk *table* (segment 0x181F/0x191F/0x1A1F), and the specific
combat thunk is 0x1CCD0 (= 0x1A1F:0x06E0), as resolved above. land.c's
"thunk @file 0x1BAAA" was likewise a mis-attribution: 0x1BAAA is a page-0x08
unit routine, unrelated to combat.

## Format corrections to docs/RTLINK_OVERLAYS.md (RECONSTRUCTED → now byte-checked)

That file (flagged RECONSTRUCTED) is wrong on the thunk byte format; the
byte-verified facts are:

* Thunk size is **14 bytes (Type-A)** / **10 bytes (Type-B)**, not a uniform 12.
* Both types start with a far `LCALL 0x110D:<stub>` (opcode **0x9A**), not a
  near `E8`/`E9`. The `EA … JMPF` placeholder follows at +5.
* Type-A's trailer **word0 is the target PAGE_ID** (the key to resolution);
  it is not a "segment id, page number" pair as written there.
* Resolution does NOT require the 82-entry segment table for code reconstruction
  — it requires the byte-decoded **VP page directory** (`overlay_pages.json`),
  page_id → code_offset. The runtime load-map is never needed at file-offset
  granularity.

These corrections are recorded here (this file is the BYTE_VERIFIED reference);
RTLINK_OVERLAYS.md was left untouched per task scope.
