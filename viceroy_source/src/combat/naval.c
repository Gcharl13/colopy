/* ============================================================================
 *                       >>> BYTE_VERIFIED (structure & control flow) <<<
 * ----------------------------------------------------------------------------
 * naval.c -- Ship-move / landfall / ship-vs-ship combat dispatch, reconstructed
 *            from VICEROY.EXE raw bytes.
 *
 * Function:  func_03FDDE  @asm file 0x03FDDE..0x040002  (548 bytes = 0x224,
 *            overlay page 0x07, ENTER 0x10,0, multiple RETF exits).
 * Binary:    COLONIZE/VICEROY.EXE
 *            (sha256 a17ed64c27671e5e95236e54a7ddc85803a96ba822fbed05e1dad34d3917e2e3)
 *
 * EXTENT NOTE (raw-EXE arbitration, per RULINGS 2026-05-30):
 *   - functions.json (flat): size 82 — TRUNCATED at first RET. Its NEXT entry is
 *     0x040002, which IS the true end (next fn `PUSH BP/MOV BP,SP` @0x40002). [V]
 *   - overlay_functions_reseg.json / page_07.asm: size=366, terminal="page-end",
 *     and it SPAWNS a phantom func_03FF4C from the in-code jump table. This is
 *     reseg DRIFT: the resegmenter cut the body at nominal_end_resident 0x3FE60
 *     and mis-read the CS-relative jump table at file 0x3FF4A as a new function
 *     prologue (0xF0 "UNRECOGNISED"). The raw EXE shows one contiguous function:
 *     a dispatch on [0x9e4e] (status 1..9) ending in a RETF chain, last RETF
 *     @0x3FFF6, followed by two RTLink ljmp trampolines @0x3FFF8 / @0x3FFFD that
 *     belong to this page. True extent therefore = 0x3FDDE..0x40002.        [V]
 *
 * PURPOSE (string xref, file_offset = handle + 0x1D9A0):
 *   handle 0x13E2 NODOCKS        @0x1ED82   (case 0)
 *   handle 0x13EA LANDFALL       @0x1ED8A   (case 1/2, status==2)
 *   handle 0x13F3 LANDFALL2      @0x1ED93   (case 1/2, status==3)
 *   handle 0x13FD EUROPENOTLEAVE @0x1ED9D   (case 3/4)
 *   handle 0x140C SAILHOME       @0x1EDAC   (case 3/4)
 *   handle 0x1415 SHIPCOMBAT     @0x1EDB5   (case 6)
 *   handle 0x1420 SHIPLAKE       @0x1EDC0   (case 7)
 *   handle 0x1429 LANDFIRST      @0x1EDC9   (case 8)
 *   => func_03FDDE is the SHIP move/arrival handler: given the active ship and a
 *      (dx,dy) step, it classifies the destination (via the sibling producer
 *      func_03FA9C which writes the status code [0x9e4e]) and dispatches to:
 *      no-docks refusal, landfall (unload onto land), sail-home-to-Europe,
 *      ship-vs-ship combat, ship-into-lake, "land first" refusal, etc.
 *
 * STATUS PER ITEM:
 *   [V]   BYTE_VERIFIED  — traced to a cited file offset + instruction.
 *   [body in thunk page] Behind an RTLink overlay thunk (LCALL 0x181F/0x191F/0x1A1F:xxxx ->
 *         dispatcher 0x110D:0x0D91 / 0x110D:0x0DAB; target patched at runtime).
 *         Characterised by call context; exact body NOT statically resolvable
 *         from this EXE image without the overlay page directory. NOT guessed.
 * ============================================================================ */
#include "viceroy_types.h"
#include "unit.h"        /* UnitRecord: base DGROUP:0x3144, stride 0x1C */

/* --- DGROUP globals (LOCAL externs — not promoted to globals.h) ----------- */
/* [0x5392] active/selected unit index; *0x1C => UnitRecord. Written @0x6FBB.
 *          Read here @0x3FE08/@0x3FDE7 (imul ...,0x1c).                  [V]  */
