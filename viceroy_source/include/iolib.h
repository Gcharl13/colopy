/* ============================================================================
 * iolib.h — C-runtime file I/O declarations
 * ----------------------------------------------------------------------------
 * @ref decompiled.md "Region: boot / file I/O — _open / _creat / fopen"
 * @ref decompiled.md "Five DOS Open sites in VICEROY.EXE"
 *
 * The actual implementations live in src/iolib/file.c.  All of these are
 * the canonical Microsoft C 6.0 runtime functions reproduced from VICEROY.EXE
 * disassembly — they DO NOT come from a stock libc.
 * ============================================================================ */
#ifndef VICEROY_IOLIB_H
#define VICEROY_IOLIB_H

#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * Standard fcntl.h-style oflag bits (as used by _open in VICEROY.EXE)
 * ---------------------------------------------------------------------------- */
#define O_RDONLY    0x0000
#define O_WRONLY    0x0001
#define O_RDWR      0x0002
#define O_APPEND    0x0008
#define O_CREAT     0x0100
#define O_TRUNC     0x0200
#define O_EXCL      0x0400
#define O_TEXT      0x4000
#define O_BINARY    0x8000

/* pmode bits (S_*) */
#define S_IWRITE    0x0080
#define S_IREAD     0x0100

/* errno values (mapped from DOS error codes) */
#define EBADF       9
#define ENOMEM      8           /* errno=8; set by func_011F6E @0x11F6E (the RTLink/
                                 * overlay-EXE record reader, NOT savegame — RULINGS 2026-05-30) */
#define ENOENT      2

/* ----------------------------------------------------------------------------
 * Low-level file primitives
 * ---------------------------------------------------------------------------- */

/* @asm 0x011D30..0x011FxX  (~750 bytes incl. create branch)
 * @ref decompiled.md "_open"
 * Returns file handle, or -1 with errno set on failure. */
int   _open(const char* path, int oflag, int pmode);

/* Standard convenience wrapper (also embedded in 0x11E33 create branch) */
int   _creat(const char* path, int pmode);

/* @asm 0x0114E4..0x011560  (125 bytes)
 * @ref decompiled.md "_read"
 * Reads up to count bytes; performs CR/LF translation in text mode. */
int   _read(int fd, void* buf, int count);

/* @asm 0x011D30 area  (sister of _read; uses AH=40h INT 21h) */
int   _write(int fd, const void* buf, int count);

/* @asm 0x01144A..0x011469  (32 bytes)
 * @ref FUNCTIONS_INVENTORY.md "_close"
 * Closes a file descriptor. Validates fd against g_NFILE_QQ. */
int   _close(int fd);

/* @asm 0x01041A..0x010427  (14 bytes)
 * @ref FUNCTIONS_INVENTORY.md "unlink" */
int   _unlink(const char* path);

/* @asm 0x010433..0x010482  (~79 bytes)
 * @ref FUNCTIONS_INVENTORY.md "find_file" */
int   _dos_findfirst(const char* path, int attr, void* finfo);
int   _dos_findnext(void* finfo);

/* ----------------------------------------------------------------------------
 * fopen-family (higher-level buffered I/O)
 *   Both 0x015635 and 0x016F39 reference the same access-mode global at
 *   CS:0x3C3A.  These are inside the 'fopen' module proper. */
typedef struct FILE FILE;
extern FILE far *g_stdout;       /* @ref DGROUP:0x2916 */
extern FILE far *g_stdin;        /* @ref DGROUP:0x290E */

/* @asm 0x015635 area; full fopen impl pending */
FILE far *fopen(const char *path, const char *mode);
int       fclose(FILE *stream);
int       fread(void *buf, int sz, int n, FILE *f);
int       fwrite(const void *buf, int sz, int n, FILE *f);

/* @asm 0xFD20..0xFD27  (8 bytes)  putchar — stdout FILE struct + JMP putc_fast
 * @ref FUNCTIONS_INVENTORY.md "putchar" */
