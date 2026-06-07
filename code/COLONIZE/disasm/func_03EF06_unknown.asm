; ============================================================================
; func_03EF06_unknown
; Region   : load_image
; Bytes    : file 0x03EF06..0x03EFBE  (184 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03EF06  C8 50 00 00           ENTER  0x50, 0                      ; UNKNOWN
03EF0A  FF 36 88 CE           PUSH   word ptr [0xce88]            ; UNKNOWN
03EF0E  FF 36 86 CE           PUSH   word ptr [0xce86]            ; UNKNOWN
03EF12  FF 36 84 CE           PUSH   word ptr [0xce84]            ; UNKNOWN
03EF16  FF 36 82 CE           PUSH   word ptr [0xce82]            ; UNKNOWN
03EF1A  A1 9E 82              MOV    ax, word ptr [0x829e]        ; UNKNOWN
03EF1D  83 C0 08              ADD    ax, 8                        ; UNKNOWN
03EF20  50                    PUSH   ax                           ; UNKNOWN
03EF21  6A 00                 PUSH   0                            ; UNKNOWN
03EF23  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03EF26  BA 07 00              MOV    dx, 7                        ; UNKNOWN
03EF29  8B 1E 9C 82           MOV    bx, word ptr [0x829c]        ; UNKNOWN
03EF2D  9A 00 00 84 5A        LCALL  0x5a84, 0                    ; UNKNOWN
03EF32  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
03EF37  74 05                 JE     0x3ef3e                      ; UNKNOWN
03EF39  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03EF3C  EB 03                 JMP    0x3ef41                      ; UNKNOWN
03EF3E  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
03EF41  9A FC 0F 98 3A        LCALL  0x3a98, 0xffc                ; UNKNOWN
03EF46  9A EA 00 E8 39        LCALL  0x39e8, 0xea                 ; UNKNOWN
03EF4B  9A 47 02 E8 39        LCALL  0x39e8, 0x247                ; UNKNOWN
03EF50  9A 26 01 BE 17        LCALL  0x17be, 0x126                ; UNKNOWN
03EF55  9A 86 05 E8 39        LCALL  0x39e8, 0x586                ; UNKNOWN
03EF5A  83 3E 34 0B 03        CMP    word ptr [0xb34], 3          ; UNKNOWN
03EF5F  75 46                 JNE    0x3efa7                      ; UNKNOWN
03EF61  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0      ; UNKNOWN
03EF65  6B 06 0E 3E 34        IMUL   ax, word ptr [0x3e0e], 0x34  ; UNKNOWN
03EF6A  05 9E C0              ADD    ax, 0xc09e                   ; UNKNOWN
03EF6D  50                    PUSH   ax                           ; UNKNOWN
03EF6E  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03EF71  50                    PUSH   ax                           ; UNKNOWN
03EF72  9A 74 07 65 5F        LCALL  0x5f65, 0x774                ; UNKNOWN
03EF77  83 C4 04              ADD    sp, 4                        ; UNKNOWN
03EF7A  6A 0F                 PUSH   0xf                          ; UNKNOWN
03EF7C  A1 84 82              MOV    ax, word ptr [0x8284]        ; UNKNOWN
03EF7F  F7 2E 7E 82           IMUL   word ptr [0x827e]            ; UNKNOWN
03EF83  C4 1E B4 09           LES    bx, ptr [0x9b4]              ; UNKNOWN
03EF87  26 8A 0F              MOV    cl, byte ptr es:[bx]         ; UNKNOWN
03EF8A  2A ED                 SUB    ch, ch                       ; UNKNOWN
03EF8C  03 C1                 ADD    ax, cx                       ; UNKNOWN
03EF8E  D1 F8                 SAR    ax, 1                        ; UNKNOWN
03EF90  83 C0 08              ADD    ax, 8                        ; UNKNOWN
03EF93  50                    PUSH   ax                           ; UNKNOWN
03EF94  FF 36 9C 82           PUSH   word ptr [0x829c]            ; UNKNOWN
03EF98  6A 00                 PUSH   0                            ; UNKNOWN
03EF9A  8D 46 B0              LEA    ax, [bp - 0x50]              ; UNKNOWN
03EF9D  16                    PUSH   ss                           ; UNKNOWN
03EF9E  50                    PUSH   ax                           ; UNKNOWN
03EF9F  9A 1E 03 13 24        LCALL  0x2413, 0x31e                ; UNKNOWN
03EFA4  83 C4 0C              ADD    sp, 0xc                      ; UNKNOWN
03EFA7  83 3E 1A 3E 00        CMP    word ptr [0x3e1a], 0         ; UNKNOWN
03EFAC  74 05                 JE     0x3efb3                      ; UNKNOWN
03EFAE  B8 FF FF              MOV    ax, 0xffff                   ; UNKNOWN
03EFB1  EB 03                 JMP    0x3efb6                      ; UNKNOWN
03EFB3  A1 0E 3E              MOV    ax, word ptr [0x3e0e]        ; UNKNOWN
03EFB6  50                    PUSH   ax                           ; UNKNOWN
03EFB7  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
03EFBA  9A                    DB     0x9A                         ; UNKNOWN (raw)
03EFBB  80                    DB     0x80                         ; UNKNOWN (raw)
03EFBC  04                    DB     0x04                         ; UNKNOWN (raw)
03EFBD  CF                    DB     0xCF                         ; UNKNOWN (raw)
