; ============================================================================
; func_0081AA_unknown
; Region   : load_image
; Bytes    : file 0x0081AA..0x0081C2  (24 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0081AA  55                    PUSH   bp ; STACK_PUSH
0081AB  8B EC                 MOV    bp, sp ; MOV
0081AD  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
0081B0  A3 60 05              MOV    word ptr [0x560], ax ; GLOBAL_LOAD
0081B3  8D 1E 84 00           LEA    bx, [0x84] ; ADDR
0081B7  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0081BA  2B D2                 SUB    dx, dx ; ARITH
0081BC  0E                    PUSH   cs ; STACK_PUSH
0081BD  E8 E8 FE              CALL   0x80a8 ; CALL_NEAR
0081C0  C9                    LEAVE ; EPILOGUE
0081C1  CB                    RETF ; RETURN
