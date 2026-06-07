; ============================================================================
; func_056BB4_unknown
; Region   : load_image
; Bytes    : file 0x056BB4..0x056C58  (164 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

056BB4  C8 1E 00 00           ENTER  0x1e, 0                      ; UNKNOWN
056BB8  56                    PUSH   si                           ; UNKNOWN
056BB9  C7 06 E4 C6 FF FF     MOV    word ptr [0xc6e4], 0xffff    ; UNKNOWN
056BBF  2B C0                 SUB    ax, ax                       ; UNKNOWN
056BC1  89 46 EA              MOV    word ptr [bp - 0x16], ax     ; UNKNOWN
056BC4  A3 F2 0B              MOV    word ptr [0xbf2], ax         ; UNKNOWN
056BC7  FF 36 86 3E           PUSH   word ptr [0x3e86]            ; UNKNOWN
056BCB  9A 98 00 AA 0D        LCALL  0xdaa, 0x98                  ; UNKNOWN
056BD0  83 C4 02              ADD    sp, 2                        ; UNKNOWN
056BD3  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
056BD6  A3 0C 3E              MOV    word ptr [0x3e0c], ax        ; UNKNOWN
056BD9  50                    PUSH   ax                           ; UNKNOWN
056BDA  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
056BDF  83 C4 02              ADD    sp, 2                        ; UNKNOWN
056BE2  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
056BE5  8A 87 7A 09           MOV    al, byte ptr [bx + 0x97a]    ; UNKNOWN
056BE9  2A E4                 SUB    ah, ah                       ; UNKNOWN
056BEB  50                    PUSH   ax                           ; UNKNOWN
056BEC  9A A9 00 0B 38        LCALL  0x380b, 0xa9                 ; UNKNOWN
056BF1  83 C4 02              ADD    sp, 2                        ; UNKNOWN
056BF4  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
056BF7  8A 87 7A 09           MOV    al, byte ptr [bx + 0x97a]    ; UNKNOWN
056BFB  2A E4                 SUB    ah, ah                       ; UNKNOWN
056BFD  83 E8 08              SUB    ax, 8                        ; UNKNOWN
056C00  89 46 E2              MOV    word ptr [bp - 0x1e], ax     ; UNKNOWN
056C03  6A 10                 PUSH   0x10                         ; UNKNOWN
056C05  6A 00                 PUSH   0                            ; UNKNOWN
056C07  68 5C CD              PUSH   0xcd5c                       ; UNKNOWN
056C0A  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
056C0F  83 C4 06              ADD    sp, 6                        ; UNKNOWN
056C12  8B 5E 06              MOV    bx, word ptr [bp + 6]        ; UNKNOWN
056C15  C6 87 48 CD 00        MOV    byte ptr [bx - 0x32b8], 0    ; UNKNOWN
056C1A  C6 06 DC CD 00        MOV    byte ptr [0xcddc], 0         ; UNKNOWN
056C1F  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
056C24  8B 5E F0              MOV    bx, word ptr [bp - 0x10]     ; UNKNOWN
056C27  F6 87 57 88 08        TEST   byte ptr [bx - 0x77a9], 8    ; UNKNOWN
056C2C  74 04                 JE     0x56c32                      ; UNKNOWN
056C2E  FE 06 DC CD           INC    byte ptr [0xcddc]            ; UNKNOWN
056C32  FF 46 F0              INC    word ptr [bp - 0x10]         ; UNKNOWN
056C35  83 7E F0 10           CMP    word ptr [bp - 0x10], 0x10   ; UNKNOWN
056C39  7C E9                 JL     0x56c24                      ; UNKNOWN
056C3B  FF 76 E2              PUSH   word ptr [bp - 0x1e]         ; UNKNOWN
056C3E  6A 00                 PUSH   0                            ; UNKNOWN
056C40  9A 69 00 0B 38        LCALL  0x380b, 0x69                 ; UNKNOWN
056C45  83 C4 04              ADD    sp, 4                        ; UNKNOWN
056C48  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0      ; UNKNOWN
056C4D  EB 76                 JMP    0x56cc5                      ; UNKNOWN
056C4F  8A 46 06              MOV    al, byte ptr [bp + 6]        ; UNKNOWN
056C52  69 5E F0 CA 00        IMUL   bx, word ptr [bp - 0x10], 0xca ; UNKNOWN
056C57  38                    DB     0x38                         ; UNKNOWN (raw)
