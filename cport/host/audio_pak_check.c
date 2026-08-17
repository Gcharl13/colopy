/* audio_pak_check — audio milestone: open COLAUDIO.PAK, validate the TOC
 * and payload structure, and dump a census (JSON).
 *
 * Layout contract: generated cport/data/colopy_audio_pak.h
 * (tools/gen_audio_pack.py). Provenance: empirical-capture tier — see
 * docs/AUDIO_PORT.md; this validator additionally proves the SFX payloads
 * are verbatim COLDIG.BIN slices whenever raw/COLONIZE/COLDIG.BIN is
 * present on the host (the bit-clean guarantee). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../data/colopy_audio_pak.h"

static unsigned rd16(const unsigned char *p) { return p[0] | (p[1] << 8); }
static unsigned rd32(const unsigned char *p) {
    return (unsigned)p[0] | ((unsigned)p[1] << 8) |
           ((unsigned)p[2] << 16) | ((unsigned)p[3] << 24);
}

static unsigned char *read_all(const char *path, long *out_sz) {
    FILE *f = fopen(path, "rb");
    if (!f) return NULL;
    fseek(f, 0, SEEK_END);
    long sz = ftell(f);
    fseek(f, 0, SEEK_SET);
    unsigned char *buf = (unsigned char *)malloc((size_t)sz);
    if (!buf || fread(buf, 1, (size_t)sz, f) != (size_t)sz) {
        fclose(f);
        free(buf);
        return NULL;
    }
    fclose(f);
    *out_sz = sz;
    return buf;
}

int audio_pak_check_main(const char *path, const char *coldig_path) {
    long fsz = 0;
    unsigned char *buf = read_all(path, &fsz);
    if (!buf) { fprintf(stderr, "audiopak: cannot read %s\n", path); return 1; }

    if (fsz < CAUD_HDRLEN || memcmp(buf, CAUD_MAGIC, 4) != 0) {
        fprintf(stderr, "audiopak: bad magic\n");
        return 1;
    }
    unsigned ver = rd16(buf + 4), count = rd16(buf + 6), rate = rd16(buf + 8);
    if (ver != CAUD_VERSION) {
        fprintf(stderr, "audiopak: version %u != %u\n", ver, CAUD_VERSION);
        return 1;
    }
    long toc_end = CAUD_HDRLEN + (long)count * CAUD_TOCENT;
    if (toc_end > fsz) { fprintf(stderr, "audiopak: TOC overruns file\n"); return 1; }

    long coldig_sz = 0;
    unsigned char *coldig = coldig_path ? read_all(coldig_path, &coldig_sz) : NULL;

    int bad = 0;
    unsigned prev_id = 0;
    unsigned long expect_off = (unsigned long)toc_end;
    printf("{\"count\":%u,\"mix_rate\":%u,\"entries\":[", count, rate);
    for (unsigned i = 0; i < count; i++) {
        const unsigned char *e = buf + CAUD_HDRLEN + i * CAUD_TOCENT;
        unsigned id = rd16(e), codec = e[2], flags = e[3], erate = rd16(e + 4);
        unsigned off = rd32(e + 8), len = rd32(e + 12);

        if (i && id <= prev_id) { fprintf(stderr, "audiopak: ids not ascending at 0x%X\n", id); bad++; }
        prev_id = id;
        if (off != expect_off || (unsigned long)off + len > (unsigned long)fsz) {
            fprintf(stderr, "audiopak: 0x%X offset/len out of place\n", id);
            bad++;
        }
        expect_off = (unsigned long)off + len;

        if (codec == CAUD_CODEC_IMA4) {
            if (len % CAUD_BLOCK_BYTES != 0) {
                fprintf(stderr, "audiopak: 0x%X IMA payload not block-aligned\n", id);
                bad++;
            } else {
                /* walk block headers: step_index sane, pad zero */
                for (unsigned long b = 0; b < len; b += CAUD_BLOCK_BYTES) {
                    const unsigned char *blk = buf + off + b;
                    if (blk[2] > 88 || blk[3] != 0) {
                        fprintf(stderr, "audiopak: 0x%X bad IMA block header @%lu\n", id, b);
                        bad++;
                        break;
                    }
                }
            }
        } else if (codec == CAUD_CODEC_PCM8U) {
            /* bit-clean check: this exact byte string must appear in the
             * bank at some offset (the slice table names it; the pak does
             * not carry the offset, so search — the bank is ~1 MB). */
            if (coldig && len && len <= (unsigned long)coldig_sz) {
                const unsigned char *hit = NULL;
                const unsigned char *hay = coldig;
                long remain = coldig_sz;
                while (remain >= (long)len) {
                    const unsigned char *p =
                        (const unsigned char *)memchr(hay, buf[off], (size_t)(remain - len + 1));
                    if (!p) break;
                    if (memcmp(p, buf + off, len) == 0) { hit = p; break; }
                    remain -= (long)(p - hay) + 1;
                    hay = p + 1;
                }
                if (!hit) {
                    fprintf(stderr, "audiopak: 0x%X PCM payload not found in COLDIG.BIN\n", id);
                    bad++;
                }
            }
        } else {
            fprintf(stderr, "audiopak: 0x%X unknown codec %u\n", id, codec);
            bad++;
        }
        printf("%s{\"id\":\"0x%X\",\"codec\":%u,\"flags\":%u,\"rate\":%u,"
               "\"len\":%u}", i ? "," : "", id, codec, flags, erate, len);
    }
    printf("],\"coldig_checked\":%s,\"bad\":%d}\n",
           coldig ? "true" : "false", bad);
    free(coldig);
    free(buf);
    return bad ? 1 : 0;
}
