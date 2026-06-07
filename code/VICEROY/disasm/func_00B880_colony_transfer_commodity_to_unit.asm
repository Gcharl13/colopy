; ============================================================================
; func_00B880_unknown
; Region   : load_image
; Bytes    : file 0x00B880..0x00B8D0  (80 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B880  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
00B884  56                    PUSH   si ; STACK_PUSH
00B885  8B 76 08              MOV    si, word ptr [bp + 8] ; LOCAL_LOAD
00B888  D1 E6                 SHL    si, 1 ; LOGIC
00B88A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00B88E  8B 80 9A 00           MOV    ax, word ptr [bx + si + 0x9a] ; MOV
00B892  3D 64 00              CMP    ax, 0x64 ; CMP
00B895  7E 03                 JLE    0xb89a ; CJUMP
00B897  B8 64 00              MOV    ax, 0x64 ; CONST_LOAD
00B89A  3B 46 0A              CMP    ax, word ptr [bp + 0xa] ; CMP
00B89D  7E 03                 JLE    0xb8a2 ; CJUMP
00B89F  8B 46 0A              MOV    ax, word ptr [bp + 0xa] ; LOCAL_LOAD
00B8A2  A3 C4 8D              MOV    word ptr [0x8dc4], ax ; GLOBAL_LOAD
00B8A5  29 80 9A 00           SUB    word ptr [bx + si + 0x9a], ax ; ARITH
00B8A9  FF 36 C4 8D           PUSH   word ptr [0x8dc4] ; PUSH_GLOBAL
00B8AD  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
00B8B0  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B8B3  0E                    PUSH   cs ; STACK_PUSH
00B8B4  E8 B1 FA              CALL   0xb368 ; CALL_NEAR
00B8B7  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00B8BA  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
00B8BE  80 BF 4C 31 02        CMP    byte ptr [bx + 0x314c], 2 ; CMP
00B8C3  74 05                 JE     0xb8ca ; CJUMP
00B8C5  C6 87 4C 31 00        MOV    byte ptr [bx + 0x314c], 0 ; MOV
00B8CA  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00B8CD  5E                    POP    si ; STACK_POP
00B8CE  C9                    LEAVE ; EPILOGUE
00B8CF  CB                    RETF ; RETURN
