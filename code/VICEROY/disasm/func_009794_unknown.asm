; ============================================================================
; func_009794_unknown
; Region   : load_image
; Bytes    : file 0x009794..0x0097BB  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009794  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
009798  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
00979D  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0097A0  0E                    PUSH   cs ; STACK_PUSH
0097A1  E8 B6 FF              CALL   0x975a ; CALL_NEAR
0097A4  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0097A7  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
0097AA  50                    PUSH   ax ; STACK_PUSH
0097AB  0E                    PUSH   cs ; STACK_PUSH
0097AC  E8 8F EE              CALL   0x863e ; CALL_NEAR
0097AF  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0097B2  0B C0                 OR     ax, ax ; LOGIC
0097B4  74 1B                 JE     0x97d1 ; CJUMP
0097B6  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0097B9  8B C3                 MOV    ax, bx ; MOV
