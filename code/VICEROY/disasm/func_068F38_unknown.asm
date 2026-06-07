; ============================================================================
; func_068F38_unknown
; Region   : overlay
; Bytes    : file 0x068F38..0x068F55  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

068F38  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
068F3C  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
068F41  B8 B0 01              MOV    ax, 0x1b0 ; CONST_LOAD
068F44  99                    CDQ ; ARITH
068F45  9A 9A 02 1F 18        LCALL  0x181f, 0x29a ; THUNK -> 0x0000:0x01A0 (thunk @file 0x01A88A type A) overlay @file 0x025AA0
068F4A  A3 A6 1E              MOV    word ptr [0x1ea6], ax ; GLOBAL_LOAD
068F4D  89 16 A8 1E           MOV    word ptr [0x1ea8], dx ; GLOBAL_LOAD
068F51  8B C2                 MOV    ax, dx ; MOV
068F53  0B                    DB     0x0B ; DATA_BYTE
068F54  06                    DB     0x06 ; DATA_BYTE
