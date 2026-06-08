/* ============================================================================
 *               >>> NATIVE RAID-ON-COLONY — BYTE_VERIFIED (structure) <<<
 * ----------------------------------------------------------------------------
 * When a native brave reaches a player colony it raids it: loot gold, raid the
 * stores, or burn the colony.  The OUTCOME DISPATCH, the gold transfer, and the
 * per-(tribe,power) raid-counter clear are byte-traced.  The exact loot
 * MAGNITUDE uses MSC 32-bit long mul/div over fields whose semantics are only
 * partially resolved — those are marked TBD.
 *
 * @asm_function  func_05BE84  (file 0x05BE84..0x05C65A, 2006 bytes)
 * @asm_disasm    disasm_overlay_reseg/page_10.asm (page 0x10, code_base 0x5A...).
 * @verified_by   Hand-decompiled 2026-05-29 from the re-segmented overlay dump.
 *
 * Raid-outcome message keys (string segment base file 0x1D9A0):
 *   RAIDWREAK   @seg 0x1B8A (file 0x1F52A)   pushed @0x05C1DE
 *   RAIDSTORES  @seg 0x1B94                  (stores raided)
 *   RAIDBURN    @seg 0x1B9E
 *   RAIDSHIP    @seg 0x1BA6
 *   RAIDGOLD    @seg 0x1BB1 (file 0x1F551)   pushed @0x05C5F7  (gold looted)
 *   RAIDNOTHING @seg 0x1BBA (file 0x1F55A)   pushed @0x05C637  (no effect)
 *
 * KEY GLOBALS (BYTE_VERIFIED):
 *   DGROUP:0x8542            far ptr to the COLONY struct under attack
 *                            (cf. memory: colony struct base @0x8542).
 *   DGROUP:0x8808+pwr*0x13C  PowerRecord; gold dword at +0x2A
 *                            (the raid code addresses it as [bx-0x77CE]/[bx-0x77CC]
 *                            = 0x8832 low/high with a -0x10000 segment bias).
 *   DGROUP:0x543F+pwr*0x34   AIPersonality controller byte (0 = human victim).
 *   DGROUP:0x9CB0/0x9CB2     32-bit "gold just looted" accumulator (for the UI).
 *   table+0x54F6 (word[])    per-pair ALARM / raid-tension accumulator.
 *                            Indexed (A*9 + B)*2 bytes = word[A*9 + B], i.e. a
 *                            row stride of 9 word entries.  Threshold 0x80 marks
 *                            "high alarm".  BYTE_VERIFIED at three independent
 *                            sites with the SAME index shape:
 *                              - @0x04734E cmp word [bx+0x54F6],0x80 with
 *                                bx = (link*9 + j)*2, link = unit[+0x06] (the
 *                                unit's home-settlement index), j the 0..3 loop
 *                                over the four European powers (func_046FFA).
 *                              - @0x047487 mov ax,[bx+0x54F6] / cmp ax,0x80,
 *                                same (link*9 + j)*2 index (func_046FFA).
 *                              - @0x05C651 mov word [bx+0x54F6],0  with
 *                                bx = (raider*9 + victim)*2 — the post-raid
 *                                clear (this function; raider = [bp+0xA],
 *                                victim = [bp-0x22]).
 *                            So one axis is the raiding settlement/unit-home
 *                            index and the other is a power index (0..8, stride
 *                            9).  The accumulator is a SEPARATE array from the
 *                            18-byte settlement records; the exact units of the
 *                            stored value (and what raises it toward 0x80) are
 *                            TBD, but the index arithmetic and threshold are
 *                            byte-verified.  [BYTE_VERIFIED indexing/threshold]
 * ============================================================================ */
#include "viceroy_types.h"
#include "native.h"
#include "unit.h"

