; ============================================================================
; func_03C282_unknown
; Region   : overlay
; Bytes    : file 0x03C282..0x03C322  (160 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C282  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
03C286  83 7E 06 04           CMP    word ptr [bp + 6], 4 ; CMP
03C28A  7D 18                 JGE    0x3c2a4 ; CJUMP
03C28C  6B 5E 06 34           IMUL   bx, word ptr [bp + 6], 0x34 ; ARITH
03C290  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
03C295  75 0D                 JNE    0x3c2a4 ; CJUMP
03C297  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
03C29A  2A E4                 SUB    ah, ah ; ARITH
03C29C  05 03 00              ADD    ax, 3 ; ARITH
03C29F  D1 E0                 SHL    ax, 1 ; LOGIC
03C2A1  EB 0B                 JMP    0x3c2ae ; JUMP
03C2A3  90                    NOP ; NOP
03C2A4  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
03C2A7  2A E4                 SUB    ah, ah ; ARITH
03C2A9  2D 0E 00              SUB    ax, 0xe ; ARITH
03C2AC  F7 D8                 NEG    ax ; ARITH
03C2AE  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
03C2B1  C1 66 FC 03           SHL    word ptr [bp - 4], 3 ; LOGIC
03C2B5  81 3E 8A 53 40 06     CMP    word ptr [0x538a], 0x640 ; CMP
03C2BB  7C 08                 JL     0x3c2c5 ; CJUMP
03C2BD  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03C2C0  D1 F8                 SAR    ax, 1 ; LOGIC
03C2C2  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
03C2C5  81 3E 8A 53 72 06     CMP    word ptr [0x538a], 0x672 ; CMP
03C2CB  7C 08                 JL     0x3c2d5 ; CJUMP
03C2CD  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03C2D0  D1 F8                 SAR    ax, 1 ; LOGIC
03C2D2  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
03C2D5  81 3E 8A 53 A4 06     CMP    word ptr [0x538a], 0x6a4 ; CMP
03C2DB  7C 08                 JL     0x3c2e5 ; CJUMP
03C2DD  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03C2E0  D1 F8                 SAR    ax, 1 ; LOGIC
03C2E2  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
03C2E5  81 3E 8A 53 D6 06     CMP    word ptr [0x538a], 0x6d6 ; CMP
03C2EB  7C 08                 JL     0x3c2f5 ; CJUMP
03C2ED  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
03C2F0  D1 F8                 SAR    ax, 1 ; LOGIC
03C2F2  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
03C2F5  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; ARITH
03C2FA  8A 87 1C 88           MOV    al, byte ptr [bx - 0x77e4] ; MOV
03C2FE  8B C8                 MOV    cx, ax ; MOV
03C300  2A E4                 SUB    ah, ah ; ARITH
03C302  40                    INC    ax ; ARITH
03C303  F7 6E FC              IMUL   word ptr [bp - 4] ; ARITH
03C306  40                    INC    ax ; ARITH
03C307  0A C9                 OR     cl, cl ; LOGIC
03C309  75 02                 JNE    0x3c30d ; CJUMP
03C30B  D1 F8                 SAR    ax, 1 ; LOGIC
03C30D  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
03C312  74 0C                 JE     0x3c320 ; CJUMP
03C314  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
03C317  2A E4                 SUB    ah, ah ; ARITH
03C319  69 C0 DC 05           IMUL   ax, ax, 0x5dc ; ARITH
03C31D  05 D0 07              ADD    ax, 0x7d0 ; ARITH
03C320  C9                    LEAVE ; EPILOGUE
03C321  CB                    RETF ; RETURN
