; ============================================================================
; func_007966_unknown
; Region   : load_image
; Bytes    : file 0x007966..0x00798F  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007966  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00796A  56                    PUSH   si ; STACK_PUSH
00796B  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00796E  0B F6                 OR     si, si ; LOGIC
007970  7C 2A                 JL     0x799c ; CJUMP
007972  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
007975  8A 87 46 31           MOV    al, byte ptr [bx + 0x3146] ; MOV
007979  88 46 FE              MOV    byte ptr [bp - 2], al ; LOCAL_STORE
00797C  3C 0D                 CMP    al, 0xd ; CMP
00797E  72 10                 JB     0x7990 ; CJUMP
007980  3C 12                 CMP    al, 0x12 ; CMP
007982  77 0C                 JA     0x7990 ; CJUMP
007984  56                    PUSH   si ; STACK_PUSH
007985  0E                    PUSH   cs ; STACK_PUSH
007986  E8 A5 FD              CALL   0x772e ; CALL_NEAR
007989  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00798C  5E                    POP    si ; STACK_POP
00798D  C9                    LEAVE ; EPILOGUE
00798E  CB                    RETF ; RETURN
