; ============================================================================
; func_00D642_unknown
; Region   : load_image
; Bytes    : file 0x00D642..0x00D6C3  (129 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00D642  C8 A4 00 00           ENTER  0xa4, 0 ; PROLOGUE
00D646  8C D8                 MOV    ax, ds ; MOV
00D648  8E C0                 MOV    es, ax ; MOV
00D64A  56                    PUSH   si ; STACK_PUSH
00D64B  57                    PUSH   di ; STACK_PUSH
00D64C  8B 76 06              MOV    si, word ptr [bp + 6] ; LOCAL_LOAD
00D64F  8D 7E AD              LEA    di, [bp - 0x53] ; ADDR
00D652  B9 4F 00              MOV    cx, 0x4f ; CONST_LOAD
00D655  AC                    LODSB  al, byte ptr [si] ; STR
00D656  AA                    STOSB  byte ptr es:[di], al ; STR
00D657  0A C0                 OR     al, al ; LOGIC
00D659  E0 FA                 LOOPNE 0xd655 ; CJUMP
00D65B  5F                    POP    di ; STACK_POP
00D65C  5E                    POP    si ; STACK_POP
00D65D  8D 5E AD              LEA    bx, [bp - 0x53] ; ADDR
00D660  8D 8E 5C FF           LEA    cx, [bp - 0xa4] ; ADDR
00D664  1E                    PUSH   ds ; STACK_PUSH
00D665  53                    PUSH   bx ; STACK_PUSH
00D666  1E                    PUSH   ds ; STACK_PUSH
00D667  51                    PUSH   cx ; STACK_PUSH
00D668  9A B0 00 F6 09        LCALL  0x9f6, 0xb0 ; LCALL
00D66D  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
00D670  B8 24 35              MOV    ax, 0x3524 ; CONST_LOAD
00D673  CD 21                 INT    0x21 ; SYS
00D675  8C C0                 MOV    ax, es ; MOV
00D677  2E 89 1E 06 00        MOV    word ptr cs:[6], bx ; MOV
00D67C  2E A3 08 00           MOV    word ptr cs:[8], ax ; MOV
00D680  1E                    PUSH   ds ; STACK_PUSH
00D681  0E                    PUSH   cs ; STACK_PUSH
00D682  1F                    POP    ds ; STACK_POP
00D683  BA 0C 00              MOV    dx, 0xc ; CONST_LOAD
00D686  B8 24 25              MOV    ax, 0x2524 ; CONST_LOAD
00D689  CD 21                 INT    0x21 ; SYS
00D68B  1F                    POP    ds ; STACK_POP
00D68C  8D 9E 5C FF           LEA    bx, [bp - 0xa4] ; ADDR
00D690  8B D3                 MOV    dx, bx ; MOV
00D692  B8 00 3D              MOV    ax, 0x3d00 ; CONST_LOAD
00D695  CD 21                 INT    0x21 ; SYS
00D697  72 0E                 JB     0xd6a7 ; CJUMP
00D699  8B D8                 MOV    bx, ax ; MOV
00D69B  B4 3E                 MOV    ah, 0x3e ; CONST_LOAD
00D69D  CD 21                 INT    0x21 ; SYS
00D69F  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff ; LOCAL_STORE
00D6A4  EB 06                 JMP    0xd6ac ; JUMP
00D6A6  90                    NOP ; NOP
00D6A7  C7 46 FE 00 00        MOV    word ptr [bp - 2], 0 ; LOCAL_STORE
00D6AC  1E                    PUSH   ds ; STACK_PUSH
00D6AD  2E 8B 16 06 00        MOV    dx, word ptr cs:[6] ; MOV
00D6B2  2E A1 08 00           MOV    ax, word ptr cs:[8] ; MOV
00D6B6  8E D8                 MOV    ds, ax ; MOV
00D6B8  B8 24 25              MOV    ax, 0x2524 ; CONST_LOAD
00D6BB  CD 21                 INT    0x21 ; SYS
00D6BD  1F                    POP    ds ; STACK_POP
00D6BE  8B 46 FE              MOV    ax, word ptr [bp - 2] ; LOCAL_LOAD
00D6C1  C9                    LEAVE ; EPILOGUE
00D6C2  CB                    RETF ; RETURN
