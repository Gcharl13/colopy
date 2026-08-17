/* Engine core: the byte-pinned caller-side sound layer.
 *
 * Ports (spec/ui/options_dialogs.md, pins of 2026-08-17):
 *   au_cmd            gate func_00518E @0x00518E
 *   au_pump           scheduler func_004EE6 @0x004EE6 (tail 0x5016..0x50BB)
 *   au_queue_tune     func_0050BC @0x0050BC
 *   au_class_set      func_0050F0 (verb 0x181f:0x498) -> [0x9A]
 *   au_class_queue_next func_0050FC (0x4a2) -> [0x98]
 *   au_class_request  func_005108 (0x4ac): set + one-shot + stop
 *   au_class_oneshot  func_00513C (0x4b6): only when BG off + Event on
 *   switches          func_0232AE writers @0x023301..0x023343
 *
 * State words mirrored 1:1 (original DGROUP addresses in comments). The
 * PRNG is a seeded xorshift32 standing in for the RTL rand the original
 * seeds from its tick words [0x83A8]/[0x83A6] — same wall-clock class,
 * different generator (catalogued). */
#include "../data/colopy_audio_pak.h"
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
static int32_t pending = -1;  /* modelled: depth-1 driver queue (observed) */

static uint32_t rng = 0x1234567;

void au_seed(uint32_t seed) { rng = seed ? seed : 0x1234567; }
void au_set_war(int at_war) { war = !!at_war; }
uint16_t au_current_tune(void) { return (uint16_t)current; }

static uint32_t xorshift(void) {
    rng ^= rng << 13;
    rng ^= rng >> 17;
    rng ^= rng << 5;
    return rng;
}

/* random(0, n) inclusive — the original RTL random's call shape
 * (push n; push 0). Modulo bias is negligible at these ranges. */
static int rnd(int n) { return (int)(xorshift() % (uint32_t)(n + 1)); }

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

static void start_entry(uint16_t id) {
    const au_entry *e = au_pak_find(id);
    if (!e) return;                    /* id with no shipped asset: silent */
    if (e->codec == CAUD_CODEC_PCM8U) {
        au_mix_start_sfx(e);           /* digitized: mixes over music (DSP) */
    } else if (au_mix_music_active()) {
        pending = id;                  /* FM family serializes (observed) */
    } else {
        au_mix_start_music(e);
    }
}

/* Gate, func_00518E: ids < 0x10 are driver commands and always pass
 * (1 = stop; 8 = query — served by au_playing()); bit 0x20 ids (tunes,
 * fanfares) gated on Event Music; bit 0x40 ids (SFX) gated on SFX. */
void au_cmd(uint16_t id) {
    if (id < 0x10) {
        if (id == 1) {
            /* stop: silences the driver. Modelled as both voices + the
             * pending slot; forced-next [0x94] survives (func_0050BC sets
             * it and THEN stops). */
            au_mix_stop_music();
            au_mix_stop_sfx();
            pending = -1;
        }
        return;
    }
    if (id & 0x20) {
        if (!sw_event) return;
    } else if (id & 0x40) {
        if (!sw_sfx) return;
    }
    start_entry(id);
}

int au_playing(void) { return au_mix_music_active() || pending >= 0; }
void au_stop(void) { au_cmd(1); }

void au_engine_music_ended(void) {
    if (pending >= 0) {
        const au_entry *e = au_pak_find((uint16_t)pending);
        pending = -1;
        if (e) au_mix_start_music(e);
    }
}

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

    int base, count;
    if (!war) {                               /* peace @0x4F37 */
        base = 1;
        count = 12;
        if (rnd(8) == 0) { base = 13; count = 11; }   /* 1-in-9 crossover */
    } else {                                  /* War of Independence @0x4F5E */
        base = 13;
        count = 6;
        if (rnd(4) == 0) { base = 1; count = 12; }    /* 1-in-5 back */
    }
    /* [0x828] widen-to-24 override (@0x4F82) not exposed: its writer is
     * unmapped (spec §8 item 5). */
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
        i = base + rnd(count - 1);
        id = index_to_id(i);
    } while ((int32_t)id == current);

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
    au_cmd(id);                               /* 0x2D8:0xE with AX=id */
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
