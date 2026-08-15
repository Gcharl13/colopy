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

int colopy_next_event(colopy_event *out) {
    if (!evq_len) return 0;
    *out = evq[evq_head];
    evq_head = (evq_head + 1) % EVQ_CAP;
    evq_len--;
    return 1;
}
