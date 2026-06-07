; ============================================================================
; func_067B84_unknown
; Region   : overlay
; Bytes    : file 0x067B84..0x067BE4  (96 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

067B84  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
067B88  50                    PUSH   ax ; STACK_PUSH
067B89  56                    PUSH   si ; STACK_PUSH
067B8A  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
067B8F  3B 16 84 01           CMP    dx, word ptr [0x184] ; CMP
067B93  7C 49                 JL     0x67bde ; CJUMP
067B95  C4 1E 98 A5           LES    bx, ptr [0xa598] ; MOV_FAR
067B99  2B 1E 48 85           SUB    bx, word ptr [0x8548] ; ARITH
067B9D  26 8A 07              MOV    al, byte ptr es:[bx] ; MOV
067BA0  2A E4                 SUB    ah, ah ; ARITH
067BA2  85 46 FC              TEST   word ptr [bp - 4], ax ; LOGIC
067BA5  74 04                 JE     0x67bab ; CJUMP
067BA7  83 46 FE 08           ADD    word ptr [bp - 2], 8 ; ARITH
067BAB  8B 1E 98 A5           MOV    bx, word ptr [0xa598] ; GLOBAL_LOAD
067BAF  8B 36 48 85           MOV    si, word ptr [0x8548] ; GLOBAL_LOAD
067BB3  26 8A 00              MOV    al, byte ptr es:[bx + si] ; MOV
067BB6  2A E4                 SUB    ah, ah ; ARITH
067BB8  85 46 FC              TEST   word ptr [bp - 4], ax ; LOGIC
067BBB  74 04                 JE     0x67bc1 ; CJUMP
067BBD  83 46 FE 04           ADD    word ptr [bp - 2], 4 ; ARITH
067BC1  26 8A 47 FF           MOV    al, byte ptr es:[bx - 1] ; MOV
067BC5  2A E4                 SUB    ah, ah ; ARITH
067BC7  85 46 FC              TEST   word ptr [bp - 4], ax ; LOGIC
067BCA  74 04                 JE     0x67bd0 ; CJUMP
067BCC  83 46 FE 02           ADD    word ptr [bp - 2], 2 ; ARITH
067BD0  26 8A 47 01           MOV    al, byte ptr es:[bx + 1] ; MOV
067BD4  2A E4                 SUB    ah, ah ; ARITH
067BD6  85 46 FC              TEST   word ptr [bp - 4], ax ; LOGIC
067BD9  74 03                 JE     0x67bde ; CJUMP
067BDB  FF 46 FE              INC    word ptr [bp - 2] ; ARITH
067BDE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
067BE1  5E                    POP    si ; STACK_POP
067BE2  C9                    LEAVE ; EPILOGUE
067BE3  C3                    RET ; RETURN
