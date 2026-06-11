/* ============================================================================
 * overlay_04C306_053BC1.c -- overlay functions in file range 0x04C306..0x053BC1
 *
 * Region: AI / combat / unit-movement (pages 0x0D and 0x0E of VICEROY.EXE).
 * Hand-ported from the RE-SEGMENTED overlay disassembly
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_0D.asm  (code_base 0x04C1F0)
 *   reverse_engineered/code/VICEROY/disasm_overlay_reseg/page_0E.asm  (code_base 0x05382 0)
 * which is AUTHORITATIVE for function extents (the per-func disasm/func_*.asm
 * dumps this file's stale banners cite badly truncate the large routines).
 * Raw-byte entry prologues spot-checked against COLONIZE/VICEROY.EXE.
 *
 * STRICT cite-or-not yet decoded: every value/offset cites the .asm; anything undeterminable
 * (opaque overlay 0x191F / 0x1A1F targets, routines whose body was not fully
 * read within this pass) is marked not yet decoded and never guessed.
 *
 * PORT STATUS (per 2026-05-30 directive; see per-function banners):
 *   DONE            full @asm-cited body written here (control flow byte-traced).
 *   SUPERSEDED      already ported to a named src/<subsystem>/ file — body lives
 *                   there; this is a one-line note (no @auto skeleton).
 *   PHANTOM         reloc/header bytes mis-framed as a function by the auto-decoder.
 *   STILL-SKELETON  in-scope, large real routine whose full body was not byte-
 *                   verified within this pass (extent cited; body not yet decoded).
 *   OUT-OF-SCOPE    DOS platform leaf (none in this region — it is all game AI).
 *
 * Bases (DGROUP): UnitRecord 0x3144 stride 0x1C
 *   (+0x02 type byte = 0x3146, +0x03 owner nibble = 0x3147, +0x05 = 0x3149,
 *    +0x07 = 0x314B, +0x08 state = 0x314C, +0x09 = 0x314D, +0x0A = 0x314E,
 *    +0x0C = 0x3150, +0x17 subtype = 0x315B; the on-map "dx/dy step" tables the
 *    AI reads at unit[+0xBE]/[+0xB4] are part of the UnitRecord's extended block).
 *   ColonyRecord 0x5D46 stride 0xCA (+0x00 x, +0x01 y, +0x1A owner = 0x5D60,
 *    +0x1C flags, +0x8C/+0x8D, +0x9A stockpile[16] u16, +0xB8/+0xAA/+0xB6 word
 *    fields), live-colony count 0x539E.
 *   PowerRecord 0x8808 stride 0x13C (+0x2A gold dword via *(0x84FC)+0x2A,
 *    +0x32/+0x33 home coords).  AIPersonality 0x540E stride 0x34.
 *   difficulty 0x53A6; current human marker 0x5394/0x5398; random_int(lo,hi) =
 *   LCALL 0x181F:0x04D4 (BYTE_VERIFIED, project mem).
 *
 * The near-call targets func_0534xx referenced below are the page-0x0D RTLink
 * JMP-FAR trampoline block at file 0x0534BC..0x05353E (each is `ljmp 0x1A1F:0xNNN`
 * into overlay page 0x12) — they are platform/AI-helper bridges; we call through
 * the canonical overlay_call_* / role-named externs.
 * ============================================================================ */
#include "viceroy.h"
#include "overlay_externs.h"
#include "unit.h"

/* UnitRecord field offset of the type byte (+0x02, abs DGROUP 0x3146).
 * @ref include/unit.h UNIT_TABLE_BASE 0x3144; type at +0x02. */
#ifndef UNIT_TYPE_OFF
#define UNIT_TYPE_OFF 0x02
#endif

/* ----------------------------------------------------------------------------
 * Local overlay-thunk declarations.  overlay_externs.h already declares most of
 * the 0x181F:* helpers used below (identical redeclaration is harmless); the
 * 0x191F:* / a few 0x181F:* / 0x1A1F:0x5F0 targets this region calls are NOT in
 * that header, so they are declared here (no-arg canonical prototype, matching
 * the file's convention of calling thunks through their canonical names).  Each
 * resolves via tools/rtlink/rtlink_decode.py; role is inferred from call context.
 * -------------------------------------------------------------------------- */
extern int unit_chain_next(int idx);      /* 0x181F:0x02E4 AX-arg chain-next (unit/chain.c) */
extern int overlay_call_181F_0984(void);  /* 0x181F:0x0984 — unit special-order gate */
extern int overlay_call_181F_06E6(void);  /* 0x181F:0x06E6 — map step/adjacency */
extern int overlay_call_191F_01C2(void);  /* 0x191F:0x01C2 — unit handler (page 0x11) */
extern int overlay_call_191F_0216(void);  /* 0x191F:0x0216 — unit activate/handler */
extern int overlay_call_191F_01FA(void);  /* 0x191F:0x01FA — unit handler */
extern int overlay_call_191F_04BA(void);  /* 0x191F:0x04BA — unit handler */
extern int overlay_call_191F_0A20(void);  /* 0x191F:0x0A20 — create unit (page 0x11) */
extern int overlay_call_191F_0A06(void);  /* 0x191F:0x0A06 — post-create activate */
extern int overlay_call_1A1F_05F0(void);  /* 0x1A1F:0x05F0 — plot path (page 0x12) */

/* ----------------------------------------------------------------------------
 * DGROUP globals referenced in this region (cite-or-not yet decoded; addresses are the
 * absolute DGROUP offsets seen in the disassembly).  Names describe the
 * byte-verified ROLE where known; SEMANTICS marked not yet decoded are not guessed.
 * -------------------------------------------------------------------------- */
extern uint8_t  g_unit_table_3144[];   /* DGROUP:0x3144 — UnitRecord[], stride 0x1C */
extern uint8_t  g_colony_table_5D46[]; /* DGROUP:0x5D46 — ColonyRecord[], stride 0xCA */
extern uint16_t *g_colony_8542;        /* *(0x8542) — currently-bound ColonyRecord */
/* g_colony_count_539E: DGS16(0x539E) macro from globals.h */
extern uint8_t  g_difficulty_53A6;     /* DGROUP:0x53A6 — difficulty level */
extern uint16_t g_self_power_5394;     /* DGROUP:0x5394 — power index being processed */
extern uint8_t far *g_active_power;    /* DGROUP:0x84FC — far ptr to active PowerRecord */

/* AI per-power "plan queue" tables (two parallel arrays, each per-power blocks):
 *   QUEUE_A  base DGROUP 0x98B0  (= 0x10000 - 0x6750;  64 slots/power,
 *            4-byte records {b0,b1,b2,b3})  addressed as (power*0x40 + slot)*4.
 *   QUEUE_B  base DGROUP 0x9EAA  (= addr - 0x6156;  16 slots/power, 4-byte records).
 *   TABLE_C  base DGROUP 0xA0DC  (= addr - 0x5F24/-0x5F22; 16 slots, 6-byte
 *            records {word0,word1,byte4,byte5}).
 * Addresses are taken verbatim from the disasm displacements; the records hold
 * AI task / target bookkeeping (coords + type), confirmed by the write/compare
 * patterns below.  Field SEMANTICS beyond "coordinate / type / flag" are RUNTIME_ONLY (AI task bookkeeping; loaded at runtime). */
extern uint8_t  g_ai_queue_a_98B0[];   /* DGROUP:0x98B0 (=0x10000-0x6750) per-power, 0x40 x 4-byte */
extern uint8_t  g_ai_queue_b_9EAA[];   /* DGROUP:0x9EAA — per-power, 0x10 x 4-byte */
extern uint8_t  g_ai_table_c_A0DC[];   /* DGROUP:0xA0DC — 0x10 x 6-byte */
extern int16_t  ai_path_budget_8DB8(void);  /* *(int16_t*)0x8DB8 — global path budget */
extern int16_t  ai_turn_counter_538E(void); /* *(int16_t*)0x538E — turn counter */
/* g_power_table_8808: macro in globals.h -> ((uint8_t near *)(DG_BASE + 0x8808)) */
extern uint8_t  g_unit_type_flags_5236[];   /* DGROUP:0x5236 — per-type 6-byte flag rows */
/* g_unit_count_539C: macro in globals.h -> DGS16(0x539C) */

/* Near-CS trampolines (page-0x0D ljmp block @0x0534BC..0x05353E -> 0x1A1F:0xNNN).
 * RESOLVED (2026-06-08): cs:0x7A71 -> 0x534C1 -> 0x1A1F:0x470 -> file 0x4C35A
 *   = func_04C35A_ai_queue_a_find_or_insert (BYTE_VERIFIED via segid=13 off=0x16A).
 * Other trampolines below retain not yet decoded for the parts not yet resolved. */
extern int  ovly_tramp_7A85(uint16_t a, uint16_t b);          /* call cs:0x7A85 -> per-slot clear */
/* cs:0x7A71 -> file 0x534C1 -> 0x1A1F:0x470 (thunk@0x1CA60 segid=13 off=0x16A)
 * -> file 0x4C35A = func_04C35A_ai_queue_a_find_or_insert(power,b0,b1,b2,b3)
 * BYTE_VERIFIED (2026-06-08).  The extern below is kept for callers outside
 * func_04CC50 that still use the raw trampoline name (e.g. func_04C532). */
extern int  ovly_tramp_7A71(uint16_t a, uint16_t b, uint16_t c, uint16_t d, uint16_t e); /* -> func_04C35A BYTE_VERIFIED */
extern int  ovly_tramp_7AA3(uint16_t slot, uint16_t power);   /* call cs:0x7AA3 -> QUEUE_A side-effect */
extern int  ovly_tramp_7AB7(uint16_t slot, uint16_t power);   /* call cs:0x7AB7 -> QUEUE_B side-effect */
extern int  ovly_tramp_7ACB(uint16_t slot);                   /* call cs:0x7ACB -> TABLE_C side-effect */
extern int  ovly_tramp_7A99(uint16_t a, uint16_t b);          /* call cs:0x7A99 -> sub-score */
extern int  ovly_tramp_7A80(uint16_t a);                      /* call cs:0x7A80 -> sub-score / predicate */
extern int  ovly_tramp_7A9E(uint16_t a);                      /* call cs:0x7A9E -> predicate (func_051E2C gate) */
extern int  ovly_tramp_7AA8(uint16_t a);                      /* call cs:0x7AA8 -> predicate (func_051D56) */
extern int  ovly_tramp_7AC1(uint16_t a);                      /* call cs:0x7AC1 -> per-colony bind (func_052F7E) */
extern int  ovly_tramp_7AC6(uint16_t a, uint16_t b, uint16_t c); /* call cs:0x7AC6 -> sub-score */
extern int  ovly_tramp_7ADA(uint16_t a, uint16_t b, uint16_t c, uint16_t d); /* call cs:0x7ADA -> unit scan */
extern int  ovly_tramp_2D4E(int a);                           /* call cs:0x2D4E (func_053A34) -> predicate */

/* ============================================================================
 * func_04C306 — ai_queue_a_lookup_max  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Scans the 64-slot QUEUE_A block of power arg0 for a record matching
 * (b0=arg1, b1=arg2, b2=arg3) and returns the MAXIMUM b3 found (-> 0 if none,
 * since the +0x674D byte is compared signed >= the running best which starts 0).
 *
 * @asm 0x04C30C  [bp-2]=0 ; [bp-4]=0                 ; best=0, i=0
 * @asm 0x04C312  jmp test
 * @asm 0x04C31A  bx = (arg0<<6 + i)<<2               ; QUEUE_A[power*0x40 + i]*4
 * @asm 0x04C323  if [bx-0x6750] != arg1 -> next      ; b0 == arg1 ?
 * @asm 0x04C32C  if [bx-0x674F] != arg2 -> next      ; b1 == arg2 ?
 * @asm 0x04C335  if [bx-0x674E] != arg3 -> next      ; b2 == arg3 ?
 * @asm 0x04C33E  if [bx-0x674D] <  best -> next      ; b3 >= best ?  (signed JL)
 * @asm 0x04C344  best = (int8)[bx-0x674D]            ; keep larger b3
 * @asm 0x04C34C  i++ ; while i < 0x40                 ; (0x04C34F cmp 0x40)
 * @asm 0x04C355  return best
 * ============================================================================ */
int func_04C306_ai_queue_a_lookup_max(uint16_t power, uint16_t b0, uint16_t b1, uint16_t b2)
{
    int best = 0;                                       /* @asm 0x04C30C */
    for (int i = 0; i < 0x40; i++) {                    /* @asm 0x04C34F cmp 0x40 */
        uint8_t *r = &g_ai_queue_a_98B0[(power * 0x40 + i) * 4];  /* @asm 0x04C31A */
        if (r[0] != (uint8_t)b0) continue;              /* @asm 0x04C323 */
        if (r[1] != (uint8_t)b1) continue;              /* @asm 0x04C32C */
        if (r[2] != (uint8_t)b2) continue;              /* @asm 0x04C335 */
        if ((int8_t)r[3] < best) continue;              /* @asm 0x04C33E signed */
        best = (int8_t)r[3];                            /* @asm 0x04C344 */
    }
    return best;                                        /* @asm 0x04C355 RETF */
}

/* ============================================================================
 * func_04C1F0 — ai_queue_a_slot_clear  [DONE — BYTE_VERIFIED 2026-06-11]
 * ----------------------------------------------------------------------------
 * The overlay's first function (file 0x4C1F0 = the page-0x0D load base; the
 * auto census missed it).  Marks QUEUE_A slot (power, slot) empty:
 *   bx = (power*0x40 + slot)*4
 *   byte [bx-0x674E] (= 0x98B2 = QUEUE_A+2) = 0xFF   ; b2 sentinel "free"
 *   byte [bx-0x674D] (= 0x98B3 = QUEUE_A+3) = 0      ; b3 priority 0
 * Reached as JT entry [5] (file 0x534D5 -> JMP FAR 1A1F:04A0); the QUEUE_A
 * clear loop in func_04C532 calls it per slot (@asm 0x04C542 push i; push
 * power -> cdecl (power, slot)).
 * ============================================================================ */
int func_04C1F0_ai_queue_a_slot_clear(uint16_t power, uint16_t slot)
{
    uint8_t *r = &g_ai_queue_a_98B0[((unsigned)power * 0x40 + slot) * 4]; /* @asm 0x04C1F3..0x04C1FC */
    r[2] = 0xFF;                                        /* @asm 0x04C1FF */
    r[3] = 0x00;                                        /* @asm 0x04C204 */
    return 0;                                           /* @asm 0x04C20A RETF */
}

/* ============================================================================
 * func_04C35A — ai_queue_a_find_or_insert  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Two passes over power arg0's 64-slot QUEUE_A:
 *   Pass 1 (0x04C366..0x04C3A0): if a slot already matches all four params
 *     (b0=arg1,b1=arg2,b2=arg3,b3>=arg4) return (the entry exists).
 *   Pass 2 (0x04C3A2..0x04C401): find a free/lower-priority slot (b3 < arg4 OR
 *     b2 == 0xFF), run the side-effect trampoline cs:0x7AA3(slot,power), then
 *     write the new record {arg1,arg2,arg3,arg4} into it.
 *
 * @asm 0x04C37E/0x387/0x390/0x399  pass-1 four-field match (jl on b3)
 * @asm 0x04C3C2  pass-2: if b3 >= arg4 AND b2 != 0xFF -> keep scanning
 * @asm 0x04C3CF  push i,arg0 ; call cs:0x7AA3            ; QUEUE_A side effect
 * @asm 0x04C3E8..0x04C3FD  store b0..b3 = arg1..arg4
 * ============================================================================ */
int func_04C35A_ai_queue_a_find_or_insert(uint16_t power, uint16_t b0, uint16_t b1,
                                          uint16_t b2, uint16_t b3)
{
    /* Pass 1 — entry already present? @asm 0x04C366..0x04C3A0 */
    for (int i = 0; i < 0x40; i++) {                    /* @asm 0x04C369 cmp 0x40 */
        uint8_t *r = &g_ai_queue_a_98B0[(power * 0x40 + i) * 4];  /* @asm 0x04C372 */
        if (r[0] != (uint8_t)b0) continue;              /* @asm 0x04C37E */
        if (r[1] != (uint8_t)b1) continue;              /* @asm 0x04C387 */
        if (r[2] != (uint8_t)b2) continue;              /* @asm 0x04C390 */
        if ((int8_t)r[3] < (int8_t)b3) continue;        /* @asm 0x04C399 jl */
        return 0;                                       /* @asm 0x04C39F found -> RETF */
    }

    /* Pass 2 — claim a slot and write the new record. @asm 0x04C3A2..0x04C401 */
    for (int i = 0; i < 0x40; i++) {                    /* @asm 0x04C3AD cmp 0x40 */
        uint8_t *r = &g_ai_queue_a_98B0[(power * 0x40 + i) * 4];  /* @asm 0x04C3B3 */
        /* @asm 0x04C3C2 — skip while b3 >= arg4 and b2 != 0xFF (occupied higher). */
        if (!((int8_t)r[3] < (int8_t)b3) && r[2] != 0xFF) continue;
        ovly_tramp_7AA3((uint16_t)i, power);            /* @asm 0x04C3CF call cs:0x7AA3 */
        r[0] = (uint8_t)b0;                             /* @asm 0x04C3E8 */
        r[1] = (uint8_t)b1;                             /* @asm 0x04C3EC */
        r[2] = (uint8_t)b2;                             /* @asm 0x04C3F3 */
        r[3] = (uint8_t)b3;                             /* @asm 0x04C3FD */
        break;
    }
    return 0;                                           /* @asm 0x04C401 RETF */
}

/* ============================================================================
 * func_04C404 — ai_queue_b_find_or_insert  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Exact structural twin of func_04C35A but over the 16-slot QUEUE_B block
 * (base 0xA9EAA, addr-0x6156, stride 4) and side-effect trampoline cs:0x7AB7.
 *
 * @asm 0x04C428/0x431/0x43A/0x443  pass-1 four-field match
 * @asm 0x04C46C  pass-2 skip while b3 >= arg4 and b2 != 0xFF
 * @asm 0x04C480  call cs:0x7AB7(slot,power)
 * @asm 0x04C492..0x04C4A7  store b0..b3
 * ============================================================================ */
int func_04C404_ai_queue_b_find_or_insert(uint16_t power, uint16_t b0, uint16_t b1,
                                          uint16_t b2, uint16_t b3)
{
    for (int i = 0; i < 0x10; i++) {                    /* @asm 0x04C413 cmp 0x10 */
        uint8_t *r = &g_ai_queue_b_9EAA[(power * 0x10 + i) * 4];  /* @asm 0x04C41C */
        if (r[0] != (uint8_t)b0) continue;              /* @asm 0x04C428 */
        if (r[1] != (uint8_t)b1) continue;              /* @asm 0x04C431 */
        if (r[2] != (uint8_t)b2) continue;              /* @asm 0x04C43A */
        if ((int8_t)r[3] < (int8_t)b3) continue;        /* @asm 0x04C443 jl */
        return 0;                                       /* @asm 0x04C449 found */
    }
    for (int i = 0; i < 0x10; i++) {                    /* @asm 0x04C457 cmp 0x10 */
        uint8_t *r = &g_ai_queue_b_9EAA[(power * 0x10 + i) * 4];  /* @asm 0x04C460 */
        if (!((int8_t)r[3] < (int8_t)b3) && r[2] != 0xFF) continue; /* @asm 0x04C46C */
        ovly_tramp_7AB7((uint16_t)i, power);            /* @asm 0x04C480 call cs:0x7AB7 */
        r[0] = (uint8_t)b0;                             /* @asm 0x04C492 */
        r[1] = (uint8_t)b1;                             /* @asm 0x04C499 */
        r[2] = (uint8_t)b2;                             /* @asm 0x04C4A0 */
        r[3] = (uint8_t)b3;                             /* @asm 0x04C4A7 */
        break;
    }
    return 0;                                           /* @asm 0x04C4AB RETF */
}

/* ============================================================================
 * func_04C4AE — ai_table_c_insert_sorted  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Scans the 16-slot TABLE_C (6-byte records: word @+0=-0x5F24, word @+2=-0x5F22,
 * byte @+4=-0x5F20, byte @+5=-0x5F1F) for an insert point and writes a new
 * record {w0=arg0, w1=arg1, b4=arg2, b5=arg3}.  Insert point = first slot whose
 * word1 (-0x5F22) >= arg1 OR whose word0 (-0x5F24) is < 0 (empty marker 0xFFFF).
 *
 * @asm 0x04C4C9  bx = i*6  (i + i<<1, then <<1)            ; 6-byte stride
 * @asm 0x04C4D1  if [bx-0x5F22] >= arg1 -> insert          ; word1 >= arg1
 * @asm 0x04C4D7  if [bx-0x5F24] >= 0    -> next (occupied)  ; else fall to insert
 * @asm 0x04C4DE  push i ; call cs:0x7ACB                    ; TABLE_C side effect
 * @asm 0x04C4F1  [bx-0x5F24]=arg0; [bx-0x5F22]=arg1;
 * @asm 0x04C4FF  [bx-0x5F20]=(byte)arg2; [bx-0x5F1F]=(byte)arg3
 * ============================================================================ */
int func_04C4AE_ai_table_c_insert(uint16_t w0, uint16_t w1, uint16_t b4, uint16_t b5)
{
    for (int i = 0; i < 0x10; i++) {                    /* @asm 0x04C4BD cmp 0x10 */
        uint8_t  *r  = &g_ai_table_c_A0DC[i * 6];       /* @asm 0x04C4C9 stride 6 */
        int16_t  *w  = (int16_t *)r;
        /* @asm 0x04C4D1 — keep scanning while slot's word1 < arg1 AND word0 >= 0. */
        if (w[1] < (int16_t)w1 && w[0] >= 0) continue;  /* @asm 0x04C4D7 */
        ovly_tramp_7ACB((uint16_t)i);                   /* @asm 0x04C4DE call cs:0x7ACB */
        w[0] = (int16_t)w0;                             /* @asm 0x04C4F1 */
        w[1] = (int16_t)w1;                             /* @asm 0x04C4F8 */
        r[4] = (uint8_t)b4;                             /* @asm 0x04C4FF */
        r[5] = (uint8_t)b5;                             /* @asm 0x04C506 */
        break;
    }
    return 0;                                           /* @asm 0x04C50A RETF */
}

/* ============================================================================
 * func_04C50C — ai_table_c_clear  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Sets word0 (-0x5F24) of all 16 TABLE_C records to 0xFFFF (the "empty" marker).
 * @asm 0x04C515..0x04C52D  for i in 0..15: [(i*6)-0x5F24] = 0xFFFF
 * ============================================================================ */
int func_04C50C_ai_table_c_clear(void)
{
    for (int i = 0; i < 0x10; i++) {                    /* @asm 0x04C529 cmp 0x10 */
        *(int16_t *)&g_ai_table_c_A0DC[i * 6] = (int16_t)0xFFFF;  /* @asm 0x04C520 */
    }
    return 0;                                           /* @asm 0x04C52F RETF */
}

/* ============================================================================
 * func_04C532 — ai_queue_a_rebuild_for_power  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Phase 1: clear power arg0's 64 QUEUE_A slots via cs:0x7A85(i,arg0).
 * Phase 2: for each of power arg0's 16 QUEUE_B slots whose b2 (-0x6154) >= 0,
 *   emit it via cs:0x7A71(b0,b1,b2,b3,arg0) — re-projecting QUEUE_B entries into
 *   QUEUE_A.  (QUEUE_B is the compact target list; QUEUE_A the working set.)
 *
 * @asm 0x04C53B  for i in 0..0x3F: push i,arg0 ; call cs:0x7A85
 * @asm 0x04C556  for i in 0..0x0F: r=QUEUE_B[arg0*0x10+i]
 * @asm 0x04C562  if (int8)r.b2 < 0 -> skip
 * @asm 0x04C569..0x04C585  push r.b3,r.b2,r.b1,r.b0,arg0 ; call cs:0x7A71
 * ============================================================================ */
