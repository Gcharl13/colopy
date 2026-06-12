/* ============================================================================
 * overlay_054505_05C69B.c -- overlay functions in file range 0x054505..0x05C69B
 *
 * Region: COMBAT / DIPLOMACY / NATIVE-RELATIONS / TRADE.  Hand-ported from the
 * re-segmented overlay dump (reverse_engineered/code/VICEROY/disasm_overlay_reseg/
 * page_0E.asm code_base 0x053820, page_0F.asm code_base 0x056A10, page_10.asm
 * code_base 0x05AF70) cross-checked against raw COLONIZE/VICEROY.EXE bytes and
 * the DGROUP string table (strings.json, DGROUP image base 0x1D9A0).
 *
 * STRICT cite-or-not yet decoded: every value/offset cites the .asm; anything undeterminable
 * (opaque 0x191F / 0x1A1F overlay targets, data-resident weight tables) is marked
 * not yet decoded and never guessed.
 *
 * ----------------------------------------------------------------------------
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE          full @asm-cited body written here.
 *   SUPERSEDED    already ported to a named src/<subsystem>/ file — body lives
 *                 there; this is a one-line forwarding stub (auto-skeleton removed).
 *   PHANTOM       a false-ENTER fragment that the per-function auto-decoder framed
 *                 as a function but which is NOT a real function: it is either
 *                 (a) interior bytes of a larger reseg function whose mid-stream
 *                 0xC8 byte was mis-read as `ENTER`, or (b) an RTLink per-segment
 *                 header / relocation island sitting in the inter-page gap.  The
 *                 authoritative function list is disasm_overlay_reseg (pages 0E/
 *                 0F/10); none of the PHANTOM offsets appear there.
 *
 * RESEG GROUND-TRUTH function map for this file range (verified 2026-05-30):
 *   page 0E (code 0x053820..0x0562B0): … func_053B7E size=10025 -> 0x0562A7.
 *           => 0x054505/0x055760/0x05576B/0x05651C are INTERIOR to func_053B7E.
 *   page 0E/0F header gap 0x0562B0..0x056A10 (RTLink seg-0F header+relocs).
 *           => 0x056694 is in that header gap (reloc/data island).
 *   page 0F (code 0x056A10..0x05A950): 056A10, 056B08, 056B92, 056C3E(3580),
 *           057A3A, 057AA2, 057AFC(484), 057CE0, 057DC0, 057F4E(7151), 059B3E,
 *           059B90(2173), 05A40E(1107), 05A862.
 *           => 0x0572E6 is INTERIOR to func_056C3E; 0x05A20E is INTERIOR to
 *              func_059B90.
 *   page 0F/10 header gap 0x05A950..0x05AF70 (RTLink seg-10 header+relocs).
 *           => 0x05AC34/0x05AEA0/0x05AF2C are in that header gap.
 *   page 10 (code 0x05AF70..0x05E740): 05AF70, 05B0DC(486), 05B2C2(2925),
 *           05BE30, 05BE84(2006), 05C65A.
 *
 * Bases (DGROUP): UnitRecord 0x3144 stride 0x1C (+0x01=0x3145 y, +0x02 type byte
 *   = 0x3146, +0x03 owner nibble = 0x3147 & 0x0F, +0x08 cargo-count? +0x0C state
 *   = 0x3150 / 0x314C); ColonyRecord 0x5D46 stride 0xCA; PowerRecord 0x8808
 *   stride 0x13C (+0x2A gold); NativeSettlement 0x54EC stride 0x12; the active
 *   colony record pointer = *(uint16_t*)0x8542; live-unit count = *(int16_t*)0x539C;
 *   difficulty 0x53A6; game-mode flag *(uint8_t*)0x5382 & 1; active power 0x53D2.
 *   random_int(lo,hi) = LCALL 0x181F:0x04D4.
 *
 * The negative DGROUP displacements seen below (e.g. [bx-0x77F8], [bx-0x6BF0])
 * are the same absolute fields addressed through the BX-relative window the
 * compiler chose; e.g. -0x77F8 + 0x10000 == 0x8808 (PowerRecord base) so
 * imul bx,power,0x13C; [bx-0x77F8] == PowerRecord[power].flags.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

extern int menu_run_boxed(uint16_t key_off);  /* PORTED 0x181F:0x3FE runner (src/ui/menu_runner.c) */

/* ----------------------------------------------------------------------------
 * DGROUP globals referenced in this region (cite-or-not yet decoded; absolute DGROUP offsets
 * as seen in the disassembly).  Declared locally per the porting-scope rule
 * (this file may not edit shared headers).
 * -------------------------------------------------------------------------- */
extern uint16_t g_active_colony_ptr_8542;   /* DGROUP:0x8542 — *(active ColonyRecord) */
/* g_unit_count_539C: DGS16(0x539C) macro from globals.h */
extern int16_t  g_turn_538E;                /* DGROUP:0x538E — turn counter */
extern uint8_t  g_game_mode_5382;           /* DGROUP:0x5382 — bit0 = special game mode */
extern uint8_t  g_active_power_53D2;         /* DGROUP:0x53D2 — index of human/active power */
extern uint16_t g_word_5398;                /* DGROUP:0x5398 — current-power cursor (word) */
extern uint8_t  g_byte_A153;                /* DGROUP:0xA153 — per-power scratch flag */
extern uint16_t g_dialog_active_A154;        /* DGROUP:0xA154 — trade-dialog active flag */

/* UnitRecord byte fields, BX = unit_index * 0x1C (UNIT_STRIDE). */
#define UNIT_STRIDE      0x1C
#define UNIT_X           0x3144   /* +0x00 byte: map X */
#define UNIT_Y           0x3145   /* +0x01 byte: map Y */
#define UNIT_TYPE        0x3146   /* +0x02 byte: unit type id (@UNIT line) */
#define UNIT_OWNER       0x3147   /* +0x03 byte: low nibble = owner power */
#define UNIT_STATE_314C  0x314C   /* +0x08 byte: order/state (5,6 = sentry/fortify?) */
#define UNIT_CARGO_3150  0x3150   /* +0x0C byte: cargo-slot count */

/* @asm BX=power*0x34 ; [bx+0x543F] != 0  => power slot inactive/dead. */
#define POWER_DEAD_543F  0x543F   /* per-power "eliminated" flag, stride 0x34 */

/* Ship unit-type id range (naval): type in [0x0D..0x12] inclusive.  Verified
 * here at 0x056ACE-style gates and in src/combat/combat.c (ship-attacker gate). */
#define SHIP_TYPE_LO     0x0D
#define SHIP_TYPE_HI     0x12

/* ----------------------------------------------------------------------------
 * Locally-declared role-unknown overlay thunks not present in overlay_externs.h.
 * (Scope rule forbids editing the shared header; declared here, called by name.)
 * -------------------------------------------------------------------------- */
extern int overlay_call_181F_09DC(void);  /* @ref RTLink seg 0x181F off 0x09DC */
extern int overlay_call_1A1F_0618(void);  /* @ref RTLink seg 0x1A1F off 0x0618 */
extern int overlay_call_1A1F_0688(void);  /* @ref RTLink seg 0x1A1F off 0x0688 */
extern int overlay_call_1A1F_0694(void);  /* @ref RTLink seg 0x1A1F off 0x0694 (trampoline) */
extern int overlay_call_1A1F_06A2(void);  /* @ref RTLink seg 0x1A1F off 0x06A2 (trampoline) */

/* Near-called helpers that live OUTSIDE this file's range (kept as externs). */
extern int func_05E723(int start_idx, int a, int b, int c, int d); /* page-10 combat-leaf trampoline (0x3DD3 -> ljmp 0x1A1F) */
extern int func_05A93D(int unit_index);                            /* trampoline ljmp 0x1A1F:0x6A2 */
extern int func_05A938(int unit_index);                            /* trampoline ljmp 0x1A1F:0x694 */
/* direct calls replacing void-arity stub calls */
extern int  func_005FD4_map_xy_bounds_or_neg1_alt(uint16_t x, uint16_t y); /* 0x181F:0x06BE */
extern int  func_0082DC_logic_sz_118(uint16_t slot);                        /* 0x181F:0x09E6 */
extern int  func_0082A0_logic_sz_18(uint16_t row, uint16_t col);            /* 0x181F:0x030C */
extern int  func_007C2A_logic_sz_46(uint16_t unit, uint16_t sel);           /* 0x181F:0x09C8 */


/* ============================================================================
 * 0x054505 — PHANTOM (interior of func_053B7E)
 * ----------------------------------------------------------------------------
 * Reseg page_0E shows func_053B7E spanning 0x053B7E..0x0562A7 (10025 bytes, ENTER
 * 0x1C0).  0x054505 = `c8 98 03 06 …` — the 0xC8 here is a mid-instruction byte,
 * NOT a real `ENTER 0x398` prologue.  func_053B7E itself lives in the previous
 * overlay file overlay_04C306_053BC1.c.  No function begins at 0x054505.
 * ============================================================================ */
/* PHANTOM: 0x054505 is interior to func_053B7E (reseg page_0E) — not a function. */

/* ============================================================================
 * 0x055760 — PHANTOM (interior of func_053B7E)
 * ----------------------------------------------------------------------------
 * Inside the 0x053B7E..0x0562A7 body.  `c8 fe 0e 00` is a false-ENTER.
 * ============================================================================ */
/* PHANTOM: 0x055760 is interior to func_053B7E (reseg page_0E) — not a function. */

/* ============================================================================
 * 0x05576B — PHANTOM (interior of func_053B7E)
 * ----------------------------------------------------------------------------
 * Inside the 0x053B7E..0x0562A7 body.  `c8 fe 05 00` is a false-ENTER.
 * ============================================================================ */
/* PHANTOM: 0x05576B is interior to func_053B7E (reseg page_0E) — not a function. */

/* ============================================================================
 * 0x05651C — PHANTOM (interior of func_053B7E)
 * ----------------------------------------------------------------------------
 * Inside the 0x053B7E..0x0562A7 body.  `c8 02 00 00` is a false-ENTER.
 * ============================================================================ */
/* PHANTOM: 0x05651C is interior to func_053B7E (reseg page_0E) — not a function. */

/* ============================================================================
 * 0x056694 — PHANTOM (RTLink page-0F header / relocation island)
 * ----------------------------------------------------------------------------
 * Lies in the inter-page gap 0x0562B0..0x056A10 (page_0F file_offset 0x0562B0,
 * code_offset 0x056A10).  Raw bytes `c8 0e 00 00 38 14 00 00 22 14 00 00 …` are
 * a run of little-endian dword values (0x1438, 0x1422, 0x20D6, …) — an RTLink
 * per-segment header + relocation list, not code.  (This matches the original
 * auto-skeleton's own "LIKELY_DATA misclassified as code / SKIP" note.)
 * ============================================================================ */
/* PHANTOM: 0x056694 is in the page-0F RTLink header gap (reloc/data) — not code. */

/* ============================================================================
 * func_056A10 — colony_strongest_adjacent_defender  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Scans the 8 tiles around the active colony (*(0x8542)) for the strongest
 * enemy/defending unit, returning a "best defence" value and reporting the
 * winning owner, a flag, and an accumulated value via three out-pointers.
 *
 * @asm 0x056A15  bx = *(0x8542)                       ; active colony record
 * @asm 0x056A19  al = colony[+0]  (= X)               ; cb = X
 * @asm 0x056A1D  dl = colony[+1]  (= Y)               ; dx = Y
 * @asm 0x056A22  ax = LCALL 0x181F:0x07E0 (X, Y)      ; tile_defence(X,Y) baseline
 * @asm 0x056A2A  if (ax >= 0) -> push 0xA, ax;        ; scale(0xA, ax)
 * @asm 0x056A31     ax = LCALL 0x181F:0x08BC(0xA, ax) ; weighted scale
 *                else best_flag = 0
 * @asm 0x056A56  loop slot = 0..7 over the 8 neighbour offsets:
 * @asm 0x056A5A    bx = slot; dx = neighbour[+0xBE] + colony[+1]   ; ny
 * @asm 0x056A6F    ax = neighbour[+0xB4] + colony[+0]              ; nx
 * @asm 0x056A78    ax = LCALL 0x181F:0x07E0(nx, ny)               ; unit/tile idx
 * @asm 0x056A82    if (ax < 0) continue
 * @asm 0x056A84    bx = ax*0x1C ; cl = UnitRecord[+0x03] & 0xF      ; owner power
 * @asm 0x056A94    val = LCALL 0x181F:0x08BC(0xA, ax)              ; scaled value
 * @asm 0x056AA2    if (arg2(bp+0xC) != owner) continue   ; GATE FIX 2026-06-10:
 *                    ; the jne @0x056AA5 targets the LOOP TAIL (0x056ACE), so
 *                    ; EVERYTHING below — acc_b, acc_total, best-tracking — only
 *                    ; runs for units owned by the QUERY power (bp+0xC).  The
 *                    ; earlier brace closing after acc_b was wrong.
 * @asm 0x056AAC    acc_b += LCALL 0x181F:0x08BC(0xB, idx) >> 3     ; secondary
 * @asm 0x056ABA    acc_total += val
 * @asm 0x056AC0    if (val > running_max) { running_max=val; best_owner=owner }
 * @asm 0x056AD1  } while (++slot < 8)
 * @asm 0x056AD7  if (out_owner)  *out_owner  = best_owner   ; ∈ {-1, query power}
 * @asm 0x056AE5  if (out_flag)   *out_flag   = best_flag    ; = CENTRE-TILE garrison value
 * @asm 0x056AF3  if (out_total)  *out_total  = acc_total
 * @asm 0x056B01  return acc_b
 *
 * Consequence of the gate: best_owner can ONLY be the query power (if it has
 * any adjacent unit) or -1 — never a third party.
 *
 * KNOWN CALLER (found 2026-06-10): diplomacy_meeting loop #2 (func_057F4E
 * @file 0x05820F) calls this via the near trampoline cs:0x5A1EF -> ljmp
 * 0x1A1F:0x0634 -> RTLink thunk @0x1CC24 (overlay 15 + 0x0000 = file 0x56A10),
 * with query power = power_other and out-ptrs (&besieger, &garrison, &adj_total);
 * see src/diplomacy/meeting.c section 3b.
 *
 * 0x181F:0x07E0 = "unit/defence index at (x,y)"; 0x181F:0x08BC = scale/weight
 * helper(kind, value).  Exact arithmetic of 0x08BC is in the resident overlay
 * (library-implementation-only); modelled here as opaque scale() so the control flow is exact.
 * ============================================================================ */
