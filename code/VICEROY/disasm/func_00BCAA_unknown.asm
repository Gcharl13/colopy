; ============================================================================
; func_00BCAA_unknown
; Region   : load_image
; Bytes    : file 0x00BCAA..0x00BCEA  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BCAA  55                    PUSH   bp ; STACK_PUSH
00BCAB  8B EC                 MOV    bp, sp ; MOV
00BCAD  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
00BCB1  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
00BCB5  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
00BCB9  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
00BCBD  6A 03                 PUSH   3 ; STACK_PUSH
00BCBF  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
00BCC2  50                    PUSH   ax ; STACK_PUSH
00BCC3  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
00BCC6  05 3B 01              ADD    ax, 0x13b ; ARITH
00BCC9  BA C5 00              MOV    dx, 0xc5 ; CONST_LOAD
00BCCC  BB 01 00              MOV    bx, 1 ; MOV
00BCCF  9A 0A 00 9E 0B        LCALL  0xb9e, 0xa ; LCALL
00BCD4  68 C5 00              PUSH   0xc5 ; PUSH_CONST
00BCD7  6A 05                 PUSH   5 ; STACK_PUSH
00BCD9  6A 03                 PUSH   3 ; STACK_PUSH
00BCDB  B8 3B 01              MOV    ax, 0x13b ; CONST_LOAD
00BCDE  BA C5 00              MOV    dx, 0xc5 ; CONST_LOAD
00BCE1  8B D8                 MOV    bx, ax ; MOV
00BCE3  9A 3A 00 70 0B        LCALL  0xb70, 0x3a ; LCALL
00BCE8  C9                    LEAVE ; EPILOGUE
00BCE9  CB                    RETF ; RETURN
