; ============================================================================
; func_064154_unknown
; Region   : overlay
; Bytes    : file 0x064154..0x064183  (47 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

064154  55                    PUSH   bp ; STACK_PUSH
064155  8B EC                 MOV    bp, sp ; MOV
064157  83 7E 04 00           CMP    word ptr [bp + 4], 0 ; CMP
06415B  75 03                 JNE    0x64160 ; CJUMP
06415D  E9 84 00              JMP    0x641e4 ; JUMP
064160  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
064164  74 7E                 JE     0x641e4 ; CJUMP
064166  A1 3A 85              MOV    ax, word ptr [0x853a] ; GLOBAL_LOAD
064169  39 46 04              CMP    word ptr [bp + 4], ax ; CMP
06416C  7D 76                 JGE    0x641e4 ; CJUMP
06416E  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
064171  39 46 06              CMP    word ptr [bp + 6], ax ; CMP
064174  7D 6E                 JGE    0x641e4 ; CJUMP
064176  FF 36 C6 85           PUSH   word ptr [0x85c6] ; PUSH_GLOBAL
06417A  FF 36 C4 85           PUSH   word ptr [0x85c4] ; PUSH_GLOBAL
06417E  FF 36 C2 85           PUSH   word ptr [0x85c2] ; PUSH_GLOBAL
064182  FF                    DB     0xFF ; DATA_BYTE
