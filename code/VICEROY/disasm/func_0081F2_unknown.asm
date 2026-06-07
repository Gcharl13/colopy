; ============================================================================
; func_0081F2_unknown
; Region   : load_image
; Bytes    : file 0x0081F2..0x008214  (34 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0081F2  55                    PUSH   bp ; STACK_PUSH
0081F3  8B EC                 MOV    bp, sp ; MOV
0081F5  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
0081F8  A3 4C 8D              MOV    word ptr [0x8d4c], ax ; GLOBAL_LOAD
0081FB  0B C0                 OR     ax, ax ; LOGIC
0081FD  7C 28                 JL     0x8227 ; CJUMP
0081FF  0B C0                 OR     ax, ax ; LOGIC
008201  7C 06                 JL     0x8209 ; CJUMP
008203  39 06 9A 53           CMP    word ptr [0x539a], ax ; CMP
008207  7F 05                 JG     0x820e ; CJUMP
008209  C7 46 06 00 00        MOV    word ptr [bp + 6], 0 ; LOCAL_STORE
00820E  6B 5E 06 12           IMUL   bx, word ptr [bp + 6], 0x12 ; ARITH
008212  81                    DB     0x81 ; DATA_BYTE
008213  C3                    DB     0xC3 ; DATA_BYTE
