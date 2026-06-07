; ============================================================================
; func_02A31C_unknown
; Region   : overlay
; Bytes    : file 0x02A31C..0x02A362  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; Tagged: "BUILD"  (auto-named via string xrefs)
; ============================================================================

02A31C  C8 18 00 00           ENTER  0x18, 0 ; PROLOGUE
02A320  B8 FF FF              MOV    ax, 0xffff ; CONST_LOAD
02A323  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
02A326  89 46 F0              MOV    word ptr [bp - 0x10], ax ; LOCAL_STORE
02A329  C7 46 FE 39 03        MOV    word ptr [bp - 2], 0x339 ; LOCAL_STORE
02A32E  C7 46 F4 37 03        MOV    word ptr [bp - 0xc], 0x337 ; LOCAL_STORE
02A333  8D 46 EA              LEA    ax, [bp - 0x16] ; ADDR
02A336  50                    PUSH   ax ; STACK_PUSH
02A337  8D 46 EE              LEA    ax, [bp - 0x12] ; ADDR
02A33A  50                    PUSH   ax ; STACK_PUSH
02A33B  8D 46 FC              LEA    ax, [bp - 4] ; ADDR
02A33E  50                    PUSH   ax ; STACK_PUSH
02A33F  B8 44 00              MOV    ax, 0x44 ; CONST_LOAD
02A342  89 46 EC              MOV    word ptr [bp - 0x14], ax ; LOCAL_STORE
02A345  50                    PUSH   ax ; STACK_PUSH
02A346  B8 03 00              MOV    ax, 3 ; MOV
02A349  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
02A34C  50                    PUSH   ax ; STACK_PUSH
02A34D  0E                    PUSH   cs ; STACK_PUSH
02A34E  E8 8B 27              CALL   0x2cadc ; CALL_NEAR
02A351  83 C4 0A              ADD    sp, 0xa ; STACK_CLEANUP
02A354  6A 2D                 PUSH   0x2d ; PUSH_CONST
02A356  6A 11                 PUSH   0x11 ; PUSH_CONST
02A358  68 84 00              PUSH   0x84                         ; STRING: "BUILD"
02A35B  68 2F 01              PUSH   0x12f ; PUSH_CONST
02A35E  9A                    DB     0x9A ; DATA_BYTE
02A35F  CA                    DB     0xCA ; DATA_BYTE
02A360  03                    DB     0x03 ; DATA_BYTE
02A361  1F                    DB     0x1F ; DATA_BYTE
