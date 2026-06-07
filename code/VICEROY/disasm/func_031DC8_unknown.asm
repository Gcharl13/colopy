; ============================================================================
; func_031DC8_unknown
; Region   : overlay
; Bytes    : file 0x031DC8..0x031E4C  (132 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

031DC8  C8 0A 00 00           ENTER  0xa, 0 ; PROLOGUE
031DCC  6A 20                 PUSH   0x20 ; PUSH_CONST
031DCE  6A 25                 PUSH   0x25 ; PUSH_CONST
031DD0  6A 59                 PUSH   0x59 ; PUSH_CONST
031DD2  68 19 01              PUSH   0x119 ; PUSH_CONST
031DD5  0E                    PUSH   cs ; STACK_PUSH
031DD6  E8 F3 4A              CALL   0x368cc ; CALL_NEAR
031DD9  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
031DDC  C7 46 FE 19 01        MOV    word ptr [bp - 2], 0x119 ; LOCAL_STORE
031DE1  C7 46 FC 59 00        MOV    word ptr [bp - 4], 0x59 ; LOCAL_STORE
031DE6  C7 46 FA 00 00        MOV    word ptr [bp - 6], 0 ; LOCAL_STORE
031DEB  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
031DF0  8B 46 FA              MOV    ax, word ptr [bp - 6] ; LOCAL_LOAD
031DF3  39 06 2E 9E           CMP    word ptr [0x9e2e], ax ; CMP
031DF7  75 13                 JNE    0x31e0c ; CJUMP
031DF9  83 3E EE 07 00        CMP    word ptr [0x7ee], 0 ; CMP
031DFE  74 0C                 JE     0x31e0c ; CJUMP
031E00  83 3E 3A 9E 05        CMP    word ptr [0x9e3a], 5 ; CMP
031E05  75 05                 JNE    0x31e0c ; CJUMP
031E07  C7 46 F8 01 00        MOV    word ptr [bp - 8], 1 ; LOCAL_STORE
031E0C  FF 76 F8              PUSH   word ptr [bp - 8] ; STACK_PUSH
031E0F  FF 76 FC              PUSH   word ptr [bp - 4] ; STACK_PUSH
031E12  FF 76 FE              PUSH   word ptr [bp - 2] ; STACK_PUSH
031E15  8B D8                 MOV    bx, ax ; MOV
031E17  D1 E3                 SHL    bx, 1 ; LOGIC
031E19  FF B7 D8 93           PUSH   word ptr [bx - 0x6c28] ; PUSH_GLOBAL
031E1D  E8 C6 FD              CALL   0x31be6 ; CALL_NEAR
031E20  83 C4 08              ADD    sp, 8 ; STACK_CLEANUP
031E23  40                    INC    ax ; ARITH
031E24  40                    INC    ax ; ARITH
031E25  01 46 FC              ADD    word ptr [bp - 4], ax ; ARITH
031E28  FF 46 FA              INC    word ptr [bp - 6] ; ARITH
031E2B  83 7E FA 03           CMP    word ptr [bp - 6], 3 ; CMP
031E2F  7C BA                 JL     0x31deb ; CJUMP
031E31  83 7E 04 00           CMP    word ptr [bp + 4], 0 ; CMP
031E35  74 13                 JE     0x31e4a ; CJUMP
031E37  6A 59                 PUSH   0x59 ; PUSH_CONST
031E39  6A 25                 PUSH   0x25 ; PUSH_CONST
031E3B  6A 20                 PUSH   0x20 ; PUSH_CONST
031E3D  B8 19 01              MOV    ax, 0x119 ; CONST_LOAD
031E40  BA 59 00              MOV    dx, 0x59 ; CONST_LOAD
031E43  8B D8                 MOV    bx, ax ; MOV
031E45  9A E2 00 1F 18        LCALL  0x181f, 0xe2 ; THUNK -> 0x0B70:0x003A (thunk @file 0x01A6D2 type B) overlay @file 0x02798C
031E4A  C9                    LEAVE ; EPILOGUE
031E4B  C3                    RET ; RETURN
