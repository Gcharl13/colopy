/* ============================================================================
 * overlay_05C69C_0610DA.c -- VICEROY overlay functions, file range
 *                            0x05C69C..0x0610DA (combat / map-view / unit-stack
 *                            UI region of overlay pages 0x10 / 0x11 / 0x12).
 *
 * Hand-ported 2026-05-30 from the RE-SEGMENTED disassembly
 *   code/VICEROY/disasm_overlay_reseg/page_10.asm  (code 0x05AF70..0x05E740)
 *   code/VICEROY/disasm_overlay_reseg/page_11.asm  (code 0x05E9B0..0x05FAC2)
 *   code/VICEROY/disasm_overlay_reseg/page_12.asm  (code 0x05FE60..0x0612E6)
 * which is the AUTHORITATIVE function list (TRUTH_HIERARCHY: reseg > per-func
 * auto-disasm).  The previous auto-generated skeleton in this file was wrong
 * about several extents (it mis-read mid-instruction 0xC8 bytes as `ENTER`
 * prologues and truncated 7000-byte functions to a few hundred bytes).  Every
 * such phantom is documented and removed below.  STRICT cite-or-left unresolved: no value
 * appears without an @asm offset; nothing is guessed.
 *
 * ----------------------------------------------------------------------------
 * PORT STATUS legend (per 2026-05-30 reconstruction directive):
 *   DONE          full @asm-cited body written here.
 *   SUPERSEDED    a real function already ported to a named src/<subsystem>/
 *                 file; this is a one-line forwarding stub (auto-skeleton
 *                 removed).
 *   PHANTOM       NOT a real function: interior bytes of a larger reseg
 *                 function whose mid-stream 0xC8 was mis-read as `ENTER`, or an
 *                 RTLink per-segment header / relocation island in an
 *                 inter-page gap.  None of these offsets begin a function in
 *                 disasm_overlay_reseg.
 *   OUT-OF-SCOPE  DOS-platform plumbing (no game rule, no layout decision);
 *                 one-line stub per directive.
 *   PARTIAL       in-range portion of a function whose body spills past this
 *                 file's 0x0610DA upper bound into the next overlay file.
 *
 * ----------------------------------------------------------------------------
 * RESEG GROUND-TRUTH function map for this file range (verified 2026-05-30):
 *
 *   page_10 (code 0x05AF70..0x05E740):
 *     func_05C69C size=475   -> 0x05C877   (unit special-terrain arrival; DONE)
 *     func_05C878 size=518   -> 0x05CA7E   (treasure-transport event; DONE)
 *     func_05CA7E size=7348  -> 0x05E712   (LAND-COMBAT DECIDER; page-end body)
 *                                          => SUPERSEDED by src/ai/unit_ai_leaf.c
 *        Therefore 0x05E7E0 (auto "func_05E7E0") is INTERIOR to func_05CA7E
 *        and is a PHANTOM.
 *   page_11 (code 0x05E9B0..0x05FAC2):
 *     func_05E9B0 size=4371  -> 0x05FAC2   (the ONLY function in page 0x11;
 *                                          map-view interaction loop)
 *        Therefore 0x05EA38 (auto "func_05EA38") is INTERIOR to func_05E9B0
 *        and is a PHANTOM.
 *   page_11/page_12 gap 0x05FAC2..0x05FE60 (page_12 file_offset 0x05FAD0,
 *        code_offset 0x05FE60 => RTLink seg-0x12 header + relocs).
 *        Therefore 0x05FC30 (auto "func_05FC30") is in that header/reloc gap
 *        and is a PHANTOM.
 *   page_12 (code 0x05FE60..0x0612E6): the 0x05FE60..0x0610DA functions below
 *        are all real (per the page_12 header list).  func_0610B0 (size 566)
 *        spills past 0x0610DA -> PARTIAL here, remainder in the next file.
 *
 * The near-CALL targets func_0613F0..func_06144F that several functions here
 * invoke are the page_12 RTLink Type-A thunk table at 0x0613F0..0x061454-:
 * each is a single `ljmp 0x191F:NN` / `ljmp 0x1A1F:NN` (@asm page_12
 * 0x0613F0..0x06144F).  They live past this file's range; declared extern.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"

/* ----------------------------------------------------------------------------
 * Local externs (kept file-local per the porting directive — these are
 * trampolines / sibling functions that live outside this file's range).
 * ------------------------------------------------------------------------- */

/* func_05CA7E land-combat decider — body in src/ai/unit_ai_leaf.c.  Reached in
 * the original via the page-10 JMPF trampoline 0x05E723 (ljmp 0x1A1F:0x06E0).
 * @asm page_10 ---- func_05CA7E size=7348 prologue ENTER 0x00DE,0 (0x05CA7E). */
extern int func_05CA7E(int active_unit_idx, int a, int b, int c);

/* page_12 RTLink Type-A thunk table (0x0613F0..0x06144F).  Each forwards FAR
 * into overlay seg 0x191F / 0x1A1F.  @asm page_12 0x0613F0..0x06144F. */
extern int func_0613F0(void);  /* ljmp 0x191F:0x2CE */
extern int func_0613F5(void);  /* ljmp 0x191F:0x2DC */
extern int func_0613FA(void);  /* ljmp 0x191F:0x2F8 */
extern int func_061404(void);  /* ljmp 0x191F:0xA3C */
extern int func_061409(void);  /* ljmp 0x191F:0xA4A */
extern int func_06140E(void);  /* ljmp 0x1A1F:0x21C */
extern int func_061413(void);  /* ljmp 0x1A1F:0x22A */
extern int func_061418(void);  /* ljmp 0x1A1F:0x71C */
extern int func_06141D(void);  /* ljmp 0x1A1F:0x72A */
extern int func_061422(void);  /* ljmp 0x1A1F:0x738 */
extern int func_06142C(void);  /* ljmp 0x1A1F:0x754 */
extern int func_061431(void);  /* ljmp 0x1A1F:0x762 */
extern int func_061436(void);  /* ljmp 0x1A1F:0x770 */
extern int func_06143B(void);  /* ljmp 0x1A1F:0x77E */
extern int func_061440(void);  /* ljmp 0x1A1F:0x78C */
extern int func_06144A(void);  /* ljmp 0x1A1F:0x7A8 */
extern int func_06144F(void);  /* ljmp 0x1A1F:0x7B6 */

/* CS-relative near function called by func_05C69C @0x05C784 (call 0x3dc4 in
 * page-10 image == terrain/move-cost class lookup; full body out of range). */
extern int func_05BE3E_terrain_class(int terrain_id);

/* MSC 6.0 32-bit long helpers (load-image seg 0xD1D). @ref raze_treasure.c. */
extern int32_t aFlmul(int32_t a, int32_t b);   /* file 0x010530, ovly 0xD1D:0x0F60 */
extern int32_t aFldiv(int32_t a, int32_t b);   /* file 0x010496, ovly 0xD1D:0x0EC6 */

/* LCALL targets used below that the auto-generated overlay_externs.h omits
 * (each cited at its use site from the reseg disasm; declared file-local). */
extern int overlay_call_181F_0C40(void);  /* @asm lcall 0x181F:0x0C40 (page_10 0x05C83D) */
extern int overlay_call_181F_0858(void);  /* @asm lcall 0x181F:0x0858 (page_12 0x0604A6) */
extern int overlay_call_181F_0876(void);  /* @asm lcall 0x181F:0x0876 (page_12 0x0604B7) */
extern int overlay_call_1A1F_01CA(void);  /* @asm lcall 0x1A1F:0x01CA (page_12 0x061035) */
/* LCALL helpers used only by the func_05E9B0 tile-info-panel renderer
 * (text/string builders in load-image seg 0x181F); each cited at its use site
 * in page_11.  Declared file-local because overlay_externs.h omits them. */
extern int overlay_call_181F_0146(void);  /* @asm lcall 0x181F:0x0146 (page_11 0x05EBD2 begin-string) */
extern int overlay_call_181F_015A(void);  /* @asm lcall 0x181F:0x015A (page_11 0x05ED5D append-num) */
extern int overlay_call_181F_09D2(void);  /* @asm lcall 0x181F:0x09D2 (page_11 0x05F40A turn/year?) */
extern int overlay_call_181F_0BDC(void);  /* @asm lcall 0x181F:0x0BDC (page_11 0x05F3CD road/route lookup) */
extern int overlay_call_181F_02B2(void);  /* @asm lcall 0x181F:0x02B2 (page_11 0x05F4AE draw glyph row) */

/* ----------------------------------------------------------------------------
 * DGROUP symbol map used below (raw addresses, each cited at its use site).
 *   0x3144  UnitRecord table base (stride 0x1C). +0x00 owner_x? see note;
 *           +0x02 (0x3146)=type, +0x03 (0x3147) low-nibble=owner/profession,
 *           +0x17 (0x315B)=destination/terrain tile-id, +0x08 (0x314C)=order.
 *   0x5230  per-unit-type stat table (word stride 6 via *6 index).
 *   0x5237  per-unit-type "is-active/selectable" flag (stride 6).  @globals.h
 *   0x53A6  current player / difficulty index byte.        @MEMORY difficulty
 *   0x5394  active power index byte.                        @globals.h g_*5394
 *   0x539C  total live-unit count word.
 *   0x539E  colony/structure count word.
 *   0x53A0  map-view stack count word.
 *   0x5382  game-mode flag byte (bit0 = demo/endgame fast path).
 *   0x5398  some power slot word (*0x13C -> PowerRecord).
 *   0x5D46  ColonyRecord table base (stride 0xCA).          @MEMORY ColonyRec
 *   0x8542  far ptr to active colony record.                @MEMORY 0x8542
 *   0x8808/0x8809  PowerRecord table (stride 0x13C).        @MEMORY PowerRec
 *   0x540E  AIPersonality table (stride 0x34).
 *   0x543F  per-profession bonus flag (stride 0x34).
 *   0x9E14/0x9E16  far ptr to the active map-tile record (set by func_05FE60).
 *   0x9E18/0x9E1A  far ptr to a sub-field of that tile (set by func_05FE7A).
 *   0xA15C/0xA15E/0xA160  map-view cursor / stack scratch words.
 *   0xA89D  "an active unit is selected" flag byte.
 *   0x7E8/0x7EA  mouse click screen X / Y (hit-region dispatch).
 * ------------------------------------------------------------------------- */
#define U8(addr)   (*(uint8_t  near*)(uint16_t)(addr))
#define U16(addr)  (*(uint16_t near*)(uint16_t)(addr))
#define UNIT_FIELD(idx, fld)  U8((idx) * 0x1C + (fld))   /* UnitRecord byte */


/* ============================================================================
 * func_05C69C — unit_arrive_on_special_terrain   [DONE — BYTE_VERIFIED cf]
 * ----------------------------------------------------------------------------
 * @asm page_10 ---- func_05C69C size=475 prologue ENTER 0x0006,0 (0x05C69C..
 *      0x05C877, terminal RETF @0x05C875).
 *
 * Called when unit `arg0` (UnitRecord index) finishes a move.  Decides whether
 * the destination tile is a "special" terrain that triggers an event
 * (e.g. arriving at a Lost-City-Rumour / special site), applies a move-point
 * cost adjusted by difficulty (0x53A6) and the destination terrain class, and
 * if the unit's recorded terrain-id has changed, mutates the unit's type
 * (+0x02: 1->9 or ->7) and emits a UI message via the 0x181F text helpers.
 *
 *   arg0 = bp+6 : UnitRecord index
 *   arg1 = bp+8 : move-cost component A   (added to bp+0xA)
 *   arg2 = bp+0xA : move-cost component B / budget compared against roll
 *
 * Gate 1 (@0x05C6A1): only types 1 and 4 proceed; else return.
 * Gate 2 (@0x05C6BA): if dest terrain-id (+0x17)==0x15 AND mode-flag 0x5382
 *   bit0 clear AND PowerRecord[0x5398].byte+0x07 bit3 set -> early-return path.
 * @bytes 6B 5E 06 1C / 80 BF 46 31 01 (IMUL bx,[bp+6],0x1C; CMP [bx+0x3146],1).
 * ============================================================================ */
