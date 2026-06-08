/* ============================================================================
 *                  >>> BYTE_VERIFIED (LCR roll engine) <<<
 * ----------------------------------------------------------------------------
 * Lost City Rumour resolution, hand-decompiled from VICEROY.EXE — REWRITTEN
 * 2026-05-30 against the FULL re-segmented disassembly of func_061454 (all 722
 * instructions), superseding the 2026-05-28 partial reconstruction.
 *
 * @asm_function   func_061454            (overlay page 0x12)
 * @asm_offset     file 0x061454..0x061C9C   (2121 bytes, ENTER 0x3C,0, RETF)
 * @asm_disasm     code/VICEROY/disasm_overlay_reseg/page_12.asm  (func_061454)
 * @region         overlay (page 0x12; file 0x05FAD0..0x061CA0, code 0x05FE60)
 * @ip_base        Disasm shows file_offset AND a page-relative IP
 *                 (IP = file - 0x05FAD0). The function spans IP 0x1984..0x21CC.
 *                 NB: the prior reconstruction cited "0x06215C" for the final
 *                 switch — that was the IP form mislabelled as a file offset.
 *                 The switch is at file 0x061C2C / IP 0x215C, INSIDE this func.
 * @verified_by    Hand-decompiled instruction-by-instruction 2026-05-30.
 *
 * IDENTIFICATION (string-first, per MEMORY.md methodology) — BYTE_VERIFIED:
 *   The function builds three GAME.TXT message-key base strings (via the
 *   strcpy helper 0xD1D:0x7E4, then the itoa-append helper 0x181F:0x182):
 *     "LOSTCITY"  DGROUP handle 0x1DAE (file 0x1F74E)  @asm file 0x0618C2
 *     "BURIAL"    DGROUP handle 0x1DB7 (file 0x1F757)  @asm file 0x061B03
 *     "SCREWED"   DGROUP handle 0x1DBE (file 0x1F75E)  @asm file 0x061B6E
 *   String rule: file_offset = handle + 0x1D9A0 (DGROUP file base). Confirmed
 *   against code/VICEROY/strings.json (LOSTCITY@128846 / BURIAL@128855 /
 *   SCREWED@128862). This is the ONLY function that pushes all three keys.
 *
 * THE BIG FINDING — the outcome distribution is PROCEDURAL, not a weight table.
 *   The pre-2026-05-28 `LCR_WEIGHTS[]` (a static 100-point table) was FABRICATED.
 *   VICEROY rolls random_int(1,9) for the base outcome (@asm file 0x0614F6,
 *   IP 0x1A26) and mutates it through a cascade of gates: a rising-floor
 *   anti-streak, a Scout/Seasoned-Scout bonus, a Founding-Father "no bad luck"
 *   flag, terrain type, per-session counters [0x1DC6]/[0x1DC7], and the 0x5382
 *   debug flag. The 1..9 number is used DIRECTLY as the decimal suffix of the
 *   "LOSTCITY" key (itoa-append at file 0x0618D9). There is no weight table.
 *
 * OUTCOME NUMBER -> GAME.TXT @LOSTCITY<n> meaning (BYTE_VERIFIED via the
 * message-key build site + the GAME.TXT text):
 *   1  @LOSTCITY1  Fountain of Youth  (8 free immigrants)
 *   2  @LOSTCITY2  Seven Cities of Cibola (treasure unit, ferry by galleon)
 *   3  @LOSTCITY3  ruins of a lost civilization (immediate gold)
 *   4  @LOSTCITY4  burial mounds -> BURIAL1/2/3 sub-dispatch (+SCREWED if rude)
 *   5  @LOSTCITY5  expedition vanished without a trace (unit destroyed)
 *   6  @LOSTCITY6  nothing but rumours (fizzle)
 *   7  @LOSTCITY7  small friendly tribe, chief's gift of gold
 *   8  @LOSTCITY8  trespass near holy shrines (tribe displeased)
 *   9  @LOSTCITY9  desperate survivors of a former colony swear allegiance
 *
 * Burial sub-dispatch (outcome 4, file 0x061989..0x061B89, BYTE_VERIFIED):
 *   sub=1 @BURIAL1 mounds cold and empty (nothing)          @asm 0x0619F8
 *   sub=2 @BURIAL2 trinkets worth NUMBER0 (small gold)       @asm 0x061A18
 *   sub=3 @BURIAL3 incredible treasure worth NUMBER1 (treasure unit) @asm 0x061A58
 *   @SCREWED appended (file 0x061B6E) if the player is the human AND a hostile
 *            tribe owns the grounds: the offended tribe is smited via the
 *            native-attitude helper 0x181F:0xD6C (file 0x045DF2).
 *
 * GOLD MAGNITUDES — UPGRADED from the prior "[TBD]" to BYTE_VERIFIED.  The
 * 2026-05-28 notes claimed the gold scale routed through an undecoded Type-B
 * helper.  It does NOT: the message NUMBER args (and the treasury credit) are
 * the locals [bp-0x10] (gold) and [bp-0x32] (treasure-unit value), computed
 * inline below.  0x181F:0x9AE (file 0x06C27C, resolved via typeA_thunk_targets)
 * only FORMATS them into the message string; it does not compute them. The
 * treasury credit at file 0x061C4C adds [bp-0x10] to PowerRecord+0x2A (= gold,
 * power.h / DATA_MODEL.md "+0x2A=gold", empirically UI-verified). See the
 * per-block @asm citations for each roll.
 *
 * Helpers (RTLink thunks; 0x181F == 0x191F alias into file 0x1A5F0..0x1D5E6;
 * targets from code/VICEROY/thunks_resolved.json + typeA_thunk_targets.json):
 *   0x181F:0x04D4 -> file 0x00C322  random_int(lo,hi)  INCLUSIVE  [BYTE_VERIFIED]
 *   0x181F:0x04CA -> file 0x00C31C  rng/anim seed helper (arg [0x83A6])
 *   0x181F:0x07B4 -> file 0x00BC10  power_attribute_bit(power, bit)  [BYTE_VERIFIED]
 *   0x181F:0x078C -> file 0x00627A  terrain_type_at(x,y) -> raw terrain byte
 *   0x181F:0x095C -> file 0x006D24  spawn_unit(type, owner, x, y) -> idx / -1
 *   0x181F:0x089E -> file 0x0069EE  unit_destroy(unit_idx)
 *   0x181F:0x0182 -> file 0x0029DE  strcat_itoa(dst, n) — appends itoa(n)
 *   0xD1D:0x07E4  -> (resident)     strcpy(dst, key) — copies base key
 *   0x181F:0x0A38 -> file 0x007F34  tribe-attr fetch (test al,0x20 = gift gate)
 *   0x181F:0x09A4 -> file 0x008110  tribe-index lookup
 *   0x181F:0x0808 -> file 0x006E94  helper on unit owner (FoY/survivors path)
 *   0x181F:0x09AE -> page 0x17 file 0x06C27C  format-int32 into message NUMBER arg
 *   0x181F:0x09BA -> page 0x15 file 0x066854  center map view at (x,y)
 *   0x181F:0x0D6C -> page 0x0B file 0x045DF2  adjust native attitude (smite)
 *   0x181F:0x0D84 -> page 0x0B file 0x046056  treasure-unit spawn at (x,y)
 *   0x181F:0x0438 -> page 0x17 file 0x06C23C  unit-redraw / refresh helper
 *   0x181F:0x0652 -> page 0x17 file 0x06F5F2  message-line append helper
 *   0x181F:0x0998 -> page 0x17 file 0x06F51A  message-box present helper
 *   0x181F:0x048E/0x498/0x4AC/0x524/0x3EA -> resident sound/anim cues
 *   0x191F:0x0AC8 -> page 0x17 file 0x06C254  survivors_join(nation,a,b)     [BYTE_VERIFIED]
 *     segid=23:0x0404, base=0x6BE50.  40-byte function.  Builds a string via
 *     0x181F:0x42E(buf,a,b) (resident @0x008074) and copies it into DGROUP:0x9CD2
 *     + nation*64 (per-nation survivor-pending slot).  Does NOT spawn the colonist
 *     unit — that happens in case LCR_SURVIVORS (spawn_unit type 0 at tile).
 *     ABI: void survivors_join(int nation, int a, int b); a=b=0 at call site.
 *   0x191F:0x0D2C -> page 0x04 file 0x034DD4  queue_immigrant(a,b)          [BYTE_VERIFIED]
 *     segid=4:0x4884, base=0x30550.  715-byte function.  Selects recruitment
 *     key and pool context based on args: a=1 -> key=LOSTCITY0 + [0x1F5E]=3
 *     (Fountain-of-Youth passage); a=0,b=0 -> key=RECRUIT + [0x1F5E]=2 (free);
 *     a=0,b!=0 -> key=RECRUITCHOOSE + [0x1F5E]=4 (purchase).  Computes
 *     passage-cost into [0x9CB0]:[0x9CB2] (zeroed when a!=0 or b!=0).  Calls
 *     0x191F:0x182 (file 0x06F0F4, 360-byte add-to-pool routine) with register
 *     args AX=key_dg_off, BX=DGROUP:0x87C (recruit table), DX=0.  Returns
 *     DX:AX = far ptr to new colonist record (NULL = pool full); sets
 *     rec[+0xA] |= 1 (free-flag) and rec[+0x22] = 8 (colonist class) on free path.
 *     ABI: colonist_record_far_ptr queue_immigrant(int a, int b);
 *          called as queue_immigrant(1, 0) from FoY loop (8 times).
 *   0x1A1F:0x06EC -> page 0x10 file 0x05C878  notify_treasure_spawn(owner)  [BYTE_VERIFIED]
 *     segid=16:0x1906, base=0x5AF70 (thunk lands at 0x5C876 = CB 90 prefix;
 *     real ENTER at 0x5C878).  518-byte function.  Already documented in the
 *     func_05C878 block below as "Treasure delivery to Europe".
 *     arg1 = owner_idx = U_OWNER(nu) & 0xF (nation 0-3 of the treasure unit).
 *     gross_val = 100 * U_SEC(owner_idx)  (@asm 0x5C882: mov al,0x64; mul [bx+0x315B]).
 *     Uses strings CASHTREASURE/KINGGALLEON/LOOTCASH.  Called only from within
 *     lcr_resolve (@asm 0x0616D5 Cibola, 0x061AD1 Burial3) — no other callers.
 *
 * Hot DGROUP globals (offsets relative to confirmed bases):
 *   [0x5394]  current_nation_index (0..3; "limit 4" — globals.h)  [BYTE_VERIFIED]
 *   [0x5396]  active/human player index                            [BYTE_VERIFIED]
 *   [0x5382]  game-flags byte; bit 1 forces outcome 2 (Cibola). Debug toggle. [TBD meaning]
 *   [0x83A6]  rumour-animation seed (cosmetic; passed to 0x181F:0x4CA)
 *   [0x1DC6]  per-session LCR attempt counter      (INC @asm file 0x0614E6)
 *   [0x1DC7]  per-session LCR "good outcome" counter(INC @asm file 0x0616C9)
 *   [0x00A2]  pending-event/queue flag tested before the sound cue
 *   [0x8D50]/[0x8D52] tribe-context words for the gift/attitude path
 *   [0x8DB8]  base count word used in the burial-empty re-roll size
 *   [0x8D4A]  far-ptr-ish word into a tribe/unit record (+2 byte read)
 *   AIPersonality (stride 0x34): [bx+0x543F] presence/controller byte (gates
 *             the "notify human" flag @asm file 0x06148B); [bx+0x543E] flags,
 *             bit 0x40 = "Fountain of Youth already granted this nation"
 *             one-shot guard (test+set @asm file 0x061870/0x061877).
 *   Per-nation byte tables addressed as [bx-0x6Bxx] with bx=nation (NOT *0x34):
 *             [bx-0x6BF0] and [bx-0x6D68] gate the FoY/Cibola demotion at
 *             file 0x06182E/0x061835/0x061850 (semantics TBD; era/disposition).
 *   UnitRecord (stride 0x1C, base 0x3144 — HARD BASE GUARD):
 *     [bx+0x3144]/[+0x3145] unit x / y     [bx+0x3146] unit TYPE (==5 -> Scout)
 *     [bx+0x3147] unit OWNER (&0xF)         [bx+0x315B] secondary byte
 *                 (==0x16 on a Scout -> Seasoned Scout; also the treasure-unit
 *                  VALUE byte when a treasure unit is spawned here)
 *   PowerRecord (stride 0x13C, base 0x8808 — HARD BASE GUARD):
 *     [bx+0x2A] u32 gold/treasury (LCR gold credited here @asm file 0x061C4C,
 *               via imul bx,[0x5394],0x13C; add [bx-0x77CE]; -0x77CE == 0x8832
 *               == 0x8808+0x2A).  power.h / DATA_MODEL.md: +0x2A = gold.
 *
 * Caller ABI (far cdecl, args pushed right-to-left):
 *   [bp+6]  = unit_idx   (the investigating unit; UnitRecord index; also reused
 *                         as the spawned treasure/survivor unit idx mid-body)
 *   [bp+8]  = tile_x
 *   [bp+0xA]= tile_y
 *   returns AX = final outcome number (1..9).
 *
 * STILL TBD (narrow, honestly bounded):
 *   - [0x5382] bit-1 semantics (forces Cibola); presumed a debug/cheat toggle.
 *   - The De-Soto "no_bad_luck" attribute is PowerRecord bit 7 (power_attribute_
 *     bit(nation,7)); the value 7 is byte-exact but the in-EXE name of bit 7
 *     is inferred from gameplay (De Soto). Tagged ANCHOR for the *name* only.
 *   - The [bx-0x6BF0]/[bx-0x6D68] per-nation gate bytes (era/disposition) —
 *     accessed byte-exactly, semantics TBD.
 *   - 0x191F:0xAC8 / 0x191F:0xD2C / 0x1A1F:0x6EC bodies fully resolved above
 *     (BYTE_VERIFIED 2026-06-08).  No remaining TBDs on these three helpers.
 * ============================================================================ */
