; ============================================================================
; func_027D84_unknown
; Region   : overlay
; Bytes    : file 0x027D84..0x027DB2  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

027D84  55                    PUSH   bp ; STACK_PUSH
027D85  8B EC                 MOV    bp, sp ; MOV
027D87  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
027D8A  8B C8                 MOV    cx, ax ; MOV
027D8C  D1 E0                 SHL    ax, 1 ; LOGIC
027D8E  03 C1                 ADD    ax, cx ; ARITH
027D90  C1 E0 02              SHL    ax, 2 ; LOGIC
027D93  05 7F 00              ADD    ax, 0x7f ; ARITH
027D96  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
027D99  89 07                 MOV    word ptr [bx], ax ; MOV
027D9B  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
027D9E  C7 07 A5 00           MOV    word ptr [bx], 0xa5 ; CONST_LOAD
027DA2  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
027DA5  C7 07 0A 00           MOV    word ptr [bx], 0xa ; CONST_LOAD
027DA9  8B 5E 0E              MOV    bx, word ptr [bp + 0xe] ; LOCAL_LOAD
027DAC  C7 07 16 00           MOV    word ptr [bx], 0x16 ; CONST_LOAD
027DB0  C9                    LEAVE ; EPILOGUE
027DB1  CB                    RETF ; RETURN
