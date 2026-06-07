; ============================================================================
; func_0287B2_unknown
; Region   : overlay
; Bytes    : file 0x0287B2..0x0287C5  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0287B2  55                    PUSH   bp ; STACK_PUSH
0287B3  8B EC                 MOV    bp, sp ; MOV
0287B5  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
0287B8  D1 E3                 SHL    bx, 1 ; LOGIC
0287BA  FF B7 B2 93           PUSH   word ptr [bx - 0x6c4e] ; PUSH_GLOBAL
0287BE  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
0287C3  C9                    LEAVE ; EPILOGUE
0287C4  CB                    RETF ; RETURN
