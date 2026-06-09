/* ============================================================================
 * iolib/file.c — C runtime file I/O primitives
 * ----------------------------------------------------------------------------
 * @ref decompiled.md "Region: boot / file I/O — _open / _creat / fopen"
 * @ref decompiled.md "Five DOS Open sites in VICEROY.EXE"
 *
 * All asset loading in VICEROY reaches the disk through these primitives.
 * The actual asset-loader functions (which open PHYS0.SS, ICONS.SS,
 * VICEROY.PAL, etc.) are in the OVERLAY — see src/overlay/asset_loaders.c.
 * Only 7 of 289 asset filenames appear by name in the load image, because
 * the loaders construct names dynamically with sprintf.
 * ============================================================================ */
#include "viceroy.h"
#include "dos.h"
#include <stdbool.h>
#include <errno.h>

extern int  errno_epilogue(int dos_err);     /* 0x10AE5 — DOS-error → errno mapper */

/* ============================================================================
 * _open — 750+ bytes including the create branch
 * @asm 0x011D30..0x011FxX  (file 0x11D30 prologue; 5 DOS Open sites total)
 *
 * The C runtime's low-level open().  Handles text/binary mode (O_TEXT/
 * O_BINARY), read/write/read-write modes, file creation (O_CREAT),
 * truncation (O_TRUNC), append mode (O_APPEND), and the legacy text-mode
 * CR/LF translation when opening an existing text file for write.
 *
 * @verified DOS Open at file 0x011D60 (B4 3D CD 21 cd2173123d02 — INT 21h
 *           AH=3Dh followed by JAE / CMP AX,2).
 * ============================================================================ */
int _open(const char* path, int oflag, int pmode)
{
    bool text_mode = false;
    char fmode_byte = 0;        /* @asm [bp-4] */

    /* @asm 0x11D44..0x11D58  Determine binary vs text mode */
    if      (oflag & O_BINARY) text_mode = false;
    else if (oflag & O_TEXT)   text_mode = true;
    else if (g_default_text_mode_2B01 & 0x80) text_mode = false;
    else                                       text_mode = true;

    if (text_mode) fmode_byte = 0x80;

    /* @asm 0x11D59..0x11D63  DOS Open */
    int dos_mode = (oflag & 3);
    int handle = int21h_AH_3D(path, dos_mode);
    if (handle < 0) {
        if (errno == ENOENT && (oflag & O_CREAT)) {
            goto create_branch;
        }
        return errno_epilogue(handle);
    }

    /* @asm 0x11D7B..0x11D8A  Special: open + truncate combo */
    if ((oflag & 0x500) == 0x500) {
        int21h_AH_3E(handle);
        return -1;
    }

    /* @asm 0x11D8C..0x11D98  IOCTL Get Device Info */
    int dev_info = int21h_AX_4400(handle);
    if (dev_info & 0x80 /* IFCHR */) {
        /* Character device: skip text-mode translation */
        return handle;
    }

    /* @asm 0x11D9A..0x11DC9  Text-mode CR/LF: peek for ^Z */
    if (text_mode) {
        int21h_AX_4202(handle, 0xFFFFFFFFL);    /* Seek End -1 */
        char ch;
        int n = int21h_AH_3F(handle, &ch, 1);
        if (n != 0 && ch == 0x1A) {
            int21h_AX_4202(handle, 0xFFFFFFFFL);
            int21h_AH_40(handle, 0, 0);          /* Truncate at ^Z position */
        }
        int21h_AX_4200(handle, 0L);
    }

    return handle;

create_branch:
    /* @asm 0x11E13..0x11EA3  File didn't exist + O_CREAT path */
    {
        int new_handle = int21h_AH_3C(path, pmode);
        if (new_handle < 0) return errno_epilogue(new_handle);

        /* @asm 0x11E33  the second of the 5 Open sites — re-open with desired mode */
        if ((oflag & O_RDWR) == 0 && !text_mode) {
            return new_handle;
        }
        int21h_AH_3E(new_handle);                 /* close first */
        int reopen = int21h_AH_3D(path, oflag & 3);
        if (reopen < 0) return errno_epilogue(reopen);
        return reopen;
    }
}

/* ============================================================================
 * _creat — convenience wrapper around _open
 * @asm 0x011E33  embedded in _open's create branch
 * ============================================================================ */
int _creat(const char* path, int pmode)
{
    return _open(path, O_CREAT | O_TRUNC | O_RDWR, pmode);
}

/* ============================================================================
 * _read — 125 bytes
 * @asm 0x0114E4..0x011560
 *
 * Low-level read with text-mode CR/LF translation and ^Z (text-mode EOF).
 * ============================================================================ */
