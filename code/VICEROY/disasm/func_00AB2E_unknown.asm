; ============================================================================
; func_00AB2E_unknown
; Region   : load_image
; Bytes    : file 0x00AB2E..0x00AB77  (73 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

00AB2E  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
00AB32  56                    PUSH   si ; STACK_PUSH
00AB33  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
00AB38  EB 2D                 JMP    0xab67 ; JUMP
00AB3A  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
00AB3D  83 7E FA 05           CMP    word ptr [bp - 6], 5 ; CMP
00AB41  7D 21                 JGE    0xab64 ; CJUMP
00AB43  8B 76 FA              MOV    si, word ptr [bp - 6] ; LOCAL_LOAD
00AB46  8B C6                 MOV    ax, si ; MOV
00AB48  C1 E6 02              SHL    si, 2 ; LOGIC
00AB4B  03 F0                 ADD    si, ax ; ARITH
00AB4D  8B 5E F8              MOV    bx, word ptr [bp - 8] ; LOCAL_LOAD
00AB50  80 B8 F0 8D 00        CMP    byte ptr [bx + si - 0x7210], 0 ; CMP
00AB55  74 E3                 JE     0xab3a ; CJUMP
00AB57  6A FF                 PUSH   -1 ; STACK_PUSH
00AB59  53                    PUSH   bx ; STACK_PUSH
00AB5A  50                    PUSH   ax ; STACK_PUSH
00AB5B  0E                    PUSH   cs ; STACK_PUSH
00AB5C  E8 23 DE              CALL   0x8982 ; CALL_NEAR
00AB5F  83 C4 06              ADD    sp, 6 ; STACK_CLEANUP
00AB62  EB D6                 JMP    0xab3a ; JUMP
00AB64  FF 46 F8              INC    word ptr [bp - 8] ; ARITH
00AB67  83 7E F8 05           CMP    word ptr [bp - 8], 5 ; CMP
00AB6B  7D 07                 JGE    0xab74 ; CJUMP
00AB6D  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
00AB72  EB C9                 JMP    0xab3d ; JUMP
00AB74  5E                    POP    si ; STACK_POP
00AB75  C9                    LEAVE ; EPILOGUE
00AB76  CB                    RETF ; RETURN
