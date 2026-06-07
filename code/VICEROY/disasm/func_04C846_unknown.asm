; ============================================================================
; func_04C846_unknown
; Region   : overlay
; Bytes    : file 0x04C846..0x04C85C  (22 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C846  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C84A  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
04C84F  EB 41                 JMP    0x4c892 ; JUMP
04C851  90                    NOP ; NOP
04C852  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
04C856  8A 9F 46 31           MOV    bl, byte ptr [bx + 0x3146] ; MOV
04C85A  8B C3                 MOV    ax, bx ; MOV