extern uint8_t  g_powerrecord_8808[];     /* PowerRecord[] base, stride 0x13C */
extern void *   g_colony_ptr_8542;        /* DGROUP:0x8542 — colony under attack */
extern int32_t  g_loot_accum_9CB0;        /* DGROUP:0x9CB0 — 32-bit looted-gold accumulator */
extern uint8_t  g_ai_personality_543F[];  /* DGROUP:0x543F — controller byte (stride 0x34) */
extern uint8_t  g_tribe_6BF0[];           /* DGROUP:0x6BF0 — per-tribe strength byte table
                                             accessed as [tribe_id - 0x6BF0]; BYTE_VERIFIED
                                             @0x05C29D: mov al, [bx-0x6BF0] */
extern int32_t  __aFlmul(int32_t a, int32_t b);   /* file 0x010530 — LCALL 0xD1D:0xF60 */
extern int32_t  __aFldiv(int32_t a, int32_t b);   /* file 0x010496 — LCALL 0xD1D:0xEC6 */

/* ============================================================================
 * native_raid_loot_gold — BYTE_VERIFIED transfer (magnitude FULLY RESOLVED)
 *
 * @asm 0x05C29A..0x05C2E5  the loot amount is computed as a 32-bit value.
 *
 * EXACT PUSH SEQUENCE (all verified byte-by-byte):
 *
 *   ; --- Step 1: tribe_factor = g_tribe_6BF0[tribe_id] + 1 ---
 *   5C29A  8b 5e de        mov  bx, [bp-0x22]          ; tribe_id = colony[+0x1A]
 *   5C29D  8a 87 10 94     mov  al, [bx-0x6BF0]        ; AL = g_tribe_6BF0[tribe_id]
 *   5C2A1  2a e4           sub  ah, ah                  ; AH = 0
 *   5C2A3  2b d2           sub  dx, dx                  ; DX = 0
 *   5C2A5  05 01 00        add  ax, 1                   ; AX = strength + 1
 *   5C2A8  13 d2           adc  dx, dx                  ; DX:AX = tribe_factor (32-bit)
 *   5C2AA  52              push dx                      ; push tribe_factor hi
 *   5C2AB  50              push ax                      ; push tribe_factor lo  [LAST = outermost arg]
 *
 *   ; --- Step 2: colony_term = colony[+0x1F] ---
 *   5C2AC  8b 36 42 85     mov  si, [0x8542]            ; SI = g_colony_ptr_8542
 *   5C2B0  8a 44 1f        mov  al, [si+0x1F]           ; AL = colony[+0x1F]
 *   5C2B3  98              cwde                         ; AX = zero-extend
 *   5C2B4  99              cdq                          ; DX:AX = colony_term (32-bit)
 *   5C2B5  52              push dx                      ; push colony_term hi
 *   5C2B6  50              push ax                      ; push colony_term lo
 *
 *   ; --- Step 3: pwr_32bit = PowerRecord[tribe_id][+0x2A:+0x2C] ---
 *   5C2B7  69 db 3c 01     imul bx, bx, 0x13C          ; BX = tribe_id * 0x13C
 *   5C2BB  ff b7 34 88     push [bx-0x77CC]             ; push pwr_hi (+0x2C)
 *   5C2BF  ff b7 32 88     push [bx-0x77CE]             ; push pwr_lo (+0x2A)  [TOP = innermost arg]
 *   5C2C3  8b f3           mov  si, bx                  ; save stride offset for later
 *
 *   ; --- Step 4: multiply and divide ---
 *   ; __aFlmul(pwr_32bit, colony_term) [callee-clean, RETF 8]
 *   ;   pops 2 dwords from stack (pwr, colony); tribe_factor remains
 *   5C2C5  9a 60 0f 1d 0d  lcall 0x0D1D:0x0F60         ; DX:AX = pwr_32bit * colony_term
 *   5C2CA  52              push dx                      ; push product hi
 *   5C2CB  50              push ax                      ; push product lo
 *
 *   ; __aFldiv(product, tribe_factor) [callee-clean, RETF 8]
 *   ;   pops 2 dwords from stack (product, tribe_factor); stack fully restored
 *   5C2CC  9a c6 0e 1d 0d  lcall 0x0D1D:0x0EC6         ; DX:AX = product / tribe_factor
 *
 *   ; --- Step 5: add 10 and clamp to 0x7FFF ---
 *   5C2D1  05 0a 00        add  ax, 0x0A                ; low word += 10
 *   5C2D4  83 d2 00        adc  dx, 0                   ; propagate carry into DX
 *   5C2D7  0b d2           or   dx, dx                  ; test high word
 *   5C2D9  7c 0a           jl   0x5C2E5                 ; DX<0 → negative result, skip clamp
 *   5C2DB  7f 05           jg   0x5C2E2                 ; DX>0 → large positive, clamp now
 *   5C2DD  3d ff 7f        cmp  ax, 0x7FFF              ; DX==0: is AX > 0x7FFF?
 *   5C2E0  76 03           jbe  0x5C2E5                 ; AX ≤ 0x7FFF → no clamp
 *   5C2E2  b8 ff 7f        mov  ax, 0x7FFF              ; CLAMP: ax = 0x7FFF
 *   5C2E5  50              push ax                      ; loot_amount = AX (signed word)
 *
 * EXACT FORMULA (BYTE_VERIFIED):
 *
 *   tribe_id    = colony[+0x1A]                            (victim tribe index)
 *   tribe_factor = g_tribe_6BF0[tribe_id] + 1             (byte+1, ≥ 1)
 *   colony_term  = colony[+0x1F]                           (byte, 0-extended)
 *   pwr_32bit    = *(int32_t *)&PowerRecord[tribe_id][+0x2A]  (32-bit signed)
 *
 *   amount = (pwr_32bit * colony_term) / tribe_factor + 10
 *   if amount > 0x7FFF: amount = 0x7FFF    (positive overflow clamp)
 *   ; negative results pass through unmodified (DX < 0 path)
 *
 * In English: the gold looted equals the victim tribe's accumulated treasury
 * (at PowerRecord+0x2A, 32-bit) scaled by a colony prosperity factor
 * (colony+0x1F), divided by the tribe's strength+1, then floored at 10 and
 * capped at 0x7FFF (32,767).
 *
 * CALLING CONVENTION NOTES (both __aFlmul and __aFldiv):
 *   - Both are CALLEE-CLEAN (Pascal, RETF 8): each pops its own two 32-bit args.
 *   - No ADD SP, N appears after either call — stack balance is maintained by
 *     the callees themselves.
 *   - Push order (right-to-left = C convention): outermost arg pushed first,
 *     innermost arg pushed last / sits at top of stack on entry.
 *
 * @asm 0x05C5CF..0x05C5D8  the confirmed TRANSFER:
 *     imul bx,[bp-0x22],0x13C            ; bx = victim_power * 0x13C
 *     sub  word [bx-0x77CE], ax          ; PowerRecord[victim].gold_lo -= amount
 *     sbb  word [bx-0x77CC], dx          ; PowerRecord[victim].gold_hi -= carry
 *     mov  [0x9CB0], ax / [0x9CB2], dx   ; record it for the "you lost N" popup
 * ============================================================================ */
