; ============================================================================
; func_078C48_unknown
; Region   : overlay
; Bytes    : file 0x078C48..0x078C78  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

078C48  C8 04 00 00           ENTER  4, 0 ; PROLOGUE
078C4C  52                    PUSH   dx ; STACK_PUSH
078C4D  50                    PUSH   ax ; STACK_PUSH
078C4E  2B C9                 SUB    cx, cx ; ARITH
078C50  89 4E FE              MOV    word ptr [bp - 2], cx ; LOCAL_STORE
078C53  89 4E FC              MOV    word ptr [bp - 4], cx ; LOCAL_STORE
078C56  C4 5E 06              LES    bx, ptr [bp + 6] ; MOV_FAR
078C59  26 39 57 10           CMP    word ptr es:[bx + 0x10], dx ; CMP
078C5D  7F 25                 JG     0x78c84 ; CJUMP
078C5F  7C 06                 JL     0x78c67 ; CJUMP
078C61  26 39 47 0E           CMP    word ptr es:[bx + 0xe], ax ; CMP
078C65  73 1D                 JAE    0x78c84 ; CJUMP
078C67  52                    PUSH   dx ; STACK_PUSH
078C68  50                    PUSH   ax ; STACK_PUSH
078C69  26 FF 77 10           PUSH   word ptr es:[bx + 0x10] ; PUSH_GLOBAL
078C6D  26 FF 77 0E           PUSH   word ptr es:[bx + 0xe] ; PUSH_GLOBAL
078C71  26 8A 1F              MOV    bl, byte ptr es:[bx] ; MOV
078C74  2A FF                 SUB    bh, bh ; ARITH
078C76  B8                    DB     0xB8 ; DATA_BYTE
078C77  C3                    DB     0xC3 ; DATA_BYTE
