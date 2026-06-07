; ============================================================================
; func_041410_unknown
; Region   : overlay
; Bytes    : file 0x041410..0x041443  (51 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041410  C8 22 00 00           ENTER  0x22, 0 ; PROLOGUE
041414  56                    PUSH   si ; STACK_PUSH
041415  C7 46 F6 01 00        MOV    word ptr [bp - 0xa], 1 ; LOCAL_STORE
04141A  C7 46 EC FF FF        MOV    word ptr [bp - 0x14], 0xffff ; LOCAL_STORE
04141F  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041423  8A 87 50 31           MOV    al, byte ptr [bx + 0x3150] ; MOV
041427  2A E4                 SUB    ah, ah ; ARITH
041429  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
04142C  3D 01 00              CMP    ax, 1 ; CMP
04142F  7D 13                 JGE    0x41444 ; CJUMP
041431  6A 03                 PUSH   3 ; STACK_PUSH
041433  6A 16                 PUSH   0x16 ; PUSH_CONST
041435  9A E0 0D 1F 18        LCALL  0x181f, 0xde0 ; THUNK -> 0x0984:0x046E (thunk @file 0x01B3D0 type B) overlay @file 0x032384
04143A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04143D  8B 46 F6              MOV    ax, word ptr [bp - 0xa] ; LOCAL_LOAD
041440  5E                    POP    si ; STACK_POP
041441  C9                    LEAVE ; EPILOGUE
041442  CB                    RETF ; RETURN
