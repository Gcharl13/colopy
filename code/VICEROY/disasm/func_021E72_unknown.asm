; ============================================================================
; func_021E72_unknown
; Region   : overlay
; Bytes    : file 0x021E72..0x021EBA  (72 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

021E72  55                    PUSH   bp ; STACK_PUSH
021E73  8B EC                 MOV    bp, sp ; MOV
021E75  8B 46 06              MOV    ax, word ptr [bp + 6] ; LOCAL_LOAD
021E78  0B C0                 OR     ax, ax ; LOGIC
021E7A  7D 02                 JGE    0x21e7e ; CJUMP
021E7C  2B C0                 SUB    ax, ax ; ARITH
021E7E  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
021E81  3D 03 00              CMP    ax, 3 ; CMP
021E84  7E 03                 JLE    0x21e89 ; CJUMP
021E86  B8 03 00              MOV    ax, 3 ; MOV
021E89  89 46 06              MOV    word ptr [bp + 6], ax ; LOCAL_STORE
021E8C  A3 84 01              MOV    word ptr [0x184], ax ; GLOBAL_LOAD
021E8F  9A 8E 01 1F 19        LCALL  0x191f, 0x18e ; THUNK -> 0x0000:0x000C (thunk @file 0x01B77E type A) overlay @file 0x02590C
021E94  6A 00                 PUSH   0 ; STACK_PUSH
021E96  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
021E9A  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
021E9E  FF 36 3E 85           PUSH   word ptr [0x853e] ; PUSH_GLOBAL
021EA2  FF 36 40 85           PUSH   word ptr [0x8540] ; PUSH_GLOBAL
021EA6  9A 52 03 1F 18        LCALL  0x181f, 0x352 ; THUNK -> 0x0984:0x02FC (thunk @file 0x01A942 type B) overlay @file 0x032212
021EAB  8B E5                 MOV    sp, bp ; MOV
021EAD  0B C0                 OR     ax, ax ; LOGIC
021EAF  75 07                 JNE    0x21eb8 ; CJUMP
021EB1  6A 01                 PUSH   1 ; STACK_PUSH
021EB3  9A 1C 0E 1F 18        LCALL  0x181f, 0xe1c ; THUNK -> 0x0000:0x00C0 (thunk @file 0x01B40C type A) overlay @file 0x0259C0
021EB8  C9                    LEAVE ; EPILOGUE
021EB9  CB                    RETF ; RETURN
