> **>>> RECONSTRUCTED — NOT BYTE-VERIFIED <<<**
>
> The formulas, tables, and specific numbers in this document are reconstructed
> from accumulated playthrough knowledge and prior reverse-engineering notes.
> They have **not** been confirmed by reading bytes from VICEROY.EXE.
>
> Treat every numerical claim as RECONSTRUCTED until cross-referenced to a
> hand-decompiled function in `code/VICEROY/decompiled.md` or to bytes
> documented in `viceroy_source/VERIFICATION_LEDGER.md`.

# MADS Engine (madsdev.lib)

## What it is

`madsdev.lib` is the **MicroProse MADS** game engine library, a shared
toolkit used across MicroProse titles ~1992-1995. VICEROY.EXE links it
statically and uses about half its API surface.

The library is identifiable by its module names in CodeView NB02
debug symbols: `pfabcomp.asm`, `pfabexp.asm`, `mssprite.asm`,
`buf.asm`, `pal.asm`, etc.

## Modules used by VICEROY.EXE

### `mssprite` — MS_SPRITE codec

```c
int  ms_sprite_load(const char *filename, SpriteSheet *out);
void ms_sprite_blit(SpriteHeader *h, int dst_x, int dst_y);
void ms_sprite_blit_transparent(SpriteHeader *h, int dst_x, int dst_y);
SpriteHeader *ms_sprite_lookup(SpriteSheet *sheet, int sprite_id);
```

Decodes the per-row RLE format (8-byte zero magic, 25-byte header, then
RLE rows). See [../formats/SS.md](../formats/SS.md).

### `buf` — Off-screen buffer + framebuffer

```c
void buf_set_video_mode(int mode);          /* INT 10h AH=00h, mode 0x13 */
void buf_set_palette(uint8_t *pal_data);    /* INT 10h AH=10h AL=12h */
void buf_clear(uint8_t color);
void buf_blit_rect(int sx, int sy, int w, int h, int dx, int dy);
uint8_t *buf_get_framebuffer(void);          /* returns 0xA0000000 */
```

### `pal` — Palette I/O

```c
int  pal_load(const char *filename, uint8_t *out_768);
void pal_set(uint8_t *pal_768);
void pal_cycle_set(int start, int end);     /* color cycling */
void pal_fade_to(uint8_t *target, int steps);
```

### `pfabcomp` / `pfabexp` — FAB compression (LZ77 variant)

```c
int fab_compress(uint8_t *src, int src_len, uint8_t *dst);
int fab_expand(uint8_t *src, int src_len, uint8_t *dst, int dst_len);
```

Used by Win16-side payloads (out of scope per CLAUDE.md). DOS-side
PIK files use a simpler RLE (CVPC); see [../formats/PIK.md](../formats/PIK.md).

### `cvpc` — CVPC RLE codec

```c
int cvpc_decode(uint8_t *src, int src_len, uint8_t *dst, int w, int h);
int cvpc_encode(uint8_t *src, int w, int h, uint8_t *dst);
```

VICEROY's PIK loader calls `cvpc_decode` after stripping the MS_SPRITE
wrapper.

### `mem` — Memory allocator (medium-model wrapper)

```c
void *mem_alloc_far(int n_bytes);
void  mem_free_far(void *p);
void *mem_alloc_near(int n_bytes);          /* DGROUP heap */
void  mem_free_near(void *p);
```

### `snd` — Sound dispatcher

```c
int  snd_init(int device_type);
void snd_play_sample(int bank_idx);
void snd_play_music(int song_idx);
void snd_set_volume(int channel, int vol);
void snd_stop_all(void);
```

Reads device config from `*.COL` files. Drives Adlib FM synth, Roland MT-32,
or PC speaker depending on detected hardware.

### `gfx_text` — Bitmap font rendering

```c
int  font_load(const char *filename, FontHandle *out);
void font_draw(FontHandle *f, int x, int y, const char *text, int color);
int  font_text_width(FontHandle *f, const char *text);
```

Reads `.FF` font files. See [../formats/FF.md](../formats/FF.md).

### `input` — Keyboard + mouse

```c
int  input_keypressed(void);
int  input_getkey(void);                     /* returns ASCII or extended */
void input_mouse_get(int *x, int *y, int *buttons);
void input_mouse_show(void);
void input_mouse_hide(void);
void input_mouse_set_cursor(int sprite_id);
```

Hooks `INT 33h` (mouse) and `INT 09h` (keyboard) at startup.

### `time` — Game clock

```c
uint32_t time_now_ticks(void);               /* INT 1Ah AH=00h */
void     time_delay(int ms);                 /* spin-loop or INT 1Ah */
```

### `file` — DOS file I/O

```c
int  file_open(const char *path, int mode);
int  file_close(int fd);
int  file_read(int fd, void *buf, int n);
int  file_write(int fd, const void *buf, int n);
int  file_seek(int fd, int32_t offset, int whence);
```

Wraps `INT 21h` AH=3Dh/3Eh/3Fh/40h/42h.

## Modules NOT used by VICEROY (present in lib)

- **`anim`** — sprite animation timer (used by some MADS games but not
  VICEROY, which uses static sprites).
- **`ui_widget`** — generic widget toolkit (VICEROY rolls its own UI).
- **`profile`** — performance profiler (debug builds only).

## Engine init sequence

```c
int engine_init(void) {
    if (!buf_set_video_mode(0x13)) return 0;
    if (!pal_load("VICEROY.PAL", g_palette)) return 0;
    pal_set(g_palette);
    snd_init(detect_sound_device());
    input_mouse_show();
    return 1;
}
```

Called from `_main()` after the DOS / heap setup.

## Engine teardown

```c
void engine_shutdown(void) {
    snd_stop_all();
    input_mouse_hide();
    buf_set_video_mode(0x03);                /* back to text mode */
    /* DOS file handles close automatically on exit */
}
```

Called via `atexit()` chain registered by cstart.

## Thread safety

None — DOS is single-threaded. The engine assumes serial execution.
`INT 09h` / `INT 33h` interrupts ARE asynchronous, but the input module
queues events to a ring buffer for synchronous consumption.

## Cross-references

- File format specs that the engine consumes: [`../formats/`](../formats/)
- Boot sequence using engine: [ARCHITECTURE.md](ARCHITECTURE.md)
- Source modules implementing engine wrappers: [`../src/iolib/`](../src/iolib/)
