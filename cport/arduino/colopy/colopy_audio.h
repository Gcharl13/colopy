/* cport/audio — the audio milestone's engine (docs/AUDIO_PORT.md).
 *
 * Caller-side port of VICEROY's resident sound layer, from the byte-pinned
 * spec (spec/ui/options_dialogs.md §2/§4/§5, pins of 2026-08-17):
 *   gate func_00518E, scheduler func_004EE6, queue-tune func_0050BC,
 *   class verbs func_0050F0/0050FC/005108/00513C, switch mirror bits
 *   @0x023301. Below the caller API, playback is the milestone's
 *   empirical-capture model (COLAUDIO.PAK slices/renders), NOT the driver's
 *   bytes — every deviation is catalogued in cport/audio/README.md.
 *
 * Layering: platform-free C11, static buffers only, no malloc, no I/O
 * (streaming reaches it through the shell-provided read callback). Never
 * touches core state and is absent from colopy_digest() — the fidelity
 * oracles cannot move. Shells guard all calls with #ifdef COLOPY_AUDIO.
 *
 * Original id namespace (byte-cited):
 *   id < 0x10           driver commands: 1 = stop, 8 = query-playing
 *   0x20..0x3F          tunes    — gated on the Event Music switch [0xA0]
 *   0x40..0x5F          SFX      — gated on the SFX switch [0xA4]
 *   0x8020+power/0x8024 fanfares (bit 0x20 set -> tune gate applies)
 */
#ifndef COLOPY_AUDIO_H
#define COLOPY_AUDIO_H

#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>

/* ---- pak attach (one of the two; call before anything plays) ---------- */
/* Read `len` bytes at absolute pak offset `off` into dst; return 1 on
 * success, 0 on failure (a failed read just silences that voice). */
typedef int (*au_read_fn)(void *ctx, uint32_t off, void *dst, uint32_t len);

int  au_init_buffer(const uint8_t *pak, uint32_t len);      /* pak in RAM  */
int  au_init_stream(au_read_fn rd, void *ctx, uint32_t len);/* SD stream   */

/* ---- original caller API --------------------------------------------- */
void au_seed(uint32_t seed);       /* scheduler PRNG (original seeds from
                                      the wall-clock tick words) */
void au_set_war(int at_war);       /* [0x5382]&1 input to the scheduler */

void     au_cmd(uint16_t id);      /* the gate (func_00518E semantics) */
int      au_playing(void);         /* driver command 8 */
void     au_stop(void);            /* driver command 1 */
void     au_pump(void);            /* func_004EE6 — call from idle loops */
void     au_queue_tune(uint16_t id);       /* func_0050BC (0x181f:0x48e) */
void     au_class_set(uint8_t cls);        /* func_0050F0 (0x498): [0x9A] */
void     au_class_queue_next(uint8_t cls); /* func_0050FC (0x4a2): [0x98] */
void     au_class_request(uint8_t cls);    /* func_005108 (0x4ac): + stop */
void     au_class_oneshot(uint8_t cls);    /* func_00513C (0x4b6): only
                                              when BG off + Event on */
uint16_t au_current_tune(void);    /* [0x96] mirror */

/* ---- Sound Options switches ------------------------------------------ */
/* which: 0 = Background Music [0xA2], 1 = Event Music [0xA0],
 *        2 = Sound Effects [0xA4]. Turning any switch off sends stop
 *        (pinned @0x023327). */
void    au_set_switch(int which, int on);
uint8_t au_switches(void);         /* save encoding: bit1 BG, bit2 Event,
                                      bit3 SFX (mask 0x0E, @0x023301) */
void    au_load_switches(uint8_t sav_bits); /* from save [0x5386] & 0x0E */

/* ---- presentation cues (spec §24.4 event->cue map) -------------------- */
void au_on_event(const char *key, int32_t p0);
void au_on_woodcut(int plate);
void au_on_new_game(void);

/* ---- backend pull ----------------------------------------------------- */
/* Fill `out` with `nframes` signed 16-bit MONO frames at AU_MIX_RATE.
 * Callable from a DMA-fill task/ISR; does pak reads (keep the read_fn
 * ISR-safe on stream builds, or pump from a task). */
#define AU_MIX_RATE 22050
void au_render(int16_t *out, int nframes);

#ifdef __cplusplus
}
#endif
#endif /* COLOPY_AUDIO_H */
