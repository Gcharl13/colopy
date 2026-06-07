; ============================================================================
; func_015D30_unknown
; Region   : load_image
; Bytes    : file 0x015D30..0x015D4E  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015D30  55                    PUSH   bp ; STACK_PUSH
015D31  8B EC                 MOV    bp, sp ; MOV
015D33  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
015D36  1E                    PUSH   ds ; STACK_PUSH
015D37  57                    PUSH   di ; STACK_PUSH
015D38  56                    PUSH   si ; STACK_PUSH
015D39  0B C9                 OR     cx, cx ; LOGIC
015D3B  75 03                 JNE    0x15d40 ; CJUMP
015D3D  E9 AF 00              JMP    0x15def ; JUMP
015D40  C5 76 0A              LDS    si, ptr [bp + 0xa] ; MOV_FAR
015D43  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
015D46  1E                    PUSH   ds ; STACK_PUSH
015D47  56                    PUSH   si ; STACK_PUSH
015D48  06                    PUSH   es ; STACK_PUSH
015D49  57                    PUSH   di ; STACK_PUSH
015D4A  9A                    DB     0x9A ; DATA_BYTE
015D4B  CA                    DB     0xCA ; DATA_BYTE
015D4C  1E                    DB     0x1E ; DATA_BYTE
015D4D  88                    DB     0x88 ; DATA_BYTE
