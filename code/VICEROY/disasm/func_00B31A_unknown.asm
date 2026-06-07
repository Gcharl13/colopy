; ============================================================================
; func_00B31A_unknown
; Region   : load_image
; Bytes    : file 0x00B31A..0x00B367  (77 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B31A  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
00B31E  56                    PUSH   si ; STACK_PUSH
00B31F  C7 46 FC F0 00        MOV    word ptr [bp - 4], 0xf0 ; LOCAL_STORE
00B324  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00B327  D1 F8                 SAR    ax, 1 ; LOGIC
00B329  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00B32C  8B F0                 MOV    si, ax ; MOV
00B32E  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00B332  8A 80 51 31           MOV    al, byte ptr [bx + si + 0x3151] ; MOV
00B336  2A E4                 SUB    ah, ah ; ARITH
00B338  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00B33B  F6 46 08 01           TEST   byte ptr [bp + 8], 1 ; LOGIC
00B33F  74 09                 JE     0xb34a ; CJUMP
00B341  C7 46 FC 0F 00        MOV    word ptr [bp - 4], 0xf ; LOCAL_STORE
00B346  C1 66 0A 04           SHL    word ptr [bp + 0xa], 4 ; LOGIC
00B34A  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
00B34D  23 46 FA              AND    ax, word ptr [bp - 6] ; LOGIC
00B350  0B 46 0A              OR     ax, word ptr [bp + 0xa] ; LOGIC
00B353  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00B356  6B 76 06 1C           IMUL   si, word ptr [bp + 6], 0x1c ; ARITH
00B35A  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
00B35D  88 80 51 31           MOV    byte ptr [bx + si + 0x3151], al ; MOV
00B361  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
00B364  5E                    POP    si ; STACK_POP
00B365  C9                    LEAVE ; EPILOGUE
00B366  CB                    RETF ; RETURN
