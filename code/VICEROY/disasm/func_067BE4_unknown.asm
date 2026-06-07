; ============================================================================
; func_067BE4_unknown
; Region   : overlay
; Bytes    : file 0x067BE4..0x067C53  (111 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067BE4  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
067BE8  50                    PUSH   ax ; STACK_PUSH
067BE9  56                    PUSH   si ; STACK_PUSH
067BEA  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
067BEF  39 16 84 01           CMP    word ptr [0x184], dx ; CMP
067BF3  7F 58                 JG     0x67c4d ; CJUMP
067BF5  C7 46 FE A0 00        MOV    word ptr [bp - 2], 0xa0 ; LOCAL_STORE
067BFA  C4 1E 98 A5           LES    bx, ptr [0xa598] ; MOV_FAR
067BFE  2B 1E 48 85           SUB    bx, word ptr [0x8548] ; ARITH
067C02  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
067C05  25 A0 00              AND    ax, 0xa0 ; LOGIC
067C08  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
067C0B  75 04                 JNE    0x67c11 ; CJUMP
067C0D  83 46 FC 08           ADD    word ptr [bp - 4], 8 ; ARITH
067C11  8B 1E 98 A5           MOV    bx, word ptr [0xa598] ; GLOBAL_LOAD
067C15  8B 36 48 85           MOV    si, word ptr [0x8548] ; GLOBAL_LOAD
067C19  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
067C1C  22 46 FE              AND    al, byte ptr [bp - 2] ; LOGIC
067C1F  2A E4                 SUB    ah, ah ; ARITH
067C21  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
067C24  75 04                 JNE    0x67c2a ; CJUMP
067C26  83 46 FC 04           ADD    word ptr [bp - 4], 4 ; ARITH
067C2A  26 8A 47 FF           MOV    al, byte ptr es:[bx - 1] ; MOV
067C2E  22 46 FE              AND    al, byte ptr [bp - 2] ; LOGIC
067C31  2A E4                 SUB    ah, ah ; ARITH
067C33  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
067C36  75 04                 JNE    0x67c3c ; CJUMP
067C38  83 46 FC 02           ADD    word ptr [bp - 4], 2 ; ARITH
067C3C  26 8A 47 01           MOV    al, byte ptr es:[bx + 1] ; MOV
067C40  22 46 FE              AND    al, byte ptr [bp - 2] ; LOGIC
067C43  2A E4                 SUB    ah, ah ; ARITH
067C45  3B 46 FA              CMP    ax, word ptr [bp - 6] ; CMP
067C48  75 03                 JNE    0x67c4d ; CJUMP
067C4A  FF 46 FC              INC    word ptr [bp - 4] ; ARITH
067C4D  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
067C50  5E                    POP    si ; STACK_POP
067C51  C9                    LEAVE ; EPILOGUE
067C52  C3                    RET ; RETURN
