; ============================================================================
; func_05FEA0_unknown
; Region   : overlay
; Bytes    : file 0x05FEA0..0x05FED8  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05FEA0  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
05FEA4  56                    PUSH   si ; STACK_PUSH
05FEA5  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
05FEA8  8B C6                 MOV    ax, si ; MOV
05FEAA  C1 E6 02              SHL    si, 2 ; LOGIC
05FEAD  03 F0                 ADD    si, ax ; ARITH
05FEAF  D1 E6                 SHL    si, 1 ; LOGIC
05FEB1  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
05FEB5  26 81 78 22 E7 03     CMP    word ptr es:[bx + si + 0x22], 0x3e7 ; CMP
05FEBB  75 1B                 JNE    0x5fed8 ; CJUMP
05FEBD  8B 1E 94 53           MOV    bx, word ptr [0x5394] ; GLOBAL_LOAD
05FEC1  D1 E3                 SHL    bx, 1 ; LOGIC
05FEC3  FF B7 8C 83           PUSH   word ptr [bx - 0x7c74] ; PUSH_GLOBAL
05FEC7  9A 22 00 1F 18        LCALL  0x181f, 0x22 ; THUNK -> 0x0000:0x0062 (thunk @file 0x01A612 type B) overlay @file 0x025962
05FECC  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
05FECF  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
05FED2  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
05FED5  5E                    POP    si ; STACK_POP
05FED6  C9                    LEAVE ; EPILOGUE
05FED7  CB                    RETF ; RETURN
