; ============================================================================
; func_0086C0_unknown
; Region   : load_image
; Bytes    : file 0x0086C0..0x0086D3  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0086C0  55                    PUSH   bp ; STACK_PUSH
0086C1  8B EC                 MOV    bp, sp ; MOV
0086C3  EB 09                 JMP    0x86ce ; JUMP
0086C5  90                    NOP ; NOP
0086C6  8A 87 86 8F           MOV    al, byte ptr [bx - 0x707a] ; MOV
0086CA  98                    CWDE ; ARITH
0086CB  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
0086CE  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0086D1  8B C3                 MOV    ax, bx ; MOV
