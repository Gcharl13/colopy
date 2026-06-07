; ============================================================================
; func_024692_unknown
; Region   : overlay
; Bytes    : file 0x024692..0x0246C4  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024692  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
024696  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
02469B  0E                    PUSH   cs ; STACK_PUSH
02469C  E8 F7 04              CALL   0x24b96 ; CALL_NEAR
02469F  A3 3E 93              MOV    word ptr [0x933e], ax ; GLOBAL_LOAD
0246A2  83 3E EC 07 00        CMP    word ptr [0x7ec], 0 ; CMP
0246A7  74 03                 JE     0x246ac ; CJUMP
0246A9  A3 28 93              MOV    word ptr [0x9328], ax ; GLOBAL_LOAD
0246AC  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
0246B1  74 2A                 JE     0x246dd ; CJUMP
0246B3  A1 28 93              MOV    ax, word ptr [0x9328] ; GLOBAL_LOAD
0246B6  EB 1C                 JMP    0x246d4 ; JUMP
0246B8  0E                    PUSH   cs ; STACK_PUSH
0246B9  E8 11 05              CALL   0x24bcd ; CALL_NEAR
0246BC  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
0246BF  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
0246C2  C9                    LEAVE ; EPILOGUE
0246C3  CB                    RETF ; RETURN