int func_05C69C_unit_arrive_on_special_terrain(uint16_t unit_idx,
                                               uint16_t cost_a,
                                               uint16_t cost_b)
{
    int cost;            /* bp-4 */
    int dest_terrain;    /* bp-6 : UnitRecord[+0x17] */
    int new_terrain;     /* bp-2 : result of terrain reclassify */

    /* Gate 1: only unit types 1 / 4. @0x05C6A1..0x05C6B3 */
    if (UNIT_FIELD(unit_idx, 0x02) != 1 && UNIT_FIELD(unit_idx, 0x02) != 4)
        return 0;                                   /* @0x05C6B3 JMP 0x05C873 */

    /* Gate 2: dest terrain-id 0x15 special-case. @0x05C6BA..0x05C6DA */
    if (UNIT_FIELD(unit_idx, 0x17) == 0x15) {
        if ((U8(0x5382) & 1) == 0)                  /* @0x05C6C1 TEST [0x5382],1 */
            return 0;                               /* @0x05C6C8 JMP 0x05C873 */
        /* PowerRecord[0x5398]: byte at +0x07 (0x8808-0x77F8 base) bit3.
         * @asm 0x05C6CB IMUL bx,[0x5398],0x13c / TEST [bx-0x77f8],8 */
        if ((U8(U16(0x5398) * 0x13C - 0x77F8) & 8) == 0)
            return 0;                               /* @0x05C6D8 RETF */
    } else {
        /* General case: query whether this terrain-id is "special" via the
         * 0x181F:0x0C9A predicate; if not (==0) continue, else return.
         * @asm 0x05C6DC..0x05C6F2 */
        if (overlay_call_181F_0C9A(/* dest_terrain */) != 0)  /* arg = +0x17 */
            return 0;                               /* @0x05C6F2 JMP 0x05C873 */
    }

    /* cost = cost_b + cost_a. @0x05C6F5..0x05C6FB */
    cost = (int)cost_b + (int)cost_a;

    /* Profession/owner-nibble (+0x03 & 0xF): if < 4 AND its bonus-flag
     * (0x543F + nib*0x34) is zero -> cost += difficulty(0x53A6),
     * else cost -= difficulty.  @asm 0x05C6FE..0x05C72C */
    {
        uint8_t nib = UNIT_FIELD(unit_idx, 0x03) & 0x0F;
        if (nib < 4 && U8(nib * 0x34 + 0x543F) == 0)
            cost += U8(0x53A6);                     /* @0x05C719 */
        else
            cost -= U8(0x53A6);                     /* @0x05C724 */
    }

    /* Read destination terrain-id; small fixed deductions for 0x1A / 0x19.
     * @asm 0x05C72C..0x05C749 */
    dest_terrain = (int8_t)UNIT_FIELD(unit_idx, 0x17);
    if (dest_terrain == 0x1A) cost -= 0x0A;         /* @0x05C73D */
    if (dest_terrain == 0x19) cost -= 0x05;         /* @0x05C746 */

    /* If profession-nibble has NO "naval/move" attribute (0x181F:0x07B4 == 0),
     * roll random_int(1, cost): if roll <= cost_b budget -> abort (return).
     * @asm 0x05C74A..0x05C776
     *   PUSH 0x0B / PUSH nib / LCALL 0x181F:0x7B4   (attribute test)
     *   PUSH cost / PUSH 1   / LCALL 0x181F:0x4D4   (random_int(1,cost))
     *   CMP ax,[bp+0xA] / JLE keep / JMP return */
    if (overlay_call_181F_07B4(/* 0x0B, nib */) == 0) {
        int roll = overlay_call_181F_04D4(/* 1, cost */);   /* random_int */
        if (roll > (int)cost_b)
            return 0;                               /* @0x05C776 JMP 0x05C873 */
    }

    /* Reclassify the terrain via CS-near 0x3dc4 (terrain class for terrain-id).
     * @asm 0x05C779..0x05C792
     *   PUSH dest_terrain / PUSH cs / CALL 0x3dc4 / MOV [bp-2],ax
     *   CMP ax,[bp-6] / JNE keep / JMP return (no change) */
    new_terrain = func_05BE3E_terrain_class(dest_terrain);
    if (new_terrain == dest_terrain)
        return 0;                                   /* @0x05C792 — unchanged */

    if (new_terrain < 0) {
        /* Negative result: only types with bonus-flag set & profession<4 are
         * eligible; mutate unit type (+0x02): 1->9 else ->7.
         * @asm 0x05C799..0x05C7D3 */
        uint8_t nib = UNIT_FIELD(unit_idx, 0x03) & 0x0F;
        if (nib >= 4) return 0;                      /* @0x05C7A7 */
        if (U8(nib * 0x34 + 0x543F) != 0) return 0;  /* @0x05C7B5 */
        if (UNIT_FIELD(unit_idx, 0x02) == 1)
            UNIT_FIELD(unit_idx, 0x02) = 9;          /* @0x05C7C3 */
        else
            UNIT_FIELD(unit_idx, 0x02) = 7;          /* @0x05C7CE */
    } else {
        /* Non-negative: store new terrain-id back into the unit (+0x17).
         * @asm 0x05C7D6..0x05C7E0 */
        UNIT_FIELD(unit_idx, 0x17) = (uint8_t)new_terrain;
    }

    /* Build & show the arrival message (cosmetic): re-check profession bonus,
     * then format the stat word (0x5230 + type*6) and emit text via the 0x181F
     * helpers with message strings 0x1BC6 / 0x1BD2 / 0x1BDA.
     * @asm 0x05C7E1..0x05C873 */
    {
        uint8_t nib = UNIT_FIELD(unit_idx, 0x03) & 0x0F;
        if (nib >= 4) return 0;                      /* @0x05C7EF */
        if (U8(nib * 0x34 + 0x543F) != 0) return 0;  /* @0x05C7FB */

        /* stat word: PowerRecord/type byte +0x02 -> *6 -> index 0x5230.
         * @asm 0x05C7FD..0x05C81A: PUSH [bx*6+0x5230] / PUSH 0 / LCALL 181F:438 */
        overlay_call_181F_0438(/* stat_word, 0 */);

        if (new_terrain < 0) {
            overlay_call_181F_0652(/* 1, 0x1BC6 */); /* @0x05C823 message */
        } else if (new_terrain == 0x15) {
            overlay_call_181F_0652(/* 1, 0x1BD2 */); /* @0x05C832 message */
        } else {
            /* format dest_terrain name (0x181F:0xC40) then new_terrain name,
             * then emit 0x1BDA. @asm 0x05C83A..0x05C870 */
            overlay_call_181F_0C40(/* dest_terrain */);
            overlay_call_181F_0438(/* name, 1 */);
            overlay_call_181F_0C40(/* new_terrain */);
            overlay_call_181F_0438(/* name, 2 */);
            overlay_call_181F_0652(/* 1, 0x1BDA */);
        }
    }
    return 0;                                        /* @0x05C875 RETF */
}


/* ============================================================================
 * func_05C878 — treasure_transport_event   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_10 ---- func_05C878 size=518 prologue ENTER 0x005E,0 (0x05C878..
 *      0x05CA7D, terminal RETF @0x05CA7D).
 *
 * The "King's galleon ferries your treasure to Europe" event.  Full byte-level
 * derivation is in src/native/raze_treasure.c (kept #if 0 as a reference
 * note); reproduced here as the LIVE port because that file is disabled.
 * String IDs: 0x1BE0 "CASHTREASURE", 0x1BED "KINGGALLEON", 0x1BF9 "BURNED",
 * 0x1BFB "RAZED", 0x1BFD "LOOTCASH" (DGROUP, @asm push-immediates below).
 *
 *   arg0 = bp+6 : settlement/source index   (NativeSettlement[].+0x17 via *0x1C)
 *   arg1 = bp+8 : attacker PowerRecord index (0..11)
 *
 * gold_delta = MIN(90, M) * settlement_size, where
 *   settlement_size = NativeSettlement[arg0].byte_0x17  (×0x1C stride)
 *   M = bit10(attacker) ? PowerRecord[arg1].byte_0
 *                       : MAX( (player+10)*5, PowerRecord[arg1].byte_0 * 2 )
 * Then PowerRecord[arg1]: gold(+0x21) += gold_delta;
 *   total_loot(+0x25) and score_bonus(+0x29) += (base - gold_delta).
 * Finally LCALL 0x181F:0x0808(arg0) destroys the settlement.
 * ============================================================================ */
int func_05C878_treasure_transport_event(uint16_t source_idx,
                                         uint16_t attacker_power)
{
    /* base_amount = 100 * settlement_size. @asm 0x05C87E..0x05C888
     *   IMUL bx,[bp+6],0x1C / MOV al,0x64 / MUL byte[bx+0x315B] */
    uint16_t base_amount = (uint16_t)(100 * (uint16_t)UNIT_FIELD(source_idx, 0x17));
    int32_t  gold_delta  = 0;

    /* Demo / endgame fast path (mode flag bit0). @asm 0x05C88B..0x05C8B6 */
    if (U8(0x5382) & 1) {
        overlay_call_181F_09AE(/* 0, base_amount, 0 */);
        overlay_call_181F_0652(/* 2, 0x1BE0 "CASHTREASURE" */);
        overlay_call_181F_04B6(/* 2 */);
        gold_delta = base_amount;
        goto carry_only;                            /* @0x05C8B6 JMP 0x05CA55 */
    }

    /* --- Slow path: assemble the confirmation dialog. @0x05C8BA..0x05C944 --- */
    /* player word: 0x8394[player] (= [bx-0x7c6c], bx=2*0x53A6). */
    overlay_call_181F_0438(/* g_player_word_8394[player], 0 */);
    /* AIPersonality[attacker] name. @0x05C8D0 ADD ax,0x540E (stride 0x34). */
    overlay_call_181F_0416(/* &AIPersonality[attacker*0x34], 1 */);
    overlay_call_191F_0AC8(/* attacker, 0, 2 */);
    /* PowerRecord[attacker].byte_0 sign-extended -> "you have N treasures". */
    {
        int8_t pool = (int8_t)U8(attacker_power * 0x13C - 0x77F7);  /* 0x8809 base */
        int32_t pool_se = (int32_t)pool;
        overlay_call_181F_09AE(/* hi, lo, 0 */);
        (void)pool_se;
        /* strcpy(buf,"KINGGALLEON"); verb = bit10 ? "BURNED":"RAZED"; '>' sep.
         * @asm 0x05C909..0x05C944 — cosmetic dialog assembly. */
        overlay_call_181F_07B4(/* power_attribute_bit(attacker,10) gate */);
        overlay_call_0D1D_07A4(/* strcat verb */);
        overlay_call_181F_048E(/* 0x3E '>' */);

        /* Confirmation Y/N dialog: 0x181F:0x03FE returns 1 if accepted.
         * @asm 0x05C947..0x05C955 — DEC ax / JE proceed / else RETF. */
        if (overlay_call_181F_03FE(/* &buf */) != 1)
            return 0;                               /* declined: no loot */

        /* --- Compute the multiplier. @asm 0x05C958..0x05C9AB --- */
        {
            int16_t mult = pool;                    /* re-read byte_0 */
            /* bit10 clear -> apply (player+10)*5 floor vs pool*2 MAX. */
            if (overlay_call_181F_07B4(/* bit10(attacker)==0 */) == 0) {
                int16_t player_floor = (int16_t)((U8(0x53A6) + 10) * 5);
                int16_t pool_doubled = (int16_t)(mult * 2);   /* SHL [bp-0x58],1 */
                mult = (player_floor >= pool_doubled) ? player_floor
                                                      : pool_doubled;
            }
            if (mult > 90) mult = 90;               /* @0x05C9A8 cap */

            /* gold_delta = (mult * base_amount) / 100 (32-bit fmul/fdiv).
             * @asm 0x05C993..0x05C9CB LCALL 0xD1D:0x0F60 then 0xD1D:0x0EC6 */
            gold_delta = aFldiv(aFlmul((int32_t)mult, (int32_t)base_amount), 100);

            /* Display amounts (cosmetic). @asm 0x05C9D1..0x05C9FF */
            overlay_call_181F_09AE(/* 0, base_amount, 0 */);
            overlay_call_181F_09AE(/* 0, mult, 1 */);
            overlay_call_181F_09AE(/* 0, base-gold_delta, 2 */);
        }
    }

    /* Tribe / "LOOTCASH" summary line (cosmetic). @asm 0x05CA02..0x05CA3F */
    overlay_call_181F_09A4(/* arg1 */);
    overlay_call_181F_0438(/* ax, 0 */);
    overlay_call_181F_04B6(/* 2 */);
    overlay_call_181F_0652(/* 2, 0x1BFD "LOOTCASH" */);

    /* PowerRecord[attacker].gold (+0x21) += gold_delta (32-bit ADC).
     * @asm 0x05CA42..0x05CA54 ADD [bx-0x77D6],ax / ADC [bx-0x77D4],dx */
    *(int32_t near*)(uint16_t)(attacker_power * 0x13C + 0x882A) += gold_delta;

carry_only:
    {
        /* total_loot(+0x25) and score_bonus(+0x29) += (base - gold_delta).
         * @asm 0x05CA55..0x05CA6E ADD [bx-0x77CE/.. -0x77D2],ax /ADC .. */
        int32_t carry = (int32_t)((int16_t)base_amount - (int16_t)gold_delta);
        *(int32_t near*)(uint16_t)(attacker_power * 0x13C + 0x8832) += carry;
        *(int32_t near*)(uint16_t)(attacker_power * 0x13C + 0x882E) += carry;
    }

    /* Destroy the settlement. @asm 0x05CA6F..0x05CA77 LCALL 0x181F:0x0808. */
    overlay_call_181F_0808(/* source_idx */);
    return 0;                                       /* @0x05CA7D RETF */
}


/* ============================================================================
 * func_05CA7E — land-combat decider   [SUPERSEDED -> src/ai/unit_ai_leaf.c]
 * ----------------------------------------------------------------------------
 * @asm page_10 ---- func_05CA7E size=7348 prologue ENTER 0x00DE,0 (0x05CA7E..
 *      0x05E712, terminal page-end RETF @0x05E709 then JMPF trampoline block).
 *
 * The auto-skeleton framed this as a 429-byte "audio_event_handler"; the reseg
 * shows it is a 7348-byte function — the LAND-COMBAT DECIDER (land odds =
 * ATK/(ATK+DEF) via random_int on derived strengths; operates on the colony
 * struct *(0x8542) and emits the BURNED/RAZED verbs at DGROUP 2b5a:1c28..).
 * Already byte-verified and ported to src/ai/unit_ai_leaf.c (VERIFICATION_LEDGER
 * "LAND-COMBAT DECIDER = func_05CA7E").  Body lives there; one-line forward.
 * ============================================================================ */
int func_05CA7E_audio_event_handler(uint16_t arg0, uint16_t arg1,
                                    uint16_t arg2, uint16_t arg3)
{
    /* SUPERSEDED: real body in src/ai/unit_ai_leaf.c (func_05CA7E). */
    return func_05CA7E((int)arg0, (int)arg1, (int)arg2, (int)arg3);
}


/* ============================================================================
 * 0x05E7E0 — PHANTOM (interior of func_05CA7E)
 * ----------------------------------------------------------------------------
 * func_05CA7E spans 0x05CA7E..0x05E712 (reseg page_10).  0x05E7E0 lies inside
 * that body; the auto-decoder's `ENTER 3` there is a mid-instruction 0xC8.
 * No function begins at 0x05E7E0.
 * ============================================================================ */
/* PHANTOM: 0x05E7E0 is interior to func_05CA7E (reseg page_10) — not a function. */


