; ============================================================================
; func_00BCEA_unknown
; Region   : load_image
; Bytes    : file 0x00BCEA..0x00BD27  (61 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00BCEA  55                    PUSH   bp ; STACK_PUSH
00BCEB  8B EC                 MOV    bp, sp ; MOV
00BCED  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
00BCF1  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
00BCF5  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
00BCF9  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
00BCFD  6A 03                 PUSH   3 ; STACK_PUSH
00BCFF  8A 46 06              MOV    al, byte ptr [bp + 6] ; LOCAL_LOAD
00BD02  50                    PUSH   ax ; STACK_PUSH
00BD03  B8 3B 01              MOV    ax, 0x13b ; CONST_LOAD
00BD06  BA C5 00              MOV    dx, 0xc5 ; CONST_LOAD
00BD09  BB 05 00              MOV    bx, 5 ; MOV
00BD0C  9A 0A 00 9E 0B        LCALL  0xb9e, 0xa ; LCALL
00BD11  68 C5 00              PUSH   0xc5 ; PUSH_CONST
00BD14  6A 05                 PUSH   5 ; STACK_PUSH
00BD16  6A 03                 PUSH   3 ; STACK_PUSH
00BD18  B8 3B 01              MOV    ax, 0x13b ; CONST_LOAD
00BD1B  BA C5 00              MOV    dx, 0xc5 ; CONST_LOAD
00BD1E  8B D8                 MOV    bx, ax ; MOV
00BD20  9A 3A 00 70 0B        LCALL  0xb70, 0x3a ; LCALL
00BD25  C9                    LEAVE ; EPILOGUE
00BD26  CB                    RETF ; RETURN
