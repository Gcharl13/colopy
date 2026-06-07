; ============================================================================
; func_012AF0_unknown
; Region   : load_image
; Bytes    : file 0x012AF0..0x012B56  (102 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

012AF0  55                    PUSH   bp ; STACK_PUSH
012AF1  8B EC                 MOV    bp, sp ; MOV
012AF3  50                    PUSH   ax ; STACK_PUSH
012AF4  57                    PUSH   di ; STACK_PUSH
012AF5  56                    PUSH   si ; STACK_PUSH
012AF6  83 3E 7A 44 00        CMP    word ptr [0x447a], 0 ; CMP
012AFB  74 55                 JE     0x12b52 ; CJUMP
012AFD  83 3E 04 45 00        CMP    word ptr [0x4504], 0 ; CMP
012B02  74 4E                 JE     0x12b52 ; CJUMP
012B04  0B C0                 OR     ax, ax ; LOGIC
012B06  74 4A                 JE     0x12b52 ; CJUMP
012B08  0E                    PUSH   cs ; STACK_PUSH
012B09  E8 50 FF              CALL   0x12a5c ; CALL_NEAR
012B0C  0B C0                 OR     ax, ax ; LOGIC
012B0E  75 42                 JNE    0x12b52 ; CJUMP
012B10  2B DB                 SUB    bx, bx ; ARITH
012B12  39 06 40 44           CMP    word ptr [0x4440], ax ; CMP
012B16  7E 2E                 JLE    0x12b46 ; CJUMP
012B18  8B 3E 7C 44           MOV    di, word ptr [0x447c] ; GLOBAL_LOAD
012B1C  8B 0E 76 44           MOV    cx, word ptr [0x4476] ; GLOBAL_LOAD
012B20  8E 06 7E 44           MOV    es, word ptr [0x447e] ; GLOBAL_LOAD
012B24  8B F7                 MOV    si, di ; MOV
012B26  03 F3                 ADD    si, bx ; ARITH
012B28  26 8A 04              MOV    al, byte ptr es:[si] ; MOV
012B2B  2A 46 FE              SUB    al, byte ptr [bp - 2] ; ARITH
012B2E  FE C8                 DEC    al ; ARITH
012B30  75 09                 JNE    0x12b3b ; CJUMP
012B32  8B F7                 MOV    si, di ; MOV
012B34  03 F3                 ADD    si, bx ; ARITH
012B36  26 C6 04 00           MOV    byte ptr es:[si], 0 ; MOV
012B3A  41                    INC    cx ; ARITH
012B3B  43                    INC    bx ; ARITH
012B3C  39 1E 40 44           CMP    word ptr [0x4440], bx ; CMP
012B40  7F E2                 JG     0x12b24 ; CJUMP
012B42  89 0E 76 44           MOV    word ptr [0x4476], cx ; GLOBAL_LOAD
012B46  6B 5E FE 5A           IMUL   bx, word ptr [bp - 2], 0x5a ; ARITH
012B4A  C4 36 FC 44           LES    si, ptr [0x44fc] ; MOV_FAR
012B4E  26 C6 00 FF           MOV    byte ptr es:[bx + si], 0xff ; CONST_LOAD
012B52  5E                    POP    si ; STACK_POP
012B53  5F                    POP    di ; STACK_POP
012B54  C9                    LEAVE ; EPILOGUE
012B55  CB                    RETF ; RETURN
