; ============================================================================
; func_015DFA_unknown
; Region   : load_image
; Bytes    : file 0x015DFA..0x015E1C  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015DFA  55                    PUSH   bp ; STACK_PUSH
015DFB  8B EC                 MOV    bp, sp ; MOV
015DFD  B8 FC 00              MOV    ax, 0xfc ; CONST_LOAD
015E00  50                    PUSH   ax ; STACK_PUSH
015E01  0E                    PUSH   cs ; STACK_PUSH
015E02  E8 7C 02              CALL   0x16081 ; CALL_NEAR
015E05  83 3E AC 46 00        CMP    word ptr [0x46ac], 0 ; CMP
015E0A  74 04                 JE     0x15e10 ; CJUMP
015E0C  FF 1E AA 46           LCALL  [0x46aa] ; LCALL
015E10  B8 FF 00              MOV    ax, 0xff ; CONST_LOAD
015E13  50                    PUSH   ax ; STACK_PUSH
015E14  0E                    PUSH   cs ; STACK_PUSH
015E15  E8 69 02              CALL   0x16081 ; CALL_NEAR
015E18  8B E5                 MOV    sp, bp ; MOV
015E1A  5D                    POP    bp ; STACK_POP
015E1B  CB                    RETF ; RETURN
