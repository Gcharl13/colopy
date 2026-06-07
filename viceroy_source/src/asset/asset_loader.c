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
 * asset_loader.c -- Centralised asset I/O for VICEROY.EXE
 * ----------------------------------------------------------------------------
 * The actual code is split across the load_image_*.c overlay files
 * (`../load_image/`). This file is the **hand-port skeleton** that
 * presents the asset loader API at a single API boundary the rest of the
 * code base can call into.
 *
 * @ref ../load_image/load_image_007610_00824E.c   (PIK loader chain)
 * @ref ../load_image/load_image_00AB2E_00C0D0.c   (SS loader chain)
 * @ref ../load_image/load_image_010B26_012A83.c   (TXT/MP loader)
 * @ref ../docs/ASSET_ROLES.md
 * @ref ../../../COLONIZATION_TECHNICAL_REFERENCE.md  §1.Assets
 * ============================================================================ */
#include "viceroy_types.h"
#include "iolib.h"
#include "format.h"

/* ----------------------------------------------------------------------------
 * Asset registry — populated at boot. Each entry: filename, loader fn, slot.
 * The boot path in _main() iterates this and invokes loaders in order.
 * ---------------------------------------------------------------------------- */
struct AssetSlot {
    const char *filename;          /* COLONIZE/ filename */
    int        (*loader)(const char *path, void *out);
    void       *destination;       /* DGROUP slot to receive parsed data */
    int         priority;          /* 0=boot, 1=on-screen, 2=on-demand */
};

extern uint8_t  g_palette[768];
extern void    *g_sprite_sheet[64];   /* per-SS slot in DGROUP */
extern void    *g_text_resource[18];  /* per-TXT */
extern void    *g_map_buffer;         /* loaded map */
extern void    *g_pik_buffer;         /* current background */

/* Forward declarations from the load_image_*.c overlay files */
extern int load_palette(const char *path, uint8_t *out_768);
extern int load_sprite_sheet(const char *path, void *out_slot);
extern int load_text_resource(const char *path, void *out_slot);
extern int load_pik(const char *path, void *out_buffer);
extern int load_map(const char *path, void *out_map);
extern int load_audio_config(const char *path, void *out_cfg);
extern int load_sample_bank(const char *path, void *out_bank);
extern int load_savegame(const char *path);
extern int load_hallfame(const char *path, void *out_table);
extern int load_font(const char *path, void *out_handle);

/* ----------------------------------------------------------------------------
 * Boot asset table — loaded once at _main() entry.
 * @ref _main() in ../load_image/load_image_*.c (entry point)
 * @ref ../docs/ARCHITECTURE.md (boot sequence)
 * ---------------------------------------------------------------------------- */
const struct AssetSlot BOOT_ASSETS[] = {
    /* === Palette (mandatory first) === */
    { "VICEROY.PAL", load_palette,        g_palette,             0 },

    /* === Always-resident sprite sheets === */
    { "ICONS.SS",    load_sprite_sheet,   &g_sprite_sheet[0],    0 },
    { "PHYS0.SS",    load_sprite_sheet,   &g_sprite_sheet[1],    0 },
    { "BUILDING.SS", load_sprite_sheet,   &g_sprite_sheet[2],    0 },
    { "TERRAIN.SS",  load_sprite_sheet,   &g_sprite_sheet[3],    0 },
    { "WOODFRAM.SS", load_sprite_sheet,   &g_sprite_sheet[4],    0 },
    { "WOODTILE.SS", load_sprite_sheet,   &g_sprite_sheet[5],    0 },

    /* === Always-loaded text === */
    { "NAMES.TXT",   load_text_resource,  &g_text_resource[0],   0 },
    { "GAME.TXT",    load_text_resource,  &g_text_resource[1],   0 },
    { "MENU.TXT",    load_text_resource,  &g_text_resource[2],   0 },
    { "LABELS.TXT",  load_text_resource,  &g_text_resource[3],   0 },
    { "TRIBE.TXT",   load_text_resource,  &g_text_resource[4],   0 },
    { "FATHER.TXT",  load_text_resource,  &g_text_resource[5],   0 },
    { "EVENTS.TXT",  load_text_resource,  &g_text_resource[6],   0 },

    /* === Audio === */
    { "ASOUND.COL",  load_audio_config,   NULL,                  0 },
    { "COLDIG.BIN",  load_sample_bank,    NULL,                  0 },

    /* === Fonts (byte-verified vs VICEROY.EXE; see docs/UI_FIDELITY.md "Fonts").
       The EXE loads EXACTLY 4 fonts via LCALL 0x1A1F:0x0A86. FONTMED/FONTLARG/
       FONTBOLD/SYMBOLS do NOT exist (were fabricated). FONTSMAL.FF is present on
       disk but is NEVER referenced by VICEROY.EXE (orphan) -- not loaded. */
    { "FONTTINY.FF", load_font,           NULL,                  0 },  /* @0x0760E8 -> [0x89E]  (default / body / reports / status) */
    { "FONTINTR.FF", load_font,           NULL,                  0 },  /* @0x0760C2 -> [0x268A] (menus / titles / new-game pickers) */
    { "FONTKING.FF", load_font,           NULL,                  0 },  /* @0x0754F2 (King audience, loaded on demand) */
    { "FONT-NP.FF",  load_font,           NULL,                  0 },  /* @0x06B7AB (newspaper/woodcut report, on demand) */

    /* === Hall of Fame === */
    { "HALLFAME.DAT",load_hallfame,       NULL,                  0 },

    /* sentinel */
    { NULL, NULL, NULL, 0 }
};

