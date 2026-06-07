; ============================================================================
; func_02AFCE_unknown
; Region   : overlay
; Bytes    : file 0x02AFCE..0x02AFF7  (41 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

02AFCE  C8 02 00 00           ENTER  2, 0 ; PROLOGUE
02AFD2  83 3E F6 07 00        CMP    word ptr [0x7f6], 0 ; CMP
02AFD7  74 11                 JE     0x2afea ; CJUMP
02AFD9  83 3E 2E 03 02        CMP    word ptr [0x32e], 2 ; CMP
02AFDE  74 0A                 JE     0x2afea ; CJUMP
02AFE0  C7 06 2E 03 02 00     MOV    word ptr [0x32e], 2 ; GLOBAL_LOAD
02AFE6  0E                    PUSH   cs ; STACK_PUSH
02AFE7  E8 B1 1A              CALL   0x2ca9b ; CALL_NEAR
02AFEA  6A 16                 PUSH   0x16 ; PUSH_CONST
02AFEC  6A 48                 PUSH   0x48 ; PUSH_CONST
02AFEE  68 A5 00              PUSH   0xa5 ; PUSH_CONST
02AFF1  6A 7F                 PUSH   0x7f ; PUSH_CONST
02AFF3  9A                    DB     0x9A ; DATA_BYTE
02AFF4  CA                    DB     0xCA ; DATA_BYTE
02AFF5  03                    DB     0x03 ; DATA_BYTE
02AFF6  1F                    DB     0x1F ; DATA_BYTE