#include "viceroy_types.h"

/* ---- helpers (see header block for @asm citations) ----------------------- */
extern int      random_int(int lo, int hi);                 /* file 0x00C322, INCLUSIVE */
extern uint16_t power_attribute_bit(uint16_t power, int16_t bit);  /* file 0x00BC10 */
extern uint8_t  terrain_type_at(int x, int y);              /* file 0x00627A */
extern int      spawn_unit(int type, int owner, int x, int y);     /* file 0x006D24 */
extern void     unit_destroy(int unit_idx);                 /* file 0x0069EE */
extern int      treasure_spawn_at(int x, int y);            /* 0x181F:0xD84 file 0x046056 */
extern void     native_attitude_smite(int a, int b, int owner, int tribe); /* 0x181F:0xD6C file 0x045DF2 */
extern void     msg_append_key(int n, const char far *key); /* 0x181F:0x652 file 0x06F5F2 */
extern void     msg_present(const char far *buf);           /* 0x181F:0x998 file 0x06F51A */
/* queue_immigrant: 0x191F:0xD2C -> file 0x034DD4 (segid=4:0x4884, BYTE_VERIFIED)
 * a=1 -> Fountain-of-Youth free immigrant (LOSTCITY0 key, [0x1F5E]=3)
 * returns far ptr to new colonist record; but return value unused at this call site. */
