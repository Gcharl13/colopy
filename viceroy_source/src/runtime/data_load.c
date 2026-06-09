/* ============================================================================
 * data_load.c -- modern-host NAMES.TXT loader (mirror of func_0749E0)
 * ----------------------------------------------------------------------------
 * _VICEROY_MODERN only.  Populates the DGROUP name tables from the game's own
 * NAMES.TXT, byte-for-byte at the destinations the DOS loader func_0749E0
 * writes (docs/NAMES_LOADER.md, all cites @asm 0x0749E0..0x074C39).  The
 * COPYRIGHT CONSTRAINT holds: everything here reads the user-supplied data
 * file at runtime; no game bytes are embedded in this source.
 *
 * Byte-verified destinations implemented exactly:
 *   SEASONS       2 word-ptrs   -> DS:0x9800            @asm 0x074A15
 *   OTHER_NAMES   5 word-ptrs   -> DS:0x2DB0            @asm 0x074AD1
 *   RESOURCE     14 word-ptrs   -> DS:0x930C
 *                14 attr bytes  -> DS:0x97B2            @asm 0x074AFF/0x074B0B
 *   COUNTRY       4 word-ptrs   -> DS:0x8D42
 *                 4 attr bytes  -> DS:0x0848 (color)    @asm 0x074B39/0x074B45
 *   NATIONALITY   4 word-ptrs   -> DS:0x8D0A            @asm 0x074B6E
 *   NATIONABBREV  4 word-ptrs   -> DS:0x97F0            @asm 0x074B97
 *   HOMEPORT      4 word-ptrs   -> DS:0x838C            @asm 0x074BC0
 *   COLONYNAME    4 strcpy      -> DS:0x5426 + i*0x34   @asm 0x074BEA
 *                                  (PowerRecord name field, stride 0x34)
 *   LEADERNAME    4 strcpy      -> DS:0x540E + i*0x34   @asm 0x074C22
 *                                  (AIPersonality leader field, stride 0x34)
 *
 * RECONSTRUCTED (marked, not byte-verified):
 *   - The string-intern arena.  The DOS interner (0x1A1F:0xB22/0xB16) lives in
 *     overlay segment 24, AMBIG in the flattener segmap -- its arena base is
 *     not yet decoded.  Strings are interned into a bump arena at the top of
 *     DGROUP (NAMES_ARENA_BASE) and the tables store 16-bit DGROUP offsets,
 *     same shape as the original near pointers.  Validation note: pointer
 *     WORDS in these tables are excluded from memcmp-vs-original (near-pointer
 *     values depend on the DOS heap layout); the STRINGS and ATTR BYTES are
 *     the comparable data.
 *   - Terrain stat rows (UNFORESTED/FORESTED/OTHER via func_07637F) are NOT
 *     loaded yet: that sub-loader is the last not-yet-decoded-inner of
 *     func_0749E0 (NAMES_LOADER.md section 3) -- filling DS:0x2F74.. rows without
 *     the decoded layout would be fabrication.
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include <string.h>

#include "viceroy_types.h"
#include "dgroup.h"

/* RECONSTRUCTED string arena: top 4 KB of DGROUP (no byte-verified table
 * claims this region; revisit when the segment-24 interner is decoded). */
#define NAMES_ARENA_BASE  0xF000
#define NAMES_ARENA_END   0xFFF0
static uint16_t arena_next = NAMES_ARENA_BASE;

static uint16_t intern(const char *s)
{
    uint16_t len = (uint16_t)strlen(s) + 1;
    if (arena_next + len > NAMES_ARENA_END) return 0;
    uint16_t at = arena_next;
    memcpy(&DG8(at), s, len);
    arena_next += len;
    return at;
}

/* ---- NAMES.TXT scanning --------------------------------------------------
 * Format: `;` comment lines, `@TAG` section heads, entries one per line.
 * Entry = name[, attr[, ...]] -- the loader takes the name and (optionally)
 * the FIRST numeric field, matching the DOS per-entry attribute read. */
