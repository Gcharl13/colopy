; ============================================================================
; func_006FC4_unknown
; Region   : load_image
; Bytes    : file 0x006FC4..0x006FD8  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006FC4  55                    PUSH   bp ; STACK_PUSH
006FC5  8B EC                 MOV    bp, sp ; MOV
006FC7  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
006FCA  0B DB                 OR     bx, bx ; LOGIC
006FCC  7C 08                 JL     0x6fd6 ; CJUMP
006FCE  6B DB 1C              IMUL   bx, bx, 0x1c ; ARITH
006FD1  80 A7 47 31 0F        AND    byte ptr [bx + 0x3147], 0xf ; LOGIC
006FD6  C9                    LEAVE ; EPILOGUE
006FD7  CB                    RETF ; RETURN
