; ============================================================================
; func_053A34_unknown
; Region   : overlay
; Bytes    : file 0x053A34..0x053A73  (63 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

053A34  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
053A38  50                    PUSH   ax ; STACK_PUSH
053A39  C7 46 FE 01 00        MOV    word ptr [bp - 2], 1 ; LOCAL_STORE
053A3E  0B C0                 OR     ax, ax ; LOGIC
053A40  7C 4A                 JL     0x53a8c ; CJUMP
053A42  50                    PUSH   ax ; STACK_PUSH
053A43  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
053A48  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
053A4B  0B C0                 OR     ax, ax ; LOGIC
053A4D  75 3D                 JNE    0x53a8c ; CJUMP
053A4F  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
053A52  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
053A55  9A 8C 0B 1F 18        LCALL  0x181f, 0xb8c ; THUNK -> 0x05EB:0x3650 (thunk @file 0x01B17C type B) overlay @file 0x02A640
053A5A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
053A5D  0B C0                 OR     ax, ax ; LOGIC
053A5F  74 0D                 JE     0x53a6e ; CJUMP
053A61  8A 46 FC              MOV    al, byte ptr [bp - 4] ; LOCAL_LOAD
053A64  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
053A68  88 87 94 00           MOV    byte ptr [bx + 0x94], al ; MOV
053A6C  EB 1E                 JMP    0x53a8c ; JUMP
053A6E  8B 5E FC              MOV    bx, word ptr [bp - 4] ; LOCAL_LOAD
053A71  8B C3                 MOV    ax, bx ; MOV
