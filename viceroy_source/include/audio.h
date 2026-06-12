/* ============================================================================
 *                  >>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<
 * ----------------------------------------------------------------------------
 * audio.h -- shared types for the RECONSTRUCTED audio layer
 * (src/audio/audio_device.c + src/audio/sound_dispatch.c).
 *
 * Phase 4.4 (2026-06-12): created so both audio translation units share one
 * AudioConfig definition (previously duplicated/implicit).  Everything here
 * is RECONSTRUCTED-tier; Phase 5 byte-verifies the audio core against
 * VICEROY.EXE and the .COL/.BIN formats (formats/COL.md, formats/BIN.md).
 * ============================================================================ */
#ifndef VICEROY_AUDIO_H
#define VICEROY_AUDIO_H

enum AudioDevice {
    AUDIO_NONE        = 0,
    AUDIO_PC_SPEAKER  = 1,
    AUDIO_ADLIB       = 2,    /* OPL2 */
    AUDIO_SOUNDBLASTER= 3,    /* SB Pro / SB16 */
    AUDIO_ROLAND_MT32 = 4,
    AUDIO_GENERAL_MIDI= 5
};

struct AudioConfig {
    int  device_type;          /* AUDIO_* */
    int  io_port;              /* base I/O port */
    int  irq;                  /* hardware IRQ */
    int  dma;                  /* DMA channel (SB only) */
    int  sample_rate;          /* Hz */
    int  music_volume;         /* 0..255 */
    int  sfx_volume;           /* 0..255 */
};

/* Song definition (sequencer input; .COL layout — Phase 5 decodes it). */
typedef struct SongDef SongDef;

/* volume channels (snd_set_volume) */
#define CHANNEL_MUSIC 0
#define CHANNEL_SFX   1

/* game-event ids consumed by snd_event() (RECONSTRUCTED mapping) */
enum SndEvent {
    EVENT_CLICK            = 0,
    EVENT_COMBAT_WIN       = 1,
    EVENT_COMBAT_LOSE      = 2,
    EVENT_NEW_COLONY       = 3,
    EVENT_BUILDING_DONE    = 4,
    EVENT_TRADE_COMPLETED  = 5,
    EVENT_FATHER_RECRUITED = 6,
    EVENT_KING_DEMAND      = 7,
    EVENT_LCR_DISCOVERED   = 8
};

/* public API (sound_dispatch.c / audio_device.c) */
int  audio_init(void);
int  audio_autodetect(void);
int  audio_load_config(const char *filename, struct AudioConfig *out);
void audio_save_config(void);
void audio_shutdown(void);
int  audio_load_sample_bank(const char *filename);
int  probe_soundblaster(void);
int  probe_adlib(void);
int  probe_mt32(void);

void snd_play_sample(int sample_id);
void snd_play_music(int song_id);
void snd_stop_music(void);
void snd_stop_all(void);
void snd_set_volume(int channel, int vol);
void snd_event(int event_id);

/* device-driver leaves (RECONSTRUCTED names; bodies land in Phase 5 —
 * until then they are weak no-op stubs from the link floor) */
void adlib_init(void);
void adlib_shutdown(void);
void adlib_play_song(SongDef *s);
void adlib_stop_song(void);
void adlib_play_pcm_approx(unsigned char *data, int len);
void mt32_init(void);
void mt32_shutdown(void);
void mt32_play_song(SongDef *s);
void mt32_stop_song(void);
void gm_init(void);
void gm_shutdown(void);
void gm_play_song(SongDef *s);
void gm_stop_song(void);
void pcspk_init(void);
void pcspk_shutdown(void);
void pcspk_play_sample(unsigned char *data, int len);
void pcspk_play_melody(SongDef *s);
void pcspk_stop(void);
void pcspk_silence(void);
void sb_play_pcm(unsigned char *data, int len, int rate);
void sb_dma_halt(void);
SongDef *song_lookup(int song_id);

/* DOS port I/O + timing (platform layer; no-ops in the headless build) */
int  inp(int port);
void outp(int port, int value);
void delay_micros(int us);

#endif /* VICEROY_AUDIO_H */
