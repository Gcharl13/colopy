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
 * Terrain stat rows (DECODED 2026-06-09; closes NAMES_LOADER.md section 3):
 *   func_07637F trampoline -> thunk 0x1A1F:0xD20 -> real body file 0x745F0
 *   (= func_0745F0_terrain_row_load, role corrected).  Row @ DS:0x2F74+k*0x10:
 *     +0x00 word name ptr; +0x02 Movement; +0x03 Defensive; +0x04 Improvement;
 *     +0x05 Value; +0x06 derived later (@asm 0x074EAD); +0x07..+0x0F 9 yields.
 *   UNFORESTED k=0..7, FORESTED k=8..15 each REP-MOVSW copied to k+8 (rows
 *   16..23, @asm 0x074A6D..0x074A7C 0x2FF4->0x3074), OTHER k=24..28.
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <stdio.h>
#include <string.h>

#include "viceroy_types.h"
#include "dgroup.h"

/* RECONSTRUCTED string arena: top 4 KB of DGROUP (no byte-verified table
 * claims this region; revisit when the segment-24 interner is decoded). */
#define NAMES_ARENA_BASE  0xE000
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
 * Entry = name[, n0, n1, ...] -- per-entry numbers are consumed in order,
 * matching the DOS section-read API's next-NUMBER calls (0x1A1F:0x88A). */
typedef struct { char name[64]; int attr; int num[13]; int nums; } entry_t;

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
        out[n].nums = 0;
        for (char *q = comma; q && out[n].nums < 13; ) {
            out[n].num[out[n].nums++] = (int)strtol(q + 1, &q, 10);
            q = strchr(q, ',');
        }
        out[n].attr = out[n].nums ? out[n].num[0] : 0;
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

/* terrain stat rows -- mirror of func_0745F0_terrain_row_load (file 0x745F0,
 * the func_07637F trampoline target).  13 numbers per entry: Movement,
 * Defensive, Improvement, Value, then 9 yields. */
#define TROW(k)  (0x2F74 + ((k) << 4))            /* @asm 0x074604 shl bx,4 */

static int load_terrain(FILE *f, const char *tag, int count, int kbase)
{
    entry_t e[8];
    int n = read_section(f, tag, e, count);
    for (int i = 0; i < n; i++) {
        uint16_t row = TROW(kbase + i);
        DG16(row)        = intern(e[i].name);     /* @asm 0x074607 +0x00 name  */
        DG8(row + 0x02)  = (uint8_t)e[i].num[0];  /* @asm 0x074612 Movement    */
        DG8(row + 0x03)  = (uint8_t)e[i].num[1];  /* @asm 0x07461B Defensive   */
        DG8(row + 0x04)  = (uint8_t)e[i].num[2];  /* @asm 0x074624 Improvement */
        DG8(row + 0x05)  = (uint8_t)e[i].num[3];  /* @asm 0x07462D Value       */
        for (int j = 0; j < 9; j++)               /* @asm 0x074633..0x074645   */
            DG8(row + 0x07 + j) = (uint8_t)e[i].num[4 + j];
    }
    return n;
}

/* @CARGO: name + 9 numbers -> bytes [0x96FC + i*9 + 0..8]; weight = +1.
 * Decoded from the func_0749E0 continuation @0x74F04.. (9x 0x1A1F:0x88A
 * stores, stride 9). */
static int load_cargo(FILE *f)
{
    entry_t e[20];
    int n = read_section(f, "CARGO", e, 20);
    for (int i = 0; i < n; i++)
        for (int j = 0; j < 9 && j < e[i].nums; j++)
            DG8(0x96FC + i*9 + j) = (uint8_t)e[i].num[j];
    return n;
}

/* derived per-terrain cargo max -> row byte +0x2F7A (terrain row +0x06):
 * for t rows 0..0x1C: max over j=1..8 of cargo_weight[j] * yield[j]
 * (weight = signed byte [j*9+0x96FD]; yield byte [t*16+0x2F7B+j]).
 * Decoded @0x74F79..0x74FB2 (imul; cmp/jle; store @0x74FB2). */
static void derive_cargo_max(void)
{
    for (int t = 0; t <= 0x1C; t++) {
        int maxv = 0;
        for (int j = 1; j < 9; j++) {
            int prod = (int8_t)DG8(0x96FD + j*9) * (int8_t)DG8(0x2F7B + t*16 + j);
            if (prod > maxv) maxv = prod;
        }
        DG8(0x2F7A + t*16) = (uint8_t)maxv;
    }
}

/* @UNIT: 24 entries, stride 9 at [0x5230] -- name handle +0, icon +2,
 * movement*3 +4, col3->+6 / col4->+5 (the 0x5235/0x5236 SWAP), cols 5..10
 * -> +7..+0xC, bit-string -> +0xD.  Decoded @0x74ED5..0x74F64. */
