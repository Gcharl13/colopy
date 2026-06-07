; ============================================================================
; func_0309DA_unknown
; Region   : load_image
; Bytes    : file 0x0309DA..0x030A03  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0309DA  C8 14 00 00           ENTER  0x14, 0                      ; UNKNOWN
0309DE  56                    PUSH   si                           ; UNKNOWN
0309DF  C7 46 FE FE FF        MOV    word ptr [bp - 2], 0xfffe    ; UNKNOWN
0309E4  83 7E 06 13           CMP    word ptr [bp + 6], 0x13      ; UNKNOWN
0309E8  7C 03                 JL     0x309ed                      ; UNKNOWN
0309EA  E9 8F 00              JMP    0x30a7c                      ; UNKNOWN
0309ED  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
0309F0  0E                    PUSH   cs                           ; UNKNOWN
0309F1  E8 D3 D6              CALL   0x2e0c7                      ; UNKNOWN
0309F4  83 C4 02              ADD    sp, 2                        ; UNKNOWN
0309F7  89 46 EC              MOV    word ptr [bp - 0x14], ax     ; UNKNOWN
0309FA  0B C0                 OR     ax, ax                       ; UNKNOWN
0309FC  7C 0F                 JL     0x30a0d                      ; UNKNOWN
0309FE  50                    PUSH   ax                           ; UNKNOWN
0309FF  0E                    PUSH   cs                           ; UNKNOWN
030A00  E8 75 CF              CALL   0x2d978                      ; UNKNOWN