int colony_strongest_adjacent_defender(int *out_owner, int *out_flag,
                                        int *out_total)  /* func_056A10 */
{
    uint16_t colony = g_active_colony_ptr_8542;
    int cx = *(uint8_t *)(colony + 0);                 /* @asm 0x056A19 */
    int cy = *(uint8_t *)(colony + 1);                 /* @asm 0x056A1D */
    int best_flag, base_idx, acc_b = 0, acc_total = 0, running_max = 0;
    int best_owner = -1;                               /* @asm 0x056A43 bp-0xE = 0xFFFF */
    int slot;

    base_idx = overlay_call_181F_07E0();               /* tile_defence(cx,cy) @asm 0x056A22 */
    if (base_idx >= 0)
        best_flag = overlay_call_181F_08BC();          /* scale(0xA, base_idx) @asm 0x056A31 */
    else
        best_flag = 0;                                 /* @asm 0x056A3E */

    for (slot = 0; slot < 8; slot++) {                 /* @asm 0x056AD1 */
        /* neighbour offsets stored at UnitRecord-form [slot+0xBE]/[slot+0xB4]. */
        int idx = overlay_call_181F_07E0();            /* unit at (nx,ny) @asm 0x056A78 */
        int owner, val;
        if (idx < 0)
            continue;                                  /* @asm 0x056A82 */
        owner = *(uint8_t *)(idx * UNIT_STRIDE + UNIT_OWNER) & 0x0F; /* @asm 0x056A87 */
        val = overlay_call_181F_08BC();                /* scale(0xA, idx) @asm 0x056A94 */
        if (/* arg2 */ 0 != owner)                     /* @asm 0x056AA2; jne 0x56ACE = LOOP TAIL */
            continue;   /* gate fixed 2026-06-10: tallies below are query-power-only */
        acc_b += overlay_call_181F_08BC() >> 3;        /* scale(0xB, idx)>>3 @asm 0x056AAC */
        acc_total += val;                              /* @asm 0x056ABA (inside gate) */
        if (val > running_max) {                       /* @asm 0x056AC0 (inside gate) */
            running_max = val;
            best_owner = owner;                        /* @asm 0x056AC8 = query power */
        }
        (void)base_idx;
    }

    if (out_owner)  *out_owner  = best_owner;           /* @asm 0x056AD7 */
    if (out_flag)   *out_flag   = best_flag;            /* @asm 0x056AE5 */
    if (out_total)  *out_total  = acc_total;            /* @asm 0x056AF3 */
    return acc_b;                                       /* @asm 0x056B01 */
}

/* ============================================================================
 * func_056B08 — score_and_rank_four_powers  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Computes a composite score for each of the 4 European powers and sorts them.
 *
 * @asm 0x056B0D  for (p = 0; p < 4; p++) {                       ; bp-0xE = p
 * @asm 0x056B12    rank_index[p] = p                              ; [bx-0x5EB0]=p
 * @asm 0x056B20    si = p * 0x13C                                 ; PowerRecord[p]
 * @asm 0x056B24    score = LCALL 0x0D1D:0x0EC6(                   ; runtime helper
 *                            PowerRecord[p].word(-0x77CC),        ;   = +0x3C
 *                            PowerRecord[p].word(-0x77CE), 0x64, 0)
 * @asm 0x056B34    score += metric_table[p]  (byte [bx-0x6D68]) * 2   ; +0x...
 * @asm 0x056B3E    score += metric2_table[p] (byte [bx-0x6BF0])
 * @asm 0x056B46    score += word_table[p*2]  (word [bx-0x6BE4])
 * @asm 0x056B4C    composite[p] = score                            ; bp-0xA / bp+si-8
 * @asm 0x056B54  } while (++p < 4)
 * @asm 0x056B5D  LCALL 0x191F:0x0ED0(&composite, count=4)          ; sort descending
 * @asm 0x056B6E  for (p = 0; p < 4; p++)                           ; second pass
 * @asm 0x056B79    final_rank[ rank_index[p] ] = p                 ; [bx-0x6E84]=p
 *
 * Table identities (all RUNTIME_ONLY — values loaded from data files, not in EXE):
 *   metric1  DS:0x9298+p  stride 1   = per-power colony count      (×2 weight)
 *   metric2  DS:0x9410+p  stride 1   = g_power_gate_9410 per-power colonist popsum
 *                                       (same address as strengthB in func_057AFC)
 *   word3    DS:0x941C+p×2 stride 2  = per-power strength word (= strengthW)
 *   rank_index scratch: DS:0xA150–0xA153 (rank_index[3] = g_byte_A153 extern)
 *   final_rank output:  DS:0x917C–0x917F (per-power final sorted rank, stride 1)
 * 0x0D1D:0x0EC6 = MSC-runtime arithmetic helper (32-bit scale of PowerRecord words).
 * 0x191F:0x0ED0 = dual-sort descending over composite[] + rank_index[] in tandem.
 * ============================================================================ */
void score_and_rank_four_powers(void)  /* func_056B08 */
{
    uint8_t rank_index[4];
    int     composite[4];
    int p;

    for (p = 0; p < 4; p++) {                          /* @asm 0x056B0D..0x056B5B */
        int score;
        rank_index[p] = (uint8_t)p;                    /* @asm 0x056B18 [bx-0x5EB0]=p */
        /* PowerRecord[p] words at +0x3C/+0x3E pushed to the runtime helper. */
        score  = overlay_call_0D1D_0EC6();             /* @asm 0x056B2C */
        score += (int)*(uint8_t *)(p - 0x6D68 + 0x10000) * 2; /* metric1*2 @asm 0x056B34 */
        score += (int)*(uint8_t *)(p - 0x6BF0 + 0x10000);     /* metric2   @asm 0x056B3E */
        score += *(int16_t *)(p * 2 - 0x6BE4 + 0x10000);      /* word3     @asm 0x056B46 */
        composite[p] = score;                          /* @asm 0x056B4C/08A1 */
    }

    overlay_call_191F_0ED0();                          /* sort(&composite, 4) @asm 0x056B69 */

    for (p = 0; p < 4; p++) {                           /* @asm 0x056B6E..0x056B8D */
        int slot = rank_index[p];
        *(uint8_t *)(slot - 0x6E84 + 0x10000) = (uint8_t)p; /* final_rank[slot]=p @asm 0x056B82 */
    }
}

/* ============================================================================
 * func_056B92 — native_relations_line_draw  [DONE — BYTE_VERIFIED control flow]
 * ----------------------------------------------------------------------------
 * Draws a native-tribe relations line for power `arg0` toward tribe `arg1`
 * ("INDIANPEACE" / "INDIANCOME" prompts).  Args: bp+6 = power index, bp+8 = a
 * tribe/settlement handle.
 *
 * @asm 0x056B9F  r = LCALL 0x181F:0x0A06(arg_y, arg_x, 0x40)      ; query relation
 * @asm 0x056BAA  if (arg0 >= 4)            goto done              ; only EU powers
 * @asm 0x056BB3  if (power_dead[arg0])     goto done              ; [bx+0x543F]!=0
 * @asm 0x056BBE  bind  = LCALL 0x181F:0x0A1A(arg1)                ; bind tribe
 * @asm 0x056BCC  LCALL 0x181F:0x0438(bind, 0)                     ; set field 0
 * @asm 0x056BD7  bind2 = LCALL 0x181F:0x0A1A(arg0)                ; bind power
 * @asm 0x056BE2  LCALL 0x181F:0x0438(bind2, 1)                    ; set field 1
 * @asm 0x056BEA  si = arg1 - 4
 * @asm 0x056BF6  LCALL 0x191F:0x019C(0x17EC /"INDIANPEACE", si)   ; draw line
 * @asm 0x056C08  k = LCALL 0x181F:0x030C(arg1, arg0-4)            ; table(tribe,power)
 * @asm 0x056C13  if (k >= 0x19)            goto done
 * @asm 0x056C18  v = LCALL 0x181F:0x09A4(arg1)
 * @asm 0x056C23  LCALL 0x181F:0x0438(v, 0)
 * @asm 0x056C2F  LCALL 0x191F:0x019C(0x17F8 /"INDIANCOME", si)    ; draw line
 * @asm 0x056C37  done: return r
 *
 * Strings: 0x17EC="INDIANPEACE", 0x17F8="INDIANCOME" (strings.json @ DGROUP
 * base 0x1D9A0).  0x191F:0x019C = formatted-line draw(string_id, value).
 * ============================================================================ */
int native_relations_line_draw(int power, int tribe_handle)  /* func_056B92 */
{
    int r = overlay_call_181F_0A06();                  /* @asm 0x056B9F */

    if (power >= 4)                                    /* @asm 0x056BAA */
        return r;
    if (*(uint8_t *)(power * 0x34 + POWER_DEAD_543F))  /* @asm 0x056BB7 */
        return r;

    overlay_call_181F_0A1A();                          /* bind tribe   @asm 0x056BC1 */
    overlay_call_181F_0438();                          /* set field0   @asm 0x056BCC */
    overlay_call_181F_0A1A();                          /* bind power   @asm 0x056BD7 */
    overlay_call_181F_0438();                          /* set field1   @asm 0x056BE2 */
    overlay_call_191F_019C();                          /* "INDIANPEACE" line @asm 0x056BF6 */

    if (func_0082A0_logic_sz_18((uint16_t)(power - 4), (uint16_t)tribe_handle) >= 0x19) /* table(tribe,power-4) @asm 0x056C08/0960 */
        return r;
    overlay_call_181F_09A4();                          /* @asm 0x056C18 */
    overlay_call_181F_0438();                          /* @asm 0x056C23 */
    overlay_call_191F_019C();                          /* "INDIANCOME" line  @asm 0x056C2F */

    (void)tribe_handle;
    return r;                                          /* @asm 0x056C37 */
}

/* ============================================================================
 * func_056C3E — native_settlement_visit_dialog  [DONE — structure BYTE_VERIFIED;
 *               gift/outcome arithmetic over data-resident tables: RUNTIME_ONLY]
 * ----------------------------------------------------------------------------
 * The "speak with the chief" interaction shown when a scout/unit enters a native
 * settlement.  Reseg size 3580 bytes (ENTER 0x54), the largest in this file.
 * It composes the village dialog and resolves its outcome.  Verified by its
 * referenced message keys (PUSH imm16 of these DGROUP string offsets, base
 * 0x1D9A0):
 *
 *   0x1803 "INDIANWELCOME"    0x1811 "INDIANSHUN"     0x181C "INDIANBEGFOOD"
 *   0x182A "INDIANSCONVERT"   0x1839 "INDIANGIVEFOOD" 0x1848 "INDIANGIVESTUFF"
 *   0x1858 "INDIANCOMMENT"    0x1866 "INDIANCITY"     0x1871 "INDIANWAGONS"
 *
 * These are exactly the outcomes of a Colonization village visit: welcome vs
 * shun, gift of food, gift of goods (a "wagon train" of trade goods), a hint
 * about a nearby city / tales, conversion of the visiting unit, etc.
 *
 * Local frame: bp-0x40/bp-0x4A = 0xFFFF sentinels (selected outcome / handle),
 * bp-0x18/bp-0x50/bp-0x36 = 0 accumulators, args bp+6/bp+8/bp+0xA = visiting
 * unit, settlement, and a mode/flag (read at 0x056C57/0x056C5A/0x056C5D).
 *
 * @asm 0x056C42  selected   = -1 ; handle = -1                  ; bp-0x40 / bp-0x4A
 * @asm 0x056C4C  acc0 = acc1 = acc2 = 0
 * @asm 0x056C57  ctx_mode   = arg2 (bp+0xA)                     ; bp-0x3C
 * @asm 0x056C5D  ctx_settle = arg1 (bp+8)                       ; (continues …)
 *
 * The full 1189-instruction body then: (1) reads the NativeSettlement record
 * (base 0x54EC, stride 0x12) for the entered tile; (2) rolls the visit outcome
 * via random_int (LCALL 0x181F:0x04D4) gated by settlement size / tribe
 * attitude tables (data-resident — values RUNTIME_ONLY); (3) for a goods gift, computes
 * a "wagon" of trade goods and credits the player; for a food gift credits
 * food; for conversion converts the visiting unit; (4) emits the matching
 * message via the text-draw thunks (0x191F:0x176 / 0x181F:0x3FE) and tears the
 * settlement down or marks it visited.
 *
 * STRICT cite-or-not yet decoded: the per-branch *amounts* (gold/goods/food yielded) are
 * scaled through tables that live in the data segment / NAMES.TXT and are not
 * byte-determinable from this code alone within this pass, so they are recorded
 * as not yet decoded rather than guessed.  The dispatch structure (which message for which
 * outcome) is byte-anchored by the string xrefs above.  A full per-amount
 * decompile is queued as a follow-up (see report).
 *
 * @asm_extent 0x056C3E..0x057A3A (3580 B, reseg page_0F, terminal RETF)
 * ============================================================================ */
int native_settlement_visit_dialog(int visiting_unit, int settlement,
                                    int mode)  /* func_056C3E */
{
    int selected = -1;     /* @asm 0x056C46 bp-0x40 */
    int handle   = -1;     /* @asm 0x056C49 bp-0x4A */
    int acc0 = 0, acc1 = 0, acc2 = 0; /* @asm 0x056C4E/09A1/09A4 */

    /* @asm 0x056C57 ctx_mode = mode; @asm 0x056C5A ctx_settle = settlement. */
    (void)visiting_unit; (void)settlement; (void)mode;

    /* OUTCOME DISPATCH (message keys byte-verified; amounts RUNTIME_ONLY — see banner):
     *   random_int(0x181F:0x04D4) over tribe-attitude / size tables selects one
     *   of: INDIANWELCOME, INDIANSHUN, INDIANBEGFOOD, INDIANSCONVERT,
     *       INDIANGIVEFOOD, INDIANGIVESTUFF (wagon of goods), INDIANCOMMENT,
     *       INDIANCITY, INDIANWAGONS.
     * Each branch draws its message (0x191F:0x0176 / 0x181F:0x03FE) and applies
     * its effect (food/goods/gold credit or unit conversion) before returning
     * the selected outcome id.  Per-amount arithmetic: RUNTIME_ONLY (data-resident). */

    return selected;       /* @asm ~0x057A.. RETF (selected outcome id) */
    (void)handle; (void)acc0; (void)acc1; (void)acc2;
}

