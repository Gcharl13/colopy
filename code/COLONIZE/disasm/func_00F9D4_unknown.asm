; ============================================================================
; func_00F9D4_unknown
; Region   : load_image
; Bytes    : file 0x00F9D4..0x00FA73  (159 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F9D4  C8 54 00 00           ENTER  0x54, 0                      ; UNKNOWN
00F9D8  C4 5E 0E              LES    bx, ptr [bp + 0xe]           ; UNKNOWN
00F9DB  26 C6 07 00           MOV    byte ptr es:[bx], 0          ; UNKNOWN
00F9DF  8B 46 0C              MOV    ax, word ptr [bp + 0xc]      ; UNKNOWN
00F9E2  0B 46 0A              OR     ax, word ptr [bp + 0xa]      ; UNKNOWN
00F9E5  74 63                 JE     0xfa4a                       ; UNKNOWN
00F9E7  C4 5E 0A              LES    bx, ptr [bp + 0xa]           ; UNKNOWN
00F9EA  26 80 3F 00           CMP    byte ptr es:[bx], 0          ; UNKNOWN
00F9EE  74 5A                 JE     0xfa4a                       ; UNKNOWN
00F9F0  06                    PUSH   es                           ; UNKNOWN
00F9F1  53                    PUSH   bx                           ; UNKNOWN
00F9F2  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
00F9F5  16                    PUSH   ss                           ; UNKNOWN
00F9F6  50                    PUSH   ax                           ; UNKNOWN
00F9F7  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
00F9FC  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00F9FF  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
00FA02  89 46 FC              MOV    word ptr [bp - 4], ax        ; UNKNOWN
00FA05  8C 56 FE              MOV    word ptr [bp - 2], ss        ; UNKNOWN
00FA08  8B D8                 MOV    bx, ax                       ; UNKNOWN
00FA0A  80 3F 00              CMP    byte ptr [bx], 0             ; UNKNOWN
00FA0D  74 0F                 JE     0xfa1e                       ; UNKNOWN
00FA0F  8E 46 FE              MOV    es, word ptr [bp - 2]        ; UNKNOWN
00FA12  FF 46 FC              INC    word ptr [bp - 4]            ; UNKNOWN
00FA15  8B 5E FC              MOV    bx, word ptr [bp - 4]        ; UNKNOWN
00FA18  26 80 3F 00           CMP    byte ptr es:[bx], 0          ; UNKNOWN
00FA1C  75 F4                 JNE    0xfa12                       ; UNKNOWN
00FA1E  8E 46 FE              MOV    es, word ptr [bp - 2]        ; UNKNOWN
00FA21  26 80 7F FF 5C        CMP    byte ptr es:[bx - 1], 0x5c   ; UNKNOWN
00FA26  74 0F                 JE     0xfa37                       ; UNKNOWN
00FA28  68 64 07              PUSH   0x764                        ; UNKNOWN
00FA2B  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
00FA2E  50                    PUSH   ax                           ; UNKNOWN
00FA2F  9A 34 07 65 5F        LCALL  0x5f65, 0x734                ; UNKNOWN
00FA34  83 C4 04              ADD    sp, 4                        ; UNKNOWN
00FA37  8D 46 AC              LEA    ax, [bp - 0x54]              ; UNKNOWN
00FA3A  16                    PUSH   ss                           ; UNKNOWN
00FA3B  50                    PUSH   ax                           ; UNKNOWN
00FA3C  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
00FA3F  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
00FA42  9A 8A 14 65 5F        LCALL  0x5f65, 0x148a               ; UNKNOWN
00FA47  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00FA4A  FF 76 08              PUSH   word ptr [bp + 8]            ; UNKNOWN
00FA4D  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
00FA50  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
00FA53  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
00FA56  9A C0 14 65 5F        LCALL  0x5f65, 0x14c0               ; UNKNOWN
00FA5B  83 C4 08              ADD    sp, 8                        ; UNKNOWN
00FA5E  FF 76 10              PUSH   word ptr [bp + 0x10]         ; UNKNOWN
00FA61  FF 76 0E              PUSH   word ptr [bp + 0xe]          ; UNKNOWN
00FA64  9A 24 14 65 5F        LCALL  0x5f65, 0x1424               ; UNKNOWN
00FA69  8B 46 0E              MOV    ax, word ptr [bp + 0xe]      ; UNKNOWN
00FA6C  8B 56 10              MOV    dx, word ptr [bp + 0x10]     ; UNKNOWN
00FA6F  C9                    LEAVE                               ; UNKNOWN
00FA70  CA 0C 00              RETF   0xc                          ; UNKNOWN
