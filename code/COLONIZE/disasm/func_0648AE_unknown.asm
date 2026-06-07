; ============================================================================
; func_0648AE_unknown
; Region   : load_image
; Bytes    : file 0x0648AE..0x0648DE  (48 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0648AE  C8 04 00 00           ENTER  4, 0                         ; UNKNOWN
0648B2  52                    PUSH   dx                           ; UNKNOWN
0648B3  50                    PUSH   ax                           ; UNKNOWN
0648B4  2B C9                 SUB    cx, cx                       ; UNKNOWN
0648B6  89 4E FE              MOV    word ptr [bp - 2], cx        ; UNKNOWN
0648B9  89 4E FC              MOV    word ptr [bp - 4], cx        ; UNKNOWN
0648BC  C4 5E 06              LES    bx, ptr [bp + 6]             ; UNKNOWN
0648BF  26 39 57 10           CMP    word ptr es:[bx + 0x10], dx  ; UNKNOWN
0648C3  7F 24                 JG     0x648e9                      ; UNKNOWN
0648C5  7C 06                 JL     0x648cd                      ; UNKNOWN
0648C7  26 39 47 0E           CMP    word ptr es:[bx + 0xe], ax   ; UNKNOWN
0648CB  73 1C                 JAE    0x648e9                      ; UNKNOWN
0648CD  52                    PUSH   dx                           ; UNKNOWN
0648CE  50                    PUSH   ax                           ; UNKNOWN
0648CF  26 FF 77 10           PUSH   word ptr es:[bx + 0x10]      ; UNKNOWN
0648D3  26 FF 77 0E           PUSH   word ptr es:[bx + 0xe]       ; UNKNOWN
0648D7  26 8A 1F              MOV    bl, byte ptr es:[bx]         ; UNKNOWN
0648DA  2A FF                 SUB    bh, bh                       ; UNKNOWN
0648DC  B8                    DB     0xB8                         ; UNKNOWN (raw)
0648DD  C3                    DB     0xC3                         ; UNKNOWN (raw)
