; ============================================================================
; func_068B24_unknown
; Region   : load_image
; Bytes    : file 0x068B24..0x068BC7  (163 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068B24  55                    PUSH   bp                           ; UNKNOWN
068B25  8B EC                 MOV    bp, sp                       ; UNKNOWN
068B27  83 EC 04              SUB    sp, 4                        ; UNKNOWN
068B2A  56                    PUSH   si                           ; UNKNOWN
068B2B  57                    PUSH   di                           ; UNKNOWN
068B2C  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
068B2F  F7 66 0A              MUL    word ptr [bp + 0xa]          ; UNKNOWN
068B32  8B C8                 MOV    cx, ax                       ; UNKNOWN
068B34  E3 5D                 JCXZ   0x68b93                      ; UNKNOWN
068B36  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
068B39  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
068B3C  8B 76 0C              MOV    si, word ptr [bp + 0xc]      ; UNKNOWN
068B3F  BF 18 13              MOV    di, 0x1318                   ; UNKNOWN
068B42  8B C6                 MOV    ax, si                       ; UNKNOWN
068B44  2D 78 12              SUB    ax, 0x1278                   ; UNKNOWN
068B47  03 F8                 ADD    di, ax                       ; UNKNOWN
068B49  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc       ; UNKNOWN
068B4D  75 05                 JNE    0x68b54                      ; UNKNOWN
068B4F  F6 05 01              TEST   byte ptr [di], 1             ; UNKNOWN
068B52  74 05                 JE     0x68b59                      ; UNKNOWN
068B54  8B 45 02              MOV    ax, word ptr [di + 2]        ; UNKNOWN
068B57  EB 03                 JMP    0x68b5c                      ; UNKNOWN
068B59  B8 00 02              MOV    ax, 0x200                    ; UNKNOWN
068B5C  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
068B5F  F6 44 06 08           TEST   byte ptr [si + 6], 8         ; UNKNOWN
068B63  75 05                 JNE    0x68b6a                      ; UNKNOWN
068B65  F6 05 01              TEST   byte ptr [di], 1             ; UNKNOWN
068B68  74 32                 JE     0x68b9c                      ; UNKNOWN
068B6A  8B 44 02              MOV    ax, word ptr [si + 2]        ; UNKNOWN
068B6D  0B C0                 OR     ax, ax                       ; UNKNOWN
068B6F  74 2B                 JE     0x68b9c                      ; UNKNOWN
068B71  3B C1                 CMP    ax, cx                       ; UNKNOWN
068B73  76 02                 JBE    0x68b77                      ; UNKNOWN
068B75  8B C1                 MOV    ax, cx                       ; UNKNOWN
068B77  50                    PUSH   ax                           ; UNKNOWN
068B78  53                    PUSH   bx                           ; UNKNOWN
068B79  51                    PUSH   cx                           ; UNKNOWN
068B7A  50                    PUSH   ax                           ; UNKNOWN
068B7B  53                    PUSH   bx                           ; UNKNOWN
068B7C  FF 34                 PUSH   word ptr [si]                ; UNKNOWN
068B7E  0E                    PUSH   cs                           ; UNKNOWN
068B7F  E8 8A 08              CALL   0x6940c                      ; UNKNOWN
068B82  83 C4 06              ADD    sp, 6                        ; UNKNOWN
068B85  59                    POP    cx                           ; UNKNOWN
068B86  5B                    POP    bx                           ; UNKNOWN
068B87  58                    POP    ax                           ; UNKNOWN
068B88  2B C8                 SUB    cx, ax                       ; UNKNOWN
068B8A  29 44 02              SUB    word ptr [si + 2], ax        ; UNKNOWN
068B8D  03 D8                 ADD    bx, ax                       ; UNKNOWN
068B8F  01 04                 ADD    word ptr [si], ax            ; UNKNOWN
068B91  EB 03                 JMP    0x68b96                      ; UNKNOWN
068B93  E9 8D 00              JMP    0x68c23                      ; UNKNOWN
068B96  0B C9                 OR     cx, cx                       ; UNKNOWN
068B98  75 C5                 JNE    0x68b5f                      ; UNKNOWN
068B9A  EB 76                 JMP    0x68c12                      ; UNKNOWN
068B9C  3B 4E FC              CMP    cx, word ptr [bp - 4]        ; UNKNOWN
068B9F  72 48                 JB     0x68be9                      ; UNKNOWN
068BA1  F6 44 06 08           TEST   byte ptr [si + 6], 8         ; UNKNOWN
068BA5  75 05                 JNE    0x68bac                      ; UNKNOWN
068BA7  F6 05 01              TEST   byte ptr [di], 1             ; UNKNOWN
068BAA  74 0E                 JE     0x68bba                      ; UNKNOWN
068BAC  53                    PUSH   bx                           ; UNKNOWN
068BAD  51                    PUSH   cx                           ; UNKNOWN
068BAE  56                    PUSH   si                           ; UNKNOWN
068BAF  0E                    PUSH   cs                           ; UNKNOWN
068BB0  E8 B5 00              CALL   0x68c68                      ; UNKNOWN
068BB3  5A                    POP    dx                           ; UNKNOWN
068BB4  59                    POP    cx                           ; UNKNOWN
068BB5  5B                    POP    bx                           ; UNKNOWN
068BB6  0B C0                 OR     ax, ax                       ; UNKNOWN
068BB8  75 58                 JNE    0x68c12                      ; UNKNOWN
068BBA  33 D2                 XOR    dx, dx                       ; UNKNOWN
068BBC  8B C1                 MOV    ax, cx                       ; UNKNOWN
068BBE  F7 76 FC              DIV    word ptr [bp - 4]            ; UNKNOWN
068BC1  8B C1                 MOV    ax, cx                       ; UNKNOWN
068BC3  2B C2                 SUB    ax, dx                       ; UNKNOWN
068BC5  50                    PUSH   ax                           ; UNKNOWN
068BC6  53                    PUSH   bx                           ; UNKNOWN