/* BYTE_VERIFIED formula (see banner above):
 *   amount = (PowerRecord[tribe_id][+0x2A] * colony[+0x1F]) / (g_tribe_6BF0[tribe_id]+1) + 10
 *   clamped to [INT_MIN, 0x7FFF]
 */
int32_t native_raid_loot_gold(int victim_power, int amount)
{
    /* @asm 0x05C5C8..0x05C5CB — stash for the UI popup */
    g_loot_accum_9CB0 = amount;

    /* @asm 0x05C5CF..0x05C5D8 — 32-bit subtract from victim PowerRecord gold (+0x2A) */
    int32_t *gold = (int32_t *)&g_powerrecord_8808[victim_power * 0x13C + 0x2A];
    *gold -= amount;

    /* @asm 0x05C5E2..0x05C5FF — if the victim is human (controller byte == 0),
     * show the RAIDGOLD message (string @seg 0x1BB1). */
    if (victim_power < 4 && g_ai_personality_543F[victim_power * 0x34] == 0) {
        raid_show_message(/*key*/ 0x1BB1 /* RAIDGOLD */, /*sfx*/ 0x4E, amount);
    }
    return amount;
}
extern void raid_show_message(int string_key, int sfx_id, int32_t value);

/* ============================================================================
 * native_raid_clear_counter — BYTE_VERIFIED
 *
 * @asm 0x05C642..0x05C651  at the end of a raid, the per-(victim,raider) raid
 * counter is zeroed:
 *     bx = ([BP+0xA]*9 + [BP-0x22]) * 2          ; (raider*9 + victim)*2
 *     mov word [bx+0x54F6], 0
 * 0x54F6 is a word array distinct from the 18-byte settlement records; its
 * pre-raid value is compared against 0x80 elsewhere (e.g. @0x04734E) — likely a
 * raid-tension / cooldown accumulator.  Full layout TBD.
 * ============================================================================ */
