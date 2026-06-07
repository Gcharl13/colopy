; ============================================================================
; func_05C69C_unknown
; Region   : overlay
; Bytes    : file 0x05C69C..0x05C6DB  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05C69C  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
05C6A0  56                    PUSH   si ; STACK_PUSH
05C6A1  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05C6A5  80 BF 46 31 01        CMP    byte ptr [bx + 0x3146], 1 ; CMP
05C6AA  74 0A                 JE     0x5c6b6 ; CJUMP
05C6AC  80 BF 46 31 04        CMP    byte ptr [bx + 0x3146], 4 ; CMP
05C6B1  74 03                 JE     0x5c6b6 ; CJUMP
05C6B3  E9 BD 01              JMP    0x5c873 ; JUMP
05C6B6  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
05C6BA  80 BF 5B 31 15        CMP    byte ptr [bx + 0x315b], 0x15 ; CMP
05C6BF  75 1B                 JNE    0x5c6dc ; CJUMP
05C6C1  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
05C6C6  75 03                 JNE    0x5c6cb ; CJUMP
05C6C8  E9 A8 01              JMP    0x5c873 ; JUMP
05C6CB  69 1E 98 53 3C 01     IMUL   bx, word ptr [0x5398], 0x13c ; ARITH
05C6D1  F6 87 08 88 08        TEST   byte ptr [bx - 0x77f8], 8 ; LOGIC
05C6D6  75 1D                 JNE    0x5c6f5 ; CJUMP
05C6D8  5E                    POP    si ; STACK_POP
05C6D9  C9                    LEAVE ; EPILOGUE
05C6DA  CB                    RETF ; RETURN
