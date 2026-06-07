; ============================================================================
; func_008352_unknown
; Region   : load_image
; Bytes    : file 0x008352..0x0083AE  (92 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008352  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
008356  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff ; LOCAL_STORE
00835B  2B C0                 SUB    ax, ax ; ARITH
00835D  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
008360  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
008363  EB 7E                 JMP    0x83e3 ; JUMP
008365  90                    NOP ; NOP
008366  8B 5E F6              MOV    bx, word ptr [bp - 0xa] ; LOCAL_LOAD
008369  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
00836D  98                    CWDE ; ARITH
00836E  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
008371  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
008374  50                    PUSH   ax ; STACK_PUSH
008375  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
008379  98                    CWDE ; ARITH
00837A  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
00837D  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
008380  50                    PUSH   ax ; STACK_PUSH
008381  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
008386  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
008389  0B C0                 OR     ax, ax ; LOGIC
00838B  74 53                 JE     0x83e0 ; CJUMP
00838D  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
008390  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
008393  9A 74 00 E4 03        LCALL  0x3e4, 0x74 ; LCALL
008398  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00839B  0B C0                 OR     ax, ax ; LOGIC
00839D  74 41                 JE     0x83e0 ; CJUMP
00839F  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
0083A4  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
0083A7  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
0083AA  9A                    DB     0x9A ; DATA_BYTE
0083AB  CA                    DB     0xCA ; DATA_BYTE
0083AC  01                    DB     0x01 ; DATA_BYTE
0083AD  7F                    DB     0x7F ; DATA_BYTE