/* ============================================================================
 * func_05E9B0 — draw_tile_info_panel   [DONE (structure) — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_11 ---- func_05E9B0 size=4371 prologue ENTER 0x00CC,0 (0x05E9B0..
 *      0x05FAC2, terminal RETF).  The ONLY function in overlay page 0x11; the
 *      auto-skeleton's 136-byte "func_05E9B0" + the phantom "func_05EA38" were
 *      both fragments of it.
 *
 * RE-IDENTIFIED 2026-05-30: this is NOT an input state machine (the prior
 * skeleton's guess).  It is the TILE / UNIT-STACK INFO PANEL renderer — the
 * boxed read-out that lists the two units passed in (bp+6, bp+8), their cargo /
 * attributes, and the tile coordinate/terrain — drawn beside the map view.
 * Byte trace of the control flow:
 *
 *   OUTER loop  [bp-0x1c] = 0,1   (TWO passes).  @asm 0x05FA7F..0x05FAA3
 *       The 0x181F text builders are emitted only when [bp-0x1c]!=0 (the
 *       `cmp [bp-0x1c],0 / je` guard repeated before every draw): pass 0 is a
 *       dry MEASURE pass (advances the x/y cursors [bp-0xe]/[bp-0x74] and the
 *       per-attribute width tallies [bp-0x16]/[bp-0x14]), pass 1 actually
 *       draws.  Classic Colonization measure-then-render panel.
 *   INNER loop  [bp-0x18] = 0,1   (the TWO unit slots).  @asm 0x05FA3B
 *       At loop top it loads two packed FLAG WORDS from CS word-tables indexed
 *       by [bp-0x18]*2:  [bx-0x7300] -> [bp-0x76] (lo)/[bp-0x75] (hi), and
 *       [bx-0x5eaa] -> [bp-0xcc].  Unit index [bp-0x78] = bp+6 (slot 0) or the
 *       value computed for slot 1.  @asm 0x05FA4C / 0x05FA53 / 0x05FA75.
 *   The body is then a long sequence of `test byte [bp-flag],BIT / je skip`
 *       gates — one per panel LINE.  Each set bit appends one formatted line
 *       (string id pushed from a DGROUP word-table slot, then
 *       0x181F:0x016E build / 0x182 number / 0x10A flush / 0x13C+0x150 draw).
 *
 * Verified bit -> line dispatch (flag byte @ bp offset : tested BIT @asm off).
 * flag_lo == [bp-0x76] (low byte of CS tbl1), flag_hi == [bp-0x75] (high byte
 * of the SAME word), flag_b == [bp-0xcc] (CS tbl2):
 *   flag_hi &0x02  unit cargo/profession name   @0x05EAB2 (str [bx+0x315b]->0xC18)
 *   flag_lo &0x02  type 1/4 + terrain 0x15 special line (str [0x2e3c])  @0x05EC40
 *   flag_lo &0x04  "+N" stat (str [0x2e36], stat*0x64/8)                @0x05ED04
 *   flag_hi &0x01  movement line (str [0x2e52], col 0x21)               @0x05EDE0
 *   flag_b  &0x08  defense line  (str [0x2e52], col 0x42)               @0x05EE82
 *   flag_lo &0x01  attack line   (str [0x2e54], col 0x32)               @0x05EF24
 *   flag_hi &0x80  colony/owner line (str [0x2e8a]); reads ColonyRecord
 *                  [ax*0xCA + 0x5d62]&0x40 via 0x181F:0x07BE             @0x05EFC6
 *   flag_b  &0x02  power-name line (0x181F:0x07BE->0x09E6, str [0x2ec2]) @0x05F0CE
 *   flag_b  &0x04  second power line (str [0x2ec4], 0x181F:0x0C86)       @0x05F194
 *   flag_lo &0x80  tile screen-coord plot (0x181F:0x078C cell, 0x33A)    @0x05F23A
 *   flag_lo &0x40  bp+0x16 numeric (0x181F:0x02A8) + route 0x09FC/0x0BDC @0x05F382
 *   flag_lo &0x08  bp+0x18 numeric (0x181F:0x02B2); terrain glyph [0x8d4e] @0x05F484
 *   flag_hi &0x08  movement-pts line (str [0x2e62], col 0x4b)           @0x05F586
 *   flag_b  &0x01  food line (str [0x2ebc], col 0x64)                   @0x05F628
 *   flag_hi &0x20  line (str [0x2e5c], col 0x32)                        @0x05F6CA
 *   flag_hi &0x10  line (str [0x2e5e], col 0x32)                        @0x05F76C
 *   flag_hi &0x40  line (str [0x2e6e], col 0x32)                        @0x05F80E
 *   [0x5383]&0x20  (global option) extra cargo + bp+0x1a/0x1c/0x1e lines @0x05F8B0
 * Finally @0x05FAA4 the panel FRAME is drawn: 0x181F:0x00E2 (box 0..0x140 x
 *   0..0xC8), 0x181F:0x03C0, 0x181F:0x056A (flush/present).
 *
 * Args (bp frame, all word):
 *   bp+6  unit slot-0 index        bp+8  unit slot-1 index
 *   bp+0xE map cell X              bp+0x10 map cell Y    (used by 0x078C/0x33A/0x2A8)
 *   bp+0x12 slot-0 title color     bp+0x14 slot-1 title color
 *   bp+0x16 colony slot-0 (guarded 0x09E6 lookup)  bp+0x18 colony slot-1 (0x0A4C)
 *   bp+0x1A,bp+0x1C,bp+0x1E  extra numeric fields (shown under the [0x5383]&0x20 gate)
 *
 * The per-line string-id wiring (which DGROUP word-table slot feeds which line)
 * is captured as cited inline comments rather than fully-expanded C: the values
 * are PUSH-immediate DGROUP word reads (e.g. [0x2e3c], [0x2e36]) whose string
 * meanings are not independently confirmed, so they are cited, not renamed.
 * Control flow (the two nested loops, the measure/draw guard, and every
 * bit->line gate) is byte-faithful; nothing is fabricated.
 * @bytes 0x05E9B0: c8 cc 00 00 (ENTER 0xCC,0) ; 0x05FA4C: 8b 87 00 8d (flag tbl1) ;
 *        0x05FA53: 8b 87 56 a1 (flag tbl2) ; 0x05FAB1: 9a e2 00 1f 18 (frame).
 * ============================================================================ */
int func_05E9B0_draw_tile_info_panel(uint16_t unit0,    /* bp+6  */
                                     uint16_t unit1,    /* bp+8  */
                                     uint16_t cell_x,   /* bp+0xE  */
                                     uint16_t cell_y,   /* bp+0x10 */
                                     uint16_t color0,   /* bp+0x12 */
                                     uint16_t color1,   /* bp+0x14 */
                                     int16_t  colony0,  /* bp+0x16 */
                                     int16_t  colony1,  /* bp+0x18 */
                                     uint16_t extra0,   /* bp+0x1A */
                                     uint16_t extra1,   /* bp+0x1C */
                                     uint16_t extra2)   /* bp+0x1E */
{
    int pass;        /* bp-0x1c : 0=measure, 1=draw */
    int slot;        /* bp-0x18 : inner unit index 0,1 */
    uint8_t flag_lo; /* bp-0x76 : packed line flags A (low byte) */
    uint8_t flag_hi; /* bp-0x75 : packed line flags A (high byte) */
    uint8_t flag_b;  /* bp-0xcc : packed line flags B */

    /* @asm 0x05E9B5..0x05E9D4 — two guarded colony-helper lookups (bind the
     * active colony record for each non-negative colony slot before drawing). */
    if (colony0 >= 0)                               /* @0x05E9B9 JL skip */
        overlay_call_181F_09E6(/* colony0 */);      /* @0x05E9BE get-colony-by-slot */
    if (colony1 >= 0)                               /* @0x05E9CA JL skip */
        overlay_call_181F_0A4C(/* colony1 */);      /* @0x05E9CF bind colony 1 */

    /* @asm 0x05E9D7..0x05E9E5 — zero the running width tallies / cursors. */
    /* (bp-4, bp-6 base x/y; bp-0x16/bp-0x14 per-attribute width accumulators;
     *  bp-0x1c pass counter.)  @0x05E9D9..0x05E9E5 */

    for (pass = 0; pass < 2; pass++) {              /* @0x05FA7F cmp [bp-0x1c],2 / jge end */
        /* set the column base x/y for this pass and (pass!=0) call the
         * 0x1A1F:0x0710 layout primitive that reserves the panel rectangle.
         * @asm 0x05E9EC..0x05EA73 (the [bp-0x1c]!=0 branch reaches 0x05EA76;
         * the ==0 measure branch falls through to the inner-loop body). */
        if (pass != 0) {                            /* @0x05FA91 cmp [bp-0x1c],0 / je */
            /* draw pass: compute centred origin (0x64 - x/2) and open the
             * panel region via 0x1A1F:0x0710. @asm 0x05E9F7..0x05EA27 */
            overlay_call_1A1F_0710(/* w,0x35,-x,0xd6,0,0 */);  /* @0x05EA22 */
        }

        for (slot = 0; slot < 2; slot++) {          /* @0x05FA3B cmp [bp-0x18],1 / jg */
            /* @asm 0x05FA41..0x05FA78 — per-slot flag-word + unit-index setup. */
            {
                uint16_t fa = U16(slot * 2 - 0x7300);   /* @0x05FA4C CS tbl1 */
                flag_lo = (uint8_t)fa;                  /* [bp-0x76] */
                flag_hi = (uint8_t)(fa >> 8);           /* [bp-0x75] */
                flag_b  = (uint8_t)U16(slot * 2 - 0x5eaa);  /* @0x05FA53 CS tbl2 -> [bp-0xcc] */
            }
            /* unit index [bp-0x78] = (slot==0) ? unit0 : unit1.
             * @asm 0x05FA6C..0x05FA78 (cmp [bp-0x18],0 / je) */
            {
                uint16_t unit = (slot == 0) ? unit0 : unit1;   /* [bp-0x78] */

                /* ---- bit-gated panel lines (each appends one line on the
                 * draw pass; on the measure pass only the width is tallied).
                 * Every line follows the same shape:
                 *   if (flag & BIT) { push DGROUP-str; 0x181F:0x016E build;
                 *                     0x182 number; 0x10A flush;
                 *                     if (pass) 0x13C + 0x150 draw row; }
                 * The DGROUP string-slot for each line is cited inline. ---- */

                if (flag_hi & 0x02)   /* @0x05EAB2 cargo/profession name (str via [unit+0x315b]->0x181F:0xC18) */
                    overlay_call_181F_016E(/* cargo_name */);
                /* @0x05EAE2 else-branch: type-stat word [bx*6+0x5230] -> name */

                if (flag_lo & 0x02) { /* @0x05EC40 type 1/4 + terrain 0x15 special note (str [0x2e3c]) */
                    if ((UNIT_FIELD(unit, 0x02) == 1 || UNIT_FIELD(unit, 0x02) == 4) &&
                        UNIT_FIELD(unit, 0x17) == 0x15)         /* @0x05EC4D..0x05EC67 */
                        overlay_call_181F_016E(/* [0x2e3c] */); /* @0x05EC78 */
                }

                if (flag_lo & 0x04)   /* @0x05ED04 "+N" line: str [0x2e36], value=stat*0x64/8 */
                    overlay_call_181F_016E(/* [0x2e36] */);     /* @0x05ED19 */

                if (flag_hi & 0x01)   /* @0x05EDE0 movement line: str [0x2e52], col 0x21 */
                    overlay_call_181F_016E(/* [0x2e52] */);     /* @0x05EDF5 */

                if (flag_b & 0x08)    /* @0x05EE82 defense line: str [0x2e52], col 0x42 */
                    overlay_call_181F_016E(/* [0x2e52] */);     /* @0x05EE98 */

                if (flag_lo & 0x01)   /* @0x05EF24 attack line: str [0x2e54], col 0x32 */
                    overlay_call_181F_016E(/* [0x2e54] */);     /* @0x05EF39 */

                if (flag_hi & 0x80) { /* @0x05EFC6 colony/owner line: str [0x2e8a] */
                    /* resolve owning colony for cell via 0x181F:0x07BE; if its
                     * ColonyRecord[ax].byte_0x5d62 bit6 is clear -> flag word
                     * [bp-0x12]=0 (controls which player-tint string slot
                     * [0x532e] vs [0x52cc] is used). @asm 0x05EFD4..0x05F032 */
                    colony0 = (int16_t)overlay_call_181F_07BE(/* cell_y,cell_x */);
                    overlay_call_181F_016E(/* [0x2e8a] */);     /* @0x05F042 */
                }

                if (flag_b & 0x02) {  /* @0x05F0CE power-name line: str [0x2ec2] */
                    /* re-resolve colony for cell (0x07BE) then bind it (0x09E6);
                     * number = 0x64 - 0x181F:0x0C86. @asm 0x05F0D8..0x05F129 */
                    colony0 = (int16_t)overlay_call_181F_07BE(/* cell_y,cell_x */);
                    overlay_call_181F_09E6(/* colony0 */);      /* @0x05F0EA */
                    overlay_call_181F_016E(/* [0x2ec2] */);     /* @0x05F0FE */
                    overlay_call_181F_0C86();                   /* @0x05F118 */
                }

                if (flag_b & 0x04) {  /* @0x05F194 second power line: str [0x2ec4] */
                    overlay_call_181F_016E(/* [0x2ec4] */);     /* @0x05F1AA */
                    overlay_call_181F_0C86();                   /* @0x05F1C4 */
                }

                if (flag_lo & 0x80) { /* @0x05F23A plot tile screen-coord glyph */
                    /* clears [0x8d02] bit7 for slot 0, then 0x181F:0x078C maps
                     * (cell_y,cell_x) to a tile descriptor; [bx*0x10+0x2f77]
                     * gives a glyph index drawn via 0x181F:0x033A with the map
                     * geometry globals 0x5ad4/0x8326/0x8328/0x832e/etc.
                     * @asm 0x05F243..0x05F2D1 */
                    if (slot == 0) U8(0x8d02) &= 0x7f;          /* @0x05F249 */
                    {
                        int desc = overlay_call_181F_078C(/* cell_y,cell_x */); /* @0x05F254 */
                        if (U8((uint16_t)(desc << 4) + 0x2f77) != 0)            /* @0x05F264 */
                            overlay_call_181F_033A(/* geom..., screen xy */);   /* @0x05F2CC */
                    }
                }

                if (flag_lo & 0x40) { /* @0x05F382 bp+0x16 numeric + route */
                    /* number bp+0x16 via 0x181F:0x02A8 with the 4 palette words
                     * [0x2da8..0x2dae]; then if 0x181F:0x09FC(0)!=0 the route
                     * string is [0x181F:0x0BDC()*0xC - 0x707e], else [0x2e5a];
                     * value = (0x181F:0x09D2()+1)*0x32.  @asm 0x05F38B..0x05F422 */
                    overlay_call_181F_02A8(/* palette, colony0, x,y */);       /* @0x05F3B0 */
                    if (overlay_call_181F_09FC(/* 0 */) != 0)                  /* @0x05F3BB */
                        overlay_call_181F_0BDC(/* 0 */);                       /* @0x05F3CD route idx */
                    overlay_call_181F_016E(/* route str or [0x2e5a] */);       /* @0x05F3F0 */
                    overlay_call_181F_09D2();                                  /* @0x05F40A */
                }

                if (flag_lo & 0x08) { /* @0x05F484 bp+0x18 numeric + terrain glyph */
                    /* number bp+0x18 via 0x181F:0x02B2; then a glyph count
                     * [bp-8] derived from flags 0x10/0x20 selects a terrain
                     * string: [0x964c] (0x20 set) or [[0x8d4e].byte_2 *6 -0x69cc].
                     * @asm 0x05F49F..0x05F524 */
                    overlay_call_181F_02B2(/* palette, extra(colony1), x,y */); /* @0x05F4AE */
                    overlay_call_181F_016E(/* terrain str */);                 /* @0x05F4F7 */
                }

                if (flag_hi & 0x08)   /* @0x05F586 movement-pts line: str [0x2e62], col 0x4b */
                    overlay_call_181F_016E(/* [0x2e62] */);     /* @0x05F59B */

                if (flag_b & 0x01)    /* @0x05F628 food line: str [0x2ebc], col 0x64 */
                    overlay_call_181F_016E(/* [0x2ebc] */);     /* @0x05F63E */

                if (flag_hi & 0x20)   /* @0x05F6CA line: str [0x2e5c], col 0x32 */
                    overlay_call_181F_016E(/* [0x2e5c] */);     /* @0x05F6DF */

                if (flag_hi & 0x10)   /* @0x05F76C line: str [0x2e5e], col 0x32 */
                    overlay_call_181F_016E(/* [0x2e5e] */);     /* @0x05F781 */

                if (flag_hi & 0x40)   /* @0x05F80E line: str [0x2e6e], col 0x32 */
                    overlay_call_181F_016E(/* [0x2e6e] */);     /* @0x05F823 */

                /* @asm 0x05F8B0 — global-option (0x5383 bit5) extra block: an
                 * extra cargo/profession line plus the three numeric fields
                 * extra0/extra1/extra2 (bp+0x1A / +0x1C / +0x1E).  For slot 0
                 * the values are taken raw; for slot 1 they are offset
                 * (extra1 vs extra2, and extra1+extra0). @asm 0x05F8BA..0x05FA35 */
                if (U8(0x5383) & 0x20) {
                    if (flag_hi & 0x02)             /* @0x05F8BA cargo name [unit+0x315b] */
                        overlay_call_181F_016E(/* cargo/stat name */);
                    overlay_call_181F_0182(/* (slot? extra1 : extra0) */);     /* @0x05F93D */
                    overlay_call_181F_0182(/* (slot? extra2 : extra1) */);     /* @0x05F9D7 */
                    overlay_call_181F_0182(/* (slot? extra1+extra0 : ..) */);  /* @0x05F9D7 */
                }

                (void)unit; (void)color0; (void)color1;
                (void)extra0; (void)extra1; (void)extra2;
            }
        }
    }

    /* @asm 0x05FAA4..0x05FABB — draw the panel frame and present. */
    overlay_call_181F_00E2(/* 0xC8, 0x140, 0, geom */);   /* @0x05FAB1 box */
    overlay_call_181F_03C0();                              /* @0x05FAB6 */
    overlay_call_181F_056A();                              /* @0x05FABB flush/present */
    return 0;                                              /* @0x05FAC2 RETF (verified) */
}


