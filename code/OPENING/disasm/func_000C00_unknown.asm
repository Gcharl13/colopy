; ============================================================================
; func_000C00_unknown
; Region   : load_image
; Bytes    : file 0x000C00..0x000C20  (32 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

000C00  55                    PUSH   bp ; STACK_PUSH
000C01  8B EC                 MOV    bp, sp ; MOV
000C03  57                    PUSH   di ; STACK_PUSH
000C04  56                    PUSH   si ; STACK_PUSH
000C05  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
000C08  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
000C0B  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
000C0E  B9 00 03              MOV    cx, 0x300 ; CONST_LOAD
000C11  3E 8A 04              MOV    al, byte ptr ds:[si] ; MOV
000C14  3E 8A 27              MOV    ah, byte ptr ds:[bx] ; MOV
000C17  26 8A 15              MOV    dl, byte ptr es:[di] ; MOV
000C1A  02 C4                 ADD    al, ah ; ARITH
000C1C  3A C2                 CMP    al, dl ; CMP
000C1E  76 02                 JBE    0xc22 ; CJUMP
