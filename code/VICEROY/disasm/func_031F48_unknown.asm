; ============================================================================
; func_031F48_unknown
; Region   : overlay
; Bytes    : file 0x031F48..0x031F5B  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031F48  55                    PUSH   bp ; STACK_PUSH
031F49  8B EC                 MOV    bp, sp ; MOV
031F4B  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
031F4E  D1 E3                 SHL    bx, 1 ; LOGIC
031F50  FF B7 B2 93           PUSH   word ptr [bx - 0x6c4e] ; PUSH_GLOBAL
031F54  9A 74 00 1F 18        LCALL  0x181f, 0x74 ; THUNK -> 0x0009:0x01A2 (thunk @file 0x01A664 type B) overlay @file 0x02296C
031F59  C9                    LEAVE ; EPILOGUE
031F5A  CB                    RETF ; RETURN