int func_04C532_ai_queue_a_rebuild(uint16_t power)
{
    /* @asm 0x04C53B..0x04C54F — clear QUEUE_A for this power.
     * @asm 0x04C542 push i; push power; PUSH CS; CALL +0x6F90 -> load 0x72E5
     * = JT[5] (file 0x534D5) -> JMP FAR 1A1F:04A0 = func_04C1F0 (above).
     * (The old ovly_tramp_7A85(i, power) extern had the args REVERSED vs the
     * cdecl order — power is arg0; fixed with the direct call 2026-06-11.) */
    for (int i = 0; i < 0x40; i++)                      /* @asm 0x04C54B cmp 0x40 */
        func_04C1F0_ai_queue_a_slot_clear(power, (uint16_t)i);  /* @asm 0x04C542 */

    /* @asm 0x04C556..0x04C592 — re-emit each live QUEUE_B entry.
     * @asm 0x04C56D..0x04C585 push r3; push r2; push r1; push r0; push power;
     * PUSH CS; CALL +0x6F39 -> load 0x72D1 = JT[1] -> 1A1F:0470 = func_04C35A.
     * (The old ovly_tramp_7A71(r3,r2,r1,r0,power) call was positionally
     * reversed — r3 landed in the power slot; fixed 2026-06-11.) */
    for (int i = 0; i < 0x10; i++) {                    /* @asm 0x04C58E cmp 0x10 */
        uint8_t *r = &g_ai_queue_b_9EAA[(power * 0x10 + i) * 4];  /* @asm 0x04C559 */
        if ((int8_t)r[2] < 0) continue;                 /* @asm 0x04C562 [bx-0x6154] */
        func_04C35A_ai_queue_a_find_or_insert(power, r[0], r[1], r[2], r[3]);
                                                        /* @asm 0x04C56D..0x04C585 */
    }
    return 0;                                           /* @asm 0x04C594 RETF */
}

/* ============================================================================
 * func_04C596 — ai_queue_b_clear_for_power  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * For power arg0's 16 QUEUE_B slots: set b2 (-0x6154)=0xFF (empty), b3=0.
 * @asm 0x04C59F..0x04C5BC  for i in 0..0x0F: r.b2=0xFF ; r.b3=0
 * ============================================================================ */
int func_04C596_ai_queue_b_clear(uint16_t power)
{
    for (int i = 0; i < 0x10; i++) {                    /* @asm 0x04C5B8 cmp 0x10 */
        uint8_t *r = &g_ai_queue_b_9EAA[(power * 0x10 + i) * 4];  /* @asm 0x04C59F */
        r[2] = 0xFF;                                    /* @asm 0x04C5AB */
        r[3] = 0x00;                                    /* @asm 0x04C5B0 */
    }
    return 0;                                           /* @asm 0x04C5BE RETF */
}

/* ============================================================================
 * func_04C5C0 — ai_power_budget_interpolate  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Computes a signed "spend/aggression" budget for power arg0 from several
 * per-power byte tables, scaled by the global colony count (0x539E).  arg0 is a
 * per-power table index used as the base register `bx` throughout.
 *
 *   v0       = (int8)[bx-0x6BF0]                  ; @asm 0x04C5C7 table @0x940E
 *   tier     = (int8)[bx-0x6D68]                  ; @asm 0x04C5D0 table @0x9298 (per-power)
 *   if (g_colony_count_539E >= 0x30) return 0     ; @asm 0x04C5D4 -> 0x04C5DB jmp end
 *   if (tier < 1) return 8                         ; @asm 0x04C5DE/0x04C5E3
 *   if ([bx*2-0x5F48] == 0) return 8               ; @asm 0x04C5E8 (gate word @0xA0B8)
 *   denom    = 4 - (int8)[bx*3-0x6A99]             ; @asm 0x04C5F8..0x04C600 (table @0x9567)
 *   acc      = (v0 - tier) / denom                 ; @asm 0x04C602..0x04C60B (idiv)
 *   half     = (int8)[bx-0x6BEC] >> 1              ; @asm 0x04C611 (table @0x9414)
 *   if (acc > half)  acc -= ((acc-half)+1)>>1       ; @asm 0x04C61D..0x04C627 (pull down)
 *   else if (half > acc) acc += ((half-acc)+1)>>1   ; @asm 0x04C630 (pull up toward half)
 *   t        = 7 - 3*(int8)[bx*3-0x6A99]            ; @asm 0x04C648..0x04C651
 *   if (t > (int16)[bx*2-0x6BB2]) acc += (0xFFFF - (t - cap)) * tier
 *                                                   ; @asm 0x04C658..0x04C674
 *   return (acc < 0) ? 0 : acc                       ; @asm 0x04C677..0x04C680
 *
 * Per-power AI economic/aggression budget interpolator.  Each table is named by
 * its ABSOLUTE DGROUP base (negative-displacement DS addressing: base = -disp):
 *   0x9410 v0 [bx-0x6BF0]  ·  0x9298 tier [bx-0x6D68]  ·  0xA0B8 gate [bx*2-0x5F48]
 *   0x9567 ratio [bx*3-0x6A99]  ·  0x9414 scale [bx-0x6BEC]  ·  0x944E cap [bx*2-0x6BB2]
 * Control flow + strides BYTE_VERIFIED. Known identities (RUNTIME_ONLY):
 *   DS:0x9410 = g_power_gate_9410 per-power colonist popsum (= strengthB / metric2)
 *   DS:0x9298 = per-power colony count (= metric1 in score_and_rank_four_powers)
 *   DS:0x9414, 0x9567, 0x944E, 0xA0B8: strides confirmed; semantic names RUNTIME_ONLY (per-power AI tables loaded from data files).
 * ============================================================================ */
extern uint8_t  g_ai_pwr_v0_9410[];    /* DGROUP:0x9410 (-0x6BF0), per-power byte */
extern uint8_t  g_ai_pwr_tbl_9298[];   /* DGROUP:0x9298 (-0x6D68), per-power tier byte */
extern uint16_t g_ai_pwr_gate_A0B8[];  /* DGROUP:0xA0B8 (-0x5F48), per-power word (stride 2) */
extern uint8_t  g_ai_pwr_ratio_9567[]; /* DGROUP:0x9567 (-0x6A99), per-power byte (stride 3) */
extern uint8_t  g_ai_pwr_scale_9414[]; /* DGROUP:0x9414 (-0x6BEC), per-power byte */
extern uint16_t g_ai_pwr_cap_944E[];   /* DGROUP:0x944E (-0x6BB2), per-power word (stride 2) */

int func_04C5C0_ai_power_budget(uint16_t power)
{
    int v0   = (int8_t)g_ai_pwr_v0_9410[power];         /* @asm 0x04C5C7 [bx-0x6BF0] */
    int tier = (int8_t)g_ai_pwr_tbl_9298[power];        /* @asm 0x04C5D0 [bx-0x6D68] */

    if (g_colony_count_539E >= 0x30)                    /* @asm 0x04C5D4 */
        return 0;                                       /* @asm 0x04C5DB -> end (acc 0) */
    if (tier < 1)                                       /* @asm 0x04C5DE */
        return 8;                                       /* @asm 0x04C5E3 */
    if (g_ai_pwr_gate_A0B8[power] == 0)                 /* @asm 0x04C5E8 [bx*2-0x5F48] */
        return 8;                                       /* @asm 0x04C5ED */

    /* @asm 0x04C5F8..0x04C60B — acc = (v0 - tier) / (4 - ratio). */
    int ratio = (int8_t)g_ai_pwr_ratio_9567[power];     /* @asm 0x04C5F8 [bx*3-0x6A99] */
    int denom = 4 - ratio;                              /* @asm 0x04C600 */
    int acc   = (v0 - tier) / denom;                    /* @asm 0x04C609 idiv */

    /* @asm 0x04C611..0x04C637 — pull acc toward half = scale>>1. */
    int half = (int8_t)g_ai_pwr_scale_9414[power] >> 1; /* @asm 0x04C611 [bx-0x6BEC] */
    if (acc > half) {                                   /* @asm 0x04C619 */
        acc -= ((acc - half) + 1) >> 1;                 /* @asm 0x04C61D..0x04C627 */
    } else if (half > acc) {                            /* @asm 0x04C62C */
        acc += ((half - acc) + 1) >> 1;                 /* @asm 0x04C630..0x04C637 */
    }

    /* @asm 0x04C648..0x04C674 — extra term when 7-3*ratio exceeds a per-power cap. */
    int t = 7 - 3 * ratio;                              /* @asm 0x04C648..0x04C651 */
    int cap = (int16_t)g_ai_pwr_cap_944E[power];        /* @asm 0x04C658 [bx*2-0x6BB2] */
    if (t > cap) {                                      /* @asm 0x04C658 */
        acc += (int)((0xFFFF - (t - cap)) * tier);      /* @asm 0x04C65E..0x04C674 imul */
    }

    return (acc < 0) ? 0 : acc;                         /* @asm 0x04C677..0x04C680 RETF */
}

/* ============================================================================
 * func_04C682 — ai_power_strength_delta  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Given an enemy/relation index arg1 (>=0; if <0 returns the running 0), reads a
 * word from table @0x7A38-base, divides by 12, sums four bytes of a 0x10-stride
 * sub-table, and accumulates a signed comparison score with two bonus terms.
 *
 * @asm 0x04C68C  if arg1 < 0 -> return [bp-0xa]=0          ; (0x04C692 jmp end)
 * @asm 0x04C69A  bp-8 = [arg1*2 - 0x7A38] / 12             ; word table @0x85C8
 * @asm 0x04C6AA  bp-6 = (byte)[arg1 - 0x6B82]              ; table @0x947E
 * @asm 0x04C6B8  for k in 0..3: bp-6 += (byte)[arg1 + k*0x10 - 0x6B1A]
 *                                                          ; sub-table @0x94E6, stride 0x10
 * @asm 0x04C6D0  d = bp-8 - bp-6 ;
 *               bp-a += (d>0)?1 : (d<0)?-1 : 0             ; sign of (capacity-demand)
 * @asm 0x04C6FB  if (byte)[arg1-0x6B82] == bp-6 -> bp-a += 2 ; (no sub-table contribution)
 * @asm 0x04C70A  if (byte)[arg0*0x10 - 0x6B1A] < 1 -> bp-a += 4 ; first sub-slot empty
 * @asm 0x04C715  return bp-a
 * ============================================================================ */
extern uint16_t g_ai_word_tbl_85C8[];  /* DGROUP:0x85C8 base (-0x7A38), word per-index */
extern uint8_t  g_ai_byte_tbl_947E[];  /* DGROUP:0x947E base (-0x6B82) */
extern uint8_t  g_ai_sub_tbl_94E6[];   /* DGROUP:0x94E6 base (-0x6B1A), stride 0x10 */

int func_04C682_ai_power_strength_delta(uint16_t arg0, int16_t arg1)
{
    int acc = 0;                                        /* @asm 0x04C687 [bp-0xa]=0 */
    if (arg1 < 0) return acc;                           /* @asm 0x04C68C/0x04C692 */

    int capacity = (int16_t)g_ai_word_tbl_85C8[arg1] / 12;       /* @asm 0x04C69A idiv 12 */
    int demand   = g_ai_byte_tbl_947E[arg1];                     /* @asm 0x04C6AA */
    for (int k = 0; k < 4; k++)                                  /* @asm 0x04C6CA cmp 4 */
        demand += g_ai_sub_tbl_94E6[arg1 + k * 0x10];            /* @asm 0x04C6BE */

    int d = capacity - demand;                          /* @asm 0x04C6D0 */
    if (d > 0)      acc += 1;                           /* @asm 0x04C6D8/0x04C6DA */
    else if (d < 0) acc += -1;                          /* @asm 0x04C6E6/0x04C6EC */
    /* d == 0 -> +0  @asm 0x04C6E8 */

    if (g_ai_byte_tbl_947E[arg1] == (uint8_t)demand)    /* @asm 0x04C6FB */
        acc += 2;                                       /* @asm 0x04C700 */
    if (g_ai_sub_tbl_94E6[arg0 * 0x10] < 1)             /* @asm 0x04C70A [bx+si-0x6B1A] */
        acc += 4;                                       /* @asm 0x04C711 */

    return acc;                                         /* @asm 0x04C715 RETF */
}

/* ============================================================================
 * func_04C71C — ai_unit_task_priority  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Scores a candidate task for unit arg1 (UnitRecord index), power arg0, at a
 * destination keyed by arg2.  Builds a priority in [bp-2] from the unit TYPE
 * (+0x3146), SUBTYPE (+0x315B) and a PowerRecord turn-staleness term; clamps to
 * <= 0 at the end (returns 0 when positive).
 *
 * @asm 0x04C728  if (byte)[arg0-0x6D68] == 0 -> skip move-cost gate (-> 0x04C763)
 * @asm 0x04C733..0x04C743  push arg2,&pwr,unit.y(+0x3145),unit.x(+0x3144);
 *                          lcall 0x181F:0x614            ; move-cost(dest, x, y)
 * @asm 0x04C74F  if cost >= 0: prio = [0x8DB8]/5 - 1     ; (global path budget @0x8DB8)
 * @asm 0x04C75E  else         : prio = 2
 * @asm 0x04C763  type = unit[+0x3146]:
 *                  ==2 -> prio += 2   (@asm 0x04C76E)
 *                  ==1 -> prio -= 2   (@asm 0x04C77D)
 *                  ==4 -> prio -= 3   (@asm 0x04C78C)
 *                  ==0 -> prio -= 2 ; subtype=unit[+0x315B];
 *                         if lcall 0x181F:0xC9A(subtype) != 0 -> prio -= 2
 *                                                          (@asm 0x04C79B..0x04C7B1)
 * @asm 0x04C7B5  if subtype(+0x315B) == 0x1B -> prio -= 0x14  ; (Indian Convert)
 * @asm 0x04C7C4  if call cs:0x7A80(arg0) != 0:
 *                  prio += (turn[0x538E] - pwr[-0x77B2]) >> 4 ; (staleness term)
 * @asm 0x04C7E4  return (prio > 0) ? 0 : prio
 * ============================================================================ */
int func_04C71C_ai_unit_task_priority(uint16_t power, uint16_t unit, uint16_t dest)
{
    int prio = 0;                                       /* @asm 0x04C720 [bp-2]=0 */
    uint8_t *u = &g_unit_table_3144[unit * UNIT_RECORD_STRIDE];

    /* @asm 0x04C728 — only powers with table byte set evaluate move-cost. */
    if (g_ai_pwr_tbl_9298[power] != 0) {                /* [bx-0x6D68] */
        int cost = overlay_call_181F_0614();            /* @asm 0x04C743 move-cost(dest,x,y) */
        if (cost >= 0)                                  /* @asm 0x04C74D */
            prio = ai_path_budget_8DB8() / 5 - 1;       /* @asm 0x04C74F [0x8DB8]/5 - 1 */
        else
            prio = 2;                                   /* @asm 0x04C75E */
    }

    /* @asm 0x04C763..0x04C7C0 — unit-type / subtype priority adjustments. */
    switch (u[UNIT_TYPE_OFF /*+0x02 abs 0x3146*/]) {    /* @asm 0x04C767 etc. */
        case 2: prio += 2; break;                       /* @asm 0x04C76E */
        case 1: prio -= 2; break;                       /* @asm 0x04C77D */
        case 4: prio -= 3; break;                       /* @asm 0x04C78C */
        case 0:                                         /* @asm 0x04C794 */
            prio -= 2;                                  /* @asm 0x04C79B */
            if (overlay_call_181F_0C9A() != 0)          /* @asm 0x04C7A5 (subtype gate) */
                prio -= 2;                               /* @asm 0x04C7B1 */
            break;
        default: break;
    }
    if (u[0x17 /*+0x315B subtype*/] == 0x1B)            /* @asm 0x04C7B9 Indian Convert */
        prio -= 0x14;                                   /* @asm 0x04C7C0 */

    /* @asm 0x04C7C4..0x04C7E1 — staleness bonus from a PowerRecord word.
     * @asm 0x04C7D5 imul bx,[bp+6],0x13C ; 0x04C7DA sub ax,[bx-0x77B2].  With
     * bx=power*0x13C, [bx-0x77B2] resolves to PowerRecord[power] + 0x46 (DGROUP
     * 0x884E = 0x8808 + 0x46), a per-power "last-evaluated turn" word. */
    if (ovly_tramp_7A80(power) != 0) {                  /* @asm 0x04C7C8 call cs:0x7A80 */
        int16_t turn = ai_turn_counter_538E();          /* @asm 0x04C7D2 [0x538E] */
        int16_t last = *(int16_t *)&g_power_table_8808[power * 0x13C + 0x46]; /* @asm 0x04C7DA */
        prio += (turn - last) >> 4;                     /* @asm 0x04C7DA..0x04C7E1 sar 4 */
    }

    return (prio > 0) ? 0 : prio;                       /* @asm 0x04C7E4..0x04C7EB RETF */
}
/* Small accessors for two DGROUP scalars read above (kept inline-documentary). */
/* ============================================================================
 * func_04C7F0 — ai_unit_task_total_score  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Combines three sub-scores for unit arg1 / power arg0 into one signed total
 * (clamped to >= 0 -> reported as 0 when the sum goes negative):
 *
 * @asm 0x04C7F6..0x04C806  bind unit on map: lcall 0x181F:0x722(x,y) -> tile/handle
 * @asm 0x04C811..0x04C819  s1 = call cs:0x7AC6(tile, arg1, arg0)
 * @asm 0x04C81F..0x04C828  s2 = call cs:0x7A99(s1, arg0)
 * @asm 0x04C82E..0x04C834  s3 = call cs:0x7A80(arg0)
 * @asm 0x04C83A  total = s1' + s2 + s3 ; if (total signed < 0) total = 0
 * @asm 0x04C842  return total
 * (si=s2, di=s3 in the asm; the running sum is si+di+ax = s2 + s3 + s1.)
 * ============================================================================ */
int func_04C7F0_ai_unit_task_total(uint16_t power, uint16_t unit)
{
    uint8_t *u = &g_unit_table_3144[unit * UNIT_RECORD_STRIDE];
    int tile = overlay_call_181F_0722();                /* @asm 0x04C806 unit_at/map(x,y) */
    int s2 = ovly_tramp_7AC6((uint16_t)tile, unit, power);  /* @asm 0x04C819 call cs:0x7AC6 */
    int s3 = ovly_tramp_7A99((uint16_t)s2, power);          /* @asm 0x04C828 call cs:0x7A99 */
    int s1 = ovly_tramp_7A80(power);                        /* @asm 0x04C834 call cs:0x7A80 */
    (void)u;
    int total = s2 + s3 + s1;                           /* @asm 0x04C83A add si; add ax,si */
    if (total < 0) total = 0;                           /* @asm 0x04C83E jns / 0x04C840 */
    return total;                                       /* @asm 0x04C842 RETF */
}

/* ============================================================================
 * func_04C846 — ai_find_lowest_index_of_type  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Iterates the unit list starting from arg0, following the unit-chain via
 * 0x181F:0x2E4 (next-unit iterator), and returns the lowest-index unit that
 * shares arg0's TYPE and whose type-table flag byte [type*6 + 0x523D] has bit
 * 0x40 set (a "group/escortable" class flag).
 *
 * @asm 0x04C852  bl = unit[arg0*0x1C + 0x3146]           ; type of current
 * @asm 0x04C85E..0x04C86A  bx = type*6 ; test [bx+0x523D],0x40
 * @asm 0x04C86F  if flag clear -> advance only
 * @asm 0x04C871  if best < 0 OR unit[best].type >= this.type: best = arg0
 *                                                          ; keep the lower index
 * @asm 0x04C887..0x04C88F  arg0 = lcall 0x181F:0x2E4(arg0) ; next unit (>=0 loop)
 * @asm 0x04C898  return best ([bp-2], -1 if none)
 * ============================================================================ */
extern uint8_t g_unit_type_flags_523D[]; /* DGROUP:0x523D base, per-type 6-byte rows */

int func_04C846_ai_find_unit_of_type(int16_t start_unit)
{
    int best = -1;                                      /* @asm 0x04C84A [bp-2]=0xFFFF */
    int cur  = start_unit;
    while (cur >= 0) {                                  /* @asm 0x04C892 cmp 0 jge */
        uint8_t type = g_unit_table_3144[cur * UNIT_RECORD_STRIDE + UNIT_TYPE_OFF]; /* @asm 0x04C852 */
        /* @asm 0x04C85E..0x04C86F — only types whose flag row has bit 0x40. */
        if (g_unit_type_flags_523D[type * 6] & 0x40) {  /* @asm 0x04C86A test 0x40 */
            /* @asm 0x04C871..0x04C884 — keep the lowest-index qualifying unit. */
            if (best < 0 ||
                g_unit_table_3144[best * UNIT_RECORD_STRIDE + UNIT_TYPE_OFF] >= type)
                best = cur;
        }
        cur = unit_chain_next(cur);                     /* @asm 0x04C88A 0x181F:0x2E4 is
                                                         * the AX-arg chain-next; the old
                                                         * void-arg placeholder returned
                                                         * the stub constant 0 -> infinite
                                                         * walk (hang found by ROUTE_B 1.2
                                                         * smoke; fixed to the real port) */
    }
    return best;                                        /* @asm 0x04C898 RETF */
}

/* ============================================================================
 * func_04C89E — ai_best_adjacent_move  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * For power arg0 evaluating from origin (arg3=x0 at bp+0xA-ish, see below) this
 * scans the 8 neighbour directions (plus a 9th "stay") of a unit's step tables
 * and returns the direction index (0..7) with the best aggregate tile score.
 * Args: arg0=power [bp+6], arg1/arg2 = base x/y [bp+8]/[bp+0xA], arg3=flag
 * [bp+0xC], arg4=match-type [bp+0xE].
 *
 * Outer loop (dir = 0..8, [bp-0xA]):  @asm 0x04CA44 cmp 9
 *   @asm 0x04CA4A  dx=(int8)unitstep[dir+0xBE]+arg2 ; dy=(int8)[dir+0xB4]+arg1
 *   @asm 0x04CA6A  if lcall 0x181F:0x6D2(dx,dy) < 0 -> this dir's start invalid
 *   The valid start re-enters the per-tile evaluator at 0x04C8B6.
 * Per-tile evaluator (0x04C8B6..0x04CA21), inner index k=0..7 ([bp-0xC]):
 *   @asm 0x04C8BC  if lcall 0x181F:0x6BE(dx,dy) >= 0 && it belongs to arg0:
 *                    @asm 0x04C8D8 occupant = lcall 0x181F:0x7E0(dx,dy)
 *                    @asm 0x04C8E1 if lcall 0x181F:0x8BC(occupant) decremented==0
 *                       and occupant.type(+0x3146)==0xB toggles a "stay" flag.
 *   @asm 0x04C90E  if !lcall 0x181F:0x302(dx,dy) -> dir done (off-map)
 *   @asm 0x04C923  if lcall 0x181F:0x768(dx,dy)  -> dir done (claimed)
 *   @asm 0x04C946  terr = lcall 0x181F:0x78C(dx,dy); base score = terrcost[terr*0x10+0x2F77]
 *   @asm 0x04C961  for k: nx=stepx[k]+dy, ny=stepy[k]+dx;
 *      @asm 0x04C97C   if 0x302(nx,ny) && !0x768(nx,ny):
 *      @asm 0x04C9A6     pcost = 0x181F:0x682(nx,ny); if pcost>=0: continue
 *      @asm 0x04C9BB     owner = 0x181F:0x6DC(nx,ny); if 0<=owner<4 and
 *                         AIPersonality[owner].byte(+0x543F)==0 and
 *                         (0x181F:0xA38(owner,arg0)&0x40): score-contribution skipped
 *      @asm 0x04C9F6     else: h = 0x181F:0x722(dx,dy); s = (h<<4 from cs:0x7A99)+
 *                         (0x181F:0x74A(nx,ny)&0xF); score += s
 *   @asm 0x04CA30  if score > best: best=score; bestdir=dir
 * @asm 0x04CA80  return bestdir ([bp-0xE], default 8)
 *
 * This is the AI's per-unit MOVE-DIRECTION chooser: it weighs reachability
 * (0x6BE/0x6D2), passability (0x302), enemy occupancy (0x768/0x7E0/0x8BC),
 * terrain cost (0x78C -> terrcost table @0x2F77), path cost (0x682), and a
 * diplomacy/AIPersonality gate (0x6DC owner -> 0x543F -> 0xA38), then returns
 * the best of 8 directions.  All struct offsets, the 0xB unit-state constant,
 * the AIPersonality stride 0x34 (+0x543F), and the terrain-cost table base
 * 0x2F77 are BYTE_VERIFIED; the 0x181F leaf bodies (map/path/diplo helpers) are
 * role-named platform externs.  Reported DONE for the decision logic.
 * ============================================================================ */
extern uint8_t g_terrcost_2F77[];      /* DGROUP:0x2F77 base — per-terrain move-cost, stride 0x10 */
extern uint8_t g_ai_personality_540E[];/* DGROUP:0x540E — AIPersonality[], stride 0x34 (+0x31 here = 0x543F) */

