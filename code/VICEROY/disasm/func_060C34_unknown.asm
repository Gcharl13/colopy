; ============================================================================
; func_060C34_unknown
; Region   : overlay
; Bytes    : file 0x060C34..0x060CDF  (171 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

060C34  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
060C38  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
060C3C  26 8A 47 21           MOV    al, byte ptr es:[bx + 0x21] ; MOV
060C40  2A E4                 SUB    ah, ah ; ARITH
060C42  3B 06 5E A1           CMP    ax, word ptr [0xa15e] ; CMP
060C46  7F 40                 JG     0x60c88 ; CJUMP
060C48  A3 5E A1              MOV    word ptr [0xa15e], ax ; GLOBAL_LOAD
060C4B  50                    PUSH   ax ; STACK_PUSH
060C4C  0E                    PUSH   cs ; STACK_PUSH
060C4D  E8 B9 07              CALL   0x61409 ; CALL_NEAR
060C50  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060C53  6A 01                 PUSH   1 ; STACK_PUSH
060C55  6A 00                 PUSH   0 ; STACK_PUSH
060C57  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
060C5B  26 FF 77 22           PUSH   word ptr es:[bx + 0x22] ; PUSH_GLOBAL
060C5F  FF 36 60 A1           PUSH   word ptr [0xa160] ; PUSH_GLOBAL
060C63  0E                    PUSH   cs ; STACK_PUSH
060C64  E8 93 07              CALL   0x613fa ; CALL_NEAR
060C67  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
060C6A  89 46 FE              MOV    word ptr [bp - 2], ax ; LOCAL_STORE
060C6D  0B C0                 OR     ax, ax ; LOGIC
060C6F  7C 68                 JL     0x60cd9 ; CJUMP
060C71  3D E8 03              CMP    ax, 0x3e8 ; CMP
060C74  74 63                 JE     0x60cd9 ; CJUMP
060C76  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
060C7A  26 FE 47 21           INC    byte ptr es:[bx + 0x21] ; ARITH
060C7E  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
060C81  0E                    PUSH   cs ; STACK_PUSH
060C82  E8 9D 07              CALL   0x61422 ; CALL_NEAR
060C85  EB 4F                 JMP    0x60cd6 ; JUMP
060C87  90                    NOP ; NOP
060C88  FF 36 5E A1           PUSH   word ptr [0xa15e] ; PUSH_GLOBAL
060C8C  0E                    PUSH   cs ; STACK_PUSH
060C8D  E8 79 07              CALL   0x61409 ; CALL_NEAR
060C90  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060C93  C4 1E 14 9E           LES    bx, ptr [0x9e14] ; MOV_FAR
060C97  26 80 7F 21 01        CMP    byte ptr es:[bx + 0x21], 1 ; CMP
060C9C  76 06                 JBE    0x60ca4 ; CJUMP
060C9E  B8 01 00              MOV    ax, 1 ; MOV
060CA1  EB 03                 JMP    0x60ca6 ; JUMP
060CA3  90                    NOP ; NOP
060CA4  2B C0                 SUB    ax, ax ; ARITH
060CA6  50                    PUSH   ax ; STACK_PUSH
060CA7  6A 00                 PUSH   0 ; STACK_PUSH
060CA9  C4 1E 18 9E           LES    bx, ptr [0x9e18] ; MOV_FAR
060CAD  26 FF 37              PUSH   word ptr es:[bx] ; STACK_PUSH
060CB0  FF 36 60 A1           PUSH   word ptr [0xa160] ; PUSH_GLOBAL
060CB4  0E                    PUSH   cs ; STACK_PUSH
060CB5  E8 42 07              CALL   0x613fa ; CALL_NEAR
060CB8  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
060CBB  0B C0                 OR     ax, ax ; LOGIC
060CBD  7C 1A                 JL     0x60cd9 ; CJUMP
060CBF  3D E8 03              CMP    ax, 0x3e8 ; CMP
060CC2  74 0A                 JE     0x60cce ; CJUMP
060CC4  C4 1E 18 9E           LES    bx, ptr [0x9e18] ; MOV_FAR
060CC8  26 89 07              MOV    word ptr es:[bx], ax ; MOV
060CCB  EB 0C                 JMP    0x60cd9 ; JUMP
060CCD  90                    NOP ; NOP
060CCE  FF 36 5E A1           PUSH   word ptr [0xa15e] ; PUSH_GLOBAL
060CD2  0E                    PUSH   cs ; STACK_PUSH
060CD3  E8 2E 07              CALL   0x61404 ; CALL_NEAR
060CD6  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
060CD9  0E                    PUSH   cs ; STACK_PUSH
060CDA  E8 59 07              CALL   0x61436 ; CALL_NEAR
060CDD  C9                    LEAVE ; EPILOGUE
060CDE  CB                    RETF ; RETURN
