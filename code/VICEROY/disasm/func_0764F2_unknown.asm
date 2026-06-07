; ============================================================================
; func_0764F2_unknown
; Region   : overlay
; Bytes    : file 0x0764F2..0x076511  (31 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0764F2  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
0764F6  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
0764FB  B8 80 38              MOV    ax, 0x3880 ; CONST_LOAD
0764FE  BA 01 00              MOV    dx, 1 ; MOV
076501  9A 9A 02 1F 18        LCALL  0x181f, 0x29a ; THUNK -> 0x0000:0x01A0 (thunk @file 0x01A88A type A) overlay @file 0x025AA0
076506  A3 C6 23              MOV    word ptr [0x23c6], ax ; GLOBAL_LOAD
076509  89 16 C8 23           MOV    word ptr [0x23c8], dx ; GLOBAL_LOAD
07650D  8B C2                 MOV    ax, dx ; MOV
07650F  0B                    DB     0x0B ; DATA_BYTE
076510  06                    DB     0x06 ; DATA_BYTE
