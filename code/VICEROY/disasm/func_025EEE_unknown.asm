; ============================================================================
; func_025EEE_unknown
; Region   : overlay
; Bytes    : file 0x025EEE..0x025F23  (53 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

025EEE  C8 5E 00 00           ENTER  0x5e, 0 ; PROLOGUE
025EF2  8B 5E 0C              MOV    bx, word ptr [bp + 0xc] ; LOCAL_LOAD
025EF5  8A 87 30 02           MOV    al, byte ptr [bx + 0x230] ; MOV
025EF9  98                    CWDE ; ARITH
025EFA  89 46 AA              MOV    word ptr [bp - 0x56], ax ; LOCAL_STORE
025EFD  8A 87 36 02           MOV    al, byte ptr [bx + 0x236] ; MOV
025F01  98                    CWDE ; ARITH
025F02  89 46 A8              MOV    word ptr [bp - 0x58], ax ; LOCAL_STORE
025F05  C6 46 B0 00           MOV    byte ptr [bp - 0x50], 0 ; LOCAL_STORE
025F09  83 7E 06 00           CMP    word ptr [bp + 6], 0 ; CMP
025F0D  7C 43                 JL     0x25f52 ; CJUMP
025F0F  FF 76 06              PUSH   word ptr [bp + 6] ; STACK_PUSH
025F12  9A FC 09 1F 18        LCALL  0x181f, 0x9fc ; THUNK -> 0x05EB:0x038E (thunk @file 0x01AFEC type B) overlay @file 0x02737E
025F17  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
025F1A  0B C0                 OR     ax, ax ; LOGIC
025F1C  74 1C                 JE     0x25f3a ; CJUMP
025F1E  8B 5E 06              MOV    bx, word ptr [bp + 6] ; LOCAL_LOAD
025F21  8B C3                 MOV    ax, bx ; MOV
