; ============================================================================
; func_00B900_unknown
; Region   : load_image
; Bytes    : file 0x00B900..0x00B939  (57 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00B900  C8 12 00 00           ENTER  0x12, 0 ; PROLOGUE
00B904  56                    PUSH   si ; STACK_PUSH
00B905  C7 46 EE 01 00        MOV    word ptr [bp - 0x12], 1 ; LOCAL_STORE
00B90A  8D 46 F4              LEA    ax, [bp - 0xc] ; ADDR
00B90D  50                    PUSH   ax ; STACK_PUSH
00B90E  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
00B911  0E                    PUSH   cs ; STACK_PUSH
00B912  E8 93 FC              CALL   0xb5a8 ; CALL_NEAR
00B915  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
00B918  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
00B91B  0B C0                 OR     ax, ax ; LOGIC
00B91D  75 03                 JNE    0xb922 ; CJUMP
00B91F  E9 42 02              JMP    0xbb64 ; JUMP
00B922  3D 01 00              CMP    ax, 1 ; CMP
00B925  74 03                 JE     0xb92a ; CJUMP
00B927  E9 A2 01              JMP    0xbacc ; JUMP
00B92A  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
00B92D  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
00B931  8A 47 1F              MOV    al, byte ptr [bx + 0x1f] ; MOV
00B934  8B 5E F4              MOV    bx, word ptr [bp - 0xc] ; LOCAL_LOAD
00B937  8B CB                 MOV    cx, bx ; MOV
