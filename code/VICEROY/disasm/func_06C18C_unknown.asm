; ============================================================================
; func_06C18C_unknown
; Region   : overlay
; Bytes    : file 0x06C18C..0x06C1CC  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06C18C  55                    PUSH   bp ; STACK_PUSH
06C18D  8B EC                 MOV    bp, sp ; MOV
06C18F  50                    PUSH   ax ; STACK_PUSH
06C190  83 3E 6C 1F 00        CMP    word ptr [0x1f6c], 0 ; CMP
06C195  74 69                 JE     0x6c200 ; CJUMP
06C197  80 7E 0A 07           CMP    byte ptr [bp + 0xa], 7 ; CMP
06C19B  75 63                 JNE    0x6c200 ; CJUMP
06C19D  83 3E 8A 1F 00        CMP    word ptr [0x1f8a], 0 ; CMP
06C1A2  74 28                 JE     0x6c1cc ; CJUMP
06C1A4  FF 36 A4 83           PUSH   word ptr [0x83a4] ; PUSH_GLOBAL
06C1A8  FF 36 A2 83           PUSH   word ptr [0x83a2] ; PUSH_GLOBAL
06C1AC  FF 36 A0 83           PUSH   word ptr [0x83a0] ; PUSH_GLOBAL
06C1B0  FF 36 9E 83           PUSH   word ptr [0x839e] ; PUSH_GLOBAL
06C1B4  FF 76 1A              PUSH   word ptr [bp + 0x1a] ; PUSH_GLOBAL
06C1B7  FF 76 18              PUSH   word ptr [bp + 0x18] ; PUSH_GLOBAL
06C1BA  FF 76 16              PUSH   word ptr [bp + 0x16] ; PUSH_GLOBAL
06C1BD  FF 76 14              PUSH   word ptr [bp + 0x14] ; PUSH_GLOBAL
06C1C0  FF 76 12              PUSH   word ptr [bp + 0x12] ; PUSH_GLOBAL
06C1C3  9A 44 04 1F 18        LCALL  0x181f, 0x444 ; THUNK -> 0x0B8F:0x0006 (thunk @file 0x01AA34 type B)
06C1C8  C9                    LEAVE ; EPILOGUE
06C1C9  C2 18 00              RET    0x18 ; RETURN
