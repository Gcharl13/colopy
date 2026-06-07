; ============================================================================
; func_00AB95_unknown
; Region   : load_image
; Bytes    : file 0x00AB95..0x00ABE3  (78 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AB95  C8 3D 04 00           ENTER  0x43d, 0 ; PROLOGUE
00AB99  7D 11                 JGE    0xabac ; CJUMP
00AB9B  6B D8 34              IMUL   bx, ax, 0x34 ; ARITH
00AB9E  38 A7 3F 54           CMP    byte ptr [bx + 0x543f], ah ; CMP
00ABA2  75 08                 JNE    0xabac ; CJUMP
00ABA4  C7 46 DA 01 00        MOV    word ptr [bp - 0x26], 1 ; LOCAL_STORE
00ABA9  EB 06                 JMP    0xabb1 ; JUMP
00ABAB  90                    NOP ; NOP
00ABAC  C7 46 DA 00 00        MOV    word ptr [bp - 0x26], 0 ; LOCAL_STORE
00ABB1  0E                    PUSH   cs ; STACK_PUSH
00ABB2  E8 4B E1              CALL   0x8d00 ; CALL_NEAR
00ABB5  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00ABB8  83 7E DA 00           CMP    word ptr [bp - 0x26], 0 ; CMP
00ABBC  75 66                 JNE    0xac24 ; CJUMP
00ABBE  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00ABC1  89 46 D2              MOV    word ptr [bp - 0x2e], ax ; LOCAL_STORE
00ABC4  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00ABC8  8A 07                 MOV    al, byte ptr [bx] ; MOV
00ABCA  2A E4                 SUB    ah, ah ; ARITH
00ABCC  8A 57 01              MOV    dl, byte ptr [bx + 1] ; MOV
00ABCF  2A F6                 SUB    dh, dh ; ARITH
00ABD1  9A 5C 00 27 04        LCALL  0x427, 0x5c ; LCALL
00ABD6  EB 27                 JMP    0xabff ; JUMP
00ABD8  6B D8 1C              IMUL   bx, ax, 0x1c ; ARITH
00ABDB  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
00ABDF  2A FF                 SUB    bh, bh ; ARITH
00ABE1  8B C3                 MOV    ax, bx ; MOV
