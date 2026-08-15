/* pak_check — C-port Phase 6: open COLOPY.PAK, validate the TOC and every
 * payload's internal offsets, and dump a census (JSON) the compare script
 * diffs against the JS DATA census (port/assets/manifest.json).
 *
 * The pack layout is the generated cport/data/colopy_pak.h contract; the
 * payload formats trace to formats/SS.md / PIK.md / FF.md / PAL.md via
 * tools/gen_sd_pack.py (byte-verified codecs, per CLAUDE.md). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../data/colopy_pak.h"

static unsigned rd16(const unsigned char *p) { return p[0] | (p[1] << 8); }
static unsigned rd32(const unsigned char *p) {
    return (unsigned)p[0] | ((unsigned)p[1] << 8) |
           ((unsigned)p[2] << 16) | ((unsigned)p[3] << 24);
}
static int rd16s(const unsigned char *p) { return (int)(short)rd16(p); }

static int ends_with(const char *n, const char *suf) {
    size_t ln = strlen(n), ls = strlen(suf);
    return ln >= ls && memcmp(n + ln - ls, suf, ls) == 0;
}

int pak_check_main(const char *path) {
    FILE *f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "pak: cannot open %s\n", path); return 1; }
    fseek(f, 0, SEEK_END);
    long fsz = ftell(f);
    fseek(f, 0, SEEK_SET);
    unsigned char *buf = (unsigned char *)malloc((size_t)fsz);
    if (!buf || fread(buf, 1, (size_t)fsz, f) != (size_t)fsz) {
        fprintf(stderr, "pak: short read\n");
        return 1;
    }
    fclose(f);

    if (fsz < COLOPY_PAK_HDRLEN || memcmp(buf, COLOPY_PAK_MAGIC, 4) != 0) {
        fprintf(stderr, "pak: bad magic\n");
        return 1;
    }
    unsigned count = rd16(buf + 4);
    long toc_end = COLOPY_PAK_HDRLEN + (long)count * COLOPY_PAK_TOCENT;
    if (toc_end > fsz) { fprintf(stderr, "pak: TOC overruns file\n"); return 1; }

    int bad = 0;
    unsigned long expect_off = (unsigned long)toc_end;
    printf("{\"count\":%u,\"entries\":[", count);
    for (unsigned i = 0; i < count; i++) {
        const unsigned char *e = buf + COLOPY_PAK_HDRLEN + i * COLOPY_PAK_TOCENT;
        char name[COLOPY_PAK_NAMELEN + 1];
        memcpy(name, e, COLOPY_PAK_NAMELEN);
        name[COLOPY_PAK_NAMELEN] = 0;
        unsigned off = rd32(e + 12), len = rd32(e + 16);
        unsigned w = rd16(e + 20), h = rd16(e + 22), frames = rd16(e + 24);
        const unsigned char *pl = buf + off;

        if (off != expect_off || (unsigned long)off + len > (unsigned long)fsz) {
            fprintf(stderr, "pak: %s offset/len out of place\n", name);
            bad = 1;
        }
        expect_off = (unsigned long)off + len;

        printf("%s{\"name\":\"%s\",\"w\":%u,\"h\":%u,\"frames\":%u,\"len\":%u",
               i ? "," : "", name, w, h, frames, len);

        if (ends_with(name, ".SS")) {
            unsigned nfr = rd16(pl), flags = rd16(pl + 2);
            unsigned long need = 4 + 12ul * nfr + (flags & 1 ? 768ul : 0);
            if (nfr != frames || len < need) {
                fprintf(stderr, "pak: %s sheet header inconsistent\n", name);
                bad = 1;
            }
            printf(",\"fw\":[");
            for (unsigned k = 0; k < nfr; k++) {
                const unsigned char *fe = pl + 4 + 12 * k;
                unsigned fw = rd16(fe + 4), fh = rd16(fe + 6);
                unsigned foff = rd32(fe + 8);
                (void)rd16s(fe);
                if ((unsigned long)foff + (unsigned long)fw * fh >
                    (unsigned long)len - (flags & 1 ? 768 : 0)) {
                    fprintf(stderr, "pak: %s frame %u pixels overrun\n",
                            name, k);
                    bad = 1;
                }
                printf("%s%u", k ? "," : "", fw);
            }
            printf("],\"fh\":[");
            for (unsigned k = 0; k < nfr; k++)
                printf("%s%u", k ? "," : "", rd16(pl + 4 + 12 * k + 6));
            printf("],\"pal\":%u", flags & 1);
        } else if (ends_with(name, ".PIK")) {
            unsigned long npx = (unsigned long)w * h;
            if (len != npx && len != npx + 768) {
                fprintf(stderr, "pak: %s pixel length mismatch\n", name);
                bad = 1;
            }
            printf(",\"pal\":%u", len == npx + 768);
        } else if (ends_with(name, ".FF")) {
            if (len < 386 || pl[0] != h || pl[1] != w) {
                fprintf(stderr, "pak: %s font header mismatch\n", name);
                bad = 1;
            }
            /* widths for the census: width(ch) = table[ch-1] (FF.md) —
             * the full 128-slot table (ch 1..128); FONTKING keys some
             * low control codes too */
            printf(",\"widths\":{");
            int first = 1;
            for (unsigned ch = 1; ch <= 128; ch++) {
                unsigned wd = pl[2 + ch - 1];
                if (!wd) continue;
                printf("%s\"%u\":%u", first ? "" : ",", ch, wd);
                first = 0;
            }
            printf("}");
        } else if (strcmp(name, "VICEROY.PAL") == 0) {
            if (len != 768) { fprintf(stderr, "pak: PAL len\n"); bad = 1; }
        } else if (strcmp(name, "CYCLE") == 0) {
            if (len != 6) { fprintf(stderr, "pak: CYCLE len\n"); bad = 1; }
            else printf(",\"cycle\":[%u,%u,%u]",
                        rd16(pl), rd16(pl + 2), rd16(pl + 4));
        } else if (strcmp(name, "TEXT") == 0) {
            unsigned n = rd32(pl);
            unsigned long base = 4 + 8ul * n;
            if (base > len) { fprintf(stderr, "pak: TEXT index\n"); bad = 1; }
            else {
                for (unsigned k = 0; k < n && !bad; k++) {
                    unsigned ko = rd32(pl + 4 + 8 * k);
                    unsigned vo = rd32(pl + 4 + 8 * k + 4);
                    if (ko >= len || vo >= len || pl[len - 1] != 0) {
                        fprintf(stderr, "pak: TEXT pair %u bounds\n", k);
                        bad = 1;
                    }
                }
                printf(",\"text\":%u", n);
            }
        }
        printf("}");
    }
    printf("],\"bytes\":%ld,\"ok\":%d}\n", fsz, !bad);
    free(buf);
    return bad;
}
