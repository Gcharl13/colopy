; ============================================================================
; func_00341E_unknown
; Region   : load_image
; Bytes    : file 0x00341E..0x003435  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00341E  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
003422  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
003425  99                    CDQ ; ARITH
003426  8A F2                 MOV    dh, dl ; MOV
003428  8A D4                 MOV    dl, ah ; MOV
00342A  8A E0                 MOV    ah, al ; MOV
00342C  2A C0                 SUB    al, al ; ARITH
00342E  9A 9A 02 1F 18        LCALL  0x181f, 0x29a ; THUNK -> 0x0000:0x01A0 (thunk @file 0x01A88A type A) overlay @file 0x025AA0
003433  C9                    LEAVE ; EPILOGUE
003434  CB                    RETF ; RETURN
