; ============================================================================
; func_060026_unknown
; Region   : overlay
; Bytes    : file 0x060026..0x0600CD  (167 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060026  C8 68 00 00           ENTER  0x68, 0 ; PROLOGUE
06002A  56                    PUSH   si ; STACK_PUSH
06002B  2B C0                 SUB    ax, ax ; ARITH
06002D  89 46 A4              MOV    word ptr [bp - 0x5c], ax ; LOCAL_STORE
060030  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
060033  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
060036  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
060039  89 46 9C              MOV    word ptr [bp - 0x64], ax ; LOCAL_STORE
06003C  EB 15                 JMP    0x60053 ; JUMP
06003E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
060041  50                    PUSH   ax ; STACK_PUSH
060042  0E                    PUSH   cs ; STACK_PUSH
060043  E8 EB 13              CALL   0x61431 ; CALL_NEAR
060046  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
060049  0B C0                 OR     ax, ax ; LOGIC
06004B  74 03                 JE     0x60050 ; CJUMP
06004D  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
060050  FF 46 9C              INC    word ptr [bp - 0x64] ; ARITH
060053  8B 46 9C              MOV    ax, word ptr [bp - 0x64] ; LOCAL_LOAD
060056  39 06 9E 53           CMP    word ptr [0x539e], ax ; CMP
06005A  7F E2                 JG     0x6003e ; CJUMP
06005C  C7 46 A6 01 00        MOV    word ptr [bp - 0x5a], 1 ; LOCAL_STORE
060061  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
060066  83 7E FC 0A           CMP    word ptr [bp - 4], 0xa ; CMP
06006A  7E 14                 JLE    0x60080 ; CJUMP
06006C  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
06006F  05 09 00              ADD    ax, 9 ; ARITH
060072  B9 0A 00              MOV    cx, 0xa ; CONST_LOAD
060075  99                    CDQ ; ARITH
060076  F7 F9                 IDIV   cx ; ARITH
060078  89 46 A6              MOV    word ptr [bp - 0x5a], ax ; LOCAL_STORE
06007B  89 4E A0              MOV    word ptr [bp - 0x60], cx ; LOCAL_STORE
06007E  EB 07                 JMP    0x60087 ; JUMP
060080  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
060083  40                    INC    ax ; ARITH
060084  89 46 A0              MOV    word ptr [bp - 0x60], ax ; LOCAL_STORE
060087  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
06008B  7C 27                 JL     0x600b4 ; CJUMP
06008D  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
060091  80 BF 46 31 0D        CMP    byte ptr [bx + 0x3146], 0xd ; CMP
060096  72 12                 JB     0x600aa ; CJUMP
060098  80 BF 46 31 12        CMP    byte ptr [bx + 0x3146], 0x12 ; CMP
06009D  77 0B                 JA     0x600aa ; CJUMP
06009F  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
0600A3  8D 06 EE 1C           LEA    ax, [0x1cee] ; ADDR
0600A7  EB 13                 JMP    0x600bc ; JUMP
0600A9  90                    NOP ; NOP
0600AA  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
0600AE  8D 06 F7 1C           LEA    ax, [0x1cf7] ; ADDR
0600B2  EB 08                 JMP    0x600bc ; JUMP
0600B4  8D 1E 7C 08           LEA    bx, [0x87c] ; ADDR
0600B8  8D 06 03 1D           LEA    ax, [0x1d03] ; ADDR
0600BC  2B D2                 SUB    dx, dx ; ARITH
0600BE  9A 82 01 1F 19        LCALL  0x191f, 0x182 ; THUNK -> 0x0000:0x32A4 (thunk @file 0x01B772 type A) overlay @file 0x028BA4
0600C3  89 46 A2              MOV    word ptr [bp - 0x5e], ax ; LOCAL_STORE
0600C6  89 56 A4              MOV    word ptr [bp - 0x5c], dx ; LOCAL_STORE
0600C9  8B C2                 MOV    ax, dx ; MOV
0600CB  0B                    DB     0x0B ; DATA_BYTE
0600CC  46                    DB     0x46 ; DATA_BYTE
