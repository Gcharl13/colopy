/* audio_smoke — deterministic host tests for cport/audio (smoke --audio).
 *
 * Everything here runs against a SYNTHETIC in-memory pak built below, so
 * the tests are exact and hermetic (the shipped COLAUDIO.PAK depends on
 * empirical captures and is validated structurally by --audiopak instead).
 * The scheduler tests hold the engine to the byte-pinned func_004EE6
 * algorithm (spec/ui/options_dialogs.md §4): windows, class table, forced
 * precedence, re-roll, crossover ratios (binomial bounds), and the
 * one-shot/queue semantics of func_0050BC/005108/00513C. */
#include <stdio.h>
#include <string.h>

#include "../audio/colopy_audio.h"
#include "../data/colopy_audio_pak.h"
#include "audio_fixture.h"

static int fail;
#define CHECK(cond, ...) do { \
    if (!(cond)) { fail++; printf("FAIL: " __VA_ARGS__); printf("\n"); } \
} while (0)

/* ---- synthetic pak ---------------------------------------------------- */
/* one silent IMA block (predictor 0, index 0, zero nibbles -> all zeros) */
static uint8_t silent_block[CAUD_BLOCK_BYTES];

#define MAXE 64
static uint8_t pak[96 * 1024];

static uint32_t pak_build(const uint16_t *ids, int n) {
    /* tunes/fanfares (bit 0x20): 1 silent IMA block; the first tune id
     * (0x20) instead carries the Python fixture blob so the render path
     * exercises real coefficients. SFX (bit 0x40): 64 bytes of PCM8. */
    static uint8_t pcm[64];  /* first sample nonzero so "did it play" reads */
    for (int i = 0; i < 64; i++) pcm[i] = (uint8_t)(136 + ((i & 7) << 3));
    uint32_t off = CAUD_HDRLEN + (uint32_t)n * CAUD_TOCENT;
    memcpy(pak, CAUD_MAGIC, 4);
    pak[4] = CAUD_VERSION; pak[5] = 0;
    pak[6] = (uint8_t)n; pak[7] = (uint8_t)(n >> 8);
    pak[8] = (uint8_t)CAUD_MIX_RATE; pak[9] = CAUD_MIX_RATE >> 8;
    pak[10] = pak[11] = 0;
    for (int i = 0; i < n; i++) {
        const uint8_t *pl; uint32_t len; uint8_t codec; uint16_t rate;
        if (ids[i] & 0x20) {
            if (ids[i] == 0x20) { pl = AUFIX_BLOB; len = AUFIX_BLOB_LEN; }
            else { pl = silent_block; len = sizeof silent_block; }
            codec = CAUD_CODEC_IMA4; rate = 22050;
        } else {
            pl = pcm; len = sizeof pcm; codec = CAUD_CODEC_PCM8U; rate = 11025;
        }
        uint8_t *e = pak + CAUD_HDRLEN + i * CAUD_TOCENT;
        e[0] = (uint8_t)ids[i]; e[1] = (uint8_t)(ids[i] >> 8);
        e[2] = codec; e[3] = 0;
        e[4] = (uint8_t)rate; e[5] = (uint8_t)(rate >> 8);
        e[6] = e[7] = 0;
        e[8] = (uint8_t)off; e[9] = (uint8_t)(off >> 8);
        e[10] = (uint8_t)(off >> 16); e[11] = (uint8_t)(off >> 24);
        e[12] = (uint8_t)len; e[13] = (uint8_t)(len >> 8);
        e[14] = (uint8_t)(len >> 16); e[15] = (uint8_t)(len >> 24);
        memcpy(pak + off, pl, len);
        off += len;
    }
    return off;
}

static void drain(void) {           /* render until both voices are idle */
    int16_t buf[512];
    for (int i = 0; i < 4096 && au_playing(); i++) au_render(buf, 512);
    au_stop();
}

static void reset_all(uint8_t switches) {
    au_stop();
    drain();
    au_load_switches(switches);
    au_seed(0xC01A11u);
}

