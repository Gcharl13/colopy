/* Engine core: the byte-pinned caller-side sound layer.
 *
 * Ports (spec/ui/options_dialogs.md, pins of 2026-08-17 + 2026-09-02):
 *   au_cmd            gate func_00518E @0x00518E (signed compare @0x5197)
 *   au_pump           scheduler func_004EE6 @0x004EE6 (tail 0x5016..0x50BB)
 *   au_queue_tune     func_0050BC @0x0050BC
 *   au_class_set      func_0050F0 (verb 0x181f:0x498) -> [0x9A]
 *   au_class_queue_next func_0050FC (0x4a2) -> [0x98]
 *   au_class_request  func_005108 (0x4ac): set + one-shot + stop
 *   au_class_oneshot  func_00513C (0x4b6): only when BG off + Event on
 *   switches          func_0232AE writers @0x023301..0x023343
 *   driver commands   ASOUND.COL dispatcher file 0x1C35 (ids 0..8)
 *
 * State words mirrored 1:1 (original DGROUP addresses in comments).
 *
 * PRNG (2026-09-02, RULINGS): the scheduler's draws are the RTL
 * random_int(lo,hi) = 0x9EF:0x32 -> func_00C322 -> MS C rand @0x0103D4
 * (state = state*0x343FD + 0x269EC3, return (state>>16)&0x7FFF) on the
 * SAME state pair [0x28EE]/[0x28F0] the whole game uses, re-seeded from
 * the BIOS tick word at the two scheduler seed points (0x9EF:0x2C ->
 * func_00C31C: srand(ticks & 0x7FFF), @0x4F28 and @0x5040).  The port
 * keeps the generator and both seed points but on a PRIVATE state word
 * (see the ruling): re-seeding the sim's shared LCG from a wall clock is
 * a non-reproducible injection no oracle can compare, and the JS
 * reference has no scheduler to do it in lockstep. */
#include "colopy_audio_pak.h"
#include "colopy_audio.h"
#include "colopy_audio_internal.h"

static int sw_bg = 1;         /* [0xA2] Background Music */
static int sw_event = 1;      /* [0xA0] Event Music */
static int sw_sfx = 1;        /* [0xA4] Sound Effects */
static int32_t current = 0;   /* [0x96] current tune id */
static int32_t forced = -1;   /* [0x94] forced-next (0xFFFF = none) */
static uint8_t class_req = 0; /* [0x9A] active class request */
static uint8_t class_next = 0;/* [0x98] queued-next class request */
static uint8_t class_play = 0;/* [0x9C] class of what is playing */
static int oneshot = 0;       /* [0x9E] pump once despite BG off */
static int war = 0;           /* [0x5382]&1 (shell-provided) */
static int demo = 0;          /* [0x828] (writers @0x70D00 '/D' switch,
                                 @0x4DA6 abort keys 0x12D/0x110) */

/* the MS C rand state, PRIVATE copy (the original's [0x28EE]/[0x28F0]) */
static uint32_t rng_state = 0x1234567;
static au_tick_fn tick_fn;

void au_seed(uint32_t seed) { rng_state = seed; }
void au_set_tick_source(au_tick_fn fn) { tick_fn = fn; }
void au_set_war(int at_war) { war = !!at_war; }
void au_set_demo(int on) { demo = !!on; }
uint16_t au_current_tune(void) { return (uint16_t)current; }
void au_set_current(uint16_t id) { current = id; }   /* [0x96] @0x23561 */

/* MS C rand @0x0103D4 (via 0xD1D:0xE04): the 32-bit LCG, high 15 bits */
static uint32_t msc_rand(void) {
    rng_state = rng_state * 0x343FDu + 0x269EC3u;
    return (rng_state >> 16) & 0x7FFF;
}
/* random_int(lo, hi) = func_00C322: lo + ((rand * (hi-lo+1)) >> 15) */
static int random_int(int lo, int hi) {
    return lo + (int)((msc_rand() * (uint32_t)(hi - lo + 1)) >> 15);
}
/* func_00C31C -> func_00C2F8: BIOS tick dword low word (0xC0C:0x12 ->
 * @0xE4D2 reads 0040:006C), `and ah,0x7F`, srand = [0x28EE]=arg,
 * [0x28F0]=0 (@0x103C2).  The word the scheduler pushes is ignored. */
static void reseed_from_ticks(void) {
    if (tick_fn) rng_state = (uint32_t)(tick_fn() & 0x7FFF);
}

/* func_004DF8: 1-based rotation index -> tune id. 26-entry jump table
 * @0x4EAC, byte-read 2026-08-17. Note 23->0x33 and 24->0x32 are explicit
 * cases SWAPPED relative to the +0x1B default. */
