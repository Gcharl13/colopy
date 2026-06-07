; ============================================================================
; func_00C322_unknown
; Region   : load_image
; Bytes    : file 0x00C322..0x00C361  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C322  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00C326  9A 04 0E 1D 0D        LCALL  0xd1d, 0xe04 ; LCALL
00C32B  8B C8                 MOV    cx, ax ; MOV
00C32D  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
00C330  2B 46 06              SUB    ax, word ptr [bp + 6] ; ARITH
00C333  40                    INC    ax ; ARITH
00C334  F7 E9                 IMUL   cx ; ARITH
00C336  8A C4                 MOV    al, ah ; MOV
00C338  8A E2                 MOV    ah, dl ; MOV
00C33A  8A D6                 MOV    dl, dh ; MOV
00C33C  D0 E6                 SHL    dh, 1 ; LOGIC
00C33E  1A F6                 SBB    dh, dh ; ARITH
00C340  D1 FA                 SAR    dx, 1 ; LOGIC
00C342  D1 D8                 RCR    ax, 1 ; LOGIC
00C344  D1 FA                 SAR    dx, 1 ; LOGIC
00C346  D1 D8                 RCR    ax, 1 ; LOGIC
00C348  D1 FA                 SAR    dx, 1 ; LOGIC
00C34A  D1 D8                 RCR    ax, 1 ; LOGIC
00C34C  D1 FA                 SAR    dx, 1 ; LOGIC
00C34E  D1 D8                 RCR    ax, 1 ; LOGIC
00C350  D1 FA                 SAR    dx, 1 ; LOGIC
00C352  D1 D8                 RCR    ax, 1 ; LOGIC
00C354  D1 FA                 SAR    dx, 1 ; LOGIC
00C356  D1 D8                 RCR    ax, 1 ; LOGIC
00C358  D1 FA                 SAR    dx, 1 ; LOGIC
00C35A  D1 D8                 RCR    ax, 1 ; LOGIC
00C35C  03 46 06              ADD    ax, word ptr [bp + 6] ; ARITH
00C35F  C9                    LEAVE ; EPILOGUE
00C360  CB                    RETF ; RETURN
