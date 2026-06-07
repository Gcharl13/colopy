; ============================================================================
; func_06C832_unknown
; Region   : overlay
; Bytes    : file 0x06C832..0x06C84F  (29 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C832  55                    PUSH   bp ; STACK_PUSH
06C833  8B EC                 MOV    bp, sp ; MOV
06C835  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
06C838  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
06C83B  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
06C83E  0E                    PUSH   cs ; STACK_PUSH
06C83F  E8 DF 2F              CALL   0x6f821 ; CALL_NEAR
06C842  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06C845  26 89 47 4C           MOV    word ptr es:[bx + 0x4c], ax ; MOV
06C849  26 89 57 4E           MOV    word ptr es:[bx + 0x4e], dx ; MOV
06C84D  C9                    LEAVE ; EPILOGUE
06C84E  CB                    RETF ; RETURN
