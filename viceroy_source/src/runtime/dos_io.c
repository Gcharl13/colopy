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
