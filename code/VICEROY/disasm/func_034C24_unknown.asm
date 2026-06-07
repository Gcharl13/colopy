; ============================================================================
; func_034C24_unknown
; Region   : overlay
; Bytes    : file 0x034C24..0x034C94  (112 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

034C24  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
034C28  56                    PUSH   si ; STACK_PUSH
034C29  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
034C2E  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
034C32  74 03                 JE     0x34c37 ; CJUMP
034C34  E9 8B 01              JMP    0x34dc2 ; JUMP
034C37  83 3E 12 9E 04        CMP    word ptr [0x9e12], 4 ; CMP
034C3C  7D 16                 JGE    0x34c54 ; CJUMP
034C3E  6B 1E 12 9E 34        IMUL   bx, word ptr [0x9e12], 0x34 ; ARITH
034C43  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
034C48  75 0A                 JNE    0x34c54 ; CJUMP
034C4A  A0 A6 53              MOV    al, byte ptr [0x53a6] ; GLOBAL_LOAD
034C4D  2A E4                 SUB    ah, ah ; ARITH
034C4F  89 46 F8              MOV    word ptr [bp - 8], ax ; LOCAL_STORE
034C52  EB 05                 JMP    0x34c59 ; JUMP
034C54  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
034C59  6A 0F                 PUSH   0xf ; PUSH_CONST
034C5B  6A 01                 PUSH   1 ; STACK_PUSH
034C5D  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
034C62  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
034C65  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
034C68  8B 4E F8              MOV    cx, word ptr [bp - 8] ; LOCAL_LOAD
034C6B  41                    INC    cx ; ARITH
034C6C  41                    INC    cx ; ARITH
034C6D  D1 F9                 SAR    cx, 1 ; LOGIC
034C6F  3B C8                 CMP    cx, ax ; CMP
034C71  7C 21                 JL     0x34c94 ; CJUMP
034C73  6A 14                 PUSH   0x14 ; PUSH_CONST
034C75  FF 36 12 9E           PUSH   word ptr [0x9e12] ; PUSH_GLOBAL
034C79  9A B4 07 1F 18        LCALL  0x181f, 0x7b4 ; THUNK -> 0x0981:0x0000 (thunk @file 0x01ADA4 type B)
034C7E  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
034C81  3D 01 00              CMP    ax, 1 ; CMP
034C84  1B C0                 SBB    ax, ax ; ARITH
034C86  24 FE                 AND    al, 0xfe ; LOGIC
034C88  05 1C 00              ADD    ax, 0x1c ; ARITH
034C8B  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
034C8E  8A 46 F6              MOV    al, byte ptr [bp - 0xa] ; LOCAL_LOAD
034C91  5E                    POP    si ; STACK_POP
034C92  C9                    LEAVE ; EPILOGUE
034C93  CB                    RETF ; RETURN
