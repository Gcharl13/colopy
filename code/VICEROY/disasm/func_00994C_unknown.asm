; ============================================================================
; func_00994C_unknown
; Region   : load_image
; Bytes    : file 0x00994C..0x009974  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00994C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
009950  8D 46 FC              LEA    ax, [bp - 4] ; ADDR
009953  50                    PUSH   ax ; STACK_PUSH
009954  8D 4E FE              LEA    cx, [bp - 2] ; ADDR
009957  51                    PUSH   cx ; STACK_PUSH
009958  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00995B  0E                    PUSH   cs ; STACK_PUSH
00995C  E8 97 FF              CALL   0x98f6 ; CALL_NEAR
00995F  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
009962  0B C0                 OR     ax, ax ; LOGIC
009964  74 0C                 JE     0x9972 ; CJUMP
009966  6A FF                 PUSH   -1 ; STACK_PUSH
009968  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00996B  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00996E  0E                    PUSH   cs ; STACK_PUSH
00996F  E8 10 F0              CALL   0x8982 ; CALL_NEAR
009972  C9                    LEAVE ; EPILOGUE
009973  CB                    RETF ; RETURN
