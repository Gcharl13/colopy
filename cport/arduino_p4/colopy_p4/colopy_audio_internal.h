/* Internal seams between the audio engine translation units. Not a public
 * header — shells include colopy_audio.h only. */
#ifndef COLOPY_AUDIO_INTERNAL_H
#define COLOPY_AUDIO_INTERNAL_H

#include <stdint.h>

/* pak TOC (colopy_audio_pak.c) */
typedef struct {
    uint16_t id;
    uint8_t codec;              /* CAUD_CODEC_* */
    uint8_t flags;
    uint16_t rate;
    uint32_t off, len;
} au_entry;

const au_entry *au_pak_find(uint16_t id);
int au_pak_read(uint32_t off, void *dst, uint32_t len);
int au_pak_ready(void);

/* mixer (colopy_audio_mix.c) */
void au_mix_start_music(const au_entry *e);
void au_mix_start_sfx(const au_entry *e);
void au_mix_stop_music(void);
void au_mix_stop_sfx(void);
int  au_mix_music_active(void);

/* engine hook: the mixer calls this when the music voice drains, so the
 * depth-1 pending queue (observed driver behaviour: a play request while
 * sounding is queued, not preempted) can start. */
void au_engine_music_ended(void);

/* engine hook for the cue layer: set forced-next [0x94] WITHOUT the stop
 * that au_queue_tune sends (the new-game cue plays 0x39 and queues 0x25
 * behind it — §24.4). */
void au_force_next_nostop(uint16_t id);

#endif /* COLOPY_AUDIO_INTERNAL_H */
