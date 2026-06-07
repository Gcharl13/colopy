; ============================================================================
; func_0587BB_unknown
; Region   : load_image
; Bytes    : file 0x0587BB..0x0587FC  (65 bytes)
; Purpose  : UNKNOWN
; Args     : UNKNOWN
; Returns  : UNKNOWN
; Callers  : UNKNOWN
; Callees  : UNKNOWN
; Verified : not yet
; ============================================================================

0587BB  C8 02 00 00           ENTER  2, 0                         ; UNKNOWN
0587BF  C7 46 FE 15 00        MOV    word ptr [bp - 2], 0x15      ; UNKNOWN
0587C4  F6 06 FA 3D 01        TEST   byte ptr [0x3dfa], 1         ; UNKNOWN
0587C9  74 0B                 JE     0x587d6                      ; UNKNOWN
0587CB  83 7E 06 15           CMP    word ptr [bp + 6], 0x15      ; UNKNOWN
0587CF  75 05                 JNE    0x587d6                      ; UNKNOWN
0587D1  C7 46 FE FF FF        MOV    word ptr [bp - 2], 0xffff    ; UNKNOWN
0587D6  83 7E 06 1A           CMP    word ptr [bp + 6], 0x1a      ; UNKNOWN
0587DA  75 05                 JNE    0x587e1                      ; UNKNOWN
0587DC  C7 46 FE 19 00        MOV    word ptr [bp - 2], 0x19      ; UNKNOWN
0587E1  83 7E 06 19           CMP    word ptr [bp + 6], 0x19      ; UNKNOWN
0587E5  75 05                 JNE    0x587ec                      ; UNKNOWN
0587E7  C7 46 FE 1C 00        MOV    word ptr [bp - 2], 0x1c      ; UNKNOWN
0587EC  83 7E 06 1B           CMP    word ptr [bp + 6], 0x1b      ; UNKNOWN
0587F0  75 05                 JNE    0x587f7                      ; UNKNOWN
0587F2  C7 46 FE 1B 00        MOV    word ptr [bp - 2], 0x1b      ; UNKNOWN
0587F7  8B 46 FE              MOV    ax, word ptr [bp - 2]        ; UNKNOWN
0587FA  C9                    LEAVE                               ; UNKNOWN
0587FB  CB                    RETF                                ; UNKNOWN