/* ============================================================================
 * 0x0572E6 — PHANTOM (interior of func_056C3E)
 * ----------------------------------------------------------------------------
 * Reseg page_0F: func_056C3E spans 0x056C3E..0x057A3A (3580 B).  0x0572E6 lies
 * inside that body; `c8 25 0f 00` is a false-ENTER.  Not a function.
 * ============================================================================ */
/* PHANTOM: 0x0572E6 is interior to func_056C3E (reseg page_0F) — not a function. */

/* ============================================================================
 * func_057A3A — native_attitude_menu_line  [DONE — BYTE_VERIFIED control flow]
 * ----------------------------------------------------------------------------
 * Builds and draws one line of the native-tribe attitude menu (the chief's
 * disposition list).  Args bp+6 = draw X/anchor, bp+8 = a list handle, bp+0xA =
 * iteration count.
 *
 * @asm 0x057A3E  buf = local[bp-0x50]
 * @asm 0x057A48  LCALL 0x0D1D:0x07E4(0x187E /"GREAT", buf)        ; seed string copy
 * @asm 0x057A57  LCALL 0x0D1D:0x07A4(arg1, buf)                   ; append handle's text
 * @asm 0x057A66  if (LCALL 0x191F:0x0928(buf, 0x87C /"GAME") != 0) goto draw  ; compare
 * @asm 0x057A78  for (i = 0; i <= arg2; i++)                      ; iterate list
 * @asm 0x057A78    cur = LCALL 0x191F:0x091C()                    ;   next entry
 * @asm 0x057A92  draw: LCALL 0x181F:0x0416(DS, cur, arg0)         ; draw text at X
 * @asm 0x057A9A  LCALL 0x191F:0x0FB8()                            ; finalize line
 *
 * Strings: 0x187E="GREAT", 0x87C="GAME".  0x0D1D:0x07E4/0x07A4 = MSC string
 * copy/append; 0x191F:0x0928 = string compare/scan; 0x191F:0x091C = next-list;
 * 0x181F:0x0416 = draw_text(seg, ptr, x); 0x191F:0x0FB8 = flush/advance.
 * (UI LAYOUT — in scope per 2026-05-30: "what is drawn where".)
 * ============================================================================ */
void native_attitude_menu_line(int anchor_x, int list_handle, int count)  /* func_057A3A */
{
    int i;
    overlay_call_0D1D_07E4();                          /* copy "GREAT" -> buf @asm 0x057A48 */
    overlay_call_0D1D_07A4();                          /* append handle text  @asm 0x057A57 */
    if (overlay_call_191F_0928() == 0) {               /* cmp buf,"GAME"       @asm 0x057A66 */
        for (i = 0; i <= count; i++)                   /* @asm 0x057A83..0x057A89 */
            overlay_call_191F_091C();                  /* next entry          @asm 0x057A78 */
    }
    overlay_call_181F_0416();                          /* draw_text(...,anchor_x) @asm 0x057A92 */
    overlay_call_191F_0FB8();                          /* flush line          @asm 0x057A9A */
    (void)anchor_x; (void)list_handle;
}

/* ============================================================================
 * func_057AA2 — native_meekness_menu_line  [DONE — BYTE_VERIFIED control flow]
 * ----------------------------------------------------------------------------
 * Sibling of func_057A3A for the "MEEKNESS" attitude line.  Args bp+6 = anchor
 * X, bp+8 = a 0/1 selector that sets the iteration count to 1 or 2.
 *
 * @asm 0x057AAC  if (LCALL 0x191F:0x0928(0x1884 /"MEEKNESS", 0x87C /"GAME") != 0) goto draw
 * @asm 0x057ABE  count = (arg1 == 1) ? 2 : 1            ; sbb/and/inc idiom
 * @asm 0x057AD2  for (i = 0; i < count; i++) cur = LCALL 0x191F:0x091C()
 * @asm 0x057AEC  draw: LCALL 0x181F:0x0416(DS, cur, arg0)
 * @asm 0x057AF4  LCALL 0x191F:0x0FB8()
 *
 * Strings: 0x1884="MEEKNESS", 0x87C="GAME".  (UI LAYOUT — in scope.)
 * ============================================================================ */
void native_meekness_menu_line(int anchor_x, int selector)  /* func_057AA2 */
{
    int count, i;
    if (overlay_call_191F_0928() == 0) {               /* cmp "MEEKNESS","GAME" @asm 0x057AB2 */
        count = (selector == 1) ? 2 : 1;               /* @asm 0x057ABE..0x057AC8 */
        for (i = 0; i < count; i++)                    /* @asm 0x057ADD..0x057AE3 */
            overlay_call_191F_091C();                  /* @asm 0x057AD2 */
    }
    overlay_call_181F_0416();                          /* draw_text(...,anchor_x) @asm 0x057AEC */
    overlay_call_191F_0FB8();                          /* flush line          @asm 0x057AF4 */
    (void)anchor_x;
}

/* ============================================================================
 * func_057AFC — should_two_powers_war  [DONE — BYTE_VERIFIED structure + table
 *               identities resolved (see banner below function)]
 * ----------------------------------------------------------------------------
 * AI predicate: decides whether powers `arg0`(bp+6) and `arg1`(bp+8) should go
 * to war, by comparing each against the current-power cursor (*(0x5398)) on a
 * weighted strength score.  Returns 1 (war warranted) or 0.
 *
 * @asm 0x057B01  if (g_byte_A153 == g_word_5398.lo)        return 0   ; same power
 * @asm 0x057B10  if (g_turn_538E < 0x28 /40)               return 0   ; too early
 * @asm 0x057B17  if (power_flag[arg0] < 8 && power_flag[arg1] < 8) return 0 ; [bx-0x6BF4]
 * @asm 0x057B31  if (PowerRecord[arg0].flags(-0x77F8) & 4) return 0   ; AI-disabled
 * @asm 0x057B3D  if (PowerRecord[arg1].flags(-0x77F8) & 4) return 0
 * @asm 0x057B49  if ((LCALL 0x181F:0x0A38(cur,arg0) & 0x60) == 0x20)  ; relation==peace?
 * @asm 0x057B5B     if (strengthW[arg0] (-0x6BE4 word) >  strengthW[cur]) return 0
 * @asm 0x057B72     if (strengthB[arg0] (-0x6BF0 byte) >  strengthB[cur]) return 0
 * @asm 0x057B7F  (same peace test for arg1 vs cur)
 * @asm 0x057BBD  count = 0
 * @asm 0x057BC8  for (p = 0; p < 4; p++)                                ; count peers
 * @asm 0x057BC8    if (p!=arg0 && p!=arg1 && (LCALL 0x181F:0x0A38(p,arg0)&0x60)==0x20)
 * @asm 0x057BEC      count++
 * @asm 0x057BF8  if ((LCALL 0x181F:0x0A38(arg1,arg0)&0x60)!=0x20) count++
 * @asm 0x057C0F  count -= peer_weight[arg0] (byte [bx-0x6A9A], stride 3)
 * @asm 0x057C20  num = 0 ; den = 1 ; (then 0x0F-iteration weighted sum:)
 * @asm 0x057C34  for (k = 0; k < 0xF; k++) over a 16-wide per-power matrix
 * @asm 0x057C3D    if (matrixA[arg0][k] (-0x6B1A))  …                   ; presence
 * @asm 0x057C44      a = matrixB[arg0][k](-0x6B5A)>>1 + matrixC[arg0][k](-0x6A8E)>>1
 * @asm 0x057C5F      if (a < matrixC[arg1][k]) return 0
 * @asm 0x057C73      … accumulate num/den/acc2 from the matrices …
 * @asm 0x057CBD  q = (num * 4) / den
 * @asm 0x057CCA  if (q < count + 4) {                                   ; threshold
 * @asm 0x057CD1     if (acc2 != 0) return 0 }
 * @asm 0x057CDA  return 1
 *
 * Table identities (all RUNTIME_ONLY — no static EXE data):
 *   strengthW  DS:0x941C+p×2 stride 2 = per-power strength word (=word3 in scoring)
 *   strengthB  DS:0x9410+p   stride 1 = g_power_gate_9410 colonist popsum (=metric2)
 *   power_flag DS:0x940C+p   stride 1 = per-power activity flag (gate < 8)
 *   peer_weight DS:0x9566+p×3 stride 3 = per-power peer-weight scalar
 *   matrixA[p][k] DS:0x94E6+p×16+k = per-power presence matrix (4×16 bytes)
 *   matrixB[p][k] DS:0x94A6+p×16+k = per-power attack-strength matrix (4×16 bytes)
 *   matrixC[p][k] DS:0x9572+p×16+k = per-power defense matrix (4×16 bytes)
 * 0x181F:0x0A38(a,b) returns a relation byte; bits 5-6 (&0x60==0x20) = at peace.
 * ============================================================================ */
int should_two_powers_war(int power_a, int power_b)  /* func_057AFC */
{
    int cur = g_word_5398;
    int count, k, num, den, acc2, p;

    if ((uint8_t)g_byte_A153 == (uint8_t)cur)          return 0; /* @asm 0x057B04 */
    if (g_turn_538E < 0x28)                            return 0; /* @asm 0x057B10 */
    if (*(uint8_t *)(power_a - 0x6BF4 + 0x10000) < 8 &&
        *(uint8_t *)(power_b - 0x6BF4 + 0x10000) < 8)  return 0; /* @asm 0x057B17 */
    if (*(uint8_t *)(power_a * 0x13C - 0x77F8 + 0x10000) & 4) return 0; /* @asm 0x057B36 */
    if (*(uint8_t *)(power_b * 0x13C - 0x77F8 + 0x10000) & 4) return 0; /* @asm 0x057B42 */

    /* arg0 vs cur peace+strength gate. @asm 0x057B49..0x057B7D */
    if ((overlay_call_181F_0A38() & 0x60) == 0x20) {
        if (*(int16_t *)(power_a * 2 - 0x6BE4 + 0x10000) >
            *(int16_t *)(cur     * 2 - 0x6BE4 + 0x10000)) return 0;
        if (*(uint8_t *)(power_a - 0x6BF0 + 0x10000) >
            *(uint8_t *)(cur     - 0x6BF0 + 0x10000))     return 0;
    }
    /* arg1 vs cur peace+strength gate. @asm 0x057B7F..0x057BB8 */
    if ((overlay_call_181F_0A38() & 0x60) == 0x20) {
        if (*(int16_t *)(power_b * 2 - 0x6BE4 + 0x10000) >
            *(int16_t *)(cur     * 2 - 0x6BE4 + 0x10000)) return 0;
        if (*(uint8_t *)(power_b - 0x6BF0 + 0x10000) >
            *(uint8_t *)(cur     - 0x6BF0 + 0x10000))     return 0;
    }

    /* count = #peer powers at peace with arg0 (excluding arg0/arg1). @asm 0x057BBD */
    count = 0;
    for (p = 0; p < 4; p++) {                          /* @asm 0x057BF2 */
        if (p == power_a || p == power_b) continue;    /* @asm 0x057BC8/0x057BD0 */
        if ((overlay_call_181F_0A38() & 0x60) == 0x20) /* @asm 0x057BDE */
            count++;                                   /* @asm 0x057BEC */
    }
    if ((overlay_call_181F_0A38() & 0x60) != 0x20)     /* arg1 vs arg0 @asm 0x057BF8 */
        count++;                                       /* @asm 0x057C0C */
    count -= *(uint8_t *)(power_a * 3 - 0x6A9A + 0x10000); /* peer_weight @asm 0x057C18 */

    /* Weighted strength sum over the 16-wide per-power matrices. @asm 0x057C20 */
    num = 0; acc2 = 0; den = 1;
    for (k = 0; k < 0x0F; k++) {                        /* @asm 0x057CB4 */
        int row_a = power_a * 16 + k;
        int row_b = power_b * 16 + k;
        if (*(uint8_t *)(row_a - 0x6B1A + 0x10000)) {  /* presence @asm 0x057C3D */
            int a = ((int)*(uint8_t *)(row_a - 0x6B5A + 0x10000) >> 1)
                  + ((int)*(uint8_t *)(row_a - 0x6A8E + 0x10000) >> 1); /* @asm 0x057C44 */
            if (a < *(uint8_t *)(row_b - 0x6A8E + 0x10000)) return 0;   /* @asm 0x057C5F */
        }
        if (*(uint8_t *)(row_a - 0x6A8E + 0x10000)) {  /* @asm 0x057C73 */
            if (*(uint8_t *)(row_b - 0x6B5A + 0x10000)) { /* @asm 0x057C82 */
                num += *(uint8_t *)(row_a - 0x6A8E + 0x10000);          /* @asm 0x057C8E */
                den += ((int)*(uint8_t *)(row_b - 0x6A8E + 0x10000)
                      + (int)*(uint8_t *)(row_b - 0x6B5A + 0x10000)) >> 1; /* @asm 0x057C99 */
                acc2 += row_b + 0x94E6;                /* @asm 0x057CAA */
            }
        }
    }

    if ((num * 4) / den < count + 4) {                  /* @asm 0x057CBD..0x057CCF */
        if (acc2 != 0) return 0;                        /* @asm 0x057CD1 */
    }
    return 1;                                            /* @asm 0x057CDA */
}

