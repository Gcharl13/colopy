; ============================================================================
; func_063E96_unknown
; Region   : load_image
; Bytes    : file 0x063E96..0x063F43  (173 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

063E96  C8 06 00 00           ENTER  6, 0                         ; UNKNOWN
063E9A  52                    PUSH   dx                           ; UNKNOWN
063E9B  50                    PUSH   ax                           ; UNKNOWN
063E9C  57                    PUSH   di                           ; UNKNOWN
063E9D  56                    PUSH   si                           ; UNKNOWN
063E9E  BF 01 00              MOV    di, 1                        ; UNKNOWN
063EA1  2B F6                 SUB    si, si                       ; UNKNOWN
063EA3  3B D6                 CMP    dx, si                       ; UNKNOWN
063EA5  7E 23                 JLE    0x63eca                      ; UNKNOWN
063EA7  0B F6                 OR     si, si                       ; UNKNOWN
063EA9  7E 07                 JLE    0x63eb2                      ; UNKNOWN
063EAB  B8 0A 00              MOV    ax, 0xa                      ; UNKNOWN
063EAE  F7 EF                 IMUL   di                           ; UNKNOWN
063EB0  8B F8                 MOV    di, ax                       ; UNKNOWN
063EB2  1E                    PUSH   ds                           ; UNKNOWN
063EB3  68 98 30              PUSH   0x3098                       ; UNKNOWN
063EB6  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063EB9  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063EBC  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
063EC1  83 C4 08              ADD    sp, 8                        ; UNKNOWN
063EC4  46                    INC    si                           ; UNKNOWN
063EC5  3B 76 F8              CMP    si, word ptr [bp - 8]        ; UNKNOWN
063EC8  7C DD                 JL     0x63ea7                      ; UNKNOWN
063ECA  89 7E FA              MOV    word ptr [bp - 6], di        ; UNKNOWN
063ECD  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063ED0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063ED3  9A 48 14 65 5F        LCALL  0x5f65, 0x1448               ; UNKNOWN
063ED8  83 C4 04              ADD    sp, 4                        ; UNKNOWN
063EDB  8B F0                 MOV    si, ax                       ; UNKNOWN
063EDD  2B 76 F8              SUB    si, word ptr [bp - 8]        ; UNKNOWN
063EE0  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063EE3  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063EE6  9A 48 14 65 5F        LCALL  0x5f65, 0x1448               ; UNKNOWN
063EEB  83 C4 04              ADD    sp, 4                        ; UNKNOWN
063EEE  3B C6                 CMP    ax, si                       ; UNKNOWN
063EF0  76 45                 JBE    0x63f37                      ; UNKNOWN
063EF2  89 76 FC              MOV    word ptr [bp - 4], si        ; UNKNOWN
063EF5  8B 76 FA              MOV    si, word ptr [bp - 6]        ; UNKNOWN
063EF8  8B 7E F6              MOV    di, word ptr [bp - 0xa]      ; UNKNOWN
063EFB  3B F7                 CMP    si, di                       ; UNKNOWN
063EFD  7F 18                 JG     0x63f17                      ; UNKNOWN
063EFF  8B C7                 MOV    ax, di                       ; UNKNOWN
063F01  99                    CDQ                                 ; UNKNOWN
063F02  F7 FE                 IDIV   si                           ; UNKNOWN
063F04  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
063F07  F7 EE                 IMUL   si                           ; UNKNOWN
063F09  2B F8                 SUB    di, ax                       ; UNKNOWN
063F0B  8A 46 FE              MOV    al, byte ptr [bp - 2]        ; UNKNOWN
063F0E  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
063F11  03 5E FC              ADD    bx, word ptr [bp - 4]        ; UNKNOWN
063F14  26 00 07              ADD    byte ptr es:[bx], al         ; UNKNOWN
063F17  B9 0A 00              MOV    cx, 0xa                      ; UNKNOWN
063F1A  8B C6                 MOV    ax, si                       ; UNKNOWN
063F1C  99                    CDQ                                 ; UNKNOWN
063F1D  F7 F9                 IDIV   cx                           ; UNKNOWN
063F1F  8B F0                 MOV    si, ax                       ; UNKNOWN
063F21  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
063F24  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
063F27  9A 48 14 65 5F        LCALL  0x5f65, 0x1448               ; UNKNOWN
063F2C  83 C4 04              ADD    sp, 4                        ; UNKNOWN
063F2F  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
063F32  3B 46 FC              CMP    ax, word ptr [bp - 4]        ; UNKNOWN
063F35  77 C4                 JA     0x63efb                      ; UNKNOWN
063F37  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
063F3A  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
063F3D  5E                    POP    si                           ; UNKNOWN
063F3E  5F                    POP    di                           ; UNKNOWN
063F3F  C9                    LEAVE                               ; UNKNOWN
063F40  CA 04 00              RETF   4                            ; UNKNOWN