static uint16_t index_to_id(int i) {
    static const uint16_t folk[12] = {
        0x20, 0x21, 0x22, 0x23, 0x3A, 0x3B, 0x38, 0x24, 0x25, 0x26, 0x27,
        0x39,
    };
    if (i >= 1 && i <= 12) return folk[i - 1];
    if (i == 23) return 0x33;
    if (i == 24) return 0x32;
    if (i == 25) return 0x35;
    if (i == 26) return 0x36;
    return (uint16_t)(i + 0x1B);       /* 13..22 -> 0x28..0x31 (+ ja default) */
}

/* The driver's play path (ASOUND dispatcher file 0x1C35): a tune handler
 * stop-marks channels 1-6 first (file 0x3724: call 0x1A64) so a NEW TUNE
 * REPLACES the playing one; an SFX handler tries the digital sample
 * (file 0x1DF6 -> 0:0xCE2, which stops a sample in flight — new kills
 * old) and otherwise assigns its FM effect to channels 7-9.  Voices:
 * music (FM ch1-6 renders), fm (FM ch7-9 SFX renders), digital (DSP). */
static void start_entry(uint16_t id) {
    const au_entry *e = au_pak_find(id);
    if (!e) return;                    /* id with no shipped asset: silent */
    if (e->codec == CAUD_CODEC_PCM8U) au_mix_start_digital(e);
    else if ((id & 0xFFE0) == 0x40) au_mix_start_fm(e);
    else au_mix_start_music(e);
}

/* ASOUND driver commands (file offsets; handler = table word + 0x200):
 *   0 @0x150F full OPL register reset (everything silent)
 *   1 @0x1AA0 = cmd 3 + cmd 5: stop-mark all 9 FM channel records —
 *              music ch1-6 AND FM sfx ch7-9; the digital ring untouched
 *   2 @0x1866 release/fade ch1-6           (modelled as stop music)
 *   3 @0x1A64 stop-mark ch1-6
 *   4 @0x188F release ch7-9 + 0:0xD82 (stop DSP, clear the sample ring)
 *   5 @0x1A8C stop-mark ch7-9
 *   6 @0x18AB save volumes, zero them    (mute)
 *   7 @0x1934 re-send OPL 0x40+ volumes  (unmute)
 *   8 @0x1AA7 OR of byte+0 over the 9 FM channel records (au_playing)
 * VICEROY itself sends only 0 (boot/abort), 1 and 8 (claim 6). */
static void driver_cmd(uint16_t id) {
    switch (id) {
    case 0:
        au_mix_stop_music();
        au_mix_stop_fm();
        au_mix_stop_digital();
        au_mix_set_mute(0);
        break;
    case 1:
        au_mix_stop_music();
        au_mix_stop_fm();
        break;
    case 2:
    case 3: au_mix_stop_music(); break;
    case 4:
        au_mix_stop_fm();
        au_mix_stop_digital();
        break;
    case 5: au_mix_stop_fm(); break;
    case 6: au_mix_set_mute(1); break;
    case 7: au_mix_set_mute(0); break;
    default: break;                    /* 8 = query (au_playing); rest ignored */
    }
}

/* Gate, func_00518E @0x518E, byte-read:
 *   cmp cx,0x10 / jge (SIGNED, 83 F9 10 7D 03 @0x5197) -> bx=1 "command"
 *   for every id < 0x10 as int16 — which includes 0x8000+ (the fanfares
 *   0x8020..0x8027), so they pass UNGATED to the driver;
 *   else dx = bit 0x20, di = bit 0x40:
 *     dx && [0xA0]  -> play          (@0x51B3..0x51BB)
 *     di && [0xA4]  -> play          (@0x51BD..0x51C5)
 *     otherwise     -> return without playing.
 * (2026-09-02: the prior "fanfares are gated on Event Music" was wrong.) */
void au_cmd(uint16_t id) {
    if ((int16_t)id < 0x10) {
        if (id < 0x10) driver_cmd(id);
        else start_entry(id);          /* 0x8000+: the driver's own range check */
        return;
    }
    if ((id & 0x20) && sw_event) { start_entry(id); return; }
    if ((id & 0x40) && sw_sfx) { start_entry(id); return; }
}

/* driver command 8: the OR of the FM channel records — music AND FM sfx;
 * a digital sample in flight does not hold the pump (@0x1AA7) */
int au_playing(void) { return au_mix_music_active() || au_mix_fm_active(); }
void au_stop(void) { au_cmd(1); }

/* the title composer func_0759E8 @0x75C2A: `push 0x33; lcall 0x181f:0x4de`
 * — the RAW driver entry, bypassing the gate and every switch; [0x96] is
 * not written */
void au_on_title(void) { start_entry(0x33); }

