; ============================================================================
; func_0603A8_unknown
; Region   : overlay
; Bytes    : file 0x0603A8..0x0603C6  (30 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0603A8  55                    PUSH   bp ; STACK_PUSH
0603A9  8B EC                 MOV    bp, sp ; MOV
0603AB  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
0603AF  74 15                 JE     0x603c6 ; CJUMP
0603B1  C4 1E 18 9E           LES    bx, ptr [0x9e18] ; MOV_FAR
0603B5  26 80 67 02 0F        AND    byte ptr es:[bx + 2], 0xf ; LOGIC
0603BA  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
0603BD  C0 E0 04              SHL    al, 4 ; LOGIC
0603C0  26 08 47 02           OR     byte ptr es:[bx + 2], al ; LOGIC
0603C4  C9                    LEAVE ; EPILOGUE
0603C5  CB                    RETF ; RETURN
