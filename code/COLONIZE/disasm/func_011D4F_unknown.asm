; ============================================================================
; func_011D4F_unknown
; Region   : load_image
; Bytes    : file 0x011D4F..0x011DF0  (161 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

011D4F  C8 0C 00 00           ENTER  0xc, 0                       ; UNKNOWN
011D53  56                    PUSH   si                           ; UNKNOWN
011D54  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0         ; UNKNOWN
011D59  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
011D5D  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
011D62  83 C4 02              ADD    sp, 2                        ; UNKNOWN
011D65  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
011D68  83 C0 04              ADD    ax, 4                        ; UNKNOWN
011D6B  A3 0C 3E              MOV    word ptr [0x3e0c], ax        ; UNKNOWN
011D6E  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
011D71  9A 06 00 BA 33        LCALL  0x33ba, 6                    ; UNKNOWN
011D76  83 C4 02              ADD    sp, 2                        ; UNKNOWN
011D79  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
011D7C  8A 87 7E 09           MOV    al, byte ptr [bx + 0x97e]    ; UNKNOWN
011D80  2A E4                 SUB    ah, ah                       ; UNKNOWN
011D82  50                    PUSH   ax                           ; UNKNOWN
011D83  9A A9 00 0B 38        LCALL  0x380b, 0xa9                 ; UNKNOWN
011D88  83 C4 02              ADD    sp, 2                        ; UNKNOWN
011D8B  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
011D90  75 03                 JNE    0x11d95                      ; UNKNOWN
011D92  E9 1C 01              JMP    0x11eb1                      ; UNKNOWN
011D95  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011D99  F6 47 03 20           TEST   byte ptr [bx + 3], 0x20      ; UNKNOWN
011D9D  74 03                 JE     0x11da2                      ; UNKNOWN
011D9F  E9 0F 01              JMP    0x11eb1                      ; UNKNOWN
011DA2  FF 36 10 3E           PUSH   word ptr [0x3e10]            ; UNKNOWN
011DA6  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
011DA9  9A DF 00 BA 33        LCALL  0x33ba, 0xdf                 ; UNKNOWN
011DAE  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011DB1  89 46 F4              MOV    word ptr [bp - 0xc], ax      ; UNKNOWN
011DB4  83 F8 19              CMP    ax, 0x19                     ; UNKNOWN
011DB7  7C 19                 JL     0x11dd2                      ; UNKNOWN
011DB9  68 90 01              PUSH   0x190                        ; UNKNOWN
011DBC  6A 01                 PUSH   1                            ; UNKNOWN
011DBE  9A DA 00 AA 0D        LCALL  0xdaa, 0xda                  ; UNKNOWN
011DC3  83 C4 04              ADD    sp, 4                        ; UNKNOWN
011DC6  39 46 F4              CMP    word ptr [bp - 0xc], ax      ; UNKNOWN
011DC9  7C 07                 JL     0x11dd2                      ; UNKNOWN
011DCB  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
011DD0  EB 05                 JMP    0x11dd7                      ; UNKNOWN
011DD2  C7 46 F6 00 00        MOV    word ptr [bp - 0xa], 0       ; UNKNOWN
011DD7  8B 1E 38 82           MOV    bx, word ptr [0x8238]        ; UNKNOWN
011DDB  F6 47 03 40           TEST   byte ptr [bx + 3], 0x40      ; UNKNOWN
011DDF  74 05                 JE     0x11de6                      ; UNKNOWN
011DE1  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1       ; UNKNOWN
011DE6  83 7E F6 00           CMP    word ptr [bp - 0xa], 0       ; UNKNOWN
011DEA  75 03                 JNE    0x11def                      ; UNKNOWN
011DEC  E9 C2 00              JMP    0x11eb1                      ; UNKNOWN
011DEF  A0                    DB     0xA0                         ; UNKNOWN (raw)