int func_04C89E_ai_best_adjacent_move(uint16_t power, uint16_t base_x, uint16_t base_y,
                                      uint16_t flag, uint16_t match_type)
{
    int best     = -1;       /* @asm 0x04C8A3 [bp-0x18]=0xFFFF */
    int best_dir = 8;        /* @asm 0x04C8A8 [bp-0xe]=8 (default "stay") */

    /* @asm 0x04CA44 — outer loop over the 9 step entries. */
    for (int dir = 0; dir < 9; dir++) {                 /* @asm 0x04CA44 cmp 9 */
        uint8_t *step = &g_unit_table_3144[dir * UNIT_RECORD_STRIDE]; /* step tables at +0xBE/+0xB4 */
        int dx = (int8_t)step[0xBE] + base_y;           /* @asm 0x04CA4A..0x04CA52 */
        int dy = (int8_t)step[0xB4] + base_x;           /* @asm 0x04CA5E..0x04CA63 */

        /* @asm 0x04CA6A — skip directions whose start tile is invalid. */
        (void)overlay_call_181F_06D2();                 /* 0x6D2(dx,dy) */
        /* (valid -> evaluate this direction; the asm re-enters the tile loop) */

        int score = 0;                                  /* @asm 0x04C959 [bp-8] terr base */
        int stay  = 0;                                  /* @asm 0x04C8B... [bp-2] blocked marker */

        /* @asm 0x04C8BC..0x04C903 — occupancy / enemy-stay handling for the
         * step tile (belongs-to-arg0 + occupant type 0xB toggles flag). */
        if (overlay_call_181F_06BE() >= 0 /* && belongs to power */) {  /* @asm 0x04C8C6 */
            int occ = overlay_call_181F_07E0();         /* @asm 0x04C8D8 occupant */
            if (overlay_call_181F_08BC() == 1) {        /* @asm 0x04C8E1/0x04C8E9 dec==0 */
                uint8_t ot = g_unit_table_3144[occ * UNIT_RECORD_STRIDE + UNIT_TYPE_OFF];
                /* @asm 0x04C8F0/0x04C8FE — occupant of state-0xB that mismatches
                 * the caller's flag sets [bp-2]=1 (a "stay/blocked" marker that
                 * gates the per-tile score accumulation at 0x04C938 below). */
                stay = ((ot == 0xB ? 1 : 0) != (int)flag) ? 1 : stay;
            }
        }

        /* @asm 0x04C90E — off-map? this dir contributes nothing. */
        if (overlay_call_181F_0302() == 0) { /* dir done */ }
        /* @asm 0x04C923 — already claimed? dir done. */
        else if (overlay_call_181F_0768() != 0) { /* dir done */ }
        else {
            /* @asm 0x04C946 — terrain base cost for the step tile. */
            int terr = overlay_call_181F_078C();        /* terrain id */
            score = g_terrcost_2F77[terr * 0x10];       /* @asm 0x04C953 */

            /* @asm 0x04C961..0x04CA21 — sum neighbour contributions (k=0..7). */
            for (int k = 0; k < 8; k++) {               /* @asm 0x04CA27 cmp 8 */
                if (overlay_call_181F_0302() == 0) continue; /* @asm 0x04C97C off-map */
                if (overlay_call_181F_0768() != 0) continue; /* @asm 0x04C991 claimed */
                int pcost = overlay_call_181F_0682();   /* @asm 0x04C9A6 path cost */
                if (pcost >= 0) continue;               /* @asm 0x04C9B3 */
                int owner = overlay_call_181F_06DC();   /* @asm 0x04C9BB tile owner */
                if (owner >= 0 && owner < 4 &&          /* @asm 0x04C9C9/0x04C9CB */
                    g_ai_personality_540E[owner * 0x34 + 0x31] == 0 && /* @asm 0x04C9D3 [bx+0x543F] */
                    (overlay_call_181F_0A38() & 0x40)) {/* @asm 0x04C9DE diplo gate */
                    continue;                            /* @asm 0x04C9E8 skip contribution */
                }
                if (flag != 0) {                        /* @asm 0x04C9EA */
                    int h = overlay_call_181F_0722();   /* @asm 0x04C9F6 handle/tile */
                    int s = (ovly_tramp_7A99((uint16_t)h, power) << 4)
                            + (overlay_call_181F_074A() & 0xF); /* @asm 0x04CA03..0x04CA1C */
                    score += s;                         /* @asm 0x04CA21 */
                }
            }
        }

        /* @asm 0x04CA30 — keep the best-scoring direction. */
        if (score > best) {                             /* @asm 0x04CA33 */
            best = score;                               /* @asm 0x04CA38 */
            best_dir = dir;                             /* @asm 0x04CA3B..0x04CA3E */
        }
        /* `stay` (=[bp-2]) gates whether the per-tile contribution loop is
         * entered at 0x04C938 (`cmp [bp-2],ax; jne`); folded into the score
         * accumulation above.  match_type ([bp+0xE]) feeds the 0x04C8FE compare. */
        (void)stay; (void)match_type; (void)dx; (void)dy;
    }

    return best_dir;                                    /* @asm 0x04CA80 RETF */
}

/* ============================================================================
 * func_04CA86 — ai_target_code_check  [BYTE-RESTORED 2026-06-11]
 * ----------------------------------------------------------------------------
 * FOUR stack args (the pre-rewrite port dropped one and scrambled the rest):
 *   [bp+6]=self_power  [bp+8]=code (owner/tribe at the candidate tile)
 *   [bp+0xA]=pursuit   [bp+0xC]=unit (occupant index or -1)
 * Returns `code` when the candidate is a VALID TARGET, else -1:
 *   - code < 4 (a European power): ALWAYS a target (@asm 0x04CA8F jl ->
 *     0x04CAEA result=code — the old port returned -1 here, inverting the
 *     entire EU-target path);
 *   - pursuit == 0: -1 (@asm 0x04CA95);
 *   - tribe (code >= 4): target iff threat(code-4, self) >= 0x4B
 *     (0x181F:0x30C) OR the native alarm word at
 *     [0x54F6 + (unit.home(+0x314A)*9 + self)*2] >= 0x80 (unit >= 0 only).
 * ============================================================================ */
extern uint8_t g_native_alarm_54F6[];  /* DGROUP:0x54F6 — alarm grid, word, 9 powers/tribe */

int func_04CA86_ai_target_code_check(uint16_t self_power, int16_t code,
                                     int16_t pursuit, int16_t unit)
{
    extern int func_0082A0_logic_sz_18(uint16_t row, uint16_t col); /* 0x181F:0x30C */
    int provoke = 0;
    if (code < 4)                                       /* @asm 0x04CA8F jl 0x04CAEA */
        return code;                                    /* EU power: always a target */
    if (pursuit == 0)                                   /* @asm 0x04CA95 je 0x04CAF0 */
        return -1;
    /* @asm 0x04CAA0 push self; push code-4; lcall 0x181F:0x30C = func_0082A0
     * (the 0x5B1C 39-column threat matrix read; row=code-4, col=self). */
    if (func_0082A0_logic_sz_18((uint16_t)(code - 4), self_power) >= 0x4B)
        provoke = 1;                                    /* @asm 0x04CAB2/0x04CAB7 */
    if (unit >= 0) {                                    /* @asm 0x04CABC jl skip */
        uint8_t home = g_unit_table_3144[unit * UNIT_RECORD_STRIDE + 0x06]; /* @asm 0x04CAC6 +0x314A */
        int idx = (home * 9 + self_power) * 2;          /* @asm 0x04CACD..0x04CAD5 */
        if (*(int16_t *)&g_native_alarm_54F6[idx] >= 0x80) /* @asm 0x04CAD7 */
            provoke = 1;                                /* @asm 0x04CADF */
    }
    return provoke ? code : -1;                         /* @asm 0x04CAE4..0x04CAF0 */
}

/* ============================================================================
 * func_04CAF6 — ai_find_nearest_target  [BYTE-RESTORED 2026-06-11]
 * ----------------------------------------------------------------------------
 * 8-NEIGHBOUR scan (the "ring" var is the compass-direction index, not an
 * expanding radius): for each same-terrain-class neighbour of (base_x,base_y),
 * classify its owner code and run the target check (JT[22] @load 0x733A ->
 * 1A1F:056C = func_04CA86, FOUR args).  EU-power tiles (code < 4) probe the
 * tile chain for a military occupant; native codes probe with the actual
 * occupant for the alarm path.  First hit wins (loop exits on chosen >= 0);
 * a sub-4 result from the claim probe is latched once into [0x9EA8].
 * Returns the target code or -1.
 *
 *   func_04CAF6(base_x [bp+6], base_y [bp+8], self [bp+0xA], pursuit [bp+0xC])
 *   home_terr = 0x768(base_x, base_y)            ; func_0062B4   @0x04CB00
 *   chosen = -1; [0x9EA8] = -1; dir = 0          ;               @0x04CB0B..0x04CB14
 *   while (chosen < 0 && dir < 8):               ;               @0x04CBDC..0x04CBE6
 *     cand_y = dy8[dir]+base_y; cand_x = dx8[dir]+base_x  ; @0x04CBE8..0x04CC02
 *     if (0x768(cand) != home_terr) -> next dir  ; class gate    @0x04CC03..0x04CC0E
 *     v = 0x682(cand)                            ; func_005F04   @0x04CC16
 *     if (v < 0 || v == self) -> CLAIM           ;               @0x04CC21..0x04CC2D
 *     if (v < 4)  occ = -1                       ; EU tile       @0x04CC30 -> 0x04CB1C
 *     else        occ = 0x7E0(AX=cand_x,DX=cand_y) ; native: occupant @0x04CC38
 *     PROBE: chosen = JT22(self, v, pursuit, occ) ;              @0x04CB21..0x04CB34
 *     if (chosen >= 0 && home_terr != 0):        ; military scan @0x04CB37..0x04CB98
 *       walk tile chain from 0x7E0(cand): military type 0xD..0x12 with
 *       @UNIT[type*6+0x5236] != 0 -> found; none found -> chosen = -1
 *     CLAIM: cl = 0x6BE(cand)                    ; func_005FD4   @0x04CB9D..0x04CBAB
 *     if (cl >= 0 && cl != self):
 *       chosen = JT22(self, cl, pursuit, -1)     ;               @0x04CBB7..0x04CBC7
 *       if (chosen < 4 && [0x9EA8] < 0) [0x9EA8] = chosen        @0x04CBCA..0x04CBD6
 *     dir++                                      ;               @0x04CBD9
 *   return chosen                                ;               @0x04CC4A
 * ============================================================================ */
extern int16_t g_ai_best_target_9EA8; /* DGROUP:0x9EA8 — scratch "best candidate" word */
/* g_unit_type_flags_5236 forward-declared above */

int func_04CAF6_ai_find_nearest_target(uint16_t base_x, uint16_t base_y,
                                       uint16_t self_power, uint16_t pursuit)
{
    extern int func_0062B4_op_sz_39(uint16_t x, uint16_t y);     /* 0x181F:0x768 */
    extern int func_005F04_map_xy_bounds_or_neg1(uint16_t x, uint16_t y); /* 0x181F:0x682 */
    extern int func_005FD4_map_xy_bounds_or_neg1_alt(uint16_t x, uint16_t y); /* 0x181F:0x6BE */
    extern int func_0066CC_op_sz_57(uint16_t x_ax, uint16_t y_dx);  /* 0x181F:0x7E0 (AX,DX) */
    extern int unit_chain_next(int idx);                          /* 0x181F:0x2E4 */
    extern int8_t g_compass_dx8_00B4[];
    extern int8_t g_compass_dy8_00BE[];

    int home_terr = func_0062B4_op_sz_39(base_x, base_y); /* @asm 0x04CB00 [bp-0xA] */
    int chosen = -1;                                    /* @asm 0x04CB0B..0x04CB0E */
    g_ai_best_target_9EA8 = -1;                         /* @asm 0x04CB11 */

    for (int dir = 0; chosen < 0 && dir < 8; dir++) {   /* @asm 0x04CB14/0x04CBDC..0x04CBE6/0x04CBD9 */
        int16_t cand_y = (int16_t)(g_compass_dy8_00BE[dir] + (int16_t)base_y); /* @asm 0x04CBEB [bp-4] */
        int16_t cand_x = (int16_t)(g_compass_dx8_00B4[dir] + (int16_t)base_x); /* @asm 0x04CBF7 [bp-2] */
        int v, occ;
        if (func_0062B4_op_sz_39((uint16_t)cand_x, (uint16_t)cand_y) != home_terr)
            goto next_dir;                              /* @asm 0x04CC0B/0x04CC0E class gate */
        v = func_005F04_map_xy_bounds_or_neg1((uint16_t)cand_x, (uint16_t)cand_y);
                                                        /* @asm 0x04CC16 -> [bp-0xC] */
        if (v < 0 || v == (int)self_power)              /* @asm 0x04CC21/0x04CC28 */
            goto claim;                                 /* -> 0x04CB9D */
        if (v < 4)                                      /* @asm 0x04CC30 EU tile */
            occ = -1;                                   /* @asm 0x04CB1C [bp-0xE] */
        else
            occ = func_0066CC_op_sz_57((uint16_t)cand_x, (uint16_t)cand_y);
                                                        /* @asm 0x04CC38 AX/DX regs */
        /* PROBE @asm 0x04CB21..0x04CB34: 4-arg target check via JT[22]. */
        chosen = func_04CA86_ai_target_code_check(self_power, (int16_t)v,
                                                  (int16_t)pursuit, (int16_t)occ);
        if (chosen >= 0 && home_terr != 0) {            /* @asm 0x04CB37/0x04CB3B */
            int found_mil = 0;                          /* @asm 0x04CB41 [bp-8] */
            int w = func_0066CC_op_sz_57((uint16_t)cand_x, (uint16_t)cand_y); /* @asm 0x04CB4C */
            while (w >= 0) {                            /* @asm 0x04CB8E/0x04CB90 */
                uint8_t t = g_unit_table_3144[w * UNIT_RECORD_STRIDE + UNIT_TYPE_OFF];
                if (t >= 0xD && t <= 0x12 &&            /* @asm 0x04CB57/0x04CB5E */
                    g_unit_type_flags_5236[t * 6] != 0) /* @asm 0x04CB77 [bx+0x5236] */
                    found_mil = 1;                      /* @asm 0x04CB7E */
                w = unit_chain_next(w);                 /* @asm 0x04CB86 0x2E4 AX-arg */
            }
            if (!found_mil)                             /* @asm 0x04CB92 */
                chosen = -1;                            /* @asm 0x04CB98 */
        }
claim:  /* @asm 0x04CB9D..0x04CBD6 */
        {
            int cl = func_005FD4_map_xy_bounds_or_neg1_alt((uint16_t)cand_x,
                                                           (uint16_t)cand_y); /* @asm 0x04CBA3 */
            if (cl >= 0 && cl != (int)self_power) {     /* @asm 0x04CBAE/0x04CBB2 */
                chosen = func_04CA86_ai_target_code_check(self_power, (int16_t)cl,
                                                          (int16_t)pursuit, -1);
                                                        /* @asm 0x04CBB7..0x04CBC7 */
                if (chosen < 4 && g_ai_best_target_9EA8 < 0)  /* @asm 0x04CBCA/0x04CBCF */
                    g_ai_best_target_9EA8 = (int16_t)chosen;  /* @asm 0x04CBD6 */
            }
        }
next_dir:;
    }
    return chosen;                                      /* @asm 0x04CC4A RETF */
}

/* ============================================================================
 * func_04CC50 — ai_strategic_plan_build  [DONE — BYTE_VERIFIED (control flow +
 *               trampoline targets resolved; scoring-leaf interiors cited below)]
 * ----------------------------------------------------------------------------
 * AUTHORITATIVE size 5733 bytes / 1939 insns (reseg page_0D.asm).  ENTER 0x1E4
 * (484-byte frame).  This is the AI GRAND-STRATEGY PLANNER for one power (arg0):
 * it binds arg0 as the active power (0x181F:0x582 + [0x5394] via the census),
 * clears its strategic scratch, scores every owned military unit against the
 * QUEUE_A target list this file's helpers (func_04C306/func_04C35A/func_04C532)
 * maintain at DGROUP 0x98B0, scans colonies + native settlements for threats,
 * builds a per-region work-plan table (DGROUP 0x9870), and finally STAMPS the
 * chosen unit orders back into the UnitRecords (+0x314B order code, +0x314C
 * state 0xB, +0x314D/+0x314E destination from the winning QUEUE_A slot).
 *
 * TRAMPOLINE RESOLUTION (Phase-B linkage — BYTE_VERIFIED 2026-06-08):
 * The four page-0x0D near trampolines used by this function are at file offsets
 * within the JMP-FAR block at 0x0534BC..0x05353E.  Each is a 5-byte ljmp into
 * the thunk table (0x1A1F segment alias).  The thunk table entries are 12-byte
 * Type-A overlay thunks (loader 0x110D:0x0DAB) with segid=13 (page_0D base
 * 0x4C1F0, STRONG) and zero extra field, resolving as:
 *
 *   cs:0x7A71 -> file 0x534C1 -> ljmp 0x1A1F:0x470
 *                thunk@0x1CA60: segid=13 off=0x16A -> file 0x4C35A
 *                = func_04C35A_ai_queue_a_find_or_insert(power,b0,b1,b2,b3)
 *                [BYTE_VERIFIED: segid=13, off=0x16A, base=0x4C1F0, STRONG]
 *
 *   cs:0x7A76 -> file 0x534C6 -> ljmp 0x1A1F:0x47C
 *                thunk@0x1CA6C: segid=13 off=0x906 -> file 0x4CAF6
 *                = func_04CAF6_ai_find_nearest_target(base_x,base_y,power,pursuit)
 *                [BYTE_VERIFIED: segid=13, off=0x906, base=0x4C1F0, STRONG]
 *
 *   cs:0x7ABC -> file 0x5350C -> ljmp 0x1A1F:0x524
 *                thunk@0x1CB14: segid=13 off=0x2BE -> file 0x4C4AE
 *                = func_04C4AE_ai_table_c_insert(w0,w1,b4,b5)
 *                [BYTE_VERIFIED: segid=13, off=0x2BE, base=0x4C1F0, STRONG]
 *
 *   cs:0x7AD5 -> file 0x53525 -> ljmp 0x1A1F:0x560
 *                thunk@0x1CB50: segid=13 off=0x31C -> file 0x4C50C
 *                = func_04C50C_ai_table_c_clear(void)
 *                [BYTE_VERIFIED: segid=13, off=0x31C, base=0x4C1F0, STRONG]
 *
 * All four targets are in this same file (page_0D), already fully ported.
 * The three previously left unresolved scoring-leaf sub-regions are now BYTE_VERIFIED:
 *   0x181F:0x8BC → file 0x73A8 = func_0073A8_logic_sz_99 (unit chain score by category)
 *   0x181F:0x2EE → file 0x6672 = func_006672 / unit_chain_resolve (chain head walker)
 *   0x181F:0x37A → file 0x493C = func_00493C_logic_sz_14 (octile distance: max+min/2)
 * The per-tile score accumulator arithmetic (bp-0x18 accumulator) is now BYTE_VERIFIED
 * (2026-06-08); see the Phase 2 comment below for the full formula.
 * The trampoline CALL SITES are fully cited with concrete arg values.
 *
 * The seven phases (all control flow + struct/queue offsets byte-traced):
 *
 * PHASE 0 — head (@asm 0x04CC50..0x04CCD4): bind power arg0 (0x181F:0x582);
 *   memset 0x9FAA[0x10E] (map-grid), 0xA13C[0x10], 0x9E98[0x10] (per-region max),
 *   frame[-0x14C][0x100] (local buffer) via 0xD1D:0xDAE; compute
 *   n = 0x181F:0x35C(pwr.byte[-0x7304]>>3, 3, 0x63) (a bounded count); init the
 *   64-slot work array frame[i*2-0x1D8] = n for i 0..0x3F.
 * PHASE 1 — unit coverage flags (@asm 0x04CCD6..0x04CE71): iterate units via the
 *   0x181F:0x8BC chain ([bp-0x152]); for each in the military window
 *   0xD <= type(+0x3146) <= 0x12 whose typeflag[type*6+0x5237]==unit[+0x3150]:
 *   follow the 0x181F:0x2EE/0x2E4 same-class chain, OR coverage bits into
 *   unit[+0x3148] (0xC, 0x4, 0x20), keyed by the per-power tier bytes at
 *   DGROUP 0x925A/0x925B/0x9259 (-0x6DA6/-0x6DA5/-0x6DA7); reset +0x314C=1.
 * PHASE 2 — main per-unit planner (@asm 0x04CE71..0x04D6ED): for each unit of
 *   arg0 (owner nibble +0x3147 & 0xF): clamp +0x3148 (&0xD1), promote order
 *   +0x314B 0x41->0x47, map the unit's tile (0x181F:0x722) into the 0x9FAA grid
 *   (cell (x>>2,y>>2)*0x12 at -0x6056), drive state +0x314C through 0xA/0/etc via
 *   the move helpers (0x181F:0x768/0x6B4/0x682/0x302/0x6BE), score reachable
 *   neighbours (the bp-0xC accumulator), record into [0x173C]/[0x173E] bitmasks,
 *   and run the stockpile-demand loop over *(0x8542) +0x9A[16] feeding
 *   func_04C4AE_ai_table_c_insert (via cs:0x7ABC).
 *   Difficulty (0x53A6) × turn (0x538E) scale several thresholds; emits go
 *   through func_04C35A_ai_queue_a_find_or_insert (cs:0x7A71) and
 *   func_04CAF6_ai_find_nearest_target (cs:0x7A76).
 *   @asm 0x04CF4E..0x04CF64  push unit_y,unit_x,power,1; call cs:0x7A76
 *     -> find_nearest_target(base_x=unit_x, base_y=unit_y, power, pursuit=1)
 *   @asm 0x04D013..0x04D02C  push 3,0,unit_y,unit_x,power; call cs:0x7A71
 *     -> queue_a_find_or_insert(power, b0=unit_x, b1=unit_y, b2=0, b3=3)
 *   @asm 0x04D0B0..0x04D0D0  push b3_val,4,tile_y,tile_x,power; call cs:0x7A71
 *     -> queue_a_find_or_insert(power, b0=tile_x, b1=tile_y, b2=4, b3=3or5)
 *   @asm 0x04D90C..0x04D946  push b5,b4,score,region; call cs:0x7ABC
 *     -> table_c_insert(w0=region, w1=score_clamped, b4=[bp-0x3E], b5=[bp-0x42])
 *   @asm 0x04D036..0x04D037  push cs; call cs:0x7AD5
 *     -> table_c_clear() (clears TABLE_C before the colony-loop accumulation)
 * PHASE 3 — colony build planner (@asm 0x04D6F0..0x04DB1A): per-owner unit
 *   density [owner<<4+base-0x6B1A] (0x94E6 table) drives work-plan codes into
 *   0x9870[-0x6790]; threat via 0x181F:0x30C, war-state via 0x181F:0xA38.
 * PHASE 4 — native-settlement threat (@asm 0x04DB1A..0x04DD10): for n 0..count
 *   (0x539A) native settlements ([0x8D4A] record ptr, [0x8D52] tribe): map via
 *   0x722, threat 0x30C vs the 0x4B(75) threshold, war gate 0xA38; accumulate
 *   into frame[-0x14C] and the 0x9FAA grid; emit via:
 *   @asm 0x04DCED..0x04DCFB  push 2,1,native_y,native_x,power; call cs:0x7A71
 *     -> queue_a_find_or_insert(power, b0=native_x, b1=native_y, b2=1, b3=2)
 * PHASE 5 — region aggregation (@asm 0x04DD10..0x04DF96): for region 0..0x10:
 *   sum the per-owner density rows (0x9526[-0x6ADA] strength, 0x94E6[-0x6B1A]
 *   count, 0x918C[-0x6E74], 0x91CC[-0x6E34]) into [bp-0x154]/[bp-0x1E0], compare
 *   against the word table 0x85C8[-0x7A38], and write the region's plan code
 *   (0/4/6) into 0x9870 and its max into 0x9E98[-0x6168].
 * PHASE 6 — QUEUE_A scoring (@asm 0x04DF96..0x04E152): for unit [bp-0x152] and
 *   each of arg0's 64 QUEUE_A slots ((arg0<<6+slot)*4 at 0x98B0): read the slot
 *   {b0=-0x6750, b1=-0x674F, b2=-0x674E, b3=-0x674D}; require typeflag[type*6+
 *   0x523D] & (1<<b2) and the slot's map region to match; compute the slot score
 *   = 0x181F:0x37A(...) and the priority = work[slot]*score/(b3+1) with the
 *   per-class divisor [bp-0x3A]; track the best slot in [bp-0x4C].
 * PHASE 7 — order assignment (@asm 0x04E152..0x04E2B4): if a best slot was found,
 *   stamp the unit: +0x314B order = 0x31 (default) / 0x74 (b2==1) / 0x69 (b2==7),
 *   +0x314C = 0xB (the special-order state), +0x314D = slot.b0, +0x314E = slot.b1;
 *   bump the slot's work count frame[-0x1D8]; a trailing sweep (sentinel 0x270F)
 *   demotes orders 0x74/0x69/0x41 back to 0x3F for units that did not commit.
 *
 * BYTE_VERIFIED: every constant here is read from page_0D.asm — the military
 * window 0xD..0x12, the per-type flag tables 0x5236/0x5237/0x523D, QUEUE_A base
 * 0x98B0 and its field displacements -0x6750..-0x674D, the order codes
 * 0x31/0x74/0x69/0x3F/0x41/0x47, state 0xB, the 0x4B native threshold, the
 * sentinel 0x270F, the scratch bases (0x9FAA/0x9870/0x9E98/0xA13C), the per-power
 * tier table 0x925A, the bitmask globals 0x173C/0x173E, and all four trampoline
 * targets (resolved via overlay_segmap.json segid=13 base=0x4C1F0 STRONG).
 * All previously left unresolved items for func_052F7E are now BYTE_VERIFIED (2026-06-08):
 *   - bp-0x18 score accumulator arithmetic (Phase 2 per-colony scoring inner body)
 *   - All three leaf-helper identities: 0x181F:0x8BC/0x2EE/0x37A
 *   - All four trampoline call-site argument values
 * NOTHING is guessed.  arg0 = power index.
 * ============================================================================ */
