; ============================================================================
; func_009A58_unknown
; Region   : load_image
; Bytes    : file 0x009A58..0x009A6F  (23 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009A58  55                    PUSH   bp ; STACK_PUSH
009A59  8B EC                 MOV    bp, sp ; MOV
009A5B  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
009A5E  8B 56 08              MOV    dx, word ptr [bp + 8] ; LOCAL_LOAD
009A61  8B D8                 MOV    bx, ax ; MOV
009A63  C1 EB 04              SHR    bx, 4 ; LOGIC
009A66  03 D3                 ADD    dx, bx ; ARITH
009A68  25 0F 00              AND    ax, 0xf ; LOGIC
009A6B  C9                    LEAVE ; EPILOGUE
009A6C  CA 04 00              RETF   4 ; RETURN