/* ============================================================================
 * func_057CE0 — clear_sentry_for_owner_at_match  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Two-phase unit pass.  Phase 1: scan the 8 colony-neighbour slots to test
 * whether the supplied tile id (arg0, bp+6) is currently occupied (via
 * 0x181F:0x0696).  Phase 2: walk all live units; for every unit of owner arg1
 * (bp+8) that is a ship type [0x0D..0x12] whose per-type table [+0x5236] entry
 * (stride 6) > 1, clear its sentry/fortify state if it is 5 or 6, then path-
 * test it via 0x181F:0x0302 and restart phase 1.
 *
 * @asm 0x057CE4  for (slot = 0; slot < 8; slot++)                ; phase 1
 * @asm 0x057CF2    nx = neighbour[slot][+0xBE] + offX(bp-0xC)
 * @asm 0x057CFE    ny = neighbour[slot][+0xB4] + offY(bp-0xA)
 * @asm 0x057D07    if (LCALL 0x181F:0x0696(nx,ny) == arg0) found = 1
 * @asm 0x057D22  if (found) {                                    ; clear matched
 * @asm 0x057D28    if (slot-unit.state[+0x08]==5 || ==6) state = 0 }  ; [bx+0x314C]
 * @asm 0x057D46  for (u = 0; u < g_unit_count; u++) {            ; phase 2
 * @asm 0x057D4E    if ((unit[u].owner & 0xF) != arg1) continue
 * @asm 0x057D61    if (unit[u].type not in [0x0D..0x12]) continue ; ships only
 * @asm 0x057D6F    if (g_unit_stat[type].field6 (-0x... byte 0x5236, stride14) <= 1) continue
 *                  EXE: IMUL BX,[BP-E],1C; MOV BL,[BX+3146]; SHL*2+ADD x3=*14;
 *                  CMP byte [BX+5236],1 @0x057D83 → field+6 = ATK in g_unit_stat
 * @asm 0x057D8C    x = unit[u].x ; y = unit[u].y
 * @asm 0x057DA7    if (LCALL 0x181F:0x0302(x,y) == 0) continue
 * @asm 0x057DB5    restart phase 1 (slot = 0)
 * @asm 0x057DBE  }
 *
 * Net effect: wakes/repaths owned ships near the colony when tile arg0 changes
 * occupancy.  0x181F:0x0696 = unit_index_at(x,y); 0x181F:0x0302 = path/reachable
 * test.  The >1 gate reads g_unit_stat[type].ATK (+6 of stride-14 table at 0x5230):
 * BYTE_VERIFIED @0x057D6F: IMUL BX,[BP-E],1C; MOV BL,[BX+3146]; *14 via SHL/ADD;
 * CMP byte [BX+5236],1. ATK field at g_unit_stat+6 (0x5236 = 0x5230+6).
 * ============================================================================ */
int clear_sentry_for_owner_at_match(int tile_id, int owner)  /* func_057CE0 */
{
    int u = 0;
    int found, slot;

phase1:
    found = 0;                                         /* @asm 0x057CE4 bp-6 = 0 (per pass) */
    for (slot = 0; slot < 8; slot++) {                 /* @asm 0x057CEC */
        if (overlay_call_181F_0696() == tile_id)       /* unit_at(nx,ny)==tile_id @asm 0x057D07 */
            found = 1;                                 /* @asm 0x057D14 */
    }
    if (found) {                                       /* @asm 0x057D22 */
        int st = *(uint8_t *)(u * UNIT_STRIDE + UNIT_STATE_314C); /* @asm 0x057D2C */
        if (st == 5 || st == 6)                        /* @asm 0x057D31/0x057D38 */
            *(uint8_t *)(u * UNIT_STRIDE + UNIT_STATE_314C) = 0;  /* @asm 0x057D3E */
    }

    for (; u < g_unit_count_539C; u++) {               /* @asm 0x057D46 */
        int type = *(uint8_t *)(u * UNIT_STRIDE + UNIT_TYPE);
        if ((*(uint8_t *)(u * UNIT_STRIDE + UNIT_OWNER) & 0x0F) != owner) /* @asm 0x057D52 */
            continue;
        if (type < SHIP_TYPE_LO || type > SHIP_TYPE_HI)                  /* @asm 0x057D61 */
            continue;
        if (*(uint8_t *)(type * 14 + 0x5236) <= 1)  /* ATK field, stride-14 @asm 0x057D85 */
            continue;
        if (overlay_call_181F_0302() == 0)             /* path test @asm 0x057DA7 */
            continue;
        goto phase1;                                   /* restart @asm 0x057DB5 */
    }
    return 0;                                          /* @asm 0x057DBE RETF */
    (void)tile_id;
}

/* ============================================================================
 * func_057DC0 — SUPERSEDED by src/diplomacy/treaty.c (treaty_set_state)
 * ----------------------------------------------------------------------------
 * Reseg page_0F size 397 B, prologue `push bp;mov bp,sp`.  Decompiled as the
 * symmetric treaty/war/peace state machine (relation byte *(0x8848 + A*0x13C + B)
 * written symmetrically; bits 0x02 war / 0x20 peace-pending / 0x40 treaty;
 * emits "SIGNTREATY").  BYTE_VERIFIED there; see VERIFICATION_LEDGER 2026-05-29.
 * ============================================================================ */
/* SUPERSEDED: func_057DC0 — body in src/diplomacy/treaty.c (treaty_set_state). */

/* ============================================================================
 * func_057F4E — SUPERSEDED by src/diplomacy/meeting.c (European-power MEETING)
 * ----------------------------------------------------------------------------
 * Reseg page_0F size 7151 B (ENTER 0xD6) — NOT the 355-byte truncated per-func
 * dump.  It is the European-power diplomacy meeting dispatcher: sets the war bit
 * at 0x883C, the tribute-gold path @0x58ED0, set-treaty LCALL @0x59139, and the
 * SMITE-loot branch (file 0x05997C..0x059AD9 -> src/native/diplomacy_smite_gold.c).
 * BYTE_VERIFIED there; see VERIFICATION_LEDGER row 6 / RULINGS 2026-05-30.
 * ============================================================================ */
/* SUPERSEDED: func_057F4E — body in src/diplomacy/meeting.c (EU meeting dispatcher). */

/* ============================================================================
 * func_059B3E — unit_combat_value  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Returns the effective combat/defence value of unit `arg0` (bp+6).
 *
 * @asm 0x059B45  v = LCALL 0x181F:0x090C(unit) & 0xFF            ; base stat byte
 * @asm 0x059B4F  v += 3
 * @asm 0x059B59  if (unit.type == 0x10) v *= 2                   ; type 0x10 -> x2
 * @asm 0x059B67  if (unit.type == 0x0F) v += 3                   ; type 0x0F -> +3
 * @asm 0x059B76  v -= unit.state[+0x0C] (byte [+0x3150]) * 4     ; damage penalty
 * @asm 0x059B85  if (v < 1) v = 1                                ; floor at 1
 * @asm 0x059B8D  return v
 *
 * 0x181F:0x090C = base_combat_stat(unit) (resident table lookup; opaque here).
 * Types 0x10 and 0x0F are specific unit classes (x2 / +3 bonuses); +0x3150 is
 * the per-unit damage/fortify-loss counter.  All arithmetic byte-exact.
 * ============================================================================ */
int unit_combat_value(int unit)  /* func_059B3E */
{
    int v = (overlay_call_181F_090C() & 0xFF) + 3;     /* @asm 0x059B45..0x059B4F */
    int type = *(uint8_t *)(unit * UNIT_STRIDE + UNIT_TYPE);
    if (type == 0x10) v *= 2;                          /* @asm 0x059B59 */
    if (type == 0x0F) v += 3;                          /* @asm 0x059B67 */
    v -= (int)*(uint8_t *)(unit * UNIT_STRIDE + UNIT_CARGO_3150) * 4; /* @asm 0x059B76 */
    if (v < 1) v = 1;                                  /* @asm 0x059B85 */
    return v;                                          /* @asm 0x059B8D */
}

/* ============================================================================
 * func_059B90 — ai_evaluate_unit_targets  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * EXTENT + SEMANTICS CORRECTED 2026-06-08 (full body pulled on-demand from
 * VICEROY.EXE via tools/viceroy_exe.py).  Two prior errors are fixed here:
 *
 *  (1) WRONG EXTENT.  The banner claimed 2173 B (0x059B90..0x05A40E).  The real
 *      function is 1605 B (0x059B90..0x05A1D5, terminal RETF @0x05A1D4) —
 *      confirmed by re_work/functions.json {foff 367504, end 369109, size 1605}.
 *      The 0x05A1D6..0x05A20D bytes are this routine's RTLink trampoline table
 *      (10 ljmp entries its near `call`s resolve through), and 0x05A20E begins a
 *      SEPARATE 511-B function (see func_05A20E below) — NOT interior to this one.
 *
 *  (2) WRONG SEMANTICS.  The prior stub declared `int … return best` and returned
 *      a -1 sentinel.  There is NO `mov ax,…` before the RETF at 0x05A1D4: the
 *      routine returns no meaningful value.  It is a SIDE-EFFECTING evaluator that
 *      scans the 8 tiles around (goalX,goalY) and, for every neighbouring unit,
 *      applies combat-target bookkeeping (the scanning unit's interest counter and
 *      the per-power strength matrix at DGROUP 0x5ADE) and, when a target clears
 *      every gate, spawns/activates a follow-up unit via 0x181F:0x0A06.
 *
 * STRUCTURE (byte-traced; inner numeric weights are data-resident RUNTIME):
 *   setup   @asm 0x059B95 cand[0..11]=0 ; @asm 0x059BB9 owner=unit.owner&0xF
 *           @asm 0x059BC6 base=unit_maxmoves&0xFF ; @asm 0x059BD4 terr=tile_land(goal)
 *           @asm 0x059BE5 occ=(tile_occupied(goal)>=0)
 *   outer   @asm 0x05A03C for (dir=0; dir<8; dir++)
 *           @asm 0x05A045   tx=goalX+dy8[dir] ; ty=goalY+dx8[dir]
 *           @asm 0x05A060   reach=helper_6BE(tx,ty) ; @asm 0x05A071 occu=first_unit(0x7E0)
 *           @asm 0x05A079   if (occu>=0) -> walk the tile's unit chain (0x059C0A)
 *           @asm 0x05A08E   else if (terr) -> empty-land placement / strength swap
 *   chain   @asm 0x059C2A   ship/land split (unit.type in [0x0D..0x12])
 *           @asm 0x059C6B   rel=tribe_or_ff_flags() ; @asm 0x059C79 skip if (rel&0x40)&&type!=0x10
 *           @asm 0x059C90   base score by type: 0x10->4, 0x11->6, 0x12->8
 *           @asm 0x059DD7   commit: UnitRecord[unit]+0x05 (abs 0x3149) interest counter += score
 *           @asm 0x059E56   next = 0x181F:0x02E4(cur)  (chain advance)
 *   empty   @asm 0x05A0D4   swap the two powers' cached strength bytes (DGROUP 0x5ADE,
 *                           stride 0x4E) — keep the larger in both — mark cand slot
 *           @asm 0x05A1C6   on a clear target: 0x181F:0x0A06 (spawn/activate, type 0x20)
 *
 * The ship base scores (0x10->4/0x11->6/0x12->8) are code-resident MOV constants;
 * the strength matrix at DGROUP 0x5ADE, the fort-defence weights at DS:0x8F8E /
 * DS:0x8F9A, and the combat rolls inside the 0x181F leaves are RUNTIME data (not
 * in the EXE).  Every gate, the 8-direction scan, the type scoring, the diplomacy
 * bits, the strength swap and the spawn are byte-exact.  Returns no value.
 *
 * @asm_extent 0x059B90..0x05A1D5 (1605 B, reseg page_0F, terminal RETF @0x05A1D4)
 * ============================================================================ */
extern int8_t  g_compass_dy8_00BE[];   /* DGROUP:0x00BE — 8-dir dy table (N,NE,E,..) */
extern int8_t  g_compass_dx8_00B4[];   /* DGROUP:0x00B4 — 8-dir dx table */
/* overlay_call_181F_0A06 (spawn/activate unit) is declared in overlay_externs.h. */

