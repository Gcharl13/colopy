; ============================================================================
; func_02DB3B_unknown
; Region   : load_image
; Bytes    : file 0x02DB3B..0x02DB7A  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02DB3B  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
02DB3F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
02DB42  0E                    PUSH   cs                           ; UNKNOWN
02DB43  E8 E3 FF              CALL   0x2db29                      ; UNKNOWN
02DB46  83 C4 02              ADD    sp, 2                        ; UNKNOWN
02DB49  03 46 08              ADD    ax, word ptr [bp + 8]        ; UNKNOWN
02DB4C  13 56 0A              ADC    dx, word ptr [bp + 0xa]      ; UNKNOWN
02DB4F  0B D2                 OR     dx, dx                       ; UNKNOWN
02DB51  7F 06                 JG     0x2db59                      ; UNKNOWN
02DB53  7D 04                 JGE    0x2db59                      ; UNKNOWN
02DB55  2B D2                 SUB    dx, dx                       ; UNKNOWN
02DB57  2B C0                 SUB    ax, ax                       ; UNKNOWN
02DB59  83 FA 0F              CMP    dx, 0xf                      ; UNKNOWN
02DB5C  7C 0D                 JL     0x2db6b                      ; UNKNOWN
02DB5E  7F 05                 JG     0x2db65                      ; UNKNOWN
02DB60  3D 3F 42              CMP    ax, 0x423f                   ; UNKNOWN
02DB63  76 06                 JBE    0x2db6b                      ; UNKNOWN
02DB65  BA 0F 00              MOV    dx, 0xf                      ; UNKNOWN
02DB68  B8 3F 42              MOV    ax, 0x423f                   ; UNKNOWN
02DB6B  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; UNKNOWN
02DB70  89 87 D4 74           MOV    word ptr [bx + 0x74d4], ax   ; UNKNOWN
02DB74  89 97 D6 74           MOV    word ptr [bx + 0x74d6], dx   ; UNKNOWN
02DB78  C9                    LEAVE                               ; UNKNOWN
02DB79  CB                    RETF                                ; UNKNOWN