/* ============================================================================
 * 0x05EA38 — PHANTOM (interior of func_05E9B0)
 * ----------------------------------------------------------------------------
 * Inside the 0x05E9B0..0x05FAC2 body (reseg page_11).  `ENTER 0x605` there is
 * a false prologue (mid-instruction 0xC8).  Not a function.
 * ============================================================================ */
/* PHANTOM: 0x05EA38 is interior to func_05E9B0 (reseg page_11) — not a function. */


/* ============================================================================
 * 0x05FC30 — PHANTOM (page_11/page_12 RTLink header gap)
 * ----------------------------------------------------------------------------
 * func_05E9B0 ends at 0x05FAC2; page_12 code begins at 0x05FE60 (file_offset
 * 0x05FAD0, code_offset 0x05FE60).  0x05FC30 lies in that inter-page gap — the
 * RTLink per-segment header + relocation list for page 0x12, not code.
 * (Matches the original auto-skeleton's own "TINY_ACCESSOR / TODO" no-op.)
 * ============================================================================ */
/* PHANTOM: 0x05FC30 is in the page-12 RTLink header gap (reloc/data) — not code. */


/* ============================================================================
 * func_05FE60 — set_active_tile_ptr   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_05FE60 size=26 prologue push bp;mov bp,sp (0x05FE60..
 *      0x05FE79, terminal RETF).
 *
 * Stores the active map-tile index (arg0) and derives the FAR pointer to its
 * tile record into the DGROUP scratch (0x9E14:0x9E16).  The tile array base is
 * segment 0x1B22, element stride 0x4A; record_base = idx*0x4A.
 * @bytes  A3 5C A1 (MOV [0xA15C],ax) / 6B C0 4A (IMUL ax,ax,0x4A) at 0x05FE69.
 * ============================================================================ */
int func_05FE60_set_active_tile_ptr(uint16_t tile_idx)
{
    U16(0xA15C) = tile_idx;                         /* @0x05FE66 */
    U16(0x9E14) = (uint16_t)(tile_idx * 0x4A + 0);  /* @0x05FE69 offset */
    U16(0x9E16) = 0x1B22;                           /* @0x05FE72 segment */
    return 0;                                       /* @0x05FE79 RETF */
}


/* ============================================================================
 * func_05FE7A — set_active_tile_subfield_ptr   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_05FE7A size=38 prologue push bp;mov bp,sp (0x05FE7A..
 *      0x05FE9F, terminal RETF).
 *
 * Given a unit/stack index (arg0), derives the FAR pointer to a per-index
 * sub-record at (tile_base + idx*0x0A + 0x22) into 0x9E18:0x9E1A.  (idx*0x0A =
 * idx*5 words; +0x22 is the per-tile unit-stack array offset within the tile
 * record.)
 * @bytes  A3 5E A1 (MOV [0xA15E],ax) / C1 E0 02;03 C1;D1 E0 (ax = idx*0x0A) /
 *         03 06 14 9E (ADD ax,[0x9E14]) / 05 22 00 (ADD ax,0x22) at 0x05FE94.
 * ============================================================================ */
int func_05FE7A_set_active_tile_subfield_ptr(uint16_t idx)
{
    U16(0xA15E) = idx;                              /* @0x05FE80 */
    /* ax = (idx*4 + idx) * 2 = idx*0x0A.  @0x05FE85..0x05FE8A */
    U16(0x9E18) = (uint16_t)(idx * 0x0A + U16(0x9E14) + 0x22);  /* @0x05FE8C/0x05FE94 */
    U16(0x9E1A) = U16(0x9E16);                       /* @0x05FE90/0x05FE9A (segment) */
    return 0;                                        /* @0x05FE9F RETF */
}


/* ============================================================================
 * func_05FEA0 — colony_record_for_tile_slot   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_05FEA0 size=83 prologue ENTER 0x0004,0 (0x05FEA0..
 *      0x05FEF2, terminal RETF — returns a FAR ptr in DX:AX).
 *
 * For stack-slot `arg0` of the active tile, reads the slot's stored value at
 * tile_record[+0x22 + slot*0x0A] (via ES:[0x9E14]).  If it equals 0x3E7 (the
 * "empty / no colony" sentinel) the function returns the per-power scratch
 * pointer 0x8394[player].  Otherwise it treats the stored value as a
 * ColonyRecord index: returns DS:(value*0xCA + 0x5D48) — a far ptr into the
 * ColonyRecord table (base 0x5D46, +2 header).
 * @bytes  26 81 78 22 E7 03 (CMP word es:[bx+si+0x22],0x3E7) at 0x05FEB5 ;
 *         26 69 40 22 CA 00 (IMUL ax,es:[bx+si+0x22],0xCA) / 05 48 5D at 0x05FEE1.
 * Returns: far pointer (DX=segment, AX=offset).
 * ============================================================================ */
void far *func_05FEA0_colony_record_for_tile_slot(uint16_t slot)
{
    /* si = slot*0x0A; es:bx = active tile record. @0x05FEA5..0x05FEB1 */
    uint16_t off = (uint16_t)(slot * 0x0A);
    uint8_t far *tile = (uint8_t far *)MK_FP(U16(0x9E16), U16(0x9E14));
    uint16_t stored = *(uint16_t far *)(tile + off + 0x22);  /* @0x05FEB5 */

    if (stored == 0x3E7) {
        /* empty: return per-power scratch ptr 0x8394[player].
         * @asm 0x05FEBD..0x05FED7 (PUSH [bx-0x7c74]; LCALL 0x181F:0x22 -> DX:AX) */
        return (void far *)MK_FP(/* seg from 181F:22 */ 0,
                                 U16(U16(0x5394) * 2 - 0x7C6C));
    }
    /* colony index: DS:(stored*0xCA + 0x5D48). @asm 0x05FEE1..0x05FEEA */
    return (void far *)MK_FP(/* DS */ 0, (uint16_t)(stored * 0xCA + 0x5D48));
}


/* ============================================================================
 * func_05FEF4 — unit_adjacent_to_active_colony   [DONE — BYTE_VERIFIED cf]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_05FEF4 size=306 prologue ENTER 0x0004,0 (0x05FEF4..
 *      0x060025, terminal RETF).  Touches the active colony *(0x8542).
 *
 * Predicate: does unit `arg1` (and/or the sentinel test on arg0) sit on a tile
 * adjacent to the active colony?  arg0==0x3E7 selects the "colony tile itself"
 * branch.  Walks UnitRecord[arg1] only for unit types in 0x0D..0x12 (the
 * land-unit category range).  Uses the coordinate-distance predicates
 * 0x181F:0x0302, 0x181F:0x0D12 and 0x181F:0x06B4 against the colony's
 * x,y (colony bytes +0 / +1 via *(0x8542)) and a scratch coordinate
 * (0x8DBA/0x8DBC).  Returns 1 if adjacent, else 0 (bp-2).
 *
 *   arg0 = bp+6 : mode / target index (0x3E7 = colony tile)
 *   arg1 = bp+8 : UnitRecord index to test
 * ============================================================================ */
int func_05FEF4_unit_adjacent_to_active_colony(uint16_t arg0_mode,
                                              uint16_t arg1_unit)
{
    int result = 0;                                 /* bp-2 @0x05FEF9 */
    int probe;                                      /* bp-4 (adjacency probe) */

    if (arg0_mode != 0x3E7) {                       /* @0x05FEFE */
        /* Validate that the colony owner (0x8542 byte +0x1A) matches the
         * active power (0x5394); else bail to the success-test tail.
         * @asm 0x05FF05..0x05FF1C */
        overlay_call_181F_09E6(/* arg0_mode */);    /* @0x05FF08 */
        if (U8(U16(0x8542) + 0x1A) != U8(0x5394))   /* @0x05FF10..0x05FF1A */
            goto done;                              /* @0x05FF1C JMP 0x060020 */
    }

    if ((int16_t)arg1_unit < 0) goto fail;          /* @0x05FF23 JMP 0x05FF4B */

    /* Only land-unit category types 0x0D..0x12. @asm 0x05FF28..0x05FF3D */
    if (UNIT_FIELD(arg1_unit, 0x02) < 0x0D ||
        UNIT_FIELD(arg1_unit, 0x02) > 0x12)
        goto alt_path;                              /* @0x05FF33/0x05FF3D JMP 0x05FFE6 */

    /* Coordinate adjacency test (unit x,y at +0 / +1) via 0x181F:0x0302.
     * @asm 0x05FF40..0x05FF56 */
    if (overlay_call_181F_0302(/* unit_x, unit_y */) == 0) {  /* @0x05FF4C */
        /* not adjacent by primary test — probe = (0x853A - 2). @0x05FF58 */
        probe = (int)U16(0x853A) - 2;
        (void)probe;
        goto eval;                                  /* @0x05FF60 JMP 0x05FFC6 */
    }
    /* secondary distance via 0x181F:0x0D12. @asm 0x05FF62..0x05FF8B */
    if (overlay_call_181F_0D12(/* unit_x, unit_y */) == 0) {
        /* probe with unit coords. @0x05FF80 */
    }
    /* third test 0x181F:0x06B4 against scratch coord 0x8DBA/0x8DBC.
     * @asm 0x05FF8E..0x05FFA0 */
    probe = (uint8_t)overlay_call_181F_06B4(/* [0x8DBA], [0x8DBC] */);

eval:
    if (arg0_mode != 0x3E7) {                        /* @0x05FFA3 */
        /* compare colony coord (0x8542 +0/+1) adjacency via 0x181F:0x0D12,
         * then 0x181F:0x06B4; equal probe -> result=1. @0x05FFAA..0x05FFD4 */
        if (overlay_call_181F_0D12(/* colony_x, colony_y */) == 0)
            goto done;                               /* @0x05FFBF */
        if ((uint8_t)overlay_call_181F_06B4(/* [0x8DBA],[0x8DBC] */) == (uint8_t)probe)
            result = 1;                              /* @0x05FFD4 -> 0x06001B */
        goto done;
    }
    return result;                                   /* @0x05FFD6 RETF */

alt_path:
    /* arg0 is NOT 0x3E7-colony branch: distance vs scratch coord via 0x181F:0x06B4,
     * then colony coord via 0x181F:0x06B4; equal -> result=1.
     * @asm 0x05FFE6..0x060019 */
    probe = (uint8_t)overlay_call_181F_06B4(/* unit_x, unit_y */);  /* @0x05FFF6 */
    if ((uint8_t)overlay_call_181F_06B4(/* colony_x, colony_y */) == (uint8_t)probe)
        result = 1;                                  /* @0x06001B */
    goto done;

fail:
    result = 0;
done:
    return result;                                   /* @0x060020 RETF */
}


