; ============================================================================
; func_008806_unknown
; Region   : load_image
; Bytes    : file 0x008806..0x008845  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

008806  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00880A  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00880D  0E                    PUSH   cs ; STACK_PUSH
00880E  E8 E3 FF              CALL   0x87f4 ; CALL_NEAR
008811  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
008814  03 46 08              ADD    ax, word ptr [bp + 8] ; ARITH
008817  13 56 0A              ADC    dx, word ptr [bp + 0xa] ; ARITH
00881A  0B D2                 OR     dx, dx ; LOGIC
00881C  7F 06                 JG     0x8824 ; CJUMP
00881E  7D 04                 JGE    0x8824 ; CJUMP
008820  2B D2                 SUB    dx, dx ; ARITH
008822  2B C0                 SUB    ax, ax ; ARITH
008824  83 FA 0F              CMP    dx, 0xf ; CMP
008827  7C 0D                 JL     0x8836 ; CJUMP
008829  7F 05                 JG     0x8830 ; CJUMP
00882B  3D 3F 42              CMP    ax, 0x423f ; CMP
00882E  76 06                 JBE    0x8836 ; CJUMP
008830  BA 0F 00              MOV    dx, 0xf ; CONST_LOAD
008833  B8 3F 42              MOV    ax, 0x423f ; CONST_LOAD
008836  69 5E 06 3C 01        IMUL   bx, word ptr [bp + 6], 0x13c ; ARITH
00883B  89 87 32 88           MOV    word ptr [bx - 0x77ce], ax ; MOV
00883F  89 97 34 88           MOV    word ptr [bx - 0x77cc], dx ; MOV
008843  C9                    LEAVE ; EPILOGUE
008844  CB                    RETF ; RETURN