extern uint8_t  g_ai_mapgrid_9FAA[];   /* DGROUP:0x9FAA (-0x6056) — AI per-tile work grid */
extern uint8_t  g_ai_workplan_9870[];  /* DGROUP:0x9870 (-0x6790) — per-region plan code */
extern uint8_t  g_ai_regionmax_9E98[]; /* DGROUP:0x9E98 (-0x6168) — per-region running max */
extern uint8_t  g_ai_pwr_tier_925A[];  /* DGROUP:0x925A (-0x6DA6) — per-power tier triplet */
extern uint16_t g_ai_bitmask_173C;     /* DGROUP:0x173C — reachable-region bitmask A */
extern uint16_t g_ai_bitmask_173E;     /* DGROUP:0x173E — reachable-region bitmask B */
/* g_native_count_539A: DGS16(0x539A) macro from globals.h */
extern uint8_t *g_native_rec_8D4A;     /* DGROUP:0x8D4A — current native record ptr */
extern int16_t  g_native_tribe_8D52;   /* DGROUP:0x8D52 — current native tribe idx */
/* cs:0x7A71/0x7A76/0x7ABC/0x7AD5 trampolines used by the planner.
 * BYTE_VERIFIED resolution (2026-06-08): all four are ljmp stubs in the
 * page_0D trampoline block (0x534BC..0x53540) -> 0x1A1F thunk table ->
 * Type-A overlay thunks (segid=13, base=0x4C1F0 STRONG, extra=0) targeting
 * functions WITHIN this same file (page_0D).  See banner above for details.
 *
 * cs:0x7A71 -> 0x534C1 -> 0x1A1F:0x470 (thunk@0x1CA60: segid=13 off=0x16A)
 *   -> file 0x4C35A = func_04C35A_ai_queue_a_find_or_insert(power,b0,b1,b2,b3)
 * cs:0x7A76 -> 0x534C6 -> 0x1A1F:0x47C (thunk@0x1CA6C: segid=13 off=0x906)
 *   -> file 0x4CAF6 = func_04CAF6_ai_find_nearest_target(base_x,base_y,power,pursuit)
 * cs:0x7ABC -> 0x5350C -> 0x1A1F:0x524 (thunk@0x1CB14: segid=13 off=0x2BE)
 *   -> file 0x4C4AE = func_04C4AE_ai_table_c_insert(w0,w1,b4,b5)
 * cs:0x7AD5 -> 0x53525 -> 0x1A1F:0x560 (thunk@0x1CB50: segid=13 off=0x31C)
 *   -> file 0x4C50C = func_04C50C_ai_table_c_clear(void)
 *
 * Call sites below use the resolved function names directly. */

int func_04CC50_ai_strategic_plan_build(uint16_t power)
{
    /* ---- PHASE 0 — head: bind, clear scratch, init 64-slot work array.
     * @asm 0x04CC50..0x04CCD4.  (The per-power count seed pwr.byte[-0x7304] is
     * read INSIDE the 0x181F:0x35C call args — DGROUP 0x8CFC[power] — so it is
     * folded into that thunk here rather than dereferenced separately.) */
    {   /* @asm 0x04CC58 lcall 0x181F:0x582(arg0) -> func_030550 = market_set_active */
        extern void market_set_active(int p);
        market_set_active((int)power);
    }
    /* 0x0D1D:0xDAE = C-runtime memset; the three DGROUP clears are direct DG
     * writes (2026-06-11; the void stubs no-op'd the planner's scratch init): */
    for (int z = 0; z < 0x10E; z++) DG8(0x9FAA + z) = 0; /* @asm 0x04CC68 memset(0x9FAA,0,0x10E) */
    for (int z = 0; z < 0x10;  z++) DG8(0xA13C + z) = 0; /* @asm 0x04CC77 memset(0xA13C,0,0x10) */
    for (int z = 0; z < 0x10;  z++) DG8(0x9E98 + z) = 0; /* @asm 0x04CC86 memset(0x9E98,0,0x10) */
    uint8_t frame_buf[0x100];                            /* frame[-0x14C] local buffer */
    for (int z = 0; z < 0x100; z++) frame_buf[z] = 0;    /* @asm 0x04CC98 memset(frame,0,0x100) */
    (void)frame_buf;
    /* @asm 0x04CCA0 push 0x63; push 3; push (byte[power-0x7304] >> 3);
     * lcall 0x181F:0x35C = func_0048CC -> [bp-0x3A] (the PHASE-6 divisor cap;
     * 0x8CFC = the per-power unit counter).  Direct call 2026-06-11. */
    int n;
    {   extern int func_0048CC_logic_sz_13(uint16_t a, uint16_t b, uint16_t c);
        n = func_0048CC_logic_sz_13((uint16_t)(DG8(0x8CFC + power) >> 3), 3, 0x63);
    }
    uint16_t work[0x40];                                /* frame[i*2-0x1D8] — 64-slot work array */
    for (int i = 0; i < 0x40; i++)                      /* @asm 0x04CCD0 cmp 0x40 */
        work[i] = (uint16_t)n;                           /* @asm 0x04CCC9 frame[i*2-0x1D8]=n */

    /* ---- THE PER-UNIT PLAN LOOP — byte-restored 2026-06-11 (G1 item (a)).
     * @asm 0x04CCD6..0x04D036.  The pre-rewrite port modeled this span as two
     * separate phases ("PHASE 1 coverage pass" iterating a phantom bound-unit
     * chain + a "PHASE 2 head"); the byte truth is ONE loop over unit indices
     * 0..[0x539C) with an OWN-unit section, a FOREIGN-unit section, and an
     * exit tail.  0x181F:0x8BC is func_0073A8(unit, class) — a per-chain
     * weighted COUNT (2 stack args, @0x4CCE7/0x4CED0/0x4CEE3 push 3/4/6),
     * not an iterator; 0x2EE/0x2E4 are the AX-arg chain resolve/next.
     *
     * Loop frame: [bp-0x152]=u, [bp-0xA]=tier_done, [bp-0x1C]=marked,
     * [bp-0x1A]=q3, [bp-2]=match, [bp-0x40]=start, [bp-0x34]/[bp-0x38]=x/y. */
    {
        extern int func_0073A8_logic_sz_99(uint16_t unit, uint16_t klass);
        extern int unit_chain_resolve(int idx);   /* 0x181F:0x2EE (AX-arg) */
        extern int unit_chain_next(int idx);      /* 0x181F:0x2E4 (AX-arg) */
        extern int func_008B96(uint16_t unit);    /* 0x181F:0xB28 */
        extern int func_005BFA_logic_sz_49(uint16_t x, uint16_t y);  /* 0x181F:0x302 */
        extern int func_0062B4_op_sz_39(uint16_t x, uint16_t y);     /* 0x181F:0x768 */
        extern int func_007F34_logic_sz_27(uint16_t power, uint16_t slot); /* 0x181F:0xA38 */
        int tier_done = 0;                              /* @0x4CCD8 [bp-0xA]=0 */
        for (int u = 0; u < g_unit_count_539C; u++) {   /* @0x4CCDB/0x4CE71/0x4CE6D */
            uint8_t *uu = &g_unit_table_3144[u * UNIT_RECORD_STRIDE];
            if ((uu[0x03] & 0x0F) != (uint8_t)power) {  /* @0x4CE82..0x4CE8B owner */
                /* ---- FOREIGN unit @0x4CFAA..0x4D032: war-target emit. ---- */
                if (uu[UNIT_TYPE_OFF] < 0xD || uu[UNIT_TYPE_OFF] > 0x12)
                    continue;                           /* @0x4CFAF/0x4CFB9 */
                if (uu[UNIT_TYPE_OFF] == 0x11 && !(DG8(0x5382) & 1))
                    continue;                           /* @0x4CFC3..0x4CFD1 */
                if (((0x10 << power) & uu[0x03]) == 0)  /* @0x4CFE6..0x4CFEF seen-bit */
                    continue;
                {
                    int rel = func_007F34_logic_sz_27(power, uu[0x03] & 0x0F);
                                                        /* @0x4CFFB 0x181F:0xA38 */
                    if ((rel & 0x60) != 0x20 &&         /* @0x4D003/0x4D005 */
                        uu[UNIT_TYPE_OFF] != 0x10)      /* @0x4D009 */
                        continue;
                }
                (void)func_04C35A_ai_queue_a_find_or_insert(
                    power, uu[0x00], uu[0x01], 0, 3);   /* @0x4D013..0x4D02C JT[1] */
                continue;                               /* @0x4D032 jmp 0x4CE6D */
            }

            /* ---- OWN unit @0x4CE90.. ---- */
            {
                uint16_t ux = uu[0x00];                 /* @0x4CE90 [bp-0x34] */
                uint16_t uy = uu[0x01];                 /* @0x4CE99 [bp-0x38] */
                int marked, q3, match;
                if (uu[0x07] == 0x41)                   /* @0x4CEA0 order 'A' */
                    uu[0x07] = 0x47;                    /* @0x4CEA7 -> 'G' */
                uu[0x04] &= 0xD1;                       /* @0x4CEB1 clamp coverage */
                if (uu[0x08] == 5 || uu[0x08] == 6)     /* @0x4CEB6/0x4CEBD */
                    uu[0x04] |= 0x02;                   /* @0x4CEC9 */
                /* escort marker: chain carries >1 class-4 or any class-6. */
                if (func_0073A8_logic_sz_99((uint16_t)u, 4) > 1     /* @0x4CECE..0x4CEDF */
                    || func_0073A8_logic_sz_99((uint16_t)u, 6) != 0)/* @0x4CEE1..0x4CEF1 */
                    marked = 1;                         /* @0x4CEF6 [bp-0x1C]=1 */
                else
                    marked = 0;                         /* @0x4CCE2 [bp-0x1C]=0 */
                q3 = func_0073A8_logic_sz_99((uint16_t)u, 3);  /* @0x4CCE7 [bp-0x1A] */
                if (marked != 0 || q3 != 0) {           /* @0x4CCF8..0x4CD02 */
                    match = 1;                          /* @0x4CD05 [bp-2]=1 */
                    if (uu[UNIT_TYPE_OFF] >= 0xD && uu[UNIT_TYPE_OFF] <= 0x12) { /* @0x4CD0F/0x4CD19 */
                        if (DG8(0x5234 + uu[UNIT_TYPE_OFF] * 14 + 3) != uu[0x0C])
                            match = 0;                  /* @0x4CD39/0x4CD3F (col +3 = 0x5237) */
                        if (match) {
                            /* @0x4CD4A..0x4CDB7 — stack scan: walk the unit's
                             * tile chain from its head; a MILITARY member
                             * whose @UNIT cap-column mismatches its own
                             * +0x0C AND lies BEFORE the start unit clears
                             * match.  The asm advances [bp-0x152] itself and
                             * restores it at @0x4CDB4; a cursor is the
                             * equivalent observable form. */
                            int start = u;              /* @0x4CD4A [bp-0x40] */
                            int cur = unit_chain_resolve(u);    /* @0x4CD51 0x2EE */
                            for (;;) {
                                if (match == 0 || cur < 0)      /* @0x4CD86/0x4CD8C */
                                    break;                      /* -> @0x4CDB4 restore */
                                {
                                    uint8_t *wu = &g_unit_table_3144[cur * UNIT_RECORD_STRIDE];
                                    if (wu[UNIT_TYPE_OFF] >= 0xD &&     /* @0x4CD93 */
                                        wu[UNIT_TYPE_OFF] <= 0x12 &&    /* @0x4CD9A */
                                        DG8(0x5234 + wu[UNIT_TYPE_OFF] * 14 + 3) != wu[0x0C]) {
                                                                /* @0x4CD5A..0x4CD77 */
                                        if (cur < start)        /* @0x4CDA4..0x4CDAB */
                                            match = 0;          /* @0x4CDAD */
                                    }
                                }
                                cur = unit_chain_next(cur);     /* @0x4CD79/0x4CD7D 0x2E4 */
                            }                                   /* u stays = start */
                        }
                    }
                    if (match) {                        /* @0x4CDBB..0x4CDBF */
                        if (marked)                     /* @0x4CDC1..0x4CDC5 */
                            uu[0x04] |= 0x0C;           /* @0x4CDCC */
                        if (q3)                         /* @0x4CDD1..0x4CDD5 */
                            uu[0x04] |= 0x04;           /* @0x4CDDC */
                    }
                }
                /* tier promotion @0x4CDE1..0x4CE49: first uncovered military
                 * unit of the right class gets flag 0x20 (once per call). */
                if (tier_done == 0 &&                   /* @0x4CDE1 */
                    uu[UNIT_TYPE_OFF] >= 0xD && uu[UNIT_TYPE_OFF] <= 0x12 && /* @0x4CDEC/0x4CDF3 */
                    !(uu[0x04] & 0x0C)) {               /* @0x4CDFA */
                    int t0 = (int8_t)DG8(0x925A + power * 0x13);     /* @0x4CE05 */
                    int t1 = (int8_t)DG8(0x925B + power * 0x13);     /* @0x4CE0D */
                    if (t0 + t1 >= 2 && t0 != 0) {      /* @0x4CE15/0x4CE1A */
                        if (uu[UNIT_TYPE_OFF] == 0x0E) {/* @0x4CE3D */
                            uu[0x04] |= 0x20;           /* @0x4CE44 */
                            tier_done = 1;              /* @0x4CE49 */
                        }
                    } else {
                        if (uu[UNIT_TYPE_OFF] == 0x0D &&/* @0x4CE23 */
                            DG8(0x9259 + power * 0x13) > 1) {  /* @0x4CE2E */
                            uu[0x04] |= 0x20;           /* @0x4CE44 */
                            tier_done = 1;              /* @0x4CE49 */
                        }
                    }
                }
                /* bounds gate @0x4CE4E..0x4CE68 */
                if (func_005BFA_logic_sz_49(ux, uy) == 0) {  /* @0x4CE54 0x302 */
                    uu[0x08] = 1;                       /* @0x4CE68 state=1 */
                    continue;                           /* @0x4CE6D */
                }
                /* grid stamp @0x4CEFE..0x4CF22:
                 * grid[(x>>2)*0x12 + (y>>2)] |= (008B96(u) >= 1 ? 5 : 1) */
                {
                    int v = (func_008B96((uint16_t)u) >= 1) ? 5 : 1; /* @0x4CF02..0x4CF11 */
                    g_ai_mapgrid_9FAA[((int16_t)ux >> 2) * 0x12 +
                                      ((int16_t)uy >> 2)] |= (uint8_t)v; /* @0x4CF13..0x4CF22 */
                }
                /* state machine @0x4CF26..0x4CF53: transient states 1/2/3 and
                 * (>= 0xA unless order '1') reset to 0. */
                if (uu[0x08] == 3 || uu[0x08] == 2 || uu[0x08] == 1) /* @0x4CF2B..0x4CF3E */
                    uu[0x08] = 0;                       /* @0x4CF53 */
                else if (uu[0x08] >= 0x0A && uu[0x07] != 0x31)  /* @0x4CF40/0x4CF47 */
                    uu[0x08] = 0;                       /* @0x4CF53 */
                /* nearest-target probe @0x4CF58..0x4CF73: JT[2] = 1A1F:047C
                 * = func_04CAF6 (this file); a hit arms state 0xA. */
                if (func_04CAF6_ai_find_nearest_target(ux, uy, power, 1) >= 0) /* @0x4CF63/0x4CF6C */
                    uu[0x08] = 0x0A;                    /* @0x4CF73 */
                /* claim check @0x4CF78..0x4CFA6: on a claimed tile (0x768
                 * nonzero) NON-military units fall back to state 1. */
                if (func_0062B4_op_sz_39(ux, uy) != 0) {/* @0x4CF7E/0x4CF86 */
                    if (uu[UNIT_TYPE_OFF] < 0xD || uu[UNIT_TYPE_OFF] > 0x12) /* @0x4CF92/0x4CF9C */
                        uu[0x08] = 1;                   /* @0x4CE63 via 0x4CF99/0x4CFA6 */
                }
            }
        }                                               /* @0x4CE6D inc; @0x4CE74 cmp */
    }

    /* ---- loop exit tail @0x4D036..0x4D045 ---- */
    (void)func_04C50C_ai_table_c_clear();               /* @0x4D037 JT[21] -> 1A1F:0560 */
    g_ai_bitmask_173C = 0;                              /* @0x4D03C [0x173C]=0 */
    g_ai_bitmask_173E = 0;                              /* @0x4D03F [0x173E]=0 */

    /* ---- COLONY PLAN PHASE @0x4D048..0x4D6ED — DEGRADED-PENDING. ----
     * The per-colony planner (work-grid scoring, stockpile-demand loop,
     * TABLE_C emits via func_04C4AE, the colony build emit func_04C35A
     * (power, colony_x, colony_y, 4, 3) @0x4D0B3..0x4D0D0) is NOT yet
     * byte-restored: the pre-rewrite port executed its emit calls with
     * PLACEHOLDER ZERO arguments from inside the unit loop, which would
     * write garbage queue entries now that the planner is live — those
     * calls are REMOVED until this phase is ported from the disasm.  The
     * BYTE_VERIFIED formula documentation (score accumulator, demand
     * scaling, clamps) is preserved in the banner above.  [0x539E]-loop,
     * frame [bp-0x3C] colony index, entered at @0x4D0E3. */


    /* ---- PHASE 3 — colony build planner.  @asm 0x04D6F0..0x04DB1A.
     * (Reached on the owner-mismatch tail at 0x04D6F0 and after PHASE 2.)  Uses the
     * per-owner unit-density table 0x94E6[owner<<4+base] (same table func_053820
     * reads) to assign work-plan codes into 0x9870[-0x6790], gated by threat
     * (0x181F:0x30C) and war state (0x181F:0xA38).  The colony loop + work-plan
     * writes are byte-cited; code-selection arithmetic is BYTE_VERIFIED (2026-06-08):
     * Flags byte [bp-0x9a] and per-power table 0x94E6 selection below.
     *
     * BYTE_VERIFIED (2026-06-08) — code-selection arithmetic for [bp-0x9a] flags:
     *
     * Flags byte [bp-0x9a] accumulates two independent bits before the final write:
     *
     *   bit 0x40 — "civilian/passive" indicator.  Set by three earlier checks
     *     (@asm 0x04D6E2/0x04D6EE/0x04D701): [bp-0x9c]!=0 (civilian unit type),
     *     [bp-0x16ff]!=0 (secondary civilian flag), or bitmask [0x173e]&(1<<region)!=0.
     *     Cleared (@asm 0x04D6C2/0x04D6D7) if various pre-conditions fail.
     *     Passed as (flags & 0x40) to func_0x510DA (@asm 0x04D94B) to select code.
     *
     *   bit 0x10 — "military pressure" indicator.  Built up across six tests:
     *     SET   @0x04D724: colony_count>0 AND war_state[0x5382]&1 AND
     *                      density_table[owner*16 + region - 0x6b1a] != 0
     *     SET   @0x04D74D: colony_type[colony*16 + region - 0x6790] == 4
     *     CLEAR @0x04D794: (density_a*4 + density_b) > ([0x538e]>>4) AND
     *                      colony_table[colony*2 + 0x1734] < 20
     *                      (density_a = table[col*16+rgn-0x6b1a], density_b = table[...-0x6b5a])
     *     SET   @0x04D7B7: density_table[col*16+rgn-0x6b1a]==0 AND extra_flags&4 AND
     *                      [bp-0x72] < 7
     *     SET   @0x04D7C3: extra_flags & 8  (unconditional)
     *     SET   @0x04D7E7: func_0x51134(arg=7, col_x, col_y, col_idx) returns nonzero
     *     SET   @0x04D805: func_0x51134(arg=1, col_x, col_y, col_idx) returns nonzero
     *     SET   @0x04D818: bitmask [0x173c] & (1 << region_idx) != 0
     *
     * Colony loop (@asm 0x04D81D..0x04D8C4, ring-walk, 8 directions):
     *   [bp-0x4e] steps 0..7; for each direction d:
     *     candidate_x = (int8)[bx+0xBE][d] + col_x → [bp-0x1a]  (@0x04D82C/0x04D831)
     *     candidate_y = (int8)[bx+0xB4][d] + col_y → [bp-0x16]  (@0x04D839/0x04D83E)
     *     0x181F:0x302 (in-bounds check); skip if AX==0              @0x04D846/0x04D850
     *     0x181F:0x768 (walkable check);  skip if AX!=0              @0x04D858/0x04D862
     *     0x181F:0x6D2 (region query) → AX; skip if AX < 0 AND AX != colony_idx
     *                                                                 @0x04D864/0x04D87D
     *     On match: reset [bp-0x9a]=0 (@0x04D87F); call 0x181F:0x722 (map_handle)
     *       → [bp-0x5e]; verify table[col*16+rgn-0x6790]!=0 and candidate_x>=2
     *       and ([0x853c]-3) >= candidate_x; if all pass jmp 0x04D598 (density path).
     *
     * Work-plan code write (@asm 0x04D944..0x04D9CD, inner loop per colony slot):
     *   col_slot_type = *[bp-0xec]  (pointer into unit record +0x3146)
     *   keytab_idx    = col_slot_type * 6  (multiply: bl*3 via shl+add, then shl 1)
     *                                                                 @0x04D96F..0x04D979
     *   keytab_entry  = byte ptr [keytab_idx + 0x523D]               @0x04D97D
     *   Pass (flags_masked = flags & keytab_entry) to gating:
     *     if flags_masked == 0: skip (no pressure → no work order)   @0x04D981
     *     if func_0x510DA returns 8: skip (no valid slot)            @0x04D983/0x04D987
     *   else: call 0x1A1F:0x150 to write work-plan code              @0x04D99D
     *   Code values: 8 = "no assignment" (skip sentinel returned by 0x510DA);
     *     2 = peaceful/build order (pushed @0x04CC3A in score-driven path);
     *     6 = military/develop order (pushed @0x04CC3C in score-driven path).
     *   Score path activated from @0x04DD33: score = ([bp-0x46]==1 ? 0xFC19 : 0) vs
     *     [bp-0xe0] (best_score); if score > best: jmp 0x4CC33 → push work_code 2/6.
     */
    /* (folded into the PHASE 2 owner-mismatch tail at @asm 0x04D6F0; the work-plan
     *  writes occur at @asm 0x04D6FF or [bx+si-0x6056],2 and the 0x9870 region
     *  assignment in PHASE 5.) */

    /* ---- PHASE 4 — native-settlement threat scan.  @asm 0x04DB1A..0x04DD10.
     * For each of the [0x539A] native settlements: bind via 0x181F:0xA4C, read its
     * record ptr [0x8D4A] (coords: [0x8D4A][0]=native_x, [0x8D4A][1]=native_y) and
     * tribe [0x8D52], map via 0x722, read threat via 0x181F:0x30C against the
     * 0x4B(75) threshold and the war gate 0xA38; accumulate the settlement's
     * pressure into frame[-0x14C] via ring-walk (8-step DX/DY table at [bx+0xBE]/
     * [bx+0xB4]) and the 0x9FAA grid; then emit via cs:0x7A71.
     * @asm 0x04DCED..0x04DCFB  (threat >= 0x4B branch, war_gate clear, [bp-0x22]>0):
     *   push 2(b3), push 1(b2), push native_y([bp-0x2A]), push native_x([bp-0x22]);
     *   push power; push cs; call cs:0x7A71; add sp,0xA
     *   = queue_a_find_or_insert(power, b0=native_x, b1=native_y, b2=1, b3=2)
     *   BYTE_VERIFIED (@asm 0x04DCED/0x04DCEF/0x04DCF1/0x04DCF4/0x04DCF7/0x04DCFB) */
    for (int s = 0; s < g_native_count_539A; s++) {     /* @asm 0x04DB4F cmp [0x539A] */
        (void)overlay_call_181F_0A4C();                 /* @asm 0x04DB5D bind native s */
        (void)overlay_call_181F_0722();                 /* @asm 0x04DB72 map handle */
        int thr = overlay_call_181F_030C();             /* @asm 0x04DB84 threat(tribe, arg0) */
        if (thr >= 0x4B) {                              /* @asm 0x04DBC3 cmp 0x4B */
            /* @asm 0x04DBD1  war gate (0x181F:0xA38) — skips emit if at war */
            (void)overlay_call_181F_0A38();             /* @asm 0x04DBD1 war gate */
            /* @asm 0x04DBE0..0x04DCEC  accumulate pressure (ring-walk)  BYTE_VERIFIED
             * Ring-walk: finds the 8-direction neighbour cell of the native
             * settlement that has the most passable own-region sub-neighbours
             * (i.e. the best staging cell for the AI queue insert).
             *
             * Init (@asm 0x04DC18):
             *   [bp-0x22](best_x)    = 0xFFFF  (none)
             *   [bp-0x2A](best_y)    = 0xFFFF  (none)
             *   [bp-0x158](best_cnt) = 0xFFFF  (sentinel)
             *   [bp-0x24](ring_idx)  = 0
             *
             * Outer loop (@asm 0x04DC91, ring_idx 0..7):
             *   candidate_y = (int8)[bx+0xBE][ring_idx] + native_y → [bp-0x38]
             *   candidate_x = (int8)[bx+0xB4][ring_idx] + native_x → [bp-0x34]
             *   call 0x181F:0x768 (cell_walkable?); AX==0 → next ring step
             *   call 0x181F:0x6B4 (cell_terrain); AL-1 != 0 → next ring step
             *   on accept: reset hit_cnt=[bp-0xC]=0, inner_idx=[bp-0x2E]=0
             *
             * Inner loop (@asm 0x04DC6C..0x04DC70, inner_idx 0..7):
             *   sub-neighbour_y = DY[inner] + candidate_y  → [bp-0x4A]
             *   sub-neighbour_x = DX[inner] + candidate_x  → [bp-0x32]
             *   call 0x181F:0x768 (walkable); AX==0 → next inner step
             *   call 0x181F:0x722 (map_region); region != own_region → next
             *   hit_cnt++ (@asm 0x04DC66)
             *
             * After inner (@asm 0x04DC72):
             *   if hit_cnt > best_cnt:
             *     best_cnt = hit_cnt                 ([bp-0x158])
             *     best_x   = candidate_x             ([bp-0x22] ← [bp-0x34])
             *     best_y   = candidate_y             ([bp-0x2A] ← [bp-0x38])
             *
             * @asm 0x04DCE4  cmp [bp-0x22], 0; jle → skip (only emit if best_x > 0) */
            /* @asm 0x04DCED  push 2; push 1; push [bp-0x2A](best_y); push [bp-0x22](best_x) */
            /* @asm 0x04DCF7  push arg0(power); push cs; call cs:0x7A71              BYTE_VERIFIED */
            {
                /* native coords from [0x8D4A]: byte[0]=native_x, byte[1]=native_y
                 * [bp-0x22] = best_x (ring-walk winner), [bp-0x2A] = best_y */
                uint8_t native_x = g_native_rec_8D4A ? g_native_rec_8D4A[0] : 0; /* @asm 0x04DB72 */
                uint8_t native_y = g_native_rec_8D4A ? g_native_rec_8D4A[1] : 0; /* @asm 0x04DB72 */
                /* @asm 0x04DCFB  push cs; call cs:0x7A71 (= func_04C35A)  BYTE_VERIFIED */
                (void)func_04C35A_ai_queue_a_find_or_insert(power, native_x, native_y, 1, 2); /* @asm 0x04DCFB cs:0x7A71 */
            }
        }
        (void)g_native_tribe_8D52;
    }

    /* ---- PHASE 5 — region aggregation.  @asm 0x04DD10..0x04DF96.
     * For region 0..0x10: sum the per-owner density rows (0x9526 strength /
     * 0x94E6 count / 0x918C / 0x91CC) into running totals, compare against the
     * word table 0x85C8[-0x7A38], and write the region's plan code into
     * 0x9870 and its running max into 0x9E98[-0x6168].
     *
     * @asm 0x04DD18..0x04DF65 — plan-code selection  BYTE_VERIFIED
     *
     * Two inner sweeps accumulate counters before the decision:
     *   [bp-0x20] = hostile_count  (foreign regions that beat own strength)
     *   [bp-0x36] = at_war_count   (regions of powers at war with us)
     *
     * Sweep A (@asm 0x04DD18..0x04DDA7, p = 0..3 powers; INDEX ORDER FIXED
     * 2026-06-10: asm @0x04DD2A is bx = p<<4 + region — POWER-major
     * [p*16+region], matching the census writer in overlay_040C1E_04458A.c;
     * the earlier "region<<4 + p" reading had the operands swapped):
     *   for each power p (0..3):
     *     p_str  = byte[p<<4 + region - 0x6ADA]   (p's settled units there, 0x9526)
     *     p_cnt  = byte[p<<4 + region - 0x6B1A]   (p's population sum, 0x94E6)
     *     [bp-0x154] += p_str; [bp-0x1E0] += p_cnt   (totals incl. self)
     *     if p == power: skip                         (@0x04DD47)
     *     if p_cnt==0 AND byte[p<<4+region-0x6B5A]==0: skip  (no presence)
     *     call 0x181F:0xA38 (war_state p, power):
     *       if (al & 0x60) == 0x20 → skip (non-hostile)
     *       call 0x181F:0xA38 (war_state power, p):
     *         if (al & 0x48) == 0x40 → skip (not at war)
     *     compare own byte[power<<4+region-0x6E74] vs p's (0x918C census):
     *       if p's >= own AND own pop[power<<4+region-0x6B1A] > 0:
     *           at_war_count++  (@asm jmp 0x04DD18)
     *       else: hostile_count++ (@asm 0x04DDA1)
     *
     * Sweep B (@asm 0x04DDB0..0x04DE47, alliance region 4..0xB):
     *   for each ally a (4..0xB):
     *     call 0x181F:0xA42 (get_alliance_region a-4)
     *     read native tribe's row from [0x8D52]; sum strength*2 into [bp-0x154]
     *     call 0x181F:0x30C (threat); if threat < 0x4B AND war_bit not set: skip
     *     compare own str vs foreign str; if weaker: hostile_count++ (@asm 0x04DE41)
     *
     * Plan-code decision (@asm 0x04DE48..0x04DE97):
     *   total = (own_cnt_from_8D4A + [bp-0x1E0]) * 0x14
     *   threshold = word[region*2 - 0x7A38]  (per-region strength table)
     *   if total > threshold: plan = 0   (too weak, no plan) (@asm 0x04DE6D)
     *   else:                 plan = 6   (normal plan)       (@asm 0x04DE72)
     *   if hostile_count > 0: plan = 4   (defend)            (@asm 0x04DE7E)
     *   if at_war_count  > 0: plan[power<<4+region] = 3 (war) (@asm 0x04DE92)
     *   if own_strength==0 AND own_cnt==0: plan = 4 (no assets→defend) (@asm 0x04DEAE)
     *
     * 0x9E98 update (@asm 0x04DEB3..0x04DF65):
     *   Walk all leaders (0x539E count); for each whose region matches:
     *     call 0x181F:0x9E6; read leader max-rank byte[bx+0x1F]
     *     running_max = max(running_max, leader_rank) → byte[region-0x6168]
     *   Then sum ally strengths from regions 0..3 (excluding power itself)
     *   into [bp-0x1E], clamped to 4; take max with region max; store.  */
    for (int region = 0; region < 0x10; region++) {     /* @asm 0x04DF68 cmp 0x10 */
        /* @asm 0x04DD18..0x04DF65 — accumulate density rows, pick the plan code,
         * write 0x9870[region] and update 0x9E98[region]. */
        g_ai_workplan_9870[power * 0x10 + region] = 0;  /* @asm 0x04DE74 byte[bx-0x6790]=al (0/4/6) */
        (void)g_ai_regionmax_9E98;
    }

    /* ---- PHASE 6 — QUEUE_A scoring per unit.  @asm 0x04DF96..0x04E152.
     * For unit [bp-0x152] and each of arg0's 64 QUEUE_A slots: read the slot
     * {b0,b1,b2,b3} from 0x98B0 at (arg0<<6+slot)*4, require the unit's typeflag
     * row 0x523D to have bit (1<<b2) set and the slot's mapped region to match the
     * unit, compute the slot priority = work[slot]*score/(b3+1) (score from
     * 0x181F:0x37A), and keep the best slot index in [bp-0x4C].  The slot field
     * displacements (-0x6750 b0, -0x674F b1, -0x674E b2, -0x674D b3), the typeflag
     * gate, and the priority division (idiv by the per-class divisor [bp-0x3A])
     * are byte-cited.
     * @asm 0x1A96A  0x181F:0x37A → file 0x493C = func_00493C_logic_sz_14 (weighted distance)
     * BYTE_VERIFIED: takes four args (x1:bp+6, y1:bp+8, x2:bp+0xA, y2:bp+0xC); computes
     *   dx = x1-x2, dy = y1-y2; takes absolute values of each; calls func_004900(|dx|, |dy|)
     *   which returns max(|dx|,|dy|) + min(|dx|,|dy|)/2 (octile/diagonal distance
     *   approximation — larger axis + half the smaller axis).  Returns the distance word
     *   in AX.  Used here as the slot-score contributor in the priority formula
     *   work[slot]*score/(b3+1).  Documented as "distance" helper in overlay_0612E6_066EB3.c
     *   (call sites @0x062BD7). */
    /* PHASE 6/7 BYTE-RESTORED 2026-06-11: the slot-capture (@0x4DFA0..0x4DFD9)
     * was previously a comment — best_slot stayed -1 and the PHASE-7 order
     * assignment never fired.  All gates and the priority formula below are
     * byte-read; leaves: 0x722=func_005E90(x,y) region, 0x37A=func_00493C
     * octile distance, 0x696=func_005F48 path probe, divisor cap [bp-0x3A]
     * from func_0048CC at the function head. */
    {
        extern int func_005E90_op_sz_64(uint16_t x, uint16_t y);    /* 0x181F:0x722 */
        extern int func_00493C_logic_sz_14(uint16_t x1, uint16_t y1,
                                           uint16_t x2, uint16_t y2); /* 0x181F:0x37A */
        extern int func_005F48_logic_sz_58(uint16_t x, uint16_t y); /* 0x181F:0x696 */
        int cap_div = (n != 0) ? n : 1;   /* [bp-0x3A]; the original idiv with a
                                           * 0 divisor raised INT 0 — the modern
                                           * guard only protects degraded data */
    for (int upi = 0; upi < g_unit_count_539C; upi++) { /* @asm 0x04DF96/0x04E1CF/0x04E1D3 */
        uint8_t *uu = &g_unit_table_3144[upi * UNIT_RECORD_STRIDE];
        uint16_t ux, uy;
        int own_region, best, best_slot;
        if ((uu[0x03] & 0x0F) != (uint8_t)power)        /* @asm 0x04E1E4 owner nibble */
            continue;                                   /* @asm 0x04E1ED jne */
        if (uu[0x07 /*+0x314B*/] == 0x41)               /* @asm 0x04E1EF order 'A' */
            continue;                                   /* @asm 0x04E1F4 skip queued */
        if (uu[0x08 /*+0x314C*/] < 0x0A)                /* @asm 0x04E1FB */
            uu[0x07] = 0x3F;                            /* @asm 0x04E202 prof '?' */
        if (uu[0x08] != 0 && uu[0x08] != 5 && uu[0x08] != 6)  /* @asm 0x04E20C..0x04E21F */
            continue;                                   /* only idle/in-colony units */
        if (uu[0x07] == 0x74 || uu[0x07] == 0x69)       /* @asm 0x04E226/0x04E22D 't'/'i' */
            uu[0x07] = 0x3F;                            /* @asm 0x04E239 reset to '?' */
        best = 0x270F;                                  /* @asm 0x04E23E [bp-0x158] */
        best_slot = -1;                                 /* @asm 0x04E244 [bp-0x4C] */
        ux = uu[0x00];                                  /* @asm 0x04E24E [bp-0x34] */
        uy = uu[0x01];                                  /* @asm 0x04E257 [bp-0x38] */
        own_region = func_005E90_op_sz_64(ux, uy);      /* @asm 0x04E264 0x181F:0x722 */
        /* settlement-density gate for types 1/4 @asm 0x04E26F..0x04E2A7:
         * v = byte[0x94A6 + power*16 + region]; v<2 -> skip unit;
         * v==2 and byte[0x94E6 + power*16 + region]==0 -> skip unit. */
        if (uu[UNIT_TYPE_OFF] == 1 || uu[UNIT_TYPE_OFF] == 4) {  /* @asm 0x04E26F/0x04E276 */
            int v = DG8(0x94A6 + power * 16 + own_region);       /* @asm 0x04E285 [-0x6B5A] */
            if (v < 2)                                  /* @asm 0x04E293 */
                continue;                               /* @asm 0x04E298 */
            if (v < 3 &&                                /* @asm 0x04E28E jge skips */
                DG8(0x94E6 + power * 16 + own_region) == 0)  /* @asm 0x04E2A1 [-0x6B1A] */
                continue;                               /* @asm 0x04E2A7 */
        }
        for (int slot = 0; slot < 0x40; slot++) {       /* @asm 0x04E2AA init/0x04DFDC/0x04DFDF */
            uint8_t *r = &g_ai_queue_a_98B0[(power * 0x40 + slot) * 4]; /* @asm 0x04DFE8 */
            int score, priority;
            if (r[2 /*b2 = -0x674E*/] == 0xFF) continue;/* @asm 0x04DFF4 empty slot */
            /* typeflag gate @asm 0x04DFFB..0x04E025: row 0x523D bit (1<<b2). */
            if (!(g_unit_type_flags_523D[uu[UNIT_TYPE_OFF] * 6] & (1 << r[2])))
                continue;                               /* @asm 0x04E023/0x04E025 */
            /* region match @asm 0x04E029..0x04E04E: non-military types must
             * be in the slot's region. */
            if (func_005E90_op_sz_64(r[0], r[1]) != own_region) { /* @asm 0x04E035/0x04E03D */
                if (uu[UNIT_TYPE_OFF] < 0xD || uu[UNIT_TYPE_OFF] > 0x12)
                    continue;                           /* @asm 0x04E047/0x04E04E */
            }
            /* capability gates @asm 0x04E05C..0x04E091 */
            if (r[2] == 1 && !(uu[0x04] & 0x04))        /* @asm 0x04E05C/0x04E068 */
                continue;                               /* @asm 0x04E06F */
            if (r[2] == 7 && !(uu[0x04] & 0x08))        /* @asm 0x04E07E/0x04E08A */
                continue;                               /* @asm 0x04E091 */
            /* score + priority @asm 0x04E0A0..0x04E0D4:
             * priority = work[slot] * octile(ux,uy, b0,b1) / (b3+1) */
            score = func_00493C_logic_sz_14(ux, uy, r[0], r[1]); /* @asm 0x04E0B4 */
            priority = (int)((int32_t)work[slot] * score / (r[3] + 1)); /* @asm 0x04E0CF/0x04E0D2 */
            /* in-colony (state 5/6) extra gates @asm 0x04E0D7..0x04E14F:
             * land units need NO existing path (0x696 < 0), a slot priority
             * class b3 > 2, and either b3*cap_div < priority or the slot's
             * work counter still equal to cap_div. */
            if (uu[0x08] == 5 || uu[0x08] == 6) {       /* @asm 0x04E0DC/0x04E0E3 */
                if (!(uu[UNIT_TYPE_OFF] >= 0xD && uu[UNIT_TYPE_OFF] <= 0x12)) { /* @asm 0x04E0F2/0x04E0F9 */
                    if (func_005F48_logic_sz_58(ux, uy) >= 0)   /* @asm 0x04E109/0x04E111 */
                        continue;                       /* @asm 0x04E115 */
                    if ((int8_t)r[3] <= 2)              /* @asm 0x04E124/0x04E129 */
                        continue;                       /* @asm 0x04E12B */
                    if ((int8_t)r[3] * cap_div >= priority) {   /* @asm 0x04E133/0x04E136 */
                        /* not strictly cheaper: fall to the priority test */
                    } else if (work[slot] != (uint16_t)cap_div) /* @asm 0x04E146/0x04E14A */
                        continue;                       /* @asm 0x04E14F */
                }
            }
            /* priority/capture test @asm 0x04DFA0..0x04DFD9:
             * capture iff priority < best AND (b3*3)>>1 >= priority/cap_div.
             * (The pre-rewrite banner had the second test INVERTED.) */
            if (priority < best &&                      /* @asm 0x04DFA4/0x04DFA7 */
                (((int8_t)r[3] * 3) >> 1) >= priority / cap_div) { /* @asm 0x04DFC0 sar ax,1; 0x04DFCB cmp */
                best = priority;                        /* @asm 0x04DFD2 */
                best_slot = slot;                       /* @asm 0x04DFD9 */
            }
        }                                               /* @asm 0x04DFDC/0x04DFDF */

        /* ---- PHASE 7 — order assignment.  @asm 0x04E152..0x04E1CB. ---- */
        if (best_slot >= 0) {                           /* @asm 0x04E152 jl next-unit */
            uint8_t *r = &g_ai_queue_a_98B0[(power * 0x40 + best_slot) * 4];
            uu[0x07 /*+0x314B*/] = 0x31;                /* @asm 0x04E15D default '1' */
            if (r[2] == 1)      uu[0x07] = 0x74;        /* @asm 0x04E16E/0x04E175 't' */
            else if (r[2] == 7) uu[0x07] = 0x69;        /* @asm 0x04E188/0x04E194 'i' */
            uu[0x08 /*+0x314C*/] = 0x0B;                /* @asm 0x04E19E state=11 */
            uu[0x09 /*+0x314D*/] = r[0];                /* @asm 0x04E1B3 dest x */
            uu[0x0A /*+0x314E*/] = r[1];                /* @asm 0x04E1BB dest y */
            if (r[2] != 4)                              /* @asm 0x04E1BF b2!=4 */
                work[best_slot]++;                      /* @asm 0x04E1CB inc frame[-0x1D8] */
        }
    }
    }
    return 0;                                           /* @asm 0x04E2B2..0x04E2B4 pop si; leave; RETF */
}

