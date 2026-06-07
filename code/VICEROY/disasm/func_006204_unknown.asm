; ============================================================================
; func_006204_unknown
; Region   : load_image
; Bytes    : file 0x006204..0x006232  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006204  55                    PUSH   bp ; STACK_PUSH
006205  8B EC                 MOV    bp, sp ; MOV
006207  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
00620A  24 1F                 AND    al, 0x1f ; LOGIC
00620C  2A E4                 SUB    ah, ah ; ARITH
00620E  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
006211  A1 8E 01              MOV    ax, word ptr [0x18e] ; GLOBAL_LOAD
006214  EB 2C                 JMP    0x6242 ; JUMP
006216  83 7E 06 18           CMP    word ptr [bp + 6], 0x18 ; CMP
00621A  7D 2D                 JGE    0x6249 ; CJUMP
00621C  83 7E 06 08           CMP    word ptr [bp + 6], 8 ; CMP
006220  7C 27                 JL     0x6249 ; CJUMP
006222  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
006225  25 07 00              AND    ax, 7 ; LOGIC
006228  0C 08                 OR     al, 8 ; LOGIC
00622A  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
00622D  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
006230  C9                    LEAVE ; EPILOGUE
006231  CB                    RETF ; RETURN
