; ============================================================================
; func_02BC72_unknown
; Region   : overlay
; Bytes    : file 0x02BC72..0x02BCA4  (50 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02BC72  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
02BC76  56                    PUSH   si ; STACK_PUSH
02BC77  C7 46 F2 01 00        MOV    word ptr [bp - 0xe], 1 ; LOCAL_STORE
02BC7C  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
02BC7F  3D 4E 00              CMP    ax, 0x4e ; CMP
02BC82  75 03                 JNE    0x2bc87 ; CJUMP
02BC84  E9 F5 02              JMP    0x2bf7c ; JUMP
02BC87  7E 03                 JLE    0x2bc8c ; CJUMP
02BC89  E9 30 04              JMP    0x2c0bc ; JUMP
02BC8C  3D 4D 00              CMP    ax, 0x4d ; CMP
02BC8F  75 03                 JNE    0x2bc94 ; CJUMP
02BC91  E9 C0 02              JMP    0x2bf54 ; JUMP
02BC94  76 03                 JBE    0x2bc99 ; CJUMP
02BC96  E9 47 04              JMP    0x2c0e0 ; JUMP
02BC99  3C 2D                 CMP    al, 0x2d ; CMP
02BC9B  75 03                 JNE    0x2bca0 ; CJUMP
02BC9D  E9 0E 03              JMP    0x2bfae ; JUMP
02BCA0  7E 03                 JLE    0x2bca5 ; CJUMP
02BCA2  E9                    DB     0xE9 ; DATA_BYTE
02BCA3  CF                    DB     0xCF ; DATA_BYTE
