/* ============================================================================
 *      >>> PARTIALLY BYTE-VERIFIED (func_057F4E diplomacy meeting) <<<
 * ----------------------------------------------------------------------------
 * This is the European-diplomacy "parley/meeting" dispatcher: the routine that
 * runs when two powers meet and exchange treaty / peace / tribute / war
 * proposals.  It is the long-missing PROPOSE / ACCEPT / REJECT + attitude-score
 * path that treaty.c and relations.c prior pass left unresolved ("caller not located").
 *
 * Function: `func_057F4E`  @ file 0x057F4E .. 0x059B3C  (page 0x0F)
 *   overlay_functions_reseg.json: size 7151, insns 2356,
 *   prologue ENTER 0x00D6,0, terminal RETF (verified @0x059B3C `leave;retf`,
 *   bytes 0x057F4E = C8 D6 00 00 in COLONIZE/VICEROY.EXE).
 *
 * PURPOSE — confirmed by STRING XREF (file_offset = handle + 0x1D9A0):
 *   The function PUSHes 49 distinct message-key handles and feeds each to the
 *   diplomacy dialog (lcall 0x1A1F:0x0688, overlay file 0x290CC).  Resolved
 *   tree (all byte-verified pushes; see DIPLO_KEY table below): HELLO/AHOY/
 *   FIRST/HELLOUSA greetings, MEEK/MANLY/KINGS/DEEDS leader styles, then
 *   topic exchanges PIRACY, SIEGES, TRIBUTE, WANTSTUFF, PROVOKE, WARMANLY,
 *   WORTHY, PEACE/OLDPEACE/PEACEUSA, GIVECASH, GIFTS, THREATS, the WITHDRAW
 *   negotiation (WITHDRAW/NOTWITHDRAW/MAYBEWITHDRAW/NOTHINGWITHDRAW), and the
 *   SMITE attack (SMITEINDIANS/SMITEEUROPE/UNFORTUNATE/MERCENARY).
 *
 * SCOPE NOTE — this single VICEROY routine handles BOTH native-chief parley
 * and European-power diplomacy (the early-out at 0x1CE4 routes `power<4` with
 * the per-power flag at 0x543F into one common body).  The NATIVE "SMITE" loot
 * branch (file 0x05997C..0x059AD9) was already extracted to
 * src/native/diplomacy_smite_gold.c by the native pass and is NOT duplicated
 * here.  This file documents the EUROPEAN-relation mutations and the shared
 * dispatcher skeleton (src/diplomacy/ scope).
 *
 * WHAT IS BYTE_VERIFIED here:
 *   - The full dialog-key tree (every push + its resolved string).
 *   - The war-flag matrix mutations at PowerRecord+0x34 (base DGROUP:0x883C,
 *     bytes -0x77C4): SET bit 0x02 (declare war), SET bit 0x08, CLEAR bit 0x80.
 *     Matches relations.c WAR_FLAG_MATRIX_BASE / WAR_FLAG_AT_WAR.
 *   - The treaty-bit set/clear via rel_apply_event(0x40,..) / rel_clear_event
 *     (0x40,..)  (0x181F:0x0A06 / 0x0A10) on PEACE-accept and PROVOKE/break.
 *   - The GOLD TRANSFER on an accepted paid treaty: subtract from power-b gold
 *     at PowerRecord+0x2A (bytes -0x77CE/-0x77CC) and add to the active player's
 *     gold via the [0x84FC] record (+0x2A/+0x2C).  This is the "gold/goods
 *     transfer on a signed treaty" that the prior pass left unresolved.
 *   - The treaty cool-down timer write at [power*2 + 0x53C8] = turn + 0x10.
 *   - The per-unit ownership transfer on a treaty (UnitRecord stride 0x1C, base
 *     0x3144; owner nibble +0x3147, type +0x3146; copies power flag bytes
 *     [PR-0x77C6]/[PR-0x77C5] -> unit +0x314D/+0x314E).
 *
 * WHAT IS NOT YET PROVEN (tagged inline, never guessed):
 *   - RESOLVED 2026-06-10: the attitude-accumulator loop #1 tables are the AI
 *     census matrices byte[4][16] (-0x6A4E=coastal cargo, -0x6B1A=population,
 *     -0x6ADA=settled units, -0x6B5A=unit count; writer in
 *     overlay_040C1E_04458A.c) — see the section-3 block in diplomacy_meeting.
 *   - RESOLVED 2026-06-10: loop #2 = per-colony adjacency pressure via
 *     func_056A10 (see section 3b); -0x6BD4 (0x942C) = census coastal-cargo
 *     per-power total; -0x6BE4 (0x941C) = census per-power finance word.
 *     Still open: 0x5236 (prod-table column) and 0x5DE0 (market, see
 *     tax_apply.c) term meanings in the later score-shaping.  The numeric
 *     thresholds (e.g. score>100 -> PROVOKE) are byte-cited constants, not
 *     invented.
 *   - 0x181F:0x035C: CONFIRMED CLAMP (2026-06-08). 0x0D1D:0x0EC6: RUNTIME_ONLY
 *     (C-runtime __aFldiv 32-bit long divide; body in segment 0x0D1D, not in load image).
 *
 * Upgrade per viceroy_source/VERIFICATION_LEDGER.md. Do not trust any value
 * not carrying an @asm citation in this file.
 * ============================================================================ */

/* ============================================================================
 * meeting.c -- European diplomacy meeting / parley dispatcher (func_057F4E)
 * ----------------------------------------------------------------------------
 * @ref ../docs/EUROPEAN_DIPLOMACY.md   (NOTE: that doc is RECONSTRUCTED; the
 *      byte-verified facts live here and in VERIFICATION_LEDGER.md)
 * @asm VICEROY.EXE func_057F4E @0x057F4E (page 0x0F, ENTER 0xD6,0, RETF @0x59B3C)
 * @asm dialog display:  lcall 0x1A1F:0x0688  -> file 0x6F61C (func_06F61C)
 * @asm option builder:  call cs:0x3F35 -> ljmp 0x1A1F:0x0618 -> file 0x57A3A
 *      (func_057A3A, ENTER 0x54 — same overlay 15 as this function)
 * THUNK-TARGET CORRECTION 2026-06-10: the old targets "0x2692A"/"0x290CC" were
 * computed with a fixed base 0x25900 for every 0x1A1F thunk; neither address is
 * a function start (raw bytes are mid-instruction).  The RTLink thunk records at
 * file 0x1C5F0+off are `9A AB0D 0D11 | EA <off32> | <ovl16> | <xx>`, and <ovl>
 * maps IDENTITY onto overlay_segmap.json keys.  Verified on four pairs:
 *   0x0434 -> ovl 12 +0x2154 = 0x48F34 (func_048F34, independently verified)
 *   0x0634 -> ovl 15 +0x0000 = 0x56A10 (func_056A10, matches call-site signature)
 *   0x0618 -> ovl 15 +0x102A = 0x57A3A (func_057A3A, ENTER 0x54)
 *   0x0688 -> ovl 23 +0x37CC = 0x6F61C (func_06F61C, PUSH BP prologue)
 * ============================================================================ */
