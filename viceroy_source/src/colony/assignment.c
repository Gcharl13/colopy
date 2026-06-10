/* ============================================================================
 * colony/assignment.c — colonist job dispatcher + auto-placement
 * ----------------------------------------------------------------------------
 * The 4-way colony dispatcher (the largest single function decoded so far)
 * plus the post-savegame-load auto-assign pass.
 *
 * @ref decompiled.md "colony_assign_or_change_colonist_job"
 * @ref decompiled.md "auto_assign_unassigned_colonists"
 * ============================================================================ */
#include "viceroy.h"

/* Helpers in load_image */
extern int  helper_8BD4(int overflow_idx);                          /* 0x8BD4 */
extern int  unit_translate_action_8BC6(int action);                 /* 0x8BC6 */
extern void func_8FB4(int slot);                                    /* 0x8FB4 */
extern int  compute_job_outputs(int prev_job, uint8_t *yields_out); /* 0x903E */
extern int  func_AB78(int slot, int action);                        /* 0xAB78 */

/* Overlay calls used by these functions */
extern int  overlay_call_0427_005C(int x, int y);    /* iterator seed */
extern int  overlay_call_0427_004A(int iter);        /* iterator next */
extern int  overlay_call_0427_06B4(int translated, int owner, int x, int y);  /* spawn */
extern int  overlay_call_0427_0824(int unit_idx);    /* place colonist on map */
extern int  overlay_call_0427_155E(int unit_idx);    /* attach/detach unit */

/* ============================================================================
 * colony_assign_or_change_colonist_job — 782 bytes
 *
 * @asm 0x009318..0x009625  (782 bytes)
 * @ref decompiled.md "colony_assign_or_change_colonist_job"
 *
 * Inputs:
 *   slot       = colonist index (or population+overflow for "next free slot")
 *   new_action = job code (0..0x12) | 0x13 boundary | 0x14 "with-tools" specialist
 *
 * Branches via classify_pair_bounds (0x929A) into 4 cases:
 *   0 = NORMAL JOB CHANGE      (slot in struct, action < 0x13)
 *   1 = UNIT LEAVES COLONY     (slot out, action >= 0x13)
 *   2 = UNIT ENTERS COLONY     (slot in,  action >= 0x13)
 *   3 = POPULATION GROWTH      (slot out, action < 0x13)
 *
 * The growth path recursively calls itself with (new_slot, action) so the
 * just-grown colonist immediately gets a job.
 *
 * @verified Recursive self-call confirmed by callgraph: file 0x9471 contains
 *           CALL +0xFEA7 = -345 = back to file 0x9318.
 * ============================================================================ */
