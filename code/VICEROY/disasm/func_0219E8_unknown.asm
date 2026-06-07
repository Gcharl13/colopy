; ============================================================================
; func_0219E8_unknown
; Region   : overlay
; Bytes    : file 0x0219E8..0x021A14  (44 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0219E8  55                    PUSH   bp ; STACK_PUSH
0219E9  8B EC                 MOV    bp, sp ; MOV
0219EB  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
0219EE  9A 78 0B 1F 18        LCALL  0x181f, 0xb78 ; THUNK -> 0x05EB:0x0902 (thunk @file 0x01B168 type B) overlay @file 0x0278F2
0219F3  8B E5                 MOV    sp, bp ; MOV
0219F5  0B C0                 OR     ax, ax ; LOGIC
0219F7  7C 07                 JL     0x21a00 ; CJUMP
0219F9  8B 5E 08              MOV    bx, word ptr [bp + 8] ; LOCAL_LOAD
0219FC  C7 07 01 00           MOV    word ptr [bx], 1 ; MOV
021A00  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
021A04  80 BF 46 31 02        CMP    byte ptr [bx + 0x3146], 2 ; CMP
021A09  75 07                 JNE    0x21a12 ; CJUMP
021A0B  8B 5E 0A              MOV    bx, word ptr [bp + 0xa] ; LOCAL_LOAD
021A0E  C7 07 01 00           MOV    word ptr [bx], 1 ; MOV
021A12  C9                    LEAVE ; EPILOGUE
021A13  CB                    RETF ; RETURN
