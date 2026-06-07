; ============================================================================
; func_006B46_unknown
; Region   : load_image
; Bytes    : file 0x006B46..0x006B8D  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006B46  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
006B4A  57                    PUSH   di ; STACK_PUSH
006B4B  56                    PUSH   si ; STACK_PUSH
006B4C  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
006B4F  C7 46 F8 FF FF        MOV    word ptr [bp - 8], 0xffff ; LOCAL_STORE
006B54  0B F6                 OR     si, si ; LOGIC
006B56  7D 03                 JGE    0x6b5b ; CJUMP
006B58  E9 54 01              JMP    0x6caf ; JUMP
006B5B  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
006B5E  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
006B62  2A E4                 SUB    ah, ah ; ARITH
006B64  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
006B67  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
006B6B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
006B6E  8B C6                 MOV    ax, si ; MOV
006B70  0E                    PUSH   cs ; STACK_PUSH
006B71  E8 FE FA              CALL   0x6672 ; CALL_NEAR
006B74  8B F0                 MOV    si, ax ; MOV
006B76  0B F6                 OR     si, si ; LOGIC
006B78  7C 39                 JL     0x6bb3 ; CJUMP
006B7A  8B C6                 MOV    ax, si ; MOV
006B7C  0E                    PUSH   cs ; STACK_PUSH
006B7D  E8 3A FB              CALL   0x66ba ; CALL_NEAR
006B80  8B F8                 MOV    di, ax ; MOV
006B82  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
006B85  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
006B89  2A FF                 SUB    bh, bh ; ARITH
006B8B  8B C3                 MOV    ax, bx ; MOV
