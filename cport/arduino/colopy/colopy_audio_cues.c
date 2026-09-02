/* Event/woodcut -> audio cue table.
 *
 * Source: the 40 `mov ax,id; lcall 0x181F:0x4C0` sites of VICEROY.EXE,
 * each read at its offset (inventory: spec/ui/options_dialogs.md §10,
 * 2026-09-02).  A row here pairs a cue with the GAME.TXT KEY pushed in
 * the same emit block (`push <key>; lcall 0x181f:0x652` within a few
 * instructions of the play) — the EXE's own attribution, so the rows
 * carry no `[inferred]` tag any more.  Cues that belong to an ACTION
 * rather than a message (Fortify, arming, founding, combat, taxes, the
 * pickers) are emitted by the core/game layer at the action's site
 * (snd_emit, colopy_core.h) and reach the backend through
 * colopy_next_sound(); they are not here.
 *
 * Rows the 2026-08-17 table carried that the bytes do NOT support were
 * removed (RULINGS 2026-09-02d): CANCELPEACE -> 0x58 (that site,
 * @0x220F9, is the Fortify command func_021FF2; the map-move treaty break
 * @0x3F22F has no play), CHIEFHOWDY -> 0x8024 (the site @0x48C41 pushes
 * MISSION0), BURNED/BURNED2/BURNED3 -> 0x53 (pushed @0x5DAE6/@0x5DB0B/
 * @0x5DB12 with no play site nearby), INDIANBURNCOLONY2 -> 0x53 (the
 * rival-colony arm @0x5DFEC is on the other side of the human gate),
 * INDIANWINCOLONY(2) -> 0x53 (see the row). */
#include <string.h>

#include "colopy_audio.h"
#include "colopy_audio_internal.h"

typedef struct {
    const char *key;
    uint16_t play;    /* au_cmd(id) when nonzero */
    uint16_t play2;   /* a second au_cmd(id), in order (the RAIDSHIP pair) */
    uint16_t queue;   /* au_queue_tune(id) when nonzero (0x181f:0x48e) */
    uint8_t cls_req;  /* au_class_request(cls) when nonzero (0x4ac) */
    uint8_t cls_set;  /* au_class_set(cls) when nonzero (0x498) */
} au_cue;

static const au_cue CUES[] = {
    /* native raids, func_05BE30 — every site gated on the target colony's
     * owner being human ([bp-0x22] < 4, controller 0):
     *   0x4F RAIDSTORES @0x5C3C2, 0x53 RAIDBURN @0x5C501,
     *   0x4B then 0x4D RAIDSHIP @0x5C569/@0x5C571 (the pair, in order),
     *   0x4E RAIDGOLD @0x5C5ED, 0x5B RAIDNOTHING @0x5C62D */
    {"RAIDSTORES", 0x4F, 0, 0, 0, 0},
    {"RAIDBURN", 0x53, 0, 0, 0, 0},
    {"RAIDSHIP", 0x4B, 0x4D, 0, 0, 0},
    {"RAIDGOLD", 0x4E, 0, 0, 0, 0},
    {"RAIDNOTHING", 0x5B, 0, 0, 0, 0},

    /* the land decider func_05CA7E, human colony owner ([bp-0x76] < 4,
     * controller 0 @0x5DFA6..0x5DFB5): colony burned -> 0x53 @0x5DFB7 +
     * queue tune 0x32 @0x5DFBF (+ woodcut 11 @0x5DFC9) before the
     * INDIANBURNCOLONY push @0x5DFE6; the colony holds -> queue tune 0x32
     * @0x5E013 before the INDIANWINCOLONY push @0x5E01F.  The natives'
     * colony-fight win sound 0x45 (@0x5D83A; 0x44 for a ship attacker,
     * which natives have none of) sits earlier in the same function, in
     * the [bp-4] "native won versus a colony" block @0x5D7B4..0x5D842 that
     * both message arms follow; the port fires it with the win row. */
    {"INDIANBURNCOLONY", 0x53, 0, 0x32, 0, 0},
    {"INDIANWINCOLONY", 0x45, 0, 0x32, 0, 0},

    /* the colony turn report: func_02CFD0's sound parameter [bp+0x12]
     * (@0x2D095..0x2D09E) is 0x8025 at exactly three of its 28 callers —
     * TRAINPROFESSION @0x2DF93 and @0x2E0E4, TRAINFAIL @0x2DFF3 — all under
     * the "Report when colonists trained" bit ([0x5384] & 0x80) */
    {"TRAINPROFESSION", 0x8025, 0, 0, 0, 0},
    {"TRAINFAIL", 0x8025, 0, 0, 0, 0},

    /* ship refit: 0x54 @0x2F1CD, REFIT pushed @0x2F1D7 */
    {"REFIT", 0x54, 0, 0, 0, 0},
    /* the Tea Party: 0x56 @0x346F6, TEAPARTY pushed @0x34700 */
    {"TEAPARTY", 0x56, 0, 0, 0, 0},
    /* a ship sunk: 0x57 @0x5BCCF (shown), SHIPSUNK pushed @0x5BD0F */
    {"SHIPSUNK", 0x57, 0, 0, 0, 0},

    /* missions: establish -> 0x8024 @0x48C41 (human power) before the
     * MISSION0 push @0x48B53's block; the fate roll @0x48EAA -> 0x8024 +
     * HERESY0 (@0x48EB7/@0x48EC1) or 0x53 + HERESY1 (@0x48EE6/@0x48EF0) */
    {"MISSION0", 0x8024, 0, 0, 0, 0},
    {"HERESY0", 0x8024, 0, 0, 0, 0},
    {"HERESY1", 0x53, 0, 0, 0, 0},
    /* live among the natives, chief killed: 0x55 @0x4AB9E, CHIEFKILL
     * @0x4ABAA (human power) */
    {"CHIEFKILL", 0x55, 0, 0, 0, 0},

    /* foreign intervention: `push 3; lcall 0x181f:0x498` (class SET 3)
     * @0x3D790, tune 0x3F @0x3D7B1, INTERVENE pushed @0x3D7BB */
    {"INTERVENE", 0x3F, 0, 0, 0, 3},

    /* war -> class-request 4 before every WAR-family / MERCENARY emit
     * (§24.4 tech ref; not re-read here) */
    {"DECLAREWAR", 0, 0, 0, 4, 0},
    {"KINGNEWWAR", 0, 0, 0, 4, 0},
    {"MERCENARIES", 0, 0, 0, 4, 0},
    {"MERCS", 0, 0, 0, 4, 0},
    {"INDIANWAR", 0, 0, 0, 4, 0},

    /* revolution -> class 3 @0x3DE88/@0x3D9A3/@0x3E2EF (§24.4) */
    {"DECLARE", 0, 0, 0, 3, 0},
    {"INDEPENDENCE", 0, 0, 0, 3, 0},

    /* Lost City rumours — §24.4 sites 0x61910/0x61ABB/0x61B42; the
     * row<->site pairing is by section text (not re-read here): */
    {"LOSTCITY1", 0x37, 0, 0, 0, 0},   /* Fountain of Youth @0x0618ED */
    {"LOSTCITY2", 0x3C, 0, 0, 0, 0},   /* Cibola */
    {"SCREWED", 0x32, 0, 0, 0, 0},     /* burial-ground doom (@0x61B42?) */
};

