; ============================================================================
; func_04C5C0_unknown
; Region   : overlay
; Bytes    : file 0x04C5C0..0x04C5E8  (40 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C5C0  C8 10 00 00           ENTER  0x10, 0 ; PROLOGUE
04C5C4  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C5C7  8A 87 10 94           MOV    al, byte ptr [bx - 0x6bf0] ; MOV
04C5CB  2A E4                 SUB    ah, ah ; ARITH
04C5CD  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
04C5D0  8A 87 98 92           MOV    al, byte ptr [bx - 0x6d68] ; MOV
04C5D4  83 3E 9E 53 30        CMP    word ptr [0x539e], 0x30 ; CMP
04C5D9  7C 03                 JL     0x4c5de ; CJUMP
04C5DB  E9 A0 00              JMP    0x4c67e ; JUMP
04C5DE  3D 01 00              CMP    ax, 1 ; CMP
04C5E1  7D 05                 JGE    0x4c5e8 ; CJUMP
04C5E3  B8 08 00              MOV    ax, 8 ; MOV
04C5E6  C9                    LEAVE ; EPILOGUE
04C5E7  CB                    RETF ; RETURN
