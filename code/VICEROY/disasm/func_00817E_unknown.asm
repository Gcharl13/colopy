; ============================================================================
; func_00817E_unknown
; Region   : load_image
; Bytes    : file 0x00817E..0x00818C  (14 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00817E  55                    PUSH   bp ; STACK_PUSH
00817F  8B EC                 MOV    bp, sp ; MOV
008181  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
008185  7C 11                 JL     0x8198 ; CJUMP
008187  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00818A  8B C3                 MOV    ax, bx ; MOV