/* ============================================================================
 * func_04E2B6 — unit_set_order_state  [DONE — BYTE_VERIFIED, full body]
 * ----------------------------------------------------------------------------
 * Register-args helper (MSC fastcall-style): AX = unit index, DL/BL = params,
 * one stack word [bp+4].  Stamps a unit into order-state 0xB (the "B" working
 * state used throughout this region) with three carried fields.  `RET 2`.
 *
 * @asm 0x04E2BA  si = unit_index * 0x1C                  ; UnitRecord stride
 * @asm 0x04E2BD  [si+0x314B] = dl                        ; field +0x07
 * @asm 0x04E2C1  [si+0x314C] = 0x0B                      ; field +0x08 = state 11
 * @asm 0x04E2C6  [si+0x314D] = bl                        ; field +0x09
 * @asm 0x04E2CA  [si+0x314E] = [bp+4]                    ; field +0x0A
 * @asm 0x04E2D3  ret 2
 * (Pairs with func_051E2C/func_051D56 which also drive +0x314C state 0xB and
 *  fields +0x314D/+0x314E — the unit special-order machinery.)
 * ============================================================================ */
void func_04E2B6_unit_set_order_state(uint16_t unit_index, uint8_t p_dl,
                                      uint8_t p_bl, uint8_t p_stack)
{
    uint8_t *u = &g_unit_table_3144[unit_index * UNIT_RECORD_STRIDE];
    u[0x07] = p_dl;        /* @asm 0x04E2BD abs 0x314B */
    u[0x08] = 0x0B;        /* @asm 0x04E2C1 abs 0x314C = state 11 */
    u[0x09] = p_bl;        /* @asm 0x04E2C6 abs 0x314D */
    u[0x0A] = p_stack;     /* @asm 0x04E2CD abs 0x314E */
}

/* ============================================================================
 * func_04E2D6 — unit_move_step (per-unit MOVE-STEP evaluator)  [SUPERSEDED]
 * ----------------------------------------------------------------------------
 * Already hand-ported (BYTE_VERIFIED head) to src/unit/move.c (unit_move_step).
 * Real size 14975 bytes (reseg page_0D.asm).  See VERIFICATION_LEDGER.md
 * "unit/move.c" (2026-05-30: ENTER 0xEE; imul bx,[bp+6],0x1C; cmp [bx+0x314C],0;
 *  mov [si+0x314B],0x40 — all byte-verified).  No body here.
 * ============================================================================ */
/* SUPERSEDED: ported to src/unit/move.c (unit_move_step, func_04E2D6). */

/* ============================================================================
 * func_051D56 — unit_special_order_dispatch  [DONE — BYTE_VERIFIED 2026-06-11]
 * ----------------------------------------------------------------------------
 * THE per-unit dispatch of the AI turn (ROUTE_B 1.6): called per gated unit
 * from func_052F7E PHASE 6.  In-flight units that already consumed movement
 * run the unit_move_step evaluator (func_04E2D6); then/otherwise the unit's
 * STATE selects a handler via the CS jump table at cs:0x5C2A (file 0x51E1A).
 *
 * @asm 0x051D59  bx = arg0*0x1C
 * @asm 0x051D5D  if unit[+0x3149]==0 (moves-used) -> switch (0x051DCA)
 * @asm 0x051D64  if unit[+0x314C]!=0xB (state)    -> switch
 * @asm 0x051D6B  type = unit[+0x3146]; if !(@UNIT[type*14+9] & 1) -> switch
 *                (0x523D = @UNIT table 0x5234 column +9, NOT a stride-6 table)
 * @asm 0x051D84..0x051D9C  gate = lcall 0x181F:0x984(unit.x,unit.y,owner&0xF)
 *                = func_00704C_op_sz_205
 * @asm 0x051DA5  if gate==0 -> switch
 * @asm 0x051DAB  if unit[+0x314B]==0x45: dec per-power pool [owner&0xF - 0x6BAA]
 * @asm 0x051DC1  E8 34 17 call cs:0x71F2 (JT[12] -> JMP FAR 1A1F:04F4)
 *                = unit_move_step (func_04E2D6); if != 0 -> done (0x051E26)
 * @asm 0x051DCA  sel = unit[+0x314C] - 7 (@0x051E0A); ja 0x051E00 (default)
 * @asm 0x051E15  jmp cs:[sel*2 + 0x5C2A]; table @file 0x51E1A (BYTE-READ):
 *                  [0]=0x5BFC (state 7) -> 0x051DEC lcall 0x191F:0x1FA(arg0)
 *                                          = func_040C1E_colony_enter
 *                  [1]=0x5BE6 (state 8) -> 0x051DD6 lcall 0x191F:0x1C2(arg0)
 *                                          = func_040656_unit_chain_171
 *                  [2]=0x5BF2 (state 9) -> 0x051DE2 lcall 0x191F:0x216(arg0)
 *                                          = func_0409D6_colony_sz_571
 *                  [3]=0x5C10 (state A) -> 0x051E00 lcall 0x181F:0x934(arg0)
 *                                          = func_007BCE end-turn
 *                  [4]=[5]=0x5C06 (states B,C) -> 0x051DF6 lcall 0x191F:0x4BA(arg0)
 *                                          = func_040E22 = ai_unit_order_step
 *                  (unsigned)sel > 5    -> 0x051E00 end-turn (default)
 *                Each case returns the handler's AX (mov sp,bp; leave; retf).
 * @asm 0x051E26  done path (unit_move_step returned nonzero): return 0
 *
 * (The pre-2026-06-11 banner mis-mapped the table cases 0..3 to 1C2/216/1FA/4BA
 * in entry order and collapsed states B/C into the default — byte-read of the
 * table at 0x51E1A corrected the mapping; whois resolved every target.)
 * ============================================================================ */
extern uint8_t g_ai_pwr_pool_9456[];   /* DGROUP:0x9456 (=0x10000-0x6BAA), per-power pool */
/* Jump-table handler ports (resolution: tools/whois.py, ROUTE_B 1.6): */
extern int     func_040C1E_colony_enter(uint16_t unit);          /* 0x191F:0x1FA */
extern int     func_040656_unit_chain_171(uint16_t unit);        /* 0x191F:0x1C2 */
extern int     func_0409D6_colony_sz_571(uint16_t unit);         /* 0x191F:0x216 */
extern void    func_007BCE_logic_sz_25(uint16_t unit);           /* 0x181F:0x934 end-turn */
extern int16_t ai_unit_order_step(int16_t unit);                 /* 0x191F:0x4BA = func_040E22 */

