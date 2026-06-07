; ============================================================================
; func_070C6C_unknown
; Region   : overlay
; Bytes    : file 0x070C6C..0x070CB3  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

070C6C  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
070C70  50                    PUSH   ax ; STACK_PUSH
070C71  53                    PUSH   bx ; STACK_PUSH
070C72  56                    PUSH   si ; STACK_PUSH
070C73  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
070C78  EB 09                 JMP    0x70c83 ; JUMP
070C7A  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
070C7D  38 04                 CMP    byte ptr [si], al ; CMP
070C7F  74 0C                 JE     0x70c8d ; CJUMP
070C81  FF 07                 INC    word ptr [bx] ; ARITH
070C83  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
070C86  8B 37                 MOV    si, word ptr [bx] ; MOV
070C88  80 3C 00              CMP    byte ptr [si], 0 ; CMP
070C8B  75 ED                 JNE    0x70c7a ; CJUMP
070C8D  80 7E FC 00           CMP    byte ptr [bp - 4], 0 ; CMP
070C91  74 0E                 JE     0x70ca1 ; CJUMP
070C93  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
070C96  38 04                 CMP    byte ptr [si], al ; CMP
070C98  75 07                 JNE    0x70ca1 ; CJUMP
070C9A  FF 07                 INC    word ptr [bx] ; ARITH
070C9C  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
070CA1  8B 5E FA              MOV    bx, word ptr [bp - 6] ; LOCAL_LOAD
070CA4  8B 37                 MOV    si, word ptr [bx] ; MOV
070CA6  80 3C 00              CMP    byte ptr [si], 0 ; CMP
070CA9  75 02                 JNE    0x70cad ; CJUMP
070CAB  FF 0F                 DEC    word ptr [bx] ; ARITH
070CAD  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
070CB0  5E                    POP    si ; STACK_POP
070CB1  C9                    LEAVE ; EPILOGUE
070CB2  CB                    RETF ; RETURN
