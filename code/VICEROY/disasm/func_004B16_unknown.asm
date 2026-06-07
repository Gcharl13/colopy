; ============================================================================
; func_004B16_unknown
; Region   : load_image
; Bytes    : file 0x004B16..0x004B44  (46 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004B16  55                    PUSH   bp ; STACK_PUSH
004B17  8B EC                 MOV    bp, sp ; MOV
004B19  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
004B1C  8B 16 E8 07           MOV    dx, word ptr [0x7e8] ; GLOBAL_LOAD
004B20  3B DA                 CMP    bx, dx ; CMP
004B22  7F 20                 JG     0x4b44 ; CJUMP
004B24  03 5E 0A              ADD    bx, word ptr [bp + 0xa] ; ARITH
004B27  4B                    DEC    bx ; ARITH
004B28  3B DA                 CMP    bx, dx ; CMP
004B2A  7C 18                 JL     0x4b44 ; CJUMP
004B2C  8B 16 EA 07           MOV    dx, word ptr [0x7ea] ; GLOBAL_LOAD
004B30  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
004B33  3B DA                 CMP    bx, dx ; CMP
004B35  7F 0D                 JG     0x4b44 ; CJUMP
004B37  03 5E 0C              ADD    bx, word ptr [bp + 0xc] ; ARITH
004B3A  4B                    DEC    bx ; ARITH
004B3B  3B DA                 CMP    bx, dx ; CMP
004B3D  7C 05                 JL     0x4b44 ; CJUMP
004B3F  B8 01 00              MOV    ax, 1 ; MOV
004B42  C9                    LEAVE ; EPILOGUE
004B43  CB                    RETF ; RETURN