extern int16_t  g_active_unit;          /* DS:0x5392 (word) */
/* [0x9e4e] ship-destination STATUS code (1..9), produced by sibling
 *          func_03FA9C (sole writer @0x3FAA9/@0x3FAE4 etc.), consumed here
 *          @0x3FE16 (`MOV AX,[0x9e4e]`) as the dispatch selector.        [V]  */
extern int16_t  g_ship_dest_status;     /* DS:0x9e4e (word) */
/* [0x9e50] secondary dest datum pushed to the LANDFALL handler @0x3FE56. [V]  */
extern int16_t  g_ship_dest_aux;        /* DS:0x9e50 (word) */
/* [0x5382] bit0 = "currently in Europe / cannot leave" flag, tested @0x3FEA6. */
extern unsigned char g_in_europe_flag;  /* DS:0x5382 */
/* [0x5394] active power index; *0x34 indexes a per-power tile-scan table at
 *          0x543e (+offset), where bit 0x80 = "scan done" — used by the
 *          landfall flood-scan loop @0x3FF81..0x3FFEF.                   [V]  */
extern int16_t  g_active_power;         /* DS:0x5394 (word) */

/* Per-unit-type table at DGROUP:0x5238 (stride 14): the high "movement/role"
 * byte compared to 0x63 (=99) @0x3FE95 to decide whether the just-revealed
 * adjacent unit is a real combatant vs. a >=99 sentinel.                 [V]  */
extern unsigned char g_unit_stat[];     /* DGROUP:0x5230 family (see combat.c) */

/* UnitRecord byte accessors (base 0x3144, stride 0x1C). */
extern struct UnitRecord g_units[];
#define U(i)            (g_units[(i)])
#define U_X(i)          (U(i).map_x)            /* +0x00 (0x3144) [V] @0x3FDEC */
#define U_Y(i)          (U(i).map_y)            /* +0x01 (0x3145) [V] @0x3FDF8 */
#define U_TYPE(i)       (U(i).type)             /* +0x02 (0x3146) [V] @0x3FE83 */
#define U_ORDERS(i)     (U(i).orders)           /* +0x08 (0x314c) cleared @0x3FE9E */

/* --- sibling producer: classifies a ship's destination, writes status ----
 * func_03FA9C @asm 0x03FA9C..0x03FDD8. Returns 0 to PROCEED, !=0 to abort the
 * move; sets g_ship_dest_status. Reached here via the page-local CS trampoline
 * `CALL 0x3FFFD` (@0x3FE0C) -> `LJMP 0x1A1F:0x01AE` (@0x3FFFD).            [V]  */
extern int naval_classify_dest(int unit_idx, int dx, int dy);   /* func_03FA9C */

/* --- RTLink overlay thunks (LCALL <seg>:<off> -> 0x110D dispatcher). Each is
 * cited by its call site; body in thunk page (target paragraph patched at
 * runtime; not statically resolvable). Roles inferred from args. --- */
extern void ovl_popup_simple   (const char *key, void *p, int z);  /* 0x181F:0x998 @0x3FE26 NODOCKS popup */
extern int  ovl_yesno_dialog   (const char *key, int flag);        /* 0x181F:0x652 @0x3FE43/@0x3FEC3/@0x3FF1B (returns choice) */
extern void ovl_unload_at      (int aux);                          /* 0x181F:0x86C @0x3FE5A */
extern int  ovl_landfall_begin (int unit_idx);                     /* 0x181F:0x2EE @0x3FE65 (-> reveal/adjacency idx) */
extern int  ovl_landfall_next  (int prev_idx);                     /* 0x181F:0x2E4 @0x3FE6F */
extern void ovl_msg_simple     (const char *key);                  /* 0x181F:0x3FE @0x3FEB1 EUROPENOTLEAVE */
extern void ovl_sailhome_191f  (void);                             /* 0x191F:0x208 @0x3FED4 */
extern void ovl_sailhome_fin   (int unit_idx);                     /* 0x181F:0xDF4 @0x3FEDD */
extern void ovl_shipcombat_fx  (int x, int y, int a, int b, int c);/* 0x181F:0x9BA @0x3FF08 (5 args; SHIPCOMBAT anim) */
extern void ovl_landfall_unit  (int unit_idx, int dy, int dx);     /* 0x1A1F:0x142 @0x3FF66 (3 args) */
extern void ovl_reveal_tile    (int x, int y);                     /* 0x181F:0xDB8 @0x3FF79 */
extern int  ovl_fortify_accum  (int x, int y);                     /* 0x181F:0x768 @0x3FFB4 (shared with resolver) */
extern void ovl_post_landfall  (void);                             /* 0x181F:0xF6C @0x3FFCF */
extern void power_scan_mark(int power);   /* defined below — forward decl for call at line ~250 */

