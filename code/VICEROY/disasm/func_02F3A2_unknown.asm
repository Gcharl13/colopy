; ============================================================================
; func_02F3A2_unknown
; Region   : overlay
; Bytes    : file 0x02F3A2..0x02F3E1  (63 bytes)
; Purpose  : Win/lose check (KINGLOSE/KINGWIN/YOULOSE/YOUWIN)  (M1W2 hand-annotated)
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : BYTE_VERIFIED structural (2026-05-04)
; ============================================================================

02F3A2  C8 78 00 00           ENTER  0x78, 0 ; PROLOGUE
02F3A6  57                    PUSH   di ; STACK_PUSH
02F3A7  56                    PUSH   si ; STACK_PUSH
02F3A8  C7 46 A2 01 00        MOV    word ptr [bp - 0x5e], 1 ; LOCAL_STORE
02F3AD  F6 06 82 53 01        TEST   byte ptr [0x5382], 1 ; LOGIC
02F3B2  74 0C                 JE     0x2f3c0 ; CJUMP
02F3B4  FF 36 D2 53           PUSH   word ptr [0x53d2] ; PUSH_GLOBAL
02F3B8  9A 74 0A 1F 19        LCALL  0x191f, 0xa74 ; THUNK -> 0x0000:0x0018 (thunk @file 0x01C064 type A) overlay @file 0x025918
02F3BD  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02F3C0  FF 36 98 53           PUSH   word ptr [0x5398] ; PUSH_GLOBAL
02F3C4  9A 74 0A 1F 19        LCALL  0x191f, 0xa74 ; THUNK -> 0x0000:0x0018 (thunk @file 0x01C064 type A) overlay @file 0x025918
02F3C9  83 C4 02              ADD    sp, 2 ; STACK_CLEANUP
02F3CC  8B 1E 98 53           MOV    bx, word ptr [0x5398] ; GLOBAL_LOAD
02F3D0  C6 87 98 92 00        MOV    byte ptr [bx - 0x6d68], 0 ; MOV
02F3D5  C7 46 8C 00 00        MOV    word ptr [bp - 0x74], 0 ; LOCAL_STORE
02F3DA  EB 18                 JMP    0x2f3f4 ; JUMP
02F3DC  69 D8 CA 00           IMUL   bx, ax, 0xca ; ARITH
02F3E0  A0                    DB     0xA0 ; DATA_BYTE
