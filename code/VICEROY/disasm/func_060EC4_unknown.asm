; ============================================================================
; func_060EC4_unknown
; Region   : overlay
; Bytes    : file 0x060EC4..0x060F0E  (74 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060EC4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
060EC8  A1 EA 07              MOV    ax, word ptr [0x7ea] ; GLOBAL_LOAD
060ECB  2D 3D 00              SUB    ax, 0x3d ; ARITH
060ECE  B9 14 00              MOV    cx, 0x14 ; CONST_LOAD
060ED1  99                    CDQ ; ARITH
060ED2  F7 F9                 IDIV   cx ; ARITH
060ED4  3D 03 00              CMP    ax, 3 ; CMP
060ED7  7E 03                 JLE    0x60edc ; CJUMP
060ED9  B8 03 00              MOV    ax, 3 ; MOV
060EDC  50                    PUSH   ax ; STACK_PUSH
060EDD  0E                    PUSH   cs ; STACK_PUSH
060EDE  E8 28 05              CALL   0x61409 ; CALL_NEAR
060EE1  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060EE4  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
060EE9  83 3E E8 07 73        CMP    word ptr [0x7e8], 0x73 ; CMP
060EEE  7C 05                 JL     0x60ef5 ; CJUMP
060EF0  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
060EF5  81 3E E8 07 C6 00     CMP    word ptr [0x7e8], 0xc6 ; CMP
060EFB  7C 05                 JL     0x60f02 ; CJUMP
060EFD  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2 ; LOCAL_STORE
060F02  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
060F05  EB 1F                 JMP    0x60f26 ; JUMP
060F07  90                    NOP ; NOP
060F08  0E                    PUSH   cs ; STACK_PUSH
060F09  E8 3E 05              CALL   0x6144a ; CALL_NEAR
060F0C  C9                    LEAVE ; EPILOGUE
060F0D  CB                    RETF ; RETURN
