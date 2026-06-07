; ============================================================================
; func_068A40_unknown
; Region   : load_image
; Bytes    : file 0x068A40..0x068AC7  (135 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068A40  55                    PUSH   bp                           ; UNKNOWN
068A41  8B EC                 MOV    bp, sp                       ; UNKNOWN
068A43  83 EC 04              SUB    sp, 4                        ; UNKNOWN
068A46  56                    PUSH   si                           ; UNKNOWN
068A47  57                    PUSH   di                           ; UNKNOWN
068A48  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
068A4B  F7 66 0A              MUL    word ptr [bp + 0xa]          ; UNKNOWN
068A4E  8B C8                 MOV    cx, ax                       ; UNKNOWN
068A50  E3 5D                 JCXZ   0x68aaf                      ; UNKNOWN
068A52  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
068A55  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
068A58  8B 76 0C              MOV    si, word ptr [bp + 0xc]      ; UNKNOWN
068A5B  BF 18 13              MOV    di, 0x1318                   ; UNKNOWN
068A5E  8B C6                 MOV    ax, si                       ; UNKNOWN
068A60  2D 78 12              SUB    ax, 0x1278                   ; UNKNOWN
068A63  03 F8                 ADD    di, ax                       ; UNKNOWN
068A65  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc       ; UNKNOWN
068A69  75 05                 JNE    0x68a70                      ; UNKNOWN
068A6B  F6 05 01              TEST   byte ptr [di], 1             ; UNKNOWN
068A6E  74 05                 JE     0x68a75                      ; UNKNOWN
068A70  8B 45 02              MOV    ax, word ptr [di + 2]        ; UNKNOWN
068A73  EB 03                 JMP    0x68a78                      ; UNKNOWN
068A75  B8 00 02              MOV    ax, 0x200                    ; UNKNOWN
068A78  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
068A7B  F6 44 06 0C           TEST   byte ptr [si + 6], 0xc       ; UNKNOWN
068A7F  75 05                 JNE    0x68a86                      ; UNKNOWN
068A81  F6 05 01              TEST   byte ptr [di], 1             ; UNKNOWN
068A84  74 2F                 JE     0x68ab5                      ; UNKNOWN
068A86  8B 44 02              MOV    ax, word ptr [si + 2]        ; UNKNOWN
068A89  0B C0                 OR     ax, ax                       ; UNKNOWN
068A8B  74 28                 JE     0x68ab5                      ; UNKNOWN
068A8D  3B C1                 CMP    ax, cx                       ; UNKNOWN
068A8F  76 02                 JBE    0x68a93                      ; UNKNOWN
068A91  8B C1                 MOV    ax, cx                       ; UNKNOWN
068A93  50                    PUSH   ax                           ; UNKNOWN
068A94  53                    PUSH   bx                           ; UNKNOWN
068A95  51                    PUSH   cx                           ; UNKNOWN
068A96  50                    PUSH   ax                           ; UNKNOWN
068A97  FF 34                 PUSH   word ptr [si]                ; UNKNOWN
068A99  53                    PUSH   bx                           ; UNKNOWN
068A9A  0E                    PUSH   cs                           ; UNKNOWN
068A9B  E8 6E 09              CALL   0x6940c                      ; UNKNOWN
068A9E  83 C4 06              ADD    sp, 6                        ; UNKNOWN
068AA1  59                    POP    cx                           ; UNKNOWN
068AA2  5B                    POP    bx                           ; UNKNOWN
068AA3  58                    POP    ax                           ; UNKNOWN
068AA4  2B C8                 SUB    cx, ax                       ; UNKNOWN
068AA6  29 44 02              SUB    word ptr [si + 2], ax        ; UNKNOWN
068AA9  03 D8                 ADD    bx, ax                       ; UNKNOWN
068AAB  01 04                 ADD    word ptr [si], ax            ; UNKNOWN
068AAD  EB 02                 JMP    0x68ab1                      ; UNKNOWN
068AAF  EB 6C                 JMP    0x68b1d                      ; UNKNOWN
068AB1  E3 59                 JCXZ   0x68b0c                      ; UNKNOWN
068AB3  EB C6                 JMP    0x68a7b                      ; UNKNOWN
068AB5  3B 4E FC              CMP    cx, word ptr [bp - 4]        ; UNKNOWN
068AB8  72 2D                 JB     0x68ae7                      ; UNKNOWN
068ABA  33 D2                 XOR    dx, dx                       ; UNKNOWN
068ABC  8B C1                 MOV    ax, cx                       ; UNKNOWN
068ABE  F7 76 FC              DIV    word ptr [bp - 4]            ; UNKNOWN
068AC1  8B C1                 MOV    ax, cx                       ; UNKNOWN
068AC3  2B C2                 SUB    ax, dx                       ; UNKNOWN
068AC5  53                    PUSH   bx                           ; UNKNOWN
068AC6  51                    PUSH   cx                           ; UNKNOWN