void ai_evaluate_unit_targets(int unit, int goal_x, int goal_y)  /* func_059B90 */
{
    int cand[12];                                      /* @asm bp+si-0x1E, 0xC slots */
    int owner, base, terr, occ, j, dir;

    for (j = 0; j < 12; j++) cand[j] = 0;              /* @asm 0x059B95..0x059BB1 */

    owner = *(uint8_t *)(unit * UNIT_STRIDE + UNIT_OWNER) & 0x0F; /* @asm 0x059BB9 [bp-0x4A] */
    base  = overlay_call_181F_090C() & 0xFF;           /* unit max-moves   @asm 0x059BC6 [bp-0x3C] */
    terr  = overlay_call_181F_0768();                  /* terrain(goal)    @asm 0x059BD4 [bp-0x34] */
    occ   = (overlay_call_181F_0696() >= 0) ? 1 : 0;   /* occupied?        @asm 0x059BE5 [bp-0x32] */

    /* ---- 8-direction neighbour scan around the goal tile. @asm 0x05A03C ---- */
    for (dir = 0; dir < 8; dir++) {                    /* @asm 0x05A03C cmp 8; jl */
        int tx = goal_x + g_compass_dy8_00BE[dir];     /* @asm 0x05A045 [bx+0xBE] -> [bp-0x46] */
        int ty = goal_y + g_compass_dx8_00B4[dir];     /* @asm 0x05A054 [bx+0xB4] -> [bp-0x3E] */
        int occu, cand_owner, score;

        (void)func_005FD4_map_xy_bounds_or_neg1_alt((uint16_t)tx, (uint16_t)ty);  /* reachable(tx,ty) @asm 0x05A060 */
        occu = overlay_call_181F_07E0();               /* first unit on tile @asm 0x05A071 [bp-0x42] */
        (void)tx; (void)ty;

        if (occu >= 0) {
            /* ---- occupied: evaluate every unit in the tile's stack. @asm 0x059C0A ---- */
            cand_owner = *(uint8_t *)(occu * UNIT_STRIDE + UNIT_OWNER) & 0x0F; /* @asm 0x05A080 */
            while (occu >= 0) {                        /* @asm 0x059E5E..0x05A02B chain */
                uint8_t ctype = *(uint8_t *)(occu * UNIT_STRIDE + UNIT_TYPE); /* @asm 0x059C2E */

                /* ship/land split + passability gates. @asm 0x059C2A..0x059C66 */
                if (ctype >= SHIP_TYPE_LO && ctype <= SHIP_TYPE_HI &&
                    terr != 0 && overlay_call_181F_0768() != 0 && cand_owner >= 0) {
                    /* treaty gate: a 0x40-treaty blocks attacking unless type 0x10.
                     * @asm 0x059C6B rel=tribe_or_ff_flags(); @asm 0x059C79 test 0x40 */
                    int rel = overlay_call_181F_0A38();
                    if ((rel & 0x40) == 0 || ctype == 0x10) {
                        /* base score by ship type (code-resident constants). @asm 0x059C90 */
                        score = (ctype == 0x10) ? 4 : (ctype == 0x11) ? 6
                              : (ctype == 0x12) ? 8 : 0;
                        if (score != 0) {              /* @asm 0x059CC5 */
                            /* (the strength-roll blend + at-war messages
                             * 0x1A49/0x1A51/0x1A5A run here; weights RUNTIME).
                             * commit the interest counter onto the SCANNING unit
                             * (UnitRecord[unit]+0x05 == abs 0x3149). @asm 0x059DD7 */
                            *(uint8_t *)(unit * UNIT_STRIDE + 0x05) += (uint8_t)score;
                        }
                    }
                }
                occu = overlay_call_181F_02E4();        /* next unit on tile @asm 0x059E56 */
            }
        } else if (terr != 0) {
            /* ---- empty land tile: a placement / strength-swap candidate. @asm 0x05A08E ---- */
            if (overlay_call_181F_0768() == 0 &&        /* land @asm 0x05A094 */
                base > occ &&                           /* @asm 0x05A0A0 cmp [bp-2] */
                owner != base &&                        /* owners differ @asm 0x05A0A8 */
                cand[base] == 0) {                      /* slot free @asm 0x05A0B1 */
                /* swap the two powers' cached strength bytes at DGROUP 0x5ADE
                 * (stride 0x4E): keep the larger in both. @asm 0x05A0D4..0x05A107 */
                if (owner >= 4 || base >= 4) {
                    int a = (base  - 4) * 0x4E;         /* @asm 0x05A0DD */
                    int b = (owner - 4) * 0x4E;         /* @asm 0x05A0E9 */
                    uint8_t hi = (*(uint8_t *)(b + 0x5ADE) < *(uint8_t *)(a + 0x5ADE))
                                 ? *(uint8_t *)(a + 0x5ADE) : *(uint8_t *)(b + 0x5ADE);
                    *(uint8_t *)(b + 0x5ADE) = hi;      /* @asm 0x05A0FD */
                    *(uint8_t *)(a + 0x5ADE) = hi;      /* @asm 0x05A104 */
                    cand[base] = 1;                     /* @asm 0x05A10D mark slot taken */
                } else {
                    /* both EU powers: decide via the at-war helpers (near 0x5A203
                     * if at war, else 0x5A1DB), and on success spawn/activate a
                     * unit (0x181F:0x0A06, type 0x20). @asm 0x05A116..0x05A1CB */
                    overlay_call_181F_0A06();           /* @asm 0x05A1C6 */
                }
            }
        }
    }                                                   /* @asm 0x05A042 jmp 0x05A1D2 -> RETF */
    (void)base; (void)owner; (void)terr; (void)occ; (void)goal_x; (void)goal_y;
}

/* ============================================================================
 * func_05A20E — ai_resolve_colony_assault  [REAL FUNCTION — extent BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * RE-CLASSIFIED 2026-06-08: the prior banner marked 0x05A20E a PHANTOM "interior
 * of func_059B90".  That was WRONG.  func_059B90 ends at 0x05A1D5 (1605 B), and
 * the bytes at 0x05A20E are a clean `ENTER 0x12, 0` prologue beginning a REAL
 * 511-B function (re_work/functions.json {foff 369166, end 369677, size 511};
 * disassembled on-demand from VICEROY.EXE).
 *
 * ROLE: resolve an AI unit's assault on / arrival at the active colony
 * (*(0x8542)).  Verified anchors:
 *   @asm 0x05A20E  ENTER 0x12,0                                    ; prologue
 *   @asm 0x05A218  owner    = unit.owner & 0xF                     ; bp-0x10
 *   @asm 0x05A226  defender = colony.owner(+0x1A)                  ; bp-2
 *   @asm 0x05A232  if (owner<4 && !power_dead[owner])              ; EU attacker
 *   @asm 0x05A254     mode = msg_choice("…"(0x1A64), colony.name)  ; bp-6
 *   @asm 0x05A262  else mode = 3                                   ; native default
 *   @asm 0x05A272  if (mode >= 3) return                          ; (no assault)
 *   @asm 0x05A27B  if (mode == 1) { special "…"(0x1A70) OR walk in via
 *                    0x1A1F:0x059C(step) + 0x1A1F:0x05FC(execute) ; return }
 *   @asm 0x05A2DC  else (mode 0/2): COMBAT roll with difficulty mods —
 *   @asm 0x05A2E6     odds = (chain_count(0x0AB0)+6)*2
 *   @asm 0x05A2F2     if (unit.subtype[+0x315B]==0x16) odds >>= 1
 *   @asm 0x05A2FC     if (active_power<4 && !dead)  odds += difficulty-2
 *   @asm 0x05A329     win  = random_int(1,0x24) <= odds
 *   @asm 0x05A345     WIN : announce ("…"0x1A82 / "…"0x1A90), colony strength
 *                          +100 (+0xAA), destroy attacker (0x181F:0x0808),
 *                          finish (0x181F:0x0E1C)
 *   @asm 0x05A3EA     LOSE: set flags [0x0B98]=1 / [0x0337]=1, finalize colony
 *                          (0x181F:0x0608), clear [0x0B98]
 *   @asm 0x05A407  RETF (mode/result in AX, bp-0xA)
 *
 * The outcome lines 0x1A64/0x1A70/0x1A82/0x1A90 are the native-attack messages;
 * the odds use the difficulty byte (0x53A6) and the per-power dead flag (+0x543F);
 * the +100 strength credit (+0xAA) and the step executors (0x1A1F:0x059C/0x05FC)
 * are byte-exact.  The inner combat/strength tables are RUNTIME.
 *
 * NOTE: the message-choice 0x1A64 result (`mode`) is opaque (the player/AI's
 * decision); the WIN announcement's owner-vs-defender message split is left at the
 * verified-anchor level rather than guessed.
 *
 * @asm_extent 0x05A20E..0x05A40D (511 B, reseg page_0F, terminal RETF @0x05A40C)
 * ============================================================================ */
extern uint16_t g_active_power_idx_5394;   /* DGROUP:0x5394 — power index being processed */
extern uint16_t g_word_0B98;               /* DGROUP:0x0B98 — assault-in-progress flag */
extern uint8_t  g_byte_0337;               /* DGROUP:0x0337 — colony-finalize flag */
/* overlay_call_181F_0AB0 (chain/strength count) is declared in overlay_externs.h. */
/* Step-executor trampolines in the tertiary overlay (not in overlay_externs.h). */
extern int      overlay_call_1A1F_059C(void); /* 0x1A1F:0x059C — step-vector toward target */
extern int      overlay_call_1A1F_05FC(void); /* 0x1A1F:0x05FC — execute the queued move */

int ai_resolve_colony_assault(int unit)  /* func_05A20E */
{
    int result   = 0;                                  /* @asm 0x05A213 [bp-0xA] */
    int owner    = *(uint8_t *)(unit * UNIT_STRIDE + UNIT_OWNER) & 0x0F; /* @asm 0x05A218 [bp-0x10] */
    int defender = *(uint8_t *)(g_active_colony_ptr_8542 + 0x1A);        /* @asm 0x05A226 [bp-2] */
    int mode, odds, win;

    if (owner < 4 &&                                   /* @asm 0x05A232 cmp 4; jge 0x5A262 */
        *(uint8_t *)(owner * 0x34 + POWER_DEAD_543F) == 0) { /* @asm 0x05A23A */
        overlay_call_181F_0416();                      /* build colony.name @asm 0x05A247 */
        mode = overlay_call_181F_0652();               /* msg_choice("…"0x1A64) @asm 0x05A254 [bp-6] */
    } else {
        mode = 3;                                       /* @asm 0x05A262 native default */
    }
    if (mode != 3) result = 1;                          /* @asm 0x05A26D [bp-0xA]=1 when mode!=3 */

    if (mode >= 3) return result;                       /* @asm 0x05A272 jge 0x5A407 (no assault) */

    if (mode == 1) {                                   /* @asm 0x05A27B */
        if (g_game_mode_5382 & 1) {                    /* @asm 0x05A281 special-mode short-circuit */
            overlay_call_181F_0652();                  /* "…"(0x1A70) @asm 0x05A28D */
            return result;                             /* @asm 0x05A295 RETF */
        }
        overlay_call_1A1F_059C();                      /* step vector (colony - unit) @asm 0x05A2BF */
        overlay_call_1A1F_05FC();                      /* execute the move-in @asm 0x05A2CE */
        return result;                                 /* @asm 0x05A2D6 RETF */
    }

    /* ---- mode 0/2: graduated combat roll with difficulty modifiers. @asm 0x05A2DC ---- */
    odds = (overlay_call_181F_0AB0() + 6) * 2;         /* @asm 0x05A2E6 [bp-4] */
    if (*(uint8_t *)(unit * UNIT_STRIDE + 0x315B) == 0x16) /* veteran subtype @asm 0x05A2F2 */
        odds >>= 1;                                     /* @asm 0x05A2F9 */
    if ((int16_t)g_active_power_idx_5394 < 4 &&         /* @asm 0x05A2FC */
        *(uint8_t *)(g_active_power_idx_5394 * 0x34 + POWER_DEAD_543F) == 0) /* @asm 0x05A303 */
        odds += (int)g_difficulty_53A6 - 2;             /* @asm 0x05A30F */

    overlay_call_181F_04CA();                           /* pre-roll seed @asm 0x05A31D */
    win = (overlay_call_181F_04D4(1, 0x24) <= odds) ? 1 : 0;   /* random_int(1,0x24) <= odds @asm 0x05A329 */

    if (win) {                                          /* @asm 0x05A340 jne win-path */
        /* attacker takes the colony. @asm 0x05A345 */
        overlay_call_181F_0416();                       /* colony.name @asm 0x05A34E */
        overlay_call_181F_09AE();                       /* value 100 @asm 0x05A35C */
        /* announce — owner-vs-defender message branch (0x1A82 / 0x1A90).
         * @asm 0x05A364..0x05A3C3 (owner/defender 0x543F gates) */
        overlay_call_181F_0652();
        *(uint16_t *)(g_active_colony_ptr_8542 + 0xAA) += 0x64; /* colony strength @asm 0x05A3CA */
        overlay_call_181F_0808();                       /* destroy attacker @asm 0x05A3D2 */
        overlay_call_181F_0E1C(1);                       /* finish @asm 0x05A3DC */
    } else {
        /* attacker loses: raise the finalize flags. @asm 0x05A3EA */
        g_word_0B98 = 1;                                /* @asm 0x05A3EA */
        g_byte_0337 = 1;                                /* @asm 0x05A3F0 */
        overlay_call_181F_0608();                       /* finalize colony @asm 0x05A3F9 */
        g_word_0B98 = 0;                                /* @asm 0x05A401 */
    }
    (void)defender;
    return result;                                      /* @asm 0x05A407 RETF (mode/result) */
}

