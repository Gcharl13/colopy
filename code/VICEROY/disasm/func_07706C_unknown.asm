; ============================================================================
; func_07706C_unknown
; Region   : overlay
; Bytes    : file 0x07706C..0x077100  (148 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

07706C  55                    PUSH   bp ; STACK_PUSH
07706D  8B EC                 MOV    bp, sp ; MOV
07706F  57                    PUSH   di ; STACK_PUSH
077070  56                    PUSH   si ; STACK_PUSH
077071  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
077074  2B FF                 SUB    di, di ; ARITH
077076  26 39 3C              CMP    word ptr es:[si], di ; CMP
077079  74 75                 JE     0x770f0 ; CJUMP
07707B  26 80 7C 04 01        CMP    byte ptr es:[si + 4], 1 ; CMP
077080  74 58                 JE     0x770da ; CJUMP
077082  26 80 7C 04 02        CMP    byte ptr es:[si + 4], 2 ; CMP
077087  74 51                 JE     0x770da ; CJUMP
077089  26 39 7C 02           CMP    word ptr es:[si + 2], di ; CMP
07708D  75 39                 JNE    0x770c8 ; CJUMP
07708F  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
077093  8C C7                 MOV    di, es ; MOV
077095  9A D8 0A 1D 0D        LCALL  0xd1d, 0xad8 ; LCALL
07709A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
07709D  8B C6                 MOV    ax, si ; MOV
07709F  8B D7                 MOV    dx, di ; MOV
0770A1  05 1A 00              ADD    ax, 0x1a ; ARITH
0770A4  52                    PUSH   dx ; STACK_PUSH
0770A5  50                    PUSH   ax ; STACK_PUSH
0770A6  6A 00                 PUSH   0 ; STACK_PUSH
0770A8  6A 01                 PUSH   1 ; STACK_PUSH
0770AA  8E C7                 MOV    es, di ; MOV
0770AC  8B DE                 MOV    bx, si ; MOV
0770AE  26 8B 5F 06           MOV    bx, word ptr es:[bx + 6] ; MOV
0770B2  B8 B0 00              MOV    ax, 0xb0 ; CONST_LOAD
0770B5  99                    CDQ ; ARITH
0770B6  9A 9C 0C 1F 1A        LCALL  0x1a1f, 0xc9c ; THUNK -> 0x0000:0x000C (thunk @file 0x01D28C type A) overlay @file 0x02590C
0770BB  0B D0                 OR     dx, ax ; LOGIC
0770BD  75 07                 JNE    0x770c6 ; CJUMP
0770BF  BF 01 00              MOV    di, 1 ; MOV
0770C2  EB 04                 JMP    0x770c8 ; JUMP
0770C4  90                    NOP ; NOP
0770C5  90                    NOP ; NOP
0770C6  2B FF                 SUB    di, di ; ARITH
0770C8  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
0770CB  26 FF 74 06           PUSH   word ptr es:[si + 6] ; STACK_PUSH
0770CF  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
0770D4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0770D7  EB 17                 JMP    0x770f0 ; JUMP
0770D9  90                    NOP ; NOP
0770DA  26 C7 44 10 FF FF     MOV    word ptr es:[si + 0x10], 0xffff ; CONST_LOAD
0770E0  26 C7 44 12 00 40     MOV    word ptr es:[si + 0x12], 0x4000 ; CONST_LOAD
0770E6  2B C0                 SUB    ax, ax ; ARITH
0770E8  26 89 44 0E           MOV    word ptr es:[si + 0xe], ax ; MOV
0770EC  26 89 44 0C           MOV    word ptr es:[si + 0xc], ax ; MOV
0770F0  8E 46 08              MOV    es, word ptr [bp + 8] ; LOCAL_LOAD
0770F3  26 C7 04 00 00        MOV    word ptr es:[si], 0 ; MOV
0770F8  8B C7                 MOV    ax, di ; MOV
0770FA  5E                    POP    si ; STACK_POP
0770FB  5F                    POP    di ; STACK_POP
0770FC  C9                    LEAVE ; EPILOGUE
0770FD  CA 04 00              RETF   4 ; RETURN