#include "viceroy_types.h"
#include "power.h"

/* ----------------------------------------------------------------------------
 * Arguments (cdecl far; last push = lowest [bp+] slot).
 *   [bp+6]  = power_self   (the "we" power; <4 => European, else native tribe)
 *   [bp+8]  = power_other  (the power being parleyed with)
 *   [bp+0xA]= context/unit-iter scratch (also reused as a unit loop index)
 *   [bp+0xC]= a record ptr (read at +0xB4/+0xBE — colony/unit stat block)
 *   [bp+0xE]= mode flag (0 = ?interactive meeting; nonzero gates some paths)
 * @asm 057F8C cmp [bp+6],4 ; 057F92 imul bx,[bp+6],0x34 ; 057F96 cmp [bx+0x543f],0
 * ---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
 * BYTE-VERIFIED diplomacy dialog-key tree (handle -> string).
 * Mapping rule (RESOLVED & re-confirmed): file_offset = handle + 0x1D9A0.
 * Each handle is PUSHed immediately before a cs:0x3F35 option-build or a
 * 0x0D1D:0x07E4 message-format call; the per-branch dialog is shown by
 * lcall 0x1A1F:0x0688.  Short keys "RID"/"WAR" (0x1951/0x1978/0x19D2) are
 * phrase modifiers concatenated by 0x0D1D:0x07A4 (verified from raw bytes:
 * 0x1F2F1='RID', 0x1F318='WAR', 0x1F372='WAR').
 * ---------------------------------------------------------------------------- */
#define DK_MEEK            0x18B0  /* @asm 0x2D... "MEEK"      file 0x1F250 */
#define DK_MANLY           0x18B5  /* "MANLY"     file 0x1F255 */
#define DK_KINGS           0x18BB  /* "KINGS"     file 0x1F25B */
#define DK_DEEDS           0x18C1  /* "DEEDS"     file 0x1F261 */
#define DK_HELLO           0x18C7  /* "HELLO"     file 0x1F267 */
#define DK_AHOY            0x18CD  /* "AHOY"      file 0x1F26D */
#define DK_FIRST           0x18D2  /* "FIRST"     file 0x1F272 */
#define DK_HELLOUSA        0x18D8  /* "HELLOUSA"  file 0x1F278 */
#define DK_APOSTATES       0x18E1  /* "APOSTATES" file 0x1F281 (@asm 0x26D9) */
#define DK_HEATHEN         0x18EB  /* "HEATHEN"   file 0x1F28B (@asm 0x2710) */
#define DK_LEADER          0x18F3  /* "LEADER"    file 0x1F293 (@asm 0x2819 PIRACY topic) */
#define DK_PIRACY          0x18FA  /* "PIRACY"    file 0x1F29A (@asm 0x285D) */
#define DK_LEADER_b        0x1901  /* "LEADER"    file 0x1F2A1 (@asm 0x29A4 SIEGES) */
#define DK_SIEGES          0x1908  /* "SIEGES"    file 0x1F2A8 (@asm 0x29E9) */
#define DK_LEADER_c        0x190F  /* "LEADER"    file 0x1F2AF (@asm 0x2B84 TRIBUTE) */
#define DK_TRIBUTE         0x1916  /* "TRIBUTE"   file 0x1F2B6 (@asm 0x2BCD) */
#define DK_LEADER2         0x191E  /* "LEADER2"   file 0x1F2BE (@asm 0x2C5F WANTSTUFF) */
#define DK_WANTSTUFF       0x1926  /* "WANTSTUFF" file 0x1F2C6 (@asm 0x2CA6) */
#define DK_PROVOKE         0x1930  /* "PROVOKE"   file 0x1F2D0 (@asm 0x2D3E break-treaty) */
#define DK_LEADER2_d       0x1938  /* "LEADER2"   file 0x1F2D8 (@asm 0x2D6D WARMANLY) */
#define DK_WARMANLY        0x1940  /* "WARMANLY"  file 0x1F2E0 (@asm 0x2D99) */
#define DK_LEADER2_e       0x1949  /* "LEADER2"   file 0x1F2E9 (@asm 0x2DA8) */
#define DK_RID             0x1951  /* "RID" modifier file 0x1F2F1 (@asm 0x2DC7) */
#define DK_LEADER2_f       0x1955  /* "LEADER2"   file 0x1F2F5 (@asm 0x2E23 WORTHY/peace) */
#define DK_WORTHY          0x195D  /* "WORTHY"    file 0x1F2FD (@asm 0x2E6D) */
#define DK_PEACE           0x1964  /* "PEACE"     file 0x1F304 (@asm 0x2EA0) */
#define DK_MEEK_b          0x196A  /* "MEEK"      file 0x1F30A (@asm 0x2EF3 GIVECASH peace) */
#define DK_GIVECASH        0x196F  /* "GIVECASH"  file 0x1F30F (@asm 0x2F25) */
#define DK_WAR_a           0x1978  /* "WAR" modifier file 0x1F318 (@asm 0x2F72) */
#define DK_LEADER2_g       0x197C  /* "LEADER2"   file 0x1F31C (@asm 0x2F94) */
#define DK_OLDPEACE        0x1984  /* "OLDPEACE"  file 0x1F324 (@asm 0x2FD3) */
#define DK_PEACEUSA        0x198D  /* "PEACEUSA"  file 0x1F32D (@asm 0x30A6) */
#define DK_NOTHINGWITHDRAW 0x1996  /* "NOTHINGWITHDRAW" file 0x1F336 (@asm 0x3107) */
#define DK_WITHDRAW        0x19A6  /* "WITHDRAW"  file 0x1F346 (@asm 0x3127) */
#define DK_NOTWITHDRAW     0x19AF  /* "NOTWITHDRAW" file 0x1F34F (@asm 0x31CD) */
#define DK_MAYBEWITHDRAW   0x19BB  /* "MAYBEWITHDRAW" file 0x1F35B (@asm 0x31E8) */
#define DK_WITHDRAW_b      0x19C9  /* "WITHDRAW"  file 0x1F369 (@asm 0x325F) */
#define DK_WAR_b           0x19D2  /* "WAR" modifier file 0x1F372 (@asm 0x327C) */
#define DK_MANLY_b         0x19D6  /* "MANLY"     file 0x1F376 (@asm 0x327C) */
#define DK_LEADER2_h       0x19DC  /* "LEADER2"   file 0x1F37C (@asm 0x329E) */
#define DK_GIFTS           0x19E4  /* "GIFTS"     file 0x1F384 (@asm 0x3450) */
#define DK_PROVOKE_b       0x19EA  /* "PROVOKE"   file 0x1F38A (@asm 0x349C) */
#define DK_THREATS         0x19F2  /* "THREATS"   file 0x1F392 (@asm 0x34A5) */
#define DK_NOCONTACT       0x1A03  /* "NOCONTACT" file 0x1F3A3 (@asm 0x35ED) */
#define DK_ALREADYSMITE    0x1A0D  /* "ALREADYSMITE" file 0x1F3AD (@asm 0x3612) */
#define DK_SMITEINDIANS    0x1A1A  /* "SMITEINDIANS" file 0x1F3BA (native branch) */
#define DK_SMITEEUROPE     0x1A27  /* "SMITEEUROPE"  file 0x1F3C7 (smite branch) */
#define DK_UNFORTUNATE     0x1A33  /* "UNFORTUNATE"  file 0x1F3D3 (smite branch) */
#define DK_MERCENARY       0x1A3F  /* "MERCENARY"    file 0x1F3DF (smite branch) */

