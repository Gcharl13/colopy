; ============================================================================
; func_0691A4_unknown
; Region   : overlay
; Bytes    : file 0x0691A4..0x0691FD  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0691A4  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
0691A8  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff ; LOCAL_STORE
0691AD  83 3E EA 07 0F        CMP    word ptr [0x7ea], 0xf ; CMP
0691B2  7F 15                 JG     0x691c9 ; CJUMP
0691B4  81 3E E8 07 A0 00     CMP    word ptr [0x7e8], 0xa0 ; CMP
0691BA  7D 08                 JGE    0x691c4 ; CJUMP
0691BC  C7 46 F8 FE FF        MOV    word ptr [bp - 8], 0xfffe ; LOCAL_STORE
0691C1  EB 06                 JMP    0x691c9 ; JUMP
0691C3  90                    NOP ; NOP
0691C4  C7 46 F8 FD FF        MOV    word ptr [bp - 8], 0xfffd ; LOCAL_STORE
0691C9  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
0691CE  EB 3E                 JMP    0x6920e ; JUMP
0691D0  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
0691D3  39 06 AA A5           CMP    word ptr [0xa5aa], ax ; CMP
0691D7  7E 3B                 JLE    0x69214 ; CJUMP
0691D9  8D 4E FC              LEA    cx, [bp - 4] ; ADDR
0691DC  51                    PUSH   cx ; STACK_PUSH
0691DD  8D 4E FE              LEA    cx, [bp - 2] ; ADDR
0691E0  51                    PUSH   cx ; STACK_PUSH
0691E1  50                    PUSH   ax ; STACK_PUSH
0691E2  0E                    PUSH   cs ; STACK_PUSH
0691E3  E8 C5 24              CALL   0x6b6ab ; CALL_NEAR
0691E6  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
0691E9  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
0691ED  7C 1C                 JL     0x6920b ; CJUMP
0691EF  6A 07                 PUSH   7 ; STACK_PUSH
0691F1  6A 64                 PUSH   0x64 ; PUSH_CONST
0691F3  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0691F6  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0691F9  9A                    DB     0x9A ; DATA_BYTE
0691FA  CA                    DB     0xCA ; DATA_BYTE
0691FB  03                    DB     0x03 ; DATA_BYTE
0691FC  1F                    DB     0x1F ; DATA_BYTE
