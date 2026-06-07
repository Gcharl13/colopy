; ============================================================================
; func_066BB0_unknown
; Region   : overlay
; Bytes    : file 0x066BB0..0x066BC7  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066BB0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
066BB4  57                    PUSH   di ; STACK_PUSH
066BB5  56                    PUSH   si ; STACK_PUSH
066BB6  8B 7E 06              MOV    di, word ptr [bp + 6] ; LOCAL_LOAD
066BB9  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
066BBC  0E                    PUSH   cs ; STACK_PUSH
066BBD  E8 32 02              CALL   0x66df2 ; CALL_NEAR
066BC0  8B C6                 MOV    ax, si ; MOV
066BC2  3B 36 CA 9C           CMP    si, word ptr [0x9cca] ; CMP
066BC6  7D                    DB     0x7D ; DATA_BYTE