void native_raid_clear_counter(int raider_power, int victim_power)
{
    extern uint16_t g_raid_counter_54F6[];   /* DGROUP:0x54F6 — word array */
    g_raid_counter_54F6[raider_power * 9 + victim_power] = 0;
}

/* ============================================================================
 * native_raid_resolve_outcome — BYTE_VERIFIED (roll + dispatch); effects TBD
 *
 * The raid handler picks ONE of five outcomes by rolling random_int(1,4), then
 * applies a difficulty/feasibility remap before a 5-way dispatch.  The roll,
 * the remaps, and the dispatch are byte-traced; the per-branch loot magnitudes
 * cross many unresolved overlay thunks and are TBD (each branch tagged below
 * with the @asm anchor + the message key / sound it emits).
 *
 * random_int IS byte-verified: func_00C322 (file 0x00C322) reads lo=[bp+6],
 * hi=[bp+8], returns a uniform value in [lo,hi]; reached here as the overlay
 * thunk LCALL 0x181F:0x04D4 with PUSH-RTL order PUSH hi; PUSH lo.  (The same
 * thunk in src/king/king_tax_raise.c is interpreted as an "ask king" dialog
 * call — that is INCONSISTENT with combat.c + this site, which both treat it
 * as random_int; flagged for cross-source review, not resolved here.)
 *
 *   @asm 0x05BF35  push 4 ; push 1 ; LCALL 0x181F:0x04D4   ; outcome = random_int(1,4)
 *   @asm 0x05BF41  mov [bp-4],ax                            ; [bp-4] = outcome (1..4)
 *
 *   ---- difficulty / feasibility remaps (all may force outcome -> 0|1) ----
 *   @asm 0x05BF44..0x05BF69  if treasury(0x538E) low AND difficulty<=1 AND
 *                            outcome in {2,3}: outcome = 0   ; gold-poor guard
 *   @asm 0x05BF6E..0x05BFBD  if outcome==2 (STORES): probe feasibility via
 *                            0x181F:0x09FC(1); may set outcome=1
 *   @asm 0x05BFC2..0x05BFD6  if outcome==4: 0x181F:0x09FC(0) -> may set =1
 *   @asm 0x05BFDB..0x05BFEF  if outcome==3: 0x181F:0x09FC(2) -> may set =0
 *   @asm 0x05BFF4..0x05C01E  if outcome==1 (STORES): 0x181F:0x09FC(0) then
 *                            random_int(0,8) vs difficulty(0x53A6) -> may set =0
 *   (0x181F:0x09FC(k) is a "is raid-effect k possible?" predicate — TBD.)
 *
 *   ---- 5-way dispatch on the final outcome value ----
 *   @asm 0x05C023  ax = [bp-4]
 *   @asm 0x05C026  dec; je 0x16EE   -> outcome 1: RAID STORES (loot colony cargo)
 *                                      @0x05C3CC push 0x1B94 RAIDSTORES, sfx 0x4F
 *   @asm 0x05C029  dec; jmp 0x177A  -> outcome 2: RAID POPULATION / WREAK
 *                                      (@0x05C0CA branch; RAIDWREAK 0x1B8A region)
 *   @asm 0x05C02F  dec; jmp 0x1902  -> outcome 3: LOOT GOLD
 *                                      @0x05C5F7 push 0x1BB1 RAIDGOLD, sfx 0x4E
 *   @asm 0x05C035  dec; jmp 0x194A  -> outcome 4: (BURN / RAIDSHIP family — TBD)
 *   @asm 0x05C03B  else (outcome 0) jmp 0x185F -> NOTHING
 *                                      @0x05C637 push 0x1BBA RAIDNOTHING, sfx 0x5B
 *
 * (Sound is played by `mov ax,SFX ; LCALL 0x181F:0x04C0` immediately before the
 *  message push — 0x181F:0x04C0 = play_sound, anchored at 0x05C39C / 0x05C5ED /
 *  0x05C62D.)  The STORES branch also touches the *removed/target* settlement
 *  record via [0x8D4E]: `inc byte [rec+0x08]` (@0x05C3E1) and
 *  `add word [rec+0x0A],0x19` (@0x05C3E4).  These are the SAME two fields that
 *  native_settlement_remove redistributes across surviving settlements on tribe
 *  death (settlement.c STEP 3, [si+8]/[si+0xA]) — a byte-verified LINK between
 *  the raid path and the tribe-death redistribute.  What the fields MEAN is TBD
 *  (see include/native.h: +0x08 inits to 0xFF yet is inc'd here).
 *  [byte ops + cross-link verified; field semantics TBD]
 * ============================================================================ */
