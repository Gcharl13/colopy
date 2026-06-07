; ============================================================================
; func_002AFC_unknown
; Region   : load_image
; Bytes    : file 0x002AFC..0x002B23  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

002AFC  55                    PUSH   bp ; STACK_PUSH
002AFD  8B EC                 MOV    bp, sp ; MOV
002AFF  57                    PUSH   di ; STACK_PUSH
002B00  56                    PUSH   si ; STACK_PUSH
002B01  1E                    PUSH   ds ; STACK_PUSH
002B02  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
002B05  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
002B08  B9 00 03              MOV    cx, 0x300 ; CONST_LOAD
002B0B  AC                    LODSB  al, byte ptr [si] ; STR
002B0C  51                    PUSH   cx ; STACK_PUSH
002B0D  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
002B10  D2 E8                 SHR    al, cl ; LOGIC
002B12  59                    POP    cx ; STACK_POP
002B13  14 00                 ADC    al, 0 ; ARITH
002B15  0A C0                 OR     al, al ; LOGIC
002B17  75 02                 JNE    0x2b1b ; CJUMP
002B19  FE C0                 INC    al ; ARITH
002B1B  AA                    STOSB  byte ptr es:[di], al ; STR
002B1C  E2 ED                 LOOP   0x2b0b ; CJUMP
002B1E  1F                    POP    ds ; STACK_POP
002B1F  5E                    POP    si ; STACK_POP
002B20  5F                    POP    di ; STACK_POP
002B21  C9                    LEAVE ; EPILOGUE
002B22  CB                    RETF ; RETURN
