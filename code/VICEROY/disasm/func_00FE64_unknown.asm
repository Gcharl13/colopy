; ============================================================================
; func_00FE64_unknown
; Region   : load_image
; Bytes    : file 0x00FE64..0x00FE86  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00FE64  55                    PUSH   bp ; STACK_PUSH
00FE65  8B EC                 MOV    bp, sp ; MOV
00FE67  57                    PUSH   di ; STACK_PUSH
00FE68  56                    PUSH   si ; STACK_PUSH
00FE69  1E                    PUSH   ds ; STACK_PUSH
00FE6A  07                    POP    es ; STACK_POP
00FE6B  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
00FE6E  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
00FE71  8B DF                 MOV    bx, di ; MOV
00FE73  8B 4E 0A              MOV    cx, word ptr [bp + 0xa] ; LOCAL_LOAD
00FE76  E3 0C                 JCXZ   0xfe84 ; CJUMP
00FE78  AC                    LODSB  al, byte ptr [si] ; STR
00FE79  0A C0                 OR     al, al ; LOGIC
00FE7B  74 03                 JE     0xfe80 ; CJUMP
00FE7D  AA                    STOSB  byte ptr es:[di], al ; STR
00FE7E  E2 F8                 LOOP   0xfe78 ; CJUMP
00FE80  32 C0                 XOR    al, al ; LOGIC
00FE82  F3 AA                 REP STOSB byte ptr es:[di], al ; STR
00FE84  8B C3                 MOV    ax, bx ; MOV
