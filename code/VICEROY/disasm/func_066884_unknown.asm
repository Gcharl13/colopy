; ============================================================================
; func_066884_unknown
; Region   : overlay
; Bytes    : file 0x066884..0x0668B8  (52 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

066884  C8 08 01 00           ENTER  0x108, 0 ; PROLOGUE
066888  B8 10 00              MOV    ax, 0x10 ; CONST_LOAD
06688B  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06688E  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
066891  8D 86 F8 FE           LEA    ax, [bp - 0x108] ; ADDR
066895  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
066898  8C 56 FE              MOV    word ptr [bp - 2], ss ; LOCAL_STORE
06689B  6A 00                 PUSH   0 ; STACK_PUSH
06689D  6A 00                 PUSH   0 ; STACK_PUSH
06689F  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
0668A2  50                    PUSH   ax ; STACK_PUSH
0668A3  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0668A6  FF 36 6E 01           PUSH   word ptr [0x16e] ; PUSH_GLOBAL
0668AA  FF 36 6C 01           PUSH   word ptr [0x16c] ; PUSH_GLOBAL
0668AE  9A 5E 02 1F 18        LCALL  0x181f, 0x25e ; THUNK -> 0x0101:0x0050 (thunk @file 0x01A84E type B) overlay @file 0x06044C
0668B3  8A 46 80              MOV    al, byte ptr [bp - 0x80] ; LOCAL_LOAD
0668B6  C9                    LEAVE ; EPILOGUE
0668B7  CB                    RETF ; RETURN
