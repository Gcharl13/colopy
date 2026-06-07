; ============================================================================
; func_00E39C_unknown
; Region   : load_image
; Bytes    : file 0x00E39C..0x00E3C6  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E39C  55                    PUSH   bp ; STACK_PUSH
00E39D  8B EC                 MOV    bp, sp ; MOV
00E39F  57                    PUSH   di ; STACK_PUSH
00E3A0  56                    PUSH   si ; STACK_PUSH
00E3A1  1E                    PUSH   ds ; STACK_PUSH
00E3A2  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
00E3A5  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00E3A8  48                    DEC    ax ; ARITH
00E3A9  8E C0                 MOV    es, ax ; MOV
00E3AB  BF 08 00              MOV    di, 8 ; MOV
00E3AE  33 C0                 XOR    ax, ax ; LOGIC
00E3B0  B9 04 00              MOV    cx, 4 ; MOV
00E3B3  F3 AB                 REP STOSW word ptr es:[di], ax ; STR
00E3B5  BF 08 00              MOV    di, 8 ; MOV
00E3B8  B9 08 00              MOV    cx, 8 ; MOV
00E3BB  AC                    LODSB  al, byte ptr [si] ; STR
00E3BC  0A C0                 OR     al, al ; LOGIC
00E3BE  AA                    STOSB  byte ptr es:[di], al ; STR
00E3BF  E0 FA                 LOOPNE 0xe3bb ; CJUMP
00E3C1  1F                    POP    ds ; STACK_POP
00E3C2  5E                    POP    si ; STACK_POP
00E3C3  5F                    POP    di ; STACK_POP
00E3C4  C9                    LEAVE ; EPILOGUE
00E3C5  CB                    RETF ; RETURN
