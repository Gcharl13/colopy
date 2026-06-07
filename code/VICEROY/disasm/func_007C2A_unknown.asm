; ============================================================================
; func_007C2A_unknown
; Region   : load_image
; Bytes    : file 0x007C2A..0x007C58  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007C2A  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
007C2E  83 7E 08 01           CMP    word ptr [bp + 8], 1 ; CMP
007C32  1B C0                 SBB    ax, ax ; ARITH
007C34  40                    INC    ax ; ARITH
007C35  83 7E 08 01           CMP    word ptr [bp + 8], 1 ; CMP
007C39  1B DB                 SBB    bx, bx ; ARITH
007C3B  F7 DB                 NEG    bx ; ARITH
007C3D  89 5E FC              MOV    word ptr [bp - 4], bx ; LOCAL_STORE
007C40  D1 E3                 SHL    bx, 1 ; LOGIC
007C42  09 87 00 8D           OR     word ptr [bx - 0x7300], ax ; LOGIC
007C46  83 7E 08 00           CMP    word ptr [bp + 8], 0 ; CMP
007C4A  74 1C                 JE     0x7c68 ; CJUMP
007C4C  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
007C50  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
007C54  2A FF                 SUB    bh, bh ; ARITH
007C56  8B C3                 MOV    ax, bx ; MOV