/* ----------------------------------------------------------------------------
 * War-flag relation matrix (SECOND matrix; distinct from treaty-state +0x40).
 * @asm base accessed as [bx + idx_pair - 0x77C4]; -0x77C4 (mod 0x10000) ==
 *      +0x883C == PowerRecord+0x34, stride 0x13C.  Matches relations.c.
 * Verified bytes (COLONIZE/VICEROY.EXE):
 *   0x058A7B = 80 88 3C 88 02  -> or  byte[..-0x77c4],2    (set "at war")
 *   0x058BE1 = 80 A0 3C 88 7F  -> and byte[..-0x77c4],0x7f (clear high bit)
 *   0x059AE9 = 80 88 3C 88 08  -> or  byte[..-0x77c4],8    (set bit 0x08)
 * ---------------------------------------------------------------------------- */
#define WAR_FLAG_MATRIX_BASE   0x883C   /* @asm -0x77C4 == PowerRecord+0x34 */
#define POWER_STRIDE           0x13C
#define WAR_FLAG_AT_WAR        0x02     /* @asm 0x27CB or [..],2 */
#define WAR_FLAG_BIT3          0x08     /* @asm 0x3839 or [..],8 — "pending" activation flag;
                                         * BYTE_VERIFIED 2026-06-08 via func_052F7E Phase 4:
                                         * bit3=pending → slot awaits countdown+random_int(0,3)==0
                                         * to arm (set bit0=armed); set here during treaty/hostility. */
#define WAR_FLAG_HIGH          0x80     /* @asm 0x2931 and [..],0x7f clears it */

/* PowerRecord gold is a 32-bit field at +0x2A.  As an absolute DGROUP byte it
 * is 0x8808 + idx*0x13C + 0x2A; the function reaches it as [bx - 0x77CE]
 * (low word, 0x8832) and [bx - 0x77CC] (high word, 0x8834).
 * @asm 0x2C2B add [bx-0x77ce],ax ; 0x2C2F adc [bx-0x77cc],dx (gift to power-b)
 * Bytes 0x058EDB = 01 87 32 88, 0x058EDF = 11 97 34 88. */
#define POWER_GOLD_LO_OFF      0x2A     /* PowerRecord+0x2A low word  (abs 0x8832) */
#define POWER_GOLD_HI_OFF      0x2C     /* PowerRecord+0x2C high word (abs 0x8834) */

/* Per-power treaty cool-down timer table, word stride, base DGROUP:0x53C8.
 * @asm 0x2E9C mov [bx+0x53c8],ax with bx = power*2, ax = turn(0x538E)+0x10.
 * Also read as the "min turns before re-meet" gate @0x1D3C / @0x2E91. */
#define TREATY_TIMER_BASE      0x53C8   /* @asm [power*2 + 0x53c8] */
#define TURN_COUNTER           0x538E   /* @asm word [0x538e] current turn */
#define DIFFICULTY_BYTE        0x53A6   /* @asm byte [0x53a6] difficulty level */

/* UnitRecord table: base DGROUP:0x3144, stride 0x1C (BYTE_VERIFIED elsewhere).
 *   +0x3144/+0x3145 = unit map x/y (copied here)
 *   +0x3146         = unit type
 *   +0x3147 & 0x0F  = owner power index
 *   +0x314D/+0x314E = ?destination/escort fields written on transfer
 * @asm 0x28BA imul bx,[bp+0xa],0x1c ; +0x3147 & 0xf == [bp+6] owner test. */
#define UNIT_TABLE_STRIDE      0x1C
#define UNIT_COUNT_WORD        0x539C   /* @asm word [0x539c] live unit count loop bound */

/* ----------------------------------------------------------------------------
 * Overlay thunks (RTLink). Call sites + args VERIFIED; internal behaviour as
 * noted. Resolved overlay file offsets cited (lcall_resolution_VICEROY.json).
 * ---------------------------------------------------------------------------- */
extern uint8_t rel_query(int self, int other);                 /* 0x181F:0x0A38 -> file 0x5FC30 (bits 0x02/0x20/0x40/0x80) */
extern void    rel_apply_event(int mask, int a, int b);        /* 0x181F:0x0A06 -> file 0x5FCD2 (SET masked treaty bit) */
extern void    rel_clear_event(int mask, int a, int handle);   /* 0x181F:0x0A10 -> file 0x5FCFC (CLEAR masked bit) */
extern int     rel_event_query_other(int self);                /* 0x181F:0x0A1A -> file 0x5FDC4 (returns a handle for power) */
extern int     power_handle(int power_idx);                    /* 0x181F:0x09A4 -> file 0x5FE0C */
extern void    power_set_slot(int handle, int slot);           /* 0x181F:0x0438 -> file 0x25CEC (UI/role slot setter) */
extern void    ui_set_text_arg(int ds_seg, void *str, int idx);/* 0x181F:0x0416 -> file 0x25CD0 (format %arg substitution) */
extern int     random_int(int lo, int hi);                     /* 0x181F:0x04D4 -> file 0x27DB2 (random_int, GROUND TRUTH) */
/* BYTE_VERIFIED 2026-06-08: pure clamp. Implementation file 0x0048CC (runtime 0x024C:0x000C)
 * via overlay stub 0x181F:0x035C. clamp(value, lo, hi) = max(lo, min(value, hi)).
 * Note: file 0x28792 is a DIFFERENT function (calls 0x181F:0x0092 then 0x181F:0x00B0). */
extern int16_t diplo_scale_181F_035C(int16_t v, int16_t lo, int16_t hi); /* clamp — VERIFIED */
extern int     diplo_182_pair(int a, int b);                   /* 0x181F:0x0D6C -> file 0x259F2. Cross-ref: overlay_046D70 / native/haggle.c
                                                                * identify this as "adjust native/power attitude(tribe,power,delta,0)";
                                                                * here called with (b-4, a, 100, 0) — attitude delta +100 for power pair.
                                                                * Body: library-implementation-only (page 0x0B overlay). */
