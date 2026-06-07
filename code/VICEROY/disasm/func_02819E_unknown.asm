; ============================================================================
; func_02819E_unknown
; Region   : overlay
; Bytes    : file 0x02819E..0x0281C9  (43 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02819E  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
0281A2  6B 46 06 13           IMUL   ax, word ptr [bp + 6], 0x13 ; ARITH
0281A6  40                    INC    ax ; ARITH
0281A7  83 3E 98 0B 00        CMP    word ptr [0xb98], 0 ; CMP
0281AC  75 25                 JNE    0x281d3 ; CJUMP
0281AE  FF 36 AE 2D           PUSH   word ptr [0x2dae] ; PUSH_GLOBAL
0281B2  FF 36 AC 2D           PUSH   word ptr [0x2dac] ; PUSH_GLOBAL
0281B6  FF 36 AA 2D           PUSH   word ptr [0x2daa] ; PUSH_GLOBAL
0281BA  FF 36 A8 2D           PUSH   word ptr [0x2da8] ; PUSH_GLOBAL
0281BE  68 C7 00              PUSH   0xc7 ; PUSH_CONST
0281C1  8A 4E 08              MOV    cl, byte ptr [bp + 8] ; LOCAL_LOAD
0281C4  51                    PUSH   cx ; STACK_PUSH
0281C5  8B D8                 MOV    bx, ax ; MOV
0281C7  83                    DB     0x83 ; DATA_BYTE
0281C8  C3                    DB     0xC3 ; DATA_BYTE