int       putchar(int c);

/* @asm 0xFD4E..0xFD55  (8 bytes)  getchar — sister of putchar
 * @ref FUNCTIONS_INVENTORY.md "getchar" */
int       getchar(void);

/* ----------------------------------------------------------------------------
 * Console I/O
 * ---------------------------------------------------------------------------- */

/* @asm 0xD272..0xD27E  (13 bytes)  INT 16h AH=01h
 * @ref FUNCTIONS_INVENTORY.md "kbhit" */
int       kbhit(void);

/* @asm 0xD286..0xD294  (15 bytes)  INT 16h AH=00h
 * @ref FUNCTIONS_INVENTORY.md "getch" */
int       getch(void);

/* @asm 0x4A5C..0x4A7F  (36 bytes)  game-specific keypress wait
 * @ref FUNCTIONS_INVENTORY.md "wait_for_keypress" */
int       wait_for_keypress(void);

/* @asm 0x4AFA..0x4B16  (28 bytes)
 * @ref FUNCTIONS_INVENTORY.md "drain_keyboard_buffer" */
void      drain_keyboard_buffer(void);

/* ----------------------------------------------------------------------------
 * Memory primitives (heap)
 * ---------------------------------------------------------------------------- */

/* @asm 0x0124D6..0x012530  (90 bytes)
 * @ref FUNCTIONS_INVENTORY.md "coreleft_total"
 * Returns total free DOS memory across all MCBs. */
uint32_t  coreleft_total(void);

/* @asm 0x078AF2..0x078B07  (23 bytes)
 * @ref FUNCTIONS_INVENTORY.md "coreleft_max" */
uint32_t  coreleft_max(void);

/* @asm 0x012573..0x012628  (not yet decoded; 90 bytes around 0x12599+)
 * Standard malloc that calls INT 21h AH=48h with paragraph round-up. */
void far *_malloc(uint16_t size);

/* @asm 0x01287A..0x012902  (136 bytes)
 * @ref decompiled.md "dos_exec_load_overlay_4B3"
 * DOS 4Bh/03h: load an .EXE as an overlay (not RTLink). */
int  dos_exec_load_overlay_4B3(const char* exe_path, void* param_block);

/* ----------------------------------------------------------------------------
 * String functions (custom implementations, not stock libc)
 * ---------------------------------------------------------------------------- */
char near *strcpy_near(char near *dst, const char near *src);   /* 0xFDB4 */
char near *strcat_near(char near *dst, const char near *src);   /* 0xFD74 */
int        strlen_near(const char near *s);                      /* 0xFE12 */
char near *strchr_near(const char near *s, int c);               /* 0x10226 */
int        strcmp_near (const char near *s1, const char near *s2);            /* 0xFDE6 */
char near *strncat_near(char near *dst, const char near *src, uint16_t n);    /* 0xFE2E */
char near *strncpy_near(char near *dst, const char near *src, uint16_t n);    /* 0xFE64 */
int        stricmp_near(const char near *s1, const char near *s2);            /* 0x10250 */
int        strnicmp_near(const char near *s1, const char near *s2, uint16_t n);/* 0x10292 */

char  far *strcpy_far (char  far *dst, const char  far *src);   /* 0x1074E */
char  far *strcat_far (char  far *dst, const char  far *src);   /* 0x10784 */
int        strlen_far (const char  far *s);                      /* 0x1070C */
char  far *strrchr_far(const char  far *s, int c);               /* 0x106BA */
char  far *strchr_far (const char  far *s, int c);               /* 0x105E0 */
char  far *strncpy_far(char  far *dst, const char  far *src, uint16_t n); /* 0x10690 */
char  far *strupr_far (char  far *s);                            /* 0x106E8 */
int        strcmp_far (const char  far *s1, const char  far *s2); /* 0x10724 */

void near *memset_near(void near *dst, int c, int n);            /* 0x1037E */

#endif /* VICEROY_IOLIB_H */
