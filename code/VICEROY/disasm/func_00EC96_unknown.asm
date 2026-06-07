; ============================================================================
; func_00EC96_unknown
; Region   : load_image
; Bytes    : file 0x00EC96..0x00ECC7  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EC96  C8 28 00 00           ENTER  0x28, 0 ; PROLOGUE
00EC9A  52                    PUSH   dx ; STACK_PUSH
00EC9B  53                    PUSH   bx ; STACK_PUSH
00EC9C  50                    PUSH   ax ; STACK_PUSH
00EC9D  57                    PUSH   di ; STACK_PUSH
00EC9E  56                    PUSH   si ; STACK_PUSH
00EC9F  8B 47 02              MOV    ax, word ptr [bx + 2] ; MOV
00ECA2  48                    DEC    ax ; ARITH
00ECA3  89 46 E0              MOV    word ptr [bp - 0x20], ax ; LOCAL_STORE
00ECA6  8B 07                 MOV    ax, word ptr [bx] ; MOV
00ECA8  48                    DEC    ax ; ARITH
00ECA9  89 46 DA              MOV    word ptr [bp - 0x26], ax ; LOCAL_STORE
00ECAC  BA 01 00              MOV    dx, 1 ; MOV
00ECAF  8B 46 D2              MOV    ax, word ptr [bp - 0x2e] ; LOCAL_LOAD
00ECB2  0B C0                 OR     ax, ax ; LOGIC
00ECB4  79 03                 JNS    0xecb9 ; CJUMP
00ECB6  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
00ECB9  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
00ECBC  25 FF 7F              AND    ax, 0x7fff ; LOGIC
00ECBF  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
00ECC2  8B 5E D2              MOV    bx, word ptr [bp - 0x2e] ; LOCAL_LOAD
00ECC5  8B C3                 MOV    ax, bx ; MOV
