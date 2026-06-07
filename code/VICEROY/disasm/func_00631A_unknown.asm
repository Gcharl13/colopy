; ============================================================================
; func_00631A_unknown
; Region   : load_image
; Bytes    : file 0x00631A..0x006333  (25 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00631A  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00631E  53                    PUSH   bx ; STACK_PUSH
00631F  57                    PUSH   di ; STACK_PUSH
006320  56                    PUSH   si ; STACK_PUSH
006321  8B FA                 MOV    di, dx ; MOV
006323  8B F0                 MOV    si, ax ; MOV
006325  57                    PUSH   di ; STACK_PUSH
006326  56                    PUSH   si ; STACK_PUSH
006327  9A E0 02 7F 03        LCALL  0x37f, 0x2e0 ; LCALL
00632C  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00632F  8E C2                 MOV    es, dx ; MOV
006331  8B D8                 MOV    bx, ax ; MOV