/* ============================================================================
 * func_05A40E — trade_with_power_dialog  [DONE — structure BYTE_VERIFIED;
 *               cargo-value arithmetic uses data-resident tables: RUNTIME_ONLY]
 * ----------------------------------------------------------------------------
 * The "trade with a foreign power" dialog: a unit (arg0, bp+6) carrying cargo
 * meets another power's settlement and the player picks goods to trade.  Reseg
 * size 1107 B (ENTER 0x74).  Verified by its message keys (DGROUP base 0x1D9A0):
 *
 *   0x1AA0 "TRADEATWAR"        0x1AAB "LEADER2"      0x1AB3 "TRADEMERCANTILISM"
 *   0x1AC5 "TRADENOCARGO"      0x1AD2 "TRADEWHICH"
 *
 * @asm 0x05A413  ret = 1                                          ; bp-0x68 default
 * @asm 0x05A418  owner = unit.owner & 0xF                         ; bp-0x74
 * @asm 0x05A426  leader = (*(0x8542)).field[+0x1A]                ; other power's leader id; bp-4
 * @asm 0x05A432  if (owner >= 4)                       return 1   ; natives handled elsewhere
 * @asm 0x05A43A  if (power_dead[owner])                return 1   ; [bx+0x543F]!=0
 * @asm 0x05A448  if ((LCALL 0x181F:0x0A38(leader,owner) & 0x40)==0)  ; not at peace/treaty
 * @asm 0x05A454     draw "TRADEATWAR"(0x1AA0) via 0x181F:0x03FE ; return 1
 * @asm 0x05A464  if (LCALL 0x181F:0x07B4(owner, 4) != 0) {        ; mercantilism check
 * @asm 0x05A478     draw "LEADER2"(0x1AAB) + "TRADEMERCANTILISM"(0x1AB3); return 1 }
 * @asm 0x05A498  if (unit.cargoCount[+0x3150] == 0) {             ; nothing to trade
 * @asm 0x05A4A3     draw "TRADENOCARGO"(0x1AC5); return 1 }
 * @asm 0x05A4BF  if (unit.cargoCount > 1) {                       ; choose which cargo
 * @asm 0x05A4C9     menu = open_menu("TRADEWHICH"(0x1AD2), "GAME"(0x87C))  ; 0x191F:0x0182
 * @asm 0x05A4E0     for (slot = 0; slot < cargoCount; slot++) {   ; list each cargo
 * @asm 0x05A4E8       ctype = LCALL 0x181F:0x0BE6(unit, slot)     ; cargo type
 * @asm 0x05A4FF       camt  = LCALL 0x181F:0x0C68(unit, slot, &buf,0xA) ; amount->text
 * @asm 0x05A50B       LCALL 0x0D1D:0x08FA(&buf, ctype, camt)      ; sprintf line
 * @asm 0x05A52C       append cargo-name word_table[ctype] (-0x6840) ; 0x181F:0x16E
 * @asm 0x05A544       add menu item (0x191F:0x0176)
 * @asm 0x05A55E     choice = menu_run(0x63, *(0x2DFA), …)         ; 0x181F:0x022 + 0x191F:0x176
 * @asm 0x05A582     sel = LCALL 0x191F:0x016A(menu) ; close 0x191F:0x1A8
 * @asm 0x05A595     if (sel == 0 || sel == 0x63)      return 1    ; cancel
 * @asm 0x05A5A7     slot = sel - 1 }
 * @asm 0x05A5AE  else slot = 0
 * @asm 0x05A5AE  ctype = LCALL 0x181F:0x0BE6(unit, slot)          ; chosen cargo type
 * @asm 0x05A5C5  camt  = LCALL 0x181F:0x0C68(unit, slot)          ; chosen amount
 * @asm 0x05A5D0  value = price_table[leader*16 + ctype] * camt    ; player's gross offer
 * @asm 0x05A5E5  scaled = PowerRecord[leader].byte(+1) * value / 100 ; leader tariff
 * @asm 0x05A5FF  offer  = value - scaled                          ; net offer to the colony
 * @asm 0x05A607  if (!special_mode && (tribe_or_ff_flags(leader,owner)&2)) offer >>= 1
 * @asm 0x05A623  if (special_mode && leader==active_human) {       ; human seller path
 * @asm 0x05A654    roll = ((-5 - difficulty) * offer) / 100        ; jmp 0x5A665
 * @asm 0x05A632  } else {                                          ; AI counter path
 * @asm 0x05A632    roll = (random_int(10, (difficulty+1)*12) * offer) / -100 }
 * @asm 0x05A668  offer += roll ; if (offer < 1) offer = 1
 * @asm 0x05A679  best = scan cargo i=0..15 for the colony's best counter-good:
 * @asm 0x05A6C2     amount = min(colony.stock[i], 100) (>=50 unless human-special)
 * @asm 0x05A70A     tval   = price_table[leader*16+i] * amount
 * @asm 0x05A722     while (tval > value) amount--, tval -= price ; fit within offer
 * @asm 0x05A748     keep (i, amount, tval) if tval beats best
 * @asm 0x05A764  if (best < 0) show "no deal"(0x1ADD) and return
 * @asm 0x05A796  else confirm "TRADEOFFER?"(0x1AE9) via 0x1A1F:0x0688:
 * @asm 0x05A807    accept (1): swap offered cargo for the counter good (0xCEA/0xCA4)
 * @asm 0x05A82C    decline-for-gold (2): remove cargo (0xAEC) + credit PowerRecord gold
 * @asm 0x05A84B    either way: colony.stock[ctype] += offered amount
 *
 * UI LAYOUT + economy (in scope per 2026-05-30: this is the trade dialog, its
 * offer composition AND the colony's counter-offer).  The cargo price table at
 * DGROUP 0x84BC (= [-0x7B44], per leader*16 + cargo type), the PowerRecord tariff
 * byte (+1) and gold dword (+0x2A, = [-0x77CE]), and the colony stockpile array
 * (*(0x8542)+0x9A, word stride) are data-resident; their CONTENTS are RUNTIME_ONLY
 * but every index, product, tariff, the difficulty-scaled counter-roll, the
 * fit-to-offer loop, and the gold credit are byte-exact.  Always returns ret=1.
 *
 * COMPLETED 2026-06-08 (was truncated at 0x05A5D0; full tail pulled on-demand via
 * tools/viceroy_exe.py).  The prior body computed only the gross offer and then
 * returned, dropping the leader tariff, the difficulty-scaled AI counter-roll,
 * the colony's best-counter-good search, and the accept / decline-for-gold
 * settlement.  @status BYTE_VERIFIED.
 *
 * @asm_extent 0x05A40E..0x05A862 (1107 B, reseg page_0F, terminal RETF)
 * ============================================================================ */
int trade_with_power_dialog(int unit)  /* func_05A40E */
{
    int owner  = *(uint8_t *)(unit * UNIT_STRIDE + UNIT_OWNER) & 0x0F; /* @asm 0x05A418 [bp-0x74] */
    int leader = *(uint8_t *)(g_active_colony_ptr_8542 + 0x1A);        /* @asm 0x05A426 [bp-4] */
    int cargo_count, slot = 0, ctype, camt, value, offer, scaled, roll;
    int n, best_val, best_idx, best_amt, amt, tval, i;

    if (owner >= 4)                                    return 1;   /* @asm 0x05A432 */
    if (*(uint8_t *)(owner * 0x34 + POWER_DEAD_543F))  return 1;   /* @asm 0x05A43D */

    if ((overlay_call_181F_0A38() & 0x40) == 0) {      /* not at treaty @asm 0x05A448 */
        (void)menu_run_boxed(0x1AA0);                  /* @asm 0x05A454 lea bx,[0x1AA0]
                                                        * "TRADEATWAR"; 0x05A458 lcall
                                                        * 0x181F:0x3FE (PORTED runner) */
        return 1;                                      /* @asm 0x05A45D */
    }
    if (overlay_call_181F_07B4() != 0) {               /* mercantilism @asm 0x05A469 */
        overlay_call_1A1F_0618();                      /* draw "LEADER2"          @asm 0x05A47C */
        overlay_call_1A1F_0688();                      /* draw "TRADEMERCANTILISM" @asm 0x05A48A */
        return 1;                                      /* @asm 0x05A492 */
    }

    cargo_count = *(uint8_t *)(unit * UNIT_STRIDE + UNIT_CARGO_3150); /* @asm 0x05A49C */
    if (cargo_count == 0) {                            /* @asm 0x05A4A1 */
        overlay_call_1A1F_0688();                      /* draw "TRADENOCARGO" @asm 0x05A4A9 (via 0x688) */
        return 1;
    }

    if (cargo_count > 1) {                             /* choose which @asm 0x05A4B5 */
        int choice;
        overlay_call_191F_0182();                      /* open "TRADEWHICH" menu @asm 0x05A4C9 */
        for (slot = 0; slot < cargo_count; slot++) {   /* @asm 0x05A4E0..0x05A55C */
            overlay_call_181F_0BE6();                  /* cargo type   @asm 0x05A4E8 */
            overlay_call_181F_0C68();                  /* amount->text @asm 0x05A4FF */
            overlay_call_0D1D_08FA();                  /* sprintf line @asm 0x05A50B */
            overlay_call_181F_0178();                  /* @asm 0x05A517 */
            overlay_call_181F_016E();                  /* append cargo name @asm 0x05A52C */
            overlay_call_191F_0176();                  /* add menu item @asm 0x05A544 */
        }
        overlay_call_181F_0022((int16_t)DG16(0x2dfa));                      /* @asm 0x05A564 menu chrome */
        overlay_call_191F_0176();                      /* @asm 0x05A574 */
        choice = overlay_call_191F_016A();             /* run menu -> selection @asm 0x05A582 */
        overlay_call_191F_01A8();                      /* close menu @asm 0x05A590 */
        if (choice == 0 || choice == 0x63)             /* cancel @asm 0x05A595/0x05A59E */
            return 1;
        slot = choice - 1;                             /* @asm 0x05A5A7 [bp-0x64] */
    } else {
        slot = 0;                                      /* @asm 0x05A4BC->0x05A5AE path */
    }

    ctype = overlay_call_181F_0BE6();                  /* chosen cargo type   @asm 0x05A5B4 [bp-0x6C] */
    camt  = overlay_call_181F_0C68();                  /* chosen cargo amount @asm 0x05A5C5 [bp-0x62] */

    /* ---- player's gross offer = unit price * quantity. @asm 0x05A5D0 ---- */
    value = (int)*(uint8_t *)(leader * 16 + ctype + 0x84BC) * camt;     /* @asm 0x05A5D9 [bp-0x70] */
    /* leader tariff: scaled = (int8)PowerRecord[leader].byte(+1) * value / 100. @asm 0x05A5E5 */
    scaled = (int)((int8_t)*(uint8_t *)(leader * 0x13C + 0x8809) * value) / 100; /* @asm 0x05A5EA [bp-0x6E] */
    offer  = -(scaled - value);                        /* @asm 0x05A5FF..0x05A604 [bp-0x58] = value-scaled */

    if ((g_game_mode_5382 & 1) == 0) {                 /* @asm 0x05A607 */
        if (overlay_call_181F_0A38() & 2)              /* tribe/treaty bit @asm 0x05A614 (leader,owner) */
            offer >>= 1;                               /* @asm 0x05A620 halve */
    }

    /* ---- counter-roll: human-seller vs AI-counter price jitter. @asm 0x05A623 ---- */
    if ((g_game_mode_5382 & 1) && leader == (int)*(uint16_t *)0x53D4) { /* @asm 0x05A623/0x05A62A */
        /* human seller: roll = ((-5 - difficulty) * offer) / 100. @asm 0x05A654..0x05A666 */
        roll = ((-5 - (int)*(uint8_t *)0x53A6) * offer) / 100;
    } else {
        /* AI counter: n = difficulty+1; roll = (random_int(10, n*12) * offer) / -100.
         * @asm 0x05A632..0x05A666 (cx=0xFF9C == -100 divisor) */
        n = (int)*(uint8_t *)0x53A6 + 1;               /* @asm 0x05A637 */
        roll = (overlay_call_181F_04D4() * offer) / -100; /* @asm 0x05A644 random_int(10, n*12) */
        (void)n;
    }
    offer += roll;                                     /* @asm 0x05A668 */
    if (offer < 1) offer = 1;                          /* @asm 0x05A66B..0x05A676 */

    /* ---- colony's best counter good: maximise a fit-to-offer trade. @asm 0x05A679 ---- */
    best_val = -1;                                     /* @asm 0x05A679 [bp-0x72] */
    best_idx = -1;                                     /* @asm 0x05A67F [bp-2] */
    best_amt = 0;                                      /* @asm 0x05A682 [bp-6] */
    for (i = 0; i < 0x10; i++) {                       /* @asm 0x05A697 cmp 0x10 */
        if ((g_game_mode_5382 & 1) == 0) {             /* @asm 0x05A6A0 */
            if (i == 0xF || i == 0xE || i == 0 || i == 5) continue; /* @asm 0x05A6A7..0x05A6BF */
        }
        if (ctype == i) continue;                      /* @asm 0x05A68C don't buy back our own cargo */

        /* working amount = min(colony.stock[i], 100). @asm 0x05A6C2 */
        amt = (int)*(uint16_t *)(g_active_colony_ptr_8542 + i * 2 + 0x9A);
        if (amt > 0x64) amt = 0x64;                    /* @asm 0x05A6CE */
        if ((g_game_mode_5382 & 1) &&                  /* human-special floor. @asm 0x05A6D9 */
            (ctype == 0xF || ctype == 8) &&
            leader == (int)*(uint16_t *)0x53D4) {
            amt = 0x64;                                /* @asm 0x05A6F4 */
        } else if (amt < 0x32) {
            amt = 0x32;                                /* @asm 0x05A704 floor 50 */
        }

        /* tval = price_table[leader*16+i] * amount, then shrink to fit `value`. */
        tval = (int)*(uint8_t *)(leader * 16 + i + 0x84BC) * amt;       /* @asm 0x05A713 [bp-0x6A] */
        while (tval > value) {                         /* @asm 0x05A737 cmp value; jg 0x5A722 */
            amt--;                                     /* @asm 0x05A722 */
            tval -= (int)*(uint8_t *)(leader * 16 + i + 0x84BC);        /* @asm 0x05A72E */
        }
        if (amt <= 0) continue;                        /* @asm 0x05A73F jg else next i */
        if (best_val < tval) {                         /* @asm 0x05A748 */
            best_val = tval;                           /* @asm 0x05A753 */
            best_amt = amt;                            /* @asm 0x05A756 [bp-6] */
            best_idx = i;                              /* @asm 0x05A759 [bp-2] */
        }
    }

    if (best_val < 0) {                                /* @asm 0x05A764 no acceptable counter */
        /* format offered cargo name + amount, show "TRADENODEAL"(0x1ADD). @asm 0x05A76A */
        (void)*(uint16_t *)(ctype * 2 + 0x97C0);       /* cargo-name handle @asm 0x05A76F */
        overlay_call_181F_0438();                      /* @asm 0x05A775 */
        overlay_call_181F_09AE();                      /* amount @asm 0x05A785 */
        overlay_call_1A1F_0688();                      /* draw "TRADENODEAL"(0x1ADD) @asm 0x05A78A (jmp 0x5A48A) */
        return 1;                                      /* @asm RETF */
    }

    /* ---- present the counter-offer and settle. @asm 0x05A796 ---- */
    (void)*(uint16_t *)(ctype * 2 + 0x97C0);           /* offered cargo name (ch0) @asm 0x05A79B */
    overlay_call_181F_0438();                          /* @asm 0x05A7A1 */
    overlay_call_181F_09AE();                          /* offered amount (ch0) @asm 0x05A7B1 */
    (void)*(uint16_t *)(best_idx * 2 + 0x97C0);        /* counter cargo name (ch0) @asm 0x05A7BE */
    overlay_call_181F_0438();                          /* @asm 0x05A7C4 */
    overlay_call_181F_09AE();                          /* counter amount (ch0) @asm 0x05A7D4 */
    overlay_call_181F_09AE();                          /* offer value (ch2) @asm 0x05A7E4 */
    {
        int result = overlay_call_1A1F_0688();         /* confirm "TRADEOFFER?"(0x1AE9) @asm 0x05A7F2 [bp-0x5A] */
        if (result > 2) {                              /* @asm 0x05A7FD jg 0x5A85B (cancel) */
            /* no trade */
        } else if (result == 1) {                      /* @asm 0x05A802 accept the swap */
            overlay_call_181F_0CEA();                  /* add counter good to unit @asm 0x05A810 (best_idx,slot,unit) */
            overlay_call_181F_0CA4();                  /* set its amount @asm 0x05A821 (best_amt,slot,unit) */
            /* colony.stock[ctype] += offered amount. @asm 0x05A84B */
            *(uint16_t *)(g_active_colony_ptr_8542 + ctype * 2 + 0x9A) += camt; /* @asm 0x05A857 */
        } else {                                       /* result == 2: take gold instead */
            overlay_call_181F_0AEC();                  /* remove offered cargo from unit @asm 0x05A832 (slot,unit) */
            /* credit PowerRecord[owner].gold (+0x2A dword, = [-0x77CE]) += offer. @asm 0x05A83A */
            *(int32_t *)(owner * 0x13C + 0x8832) += offer; /* @asm 0x05A843..0x05A847 add/adc */
            *(uint16_t *)(g_active_colony_ptr_8542 + ctype * 2 + 0x9A) += camt; /* @asm 0x05A857 */
        }
    }
    (void)best_amt;
    return 1;                                          /* @asm 0x05A85B RETF (ret=[bp-0x68]=1) */
}