/* func_0050BC: queue tune as forced-next and stop the current sound so the
 * pump switches. Sets the one-shot ONLY when Event on + BG off (@0x50CD). */
void au_queue_tune(uint16_t id) {
    if ((int32_t)id == current) return;
    forced = id;
    if (sw_event && !sw_bg) oneshot = 1;
    au_cmd(1);
}

void au_class_set(uint8_t cls) { class_req = cls; }         /* [0x9A] */
void au_class_queue_next(uint8_t cls) { class_next = cls; } /* [0x98] */
void au_force_next_nostop(uint16_t id) { forced = id; }

/* func_005108: class request that interrupts — unless that class is
 * already the playing class (@0x5117). */
void au_class_request(uint8_t cls) {
    class_req = cls;
    if (class_play == cls) return;
    if (sw_event && !sw_bg) oneshot = 1;
    au_cmd(1);
}

/* func_00513C: fires only as a one-shot when BG is off (and Event on) —
 * an event tune that never interrupts running background music. */
void au_class_oneshot(uint8_t cls) {
    if (sw_event && !sw_bg) au_class_request(cls);
}

/* Scheduler, func_004EE6 — see spec §4 for the byte-pinned flow. */
void au_pump(void) {
    if (!sw_bg && !oneshot) return;
    if (au_playing()) return;
    oneshot = 0;                              /* [0x9E] = 0 @0x4F0C */

    if (forced >= 0) {                        /* [0x94] wins @0x4F15 */
        uint16_t id = (uint16_t)forced;
        forced = -1;                          /* reset to 0xFFFF */
        current = id;                         /* [0x96] before the play call */
        au_cmd(id);
        return;
    }

    reseed_from_ticks();                      /* 0x9EF:0x2C @0x4F28 */
    int base, count;
    if (!war) {                               /* peace @0x4F37 */
        base = 1;
        count = 12;
        if (random_int(0, 8) == 0) { base = 13; count = 11; }   /* 1-in-9 */
    } else {                                  /* War of Independence @0x4F5E */
        base = 13;
        count = 6;
        if (random_int(0, 4) == 0) { base = 1; count = 12; }    /* 1-in-5 */
    }
    if (demo) { base = 1; count = 24; }       /* [0x828] @0x4F82: (1,0x18) */
    switch (class_req) {                      /* jump table @0x5008 */
    case 1: base = 1;  count = 7; break;      /* folk A */
    case 2: base = 8;  count = 5; break;      /* folk B */
    case 3: base = 13; count = 6; break;      /* independence */
    case 4: base = 19; count = 4; break;      /* military */
    case 5: if (current != 0x33) { base = 23; count = 1; } break;
    case 6: if (current != 0x35) { base = 25; count = 1; } break;
    case 7: if (current != 0x36) { base = 26; count = 1; } break;
    default: break;
    }

    int i;
    uint16_t id;
    do {                                      /* pick + re-roll @0x5016 */
        i = base + random_int(0, count - 1);  /* 0x9EF:0x32 @0x501D */
        id = index_to_id(i);
    } while ((int32_t)id == current);
    reseed_from_ticks();                      /* 0x9EF:0x2C @0x5040 */

    if (class_req == 0) {                     /* derive class @0x504F */
        if (i <= 6) class_req = 1;
        else if (i <= 12) class_req = 2;
        else if (i <= 18) class_req = 3;
        else if (i <= 22) class_req = 4;
        else if (i <= 24) class_req = 5;
        else if (i <= 25) class_req = 6;
        else class_req = 7;
    }
    class_play = class_req;                   /* [0x9C] = [0x9A] @0x50A0 */
    class_req = class_next;                   /* [0x9A] = [0x98] */
    class_next = 0;                           /* [0x98] = 0 */

    current = id;                             /* [0x96] @0x50B2 */
    au_cmd(id);                               /* 0x2D8:0xE = the gate, AX=id */
}

/* Sound Options switch writers (@0x023301..0x023343): save bits are
 * bit1 = BG, bit2 = Event, bit3 = SFX; turning ANY switch off sends stop. */
void au_set_switch(int which, int on) {
    if (which == 0) sw_bg = !!on;
    else if (which == 1) sw_event = !!on;
    else if (which == 2) sw_sfx = !!on;
    if (!(sw_bg && sw_event && sw_sfx)) au_cmd(1);
}

uint8_t au_switches(void) {
    return (uint8_t)((sw_bg ? 0x02 : 0) | (sw_event ? 0x04 : 0) |
                     (sw_sfx ? 0x08 : 0));
}

void au_load_switches(uint8_t sav_bits) {
    sw_bg = !!(sav_bits & 0x02);
    sw_event = !!(sav_bits & 0x04);
    sw_sfx = !!(sav_bits & 0x08);
}
