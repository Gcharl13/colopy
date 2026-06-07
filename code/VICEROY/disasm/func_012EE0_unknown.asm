; ============================================================================
; func_012EE0_unknown
; Region   : load_image
; Bytes    : file 0x012EE0..0x012F1F  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012EE0  C8 A2 05 00           ENTER  0x5a2, 0 ; PROLOGUE
012EE4  8A CC                 MOV    cl, ah ; MOV
012EE6  B8 01 00              MOV    ax, 1 ; MOV
012EE9  D3 E0                 SHL    ax, cl ; LOGIC
012EEB  A3 08 00              MOV    word ptr [8], ax ; MOV
012EEE  80 E9 04              SUB    cl, 4 ; ARITH
012EF1  B8 01 00              MOV    ax, 1 ; MOV
012EF4  D3 E0                 SHL    ax, cl ; LOGIC
012EF6  A3 0A 00              MOV    word ptr [0xa], ax ; GLOBAL_LOAD
012EF9  80 E9 04              SUB    cl, 4 ; ARITH
012EFC  B0 FF                 MOV    al, 0xff ; CONST_LOAD
012EFE  D2 E0                 SHL    al, cl ; LOGIC
012F00  A2 06 00              MOV    byte ptr [6], al ; MOV
012F03  81 FE 1B 08           CMP    si, 0x81b ; CMP
012F07  72 03                 JB     0x12f0c ; CJUMP
012F09  E8 07 01              CALL   0x13013 ; CALL_NEAR
012F0C  AD                    LODSW  ax, word ptr [si] ; STR
012F0D  8B E8                 MOV    bp, ax ; MOV
012F0F  BA 10 00              MOV    dx, 0x10 ; CONST_LOAD
012F12  EB 0B                 JMP    0x12f1f ; JUMP
012F14  90                    NOP ; NOP
012F15  B8 16 00              MOV    ax, 0x16 ; CONST_LOAD
012F18  1F                    POP    ds ; STACK_POP
012F19  5F                    POP    di ; STACK_POP
012F1A  5E                    POP    si ; STACK_POP
012F1B  C9                    LEAVE ; EPILOGUE
012F1C  CA 0C 00              RETF   0xc ; RETURN