static uint8_t parse_bits(const char *s)
{
    uint8_t v = 0;
    for (int i = 0; s[i] == '0' || s[i] == '1'; i++) v = (uint8_t)((v << 1) | (s[i] == '1'));
    return v;
}
static int load_units(FILE *f)
{
    char line[256]; int n = 0, in = 0;
    rewind(f);
    while (fgets(line, sizeof line, f) && n < 0x18) {
        char *p = line + strspn(line, " \t");
        if (*p == ';' || *p == '\r' || *p == '\n' || !*p) continue;
        if (*p == '@') { if (in) break; in = !strncmp(p, "@UNIT", 5) && p[5] < 'A'; continue; }
        if (!in) continue;
        int base = 0x5230 + n * 9;
        size_t len = strcspn(p, ",");
        { char sv=p[len]; p[len]=0;
          char *e=p+strlen(p); while(e>p&&e[-1]==' ')*--e=0;
          DG16(base) = intern(p); p[len]=sv; }                 /* @0x74EEE +0 name  */
        char *q = p + len; long col[12]; int nc = 0; char *bits = 0;
        while (*q == ',' && nc < 12) {
            q++;
            while (*q == ' ') q++;
            if (q[0]=='0'||q[0]=='1') { char *r=q; int b=1;
                while(*r=='0'||*r=='1') r++;
                if (r-q >= 6) { bits=q; col[nc++]=0; q=r; continue; } }
            col[nc++] = strtol(q, &q, 10);
        }
        DG8(base + 2)  = (uint8_t)col[0];                      /* @0x74EF9 icon   */
        DG8(base + 4)  = (uint8_t)(col[1] * 3);                /* @0x74F08 move*3 */
        DG8(base + 6)  = (uint8_t)col[2];                      /* @0x74F11 (swap) */
        DG8(base + 5)  = (uint8_t)col[3];                      /* @0x74F1A (swap) */
        for (int k = 0; k < 6 && 4 + k < nc; k++)
            DG8(base + 7 + k) = (uint8_t)col[4 + k];           /* @0x74F23..0x74F50 */
        if (bits) DG8(base + 0xD) = parse_bits(bits);          /* @0x74F59 */
        n++;
    }
    return n;
}

/* @LEVELS: 5 rows x 3 comma-separated strings -> [0x9632 + i*6 + 0/2/4]
 * (interned handles).  Decoded @0x7507A..0x750AE. */
static int load_levels(FILE *f)
{
    char line[256]; int n = 0, in = 0;
    rewind(f);
    while (fgets(line, sizeof line, f) && n < 5) {
        char *p = line + strspn(line, " \t");
        if (*p == ';' || *p == '\r' || *p == '\n' || !*p) continue;
        if (*p == '@') { if (in) break; in = !strncmp(p, "@LEVELS", 7); continue; }
        if (!in) continue;
        for (int col = 0; col < 3; col++) {
            size_t len = strcspn(p, ",\r\n");
            char save = p[len]; p[len] = 0;
            char *q = p; while (*q == ' ') q++;
            char *e2 = q + strlen(q); while (e2 > q && e2[-1] == ' ') *--e2 = 0;
            DG16(0x9632 + n*6 + col*2) = intern(q);
            p[len] = save;
            p += len + (save == ',');
            while (*p == ' ') p++;
        }
        n++;
    }
    return n;
}

/* @COLORS: one row of 9 numbers -> bytes [0x830..0x835],[0x837..0x839]
 * (0x836 skipped).  Decoded @0x751A2..0x751E7. */
