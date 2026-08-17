/* 2-voice mixer + IMA ADPCM decoder — the playback model under the ported
 * caller API (docs/AUDIO_PORT.md).
 *
 * Voice model (approximation, catalogued in README.md): entries decode onto
 * a voice chosen by CODEC, mirroring the original hardware split under the
 * SB driver — IMA renders (FM-family sounds: tunes, fanfares, FM sfx) own
 * the MUSIC voice and serialize, like the OPL chip did (observed live:
 * a play request while sounding is queued, not preempted); PCM8 slices
 * (digitized COLDIG sounds) own the SFX voice and mix over the music, like
 * the DSP did. A new SFX preempts the playing SFX (single-DMA model).
 *
 * Internal format: s16 mono @ AU_MIX_RATE (22050). PCM8 payloads are 11025
 * Hz and are zero-order-held x2. IMA blocks are self-contained (predictor +
 * step index in each 516-byte block header), so streaming needs no
 * cross-block state. */
#include <string.h>

#include "../data/colopy_audio_pak.h"
#include "colopy_audio.h"
#include "colopy_audio_internal.h"

/* IMA tables (standard DVI; identical to tools/audio/ima_adpcm.py) */
static const int16_t STEP_TABLE[89] = {
    7, 8, 9, 10, 11, 12, 13, 14, 16, 17, 19, 21, 23, 25, 28, 31, 34, 37, 41,
    45, 50, 55, 60, 66, 73, 80, 88, 97, 107, 118, 130, 143, 157, 173, 190,
    209, 230, 253, 279, 307, 337, 371, 408, 449, 494, 544, 598, 658, 724,
    796, 876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066, 2272,
    2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358, 5894, 6484, 7132,
    7845, 8630, 9493, 10442, 11487, 12635, 13899, 15289, 16818, 18500,
    20350, 22385, 24623, 27086, 29794, 32767,
};
static const int8_t INDEX_TABLE[16] = {
    -1, -1, -1, -1, 2, 4, 6, 8, -1, -1, -1, -1, 2, 4, 6, 8,
};

#define RAW_CHUNK 516              /* one IMA block; PCM reads use 256 of it */
#define DEC_BUF   1024             /* decoded samples per refill (IMA block) */

typedef struct {
    int active;
    uint8_t codec;
    uint32_t off, len, pos;        /* payload window + read cursor */
    int16_t buf[DEC_BUF];
    int buf_n, buf_i;
    int hold;                      /* PCM8 x2 zero-order hold phase */
    int16_t hold_s;
    uint8_t raw[RAW_CHUNK];
} au_voice;

static au_voice music, sfx;

static int16_t clamp16(int32_t v) {
    if (v > 32767) return 32767;
    if (v < -32768) return -32768;
    return (int16_t)v;
}

static void ima_decode_block(const uint8_t *blk, int16_t *out) {
    int32_t pred = (int16_t)(blk[0] | (blk[1] << 8));
    int index = blk[2];
    if (index > 88) index = 88;
    const uint8_t *nib = blk + 4;
    for (int i = 0; i < CAUD_BLOCK; i++) {
        int code = (i & 1) ? (nib[i >> 1] >> 4) : (nib[i >> 1] & 0xF);
        int step = STEP_TABLE[index];
        int delta = step >> 3;
        if (code & 4) delta += step;
        if (code & 2) delta += step >> 1;
        if (code & 1) delta += step >> 2;
        pred = clamp16(code & 8 ? pred - delta : pred + delta);
        index += INDEX_TABLE[code];
        if (index < 0) index = 0;
        if (index > 88) index = 88;
        out[i] = (int16_t)pred;
    }
}

static void voice_start(au_voice *v, const au_entry *e) {
    memset(v, 0, sizeof *v);
    v->codec = e->codec;
    v->off = e->off;
    v->len = e->len;
    v->active = 1;
}

static int voice_refill(au_voice *v) {
    if (v->pos >= v->len) return 0;
    if (v->codec == CAUD_CODEC_IMA4) {
        uint32_t n = v->len - v->pos;
        if (n < CAUD_BLOCK_BYTES) return 0;      /* generator writes whole blocks */
        if (!au_pak_read(v->off + v->pos, v->raw, CAUD_BLOCK_BYTES)) return 0;
        v->pos += CAUD_BLOCK_BYTES;
        ima_decode_block(v->raw, v->buf);
        v->buf_n = CAUD_BLOCK;
    } else {                                     /* PCM8U @ 11025, hold x2 */
        uint32_t n = v->len - v->pos;
        if (n > 256) n = 256;
        if (!au_pak_read(v->off + v->pos, v->raw, n)) return 0;
        v->pos += n;
        for (uint32_t i = 0; i < n; i++)
            v->buf[i] = (int16_t)(((int)v->raw[i] - 128) << 8);
        v->buf_n = (int)n;
    }
    v->buf_i = 0;
    return 1;
}

static int32_t voice_next(au_voice *v) {
    if (!v->active) return 0;
    if (v->codec == CAUD_CODEC_PCM8U) {
        /* 11025 -> 22050: emit each source sample twice */
        if (v->hold) {
            v->hold = 0;
            return v->hold_s;
        }
    }
    if (v->buf_i >= v->buf_n) {
        if (!voice_refill(v)) {
            v->active = 0;
            return 0;
        }
    }
    int16_t s = v->buf[v->buf_i++];
    if (v->codec == CAUD_CODEC_PCM8U) {
        v->hold = 1;
        v->hold_s = s;
    }
    return s;
}

void au_mix_start_music(const au_entry *e) { voice_start(&music, e); }
void au_mix_start_sfx(const au_entry *e) { voice_start(&sfx, e); }
void au_mix_stop_music(void) { music.active = 0; }
void au_mix_stop_sfx(void) { sfx.active = 0; }
int au_mix_music_active(void) { return music.active; }

void au_render(int16_t *out, int nframes) {
    for (int i = 0; i < nframes; i++) {
        int was = music.active;
        int32_t s = voice_next(&music) + voice_next(&sfx);
        if (was && !music.active)
            au_engine_music_ended();
        out[i] = clamp16(s);
    }
}
