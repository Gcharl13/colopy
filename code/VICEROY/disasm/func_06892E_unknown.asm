; ============================================================================
; func_06892E_unknown
; Region   : overlay
; Bytes    : file 0x06892E..0x06896A  (60 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06892E  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
068932  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
068937  EB 20                 JMP    0x68959 ; JUMP
068939  90                    NOP ; NOP
06893A  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
06893D  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
068940  39 06 3A 85           CMP    word ptr [0x853a], ax ; CMP
068944  7E 10                 JLE    0x68956 ; CJUMP
068946  6A FF                 PUSH   -1 ; STACK_PUSH
068948  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
06894B  50                    PUSH   ax ; STACK_PUSH
06894C  9A 04 07 1F 18        LCALL  0x181f, 0x704 ; THUNK -> 0x037F:0x0228 (thunk @file 0x01ACF4 type B) overlay @file 0x02ED64
068951  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
068954  EB E4                 JMP    0x6893a ; JUMP
068956  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
068959  A1 3C 85              MOV    ax, word ptr [0x853c] ; GLOBAL_LOAD
06895C  39 46 FC              CMP    word ptr [bp - 4], ax ; CMP
06895F  7D 07                 JGE    0x68968 ; CJUMP
068961  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
068966  EB D5                 JMP    0x6893d ; JUMP
068968  C9                    LEAVE ; EPILOGUE
068969  CB                    RETF ; RETURN