static int load_colors(FILE *f)
{
    entry_t e[1];
    /* the row has no name field; read raw line */
    char line[256]; int in = 0;
    rewind(f);
    while (fgets(line, sizeof line, f)) {
        char *p = line + strspn(line, " \t");
        if (*p == ';' || !*p || *p == '\r' || *p == '\n') continue;
        if (*p == '@') { if (in) break; in = !strncmp(p, "@COLORS", 7); continue; }
        if (!in) continue;
        static const uint16_t slot[9] =
            {0x830,0x831,0x832,0x833,0x834,0x835,0x837,0x838,0x839};
        char *q = p - 1;
        for (int i = 0; i < 9 && q; i++) {
            DG8(slot[i]) = (uint8_t)(int)strtol(q + 1, &q, 10);
            q = strchr(q, ',');
        }
        return 9;
    }
    (void)e;
    return 0;
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
    total += load_terrain  (f, "UNFORESTED",   8,  0);              /* @asm 0x074A38 k=i    */
    total += load_terrain  (f, "FORESTED",     8,  8);              /* @asm 0x074A61 k=i+8  */
    /* each FORESTED row is REP-MOVSW duplicated to row k+8 (rows 16..23):
     * @asm 0x074A6D lea di,[bx+0x3074]; lea si,[bx+0x2FF4]; movsw x8 */
    for (int k = 8; k < 16; k++)
        memcpy(&DG8(TROW(k + 8)), &DG8(TROW(k)), 16);
    total += load_terrain  (f, "OTHER",        5,  24);             /* @asm 0x074AA1 k=i+0x18 */
    total += load_ptr_table(f, "OTHER_NAMES",  5,  0x2DB0, 0);      /* @asm 0x074AD1 */
    total += load_ptr_table(f, "RESOURCE",    14,  0x930C, 0x97B2); /* @asm 0x074AFF */
    total += load_ptr_table(f, "COUNTRY",      4,  0x8D42, 0x0848); /* @asm 0x074B39 */
    total += load_ptr_table(f, "NATIONALITY",  4,  0x8D0A, 0);      /* @asm 0x074B6E */
    total += load_ptr_table(f, "NATIONABBREV", 4,  0x97F0, 0);      /* @asm 0x074B97 */
    total += load_ptr_table(f, "HOMEPORT",     4,  0x838C, 0);      /* @asm 0x074BC0 */
    total += load_rec_strings(f, "COLONYNAME", 4,  0x5426);         /* @asm 0x074BEA */
    total += load_rec_strings(f, "LEADERNAME", 4,  0x540E);         /* @asm 0x074C22 */
    /* func_0749E0 CONTINUATION (the '601 byte' size was a truncation; the
     * real body runs to 0x75351 and loads the rest of NAMES + LABELS + PEDIA): */
    total += load_units(f);                                          /* @0x74ED5 */
    total += load_cargo(f);                                          /* @0x74F04 */
    derive_cargo_max();                                              /* @0x74F79 */
    total += load_levels(f);                                         /* @0x7507A */
    total += load_colors(f);                                         /* @0x751A2 */
    /* UNFORESTED/FORESTED/OTHER terrain rows: blocked on func_07637F decode */

    fclose(f);
    return total;
}

/* ============================================================================
 * LABELS.TXT + PEDIA.TXT  (the func_0749E0 tail, decoded 2026-06-10)
 *   @INFO      4  -> [0x96F4+i*2]   @0x751FD   @CMISC    3 -> [0x9398+i*2] @0x75279
 *   @MISC    221  -> [0x2DBA+i*2]   @0x75226   @CTITLE  10 -> [0x939E+i*2] @0x752A2
 *   @ROUTE     9  -> [0x93DE+i*2]   @0x75250   @CMESSAGE 19-> [0x93B2+i*2] @0x752CB
 *   @EUROLABEL 3  -> [0x93D8+i*2]   @0x752F4
 *   PEDIA @MISCELLANEOUS: count line -> [0x846]; strs -> [0x935C+i*2] @0x7530B
 * All entries interned; tables hold 16-bit handles (modern: arena offsets).
 * ============================================================================ */
static int load_str_table(FILE *f, const char *tag, int count, uint16_t tbl)
{
    entry_t e[224];
    int n = read_section(f, tag, e, count);
    for (int i = 0; i < n; i++)
        DG16(tbl + i*2) = intern(e[i].name);
    return n;
}

int viceroy_load_labels(const char *dir)
{
    char path[512];
    snprintf(path, sizeof path, "%s/LABELS.TXT", dir);
    FILE *f = fopen(path, "r");
    if (!f) return -1;
    int total = 0;
    total += load_str_table(f, "INFO",      4,   0x96F4);  /* @0x751FD */
    total += load_str_table(f, "MISC",      221, 0x2DBA);  /* @0x75226 loop<0xDD */
    total += load_str_table(f, "ROUTE",     9,   0x93DE);  /* @0x75250 loop<9 */
    total += load_str_table(f, "CMISC",     3,   0x9398);  /* @0x75279 loop<3 */
    total += load_str_table(f, "CTITLE",    10,  0x939E);  /* @0x752A2 loop<0xA */
    total += load_str_table(f, "CMESSAGE",  19,  0x93B2);  /* @0x752CB loop<0x13 */
    total += load_str_table(f, "EUROLABEL", 3,   0x93D8);  /* @0x752F4 loop<3 */
    fclose(f);

    snprintf(path, sizeof path, "%s/PEDIA.TXT", dir);
    f = fopen(path, "r");
    if (f) {
        entry_t e[64];
        int n = read_section(f, "MISCELLANEOUS", e, 64);
        if (n > 0) {
            int cnt = e[0].name[0] >= '0' && e[0].name[0] <= '9'
                    ? atoi(e[0].name) : 0;                 /* count line @0x75321 */
            DG16(0x846) = (uint16_t)cnt;
            for (int i = 0; i < cnt && i + 1 < n; i++)
                DG16(0x935C + i*2) = intern(e[i + 1].name); /* @0x7533E */
            total += cnt;
        }
        fclose(f);
    }
    return total;
}

/* string-handle service (the modern face of 0x181F:0x22): handles are arena
 * offsets inside g_dgroup, so the text IS at &DG8(handle). */
const char *viceroy_str(uint16_t handle)
{
    return handle ? (const char *)&DG8(handle) : "";
}

#endif /* _VICEROY_MODERN */
