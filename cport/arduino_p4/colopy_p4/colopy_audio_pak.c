/* COLAUDIO.PAK reader — buffer mode (whole pak in RAM) or streaming mode
 * (SD, via the shell's read callback). Layout contract: the generated
 * cport/data/colopy_audio_pak.h (tools/gen_audio_pack.py). */
#include <string.h>

#include "colopy_audio_pak.h"
#include "colopy_audio.h"
#include "colopy_audio_internal.h"

#define AU_MAX_ENTRIES 96

static au_entry toc[AU_MAX_ENTRIES];
static int toc_n = 0;

static const uint8_t *ram_pak = 0;
static uint32_t pak_len = 0;
static au_read_fn stream_rd = 0;
static void *stream_ctx = 0;

int au_pak_ready(void) { return toc_n > 0; }

int au_pak_read(uint32_t off, void *dst, uint32_t len) {
    if (off + len > pak_len) return 0;
    if (ram_pak) {
        memcpy(dst, ram_pak + off, len);
        return 1;
    }
    if (stream_rd) return stream_rd(stream_ctx, off, dst, len);
    return 0;
}

const au_entry *au_pak_find(uint16_t id) {
    int lo = 0, hi = toc_n - 1;          /* TOC is id-sorted by generator */
    while (lo <= hi) {
        int mid = (lo + hi) / 2;
        if (toc[mid].id == id) return &toc[mid];
        if (toc[mid].id < id) lo = mid + 1;
        else hi = mid - 1;
    }
    return 0;
}

static unsigned rd16(const uint8_t *p) { return p[0] | (p[1] << 8); }
static uint32_t rd32(const uint8_t *p) {
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static int parse_toc(void) {
    uint8_t hdr[CAUD_HDRLEN];
    toc_n = 0;
    if (!au_pak_read(0, hdr, sizeof hdr)) return 0;
    if (memcmp(hdr, CAUD_MAGIC, 4) != 0) return 0;
    if (rd16(hdr + 4) != CAUD_VERSION) return 0;
    int count = (int)rd16(hdr + 6);
    if (count > AU_MAX_ENTRIES) count = AU_MAX_ENTRIES;
    for (int i = 0; i < count; i++) {
        uint8_t e[CAUD_TOCENT];
        if (!au_pak_read(CAUD_HDRLEN + (uint32_t)i * CAUD_TOCENT, e, sizeof e))
            return 0;
        toc[i].id = (uint16_t)rd16(e);
        toc[i].codec = e[2];
        toc[i].flags = e[3];
        toc[i].rate = (uint16_t)rd16(e + 4);
        toc[i].off = rd32(e + 8);
        toc[i].len = rd32(e + 12);
        if (toc[i].off + toc[i].len > pak_len) return 0;
    }
    toc_n = count;
    return 1;
}

int au_init_buffer(const uint8_t *pak, uint32_t len) {
    ram_pak = pak;
    pak_len = len;
    stream_rd = 0;
    stream_ctx = 0;
    return parse_toc();
}

int au_init_stream(au_read_fn rd, void *ctx, uint32_t len) {
    ram_pak = 0;
    pak_len = len;
    stream_rd = rd;
    stream_ctx = ctx;
    return parse_toc();
}
