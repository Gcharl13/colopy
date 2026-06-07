; ============================================================================
; func_042F20_unknown
; Region   : overlay
; Bytes    : file 0x042F20..0x042F58  (56 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

042F20  55                    PUSH   bp ; STACK_PUSH
042F21  8B EC                 MOV    bp, sp ; MOV
042F23  FF 76 0A              PUSH   word ptr [bp + 0xa] ; PUSH_GLOBAL
042F26  FF 76 08              PUSH   word ptr [bp + 8] ; STACK_PUSH
042F29  9A 02 03 1F 18        LCALL  0x181f, 0x302 ; THUNK -> 0x037F:0x000A (thunk @file 0x01A8F2 type B) overlay @file 0x02EB46
042F2E  8B E5                 MOV    sp, bp ; MOV
042F30  0B C0                 OR     ax, ax ; LOGIC
042F32  75 2A                 JNE    0x42f5e ; CJUMP
042F34  39 46 0C              CMP    word ptr [bp + 0xc], ax ; CMP
042F37  7C 1F                 JL     0x42f58 ; CJUMP
042F39  8A 46 0C              MOV    al, byte ptr [bp + 0xc] ; LOCAL_LOAD
042F3C  2A 46 08              SUB    al, byte ptr [bp + 8] ; ARITH
042F3F  3C 14                 CMP    al, 0x14 ; CMP
042F41  75 15                 JNE    0x42f58 ; CJUMP
042F43  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
042F46  D1 E3                 SHL    bx, 1 ; LOGIC
042F48  FF B7 8C 83           PUSH   word ptr [bx - 0x7c74] ; PUSH_GLOBAL
042F4C  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
042F4F  9A 6E 01 1F 18        LCALL  0x181f, 0x16e ; THUNK -> 0x004B:0x00E2 (thunk @file 0x01A75E type B) overlay @file 0x06048A
042F54  8B E5                 MOV    sp, bp ; MOV
042F56  C9                    LEAVE ; EPILOGUE
042F57  CB                    RETF ; RETURN
