; ============================================================================
; func_04C404_unknown
; Region   : overlay
; Bytes    : file 0x04C404..0x04C44B  (71 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04C404  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
04C408  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
04C40D  EB 04                 JMP    0x4c413 ; JUMP
04C40F  90                    NOP ; NOP
04C410  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
04C413  83 7E FE 10           CMP    word ptr [bp - 2], 0x10 ; CMP
04C417  7D 33                 JGE    0x4c44c ; CJUMP
04C419  8A 46 08              MOV    al, byte ptr [bp + 8] ; LOCAL_LOAD
04C41C  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
04C41F  C1 E3 04              SHL    bx, 4 ; LOGIC
04C422  03 5E FE              ADD    bx, word ptr [bp - 2] ; ARITH
04C425  C1 E3 02              SHL    bx, 2 ; LOGIC
04C428  38 87 AA 9E           CMP    byte ptr [bx - 0x6156], al ; CMP
04C42C  75 E2                 JNE    0x4c410 ; CJUMP
04C42E  8A 46 0A              MOV    al, byte ptr [bp + 0xa] ; LOCAL_LOAD
04C431  38 87 AB 9E           CMP    byte ptr [bx - 0x6155], al ; CMP
04C435  75 D9                 JNE    0x4c410 ; CJUMP
04C437  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
04C43A  38 87 AC 9E           CMP    byte ptr [bx - 0x6154], al ; CMP
04C43E  75 D0                 JNE    0x4c410 ; CJUMP
04C440  8A 46 0E              MOV    al, byte ptr [bp + 0xe] ; LOCAL_LOAD
04C443  38 87 AD 9E           CMP    byte ptr [bx - 0x6153], al ; CMP
04C447  7C C7                 JL     0x4c410 ; CJUMP
04C449  C9                    LEAVE ; EPILOGUE
04C44A  CB                    RETF ; RETURN
