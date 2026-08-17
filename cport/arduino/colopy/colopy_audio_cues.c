/* Event/woodcut -> audio cue table.
 *
 * Source: the byte-cited event->cue map, docs/COLONIZATION_TECHNICAL_
 * REFERENCE.md §24.4 (sites quoted per row). The KEY pairing maps each
 * cited cue onto the event key the cport core actually emits; where the
 * pairing rests on the GAME.TXT section text rather than a traced call
 * site it is tagged [inferred] — those rows are judgement, not bytes.
 * Rows the spec knows about but cport cannot trigger yet (European first
 * contact fanfare 0x8020+power; combat SFX ids, which no spec row names)
 * are listed at the bottom as TBD, not guessed. */
#include <string.h>

#include "colopy_audio.h"
#include "colopy_audio_internal.h"

typedef struct {
    const char *key;
    uint16_t play;    /* au_cmd(id) when nonzero */
    uint8_t cls;      /* au_class_request(cls) when nonzero */
} au_cue;

static const au_cue CUES[] = {
    /* native raids — §24.4 sfx trio + ship pair, keys matched to the
     * raid outcome texts (@RAID* in GAME.TXT):
     *   0x4E gold seized @0x5C3CC-family, 0x4F stores looted,
     *   0x5B "raiding party wiped out", 0x4B(+0x4D) raid-takes-ship */
    {"RAIDGOLD", 0x4E, 0},
    {"RAIDSTORES", 0x4F, 0},
    {"RAIDNOTHING", 0x5B, 0},
    {"RAIDSHIP", 0x4B, 0},          /* the 0x4D half of the pair: TBD */
    {"RAIDBURN", 0x53, 0},          /* [inferred] burn family -> 0x53 */

    /* colony burn / massacre — sfx 0x53 @0x05DFCB, @0x48EE6 */
    {"BURNED", 0x53, 0},
    {"BURNED2", 0x53, 0},
    {"BURNED3", 0x53, 0},
    {"INDIANBURNCOLONY", 0x53, 0},
    {"INDIANBURNCOLONY2", 0x53, 0},
    {"INDIANWINCOLONY", 0x53, 0},   /* [inferred] massacre family */
    {"INDIANWINCOLONY2", 0x53, 0},  /* [inferred] */

    /* treaty-break attack — sfx 0x58 @0x220F9 */
    {"CANCELPEACE", 0x58, 0},

    /* war -> class-request 4 before every WAR-family / MERCENARY emit */
    {"DECLAREWAR", 0, 4},
    {"KINGNEWWAR", 0, 4},
    {"MERCENARIES", 0, 4},
    {"MERCS", 0, 4},
    {"INDIANWAR", 0, 4},

    /* revolution -> class 3 @0x3DE88/@0x3D790/@0x3D9A3/@0x3E2EF;
     * intervention arrival additionally plays 0x3F @0x3D7B1 */
    {"DECLARE", 0, 3},
    {"INDEPENDENCE", 0, 3},
    {"INTERVENTION", 0x3F, 3},

    /* Lost City rumours — §24.4 sites 0x61910/0x61ABB/0x61B42; the
     * row<->site pairing is by section text: */
    {"LOSTCITY1", 0x37, 0},         /* Fountain of Youth -> 0x37 @0x0618ED */
    {"LOSTCITY2", 0x3C, 0},         /* Cibola -> "sound 0x3C" */
    {"SCREWED", 0x32, 0},           /* [inferred] burial-ground doom ->
                                     * 0x32 Indian Victory (@0x61B42?) */

    /* native meetings — fanfare bank 0x8024 @0x48C41/@0x48EB7 */
    {"CHIEFHOWDY", 0x8024, 0},      /* [inferred] key pairing */
};

void au_on_event(const char *key, int32_t p0) {
    (void)p0;
    if (!key) return;
    for (unsigned i = 0; i < sizeof CUES / sizeof CUES[0]; i++) {
        if (strcmp(CUES[i].key, key) == 0) {
            if (CUES[i].cls) au_class_request(CUES[i].cls);
            if (CUES[i].play) au_cmd(CUES[i].play);
            return;
        }
    }
    /* TBD (spec'd, no cport trigger yet): European first contact
     * fanfare 0x8020+power (@0x58040); combat SFX (no byte-cited ids). */
}

/* Woodcut plates — §24.4: 0/1/9 -> class 2; 3/4/5 -> the single-tune
 * classes 5/6/7 (0x33/0x35/0x36); 2 (first colony) -> sfx 0x54 @0x040E00;
 * 11 (colony burning) -> sfx 0x53 + tune 0x32 @0x05DFCB. Woodcut 6's
 * 0x39 cue @0x0054A2 has no caller in the original (dead) — not wired. */
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
    case 2:
        au_cmd(0x54);
        break;
    case 11:
        au_cmd(0x53);
        au_queue_tune(0x32);
        break;
    default:
        break;
    }
}

/* New game — §24.4: tune 0x39 @0x756E4, queue 0x25 @0x759A0. Modelled as
 * play-then-force (no stop between them — the original's two sites run in
 * boot order; a queue_tune here would kill the 0x39 jingle). */
void au_on_new_game(void) {
    au_cmd(0x39);
    au_force_next_nostop(0x25);
}