int _read(int fd, void* buf, int count)
{
    /* @asm 0x114E7..0x114F8  fd bound check */
    if (fd >= g_NFILE_QQ) {
        return -1;       /* errno = EBADF */
    }
    if (count == 0) return 0;
    if (g_file_flags[fd] & 2) return 0;       /* AppendMode: empty read */

    /* @asm 0x11507..0x1150F  IOB-dispatch hook */
    if (g_iob_dispatch_2B16 == 0xD6D6) {
        g_iob_dispatch_2B18();
    }

    /* @asm 0x11519..0x11521  DOS Read */
    int n = int21h_AH_3F(/*dos handle for fd*/ fd, buf, count);
    if (n < 0) return -1;

    /* @asm 0x11523..0x1152A  Text-mode? */
    if (!(g_file_flags[fd] & 0x80)) return n;
    g_file_flags[fd] &= 0xFB;

    /* @asm 0x1152F..0x1155F  Text-mode CR/LF translation */
    char* dst = (char*)buf;
    char* src = (char*)buf;
    int remaining = n;
    if (remaining == 0) return n;
    if (*src == '\n') g_file_flags[fd] |= 4;

    while (remaining-- > 0) {
        char c = *src++;
        if (c == '\r') continue;            /* drop CR */
        if (c == 0x1A) {                    /* ^Z */
            g_file_flags[fd] |= 2;          /* EOF flag */
            break;
        }
        *dst++ = c;
    }
    return (int)(dst - (char*)buf);
}

/* ============================================================================
 * _write — 5 bytes (sister of _read with AH=40h)
 * @asm 0x01046D
 *
 * Falls through into the shared rw_impl trampoline at 0x10472.
 * ============================================================================ */
int _write(int fd, const void* buf, int count)
{
    return int21h_AH_40(fd, buf, count);
}

/* ============================================================================
 * _close — 32 bytes
 * @asm 0x01144A..0x011469
 * ============================================================================ */
int _close(int fd)
{
    /* @asm 0x1144A..0x11458  fd bound check */
    if (fd >= g_NFILE_QQ) {
        return -1;       /* errno = EBADF */
    }
    /* @asm 0x1145C..0x1145E  DOS Close */
    int rc = int21h_AH_3E(fd);
    g_file_flags[fd] = 0;
    return rc;
}

/* ============================================================================
 * unlink — 14 bytes
 * @asm 0x01041A..0x010427
 *
 * INT 21h AH=41h (Delete File) with the path in DS:DX.
 * ============================================================================ */
int _unlink(const char* path)
{
    int rc = int21h_AH_41(path);
    if (rc < 0) return errno_epilogue(rc);
    return 0;
}

/* ============================================================================
 * _dos_findfirst / _dos_findnext — 79 bytes (combined)
 * @asm 0x010433..0x010482
 * ============================================================================ */
int _dos_findfirst(const char* path, int attr, void* finfo)
{
    int prev_dta = int21h_AH_2F();          /* Get current DTA */
    int21h_AH_1A(finfo);                     /* Set new DTA */
    int rc = int21h_AH_4E(path, attr);       /* Find First Match */
    int21h_AH_1A((void*)prev_dta);           /* Restore DTA */
    return rc;
}

int _dos_findnext(void* finfo)
{
    int prev_dta = int21h_AH_2F();
    int21h_AH_1A(finfo);
    int rc = int21h_AH_4F();                 /* Find Next Match */
    int21h_AH_1A((void*)prev_dta);
    return rc;
}

/* ============================================================================
 * Memory primitives — coreleft_total / coreleft_max
 * ============================================================================ */

/* @asm 0x0124D6..0x012530  (90 bytes)
 * @ref FUNCTIONS_INVENTORY.md "coreleft_total" */
uint32_t coreleft_total(void)
{
    /* INT 21h AH=48h BX=FFFF (deliberate fail) returns BX = max paragraphs */
    int max_paras = int21h_AH_48(0xFFFF);

    /* Walk MCB chain starting at saved DGROUP segment for total count */
    uint32_t total = 0;
    uint16_t mcb = g_program_ds - 1;        /* MCB precedes program PSP */
    while (true) {
        uint8_t mcb_type = mcb_at(mcb).type;
        uint16_t blk_size = mcb_at(mcb).blk_size;
        uint16_t owner    = mcb_at(mcb).owner;
        if (owner == 0) total += blk_size;   /* free block */
        if (mcb_type == 'Z') break;          /* end of chain */
        mcb += blk_size + 1;                 /* skip past block */
    }
    return total * 16;                        /* paragraphs → bytes */
}

/* @asm 0x078AF2..0x078B07  (23 bytes)
 * @ref FUNCTIONS_INVENTORY.md "coreleft_max" */
uint32_t coreleft_max(void)
{
    int paras = int21h_AH_48(0xFFFF);
    return ((uint32_t)paras) << 4;            /* paragraphs → bytes */
}
