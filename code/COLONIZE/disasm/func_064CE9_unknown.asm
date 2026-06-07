; ============================================================================
; func_064CE9_unknown
; Region   : load_image
; Bytes    : file 0x064CE9..0x064D7A  (145 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064CE9  55                    PUSH   bp                           ; UNKNOWN
064CEA  8B EC                 MOV    bp, sp                       ; UNKNOWN
064CEC  57                    PUSH   di                           ; UNKNOWN
064CED  56                    PUSH   si                           ; UNKNOWN
064CEE  C4 76 06              LES    si, ptr [bp + 6]             ; UNKNOWN
064CF1  2B FF                 SUB    di, di                       ; UNKNOWN
064CF3  26 39 3C              CMP    word ptr es:[si], di         ; UNKNOWN
064CF6  74 72                 JE     0x64d6a                      ; UNKNOWN
064CF8  26 80 7C 04 01        CMP    byte ptr es:[si + 4], 1      ; UNKNOWN
064CFD  74 55                 JE     0x64d54                      ; UNKNOWN
064CFF  26 80 7C 04 02        CMP    byte ptr es:[si + 4], 2      ; UNKNOWN
064D04  74 4E                 JE     0x64d54                      ; UNKNOWN
064D06  26 39 7C 02           CMP    word ptr es:[si + 2], di     ; UNKNOWN
064D0A  75 37                 JNE    0x64d43                      ; UNKNOWN
064D0C  26 FF 74 06           PUSH   word ptr es:[si + 6]         ; UNKNOWN
064D10  8C C7                 MOV    di, es                       ; UNKNOWN
064D12  9A 5C 0A 65 5F        LCALL  0x5f65, 0xa5c                ; UNKNOWN
064D17  83 C4 02              ADD    sp, 2                        ; UNKNOWN
064D1A  8B C6                 MOV    ax, si                       ; UNKNOWN
064D1C  8B D7                 MOV    dx, di                       ; UNKNOWN
064D1E  83 C0 1A              ADD    ax, 0x1a                     ; UNKNOWN
064D21  52                    PUSH   dx                           ; UNKNOWN
064D22  50                    PUSH   ax                           ; UNKNOWN
064D23  6A 00                 PUSH   0                            ; UNKNOWN
064D25  6A 01                 PUSH   1                            ; UNKNOWN
064D27  8E C7                 MOV    es, di                       ; UNKNOWN
064D29  8B DE                 MOV    bx, si                       ; UNKNOWN
064D2B  26 8B 5F 06           MOV    bx, word ptr es:[bx + 6]     ; UNKNOWN
064D2F  B8 B0 00              MOV    ax, 0xb0                     ; UNKNOWN
064D32  99                    CDQ                                 ; UNKNOWN
064D33  9A 08 00 23 5B        LCALL  0x5b23, 8                    ; UNKNOWN
064D38  0B D0                 OR     dx, ax                       ; UNKNOWN
064D3A  75 05                 JNE    0x64d41                      ; UNKNOWN
064D3C  BF 01 00              MOV    di, 1                        ; UNKNOWN
064D3F  EB 02                 JMP    0x64d43                      ; UNKNOWN
064D41  2B FF                 SUB    di, di                       ; UNKNOWN
064D43  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
064D46  26 FF 74 06           PUSH   word ptr es:[si + 6]         ; UNKNOWN
064D4A  9A BC 02 65 5F        LCALL  0x5f65, 0x2bc                ; UNKNOWN
064D4F  83 C4 02              ADD    sp, 2                        ; UNKNOWN
064D52  EB 16                 JMP    0x64d6a                      ; UNKNOWN
064D54  26 C7 44 10 FF FF     MOV    word ptr es:[si + 0x10], 0xffff ; UNKNOWN
064D5A  26 C7 44 12 00 40     MOV    word ptr es:[si + 0x12], 0x4000 ; UNKNOWN
064D60  2B C0                 SUB    ax, ax                       ; UNKNOWN
064D62  26 89 44 0E           MOV    word ptr es:[si + 0xe], ax   ; UNKNOWN
064D66  26 89 44 0C           MOV    word ptr es:[si + 0xc], ax   ; UNKNOWN
064D6A  8E 46 08              MOV    es, word ptr [bp + 8]        ; UNKNOWN
064D6D  26 C7 04 00 00        MOV    word ptr es:[si], 0          ; UNKNOWN
064D72  8B C7                 MOV    ax, di                       ; UNKNOWN
064D74  5E                    POP    si                           ; UNKNOWN
064D75  5F                    POP    di                           ; UNKNOWN
064D76  C9                    LEAVE                               ; UNKNOWN
064D77  CA 04 00              RETF   4                            ; UNKNOWN