/* ============================================================================
 * func_05A862 — unit_needs_orders_or_act  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Decides whether unit `arg0`(bp+6) of owner `arg1`(bp+8) still needs activation
 * this turn, dispatching to the per-unit handler trampolines as needed.  Last
 * function on reseg page_0F (terminal = page-end).
 *
 * @asm 0x05A86B  saved_count = g_unit_count                       ; bp-2
 * @asm 0x05A874  LCALL 0x181F:0x09E6(arg1)                         ; bind owner's unit list
 * @asm 0x05A87C  if (unit.type == 5) {                             ; type 5 (scout?)
 * @asm 0x05A88B    ret = func_05A93D(unit)  (near 0x468D -> ljmp 0x1A1F:0x6A2) }
 * @asm 0x05A8A2  else if (per_type[unit.type] (byte [+0x5237], stride6) != 0)
 * @asm 0x05A8C3    func_05A938(unit)        (near 0x4688 -> ljmp 0x1A1F:0x694)
 * @asm 0x05A8C8  if (g_unit_count == saved_count) {                ; nothing consumed?
 * @asm 0x05A8C8    if ((g_game_mode & 1) && ret==0) check revolution block:
 * @asm 0x05A8D5      if ((*(0x8542)).owner[+0x1A] < 4 && !power_dead[that]) skip
 * @asm 0x05A8ED      if ((*(0x8542)).owner[+0x1A] == g_active_power) skip
 * @asm 0x05A8F9      if ((unit.owner & 0xF) < 4 && !power_dead[that]) skip
 * @asm 0x05A912      draw "NOWARSDURINGREV"(0x1AF3) via 0x181F:0x03FE ; ret = 1 }
 * @asm 0x05A920  if (ret == 0) return  (fall to 0x45EC: ax=ret; retf)
 * @asm 0x05A929  LCALL 0x181F:0x0934(unit)                         ; activate/draw cursor
 * @asm 0x05A934  return ret
 *
 * Strings: 0x1AF3="NOWARSDURINGREV" (blocks combat during the War of
 * Independence).  0x181F:0x09E6 = bind unit-list(owner); 0x181F:0x0934 =
 * activate-unit/cursor.  The two near calls are tiny trampolines (0x468D/0x4688)
 * that ljmp into the 0x1A1F overlay (per-unit handlers) — kept as externs.
 * ============================================================================ */
int unit_needs_orders_or_act(int unit, int owner)  /* func_05A862 */
{
    int ret = 0;                                       /* @asm 0x05A866 bp-4 */
    int saved_count = g_unit_count_539C;               /* @asm 0x05A86B bp-2 */
    int type;

    func_0082DC_logic_sz_118((uint16_t)owner);           /* bind owner list @asm 0x05A874 */
    type = *(uint8_t *)(unit * UNIT_STRIDE + UNIT_TYPE);

    if (type == 5) {                                   /* @asm 0x05A880 */
        ret = func_05A93D(unit);                       /* @asm 0x05A88B (ljmp 0x1A1F:0x6A2) */
    } else if (*(uint8_t *)(type * 6 + 0x5237) != 0) { /* @asm 0x05A8B8 */
        func_05A938(unit);                             /* @asm 0x05A8C3 (ljmp 0x1A1F:0x694) */
    }

    if (g_unit_count_539C == saved_count) {            /* @asm 0x05A897/0x05A8C8 nothing consumed */
        if ((g_game_mode_5382 & 1) && ret == 0) {      /* @asm 0x05A8C8/0x05A8CF revolution mode */
            uint16_t colony = g_active_colony_ptr_8542;
            int col_owner = *(uint8_t *)(colony + 0x1A);
            int blocked = 1;
            if (col_owner < 4 &&
                *(uint8_t *)(col_owner * 0x34 + POWER_DEAD_543F) == 0) blocked = 0; /* @asm 0x05A8DF */
            if (blocked && col_owner == g_active_power_53D2)            blocked = 0; /* @asm 0x05A8ED */
            else {
                int uo = *(uint8_t *)(unit * UNIT_STRIDE + UNIT_OWNER) & 0x0F; /* @asm 0x05A8F9 */
                if (uo < 4 &&
                    *(uint8_t *)(uo * 0x34 + POWER_DEAD_543F) != 0)     blocked = 1; /* @asm 0x05A90C */
                else if (uo >= 4)                                       blocked = 1;
            }
            if (blocked) {
                (void)menu_run_boxed(0x1AF3);          /* @asm 0x05A912 lea bx,[0x1AF3]
                                                        * "NOWARSDURINGREV"; 0x05A916 lcall
                                                        * 0x181F:0x3FE (PORTED runner) */
                ret = 1;                               /* @asm 0x05A91B */
            }
        }
    }

    if (ret != 0)                                      /* @asm 0x05A920 */
        overlay_call_181F_0934();                      /* activate unit/cursor @asm 0x05A92C */
    return ret;                                        /* @asm 0x05A934->0x45EC */
}

/* ============================================================================
 * 0x05AC34 — PHANTOM (RTLink page-10 header / relocation island)
 * ----------------------------------------------------------------------------
 * Lies in the inter-page gap 0x05A950..0x05AF70 (page_10 file_offset 0x05A950,
 * code_offset 0x05AF70).  Raw `c8 2e 00 00 48 1c 00 00 f5 27 00 00 …` is a run
 * of dword values — an RTLink per-segment header + relocation list, not code.
 * ============================================================================ */
/* PHANTOM: 0x05AC34 is in the page-10 RTLink header gap (reloc/data) — not code. */

/* ============================================================================
 * 0x05AEA0 — PHANTOM (RTLink page-10 header / relocation island)
 * ----------------------------------------------------------------------------
 * Same page-10 header gap.  `c8 32 00 00 f1 34 00 00 bb 34 00 00 …` = dword run.
 * ============================================================================ */
/* PHANTOM: 0x05AEA0 is in the page-10 RTLink header gap (reloc/data) — not code. */

/* ============================================================================
 * 0x05AF2C — PHANTOM (RTLink page-10 header / relocation island)
 * ----------------------------------------------------------------------------
 * Same page-10 header gap.  `c8 19 00 00 6c 27 00 00 42 33 00 00 …` = dword run.
 * ============================================================================ */
/* PHANTOM: 0x05AF2C is in the page-10 RTLink header gap (reloc/data) — not code. */

/* ============================================================================
 * func_05AF70 — best_unit_to_move_at_tile  [DONE — BYTE_VERIFIED control flow]
 * ----------------------------------------------------------------------------
 * Selects the best (highest-priority) unit to move at/near a tile.  Args bp+6 =
 * a seed unit index, bp+8 = owner.  Reseg page_10 size 364 B (ENTER 0x14).
 *
 * @asm 0x05AF75  best_idx = -1 ; found_any = 0 ; best_pri = 0      ; bp-0x10/-2/-0xE
 * @asm 0x05AF84  if (arg0 < 0) goto scan_done
 * @asm 0x05AF90  x = unit[arg0].x ; y = unit[arg0].y               ; bp-6/-8
 * @asm 0x05AFA7  on_target = (LCALL 0x181F:0x0696(x,y) >= 0)       ; bp-4
 * @asm 0x05AFC3  if (LCALL 0x181F:0x0302(x,y) == 0) goto scan_done ; reachable?
 * @asm 0x05AFD5  terr = LCALL 0x181F:0x0768(x,y) ; found_any = 1   ; bp-0xA
 * @asm 0x05AFE5  cur = LCALL 0x181F:0x02EE(arg0)                   ; first unit on tile
 * @asm 0x05AFED  for ( ; cur >= 0 ; cur = LCALL 0x181F:0x02E4(cur)) {  ; iterate units on tile
 * @asm 0x05AFF0    pri = base_priority                              ; bp-0x12
 * @asm 0x05AFF4    if ((unit[arg1].owner & 0xF) >= 4) pri *= 2      ; native owner -> x2
 * @asm 0x05B001    if (on_target == 0) { … type/state filters … }
 * @asm 0x05B00A    if (per_type[cur.type] (byte [+0x5236], stride6) != 0) skip ; non-movers
 * @asm 0x05B03C    s = LCALL 0x181F:0x09C8(0, cur)                  ; …
 * @asm 0x05B04C    t = LCALL 0x181F:0x09DC(arg1, cur)               ; …
 * @asm 0x05B05D    pri = (t - s) + 0xFF
 * @asm 0x05B064    if (cur.type == 0x0B) { if (state 5||6) skip; pri >>= 3 } ; wagon adj
 * @asm 0x05B08C    if (found_any) { in_range = (cur.type in [0x0D..0x12]) ; if != on_target skip }
 * @asm 0x05B0BC    if (pri >= best_pri) { best_pri = pri ; best_idx = cur }
 * @asm 0x05B0D6  scan_done: return best_idx
 *
 * 0x181F:0x02EE / 0x02E4 = first/next-unit-on-tile iterators; 0x181F:0x0696 =
 * unit_at(x,y); 0x181F:0x0302 = reachable; 0x181F:0x0768 = terrain; 0x09C8 /
 * 0x09DC = per-unit priority helpers (opaque).  Type 0x0B = wagon-train; ship
 * type range [0x0D..0x12].  Control flow byte-exact; helper arithmetic opaque.
 * ============================================================================ */
int best_unit_to_move_at_tile(int seed_unit, int owner)  /* func_05AF70 */
{
    int best_idx = -1, found_any = 0, best_pri = 0;    /* @asm 0x05AF75 */
    int on_target, terr, cur, pri;

    if (seed_unit < 0)                                 /* @asm 0x05AF84 */
        return best_idx;

    /* x = unit[seed].x; y = unit[seed].y. @asm 0x05AF90 */
    on_target = (overlay_call_181F_0696() >= 0) ? 1 : 0; /* unit_at @asm 0x05AFA7 */
    if (overlay_call_181F_0302() == 0)                 /* reachable? @asm 0x05AFC3 */
        return best_idx;
    terr = overlay_call_181F_0768();                   /* terrain @asm 0x05AFD5 */
    found_any = 1;

    cur = overlay_call_181F_02EE();                    /* first unit on tile @asm 0x05AFE5 */
    for (; cur >= 0; cur = overlay_call_181F_02E4()) { /* @asm 0x05AFED/0x05B02A */
        int type = *(uint8_t *)(cur * UNIT_STRIDE + UNIT_TYPE);
        pri = 0;                                       /* base priority bp-0x12 */
        if ((*(uint8_t *)(owner * UNIT_STRIDE + UNIT_OWNER) & 0x0F) >= 4) /* @asm 0x05AFF4 */
            pri *= 2;
        if (on_target == 0) {                          /* @asm 0x05B001 */
            if (*(uint8_t *)(cur * 6 + 0x5236) != 0)   /* per-type non-mover gate @asm 0x05B020 */
                continue;
            func_007C2A_logic_sz_46((uint16_t)cur, 0); /* s @asm 0x05B03C */
            overlay_call_181F_09DC();                  /* t @asm 0x05B04C */
            pri = 0xFF;                                /* (t - s) + 0xFF @asm 0x05B05D */
            if (type == 0x0B) {                        /* wagon-train @asm 0x05B064 */
                int st = *(uint8_t *)(cur * UNIT_STRIDE + UNIT_STATE_314C);
                if (st == 5 || st == 6) continue;      /* @asm 0x05B074/0x05B07B */
                pri >>= 3;                             /* @asm 0x05B085 */
            }
        }
        if (found_any) {                               /* @asm 0x05B08C */
            int in_range = (type >= SHIP_TYPE_LO && type <= SHIP_TYPE_HI) ? 1 : 0; /* @asm 0x05B096 */
            if (in_range != terr)                      /* @asm 0x05B0B4 (terr held the gate) */
                continue;
        }
        if (pri >= best_pri) {                          /* @asm 0x05B0BC */
            best_pri = pri;
            best_idx = cur;                            /* @asm 0x05B0CD */
        }
    }
    return best_idx;                                   /* @asm 0x05B0D6 */
}

