; ============================================================================
; func_025A1E_unknown
; Region   : overlay
; Bytes    : file 0x025A1E..0x025A86  (104 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025A1E  C8 40 00 00           ENTER  0x40, 0 ; PROLOGUE
025A22  56                    PUSH   si ; STACK_PUSH
025A23  C7 46 F8 00 00        MOV    word ptr [bp - 8], 0 ; LOCAL_STORE
025A28  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
025A2B  9A 0E 0C 1F 18        LCALL  0x181f, 0xc0e ; THUNK -> 0x05EB:0x0E18 (thunk @file 0x01B1FE type B) overlay @file 0x027E08
025A30  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
025A33  89 46 F2              MOV    word ptr [bp - 0xe], ax ; LOCAL_STORE
025A36  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
025A39  9A 54 0C 1F 18        LCALL  0x181f, 0xc54 ; THUNK -> 0x05EB:0x0E52 (thunk @file 0x01B244 type B) overlay @file 0x027E42
025A3E  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
025A41  89 46 FC              MOV    word ptr [bp - 4], ax ; LOCAL_STORE
025A44  8B 46 08              MOV    ax, word ptr [bp + 8] ; LOCAL_LOAD
025A47  39 46 F2              CMP    word ptr [bp - 0xe], ax ; CMP
025A4A  75 03                 JNE    0x25a4f ; CJUMP
025A4C  E9 DC 01              JMP    0x25c2b ; JUMP
025A4F  50                    PUSH   ax ; STACK_PUSH
025A50  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
025A53  9A 0A 0B 1F 18        LCALL  0x181f, 0xb0a ; THUNK -> 0x05EB:0x0FEA (thunk @file 0x01B0FA type B) overlay @file 0x027FDA
025A58  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
025A5B  89 46 FA              MOV    word ptr [bp - 6], ax ; LOCAL_STORE
025A5E  3D 02 00              CMP    ax, 2 ; CMP
025A61  75 61                 JNE    0x25ac4 ; CJUMP
025A63  6A 00                 PUSH   0 ; STACK_PUSH
025A65  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
025A6A  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
025A6D  0B C0                 OR     ax, ax ; LOGIC
025A6F  74 15                 JE     0x25a86 ; CJUMP
025A71  8B 1E 42 85           MOV    bx, word ptr [0x8542] ; GLOBAL_LOAD
025A75  80 7F 1F 03           CMP    byte ptr [bx + 0x1f], 3 ; CMP
025A79  7F 0B                 JG     0x25a86 ; CJUMP
025A7B  C7 46 F8 15 00        MOV    word ptr [bp - 8], 0x15 ; LOCAL_STORE
025A80  8B 46 F8              MOV    ax, word ptr [bp - 8] ; LOCAL_LOAD
025A83  5E                    POP    si ; STACK_POP
025A84  C9                    LEAVE ; EPILOGUE
025A85  CB                    RETF ; RETURN
