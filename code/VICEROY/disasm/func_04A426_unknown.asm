; ============================================================================
; func_04A426_unknown
; Region   : overlay
; Bytes    : file 0x04A426..0x04A497  (113 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

04A426  C8 36 00 00           ENTER  0x36, 0 ; PROLOGUE
04A42A  56                    PUSH   si ; STACK_PUSH
04A42B  83 7E 08 04           CMP    word ptr [bp + 8], 4 ; CMP
04A42F  7D 13                 JGE    0x4a444 ; CJUMP
04A431  6B 5E 08 34           IMUL   bx, word ptr [bp + 8], 0x34 ; ARITH
04A435  80 BF 3F 54 00        CMP    byte ptr [bx + 0x543f], 0 ; CMP
04A43A  75 08                 JNE    0x4a444 ; CJUMP
04A43C  C7 46 F0 01 00        MOV    word ptr [bp - 0x10], 1 ; LOCAL_STORE
04A441  EB 06                 JMP    0x4a449 ; JUMP
04A443  90                    NOP ; NOP
04A444  C7 46 F0 00 00        MOV    word ptr [bp - 0x10], 0 ; LOCAL_STORE
04A449  83 7E F0 00           CMP    word ptr [bp - 0x10], 0 ; CMP
04A44D  74 3C                 JE     0x4a48b ; CJUMP
04A44F  6A 03                 PUSH   3 ; STACK_PUSH
04A451  6A 00                 PUSH   0 ; STACK_PUSH
04A453  9A D4 04 1F 18        LCALL  0x181f, 0x4d4 ; THUNK -> 0x09EF:0x0032 (thunk @file 0x01AAC4 type B) overlay @file 0x027DB2
04A458  83 C4 04              ADD    sp, 4 ; STACK_CLEANUP
04A45B  0B C0                 OR     ax, ax ; LOGIC
04A45D  75 2C                 JNE    0x4a48b ; CJUMP
04A45F  6A 05                 PUSH   5 ; STACK_PUSH
04A461  9A 98 04 1F 18        LCALL  0x181f, 0x498 ; THUNK -> 0x029F:0x0300 (thunk @file 0x01AA88 type B) overlay @file 0x022328
04A466  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04A469  83 3E 52 8D 00        CMP    word ptr [0x8d52], 0 ; CMP
04A46E  75 0A                 JNE    0x4a47a ; CJUMP
04A470  6A 07                 PUSH   7 ; STACK_PUSH
04A472  9A 98 04 1F 18        LCALL  0x181f, 0x498 ; THUNK -> 0x029F:0x0300 (thunk @file 0x01AA88 type B) overlay @file 0x022328
04A477  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04A47A  83 3E 52 8D 01        CMP    word ptr [0x8d52], 1 ; CMP
04A47F  75 0A                 JNE    0x4a48b ; CJUMP
04A481  6A 06                 PUSH   6 ; STACK_PUSH
04A483  9A 98 04 1F 18        LCALL  0x181f, 0x498 ; THUNK -> 0x029F:0x0300 (thunk @file 0x01AA88 type B) overlay @file 0x022328
04A488  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
04A48B  0E                    PUSH   cs ; STACK_PUSH
04A48C  E8 B4 15              CALL   0x4ba43 ; CALL_NEAR
04A48F  FF 36 7A 91           PUSH   word ptr [0x917a] ; PUSH_GLOBAL
04A493  9A                    DB     0x9A ; DATA_BYTE
04A494  CA                    DB     0xCA ; DATA_BYTE
04A495  04                    DB     0x04 ; DATA_BYTE
04A496  1F                    DB     0x1F ; DATA_BYTE
