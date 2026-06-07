; ============================================================================
; func_03D948_unknown
; Region   : overlay
; Bytes    : file 0x03D948..0x03D979  (49 bytes)
; Purpose  : French intervention force (revolution aid)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

03D948  C8 06 00 00           ENTER  6, 0 ; PROLOGUE
03D94C  C7 46 FC FF FF        MOV    word ptr [bp - 4], 0xffff ; LOCAL_STORE
03D951  2B C0                 SUB    ax, ax ; ARITH
03D953  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
03D956  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
03D959  EB 40                 JMP    0x3d99b ; JUMP
03D95B  90                    NOP ; NOP
03D95C  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
03D95F  9A E6 09 1F 18        LCALL  0x181f, 0x9e6 ; THUNK -> 0x05EB:0x002C (thunk @file 0x01AFD6 type B) overlay @file 0x02701C
03D964  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
03D967  A0 98 53              MOV    al, byte ptr [0x5398] ; GLOBAL_LOAD
03D96A  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
03D96E  38 47 1A              CMP    byte ptr [bx + 0x1a], al ; CMP
03D971  75 25                 JNE    0x3d998 ; CJUMP
03D973  69 5E FA CA 00        IMUL   bx, word ptr [bp - 6], 0xca ; ARITH
03D978  F6                    DB     0xF6 ; DATA_BYTE
