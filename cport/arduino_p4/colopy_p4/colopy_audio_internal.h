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

/* mixer (colopy_audio_mix.c): three voices after the driver's channel
 * split — music = FM ch1-6 (tunes, fanfares), fm = FM ch7-9 (the SFX ids
 * the driver renders on the OPL), digital = the DSP sample ring.  A start
 * on a voice REPLACES what it carries (ASOUND: tune head stop-marks ch1-6,
 * 0:0xCE2 stops a sample in flight). */
void au_mix_start_music(const au_entry *e);
void au_mix_start_fm(const au_entry *e);
void au_mix_start_digital(const au_entry *e);
void au_mix_stop_music(void);
void au_mix_stop_fm(void);
void au_mix_stop_digital(void);
int  au_mix_music_active(void);
int  au_mix_fm_active(void);
void au_mix_set_mute(int on);          /* driver cmds 6/7 */

/* engine hook for the cue layer: set forced-next [0x94] WITHOUT the stop
 * that au_queue_tune sends (the new-game cue plays 0x39 and queues 0x25
 * behind it — §24.4). */
void au_force_next_nostop(uint16_t id);

#endif /* COLOPY_AUDIO_INTERNAL_H */
