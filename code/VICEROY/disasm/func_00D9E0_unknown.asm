; ============================================================================
; func_00D9E0_unknown
; Region   : load_image
; Bytes    : file 0x00D9E0..0x00DA4F  (111 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D9E0  C8 32 01 00           ENTER  0x132, 0 ; PROLOGUE
00D9E4  50                    PUSH   ax ; STACK_PUSH
00D9E5  57                    PUSH   di ; STACK_PUSH
00D9E6  56                    PUSH   si ; STACK_PUSH
00D9E7  B8 11 00              MOV    ax, 0x11 ; CONST_LOAD
00D9EA  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
00D9ED  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
00D9F0  2B C0                 SUB    ax, ax ; ARITH
00D9F2  B9 04 00              MOV    cx, 4 ; MOV
00D9F5  8D 7E F4              LEA    di, [bp - 0xc] ; ADDR
00D9F8  16                    PUSH   ss ; STACK_PUSH
00D9F9  07                    POP    es ; STACK_POP
00D9FA  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
00D9FC  8D 86 CE FE           LEA    ax, [bp - 0x132] ; ADDR
00DA00  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
00DA03  8C 56 F6              MOV    word ptr [bp - 0xa], ss ; LOCAL_STORE
00DA06  16                    PUSH   ss ; STACK_PUSH
00DA07  50                    PUSH   ax ; STACK_PUSH
00DA08  FF 76 F2              PUSH   word ptr [bp - 0xe] ; PUSH_GLOBAL
00DA0B  FF 76 F0              PUSH   word ptr [bp - 0x10] ; PUSH_GLOBAL
00DA0E  B0 FF                 MOV    al, 0xff ; CONST_LOAD
00DA10  9A 04 00 8D 0B        LCALL  0xb8d, 4 ; LCALL
00DA15  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00DA18  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00DA1B  6A 00                 PUSH   0 ; STACK_PUSH
00DA1D  2B D2                 SUB    dx, dx ; ARITH
00DA1F  89 56 FA              MOV    word ptr [bp - 6], dx ; LOCAL_STORE
00DA22  89 56 F8              MOV    word ptr [bp - 8], dx ; LOCAL_STORE
00DA25  8B 86 CC FE           MOV    ax, word ptr [bp - 0x134] ; LOCAL_LOAD
00DA29  8D 5E F0              LEA    bx, [bp - 0x10] ; ADDR
00DA2C  9A 0A 00 36 0C        LCALL  0xc36, 0xa ; LCALL
00DA31  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00DA36  8D 86 DE FE           LEA    ax, [bp - 0x122] ; ADDR
00DA3A  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00DA3D  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00DA40  8B F8                 MOV    di, ax ; MOV
00DA42  8B 4E F8              MOV    cx, word ptr [bp - 8] ; LOCAL_LOAD
00DA45  8B 56 FA              MOV    dx, word ptr [bp - 6] ; LOCAL_LOAD
00DA48  80 3D FF              CMP    byte ptr [di], 0xff ; CMP
00DA4B  74 02                 JE     0xda4f ; CJUMP
00DA4D  8B CB                 MOV    cx, bx ; MOV
