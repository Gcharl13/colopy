; ============================================================================
; func_007A80_unknown
; Region   : load_image
; Bytes    : file 0x007A80..0x007B0F  (143 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

007A80  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
007A84  57                    PUSH   di ; STACK_PUSH
007A85  56                    PUSH   si ; STACK_PUSH
007A86  8B F0                 MOV    si, ax ; MOV
007A88  2B FF                 SUB    di, di ; ARITH
007A8A  0B F6                 OR     si, si ; LOGIC
007A8C  7C 7B                 JL     0x7b09 ; CJUMP
007A8E  39 36 9C 53           CMP    word ptr [0x539c], si ; CMP
007A92  7E 75                 JLE    0x7b09 ; CJUMP
007A94  6B DE 1C              IMUL   bx, si, 0x1c ; ARITH
007A97  89 5E FE              MOV    word ptr [bp - 2], bx ; LOCAL_STORE
007A9A  8A 87 45 31           MOV    al, byte ptr [bx + 0x3145] ; MOV
007A9E  2A E4                 SUB    ah, ah ; ARITH
007AA0  50                    PUSH   ax ; STACK_PUSH
007AA1  8A 87 44 31           MOV    al, byte ptr [bx + 0x3144] ; MOV
007AA5  50                    PUSH   ax ; STACK_PUSH
007AA6  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
007AAB  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
007AAE  0B C0                 OR     ax, ax ; LOGIC
007AB0  75 18                 JNE    0x7aca ; CJUMP
007AB2  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
007AB5  80 BF 4C 31 02        CMP    byte ptr [bx + 0x314c], 2 ; CMP
007ABA  75 4D                 JNE    0x7b09 ; CJUMP
007ABC  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
007AC0  24 0F                 AND    al, 0xf ; LOGIC
007AC2  2A 87 44 31           SUB    al, byte ptr [bx + 0x3144] ; ARITH
007AC6  3C 14                 CMP    al, 0x14 ; CMP
007AC8  75 3F                 JNE    0x7b09 ; CJUMP
007ACA  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
007ACD  8A 87 47 31           MOV    al, byte ptr [bx + 0x3147] ; MOV
007AD1  24 0F                 AND    al, 0xf ; LOGIC
007AD3  3A 06 94 53           CMP    al, byte ptr [0x5394] ; CMP
007AD7  75 30                 JNE    0x7b09 ; CJUMP
007AD9  80 BF 4C 31 01        CMP    byte ptr [bx + 0x314c], 1 ; CMP
007ADE  74 29                 JE     0x7b09 ; CJUMP
007AE0  80 BF 4C 31 06        CMP    byte ptr [bx + 0x314c], 6 ; CMP
007AE5  74 22                 JE     0x7b09 ; CJUMP
007AE7  F6 87 48 31 80        TEST   byte ptr [bx + 0x3148], 0x80 ; LOGIC
007AEC  74 07                 JE     0x7af5 ; CJUMP
007AEE  80 BF 46 31 0B        CMP    byte ptr [bx + 0x3146], 0xb ; CMP
007AF3  75 14                 JNE    0x7b09 ; CJUMP
007AF5  56                    PUSH   si ; STACK_PUSH
007AF6  0E                    PUSH   cs ; STACK_PUSH
007AF7  E8 D0 F1              CALL   0x6cca ; CALL_NEAR
007AFA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
007AFD  8B 5E FE              MOV    bx, word ptr [bp - 2] ; LOCAL_LOAD
007B00  38 87 49 31           CMP    byte ptr [bx + 0x3149], al ; CMP
007B04  73 03                 JAE    0x7b09 ; CJUMP
007B06  BF 01 00              MOV    di, 1 ; MOV
007B09  8B C7                 MOV    ax, di ; MOV
007B0B  5E                    POP    si ; STACK_POP
007B0C  5F                    POP    di ; STACK_POP
007B0D  C9                    LEAVE ; EPILOGUE
007B0E  CB                    RETF ; RETURN
