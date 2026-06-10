/* ============================================================================
 * dos_io.c -- modern-host implementation of the DOS INT 21h file-I/O layer
 * ----------------------------------------------------------------------------
 * _VICEROY_MODERN only.  The rules/load_image code calls the period-correct
 * DOS interrupt wrappers (declared in include/dos.h); on a modern host each
 * maps 1:1 onto libc.  DOS error convention preserved: -1 on failure, else
 * the handle/count/position the original AH service returned in AX(:DX).
 *
 * Deliberately NOT implemented as real services (stubbed, error-return):
 *   AH=48 memory alloc -- RTLink/EMS-era segment arithmetic has no modern
 *                         meaning; the flat build never needs DOS paragraphs.
 *   AH=4E/4F findfirst -- save-slot directory scan; returns "no files" until
 *                         the save/load milestone wires a real directory walk.
 * ============================================================================ */
#ifdef _VICEROY_MODERN

#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>

/* ---- DTA (Disk Transfer Area) bookkeeping: AH=1A set / AH=2F get -------- */
static void *g_dta = 0;

void int21h_AH_1A(void *dta)            { g_dta = dta; }
int  int21h_AH_2F(void)                 { return (int)(intptr_t)g_dta; }

/* ---- create / open / close / unlink ------------------------------------- */
int int21h_AH_3C(const char *path, int attr)
{
    (void)attr;                              /* DOS file attributes ignored */
    return open(path, O_CREAT | O_TRUNC | O_RDWR, 0644);
}

int int21h_AH_3D(const char *path, int mode)
{
    static const int flags[3] = { O_RDONLY, O_WRONLY, O_RDWR };
    return open(path, flags[mode & 3]);
}

int int21h_AH_3E(int handle)            { return close(handle); }
int int21h_AH_41(const char *path)      { return unlink(path); }

/* ---- read / write -------------------------------------------------------- */
int int21h_AH_3F(int handle, void *buf, int count)
{
    long n = read(handle, buf, (unsigned)count);
    return n < 0 ? -1 : (int)n;
}

int int21h_AH_40(int handle, const void *buf, int count)
{
    long n = write(handle, buf, (unsigned)count);
    return n < 0 ? -1 : (int)n;
}

/* ---- seek: unified AH=42 + the per-whence AX=42xx forms ------------------ */
int int21h_AH_42(int handle, long offset, int whence)
{
    static const int w[3] = { SEEK_SET, SEEK_CUR, SEEK_END };
    long p = lseek(handle, offset, w[whence & 3]);
    return p < 0 ? -1 : (int)p;
}

uint32_t int21h_AX_4200(int handle, uint32_t offset)
{
    long p = lseek(handle, (long)offset, SEEK_SET);
    return p < 0 ? (uint32_t)-1 : (uint32_t)p;
}

uint32_t int21h_AX_4201(int handle, int32_t offset)
{
    long p = lseek(handle, offset, SEEK_CUR);
    return p < 0 ? (uint32_t)-1 : (uint32_t)p;
}

uint32_t int21h_AX_4202(int handle, int32_t offset)
{
    long p = lseek(handle, offset, SEEK_END);
    return p < 0 ? (uint32_t)-1 : (uint32_t)p;
}

/* ---- IOCTL AL=00 get device info: always "plain file" -------------------- */
int int21h_AX_4400(int handle)          { (void)handle; return 0; }

/* ---- stubbed services (see header banner) -------------------------------- */
int int21h_AH_48(uint16_t paragraphs)   { (void)paragraphs; return -1; }
int int21h_AH_4E(const char *path, int attr) { (void)path; (void)attr; return -1; }
int int21h_AH_4F(void)                  { return -1; }

#endif /* _VICEROY_MODERN */

/* ============================================================================
 * MSC stdio bridge for the SAVE/LOAD drivers (integration 2026-06-10).
 * The byte-cited DOS leaves (0xD1D:0x4DA fopen / 0x528 fread / 0x60C fwrite /
 * 0x3F4 fclose / 0xE4A remove; the 0x1A1F:0xDE4/0xDEE magic pair and
 * 0xC9C/0xCB4 block IO) become host stdio.  ARG ORDER per the citations:
 * msc_fopen(mode, path).  Strong definitions override the weak floor.
 * ============================================================================ */
#include <stdio.h>
#include <string.h>
#include <stdint.h>

/* The byte-cited serializers pass DGROUP OFFSETS as buffer "pointers"
 * (e.g. fwrite(0x5380,1,142,f) writes the colony-name block).  Rebase any
 * sub-64K pointer through g_dgroup so their structure stays untouched. */
extern unsigned char g_dgroup[];
/* the one FAR block the serializer touches: seg 0x1B22:0000, 0x378 bytes
 * (a resident table; identity pending port -- zeros keep the format length) */
static unsigned char g_far_1B220[0x378];
static void *dg_rebase(const void *p)
{
    uintptr_t a = (uintptr_t)p;
    if (a >= 0x1B220 && a < 0x1B220 + sizeof g_far_1B220)
        return g_far_1B220 + (a - 0x1B220);
    return a < 0x10000 ? (void *)(g_dgroup + a) : (void *)p;
}

void *msc_fopen(const char *mode, const char *path) { return fopen(path, mode); }
int   msc_fclose(void *f)                  { return f ? fclose((FILE *)f) : -1; }
int   msc_fread (void *p, int sz, int n, void *f)
                                           { return (int)fread (dg_rebase(p), (size_t)sz, (size_t)n, (FILE *)f); }
int   msc_fwrite(const void *p, int sz, int n, void *f)
                                           { return (int)fwrite(dg_rebase(p), (size_t)sz, (size_t)n, (FILE *)f); }
int   msc_remove(const char *path)         { return remove(path); }
int   msc_strcmp(const char *a, const char *b) { return strcmp(a, b); }

void  put_magic_string(void *f, const char *s)      /* writes "COLONIZE" + NUL */
{
    fwrite(s, 1, strlen(s) + 1, (FILE *)f);
}
int   get_magic_string(void *f, char *buf)          /* reads through the NUL */
{
    int i = 0, c;
    while (i < 15 && (c = fgetc((FILE *)f)) != EOF) {
        buf[i++] = (char)c;
        if (c == 0) return i;
    }
    buf[i] = 0;
    return i;
}
int   blk_write(void *f, const void *p, uint32_t n) { return (int)fwrite(dg_rebase(p), 1, n, (FILE *)f); }
int   blk_read (void *f, void *p, uint32_t n)       { return (int)fread (dg_rebase(p), 1, n, (FILE *)f); }
