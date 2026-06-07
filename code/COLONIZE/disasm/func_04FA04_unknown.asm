; ============================================================================
; func_04FA04_unknown
; Region   : load_image
; Bytes    : file 0x04FA04..0x04FA84  (128 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04FA04  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
04FA08  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1         ; UNKNOWN
04FA0D  83 7E 06 00           CMP    word ptr [bp + 6], 0         ; UNKNOWN
04FA11  7E 1A                 JLE    0x4fa2d                      ; UNKNOWN
04FA13  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04FA16  0E                    PUSH   cs                           ; UNKNOWN
04FA17  E8 C6 FF              CALL   0x4f9e0                      ; UNKNOWN
04FA1A  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04FA1D  0B C0                 OR     ax, ax                       ; UNKNOWN
04FA1F  75 77                 JNE    0x4fa98                      ; UNKNOWN
04FA21  6A 01                 PUSH   1                            ; UNKNOWN
04FA23  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
04FA26  0E                    PUSH   cs                           ; UNKNOWN
04FA27  E8 7C FF              CALL   0x4f9a6                      ; UNKNOWN
04FA2A  83 C4 04              ADD    sp, 4                        ; UNKNOWN
04FA2D  8B 46 06              MOV    ax, word ptr [bp + 6]        ; UNKNOWN
04FA30  EB 38                 JMP    0x4fa6a                      ; UNKNOWN
04FA32  83 3E 1A 0F 00        CMP    word ptr [0xf1a], 0          ; UNKNOWN
04FA37  74 54                 JE     0x4fa8d                      ; UNKNOWN
04FA39  83 3E 1C 0F 00        CMP    word ptr [0xf1c], 0          ; UNKNOWN
04FA3E  75 4D                 JNE    0x4fa8d                      ; UNKNOWN
04FA40  6A 02                 PUSH   2                            ; UNKNOWN
04FA42  9A 11 03 28 1A        LCALL  0x1a28, 0x311                ; UNKNOWN
04FA47  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04FA4A  EB 41                 JMP    0x4fa8d                      ; UNKNOWN
04FA4C  6A 02                 PUSH   2                            ; UNKNOWN
04FA4E  9A 44 03 28 1A        LCALL  0x1a28, 0x344                ; UNKNOWN
04FA53  EB F2                 JMP    0x4fa47                      ; UNKNOWN
04FA55  6A 33                 PUSH   0x33                         ; UNKNOWN
04FA57  9A C8 02 28 1A        LCALL  0x1a28, 0x2c8                ; UNKNOWN
04FA5C  EB E9                 JMP    0x4fa47                      ; UNKNOWN
04FA5E  6A 35                 PUSH   0x35                         ; UNKNOWN
04FA60  EB F5                 JMP    0x4fa57                      ; UNKNOWN
04FA62  6A 36                 PUSH   0x36                         ; UNKNOWN
04FA64  EB F1                 JMP    0x4fa57                      ; UNKNOWN
04FA66  6A 39                 PUSH   0x39                         ; UNKNOWN
04FA68  EB ED                 JMP    0x4fa57                      ; UNKNOWN
04FA6A  83 F8 0A              CMP    ax, 0xa                      ; UNKNOWN
04FA6D  77 1E                 JA     0x4fa8d                      ; UNKNOWN
04FA6F  D1 E0                 SHL    ax, 1                        ; UNKNOWN
04FA71  93                    XCHG   bx, ax                       ; UNKNOWN
04FA72  2E FF A7 D7 00        JMP    word ptr cs:[bx + 0xd7]      ; UNKNOWN
04FA77  92                    XCHG   dx, ax                       ; UNKNOWN
04FA78  00 92 00 AC           ADD    byte ptr [bp + si - 0x5400], dl ; UNKNOWN
04FA7C  00 B5 00 BE           ADD    byte ptr [di - 0x4200], dh   ; UNKNOWN
04FA80  00 C2                 ADD    dl, al                       ; UNKNOWN
04FA82  00 C6                 ADD    dh, al                       ; UNKNOWN
