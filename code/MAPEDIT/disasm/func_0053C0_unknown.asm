; ============================================================================
; func_0053C0_unknown
; Region   : load_image
; Bytes    : file 0x0053C0..0x0053DD  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0053C0  55                    PUSH   bp ; STACK_PUSH
0053C1  8B EC                 MOV    bp, sp ; MOV
0053C3  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
0053C6  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0053C9  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
0053CC  0E                    PUSH   cs ; STACK_PUSH
0053CD  E8 A8 FE              CALL   0x5278 ; CALL_NEAR
0053D0  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
0053D3  26 89 47 4C           MOV    word ptr es:[bx + 0x4c], ax ; MOV
0053D7  26 89 57 4E           MOV    word ptr es:[bx + 0x4e], dx ; MOV
0053DB  C9                    LEAVE ; EPILOGUE
0053DC  CB                    RETF ; RETURN
