; ============================================================================
; func_004D1E_unknown
; Region   : load_image
; Bytes    : file 0x004D1E..0x004DF7  (217 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

004D1E  C8 08 00 00           ENTER  8, 0 ; PROLOGUE
004D22  56                    PUSH   si ; STACK_PUSH
004D23  9A 06 00 0C 0C        LCALL  0xc0c, 6 ; LCALL
004D28  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
004D2B  89 56 FE              MOV    word ptr [bp - 2], dx ; LOCAL_STORE
004D2E  83 3E 92 00 00        CMP    word ptr [0x92], 0 ; CMP
004D33  7C 13                 JL     0x4d48 ; CJUMP
004D35  2B 06 90 00           SUB    ax, word ptr [0x90] ; ARITH
004D39  1B 16 92 00           SBB    dx, word ptr [0x92] ; ARITH
004D3D  0B D2                 OR     dx, dx ; LOGIC
004D3F  7C 3F                 JL     0x4d80 ; CJUMP
004D41  7F 05                 JG     0x4d48 ; CJUMP
004D43  3D 3A 02              CMP    ax, 0x23a ; CMP
004D46  72 38                 JB     0x4d80 ; CJUMP
004D48  83 3E 8C 00 0A        CMP    word ptr [0x8c], 0xa ; CMP
004D4D  7C 15                 JL     0x4d64 ; CJUMP
004D4F  C7 06 8A 00 01 00     MOV    word ptr [0x8a], 1 ; GLOBAL_LOAD
004D55  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
004D58  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
004D5B  A3 90 00              MOV    word ptr [0x90], ax ; GLOBAL_LOAD
004D5E  89 16 92 00           MOV    word ptr [0x92], dx ; GLOBAL_LOAD
004D62  EB 1C                 JMP    0x4d80 ; JUMP
004D64  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
004D67  8B 56 FE              MOV    dx, word ptr [bp - 2] ; LOCAL_LOAD
004D6A  A3 90 00              MOV    word ptr [0x90], ax ; GLOBAL_LOAD
004D6D  89 16 92 00           MOV    word ptr [0x92], dx ; GLOBAL_LOAD
004D71  FF 06 8C 00           INC    word ptr [0x8c] ; ARITH
004D75  FF 36 8C 00           PUSH   word ptr [0x8c] ; PUSH_GLOBAL
004D79  0E                    PUSH   cs ; STACK_PUSH
004D7A  E8 F5 FD              CALL   0x4b72 ; CALL_NEAR
004D7D  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004D80  9A 02 00 E7 0A        LCALL  0xae7, 2 ; LCALL
004D85  0B C0                 OR     ax, ax ; LOGIC
004D87  74 38                 JE     0x4dc1 ; CJUMP
004D89  9A 16 00 E7 0A        LCALL  0xae7, 0x16 ; LCALL
004D8E  8B F0                 MOV    si, ax ; MOV
004D90  0E                    PUSH   cs ; STACK_PUSH
004D91  E8 66 FD              CALL   0x4afa ; CALL_NEAR
004D94  C7 06 8A 00 01 00     MOV    word ptr [0x8a], 1 ; GLOBAL_LOAD
004D9A  81 FE 2D 01           CMP    si, 0x12d ; CMP
004D9E  74 06                 JE     0x4da6 ; CJUMP
004DA0  81 FE 10 01           CMP    si, 0x110 ; CMP
004DA4  75 05                 JNE    0x4dab ; CJUMP
004DA6  C6 06 28 08 01        MOV    byte ptr [0x828], 1 ; GLOBAL_LOAD
004DAB  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
004DB0  74 0F                 JE     0x4dc1 ; CJUMP
004DB2  9A D4 03 1F 18        LCALL  0x181f, 0x3d4 ; THUNK -> 0x0000:0x014E (thunk @file 0x01A9C4 type A) overlay @file 0x025A4E
004DB7  6A 03                 PUSH   3 ; STACK_PUSH
004DB9  9A 0D 03 1D 0D        LCALL  0xd1d, 0x30d ; LCALL
004DBE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004DC1  8D 46 FA              LEA    ax, [bp - 6] ; ADDR
004DC4  50                    PUSH   ax ; STACK_PUSH
004DC5  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
004DC8  50                    PUSH   ax ; STACK_PUSH
004DC9  9A 8B 03 58 0A        LCALL  0xa58, 0x38b ; LCALL
004DCE  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
004DD1  0B C0                 OR     ax, ax ; LOGIC
004DD3  74 1C                 JE     0x4df1 ; CJUMP
004DD5  C7 06 8A 00 01 00     MOV    word ptr [0x8a], 1 ; GLOBAL_LOAD
004DDB  80 3E 28 08 00        CMP    byte ptr [0x828], 0 ; CMP
004DE0  74 0F                 JE     0x4df1 ; CJUMP
004DE2  9A D4 03 1F 18        LCALL  0x181f, 0x3d4 ; THUNK -> 0x0000:0x014E (thunk @file 0x01A9C4 type A) overlay @file 0x025A4E
004DE7  6A 03                 PUSH   3 ; STACK_PUSH
004DE9  9A 0D 03 1D 0D        LCALL  0xd1d, 0x30d ; LCALL
004DEE  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
004DF1  A1 8A 00              MOV    ax, word ptr [0x8a] ; GLOBAL_LOAD
004DF4  5E                    POP    si ; STACK_POP
004DF5  C9                    LEAVE ; EPILOGUE
004DF6  CB                    RETF ; RETURN
