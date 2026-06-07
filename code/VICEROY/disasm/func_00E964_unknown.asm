; ============================================================================
; func_00E964_unknown
; Region   : load_image
; Bytes    : file 0x00E964..0x00E99A  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E964  C8 6E 01 00           ENTER  0x16e, 0 ; PROLOGUE
00E968  52                    PUSH   dx ; STACK_PUSH
00E969  53                    PUSH   bx ; STACK_PUSH
00E96A  50                    PUSH   ax ; STACK_PUSH
00E96B  57                    PUSH   di ; STACK_PUSH
00E96C  56                    PUSH   si ; STACK_PUSH
00E96D  8B 47 02              MOV    ax, word ptr [bx + 2] ; MOV
00E970  48                    DEC    ax ; ARITH
00E971  89 86 9E FE           MOV    word ptr [bp - 0x162], ax ; LOCAL_STORE
00E975  8B 07                 MOV    ax, word ptr [bx] ; MOV
00E977  48                    DEC    ax ; ARITH
00E978  89 86 94 FE           MOV    word ptr [bp - 0x16c], ax ; LOCAL_STORE
00E97C  BA 01 00              MOV    dx, 1 ; MOV
00E97F  8B 86 8C FE           MOV    ax, word ptr [bp - 0x174] ; LOCAL_LOAD
00E983  0B C0                 OR     ax, ax ; LOGIC
00E985  79 03                 JNS    0xe98a ; CJUMP
00E987  BA FF FF              MOV    dx, 0xffff ; CONST_LOAD
00E98A  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
00E98D  25 FF 7F              AND    ax, 0x7fff ; LOGIC
00E990  89 86 8C FE           MOV    word ptr [bp - 0x174], ax ; LOCAL_STORE
00E994  8B 9E 8C FE           MOV    bx, word ptr [bp - 0x174] ; LOCAL_LOAD
00E998  8B C3                 MOV    ax, bx ; MOV
