; ============================================================================
; func_010812_unknown
; Region   : load_image
; Bytes    : file 0x010812..0x010834  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

010812  55                    PUSH   bp ; STACK_PUSH
010813  8B EC                 MOV    bp, sp ; MOV
010815  B8 FC 00              MOV    ax, 0xfc ; CONST_LOAD
010818  50                    PUSH   ax ; STACK_PUSH
010819  0E                    PUSH   cs ; STACK_PUSH
01081A  E8 7C 02              CALL   0x10a99 ; CALL_NEAR
01081D  83 3E F4 28 00        CMP    word ptr [0x28f4], 0 ; CMP
010822  74 04                 JE     0x10828 ; CJUMP
010824  FF 1E F2 28           LCALL  [0x28f2] ; LCALL
010828  B8 FF 00              MOV    ax, 0xff ; CONST_LOAD
01082B  50                    PUSH   ax ; STACK_PUSH
01082C  0E                    PUSH   cs ; STACK_PUSH
01082D  E8 69 02              CALL   0x10a99 ; CALL_NEAR
010830  8B E5                 MOV    sp, bp ; MOV
010832  5D                    POP    bp ; STACK_POP
010833  CB                    RETF ; RETURN
