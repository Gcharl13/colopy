; ============================================================================
; func_03FBD0_unknown
; Region   : load_image
; Bytes    : file 0x03FBD0..0x03FC09  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03FBD0  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
03FBD4  52                    PUSH   dx                           ; UNKNOWN
03FBD5  50                    PUSH   ax                           ; UNKNOWN
03FBD6  57                    PUSH   di                           ; UNKNOWN
03FBD7  56                    PUSH   si                           ; UNKNOWN
03FBD8  8B FA                 MOV    di, dx                       ; UNKNOWN
03FBDA  8B F0                 MOV    si, ax                       ; UNKNOWN
03FBDC  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; UNKNOWN
03FBE1  57                    PUSH   di                           ; UNKNOWN
03FBE2  56                    PUSH   si                           ; UNKNOWN
03FBE3  9A 02 00 C9 33        LCALL  0x33c9, 2                    ; UNKNOWN
03FBE8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03FBEB  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
03FBEE  0B C0                 OR     ax, ax                       ; UNKNOWN
03FBF0  74 17                 JE     0x3fc09                      ; UNKNOWN
03FBF2  57                    PUSH   di                           ; UNKNOWN
03FBF3  56                    PUSH   si                           ; UNKNOWN
03FBF4  9A 04 03 C9 33        LCALL  0x33c9, 0x304                ; UNKNOWN
03FBF9  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03FBFC  0B C0                 OR     ax, ax                       ; UNKNOWN
03FBFE  7D 09                 JGE    0x3fc09                      ; UNKNOWN
03FC00  8B 7E FC              MOV    di, word ptr [bp - 4]        ; UNKNOWN
03FC03  8B C7                 MOV    ax, di                       ; UNKNOWN
03FC05  5E                    POP    si                           ; UNKNOWN
03FC06  5F                    POP    di                           ; UNKNOWN
03FC07  C9                    LEAVE                               ; UNKNOWN
03FC08  CB                    RETF                                ; UNKNOWN
