/* stub_hits.c -- COMMITTED runtime for the generated stub-hit counter
 * (Gate G1 instrumentation; see tools/linkgap.py stub emission).
 *
 * Every weak no-op stub in tools/generated/linkfloor_stubs.c calls
 * viceroy_stub_hit(symbol_name) when executed.  The table records which
 * unported leaves the run actually reached, and how often -- the gates
 * (ROUTE_B_PLAN G1/G4) require ZERO hits for engine symbols on the soak
 * paths; the remaining rows are the live Phase-4 worklist, ranked.
 *
 * viceroy_stub_report() prints "count symbol" rows, hottest first.  The
 * smoke/soak harness calls it after the run.  Interned pointers are the
 * stubs' string literals, so identity compare is enough.
 */
#include <stdio.h>

#define STUB_HIT_SLOTS 1024

struct stub_hit { const char *sym; unsigned long n; };
static struct stub_hit g_hits[STUB_HIT_SLOTS];
static int g_nhits;
static unsigned long g_lost;          /* hits beyond table capacity */

void viceroy_stub_hit(const char *sym)
{
    for (int i = 0; i < g_nhits; i++) {
        if (g_hits[i].sym == sym) {   /* same literal -> same pointer */
            g_hits[i].n++;
            return;
        }
    }
    if (g_nhits < STUB_HIT_SLOTS) {
        g_hits[g_nhits].sym = sym;
        g_hits[g_nhits].n = 1;
        g_nhits++;
    } else {
        g_lost++;
    }
}

int viceroy_stub_report(void)
{
    /* insertion sort, hottest first: the table is small and this runs once */
    for (int i = 1; i < g_nhits; i++)
        for (int j = i; j > 0 && g_hits[j].n > g_hits[j-1].n; j--) {
            struct stub_hit t = g_hits[j];
            g_hits[j] = g_hits[j-1];
            g_hits[j-1] = t;
        }
    unsigned long total = 0;
    for (int i = 0; i < g_nhits; i++) total += g_hits[i].n;
    fprintf(stderr, "stub-hits: %d distinct symbols, %lu calls%s\n",
            g_nhits, total, g_lost ? " (table overflow!)" : "");
    for (int i = 0; i < g_nhits; i++)
        fprintf(stderr, "  %10lu  %s\n", g_hits[i].n, g_hits[i].sym);
    return g_nhits;
}
