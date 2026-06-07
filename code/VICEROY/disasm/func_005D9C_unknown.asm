; ============================================================================
; func_005D9C_unknown
; Region   : load_image
; Bytes    : file 0x005D9C..0x005DB9  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

005D9C  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
005DA0  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
005DA3  F7 2E 3A 85           IMUL   word ptr [0x853a] ; ARITH
005DA7  8B D8                 MOV    bx, ax ; MOV
005DA9  03 1E 64 01           ADD    bx, word ptr [0x164] ; ARITH
005DAD  8E 06 66 01           MOV    es, word ptr [0x166] ; GLOBAL_LOAD
005DB1  03 5E 06              ADD    bx, word ptr [bp + 6] ; ARITH
005DB4  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
005DB7  C9                    LEAVE ; EPILOGUE
005DB8  CB                    RETF ; RETURN
