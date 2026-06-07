; ============================================================================
; func_06BF66_unknown
; Region   : overlay
; Bytes    : file 0x06BF66..0x06BF90  (42 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

06BF66  C8 8C 00 00           ENTER  0x8c, 0 ; PROLOGUE
06BF6A  57                    PUSH   di ; STACK_PUSH
06BF6B  56                    PUSH   si ; STACK_PUSH
06BF6C  C4 5E 04              LES    bx, ptr [bp + 4] ; MOV_FAR
06BF6F  26 8B 47 6E           MOV    ax, word ptr es:[bx + 0x6e] ; MOV
06BF73  26 0B 47 6C           OR     ax, word ptr es:[bx + 0x6c] ; LOGIC
06BF77  75 03                 JNE    0x6bf7c ; CJUMP
06BF79  E9 0A 02              JMP    0x6c186 ; JUMP
06BF7C  83 3E 5C 1F 07        CMP    word ptr [0x1f5c], 7 ; CMP
06BF81  7E 05                 JLE    0x6bf88 ; CJUMP
06BF83  B8 01 00              MOV    ax, 1 ; MOV
06BF86  EB 02                 JMP    0x6bf8a ; JUMP
06BF88  2B C0                 SUB    ax, ax ; ARITH
06BF8A  89 86 7A FF           MOV    word ptr [bp - 0x86], ax ; LOCAL_STORE
06BF8E  8B C3                 MOV    ax, bx ; MOV