extern void     queue_immigrant(int a, int b);              /* 0x191F:0xD2C file 0x034DD4 [BYTE_VERIFIED] */
/* survivors_join: 0x191F:0xAC8 -> file 0x06C254 (segid=23:0x0404, BYTE_VERIFIED)
 * Writes survivor-pending string to DGROUP:0x9CD2+nation*64 slot. */
extern void     survivors_join(int nation, int a, int b);   /* 0x191F:0xAC8 file 0x06C254 [BYTE_VERIFIED] */
/* notify_treasure_spawn: 0x1A1F:0x6EC -> file 0x05C878 (segid=16:0x1906+2, BYTE_VERIFIED)
 * arg = owner_idx = U_OWNER(nu) & 0xF; gross = 100 * U_SEC(owner_idx). */
extern void     notify_treasure_spawn(int owner_idx);       /* 0x1A1F:0x6EC file 0x05C878 [BYTE_VERIFIED] */

/* DGROUP globals (byte-verified bases). */
extern int16_t  g_current_nation;     /* DGROUP:0x5394 (0..3) */
extern int16_t  g_active_player;      /* DGROUP:0x5396 */
extern uint8_t  g_flags_5382;         /* DGROUP:0x5382 */
extern uint8_t  g_lcr_attempts;       /* DGROUP:0x1DC6 */
extern uint8_t  g_lcr_good_results;   /* DGROUP:0x1DC7 */
extern uint8_t  g_ai_personality[];   /* AIPersonality stride 0x34, +0x543E flags / +0x543F presence */
extern uint8_t  g_per_nation_6BF0[];  /* DGROUP table addressed [nation-0x6BF0] */
extern uint8_t  g_per_nation_6D68[];  /* DGROUP table addressed [nation-0x6D68] */
extern uint8_t  g_unit_records[];     /* DGROUP:0x3144, stride 0x1C */
extern uint8_t  g_power_records[];    /* DGROUP:0x8808, stride 0x13C */
extern uint16_t g_burial_size_8DB8;   /* DGROUP:0x8DB8 — base size word in burial re-roll (semantics TBD) */
extern uint8_t far *g_tribe_ctx_8D4A; /* DGROUP:0x8D4A — far/near ptr to a tribe/unit record; +2 byte read */

/* UnitRecord field accessors (base 0x3144 -> field = addr-0x3144). */
#define U_X(i)     g_unit_records[(i)*0x1C + 0x00]   /* 0x3144 */
#define U_Y(i)     g_unit_records[(i)*0x1C + 0x01]   /* 0x3145 */
#define U_TYPE(i)  g_unit_records[(i)*0x1C + 0x02]   /* 0x3146 */
#define U_OWNER(i) (g_unit_records[(i)*0x1C + 0x03] & 0x0F) /* 0x3147 & 0xF */
#define U_SEC(i)   g_unit_records[(i)*0x1C + 0x17]   /* 0x315B (Seasoned-Scout / treasure value) */

/* Outcome numbers — these ARE the @LOSTCITY<n> GAME.TXT key suffixes. */
enum LcrOutcome {
    LCR_FOUNTAIN_OF_YOUTH = 1,  /* @LOSTCITY1 */
    LCR_CIBOLA            = 2,  /* @LOSTCITY2 — treasure unit (needs galleon) */
    LCR_RUINS_GOLD        = 3,  /* @LOSTCITY3 — immediate gold */
    LCR_BURIAL_MOUNDS     = 4,  /* @LOSTCITY4 — sub-dispatch (BURIAL1/2/3 / SCREWED) */
    LCR_VANISHED          = 5,  /* @LOSTCITY5 — unit destroyed */
    LCR_NOTHING           = 6,  /* @LOSTCITY6 — fizzle */
    LCR_TRIBE_GIFT        = 7,  /* @LOSTCITY7 — small gold from friendly chief */
    LCR_TRESPASS_SHRINE   = 8,  /* @LOSTCITY8 — tribe displeased */
    LCR_SURVIVORS         = 9   /* @LOSTCITY9 — colonists join you */
};

