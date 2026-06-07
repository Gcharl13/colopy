; ============================================================================
; func_0132B0_unknown
; Region   : load_image
; Bytes    : file 0x0132B0..0x0132CA  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0132B0  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
0132B4  56                    PUSH   si ; STACK_PUSH
0132B5  57                    PUSH   di ; STACK_PUSH
0132B6  1E                    PUSH   ds ; STACK_PUSH
0132B7  C4 7E 06              LES    di, ptr [bp + 6] ; MOV_FAR
0132BA  8C C0                 MOV    ax, es ; MOV
0132BC  0B C7                 OR     ax, di ; LOGIC
0132BE  75 0A                 JNE    0x132ca ; CJUMP
0132C0  B8 04 00              MOV    ax, 4 ; MOV
0132C3  1F                    POP    ds ; STACK_POP
0132C4  5F                    POP    di ; STACK_POP
0132C5  5E                    POP    si ; STACK_POP
0132C6  C9                    LEAVE ; EPILOGUE
0132C7  CA 0C 00              RETF   0xc ; RETURN
