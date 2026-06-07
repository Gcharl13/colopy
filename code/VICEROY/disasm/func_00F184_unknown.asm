; ============================================================================
; func_00F184_unknown
; Region   : load_image
; Bytes    : file 0x00F184..0x00F1B5  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00F184  C8 28 00 00           ENTER  0x28, 0 ; PROLOGUE
00F188  52                    PUSH   dx ; STACK_PUSH
00F189  53                    PUSH   bx ; STACK_PUSH
00F18A  50                    PUSH   ax ; STACK_PUSH
00F18B  57                    PUSH   di ; STACK_PUSH
00F18C  56                    PUSH   si ; STACK_PUSH
00F18D  8B 47 02              MOV    ax, word ptr [bx + 2] ; MOV
00F190  48                    DEC    ax ; ARITH
00F191  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
00F194  8B 07                 MOV    ax, word ptr [bx] ; MOV
00F196  48                    DEC    ax ; ARITH
00F197  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
00F19A  BA 01 00              MOV    dx, 1 ; MOV
00F19D  8B 46 D2              MOV    ax, word ptr [bp - 0x2e] ; LOCAL_LOAD
00F1A0  0B C0                 OR     ax, ax ; LOGIC
00F1A2  79 03                 JNS    0xf1a7 ; CJUMP
00F1A4  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
00F1A7  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
00F1AA  25 FF 7F              AND    ax, 0x7fff ; LOGIC
00F1AD  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
00F1B0  8B 5E D2              MOV    bx, word ptr [bp - 0x2e] ; LOCAL_LOAD
00F1B3  8B C3                 MOV    ax, bx ; MOV
