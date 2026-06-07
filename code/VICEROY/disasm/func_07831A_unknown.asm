; ============================================================================
; func_07831A_unknown
; Region   : overlay
; Bytes    : file 0x07831A..0x078394  (122 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

07831A  C8 16 03 00           ENTER  0x316, 0 ; PROLOGUE
07831E  50                    PUSH   ax ; STACK_PUSH
07831F  57                    PUSH   di ; STACK_PUSH
078320  56                    PUSH   si ; STACK_PUSH
078321  8D 86 F2 FC           LEA    ax, [bp - 0x30e] ; ADDR
078325  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
078328  8C 56 FA              MOV    word ptr [bp - 6], ss ; LOCAL_STORE
07832B  8B 4E 06              MOV    cx, word ptr [bp + 6] ; LOCAL_LOAD
07832E  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
078331  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
078334  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
078337  2B C9                 SUB    cx, cx ; ARITH
078339  89 0E 3A 83           MOV    word ptr [0x833a], cx ; GLOBAL_LOAD
07833D  89 0E 38 83           MOV    word ptr [0x8338], cx ; GLOBAL_LOAD
078341  6A 03                 PUSH   3 ; STACK_PUSH
078343  16                    PUSH   ss ; STACK_PUSH
078344  50                    PUSH   ax ; STACK_PUSH
078345  B8 00 FC              MOV    ax, 0xfc00 ; CONST_LOAD
078348  BA 00 A0              MOV    dx, 0xa000 ; CONST_LOAD
07834B  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
07834E  89 56 F6              MOV    word ptr [bp - 0xa], dx ; LOCAL_STORE
078351  52                    PUSH   dx ; STACK_PUSH
078352  50                    PUSH   ax ; STACK_PUSH
078353  0E                    PUSH   cs ; STACK_PUSH
078354  E8 87 00              CALL   0x783de ; CALL_NEAR
078357  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
07835A  C7 46 F2 00 00        MOV    word ptr [bp - 0xe], 0 ; LOCAL_STORE
07835F  9A 22 00 0C 0C        LCALL  0xc0c, 0x22 ; LCALL
078364  8B C8                 MOV    cx, ax ; MOV
078366  8B 86 E8 FC           MOV    ax, word ptr [bp - 0x318] ; LOCAL_LOAD
07836A  8B DA                 MOV    bx, dx ; MOV
07836C  99                    CDQ ; ARITH
07836D  03 C1                 ADD    ax, cx ; ARITH
07836F  13 D3                 ADC    dx, bx ; ARITH
078371  89 86 EE FC           MOV    word ptr [bp - 0x312], ax ; LOCAL_STORE
078375  89 96 F0 FC           MOV    word ptr [bp - 0x310], dx ; LOCAL_STORE
078379  1E                    PUSH   ds ; STACK_PUSH
07837A  C4 5E F8              LES    bx, ptr [bp - 8] ; MOV_FAR
07837D  C4 7E FC              LES    di, ptr [bp - 4] ; MOV_FAR
078380  C5 76 F4              LDS    si, ptr [bp - 0xc] ; MOV_FAR
078383  B9 00 03              MOV    cx, 0x300 ; CONST_LOAD
078386  AC                    LODSB  al, byte ptr [si] ; STR
078387  26 8A 25              MOV    ah, byte ptr es:[di] ; MOV
07838A  86 C4                 XCHG   ah, al ; MOV
07838C  36 8A 17              MOV    dl, byte ptr ss:[bx] ; MOV
07838F  43                    INC    bx ; ARITH
078390  02 C2                 ADD    al, dl ; ARITH
078392  3A C4                 CMP    al, ah ; CMP
