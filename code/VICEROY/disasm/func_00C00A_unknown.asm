; ============================================================================
; func_00C00A_unknown
; Region   : load_image
; Bytes    : file 0x00C00A..0x00C07A  (112 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00C00A  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
00C00E  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
00C013  A1 40 85              MOV    ax, word ptr [0x8540] ; GLOBAL_LOAD
00C016  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
00C019  8B 0E 3E 85           MOV    cx, word ptr [0x853e] ; GLOBAL_LOAD
00C01D  89 4E FA              MOV    word ptr [bp - 6], cx ; LOCAL_STORE
00C020  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
00C023  8A 87 B4 00           MOV    al, byte ptr [bx + 0xb4] ; MOV
00C027  98                    CWDE ; ARITH
00C028  03 06 40 85           ADD    ax, word ptr [0x8540] ; ARITH
00C02C  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
00C02F  8B D0                 MOV    dx, ax ; MOV
00C031  8A 87 BE 00           MOV    al, byte ptr [bx + 0xbe] ; MOV
00C035  98                    CWDE ; ARITH
00C036  03 C8                 ADD    cx, ax ; ARITH
00C038  89 4E F6              MOV    word ptr [bp - 0xa], cx ; LOCAL_STORE
00C03B  51                    PUSH   cx ; STACK_PUSH
00C03C  52                    PUSH   dx ; STACK_PUSH
00C03D  9A 0A 00 7F 03        LCALL  0x37f, 0xa ; LCALL
00C042  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00C045  0B C0                 OR     ax, ax ; LOGIC
00C047  75 03                 JNE    0xc04c ; CJUMP
00C049  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
00C04C  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
00C050  74 26                 JE     0xc078 ; CJUMP
00C052  6A 01                 PUSH   1 ; STACK_PUSH
00C054  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00C057  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00C05A  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
00C05D  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
00C060  0E                    PUSH   cs ; STACK_PUSH
00C061  E8 D8 FE              CALL   0xbf3c ; CALL_NEAR
00C064  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
00C067  FF 76 F6              PUSH   word ptr [bp - 0xa] ; PUSH_GLOBAL
00C06A  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
00C06D  0E                    PUSH   cs ; STACK_PUSH
00C06E  E8 B7 FC              CALL   0xbd28 ; CALL_NEAR
00C071  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00C074  0E                    PUSH   cs ; STACK_PUSH
00C075  E8 D2 FC              CALL   0xbd4a ; CALL_NEAR
00C078  C9                    LEAVE ; EPILOGUE
00C079  CB                    RETF ; RETURN
