; ============================================================================
; func_05576B_unknown
; Region   : overlay
; Bytes    : file 0x05576B..0x0557C2  (87 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

05576B  C8 FE 05 00           ENTER  0x5fe, 0 ; PROLOGUE
05576F  83 BE C8 FE 00        CMP    word ptr [bp - 0x138], 0 ; CMP
055774  7C 24                 JL     0x5579a ; CJUMP
055776  8B B6 C8 FE           MOV    si, word ptr [bp - 0x138] ; LOCAL_LOAD
05577A  D1 E6                 SHL    si, 1 ; LOGIC
05577C  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
055780  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; MOV
055784  2B 84 0A 8E           SUB    ax, word ptr [si - 0x71f6] ; ARITH
055788  03 84 C8 8D           ADD    ax, word ptr [si - 0x7238] ; ARITH
05578C  89 46 8A              MOV    word ptr [bp - 0x76], ax ; LOCAL_STORE
05578F  0B C0                 OR     ax, ax ; LOGIC
055791  7C 81                 JL     0x55714 ; CJUMP
055793  0B C0                 OR     ax, ax ; LOGIC
055795  75 03                 JNE    0x5579a ; CJUMP
055797  FF 46 8A              INC    word ptr [bp - 0x76] ; ARITH
05579A  8D 46 CE              LEA    ax, [bp - 0x32] ; ADDR
05579D  50                    PUSH   ax ; STACK_PUSH
05579E  FF B6 56 FF           PUSH   word ptr [bp - 0xaa] ; PUSH_GLOBAL
0557A2  9A D6 0C 1F 18        LCALL  0x181f, 0xcd6 ; THUNK -> 0x05EB:0x1D4C (thunk @file 0x01B2C6 type B) overlay @file 0x028D3C
0557A7  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
0557AA  89 86 BE FE           MOV    word ptr [bp - 0x142], ax ; LOCAL_STORE
0557AE  3B 46 8A              CMP    ax, word ptr [bp - 0x76] ; CMP
0557B1  7E 03                 JLE    0x557b6 ; CJUMP
0557B3  8B 46 8A              MOV    ax, word ptr [bp - 0x76] ; LOCAL_LOAD
0557B6  89 86 BE FE           MOV    word ptr [bp - 0x142], ax ; LOCAL_STORE
0557BA  83 7E CE 10           CMP    word ptr [bp - 0x32], 0x10 ; CMP
0557BE  7D 03                 JGE    0x557c3 ; CJUMP
0557C0  E9                    DB     0xE9 ; DATA_BYTE
0557C1  CF                    DB     0xCF ; DATA_BYTE