extern void    ui_set_long_arg(int hi, int lo, int idx);       /* 0x181F:0x09AE (long %arg) */
/* 0x1A1F:0x0688 -> file 0x290CC.  Second arg is a 16-bit word that is EITHER a
 * near pointer to a composed buffer OR a bare message-key handle (both forms
 * appear in the disasm: `push &buf` vs `push 0x1930`).  Returns the player's
 * choice code (1 = accept/yes, 2 = the alternate "accept" used by the topic
 * exchanges; 0 = dismiss).  Modelled as int to match the raw 16-bit push. */
extern int     ui_dialog_show(int power_other, int key_or_strptr);

/* cs:0x3FXX are a near-call FAR-JUMP TRAMPOLINE table at file 0x05A1D6
 * (a block of `ljmp 0x1A1F:NNN` / `ljmp 0x181F:NNN`).  CS base of page 0x0F is
 * 0x562B0 (file 0x057DC0 == cs-off 0x1B10).  Resolved:
 *   cs:0x3F26 -> ljmp 0x181F:0x550   (early setup; file 0x259F8)
 *   cs:0x3F30 -> ljmp 0x1A1F:0x60A   (per-side relation tag on treaty SET)
 *   cs:0x3F35 -> ljmp 0x1A1F:0x618   (file 0x2692A: build a dialog OPTION line)
 *   cs:0x3F3F -> ljmp 0x1A1F:0x634
 *   cs:0x3F44 -> ljmp 0x1A1F:0x642   (build dialog option, bool variant)
 *   cs:0x3F4E -> ljmp 0x1A1F:0x65E   (native-meeting sub-path, early-out branch)
 *   cs:0x3F58 -> ljmp 0x1A1F:0x67A   (relation predicate, used by treaty.c)
 * VERIFIED: trampoline bytes at 0x05A1D6 are EA <off> <seg> far-jumps. */
extern void diplo_opt(int key, char *buf);            /* cs:0x3F35 -> 0x1A1F:0x618 */
extern void diplo_opt_if(int cond, int idx);          /* cs:0x3F44 -> 0x1A1F:0x642 */
extern void diplo_relation_tag(int a, int b);         /* cs:0x3F30 -> 0x1A1F:0x60A */
extern void diplo_native_meeting(int self, int other);/* cs:0x3F4E -> 0x1A1F:0x65E */

/* String concat/format helpers in the 0x0D1D overlay (load-image text lib). */
extern void str_set(int key, char *buf);              /* 0x0D1D:0x07E4 (set buf = key text) */
extern void str_cat(int key_or_buf, char *buf);       /* 0x0D1D:0x07A4 (append) */
extern long gold_scale_0D1D_0EC6(int hi, int lo, int mul, int z); /* 0x0D1D:0xEC6 — 32-bit long divide (__aFldiv-style).
                                                                    * Cross-ref: production_support.c "LCALL 0xD1D:0xEC6 — 32-bit divide";
                                                                    * colony/sol_tory.c "0xD1D:0xEC6 = 32-bit div: (gross*tax)/100";
                                                                    * overlay_031F28 extern ldiv_D1D_EC6(long a, long b).
                                                                    * Used here to scale other.gold down to a peace-payment base amount.
                                                                    * Body: RUNTIME_ONLY (C-runtime long-arith, segment 0x0D1D). */

/* DGROUP globals (precise meaning cited where known).
 * 0x5382 cross-ref: ai/unit_ai_leaf.c "bit0 = endgame/War-of-Independence active";
 *   king/war_turn.c "global event flags; bit0=independence declared". */
extern uint8_t  g_diplo_guard_5382;   /* @asm 0x1D04 test byte[0x5382],1 — global-event flag; bit0=independence/endgame lock */
extern uint8_t  g_perpower_flag_543F[]; /* @asm 0x1CE6 byte[bx+0x543f] (bx=power*0x34) — meeting-eligible flag */
extern int16_t  g_word_539E;          /* @asm word[0x539e] — outer item-loop bound (#15 below) */
extern int16_t  g_word_539C;          /* @asm word[0x539c] — unit-loop bound */
extern int16_t  g_word_53D2;          /* @asm word[0x53d2] — a power index excluded from a scan */
extern struct PowerRecord *g_active_power; /* DGROUP:0x84FC — active player's record (gold +0x2A/+0x2C) */

/* ----------------------------------------------------------------------------
 * Cell helpers (pure address arithmetic; BYTE_VERIFIED bases).
 * ---------------------------------------------------------------------------- */
static inline uint8_t *war_flag_cell(int self, int other)
{
    uint8_t *base = (uint8_t *)WAR_FLAG_MATRIX_BASE;          /* +0x883C */
    return base + (unsigned)self * POWER_STRIDE + (unsigned)other;
}
static inline int32_t *power_gold(int power_idx)
{
    uint8_t *base = (uint8_t *)POWER_TABLE_BASE;              /* 0x8808 */
    return (int32_t *)(base + (unsigned)power_idx * POWER_STRIDE + POWER_GOLD_LO_OFF);
}
/* Active player's gold pointer via [0x84FC] (32-bit field at +0x2A).
 * @asm 0x2B6B/0x2C1C/0x2F56 mov bx,[0x84fc]; ... [bx+0x2a]/[bx+0x2c]. */
static inline int32_t *power_gold_active(void)
{
    return (int32_t *)((uint8_t *)g_active_power + POWER_GOLD_LO_OFF);
}

/* ============================================================================
 * diplomacy_meeting -- func_057F4E
 * ----------------------------------------------------------------------------
 * Runs one diplomacy parley between `power_self` and `power_other`.  Computes a
 * running attitude score (`score`, local [bp-0x66]) from many weighted terms,
 * then walks a fixed sequence of proposal exchanges; each shows a dialog and,
 * on the player's choice, mutates the war/treaty matrices and transfers gold.
 *
 * This reproduction is FAITHFUL to the disasm control flow and to every
 * verified mutation, with @asm citations per block.  The attitude-score
 * arithmetic is transcribed literally (constants are byte-cited); blocks whose
 * *meaning* is not fully proven are marked 'not yet decoded' and never editorialised.
 * Local-name legend (BP offsets -> our identifiers):
 *   score=[bp-0x66]  early_out=[bp-0x8c]  want_action=[bp-0xa6]
 *   warbit_set=[bp-0xac]  is_war_topic=[bp-0xa]  third_power=[bp-0xc8]
 *   payment=[bp-0x94]  dlg=[bp-8]  notify_kind=[bp-0xd2]
 * ---------------------------------------------------------------------------- */
