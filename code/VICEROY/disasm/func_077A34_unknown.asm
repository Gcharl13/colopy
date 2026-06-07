; ============================================================================
; func_077A34_unknown
; Region   : overlay
; Bytes    : file 0x077A34..0x077A6A  (54 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

077A34  C8 58 00 00           ENTER  0x58, 0 ; PROLOGUE
077A38  53                    PUSH   bx ; STACK_PUSH
077A39  56                    PUSH   si ; STACK_PUSH
077A3A  C7 46 AE 01 00        MOV    word ptr [bp - 0x52], 1 ; LOCAL_STORE
077A3F  1E                    PUSH   ds ; STACK_PUSH
077A40  53                    PUSH   bx ; STACK_PUSH
077A41  8D 1E C8 24           LEA    bx, [0x24c8] ; ADDR
077A45  9A 86 0E 1F 18        LCALL  0x181f, 0xe86 ; THUNK -> 0x09F6:0x00FA (thunk @file 0x01B476 type B) overlay @file 0x030D60
077A4A  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
077A4D  0B C0                 OR     ax, ax ; LOGIC
077A4F  74 78                 JE     0x77ac9 ; CJUMP
077A51  C7 46 AC 01 00        MOV    word ptr [bp - 0x54], 1 ; LOCAL_STORE
077A56  8B 5E A8              MOV    bx, word ptr [bp - 0x58] ; LOCAL_LOAD
077A59  F6 47 06 10           TEST   byte ptr [bx + 6], 0x10 ; LOGIC
077A5D  75 6A                 JNE    0x77ac9 ; CJUMP
077A5F  53                    PUSH   bx ; STACK_PUSH
077A60  6A 4F                 PUSH   0x4f ; PUSH_CONST
077A62  8D 46 B0              LEA    ax, [bp - 0x50] ; ADDR
077A65  50                    PUSH   ax ; STACK_PUSH
077A66  9A                    DB     0x9A ; DATA_BYTE
077A67  CA                    DB     0xCA ; DATA_BYTE
077A68  09                    DB     0x09 ; DATA_BYTE
077A69  1D                    DB     0x1D ; DATA_BYTE
