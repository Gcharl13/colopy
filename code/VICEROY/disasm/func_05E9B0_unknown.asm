; ============================================================================
; func_05E9B0_unknown
; Region   : overlay
; Bytes    : file 0x05E9B0..0x05EA38  (136 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05E9B0  C8 CC 00 00           ENTER  0xcc, 0 ; PROLOGUE
05E9B4  56                    PUSH   si ; STACK_PUSH
05E9B5  83 7E 16 00           CMP    word ptr [bp + 0x16], 0 ; CMP
05E9B9  7C 0B                 JL     0x5e9c6 ; CJUMP
05E9BB  FF 76 16              PUSH   word ptr [bp + 0x16] ; PUSH_GLOBAL
05E9BE  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
05E9C3  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05E9C6  83 7E 18 00           CMP    word ptr [bp + 0x18], 0 ; CMP
05E9CA  7C 0B                 JL     0x5e9d7 ; CJUMP
05E9CC  FF 76 18              PUSH   word ptr [bp + 0x18] ; PUSH_GLOBAL
05E9CF  9A 4C 0A 1F 18        LCALL  0x181f, 0xa4c ; THUNK -> 0x05DC:0x0032 (thunk @file 0x01B03C type B) overlay @file 0x021A14
05E9D4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05E9D7  2B C0                 SUB    ax, ax ; ARITH
05E9D9  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
05E9DC  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
05E9DF  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
05E9E2  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
05E9E5  89 46 E4              MOV    word ptr [bp - 0x1c], ax ; LOCAL_STORE
05E9E8  E9 94 10              JMP    0x5fa7f ; JUMP
05E9EB  90                    NOP ; NOP
05E9EC  8B 46 EC              MOV    ax, word ptr [bp - 0x14] ; LOCAL_LOAD
05E9EF  3B 46 EA              CMP    ax, word ptr [bp - 0x16] ; CMP
05E9F2  7D 03                 JGE    0x5e9f7 ; CJUMP
05E9F4  8B 46 EA              MOV    ax, word ptr [bp - 0x16] ; LOCAL_LOAD
05E9F7  6B C0 14              IMUL   ax, ax, 0x14 ; ARITH
05E9FA  05 06 00              ADD    ax, 6 ; ARITH
05E9FD  89 46 8E              MOV    word ptr [bp - 0x72], ax ; LOCAL_STORE
05EA00  8B C8                 MOV    cx, ax ; MOV
05EA02  D1 F8                 SAR    ax, 1 ; LOGIC
05EA04  2D 64 00              SUB    ax, 0x64 ; ARITH
05EA07  F7 D8                 NEG    ax ; ARITH
05EA09  89 46 E6              MOV    word ptr [bp - 0x1a], ax ; LOCAL_STORE
05EA0C  51                    PUSH   cx ; STACK_PUSH
05EA0D  B9 D6 00              MOV    cx, 0xd6 ; CONST_LOAD
05EA10  89 4E 92              MOV    word ptr [bp - 0x6e], cx ; LOCAL_STORE
05EA13  51                    PUSH   cx ; STACK_PUSH
05EA14  50                    PUSH   ax ; STACK_PUSH
05EA15  B9 35 00              MOV    cx, 0x35 ; CONST_LOAD
05EA18  89 4E F0              MOV    word ptr [bp - 0x10], cx ; LOCAL_STORE
05EA1B  51                    PUSH   cx ; STACK_PUSH
05EA1C  6A 00                 PUSH   0 ; STACK_PUSH
05EA1E  6A 00                 PUSH   0 ; STACK_PUSH
05EA20  8B F0                 MOV    si, ax ; MOV
05EA22  9A 10 07 1F 1A        LCALL  0x1a1f, 0x710 ; THUNK -> 0x0000:0x2278 (thunk @file 0x01CD00 type A) overlay @file 0x027B78
05EA27  83 C4 0C              ADD    sp, 0xc ; STACK_CLEANUP
05EA2A  8D 44 03              LEA    ax, [si + 3] ; ADDR
05EA2D  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
05EA30  8A 0E 30 08           MOV    cl, byte ptr [0x830] ; GLOBAL_LOAD
05EA34  2A ED                 SUB    ch, ch ; ARITH
05EA36  51                    PUSH   cx ; STACK_PUSH
05EA37  8B                    DB     0x8B ; DATA_BYTE
