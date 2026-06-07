; ============================================================================
; func_006F3C_unknown
; Region   : load_image
; Bytes    : file 0x006F3C..0x006F5E  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

006F3C  55                    PUSH   bp ; STACK_PUSH
006F3D  8B EC                 MOV    bp, sp ; MOV
006F3F  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
006F42  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
006F45  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
006F48  26 89 47 50           MOV    word ptr es:[bx + 0x50], ax ; MOV
006F4C  26 89 57 52           MOV    word ptr es:[bx + 0x52], dx ; MOV
006F50  06                    PUSH   es ; STACK_PUSH
006F51  53                    PUSH   bx ; STACK_PUSH
006F52  2B C0                 SUB    ax, ax ; ARITH
006F54  BA 01 00              MOV    dx, 1 ; MOV
006F57  8B DA                 MOV    bx, dx ; MOV
006F59  E8 A0 FA              CALL   0x69fc ; CALL_NEAR
006F5C  C9                    LEAVE ; EPILOGUE
006F5D  CB                    RETF ; RETURN
