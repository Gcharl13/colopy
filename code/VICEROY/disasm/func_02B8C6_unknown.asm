; ============================================================================
; func_02B8C6_unknown
; Region   : overlay
; Bytes    : file 0x02B8C6..0x02B90C  (70 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02B8C6  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
02B8CA  A1 42 03              MOV    ax, word ptr [0x342] ; GLOBAL_LOAD
02B8CD  89 46 F6              MOV    word ptr [bp - 0xa], ax ; LOCAL_STORE
02B8D0  C7 06 42 03 FF FF     MOV    word ptr [0x342], 0xffff ; GLOBAL_LOAD
02B8D6  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
02B8DA  80 BF 94 00 00        CMP    byte ptr [bx + 0x94], 0 ; CMP
02B8DF  7C 39                 JL     0x2b91a ; CJUMP
02B8E1  8D 46 F8              LEA    ax, [bp - 8] ; ADDR
02B8E4  50                    PUSH   ax ; STACK_PUSH
02B8E5  8D 4E FA              LEA    cx, [bp - 6] ; ADDR
02B8E8  51                    PUSH   cx ; STACK_PUSH
02B8E9  FF 36 A2 93           PUSH   word ptr [0x93a2] ; PUSH_GLOBAL
02B8ED  0E                    PUSH   cs ; STACK_PUSH
02B8EE  E8 CE 10              CALL   0x2c9bf ; CALL_NEAR
02B8F1  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
02B8F4  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
02B8F7  FF 76 FA              PUSH   word ptr [bp - 6] ; STACK_PUSH
02B8FA  B8 8A 00              MOV    ax, 0x8a ; CONST_LOAD
02B8FD  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
02B900  50                    PUSH   ax ; STACK_PUSH
02B901  B8 D8 00              MOV    ax, 0xd8 ; CONST_LOAD
02B904  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
02B907  50                    PUSH   ax ; STACK_PUSH
02B908  9A                    DB     0x9A ; DATA_BYTE
02B909  CA                    DB     0xCA ; DATA_BYTE
02B90A  03                    DB     0x03 ; DATA_BYTE
02B90B  1F                    DB     0x1F ; DATA_BYTE
