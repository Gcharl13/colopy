; ============================================================================
; func_041C64_unknown
; Region   : overlay
; Bytes    : file 0x041C64..0x041CBD  (89 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

041C64  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
041C68  C7 46 FC 00 00        MOV    word ptr [bp - 4], 0 ; LOCAL_STORE
041C6D  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
041C70  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
041C73  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
041C78  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041C7B  0B C0                 OR     ax, ax ; LOGIC
041C7D  74 39                 JE     0x41cb8 ; CJUMP
041C7F  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
041C82  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
041C85  9A 8C 07 1F 18        LCALL  0x181f, 0x78c ; THUNK -> 0x03E4:0x003A (thunk @file 0x01AD7C type B) overlay @file 0x02842C
041C8A  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041C8D  3D 1A 00              CMP    ax, 0x1a ; CMP
041C90  75 26                 JNE    0x41cb8 ; CJUMP
041C92  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
041C95  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
041C98  9A 82 06 1F 18        LCALL  0x181f, 0x682 ; THUNK -> 0x037F:0x0314 (thunk @file 0x01AC72 type B) overlay @file 0x02EE50
041C9D  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
041CA0  0B C0                 OR     ax, ax ; LOGIC
041CA2  7C 0F                 JL     0x41cb3 ; CJUMP
041CA4  6B 5E 06 1C           IMUL   bx, word ptr [bp + 6], 0x1c ; ARITH
041CA8  8A 8F 47 31           MOV    cl, byte ptr [bx + 0x3147] ; MOV
041CAC  83 E1 0F              AND    cx, 0xf ; LOGIC
041CAF  3B C8                 CMP    cx, ax ; CMP
041CB1  75 05                 JNE    0x41cb8 ; CJUMP
041CB3  C7 46 FC 01 00        MOV    word ptr [bp - 4], 1 ; LOCAL_STORE
041CB8  8B 46 FC              MOV    ax, word ptr [bp - 4] ; LOCAL_LOAD
041CBB  C9                    LEAVE ; EPILOGUE
041CBC  CB                    RETF ; RETURN
