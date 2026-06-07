; ============================================================================
; func_045A1E_unknown
; Region   : overlay
; Bytes    : file 0x045A1E..0x045ADE  (192 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

045A1E  C8 14 00 00           ENTER  0x14, 0 ; PROLOGUE
045A22  50                    PUSH   ax ; STACK_PUSH
045A23  57                    PUSH   di ; STACK_PUSH
045A24  56                    PUSH   si ; STACK_PUSH
045A25  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
045A28  2B C0                 SUB    ax, ax ; ARITH
045A2A  99                    CDQ ; ARITH
045A2B  8B C8                 MOV    cx, ax ; MOV
045A2D  89 56 F4              MOV    word ptr [bp - 0xc], dx ; LOCAL_STORE
045A30  26 8B 44 38           MOV    ax, word ptr es:[si + 0x38] ; MOV
045A34  26 8B 54 3A           MOV    dx, word ptr es:[si + 0x3a] ; MOV
045A38  8B D8                 MOV    bx, ax ; MOV
045A3A  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
045A3D  2B FF                 SUB    di, di ; ARITH
045A3F  89 7E EC              MOV    word ptr [bp - 0x14], di ; LOCAL_STORE
045A42  26 89 3C              MOV    word ptr es:[si], di ; MOV
045A45  89 7E FA              MOV    word ptr [bp - 6], di ; LOCAL_STORE
045A48  89 4E F2              MOV    word ptr [bp - 0xe], cx ; LOCAL_STORE
045A4B  0B D0                 OR     dx, ax ; LOGIC
045A4D  74 74                 JE     0x45ac3 ; CJUMP
045A4F  8B F1                 MOV    si, cx ; MOV
045A51  8B 4E FA              MOV    cx, word ptr [bp - 6] ; LOCAL_LOAD
045A54  0B C9                 OR     cx, cx ; LOGIC
045A56  75 68                 JNE    0x45ac0 ; CJUMP
045A58  8E 46 F0              MOV    es, word ptr [bp - 0x10] ; LOCAL_LOAD
045A5B  26 F6 47 0C 01        TEST   byte ptr es:[bx + 0xc], 1 ; LOGIC
045A60  75 4A                 JNE    0x45aac ; CJUMP
045A62  26 8B 47 1E           MOV    ax, word ptr es:[bx + 0x1e] ; MOV
045A66  26 8B 57 20           MOV    dx, word ptr es:[bx + 0x20] ; MOV
045A6A  8B F0                 MOV    si, ax ; MOV
045A6C  89 56 F4              MOV    word ptr [bp - 0xc], dx ; LOCAL_STORE
045A6F  0B D0                 OR     dx, ax ; LOGIC
045A71  74 39                 JE     0x45aac ; CJUMP
045A73  89 5E EE              MOV    word ptr [bp - 0x12], bx ; LOCAL_STORE
045A76  8B 5E EA              MOV    bx, word ptr [bp - 0x16] ; LOCAL_LOAD
045A79  0B C9                 OR     cx, cx ; LOGIC
045A7B  75 29                 JNE    0x45aa6 ; CJUMP
045A7D  8E 46 F4              MOV    es, word ptr [bp - 0xc] ; LOCAL_LOAD
045A80  26 39 5C 02           CMP    word ptr es:[si + 2], bx ; CMP
045A84  75 0C                 JNE    0x45a92 ; CJUMP
045A86  26 F6 04 03           TEST   byte ptr es:[si], 3 ; LOGIC
045A8A  75 06                 JNE    0x45a92 ; CJUMP
045A8C  B9 01 00              MOV    cx, 1 ; MOV
045A8F  EB 0E                 JMP    0x45a9f ; JUMP
045A91  90                    NOP ; NOP
045A92  26 8B 44 0E           MOV    ax, word ptr es:[si + 0xe] ; MOV
045A96  26 8B 54 10           MOV    dx, word ptr es:[si + 0x10] ; MOV
045A9A  8B F0                 MOV    si, ax ; MOV
045A9C  89 56 F4              MOV    word ptr [bp - 0xc], dx ; LOCAL_STORE
045A9F  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
045AA2  0B C6                 OR     ax, si ; LOGIC
045AA4  75 D3                 JNE    0x45a79 ; CJUMP
045AA6  89 4E FA              MOV    word ptr [bp - 6], cx ; LOCAL_STORE
045AA9  8B 5E EE              MOV    bx, word ptr [bp - 0x12] ; LOCAL_LOAD
045AAC  8E 46 F0              MOV    es, word ptr [bp - 0x10] ; LOCAL_LOAD
045AAF  26 8B 47 16           MOV    ax, word ptr es:[bx + 0x16] ; MOV
045AB3  26 8B 57 18           MOV    dx, word ptr es:[bx + 0x18] ; MOV
045AB7  8B D8                 MOV    bx, ax ; MOV
045AB9  89 56 F0              MOV    word ptr [bp - 0x10], dx ; LOCAL_STORE
045ABC  0B D0                 OR     dx, ax ; LOGIC
045ABE  75 91                 JNE    0x45a51 ; CJUMP
045AC0  89 76 F2              MOV    word ptr [bp - 0xe], si ; LOCAL_STORE
045AC3  8B 5E EC              MOV    bx, word ptr [bp - 0x14] ; LOCAL_LOAD
045AC6  8B 7E F2              MOV    di, word ptr [bp - 0xe] ; LOCAL_LOAD
045AC9  83 7E FA 00           CMP    word ptr [bp - 6], 0 ; CMP
045ACD  74 0D                 JE     0x45adc ; CJUMP
045ACF  8E 46 F4              MOV    es, word ptr [bp - 0xc] ; LOCAL_LOAD
045AD2  26 8B 5D 04           MOV    bx, word ptr es:[di + 4] ; MOV
045AD6  C4 76 06              LES    si, ptr [bp + 6] ; MOV_FAR
045AD9  26 89 1C              MOV    word ptr es:[si], bx ; MOV
045ADC  8B C3                 MOV    ax, bx ; MOV