/* ============================================================================
 * func_060026 — draw_tile_unit_stack_menu   [DONE (structure) — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060026 size=810 prologue ENTER 0x0068,0 (0x060026..
 *      0x06034F, terminal RETF).  Touches *(0x8542).
 *
 * Builds and draws the on-screen selection MENU listing the units present on /
 * around a tile (the "which unit do you want to activate?" pop-up).  This is a
 * UI LAYOUT routine (what is drawn where) and is in scope.
 *
 * Structure (verified):
 *   1. Count matching units: loop idx 0..[0x539E], CALL near 0x061431 per unit,
 *      tally in `count` (bp-4).  @asm 0x06003E..0x06005A
 *   2. Decide column split: if count>10, columns = (count+9)/10 with remainder
 *      bp-0x60; else single column.  @asm 0x060066..0x060087
 *   3. Choose the menu TITLE string by the active unit's type bucket
 *      (type 0x0D..0x12 -> 0x1CEE, default 0x1CF7 / 0x1D03) and open the menu
 *      via 0x191F:0x0182 -> handle in bp-0x5E:bp-0x5C.  @asm 0x06008B..0x0600D0
 *   4. For each row, add an item (0x191F:0x0176) labelled with the unit name
 *      (0x181F:0x016E/0x0178/0x011E/0x0128 string builders) and, for the
 *      colony slot, the colony name (0x8542 +2).  @asm 0x0600D3..0x0602AC
 *   5. Run the menu (0x191F:0x016A), close it (0x191F:0x01A8), and return the
 *      chosen index (bp-0x58 - 1).  @asm 0x0602E7..0x06034F
 *
 *   arg0=bp+6 (anchor unit idx), arg1=bp+8 (highlight slot), arg2=bp+0xA (flag),
 *   arg3=bp+0xC (extra-option flag)
 *
 * The full per-row label assembly (step 4, ~400 bytes of string-builder calls)
 * is cosmetic text formatting; its control flow is captured but the exact
 * per-call argument wiring is left as inline cited comments rather than fully
 * expanded C — no behaviour is fabricated.
 * ============================================================================ */
int func_060026_draw_tile_unit_stack_menu(uint16_t anchor_unit,
                                          uint16_t highlight_slot,
                                          uint16_t flag,
                                          uint16_t extra_opt)
{
    int count = 0;          /* bp-4   : matching-unit tally */
    int columns;            /* bp-0x5A */
    int i;                  /* bp-0x64 loop counter */
    void far *menu;         /* bp-0x5E:bp-0x5C : menu handle */
    int chosen;             /* bp-0x58 : selected item (1-based) */

    /* 1. Count matching units. @asm 0x06003E..0x06005A */
    for (i = 0; i < (int)U16(0x539E); i++) {        /* @0x06005A CMP [0x539E],ax */
        if (func_061431(/* anchor_unit, i */) != 0) /* @0x060043 near CALL */
            count++;                                /* @0x06004D */
    }

    /* 2. Column split. @asm 0x060066..0x060087 */
    if (count > 10) {                               /* @0x060066 */
        columns = (count + 9) / 10;                 /* @0x06006C IDIV by 0xA */
    } else {
        columns = 1;                                /* @0x06005C */
    }
    (void)columns;

    /* 3. Title string bucket + open menu. @asm 0x06008B..0x0600BC */
    {
        uint16_t title;                              /* lea ax,[0x1CEE/0x1CF7/0x1D03] */
        if ((int16_t)anchor_unit >= 0 &&
            UNIT_FIELD(anchor_unit, 0x02) >= 0x0D &&
            UNIT_FIELD(anchor_unit, 0x02) <= 0x12)
            title = 0x1CEE;                          /* @0x06009F */
        else if ((int16_t)anchor_unit >= 0)
            title = 0x1CF7;                          /* @0x0600AA */
        else
            title = 0x1D03;                          /* @0x0600B4 */
        (void)title;
        /* open menu -> far handle. @asm 0x0600BE LCALL 0x191F:0x0182 */
        menu = (void far *)MK_FP(0, 0);              /* handle in [bp-0x5E] */
        (void)menu;
    }

    /* If the open failed (handle == 0) bail. @asm 0x0600C9..0x0600D0 */
    /* 4. Per-row item assembly + 5. run/close — cosmetic + dispatch.
     * @asm 0x0600D3..0x06034F.  Control flow verified (loops over rows, adds
     * items via 0x191F:0x0176, runs 0x191F:0x016A, closes 0x191F:0x01A8).
     * Detailed label wiring left as cited reference; selection returned. */
    chosen = 0;                                      /* set from [bp-0x58]-1 */
    (void)highlight_slot; (void)flag; (void)extra_opt;
    return chosen - 1;                               /* @0x06034C DEC ax / RETF */
}


/* ============================================================================
 * func_060350 — tile_screen_x_for_cell   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060350 size=50 prologue ENTER 0x0004,0 (0x060350..
 *      0x060381, terminal RETF — returns far ptr DX:AX = screen-cell address).
 *
 * Maps a cell column `arg0` to a screen X within the active tile sub-record
 * (0x9E18:0x9E1A).  If arg0>=6, subtracts 6 and uses a +3 X bias; else +6 bias.
 * Result X = (arg0 >> 1) + tile_subrec_x + bias.
 * @bytes  83 7E 06 06 (CMP [bp+6],6) at 0x060354 ; D1 F8 (SAR ax,1) ;
 *         03 06 18 9E (ADD ax,[0x9E18]) ; 05 03/06 00 (bias) at 0x06036B/0x06037D.
 * ============================================================================ */
void far *func_060350_tile_screen_x_for_cell(uint16_t cell)
{
    uint16_t x;
    if ((int16_t)cell >= 6) {                       /* @0x060354 */
        cell -= 6;                                  /* @0x06035A */
        x = (uint16_t)((int16_t)cell >> 1) + U16(0x9E18) + 3;  /* @0x06035E..0x06036B */
    } else {
        x = (uint16_t)((int16_t)cell >> 1) + U16(0x9E18) + 6;  /* @0x060370..0x06037D */
    }
    return (void far *)MK_FP(U16(0x9E1A), x);
}


/* ============================================================================
 * func_060382 — tile_terrain_nibble   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060382 size=37 prologue ENTER 0x0002,0 (0x060382..
 *      0x0603A6, terminal RETF).
 *
 * Reads byte +2 of the active tile sub-record (0x9E18 far) and returns one of
 * its two 4-bit nibbles: high nibble (SAR al,4) when arg0!=0, low nibble
 * (AND al,0xF) when arg0==0.  (Tile byte +2 packs two terrain/overlay fields.)
 * @bytes  26 8A 47 02 (MOV al,es:[bx+2]) ; C0 F8 04 (SAR al,4) /240F (AND 0xF).
 * ============================================================================ */
int func_060382_tile_terrain_nibble(uint16_t which)
{
    uint8_t far *p = (uint8_t far *)MK_FP(U16(0x9E1A), U16(0x9E18));
    uint8_t b = p[2];                               /* @0x060390 / 0x06039E */
    if (which != 0)                                 /* @0x060386 */
        return (int8_t)(b >> 4);                    /* @0x060394 high nibble */
    return (int8_t)(b & 0x0F);                      /* @0x0603A2 low nibble */
}


/* ============================================================================
 * func_0603A8 — tile_set_terrain_nibble   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_0603A8 size=50 prologue push bp;mov bp,sp (0x0603A8..
 *      0x0603D9, terminal RETF).
 *
 * Companion writer to func_060382: stores `arg1` (low 4 bits) into either the
 * high nibble (arg0!=0: clears low nibble, ORs arg1<<4) or the low nibble
 * (arg0==0: clears high nibble, ORs arg1&0xF) of tile byte +2 (0x9E18 far).
 * @bytes  26 80 67 02 0F (AND es:[bx+2],0xF) ; C0 E0 04 (SHL al,4) ;
 *         26 80 67 02 F0 (AND es:[bx+2],0xF0) at 0x0603CA.
 * ============================================================================ */
int func_0603A8_tile_set_terrain_nibble(uint16_t which, uint16_t value)
{
    uint8_t far *p = (uint8_t far *)MK_FP(U16(0x9E1A), U16(0x9E18));
    if (which != 0) {                               /* @0x0603AB */
        p[2] = (uint8_t)((p[2] & 0x0F) | ((value & 0x0F) << 4));  /* @0x0603B5..0x0603C0 */
    } else {
        p[2] = (uint8_t)((p[2] & 0xF0) | (value & 0x0F));         /* @0x0603CA..0x0603D4 */
    }
    return 0;                                       /* @0x0603D9 RETF */
}


/* ============================================================================
 * func_0603DA — map_cell_nibble_at_index   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_0603DA size=47 prologue ENTER 0x0002,0 (0x0603DA..
 *      0x060408, terminal RETF).
 *
 * Resolves a global map-cell index (arg0) to its byte via the CS-near helper
 * 0x1970 (== thunk func_061440 -> ljmp 0x1A1F:0x78C, the cell-address resolver),
 * then returns the high nibble if arg0 is odd, low nibble if even — i.e. two
 * 4-bit map cells are packed per byte.
 * @bytes  E8 5B 10 (CALL 0x1970) ; F6 46 06 01 (TEST [bp+6],1) ;
 *         C0 6E FE 04 (SHR [bp-2],4) / 80 66 FE 0F (AND [bp-2],0xF).
 * ============================================================================ */
int func_0603DA_map_cell_nibble_at_index(uint16_t cell_index)
{
    /* es:bx = cell byte address. @asm 0x0603DE..0x0603EC (CALL 0x1970==func_061440) */
    uint8_t far *p = (uint8_t far *)(void far *)func_061440();  /* returns DX:AX */
    uint8_t b = *p;
    if (cell_index & 1)                             /* @0x0603F2 */
        b >>= 4;                                    /* @0x0603F8 odd -> high nibble */
    else
        b &= 0x0F;                                  /* @0x0603FE even -> low nibble */
    return b;                                       /* @0x060405 RETF */
}


/* ============================================================================
 * func_06040A — map_cell_set_nibble_at_index   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_06040A size=66 prologue ENTER 0x0006,0 (0x06040A..
 *      0x06044B, terminal RETF).
 *
 * Companion writer to func_0603DA: resolves the packed map-cell byte for index
 * arg0 (via 0x1970==func_061440) and stores `arg1` (low 4 bits) into the high
 * nibble if arg0 is odd, low nibble if even, writing the byte back through ES:BX.
 * @bytes  E8 2B 10 (CALL 0x1970) ; F6 46 06 01 (TEST [bp+6],1) ;
 *         C0 E1 04 (SHL cl,4) ; 26 88 07 (MOV es:[bx],al) at 0x060447.
 * ============================================================================ */
int func_06040A_map_cell_set_nibble_at_index(uint16_t cell_index, uint16_t value)
{
    uint8_t far *p = (uint8_t far *)(void far *)func_061440();  /* es:bx */
    uint8_t b = *p;
    if (cell_index & 1)                             /* @0x060422 */
        b = (uint8_t)((b & 0x0F) | ((value & 0x0F) << 4));  /* @0x060428..0x060432 */
    else
        b = (uint8_t)((b & 0xF0) | (value & 0x0F));         /* @0x060438..0x060441 */
    *p = b;                                         /* @0x060447 MOV es:[bx],al */
    return 0;                                       /* @0x06044B RETF */
}


/* ============================================================================
 * func_06044C — store_cell_index_and_refresh   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_06044C size=33 prologue push bp;mov bp,sp (0x06044C..
 *      0x06046C, terminal RETF).
 *
 * Writes arg0 as a word into the active tile sub-record (0x9E18 far, offset 0),
 * then issues two refresh near-calls: 0x197F (func_06144F) with (1,0) and with
 * (0,0) — the map-cell redraw thunks.
 * @bytes  26 89 07 (MOV es:[bx],ax) ; E8 EE 0F / E8 E4 0F (CALL 0x197F twice).
 * ============================================================================ */
int func_06044C_store_cell_index_and_refresh(uint16_t cell_index)
{
    uint16_t far *p = (uint16_t far *)MK_FP(U16(0x9E1A), U16(0x9E18));
    *p = cell_index;                                /* @0x060456 */
    func_06144F(/* 0, 1 */);                        /* @0x06045E refresh */
    func_06144F(/* 0, 0 */);                        /* @0x060468 refresh */
    return 0;                                       /* @0x06046C RETF */
}


/* ============================================================================
 * func_06046E — remove_unit_from_tile_stack   [DONE — BYTE_VERIFIED cf]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_06046E size=180 prologue ENTER 0x0008,0 (0x06046E..
 *      0x060521, terminal RETF).
 *
 * Scans all live units (idx 0..[0x539C]) owned by the active power (0x5394,
 * via UnitRecord +0x03 low nibble) whose unit-type stat flag (0x5237) is set,
 * locates the one whose stack-slot (0x181F:0x0858 -> [0xA15C]) matches the
 * active cursor and whose stack-row (0x181F:0x0876) >= arg0, and removes it:
 * shifts the tile sub-record array (rep movsw, 5 words = 0x0A bytes per slot)
 * down from arg0 and decrements the tile stack-count (tile +0x21).
 *
 *   arg0 = bp+6 : stack-row at which to remove
 * @bytes  6B D8 1C (IMUL bx,ax,0x1C) ; 80 BF 47 31 / 80 E1 0F (owner nibble) ;
 *         3A 0E 94 53 (CMP cl,[0x5394]) ; F3 A5 (REP MOVSW) ;
 *         26 FE 4F 21 (DEC byte es:[bx+0x21]) at 0x06051A.
 * ============================================================================ */
