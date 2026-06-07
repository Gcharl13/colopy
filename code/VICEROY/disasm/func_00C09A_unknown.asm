; ============================================================================
; func_00C09A_unknown
; Region   : load_image
; Bytes    : file 0x00C09A..0x00C0AD  (19 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C09A  55                    PUSH   bp ; STACK_PUSH
00C09B  8B EC                 MOV    bp, sp ; MOV
00C09D  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00C0A0  D1 E3                 SHL    bx, 1 ; LOGIC
00C0A2  FF B7 BA 2D           PUSH   word ptr [bx + 0x2dba] ; PUSH_GLOBAL
00C0A6  9A A2 01 09 00        LCALL  9, 0x1a2 ; LCALL
00C0AB  C9                    LEAVE ; EPILOGUE
00C0AC  CB                    RETF ; RETURN
