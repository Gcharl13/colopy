; ============================================================================
; func_024CA7_unknown
; Region   : load_image
; Bytes    : file 0x024CA7..0x024CE7  (64 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

024CA7  55                    PUSH   bp                           ; UNKNOWN
024CA8  8B EC                 MOV    bp, sp                       ; UNKNOWN
024CAA  50                    PUSH   ax                           ; UNKNOWN
024CAB  83 3E 14 0A 00        CMP    word ptr [0xa14], 0          ; UNKNOWN
024CB0  74 68                 JE     0x24d1a                      ; UNKNOWN
024CB2  80 7E 0A 07           CMP    byte ptr [bp + 0xa], 7       ; UNKNOWN
024CB6  75 62                 JNE    0x24d1a                      ; UNKNOWN
024CB8  83 3E 1A 0A 00        CMP    word ptr [0xa1a], 0          ; UNKNOWN
024CBD  74 28                 JE     0x24ce7                      ; UNKNOWN
024CBF  FF 36 90 CE           PUSH   word ptr [0xce90]            ; UNKNOWN
024CC3  FF 36 8E CE           PUSH   word ptr [0xce8e]            ; UNKNOWN
024CC7  FF 36 8C CE           PUSH   word ptr [0xce8c]            ; UNKNOWN
024CCB  FF 36 8A CE           PUSH   word ptr [0xce8a]            ; UNKNOWN
024CCF  FF 76 1A              PUSH   word ptr [bp + 0x1a]         ; UNKNOWN
024CD2  FF 76 18              PUSH   word ptr [bp + 0x18]         ; UNKNOWN
024CD5  FF 76 16              PUSH   word ptr [bp + 0x16]         ; UNKNOWN
024CD8  FF 76 14              PUSH   word ptr [bp + 0x14]         ; UNKNOWN
024CDB  FF 76 12              PUSH   word ptr [bp + 0x12]         ; UNKNOWN
024CDE  9A 04 00 49 5A        LCALL  0x5a49, 4                    ; UNKNOWN
024CE3  C9                    LEAVE                               ; UNKNOWN
024CE4  C2 18 00              RET    0x18                         ; UNKNOWN
