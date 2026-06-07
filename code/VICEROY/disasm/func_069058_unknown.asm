; ============================================================================
; func_069058_unknown
; Region   : overlay
; Bytes    : file 0x069058..0x06907F  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

069058  C8 1C 00 00           ENTER  0x1c, 0 ; PROLOGUE
06905C  57                    PUSH   di ; STACK_PUSH
06905D  56                    PUSH   si ; STACK_PUSH
06905E  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
069063  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
069068  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
06906B  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
06906E  E9 CE 00              JMP    0x6913f ; JUMP
069071  90                    NOP ; NOP
069072  A1 AA A5              MOV    ax, word ptr [0xa5aa] ; GLOBAL_LOAD
069075  48                    DEC    ax ; ARITH
069076  3B 46 F4              CMP    ax, word ptr [bp - 0xc] ; CMP
069079  7F 03                 JG     0x6907e ; CJUMP
06907B  E9 CA 00              JMP    0x69148 ; JUMP
06907E  8B                    DB     0x8B ; DATA_BYTE
