/* ============================================================================
 *                  >>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * The values, formulas, and offsets in this file are reconstructed from
 * accumulated playthrough knowledge and the project's prior reverse-engineering
 * work. They have NOT been confirmed by reading bytes from VICEROY.EXE or by
 * hand-decompiling the relevant overlay function.
 *
 * DO NOT TRUST any specific number, table value, or formula in this file
 * for gameplay decisions. To upgrade an entry to BYTE_VERIFIED, follow the
 * methodology in viceroy_source/VERIFICATION_LEDGER.md.
 *
 * Status of every claim in this file: RECONSTRUCTED (until proven otherwise).
 * ============================================================================ */

/* ============================================================================
 * sound_dispatch.c -- High-level music + sample playback API
 * ----------------------------------------------------------------------------
 * The game calls into snd_play_sample() / snd_play_music() with a sample
 * or song ID. This module routes that call to the active device driver.
 *
 * @ref audio_device.c
 * @ref ../formats/BIN.md (sample bank)
 * @ref ../formats/COL.md (instrument/song defs)
 * ============================================================================ */
#include "viceroy_types.h"

extern struct AudioConfig g_audio_cfg;
extern uint8_t *g_sample_bank;          /* loaded from COLDIG.BIN */
extern int     *g_sample_offsets;        /* per-sample offset table */
extern int     *g_sample_lengths;        /* per-sample length table */

/* Sample IDs (selected) */
enum SampleId {
    SFX_CLICK            = 0,
    SFX_CANNON           = 1,
    SFX_MUSKET           = 2,
    SFX_HORSE_GALLOP     = 3,
    SFX_DRUM_ROLL        = 4,
    SFX_FANFARE          = 5,
    SFX_COIN             = 6,
    SFX_NEW_COLONY       = 7,
    SFX_COLONY_LOST      = 8,
    SFX_BUILDING_DONE    = 9,
    SFX_TRADE_COMPLETED  = 10,
    SFX_FATHER_RECRUITED = 11,
    SFX_KING_DEMAND      = 12,
    SFX_REVOLUTION       = 13,
    SFX_NATIVE_ATTACK    = 14,
    SFX_LCR_DISCOVER     = 15,
    SFX_VICTORY          = 16,
    SFX_DEFEAT           = 17,
    /* ... more */
};

/* Song IDs */
enum SongId {
    MUSIC_TITLE          = 0,
    MUSIC_NEW_GAME       = 1,
    MUSIC_DEFAULT        = 2,
    MUSIC_COLONY_SCREEN  = 3,
    MUSIC_EUROPE         = 4,
    MUSIC_NATIVE         = 5,
    MUSIC_BATTLE         = 6,
    MUSIC_VICTORY        = 7,
    MUSIC_DEFEAT         = 8,
    MUSIC_INDEPENDENCE   = 9
};

void snd_play_sample(int sample_id)
{
    if (g_audio_cfg.device_type == AUDIO_NONE) return;
    if (g_audio_cfg.sfx_volume == 0) return;
    if (sample_id < 0 || g_sample_bank == NULL) return;

    uint8_t *data = g_sample_bank + g_sample_offsets[sample_id];
    int      len  = g_sample_lengths[sample_id];

    /* Route to active device */
    switch (g_audio_cfg.device_type) {
    case AUDIO_SOUNDBLASTER:
        sb_play_pcm(data, len, 11025);
        break;
    case AUDIO_ADLIB:
        /* AdLib has no PCM — synthesize via OPL2 amplitude modulation
         * (a low-fi approximation). */
        adlib_play_pcm_approx(data, len);
        break;
    case AUDIO_PC_SPEAKER:
        pcspk_play_sample(data, len);
        break;
    default:
        break;
    }
}

void snd_play_music(int song_id)
{
    if (g_audio_cfg.device_type == AUDIO_NONE) return;
    if (g_audio_cfg.music_volume == 0) return;

    /* Stop current music */
    snd_stop_music();

    SongDef *s = song_lookup(song_id);
    if (!s) return;

    switch (g_audio_cfg.device_type) {
    case AUDIO_ADLIB:
    case AUDIO_SOUNDBLASTER:
        adlib_play_song(s);
        break;
    case AUDIO_ROLAND_MT32:
        mt32_play_song(s);
        break;
    case AUDIO_GENERAL_MIDI:
        gm_play_song(s);
        break;
    case AUDIO_PC_SPEAKER:
        pcspk_play_melody(s);
        break;
    }
}

void snd_stop_music(void)
{
    switch (g_audio_cfg.device_type) {
    case AUDIO_ADLIB:
    case AUDIO_SOUNDBLASTER:  adlib_stop_song();  break;
    case AUDIO_ROLAND_MT32:   mt32_stop_song();   break;
    case AUDIO_GENERAL_MIDI:  gm_stop_song();     break;
    case AUDIO_PC_SPEAKER:    pcspk_stop();       break;
    }
}

void snd_stop_all(void)
{
    snd_stop_music();
    /* Stop any active SFX */
    switch (g_audio_cfg.device_type) {
    case AUDIO_SOUNDBLASTER:  sb_dma_halt();      break;
    case AUDIO_PC_SPEAKER:    pcspk_silence();    break;
    }
}

void snd_set_volume(int channel, int vol)
{
    if (channel == CHANNEL_MUSIC) g_audio_cfg.music_volume = vol;
    else                          g_audio_cfg.sfx_volume = vol;
}

/* Game event hook: called from various subsystems to play sound effects. */
void snd_event(int event_id)
{
    static const int EVENT_TO_SAMPLE[] = {
        [EVENT_CLICK]            = SFX_CLICK,
        [EVENT_COMBAT_WIN]       = SFX_FANFARE,
        [EVENT_COMBAT_LOSE]      = SFX_DRUM_ROLL,
        [EVENT_NEW_COLONY]       = SFX_NEW_COLONY,
        [EVENT_BUILDING_DONE]    = SFX_BUILDING_DONE,
        [EVENT_TRADE_COMPLETED]  = SFX_TRADE_COMPLETED,
        [EVENT_FATHER_RECRUITED] = SFX_FATHER_RECRUITED,
        [EVENT_KING_DEMAND]      = SFX_KING_DEMAND,
        [EVENT_LCR_DISCOVERED]   = SFX_LCR_DISCOVER
    };
    if (event_id >= 0 && event_id < sizeof(EVENT_TO_SAMPLE)/sizeof(int)) {
        snd_play_sample(EVENT_TO_SAMPLE[event_id]);
    }
}
