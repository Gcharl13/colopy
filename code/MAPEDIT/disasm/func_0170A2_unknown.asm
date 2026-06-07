; ============================================================================
; func_0170A2_unknown
; Region   : load_image
; Bytes    : file 0x0170A2..0x0170BC  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0170A2  55                    PUSH   bp ; STACK_PUSH
0170A3  8B EC                 MOV    bp, sp ; MOV
0170A5  83 EC 04              SUB    sp, 4 ; STACK_ALLOC
0170A8  32 FF                 XOR    bh, bh ; LOGIC
0170AA  80 3E 70 45 03        CMP    byte ptr [0x4570], 3 ; CMP
0170AF  72 03                 JB     0x170b4 ; CJUMP
0170B1  8A 7E 0A              MOV    bh, byte ptr [bp + 0xa] ; LOCAL_LOAD
0170B4  8B 46 0C              MOV    ax, word ptr [bp + 0xc] ; LOCAL_LOAD
0170B7  89 46 0A              MOV    word ptr [bp + 0xa], ax ; LOCAL_STORE
0170BA  EB 08                 JMP    0x170c4 ; JUMP
