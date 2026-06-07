; ============================================================================
; func_0083F2_unknown
; Region   : load_image
; Bytes    : file 0x0083F2..0x008439  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0083F2  C8 0C 00 00           ENTER  0xc, 0 ; PROLOGUE
0083F6  C7 46 F4 FF FF        MOV    word ptr [bp - 0xc], 0xffff ; LOCAL_STORE
0083FB  C7 46 FE 0F 27        MOV    word ptr [bp - 2], 0x270f ; LOCAL_STORE
008400  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
008405  83 7E 0C FE           CMP    word ptr [bp + 0xc], -2 ; CMP
008409  75 16                 JNE    0x8421 ; CJUMP
00840B  C7 46 FA 01 00        MOV    word ptr [bp - 6], 1 ; LOCAL_STORE
008410  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
008413  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
008416  9A A0 02 7F 03        LCALL  0x37f, 0x2a0 ; LCALL
00841B  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00841E  89 46 0C              MOV    word ptr [bp + 0xc], ax ; LOCAL_STORE
008421  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
008426  E9 81 00              JMP    0x84aa ; JUMP
008429  90                    NOP ; NOP
00842A  83 7E 0A 00           CMP    word ptr [bp + 0xa], 0 ; CMP
00842E  7C 0E                 JL     0x843e ; CJUMP
008430  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
008433  69 5E F8 CA 00        IMUL   bx, word ptr [bp - 8], 0xca ; ARITH
008438  38                    DB     0x38 ; DATA_BYTE
