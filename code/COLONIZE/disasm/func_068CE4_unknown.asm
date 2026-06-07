; ============================================================================
; func_068CE4_unknown
; Region   : load_image
; Bytes    : file 0x068CE4..0x068D2F  (75 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068CE4  55                    PUSH   bp                           ; UNKNOWN
068CE5  8B EC                 MOV    bp, sp                       ; UNKNOWN
068CE7  83 EC 02              SUB    sp, 2                        ; UNKNOWN
068CEA  57                    PUSH   di                           ; UNKNOWN
068CEB  56                    PUSH   si                           ; UNKNOWN
068CEC  BE 78 12              MOV    si, 0x1278                   ; UNKNOWN
068CEF  2B FF                 SUB    di, di                       ; UNKNOWN
068CF1  89 7E FE              MOV    word ptr [bp - 2], di        ; UNKNOWN
068CF4  EB 08                 JMP    0x68cfe                      ; UNKNOWN
068CF6  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
068CFB  83 C6 08              ADD    si, 8                        ; UNKNOWN
068CFE  39 36 B8 13           CMP    word ptr [0x13b8], si        ; UNKNOWN
068D02  72 16                 JB     0x68d1a                      ; UNKNOWN
068D04  F6 44 06 83           TEST   byte ptr [si + 6], 0x83      ; UNKNOWN
068D08  74 F1                 JE     0x68cfb                      ; UNKNOWN
068D0A  56                    PUSH   si                           ; UNKNOWN
068D0B  9A 18 06 65 5F        LCALL  0x5f65, 0x618                ; UNKNOWN
068D10  83 C4 02              ADD    sp, 2                        ; UNKNOWN
068D13  40                    INC    ax                           ; UNKNOWN
068D14  74 E0                 JE     0x68cf6                      ; UNKNOWN
068D16  47                    INC    di                           ; UNKNOWN
068D17  EB E2                 JMP    0x68cfb                      ; UNKNOWN
068D19  90                    NOP                                 ; UNKNOWN
068D1A  83 7E 04 01           CMP    word ptr [bp + 4], 1         ; UNKNOWN
068D1E  75 04                 JNE    0x68d24                      ; UNKNOWN
068D20  8B C7                 MOV    ax, di                       ; UNKNOWN
068D22  EB 03                 JMP    0x68d27                      ; UNKNOWN
068D24  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
068D27  5E                    POP    si                           ; UNKNOWN
068D28  5F                    POP    di                           ; UNKNOWN
068D29  8B E5                 MOV    sp, bp                       ; UNKNOWN
068D2B  5D                    POP    bp                           ; UNKNOWN
068D2C  C2 02 00              RET    2                            ; UNKNOWN