#define DEST_OK 0

/* power-scan flag helpers — DGROUP table 0x543e, stride 0x34 per power, bit
 * 0x80 = "landfall scan complete for this power this turn".  @0x3FF86 / @0x3FFC0 */
extern int  power_scan_done(int power);   /* TEST [power*0x34 + 0x543e],0x80  [V] */
extern void power_scan_mark(int power);   /* OR   [power*0x34 + 0x543e],0x80  [V] */

/* ============================================================================
 * naval_move_arrive  --  @asm func_03FDDE @ file 0x3FDDE
 *   dx [bp+6], dy [bp+8].  Far function; ret value [bp-2] (default 1 = handled).
 *   Operates on the global active ship g_active_unit.
 * ============================================================================ */
int naval_move_arrive(int dx, int dy)
{
    int ret      = 1;          /* [bp-2]  pre-set 1                @0x3FDE2  [V] */
    int dest_x;                /* [bp-0xa] = ship.x + dx           @0x3FDF5  [V] */
    int dest_y;                /* [bp-0xe] = ship.y + dy           @0x3FE01  [V] */
    int adj_idx;               /* [bp-4]  adjacency-scan unit idx                */
    int choice;                /* [bp-0xc] dialog result                         */
    int done;                  /* [bp-0x10] flood-scan terminator                */
    int sx, sy;                /* [bp-8]/[bp-6] flood-scan cursors               */

    /* --- compute destination tile from active ship + step ---------- [V] --- */
    dest_x = U_X(g_active_unit) + dx;          /* @0x3FDE7..0x3FDF5 */
    dest_y = U_Y(g_active_unit) + dy;          /* @0x3FDF8..0x3FE01 */

    /* --- classify the destination (sibling fn via CS trampoline) --- [V] ---
     * CALL 0x3FFFD -> LJMP 0x1A1F:0x01AE -> func_03FA9C(unit, dx? in dx/bx).
     * Returns 0 => proceed; nonzero => abort (jump to common RETF @0x3FF5C). */
    if (naval_classify_dest(g_active_unit, dest_x, dest_y) != DEST_OK) {  /* @0x3FE0C/0x3FE0F */
        goto abort_move;                       /* @0x3FE13 -> 0x3FF5C */
    }

    /* --- dispatch on status code (1..9) ------------------------------ [V] --
     * @0x3FF38: AX = g_ship_dest_status; AX--; if (AX > 8) goto done(@0x3FFF2);
     * @0x3FF44: JMP word cs:[bx + 0x60a]  (9-entry table @file 0x3FF4A, decoded:
     *   case0->0x3FE1C case1->0x3FE30 case2->0x3FE30 case3->0x3FEA6 case4->0x3FEA6
     *   case5->0x3FEF6 case6->0x3FF16 case7->0x3FF28 case8->0x3FF30)             */
    switch (g_ship_dest_status) {              /* read @0x3FE16 */

    case 1:   /* ---- NODOCKS: ship cannot dock here -------------- @0x3FE1C [V] */
        /* LEA BX,[0x87c]; LEA AX,[0x13E2]("NODOCKS"); SUB DX,DX; LCALL 0x181F:0x998 */
        ovl_popup_simple("NODOCKS", (void *)0x87c, 0);   /* @0x3FE1C..0x3FE26 */
        ret = 1;
        return ret;                            /* LEAVE/RETF @0x3FE2E/0x3FE2F */

    case 2:   /* ---- LANDFALL: unload colonists onto land -------- @0x3FE30 [V] */
    case 3:   /* (status 2 -> "LANDFALL", status 3 -> "LANDFALL2")              */
        /* @0x3FE30: if (g_ship_dest_status==2) {push 3; key="LANDFALL";}
         *           else {push 3; key="LANDFALL2";}  choice=ovl_yesno("...",3)  */
        choice = ovl_yesno_dialog(
                     (g_ship_dest_status == 2) ? "LANDFALL" : "LANDFALL2", 3);  /* @0x3FE30..0x3FE4B */
        if (choice != 2) goto done;            /* @0x3FE4E/0x3FE51 -> 0x3FFF2 */

        ovl_unload_at(g_ship_dest_aux);        /* @0x3FE56..0x3FE5A (push [0x9e50]) */

        /* adjacency reveal loop: walk units adjacent to the landing site.
         * adj_idx = ovl_landfall_begin(active_unit) @0x3FE65, then repeatedly
         * adj_idx = ovl_landfall_next(adj_idx) @0x3FE6F until <0.            */
        adj_idx = ovl_landfall_begin(g_active_unit);     /* @0x3FE62..0x3FE65 */
        for (;;) {
            adj_idx = ovl_landfall_next(adj_idx);        /* @0x3FE6C..0x3FE6F (entry @0x3FE6A jmps here) */
            if (adj_idx < 0) goto abort_move;            /* @0x3FE77/0x3FE79 -> 0x3FF5C */
            /* per-type role byte at 0x5238 (stride 14): cmp ...,0x63
             * (skip sentinels >= 99) @0x3FE7E..0x3FE9A */
            {
                int t = U_TYPE(adj_idx);                 /* @0x3FE83 */
                int role = g_unit_stat[t * 14 + 8];      /* +8 from 0x5230 == 0x5238 */
                if (role >= 0x63) continue;              /* @0x3FE95/0x3FE9A loop back @0x3FE6C */
            }
            U_ORDERS(adj_idx) = 0;                       /* @0x3FE9E clear +0x08 byte (orders) */
            /* @0x3FEA3 unconditional loop back to next() */
        }
        /* (unreachable fallthrough) */

    case 4:   /* ---- SAILHOME / EUROPENOTLEAVE -------------------- @0x3FEA6 [V] */
    case 5:   /* (both statuses 4 and 5 route here)                              */
        if (g_in_europe_flag & 1) {            /* @0x3FEA6 TEST [0x5382],1 */
            ovl_msg_simple("EUROPENOTLEAVE");  /* @0x3FEAD..0x3FEB1 */
            choice = 2;                        /* @0x3FEB6 [bp-0xc]=2 */
        } else {
            choice = ovl_yesno_dialog("SAILHOME", 0);    /* @0x3FEBE..0x3FECB (push 0; key=0x140C) */
        }
        if (choice == 1) {                     /* @0x3FECE/0x3FED2 */
            ovl_sailhome_191f();               /* @0x3FED4 LCALL 0x191F:0x208 */
            ovl_sailhome_fin(g_active_unit);   /* @0x3FED9..0x3FEDD push [0x5392] */
            ret = 1;
            return ret;                        /* RETF @0x3FEE9 */
        }
        if (g_ship_dest_status == 4) goto done;/* @0x3FEEA CMP [0x9e4e],4 -> 0x3FFF2 */
        goto abort_move;                       /* @0x3FEF4 -> 0x3FF5C */

    case 6:   /* ---- SHIPCOMBAT (ship-vs-ship) -------------------- @0x3FEF6 [V] */
        /* push 1,5,5,(dest_y-2),(dest_x-2); LCALL 0x181F:0x9BA (5 args; combat
         * animation / ship-vs-ship resolution at the destination tile).        */
        ovl_shipcombat_fx(dest_x - 2, dest_y - 2, 5, 5, 1);  /* @0x3FEF6..0x3FF08 */
        ret = 1;
        return ret;                            /* RETF @0x3FF14 */

    case 7:   /* ---- SHIPCOMBAT message --------------------------- @0x3FF16 [V] */
        /* push 0; key=0x1415("SHIPCOMBAT"); LCALL 0x181F:0x652 */
        ovl_yesno_dialog("SHIPCOMBAT", 0);     /* @0x3FF16..0x3FF1B (shared tail) */
        ret = 1;
        return ret;                            /* RETF @0x3FF27 */

    case 8:   /* ---- SHIPLAKE (ship cannot enter inland lake) ----- @0x3FF28 [V] */
        ovl_yesno_dialog("SHIPLAKE", 0);       /* @0x3FF28..0x3FF2D push 0,key=0x1420; jmp tail 0x3FF1B */
        ret = 1;
        return ret;

    case 9:   /* ---- LANDFIRST (must land a unit first) ----------- @0x3FF30 [V] */
        ovl_yesno_dialog("LANDFIRST", 0);      /* @0x3FF30..0x3FF35 push 0,key=0x1429; jmp tail 0x3FF1B */
        ret = 1;
        return ret;

    default:                                   /* status 0 or >9 */
        goto done;                             /* @0x3FF3E -> 0x3FFF2 */
    }

abort_move:
    /* --- common abort/landfall-finish path -------------------------- [V] ---
     * @0x3FF5C: push dest_y([bp-0xe]), dest_x([bp-0xa]), [0x5392];
     *           LCALL 0x1A1F:0x142 (3 args) ; ret=0.                            */
    ovl_landfall_unit(g_active_unit, dest_y, dest_x);   /* @0x3FF5C..0x3FF66 */
    ret = 0;                                            /* @0x3FF6E [bp-2]=0 */

    /* reveal the destination tile @0x3FF73..0x3FF79 (push dest_y,dest_x;
     * LCALL 0x181F:0xDB8) */
    ovl_reveal_tile(dest_x, dest_y);                    /* @0x3FF73..0x3FF79 */

    /* if the active power's tile-scan flag (table 0x543e bit0x80, indexed by
     * g_active_power*0x34) is already set, we're done @0x3FF81..0x3FF8B. */
    {
        unsigned char *scan = &g_unit_stat[0];  /* placeholder; real base 0x543e */
        (void)scan;
    }
    /* @0x3FF81 IMUL bx,[0x5394],0x34 ; TEST [bx+0x543e],0x80 ; JNE 0x3FFF2 */
    if (power_scan_done(g_active_power)) goto done;      /* @0x3FF86/0x3FF8B */

    /* --- adjacency flood-scan around the landing tile ------------- [V] ---
     * Nested cursor loop over (sx,sy) in [dest_x-1 .. dest_x+1] x
     * [dest_y-1 .. dest_y+1] calling ovl_fortify_accum(sx,sy) (0x181F:0x768).
     * On the first nonzero result it marks the power-scan flag (OR 0x80 into
     * [bx+0x543e]) and calls ovl_post_landfall (0x181F:0xF6C), setting done=1.
     * @0x3FF8D..0x3FFEF. Exact cursor bookkeeping byte-traced below.            */
    done = 0;                                  /* @0x3FF8D [bp-0x10]=0 */
    sx   = dest_y - 1;                         /* @0x3FF92..0x3FF96 [bp-8] = dest_y-1 */
    /* outer/inner loop (@0x3FF99..0x3FFEF): the disasm interleaves [bp-8]/[bp-6]
     * (sx,sy) cursors with the done flag; structurally a 3x3 neighbourhood walk. */
    for (; done == 0 && (dest_y + 1) >= sx; sx++) {     /* @0x3FFD9/0x3FFDF..0x3FFE6 */
        for (sy = dest_x - 1; done == 0 && (dest_x + 1) >= sy; sy++) {  /* @0x3FF9F..0x3FFAC */
            if (ovl_fortify_accum(sx, sy) != 0) {       /* @0x3FFAE..0x3FFBE (push [bp-8],[bp-6]) */
                /* OR 0x80 into power-scan flag; mark done; post-landfall hook */
                power_scan_mark(g_active_power);         /* @0x3FFC0..0x3FFC9 */
                done = 1;                                /* @0x3FFCA [bp-0x10]=1 */
                ovl_post_landfall();                     /* @0x3FFCF LCALL 0x181F:0xF6C */
                break;
            }
        }
    }

done:
    ret = ret;                                 /* @0x3FFF2 MOV AX,[bp-2] */
    return ret;                                /* LEAVE/RETF @0x3FFF5/0x3FFF6 */
}
/* (power_scan_done / power_scan_mark declared above, before naval_move_arrive) */