/* ----------------------------------------------------------------------------
 * On-screen-entry assets (loaded when the player navigates into a screen)
 * ---------------------------------------------------------------------------- */
const struct AssetSlot SCREEN_TITLE_ASSETS[] = {
    { "TITLE.PIK",   load_pik,            NULL,                  1 },
    { "MENU.SS",     load_sprite_sheet,   &g_sprite_sheet[6],    1 },
    { NULL, NULL, NULL, 0 }
};

const struct AssetSlot SCREEN_COLONY_ASSETS[] = {
    { "COLONY.PIK",  load_pik,            NULL,                  1 },
    { "COLONY.SS",   load_sprite_sheet,   &g_sprite_sheet[7],    1 },
    { NULL, NULL, NULL, 0 }
};

const struct AssetSlot SCREEN_EUROPE_ASSETS[] = {
    { "EUROPE.PIK",  load_pik,            NULL,                  1 },
    { "EUROPE.SS",   load_sprite_sheet,   &g_sprite_sheet[8],    1 },
    { NULL, NULL, NULL, 0 }
};

/* ----------------------------------------------------------------------------
 * Public API: bootstrap, screen-load, on-demand load
 * ---------------------------------------------------------------------------- */

/* Called from _main() once at startup. Loads BOOT_ASSETS in order.
 * Halts the program if any mandatory asset fails to load. */
void asset_load_boot(void)
{
    for (const struct AssetSlot *a = BOOT_ASSETS; a->filename; a++) {
        int rc = a->loader(a->filename, a->destination);
        if (rc != 0) {
            /* Boot asset is mandatory - print error and halt.
             * @asm @0x012FA0 calls dos_print_string + exit(1). */
            dos_print_error_and_exit(a->filename, rc);
        }
    }
}

/* Called when the player enters a screen state. */
void asset_load_screen(int screen_id)
{
    const struct AssetSlot *table;
    switch (screen_id) {
    case SCREEN_TITLE:  table = SCREEN_TITLE_ASSETS;  break;
    case SCREEN_COLONY: table = SCREEN_COLONY_ASSETS; break;
    case SCREEN_EUROPE: table = SCREEN_EUROPE_ASSETS; break;
    default: return;
    }
    for (const struct AssetSlot *a = table; a->filename; a++) {
        a->loader(a->filename, a->destination);
    }
}

/* On-demand: load a specific .PIK background (used for event popups) */
int asset_load_pik(const char *filename)
{
    extern void *g_pik_buffer;
    return load_pik(filename, g_pik_buffer);
}

/* On-demand: load a savegame */
int asset_load_savegame(int slot)
{
    char path[16];
    strfmt(path, "GAME%04d.SAV", slot);
    return load_savegame(path);
}

/* On-demand: load a specific stock map */
int asset_load_map(const char *map_name)
{
    extern void *g_map_buffer;
    return load_map(map_name, g_map_buffer);
}
