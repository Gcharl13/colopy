; ============================================================================
; func_021E36_unknown
; Region   : load_image
; Bytes    : file 0x021E36..0x021EA3  (109 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021E36  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
021E3A  57                    PUSH   di                           ; UNKNOWN
021E3B  56                    PUSH   si                           ; UNKNOWN
021E3C  2B C0                 SUB    ax, ax                       ; UNKNOWN
021E3E  99                    CDQ                                 ; UNKNOWN
021E3F  8B F0                 MOV    si, ax                       ; UNKNOWN
021E41  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
021E44  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
021E47  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
021E4A  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
021E4D  0E                    PUSH   cs                           ; UNKNOWN
021E4E  E8 55 FC              CALL   0x21aa6                      ; UNKNOWN
021E51  83 C4 06              ADD    sp, 6                        ; UNKNOWN
021E54  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
021E57  89 56 EE              MOV    word ptr [bp - 0x12], dx     ; UNKNOWN
021E5A  0B D0                 OR     dx, ax                       ; UNKNOWN
021E5C  75 03                 JNE    0x21e61                      ; UNKNOWN
021E5E  E9 30 01              JMP    0x21f91                      ; UNKNOWN
021E61  2B C0                 SUB    ax, ax                       ; UNKNOWN
021E63  99                    CDQ                                 ; UNKNOWN
021E64  8B C8                 MOV    cx, ax                       ; UNKNOWN
021E66  89 56 F2              MOV    word ptr [bp - 0xe], dx      ; UNKNOWN
021E69  C4 76 EC              LES    si, ptr [bp - 0x14]          ; UNKNOWN
021E6C  26 8B 44 1E           MOV    ax, word ptr es:[si + 0x1e]  ; UNKNOWN
021E70  26 8B 54 20           MOV    dx, word ptr es:[si + 0x20]  ; UNKNOWN
021E74  8B D8                 MOV    bx, ax                       ; UNKNOWN
021E76  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
021E79  0B D0                 OR     dx, ax                       ; UNKNOWN
021E7B  75 31                 JNE    0x21eae                      ; UNKNOWN
021E7D  8B F9                 MOV    di, cx                       ; UNKNOWN
021E7F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
021E82  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
021E85  83 C0 3C              ADD    ax, 0x3c                     ; UNKNOWN
021E88  52                    PUSH   dx                           ; UNKNOWN
021E89  50                    PUSH   ax                           ; UNKNOWN
021E8A  B8 16 00              MOV    ax, 0x16                     ; UNKNOWN
021E8D  99                    CDQ                                 ; UNKNOWN
021E8E  9A 0E 01 7A 5B        LCALL  0x5b7a, 0x10e                ; UNKNOWN
021E93  8B F0                 MOV    si, ax                       ; UNKNOWN
021E95  89 56 FA              MOV    word ptr [bp - 6], dx        ; UNKNOWN
021E98  8B 46 F2              MOV    ax, word ptr [bp - 0xe]      ; UNKNOWN
021E9B  0B C7                 OR     ax, di                       ; UNKNOWN
021E9D  74 2A                 JE     0x21ec9                      ; UNKNOWN
021E9F  8B C2                 MOV    ax, dx                       ; UNKNOWN
021EA1  8E                    DB     0x8E                         ; UNKNOWN (raw)
021EA2  46                    DB     0x46                         ; UNKNOWN (raw)
