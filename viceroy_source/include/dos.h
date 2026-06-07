/* ============================================================================
 * dos.h — DOS service wrappers (INT 21h, INT 67h)
 * ----------------------------------------------------------------------------
 * Each function here is a 1:1 wrapper around a single DOS or BIOS service
 * call.  They exist to make the C source readable without obscuring the
 * fact that the original VICEROY.EXE made these exact INT calls.
 * ============================================================================ */
#ifndef VICEROY_DOS_H
#define VICEROY_DOS_H

#include "viceroy_types.h"

/* ----------------------------------------------------------------------------
 * INT 21h DOS services (the bulk of all syscalls)
 * ---------------------------------------------------------------------------- */

/* AH=09h — Print String to stdout (DS:DX → '$'-terminated string) */
void     int21h_AH_09(const char *str);

/* AH=1Ah — Set DTA (Disk Transfer Area) at DS:DX */
void     int21h_AH_1A(void *dta);

/* AH=25h — Set Interrupt Vector (AL = vector, DS:DX = handler) */
void     int21h_AH_25(int vector, void (*handler)());

/* AH=2Fh — Get current DTA (returns ES:BX) */
int      int21h_AH_2F(void);

/* AH=30h — Get DOS Version (returns AL=major, AH=minor) */
uint16_t int21h_AH_30(void);

/* AH=35h — Get Interrupt Vector (AL = vector; returns ES:BX) */
void far*int21h_AH_35(int vector);

/* AH=3Ch — Create File (DS:DX = path, CX = attributes; returns AX = handle) */
int      int21h_AH_3C(const char *path, int attr);

/* AH=3Dh — Open File (DS:DX = path, AL = mode; returns AX = handle) */
int      int21h_AH_3D(const char *path, int mode);

/* AH=3Eh — Close File (BX = handle) */
int      int21h_AH_3E(int handle);

/* AH=3Fh — Read From File Handle (BX = handle, CX = count, DS:DX = buf) */
int      int21h_AH_3F(int handle, void *buf, int count);

/* AH=40h — Write to File Handle (BX = handle, CX = count, DS:DX = buf) */
int      int21h_AH_40(int handle, const void *buf, int count);

/* AH=41h — Delete File (DS:DX = path) */
int      int21h_AH_41(const char *path);

/* AX=4200h — Seek from start;  AX=4201h — Seek from current;  AX=4202h — Seek from end */
uint32_t int21h_AX_4200(int handle, uint32_t offset);
uint32_t int21h_AX_4201(int handle, int32_t offset);
uint32_t int21h_AX_4202(int handle, int32_t offset);

/* AX=4300h — Get File Attributes (DS:DX = path; returns CX = attr) */
int      int21h_AX_4300(const char *path);

/* AX=4400h — IOCTL Get Device Info (BX = handle; returns DX = device flags) */
int      int21h_AX_4400(int handle);

/* AH=48h — Allocate Memory (BX = paragraphs; returns AX = segment) */
int      int21h_AH_48(uint16_t paragraphs);

/* AH=4Ah — Resize Memory Block (ES = segment, BX = new paragraphs) */
int      int21h_AH_4A_resize(uint16_t paragraphs);

/* AH=4Bh AL=03h — Load Overlay (DS:DX = path, ES:BX = parameter block) */
int      int21h_AH_4B_AL_3(const char *path, void *param_block);

/* AH=4Ch — Terminate with Status (AL = exit code) — never returns */
void     int21h_AH_4C(int status);

/* AH=4Eh — Find First Match (DS:DX = path, CX = attr) */
int      int21h_AH_4E(const char *path, int attr);

/* AH=4Fh — Find Next Match */
int      int21h_AH_4F(void);

/* ----------------------------------------------------------------------------
 * INT 67h EMS services (Expanded Memory)
 * ---------------------------------------------------------------------------- */

/* AH=42h — Get Number of Pages (returns BX = total, DX = free) */
int      ems_probe_int67_42(void);

/* AH=43h — Allocate Pages (BX = pages; returns DX = handle) */
int      ems_alloc_pages_int67_43(int pages);

/* AH=44h — Map Page (BL = page, DX = handle, AL = window slot) */
int      ems_map_page(int handle, int page, int window_slot);

/* AH=45h — Free Pages (DX = handle) */
int      ems_free_handle(int handle);

/* ----------------------------------------------------------------------------
 * INT 16h BIOS keyboard
 * ---------------------------------------------------------------------------- */
int      int16h_AH_00_get_key(void);
int      int16h_AH_01_check_key(void);

/* ----------------------------------------------------------------------------
 * Helpers used by boot
 * ---------------------------------------------------------------------------- */
void     terminate_via_psp_int20(void);

/* MCB (Memory Control Block) accessor helper */
struct mcb_view {
    char     type;            /* 'M' or 'Z' */
    uint16_t owner;
    uint16_t blk_size;
};
struct mcb_view mcb_at(uint16_t seg);

#endif /* VICEROY_DOS_H */
