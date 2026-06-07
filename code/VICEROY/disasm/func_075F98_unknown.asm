; ============================================================================
; func_075F98_unknown
; Region   : overlay
; Bytes    : file 0x075F98..0x075FB6  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

075F98  C8 00 03 00           ENTER  0x300, 0 ; PROLOGUE
075F9C  8D 86 00 FD           LEA    ax, [bp - 0x300] ; ADDR
075FA0  16                    PUSH   ss ; STACK_PUSH
075FA1  50                    PUSH   ax ; STACK_PUSH
075FA2  9A 78 0A 1F 1A        LCALL  0x1a1f, 0xa78 ; THUNK -> 0x0000:0x0008 (thunk @file 0x01D068 type A) overlay @file 0x025908
075FA7  8D 86 00 FD           LEA    ax, [bp - 0x300] ; ADDR
075FAB  16                    PUSH   ss ; STACK_PUSH
075FAC  50                    PUSH   ax ; STACK_PUSH
075FAD  2B C0                 SUB    ax, ax ; ARITH
075FAF  9A 6A 0A 1F 1A        LCALL  0x1a1f, 0xa6a ; THUNK -> 0x0000:0x002A (thunk @file 0x01D05A type A) overlay @file 0x02592A
075FB4  C9                    LEAVE ; EPILOGUE
075FB5  CB                    RETF ; RETURN