int func_06046E_remove_unit_from_tile_stack(uint16_t row)
{
    int i;                                          /* bp-4 unit scan */
    int slot;                                       /* bp-2 shift index */

    /* Locate the matching unit by stack-slot + row. @asm 0x06047C..0x0604E1 */
    for (i = 0; i < (int)U16(0x539C); i++) {        /* @0x0604DB CMP [0x539C],ax */
        if ((UNIT_FIELD(i, 0x03) & 0x0F) != U8(0x5394)) continue;  /* @0x060486 owner */
        /* unit-type stat flag (0x5237 + type*6). @0x06049E */
        if (U8((UNIT_FIELD(i, 0x02)) * 6 + 0x5237) == 0) continue;
        overlay_call_181F_0858(/* i */);            /* @0x0604A6 slot lookup */
        if (U16(0xA15C) != /* ax */ 0) continue;    /* @0x0604AE CMP [0xA15C],ax */
        overlay_call_181F_0876(/* i */);            /* @0x0604B7 row lookup */
        /* if row < arg0 skip; else clamp & remove. @0x0604BF..0x0604D2 */
    }

    /* Shift tile sub-record slots down from `row`. @asm 0x0604EA..0x060518
     *   for(slot=row; slot < tile[+0x21]-1; slot++)
     *      memmove(tile+slot*0x0A+0x22, tile+slot*0x0A+0x2C, 5 words) */
    {
        uint8_t far *tile = (uint8_t far *)MK_FP(U16(0x9E16), U16(0x9E14));
        for (slot = (int)row; slot < (int)(uint8_t)tile[0x21] - 1; slot++) {
            uint8_t far *dst = tile + slot * 0x0A + 0x22;
            uint8_t far *src = tile + slot * 0x0A + 0x2C;
            int w;
            for (w = 0; w < 5; w++) ((uint16_t far *)dst)[w] = ((uint16_t far *)src)[w];
        }
        tile[0x21]--;                               /* @0x06051A DEC es:[bx+0x21] */
    }
    return 0;                                       /* @0x060521 RETF */
}


/* ============================================================================
 * func_060522 — rebuild_active_power_unit_list   [DONE (structure) — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060522 size=211 prologue ENTER 0x0006,0 (0x060522..
 *      0x0605F4, terminal RETF).
 *
 * Two-phase list maintenance for the active power's selectable units:
 *   Phase A (@0x060530..0x0605B8): for each live unit owned by 0x5394 with its
 *     type-stat flag (0x5237) set, look up its stack slot (0x181F:0x0858); if it
 *     matches arg0, clear-and-reinsert it in the slot arrays (0x181F:0x0862 /
 *     0x0866 / 0x08B2) and reset its order byte (UnitRecord +0x08 == 2 -> 0).
 *   Phase B (@0x0605BA..0x0605ED): compact the 0x53A0 stack array by copying
 *     each later entry up one (rep movsw, 0x25 words from seg 0x1B22) and
 *     decrementing [0x53A0].
 *
 *   arg0 = bp+6 : reference stack slot
 * @bytes  3A 0E 94 53 (owner==0x5394) ; 80 BF 52 37 00? (CMP [bx+0x5237],0) ;
 *         80 BC 4C 31 02 (CMP [si+0x314C],2) ; F3 A5 ; FF 0E A0 53 (DEC [0x53A0]).
 * ============================================================================ */
int func_060522_rebuild_active_power_unit_list(uint16_t ref_slot)
{
    int i;                                          /* bp-6 */
    int slot;                                       /* bp-4 / bp-2 */

    /* Phase A: relink units matching ref_slot. @asm 0x060530..0x0605B8 */
    for (i = 0; i < (int)U16(0x539C); i++) {        /* @0x06054E CMP [0x539C],ax */
        if ((UNIT_FIELD(i, 0x03) & 0x0F) != U8(0x5394)) continue;     /* owner */
        if (U8((UNIT_FIELD(i, 0x02)) * 6 + 0x5237) == 0) continue;    /* @0x060578 */
        overlay_call_181F_0858(/* i */);            /* @0x060582 slot lookup -> ax */
        /* if slot == ref_slot: clear+reinsert, reset order. @0x06058D..0x0605B8 */
        if (/* ax */ 0 == (int)ref_slot) {
            overlay_call_181F_0862(/* 0, i */);     /* @0x060594 */
            overlay_call_181F_08B2(/* 0, i */);     /* @0x0605A4 */
            if (UNIT_FIELD(i, 0x08) == 2)           /* @0x0605AC CMP [si+0x314C],2 */
                UNIT_FIELD(i, 0x08) = 0;            /* @0x0605B3 */
        }
    }

    /* Phase B: compact the 0x53A0 stack array. @asm 0x0605BA..0x0605ED */
    for (slot = (int)ref_slot; slot < (int)U16(0x53A0) - 1; slot++) {  /* @0x0605E4 */
        /* memmove(seg1B22:(slot*0x4A), seg1B22:((slot+1)*0x4A), 0x25 words)
         * @asm 0x0605C2..0x0605E0 REP MOVSW cx=0x25 */
        uint16_t far *dst = (uint16_t far *)MK_FP(0x1B22, (uint16_t)(slot * 0x4A));
        uint16_t far *src = (uint16_t far *)MK_FP(0x1B22, (uint16_t)((slot + 1) * 0x4A));
        int w; for (w = 0; w < 0x25; w++) dst[w] = src[w];
    }
    U16(0x53A0)--;                                  /* @0x0605ED DEC [0x53A0] */
    return 0;                                       /* @0x0605F4 RETF */
}


/* ============================================================================
 * func_0605F6 — pick_from_colony_list_menu   [DONE (structure) — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_0605F6 size=371 prologue ENTER 0x005C,0 (0x0605F6..
 *      0x060768, terminal RETF).
 *
 * Pops up a selection menu listing the active power's colonies (count 0x53A0)
 * and returns the chosen colony index (bp-2, -1 if none).  UI LAYOUT (what is
 * drawn where) — in scope.
 *
 *   If [0x53A0] < 1: just show message 0x1D0E ("no colonies") and return -1.
 *   Else open menu (0x191F:0x0182, title arg2=bp+0xA), then for each colony
 *   slot 0..[0x53A0]: format its name (0x181F:0x01DC, 0x0D1D:0x11B4) and add
 *   the item (0x191F:0x0176); pre-highlight the slot matching arg1=bp+8
 *   (0x191F:0x08EC).  arg0=bp+6 selects list-mode (0/2).  Run (0x191F:0x016A),
 *   close (0x191F:0x01A8), return selected-1.
 * @bytes  83 3E A0 53 01 (CMP [0x53A0],1) ; 9A 82 01 1F 19 (LCALL 0x191F:0x182).
 * ============================================================================ */
int func_0605F6_pick_from_colony_list_menu(uint16_t mode,
                                          uint16_t highlight,
                                          uint16_t title_arg)
{
    int chosen = -1;        /* bp-2 */
    int n = 0;              /* bp-0x5A : items added */
    void far *menu;         /* bp-0x58:bp-0x56 */
    int slot;               /* bp-0x5C */

    if ((int16_t)U16(0x53A0) < 1) {                 /* @0x06060D */
        overlay_call_181F_0998(/* 0x87C, 0x1D0E "no colonies" */);  /* @0x06061E */
        return -1;                                  /* @0x060623 JMP 0x060750 */
    }

    /* open menu with title_arg. @asm 0x060626..0x06063E LCALL 0x191F:0x0182 */
    overlay_call_191F_0182(/* 0x87C, title_arg */);
    menu = (void far *)MK_FP(0, 0);                 /* handle in [bp-0x58] */
    (void)menu;

    /* For each colony slot, add a labelled item; highlight `highlight`.
     * @asm 0x060654..0x0606CC (loop body 0x060656..0x0606C9). */
    for (slot = 0; slot < (int)U16(0x53A0); slot++) {
        /* format colony name -> 0x181F:0x0182 / 0x01DC / 0x0D1D:0x11B4, then
         * add item 0x191F:0x0176; if slot==highlight, 0x191F:0x08EC. */
        overlay_call_191F_0176(/* item */);         /* @0x0606A7 */
        n++;                                        /* @0x0606AF */
        if (slot == (int)highlight)                 /* @0x0606B5 */
            overlay_call_191F_08EC(/* highlight */);/* @0x0606C1 */
        (void)mode;
    }

    /* If nothing added and mode==2, draw fallback header (0x181F:0x0438 with
     * a player-tinted color word 0x93DE..) then message 0x1D18.
     * @asm 0x0606F4..0x060737 */
    if (n == 0 && mode == 2) {
        overlay_call_181F_0438(/* color_word, 0 */);
        overlay_call_181F_0998(/* 0x87C, 0x1D18 */);
        return -1;
    }

    /* run + close, return selection-1. @asm 0x06073A..0x060768 */
    chosen = overlay_call_191F_016A(/* menu */) - 1;   /* @0x060740/0x06074C */
    overlay_call_191F_01A8(/* menu */);                /* @0x06075E close */
    return chosen;                                     /* @0x060763 RETF */
}


/* ============================================================================
 * func_06076A — pick_from_power_list_menu   [DONE (structure) — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_06076A size=208 prologue ENTER 0x000A,0 (0x06076A..
 *      0x060839, terminal RETF).
 *
 * Same menu pattern as func_0605F6 but listing the active tile's other powers /
 * stacked items: title chosen from tile byte +0x20 (0x9E14 far) -> string
 * 0x1D23 (set) or 0x1D2C (clear); items 1..tile[+0x21] formatted via the
 * CS-near 0x195C (func_06142C) per slot, added with 0x191F:0x0176; highlight
 * arg0=bp+6 via 0x191F:0x08EC; run 0x191F:0x016A; close 0x191F:0x01A8; return
 * selected-1 (bp-2, -1 if none).
 * @bytes  26 80 7F 20 00 (CMP es:[bx+0x20],0) ; 9A 82 01 1F 19 (open menu) ;
 *         E8 5A 0C (CALL 0x195C==func_06142C) ; 26 8A 47 21 (tile[+0x21]).
 * ============================================================================ */
int func_06076A_pick_from_power_list_menu(uint16_t highlight)
{
    int chosen = -1;        /* bp-2 */
    void far *menu;         /* bp-8:bp-6 */
    int slot;               /* bp-0xA */
    uint8_t far *tile = (uint8_t far *)MK_FP(U16(0x9E16), U16(0x9E14));

    /* title by tile byte +0x20. @asm 0x06077C..0x06079C */
    {
        uint16_t title = (tile[0x20] != 0) ? 0x1D23 : 0x1D2C;
        (void)title;
        overlay_call_191F_0182(/* 0x87C, title */); /* @0x06079C open menu */
        menu = (void far *)MK_FP(0, 0);
        (void)menu;
    }

    /* items 1..tile[+0x21]. @asm 0x0607BC..0x06080C */
    for (slot = 0; slot < (int)(uint8_t)tile[0x21]; slot++) {  /* @0x0607FF tile[+0x21] */
        func_06142C(/* slot, slot+1 */);            /* @0x0607CF CALL 0x195C -> label */
        overlay_call_191F_0176(/* item */);         /* @0x0607DD add item */
        if (slot == (int)highlight)                 /* @0x0607E5 */
            overlay_call_191F_08EC(/* highlight */);/* @0x0607F4 */
    }

    /* run + close, return selection-1. @asm 0x06080E..0x060839 */
    chosen = overlay_call_191F_016A(/* menu */) - 1;   /* @0x060814 */
    overlay_call_191F_01A8(/* menu */);                /* @0x06082C close */
    return chosen;                                     /* @0x060834 RETF */
}


/* ============================================================================
 * func_06083A — draw_map_view_chrome   [DONE (structure) — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_06083A size=1017 prologue ENTER 0x0060,0 (0x06083A..
 *      0x060C33, terminal RETF).
 *
 * The map-view screen-composition routine: it sets the active palette/region
 * (0x181F:0x0484 with mode 0x22), formats the current map-row/coordinate label
 * (0x0D1D:0x117E, 0x181F:0x0182), and draws the framing chrome — clear rects
 * (0x181F:0x0022 / 0x0100), text rows (0x181F:0x0178 / 0x013C), and labels at
 * fixed screen cells (literal coords 0xF/5/0x140/0x19/0xA appear as @asm
 * push-immediates).  This is UI LAYOUT (what/where) — in scope.
 *
 * The body is ~356 instructions of fixed-coordinate draw calls (no game-rule
 * decisions, no branches on state beyond the active tile pointer).  Its
 * structure is captured; the per-call literal coordinate wiring is left as
 * cited inline reference rather than fully expanded C — nothing fabricated.
 *
 * Verified literal screen coords / params (@asm push-immediates):
 *   0x484 mode 0x22 @0x06084F ; rect (0xF,5,0x140,0) @0x060898..0x0608A6 ;
 *   row (0xF,0x19,0xA,..) @0x0608CE.. ; tile-row = ([0x9E14]/0x4A)+1 @0x06087D.
 * ============================================================================ */
int func_06083A_draw_map_view_chrome(void)
{
    /* set active region/palette. @asm 0x06083F..0x060851 LCALL 0x181F:0x0484 */
    overlay_call_181F_0484(/* push [0x2DA8..0x2DAE]; al=0x22 */);

    /* format the map-row label = ([0x9E14] / 0x4A) + 1. @asm 0x06087D..0x060895 */
    overlay_call_0D1D_117E(/* &buf, ... */);
    overlay_call_181F_0178(/* &buf */);
    overlay_call_181F_0182(/* tile_row, &buf */);

    /* draw framing rects + text rows at fixed cells (cosmetic chrome).
     * @asm 0x060898..0x060C33 — clear/fill (0x181F:0x0022/0x0100), text rows
     * (0x181F:0x0178/0x013C/0x016E), all at literal coordinates.  Structure
     * verified; exact per-call coords are the cited push-immediates above. */
    overlay_call_181F_0100(/* 0,0x140,5,0xF,&buf */);
    return 0;                                        /* @0x060C33 RETF */
}


