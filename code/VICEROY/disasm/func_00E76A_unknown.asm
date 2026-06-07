; ============================================================================
; func_00E76A_unknown
; Region   : load_image
; Bytes    : file 0x00E76A..0x00E79B  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E76A  C8 28 00 00           ENTER  0x28, 0 ; PROLOGUE
00E76E  52                    PUSH   dx ; STACK_PUSH
00E76F  53                    PUSH   bx ; STACK_PUSH
00E770  50                    PUSH   ax ; STACK_PUSH
00E771  57                    PUSH   di ; STACK_PUSH
00E772  56                    PUSH   si ; STACK_PUSH
00E773  8B 47 02              MOV    ax, word ptr [bx + 2] ; MOV
00E776  48                    DEC    ax ; ARITH
00E777  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
00E77A  8B 07                 MOV    ax, word ptr [bx] ; MOV
00E77C  48                    DEC    ax ; ARITH
00E77D  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
00E780  BA 01 00              MOV    dx, 1 ; MOV
00E783  8B 46 D2              MOV    ax, word ptr [bp - 0x2e] ; LOCAL_LOAD
00E786  0B C0                 OR     ax, ax ; LOGIC
00E788  79 03                 JNS    0xe78d ; CJUMP
00E78A  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
00E78D  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
00E790  25 FF 7F              AND    ax, 0x7fff ; LOGIC
00E793  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
00E796  8B 5E D2              MOV    bx, word ptr [bp - 0x2e] ; LOCAL_LOAD
00E799  8B C3                 MOV    ax, bx ; MOV
