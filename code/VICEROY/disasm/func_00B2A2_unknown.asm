; ============================================================================
; func_00B2A2_unknown
; Region   : load_image
; Bytes    : file 0x00B2A2..0x00B2C1  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B2A2  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
00B2A6  56                    PUSH   si                           ; UNKNOWN
00B2A7  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c  ; ARITH
00B2AB  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150]   ; MOV
00B2AF  2A E4                 SUB    ah, ah                       ; UNKNOWN
00B2B1  3B 46 08              CMP    ax, word ptr [bp + 8]        ; UNKNOWN
00B2B4  7F 0C                 JG     0xb2c2                       ; UNKNOWN
00B2B6  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff    ; LOCAL_STORE
00B2BB  8B 46 FC              MOV    ax, word ptr [bp - 4]        ; UNKNOWN
00B2BE  5E                    POP    si                           ; UNKNOWN
00B2BF  C9                    LEAVE                               ; UNKNOWN
00B2C0  CB                    RETF                                ; UNKNOWN