/* ============================================================================
 * lcr_resolve — the byte-faithful roll engine (func_061454).
 *
 * Control flow mirrors the disassembly 1:1; every step cites its @asm file
 * offset (and IP where helpful).  All rolls and magnitudes below are
 * byte-exact.  Where a helper body is overlay-resident the CALL is cited but
 * its effect is noted [TBD].
 * ============================================================================ */
int lcr_resolve(int unit_idx, int tile_x, int tile_y)
{
    int outcome;             /* [bp-6]    the 1..9 outcome number */
    int floor_min = 0;       /* [bp-0x2c] rising anti-streak floor (zeroed at entry) */
    int scout_bonus = 0;     /* [bp-0x34] Scout(=1)/Seasoned(=2)/+DeSoto(=3) bonus */
    int no_bad_luck = 0;     /* [bp-0x2e] 1 if De-Soto+scout suppresses bad outcomes */
    int magnitude;           /* [bp-0xa]  1..100(+) gates the FoY/Cibola/burial tiers */
    int terrain;             /* [bp-0xe]  raw terrain byte at the tile */
    int gold_amount = 0;     /* [bp-0x10] message NUMBER0 = immediate gold (credited) */
    int treasure_val = 0;    /* [bp-0x32] message NUMBER1 = treasure-unit value (/100 displayed) */
    int notify;              /* [bp-8]    1 -> render/announce (human's turn) */
    int burial_sub = 0;      /* [bp-0x38] BURIAL sub-outcome 1/2/3 */
    int smite_tribe = -1;    /* [bp-0x30] tribe idx to smite, or -1 */
    int did_action = 0;      /* [bp-2] / [bp-0xc] post-dispatch flags (refresh/center) */

    /* --- entry init  @asm file 0x06145A..0x061476 ------------------------- */
    /* [bp-0x3a]=1; many locals zeroed. */

    /* --- "notify the human?" gate  @asm file 0x061476..0x06149A -----------
     *   notify = (g_active_player == g_current_nation) AND
     *            (g_current_nation < 4) AND
     *            (AIPersonality[nation].presence_543F == 0);
     * i.e. only announce/render when it is the human player's own nation. */
    if (g_active_player == g_current_nation                /* @asm 0x061476/0x061479 */
        && g_current_nation < 4                            /* @asm 0x06147F */
        && g_ai_personality[g_current_nation * 0x34 + 0x31] == 0) /* @asm 0x06148B [bx+0x543F] */
        notify = 1;                                        /* @asm 0x061492 */
    else
        notify = 0;                                        /* @asm 0x06149A */

    /* --- Scout detection  @asm file 0x06149F..0x0614C4 --------------------
     *   scout_bonus = (U_TYPE(unit)==5) ? 1 : 0;            ; Scout family
     *   if (scout_bonus && U_SEC(unit)==0x16) scout_bonus++; ; Seasoned Scout */
    scout_bonus = (U_TYPE(unit_idx) == 5) ? 1 : 0;         /* @asm 0x0614A6 cmp [bx+0x3146],5 */
    if (scout_bonus && U_SEC(unit_idx) == 0x16)            /* @asm 0x0614BB cmp [bx+0x315b],0x16 */
        scout_bonus++;                                     /* @asm 0x0614C2 */

    /* --- De-Soto-class "no bad luck" gate  @asm file 0x0614C6..0x0614E3 ---
     *   if (power_attribute_bit(nation, 7) && scout_bonus) {
     *       no_bad_luck = 1;  scout_bonus++;
     *   }  (bit 7 of the PowerRecord attribute bitfield.) */
    if (power_attribute_bit(g_current_nation, 7) && scout_bonus) { /* @asm 0x0614C6 (push 7) */
        no_bad_luck = 1;                                   /* @asm 0x0614DE */
        scout_bonus++;                                     /* @asm 0x0614E3 */
    }

    g_lcr_attempts++;                                      /* @asm 0x0614E6 inc byte [0x1DC6] */
    /* rumour-discovered cue (cosmetic): 0x181F:0x4CA(arg [0x83A6])  @asm 0x0614EA */

reroll:                                                    /* @asm file 0x0614F6 / IP 0x1A26 */
    /* --- 1. base outcome = random_int(1,9)  @asm file 0x0614F6 ------------ */
    outcome = random_int(1, 9);                            /* push 9 / push 1 / 0x181F:0x4D4 */

    /* --- 2. rising-floor anti-streak  @asm file 0x061505..0x06151A -------- */
    floor_min++;                                           /* @asm 0x061508 */
    if (floor_min > 3) floor_min = 3;                      /* @asm 0x06150C */
    if (outcome < floor_min) outcome = floor_min;          /* @asm 0x061514 */

    /* --- 3. magnitude roll = random_int(1,100) + scout_bonus*10  @asm 0x06151D
     *   magnitude = random_int(1,100) + (scout_bonus*5)*2; */
    magnitude = random_int(1, 100) + (scout_bonus * 5) * 2; /* @asm 0x06151D..0x061537 */

    /* --- 4. terrain at the tile  @asm file 0x06153A (0x181F:0x78C) -------- */
    terrain = terrain_type_at(tile_x, tile_y);             /* @asm 0x061540 */

    /* === Outcome-mutation cascade (every branch byte-exact) =============== */

    /* 4a. Outcome 5 (vanished): 1-in-(scout+1) chance to demote.  @asm 0x06154B
     *     if (random_int(1, scout_bonus+1) - 1 == 0) {
     *         if (no_bad_luck) goto reroll;
     *         else outcome = 6;
     *     } else keep 5. */
    if (outcome == LCR_VANISHED) {                         /* @asm 0x06154B */
        if (random_int(1, scout_bonus + 1) - 1 == 0) {     /* @asm 0x061551 */
            if (no_bad_luck) goto reroll;                  /* @asm 0x061563 -> 0x1A26 */
            outcome = LCR_NOTHING;                         /* @asm 0x061569 */
        }
    }

    /* 4b. Outcome 8 (trespass shrine): same anti-bad-luck treatment. @asm 0x06156E */
    if (outcome == LCR_TRESPASS_SHRINE) {                  /* @asm 0x06156E */
        if (random_int(1, scout_bonus + 1) - 1 == 0) {     /* @asm 0x061574 */
            if (no_bad_luck) goto reroll;                  /* @asm 0x06158C -> 0x1A26 */
            outcome = LCR_NOTHING;                         /* @asm 0x06158F */
        }
    }

    /* 4c. Outcome 1 (Fountain of Youth): terrain + session gated. @asm 0x061594
     *     terr_ok = (terrain < 0x18) && ((terrain & 7) >= 4);
     *     if (terr_ok && !(attempts>=4) && !no_bad_luck)        ; band path
     *         outcome = (magnitude <= 10) ? 5 : 6;              ; demote
     *     if (g_flags_5382 & 1) outcome = 2;                    ; debug -> Cibola
     * NOTE: the (attempts>=4)/(no_bad_luck) test here DEMOTES the FoY result on
     * the band path; the real FoY ACCEPT happens later at file 0x061841 via the
     * AIPersonality one-shot bit. */
    if (outcome == LCR_FOUNTAIN_OF_YOUTH) {                /* @asm 0x061594 */
        int terr_ok;
        if (terrain >= 0x18)                               /* @asm 0x06159A */
            terr_ok = 0;                                   /* @asm 0x0615B0 */
        else
            terr_ok = ((terrain & 7) >= 4);                /* @asm 0x0615A0..0x0615A9 */

        if (terr_ok && !(g_lcr_attempts >= 4)             /* @asm 0x0615B5/0x0615BB */
            && !no_bad_luck) {                             /* @asm 0x0615C2 */
            if (magnitude <= 10)                           /* @asm 0x0615C8 */
                outcome = LCR_VANISHED;                    /* @asm 0x0615CE */
            else
                outcome = LCR_NOTHING;                     /* @asm 0x0615D6 */
        }
        if (g_flags_5382 & 1)                              /* @asm 0x0615DB test [0x5382],1 */
            outcome = LCR_CIBOLA;                          /* @asm 0x0615E2 */
    }

    /* 4d. Outcome 2 (Cibola): terrain gate + treasure-value roll + spawn.
     *     @asm file 0x0615E7..0x0616DA
     *     terr_ok = (terrain==0x1B || terrain==0x1C)            ; mountains/hills
     *               || (terrain < 0x18 && (terrain & 7)==1);
     *     if (!terr_ok && no_bad_luck && random_int(0,2)==0) terr_ok=1; ; DeSoto rescue
     *     if (terr_ok && !(attempts>=1 && good>=7)) {
     *         if      (magnitude <= 10) outcome = 5;            ; demote vanished
     *         else if (magnitude >= 0x19) outcome = 6;          ; demote nothing
     *         else    outcome = 8;                              ; demote trespass
     *         ... BUT if it survives, build the treasure unit + value [bp-0x32]
     *             and spawn it on the tile, bumping good_results.
     *     } */
    if (outcome == LCR_CIBOLA) {                           /* @asm 0x0615E7 */
        int terr_ok;
        if (terrain == 0x1B || terrain == 0x1C)            /* @asm 0x0615F0/0x0615F6 */
            terr_ok = 1;
        else if (terrain >= 0x18)                          /* @asm 0x0615FC */
            terr_ok = 0;
        else
            terr_ok = ((terrain & 7) == 1);                /* @asm 0x061602..0x06160B */

        if (!terr_ok && no_bad_luck) {                     /* @asm 0x061617 */
            if (random_int(0, 2) == 0)                     /* @asm 0x06161D (push 2/push 0) */
                terr_ok = 1;                               /* @asm 0x06162D */
        }
        if (terr_ok && !(g_lcr_attempts >= 1 && g_lcr_good_results >= 7)) { /* @asm 0x061632..0x061644 */
            if (magnitude <= 10)                           /* @asm 0x061646 */
                outcome = LCR_VANISHED;                    /* @asm 0x06164C */
            else if (magnitude >= 0x19)                    /* @asm 0x061654 */
                outcome = LCR_NOTHING;                     /* @asm 0x061662 */
            else
                outcome = LCR_TRESPASS_SHRINE;             /* @asm 0x06165A */
            /* --- Cibola treasure value + spawn  @asm 0x06166A..0x0616DA ----
             * treasure_val = (scout_bonus+2)*5*2 + random_int(1,0x14);
             * spawn treasure unit (type 0xA) at unit's (x,y) for its owner;
             * store treasure_val into the new unit's secondary byte; good++; */
            treasure_val = ((scout_bonus + 2) * 5) * 2     /* @asm 0x061676..0x061682 */
                         + random_int(1, 0x14);            /* @asm 0x06166A */
            {
                int nu = spawn_unit(0xA, U_OWNER(unit_idx),/* @asm 0x06169D push 0xA / 0x181F:0x95C */
                                    U_X(unit_idx), U_Y(unit_idx));
                if (nu < 0) goto tail;              /* @asm 0x0616B0 jge / else jmp 0x218A */
                unit_idx = nu;                             /* @asm 0x0616AB mov [bp+6],ax */
                U_SEC(unit_idx) = (uint8_t)treasure_val;   /* @asm 0x0616BC [bx+0x315b] */
                did_action = 1;                            /* @asm 0x0616C0 [bp-2]=[bp-0xc]=1 */
                g_lcr_good_results++;                      /* @asm 0x0616C9 inc [0x1DC7] */
                notify_treasure_spawn(U_OWNER(unit_idx)); /* @asm 0x0616D5 0x1A1F:0x6EC file 0x05C878 */
            }
        }
    }

    /* 4e. Outcome 8 displaced-to-nothing-if-De-Soto?  @asm file 0x0616DD ---
     *     if (outcome==8 && no_bad_luck) goto reroll;  (a final 8->reroll for
     *     the De Soto path; otherwise fall through to the shared tail). */
    if (outcome == LCR_TRESPASS_SHRINE && no_bad_luck)     /* @asm 0x0616DD/0x0616E6 */
        goto reroll;                                       /* @asm 0x0616EC -> 0x1A26 */

    /* --- Outcome 8 acceptance: spawn a treasure (-1 type) then SCREWED smite
     *     setup  @asm file 0x0616EF..0x06176B ------------------------------
     * (When trespass survives: a special treasure_spawn_at(-1,-1,x,y) returns a
     *  tribe/own marker [bp-0x12]; if <=2 the tribe's attitude byte feeds the
     *  smite target [bp-0x30]; the gift-gate test al,0x20 on the tribe attr can
     *  flip outcome back to 6.)  Magnitudes here stay 0 (no gold). */
    if (outcome == LCR_TRESPASS_SHRINE) {                  /* @asm 0x0616DD path continues */
        int marker = treasure_spawn_at(tile_x, tile_y);    /* @asm 0x0616F3..0x061708 0x181F:0xD84(-1,-1,x,y) */
        if (marker <= 2) {                                 /* @asm 0x06170E cmp ax,2 / jg 0x1C9B */
            /* derive smite tribe + difficulty-scaled magnitude [bp-0x36];
             * fetch tribe attr (0x181F:0xA38); test al,0x20 -> if NOT set,
             * smite_tribe stays -1 and outcome demotes to 6. */
            smite_tribe = marker;                          /* @asm 0x061716 [bp-0x30] (provisional) */
            /* tribe-attr gate  @asm 0x06175A..0x061766 */
            /* (gift bit clear -> outcome=6 @asm 0x06176B) */
            outcome = LCR_NOTHING;                         /* @asm 0x06176B (taken when gate fails) */
        }
    }

    /* --- 3. Outcome 3 (ruins): immediate gold  @asm file 0x061770..0x0617BD
     *   sum3 = 3 * random_int(1,8) (summed);
     *   gold_amount = sum3 * 5 * 2;                            ( = sum3 * 10 )
     *   if (scout_bonus) gold_amount = gold_amount*(scout_bonus+2)/2; */
    if (outcome == LCR_RUINS_GOLD) {                       /* @asm 0x061770 */
        int s = random_int(1, 8);                          /* @asm 0x061776 */
        s += random_int(1, 8);                             /* @asm 0x061784..0x06179E */
        s += random_int(1, 8);
        gold_amount = (s * 5) * 2;                         /* @asm 0x0617A2..0x0617AB ( *10 ) */
        if (scout_bonus) {                                 /* @asm 0x0617AE */
            gold_amount = (gold_amount * (scout_bonus + 2)) >> 1; /* @asm 0x0617B4..0x0617BD imul/sar */
        }
    }

    /* --- 7. Outcome 7 (tribe gift): smaller gold  @asm file 0x0617C0..0x061806
     *   sum4 = 4 * random_int(1,10) (summed);
     *   gold_amount = sum4 * 2; */
    if (outcome == LCR_TRIBE_GIFT) {                       /* @asm 0x0617C0 */
        int s = random_int(1, 10);                         /* @asm 0x0617C6 */
        s += random_int(1, 10);                            /* @asm 0x0617D2..0x0617E0 */
        s += random_int(1, 10) + random_int(1, 10);        /* @asm 0x0617E0..0x0617FD */
        gold_amount = s * 2;                               /* @asm 0x061802..0x061806 ( *2 ) */
    }

    /* --- 9. Outcome 9 (survivors): clear a flag + queue the join  @asm 0x061809
     *   [0x9CD2]=0; survivors_join(nation, 0, 0) via 0x191F:0xAC8.  The actual
     *   colonists are placed by the switch case at file 0x061BFC (spawn type 0). */
    if (outcome == LCR_SURVIVORS) {                        /* @asm 0x061809 */
        /* [0x9CD2] = 0  @asm 0x06180F */
        survivors_join(g_current_nation, 0, 0);            /* @asm 0x06181C 0x191F:0xAC8 */
    }

    /* --- Outcome 5 era gate + FoY accept  @asm file 0x061824..0x06187C ----
     *   if (outcome==5 && per_nation_6BF0[nation]<=4 && per_nation_6D68[nation]<=2)
     *       outcome = 6;                                       ; early-game safety
     *   if (U_TYPE(unit)==2 && per_nation_6BF0[nation]<=8 && random_int(1,2)==1)
     *       outcome = 6;                                       ; Seasoned-Scout safety
     *   if (!(AIPersonality[nation].flags_543E & 0x40)) {       ; FoY one-shot
     *       AIPersonality[nation].flags_543E |= 0x40;
     *       outcome = 4;     <-- NB: sets BURIAL here (see note)
     *   } */
    if (outcome == LCR_VANISHED) {                         /* @asm 0x061824 */
        if (g_per_nation_6BF0[g_current_nation] <= 4       /* @asm 0x06182E [bx-0x6bf0] */
            && g_per_nation_6D68[g_current_nation] <= 2)   /* @asm 0x061835 [bx-0x6d68] */
            outcome = LCR_NOTHING;                         /* @asm 0x06183C */
    }
    if (U_TYPE(unit_idx) == 2                              /* @asm 0x061845 cmp [bx+0x3146],2 */
        && g_per_nation_6BF0[g_current_nation] <= 8        /* @asm 0x061850 */
        && random_int(1, 2) == 1) {                        /* @asm 0x061857..0x061863 */
        outcome = LCR_NOTHING;                             /* @asm 0x061866 */
    }
    {
        uint8_t *ffl = &g_ai_personality[g_current_nation * 0x34 + 0x30]; /* @asm 0x06186B [bx+0x543E] */
        if (!(*ffl & 0x40)) {                              /* @asm 0x061870 test ...,0x40 */
            *ffl |= 0x40;                                  /* @asm 0x061877 or ...,0x40 */
            outcome = LCR_BURIAL_MOUNDS;                   /* @asm 0x06187C mov [bp-6],4 */
        }
    }

    /* --- De-Soto demotion of a surviving 5, and 6-with-DeSoto reroll  @asm 0x061881
     *   if (outcome==5 && no_bad_luck) outcome=6;
     *   if (outcome==6 && no_bad_luck) goto reroll; */
    if (outcome == LCR_VANISHED && no_bad_luck)            /* @asm 0x061881/0x061887 */
        outcome = LCR_NOTHING;                             /* @asm 0x06188D */
    if (outcome == LCR_NOTHING && no_bad_luck)             /* @asm 0x061892/0x061898 */
        goto reroll;                                       /* @asm 0x06189E -> 0x1A26 */

    /* === Message build + present (only when `notify`) ===================== */
    /* @asm file 0x0618A1..0x06195B :
     *   format-int32([bp-0x10] gold)               (0x181F:0x9AE, arg slot 0)
     *   format-int32([bp-0x32]*100 treasure worth) (0x181F:0x9AE, arg slot 1)
     *   strcpy(buf, "LOSTCITY"); strcat_itoa(buf, outcome);   build @LOSTCITY<n>
     *   if (notify) { play per-outcome sound/anim; center map; present buf } */
    /* (NUMBER0 = gold_amount; NUMBER1 = treasure_val*100 — both byte-exact above) */

    /* === BURIAL MOUNDS sub-dispatch (outcome 4)  @asm file 0x061980..0x061B89 ==
     * Reached only when outcome==4 AND [bp-0x3a]==1 (the FoY-seat flag set at
     * entry). Rolls a treasure marker, then bands on `magnitude`:
     *
     *   marker = treasure_spawn_at(x,y) (0x181F:0xD84, -1,-1,x,y)  @asm 0x0619A0
     *   if (marker >= 0) {                                          ; tile had a mound
     *       roll = random_int(1, (0x8DB8 + 5) << scout_bonus);     @asm 0x0619B2
     *       if (roll <= 3) marker = *(0x8D4A).byte[2] - 4;          @asm 0x0619CA
     *       smite tribe attr gate (0x181F:0xA38, test al,0x20)      @asm 0x0619E1
     *           -> if gift bit clear, smite_tribe = -1.
     *   }
     *   if      (magnitude <  0x19)          burial_sub = 1, gold = 0;        @asm 0x0619F2
     *   else if (magnitude <  0x32           burial_sub = 2 + small gold;     @asm 0x061A06/0x061A18
     *            || (smite_tribe>=0 && magnitude<0x41))
     *   else                                  burial_sub = 3 + treasure unit; @asm 0x061A58
     *
     *   BURIAL2 (sub=2) small gold  @asm 0x061A1D..0x061A52 :
     *       sum3 = 3 * random_int(1,8) (summed);  gold_amount = sum3 * 5 * 2; ( *10 )
     *   BURIAL3 (sub=3) treasure  @asm 0x061A58..0x061AE2 :
     *       treasure_val = ((scout_bonus+5)*2 + random_int(1,8)) * 2;
     *       spawn treasure unit (type 0xA) at (x,y); store value in its sec byte;
     *       did_action = 1.
     *
     *   Then build "BURIAL"+burial_sub key (@asm 0x061B03 strcpy + 0x061B1A itoa);
     *   if (notify) present it; and if (smite_tribe>=0):
     *       if (notify) append "SCREWED" key (@asm 0x061B6E) and
     *       native_attitude_smite(0,0x64,nation,smite_tribe) (@asm 0x061B84 0x181F:0xD6C). */
    if (outcome == LCR_BURIAL_MOUNDS) {                    /* @asm 0x061980 */
        int marker = treasure_spawn_at(tile_x, tile_y);    /* @asm 0x0619A0 0x181F:0xD84(-1,-1,x,y) */
        if (marker >= 0) {                                 /* @asm 0x0619AD */
            /* size = ([0x8DB8] + 5) << scout_bonus  @asm 0x0619B2..0x0619B8 */
            int roll = random_int(1, (g_burial_size_8DB8 + 5) << scout_bonus); /* @asm 0x0619BA */
            if (roll <= 3)                                 /* @asm 0x0619C5 */
                smite_tribe = (int)g_tribe_ctx_8D4A[2] - 4;/* @asm 0x0619CA..0x0619D6 [bp-0x30] */
            /* tribe-attr gift gate  @asm 0x0619E1..0x0619EB : if (attr & 0x20)==0 -> keep,
             * else smite_tribe = -1.  (test al,0x20 / jne)  @asm 0x0619E9 */
        }

        if (magnitude < 0x19) {                            /* @asm 0x0619F2 */
            burial_sub = 1;                                /* @asm 0x0619F8 */
            gold_amount = 0;                               /* @asm 0x0619FD */
        } else if (magnitude < 0x32                        /* @asm 0x061A06 */
                   || (smite_tribe >= 0 && magnitude < 0x41)) { /* @asm 0x061A0C/0x061A12 */
            burial_sub = 2;                                /* @asm 0x061A18 */
            {                                              /* small gold: sum3*10  @asm 0x061A1D.. */
                int s = random_int(1, 8);                  /* @asm 0x061A1D */
                s += random_int(1, 8);                     /* @asm 0x061A29..0x061A45 */
                s += random_int(1, 8);
                gold_amount = (s * 5) * 2;                 /* @asm 0x061A49..0x061A52 ( *10 ) */
            }
        } else {
            burial_sub = 3;                                /* @asm 0x061A58 */
            treasure_val = (((scout_bonus + 5) * 2)        /* @asm 0x061A69..0x061A6F */
                            + random_int(1, 8)) * 2;       /* @asm 0x061A5D / 0x061A73 ( *2 ) */
            {
                int nu = spawn_unit(0xA, U_OWNER(unit_idx),/* @asm 0x061A8C 0x181F:0x95C */
                                    U_X(unit_idx), U_Y(unit_idx));
                if (nu < 0) goto tail;              /* @asm 0x061A9F jge / else jmp 0x218A */
                unit_idx = nu;                             /* @asm 0x061A9A */
                U_SEC(unit_idx) = (uint8_t)treasure_val;   /* @asm 0x061AAB [bx+0x315b] */
                did_action = 1;                            /* @asm 0x061AD9 */
                notify_treasure_spawn(U_OWNER(unit_idx)); /* @asm 0x061AD1 0x1A1F:0x6EC file 0x05C878 */
            }
        }
        /* build "BURIAL"+burial_sub, present, and SCREWED smite — see header */
        if (smite_tribe >= 0) {                            /* @asm 0x061B36 */
            /* native_attitude_smite(0, 0x64, nation, smite_tribe)  @asm 0x061B84 0x181F:0xD6C */
            native_attitude_smite(0, 0x64, g_current_nation, smite_tribe);
        }
        (void)burial_sub;
    }

    /* === Final switch on `outcome`  @asm file 0x061C2C / IP 0x215C ========
     *   ax = outcome;
     *   switch (ax) {
     *     case 9: -> file 0x061BFC : spawn colonist unit (type 0) at (x,y),
     *                                set did_action; [bp-0xc]=1.  (survivors)
     *     case 1: -> file 0x061B92 : loop 8x queue_immigrant(1,0) (0x191F:0xD2C),
     *                                then helper 0x181F:0x582(owner).  (Fountain)
     *     case 5: -> file 0x061BC8 / 0x061C1F : if notify play vanish cue;
     *                                unit_destroy(unit_idx) (0x181F:0x89E).
     *     default: fall through.
     *   } */
    switch (outcome) {                                     /* @asm 0x061C2C cmp ax,9 ... dec al ladder */
    case LCR_SURVIVORS: {                                  /* @asm 0x061C2F je 0x212C -> file 0x061BFC */
        int nu = spawn_unit(0, U_OWNER(unit_idx),          /* @asm 0x061C0E 0x181F:0x95C type 0 */
                            tile_x, tile_y);
        if (nu >= 0) did_action = 1;                       /* @asm 0x061C1B/0x061C24 */
        break;
    }
    case LCR_FOUNTAIN_OF_YOUTH: {                          /* @asm 0x061C37 -> file 0x061B92 */
        int i;
        for (i = 0; i < 8; i++)                            /* @asm 0x061BB1 cmp [bp-0x16],8 */
            queue_immigrant(1, 0);                         /* @asm 0x061BBE push 0/push 1 -> 0x191F:0xD2C(1,0) */
        /* 0x181F:0x582(owner) post-FoY helper  @asm 0x061B9E */
        did_action = 1;                                    /* @asm 0x061BF4 [bp-0xc]=1 */
        break;
    }
    case LCR_VANISHED:                                     /* @asm 0x061C40 -> file 0x061BC8/0x061C1F */
        /* if (notify) vanish sound 0x181F:0x498, [0x00A2] gate, 0x181F:0x4AC */
        unit_destroy(unit_idx);                            /* @asm 0x061C22 0x181F:0x89E */
        break;
    default:
        break;
    }

    /* --- Credit gold to the treasury  @asm file 0x061C42..0x061C56 --------
     * (Reached by fall-through from the switch; the disasm label here is IP
     *  0x2172. Spawn-fail paths `goto tail` to SKIP this, matching `jmp 0x218A`.)
     *   if (gold_amount != 0)
     *       *(u32*)&PowerRecord[nation].gold_2A += gold_amount;
     * (imul bx,[0x5394],0x13C; add [bx-0x77CE],ax; adc [bx-0x77CC],dx;
     *  -0x77CE == 0x8832 == PowerRecord base 0x8808 + 0x2A == gold.) */
    if (gold_amount != 0) {                                /* @asm 0x061C42 */
        *(uint32_t *)&g_power_records[g_current_nation * 0x13C + 0x2A] += gold_amount; /* @asm 0x061C4C */
    }

tail:                                                      /* @asm file 0x061C5A / IP 0x218A */
    /* --- Tail: if (notify && did_action) center the map on (x-3,y-3) and, if
     *     a unit action happened, play the reveal cue.  @asm 0x061C5A..0x061C96
     *     (0x181F:0x9BA center-view; 0x181F:0x3EA reveal cue.)
     *     NB: the spawn-fail `goto tail` (disasm `jmp 0x218A`) deliberately
     *     SKIPS the gold credit; gold_amount is 0 on those paths anyway. */
    (void)notify; (void)did_action;
    return outcome;                                        /* AX = final outcome (1..9) */
}

