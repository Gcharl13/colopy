; ============================================================================
; func_0643F7_unknown
; Region   : load_image
; Bytes    : file 0x0643F7..0x064411  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0643F7  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0643FB  57                    PUSH   di                           ; UNKNOWN
0643FC  56                    PUSH   si                           ; UNKNOWN
0643FD  8B 4E 0A              MOV    cx, word ptr [bp + 0xa]      ; UNKNOWN
064400  8B 76 0E              MOV    si, word ptr [bp + 0xe]      ; UNKNOWN
064403  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
064406  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
064409  3B CE                 CMP    cx, si                       ; UNKNOWN
06440B  75 04                 JNE    0x64411                      ; UNKNOWN
06440D  3B C2                 CMP    ax, dx                       ; UNKNOWN
06440F  74 0C                 JE     0x6441d                      ; UNKNOWN
