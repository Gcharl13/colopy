; ============================================================================
; func_001CD2_unknown
; Region   : load_image
; Bytes    : file 0x001CD2..0x001CF9  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

001CD2  55                    PUSH   bp ; STACK_PUSH
001CD3  8B EC                 MOV    bp, sp ; MOV
001CD5  57                    PUSH   di ; STACK_PUSH
001CD6  56                    PUSH   si ; STACK_PUSH
001CD7  1E                    PUSH   ds ; STACK_PUSH
001CD8  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
001CDB  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
001CDE  B9 00 03              MOV    cx, 0x300 ; CONST_LOAD
001CE1  AC                    LODSB  al, byte ptr [si] ; STR
001CE2  51                    PUSH   cx ; STACK_PUSH
001CE3  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
001CE6  D2 E8                 SHR    al, cl ; LOGIC
001CE8  59                    POP    cx ; STACK_POP
001CE9  14 00                 ADC    al, 0 ; ARITH
001CEB  0A C0                 OR     al, al ; LOGIC
001CED  75 02                 JNE    0x1cf1 ; CJUMP
001CEF  FE C0                 INC    al ; ARITH
001CF1  AA                    STOSB  byte ptr es:[di], al ; STR
001CF2  E2 ED                 LOOP   0x1ce1 ; CJUMP
001CF4  1F                    POP    ds ; STACK_POP
001CF5  5E                    POP    si ; STACK_POP
001CF6  5F                    POP    di ; STACK_POP
001CF7  C9                    LEAVE ; EPILOGUE
001CF8  CB                    RETF ; RETURN
