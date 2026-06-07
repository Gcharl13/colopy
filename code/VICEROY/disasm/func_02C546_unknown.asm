; ============================================================================
; func_02C546_unknown
; Region   : overlay
; Bytes    : file 0x02C546..0x02C5D3  (141 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02C546  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
02C54A  A0 9B 0B              MOV    al, byte ptr [0xb9b] ; GLOBAL_LOAD
02C54D  88 46 FC              MOV    byte ptr [bp - 4], al ; LOCAL_STORE
02C550  A0 9D 0B              MOV    al, byte ptr [0xb9d] ; GLOBAL_LOAD
02C553  88 46 FA              MOV    byte ptr [bp - 6], al ; LOCAL_STORE
02C556  A0 9F 0B              MOV    al, byte ptr [0xb9f] ; GLOBAL_LOAD
02C559  88 46 FE              MOV    byte ptr [bp - 2], al ; LOCAL_STORE
02C55C  2A C0                 SUB    al, al ; ARITH
02C55E  A2 9B 0B              MOV    byte ptr [0xb9b], al ; GLOBAL_LOAD
02C561  A2 9D 0B              MOV    byte ptr [0xb9d], al ; GLOBAL_LOAD
02C564  A2 9F 0B              MOV    byte ptr [0xb9f], al ; GLOBAL_LOAD
02C567  0E                    PUSH   cs ; STACK_PUSH
02C568  E8 12 05              CALL   0x2ca7d ; CALL_NEAR
02C56B  80 3E 9B 0B 00        CMP    byte ptr [0xb9b], 0 ; CMP
02C570  75 0F                 JNE    0x2c581 ; CJUMP
02C572  80 7E FC 00           CMP    byte ptr [bp - 4], 0 ; CMP
02C576  74 09                 JE     0x2c581 ; CJUMP
02C578  6A 01                 PUSH   1 ; STACK_PUSH
02C57A  0E                    PUSH   cs ; STACK_PUSH
02C57B  E8 00 04              CALL   0x2c97e ; CALL_NEAR
02C57E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C581  80 3E 9D 0B 00        CMP    byte ptr [0xb9d], 0 ; CMP
02C586  75 0F                 JNE    0x2c597 ; CJUMP
02C588  80 7E FA 00           CMP    byte ptr [bp - 6], 0 ; CMP
02C58C  74 09                 JE     0x2c597 ; CJUMP
02C58E  6A 01                 PUSH   1 ; STACK_PUSH
02C590  0E                    PUSH   cs ; STACK_PUSH
02C591  E8 85 04              CALL   0x2ca19 ; CALL_NEAR
02C594  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C597  80 3E 9F 0B 00        CMP    byte ptr [0xb9f], 0 ; CMP
02C59C  75 0F                 JNE    0x2c5ad ; CJUMP
02C59E  80 7E FE 00           CMP    byte ptr [bp - 2], 0 ; CMP
02C5A2  74 09                 JE     0x2c5ad ; CJUMP
02C5A4  6A 01                 PUSH   1 ; STACK_PUSH
02C5A6  0E                    PUSH   cs ; STACK_PUSH
02C5A7  E8 F7 03              CALL   0x2c9a1 ; CALL_NEAR
02C5AA  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02C5AD  80 3E 9B 0B 00        CMP    byte ptr [0xb9b], 0 ; CMP
02C5B2  75 05                 JNE    0x2c5b9 ; CJUMP
02C5B4  C6 06 9A 0B FE        MOV    byte ptr [0xb9a], 0xfe ; GLOBAL_LOAD
02C5B9  80 3E 9D 0B 00        CMP    byte ptr [0xb9d], 0 ; CMP
02C5BE  75 05                 JNE    0x2c5c5 ; CJUMP
02C5C0  C6 06 9C 0B FE        MOV    byte ptr [0xb9c], 0xfe ; GLOBAL_LOAD
02C5C5  80 3E 9F 0B 00        CMP    byte ptr [0xb9f], 0 ; CMP
02C5CA  75 05                 JNE    0x2c5d1 ; CJUMP
02C5CC  C6 06 9E 0B FE        MOV    byte ptr [0xb9e], 0xfe ; GLOBAL_LOAD
02C5D1  C9                    LEAVE ; EPILOGUE
02C5D2  C3                    RET ; RETURN
