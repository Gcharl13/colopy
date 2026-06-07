; ============================================================================
; func_007A20_unknown
; Region   : load_image
; Bytes    : file 0x007A20..0x007A73  (83 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007A20  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
007A24  57                    PUSH   di ; STACK_PUSH
007A25  56                    PUSH   si ; STACK_PUSH
007A26  8B F0                 MOV    si, ax ; MOV
007A28  2B DB                 SUB    bx, bx ; ARITH
007A2A  0B F6                 OR     si, si ; LOGIC
007A2C  7C 4C                 JL     0x7a7a ; CJUMP
007A2E  39 36 9C 53           CMP    word ptr [0x539c], si ; CMP
007A32  7E 46                 JLE    0x7a7a ; CJUMP
007A34  6B FE 1C              IMUL   di, si, 0x1c ; ARITH
007A37  89 7E FE              MOV    word ptr [bp - 2], di ; LOCAL_STORE
007A3A  80 BD 44 31 00        CMP    byte ptr [di + 0x3144], 0 ; CMP
007A3F  7C 39                 JL     0x7a7a ; CJUMP
007A41  8B DF                 MOV    bx, di ; MOV
007A43  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
007A47  24 0F                 AND    al, 0xf ; LOGIC
007A49  3A 06 94 53           CMP    al, byte ptr [0x5394] ; CMP
007A4D  75 29                 JNE    0x7a78 ; CJUMP
007A4F  F6 87 48 31 80        TEST   byte ptr [bx + 0x3148], 0x80 ; LOGIC
007A54  74 07                 JE     0x7a5d ; CJUMP
007A56  80 BF 46 31 0B        CMP    byte ptr [bx + 0x3146], 0xb ; CMP
007A5B  75 1B                 JNE    0x7a78 ; CJUMP
007A5D  56                    PUSH   si ; STACK_PUSH
007A5E  0E                    PUSH   cs ; STACK_PUSH
007A5F  E8 68 F2              CALL   0x6cca ; CALL_NEAR
007A62  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007A65  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
007A68  38 87 49 31           CMP    byte ptr [bx + 0x3149], al ; CMP
007A6C  73 0A                 JAE    0x7a78 ; CJUMP
007A6E  BB 01 00              MOV    bx, 1 ; MOV
007A71  8B C3                 MOV    ax, bx ; MOV
