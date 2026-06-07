; ============================================================================
; func_00EEA4_unknown
; Region   : load_image
; Bytes    : file 0x00EEA4..0x00EEDA  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00EEA4  C8 6E 01 00           ENTER  0x16e, 0 ; PROLOGUE
00EEA8  52                    PUSH   dx ; STACK_PUSH
00EEA9  53                    PUSH   bx ; STACK_PUSH
00EEAA  50                    PUSH   ax ; STACK_PUSH
00EEAB  57                    PUSH   di ; STACK_PUSH
00EEAC  56                    PUSH   si ; STACK_PUSH
00EEAD  8B 47 02              MOV    ax, word ptr [bx + 2] ; MOV
00EEB0  48                    DEC    ax ; ARITH
00EEB1  89 86 9E FE           MOV    word ptr [bp - 0x162], ax ; LOCAL_STORE
00EEB5  8B 07                 MOV    ax, word ptr [bx] ; MOV
00EEB7  48                    DEC    ax ; ARITH
00EEB8  89 86 94 FE           MOV    word ptr [bp - 0x16c], ax ; LOCAL_STORE
00EEBC  BA 01 00              MOV    dx, 1 ; MOV
00EEBF  8B 86 8C FE           MOV    ax, word ptr [bp - 0x174] ; LOCAL_LOAD
00EEC3  0B C0                 OR     ax, ax ; LOGIC
00EEC5  79 03                 JNS    0xeeca ; CJUMP
00EEC7  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
00EECA  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
00EECD  25 FF 7F              AND    ax, 0x7fff ; LOGIC
00EED0  89 86 8C FE           MOV    word ptr [bp - 0x174], ax ; LOCAL_STORE
00EED4  8B 9E 8C FE           MOV    bx, word ptr [bp - 0x174] ; LOCAL_LOAD
00EED8  8B C3                 MOV    ax, bx ; MOV