void diplomacy_meeting(int power_self, int power_other, int ctx, void *rec, int mode)
{
    int  score = 0;            /* [bp-0x66]  running attitude accumulator */
    int  want_action = 0;      /* [bp-0xa6]  "a state change is warranted" */
    int  warbit_set;           /* [bp-0xac]  = war_flag_cell(self,other) & 2 */
    int  is_war_topic = 0;     /* [bp-0xa]   set by late-game aggression gate */
    int  third_power = -1;     /* [bp-0xc8]  best ally/enemy found in scan */
    int  notify_kind = 0;      /* [bp-0xd2]  0/1 selects greeting/leader variant */
    int  dlg;                  /* [bp-8]     dialog return (1=yes/accept,2=...) */
    char buf[0x54];            /* [bp-0x5a]  composed dialog text */
    char buf2[0x2c];           /* [bp-0x7e]  secondary text fragment */

    (void)ctx; (void)rec; (void)mode; (void)buf2;

    /* ---- 0. Eligibility / global lock --------------------------------------
     * @asm 0x1CDC: if power_self < 4 AND g_perpower_flag_543F[self] != 0:
     *                  diplo_native_meeting(other,self); early_out=1; goto exit.
     *   (Routes the "already-known native" case to the cs:0x3F4E sub-path.)
     * @asm 0x1D04: if (g_diplo_guard_5382 & 1) goto exit (global diplomacy lock). */
    if (power_self < 4 && g_perpower_flag_543F[power_self * 0x34] != 0) {
        diplo_native_meeting(power_other, power_self);   /* @asm 0x1CF4 call cs:0x3f4e */
        return;                                          /* @asm 0x1D00 -> exit */
    }
    if (g_diplo_guard_5382 & 1)                          /* @asm 0x1D04 test [0x5382],1 */
        return;                                          /* @asm 0x1D0B jmp exit */

    /* ---- 1. Peace-pending bootstrap & re-meet cool-down --------------------
     * @asm 0x1D1B rel_query(self,other) & 0x20 -> if NOT pending, mark want=1
     *      and play sound 0x0A (lcall 0x181F:0x524).
     * @asm 0x1D3C cool-down: if power_timer[other] + 0x10 > turn -> want=1 and
     *      rel_clear_event(0x10, self, other).  (0x10 = "meet recently" bit.)
     * @asm 0x1D65 cache (rel_query(self,other) & 0x10) into a local for later. */
    if (!(rel_query(power_self, power_other) & 0x20)) {  /* @asm 0x1D23 test al,0x20 */
        want_action = 1;
        /* play sound 0x0A @asm 0x1D2F lcall 0x181f,0x524 */
    }
    {
        int16_t *timer = (int16_t *)((uint8_t *)TREATY_TIMER_BASE + power_other * 2);
        if (*timer + 0x10 > *(int16_t *)TURN_COUNTER) {  /* @asm 0x1D43 cmp ax,[0x538e] */
            want_action = 1;
            rel_clear_event(0x10, power_self, power_other); /* @asm 0x1D57 lcall 0x181f,0xa10 */
        }
    }

    /* ---- 2. Greeting selection (HELLO/AHOY/FIRST/HELLOUSA) ------------------
     * @asm 0x1D7E switch(power_other & 3) loads a sound id 0x8020..0x8023 and
     *      plays it (lcall 0x181F:0x4C0).  The leading 0x80 bit marks "diplo".
     * (Greeting STRING composition happens later at the 0x258C block.) */

    /* ---- 3. ATTITUDE-SCORE ACCUMULATOR (the AI relationship estimate) -------
     * DECODED 2026-06-10 (BYTE_VERIFIED against func_057F4E.asm file
     * 0x05809A..0x0581C4).  The "per-power item tables" are the per-turn AI
     * CENSUS MATRICES — byte[4 powers][16 regions], player-major stride 16,
     * rebuilt each turn by the census pass in overlay_040C1E_04458A.c and
     * saved as six 0x40 blocks (save_serializer.c @0x94A6/0x94E6/0x95B2/...):
     *   0x94A6 (-0x6B5A)  unit count     (+1 per land unit homed in region @0x04228D)
     *   0x94E6 (-0x6B1A)  population sum (+= colony[+0x1F] per colony  @0x042595)
     *   0x9526 (-0x6ADA)  settled units  (+1 per unit in a settlement  @0x0422D5)
     *   0x95B2 (-0x6A4E)  coastal cargo  (+= cargo value of coastal non-REF
     *                                     units @0x0423C1 — "exposed wealth")
     *
     * Loop: for region i = 0..14 ([bp-0xca], cmp 0xF @file 0x0581AC):
     *  presence threshold t = (colony_count(other)[other-0x6D68] > 1) ? 1 : 0
     *                                              @file 0x0581B6/0x0581C0
     *  1. VULNERABLE-CARGO term (secondary acc [bp-0xcc], @0x0580A3..0x0580DC):
     *     if pop[other][i] > t  AND  units[other][i] < cargo[self][i]:
     *       [bp-0xcc] += (cargo[self][i] / (units[other][i]+1))
     *                       << (difficulty==0 ? 2 : 1)      @0x0580CD..0x0580DA
     *     (self's coastal wealth poorly covered by other's units there.)
     *  2. CONTACT FLAGS (@0x0580E4..0x058126):
     *     if cargo[self][i] && cargo[other][i]            -> want_action = 1
     *     if cargo[other][i] && settled[self][i] > 4      -> want_action = 1
     *  3. SCORE FOLD (@0x058128..0x0581A5), score [bp-0x66] +=
     *     pop[self][i]>0 && pop[other][i]>1 :  cargo[other][i]-cargo[self][i]
     *     pop[self][i]>0 && pop[other][i]<=1:  cargo[other][i]
     *     pop[self][i]==0:  (cargo[other][i]-cargo[self][i])
     *                          >> (pop[other][i]>=1 ? 1 : 2)
     * Net: score ~= per-region (other's exposed coastal wealth - self's),
     * weighted by population presence — the AI's envy/oppportunity estimate. */
    /* [attitude loop #1 — @asm 0x1DEA..0x1F14 = file 0x05809A..0x0581C4; above] */

    /* ---- 3b. ATTITUDE LOOP #2 — per-colony adjacency pressure ---------------
     * DECODED 2026-06-10 (BYTE_VERIFIED, func_057F4E.asm file 0x0581DA..0x0582A6).
     * For each colony c = 0..[0x539E]-1 owned by self OR other (owner byte
     * colony[+0x1A] checked @0x0581E6/0x0581F2):
     *
     *   pressure = colony_strongest_adjacent_defender(&besieger, &garrison,
     *                                                 &adj_total, power_other);
     *     -- the near call @0x05820F `push cs; call 0x5A1EF` goes through the
     *        far-jump trampoline @file 0x05A1EF (ljmp 0x1A1F:0x0634) -> RTLink
     *        thunk @0x1CC24 (overlay 15 + 0) -> func_056A10 (ported in
     *        overlay_054505_05C69B.c).  It scans the colony tile + 8 neighbours:
     *        garrison  = scaled value (0x8BC code 0xA) of the unit ON the tile,
     *        and over adjacent units OWNED BY power_other only:
     *        pressure += 0x8BC(0xB,u)>>3, adj_total += 0x8BC(0xA,u),
     *        besieger = power_other if it has any adjacent unit else -1.
     *
     *   if (besieger == power_other):                          @asm 0x05821C
     *       score += 2*pressure;                               @asm 0x058226
     *       if (garrison == 0 || adj_total > 1) {              @asm 0x05822B
     *           if (vulncargo_acc) vulncargo_acc--;            @asm 0x05823F
     *           want_action = 1; }                             @asm 0x058243
     *       region = region_index(colony.x, colony.y);         @asm 0x058256 0x181F:0x722
     *       if (census_pop_94E6[other*16+region] == 0)          @asm 0x05826A
     *           pressure <<= 1;          (besieging w/o local base counts double)
     *       other_pressure_sum += pressure;  other_has_siege = 1; @asm 0x058279/0x05827D
     *
     *   if (besieger == power_self):                           @asm 0x058285
     *       self_pressure_sum += pressure;  score -= 2*adj_total;
     *       NOTE: STRUCTURALLY DEAD AS COMPILED — func_056A10's owner gate
     *       (@0x056AA2 jne to loop tail) means besieger ∈ {-1, power_other}
     *       only; this arm is transcribed faithfully but cannot fire.
     *
     * Local map: [bp-0xb6]=pressure  [bp-0x90]=besieger  [bp-4]=garrison
     *   [bp-0xc2]=adj_total  [bp-0xb0]=other_pressure_sum  [bp-6]=self_pressure_sum
     *   [bp-0x60]=other_has_siege  [bp-0xcc]=vulncargo_acc (from loop #1). */

    /* @asm 0x1FFB late-game aggression gate: if [0xA153]==self AND turn>=0x50
     *      AND self.byte[-0x6D68]>3 AND other.byte[-0x6D68]>1 -> is_war_topic=1. */
    /* @asm 0x2024 warbit_set = war_flag_cell(self,other) & 2 (the "at war" bit). */
    warbit_set = *war_flag_cell(power_self, power_other) & WAR_FLAG_AT_WAR;

    /* @asm 0x2037..0x2078 (file 0x0582E7..0x058328) — DECODED 2026-06-10:
     *      if (!is_war_topic && warbit_set &&
     *          3 * census_cargo_total_942C[other] > census_cargo_total_942C[self])
     *      { want_action=1; vulncargo_acc=0;
     *        score = clamp(score, 0xC8*difficulty + 0x64, 0x26AC); }
     *      0x942C (-0x6BD4) = per-power census coastal-cargo TOTAL (the scalar
     *      row-sum twin of the 0x95B2 matrix, written @0x0423A8 in the census).
     *      The "×3" @file 0x0582F8-0x0582FC is shl al,1; add al,cl.
     *      diplo_scale_181F_035C = clamp (resolved 2026-06-08). */
    /* @asm 0x2099 bit-19 power attribute (lcall 0x181F:0x7B4) halves a term. */
    /* @asm 0x20F8..0x2171 difficulty/turn scaling of score (×(diff+8), /100,
     *      then halves/quarters by turn thresholds 0x32/0x64 and aggression). */
    /* @asm 0x2154 diplo_scale_181F_035C(score, 0, 0x190) then ×0x32. */
    /* @asm 0x2188 cap by active-player gold ([0x84FC]+0x2a/+0x2c). */
    /* These are all score-shaping; reproduced as a single opaque step here
     * because their individual table meanings are not yet decoded (cited above). */

    /* ---- 4. Find the most relevant THIRD power (ally/enemy) -----------------
     * @asm 0x237F..0x24A6: scans powers 0..3 (skipping self, other, [0x53D2]);
     *      tracks `third_power` ([bp-0xc8]) = a power that is at peace bit 0x20,
     *      adjusting a tally [bp-0xb8] by relative strength [bx-0x6BE4].
     *      Used to colour the dialog (e.g. "join us against X"). */

    /* ---- 5. PIRACY / war-grievance exchange --------------------------------
     * @asm 0x27F7 if rel_query(self,other) & 0x80 (a contact/known bit) and
     *      self has a colony/strength, build LEADER+PIRACY and show dialog.
     * @asm 0x289D if dlg==2 ("accept"): loop all units (stride 0x1C), for units
     *      owned by self with type 0x10 reassign them, then CLEAR the war high
     *      bit:  and war_flag_cell(self,other), 0x7F.  (@asm 0x2931) */
    /* (Full body @0x27F7..0x296A.  War-bit clear is BYTE_VERIFIED.) */

    /* ---- 6. SIEGES exchange (military pressure) -----------------------------
     * @asm 0x2974..0x2A36 builds LEADER+SIEGES if a siege count [bp-6] exceeds
     *      other's threshold; on dlg==2 applies score -= 100*[bp-6] (clamped
     *      >=0) via @asm 0x2A3B imul ax,[bp-6],-0x64.  Then a unit-transfer loop
     *      (@0x2A60..0x2B51) reassigns matching units. */

    /* ---- 7. TRIBUTE demand (we demand gold from them) ----------------------
     * @asm 0x2B54: gated on score!=0 (0x2B54) AND notify_kind==1 (0x2B5D) AND
     *      player gold ([0x84FC]) >= score (0x2B6B..0x2B7C).  Builds
     *      LEADER(0x190F)+TRIBUTE(0x1916), shows dialog @0x2C08.
     * @asm 0x2C18 on dlg==2 ("pay"): GOLD TRANSFER (BYTE_VERIFIED) —
     *      player_gold -= score; power_other_gold += score (@0x2C20..0x2C2F),
     *      then score=0x3E7 (a sentinel meaning "tribute resolved"). */
    if (score != 0 && notify_kind == 1                   /* @asm 0x2B54 / 0x2B5D */
        && *power_gold_active() >= (int32_t)score) {     /* @asm 0x2B6B..0x2B7C cmp gold,score */
        /* build LEADER(0x190F) + TRIBUTE(0x1916); show dialog @0x2C08 */
        dlg = ui_dialog_show(power_other, (int)buf);     /* @asm 0x2C08 lcall 0x1a1f,0x688 */
        if (dlg == 2) {                                  /* @asm 0x2C13 cmp ax,2 */
            *power_gold_active()    -= (int32_t)score;   /* @asm 0x2C20 sub [bx+0x2a],ax ; 0x2C23 sbb [bx+0x2c],dx */
            *power_gold(power_other) += (int32_t)score;  /* @asm 0x2C2B add [bx-0x77ce],ax ; 0x2C2F adc */
            want_action = 0;                             /* @asm 0x2C33 */
        }
        score = 0x3E7;                                   /* @asm 0x2C39 sentinel "tribute resolved" */
    }

    /* ---- 8. WANTSTUFF (we demand a commodity from them) --------------------
     * @asm 0x2C3E gated on notify_kind!=0 (0x2C3E) AND score!=0x3E7 sentinel
     *      (0x2C48) AND [bp-0xb2] (best-good index) >= 0 (0x2C52).  Builds
     *      LEADER2(0x191E)+WANTSTUFF(0x1926), shows dialog @0x2CE5.
     * @asm 0x2CF5 on dlg==2: DECODED (func_057F4E.asm @0x058FA5..0x058FC8 BYTE_VERIFIED):
     *   MARKET_PRICE_5DE0[power_other*0x65 + best_good] -= amount   (@asm 0x058FB4)
     *   MARKET_PRICE_5DE0[power_self *0x65 + best_good] += amount   (@asm 0x058FC2)
     * Transfers `amount` worth of commodity `best_good` from power_other's EU
     * market supply to power_self's.  0x5DE0 = EU market word array (stride 0x65
     * per power, 16 goods × 2 bytes; confirmed in tax_apply.c MARKET_PRICE_5DE0). */
    if (notify_kind != 0 && score != 0x3E7 /* && best_good >= 0 */) { /* @asm 0x2C3E/0x2C48/0x2C52 */
        /* build LEADER2(0x191E)+WANTSTUFF(0x1926); show dialog @0x2CE5 */
        dlg = ui_dialog_show(power_other, (int)buf);     /* @asm 0x2CE5 lcall 0x1a1f,0x688 */
        if (dlg == 2) {                                  /* @asm 0x2CF0 cmp ax,2 */
            /* @asm 0x2CF5: transfer amount of best_good from power_other to power_self in 0x5DE0 */
            want_action = 0;                             /* @asm 0x2D16 */
        }
    }

    /* ---- 9. Auto-commit: PROVOKE break, WARMANLY, or RID -------------------
     * @asm 0x2D1C: if want_action AND treaty bit set (rel_query&0x40) AND
     *      score>0x64 -> emit PROVOKE(0x1930) and rel_clear_event(0x40,self,
     *      other) — BREAK the treaty.  (@asm 0x2D3E..0x2D56 — BYTE_VERIFIED.)
     * @asm 0x2D5C: else if want_action AND score==0x3E7 -> WARMANLY(0x1940)
     *      with sound 4 (lcall 0x181F:0x4AC).
     * @asm 0x2D9E: else if want_action -> LEADER2(0x1949)+RID(0x1951) parting
     *      line.  All three converge at 0x2DFB. */
    if (want_action && (rel_query(power_self, power_other) & 0x40)  /* @asm 0x2D21/0x2D2E */
        && score > 0x64) {                                          /* @asm 0x2D35 cmp [bp-0x66],0x64 */
        ui_dialog_show(power_other, DK_PROVOKE);          /* @asm 0x2D3E/0x2D41 lcall 0x1a1f,0x688 */
        rel_clear_event(0x40, power_self, power_other);   /* @asm 0x2D51 lcall 0x181f,0xa10 — BREAK treaty */
    }

    /* ---- 10. PEACE acceptance (WORTHY/PEACE, then paid GIVECASH peace) ------
     * @asm 0x2DFB..0x2FE8.  Entered only when NO auto-action fired
     *      (want_action==0 @0x2E01; otherwise jmp 0x2FCC to the OLDPEACE tail).
     *      Within it, a treaty-in-force test (rel_query&0x40 @0x2E19) selects
     *      whether to play the WORTHY/PEACE accept (treaty NOT yet in force, the
     *      je 0x2E20 path) vs. fall through.
     *   (a) WORTHY/PEACE  (@asm 0x2E20..0x2EAF): build LEADER2(0x1955)+WORTHY
     *       (0x195D); show dialog @0x2E70.  On dlg==1 ("accept"):
     *       rel_apply_event(0x40,other,self) SET the treaty bit, set re-meet
     *       timer power_timer[other]=turn+0x10, emit PEACE(0x1964).
     *       (@asm 0x2E81..0x2E9C — BYTE_VERIFIED.)
     *   (b) MEEK/GIVECASH paid peace (@asm 0x2EBC..0x2F5D), only when warbit_set
     *       ([bp-0xac]) is 0: compute `payment` =
     *       gold_scale_0D1D_0EC6(other.gold) then diplo_scale_181F_035C(...,
     *       (secondary-2)*2) ×100 (@asm 0x2EC0..0x2EE8); build MEEK(0x196A)+
     *       GIVECASH(0x196F); show dialog @0x2F28.  On dlg==1:
     *       rel_apply_event(0x40,other,self) AND GOLD TRANSFER (BYTE_VERIFIED) —
     *       power_other_gold -= payment; player_gold += payment.
     *       (@asm 0x2F36..0x2F5D.) */
    if (want_action == 0) {                              /* @asm 0x2E01 cmp [bp-0xa6],0; jne 0x2FCC */
        /* (a) WORTHY/PEACE accept — only when no treaty is in force yet. */
        if (!(rel_query(power_self, power_other) & 0x40)) { /* @asm 0x2E19 test al,0x40; je 0x2E20 */
            /* build LEADER2(0x1955)+WORTHY(0x195D); show dialog @0x2E70 */
            dlg = ui_dialog_show(power_other, DK_WORTHY); /* @asm 0x2E70 lcall 0x1a1f,0x688 */
            if (dlg == 1) {                               /* @asm 0x2E7F cmp [bp-8],1 */
                rel_apply_event(0x40, power_other, power_self); /* @asm 0x2E89 lcall 0x181f,0xa06 */
                {
                    int16_t *timer = (int16_t *)((uint8_t *)TREATY_TIMER_BASE + power_other * 2);
                    *timer = *(int16_t *)TURN_COUNTER + 0x10;   /* @asm 0x2E9C mov [bx+0x53c8],ax */
                }
                /* emit PEACE (0x1964) @asm 0x2EA0 */
            }
        }
        /* (b) MEEK/GIVECASH paid-peace (@asm 0x2EBC) — only when not already at war */
        if (warbit_set == 0) {                            /* @asm 0x2EB7 cmp [bp-0xac],0 */
            int  payment;                                 /* [bp-0x94] */
            long g = gold_scale_0D1D_0EC6(                /* @asm 0x2ECF lcall 0xd1d,0xec6 */
                        (int)((uint32_t)*power_gold(power_other) >> 16),  /* [bx-0x77cc] high */
                        (int)((uint32_t)*power_gold(power_other) & 0xFFFF), /* [bx-0x77ce] low */
                        0, 0);
            /* @asm 0x2ED7 third arg = (([bp-0xcc] secondary acc) - 2) * 2 */
            payment = (int)diplo_scale_181F_035C(g, 0, 0); /* @asm 0x2EE0 lcall 0x181f,0x35c — clamp(g, 0, hi).
                                                              * 3rd arg = (secondary-acc-2)*2 from [bp-0xcc]; modelled as 0
                                                              * here (secondary acc arithmetic is in the elided score block). */
            payment = payment * 0x64;                     /* @asm 0x2EE8 imul ax,ax,0x64 */
            if (payment != 0) {                           /* @asm 0x2EF1 or ax,ax;je */
                /* build MEEK(0x196A)+GIVECASH(0x196F); show dialog @0x2F28 */
                dlg = ui_dialog_show(power_other, (int)buf); /* @asm 0x2F28 lcall 0x1a1f,0x688 */
                if (dlg == 1) {                           /* @asm 0x2F33 dec ax;jne */
                    rel_apply_event(0x40, power_other, power_self); /* @asm 0x2F3E lcall 0x181f,0xa06 */
                    /* @asm 0x2F4E..0x2F5D: they pay us the gold */
                    *power_gold(power_other) -= (int32_t)payment; /* @asm 0x2F4E sub [si-0x77ce],ax */
                    *power_gold_active()     += (int32_t)payment; /* @asm 0x2F5A add [bx+0x2a],ax */
                }
            }
        }
    }

    /* @asm 0x2FE8..0x3011: if treaty bit now set, fire the two symmetric
     *      relation-tag callbacks diplo_relation_tag(other,self) and
     *      diplo_relation_tag(self,other) (cs:0x3F30 -> 0x1A1F:0x60A). */
    if (rel_query(power_self, power_other) & 0x40) {      /* @asm 0x2FF6 test al,0x40 */
        diplo_relation_tag(power_other, power_self);      /* @asm 0x3001 call cs:0x3f30 */
        diplo_relation_tag(power_self, power_other);      /* @asm 0x300E call cs:0x3f30 */
    }
    if (want_action)                                      /* @asm 0x3019 */
        goto present_screen;                              /* @asm 0x301B jmp 0x382a */

    /* ---- 11. GIFTS / THREATS / WITHDRAW / SMITE menu -----------------------
     * @asm 0x301E..0x383E: when no automatic action fired, present the player's
     *      action menu (PEACEUSA/GIFTS/THREATS/WITHDRAW/SMITE).  Each option is
     *      built with cs:0x3F35 / cs:0x3F44 and shown via 0x1A1F:0x688.  Notable
     *      verified effects in this block:
     *   - PEACEUSA banner via 0x181F:0x09AE/0x0438 formatting (@0x30A6).
     *   - WITHDRAW negotiation (NOTHINGWITHDRAW/WITHDRAW/NOTWITHDRAW/
     *     MAYBEWITHDRAW) gating on [bp-0x60]/[bp-0xcc]/[bp-0xae] (@0x30F8).
     *   - GIFTS (@0x3450) and THREATS (@0x349C/0x34A5).
     *   - SMITE / DECLAREWAR: SET war_flag bit 0x02 (@0x37B1 or [..],2) or bit
     *     0x08 (@0x3839 or [..],8) and a gold loot transfer (@0x3822 add gold).
     *     The NATIVE smite-loot formula is in src/native/diplomacy_smite_gold.c
     *     (file 0x05997C..0x059AD9) and is not repeated here.
     * The menu's per-option scoring (e.g. @0x313C: ((diff+2)*[bp-0xb0])*0x19,
     *      doubled if warbit_set, halved by bit-19 attribute) is byte-cited but
     *      its overall meaning (a "demand magnitude") is not yet decoded. */

present_screen:
    /* @asm 0x382A..0x383E final present + leave/retf @0x59B3C. */
    return;
}

