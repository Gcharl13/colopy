; ============================================================================
; func_06D938_unknown
; Region   : overlay
; Bytes    : file 0x06D938..0x06D975  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06D938  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
06D93C  56                    PUSH   si ; STACK_PUSH
06D93D  83 3E 5C 1F 07        CMP    word ptr [0x1f5c], 7 ; CMP
06D942  7E 06                 JLE    0x6d94a ; CJUMP
06D944  B8 01 00              MOV    ax, 1 ; MOV
06D947  EB 03                 JMP    0x6d94c ; JUMP
06D949  90                    NOP ; NOP
06D94A  2B C0                 SUB    ax, ax ; ARITH
06D94C  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06D94F  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06D952  26 8B 47 6A           MOV    ax, word ptr es:[bx + 0x6a] ; MOV
06D956  26 0B 47 68           OR     ax, word ptr es:[bx + 0x68] ; LOGIC
06D95A  74 6D                 JE     0x6d9c9 ; CJUMP
06D95C  26 F6 47 0A 40        TEST   byte ptr es:[bx + 0xa], 0x40 ; LOGIC
06D961  75 66                 JNE    0x6d9c9 ; CJUMP
06D963  26 8B 47 68           MOV    ax, word ptr es:[bx + 0x68] ; MOV
06D967  26 8B 57 6A           MOV    dx, word ptr es:[bx + 0x6a] ; MOV
06D96B  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
06D96E  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
06D971  8E C2                 MOV    es, dx ; MOV
06D973  8B D8                 MOV    bx, ax ; MOV