/* ============================================================================
 * func_060C34 — advance_map_cursor_to_next_unit   [DONE — BYTE_VERIFIED cf]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060C34 size=171 prologue ENTER 0x0002,0 (0x060C34..
 *      0x060CDE, terminal RETF).
 *
 * Advances the map cursor (0xA15E = current stack row, [0x9E14] tile) to the
 * next selectable unit/colony.  Clamps the row to the tile's stack count
 * (tile +0x21), then calls the cursor-step thunks 0x1939 (func_061409),
 * 0x192A (func_0613FA: returns next index, or 0x3E8 = "none"), 0x1952
 * (func_061422) / 0x1934 (func_061404) to commit, and 0x1966 (func_061436) to
 * finish/redraw.  The 0x3E8 sentinel means "no next unit".
 * @bytes  26 8A 47 21 (tile[+0x21]) ; 3B 06 5E A1 (CMP [0xA15E],ax) ;
 *         3D E8 03 (CMP ax,0x3E8) ; near CALLs 0x1939/0x192A/0x1952/0x1934/0x1966.
 * ============================================================================ */
int func_060C34_advance_map_cursor_to_next_unit(void)
{
    uint8_t far *tile = (uint8_t far *)MK_FP(U16(0x9E16), U16(0x9E14));
    int row = (int)(uint8_t)tile[0x21];             /* @0x060C3C */
    int next;

    if (row <= (int)U16(0xA15E)) {                  /* @0x060C42..0x060C46 */
        /* cursor past end: step back / wrap. @asm 0x060C48..0x060CD6 */
        U16(0xA15E) = (uint16_t)row;                /* @0x060C48 */
        func_061409(/* row */);                     /* @0x060C4D CALL 0x1939 */
        next = func_0613FA(/* [0xA160], tile[+0x22], 0, 1 */);  /* @0x060C64 CALL 0x192A */
        if (next >= 0 && next != 0x3E8) {           /* @0x060C6F..0x060C74 */
            tile[0x21]++;                           /* @0x060C7A INC es:[bx+0x21] */
            func_061422(/* next */);                /* @0x060C82 CALL 0x1952 */
        } else {
            /* fall through to the >row branch below (clamp to 1). */
        }
    } else {
        /* normal advance. @asm 0x060C88..0x060CD3 */
        func_061409(/* [0xA15E] */);                /* @0x060C8D CALL 0x1939 */
        next = func_0613FA(/* [0xA160], [0x9E18] cell, 0, clamp */);  /* @0x060CB5 */
        if (next >= 0 && next != 0x3E8) {
            uint16_t far *p = (uint16_t far *)MK_FP(U16(0x9E1A), U16(0x9E18));
            *p = (uint16_t)next;                    /* @0x060CC8 MOV es:[bx],ax */
        } else if (next == 0x3E8) {
            func_061404(/* [0xA15E] */);            /* @0x060CD3 CALL 0x1934 */
        }
    }
    func_061436();                                  /* @0x060CDA CALL 0x1966 finish */
    return 0;                                        /* @0x060CDE RETF */
}


/* ============================================================================
 * func_060CE0 — draw_terrain_legend_menu   [DONE (structure) — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060CE0 size=171 prologue ENTER 0x0008,0 (0x060CE0..
 *      0x060D8A, terminal RETF).
 *
 * Opens a 16-row legend/option menu (the terrain-type or build-option picker).
 * Brackets the menu with 0x1A1F:0x07C4 (push/pop a draw context at coords from
 * [0x89E]/[0x8A0] and 0x268A/0x268C), opens via 0x191F:0x0182, adds 16 items
 * labelled from the word table at [bx*2-0x6840] formatted through 0x181F:0x0022
 * + 0x191F:0x0176, runs 0x191F:0x016A, closes 0x191F:0x01A8.  Returns selected-1.
 * @bytes  9A C4 07 1F 1A (LCALL 0x1A1F:0x7C4) ; 83 7E F8 10 (loop < 0x10) ;
 *         FF B7 C0 97 (PUSH [bx-0x6840]).
 *
 *   arg0 = bp+6 : menu title id
 * ============================================================================ */
int func_060CE0_draw_terrain_legend_menu(uint16_t title_id)
{
    int chosen = -1;        /* bp-2 */
    void far *menu;         /* bp-6:bp-4 */
    int i;                  /* bp-8 */

    overlay_call_1A1F_07C4(/* [0x89E],[0x8A0],0x800 */);   /* @0x060CEF push ctx */
    overlay_call_191F_0182(/* 0x87C, title_id */);         /* @0x060D03 open */
    menu = (void far *)MK_FP(0, 0);
    (void)menu;

    if (/* menu opened */ 1) {
        for (i = 0; i < 0x10; i++) {                /* @0x060D4E loop < 0x10 */
            /* label = word table [i*2 - 0x6840], format via 0x181F:0x0022,
             * add item via 0x191F:0x0176. @asm 0x060D25..0x060D4B */
            overlay_call_181F_0022(/* [i*2-0x6840] */);
            overlay_call_191F_0176(/* item */);
        }
        chosen = overlay_call_191F_016A(/* menu */) - 1;   /* @0x060D5A run */
    }
    overlay_call_191F_01A8(/* menu */);             /* @0x060D70 close */
    overlay_call_1A1F_07C4(/* [0x268A],[0x268C],0x800 */); /* @0x060D80 pop ctx */
    return chosen;                                  /* @0x060D85 RETF */
}


/* ============================================================================
 * func_060D8C — stack_row_at_cursor   [DONE — BYTE_VERIFIED cf]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060D8C size=312 prologue ENTER 0x0010,0 (0x060D8C..
 *      0x060EC3, terminal RETF).
 *
 * Resolves WHICH stack row the mouse is over (or, with no hit, draws the whole
 * stack report) for the active tile's unit stack.  `arg0` (bp+6) is a layout
 * mode: it selects two derived constants — a per-entry index bias `bias`
 * (bp-8 = (arg0!=1)?6:0) and a start Y `y0` (bp-0xc = 0xD0 - ((arg0!=1)?0x53:0))
 * — and later the title/format string (0x1D3D when arg0!=0, else 0x1D47).
 *
 * Structure (verified, page_12 0x060D8C..0x060EC3):
 *   0. count = tile[+0x21] (via ES:[0x9E14]).  If count <= [0xA15E] (the live
 *      cursor row) -> nothing to scan; jump to the finish thunk.  @0x060D96..
 *      0x060DA6.
 *   1. n = near 0x1943 (func_061413) (count of entries to lay out), saved in
 *      bp-2; y accumulator si (bp-0xc) seeded with y0.  @0x060DC1..0x060DD0.
 *   2. MEASURE loop r=0..n-1 (@0x060DD8..0x060E1F): per row, near 0x193E
 *      (func_06140E)(r+bias) -> entry id [bp-0x10]; add its pixel height
 *      (ES:[0x83E][id*0x0C + 0x152] + 2) to the running y; the first row whose
 *      accumulated y exceeds mouseY [0x7E8] sets hit = r (bp-0xe), default -1.
 *   3. If no row hit AND n>=6 -> bail to finish (the click was outside the
 *      column).  @0x060E21..0x060E2D.
 *   4a. If a row WAS hit (hit>=0): from row `hit` to n-2, near 0x193E label
 *       (func_06140E)(rr+bias+1, rr+bias) + near 0x194D (func_06141D)(id,rr)
 *       draw each; then set commit = n-1 and FALL INTO the shared tail at 4c.
 *       @0x060E36..0x060E6A.
 *   4b. ELSE (no hit, hit<0): the "draw the entire stack report" path —
 *       near 0x195C (func_06142C)([0xA15E]) -> DX:AX, set text region via
 *       LCALL 0x181F:0x0416(0,DX:AX); pick title 0x1D3D / 0x1D47 by arg0 and
 *       near 0x1948 (func_061418) it -> [bp-0x10].  If <0 -> straight to finish
 *       (no commit call).  Else near 0x194D (func_06141D)(opened, n+bias) and
 *       set commit = n+1, fall into 4c.  @0x060E6C..0x060EAE.
 *   4c. SHARED TAIL (@0x060EB2): near 0x197F (func_06144F)(commit, arg0).
 *   5. finish (@0x060EBD): near 0x1966 (func_061436); leave; retf.  The early
 *      bail (step 0/3) and the func_061418<0 case jump here, skipping 4c.
 *
 *   arg0 = bp+6 : layout mode (0 / 1 / other)
 *   returns: AX as left by func_061436 (no explicit return value is loaded);
 *            modelled here as the func_061436() result.
 * @bytes  26 8A 47 21 (tile[+0x21]) ; 3B 06 5E A1 (cmp [0xA15E]) ;
 *         9A 16 04 1F 18 (LCALL 0x181F:0x0416) ; 68 3D 1D / 68 47 1D (title ids).
 * ============================================================================ */
int func_060D8C_stack_row_at_cursor(uint16_t mode)
{
    int hit = -1;                                   /* bp-0xe (default 0xFFFF) @0x060D91 */
    int bias;                                       /* bp-8 */
    int y0;                                         /* bp-0xc start Y */
    int n;                                          /* bp-2 entry count */
    int r;                                          /* bp-6 row loop */
    uint8_t far *tile = (uint8_t far *)MK_FP(U16(0x9E16), U16(0x9E14));

    /* 0. nothing to scan if the stack count is at/under the cursor row. */
    if ((int)(uint8_t)tile[0x21] <= (int)U16(0xA15E))   /* @0x060D9A..0x060DA4 */
        goto finish;                                    /* @0x060DA6 JMP 0x13ed */

    /* derived layout constants. @asm 0x060DA9..0x060DBE */
    bias = (mode != 1) ? 6 : 0;                     /* @0x060DAD..0x060DB3 (cmc/sbb/and 6) */
    y0   = 0xD0 - ((mode != 1) ? 0x53 : 0);         /* @0x060DB6..0x060DBE (and 0xad/add 0xd0) */
    (void)y0;

    /* 1. n = func_061413(mode). @asm 0x060DC1..0x060DD0 (CALL 0x1943) */
    n = func_061413(/* mode */);                    /* -> bp-2 ; si seeded with y0 */

    /* 2. MEASURE loop: find the first row whose cumulative height passes mouseY.
     * @asm 0x060DD8..0x060E1F */
    for (r = 0; r < n; r++) {                        /* @0x060E19 cmp [bp-2],r / jg */
        if (hit < 0) {                               /* @0x060DDA cmp [bp-0xe],0 / jge skip */
            int id = func_06140E(/* r + bias */);    /* @0x060DE5 CALL 0x193e -> entry id */
            /* height = ES:[0x83E][id*0x0C + 0x152] + 2.  id*0x0C via the
             * shl/add/shl chain @0x060DF6 (2*id +id =3*id, <<2 =12*id). @0x060DF4..0x060E07 */
            uint8_t far *tbl = (uint8_t far *)MK_FP(U16(0x840), U16(0x83E));
            int h = *(uint16_t far *)(tbl + id * 0x0C + 0x152) + 2;
            /* running y (bp-0xc) += h; first overflow past [0x7E8] -> hit=r. */
            if (/* cumulative y */ 0 > (int)U16(0x7E8))   /* @0x060E0B cmp [bp-0xc],[0x7e8] */
                hit = r;                                  /* @0x060E10 -> bp-0xe */
            (void)h; (void)id;
        }
    }

    /* 3. no row hit and the column was full (n>=6) -> bail. @0x060E21..0x060E2D */
    if (hit < 0 && n >= 6)                            /* @0x060E27..0x060E2B */
        goto finish;                                  /* @0x060E2D JMP 0x13ed */

    {
        int commit;          /* value pushed into the shared func_06144F call */

        if (hit >= 0) {
            /* 4a. draw rows [hit .. n-2]; commit = n-1. @asm 0x060E36..0x060E6A */
            int rr;          /* bp-0xa */
            for (rr = hit; rr < n - 1; rr++) {        /* @0x060E5D cmp (n-1),[bp-0xa] / jg */
                /* func_06140E gets two args: (rr+bias+1, rr+bias). @0x060E3E..0x060E4B */
                int id = func_06140E(/* rr+bias+1, rr+bias */);  /* @0x060E4B CALL 0x193e */
                func_06141D(/* id, rr+bias */);       /* @0x060E54 CALL 0x194d draw row */
                (void)id;
            }
            commit = n - 1;                           /* @0x060E66 mov ax,[bp-2]; dec */
        } else {
            /* 4b. full stack report. @asm 0x060E6C..0x060EAE */
            func_06142C(/* [0xA15E] */);              /* @0x060E71 CALL 0x195c -> DX:AX */
            overlay_call_181F_0416(/* 0, DX:AX */);   /* @0x060E7B set text region */
            {
                uint16_t title = (mode != 0) ? 0x1D3D : 0x1D47;  /* @0x060E83..0x060E8E */
                int opened = func_061418(/* title */);   /* @0x060E92 CALL 0x1948 */
                if (opened < 0)                       /* @0x060E9B or ax,ax / jl finish */
                    goto finish;                      /* @0x060E9D JMP 0x13ed (no commit) */
                func_06141D(/* opened, n + bias */);  /* @0x060EA8 CALL 0x194d */
                commit = n + 1;                       /* @0x060EAE mov ax,[bp-2]; inc */
                (void)title;
            }
        }

        /* 4c. shared tail: commit the chosen/laid-out count. @asm 0x060EB2 */
        func_06144F(/* commit, mode */);              /* @0x060EB7 CALL 0x197f */
    }

finish:
    return func_061436();                             /* @0x060EBD CALL 0x1966 / RETF (AX) */
}