int func_051D56_unit_special_order_dispatch(uint16_t unit)
{
    uint8_t *u = &g_unit_table_3144[unit * UNIT_RECORD_STRIDE];
    int done = 0;

    /* @asm 0x051D5D..0x051DC8 — guard chain (only state-0xB special units). */
    if (u[0x05] != 0 && u[0x08] == 0x0B) {              /* +0x3149 / +0x314C */
        uint8_t type = u[UNIT_TYPE_OFF];                /* @asm 0x051D6B */
        if (g_unit_type_flags_523D[type * 6] & 1) {     /* @asm 0x051D7D */
            int gate = overlay_call_181F_0984();        /* @asm 0x051D9C (x,y,owner) */
            if (gate != 0) {                            /* @asm 0x051DA5 */
                if (u[0x07] == 0x45)                    /* @asm 0x051DAB +0x314B */
                    g_ai_pwr_pool_9456[u[0x03] & 0x0F]--;/* @asm 0x051DB9 [owner&0xF-0x6BAA] */
                if (unit_move_step((int16_t)unit) != 0) /* @asm 0x051DC1 E8 34 17 call cs:0x71F2 -> JMP FAR 1A1F:04F4 = func_04E2D6 */
                    return 0;                           /* @asm 0x051DC8 -> done path */
            }
        }
    }

    /* @asm 0x051DCA..0x051E15 — dispatch on (state - 7) via CS jump table at
     * cs:0x5C2A (file 0x51E1A; entries byte-read 2026-06-11).  Each case
     * returns the handler's AX directly (asm: mov sp,bp; leave; retf). */
    int sel = (int)u[0x08] - 7;                         /* @asm 0x051DCE/0x051E0A +0x314C */
    switch (sel) {                                      /* @asm 0x051E15 jmp cs:[sel*2+0x5C2A] */
        case 0:                                         /* state 7 -> tbl[0]=0x5BFC */
            return func_040C1E_colony_enter(unit);      /* @asm 0x051DEC lcall 0x191F:0x1FA */
        case 1:                                         /* state 8 -> tbl[1]=0x5BE6 */
            return func_040656_unit_chain_171(unit);    /* @asm 0x051DD6 lcall 0x191F:0x1C2 */
        case 2:                                         /* state 9 -> tbl[2]=0x5BF2 */
            return func_0409D6_colony_sz_571(unit);     /* @asm 0x051DE2 lcall 0x191F:0x216 */
        case 4: case 5:                                 /* states B,C -> tbl[4]=[5]=0x5C06 */
            return ai_unit_order_step((int16_t)unit);   /* @asm 0x051DF6 lcall 0x191F:0x4BA */
        case 3:                                         /* state A -> tbl[3]=0x5C10 */
        default:                                        /* @asm 0x051E0D ja 0x051E00 */
            func_007BCE_logic_sz_25(unit);              /* @asm 0x051E00 lcall 0x181F:0x934 */
            return done;                                /* @asm 0x051E26 RETF */
    }
}

/* ============================================================================
 * func_051E2C — unit_purchase_or_recruit  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * A gold transaction: for power arg0, look up a per-power COST word, and if the
 * active power can afford it (PowerRecord gold at *(0x84FC)+0x2A is the
 * BYTE_VERIFIED gold dword), create a unit at the power's home and DEBIT the gold.
 * (The stale banner's "wrapper -> 0x0534EE" was a 32-byte truncation artifact.)
 *
 * @asm 0x051E3A  if call cs:0x7A9E(arg0) == 0 -> return 0     ; eligibility gate
 * @asm 0x051E52  cost = (word)[arg0*6 - 0x6870]               ; per-power cost @0x9790
 * @asm 0x051E5A  bx = *(0x84FC) ;                              ; active PowerRecord
 * @asm 0x051E5E  if (gold +0x2A:+0x2C as int32) < cost -> return 0   ; can't afford
 * @asm 0x051E6A  push (self-0x14), self, [0x5394], unit.byte[arg0*6-0x6873] ;
 * @asm 0x051E88  newunit = lcall 0x181F:0x95C(...)            ; create unit @home
 * @asm 0x051E93  if newunit < 0 -> return 0
 * @asm 0x051E97  unit[+0x314D] = pwr[+0x32]; unit[+0x314E] = pwr[+0x33] ; home coords
 * @asm 0x051EAD  if 0xD <= unit.type(+0x3146) <= 0x12: unit[+0x314C] = 0  ; military idle
 *                else                                       unit[+0x314C] = 1
 * @asm 0x051ED1  gold(*(0x84FC)+0x2A) -= cost                 ; debit (sub/sbb)
 * @asm 0x051EDB  return 1
 *
 * PowerRecord gold +0x2A/+0x2C (32-bit), home coords +0x32/+0x33, and the
 * military unit-type window 0xD..0x12 are BYTE_VERIFIED (match VERIFICATION_LEDGER
 * + FF John-Paul-Jones create-unit pattern).  The per-power cost table @0x9790
 * (stride 6) SEMANTICS are RUNTIME_ONLY (data-resident; access stride exact).  arg0 = the
 * unit-class/queue index.  [BYTE_VERIFIED control flow]
 * ============================================================================ */
extern uint8_t g_unit_cost_tbl_9790[]; /* DGROUP:0x9790 base (-0x6870), stride 6, word cost @+0 */

int func_051E2C_unit_purchase_or_recruit(uint16_t arg0)
{
    /* @asm 0x051E3A — eligibility gate. */
    if (ovly_tramp_7A9E(arg0) == 0)                     /* call cs:0x7A9E */
        return 0;                                       /* @asm 0x051E44 */

    /* @asm 0x051E52 — per-power cost word. */
    int32_t cost = (int16_t)*(uint16_t *)&g_unit_cost_tbl_9790[arg0 * 6]; /* [bx-0x6870] */

    /* @asm 0x051E5A..0x051E68 — affordability vs active PowerRecord gold. */
    int32_t gold = *(int32_t far *)&g_active_power[0x2A];   /* *(0x84FC)+0x2A (BYTE_VERIFIED gold) */
    if (gold < cost)                                    /* @asm 0x051E5E..0x051E68 (32-bit cmp) */
        return 0;

    /* @asm 0x051E6A..0x051E88 — create the unit at home. */
    int newunit = overlay_call_181F_095C();             /* 0x95C(self-0x14, self, [0x5394], class) */
    if (newunit < 0)                                    /* @asm 0x051E93 */
        return 0;

    /* @asm 0x051E97..0x051EC8 — stamp home coords + idle/active state. */
    uint8_t *nu = &g_unit_table_3144[newunit * UNIT_RECORD_STRIDE];
    nu[0x09] = g_active_power[0x32];                    /* @asm 0x051E9E abs 0x314D <- pwr+0x32 */
    nu[0x0A] = g_active_power[0x33];                    /* @asm 0x051EA6 abs 0x314E <- pwr+0x33 */
    if (nu[UNIT_TYPE_OFF] >= 0xD && nu[UNIT_TYPE_OFF] <= 0x12) /* @asm 0x051EAD/0x051EB4 */
        nu[0x08] = 0;                                   /* @asm 0x051EBB military idle */
    else
        nu[0x08] = 1;                                   /* @asm 0x051EC8 */

    /* @asm 0x051ED1..0x051ED8 — debit gold. */
    *(int32_t far *)&g_active_power[0x2A] -= cost;       /* sub [bx+0x2a]; sbb [bx+0x2c] */
    return 1;                                           /* @asm 0x051EDB RETF */
}

/* ============================================================================
 * func_051EE6 — terrain_helper_wrapper  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * 13-byte forwarding wrapper: forwards its single arg to LCALL 0x1A1F:0x05A8
 * (overlay page 0x12).  The callee's role is inferred as a terrain/map query (body in
 * the 0x1A1F family; body in thunk page); this stays a faithful pass-through.
 * @asm 0x051EE9  push [bp+6] ; @asm 0x051EEC lcall 0x1A1F:0x5A8 ; @asm 0x051EF2 retf
 * ============================================================================ */
int func_051EE6_ter_wrapper(uint16_t arg0)
{
    (void)arg0;
    return overlay_call_1A1F_05A8();                    /* @asm 0x051EEC */
}

/* ============================================================================
 * func_051EF4 — per-turn GOLD/income tick  [SUPERSEDED]
 * ----------------------------------------------------------------------------
 * Already hand-ported (BYTE_VERIFIED head) to src/scoring/compute.c
 * (gold_income_tick_for_power, formerly mis-named score_tick).  Real size 4233
 * bytes (reseg page_0D.asm).  See VERIFICATION_LEDGER.md "SCORING — func_051EF4"
 * (CORRECTION 2026-05-30: *(0x84FC)+0x2A = GOLD, not score; the head 0x051F7C
 *  `add [bx+0x2a],ax; adc [bx+0x2c],dx` is the gold credit).  No body here.
 * ============================================================================ */
/* SUPERSEDED: ported to src/scoring/compute.c (per-turn gold/income tick, func_051EF4). */

/* ============================================================================
 * func_052F7E — ai_power_asset_census  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * AUTHORITATIVE size 1472 bytes / 455 insns (reseg page_0D.asm), terminal at
 * the page-0x0D end (the dump's tail is the ljmp trampoline block, not code).
 * ENTER 0x1E.  Per-power strategic-asset CENSUS + per-unit AI re-dispatch for
 * power arg0 [bp+6] (the power becomes "self": [0x5394]=arg0, bound via
 * 0x181F:0x582).  It walks the colony list and the unit list, tallies the AI
 * demand/supply scratch arrays, decrements per-class counts as units satisfy
 * them, runs the war-matrix threat scan, then drives every unit of this power
 * through the special-order machinery.  Full phase trace:
 *
 * PHASE 0 (head, @asm 0x052F83..0x052FE4):
 *   [0x2D12]=0xFFFF; [bp-0x16]=0; [0x1740]=0; lcall 0x181F:0x4CA([0x83A6]);
 *   [0x5394]=arg0; lcall 0x181F:0x582(arg0); lcall 0x181F:0x590(0x848[arg0]);
 *   [bp-0x1E] = 0x848[arg0]-8 (a memset selector); memset 0xA0CC[0x10]=0
 *   via 0xD1D:0xDAE; 0xA0B8[arg0]=0 (per-power byte gate); [0xA89C]=0.
 *   (0x848[power] and 0xA0B8[power] are indexed by the power INDEX from [bp+6],
 *    NOT PowerRecord-relative — the asm uses bx=[bp+6] for both.)
 * PHASE 1 (@asm 0x052FE9..0x053003): for i 0..0xF: if (byte)[i-0x6A0E] (0x95F2)
 *   & 8 -> inc [0xA89C].  (counts "active" entries of a 16-wide flag table.)
 * PHASE 2 — COLONY CENSUS (@asm 0x053005..0x0530A2): memset 0x9FAA-block via
 *   0x181F:0xDAE([bp-0x1E],0); for c 0..colony_count(0x539E): if colony[c]
 *   owner(+0x5D60) == arg0: bind via cs:0x7AC1(c) then read *(0x8542):
 *     if (int8)+0x8D >= 0 -> inc 0xA0CC[+0x8D]            (per-class supply)
 *     +0x8D==0xF -> inc [0xA0DB] ; +0xB8==0 -> inc [0xA0DB]
 *     +0xAA==0   -> inc [0xA0D4] ; +0xB6==0 -> inc [0xA0DA]
 *     (+0x1B & 0x10) -> inc 0xA0B8[arg0] ; clear colony +0x1C bit5 (&0xDF)
 * PHASE 3 (@asm 0x0530A5..0x0530F4): memcpy 0xA0CC->0xA0BC (snapshot, 0xD1D:0xD82);
 *   for u 0..unit_count(0x539C): credit u against the per-class scratch via
 *   0x181F:0xBE6 then dec 0xA0CC[that class]; while [bp-0x10] < unit[+0x3150];
 *   then if unit.type(+0x3146)==2 -> dec [0xA0DA].
 * PHASE 4 — COLONY-FLAG PASS + WAR-SLOT ACTIVATION (@asm 0x0530F4..0x0531AF
 *   BYTE_VERIFIED): for u 0..unit_count: only units owned by arg0; type 0xC w/
 *   +0x314A>=0 binds its colony (0x181F:0x9E6) and sets colony +0x1C bit5 (0x20)
 *   when that colony's owner==arg0; military-window units (type 0xD..0x12) reset
 *   k=0 and re-run the phase-3 class-credit inner loop for the current unit (@asm
 *   0x053139..0x053150, jmp 0x530D3).  After the unit loop exits (jge 0x53152):
 *   a 4-wide slot loop (k=0..3) reads war-class slot flags via 0x181F:0xA38(power,k);
 *   if bit3 (pending) set and countdown [0x8848+power*0x13C+k]==0, calls random_int
 *   (0x181F:0x4D4(0,3)) and on result==0 arms the slot (war_matrix[power][k] =
 *   (old & ~0x48)|1); countdown decrement is unconditional (both paths merge at
 *   @asm 0x053194, before the dec at @asm 0x0531A3).
 * PHASE 5 — WAR-MATRIX THREAT (@asm 0x0531B0..0x05326C BYTE_VERIFIED): clear
 *   0x883C war-matrix row for arg0 via cs:0x7AD0/0x7ADF/0x7AB2 helpers and the
 *   0x181F:0x470/0x47A/0x466 resets; tea-party/boycott gate on [0x828]: if active,
 *   do_party = ([0x7F4]!=0 || 0x181F:0xF6()!=0); when do_party: 0x181F:0x3E0()
 *   returns event code, 0xD1D:0x92C(code) shows dialog; response 'J'(0x4A) sets
 *   [0x82B]=1 (accepted), else 0x181F:0x5B6(5) escalation + [0x53C2]=0.
 *   [TRAMPOLINE TARGETS BYTE_VERIFIED 2026-06-08: see extern declarations above]
 * PHASE 6 — PER-UNIT DISPATCH (@asm 0x05326C..0x0534B5): two outer passes
 *   ([bp-0xC] = 0 then 1).  For each unit (descending index [bp-0x1A] over
 *   unit_count(0x539C)): record it via cs:0x7A7B, conditionally publish a
 *   queue/move entry via cs:0x7A71 (the same emit trampoline func_04C532 uses),
 *   gate on the active-power / view globals (0x5396/0x53A2/0x826/0x828), and on
 *   the per-unit move state via 0x181F:0x302/0x55E/0x77E/0x97A.  Cleanup memset
 *   via 0x181F:0xDAE([bp-0x1E],5) before RETF.
 *
 * The colony field offsets (+0x1A owner / +0x8D selected-class / +0xAA/+0xB6/
 * +0xB8 word fields / +0x1B / +0x1C flags), the scratch arrays (0xA0CC per-class
 * supply, 0xA0BC snapshot, 0xA0D4/0xA0DA/0xA0DB aggregate counters, 0xA89C,
 * 0x9FAA work-block, 0xA0B8 per-power gate), the war matrix 0x883C (flags) and
 * 0x8848 (countdown, both stride 0x13C per power), the flag table 0x95F2, the unit
 * fields (+0x3146 type, +0x314A/+0x3150/+0x315B, +0x314B order, +0x314C state,
 * +0x1F/+0x1E colony fields), and ColonyRecord stride 0xCA are BYTE_VERIFIED.
 * The page-0x12 cs:0x7Axx trampolines: cs:0x7AD0/0x7ADF/0x7AB2 targets are now
 * BYTE_VERIFIED via RTLink flattener (see extern block below).
 *
 * 0x181F LEAF BODIES — BYTE_VERIFIED 2026-06-08 (RTLink thunk chain traced):
 *
 *   0x181F:0x4CA  RTLink Type-A thunk header (4-byte prefix 2C00EF09 = offset/seg of target).
 *                 Resolves to 0x09EF:0x002C (file 0x0C31C) = seed_rng_from_timer().
 *                 Chain: 0x002C { push cs; call near 0x0008; retf }
 *                        0x0008 { lcall 0x0C0C:0x0012 (read BIOS timer 0x40:0x6C-6E
 *                                 into AX:DX); AX &= 0x7FFF;
 *                                 push AX; lcall 0xD1D:0xDF2 (set LCG seed:
 *                                   [0x28EE]=AX, [0x28F0]=0); add sp,2; retf }
 *                 Called at Phase 0 as: push [0x83A6]; lcall 0x181F:0x4CA; add sp,2
 *                 [0x83A6] is ignored by the actual function (sits below the far
 *                 return address on entry; the near-called 0x0008 does not access it).
 *                 Purpose: re-seed the LCG RNG from the BIOS tick counter at the
 *                 start of each AI power's asset-census/dispatch run.
 *
 *   0x181F:0x97A  Resolves to 0x0427:0x13B0 (file 0x07A20).
 *                 Input: AX = unit_index (register convention, no stack push).
 *                 Body (enter 2,0):
 *                   si = AX; BX_result = 0 (default)
 *                   if si < 0 or si >= unit_count[0x539C]: return 0
 *                   di = si*0x1C; if unit_tbl[di+0x3144] < 0 (flag byte): return 0
 *                   al = unit[di+0x3147] & 0xF (owner nibble)
 *                   if owner != [0x5394] (current AI power): return 0
 *                   if NOT (unit[di+0x3148]&0x80 AND unit[di+0x3146]==0x0B): return 0
 *                   threshold = call 0x0427:0x065A(si)  [unit-type table lookup,
 *                               base 0x5234, stride 14, +3 for military class 0xD-0x12]
 *                   if unit[di+0x3149] < threshold: return 1  else: return 0
 *                 Returns 1 = "skip unit" when unit is an in-progress type-0xB
 *                 special-order unit whose order-step counter is below the
 *                 type-class threshold; returns 0 otherwise (including all
 *                 invalid/dead/wrong-owner cases).
 *                 Phase 6 caller: "if (predicate != 0) continue" -> units still
 *                 executing a type-0xB order below threshold are NOT re-dispatched.
 *
 *   0x181F:0xA38  Resolves to 0x05B3:0x0004 (file 0x07F34).
 *                 Args: [bp+6]=power (0-based), [bp+8]=slot_k (0-3).
 *                 Body (enter 2,0):
 *                   if power < 4:  imul si,power,0x13C; al=byte[bx+si+(-0x77C4)]
 *                                  = g_war_matrix_883C[power*0x13C + slot_k]
 *                   if power >= 4: imul si,power,0x4E;  al=byte[bx+si+0x59D8]
 *                                  = g_extended_war_59D8[power*0x4E + slot_k]
 *                   AH = 0; return AX
 *                 Two distinct flat arrays: 0x883C (stride 0x13C, main 4-power matrix)
 *                 and 0x59D8 (stride 0x4E, extended/allied powers).  Bit semantics
 *                 of the returned byte: bit0=armed, bit3=pending, bit6=done (as
 *                 documented for g_war_matrix_883C in the Phase 4 comment above).
 *
 *   0x181F:0x30C  Resolves to 0x05DC:0x00E0 (file 0x082A0).
 *                 Args: [bp+6]=row_idx, [bp+8]=col_idx.
 *                 Body (push bp / mov bp,sp — no ENTER):
 *                   bx = row_idx*0x27 + col_idx; bx <<= 1
 *                   AX = word[bx + 0x5B1C]
 *                 Returns: 16-bit entry from a 2-D word table at DGROUP:0x5B1C,
 *                 row-stride 0x27 (39 columns).  Likely a power-vs-power
 *                 threat/relation matrix (indices are power numbers or similar).
 *                 arg0 = power.
 * ============================================================================ */
extern uint8_t  g_colony_owners_5D60[];   /* DGROUP:0x5D60 — ColonyRecord owner col, stride 0xCA (+0x1A) */
extern uint8_t  g_ai_supply_A0CC[];       /* DGROUP:0xA0CC (-0x5F34) — per-class supply count (16) */
extern uint8_t  g_ai_flagtbl_95F2[];      /* DGROUP:0x95F2 (-0x6A0E) — 16-wide flag table (bit3 = active) */
extern uint8_t  g_ai_count_A89C;          /* DGROUP:0xA89C — active-entry counter */
extern uint8_t  g_ai_count_A0D4;          /* DGROUP:0xA0D4 */
extern uint8_t  g_ai_count_A0DA;          /* DGROUP:0xA0DA */
extern uint8_t  g_ai_count_A0DB;          /* DGROUP:0xA0DB */
/* g_unit_count_539C forward-declared above */
/* cs:0x1A1F page-0x12 trampolines used by this routine.
 * TARGETS CORRECTED 2026-06-10: the 2026-06-08 resolutions decoded the thunk
 * overlay field as "page 0" and applied base 0x25900; the raw thunk bytes carry
 * overlay field 0x0D (13) = segmap base 0x4C1F0 (identity mapping verified on
 * four pairs — see VERIFICATION_LEDGER.md "Thunk-decode rule").  All three
 * land on REAL function starts in overlay 13 (this very file's range):
 *
 *   cs:0x7AD0 -> ljmp 0x1A1F:0x554 ; thunk@0x1CB44 = ovl 13 + 0x5D04
 *                -> file 0x51EF4 = func_051EF4 (ENTER 0x44)
 *                (old claim "0x2B604 inside func_02B4D2" RETRACTED)
 *
 *   cs:0x7ADF -> ljmp 0x1A1F:0x578 ; thunk@0x1CB68 = ovl 13 + 0x0342
 *                -> file 0x4C532 = func_04C532
 *                (old claim "0x25C42 inside func_025C32" RETRACTED)
 *
 *   cs:0x7AB2 -> ljmp 0x1A1F:0x50C ; thunk@0x1CAFC = ovl 13 + 0x0A60
 *                -> file 0x4CC50 = func_04CC50 — the region-aggregation /
 *                plan-code writer documented in THIS file (PHASE 5 block above);
 *                a war-matrix routine calling its own overlay's planner is
 *                coherent, unlike the old cross-overlay mid-function claim.
 */
/* (2026-06-11) The old "ovly_tramp_7A7B record-unit" extern is RETIRED: the
 * PHASE-6 call at @0x053370 is PUSH CS; CALL 0x72DB = jump-table entry [3]
 * (file 0x0534CB) = JMP FAR 1A1F:0488 = func_051D56_unit_special_order_dispatch
 * (defined above in this file) — called directly now. */
extern int  func_007A20_logic_sz_96(uint16_t unit); /* 0x181F:0x97A movement gate (file 0x07A20) */
extern int  func_00D1CA_logic_sz_26_pacing_wait(int16_t ax, int16_t dx); /* 0x181F:0x45C (file 0x0D1CA) */
extern int  ovly_tramp_7AB2(uint16_t power);               /* call cs:0x7AB2 -> 0x1A1F:0x50C -> func_04CC50 [CORRECTED 2026-06-10] */
extern int  ovly_tramp_7AD0(uint16_t power);               /* call cs:0x7AD0 -> 0x1A1F:0x554 -> func_051EF4 [CORRECTED 2026-06-10] */
extern int  ovly_tramp_7ADF(uint16_t power);               /* call cs:0x7ADF -> 0x1A1F:0x578 -> func_04C532 [CORRECTED 2026-06-10] */
/* file-local 0x181F / 0xD1D leaves not pre-declared in overlay_externs.h.
 * BYTE_VERIFIED 2026-06-08: bodies traced via RTLink thunk resolution (see block above). */
extern int  overlay_call_181F_04CA(void);  /* 0x181F:0x4CA -> 0x09EF:0x002C seed_rng_from_timer:
                                            *   reads BIOS tick 0x40:0x6C-6E, masks &0x7FFF,
                                            *   seeds LCG [0x28EE/0x28F0] via 0xD1D:0xDF2.
                                            *   arg [0x83A6] is pushed by caller but ignored. */
extern int  overlay_call_181F_097A(void);  /* 0x181F:0x97A -> 0x0427:0x13B0 per_unit_type0B_gate:
                                            *   input in AX (unit_index, register convention).
                                            *   returns 1 if unit is valid/owned/type-0xB with
                                            *   order_step[+0x3149] < type_threshold; else 0. */
extern int  overlay_call_0D1D_092C(void);  /* 0xD1D:0x92C — string/text helper */

/* DGROUP:0x848 — per-power byte (indexed by the power INDEX, not PowerRecord);
 * read as pwr_sub_state[power].  @asm 0x052FAF/0x052FC1 mov al,[bx+0x848] (bx=arg0). */
extern uint8_t g_pwr_substate_0848[];  /* DGROUP:0x848, per-power byte */
extern int16_t g_sel_2D12;             /* DGROUP:0x2D12 — selection scratch */
extern int16_t g_flag_1740;            /* DGROUP:0x1740 — pass flag */
/* PHASE-5 tea-party / boycott escalation gate scalars. */
extern uint8_t g_flag_828;             /* DGROUP:0x828 */
extern int16_t g_flag_7F4;             /* DGROUP:0x7F4 */
extern uint8_t g_flag_82B;             /* DGROUP:0x82B */
extern int16_t g_flag_53C2;            /* DGROUP:0x53C2 */
/* War-matrix slot tables used in the Phase 4 slot-activation loop.
 * Both arrays are indexed as [power * 0x13C + k] (k = 0..3 war-class slots).
 * @asm 0x053169/0x053194: imul bx/si, [bp+6], 0x13C; add bx/si, [bp-0x10] (k).
 * g_war_matrix_883C [bx-0x77C4]: flags byte; bit0=armed/active, bit3=pending
 *   order, bit6=done.  The slot-activation loop clears bits 3,6 and sets bit0
 *   (and [si-0x77c4], 0xB7; or [si-0x77c4], 1) @asm 0x05318A/0x05318F.
 * g_war_matrix_cdown_8848 [bx-0x77B8]: per-slot countdown; decremented each
 *   tick; slot not re-activated until it reaches 0.  @asm 0x053171/0x0531A3. */
