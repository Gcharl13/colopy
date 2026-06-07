; ============================================================================
; func_04BE95_unknown
; Region   : load_image
; Bytes    : file 0x04BE95..0x04BEFD  (104 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04BE95  C8 CE 00 00           ENTER  0xce, 0                      ; UNKNOWN
04BE99  56                    PUSH   si                           ; UNKNOWN
04BE9A  6A 60                 PUSH   0x60                         ; UNKNOWN
04BE9C  2B C0                 SUB    ax, ax                       ; UNKNOWN
04BE9E  89 46 FE              MOV    word ptr [bp - 2], ax        ; UNKNOWN
04BEA1  89 46 A2              MOV    word ptr [bp - 0x5e], ax     ; UNKNOWN
04BEA4  89 46 9A              MOV    word ptr [bp - 0x66], ax     ; UNKNOWN
04BEA7  50                    PUSH   ax                           ; UNKNOWN
04BEA8  8D 86 34 FF           LEA    ax, [bp - 0xcc]              ; UNKNOWN
04BEAC  50                    PUSH   ax                           ; UNKNOWN
04BEAD  9A E8 0D 65 5F        LCALL  0x5f65, 0xde8                ; UNKNOWN
04BEB2  83 C4 06              ADD    sp, 6                        ; UNKNOWN
04BEB5  8B 46 08              MOV    ax, word ptr [bp + 8]        ; UNKNOWN
04BEB8  89 46 A6              MOV    word ptr [bp - 0x5a], ax     ; UNKNOWN
04BEBB  83 F8 13              CMP    ax, 0x13                     ; UNKNOWN
04BEBE  75 05                 JNE    0x4bec5                      ; UNKNOWN
04BEC0  C7 46 A6 1C 00        MOV    word ptr [bp - 0x5a], 0x1c   ; UNKNOWN
04BEC5  C7 46 9C 00 00        MOV    word ptr [bp - 0x64], 0      ; UNKNOWN
04BECA  EB 34                 JMP    0x4bf00                      ; UNKNOWN
04BECC  FF 46 AA              INC    word ptr [bp - 0x56]         ; UNKNOWN
04BECF  8B 1E 38 73           MOV    bx, word ptr [0x7338]        ; UNKNOWN
04BED3  8A 47 1F              MOV    al, byte ptr [bx + 0x1f]     ; UNKNOWN
04BED6  98                    CWDE                                ; UNKNOWN
04BED7  3B 46 AA              CMP    ax, word ptr [bp - 0x56]     ; UNKNOWN
04BEDA  7E 21                 JLE    0x4befd                      ; UNKNOWN
04BEDC  FF 76 AA              PUSH   word ptr [bp - 0x56]         ; UNKNOWN
04BEDF  9A 30 0E 5F 24        LCALL  0x245f, 0xe30                ; UNKNOWN
04BEE4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
04BEE7  89 46 A8              MOV    word ptr [bp - 0x58], ax     ; UNKNOWN
04BEEA  3B 46 A6              CMP    ax, word ptr [bp - 0x5a]     ; UNKNOWN
04BEED  75 DD                 JNE    0x4becc                      ; UNKNOWN
04BEEF  FF 46 9A              INC    word ptr [bp - 0x66]         ; UNKNOWN
04BEF2  8B 76 9C              MOV    si, word ptr [bp - 0x64]     ; UNKNOWN
04BEF5  D1 E6                 SHL    si, 1                        ; UNKNOWN
04BEF7  FF 82 34 FF           INC    word ptr [bp + si - 0xcc]    ; UNKNOWN
04BEFB  EB CF                 JMP    0x4becc                      ; UNKNOWN
