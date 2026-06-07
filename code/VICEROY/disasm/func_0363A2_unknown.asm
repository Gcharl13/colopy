; ============================================================================
; func_0363A2_unknown
; Region   : overlay
; Bytes    : file 0x0363A2..0x0363C3  (33 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0363A2  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
0363A6  56                    PUSH   si ; STACK_PUSH
0363A7  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
0363AC  74 03                 JE     0x363b1 ; CJUMP
0363AE  E9 C0 01              JMP    0x36571 ; JUMP
0363B1  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0363B4  0E                    PUSH   cs ; STACK_PUSH
0363B5  E8 56 04              CALL   0x3680e ; CALL_NEAR
0363B8  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
0363BB  FF 36 A6 83           PUSH   word ptr [0x83a6] ; PUSH_GLOBAL
0363BF  9A                    DB     0x9A ; DATA_BYTE
0363C0  CA                    DB     0xCA ; DATA_BYTE
0363C1  04                    DB     0x04 ; DATA_BYTE
0363C2  1F                    DB     0x1F ; DATA_BYTE
