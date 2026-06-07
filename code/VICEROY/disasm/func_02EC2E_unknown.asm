; ============================================================================
; func_02EC2E_unknown
; Region   : overlay
; Bytes    : file 0x02EC2E..0x02EC3D  (15 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02EC2E  C8 00 00 00           ENTER  0, 0 ; PROLOGUE
02EC32  2B C0                 SUB    ax, ax ; ARITH
02EC34  89 87 C4 00           MOV    word ptr [bx + 0xc4], ax ; MOV
02EC38  89 87 C2 00           MOV    word ptr [bx + 0xc2], ax ; MOV
02EC3C  6A                    DB     0x6A ; DATA_BYTE
