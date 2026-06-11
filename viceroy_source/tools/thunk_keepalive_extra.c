/* thunk_keepalive_extra.c -- COMMITTED companion to the generated
 * tools/generated/thunk_keepalive.c.  Forces archive-member extraction
 * for ported functions that are NOT in the overlay-thunk table and
 * therefore absent from the generated keepalive.  Add one entry here
 * whenever a new port whose strong definition would otherwise lose to
 * the weak stub in linkfloor_stubs.c. */

extern char ai_unit_leaf;           /* src/ai/unit_ai_leaf.c       */
extern char func_008734_logic_sz_30; /* src/load_image/ (bld_pop)   */

void *viceroy_port_keepalive[] = {
    (void *)&ai_unit_leaf,
    (void *)&func_008734_logic_sz_30,
};