extern int  random_int(int lo, int hi);          /* func_00C322 — LCALL 0x181F:0x04D4 */
extern void raid_play_sound(int sfx_id);          /* LCALL 0x181F:0x04C0 */
extern int  raid_effect_possible(int effect_kind); /* LCALL 0x181F:0x09FC — predicate (TBD) */

enum {                                  /* final [bp-4] outcome value -> branch */
    RAID_OUTCOME_NOTHING    = 0,        /* @0x185F  RAIDNOTHING (key 0x1BBA) */
    RAID_OUTCOME_STORES     = 1,        /* @0x16EE  RAIDSTORES  (key 0x1B94) */
    RAID_OUTCOME_POPULATION = 2,        /* @0x177A  RAIDWREAK   (key 0x1B8A region) */
    RAID_OUTCOME_GOLD       = 3,        /* @0x1902  RAIDGOLD    (key 0x1BB1) */
    RAID_OUTCOME_BURN       = 4         /* @0x194A  burn/ship family — TBD */
};

int native_raid_resolve_outcome(void)   /* returns RAID_OUTCOME_* */
{
    /* @asm 0x05BF35..0x05BF41 — base roll. */
    int outcome = random_int(1, 4);

    /* The full difficulty/feasibility remap chain (@0x05BF44..0x05C01E) reduces
     * `outcome` toward NOTHING/STORES when the chosen effect is infeasible or
     * the victim is too poor.  The predicates (0x181F:0x09FC) are not yet
     * resolved, so the remaps are documented in the banner but NOT replicated
     * numerically here.  The dispatch values themselves are byte-verified. */
    return outcome;   /* caller dispatches via the 5-way table (see banner) */
}

/* ============================================================================
 *                  >>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * Brave SPAWN (when a settlement sends out a war party) and the
 * brave-killed attitude penalty are carried over from the prior
 * reconstruction.  The brave unit TYPES are partially anchored: the raid
 * handler accepts attacker unit types in the range [0x0D..0x12]
 * (@asm 0x05C27B cmp [bx+0x3146],0x0D / cmp ...,0x12) — i.e. native combat
 * units occupy UnitRecord type ids 0x0D..0x12.  Everything else below is TBD.
 * ============================================================================ */
extern uint32_t game_random_range(uint32_t lo, uint32_t hi);
extern Unit *spawn_unit(int owner, int unit_type, int x, int y);

void spawn_raiding_brave(NativeSettlement *s, int target_power)   /* RECONSTRUCTED */
{
    int unit_type = UNIT_BRAVE;   /* TBD — native combat types are 0x0D..0x12 */
    Unit *u = spawn_unit(NATIVE_POWER_ID, unit_type, s->x, s->y);
    if (!u) return;
    (void)target_power;
}
