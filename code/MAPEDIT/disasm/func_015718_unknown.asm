; ============================================================================
; func_015718_unknown
; Region   : load_image
; Bytes    : file 0x015718..0x015739  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

015718  55                    PUSH   bp ; STACK_PUSH
015719  8B EC                 MOV    bp, sp ; MOV
01571B  57                    PUSH   di ; STACK_PUSH
01571C  56                    PUSH   si ; STACK_PUSH
01571D  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
015720  8A 44 07              MOV    al, byte ptr [si + 7] ; MOV
015723  2A E4                 SUB    ah, ah ; ARITH
015725  8B F8                 MOV    di, ax ; MOV
015727  56                    PUSH   si ; STACK_PUSH
015728  9A CE 15 88 13        LCALL  0x1388, 0x15ce ; LCALL
01572D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
015730  80 A5 77 45 FD        AND    byte ptr [di + 0x4577], 0xfd ; LOGIC
015735  80 64 06 CF           AND    byte ptr [si + 6], 0xcf ; LOGIC
