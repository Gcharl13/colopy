/* dos_service_glue.c -- Modern replacements for DOS service / video address stubs
 * that are called from the ported C code but have no 1:1 modern equivalent.
 *
 * All functions here are defined with strong (T) linkage so the linker's
 * PROVIDE aliases can resolve the corresponding overlay_call_XXXX_XXXX stubs.
 */
#include "viceroy.h"
#include "dgroup.h"

/* overlay_call_0D1C_0000 -> file 0x0F5C0
 * DOS VGA segment:offset address calculator (uses 0xa000 segment).
 * In the modern host there is no VGA buffer; return 0. */
int func_0F5C0_vga_addr_calc(void) {
    return 0;
}

/* overlay_call_0A4E_0008 -> file 0x0C8E8
 * Screen-address helper: computes a flat VGA address from cx=x, ax=y or
 * similar register-based convention. No-op in the modern host. */
int func_0C8E8_screen_addr_helper(void) {
    return 0;
}

/* overlay_call_0427_0002 -> file 0x06672
 * Colony-data lookup with register-based arg (ax on entry).
 * Returns an index. No-op structural stub. */
int func_06672_colony_data_lookup(void) {
    return 0;
}

/* overlay_call_181F_0088 -> file 0x026B2 (not in known function span)
 * Reads strlen of DGROUP:0x2D54 and conditionally writes a byte nearby.
 * Structural stub. */
int func_026B2_name_buf_composite(void) {
    return 0;
}

/* overlay_call_0D1D_0E4A -> file 0x01041A (INT 21h AH=41h = delete file)
 * Deletes the file named by the near-pointer arg passed in register DX. */
int func_01041A_dos_delete_file(uint16_t name_nearptr) {
    (void)name_nearptr;
    return 0;
}

/* overlay_call_0D1D_0E63 -> file 0x010433 (INT 21h AH=4Eh/4Fh = FindFirst/FindNext)
 * DOS FindFirst/FindNext: returns 0 (no-op; callers treat 0 as "found nothing"). */
int func_010433_dos_find_next(void) {
    return 1;  /* non-zero = not found / done */
}

/* overlay_call_181F_000E -> func_002400 -> file 0x002400
 * NAMES module initialiser: allocates a names table block and resets counter.
 * Structural stub: heap allocation not implemented. */
int func_002400_names_init(uint16_t base_nearptr, uint16_t flags) {
    (void)base_nearptr; (void)flags;
    DGS16(0x2d52) = 0;
    return 0;
}

/* overlay_call_181F_0018 -> func_00242C -> file 0x00242C
 * NAMES string intern: allocs a block for a string copy, returns the slot index.
 * Structural stub: returns 0. */
int func_00242C_names_intern(uint16_t str_lo, uint16_t str_hi) {
    (void)str_lo; (void)str_hi;
    return DGS16(0x2d52)++;
}
