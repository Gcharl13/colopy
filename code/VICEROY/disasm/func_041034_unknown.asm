; ============================================================================
; func_041034_unknown
; Region   : overlay
; Bytes    : file 0x041034..0x04105E  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041034  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
041038  56                    PUSH   si ; STACK_PUSH
041039  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04103E  81 7E 08 E7 03        CMP    word ptr [bp + 8], 0x3e7 ; CMP
041043  75 13                 JNE    0x41058 ; CJUMP
041045  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041049  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
04104D  24 0F                 AND    al, 0xf ; LOGIC
04104F  2A 87 44 31           SUB    al, byte ptr [bx + 0x3144] ; ARITH
041053  3C 14                 CMP    al, 0x14 ; CMP
041055  EB 1C                 JMP    0x41073 ; JUMP
041057  90                    NOP ; NOP
041058  69 5E 08 CA 00        IMUL   bx, word ptr [bp + 8], 0xca ; ARITH
04105D  8A                    DB     0x8A ; DATA_BYTE
