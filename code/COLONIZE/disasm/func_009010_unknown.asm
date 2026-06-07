; ============================================================================
; func_009010_unknown
; Region   : load_image
; Bytes    : file 0x009010..0x009050  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

009010  C8 02 01 00           ENTER  0x102, 0                     ; UNKNOWN
009014  83 3E 68 00 04        CMP    word ptr [0x68], 4           ; UNKNOWN
009019  7C 33                 JL     0x904e                       ; UNKNOWN
00901B  B0 2A                 MOV    al, 0x2a                     ; UNKNOWN
00901D  88 86 FE FE           MOV    byte ptr [bp - 0x102], al    ; UNKNOWN
009021  88 86 FF FE           MOV    byte ptr [bp - 0x101], al    ; UNKNOWN
009025  88 86 00 FF           MOV    byte ptr [bp - 0x100], al    ; UNKNOWN
009029  88 86 01 FF           MOV    byte ptr [bp - 0xff], al     ; UNKNOWN
00902D  C6 86 02 FF 20        MOV    byte ptr [bp - 0xfe], 0x20   ; UNKNOWN
009032  8D 46 08              LEA    ax, [bp + 8]                 ; UNKNOWN
009035  50                    PUSH   ax                           ; UNKNOWN
009036  FF 76 06              PUSH   word ptr [bp + 6]            ; UNKNOWN
009039  8D 86 03 FF           LEA    ax, [bp - 0xfd]              ; UNKNOWN
00903D  50                    PUSH   ax                           ; UNKNOWN
00903E  9A 26 0B 65 5F        LCALL  0x5f65, 0xb26                ; UNKNOWN
009043  83 C4 06              ADD    sp, 6                        ; UNKNOWN
009046  8D 86 FE FE           LEA    ax, [bp - 0x102]             ; UNKNOWN
00904A  50                    PUSH   ax                           ; UNKNOWN
00904B  E8 B2 FF              CALL   0x9000                       ; UNKNOWN
00904E  C9                    LEAVE                               ; UNKNOWN
00904F  CB                    RETF                                ; UNKNOWN
