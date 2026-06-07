; ============================================================================
; func_02EB20_unknown
; Region   : load_image
; Bytes    : file 0x02EB20..0x02EB62  (66 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EB20  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
02EB24  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0         ; UNKNOWN
02EB29  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02EB2C  0E                    PUSH   cs                           ; UNKNOWN
02EB2D  E8 33 FF              CALL   0x2ea63                      ; UNKNOWN
02EB30  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EB33  0B C0                 OR     ax, ax                       ; UNKNOWN
02EB35  75 2B                 JNE    0x2eb62                      ; UNKNOWN
02EB37  A1 40 73              MOV    ax, word ptr [0x7340]        ; UNKNOWN
02EB3A  EB 17                 JMP    0x2eb53                      ; UNKNOWN
02EB3C  50                    PUSH   ax                           ; UNKNOWN
02EB3D  0E                    PUSH   cs                           ; UNKNOWN
02EB3E  E8 83 F3              CALL   0x2dec4                      ; UNKNOWN
02EB41  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02EB44  0B C0                 OR     ax, ax                       ; UNKNOWN
02EB46  74 03                 JE     0x2eb4b                      ; UNKNOWN
02EB48  FF 46 FE              INC    word ptr [bp - 2]            ; UNKNOWN
02EB4B  8B 46 FA              MOV    ax, word ptr [bp - 6]        ; UNKNOWN
02EB4E  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
02EB53  89 46 FA              MOV    word ptr [bp - 6], ax        ; UNKNOWN
02EB56  0B C0                 OR     ax, ax                       ; UNKNOWN
02EB58  7D E2                 JGE    0x2eb3c                      ; UNKNOWN
02EB5A  F7 5E FE              NEG    word ptr [bp - 2]            ; UNKNOWN
02EB5D  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
02EB60  C9                    LEAVE                               ; UNKNOWN
02EB61  CB                    RETF                                ; UNKNOWN