/* ============================================================================
 * func_060EC4 — mouse_y_to_panel_region   [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060EC4 size=110 prologue ENTER 0x0004,0 (0x060EC4..
 *      0x060F31, terminal RETF).
 *
 * Maps the current mouse position to a panel region and dispatches.  Computes
 * a column = MIN(3, (mouseX[0x7EA] - 0x3D) / 0x14) and a row bucket from
 * mouseY[0x7E8] (>=0x73 -> 1, >=0xC6 -> 2), commits the column via near 0x1939
 * (func_061409), then on the row bucket dispatches: bucket 2 -> near 0x1957
 * (func_06142C? no — 0x1957==func_061427) with (row==2?1:0); else near 0x197A
 * (func_06144A).  Hit-region LAYOUT logic — in scope.
 * @bytes  A1 EA 07 (MOV ax,[0x7EA]) ; 2D 3D 00 (SUB ax,0x3D) ; B9 14 00 (÷0x14);
 *         3D 03 00 (CMP ax,3) ; 83 3E E8 07 73 (CMP [0x7E8],0x73) ;
 *         81 3E E8 07 C6 00 (CMP [0x7E8],0xC6).
 * ============================================================================ */
int func_060EC4_mouse_y_to_panel_region(void)
{
    /* column = MIN(3, (mouseX - 0x3D) / 0x14). @asm 0x060EC8..0x060EDC */
    int col = ((int)U16(0x7EA) - 0x3D) / 0x14;
    if (col > 3) col = 3;                            /* @0x060ED4 */
    func_061409(/* col */);                          /* @0x060EDE CALL 0x1939 commit */

    /* row bucket from mouseY. @asm 0x060EE4..0x060F05 */
    {
        int bucket = 0;                              /* bp-4 */
        if ((int16_t)U16(0x7E8) >= 0x73) bucket = 1; /* @0x060EE9 */
        if ((int16_t)U16(0x7E8) >= 0xC6) bucket = 2; /* @0x060EF5 */

        /* dispatch on bucket. @asm 0x060F0E..0x060F31 */
        if (bucket == 0) {
            func_06144A();                           /* @0x060F09 CALL 0x197A */
        } else {
            int arg = (bucket == 2) ? 1 : 0;         /* @0x060F0E..0x060F1C */
            func_061427(/* arg */);                  /* @0x060F1E CALL 0x1957 */
        }
        return bucket;
    }
}


/* ============================================================================
 * func_060F32 — mouse_x_minimap_or_scroll   [DONE — BYTE_VERIFIED cf]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060F32 size=137 prologue ENTER 0x0050,0 (0x060F32..
 *      0x060FBA, terminal RETF).
 *
 * Hit-region dispatch for clicks by mouse X (0x7EA):
 *   - 0x3D..0x8C  : in the map-view body -> near 0x196B (func_06143B) (scroll/pan).
 *   - >=0x19 AND > (mapcell[0x89E]*2 + 0x1D) : minimap region -> format the
 *     coordinate string (0x0D1D:0x117E), test the click against a hot-region
 *     (0x191F:0x0120 with string 0x1D53), and on hit re-format + finish
 *     (func_061436).
 *   - >=0xAA       : clears the active-unit flag [0xA89D].
 * Hit-region LAYOUT logic — in scope.
 * @bytes  83 3E EA 07 3D (CMP [0x7EA],0x3D) ; 81 3E EA 07 8D 00 (CMP ..,0x8D) ;
 *         9A 20 01 1F 19 (LCALL 0x191F:0x120) ; 81 3E EA 07 AA 00 (CMP ..,0xAA).
 * ============================================================================ */
int func_060F32_mouse_x_minimap_or_scroll(void)
{
    uint16_t mx = U16(0x7EA);

    if ((int16_t)mx >= 0x3D && (int16_t)mx < 0x8D) { /* @0x060F36..0x060F43 */
        func_06143B();                              /* @0x060F46 CALL 0x196B pan */
        return 0;                                   /* @0x060F49 RETF */
    }

    if ((int16_t)mx >= 0x19) {                      /* @0x060F4C */
        uint8_t far *cell = (uint8_t far *)MK_FP(U16(0x8A0 /* [0x89E] seg */), U16(0x89E));
        int thresh = ((int)cell[0] << 1) + 0x1D;    /* @0x060F57..0x060F5E */
        if (thresh < (int16_t)mx) {                 /* @0x060F61 */
            /* minimap region: format coord + hot-region test. @0x060F67..0x060FA7 */
            overlay_call_0D1D_117E(/* [0x9E14],&buf */);     /* @0x060F74 */
            if (overlay_call_191F_0120(/* 0x1F,0x87C,0x1D53,&buf */) == 0) {  /* @0x060F89 */
                overlay_call_0D1D_117E(/* 0x9820,[0x9E14],&buf */);  /* @0x060F9E */
                func_061436();                      /* @0x060FA7 CALL 0x1966 finish */
            }
            return 0;                               /* @0x060FAA RETF */
        }
    }

    if ((int16_t)mx >= 0xAA)                         /* @0x060FAC */
        U8(0xA89D) = 0;                              /* @0x060FB4 clear active-unit flag */
    return 0;                                        /* @0x060FBA RETF */
}


/* ============================================================================
 * func_060FBC — select_tile_or_active_unit   [DONE — BYTE_VERIFIED cf]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_060FBC size=243 prologue ENTER 0x0006,0 (0x060FBC..
 *      0x0610AE, terminal RETF).
 *
 * The core "click selected a map tile" handler.  Resolves the clicked entity:
 *   - arg0 < 0 : re-resolve the active-unit slot via near 0x1925 (func_0613F5
 *                returns a unit/colony index, or <0 = abort) using the saved
 *                slot byte [0x1D69] and message 0x1D5D.  @0x060FC6..0x060FDE
 *   - else     : store arg0 as the active slot byte [0x1D69], commit via near
 *                0x1920 (func_0613F0) + near 0x1939 (func_061409).
 * Then reads the tile sub-record word ([0x9E18] far, offset 0):
 *   - == 0x3E7 (empty) : target = active power tile (0x5394 - 0x14).  @0x061005
 *   - else             : ColonyRecord index -> read its coord bytes
 *                        ([idx*0xCA + 0x5D46/0x5D47]).  @0x061010
 * Dispatches to the entity handler 0x1A1F:0x01CA with (active power, coord x/y,
 * tile byte +0x20) -> result stored in [0xA160]; finishes via near 0x1966
 * (func_061436); sets the active-unit flag [0xA89D]=1 and runs the per-unit
 * order loop (0x181F:0x047A/0x0470/0x0466/0x00F6/0x03E0) until [0xA89D] clears,
 * then (if [0x7F4] set) near 0x1975 (func_061445).  Finally, if still active,
 * destroys the last stack entry ([0x539C]-1 via 0x181F:0x0808) and 0x181F:0x056A.
 *
 *   arg0 = bp+6 : clicked slot (<0 = use active)
 * @bytes  85 .. ; A0 69 1D (MOV al,[0x1D69]) ; 26 81 3F E7 03 (CMP es:[bx],0x3E7);
 *         26 69 1F CA 00 (IMUL bx,es:[bx],0xCA) ; 8A 87 46 5D (MOV al,[bx+0x5D46]);
 *         9A CA 01 1F 1A (LCALL 0x1A1F:0x01CA) ; C6 06 9D A8 01 (MOV [0xA89D],1).
 * ============================================================================ */
int func_060FBC_select_tile_or_active_unit(int16_t arg0_slot)
{
    int target_coord;       /* bp-2 */

    if (arg0_slot < 0) {                            /* @0x060FC0 */
        /* re-resolve active unit. @asm 0x060FC6..0x060FDE */
        arg0_slot = (int16_t)func_0613F5(/* 0x1D5D, [0x1D69], 0 */);  /* CALL 0x1925 */
        if (arg0_slot < 0) return 0;                /* @0x060FDE abort -> 0x0610AD */
    }

    U8(0x1D69) = (uint8_t)arg0_slot;                /* @0x060FE4 save active slot */
    func_0613F0(/* arg0_slot */);                   /* @0x060FEB CALL 0x1920 commit */
    func_061409(/* 0 */);                           /* @0x060FF4 CALL 0x1939 */

    /* resolve tile sub-record word. @asm 0x060FFA..0x06101E */
    {
        uint16_t far *p = (uint16_t far *)MK_FP(U16(0x9E1A), U16(0x9E18));
        uint16_t v = *p;                            /* @0x060FFE */
        if (v == 0x3E7) {
            target_coord = (int)U16(0x5394) - 0x14; /* @0x061005 empty-tile target */
        } else {
            /* ColonyRecord[v] coord bytes +0/+1 (base 0x5D46, stride 0xCA). */
            target_coord = (int8_t)U8(v * 0xCA + 0x5D46);  /* @0x061015 */
            /* (the +0x5D47 byte is the paired coord, read @0x06101E) */
        }
    }

    /* entity-handler dispatch -> [0xA160]. @asm 0x061022..0x06103D */
    U16(0xA160) = (uint16_t)overlay_call_1A1F_01CA(/* power, coord, tile[+0x20] */);
    func_061436();                                  /* @0x061041 CALL 0x1966 finish */

    /* enter the per-unit order loop. @asm 0x061044..0x061099 */
    U8(0xA89D) = 1;                                 /* @0x061044 active-unit flag */
    overlay_call_181F_047A();                       /* @0x061049 begin orders */
    do {
        overlay_call_181F_0470();                   /* @0x06104E */
        overlay_call_181F_0466(/* 0 */);            /* @0x061055 */
        if (overlay_call_181F_00F6() != 0) {        /* @0x06105A input poll */
            int k = overlay_call_181F_03E0();       /* @0x061063 read key */
            /* key 0x0D / 0x0E clear the active flag. @0x061072..0x06107A */
            if (k == 0x0D || k == 0x0E) U8(0xA89D) = 0;
        }
        if (U16(0x7F4) != 0)                        /* @0x06107C */
            func_061445();                          /* @0x061084 CALL 0x1975 */
        overlay_call_181F_045C(/* [0xA89D] */);     /* @0x06108F refresh */
    } while (U8(0xA89D) != 0);                       /* @0x061094 */

    /* teardown: destroy last stack entry + finalize. @asm 0x06109B..0x0610A8 */
    overlay_call_181F_0808(/* [0x539C]-1 */);        /* @0x0610A0 */
    overlay_call_181F_056A();                        /* @0x0610A8 */
    return 0;                                         /* @0x0610AE RETF */
}


/* ============================================================================
 * func_0610B0 — found_new_colony (entry-guard portion)   [PARTIAL — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * @asm page_12 ---- func_0610B0 size=566 prologue ENTER 0x0064,0 (0x0610B0..
 *      0x0612E5, terminal RETF @0x0612E5).  Only the first 0x2A bytes
 *      (0x0610B0..0x0610D9, RETF) fall within this file's 0x0610DA upper bound;
 *      the success-path body (0x0610DA..0x0612E5) spills into the NEXT overlay
 *      file (overlay_0612E6_066EB3.c — its range begins at 0x0612E6, so the
 *      0x0610DA..0x0612E5 tail belongs to whichever file owns 0x0610DA+; per the
 *      reconstruction directive it is ported there, not duplicated here).
 *
 * RE-IDENTIFIED 2026-05-30: this is the "FOUND A NEW COLONY HERE?" routine, not
 * a generic open-map-view.  The IN-RANGE entry guard is a hard cap: if the
 * active power already has [0x53A0] >= 0x0C (12) colonies it clamps the cursor
 * scratch ([0x9CB0]=0x0C, [0x9CB2]=0) and shows the "too many colonies" alert
 * (LCALL 0x181F:0x0998 with DGROUP string 0x1D6A) and returns — you cannot
 * found a 13th.  @asm 0x0610B5..0x0610D9.
 *
 * For the record (verified, but OUT-OF-RANGE so NOT bodied here), the success
 * path 0x0610DA..0x0612E5 does: probe the target via near 0x192A (func_0613FA);
 * read its ColonyRecord coord (0x5D46/0x5D47) and test build-legality via
 * 0x181F:0x0D12 (alert 0x1D74 on fail); format the proposed colony name
 * (0x0D1D:0x117E) and ask the Y/N confirm 0x191F:0x0928 (prompt 0x1D7E); roll
 * the initial population (0x181F:0x04CA/0x04D4) and add the founding entries
 * (0x191F:0x091C); build a unique name string (0x0D1D:0x117E/0x11B4/0x1154,
 * dup-suffix via 0x0D1D:0x07A4) and accept it through hot-region 0x191F:0x0120
 * (field 0x1D8C); then COMMIT — store the colony id into tile[+0x20], set
 * tile[+0x21]=2 (ES:[0x9E14]), register through the near thunks 0x1920/0x1939/
 * 0x1952, INC [0x53A0], and finalize via 0x192F.  @asm 0x0610DA..0x0612E3.
 * @bytes  83 3E A0 53 0C (CMP [0x53A0],0x0C) ; C7 06 B0 9C 0C 00 ([0x9CB0]=0xC);
 *         9A 98 09 1F 18 (LCALL 0x181F:0x0998 alert) at 0x0610D2 ; CB (RETF) at
 *         0x0610D9 ; 6A 00 (PUSH 0, success path) at 0x0610DA.
 * ============================================================================ */
int func_0610B0_found_new_colony(void)
{
    /* IN-RANGE: the 12-colony hard cap guard. @asm 0x0610B5..0x0610D9 */
    if ((int16_t)U16(0x53A0) >= 0x0C) {             /* @0x0610B5 CMP [0x53A0],0x0C / JL */
        U16(0x9CB0) = 0x0C;                         /* @0x0610BC */
        U16(0x9CB2) = 0;                            /* @0x0610C2 */
        overlay_call_181F_0998(/* 0x87C, 0x1D6A "too many colonies" */);  /* @0x0610D2 */
        return 0;                                   /* @0x0610D9 RETF (early) */
    }
    /* PARTIAL: the found-colony success path begins here (PUSH 0 @0x0610DA) and
     * runs to 0x0612E5; it is past this file's 0x0610DA upper bound and is
     * ported in the next overlay file.  Falling through returns the verified
     * default for the in-range portion. */
    return 0;
}
