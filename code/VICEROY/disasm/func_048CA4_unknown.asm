; ============================================================================
; func_048CA4_unknown
; Region   : overlay
; Bytes    : file 0x048CA4..0x048CF8  (84 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

048CA4  C8 20 00 00           ENTER  0x20, 0 ; PROLOGUE
048CA8  56                    PUSH   si ; STACK_PUSH
048CA9  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
048CAC  89 46 EE              MOV    word ptr [bp - 0x12], ax ; LOCAL_STORE
048CAF  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048CB3  8A 47 05              MOV    al, byte ptr [bx + 5] ; MOV
048CB6  25 0F 00              AND    ax, 0xf ; LOGIC
048CB9  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
048CBC  A1 4C 8D              MOV    ax, word ptr [0x8d4c] ; GLOBAL_LOAD
048CBF  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
048CC2  2B C0                 SUB    ax, ax ; ARITH
048CC4  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
048CC7  89 46 E8              MOV    word ptr [bp - 0x18], ax ; LOCAL_STORE
048CCA  89 46 F4              MOV    word ptr [bp - 0xc], ax ; LOCAL_STORE
048CCD  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
048CD0  89 46 EA              MOV    word ptr [bp - 0x16], ax ; LOCAL_STORE
048CD3  EB 75                 JMP    0x48d4a ; JUMP
048CD5  90                    NOP ; NOP
048CD6  39 46 EE              CMP    word ptr [bp - 0x12], ax ; CMP
048CD9  75 09                 JNE    0x48ce4 ; CJUMP
048CDB  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
048CDE  01 46 EC              ADD    word ptr [bp - 0x14], ax ; ARITH
048CE1  EB 07                 JMP    0x48cea ; JUMP
048CE3  90                    NOP ; NOP
048CE4  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
048CE7  01 46 F6              ADD    word ptr [bp - 0xa], ax ; ARITH
048CEA  8B 1E 4A 8D           MOV    bx, word ptr [0x8d4a] ; GLOBAL_LOAD
048CEE  80 7F 05 00           CMP    byte ptr [bx + 5], 0 ; CMP
048CF2  7C 53                 JL     0x48d47 ; CJUMP
048CF4  8A 47 05              MOV    al, byte ptr [bx + 5] ; MOV
048CF7  8B                    DB     0x8B ; DATA_BYTE
