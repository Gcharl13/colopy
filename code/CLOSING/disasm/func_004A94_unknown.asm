; ============================================================================
; func_004A94_unknown
; Region   : load_image
; Bytes    : file 0x004A94..0x004AB5  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004A94  55                    PUSH   bp ; STACK_PUSH
004A95  8B EC                 MOV    bp, sp ; MOV
004A97  57                    PUSH   di ; STACK_PUSH
004A98  56                    PUSH   si ; STACK_PUSH
004A99  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
004A9C  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
004A9F  2A E4                 SUB    ah, ah ; ARITH
004AA1  8B F8                 MOV    di, ax ; MOV
004AA3  56                    PUSH   si ; STACK_PUSH
004AA4  9A 36 14 7D 03        LCALL  0x37d, 0x1436 ; LCALL
004AA9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004AAC  80 A5 59 40 FD        AND    byte ptr [di + 0x4059], 0xfd ; LOGIC
004AB1  80 64 06 CF           AND    byte ptr [si + 6], 0xcf ; LOGIC
