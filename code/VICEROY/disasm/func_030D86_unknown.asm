; ============================================================================
; func_030D86_unknown
; Region   : overlay
; Bytes    : file 0x030D86..0x030DBC  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030D86  55                    PUSH   bp ; STACK_PUSH
030D87  8B EC                 MOV    bp, sp ; MOV
030D89  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
030D8D  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
030D91  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
030D95  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
030D99  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
030D9D  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
030DA1  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
030DA5  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
030DA9  FF 76 0C              PUSH   word ptr [bp + 0xc] ; PUSH_GLOBAL
030DAC  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
030DAF  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
030DB2  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
030DB5  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
030DBA  C9                    LEAVE ; EPILOGUE
030DBB  CB                    RETF ; RETURN
