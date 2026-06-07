; ============================================================================
; func_00D1CA_unknown
; Region   : load_image
; Bytes    : file 0x00D1CA..0x00D1E4  (26 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D1CA  55                    PUSH   bp ; STACK_PUSH
00D1CB  8B EC                 MOV    bp, sp ; MOV
00D1CD  0B D2                 OR     dx, dx ; LOGIC
00D1CF  74 11                 JE     0xd1e2 ; CJUMP
00D1D1  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
00D1D6  3B 06 FC 07           CMP    ax, word ptr [0x7fc] ; CMP
00D1DA  75 06                 JNE    0xd1e2 ; CJUMP
00D1DC  3B 16 FE 07           CMP    dx, word ptr [0x7fe] ; CMP
00D1E0  74 EF                 JE     0xd1d1 ; CJUMP
00D1E2  C9                    LEAVE ; EPILOGUE
00D1E3  CB                    RETF ; RETURN
