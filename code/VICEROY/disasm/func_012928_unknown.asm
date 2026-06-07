; ============================================================================
; func_012928_unknown
; Region   : load_image
; Bytes    : file 0x012928..0x012959  (49 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012928  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
01292C  06                    PUSH   es ; STACK_PUSH
01292D  1E                    PUSH   ds ; STACK_PUSH
01292E  56                    PUSH   si ; STACK_PUSH
01292F  57                    PUSH   di ; STACK_PUSH
012930  C6 06 A2 26 FF        MOV    byte ptr [0x26a2], 0xff ; GLOBAL_LOAD
012935  8B 56 06              MOV    dx, word ptr [bp + 6] ; LOCAL_LOAD
012938  0B D2                 OR     dx, dx ; LOGIC
01293A  74 17                 JE     0x12953 ; CJUMP
01293C  BE 32 00              MOV    si, 0x32 ; CONST_LOAD
01293F  BF 54 A6              MOV    di, 0xa654 ; CONST_LOAD
012942  B8 5A 1B              MOV    ax, 0x1b5a ; CONST_LOAD
012945  8E C0                 MOV    es, ax ; MOV
012947  B9 05 00              MOV    cx, 5 ; MOV
01294A  8E DA                 MOV    ds, dx ; MOV
01294C  A1 28 00              MOV    ax, word ptr [0x28] ; GLOBAL_LOAD
01294F  A5                    MOVSW  word ptr es:[di], word ptr [si] ; STR
012950  AB                    STOSW  word ptr es:[di], ax ; STR
012951  E2 FC                 LOOP   0x1294f ; CJUMP
012953  5F                    POP    di ; STACK_POP
012954  5E                    POP    si ; STACK_POP
012955  1F                    POP    ds ; STACK_POP
012956  07                    POP    es ; STACK_POP
012957  C9                    LEAVE ; EPILOGUE
012958  CB                    RETF ; RETURN