extern uint8_t g_war_matrix_883C[];       /* DGROUP:0x883C — war-matrix flags [power*0x13C+k] */
extern uint8_t g_war_matrix_cdown_8848[]; /* DGROUP:0x8848 — war-matrix countdown [power*0x13C+k] */
/* Epoch helpers, resolved + called direct 2026-06-11 (G1 tranche 4):
 *   0x181F:0x582 -> func_030550 = market_set_active ([0x9E12]/[0x84FC] bind)
 *   0x181F:0x590 -> func_00BCEA (file 0x0BCEA)
 *   0x181F:0xDAE -> func_00BCAA (file 0x0BCAA) phase-block clear (n, sel)
 *   0x181F:0x47A -> func_00D0E0 (file 0x0D0E0) input-window reset
 *   0x0D1D:0xDAE / 0x0D1D:0xD82 are C-runtime memset/memcpy -> direct DG ops */
extern void market_set_active(int power);
extern int  func_00BCEA_op_sz_61(uint16_t arg0);
extern int  func_00BCAA_op_sz_64(uint16_t n, uint16_t sel);
extern int  func_00D0E0_input_window_reset(void);

int func_052F7E_ai_power_asset_census(uint16_t power)
{
    /* ---- PHASE 0 — head: bind power, clear scratch. @asm 0x052F83..0x052FE4 */
    g_sel_2D12 = -1;                                    /* @asm 0x052F83 [0x2D12]=0xFFFF */
    g_flag_1740 = 0;                                    /* @asm 0x052F8E [0x1740]=0 */
    (void)overlay_call_181F_04CA();                     /* @asm 0x052F95 seed_rng_from_timer([0x83A6]):
                                                         *   reads BIOS tick 0x40:0x6C, seeds LCG
                                                         *   [0x28EE/0x28F0]; [0x83A6] arg ignored.
                                                         *   BYTE_VERIFIED 2026-06-08. */
    g_self_power_5394 = power;                          /* @asm 0x052FA0 [0x5394]=arg0 */
    market_set_active((int)power);                      /* @asm 0x052FA4 lcall 0x181F:0x582(arg0)
                                                         * -> func_030550: [0x9E12]=power,
                                                         * [0x84FC]=0x8808+power*0x13C. */
    (void)func_00BCEA_op_sz_61(g_pwr_substate_0848[power]); /* @asm 0x052FB6 0x181F:0x590(0x848[p]) */
    int memsel = (int)g_pwr_substate_0848[power] - 8;   /* @asm 0x052FC1..0x052FCA [bp-0x1E] */
    /* @asm 0x052FD4 push 0x10; push 0; push 0xA0CC; lcall 0x0D1D:0x0DAE =
     * C-runtime memset(0xA0CC, 0, 0x10) — direct DG write 2026-06-11. */
    for (int z = 0; z < 0x10; z++) g_ai_supply_A0CC[z] = 0;
    /* @asm 0x052FDC mov bx,[bp+6]; 0x052FDF mov byte[bx-0x5F48],0 — bx is the
     * power INDEX (not the PowerRecord ptr), so this is the per-power byte gate
     * 0xA0B8[power] (byte-indexed; the word-indexed view is g_ai_pwr_gate_A0B8). */
    ((uint8_t *)g_ai_pwr_gate_A0B8)[power] = 0;         /* @asm 0x052FDF 0xA0B8[power] */
    g_ai_count_A89C = 0;                                /* @asm 0x052FE4 [0xA89C]=0 */

    /* ---- PHASE 1 — count active flag-table entries. @asm 0x052FE9..0x053003 */
    for (int i = 0; i < 0x10; i++) {                    /* @asm 0x052FFF cmp 0x10 */
        if (g_ai_flagtbl_95F2[i] & 8)                   /* @asm 0x052FF1 [bx-0x6A0E] */
            g_ai_count_A89C++;                          /* @asm 0x052FF8 inc [0xA89C] */
    }

    /* ---- PHASE 2 — colony census. @asm 0x053005..0x0530A2 */
    /* @asm 0x053005 push [bp-0x1E](memsel); push 0; lcall 0x181F:0xDAE
     * = func_00BCAA_op_sz_64(0, memsel): phase-block clear (the "memset
     * (0x9FAA-block)" effect).  Direct call 2026-06-11. */
    (void)func_00BCAA_op_sz_64(0, (uint16_t)memsel);
    for (int c = 0; c < g_colony_count_539E; c++) {     /* @asm 0x053090 cmp [0x539E] */
        if (g_colony_owners_5D60[c * 0xCA] != (uint8_t)power) /* @asm 0x053022 [bx+0x5D60] */
            continue;                                   /* @asm 0x053026 jne */
        (void)ovly_tramp_7AC1((uint16_t)c);             /* @asm 0x05302C call cs:0x7AC1 (bind colony c) */
        uint8_t *col = (uint8_t *)g_colony_8542;        /* @asm 0x053032 *(0x8542) */
        if ((int8_t)col[0x8D] >= 0)                     /* @asm 0x053036 */
            g_ai_supply_A0CC[col[0x8D]]++;              /* @asm 0x053044 inc 0xA0CC[+0x8D] */
        if (col[0x8D] == 0xF)                           /* @asm 0x05304C */
            g_ai_count_A0DB++;                          /* @asm 0x053053 */
        if (*(int16_t *)&col[0xB8] == 0)                /* @asm 0x053057 */
            g_ai_count_A0DB++;                          /* @asm 0x05305E */
        if (*(int16_t *)&col[0xAA] == 0)                /* @asm 0x053062 */
            g_ai_count_A0D4++;                          /* @asm 0x053069 */
        if (*(int16_t *)&col[0xB6] == 0)                /* @asm 0x05306D */
            g_ai_count_A0DA++;                          /* @asm 0x053074 */
        if (col[0x1B] & 0x10)                           /* @asm 0x053078 */
            ((uint8_t *)g_ai_pwr_gate_A0B8)[power]++;   /* @asm 0x053081 inc 0xA0B8[power] */
        col[0x1C] &= 0xDF;                              /* @asm 0x053089 clear bit5 */
    }

    /* ---- PHASE 3 — snapshot 0xA0CC, credit each unit, dec per-class supply.
     * @asm 0x0530A5..0x0530F4.  memcpy(0xA0BC <- 0xA0CC, 0x10) then for each
     * unit u: 0x181F:0xBE6(u, [bp-0x10]) yields the class index bx; dec
     * 0xA0CC[bx] (units cancel demand); inner [bp-0x10] runs while it is below
     * unit[+0x3150]; finally type==2 units decrement the [0xA0DA] aggregate.
     * BYTE_VERIFIED 2026-06-08: 0x181F:0xBE6 is an RTLink Type-B thunk at
     * file 0x1B1D6 dispatching to overlay page 0x5EB:0x2FF2 (body out of scope);
     * call-site args: push[bp-0x1a]=u, push[bp-0x10]=k; return AX=class index (0..15);
     * caller's dec [AX-0x5F34] = dec g_ai_supply_A0CC[AX] BYTE_VERIFIED @0x530CA.CLOSED. */
    /* @asm 0x053098 push [bp-0x1E]; push 1; lcall 0x181F:0xDAE — phase-1
     * block clear, MISSING from the pre-2026-06-11 port (byte-restored). */
    (void)func_00BCAA_op_sz_64(1, (uint16_t)memsel);
    /* @asm 0x0530A5 push 0x10; push 0xA0CC; push 0xA0BC; lcall 0x0D1D:0x0D82
     * = C-runtime memcpy(0xA0BC, 0xA0CC, 0x10) — direct DG copy 2026-06-11. */
    for (int z = 0; z < 0x10; z++) DG8(0xA0BC + z) = g_ai_supply_A0CC[z];
    for (int u = 0; u < g_unit_count_539C; u++) {       /* @asm 0x0530F4 cmp [0x539C] */
        uint8_t *uu = &g_unit_table_3144[u * UNIT_RECORD_STRIDE];
        for (int k = 0; k < uu[0x0C /*+0x3150*/]; k++) { /* @asm 0x0530D3..0x0530E0 cmp unit[+0x3150] */
            int klass = overlay_call_181F_0BE6();       /* @asm 0x0530C2 class←0x5EB:0x2FF2 */
            g_ai_supply_A0CC[(uint8_t)klass]--;         /* @asm 0x0530CC dec 0xA0CC[bx] */
        }
        if (uu[UNIT_TYPE_OFF] == 2)                     /* @asm 0x0530E6 type==2 */
            g_ai_count_A0DA--;                          /* @asm 0x0530ED dec [0xA0DA] */
    }

    /* ---- PHASE 4 — colony-flag pass + war-slot activation. BYTE_VERIFIED.
     * @asm 0x0530F4..0x0531AF.  For each unit owned by arg0 (owner nibble
     * +0x3147 & 0xF == arg0): a type-0xC unit with +0x314A >= 0 binds its colony
     * (0x181F:0x9E6) and, when that colony's owner is arg0, sets colony +0x1C
     * bit5 (0x20); military-window units (type 0xD..0x12) restart the per-class
     * inner loop (re-run 0x181F:0xBE6 from k=0 for that unit).  After the unit
     * loop exits, a 4-wide slot activation loop (k=0..3) processes war-class slots
     * via 0x181F:0xA38(power,k) / 0x181F:0x4D4(0,3) / war_matrix_883C/cdown_8848. */
    for (int u = 0; u < g_unit_count_539C; u++) {       /* @asm 0x0530F7 cmp [0x539C] */
        uint8_t *uu = &g_unit_table_3144[u * UNIT_RECORD_STRIDE];
        if ((uu[0x03 /*+0x3147*/] & 0x0F) != (uint8_t)power) /* @asm 0x053100 owner nibble */
            continue;                                   /* @asm 0x05310B jne */
        if (uu[UNIT_TYPE_OFF] == 0xC && (int8_t)uu[0x06 /*+0x314A*/] >= 0) { /* @asm 0x05310D/0x053114 */
            (void)overlay_call_181F_09E6();             /* @asm 0x053121 bind colony(unit.+0x314A) */
            if (((uint8_t *)g_colony_8542)[0x1A] == (uint8_t)power) /* @asm 0x053130 colony owner */
                ((uint8_t *)g_colony_8542)[0x1C] |= 0x20; /* @asm 0x053135 set bit5 */
        }
        /* @asm 0x053139..0x053150 — BYTE_VERIFIED: military-window units (type 0xD..0x12)
         * reset k ([bp-0x10]) to 0 and jump back to the phase-3 inner-loop head at
         * 0x530D3, re-running the 0x181F:0xBE6 class-index lookup from scratch for
         * the current unit.  Non-military units (type < 0xD or > 0x12) fall through
         * to the outer unit-loop increment at 0x530E2 without re-scanning.
         * @asm 0x05313D cmp [bx+0x3146],0xD; jb 0x530E2 (below window -> skip)
         * @asm 0x053144 cmp [bx+0x3146],0x12; ja 0x530E2 (above window -> skip)
         * @asm 0x05314B mov [bp-0x10],0; jmp 0x530D3 (restart inner loop k=0) */
        if (uu[UNIT_TYPE_OFF] >= 0xD && uu[UNIT_TYPE_OFF] <= 0x12) { /* @asm 0x05313D/0x053144 */
            /* military-window restart: re-run phase-3 class-credit from k=0
             * for this unit (the actual re-scan loop body is shared with PHASE 3
             * at @asm 0x530D3..0x530E0; effect: dec g_ai_supply_A0CC[class] again). */
            for (int k2 = 0; k2 < uu[0x0C /*+0x3150*/]; k2++) { /* @asm 0x053150 jmp 0x530D3 */
                int klass2 = overlay_call_181F_0BE6();  /* @asm 0x0530C2 -> class bx */
                g_ai_supply_A0CC[(uint8_t)klass2]--;   /* @asm 0x0530CC dec 0xA0CC[bx] */
            }
        }                                               /* @asm 0x053142/0x053149 jb/ja 0x530E2 */
    }

    /* @asm 0x053152..0x0531AF — BYTE_VERIFIED: war-class slot activation loop.
     * Runs AFTER the unit outer loop exits (jge 0x53152 at @asm 0x0530FA).
     * For each of the 4 war-class slots k=0..3 for this power:
     *   - read flags via 0x181F:0xA38(power, k); if bit3 (0x08) set (pending):
     *       if countdown [0x8848+power*0x13C+k]==0: call random_int(0,3) via
     *       0x181F:0x4D4; on result==0 (25% chance) arm the slot:
     *       war_matrix[power][k] = (old & ~0x48)|0x01 (clear bits3,6; set bit0).
     *   - countdown decrement is UNCONDITIONAL (not gated on pending): both the
     *     pending-true and pending-false paths converge at @asm 0x053194 where
     *     imul si,[bp+6],0x13C; add si,k; cmp [bx+si-0x77B8],0; dec if nonzero.
     * DGROUP reads: g_war_matrix_883C[power*0x13C+k] @asm 0x05318A/0x05318F;
     *               g_war_matrix_cdown_8848[power*0x13C+k] @asm 0x053171/0x0531A3.
     * @asm 0x053157 push k; push power; lcall 0x181F:0xA38 (slot predicate)
     * @asm 0x053165 test al,8; je 0x53194 -> jump over pending body if not pending
     * @asm 0x053169 imul bx,[bp+6],0x13C; add bx,[bp-0x10] -> slot linear index
     * @asm 0x053171 cmp [bx-0x77B8],0 -> cmp g_war_matrix_cdown_8848[idx],0
     * @asm 0x053178 push 3; push 0; lcall 0x181F:0x4D4 -> random_int(0,3)
     * @asm 0x05318A and [si-0x77C4],0xB7; or [si-0x77C4],1 -> arm slot
     * @asm 0x053194 imul si,[bp+6],0x13C (both paths merge here for countdown)
     * @asm 0x0531A3 dec [bx+si-0x77B8] -> decrement countdown (unconditional)
     * @asm 0x0531AA cmp [bp-0x10],4; jl 0x53157 */
    for (int k = 0; k < 4; k++) {                      /* @asm 0x053152 mov [bp-0x10],0 */
        extern int func_007F34_logic_sz_27(uint16_t power, uint16_t slot);
        int slot_flags = func_007F34_logic_sz_27(power, (uint16_t)k);
                                                        /* @asm 0x053157 lcall 0x181F:0xA38(power,k)
                                                         *   -> 0x05B3:0x0004 = func_007F34 (file
                                                         *   0x07F34) war_matrix_read:
                                                         *   power<4: byte[0x883C+power*0x13C+k]
                                                         *   power>=4: byte[0x59D8+power*0x4E+k]
                                                         *   BYTE_VERIFIED; direct call 2026-06-11
                                                         *   (the void-arity overlay_call_ stub
                                                         *   returned 0 = war slots never pending). */
        if (slot_flags & 0x08) {                        /* @asm 0x053165 test al,8 (pending?) */
            int idx = (int)power * 0x13C + k;           /* @asm 0x053169 imul/add */
            if (g_war_matrix_cdown_8848[idx] == 0) {    /* @asm 0x053171 cmp [bx-0x77B8],0 */
                if (overlay_call_181F_04D4() == 0)      /* @asm 0x053178 random_int(0,3)==0 */
                    g_war_matrix_883C[idx] = (g_war_matrix_883C[idx] & 0xB7) | 0x01; /* @asm 0x05318A/0x05318F */
            }
        }
        /* countdown decrement is unconditional (not gated on pending):
         * both paths from je 0x53167 converge at @asm 0x053194 for this update. */
        {
            int idx = (int)power * 0x13C + k;           /* @asm 0x053194 imul si; 0x053199 mov bx */
            if (g_war_matrix_cdown_8848[idx] != 0)      /* @asm 0x05319C cmp [bx+si-0x77B8],0 */
                g_war_matrix_cdown_8848[idx]--;          /* @asm 0x0531A3 dec */
        }
    }                                                   /* @asm 0x0531AA cmp k,4; jl 0x53157 */

    /* ---- PHASE 5 — war-matrix threat reset + tea-party/boycott gates.
     * @asm 0x0531B0..0x05326C.  Clears power arg0's 0x883C war-matrix row through
     * the page-0x12 helpers (cs:0x7AD0 / cs:0x7ADF / cs:0x7AB2) bracketed by the
     * 0x181F:0x470/0x47A/0x466 begin/step/end resets, then walks the tea-party /
     * boycott escalation gated on [0x828], [0x7F4], [0x82B], [0x53C2]. */
    (void)func_00BCAA_op_sz_64(2, (uint16_t)memsel);    /* @asm 0x0531B5 phase-block clear (.,2) */
    (void)overlay_call_181F_0470();                     /* @asm 0x0531BD reset-begin */
    (void)ovly_tramp_7AD0(power);                       /* @asm 0x0531C6 call cs:0x7AD0 -> 0x1A1F:0x554
                                                         * -> func_051EF4 = gold_income_tick_for_power
                                                         * (scoring/compute.c; wired via linkfloor_extra) */
    (void)func_00BCAA_op_sz_64(3, (uint16_t)memsel);    /* @asm 0x0531D1 phase-block clear (.,3) */
    (void)overlay_call_181F_0470();                     /* @asm 0x0531D9 */
    (void)ovly_tramp_7ADF(power);                       /* @asm 0x0531E2 call cs:0x7ADF -> 0x1A1F:0x578
                                                         * -> func_04C532_ai_queue_a_rebuild (this file) */
    (void)ovly_tramp_7AB2(power);                       /* @asm 0x0531EC call cs:0x7AB2 -> 0x1A1F:0x50C
                                                         * -> func_04CC50_ai_strategic_plan_build (this file) */
    (void)func_00BCAA_op_sz_64(4, (uint16_t)memsel);    /* @asm 0x0531F7 phase-block clear (.,4) */
    (void)overlay_call_181F_0470();                     /* @asm 0x0531FF */
    (void)func_00D0E0_input_window_reset();             /* @asm 0x053204 0x181F:0x47A (file 0x0D0E0) */

    /* ---- PHASE 6 — the per-unit AI DISPATCH EPOCH.  @asm 0x053209..0x0534B5.
     * REWRITTEN BYTE-TRUE 2026-06-11 (ROUTE_B 1.6; the pre-rewrite "emit loop"
     * misread the cs-relative call targets: the call at @0x053370 is jump-table
     * entry [3] (load 0x72DB -> JMP FAR 1A1F:0488 = func_051D56), NOT cs:0x7A7B,
     * and the gate 0x181F:0x97A SELECTS units to dispatch, it does not skip them).
     *
     * Structure (all branch targets byte-read from file 0x05326C..0x0534BA):
     *   epoch:  0x181F:0x470; 0x181F:0x466(0); tea-party gate;  @0x053209..
     *           two PASSES ([bp-0xC]=0,1)                       @0x05326C/0x053483
     *   pass:   did=0; for u = unit_count-1 .. 0 DESCENDING     @0x053489..0x053495
     *           (exit the scan as soon as did!=0 @0x053450)
     *           pass 0 runs only "special" types 0xA/0xB/0xC    @0x05345C..0x053473
     *           (run flag [bp-0xA] = pass!=0 || special         @0x053274..0x053293)
     *   unit:   WHILE func_007A20(u) (0x181F:0x97A: owned + moves-used[+0x05]
     *           below the @UNIT allowance = "still has movement"):
     *             stuck-track [0x2D12]/[0x2D14] (>20 -> force end-turn) @0x05329F
     *             view publish (skipped unwatched)               @0x0532CC..0x05332A
     *             func_051D56(u)  -> unit_move_step / state handlers  @0x053370
     *             special-finished queue insert (func_04C35A)    @0x053376..0x0533CF
     *             view delay (skipped unwatched)                 @0x0533D2..0x053422
     *             did=1; if([0x828]) [0x5390]=1                  @0x05342C..0x053438
     *   tail:   0x181F:0x45C(AX=0,DX=did); restart epoch while did  @0x053498..0x0534A8
     *
     * [bp-6] (unit-count snapshot for the insert/delay "count changed" tests) is
     * ONLY written inside the view-publish block (@0x053327).  When the AI runs
     * UNWATCHED the original compares an UNINITIALIZED stack word (ENTER frame
     * garbage) — a real MSC artifact.  The port initializes snap=-1 ("never
     * equal"), making the unwatched behavior the deterministic variant of the
     * garbage compare: insert skipped.  Watched mode is byte-faithful. */
    {
        int did;                                        /* [bp-8] */
        int snap = -1;                                  /* [bp-6] — see quirk note */
        do {
            (void)overlay_call_181F_0470();             /* @asm 0x053209 (epoch restart target 0x7019) */
            (void)overlay_call_181F_0466();             /* @asm 0x053210 reset-end(AX=0) */
            /* @asm 0x053215..0x05326C — BYTE_VERIFIED: tea-party / boycott
             * escalation (re-runs each epoch).  Gate: g_flag_828 != 0 (Boston
             * Harbour active).  do_party: g_flag_7F4 != 0 OR 0x181F:0xF6() != 0.
             * @asm 0x05322C mov [bp-0x1C],0x1B is a dead assign (overwritten by
             * the 0x181F:0x3E0 event lookup @0x053239; the mov ax,0x181F / or
             * ax,0xF6 / je at 0x53231..0x53237 is a dead branch).  0xD1D:0x92C
             * shows the dialog; response 'J' (0x4A) -> g_flag_82B=1, else
             * 0x181F:0x5B6(5) escalation + g_flag_53C2=0. */
            if (g_flag_828 != 0) {                      /* @asm 0x053215 cmp [0x828],0 */
                int do_party = (g_flag_7F4 != 0);       /* @asm 0x05321C cmp [0x7F4],0 */
                if (!do_party)
                    do_party = (overlay_call_181F_00F6() != 0); /* @asm 0x053223 */
                if (do_party) {                         /* @asm 0x05322A */
                    int code = overlay_call_181F_03E0();/* @asm 0x053239 lcall 0x181F:0x3E0 */
                    code = overlay_call_0D1D_092C();    /* @asm 0x053244 lcall 0xD1D:0x92C(code) */
                    if (code == 0x4A)                   /* @asm 0x05324F cmp ax,0x4A ('J') */
                        g_flag_82B = 1;                 /* @asm 0x053254 mov [0x82B],1 */
                    else {
                        (void)overlay_call_181F_05B6(); /* @asm 0x05325E lcall 0x181F:0x5B6(5) */
                        g_flag_53C2 = 0;                /* @asm 0x053266 mov [0x53C2],0 */
                    }
                }
            }

            did = 0;
            for (int pass = 0; pass < 2; pass++) {      /* @asm 0x05326C [bp-0xC]=0 / 0x053483 cmp 2 */
                did = 0;                                /* @asm 0x053489 [bp-8]=0 */
                for (int u = g_unit_count_539C - 1;     /* @asm 0x05328E..0x0532A2 count-1 */
                     u >= 0 && !did;                    /* @asm 0x05345A jl / 0x053450 did-exit */
                     u--) {                             /* @asm 0x05344D dec [bp-0x1A] */
                    uint8_t *uu = &g_unit_table_3144[u * UNIT_RECORD_STRIDE];
                    /* pass-0 filter: only "special" types 0xC/0xA/0xB march first. */
                    int special = (uu[UNIT_TYPE_OFF] == 0x0C ||  /* @asm 0x053460 */
                                   uu[UNIT_TYPE_OFF] == 0x0A ||  /* @asm 0x053467 */
                                   uu[UNIT_TYPE_OFF] == 0x0B);   /* @asm 0x05346E */
                    int run = (pass != 0) || special;   /* @asm 0x053274..0x053293 [bp-0xA] */

                    /* WHILE the unit still has movement (0x181F:0x97A ->
                     * func_007A20: owned by [0x5394], moves-used[+0x05] below
                     * the @UNIT allowance (func_006CCA), +0x04 bit7 => type 0xB). */
                    while (func_007A20_logic_sz_96((uint16_t)u) != 0) { /* @asm 0x053441/0x053448 */
                        if (!run)                       /* @asm 0x053296 cmp [bp-0xA],0 */
                            break;                      /* @asm 0x05329C -> 0x05345D next unit */
                        /* stuck-tracking: same unit > 20 rounds -> force end-turn. */
                        if ((int16_t)g_sel_2D12 == u) { /* @asm 0x05329F/0x0532A2 */
                            DGS16(0x2D14)++;            /* @asm 0x0532A7 inc [0x2D14] */
                            if (DGS16(0x2D14) > 20)     /* @asm 0x0532AB cmp 0x14; jle */
                                func_007BCE_logic_sz_25((uint16_t)u); /* @asm 0x0532B5 0x181F:0x934 */
                        } else {
                            g_sel_2D12 = (int16_t)u;    /* @asm 0x0532C3 [0x2D12]=u */
                            DGS16(0x2D14) = 0;          /* @asm 0x0532C6 [0x2D14]=0 */
                        }
                        /* view publish — only when watched: [0x826]!=0x26 AND
                         * ([0x5396]==power OR [0x53A2]!=0).  Headless AI skips. */
                        if (DG8(0x0826) != 0x26 &&      /* @asm 0x0532CC cmp byte,0x26 */
                            ((int16_t)DG16(0x5396) == (int16_t)power || /* @asm 0x0532D3 */
                             DG8(0x53A2) != 0)) {       /* @asm 0x0532DB cmp byte,0 */
                            DG16(0x5390) = 0;           /* @asm 0x0532E2 */
                            DG16(0x5392) = (uint16_t)u; /* @asm 0x0532EB */
                            (void)overlay_call_181F_0302(); /* @asm 0x0532FF passable(x,y) */
                            /* if passable: publish view focus @asm 0x053311/0x053318 */
                            DG16(0x8540) = uu[0x00];
                            DG16(0x853E) = uu[0x01];
                            (void)overlay_call_181F_055E(); /* @asm 0x05331F select(1,0) */
                            snap = g_unit_count_539C;   /* @asm 0x053327 [bp-6]=count */
                        }
                        /* @asm 0x05332D [bp-0x16] debug-trace gate — [bp-0x16]=0
                         * since PHASE 0 (@0x052F8B), so the two 0x181F:0x77E
                         * score-trace calls (@0x053348/0x053364, fmt 0x17BA/0x17CE)
                         * never run; cited, not modeled. */

                        (void)func_051D56_unit_special_order_dispatch((uint16_t)u);
                                                        /* @asm 0x053370 PUSH CS; CALL 0x72DB
                                                         * -> JT[3] -> 1A1F:0488 = func_051D56 */

                        /* special-type finished-move queue insert. */
                        if (g_unit_count_539C == snap &&             /* @asm 0x053379 */
                            special &&                               /* @asm 0x05337E [bp-2] */
                            func_007A20_logic_sz_96((uint16_t)u) == 0) { /* @asm 0x053387 exhausted */
                            int code;
                            switch (uu[UNIT_TYPE_OFF]) {             /* @asm 0x053394 type-0xA chain */
                                case 0x0A: code = 2; break;          /* @asm 0x053424 [bp-4]=2 */
                                case 0x0B: code = 3; break;          /* @asm 0x0533AE [bp-4]=3 */
                                default:   code = 1; break;          /* @asm 0x0533A5 [bp-4]=1 */
                            }
                            (void)func_04C35A_ai_queue_a_find_or_insert(
                                power, uu[0x00], uu[0x01], 2, (uint16_t)code);
                                                        /* @asm 0x0533CC PUSH CS; CALL 0x72D1
                                                         * -> JT[1] -> 1A1F:0470 = func_04C35A
                                                         * args (power,x,y,2,code) @0x0533B3.. */
                        }
                        /* view move-delay (watched only): ~30 BIOS ticks via
                         * 0x0C0C:0x0006 reads; skipped while the unit still has
                         * movement and the count is unchanged.  Headless skips.
                         * @asm 0x0533D2..0x053422 (busy-wait not modeled). */
                        did = 1;                        /* @asm 0x05342C [bp-8]=1 */
                        if (DG8(0x0828) != 0)           /* @asm 0x053431 cmp byte [0x828],0 */
                            DG16(0x5390) = 1;           /* @asm 0x053438 [0x5390]=1 */
                    }                                   /* @asm 0x05344A jmp 0x0532A6 (re-gate) */
                }
            }
            (void)func_00D1CA_logic_sz_26_pacing_wait(0, (int16_t)did);
                                                        /* @asm 0x053498 sub ax,ax; mov dx,[bp-8];
                                                         * @asm 0x05349D lcall 0x181F:0x45C */
        } while (did);                                  /* @asm 0x0534A2/0x0534A8 jmp 0x053209 */
    }

    (void)func_00BCAA_op_sz_64(5, (uint16_t)memsel);    /* @asm 0x0534B0 phase-block clear (.,5) */
    (void)memsel;
    return 0;                                           /* @asm 0x0534BA RETF */
}

