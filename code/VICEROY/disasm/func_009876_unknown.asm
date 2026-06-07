; ============================================================================
; func_009876_unknown
; Region   : load_image
; Bytes    : file 0x009876..0x0098B4  (62 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009876  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
00987A  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
00987F  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
009883  7C 2A                 JL     0x98af ; CJUMP
009885  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
009888  0E                    PUSH   cs ; STACK_PUSH
009889  E8 10 F5              CALL   0x8d9c ; CALL_NEAR
00988C  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
00988F  0B C0                 OR     ax, ax ; LOGIC
009891  7C 1C                 JL     0x98af ; CJUMP
009893  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
009898  8B D8                 MOV    bx, ax ; MOV
00989A  D1 E3                 SHL    bx, 1 ; LOGIC
00989C  03 D8                 ADD    bx, ax ; ARITH
00989E  C1 E3 02              SHL    bx, 2 ; LOGIC
0098A1  8A 87 86 8F           MOV    al, byte ptr [bx - 0x707a] ; MOV
0098A5  98                    CWDE ; ARITH
0098A6  0B C0                 OR     ax, ax ; LOGIC
0098A8  7C 05                 JL     0x98af ; CJUMP
0098AA  C7 46 FC 02 00        MOV    word ptr [bp - 4], 2 ; LOCAL_STORE
0098AF  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
0098B2  C9                    LEAVE ; EPILOGUE
0098B3  CB                    RETF ; RETURN