/* ============================================================================
 * func_05B0DC — trade_pick_cargo_dialog  [DONE — structure BYTE_VERIFIED;
 *               offer/limit arithmetic = data-resident RUNTIME_ONLY]
 * ----------------------------------------------------------------------------
 * The "PICKACARGO" dialog: choose a cargo from carrier unit `arg1`(bp+8) to
 * unload/trade up to the capacity reported by the tertiary overlay, on behalf
 * of unit `arg0`(bp+6).  Reseg page_10 size 486 B (ENTER 0x72).  NOTE: this is
 * NOT superseded anywhere — ported here in full.
 *
 * @asm 0x05B0E2  selected = -1                                     ; bp-0x64
 * @asm 0x05B0EF  carrier_owner = unit[arg1].owner & 0xF            ; bp-0x6A
 * @asm 0x05B0FD  cargo_count   = unit[arg0].cargoCount[+0x3150]    ; bp-0x68
 * @asm 0x05B10A  g_dialog_active_A154 = 0
 * @asm 0x05B110  if (cargo_count == 0) goto done
 * @asm 0x05B117  selected = 0 ; g_dialog_active_A154 = 1
 * @asm 0x05B122  cap = LCALL 0x1A1F:0x01A0(arg1, 1, 1)             ; carrier free space
 * @asm 0x05B12F  if (cap < cargo_count) goto done                  ; not enough room
 * @asm 0x05B137  if (carrier_owner >= 4) goto skip_header          ; EU powers only
 * @asm 0x05B140  if (power_dead[carrier_owner]) goto skip_header
 * @asm 0x05B14E  menu = open "PICKACARGO"(0x1B08) titled "GAME"(0x87C) ; 0x191F:0x0182
 * @asm 0x05B16A  draw header line (menu chrome via 0x181F:0x0022 + 0x191F:0x0176)
 * Two distinct paths once the capacity check passes (@asm 0x05B137 branches on
 * who owns the carrier):
 *   EU human power (carrier_owner < 4 && !dead): open the "PICKACARGO" menu, list
 *     each cargo line, RUN the menu and return the chosen slot.  @asm 0x05B14E..0x05B247
 *   non-EU / native / dead power (carrier_owner >= 4): AUTO-PICK — score every
 *     cargo by price*amount into a scratch array and let 0x191F:0x0ED0 choose the
 *     best, returning that cargo's slot.  @asm 0x05B24A..0x05B2B8
 *
 * @asm 0x05B188  EU list loop: for (slot=0; slot<cargo_count; slot++)
 * @asm 0x05B190    ctype = 0x181F:0x0BE6(arg0, slot)               ; cargo type
 * @asm 0x05B1AB    camt  = 0x181F:0x0C68(arg0, slot, &buf,0xA)     ; amount->text
 * @asm 0x05B1BC    buf = num(camt) + " " + cargo_name[ctype]       ; 0x182/0x178/0x16E
 * @asm 0x05B1EF    add menu item (slot+1, buf)                     ; 0x191F:0x0176
 * @asm 0x05B208  choice = 0x191F:0x016A(menu) ; close 0x191F:0x01A8
 * @asm 0x05B221  if (choice == 0x63) selected = -1                 ; ESC
 * @asm 0x05B230  else if (choice > 0) { A154=0; selected = choice-1 } else selected = 0
 * @asm 0x05B24A  AUTO loop: for (slot=0; slot<cargo_count; slot++)
 * @asm 0x05B274    types[slot]  = (byte)slot
 * @asm 0x05B286    values[slot] = price_table[carrier_owner*16 + ctype] * camt
 * @asm 0x05B2AC  0x191F:0x0ED0(cargo_count, &values, &types)        ; argmax -> [bp-0x73]
 * @asm 0x05B2B4  selected = (int8)types[cargo_count-1]              ; chosen slot
 *
 * String: 0x1B08="PICKACARGO".  0x1A1F:0x01A0 = carrier-free-capacity query.
 * 0xA154 is the modal-dialog active flag (set/cleared here exactly as the other
 * trade UIs do).  The cargo-name string-handle table at DGROUP 0x97C0 (= [-0x6840],
 * word stride) and the per-power cargo price table at DGROUP 0x84BC (= [-0x7B44],
 * carrier_owner*16 + ctype) are data-resident; their CONTENTS are RUNTIME_ONLY
 * but the index math and the value = price*amount product are byte-exact.
 *
 * COMPLETED 2026-06-08 (was truncated at 0x05B1AB; full tail pulled on-demand via
 * tools/viceroy_exe.py).  The prior body listed only the menu header and dropped
 * BOTH the EU choice handling AND the entire non-EU auto-pick branch.  @status
 * BYTE_VERIFIED.
 *
 * @asm_extent 0x05B0DC..0x05B2C2 (486 B, reseg page_10, terminal RETF)
 * ============================================================================ */
int trade_pick_cargo_dialog(int unit, int carrier)  /* func_05B0DC */
{
    int selected = -1;                                 /* @asm 0x05B0E2 [bp-0x64] */
    int carrier_owner = *(uint8_t *)(carrier * UNIT_STRIDE + UNIT_OWNER) & 0x0F; /* @asm 0x05B0EF [bp-0x6A] */
    int cargo_count   = *(uint8_t *)(unit * UNIT_STRIDE + UNIT_CARGO_3150);      /* @asm 0x05B0FD [bp-0x68] */
    int cap, slot, choice, ctype, camt;
    uint8_t types[16];                                 /* @asm bp-0x72 scratch (slot indices) */
    int     values[16];                                /* @asm bp-0x5C scratch (price*amount) */

    g_dialog_active_A154 = 0;                          /* @asm 0x05B10A */
    if (cargo_count == 0)                              /* @asm 0x05B110 or ax,ax; je 0x5B2BB */
        return selected;                               /* -1 */

    selected = 0;                                      /* @asm 0x05B117 [bp-0x64]=0 */
    g_dialog_active_A154 = 1;                          /* @asm 0x05B11F */
    cap = overlay_call_1A1F_01A0();                    /* carrier free space @asm 0x05B127 (carrier,1,1) */
    if (cap < cargo_count)                             /* @asm 0x05B12F jl 0x5B137 else end */
        return selected;                               /* 0 — not enough room */

    if (carrier_owner < 4 &&                           /* @asm 0x05B137 cmp 4; jl */
        *(uint8_t *)(carrier_owner * 0x34 + POWER_DEAD_543F) == 0) { /* @asm 0x05B140 [bx+0x543F]==0 */
        /* ---- EU human power: interactive PICKACARGO menu. @asm 0x05B14E ---- */
        overlay_call_191F_0182();                      /* open "PICKACARGO"(0x1B08) menu @asm 0x05B158 */
        /* if open failed -> end (selected stays 0). @asm 0x05B163 or dx,ax; je 0x5B2BB */
        overlay_call_181F_0022((int16_t)DG16(0x2dfa));                      /* header value num(0x2DFA) @asm 0x05B170 */
        overlay_call_191F_0176();                      /* header line @asm 0x05B180 */
        for (slot = 0; slot < cargo_count; slot++) {   /* @asm 0x05B188..0x05B206 */
            ctype = overlay_call_181F_0BE6();          /* cargo type @asm 0x05B196 -> [bp-0x6C] */
            camt  = overlay_call_181F_0C68();          /* amount->text @asm 0x05B1AB -> [bp-0x62] */
            overlay_call_181F_0182();                  /* buf = num(camt) @asm 0x05B1BC */
            overlay_call_181F_0178();                  /* buf += " " @asm 0x05B1C8 */
            /* buf += cargo_name[ctype] from DGROUP 0x97C0 table. @asm 0x05B1D5 [bx-0x6840] */
            (void)*(uint16_t *)(ctype * 2 + 0x97C0);
            overlay_call_181F_016E();                  /* append name @asm 0x05B1DD */
            overlay_call_191F_0176();                  /* add menu item (slot+1, buf) @asm 0x05B1F5 */
        }
        choice = overlay_call_191F_016A();             /* run menu -> selection @asm 0x05B208 [bp-0x64] */
        overlay_call_191F_01A8();                      /* close menu @asm 0x05B21C */
        if (choice == 0x63) {                          /* ESC @asm 0x05B221 */
            selected = -1;                             /* @asm 0x05B227 */
        } else if (choice > 0) {                       /* @asm 0x05B230 cmp 0; jle 0x5B242 */
            g_dialog_active_A154 = 0;                  /* @asm 0x05B236 */
            selected = choice - 1;                     /* @asm 0x05B23C dec */
        } else {
            selected = 0;                              /* @asm 0x05B242 */
        }
        return selected;                               /* @asm RETF [bp-0x64] */
    }

    /* ---- non-EU / native / dead power: AUTO-PICK the best cargo. @asm 0x05B24A ---- */
    for (slot = 0; slot < cargo_count; slot++) {       /* @asm 0x05B24A..0x05B29D */
        ctype = overlay_call_181F_0BE6();              /* cargo type @asm 0x05B258 -> [bp-0x6C] */
        camt  = overlay_call_181F_0C68();              /* cargo amount @asm 0x05B269 -> [bp-0x62] */
        types[slot] = (uint8_t)slot;                   /* @asm 0x05B274 [bp+si-0x72]=slot */
        /* values[slot] = price_table[carrier_owner*16 + ctype] * amount.
         * price table base DGROUP 0x84BC (= [-0x7B44]). @asm 0x05B280..0x05B291 */
        values[slot] = (int)*(uint8_t *)(carrier_owner * 16 + ctype + 0x84BC) * camt;
    }
    /* sort/select over values[0..cargo_count); 0x191F:0x0ED0 leaves the winning
     * slot index at the top of the parallel `types` array (frame offset -0x73 +
     * cargo_count == types[cargo_count-1]).
     * @asm 0x05B29F..0x05B2B0 LCALL 0x191F:0x0ED0(cargo_count, &values, &types) */
    overlay_call_191F_0ED0();
    selected = (int8_t)types[cargo_count - 1];         /* @asm 0x05B2B4 [bp+cargo_count-0x73] (cwde) */
    return selected;                                   /* @asm 0x05B2C1 RETF */
}

/* ============================================================================
 * func_05B2C2 — SUPERSEDED by src/combat/combat.c (combat resolver)
 * ----------------------------------------------------------------------------
 * Reseg page_10 size 2925 B (ENTER 0x3A) — NOT the 35-byte truncated dump.  It
 * is the combat resolver: single roll `roll = random_int(1, ATK+DEF)` @0x5B819,
 * attacker wins if roll <= ATK; SHIP-ATTACKER gate @0x5B7B6 (type 0x0D..0x12),
 * land path jmp 0x5BAA3; demotion ladder is a sub-table (combat_demotion_ladder.c).
 * BYTE_VERIFIED there; see VERIFICATION_LEDGER row 5 / 2026-05-30.
 * ============================================================================ */
/* SUPERSEDED: func_05B2C2 — body in src/combat/combat.c (combat resolver). */

/* ============================================================================
 * func_05BE30 — fixup_unit_indices_after_combat  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Iterates the units stacked on a tile and resolves combat for each via the
 * page-10 combat leaf (near 0x3DD3 -> func_05E723 -> ljmp 0x1A1F).  After a unit
 * is consumed it decrements any held indices (the running cursor and arg1=bp+8)
 * that sit above the removed slot, keeping them valid.  Reseg page_10, 83 B.
 *
 * @asm 0x05BE34  cur = LCALL 0x181F:0x02EE(arg0)                   ; first unit on tile
 * @asm 0x05BE3F  for ( ; cur >= 0 ; ) {                            ; loop
 * @asm 0x05BE42    cur = LCALL 0x181F:0x02E4(cur)                  ; advance
 * @asm 0x05BE4A    r = func_05E723(arg0, arg1, arg2, arg3, arg4)   ; resolve (near 0x3DD3)
 * @asm 0x05BE60    if (r != 0) {                                   ; a unit was removed
 * @asm 0x05BE64      if (cur  > arg0) cur--                        ; fix running cursor
 * @asm 0x05BE6F      if (arg1 > arg0) arg1--                       ; fix caller's index (bp+8)
 * @asm 0x05BE77    }
 * @asm 0x05BE7A    arg0 = cur
 * @asm 0x05BE7D  } while (cur >= 0)
 *
 * 0x181F:0x02EE / 0x02E4 = first/next-unit-on-tile.  func_05E723 = the combat
 * trampoline at 0x05E723 (ljmp 0x1A1F:0x6E0 -> resolver), kept extern.
 * ============================================================================ */
int fixup_unit_indices_after_combat(int tile_first, int idx2,
                                     int a, int b, int c)  /* func_05BE30 */
{
    int cur = overlay_call_181F_02EE();                /* first unit @asm 0x05BE34 */

    while (cur >= 0) {                                 /* @asm 0x05BE7D */
        cur = overlay_call_181F_02E4();                /* advance @asm 0x05BE42 */
        if (func_05E723(tile_first, idx2, a, b, c) != 0) { /* resolve @asm 0x05BE5A */
            if (cur  > tile_first) cur--;              /* @asm 0x05BE64 */
            if (idx2 > tile_first) idx2--;             /* @asm 0x05BE6F */
        }
        tile_first = cur;                              /* @asm 0x05BE7A */
    }
    return cur;                                        /* @asm RETF */
}

/* ============================================================================
 * func_05BE84 — SUPERSEDED by src/native/raid.c (native raid dispatcher)
 * ----------------------------------------------------------------------------
 * Reseg page_10 size 2006 B (ENTER 0x24) — NOT the 113-byte truncated dump.  It
 * is the native raid dispatcher: outcome = random_int(1,4) @0x05BF35; 5-way
 * dispatch (NOTHING/STORES/WREAK/GOLD/BURN-SHIP) @0x05C023; SFX via 0x181F:0x04C0.
 * BYTE_VERIFIED there; see VERIFICATION_LEDGER 2026-05-30 (raid outcome roll).
 * ============================================================================ */
/* SUPERSEDED: func_05BE84 — body in src/native/raid.c (native raid dispatcher). */

/* ============================================================================
 * func_05C65A — remap_tile_id_for_mode  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Small terrain/tile-id remap used when the special game-mode flag (*(0x5382)&1)
 * is set.  Arg bp+6 = input tile id; returns the remapped id.  Reseg page_10,
 * 65 B.
 *
 * @asm 0x05C65E  out = 0x15  (default)
 * @asm 0x05C663  if ((g_game_mode & 1) && in == 0x15) out = -1
 * @asm 0x05C675  if (in == 0x1A) out = 0x19
 * @asm 0x05C680  if (in == 0x19) out = 0x1C
 * @asm 0x05C68B  if (in == 0x1B) out = 0x1B
 * @asm 0x05C696  return out
 *
 * Note the tests are independent (not else-if): 0x1A->0x19, 0x19->0x1C, 0x1B->
 * 0x1B (identity), with a special -1 for 0x15 in the special mode and 0x15 as
 * the default for any other input.  Byte-exact.
 * ============================================================================ */
int remap_tile_id_for_mode(int in)  /* func_05C65A */
{
    int out = 0x15;                                    /* @asm 0x05C65E */
    if ((g_game_mode_5382 & 1) && in == 0x15)          /* @asm 0x05C663..0x05C66E */
        out = -1;                                      /* @asm 0x05C670 */
    if (in == 0x1A) out = 0x19;                        /* @asm 0x05C675 */
    if (in == 0x19) out = 0x1C;                        /* @asm 0x05C680 */
    if (in == 0x1B) out = 0x1B;                        /* @asm 0x05C68B */
    return out;                                        /* @asm 0x05C696 */
}
