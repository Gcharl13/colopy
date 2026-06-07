; ============================================================================
; func_01AFDF_unknown
; Region   : load_image
; Bytes    : file 0x01AFDF..0x01B011  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

01AFDF  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
01AFE3  FF 36 72 09           PUSH   word ptr [0x972]             ; UNKNOWN
01AFE7  FF 36 70 09           PUSH   word ptr [0x970]             ; UNKNOWN
01AFEB  83 7E 08 64           CMP    word ptr [bp + 8], 0x64      ; UNKNOWN
01AFEF  7C 05                 JL     0x1aff6                      ; UNKNOWN
01AFF1  B8 17 00              MOV    ax, 0x17                     ; UNKNOWN
01AFF4  EB 03                 JMP    0x1aff9                      ; UNKNOWN
01AFF6  B8 27 00              MOV    ax, 0x27                     ; UNKNOWN
01AFF9  03 46 06              ADD    ax, word ptr [bp + 6]        ; UNKNOWN
01AFFC  2B D2                 SUB    dx, dx                       ; UNKNOWN
01AFFE  9A 00 00 BC 5C        LCALL  0x5cbc, 0                    ; UNKNOWN
01B003  C7 06 0A 09 01 00     MOV    word ptr [0x90a], 1          ; UNKNOWN
01B009  C7 06 C6 32 07 00     MOV    word ptr [0x32c6], 7         ; UNKNOWN
01B00F  C9                    LEAVE                               ; UNKNOWN
01B010  CB                    RETF                                ; UNKNOWN