void au_on_event(const char *key, int32_t p0) {
    (void)p0;
    if (!key) return;
    for (unsigned i = 0; i < sizeof CUES / sizeof CUES[0]; i++) {
        if (strcmp(CUES[i].key, key) == 0) {
            const au_cue *c = &CUES[i];
            if (c->cls_set) au_class_set(c->cls_set);
            if (c->cls_req) au_class_request(c->cls_req);
            if (c->play) au_cmd(c->play);
            if (c->play2) au_cmd(c->play2);
            if (c->queue) au_queue_tune(c->queue);
            return;
        }
    }
}

/* The core's action cues (colopy_next_sound) -> the engine's verbs. */
void au_on_sound(int verb, uint16_t arg) {
    switch (verb) {
    case 0: au_cmd(arg); break;                       /* SND_PLAY */
    case 1: au_queue_tune(arg); break;                /* SND_QUEUE_TUNE */
    case 2: au_class_oneshot((uint8_t)arg); break;    /* SND_CLASS_ONESHOT */
    case 3: au_class_request((uint8_t)arg); break;    /* SND_CLASS_REQUEST */
    case 4: au_class_set((uint8_t)arg); break;        /* SND_CLASS_SET */
    case 5:                                           /* SND_PICK */
        au_set_current(arg);                          /* [0x96] @0x23561 */
        au_cmd(arg);                                  /* gated @0x23564 */
        break;
    case 6:                                           /* SND_SWITCHES */
        au_load_switches((uint8_t)arg);
        if ((arg & 0x0E) != 0x0E) au_cmd(1);          /* @0x23327..0x2333B */
        break;
    default: break;
    }
}

/* Woodcut plates — §24.4: 0/1/9 -> class 2; 3/4/5 -> the single-tune
 * classes 5/6/7 (0x33/0x35/0x36).  Plates 2 and 11 no longer carry a
 * sound here: 0x54 belongs to the founding itself (func_040C1E @0x40DF6,
 * every colony, before the once-only plate), and 0x53 + tune 0x32 belong
 * to the INDIANBURNCOLONY emit (@0x5DFB7/@0x5DFBF) — both now fire at
 * their own sites.  Woodcut 6's 0x39 cue @0x0054A2 has no caller in the
 * original (dead) — not wired. */
void au_on_woodcut(int plate) {
    switch (plate) {
    case 0:
    case 1:
    case 9:
        au_class_request(2);
        break;
    case 3:
        au_class_request(5);
        break;
    case 4:
        au_class_request(6);
        break;
    case 5:
        au_class_request(7);
        break;
    default:
        break;
    }
}

/* New game — tune 0x39 @0x756E4 (after 0x181F:0x4F2), queue 0x25 @0x759A0
 * later in the boot flow. Modelled as play-then-force (no stop between
 * them — the original's two sites run in boot order; a queue_tune here
 * would kill the 0x39 jingle). */
void au_on_new_game(void) {
    au_cmd(0x39);
    au_force_next_nostop(0x25);
}
