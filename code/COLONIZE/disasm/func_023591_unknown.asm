; ============================================================================
; func_023591_unknown
; Region   : load_image
; Bytes    : file 0x023591..0x0235C4  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

023591  55                    PUSH   bp                           ; UNKNOWN
023592  8B EC                 MOV    bp, sp                       ; UNKNOWN
023594  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
023597  0E                    PUSH   cs                           ; UNKNOWN
023598  E8 E0 FF              CALL   0x2357b                      ; UNKNOWN
02359B  8B E5                 MOV    sp, bp                       ; UNKNOWN
02359D  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
0235A0  39 06 E0 09           CMP    word ptr [0x9e0], ax         ; UNKNOWN
0235A4  74 1C                 JE     0x235c2                      ; UNKNOWN
0235A6  83 3E 1A 0F 00        CMP    word ptr [0xf1a], 0          ; UNKNOWN
0235AB  74 0D                 JE     0x235ba                      ; UNKNOWN
0235AD  83 3E 1C 0F 00        CMP    word ptr [0xf1c], 0          ; UNKNOWN
0235B2  75 06                 JNE    0x235ba                      ; UNKNOWN
0235B4  C7 06 E2 09 01 00     MOV    word ptr [0x9e2], 1          ; UNKNOWN
0235BA  B8 01 00              MOV    ax, 1                        ; UNKNOWN
0235BD  9A 0A 00 11 5D        LCALL  0x5d11, 0xa                  ; UNKNOWN
0235C2  C9                    LEAVE                               ; UNKNOWN
0235C3  CB                    RETF                                ; UNKNOWN
