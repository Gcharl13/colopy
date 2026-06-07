; ============================================================================
; func_00E1D2_unknown
; Region   : load_image
; Bytes    : file 0x00E1D2..0x00E2AF  (221 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "$MPOP.$"  (auto-named via string xrefs)
; ============================================================================

00E1D2  C8 2C 00 00           ENTER  0x2c, 0 ; PROLOGUE
00E1D6  52                    PUSH   dx ; STACK_PUSH
00E1D7  50                    PUSH   ax ; STACK_PUSH
00E1D8  53                    PUSH   bx ; STACK_PUSH
00E1D9  57                    PUSH   di ; STACK_PUSH
00E1DA  56                    PUSH   si ; STACK_PUSH
00E1DB  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
00E1E0  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00E1E5  2B F6                 SUB    si, si ; ARITH
00E1E7  8B FE                 MOV    di, si ; MOV
00E1E9  A0 3C 26              MOV    al, byte ptr [0x263c] ; GLOBAL_LOAD
00E1EC  2A E4                 SUB    ah, ah ; ARITH
00E1EE  40                    INC    ax ; ARITH
00E1EF  B9 0A 00              MOV    cx, 0xa ; CONST_LOAD
00E1F2  99                    CDQ ; ARITH
00E1F3  F7 F9                 IDIV   cx ; ARITH
00E1F5  88 16 3C 26           MOV    byte ptr [0x263c], dl ; GLOBAL_LOAD
00E1F9  68 34 26              PUSH   0x2634                       ; STRING: "$MPOP.$"
00E1FC  8D 46 D4              LEA    ax, [bp - 0x2c] ; ADDR
00E1FF  50                    PUSH   ax ; STACK_PUSH
00E200  9A E4 07 1D 0D        LCALL  0xd1d, 0x7e4 ; LCALL
00E205  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00E208  8D 46 D4              LEA    ax, [bp - 0x2c] ; ADDR
00E20B  16                    PUSH   ss ; STACK_PUSH
00E20C  50                    PUSH   ax ; STACK_PUSH
00E20D  A0 3C 26              MOV    al, byte ptr [0x263c] ; GLOBAL_LOAD
00E210  2A E4                 SUB    ah, ah ; ARITH
00E212  BA 01 00              MOV    dx, 1 ; MOV
00E215  9A 02 00 F6 09        LCALL  0x9f6, 2 ; LCALL
00E21A  8A 1E 3C 26           MOV    bl, byte ptr [0x263c] ; GLOBAL_LOAD
00E21E  2A FF                 SUB    bh, bh ; ARITH
00E220  38 BF 3E 26           CMP    byte ptr [bx + 0x263e], bh ; CMP
00E224  75 06                 JNE    0xe22c ; CJUMP
00E226  BE FF FF              MOV    si, 0xffff ; CONST_LOAD
00E229  EB 0D                 JMP    0xe238 ; JUMP
00E22B  90                    NOP ; NOP
00E22C  47                    INC    di ; ARITH
00E22D  83 FF 0A              CMP    di, 0xa ; CMP
00E230  7E 06                 JLE    0xe238 ; CJUMP
00E232  8B 7E FE              MOV    di, word ptr [bp - 2] ; LOCAL_LOAD
00E235  EB 62                 JMP    0xe299 ; JUMP
00E237  90                    NOP ; NOP
00E238  0B F6                 OR     si, si ; LOGIC
00E23A  74 AD                 JE     0xe1e9 ; CJUMP
00E23C  8A 1E 3C 26           MOV    bl, byte ptr [0x263c] ; GLOBAL_LOAD
00E240  2A FF                 SUB    bh, bh ; ARITH
00E242  C6 87 3E 26 FF        MOV    byte ptr [bx + 0x263e], 0xff ; CONST_LOAD
00E247  68 30 26              PUSH   0x2630 ; PUSH_CONST
00E24A  8D 46 D4              LEA    ax, [bp - 0x2c] ; ADDR
00E24D  50                    PUSH   ax ; STACK_PUSH
00E24E  9A DA 04 1D 0D        LCALL  0xd1d, 0x4da ; LCALL
00E253  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00E256  8B F8                 MOV    di, ax ; MOV
00E258  0B FF                 OR     di, di ; LOGIC
00E25A  74 3D                 JE     0xe299 ; CJUMP
00E25C  2B F6                 SUB    si, si ; ARITH
00E25E  39 76 06              CMP    word ptr [bp + 6], si ; CMP
00E261  7E 2E                 JLE    0xe291 ; CJUMP
00E263  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
00E266  8B 56 D2              MOV    dx, word ptr [bp - 0x2e] ; LOCAL_LOAD
00E269  03 D6                 ADD    dx, si ; ARITH
00E26B  8B 5E CE              MOV    bx, word ptr [bp - 0x32] ; LOCAL_LOAD
00E26E  8B 46 D0              MOV    ax, word ptr [bp - 0x30] ; LOCAL_LOAD
00E271  9A 08 00 4E 0A        LCALL  0xa4e, 8 ; LCALL
00E276  52                    PUSH   dx ; STACK_PUSH
00E277  50                    PUSH   ax ; STACK_PUSH
00E278  6A 00                 PUSH   0 ; STACK_PUSH
00E27A  6A 01                 PUSH   1 ; STACK_PUSH
00E27C  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00E27F  99                    CDQ ; ARITH
00E280  8B DF                 MOV    bx, di ; MOV
00E282  9A 9C 0C 1F 1A        LCALL  0x1a1f, 0xc9c ; THUNK -> 0x0000:0x000C (thunk @file 0x01D28C type A) overlay @file 0x02590C
00E287  0B D0                 OR     dx, ax ; LOGIC
00E289  74 0E                 JE     0xe299 ; CJUMP
00E28B  46                    INC    si ; ARITH
00E28C  39 76 06              CMP    word ptr [bp + 6], si ; CMP
00E28F  7F D5                 JG     0xe266 ; CJUMP
00E291  A0 3C 26              MOV    al, byte ptr [0x263c] ; GLOBAL_LOAD
00E294  2A E4                 SUB    ah, ah ; ARITH
00E296  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00E299  0B FF                 OR     di, di ; LOGIC
00E29B  74 09                 JE     0xe2a6 ; CJUMP
00E29D  57                    PUSH   di ; STACK_PUSH
00E29E  9A F4 03 1D 0D        LCALL  0xd1d, 0x3f4 ; LCALL
00E2A3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00E2A6  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00E2A9  5E                    POP    si ; STACK_POP
00E2AA  5F                    POP    di ; STACK_POP
00E2AB  C9                    LEAVE ; EPILOGUE
00E2AC  CA 04 00              RETF   4 ; RETURN
