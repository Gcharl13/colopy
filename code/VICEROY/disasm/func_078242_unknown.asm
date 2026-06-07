; ============================================================================
; func_078242_unknown
; Region   : overlay
; Bytes    : file 0x078242..0x078269  (39 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078242  55                    PUSH   bp ; STACK_PUSH
078243  8B EC                 MOV    bp, sp ; MOV
078245  57                    PUSH   di ; STACK_PUSH
078246  56                    PUSH   si ; STACK_PUSH
078247  1E                    PUSH   ds ; STACK_PUSH
078248  C4 7E 0A              LES    di, ptr [bp + 0xa] ; MOV_FAR
07824B  C5 76 06              LDS    si, ptr [bp + 6] ; MOV_FAR
07824E  B9 00 03              MOV    cx, 0x300 ; CONST_LOAD
078251  AC                    LODSB  al, byte ptr [si] ; STR
078252  51                    PUSH   cx ; STACK_PUSH
078253  8B 4E 0E              MOV    cx, word ptr [bp + 0xe] ; LOCAL_LOAD
078256  D2 E8                 SHR    al, cl ; LOGIC
078258  59                    POP    cx ; STACK_POP
078259  14 00                 ADC    al, 0 ; ARITH
07825B  0A C0                 OR     al, al ; LOGIC
07825D  75 02                 JNE    0x78261 ; CJUMP
07825F  FE C0                 INC    al ; ARITH
078261  AA                    STOSB  byte ptr es:[di], al ; STR
078262  E2 ED                 LOOP   0x78251 ; CJUMP
078264  1F                    POP    ds ; STACK_POP
078265  5E                    POP    si ; STACK_POP
078266  5F                    POP    di ; STACK_POP
078267  C9                    LEAVE ; EPILOGUE
078268  CB                    RETF ; RETURN
