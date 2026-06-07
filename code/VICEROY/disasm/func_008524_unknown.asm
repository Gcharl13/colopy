; ============================================================================
; func_008524_unknown
; Region   : load_image
; Bytes    : file 0x008524..0x008536  (18 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008524  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
008528  2B C0                 SUB    ax, ax ; ARITH
00852A  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
00852D  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
008531  8B 87 C2 00           MOV    ax, word ptr [bx + 0xc2] ; MOV
008535  8B                    DB     0x8B ; DATA_BYTE