typedef struct { char name[64]; int attr; } entry_t;

static int read_section(FILE *f, const char *tag, entry_t *out, int max)
{
    char line[256];
    int n = 0, in = 0;
    rewind(f);
    while (fgets(line, sizeof line, f)) {
        char *p = line;
        while (*p == ' ' || *p == '\t') p++;
        if (*p == ';' || *p == '\r' || *p == '\n' || !*p) continue;
        if (*p == '@') {
            if (in) break;                       /* next section: done */
            in = !strncmp(p + 1, tag, strlen(tag)) &&
                 (p[1 + strlen(tag)] == '\0' || p[1 + strlen(tag)] == '\n' ||
                  p[1 + strlen(tag)] == '\r');
            continue;
        }
        if (!in || n >= max) continue;
        char *comma = strchr(p, ',');
        size_t len = comma ? (size_t)(comma - p) : strcspn(p, "\r\n");
        while (len && (p[len-1] == ' ' || p[len-1] == '\t')) len--;
        if (len >= sizeof out[n].name) len = sizeof out[n].name - 1;
        memcpy(out[n].name, p, len); out[n].name[len] = 0;
        out[n].attr = comma ? (int)strtol(comma + 1, 0, 10) : 0;
        n++;
    }
    return n;
}

/* store a section as a word table of interned-string offsets (+ attr bytes) */
static int load_ptr_table(FILE *f, const char *tag, int count,
                          uint16_t tbl, uint16_t attr_tbl)
{
    entry_t e[16];
    int n = read_section(f, tag, e, count);
    for (int i = 0; i < n; i++) {
        DG16(tbl + i*2) = intern(e[i].name);
        if (attr_tbl) DG8(attr_tbl + i) = (uint8_t)e[i].attr;
    }
    return n;
}

/* store a section as in-place strcpy into stride-0x34 records */
static int load_rec_strings(FILE *f, const char *tag, int count, uint16_t base)
{
    entry_t e[8];
    int n = read_section(f, tag, e, count);
    for (int i = 0; i < n; i++) {
        size_t len = strlen(e[i].name) + 1;
        memcpy(&DG8(base + i*0x34), e[i].name, len);
    }
    return n;
}

int viceroy_load_names(const char *dir)
{
    char path[512];
    snprintf(path, sizeof path, "%s/NAMES.TXT", dir);
    FILE *f = fopen(path, "r");
    if (!f) { fprintf(stderr, "data_load: cannot open %s\n", path); return -1; }

    arena_next = NAMES_ARENA_BASE;
    int total = 0;
    total += load_ptr_table(f, "SEASONS",      2,  0x9800, 0);      /* @asm 0x074A15 */
    total += load_ptr_table(f, "OTHER_NAMES",  5,  0x2DB0, 0);      /* @asm 0x074AD1 */
    total += load_ptr_table(f, "RESOURCE",    14,  0x930C, 0x97B2); /* @asm 0x074AFF */
    total += load_ptr_table(f, "COUNTRY",      4,  0x8D42, 0x0848); /* @asm 0x074B39 */
    total += load_ptr_table(f, "NATIONALITY",  4,  0x8D0A, 0);      /* @asm 0x074B6E */
    total += load_ptr_table(f, "NATIONABBREV", 4,  0x97F0, 0);      /* @asm 0x074B97 */
    total += load_ptr_table(f, "HOMEPORT",     4,  0x838C, 0);      /* @asm 0x074BC0 */
    total += load_rec_strings(f, "COLONYNAME", 4,  0x5426);         /* @asm 0x074BEA */
    total += load_rec_strings(f, "LEADERNAME", 4,  0x540E);         /* @asm 0x074C22 */
    /* UNFORESTED/FORESTED/OTHER terrain rows: blocked on func_07637F decode */

    fclose(f);
    return total;
}

#endif /* _VICEROY_MODERN */
