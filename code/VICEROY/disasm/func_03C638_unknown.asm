; ============================================================================
; func_03C638_unknown
; Region   : overlay
; Bytes    : file 0x03C638..0x03C681  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

03C638  C8 24 00 00           ENTER  0x24, 0 ; PROLOGUE
03C63C  56                    PUSH   si ; STACK_PUSH
03C63D  F6 06 81 53 80        TEST   byte ptr [0x5381], 0x80 ; LOGIC
03C642  74 03                 JE     0x3c647 ; CJUMP
03C644  E9 E8 02              JMP    0x3c92f ; JUMP
03C647  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
03C64C  8A 46 F0              MOV    al, byte ptr [bp - 0x10] ; LOCAL_LOAD
03C64F  8B 76 F0              MOV    si, word ptr [bp - 0x10] ; LOCAL_LOAD
03C652  88 42 EC              MOV    byte ptr [bp + si - 0x14], al ; LOCAL_STORE
03C655  8A 84 18 94           MOV    al, byte ptr [si - 0x6be8] ; MOV
03C659  2A E4                 SUB    ah, ah ; ARITH
03C65B  8B C8                 MOV    cx, ax ; MOV
03C65D  D1 E0                 SHL    ax, 1 ; LOGIC
03C65F  03 C1                 ADD    ax, cx ; ARITH
03C661  8A 8C 98 92           MOV    cl, byte ptr [si - 0x6d68] ; MOV
03C665  2A ED                 SUB    ch, ch ; ARITH
03C667  D1 E1                 SHL    cx, 1 ; LOGIC
03C669  03 C1                 ADD    ax, cx ; ARITH
03C66B  8A 8C 10 94           MOV    cl, byte ptr [si - 0x6bf0] ; MOV
03C66F  2A ED                 SUB    ch, ch ; ARITH
03C671  03 C1                 ADD    ax, cx ; ARITH
03C673  D1 E6                 SHL    si, 1 ; LOGIC
03C675  89 42 E4              MOV    word ptr [bp + si - 0x1c], ax ; LOCAL_STORE
03C678  FF 46 F0              INC    word ptr [bp - 0x10] ; ARITH
03C67B  83 7E F0 04           CMP    word ptr [bp - 0x10], 4 ; CMP
03C67F  7C CB                 JL     0x3c64c ; CJUMP
