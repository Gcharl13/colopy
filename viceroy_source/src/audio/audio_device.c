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
 * audio_device.c -- Sound device detection and config
 * ----------------------------------------------------------------------------
 * Reads device config from .COL files (ASOUND/GSOUND/PSOUND/RSOUND).
 * Initializes the appropriate driver: AdLib, MT-32, General MIDI, PC speaker.
 *
 * @ref ../docs/ENGINE.md (snd module)
 * @ref ../formats/COL.md
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"

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

static struct AudioConfig g_audio_cfg = {
    .device_type = AUDIO_NONE
};

/* ----------------------------------------------------------------------------
 * audio_init -- called from _main() at boot.
 * ---------------------------------------------------------------------------- */
int audio_init(void)
{
    /* 1. Read CONFIG.COL for last-known user choice */
    if (audio_load_config("CONFIG.COL", &g_audio_cfg) != 0) {
        /* No config: auto-detect */
        g_audio_cfg.device_type = audio_autodetect();
    }

    /* 2. Load the device-specific instrument bank */
    switch (g_audio_cfg.device_type) {
    case AUDIO_ADLIB:
    case AUDIO_SOUNDBLASTER:
        audio_load_config("ASOUND.COL", &g_audio_cfg);
        adlib_init();
        break;
    case AUDIO_ROLAND_MT32:
        audio_load_config("RSOUND.COL", &g_audio_cfg);
        mt32_init();
        break;
    case AUDIO_GENERAL_MIDI:
        audio_load_config("GSOUND.COL", &g_audio_cfg);
        gm_init();
        break;
    case AUDIO_PC_SPEAKER:
        audio_load_config("PSOUND.COL", &g_audio_cfg);
        pcspk_init();
        break;
    default:
        return -1;
    }

    /* 3. Load digital sample bank */
    audio_load_sample_bank("COLDIG.BIN");

    return 0;
}

int audio_autodetect(void)
{
    /* Probe in order of preference. Each probe writes/reads a hardware port.
     */
    if (probe_soundblaster() == 0) return AUDIO_SOUNDBLASTER;
    if (probe_adlib() == 0)        return AUDIO_ADLIB;
    if (probe_mt32() == 0)         return AUDIO_ROLAND_MT32;
    return AUDIO_PC_SPEAKER;
}

int probe_soundblaster(void)
{
    /* Attempt SB DSP reset at default I/O 0x220 */
    outp(0x226, 1);
    delay_micros(3);
    outp(0x226, 0);
    delay_micros(100);
    if (inp(0x22A) == 0xAA) {
        g_audio_cfg.io_port = 0x220;
        g_audio_cfg.irq     = 7;
        g_audio_cfg.dma     = 1;
        return 0;
    }
    return -1;
}

int probe_adlib(void)
{
    /* Reset OPL2 timers and check status */
    outp(0x388, 0x04);
    outp(0x389, 0x60);
    outp(0x388, 0x04);
    outp(0x389, 0x80);
    int s1 = inp(0x388);
    outp(0x388, 0x02);
    outp(0x389, 0xFF);
    outp(0x388, 0x04);
    outp(0x389, 0x21);
    delay_micros(80);
    int s2 = inp(0x388);
    outp(0x388, 0x04);
    outp(0x389, 0x60);
    outp(0x388, 0x04);
    outp(0x389, 0x80);
    if ((s1 & 0xE0) == 0 && (s2 & 0xE0) == 0xC0) return 0;
    return -1;
}

int probe_mt32(void) { return -1; /* MT-32 needs MPU-401 probe at 0x330 */ }

int audio_load_config(const char *filename, struct AudioConfig *out)
{
    int fd = file_open(filename, FILE_READ);
    if (fd < 0) return -1;
    file_read(fd, out, sizeof(*out));
    file_close(fd);
    return 0;
}

void audio_save_config(void)
{
    int fd = file_open("CONFIG.COL", FILE_WRITE);
    if (fd < 0) return;
    file_write(fd, &g_audio_cfg, sizeof(g_audio_cfg));
    file_close(fd);
}

void audio_shutdown(void)
{
    /* Stop all playback, reset device */
    snd_stop_all();
    switch (g_audio_cfg.device_type) {
    case AUDIO_ADLIB:
    case AUDIO_SOUNDBLASTER:  adlib_shutdown();  break;
    case AUDIO_ROLAND_MT32:   mt32_shutdown();   break;
    case AUDIO_GENERAL_MIDI:  gm_shutdown();     break;
    case AUDIO_PC_SPEAKER:    pcspk_shutdown();  break;
    }
}
