; ============================================================================
; func_06E3AE_unknown
; Region   : overlay
; Bytes    : file 0x06E3AE..0x06E3D0  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06E3AE  55                    PUSH   bp ; STACK_PUSH
06E3AF  8B EC                 MOV    bp, sp ; MOV
06E3B1  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06E3B4  8B 56 0C              MOV    dx, word ptr [bp + 0xc] ; LOCAL_LOAD
06E3B7  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06E3BA  26 89 47 50           MOV    word ptr es:[bx + 0x50], ax ; MOV
06E3BE  26 89 57 52           MOV    word ptr es:[bx + 0x52], dx ; MOV
06E3C2  06                    PUSH   es ; STACK_PUSH
06E3C3  53                    PUSH   bx ; STACK_PUSH
06E3C4  2B C0                 SUB    ax, ax ; ARITH
06E3C6  BA 01 00              MOV    dx, 1 ; MOV
06E3C9  8B DA                 MOV    bx, dx ; MOV
06E3CB  E8 A0 FA              CALL   0x6de6e ; CALL_NEAR
06E3CE  C9                    LEAVE ; EPILOGUE
06E3CF  CB                    RETF ; RETURN
