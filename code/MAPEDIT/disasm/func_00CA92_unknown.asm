; ============================================================================
; func_00CA92_unknown
; Region   : load_image
; Bytes    : file 0x00CA92..0x00CB17  (133 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00CA92  55                    PUSH   bp ; STACK_PUSH
00CA93  8B EC                 MOV    bp, sp ; MOV
00CA95  50                    PUSH   ax ; STACK_PUSH
00CA96  0E                    PUSH   cs ; STACK_PUSH
00CA97  E8 DC EF              CALL   0xba76 ; CALL_NEAR
00CA9A  83 3E D8 5A 00        CMP    word ptr [0x5ad8], 0 ; CMP
00CA9F  75 07                 JNE    0xcaa8 ; CJUMP
00CAA1  83 3E F4 5A 00        CMP    word ptr [0x5af4], 0 ; CMP
00CAA6  74 57                 JE     0xcaff ; CJUMP
00CAA8  83 3E 90 00 00        CMP    word ptr [0x90], 0 ; CMP
00CAAD  74 39                 JE     0xcae8 ; CJUMP
00CAAF  6A F8                 PUSH   -8 ; STACK_PUSH
00CAB1  6A 00                 PUSH   0 ; STACK_PUSH
00CAB3  FF 36 FC 3A           PUSH   word ptr [0x3afc] ; PUSH_GLOBAL
00CAB7  FF 36 FE 3A           PUSH   word ptr [0x3afe] ; PUSH_GLOBAL
00CABB  6A 00                 PUSH   0 ; STACK_PUSH
00CABD  6A 00                 PUSH   0 ; STACK_PUSH
00CABF  8B 1E 90 00           MOV    bx, word ptr [0x90] ; GLOBAL_LOAD
00CAC3  FF 77 06              PUSH   word ptr [bx + 6] ; STACK_PUSH
00CAC6  FF 77 04              PUSH   word ptr [bx + 4] ; STACK_PUSH
00CAC9  FF 77 02              PUSH   word ptr [bx + 2] ; STACK_PUSH
00CACC  FF 37                 PUSH   word ptr [bx] ; STACK_PUSH
00CACE  FF 36 02 3B           PUSH   word ptr [0x3b02] ; PUSH_GLOBAL
00CAD2  FF 36 00 3B           PUSH   word ptr [0x3b00] ; PUSH_GLOBAL
00CAD6  FF 36 FE 3A           PUSH   word ptr [0x3afe] ; PUSH_GLOBAL
00CADA  FF 36 FC 3A           PUSH   word ptr [0x3afc] ; PUSH_GLOBAL
00CADE  9A 00 00 B9 0C        LCALL  0xcb9, 0 ; LCALL
00CAE3  83 C4 1C              ADD    sp, 0x1c ; STACK_CLEANUP
00CAE6  EB 17                 JMP    0xcaff ; JUMP
00CAE8  FF 36 02 3B           PUSH   word ptr [0x3b02] ; PUSH_GLOBAL
00CAEC  FF 36 00 3B           PUSH   word ptr [0x3b00] ; PUSH_GLOBAL
00CAF0  FF 36 FE 3A           PUSH   word ptr [0x3afe] ; PUSH_GLOBAL
00CAF4  FF 36 FC 3A           PUSH   word ptr [0x3afc] ; PUSH_GLOBAL
00CAF8  2A C0                 SUB    al, al ; ARITH
00CAFA  9A 0E 00 49 0C        LCALL  0xc49, 0xe ; LCALL
00CAFF  FF 36 D8 52           PUSH   word ptr [0x52d8] ; PUSH_GLOBAL
00CB03  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
00CB06  A1 F2 49              MOV    ax, word ptr [0x49f2] ; GLOBAL_LOAD
00CB09  8B 16 F4 49           MOV    dx, word ptr [0x49f4] ; GLOBAL_LOAD
00CB0D  8B 1E D4 52           MOV    bx, word ptr [0x52d4] ; GLOBAL_LOAD
00CB11  0E                    PUSH   cs ; STACK_PUSH
00CB12  E8 C1 FC              CALL   0xc7d6 ; CALL_NEAR
00CB15  C9                    LEAVE ; EPILOGUE
00CB16  CB                    RETF ; RETURN
