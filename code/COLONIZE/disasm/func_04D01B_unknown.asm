; ============================================================================
; func_04D01B_unknown
; Region   : load_image
; Bytes    : file 0x04D01B..0x04D060  (69 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04D01B  C8 68 00 00           ENTER  0x68, 0                      ; UNKNOWN
04D01F  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04D022  9A 04 00 E2 29        LCALL  0x29e2, 4                    ; UNKNOWN
04D027  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04D02A  C7 46 A6 02 00        MOV    word ptr [bp - 0x5a], 2      ; UNKNOWN
04D02F  C7 46 A2 14 00        MOV    word ptr [bp - 0x5e], 0x14   ; UNKNOWN
04D034  0E                    PUSH   cs                           ; UNKNOWN
04D035  E8 8C FF              CALL   0x4cfc4                      ; UNKNOWN
04D038  2B C0                 SUB    ax, ax                       ; UNKNOWN
04D03A  89 46 AC              MOV    word ptr [bp - 0x54], ax     ; UNKNOWN
04D03D  89 46 98              MOV    word ptr [bp - 0x68], ax     ; UNKNOWN
04D040  89 46 A0              MOV    word ptr [bp - 0x60], ax     ; UNKNOWN
04D043  E9 AA 00              JMP    0x4d0f0                      ; UNKNOWN
04D046  8B 46 9C              MOV    ax, word ptr [bp - 0x64]     ; UNKNOWN
04D049  9A 4E 00 B7 36        LCALL  0x36b7, 0x4e                 ; UNKNOWN
04D04E  89 46 9C              MOV    word ptr [bp - 0x64], ax     ; UNKNOWN
04D051  0B C0                 OR     ax, ax                       ; UNKNOWN
04D053  7C 51                 JL     0x4d0a6                      ; UNKNOWN
04D055  6B D8 1C              IMUL   bx, ax, 0x1c                 ; UNKNOWN
04D058  8A 9F 82 88           MOV    bl, byte ptr [bx - 0x777e]   ; UNKNOWN
04D05C  2A FF                 SUB    bh, bh                       ; UNKNOWN
04D05E  8B C3                 MOV    ax, bx                       ; UNKNOWN
