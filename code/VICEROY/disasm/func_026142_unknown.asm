; ============================================================================
; func_026142_unknown
; Region   : overlay
; Bytes    : file 0x026142..0x026175  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

026142  C8 6E 00 00           ENTER  0x6e, 0 ; PROLOGUE
026146  57                    PUSH   di ; STACK_PUSH
026147  56                    PUSH   si ; STACK_PUSH
026148  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
02614C  7D 03                 JGE    0x26151 ; CJUMP
02614E  E9 E8 01              JMP    0x26339 ; JUMP
026151  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
026154  C1 F8 03              SAR    ax, 3 ; LOGIC
026157  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
02615A  8B D8                 MOV    bx, ax ; MOV
02615C  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
02615F  83 E6 07              AND    si, 7 ; LOGIC
026162  89 76 AE              MOV    word ptr [bp - 0x52], si ; LOCAL_STORE
026165  8B C6                 MOV    ax, si ; MOV
026167  C1 E6 02              SHL    si, 2 ; LOGIC
02616A  03 F0                 ADD    si, ax ; ARITH
02616C  F6 80 F0 8D 10        TEST   byte ptr [bx + si - 0x7210], 0x10 ; LOGIC
026171  74 03                 JE     0x26176 ; CJUMP
026173  E9                    DB     0xE9 ; DATA_BYTE
026174  C3                    DB     0xC3 ; DATA_BYTE
