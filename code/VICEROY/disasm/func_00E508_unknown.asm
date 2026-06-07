; ============================================================================
; func_00E508_unknown
; Region   : load_image
; Bytes    : file 0x00E508..0x00E51C  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00E508  55                    PUSH   bp ; STACK_PUSH
00E509  8B EC                 MOV    bp, sp ; MOV
00E50B  FA                    CLI ; FLAG
00E50C  B0 36                 MOV    al, 0x36 ; CONST_LOAD
00E50E  E6 43                 OUT    0x43, al ; IO
00E510  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00E513  E6 40                 OUT    0x40, al ; IO
00E515  8A C4                 MOV    al, ah ; MOV
00E517  E6 40                 OUT    0x40, al ; IO
00E519  FB                    STI ; FLAG
00E51A  C9                    LEAVE ; EPILOGUE
00E51B  CB                    RETF ; RETURN
