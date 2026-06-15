/*
 * mp.c — .MP map file reader/writer (see mp.h for the verified layout).
 *
 * The I/O is endian-safe: width/height are read and written as explicit
 * little-endian byte pairs rather than by reinterpreting host memory, so the
 * code produces byte-identical files on any platform.
 */
#include "mp.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint16_t rd_u16le(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }
static void     wr_u16le(uint8_t *p, uint16_t v) { p[0] = (uint8_t)v; p[1] = (uint8_t)(v >> 8); }

size_t mp_tile_count(const mp_map *m) { return (size_t)m->width * m->height; }

size_t mp_file_size(const mp_map *m)
{
    return MP_HEADER_BYTES + MP_LAYERS * mp_tile_count(m) + m->trailer_len;
}

bool mp_in_bounds(const mp_map *m, int x, int y)
{
    return x >= 0 && y >= 0 && x < (int)m->width && y < (int)m->height;
}

mp_map *mp_new(uint16_t width, uint16_t height)
{
    if (width == 0 || height == 0)
        return NULL;

    mp_map *m = calloc(1, sizeof *m);
    if (!m)
        return NULL;

    m->width = width;
    m->height = height;
    m->reserved = 4;       /* AMER2's 3rd header word */
    size_t n = (size_t)width * height;

    m->terrain = calloc(n, 1);
    m->feature = calloc(n, 1);
    m->special = calloc(n, 1);
    /* AMER2 has no trailer (6-byte header + 3 layers fills the file). */
    m->trailer_len = 0;
    m->trailer = calloc(1, 1);

    if (!m->terrain || !m->feature || !m->special || !m->trailer) {
        mp_free(m);
        return NULL;
    }
    return m;
}

void mp_free(mp_map *m)
{
    if (!m)
        return;
    free(m->terrain);
    free(m->feature);
    free(m->special);
    free(m->trailer);
    free(m);
}

static uint8_t *read_whole_file(const char *path, size_t *out_len, char *err, size_t errsz)
{
    FILE *f = fopen(path, "rb");
    if (!f) {
        if (err) snprintf(err, errsz, "cannot open '%s': %s", path, strerror(errno));
        return NULL;
    }
    if (fseek(f, 0, SEEK_END) != 0) {
        if (err) snprintf(err, errsz, "seek failed on '%s'", path);
        fclose(f);
        return NULL;
    }
    long sz = ftell(f);
    if (sz < 0) {
        if (err) snprintf(err, errsz, "ftell failed on '%s'", path);
        fclose(f);
        return NULL;
    }
    rewind(f);
    uint8_t *buf = malloc((size_t)sz ? (size_t)sz : 1);
    if (!buf) {
        if (err) snprintf(err, errsz, "out of memory");
        fclose(f);
        return NULL;
    }
    if (fread(buf, 1, (size_t)sz, f) != (size_t)sz) {
        if (err) snprintf(err, errsz, "short read on '%s'", path);
        free(buf);
        fclose(f);
        return NULL;
    }
    fclose(f);
    *out_len = (size_t)sz;
    return buf;
}

mp_map *mp_load(const char *path, char *err, size_t errsz)
{
    size_t len = 0;
    uint8_t *buf = read_whole_file(path, &len, err, errsz);
    if (!buf)
        return NULL;

    if (len < MP_HEADER_BYTES) {
        if (err) snprintf(err, errsz, "file too small (%zu bytes)", len);
        free(buf);
        return NULL;
    }

    uint16_t w = rd_u16le(buf + 0);
    uint16_t h = rd_u16le(buf + 2);
    uint16_t reserved = rd_u16le(buf + 4);
    if (w == 0 || h == 0) {
        if (err) snprintf(err, errsz, "invalid dimensions %ux%u", w, h);
        free(buf);
        return NULL;
    }

    size_t n = (size_t)w * h;
    size_t need = MP_HEADER_BYTES + MP_LAYERS * n;
    if (len < need) {
        if (err)
            snprintf(err, errsz,
                     "truncated: %ux%u needs >= %zu bytes for 3 layers, have %zu",
                     w, h, need, len);
        free(buf);
        return NULL;
    }

    mp_map *m = calloc(1, sizeof *m);
    if (!m) {
        if (err) snprintf(err, errsz, "out of memory");
        free(buf);
        return NULL;
    }
    m->width = w;
    m->height = h;
    m->reserved = reserved;
    m->terrain = malloc(n);
    m->feature = malloc(n);
    m->special = malloc(n);
    m->trailer_len = len - need;
    m->trailer = malloc(m->trailer_len ? m->trailer_len : 1);
    if (!m->terrain || !m->feature || !m->special || !m->trailer) {
        if (err) snprintf(err, errsz, "out of memory");
        mp_free(m);
        free(buf);
        return NULL;
    }

    const uint8_t *p = buf + MP_HEADER_BYTES;
    memcpy(m->terrain, p, n);          p += n;
    memcpy(m->feature, p, n);          p += n;
    memcpy(m->special, p, n);          p += n;
    memcpy(m->trailer, p, m->trailer_len);

    free(buf);
    return m;
}

int mp_save(const mp_map *m, const char *path)
{
    FILE *f = fopen(path, "wb");
    if (!f)
        return -1;

    uint8_t hdr[MP_HEADER_BYTES];
    wr_u16le(hdr + 0, m->width);
    wr_u16le(hdr + 2, m->height);
    wr_u16le(hdr + 4, m->reserved);

    size_t n = mp_tile_count(m);
    bool ok = fwrite(hdr, 1, sizeof hdr, f) == sizeof hdr
           && fwrite(m->terrain, 1, n, f) == n
           && fwrite(m->feature, 1, n, f) == n
           && fwrite(m->special, 1, n, f) == n
           && fwrite(m->trailer, 1, m->trailer_len, f) == m->trailer_len;

    if (fclose(f) != 0)
        ok = false;
    return ok ? 0 : -1;
}
