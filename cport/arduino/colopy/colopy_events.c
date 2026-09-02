/* The game->front-end event queue (colopy_core.h contract).
 *
 * Fixed ring, no allocation. Overflow POLICY: dropping a notice silently
 * would hide game outcomes, so emit asserts headroom in debug builds and
 * overwrites the OLDEST notice in release — the newest information wins,
 * and the drop is counted where the front end can see it. Blocking
 * questions are never dropped (the machine stalls on them by design). */
#include <string.h>

#include "colopy_core.h"
#include "colopy_sim.h"

#define EVQ_CAP 64

static colopy_event evq[EVQ_CAP];
static int evq_head, evq_len;
static uint32_t evq_dropped;

void ev_reset(void) { evq_head = evq_len = 0; evq_dropped = 0; }
uint32_t ev_dropped(void) { return evq_dropped; }

void ev_emit(const char *key, int32_t p0, int32_t p1,
             const char *s0, const char *s1) {
    colopy_event *e;
    if (evq_len == EVQ_CAP) {
        evq_head = (evq_head + 1) % EVQ_CAP;   /* overwrite oldest */
        evq_len--;
        evq_dropped++;
    }
    e = &evq[(evq_head + evq_len) % EVQ_CAP];
    memset(e, 0, sizeof(*e));
    strncpy(e->key, key, sizeof(e->key) - 1);
    e->p[0] = p0;
    e->p[1] = p1;
    e->s[0] = s0;
    e->s[1] = s1;
    evq_len++;
}

/* The key of the event emitted most recently — the PROMPT for the ask that
 * follows it (the core's invariant pattern, see ask_choice).  The A0/A1
 * answer markers ask_choice emits itself are skipped, so two asks with no
 * prompt between them still see the real prompt.  "" if nothing qualifies. */
const char *ev_last_key(void) {
    for (int i = evq_len - 1; i >= 0; i--) {
        const char *k = evq[(evq_head + i) % EVQ_CAP].key;
        if (k[0] == 'A' && (k[1] == '0' || k[1] == '1') && !k[2]) continue;
        return k;
    }
    return "";
}

int colopy_next_event(colopy_event *out) {
    if (!evq_len) return 0;
    *out = evq[evq_head];
    evq_head = (evq_head + 1) % EVQ_CAP;
    evq_len--;
    return 1;
}

/* The sound-cue ring (colopy_core.h): the same overflow policy as the
 * notices — the oldest cue is dropped, since a play the shell never saw
 * is a missed sound, not a missed outcome.  Sixteen is more than one
 * command ever fires (the deepest chain is a raid's pair + a tune). */
#define SNDQ_CAP 16
static colopy_sound sndq[SNDQ_CAP];
static int sndq_head, sndq_len;

void snd_emit(int verb, uint16_t arg) {
    if (sndq_len == SNDQ_CAP) {
        sndq_head = (sndq_head + 1) % SNDQ_CAP;
        sndq_len--;
    }
    colopy_sound *s = &sndq[(sndq_head + sndq_len) % SNDQ_CAP];
    s->verb = (uint8_t)verb;
    s->arg = arg;
    sndq_len++;
}

int colopy_next_sound(colopy_sound *out) {
    if (!sndq_len) return 0;
    *out = sndq[sndq_head];
    sndq_head = (sndq_head + 1) % SNDQ_CAP;
    sndq_len--;
    return 1;
}