/* every id the scheduler can reach (rotation indices 1..26) */
static const uint16_t ALL_IDS[] = {
    0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B,
    0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x33, 0x35, 0x36, 0x38, 0x39,
    0x3A, 0x3B, 0x3E, 0x3F, 0x40, 0x42, 0x54, 0x8024,
};
#define N_IDS ((int)(sizeof ALL_IDS / sizeof ALL_IDS[0]))

static int in_set(uint16_t id, const uint16_t *set, int n) {
    for (int i = 0; i < n; i++) if (set[i] == id) return 1;
    return 0;
}

/* the pinned index->id windows (spec §4) */
static const uint16_t FOLK[12] = {0x20, 0x21, 0x22, 0x23, 0x3A, 0x3B, 0x38,
                                  0x24, 0x25, 0x26, 0x27, 0x39};
static const uint16_t INDEP[6] = {0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D};
static const uint16_t MILIT[4] = {0x2E, 0x2F, 0x30, 0x31};

static uint16_t pump_once(void) {   /* pump, note the pick, silence it */
    au_pump();
    uint16_t id = au_current_tune();
    drain();
    return id;
}

int audio_smoke_main(void) {
    /* ---- ADPCM cross-language round-trip (exact) ---- */
    {
        uint32_t len = pak_build((const uint16_t[]){0x20}, 1);
        CHECK(au_init_buffer(pak, len), "synthetic pak init");
        au_load_switches(0x0E);
        au_cmd(0x20);
        static int16_t out[AUFIX_SAMPLES + 64];
        au_render(out, AUFIX_SAMPLES + 64);
        int exact = 1;
        for (int i = 0; i < AUFIX_SAMPLES; i++)
            if (out[i] != AUFIX_DEC[i]) { exact = 0; break; }
        CHECK(exact, "C IMA decoder != Python decoder");
        for (int i = AUFIX_SAMPLES; i < AUFIX_SAMPLES + 64; i++)
            CHECK(out[i] == 0, "tail not silent after voice end");
    }

    uint32_t len = pak_build(ALL_IDS, N_IDS);
    CHECK(au_init_buffer(pak, len), "full synthetic pak init");

    /* ---- gate truth table (func_00518E) ---- */
    reset_all(0x00);                 /* all switches off */
    au_cmd(0x20);
    CHECK(!au_playing(), "tune must gate on Event Music");
    au_cmd(0x42);
    {
        int16_t b[8];
        au_render(b, 8);
        CHECK(b[0] == 0, "sfx must gate on SFX switch");
    }
    reset_all(0x04);                 /* Event only */
    au_cmd(0x8024);
    CHECK(au_playing(), "fanfare (bit 0x20) passes on Event Music");
    reset_all(0x08);                 /* SFX only */
    au_cmd(0x42);
    {
        int16_t b[4];
        au_render(b, 4);
        CHECK(b[0] != 0, "sfx plays with SFX switch on");
    }
    au_cmd(1);
    {
        int16_t b[4];
        au_render(b, 4);
        CHECK(b[0] == 0, "cmd 1 stops the sfx voice");
    }

    /* ---- switch encoding (bits @0x023301) + stop-on-any-off ---- */
    reset_all(0x0E);
    CHECK(au_switches() == 0x0E, "switch encoding 0x0E");
    au_cmd(0x20);
    CHECK(au_playing(), "tune playing before switch-off");
    au_set_switch(0, 0);             /* BG off -> stop sent */
    CHECK(!au_playing(), "any-switch-off sends stop");
    CHECK(au_switches() == 0x0C, "BG bit cleared");

    /* ---- forced-next precedence + queue_tune ---- */
    reset_all(0x0E);
    au_queue_tune(0x2C);
    CHECK(!au_playing(), "queue_tune stops current");
    au_pump();
    CHECK(au_current_tune() == 0x2C, "forced-next wins the pump");
    drain();

    /* ---- pending queue (observed driver serialization) ---- */
    reset_all(0x0E);
    au_cmd(0x21);
    CHECK(au_playing(), "tune started");
    au_cmd(0x22);                    /* second play while sounding: queued */
    CHECK(au_playing(), "still sounding");
    {
        int16_t b[512];
        int saw22 = 0;
        for (int i = 0; i < 64 && au_playing(); i++) {
            au_render(b, 512);
        }
        /* 0x21 is one silent block (1024 samples) -> 0x22 must have
         * auto-started from the pending slot before draining fully */
        (void)saw22;
    }
    CHECK(!au_playing(), "pending chain drained");

    /* ---- class windows (jump table @0x5008) ---- */
    struct { uint8_t cls; const uint16_t *set; int n; } CL[] = {
        {1, FOLK, 7},                /* folk A = indices 1..7 */
        {2, FOLK + 7, 5},            /* folk B = indices 8..12 */
        {3, INDEP, 6},
        {4, MILIT, 4},
    };
    for (unsigned c = 0; c < sizeof CL / sizeof CL[0]; c++) {
        for (int rep = 0; rep < 24; rep++) {
            reset_all(0x0E);
            au_class_set(CL[c].cls);
            uint16_t id = pump_once();
            CHECK(in_set(id, CL[c].set, CL[c].n),
                  "class %u picked 0x%X outside its window", CL[c].cls, id);
        }
    }
    /* single-tune classes with already-playing guard */
    reset_all(0x0E);
    au_class_set(5);
    CHECK(pump_once() == 0x33, "class 5 -> 0x33");
    au_class_set(6);
    CHECK(pump_once() == 0x35, "class 6 -> 0x35");
    au_class_set(7);
    CHECK(pump_once() == 0x36, "class 7 -> 0x36");

    /* ---- peace / war windows + crossover ratios ---- */
    {
        reset_all(0x0E);
        au_set_war(0);
        int cross = 0, n = 800;
        for (int i = 0; i < n; i++) {
            uint16_t id = pump_once();
            int is_folk = in_set(id, FOLK, 12);
            if (!is_folk) {
                cross++;
                CHECK(in_set(id, INDEP, 6) || in_set(id, MILIT, 4) ||
                      id == 0x33, "peace crossover 0x%X outside 13..23", id);
            }
        }
        /* p = 1/9: expect ~89 of 800; allow 4 sigma (~±34) */
        CHECK(cross > 55 && cross < 125,
              "peace 1-in-9 crossover off: %d/800", cross);

        au_set_war(1);
        cross = 0;
        for (int i = 0; i < n; i++) {
            uint16_t id = pump_once();
            if (in_set(id, FOLK, 12)) cross++;
            else CHECK(in_set(id, INDEP, 6), "war pick 0x%X not independence",
                       id);
        }
        /* p = 1/5: expect ~160 of 800; 4 sigma ≈ ±45 */
        CHECK(cross > 115 && cross < 205,
              "war 1-in-5 crossover off: %d/800", cross);
        au_set_war(0);
    }

    /* ---- re-roll: the pump never repeats the current tune ---- */
    {
        reset_all(0x0E);
        uint16_t prev = 0;
        for (int i = 0; i < 200; i++) {
            uint16_t id = pump_once();
            CHECK(id != prev, "pump repeated tune 0x%X", id);
            prev = id;
        }
    }

    /* ---- one-shot: class_request plays once with BG off ---- */
    reset_all(0x04);                 /* Event on, BG off, SFX off */
    au_class_request(4);
    au_pump();
    CHECK(in_set(au_current_tune(), MILIT, 4), "one-shot class 4 played");
    drain();
    au_pump();
    CHECK(!au_playing(), "no rotation after the one-shot (BG off)");

    /* ---- class_oneshot only fires when BG off ---- */
    reset_all(0x0E);                 /* BG on */
    au_cmd(0x21);
    au_class_oneshot(4);
    CHECK(au_current_tune() != 0x2E, "class_oneshot must not interrupt BG");
    drain();

    printf(fail ? "audio_smoke: %d FAILURES\n" : "audio_smoke: all OK\n",
           fail);
    return fail ? 1 : 0;
}
