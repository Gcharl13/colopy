; ============================================================================
; func_06C6EA_unknown
; Region   : overlay
; Bytes    : file 0x06C6EA..0x06C742  (88 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C6EA  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
06C6EE  50                    PUSH   ax ; STACK_PUSH
06C6EF  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
06C6F4  2B C0                 SUB    ax, ax ; ARITH
06C6F6  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
06C6F9  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
06C6FC  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
06C6FF  26 8B 47 54           MOV    ax, word ptr es:[bx + 0x54] ; MOV
06C703  26 8B 57 56           MOV    dx, word ptr es:[bx + 0x56] ; MOV
06C707  EB 2B                 JMP    0x6c734 ; JUMP
06C709  90                    NOP ; NOP
06C70A  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
06C70D  0B 46 FA              OR     ax, word ptr [bp - 6] ; LOGIC
06C710  74 2E                 JE     0x6c740 ; CJUMP
06C712  8B 46 F4              MOV    ax, word ptr [bp - 0xc] ; LOCAL_LOAD
06C715  C4 5E FA              LES    bx, ptr [bp - 6] ; MOV_FAR
06C718  26 39 47 04           CMP    word ptr es:[bx + 4], ax ; CMP
06C71C  75 0E                 JNE    0x6c72c ; CJUMP
06C71E  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
06C723  89 5E F6              MOV    word ptr [bp - 0xa], bx ; LOCAL_STORE
06C726  8C 46 F8              MOV    word ptr [bp - 8], es ; LOCAL_STORE
06C729  EB 0F                 JMP    0x6c73a ; JUMP
06C72B  90                    NOP ; NOP
06C72C  26 8B 47 10           MOV    ax, word ptr es:[bx + 0x10] ; MOV
06C730  26 8B 57 12           MOV    dx, word ptr es:[bx + 0x12] ; MOV
06C734  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
06C737  89 56 FC              MOV    word ptr [bp - 4], dx ; LOCAL_STORE
06C73A  83 7E FE 00           CMP    word ptr [bp - 2], 0 ; CMP
06C73E  74 CA                 JE     0x6c70a ; CJUMP
06C740  8B                    DB     0x8B ; DATA_BYTE
06C741  46                    DB     0x46 ; DATA_BYTE