int colony_assign_or_change_colonist_job(int slot, int new_action)
{
    /* @asm 0x9322..0x9331  0x17 → 0x15 unit-type / job remap */
    if (new_action == 0x17) new_action = 0x15;

    /* @asm 0x9332..0x933C  prev_job = current_unit_field_at_20(slot) */
    int prev_job = current_unit_field_at_20(slot);

    /* @asm 0x933D..0x934B  yield_count = compute_job_outputs(prev_job, &produced) */
    uint8_t produced[10];   /* @asm [bp-0x28] — 10-byte yield buffer */
    int yield_count = compute_job_outputs(prev_job, produced);
    int returned_slot = -1;

    /* ---- Phase 1: REVERSE the old job's contribution to the stockpile ----
     * @asm 0x9353..0x93BF  loop yield_count entries at produced[]; subtract from stockpile */
    for (int i = 0; i < yield_count; i++) {
        int production_id = produced[i*2];
        int yield;
        if (production_id == 0xE) {
            /* Tools branch: re-fetch via UnitRecord field */
            int unit_idx = helper_8BD4(ctx->population - slot);
            yield = unit(unit_idx).cargo_qty[4] - 50;  /* +0x14 = cargo_qty[4] */
        } else if (production_id > 0xE) {
            yield = 50 - 8;       /* @asm 0x93B0: MOV [bp-6], 0x32 (+/-8) */
        } else if (production_id == 0) {
            yield = 0;
        } else {
            yield = 50;            /* baseline */
        }
        ctx->stockpile_9a[production_id * 2] += yield;
    }

    /* ---- Phase 2: zero a 0x10-byte scratch region on stack ----
     * @asm 0x93C0..0x93CD  LCALL 0xD1D:0xDAE (memset(buf, 0, 16)) */
    uint8_t local_buf[0x10];
    overlay_call_0D1D_0DAE(local_buf, 0, 0x10);

    /* ---- Phase 3: compute liberty / population ratio ----
     * @asm 0x93D0..0x93F6  popularity = ctx->progress_b6 / 20, clamped
     * (then * 20, clamped to 100, stored as feature byte) */
    int popularity = ctx->progress_b6 / 20;
    int popular_pct = popularity * 20;
    if (popular_pct > 100) popular_pct = 100;
    uint8_t feature_byte = (uint8_t)popular_pct;

    /* ---- Phase 4: clear expertise nibble if job is changing ----
     * @asm 0x93F7..0x940A */
    if (new_action != prev_job) {
        pack_nibble_at_60(slot, 0);
    }

    /* ---- Phase 5: dispatch on (slot in?, action in?) ---- */
    /* @asm 0x940B..0x942D  classify_pair_bounds → switch */
    int dispatch_code = classify_pair_bounds(slot, new_action);

    switch (dispatch_code) {
    case 0:  /* NORMAL JOB CHANGE */
        /* @asm 0x94D6..0x94F4 */
        ctx->job_at_20[slot] = (uint8_t)new_action;
        returned_slot = slot;
        yield_count = compute_job_outputs(new_action, produced);
        break;

    case 1:  /* UNIT LEAVES COLONY */
        /* @asm 0x9576..0x95C0 */
        {
            int unit_idx = helper_8BD4(ctx->population - slot);
            int translated = unit_translate_action_8BC6(new_action);
            unit(unit_idx).type        = (uint8_t)translated;
            unit(unit_idx).cargo_qty[5] = 0;            /* +0x15; clear slot */
            if (new_action == 0x14) {
                unit(unit_idx).cargo_qty[4] = feature_byte;  /* +0x14 */
            }
            overlay_call_0427_155E(unit_idx);
            returned_slot = slot;
        }
        break;

    case 2:  /* UNIT ENTERS COLONY */
        /* @asm 0x9500..0x956D */
        {
            int translated = unit_translate_action_8BC6(new_action);
            int unit_idx = overlay_call_0427_06B4(translated, ctx->owner_power,
                                                  ctx->map_x, ctx->map_y);
            if (unit_idx < 0) {
                returned_slot = slot;       /* failed — fallback */
            } else {
                overlay_call_0427_155E(unit_idx);
                int existing = current_unit_field_at_40(slot);
                unit(unit_idx).turn_counter = (uint8_t)existing;  /* +0x16 */
                if (new_action == 0x14) {
                    unit(unit_idx).cargo_qty[4] = feature_byte;  /* +0x14 */
                }
                func_8FB4(slot);
                returned_slot = ctx->population;
            }
        }
        break;

    case 3:  /* POPULATION GROWTH */
        /* @asm 0x942E..0x94D2 */
        if (ctx->population >= 0x20) {
            /* Cap reached: just return last available slot */
            returned_slot = ctx->population - 1;
            break;
        }
        {
            int new_unit_idx = helper_8BD4(ctx->population - slot);
            /* @asm 0x9453..0x945C  ctx->cumulative_c6 += 100 (long-add, low+high) */
            uint32_t cum = ((uint32_t)ctx->cumulative_c8 << 16) | ctx->cumulative_c6;
            cum += 100;
            ctx->cumulative_c6 = (uint16_t)(cum & 0xFFFF);
            ctx->cumulative_c8 = (uint16_t)(cum >> 16);

            int new_slot = ctx->population;
            ctx->population++;

            /* RECURSIVE self-call to assign the new slot's job */
            colony_assign_or_change_colonist_job(new_slot, new_action);

            int initial_field = unit(new_unit_idx).turn_counter;  /* +0x16 */
            set_field_at_40_or_unit_byte(new_slot, initial_field);
            overlay_call_0427_0824(new_unit_idx);

            returned_slot = new_slot;

            /* @asm 0x9499..0x94D2  Tutorial / first-3-colonists trigger */
            if (ctx->population < 3 && g_tutorial_flag_35C == 0) {
                if (overlay_call_0981_0000(ctx->owner_power, 9)) {
                    set_or_clear_bit_at_84(0, 1);
                }
            }
        }
        break;
    }

    /* @asm 0x956E..0x9572  init_and_scan_units_in_area() — refresh counters */
    init_and_scan_units_in_area();

    /* ---- Phase 6: APPLY the new job's production by SUBTRACTING from stockpile ---- */
    /* @asm 0x95D1..0x960F  for cases 0/3: subtract new yields from stockpile */
    for (int i = 0; i < yield_count; i++) {
        int production_id = produced[i*2];
        uint8_t feature_yield = local_buf[i];
        if (production_id == 0) {
            /* @asm 0x95E9..0x95EE  Sentinel zero */
            /* (no specific action; flag below gets set if pop hit zero) */
        }
        int amount = ctx->stockpile_9a[production_id * 2] - feature_yield;
        if (amount < 0) amount = 0;
        ctx->stockpile_9a[production_id * 2] = amount;
    }

    /* ---- Phase 7: if colony just emptied, fire global signal ---- */
    /* @asm 0x9610..0x961F */
    if (ctx->population == 0) {
        g_tutorial_flag_348 = 1;
    }

    return returned_slot;
}

/* ============================================================================
 * auto_assign_unassigned_colonists — 155 bytes
 *
 * @asm 0x00B150..0x00B1EB  (155 bytes)
 * @ref decompiled.md "auto_assign_unassigned_colonists"
 *
 * Post-savegame-load fix-up pass.  Ensures every colonist is either bound
 * to a working tile (via tile_state_70[]) or demoted to "idle" (action 0xD).
 * ============================================================================ */
void auto_assign_unassigned_colonists(void)
{
    uint8_t slot_used[0x20];

    /* @asm 0xB155..0xB172  zero slot_used[0..population-1] */
    for (int i = 0; i < ctx->population; i++) {
        slot_used[i] = 0;
    }

    /* @asm 0xB173..0xB198  mark tile-state slots */
    for (int tile = 0; tile < 20; tile++) {
        int8_t bound = (int8_t)ctx->tile_state_70[tile];
        if (bound >= 0) slot_used[bound] = 1;
    }

    /* @asm 0xB19A..0xB1E7  for each unassigned: try place; else demote to idle */
    for (int i = 0; i < ctx->population; i++) {
        if (slot_used[i] != 0) continue;

        int job = current_unit_field_at_20(i);
        if (job >= 9) continue;            /* non-working unit type, skip */

        int placed = func_AB78(i, -1);
        if (placed != 0) {
            slot_used[i] = 1;
        } else {
            colony_assign_or_change_colonist_job(i, 0xD);
        }
    }
}
