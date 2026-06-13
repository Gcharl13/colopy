/* ============================================================================
 * audio_silent.c -- terminal (silent) definitions for the audio device leaves.
 * ----------------------------------------------------------------------------
 * AUDIO DESCOPED 2026-06-13 (user decision: "I don't need music"). Phase 5
 * (audio parity) is out of scope; there is no host audio-device model in the
 * modern build. Every hardware/driver leaf below is therefore a deliberate
 * SILENT no-op -- the AUDIO_NONE device path made explicit.
 *
 * These were the weak hit-counting stubs that audio_device.c / sound_dispatch.c
 * (RECONSTRUCTED-tier) call into; strong silent definitions here move them to
 * their terminal state (MODERN-REPLACED-silent / UNREACHABLE-BY-CONFIG) so they
 * leave the Gate-G4 weak-stub floor. They do nothing and return benign values,
 * which is exactly "no sound": the dispatch layer's snd_play_* triggers reach a
 * silent driver. Ledger: docs/UNREACHABLE_LEDGER.md §AUDIO-DESCOPED.
 *
 * If audio parity is ever re-scoped, replace this unit with the byte-verified
 * OPL2/MT-32/SB drivers per ROUTE_B_PLAN Phase 5; nothing else need change
 * (the call sites and signatures are already in include/audio.h).
 * ============================================================================ */
#include "audio.h"

/* --- AdLib (OPL2) ---------------------------------------------------------- */
void adlib_init(void)                                   { }
void adlib_shutdown(void)                               { }
void adlib_play_song(SongDef *s)                        { (void)s; }
void adlib_stop_song(void)                              { }
void adlib_play_pcm_approx(unsigned char *d, int len)   { (void)d; (void)len; }

/* --- MT-32 / MPU-401 (UNREACHABLE-BY-CONFIG even pre-descope) --------------- */
void mt32_init(void)                                    { }
void mt32_shutdown(void)                                { }
void mt32_play_song(SongDef *s)                         { (void)s; }
void mt32_stop_song(void)                               { }

/* --- General MIDI ---------------------------------------------------------- */
void gm_init(void)                                      { }
void gm_shutdown(void)                                  { }
void gm_play_song(SongDef *s)                           { (void)s; }
void gm_stop_song(void)                                 { }

/* --- PC speaker ------------------------------------------------------------ */
void pcspk_init(void)                                   { }
void pcspk_shutdown(void)                               { }
void pcspk_play_melody(SongDef *s)                      { (void)s; }
void pcspk_play_sample(unsigned char *d, int len)       { (void)d; (void)len; }
void pcspk_stop(void)                                   { }
void pcspk_silence(void)                                { }

/* --- Sound Blaster (PCM/DMA) ----------------------------------------------- */
void sb_play_pcm(unsigned char *d, int len, int rate)   { (void)d; (void)len; (void)rate; }
void sb_dma_halt(void)                                  { }

/* --- sample bank / config loaders ------------------------------------------ */
int  audio_load_sample_bank(const char *filename)       { (void)filename; return 0; }
int  load_sample_bank(const char *path, void *out_bank) { (void)path; (void)out_bank; return 0; }
int  load_audio_config(const char *path, void *out_cfg) { (void)path; (void)out_cfg; return 0; }
SongDef *song_lookup(int song_id)                       { (void)song_id; return (SongDef *)0; }

/* --- raw hardware port I/O + busy-wait (no ports on the host) --------------- */
int  inp(int port)                                      { (void)port; return 0; }
void outp(int port, int value)                          { (void)port; (void)value; }
void delay_micros(int us)                               { (void)us; }   /* deterministic: no real sleep */
