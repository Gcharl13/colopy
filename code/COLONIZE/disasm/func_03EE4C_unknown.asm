; ============================================================================
; func_03EE4C_unknown
; Region   : load_image
; Bytes    : file 0x03EE4C..0x03EEE5  (153 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03EE4C  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
03EE50  56                    PUSH   si                           ; UNKNOWN
03EE51  8B 76 0E              MOV    si, word ptr [bp + 0xe]      ; UNKNOWN
03EE54  8D 46 0C              LEA    ax, [bp + 0xc]               ; UNKNOWN
03EE57  50                    PUSH   ax                           ; UNKNOWN
03EE58  8D 4E 0A              LEA    cx, [bp + 0xa]               ; UNKNOWN
03EE5B  51                    PUSH   cx                           ; UNKNOWN
03EE5C  8D 56 08              LEA    dx, [bp + 8]                 ; UNKNOWN
03EE5F  52                    PUSH   dx                           ; UNKNOWN
03EE60  8D 5E 06              LEA    bx, [bp + 6]                 ; UNKNOWN
03EE63  53                    PUSH   bx                           ; UNKNOWN
03EE64  9A 47 00 BE 17        LCALL  0x17be, 0x47                 ; UNKNOWN
03EE69  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03EE6C  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
03EE6F  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
03EE74  74 05                 JE     0x3ee7b                      ; UNKNOWN
03EE76  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03EE79  EB 03                 JMP    0x3ee7e                      ; UNKNOWN
03EE7B  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
03EE7E  50                    PUSH   ax                           ; UNKNOWN
03EE7F  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
03EE82  8B 56 08              MOV    dx, word ptr [bp + 8]        ; UNKNOWN
03EE85  8B 5E 0A              MOV    bx, word ptr [bp + 0xa]      ; UNKNOWN
03EE88  9A 45 0D 98 3A        LCALL  0x3a98, 0xd45                ; UNKNOWN
03EE8D  9A EA 00 E8 39        LCALL  0x39e8, 0xea                 ; UNKNOWN
03EE92  9A 47 02 E8 39        LCALL  0x39e8, 0x247                ; UNKNOWN
03EE97  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
03EE9A  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
03EE9D  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03EEA0  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03EEA3  9A BD 00 BE 17        LCALL  0x17be, 0xbd                 ; UNKNOWN
03EEA8  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03EEAB  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
03EEAE  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
03EEB1  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03EEB4  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03EEB7  9A B5 04 E8 39        LCALL  0x39e8, 0x4b5                ; UNKNOWN
03EEBC  83 C4 08              ADD    sp, 8                        ; UNKNOWN
03EEBF  6A 00                 PUSH   0                            ; UNKNOWN
03EEC1  89 76 FE              MOV    word ptr [bp - 2], si        ; UNKNOWN
03EEC4  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
03EEC9  74 05                 JE     0x3eed0                      ; UNKNOWN
03EECB  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03EECE  EB 03                 JMP    0x3eed3                      ; UNKNOWN
03EED0  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
03EED3  50                    PUSH   ax                           ; UNKNOWN
03EED4  56                    PUSH   si                           ; UNKNOWN
03EED5  FF 76 0C              PUSH   word ptr [bp + 0xc]          ; UNKNOWN
03EED8  FF 76 0A              PUSH   word ptr [bp + 0xa]          ; UNKNOWN
03EEDB  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
03EEDE  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03EEE1  9A                    DB     0x9A                         ; UNKNOWN (raw)
03EEE2  5B                    DB     0x5B                         ; UNKNOWN (raw)
03EEE3  03                    DB     0x03                         ; UNKNOWN (raw)
03EEE4  CF                    DB     0xCF                         ; UNKNOWN (raw)
