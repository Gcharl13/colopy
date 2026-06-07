; ============================================================================
; func_030B38_unknown
; Region   : overlay
; Bytes    : file 0x030B38..0x030B4C  (20 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

030B38  55                    PUSH   bp ; STACK_PUSH
030B39  8B EC                 MOV    bp, sp ; MOV
030B3B  B8 01 00              MOV    ax, 1 ; MOV
030B3E  8A 4E 06              MOV    cl, byte ptr [bp + 6] ; LOCAL_LOAD
030B41  D3 E0                 SHL    ax, cl ; LOGIC
030B43  8B 1E FC 84           MOV    bx, word ptr [0x84fc] ; GLOBAL_LOAD
030B47  23 47 20              AND    ax, word ptr [bx + 0x20] ; LOGIC
030B4A  C9                    LEAVE ; EPILOGUE
030B4B  CB                    RETF ; RETURN