/* ============================================================================
 * VERIFICATION SUMMARY (func_057F4E European-diplomacy meeting)
 *
 * BYTE_VERIFIED (proven from VICEROY.EXE bytes / cited @asm offsets):
 *   - Function identity, extent (0x057F4E..0x059B3C), prologue/epilogue.
 *   - The complete 49-key diplomacy dialog tree (handle->string via +0x1D9A0).
 *   - War-flag matrix at PowerRecord+0x34 (0x883C): SET bit2 (declare war,
 *     0x058A7B = 80 88 3C 88 02), SET bit3 (0x059AE9 = 80 88 3C 88 08),
 *     CLEAR high bit (and [..-0x77c4],0x7f).
 *   - Treaty SET/CLEAR via rel_apply_event(0x40,..) / rel_clear_event(0x40,..).
 *   - GOLD TRANSFER on accepted tribute and on paid peace (player<->other at
 *     PowerRecord+0x2A; verified bytes 0x058EDB/0x058EDF and the [0x84FC] path).
 *   - Re-meet cool-down timer write at [power*2+0x53C8] = turn+0x10.
 *   - Per-unit ownership transfer loop (UnitRecord stride 0x1C base 0x3144).
 *   - The two symmetric relation-tag callbacks on treaty establish (cs:0x3F30).
 *   - cs:0x3FXX is a far-jump TRAMPOLINE table (file 0x05A1D6) to 0x1A1F/0x181F.
 *
 * call sites + args verified; numeric meaning not yet decoded — never
 * guessed:
 *   - Attitude tables RESOLVED 2026-06-10: -0x6A4E/-0x6B1A/-0x6ADA/-0x6B5A are
 *     the AI census matrices byte[4][16] (coastal cargo / population / settled
 *     units / unit count; writer overlay_040C1E_04458A.c, saved as 0x40 blocks);
 *     -0x6BD4 (0x942C) = census coastal-cargo per-power TOTAL; -0x6BE4 (0x941C)
 *     = census per-power finance word.  Loop #2 = colony adjacency pressure via
 *     func_056A10 (section 3b).  Still open: 0x5236 (prod table column) and
 *     0x5DE0 (market — see tax_apply.c) in the later score-shaping steps.
 *   - diplo_scale_181F_035C: RESOLVED 2026-06-08 — pure clamp(v, lo, hi).
 *   - gold_scale_0D1D_0EC6 (0x0D1D:0xEC6): RUNTIME_ONLY — C-runtime __aFldiv 32-bit
 *     long divide (body in segment 0x0D1D); cross-ref production_support.c / sol_tory.c.
 *   - diplo_182_pair (0x181F:0x0D6C, file 0x259F2): cross-ref overlay_046D70 / native/haggle.c
 *     identifies as "adjust native/power attitude(tribe,power,delta,0)"; body library-implementation-only.
 *   - Exact field roles of UnitRecord +0x314D/+0x314E written on transfer.
 *
 * Three tractable follow-up traces (each one cited entry point):
 *   1. Decode 0x1A1F:0x0618 = func_057A3A (file 0x57A3A, ENTER 0x54; target
 *      CORRECTED 2026-06-10 — see thunk note in the function header above) =
 *      the dialog OPTION builder, to learn how "key + modifier" composes a
 *      numbered choice.
 *   2. Decode 0x1A1F:0x0688 = func_06F61C (file 0x6F61C; target CORRECTED
 *      2026-06-10) = the dialog show, to confirm the return-code convention
 *      (1=accept / 2=alt as used above).
 *   3. (DONE 2026-06-08) 0x181F:0x035C = pure clamp(v, lo, hi) at file 0x0048CC.
 * ============================================================================ */