/* ============================================================================
 * Treasure delivery to Europe (the king's-cut split) — SEPARATE function.
 * ----------------------------------------------------------------------------
 * @asm_function   func_05C878            (overlay, region 0x05C878..0x05CA7E)
 * @asm_disasm     code/VICEROY/disasm/func_05C878_unknown.asm
 * @verified_by    BYTE_VERIFIED 2026-05-02 (full writeup in
 *                 src/native/raze_treasure.c #if 0 block — that file MIS-NAMES
 *                 this as "raze"; it is the treasure-galleon transport event).
 * @thunk_resolved BYTE_VERIFIED 2026-06-08: also reachable as 0x1A1F:0x6EC
 *                 (segid=16:0x1906, base=0x5AF70; thunk at file 0x1CCDC lands on
 *                 the 2-byte CB 90 prefix at 0x5C876; ENTER starts at 0x5C878).
 *                 Called from lcr_resolve Cibola (@asm 0x0616D5) and Burial3
 *                 (@asm 0x061AD1) with arg = owner_idx (U_OWNER(nu) & 0xF).
 *
 * Tagged strings: "CASHTREASURE" / "KINGGALLEON" / "LOOTCASH".
 * gross = 100 * unit_secondary_byte([unit].0x315B)   <-- the treasure_val this
 *          LCR resolver stored above (Cibola/BURIAL3 = value byte; UI shows ×100).
 *          Accessed as U_SEC(owner_idx) = DGROUP[0x315B + owner_idx*0x1C].
 *          @asm 0x5C87E: imul bx,[bp+6],0x1c; @asm 0x5C882: mov al,0x64; mul [bx+0x315B].
 * king_cut governed by PowerRecord.tax_rate (+0x01) and the bit-10 De-Soto/
 * Cortés attribute (power_attribute_bit). Net credited to PowerRecord gold u32s.
 *
 * This is the POST-LCR step: a Treasure unit (spawned by lcr_resolve outcome
 * 2/4) is ferried to Europe by a Galleon, and THAT function books the gold.
 * ============================================================================ */

/* ============================================================================
 * NOTE — capital-raze gold bonus (random_events-adjacent).  [TBD magnitude]
 * ----------------------------------------------------------------------------
 * Razing a NATIVE CAPITAL pays the standard CHIEFKILL (func_04A7CA, file
 * 0x04AAD0..0x04AB6E: gold = sum_3 * roll_4 * 4 * (pop+1)) PLUS a capital-only
 * bonus on top.  User data (docs/CAPITAL_BONUS_ANALYSIS.md): Inca cap (pop 13)
 * = 15,000; Aztec cap (pop 10) = 10,000 — both exceed the pure CHIEFKILL
 * ceiling, so a bonus exists.  The leading hypothesis is
 * `1000 * civ_tier * random_int(1,5)` but the dice range / multiplier are NOT
 * byte-proven (the branch on the NativeSettlement capital flag +0x03&0x04 has
 * not been read).  MAGNITUDE STAYS [TBD] — do not fabricate.  CHIEFKILL itself
 * lives in the native subsystem (out of this file's scope).
 * ============================================================================ */