/* ============================================================================
 * func_053654 — PHANTOM (mis-decoded page-0x0E header/reloc bytes)
 * ----------------------------------------------------------------------------
 * File 0x053654 lies in the GAP between page-0x0D code-end (0x053540, which ends
 * with the ljmp trampoline block) and page-0x0E code-start (0x053820) — i.e.
 * inside page-0x0E's 32-byte segment-record header + internal relocation table.
 * Raw bytes @0x053654 = `C8 0D 00 00 8B 0B 00 00`: the auto-decoder read the
 * `C8 0D 00` as "ENTER 0xD" but `8B 0B 00 00` is not a coherent body — these are
 * reloc/header words, not code.  The AUTHORITATIVE reseg disasm lists NO function
 * at 0x053654 (page_0E begins at func_053820).  Marked PHANTOM; no body emitted.
 * ============================================================================ */
/* PHANTOM: 0x053654 is page-0x0E header/reloc bytes mis-framed as a function. */

/* ============================================================================
 * func_053820 — ai_dispatch_unit_to_target_colony  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * (page 0x0E, real size 531 bytes — the stale "150-byte colony 0x722" banner was
 *  a truncation.)  Operating from the current colony *(0x8542), finds the nearest
 * OTHER colony of a different owner within Manhattan range 7, and — with a
 * difficulty-gated random chance — spawns/dispatches a unit toward it, plotting a
 * path and creating the unit at the chosen tile.
 *
 * @asm 0x05382A  bx=*(0x8542); cx0=col.x(+0); cx1=col.y(+1)
 * @asm 0x05383F  base = lcall 0x181F:0x722(col.y, col.x)     ; map handle/owner at colony
 * @asm 0x05384E  owner = col[+0x1A]
 * @asm 0x05385E  if mapcell[owner<<4 + base - 0x6B1A] < 2 -> return 0  ; few units of owner
 * @asm 0x053873  range = mapcell[..] - 2                     ; allowed reach
 * @asm 0x053881  for c in 0..colony_count(0x539E):           ; (0x05387E..0x0538E4 ring)
 *      compute Manhattan dist (|dx|,|dy|) from this colony; keep those within 7
 *      @asm 0x0538B1  if colony[c].owner(+0x5D60) != owner AND c != [0x8DC6]:
 *         tx = colony[c].x(+0x5D46); ty = colony[c].y(+0x5D47)
 * @asm 0x0538E6  if lcall 0x181F:0x722(ty,tx) == base (same map region) AND
 * @asm 0x0538FC  random_int(0, range) == 0:                  ; difficulty/range gated
 *      @asm 0x053908  [0x1DD6]=0xFFFF; [0xA14E]=tx; [0xA14C]=ty; [0x1DD4]=[0x1DD2]=1
 *      @asm 0x05392F  pathres = lcall 0x1A1F:0x5F0(col.x, col.y, 0x63)  ; plot path
 *         if pathres in [0,8): step = unit[pathres].dx(+0xBE)/dy(+0xB4); advance toward tx,ty
 *      @asm 0x053965  lcall 0x181F:0x6BE / 0x754             ; reach / claim checks
 *      @asm 0x0539C0  lcall 0x181F:0x6E6 / 0x78C             ; final tile + terrain
 *      @asm 0x0539EF  if terr+2 <= colony.byte[+0x8C]:        ; capacity gate
 *         @asm 0x053A0A  newunit = lcall 0x191F:0xA20(terr, ty, tx, [0x524E]) ; create unit
 *         @asm 0x053A15  unit[newunit*0x1C + 0x315A] = 0x63   ; mark created
 *         @asm 0x053A1B  lcall 0x191F:0x216(newunit) ; lcall 0x191F:0xA06 ; activate
 *      return 1
 * @asm 0x053A2D  return 0
 *
 * The AI "send a unit toward an enemy/neutral colony" action: it uses the colony
 * owner (+0x1A), the per-owner unit-density map (cell @-0x6B1A), the colony
 * coordinate fields (+0x5D46/+0x5D47), the colony-list owner field (+0x5D60),
 * a difficulty/range-scaled random_int (0x181F:0x4D4), a path plot (0x1A1F:0x5F0),
 * and unit creation (0x191F:0xA20) with subtype mark 0x63 at +0x315A.  All
 * struct offsets, the range constant 7, and ColonyRecord stride 0xCA are
 * BYTE_VERIFIED; the 0x181F/0x191F/0x1A1F leaf bodies are role-named externs.
 * [DONE — decision/dispatch logic byte-traced]
 * ============================================================================ */
/* g_ai_sub_tbl_94E6 (DGROUP:0x94E6, declared above) is the same per-owner
 * map-density table this routine reads at [owner<<4 + base - 0x6B1A]. */
extern int16_t  g_active_colony_8DC6;        /* DGROUP:0x8DC6 — current/source colony index */

int func_053820_ai_dispatch_unit_to_colony(void)
{
    int result = 0;                                     /* @asm 0x053825 [bp-4]=0 */
    uint16_t *col = g_colony_8542;
    int cx0 = ((uint8_t *)col)[0];                      /* @asm 0x05382E col.x */
    int cy0 = ((uint8_t *)col)[1];                      /* @asm 0x053835 col.y */

    int base = overlay_call_181F_0722();                /* @asm 0x05383F map handle@(y,x) */
    int owner = ((uint8_t *)g_colony_8542)[0x1A];       /* @asm 0x05384E col owner +0x1A */

    /* @asm 0x05385E — bail when the owner has too few units in this region. */
    int dens = g_ai_sub_tbl_94E6[(owner << 4) + base]; /* @asm 0x05385E [bx+si-0x6B1A] */
    if (dens < 2)                                       /* @asm 0x053863 jae */
        return 0;                                       /* @asm 0x053865 -> 0x053A2D */
    int range = dens - 2;                               /* @asm 0x053873 */

    /* @asm 0x0538A5..0x0538E4 — single loop, index c = [bp-0x20]; find a
     * different-owner colony (not self) within Manhattan range 7.  (The range-
     * test block physically precedes the body @0x05387E and is reached by the
     * jumps at 0x0538DD/0x0538E4 after the candidate coords are loaded.) */
    for (int c = 0; c < g_colony_count_539E; c++) {     /* @asm 0x0538A8 cmp [0x539E] */
        uint8_t *oc = &g_colony_table_5D46[c * 0xCA];   /* @asm 0x0538B1 stride 0xCA */
        if (oc[0x1A] == (uint8_t)owner) continue;       /* @asm 0x0538B8 [bx+0x5D60] */
        if (c == g_active_colony_8DC6) continue;        /* @asm 0x0538C1 [0x8DC6] */
        int tx = oc[0x00];                              /* @asm 0x0538CB col.x +0x5D46 */
        int ty = oc[0x01];                              /* @asm 0x0538D4 col.y +0x5D47 */
        /* @asm 0x05387E..0x0538A4 — Manhattan |dx|,|dy| both < 7 (range gate).
         * (asm computes |d| via NOT+INC on the negative branch @0x053886/0x05389A.) */
        int adx = tx - cx0; if (adx < 0) adx = -adx;
        int ady = ty - cy0; if (ady < 0) ady = -ady;
        if (adx >= 7 || ady >= 7) continue;             /* @asm 0x053887/0x05389D cmp 7 jl */

        /* @asm 0x0538E6 — same map region as the source colony? */
        if (overlay_call_181F_0722() != base) continue; /* handle@(ty,tx) == base */

        /* @asm 0x0538FC — difficulty/range-gated random trigger. */
        if (overlay_call_181F_04D4() != 0) continue;    /* random_int(0,range)==0 */

        /* @asm 0x053908..0x053923 — publish target into the path/plot globals. */
        ai_set_plot_target(tx, ty);                     /* [0x1DD6/0xA14E/0xA14C/0x1DD4/0x1DD2] */

        /* @asm 0x05392F — plot a path from the source colony toward the target. */
        int path = overlay_call_1A1F_05F0();            /* plot_path(cx0, cy0, 0x63) */
        int found = 0;                                  /* @asm 0x053923 [bp-6]=1 set below */
        if (path >= 0 && path < 8) {                    /* @asm 0x053936/0x05393B */
            /* @asm 0x05393D..0x05398C — step toward target along the path; the
             * reach (0x6BE), claim (0x754), step (0x6D2/0x6E6), and terrain
             * (0x78C) checks confirm a legal next tile.  found=1 on success. */
            found = 1;
            (void)overlay_call_181F_06BE();             /* @asm 0x053965 */
            (void)overlay_call_181F_0754();             /* @asm 0x053977 */
        }

        if (found) {                                    /* @asm 0x053998 */
            (void)overlay_call_181F_06D2();             /* @asm 0x0539A3 */
            (void)overlay_call_181F_06E6();             /* @asm 0x0539C0 */
            int terr = overlay_call_181F_078C();        /* @asm 0x0539DA terrain id */
            int terrv = g_terrcost_2F77[terr * 0x10] + 2;/* @asm 0x0539E7..0x0539EE */
            if (terrv <= ((uint8_t *)g_colony_8542)[0x8C]) { /* @asm 0x0539F3 capacity gate */
                int nu = overlay_call_191F_0A20();      /* @asm 0x053A0A create unit(terr,ty,tx,sel) */
                g_unit_table_3144[nu * UNIT_RECORD_STRIDE + 0x16] = 0x63; /* @asm 0x053A15 +0x315A */
                (void)overlay_call_191F_0216();         /* @asm 0x053A1B activate */
                (void)overlay_call_191F_0A06();         /* @asm 0x053A23 */
                result = 1;                             /* @asm 0x053A28 [bp-4]=1 */
            }
        }
        break;                                          /* path of 0x4ED reaches the single RETF */
    }
    return result;                                      /* @asm 0x053A2D RETF */
}
/* Publish the AI move-plot target into the DGROUP path-request globals.
 * @asm 0x053908 [0x1DD6]=0xFFFF; 0x05390E [0xA14E]=tx; 0x053917 [0xA14C]=ty;
 *      0x05391D [0x1DD4]=1; 0x053920 [0x1DD2]=1. */
extern void ai_set_plot_target(int tx, int ty);

/* ============================================================================
 * func_053A34 — colony_set_or_validate_field  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Register-arg helper (AX in = a value/index, saved at [bp-4]).  If AX >= 0,
 * runs two gates (0x181F:0x9FC then 0x181F:0xB8C); when the second succeeds it
 * writes (byte)AX into the current colony's +0x94 field; otherwise it does a
 * table lookup (DGROUP 0x8F85, 12-byte stride) and a predicate (near 0x2D4E).  On any
 * non-success it clears colony +0x1C bit7.
 *
 * @asm 0x053A39  ok = 1
 * @asm 0x053A3E  if (int)AX < 0 -> tail (0x053A8C)
 * @asm 0x053A43  if lcall 0x181F:0x9FC(AX) != 0 -> tail (ok stays 1)
 * @asm 0x053A4F  ok = 0
 * @asm 0x053A55  if lcall 0x181F:0xB8C(AX) != 0:               ; second gate succeeds
 *      @asm 0x053A61  colony[*(0x8542)] +0x94 = (byte)AX       ; commit
 *      @asm 0x053A6C  goto tail
 *   else (0x053A6E): v = (int8)[value*12 - 0x707B] ;          ; table @DGROUP 0x8F85
 *      @asm 0x053A80  if (near call 0x2D4E)(v) != 0 -> ok = 1
 * @asm 0x053A8C  if !ok -> colony +0x1C &= 0x7F (clear bit7)
 * @asm 0x053A9A  return ok
 *
 * Reads/writes the current colony *(0x8542) (+0x94 field, +0x1C flags bit7).
 * The 12-byte-stride table @0x8F85 (DS disp -0x707B) and predicate (near 0x2D4E)
 * g_tbl_8F85 is RUNTIME_ONLY (EXE bytes at DS:0x8F85 are near-code instructions).
 * Predicate near 0x2D4E: body in thunk page (semantics inferred from call context; not decodable from overlay bytecode alone).  [BYTE_VERIFIED control flow]
 * ============================================================================ */
extern int8_t g_tbl_8F85[];   /* DGROUP:0x8F85 (=disp -0x707B), 12-byte stride (read .b0) */

int func_053A34_colony_set_field(int16_t value)
{
    int ok = 1;                                         /* @asm 0x053A39 [bp-2]=1 */
    if (value < 0) {                                    /* @asm 0x053A3E or/jl */
        /* fall through to tail with ok=1 */
    } else if (overlay_call_181F_09FC() != 0) {         /* @asm 0x053A43 gate 1 */
        /* ok stays 1 */
    } else {
        ok = 0;                                         /* @asm 0x053A4F */
        if (overlay_call_181F_0B8C() != 0) {            /* @asm 0x053A55 gate 2 */
            ((uint8_t *)g_colony_8542)[0x94] = (uint8_t)value; /* @asm 0x053A61 colony +0x94 */
        } else {
            int8_t v = g_tbl_8F85[value * 12];          /* @asm 0x053A7A [bx-0x707B] */
            if (ovly_tramp_2D4E(v) != 0)                /* @asm 0x053A80 call cs:0x2D4E */
                ok = 1;                                 /* @asm 0x053A87 */
        }
    }

    if (!ok)                                            /* @asm 0x053A90 */
        ((uint8_t *)g_colony_8542)[0x1C] &= 0x7F;       /* @asm 0x053A96 clear bit7 */
    return ok;                                          /* @asm 0x053A9A RETF */
}

/* ============================================================================
 * func_053AA0 — colony_meets_demand_tier  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * For class arg0 [bp+6], reads two per-class bytes (tables @0x866/@0x864,
 * stride 4), computes a "need tier" (0..3) from a word table @-0x7238 thresholds
 * (3 and 8) and the current colony's stockpile (+0x9A, 16x word) against 0x64,
 * then returns 1 if a measured value (from 0x181F:0xAB0) is BELOW the tier
 * (i.e. demand unmet), else 0.
 *
 * @asm 0x053AAD  klass_b = (byte)[arg0*4 + 0x866]            ; commodity slot @0x866
 * @asm 0x053AB9  have = lcall 0x181F:0xAB0((byte)[arg0*4 + 0x864]) ; measured amount
 * @asm 0x053AC9  tier = 0
 *      @asm 0x053ACE  if (word)[klass_b*2 - 0x7238] >= 3 -> tier = 2   ; table @0x8DC8
 *      @asm 0x053ADF  if (word)[klass_b*2 - 0x7238] >= 8 -> tier = 3
 *      @asm 0x053AF4  if colony.stock[*(0x8542)+klass_b*2 + 0x9A] >= 0x64 -> tier = 3
 * @asm 0x053B00  return (have < tier) ? 1 : 0
 *
 * Reads the current colony *(0x8542) stockpile array (+0x9A, 16x u16) — the same
 * stockpile field colony_screen.c documents.  The word table @-0x7238 thresholds
 * (3, 8) and the 0x64 stock cap are byte-read; the per-class tables @0x864/@0x866
 * Per-class tables are STATIC in EXE (BYTE_VERIFIED values @file DS+0x864):
 *   class 0: [+0]=0x03, [+2]=0x0E  class 1: [+0]=0x27, [+2]=0x06
 *   class 2: [+0]=0x20, [+2]=0x04  class 3: [+0]=0x1B, [+2]=0x01
 *   class 4: [+0]=0x18, [+2]=0x02  class 5: [+0]=0x15, [+2]=0x03
 * Field semantic names not decoded; values BYTE_VERIFIED (STATIC in EXE).  arg0 = class idx.  [BV]
 * ============================================================================ */
extern uint8_t  g_class_tbl_0864[];   /* DGROUP:0x0864 base, stride 4 (b@+0 / b@+2) */
extern int16_t  g_class_word_8DC8[];  /* DGROUP:0x8DC8 (=0x10000-0x7238) — per-class word thresholds */

int func_053AA0_colony_meets_demand(uint16_t klass)
{
    int tier = 0;                                       /* @asm 0x053AA5 [bp-8]=0 */
    int klass_b = g_class_tbl_0864[klass * 4 + 2];      /* @asm 0x053AAD [bx+0x866] */
    int have    = overlay_call_181F_0AB0();             /* @asm 0x053ABE measure([bx+0x864]) */

    if (g_class_word_8DC8[klass_b] >= 3) tier = 2;      /* @asm 0x053ACE [bx-0x7238] */
    if (g_class_word_8DC8[klass_b] >= 8) tier = 3;      /* @asm 0x053ADF */
    if (*(int16_t *)&((uint8_t *)g_colony_8542)[0x9A + klass_b * 2] >= 0x64) /* @asm 0x053AF4 */
        tier = 3;                                       /* @asm 0x053AFB */

    return (have < tier) ? 1 : 0;                       /* @asm 0x053B00..0x053B0E RETF */
}

/* ============================================================================
 * func_053B14 — colony_clear_flag_and_offset  [DONE — BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Clears bit7 of the current colony's +0x1C flags and returns (byte)(arg0+0x1F).
 * (A tiny "reset dirty bit, return the commodity's stockpile base offset" helper:
 *  +0x1F is the first stockpile-region index used elsewhere.)
 *
 * @asm 0x053B17  bx = *(0x8542) ; [bx+0x1C] &= 0x7F
 * @asm 0x053B1F  al = (byte)[bp+6] ; al += 0x1F
 * @asm 0x053B24  return al
 * ============================================================================ */
int func_053B14_colony_clear_flag(uint16_t arg0)
{
    ((uint8_t *)g_colony_8542)[0x1C] &= 0x7F;           /* @asm 0x053B17 */
    return (uint8_t)(arg0 + 0x1F);                      /* @asm 0x053B1F..0x053B22 RETF al */
}

/* ============================================================================
 * func_053B26 — colony_toggle_select_by_stock  [DONE — control flow BYTE_VERIFIED]
 * ----------------------------------------------------------------------------
 * Polls input (0x181F:0xD3A -> threshold word in AX), and for commodity arg0
 * [bp+6] sets or clears the current colony's "selected commodity" byte (+0x8D):
 *
 * @asm 0x053B2A  thr = lcall 0x181F:0xD3A()                  ; event poll / level
 * @asm 0x053B34  if colony.stock[*(0x8542)+arg0*2 + 0x9A] >= thr -> [bp+8]=0
 * @asm 0x053B46  if (word)[arg0*2 - 0x7238] == 0           -> [bp+8]=0
 * @asm 0x053B54  if [bp+8] != 0: colony +0x8D = (byte)arg0  ; select this commodity
 *      else if colony +0x8D == arg0: colony +0x8D = 0xFF     ; deselect
 *
 * Reads the current colony *(0x8542) stockpile (+0x9A, 16x u16) and the selected-
 * commodity byte (+0x8D).  [BYTE_VERIFIED control flow]  arg0 = commodity index;
 * [bp+8] is a caller-provided in/out "enable" word.
 * ============================================================================ */
int func_053B26_colony_select_commodity(uint16_t arg0, int enable)
{
    int thr = overlay_call_181F_0D3A();                 /* @asm 0x053B2A event/level poll */

    if (*(int16_t *)&((uint8_t *)g_colony_8542)[0x9A + arg0 * 2] < thr) /* @asm 0x053B38 */
        enable = 0;                                     /* @asm 0x053B3E */
    if (g_class_word_8DC8[arg0] == 0)                   /* @asm 0x053B48 [bx-0x7238] */
        enable = 0;                                     /* @asm 0x053B4F */

    if (enable != 0) {                                  /* @asm 0x053B54 */
        ((uint8_t *)g_colony_8542)[0x8D] = (uint8_t)arg0;  /* @asm 0x053B61 select */
    } else if (((uint8_t *)g_colony_8542)[0x8D] == (uint8_t)arg0) { /* @asm 0x053B6F */
        ((uint8_t *)g_colony_8542)[0x8D] = 0xFF;        /* @asm 0x053B75 deselect */
    }
    return enable;                                      /* @asm 0x053B65/0x053B7A RETF */
}

/* ============================================================================
 * func_053B7E — SUPERSEDED → src/colony/auto_manage.c
 * ----------------------------------------------------------------------------
 * This is the AI COLONY AUTO-MANAGEMENT PASS (file 0x53B7E, overlay page 0x0E,
 * ENTER 0x1C0, ~9999 bytes — the heaviest routine in this region).  It binds
 * the colony working buffer *(0x8542) via 0x181F:0x9E6(arg0) at entry and
 * rebuilds its derived state (work re-allocation + build planner + status
 * flags).  Already ported with a BYTE_VERIFIED structure in
 *     src/colony/auto_manage.c   (func_053B7E_ai_colony_auto_manage)
 * Its body spills past this file's nominal page-0x0E end into the 054505 page
 * region (where overlay_054505_05C69B.c sees the interior bytes as phantoms).
 * No stub emitted here — see auto_manage.c for the authoritative body.
 * ============================================================================ */
